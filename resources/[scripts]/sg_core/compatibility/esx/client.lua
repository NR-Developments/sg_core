if not lib.table.contains(Config.compatibility, "esx") then return end

SGCore.Game = {}
SGCore.Game.Utils = {}
SGCore.Scaleform = {}
SGCore.Scaleform.Utils = {}
SGCore.Streaming = {}
SGCore.UI = {}
SGCore.UI.HUD = {}
SGCore.UI.Menu = {}
SGCore.PlayerData = {}

local uiMetatable = {
    __index = function(table, key)
        if type(key) == "string" and key:match("^%a+$") then
            return function()
                print(("[^3WARNING^7] ESX Function '%s' is not compatible with SGCore!"):format(key))
            end
        end
    end
}

setmetatable(SGCore.UI, uiMetatable)
setmetatable(SGCore.UI.HUD, uiMetatable)
setmetatable(SGCore.UI.Menu, uiMetatable)

local function exportHandler(resource, exportName, cb)
    AddEventHandler(("__cfx_export_%s_%s"):format(resource, exportName), function(setCB)
        setCB(cb)
    end)
end

exportHandler("es_extended", "getSharedObject", function()
    return SGCore
end)

function SGCore.GetPlayerData()
    local native = SGCore.getPlayer()
    local player = native and lib.table.deepclone(native)
    if not player then return {} end

    player.Accounts = {
        Bank = player.bank,
        Money = player.cash,
        Black = player.cash
    }

    if player.jobInfo then        
        player.job = {
            id = player.job,
            name = player.job,
            label = player.jobInfo.label,
            grade = math.max(0, player.jobInfo.rank-1),
            grade_name = tostring(player.jobInfo.rankName),
            grade_label = player.jobInfo.rankName,
            grade_salary = 0,
            skin_male = {},
            skin_female = {}
        }
    end

    player.identifier = tostring(player.id)
    player.inventory = GetResourceState("ox_inventory") == "started" and exports.ox_inventory:GetPlayerItems() or {}
    player.coords = GetEntityCoords(cache.ped)
    player.loadout = {}
    player.maxWeight = 30000
    player.money = player.Accounts.Money
    player.sex = player.gender
    player.firstName = player.firstname
    player.lastName = player.lastname
    player.dateofbirth = player.dob
    player.height = 120
    player.dead = LocalPlayer.state.dead or false
    SGCore.PlayerData = player

    return player
end

function SGCore.IsPlayerLoaded()
    return SGCore.getPlayer() ~= nil
end

function SGCore.Progressbar(message, lenght, options)
    local newOptions = {
        duration = lenght,
        label = message,
        canCancel = true
    }

    if options.animation then        
        newOptions.anim = {}
        if options.animation.type == "anim" then            
            if options.animation.dict then
                newOptions.anim.dict = options.animation.dict
            end
            if options.animation.lib then
                newOptions.anim.clip = options.animation.lib
            end
        elseif options.animation.type == "Scenario" then
            newOptions.anim.scenario = options.animation.Scenario
        end
    end

    if options.FreezePlayer then FreezeEntityPosition(cache.ped, true) end
    local complete = lib.progressBar(newOptions)

    if options.FreezePlayer then FreezeEntityPosition(cache.ped, false) end
    if newOptions.onFinish and complete then
        newOptions.onFinish()
    end
    if newOptions.onCancel and not complete then
        newOptions.onCancel()
    end
    return complete
end

function SGCore.SearchInventory(item, count)
    local itemCount =  GetResourceState("ox_inventory") == "started" and exports.ox_inventory:Search(item) or 0
    return itemCount >= count and itemCount
end

function SGCore.SetPlayerData()
    print("[^3WARNING^7] ESX Function 'SetPlayerData' is not compatible with SGCore!")
end

function SGCore.ShowAdvancedNotification()
    print("[^3WARNING^7] ESX Function 'ShowAdvancedNotification' is not compatible with SGCore!")
