local SGCore = exports["sg_core"]

RegisterNetEvent("sg_fuel:pay", function(amount)
    local src = source
    local player = SGCore:getPlayer(src)
    if not player then return end

    player.deductMoney("bank", math.floor(amount), "Gas Station")
    player.notify({
        title = ("Paid: $%.2f for gas."):format(amount),
        type = "inform"
    })
end)
