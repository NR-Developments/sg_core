-- ESX is a view over SG players. Never decorate or mutate the native character table.
if not lib.table.contains(Config.compatibility, 'esx') then return end
local ESX = {Players = {}, Jobs = {}, OneSync = {}}
local callbacks, usable = {}, {}
local function account(name) return name == 'money' and 'cash' or name end
local function jobData(p)
    local j = p.jobInfo or (p.groups or {}).unemployed or {}
    return {name=p.job or 'unemployed', label=j.label or 'Unemployed', grade=math.max(0,(j.rank or 1)-1),
        grade_name=tostring(j.rankName or 'unemployed'), grade_label=tostring(j.rankName or 'Unemployed'),
        grade_salary=0, onDuty=p.metadata.onduty ~= false, isboss=j.isBoss == true}
end
for name, group in pairs(Config.groups) do
    local grades = {}
    for i, rank in ipairs(group.ranks or {}) do grades[tostring(i-1)]={grade=i-1,name=rank,label=rank,salary=0} end
    ESX.Jobs[name]={name=name,label=group.label,grades=grades}
end
local function view(p)
    if not p then return end
    local x={source=p.source, identifier=tostring(p.id), license=p.identifier, name=p.fullname,
        firstname=p.firstname, lastname=p.lastname, dateofbirth=p.dob, sex=p.gender, job=jobData(p),
        variables=p.metadata, metadata=p.metadata}
    x.getIdentifier=function() return tostring(p.id) end
    x.getName=function() return ('%s %s'):format(p.firstname,p.lastname) end
    x.getJob=function() return jobData(p) end
    x.setJob=function(name,grade) if not ESX.DoesJobExist(name,grade) then return false end local ok=p.setJob(name,tonumber(grade)+1); x.job=jobData(p);return ok~=nil end
    x.getMoney=function() return p.cash end
    x.addMoney=function(n,reason) return p.addMoney('cash',n,reason) end
    x.removeMoney=function(n,reason) return p.deductMoney('cash',n,reason) end
    x.setMoney=function(n) return x.setAccountMoney('money',n) end
    x.getAccount=function(name) local a=account(name); if a~='cash' and a~='bank' then return end return {name=name,money=p[a],label=name} end
    x.getAccounts=function() return {x.getAccount('money'),x.getAccount('bank')} end
    x.addAccountMoney=function(name,n,reason) return p.addMoney(account(name),n,reason) end
    x.removeAccountMoney=function(name,n,reason) return p.deductMoney(account(name),n,reason) end
    x.setAccountMoney=function(name,n)
        local a=account(name); n=tonumber(n)
        if (a~='cash' and a~='bank') or not n or n~=n or n<0 or n==math.huge or n%1~=0 then return false end
        p.setData(a,n); return true
    end
    x.getInventory=function() return exports.ox_inventory:GetInventoryItems(p.source) or {} end
    x.getInventoryItem=function(name) return exports.ox_inventory:GetItem(p.source,name) or {name=name,count=0} end
    x.addInventoryItem=function(name,count,metadata) return exports.ox_inventory:AddItem(p.source,name,count,metadata) end
    x.removeInventoryItem=function(name,count,metadata) return exports.ox_inventory:RemoveItem(p.source,name,count,metadata) end
    x.setInventoryItem=function(name,count) return exports.ox_inventory:SetItem(p.source,name,count) end
    x.canCarryItem=function(name,count,metadata) return exports.ox_inventory:CanCarryItem(p.source,name,count,metadata) end
    x.canSwapItem=function(...) return exports.ox_inventory:CanSwapItem(p.source,...) end
    x.hasItem=x.getInventoryItem
    x.getGroup=function() return IsPlayerAceAllowed(p.source,'command') and 'admin' or 'user' end
    x.getMeta=p.getMetadata; x.setMeta=p.setMetadata; x.set=p.setMetadata; x.get=p.getMetadata
    x.getCoords=function(asVector) local c=GetEntityCoords(GetPlayerPed(p.source)); return asVector and c or {x=c.x,y=c.y,z=c.z,heading=GetEntityHeading(GetPlayerPed(p.source))} end
    x.setCoords=p.setCoords; x.triggerEvent=p.triggerEvent; x.kick=p.drop
    x.showNotification=function(msg,kind,duration) p.notify({description=msg,type=kind or 'inform',duration=duration}) end
    x.getWeight=function() local inv=exports.ox_inventory:GetInventory(p.source); return inv and inv.weight or 0 end
    x.getMaxWeight=function() local inv=exports.ox_inventory:GetInventory(p.source); return inv and inv.maxWeight or 0 end
    x.setMaxWeight=function(weight) return exports.ox_inventory:SetMaxWeight(p.source,weight) end
    x.inventory=GetResourceState('ox_inventory')=='started' and x.getInventory() or {}
    x.accounts=x.getAccounts(); x.coords=x.getCoords(false)
    return x
