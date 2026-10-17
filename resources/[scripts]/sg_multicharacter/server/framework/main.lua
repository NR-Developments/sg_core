-- SG native character storage. Slot identity is metadata, ownership is always checked server-side.
local Core=exports.sg_core
local locks={}
local function ready()
    local deadline=GetGameTimer()+15000
    while not GlobalState.sgDatabaseReady do
        if GetGameTimer()>deadline then error('SG database is not ready') end
        Wait(100)
    end
end
GetIdentifiers=function(src) return GetPlayerIdentifierByType(src,'license') end
local function slotLimit(src)
    local limits=json.decode(GetResourceKvpString('char_slots') or '{}')
    return math.min(20,math.max(1,tonumber(limits[GetIdentifiers(src)]) or Config.Slots))
end
local function list(src)
    ready()
    local result=Core:fetchAllCharacters(src)
    local slots,unassigned={},{}
    for id,p in pairs(result) do
        local slot=tonumber(p.metadata.sgSlot)
        if slot and not slots[slot] then slots[slot]=p else unassigned[#unassigned+1]=p end
    end
    table.sort(unassigned,function(a,b) return a.id<b.id end)
    for _,p in ipairs(unassigned) do
        local slot=1 while slots[slot] do slot=slot+1 end
        p.setMetadata('sgSlot',slot);p.save('metadata');slots[slot]=p
    end
    return slots
end
GetExtras=function(id) return (GlobalState.PlayerStates or {})[tostring(id)] or {} end
GetCharacters=function(src)
    local chars={}
    for slot,p in pairs(list(src)) do
        local j=p.jobInfo or {}
        chars[slot]={slot=slot,identifier=tostring(p.id),name=p.firstname..' '..p.lastname,
            job=j.label or 'Unemployed',grade=j.rankName or '',dateofbirth=p.dob,
            bank=p.bank,money=p.cash,skin=p.metadata.clothing or {},sex=p.gender,
            position=p.metadata.location or {x=Config.Spawn.x,y=Config.Spawn.y,z=Config.Spawn.z,heading=0},extras=GetExtras(p.id)}
    end
    return {characters=chars,slots=slotLimit(src)}
end
DeleteCharacter=function(src,slot)
    if not Config.CanDelete or Core:getPlayer(src) then return false end
    local p=list(src)[tonumber(slot)];return p and p.delete()~=nil or false
end
LoadPlayer=function(src) return Core:getPlayer(src)~=nil end
Login=function(src,slot,info)
    slot=tonumber(slot)
    if locks[src] or Core:getPlayer(src) or not slot or slot%1~=0 or slot<1 or slot>slotLimit(src) then return false end
    locks[src]=true
    local ok,result=pcall(function()
        local chars=list(src);local p=chars[slot]
        if info then
            if p or type(info)~='table' then return false end
            local first,last=tostring(info.firstname or ''),tostring(info.lastname or '')
            if #first<1 or #first>40 or #last<1 or #last>40 then return false end
            p=Core:newCharacter(src,{firstname=first,lastname=last,dob=tostring(info.dateofbirth or info.birthdate or ''):sub(1,20),
                gender=info.sex=='f' and 'f' or 'm',cash=GetConvarInt('sg:startingCash',500),bank=GetConvarInt('sg:startingBank',5000),
                metadata={sgSlot=slot,sgNew=true,nationality=tostring(info.nationality or ''):sub(1,80),background=tostring(info.freeform or ''):sub(1,2000),location={x=Config.Spawn.x,y=Config.Spawn.y,z=Config.Spawn.z,w=0}}})
            if not p then return false end
            p.setJob('unemployed',1);p.save()
        elseif not p then return false end
        SetPlayerRoutingBucket(src,0)
        local selected=Core:setActiveCharacter(src,p.id)
        if not selected then return false end
        Player(src).state:set('identifier',tostring(selected.id),true)
        local result={playerData={coords=selected.metadata.location,sex=selected.gender},
            isNew=selected.metadata.sgNew==true,skin=selected.metadata.clothing or {}}
        if selected.metadata.sgNew then selected.setMetadata('sgNew',false);selected.save('metadata') end
        return result
    end)
    locks[src]=nil
    if not ok then print(('[SG Characters] Login failed: %s'):format(result));return false end
    return result
end
SaveSkin=function(src,appearance)
    local p=Core:getPlayer(src)
    if not p or type(appearance)~='table' or #json.encode(appearance)>65536 then return false end
    p.setMetadata('clothing',appearance);return p.save('metadata')
end
UpdateSlot=function(src,id,slots)
    if src~=0 and not IsPlayerAceAllowed(src,'command.updatecharslots') then return false end
    local license=GetIdentifiers(tonumber(id));slots=tonumber(slots)
    if not license or not slots or slots%1~=0 or slots<1 or slots>20 then return false end
    local limits=json.decode(GetResourceKvpString('char_slots') or '{}');limits[license]=slots
    SetResourceKvp('char_slots',json.encode(limits));return true
end
RegisterCommand(Config.commandslot,function(src,args) UpdateSlot(src,args[1],args[2]) end,true)
AddEventHandler('playerDropped',function() locks[source]=nil end)
