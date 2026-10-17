local bridge = {}
local SGCore = exports["sg_core"]

function bridge.notify(...)
    SGCore:notify(...)
end

function bridge.hasGroup(groups)
    if not groups then return end

    local player = SGCore.getPlayer()
    for i=1, #groups do
        if player.groups[groups[i]] then
            return true
        end
    end
end

function bridge.getPlayer()
    return SGCore:getPlayer()
end

function bridge.doesPlayerHaveJob(player, job)
    return player.groups[job]
end


AddEventHandler("SG:characterUnloaded", function()
    TriggerEvent("sg_police:playerUnloaded")
end)

return bridge