end
function ESX.GetPlayerFromId(src) return view(SGCore.getPlayer(tonumber(src))) end
function ESX.GetPlayerFromIdentifier(id)
    for _,p in pairs(SGCore.players) do if tostring(p.id)==tostring(id) then return view(p) end end
end
function ESX.GetPlayers() local ids={} for src in pairs(SGCore.players) do ids[#ids+1]=src end return ids end
function ESX.GetExtendedPlayers(key,value)
    local list={} for _,p in pairs(SGCore.players) do local x=view(p); if not key or (key=='job' and x.job.name==value) or x[key]==value then list[#list+1]=x end end return list
end
function ESX.GetIdentifier(src) return SGCore.getPlayerIdentifierByType(src,Config.characterIdentifier) end
function ESX.GetJobs() return ESX.Jobs end
function ESX.DoesJobExist(name,grade) return ESX.Jobs[name] and ESX.Jobs[name].grades[tostring(grade)] ~= nil end
function ESX.GetItemLabel(name) local item=exports.ox_inventory:Items(name); return item and item.label end
function ESX.RegisterServerCallback(name,cb)
    callbacks[name]=cb
    lib.callback.register(name,function(src,...)
        local result=promise.new()
        local resolved=false
        local function reply(...) if resolved then return end; resolved=true; result:resolve(table.pack(...)) end
        cb(src,reply,...)
        SetTimeout(15000,function() reply(nil) end)
        local values=Citizen.Await(result); return table.unpack(values,1,values.n)
    end)
end
RegisterNetEvent('esx:triggerServerCallback',function(name,requestId,invoker,...)
    local src=source
    if type(name)~='string' or not callbacks[name] then return end
    callbacks[name](src,function(...) TriggerClientEvent('esx:serverCallback',src,requestId,invoker,...) end,...)
end)
function ESX.RegisterUsableItem(name,cb) usable[name]=cb end
function ESX.UseItem(src,name,data) if not usable[name] then return false end; usable[name](src,data); return true end
function ESX.RegisterCommand(names,groups,cb,allowConsole,suggestion)
    if type(names)=='string' then names={names} end
    for _,name in ipairs(names) do RegisterCommand(name,function(src,args)
        if src==0 and not allowConsole then return end
        local permitted=not groups or groups=='user' or src==0
        for _,g in ipairs(type(groups)=='table' and groups or {groups}) do if g and IsPlayerAceAllowed(src,'group.'..g) then permitted=true end end
        if not permitted then return end
        cb(ESX.GetPlayerFromId(src),args,function(msg) if src==0 then print(msg) else TriggerClientEvent('esx:showNotification',src,msg) end end)
    end,false) end
end
ESX.SetTimeout=SetTimeout; ESX.Trace=print
ESX.GetConfig=function() return {CustomInventory='ox',EnableMultichar=true,Locale=GetConvar('ox:locale','en')} end
ESX.SavePlayer=function(x,cb) local p=SGCore.getPlayer(x.source); local ok=p and p.save(); if cb then cb(ok) end return ok end
AddEventHandler('esx:getSharedObject',function(cb) cb(ESX) end)
exports('GetESXObject',function() return ESX end)
exports('UseItem',ESX.UseItem)
AddEventHandler('SG:characterLoaded',function(p)
    local x=view(p); ESX.Players[p.source]=x
    TriggerEvent('esx:playerLoaded',p.source,x,p.metadata.sgNew==true)
    TriggerClientEvent('esx:playerLoaded',p.source,{identifier=x.identifier,firstname=p.firstname,lastname=p.lastname,
        sex=p.gender,dateofbirth=p.dob,job=x.job,accounts=x.accounts,inventory=x.inventory,coords=p.metadata.location or {x=-1037.59,y=-2736.90,z=20.16}},p.metadata.sgNew==true,p.metadata.clothing or {})
end)
AddEventHandler('SG:characterUnloaded',function(src)
    ESX.Players[src]=nil; TriggerEvent('esx:playerDropped',src,'Character unloaded')
    TriggerClientEvent('esx:onPlayerLogout',src)
end)
AddEventHandler('SG:updateCharacter',function(p,key)
    ESX.Players[p.source]=view(p)
    if key=='job' or key=='groups' then TriggerClientEvent('esx:setJob',p.source,jobData(p)); TriggerEvent('esx:setJob',p.source,jobData(p)) end
end)
