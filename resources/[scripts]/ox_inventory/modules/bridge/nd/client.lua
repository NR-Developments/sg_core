if not lib.checkDependency('sg_core', '2.0.0', true) then return end

SGCore = {}

lib.load('@sg_core.init')

RegisterNetEvent("SG:characterUnloaded", client.onLogout)

local function reorderGroups(groups)
    groups = groups or {}
    for group, info in pairs(groups) do
        groups[group] = info.rank
    end
    return groups
end

SetTimeout(500, function()
	local player = SGCore.getPlayer()
    if not player then return end
    client.setPlayerData("groups", reorderGroups(player.groups))
end)

RegisterNetEvent("SG:characterLoaded", function(character)
    client.setPlayerData("groups", reorderGroups(character.groups))
end)

RegisterNetEvent("SG:updateCharacter", function(character, updatedData)
    local validUpdateData = { ["job"] = true, ["groups"] = true, ["jobInfo"] = true }
    if not validUpdateData[updatedData] then return end
    client.setPlayerData("groups", reorderGroups(character.groups))
end)

---@diagnostic disable-next-line: duplicate-set-field
function client.setPlayerStatus(values)
    if GetResourceState("sg_status") ~= "started" then return end

    local status = exports["sg_status"]

    for name, value in pairs(values) do

        if value > 100 or value < -100 then
            value = value * 0.0001
        end

        status:changeStatus(name, value)
    end
end
