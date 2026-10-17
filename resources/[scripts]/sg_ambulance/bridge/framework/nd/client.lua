local bridge = {}
local SGCore = require "@sg_core.init"

local player = SGCore.getPlayer()

AddEventHandler("onResourceStart", function(resourceName)
    if cache.resource ~= resourceName then return end
    player = SGCore.getPlayer()
end)

RegisterNetEvent("SG:characterLoaded", function(character)
    player = character
end)

RegisterNetEvent("SG:updateCharacter", function(character)
    player = character
end)

function bridge.hasJobs(jobs)
    return player and lib.table.contains(jobs, player.job)
end

function bridge.notify(data)
    SGCore.notify(data)
end

function bridge.createAiPed(info)
    SGCore.createAiPed(info)
end

function bridge.isDead()
    return player and player.metadata.dead
end

return bridge