local lastAccounts, lastSignal = {}, {}
local function balance(value)
    value = tonumber(value)
    if not value or value ~= value or value == math.huge or value == -math.huge then return 0 end
    return math.max(0, math.floor(value))
end
local function read(provider, player)
    local ok, value = pcall(provider, player)
    if not ok then return nil end
    return value ~= nil and balance(value) or nil
end
lib.callback.register('sg_hud:accounts', function(src)
    local player = exports.sg_core:getPlayer(src)
    if not player then return {blackMoney=0, society=0, hasSociety=false} end
    local now = GetGameTimer()
    if lastAccounts[src] and now-lastAccounts[src].time < 1000 then return lastAccounts[src].value end
    local boss = player.jobInfo and player.jobInfo.isBoss == true
    local society = boss and read(HUDAccounts.society, player) or nil
    local result = {blackMoney=read(HUDAccounts.blackMoney, player) or 0, society=society or 0, hasSociety=society ~= nil}
    lastAccounts[src] = {time=now, value=result}
    return result
end)
RegisterNetEvent('sg_hud:syncCarLights', function(status)
    local src = source
    if status ~= 'left' and status ~= 'right' and status ~= 'both' and status ~= 'off' then return end
    local now = GetGameTimer()
    if lastSignal[src] and now-lastSignal[src] < 100 then return end
    local ped = GetPlayerPed(src)
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle == 0 or GetPedInVehicleSeat(vehicle, -1) ~= ped then return end
    lastSignal[src] = now
    TriggerClientEvent('sg_hud:syncCarLights', -1, src, status)
end)
AddEventHandler('playerDropped', function() lastAccounts[source]=nil;lastSignal[source]=nil end)
AddEventHandler('SG:characterUnloaded', function(src) lastAccounts[src]=nil;lastSignal[src]=nil end)
