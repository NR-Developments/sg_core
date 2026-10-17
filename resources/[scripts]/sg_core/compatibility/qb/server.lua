if not lib.table.contains(Config.compatibility,'qb') then return end
local QB={Functions={},Shared={Jobs={},Gangs={},Items={},Vehicles={},Weapons={},StarterItems={}},Commands={},Config={}}
local F=QB.Functions
local function data(p)
    local j=p.jobInfo or {}; local metadata=lib.table.deepclone(p.metadata)
    metadata.inside=metadata.inside or {house=nil,apartment={}}
    return {source=p.source,citizenid=tostring(p.id),license=p.identifier,name=GetPlayerName(p.source),
        charinfo={firstname=p.firstname,lastname=p.lastname,birthdate=p.dob,phone=p.phonenumber,gender=(p.gender=='f' or p.gender=='female') and 1 or 0,nationality=metadata.nationality or ''},
        money={cash=p.cash,bank=p.bank},metadata=metadata,
        job={name=p.job or 'unemployed',label=j.label or 'Unemployed',type=(j.metadata or {}).type,onduty=metadata.onduty~=false,isboss=j.isBoss==true,grade={level=math.max(0,(j.rank or 1)-1),name=tostring(j.rankName or 'Unemployed')}},
        gang=metadata.gang or {name='none',label='No Gang',isboss=false,grade={level=0,name='None'}},
        items=GetResourceState('ox_inventory')=='started' and exports.ox_inventory:GetInventoryItems(p.source) or {}}
end
local function wrap(p)
    if not p then return end
    local obj={PlayerData=data(p),Functions={}}; local f=obj.Functions
    f.AddMoney=function(...) local ok=p.addMoney(...);obj.PlayerData=data(p);return ok end
    f.RemoveMoney=function(...) local ok=p.deductMoney(...);obj.PlayerData=data(p);return ok end
    f.GetMoney=function(account) return p[account] or 0 end
    f.SetMoney=function(account,n,reason)
        n=tonumber(n)
        if (account~='cash' and account~='bank') or not n or n~=n or n==math.huge or n<0 or n%1~=0 then return false end
        p.setData(account,n,reason); obj.PlayerData=data(p); return true
    end
    f.SetJob=function(name,grade) if not QB.Shared.Jobs[name] then return false end local ok=p.setJob(name,(tonumber(grade) or 0)+1);obj.PlayerData=data(p);return ok~=nil end
    f.SetJobDuty=function(duty) p.setMetadata('onduty',duty==true);obj.PlayerData=data(p);TriggerClientEvent('QBCore:Client:OnJobUpdate',p.source,obj.PlayerData.job) end
    f.SetMetaData=function(...) local value=p.setMetadata(...);obj.PlayerData=data(p);return value end; f.GetMetaData=p.getMetadata
    f.AddItem=function(item,amount,slot,info) return exports.ox_inventory:AddItem(p.source,item,amount,info,slot) end
    f.RemoveItem=function(item,amount,slot) return exports.ox_inventory:RemoveItem(p.source,item,amount,nil,slot) end
    f.GetItemByName=function(item) return exports.ox_inventory:GetItem(p.source,item) end
    f.GetItemsByName=function(item) return exports.ox_inventory:Search(p.source,'slots',item) or {} end
    f.Save=p.save
    f.UpdatePlayerData=function() obj.PlayerData=data(p);TriggerClientEvent('QBCore:Player:SetPlayerData',p.source,obj.PlayerData) end
    f.SetPlayerData=function(key,value)
        local fields={charinfo=true,metadata=true}
        if key=='metadata' then p.setMetadata(value)
        elseif key=='charinfo' and type(value)=='table' then
            p.setData({firstname=value.firstname or p.firstname,lastname=value.lastname or p.lastname,phonenumber=value.phone or p.phonenumber})
        else return false end
        f.UpdatePlayerData(); return true
    end
    f.Logout=p.unload
    return obj
