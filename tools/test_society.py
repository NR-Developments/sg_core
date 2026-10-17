"""Exercise society ownership, ledger bounds, rollback and trusted resource contracts."""
import ctypes
from pathlib import Path
from check_lua import lib
lib.luaL_openlibs.argtypes=[ctypes.c_void_p]
lib.lua_pcallk.argtypes=[ctypes.c_void_p,ctypes.c_int,ctypes.c_int,ctypes.c_int,ctypes.c_longlong,ctypes.c_void_p]
setup=r'''
local callbacks, exported, commands = {}, {}, {}
local owner, bank, ledger, history, failed = true, 1000, 500, {}, false
local player={id=12,source=1,jobInfo={isBoss=false}}
player.deductMoney=function(_,n)if bank<n then return false end bank=bank-n return true end
player.addMoney=function(_,n)bank=bank+n return true end
player.save=function()return true end
SGCore={getPlayer=function(src)if src==1 then return player end end,loadSQL=function()end}
config={societyResources={trusted=true}}
lib={callback={register=function(n,cb)callbacks[n]=cb end}}
function CreateThread(cb)cb()end
function RegisterCommand(n,cb)commands[n]=cb end
function GetInvokingResource()return invoking or 'untrusted' end
exports=function(n,cb)exported[n]=cb end
MySQL={scalar={await=function(sql,args)
 if sql:find('society_owners') then return owner and args[2]==12 and args[1]=='mechanic' and 1 or nil end
 return ledger
end},query={await=function(sql,args)
 if sql:find('JOIN')then return owner and {{name='mechanic',balance=ledger}} or {} end
 if sql:find('SELECT actor') then return history end
 error('unexpected query')
end}}
MySQL.startTransaction=function(cb)
 local old=ledger
 local ok=cb(function(sql,args)
  if failed then error('database unavailable')end
  if sql:find('UPDATE') then
   if args[2]~='mechanic' or ledger+args[1]<0 then return {affectedRows=0} end
   ledger=ledger+args[1];return {affectedRows=1}
  end
  history[#history+1]=args;return {}
 end)
 if not ok then ledger=old end
 return ok
end
'''
checks=r'''
local action=callbacks['sg_banking:societyAction']
assert(action(1,'mechanic','deposit',100));assert(bank==900 and ledger==600)
assert(action(1,'mechanic','withdraw',200));assert(bank==1100 and ledger==400)
assert(not action(1,'mechanic','withdraw',500));assert(bank==1100 and ledger==400)
for _,n in ipairs({0,-1,1.5,math.huge,0/0,1000000001})do assert(not action(1,'mechanic','deposit',n))end
assert(not action(1,'other','withdraw',1))
assert(not action(1,'mechanic','set',1))
owner=false;player.jobInfo.isBoss=true
assert(#callbacks['sg_banking:societies'](1)==0)
assert(callbacks['sg_banking:societyHistory'](1,'mechanic')==nil)
assert(exported.getSocietyBalance(1,'mechanic')==nil)
assert(not action(1,'mechanic','deposit',100) and not action(1,'mechanic','withdraw',100))
owner=true;failed=true
assert(not action(1,'mechanic','deposit',100));assert(bank==1100 and ledger==400)
failed=false
assert(not exported.addSocietyMoney('mechanic',10))
invoking='trusted';assert(exported.addSocietyMoney('mechanic',10));assert(ledger==410)
assert(not exported.removeSocietyMoney('mechanic',411));assert(ledger==410)
assert(exported.removeSocietyMoney('mechanic',10));assert(ledger==400)
print('PASS: character ownership (including non-boss owner and non-owner boss), account/history privacy, amounts, overdraft, refunds, and resource allowlist')
'''
source=setup+'\n'+Path('resources/[scripts]/sg_banking/source/society_server.lua').read_text()+'\n'+checks
state=lib.luaL_newstate();lib.luaL_openlibs(state);data=source.encode()
status=lib.luaL_loadbufferx(state,data,len(data),b'society-tests',None)
if not status:status=lib.lua_pcallk(state,0,0,0,0,None)
if status:raise SystemExit(lib.lua_tolstring(state,-1,None).decode())
lib.lua_close(state)