end

function SGCore.ShowFloatingHelpNotification()
    print("[^3WARNING^7] ESX Function 'ShowFloatingHelpNotification' is not compatible with SGCore!")
end

function SGCore.ShowHelpNotification()
    print("[^3WARNING^7] ESX Function 'ShowHelpNotification' is not compatible with SGCore!")
end

function SGCore.ShowInventory()
    return GetResourceState("ox_inventory") == "started" and exports.ox_inventory:openInventory("player", cache.serverId)
end

function SGCore.ShowNotification(msg, type, time)
    SGCore.notify({
        title = "Notification",
        description = msg,
        type = type == "info" and "inform" or type,
        duration = time
    })
end

function SGCore.TriggerServerCallback(name, cb, ...)
    lib.callback(name, nil, cb, ...)
end

function SGCore.Streaming.RequestAnimDict(animDict, cb)
    lib.requestAnimDict(animDict)
    if cb then cb(animDict) end
    return animDict
end

function SGCore.Streaming.RequestAnimSet(animSet, cb)
    lib.requestAnimSet(animSet)
    if cb then cb(animSet) end
    return animSet
end

function SGCore.Streaming.RequestModel(model, cb)
    lib.requestModel(model)
    if cb then cb(model) end
    return model
end

function SGCore.Streaming.RequestNamedPtfxAsset(assetName, cb)
    lib.requestNamedPtfxAsset(assetName)
    if cb then cb(assetName) end
    return assetName
end

function SGCore.Streaming.RequestStreamedTextureDict(textureDict, cb)
    lib.requestStreamedTextureDict(textureDict)
    if cb then cb(textureDict) end
    return textureDict
end

function SGCore.Streaming.RequestWeaponAsset(weaponHash, cb)
    lib.requestWeaponAsset(weaponHash)
    if cb then cb(weaponHash) end
    return weaponHash
end

function SGCore.Scaleform.ShowBreakingNews()
    print("[^3WARNING^7] ESX Function 'Scaleform.ShowBreakingNews' is not compatible with SGCore!")
end

function SGCore.Scaleform.ShowFreemodeMessage()
    print("[^3WARNING^7] ESX Function 'Scaleform.ShowFreemodeMessage' is not compatible with SGCore!")
end

function SGCore.Scaleform.ShowPopupWarning()
    print("[^3WARNING^7] ESX Function 'Scaleform.ShowPopupWarning' is not compatible with SGCore!")
end

function SGCore.Scaleform.ShowTrafficMovie()
    print("[^3WARNING^7] ESX Function 'Scaleform.ShowTrafficMovie' is not compatible with SGCore!")
end

function SGCore.Scaleform.Utils.RequestScaleformMovie()
    print("[^3WARNING^7] ESX Function 'Scaleform.Utils.RequestScaleformMovie' is not compatible with SGCore!")
end

function SGCore.Game.Utils.DrawText3D(coords, text, size, font)
    local onScreen, x, y = World3dToScreen2d(coords.x, coords.y, coords.z)
    if not onScreen then return end
    SetTextScale(size or 0.4, size or 0.4)
    SetTextFont(font or 4)
    SetTextProportional(1)
    SetTextEntry("STRING")
    SetTextCentre(true)
    SetTextColour(255, 255, 255, 255)
    SetTextOutline()
    AddTextComponentString(text)
    DrawText(x, y)
end

function SGCore.Game.DeleteObject(object)
    if not DoesEntityExist(object) then return end
    DeleteEntity(object)
end

function SGCore.Game.DeleteVehicle(vehicle)
    if not DoesEntityExist(vehicle) then return end
    DeleteEntity(vehicle)
end