end
for name,g in pairs(Config.groups) do
    local grades={} for i,rank in ipairs(g.ranks or {}) do grades[tostring(i-1)]={name=rank,payment=0,isboss=i>=(g.minimumBossRank or math.huge)} end
    QB.Shared.Jobs[name]={label=g.label,defaultDuty=true,offDutyPay=false,grades=grades}
end
function F.GetPlayer(src) return wrap(SGCore.getPlayer(tonumber(src))) end
function F.GetPlayers() local list={} for src in pairs(SGCore.players) do list[#list+1]=src end return list end
function F.GetQBPlayers() local list={} for src,p in pairs(SGCore.players) do list[src]=wrap(p) end return list end
function F.GetPlayerByCitizenId(id) for _,p in pairs(SGCore.players) do if tostring(p.id)==tostring(id) then return wrap(p) end end end
function F.GetPlayerByPhone(phone) for _,p in pairs(SGCore.players) do if p.phonenumber==phone then return wrap(p) end end end
F.GetSource=function(id) local p=F.GetPlayerByCitizenId(id);return p and p.PlayerData.source end
F.GetIdentifier=GetPlayerIdentifierByType
F.HasPermission=function(src,permission)
    if type(permission)=='table' then for _,v in pairs(permission) do if F.HasPermission(src,v) then return true end end return false end
    return IsPlayerAceAllowed(src,'group.'..tostring(permission)) or IsPlayerAceAllowed(src,'command')
end
F.IsOptin=function(src) return F.HasPermission(src,'admin') end
F.Notify=function(src,text,kind,length) TriggerClientEvent('QBCore:Notify',src,text,kind,length) end
F.CreateUseableItem=function(name,cb) exports.sg_core:GetESXObject().RegisterUsableItem(name,cb) end
F.CreateCallback=function(name,cb) exports.sg_core:GetESXObject().RegisterServerCallback(name,cb) end
F.GetPlayersFromCoords=function(coords,distance)
    local list={} for src in pairs(SGCore.players) do if #(GetEntityCoords(GetPlayerPed(src))-vector3(coords.x,coords.y,coords.z))<=(distance or 5) then list[#list+1]=src end end return list
end
function QB.Commands.Add(name,help,arguments,argsRequired,cb,permission)
    RegisterCommand(name,function(src,args) if src~=0 and permission and permission~='user' and not F.HasPermission(src,permission) then return end cb(src,args) end,false)
end
QB.Commands.Refresh=function() end
QB.Shared.Round=function(n,d) local m=10^(d or 0);return math.floor(n*m+0.5)/m end
QB.Shared.Trim=function(s) return s:match('^%s*(.-)%s*$') end
QB.Shared.SplitStr=function(s,sep) local t={} for token in s:gmatch('[^'..sep..']+') do t[#t+1]=token end return t end
exports('GetQBObject',function() return QB end)
AddEventHandler('SG:characterLoaded',function(p) TriggerClientEvent('QBCore:Player:SetPlayerData',p.source,data(p));TriggerClientEvent('QBCore:Client:OnPlayerLoaded',p.source);TriggerEvent('QBCore:Server:PlayerLoaded',wrap(p)) end)
AddEventHandler('SG:characterUnloaded',function(src) TriggerClientEvent('QBCore:Client:OnPlayerUnload',src);TriggerEvent('QBCore:Server:OnPlayerUnload',src) end)
local function sync(p,key)
    TriggerClientEvent('QBCore:Player:SetPlayerData',p.source,data(p))
    if key=='job' or key=='groups' then TriggerClientEvent('QBCore:Client:OnJobUpdate',p.source,data(p).job) end
end
AddEventHandler('SG:updateCharacter',sync)
AddEventHandler('SG:moneyChange',function(src) local p=SGCore.getPlayer(src);if p then sync(p,'money') end end)
AddEventHandler('onResourceStart',function(name)
    if name=='ox_inventory' then QB.Shared.Items=exports.ox_inventory:Items() end
end)
