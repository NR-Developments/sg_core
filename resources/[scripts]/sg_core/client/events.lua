-- updates the money on the client.
RegisterNetEvent("SG:updateMoney", function(cash, bank)
    if not SGCore.player then return end
    SGCore.player.cash = cash
    SGCore.player.bank = bank
end)

-- Sets main character.
RegisterNetEvent("SG:characterLoaded", function(character)
    SGCore.player = character
end)

-- Update main character info.
RegisterNetEvent("SG:updateCharacter", function(character)
    SGCore.player = character
end)

-- Updates last lcoation.
RegisterNetEvent("SG:updateLastLocation", function(location)
    if not SGCore.player then return end
    SGCore.player.lastLocation = location
end)

RegisterNetEvent("SG:revivePlayer", function()
    if source == "" then return end
    local oldPed = cache.ped
    local veh = GetVehiclePedIsIn(oldPed)
    local seat = cache.seat
    local coords = GetEntityCoords(oldPed)
    local armor = GetPedArmour(oldPed)

    NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, GetEntityHeading(oldPed), true, true, false)

    local ped = PlayerPedId()
    if oldPed ~= ped then
        DeleteEntity(oldPed)
        ClearAreaOfPeds(coords.x, coords.y, coords.z, 0.2, false)
    end

    SetEntityInvincible(ped, false)
    FreezeEntityPosition(ped, false)
    SetEntityVisible(ped, true)
    SetEveryoneIgnorePlayer(ped, false)
    SetPedCanBeTargetted(ped, true)
    SetEntityCanBeDamaged(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, false)
    SetPedCanRagdollFromPlayerImpact(ped, true)
    ClearPedTasksImmediately(ped)
    SetPedArmour(ped, armor)

    if veh and veh ~= 0 then
        SetPedIntoVehicle(ped, veh, seat)
    end
end)

RegisterNetEvent("SG:characterUnloaded", function()
    SGCore.player = nil
end)

RegisterNetEvent("SG:clothingMenu", function()
    if GetResourceState("fivem-appearance") ~= "started" then return end
    
    local function customize(appearance)
        if not appearance then return end
        TriggerServerEvent("SG:updateClothing", appearance)
    end
    
    exports["fivem-appearance"]:startPlayerCustomization(customize, {
        ped = false,
        headBlend = true,
        faceFeatures = true,
        headOverlays = true,
        components = true,
        props = true,
        tattoos = true
    })
end)