function SGCore.Game.GetClosestEntity(coords)
    coords = coords or GetEntityCoords(cache.ped)
    local loc = vec3(coords.x, coords.y, coords.z)
    local entities = {lib.getClosestObject(loc), lib.getClosestPed(loc), lib.getClosestVehicle(loc)}
    local closest = nil
    local closestDistance = math.huge

    for i = 1, #entities do
        local ent = entities[i]
        if DoesEntityExist(ent.object or ent.ped or ent.vehicle) then
            local distance = #(loc-ent.coords)
            if distance < closestDistance then
                closest = ent
                closestDistance = distance
            end
        end
    end
    return closest.object or closest.ped or closest.vehicle
end

function SGCore.Game.GetClosestObject(coords)
    coords = coords or GetEntityCoords(cache.ped)
    local loc = vec3(coords.x, coords.y, coords.z)
    return lib.getClosestObject(loc, 1000, false) or 0
end

function SGCore.Game.GetClosestPed(coords)
    coords = coords or GetEntityCoords(cache.ped)
    local loc = vec3(coords.x, coords.y, coords.z)
    return lib.getClosestPed(loc, 1000, false) or 0
end

function SGCore.Game.GetClosestPlayer(coords)
    coords = coords or GetEntityCoords(cache.ped)
    local loc = vec3(coords.x, coords.y, coords.z)
    local id, ped, pos = lib.getClosestPlayer(loc, 1000, false)
    return id or -1, pos and #(pos-loc) or -1
end

function SGCore.Game.GetClosestVehicle(coords)
    coords = coords or GetEntityCoords(cache.ped)
    local loc = vec3(coords.x, coords.y, coords.z)
    return lib.getClosestVehicle(loc, 1000, false) or 0
end

function SGCore.Game.GetObjects()
    return GetGamePool("CObject")
end

function SGCore.Game.GetPedMugshot()
    print("[^3WARNING^7] ESX Function 'Game.GetPedMugshot' is not compatible with SGCore!")
end

function SGCore.Game.GetPeds(onlyOtherPeds)
    local peds = GetGamePool("CPed")
    if onlyOtherPeds then
        for i=1, #peds do
            if peds[i] == cache.ped then
                table.remove(peds, i)
            end
        end
    end
    return peds
end

function SGCore.Game.GetPlayers()
    print("[^3WARNING^7] ESX Function 'Game.GetPlayers' is not compatible with SGCore!")
end

function SGCore.Game.GetPlayersInArea()
    print("[^3WARNING^7] ESX Function 'Game.GetPlayersInArea' is not compatible with SGCore!")
end

function SGCore.Game.GetPlayersInArea()
    print("[^3WARNING^7] ESX Function 'Game.GetPlayersInArea' is not compatible with SGCore!")
end

function SGCore.Game.GetVehicleInDirection()
    print("[^3WARNING^7] ESX Function 'Game.GetVehicleInDirection' is not compatible with SGCore!")
end

function SGCore.Game.GetVehicleProperties(vehicle)
    return lib.getVehicleProperties(vehicle)
end

function SGCore.Game.GetVehicles()
    return GetGamePool("CVehicle")
end

function SGCore.Game.GetVehiclesInArea()
    print("[^3WARNING^7] ESX Function 'Game.GetVehiclesInArea' is not compatible with SGCore!")
end

function SGCore.Game.IsSpawnPointClear()
    print("[^3WARNING^7] ESX Function 'Game.IsSpawnPointClear' is not compatible with SGCore!")
end

function SGCore.Game.IsVehicleEmpty(vehicle)
    for i=-1, 6 do
        if not IsVehicleSeatFree(vehicle, i) then
            return false
        end
    end
    return true
end

function SGCore.Game.SetVehicleProperties(vehicle, props)
    lib.setVehicleProperties(vehicle, props)
end

function SGCore.Game.SpawnLocalObject(model, coords, cb)
    if type(model) == "string" then
        model = GetHashKey(model)
    end
    local entity = CreateObject(model, coords.x, coords.y, coords.z, false, false, false)
    entity = lib.waitFor(function()
        if DoesEntityExist(entity) then return entity end
    end)
    if cb then cb(entity) end
    return entity
