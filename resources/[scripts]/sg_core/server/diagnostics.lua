local expected = {'oxmysql','ox_lib','sg_core','es_extended','qb-core','fivem-appearance','ox_target','ox_inventory','ox_doorlock','pma-voice','sg_spawn','sg_multicharacter','sg_appearanceshops','sg_status','sg_banking','sg_dealership','sg_fuel','sg_casino','sg_blackjack','sg_nitro','sg_mdt','sg_police','sg_ambulance'}
local function status()
    local result = {databaseReady = SGCore.databaseReady == true, resources = {}}
    for _,name in ipairs(expected) do result.resources[name]=GetResourceState(name) end
    return result
end
exports('GetFrameworkStatus',status)
RegisterCommand('sgdoctor',function(src)
    if src ~= 0 and not IsPlayerAceAllowed(src,'command.sgdoctor') then return end
    local info=status()
    local lines={'SG database ready: '..tostring(info.databaseReady)}
    for _,name in ipairs(expected) do lines[#lines+1]=name..': '..info.resources[name] end
    if src==0 then print(table.concat(lines,'\n'))
    else TriggerClientEvent('chat:addMessage',src,{args={'SG Framework',table.concat(lines,'\n')}}) end
end,true)
