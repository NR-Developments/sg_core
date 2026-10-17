local bridge = {}
local SGCore = require "@sg_core.init"

function bridge.getPlayer(src)
    return SGCore.getPlayer(src)
end

function bridge.notify(src, data)
    local player = SGCore.getPlayer(src)
    if not player then return end
    player.notify(data)
end

function bridge.hasMoney(src, amount)
    local player = SGCore.getPlayer(src)
    if not player then return end

    if player.bank >= amount or player.cash >= amount then
        return true
    end
end

function bridge.deductMoney(src, amount)
    local player = SGCore.getPlayer(src)
    if not player then return end

    if player.bank >= amount then
        player.deductMoney("bank", amount, "Hospital bill")
    elseif player.cash >= amount then
        player.deductMoney("cash", amount, "Hospital bill")
    end
end

function bridge.revivePlayer(src)
    local player = SGCore.getPlayer(src)
    if not player then return end
    player.revive()
end

return bridge