"""Execute core and adapter contracts with Lua 5.4 and deterministic FiveM/MySQL mocks."""
import ctypes
from pathlib import Path
from check_lua import lib, normalize
lib.luaL_openlibs.argtypes=[ctypes.c_void_p]
lib.lua_pcallk.argtypes=[ctypes.c_void_p,ctypes.c_int,ctypes.c_int,ctypes.c_int,ctypes.c_longlong,ctypes.c_void_p]
bootstrap=r'''
local handlers, exported = {}, {}
function AddEventHandler(name, cb) handlers[name] = handlers[name] or {}; table.insert(handlers[name],cb) end
RegisterNetEvent=AddEventHandler
function TriggerEvent(name,...) for _,cb in ipairs(handlers[name] or {}) do cb(...) end end
function TriggerClientEvent(...) end
function GetCurrentResourceName() return 'sg_core' end
function GetResourceState(name) return name=='ox_inventory' and 'started' or 'stopped' end
function GetPlayerName(src) return 'Player '..tostring(src) end
function GetPlayerPed(src) return src end
function DoesEntityExist(entity) return entity~=0 end
function GetEntityCoords(ped) return {x=0,y=0,z=0} end
function GetEntityHeading(ped) return 0 end
function GetPlayerIdentifierByType(src,kind) return kind..':'..src end
function IsPlayerAceAllowed() return false end
function RegisterCommand() end
function GetConvar(key,default) return default end
function GetPlayers() return {} end
function SetTimeout(ms,cb) end
function Wait() end
local function clone(t) if type(t)~='table' then return t end local c={} for k,v in pairs(t) do c[k]=clone(v) end return c end
lib={table={deepclone=clone,contains=function(t,v) for _,x in pairs(t) do if x==v then return true end end return false end},
    addPrincipal=function()end,removePrincipal=function()end,print={error=error},callback={register=function()end}}
json={encode=function()return '{}'end,decode=function()return {}end}
local stored, nextId = {}, 0
MySQL={insert={await=function(query,args) nextId=nextId+1;return nextId end},update={await=function()return 1 end},query={await=function(query,args) return {} end}}
Config={characterIdentifier='license',groups={unemployed={label='Unemployed',ranks={'Unemployed'},minimumBossRank=1},police={label='Police',ranks={'Officer','Chief'},minimumBossRank=2}},compatibility={'esx','qb'},admins={},adminDiscordRoles={},groupRoles={}}
PlayersInfo={}
SGCore={players={}}
function SGCore.getPlayerIdentifierByType(src,kind) return kind..':'..src end
function SGCore.getPlayer(src) return SGCore.players[tonumber(src)] end
local inventory={}
local inv={}
function inv.GetInventoryItems(self,src) return inventory[src] or {} end
function inv.GetItem(self,src,name) return {name=name,count=2} end
function inv.GetInventory() return {weight=0,maxWeight=30000} end
function inv.Items() return {} end
function inv.AddItem() return true end
function inv.RemoveItem() return true end
function inv.SetItem() return true end
function inv.CanCarryItem() return true end
function inv.CanSwapItem() return true end
exports=setmetatable({ox_inventory=inv,sg_core=setmetatable({},{__index=function(_,name) return function(_,...) return assert(exported[name],name)(...) end end})},{__call=function(_,name,cb) exported[name]=cb end})
_G._exports=exported
'''
contracts=r'''
local p=assert(SGCore.newCharacter(1,{firstname='Josh',lastname='Test',cash=100,bank=500,metadata={},groups={}}))
SGCore.players[1]=p
assert(p.deductMoney('cash',101)==false and p.cash==100,'overdraft changed cash')
for _,amount in ipairs({0,-5,0/0,math.huge,1.5,'invalid'}) do
    assert(p.addMoney('bank',amount)==false and p.bank==500,'invalid deposit accepted')
end
assert(p.deductMoney('cash',30) and p.cash==70)
assert(p.addMoney('cash',30) and p.cash==100)
assert(SGCore.fetchCharacter(999,1)==nil,'missing character should return nil')
assert(p.save('cash` = 0; DROP TABLE nd_characters; --')==false,'unvalidated SQL column')
assert(p.setJob('police',2));assert(p.job=='police' and p.groups.police.rank==2)
local ESX=_exports.GetESXObject()
local x=ESX.GetPlayerFromId(1)
assert(x.identifier==tostring(p.id) and x.getAccount('money').money==100)
assert(x.job.grade==1 and x.job.name=='police')
assert(p.job=='police','ESX view mutated native job')
assert(x.removeMoney(10) and p.cash==90 and p.bank==500,'ESX cash uses wrong account')
assert(x.getMoney()==90)
assert(x.removeAccountMoney('bank',501)==false and p.bank==500)
assert(x.setMoney(-1)==false and p.cash==90)
assert(x.setInventoryItem('water',2))
assert(ESX.GetPlayerFromId(999)==nil)
assert(#ESX.GetPlayers()==1 and ESX.GetPlayers()[1]==1)
assert(ESX.GetPlayerFromIdentifier(tostring(p.id)).source==1)
local QB=_exports.GetQBObject()
local q=QB.Functions.GetPlayer(1)
assert(q.PlayerData.citizenid==x.identifier,'framework identities disagree')
assert(q.PlayerData.job.grade.level==1)
assert(q.Functions.RemoveMoney('cash',10) and p.cash==80 and q.PlayerData.money.cash==80)
assert(q.Functions.SetMoney('bank',-1)==false and p.bank==500)
assert(q.Functions.SetJob('unemployed',0));assert(p.job=='unemployed')
assert(QB.Functions.GetPlayerByCitizenId(x.identifier).PlayerData.source==1)
assert(QB.Functions.GetPlayer(999)==nil)
assert(p.groups.police==nil and p.groups.unemployed.rank==1)
local calls=0
ESX.RegisterUsableItem('water',function(src) assert(src==1);calls=calls+1 end)
assert(_exports.UseItem(1,'water',{}) and calls==1)
assert(_exports.UseItem(1,'not_registered',{})==false)
print('PASS: canonical identity, detached views, account semantics, overdraft/amount validation, jobs, usable items and SQL column allowlist')
'''
paths=['server/player.lua','compatibility/esx/server.lua','compatibility/qb/server.lua']
inventory_test=r'''
local native=SGCore
local incoming
local inv=setmetatable({SetItem=function() end,GetAccountItemCounts=function() return {money=p and p.cash or 80} end},{__call=function()return {player={}} end})
local env=setmetatable({server={setPlayerInventory=function(data) incoming=data end,playerDropped=function()end},require=function()return inv end},{__index=_G})
env.lib=setmetatable({checkDependency=function()return true end,load=function()env.SGCore=native end},{__index=lib})
local f=assert(load([====[BRIDGE]====],'inventory-bridge','t',env));f()
local p=native.players[1]
local identifier,group=p.identifier,p.groups.unemployed
TriggerEvent('SG:characterLoaded',p)
assert(p.identifier==identifier and p.name=='Player 1','inventory bridge changed canonical identity')
assert(p.groups.unemployed==group and type(group)=='table' and group.rank==1,'inventory bridge changed group object')
assert(incoming.identifier==p.id and incoming.groups.unemployed==1,'inventory projection is incorrect')
print('PASS: inventory projection leaves native character identity and group objects intact')
''' .replace('BRIDGE',normalize(Path('resources/[scripts]/ox_inventory/modules/bridge/nd/server.lua').read_text()))
source=bootstrap+'\n'+'\n'.join('do\n'+normalize((Path('resources/[scripts]/sg_core')/p).read_text())+'\nend' for p in paths)+'\n'+contracts+'\n'+inventory_test
encoded=source.encode();state=lib.luaL_newstate();lib.luaL_openlibs(state)
status=lib.luaL_loadbufferx(state,encoded,len(encoded),b'core-contracts',None)
if not status: status=lib.lua_pcallk(state,0,0,0,0,None)
if status: raise SystemExit(lib.lua_tolstring(state,-1,None).decode())
lib.lua_close(state)
