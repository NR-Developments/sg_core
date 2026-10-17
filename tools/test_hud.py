"""Execute native SG HUD bridge/server contracts with deterministic FiveM mocks."""
import ctypes
from pathlib import Path
from check_lua import lib
lib.luaL_openlibs.argtypes=[ctypes.c_void_p]
lib.lua_pcallk.argtypes=[ctypes.c_void_p,ctypes.c_int,ctypes.c_int,ctypes.c_int,ctypes.c_longlong,ctypes.c_void_p]
root=Path('resources/[scripts]/sg_hud')
def chunk(path):return 'assert(load([====['+(root/path).read_text()+']====],"'+path+'"))()\n'
bootstrap=r'''
local events,callbacks,commands,exported,messages,threads={},{},{},{},{},{}
function AddEventHandler(name,cb)local old=events[name];events[name]=function(...)if old then old(...)end;return cb(...)end end
function RegisterNetEvent(name,cb) if cb then AddEventHandler(name,cb) end end
function RegisterNUICallback(name,cb)callbacks[name]=cb end
function RegisterCommand(name,cb)commands[name]=cb end
function CreateThread(cb)threads[#threads+1]=cb end
Citizen={CreateThread=CreateThread}
function Wait()end
function SendNUIMessage(msg)messages[#messages+1]=msg end
function IsPauseMenuActive()return false end
function DisplayRadar()end
function PlayerPedId()return 10 end
function PlayerId()return 1 end
function IsEntityDead()return false end
function GetEntityHealth()return 175 end
function GetEntityMaxHealth()return 200 end
function GetPedArmour()return 30 end
function GetPlayerMaxArmour()return 100 end
function GetPlayerSprintStaminaRemaining()return 90 end
function GetResourceState()return 'started' end
function GetCurrentResourceName()return 'sg_hud' end
function GetClockDayOfMonth()return 17 end
function GetClockDayOfWeek()return 6 end
function GetClockMonth()return 9 end
function GetClockYear()return 2026 end
function GetClockHours()return 15 end
function GetClockMinutes()return 45 end
local player={source=1,id=12,cash=123,bank=456,job='police',jobInfo={label='Police',rankName='Chief',isBoss=true}}
local statuses={hunger={status=80,max=100},thirst={status=50,max=100},stamina={status=25,max=100}}
LocalPlayer={state={proximity={index=1}}}
exports=setmetatable({sg_core={getPlayer=function()return player end},sg_status={getStatus=function()return statuses end}}, {__call=function(_,name,cb)exported[name]=cb end})
json={decode=function()return {}end}
lib={callback={await=function()return {}end}}
'''
checks=r'''
callbacks.ready({},function(result)assert(result.ok)end)
assert(type(hudDate())=='string' and #hudDate()>0,'localization/date formatter failed without ESX')
assert(SGHUD.voiceDistance()=='whisper')
LocalPlayer.state.proximity.index=2;assert(SGHUD.voiceDistance()=='normal')
LocalPlayer.state.proximity.index=3;assert(SGHUD.voiceDistance()=='shout')
SGHUD.extra={blackMoney=20,society=800,hasSociety=true}
SGHUD.pushData()
local latest={}
for _,msg in ipairs(messages)do if msg.action=='setMoney' then latest[msg.id]=msg.value elseif msg.action=='setStatus' then latest.status=msg end end
assert(latest.wallet==123 and latest.bank==456 and latest.society==800 and latest.blackMoney==20)
local values={}for _,entry in ipairs(latest.status.status)do values[entry.name]=entry.value end
assert(values.health==75 and values.armor==30 and values.hunger==20 and values.thirst==50 and values.stamina==25,'Trew status payload normalization failed')
player.cash=999;events['SG:updateMoney']();local wallet
for _,msg in ipairs(messages)do if msg.action=='setMoney' and msg.id=='wallet' then wallet=msg.value end end
assert(wallet==999,'SG cash event did not update HUD')
commands.toggleui();assert(SGHUD.infoHidden==true);commands.toggleui();assert(SGHUD.infoHidden==false)
exported.createStatus({status='stress',color='#ff0000',icon='fas fa-brain'});assert(messages[#messages].action=='createStatus')
exported.setStatus({name='stress',value=25});assert(messages[#messages].status[1].name=='stress')
player=nil;events['SG:characterUnloaded']();assert(messages[#messages].action=='toggleUi' and messages[#messages].value==false)
print('PASS: HUD payloads, native money events, normalized needs/health, PMA modes, localization, custom exports and unload visibility')
-- Server callback permissions and signal validation.
events={} -- Client and server have separate event runtimes.
local serverCallbacks,relay={},0
lib.callback.register=function(name,cb)serverCallbacks[name]=cb end
local tick=0;function GetGameTimer()tick=tick+2000;return tick end
function GetPlayerPed()return 10 end
local vehicle=20;function GetVehiclePedIsIn()return vehicle end
function GetPedInVehicleSeat()return 10 end
function TriggerClientEvent()relay=relay+1 end
source=1
player={source=1,id=12,jobInfo={isBoss=false}}
local societyReads=0
HUDAccounts={blackMoney=function()return 3 end,society=function()societyReads=societyReads+1;return 100 end}
'''
server_checks=r'''
local result=serverCallbacks['sg_hud:accounts'](1)
assert(result.blackMoney==3 and result.hasSociety==false and societyReads==0,'non-boss saw society data')
player.jobInfo.isBoss=true;result=serverCallbacks['sg_hud:accounts'](1)
assert(result.hasSociety and result.society==100 and societyReads==1)
events['sg_hud:syncCarLights']('invalid');assert(relay==0)
vehicle=0;events['sg_hud:syncCarLights']('left');assert(relay==0)
vehicle=20;events['sg_hud:syncCarLights']('both');assert(relay==1)
print('PASS: server-verified society access, optional balances and driver/signal validation')
'''
source=bootstrap+chunk('locales/init.lua')+chunk('locales/br.lua')+chunk('locales/en.lua')+chunk('locales/es.lua')+chunk('config.lua')+chunk('client/bridge.lua')+chunk('client/client.lua')+checks+chunk('server/server.lua')+server_checks
encoded=source.encode();state=lib.luaL_newstate();lib.luaL_openlibs(state)
status=lib.luaL_loadbufferx(state,encoded,len(encoded),b'hud-regressions',None)
if not status:status=lib.lua_pcallk(state,0,0,0,0,None)
if status:raise SystemExit(lib.lua_tolstring(state,-1,None).decode())
lib.lua_close(state)
