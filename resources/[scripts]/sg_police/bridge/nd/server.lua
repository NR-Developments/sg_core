local bridge = {}
local SGCore = exports["sg_core"]

function bridge.notify(src, info)
    local player = SGCore:getPlayer(src)
    if not player then return end
    player.notify(info)
end

function bridge.shotSpotter(src, location, coords)
    if GetResourceState("sg_mdt") ~= "started" then return end

    exports["sg_mdt"]:createDispatch({
        location = location,
        callDescription = "Shotspotter detected gunshot",
        coords = coords
    })
end

function bridge.hasJobs(src, groups)
    local player = SGCore:getPlayer(src)
    if not player then return end

    for i=1, #groups do
        if player.groups[groups[i]] then
            return true
        end
    end
end

function bridge.impoundVehicle(netId, entity, impoundReclaimPrice)
    local vehicle = SGCore.getVehicle(entity)
    if not vehicle then return end
    vehicle.setMetadata("impoundReclaimPrice", impoundReclaimPrice)
    vehicle.setStatus("impounded", true)
end

return bridge
