"""Regression tests for SG module-return contracts and selector initialization."""
import ctypes
from pathlib import Path
from check_lua import lib,normalize
lib.luaL_openlibs.argtypes=[ctypes.c_void_p]
lib.lua_pcallk.argtypes=[ctypes.c_void_p,ctypes.c_int,ctypes.c_int,ctypes.c_int,ctypes.c_longlong,ctypes.c_void_p]
def literal(text): return '[====['+text+']====]'
init=literal(Path('resources/[scripts]/sg_core/init.lua').read_text())
client=literal(Path('resources/[scripts]/sg_ambulance/bridge/framework/nd/client.lua').read_text())
server=literal(Path('resources/[scripts]/sg_ambulance/bridge/framework/nd/server.lua').read_text())
selector=literal(normalize(Path('resources/[scripts]/sg_multicharacter/client/main.lua').read_text()))
source=r'''
local player={job='ambulance',bank=100,cash=0,metadata={dead=false}}
exports={sg_core={getPlayer=function()return player end}}
cache={resource='sg_ambulance'}
function AddEventHandler() end
function RegisterNetEvent() end
lib={table={contains=function(t,v)for _,x in ipairs(t)do if x==v then return true end end return false end}}
local import=assert(load(INIT,'@@sg_core/init.lua'))
function require(name) assert(name=='@sg_core.init');return import() or true end
local core=require('@sg_core.init')
assert(type(core)=='table' and core.getPlayer()==player,'core module did not return the SG proxy')
local client=assert(load(CLIENT,'@@sg_ambulance/bridge/framework/nd/client.lua'))()
assert(client.hasJobs({'ambulance'}) and client.isDead()==false)
local server=assert(load(SERVER,'@@sg_ambulance/bridge/framework/nd/server.lua'))()
assert(server.getPlayer(1)==player and server.hasMoney(1,50))
-- Loading the selector should register callbacks, not reload ox_lib with an anonymous chunk.
local registered, nui, cacheHooks, libraryReads = {}, {}, {}, 0
exports=setmetatable({sg_multicharacter=setmetatable({},{__index=function(_,name)return function(_,...)return registered[name](...)end end})},
    {__call=function(_,name,cb)registered[name]=cb end})
function vec3(x,y,z)return {x=x,y=y,z=z}end
function vector3(...)return vec3(...)end
Config={Spawn=vec3(0,0,0),Slots=1}
Citizen={CreateThreadNow=function()end}
function RegisterCommand()end
function RegisterNUICallback(name,cb)nui[name]=cb end
function AddStateBagChangeHandler()end
function LoadResourceFile(resource)if resource=='ox_lib' then libraryReads=libraryReads+1 end end
lib.onCache=function(name,cb)cacheHooks[name]=cb end
assert(load(SELECTOR,'@@sg_multicharacter/client/main.lua'))()
assert(type(nui.nuicb)=='function' and type(cacheHooks.vehicle)=='function')
assert(libraryReads==0,'selector reloaded ox_lib anonymously')
print('PASS: ambulance client/server imports return SG tables; selector initializes without anonymous library reload')
'''.replace('INIT',init).replace('CLIENT',client).replace('SERVER',server).replace('SELECTOR',selector)
encoded=source.encode();state=lib.luaL_newstate();lib.luaL_openlibs(state)
status=lib.luaL_loadbufferx(state,encoded,len(encoded),b'startup-regressions',None)
if not status:status=lib.lua_pcallk(state,0,0,0,0,None)
if status:raise SystemExit(lib.lua_tolstring(state,-1,None).decode())
lib.lua_close(state)