end

function SGCore.Game.SpawnLocalVehicle(model, coords, heading, cb)
    if type(model) == "string" then
        model = GetHashKey(model)
    end
    local entity = CreateVehicle(model, coords.x, coords.y, coords.z, heading, false, false, false)
    entity = lib.waitFor(function()
        if DoesEntityExist(entity) then return entity end
    end)
    if cb then cb(entity) end
    return entity
end

function SGCore.Game.SpawnObject(model, coords, cb)
    if type(model) == "string" then
        model = GetHashKey(model)
    end
    local entity = CreateObject(model, coords.x, coords.y, coords.z, true, false, false)
    entity = lib.waitFor(function()
        if DoesEntityExist(entity) then return entity end
    end)
    if cb then cb(entity) end
    return entity
end

function SGCore.Game.SpawnVehicle(model, coords, heading, cb)
    if type(model) == "string" then
        model = GetHashKey(model)
    end
    local entity = CreateVehicle(model, coords.x, coords.y, coords.z, heading, true, false, false)
    entity = lib.waitFor(function()
        if DoesEntityExist(entity) then return entity end
    end)
    if cb then cb(entity) end
    return entity
end

function SGCore.Game.Teleport(entity, coords, cb)
    if DoesEntityExist(entity) then
        RequestCollisionAtCoord(coords.x, coords.y, coords.z)
        while not HasCollisionLoadedAroundEntity(entity) do
            Wait(0)
        end

        SetEntityCoords(entity, coords.x, coords.y, coords.z, false, false, false, false)
        SetEntityHeading(entity, coords.w or coords.heading or 0.0)
    end

    if cb then
        cb()
    end
end

AddEventHandler("SG:characterLoaded", function()
    SGCore.GetPlayerData()
end)

AddEventHandler("SG:updateCharacter", function()
    SGCore.GetPlayerData()
end)

exports('GetESXObject', function() return SGCore end)
SGCore.Math = {Round = function(n,d) local m=10^(d or 0); return math.floor(n*m+0.5)/m end, Trim=function(s) return s:match('^%s*(.-)%s*$') end}
SGCore.Game.GetPlayers = GetActivePlayers
SGCore.Game.GetPlayersInArea = SGCore.getPlayersFromCoords
SGCore.Game.GetVehiclesInArea = function(coords,distance)
    local result={} local c=coords or GetEntityCoords(cache.ped)
    for _,v in ipairs(GetGamePool('CVehicle')) do if #(GetEntityCoords(v)-c)<=(distance or 5) then result[#result+1]=v end end
    return result
end
SGCore.Game.IsSpawnPointClear = function(coords,distance) return #SGCore.Game.GetVehiclesInArea(coords,distance)==0 end
SGCore.ShowHelpNotification=function(message) lib.showTextUI(message);SetTimeout(3000,lib.hideTextUI) end
SGCore.ShowAdvancedNotification=function(sender,subject,msg) SGCore.ShowNotification(msg) end
SGCore.ShowFloatingHelpNotification=SGCore.ShowHelpNotification
SGCore.PlayerLoaded=false
AddEventHandler('esx:playerLoaded',function(data) SGCore.PlayerData=data;SGCore.PlayerLoaded=true end)
AddEventHandler('esx:setJob',function(job) SGCore.PlayerData.job=job end)
AddEventHandler('esx:onPlayerLogout',function() SGCore.PlayerData={};SGCore.PlayerLoaded=false end)
RegisterNetEvent('esx:showNotification',SGCore.ShowNotification)
RegisterNetEvent('esx:showHelpNotification',SGCore.ShowHelpNotification)

AddEventHandler('SG:updateMoney',function(cash,bank)
    SGCore.GetPlayerData()
    TriggerEvent('esx:setAccountMoney',{name='money',money=cash,label='Cash'})
    TriggerEvent('esx:setAccountMoney',{name='bank',money=bank,label='Bank'})
end)
