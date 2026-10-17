local zones = { ['AIRP'] = "Los Santos International Airport", ['ALAMO'] = "Alamo Sea", ['ALTA'] = "Alta", ['ARMYB'] = "Fort Zancudo", ['BANHAMC'] = "Banham Canyon Dr", ['BANNING'] = "Banning", ['BEACH'] = "Vespucci Beach", ['BHAMCA'] = "Banham Canyon", ['BRADP'] = "Braddock Pass", ['BRADT'] = "Braddock Tunnel", ['BURTON'] = "Burton", ['CALAFB'] = "Calafia Bridge", ['CANNY'] = "Raton Canyon", ['CCREAK'] = "Cassidy Creek", ['CHAMH'] = "Chamberlain Hills", ['CHIL'] = "Vinewood Hills", ['CHU'] = "Chumash", ['CMSW'] = "Chiliad Mountain State Wilderness", ['CYPRE'] = "Cypress Flats", ['DAVIS'] = "Davis", ['DELBE'] = "Del Perro Beach", ['DELPE'] = "Del Perro", ['DELSOL'] = "La Puerta", ['DESRT'] = "Grand Senora Desert", ['DOWNT'] = "Downtown", ['DTVINE'] = "Downtown Vinewood", ['EAST_V'] = "East Vinewood", ['EBURO'] = "El Burro Heights", ['ELGORL'] = "El Gordo Lighthouse", ['ELYSIAN'] = "Elysian Island", ['GALFISH'] = "Galilee", ['GOLF'] = "GWC and Golfing Society", ['GRAPES'] = "Grapeseed", ['GREATC'] = "Great Chaparral", ['HARMO'] = "Harmony", ['HAWICK'] = "Hawick", ['HORS'] = "Vinewood Racetrack", ['HUMLAB'] = "Humane Labs and Research", ['JAIL'] = "Bolingbroke Penitentiary", ['KOREAT'] = "Little Seoul", ['LACT'] = "Land Act Reservoir", ['LAGO'] = "Lago Zancudo", ['LDAM'] = "Land Act Dam", ['LEGSQU'] = "Legion Square", ['LMESA'] = "La Mesa", ['LOSPUER'] = "La Puerta", ['MIRR'] = "Mirror Park", ['MORN'] = "Morningwood", ['MOVIE'] = "Richards Majestic", ['MTCHIL'] = "Mount Chiliad", ['MTGORDO'] = "Mount Gordo", ['MTJOSE'] = "Mount Josiah", ['MURRI'] = "Murrieta Heights", ['NCHU'] = "North Chumash", ['NOOSE'] = "N.O.O.S.E", ['OCEANA'] = "Pacific Ocean", ['PALCOV'] = "Paleto Cove", ['PALETO'] = "Paleto Bay", ['PALFOR'] = "Paleto Forest", ['PALHIGH'] = "Palomino Highlands", ['PALMPOW'] = "Palmer-Taylor Power Station", ['PBLUFF'] = "Pacific Bluffs", ['PBOX'] = "Pillbox Hill", ['PROCOB'] = "Procopio Beach", ['RANCHO'] = "Rancho", ['RGLEN'] = "Richman Glen", ['RICHM'] = "Richman", ['ROCKF'] = "Rockford Hills", ['RTRAK'] = "Redwood Lights Track", ['SANAND'] = "San Andreas", ['SANCHIA'] = "San Chianski Mountain Range", ['SANDY'] = "Sandy Shores", ['SKID'] = "Mission Row", ['SLAB'] = "Stab City", ['STAD'] = "Maze Bank Arena", ['STRAW'] = "Strawberry", ['TATAMO'] = "Tataviam Mountains", ['TERMINA'] = "Terminal", ['TEXTI'] = "Textile City", ['TONGVAH'] = "Tongva Hills", ['TONGVAV'] = "Tongva Valley", ['VCANA'] = "Vespucci Canals", ['VESP'] = "Vespucci", ['VINE'] = "Vinewood", ['WINDF'] = "Ron Alternates Wind Farm", ['WVINE'] = "West Vinewood", ['ZANCUDO'] = "Zancudo River", ['ZP_ORT'] = "Port of South Los Santos", ['ZQ_UAR'] = "Davis Quartz" }
local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18, ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182, ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81, ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178, ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173, ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local AllWeapons = json.decode('{"melee":{"dagger":"0x92A27487","bat":"0x958A4A8F","bottle":"0xF9E6AA4B","crowbar":"0x84BD7BFD","unarmed":"0xA2719263","flashlight":"0x8BB05FD7","golfclub":"0x440E4788","hammer":"0x4E875F73","hatchet":"0xF9DCBF2D","knuckle":"0xD8DF3C3C","knife":"0x99B507EA","machete":"0xDD5DF8D9","switchblade":"0xDFE37640","nightstick":"0x678B81B1","wrench":"0x19044EE0","battleaxe":"0xCD274149","poolcue":"0x94117305","stone_hatchet":"0x3813FC08"},"handguns":{"pistol":"0x1B06D571","pistol_mk2":"0xBFE256D4","combatpistol":"0x5EF9FEC4","appistol":"0x22D8FE39","stungun":"0x3656C8C1","pistol50":"0x99AEEB3B","snspistol":"0xBFD21232","snspistol_mk2":"0x88374054","heavypistol":"0xD205520E","vintagepistol":"0x83839C4","flaregun":"0x47757124","marksmanpistol":"0xDC4DB296","revolver":"0xC1B3C3D1","revolver_mk2":"0xCB96392F","doubleaction":"0x97EA20B8","raypistol":"0xAF3696A1"},"smg":{"microsmg":"0x13532244","smg":"0x2BE6766B","smg_mk2":"0x78A97CD0","assaultsmg":"0xEFE7E2DF","combatpdw":"0xA3D4D34","machinepistol":"0xDB1AA450","minismg":"0xBD248B55","raycarbine":"0x476BF155"},"shotguns":{"pumpshotgun":"0x1D073A89","pumpshotgun_mk2":"0x555AF99A","sawnoffshotgun":"0x7846A318","assaultshotgun":"0xE284C527","bullpupshotgun":"0x9D61E50F","musket":"0xA89CB99E","heavyshotgun":"0x3AABBBAA","dbshotgun":"0xEF951FBB","autoshotgun":"0x12E82D3D"},"assault_rifles":{"assaultrifle":"0xBFEFFF6D","assaultrifle_mk2":"0x394F415C","carbinerifle":"0x83BF0278","carbinerifle_mk2":"0xFAD1F1C9","advancedrifle":"0xAF113F99","specialcarbine":"0xC0A3098D","specialcarbine_mk2":"0x969C3D67","bullpuprifle":"0x7F229F94","bullpuprifle_mk2":"0x84D6FAFD","compactrifle":"0x624FE830"},"machine_guns":{"mg":"0x9D07F764","combatmg":"0x7FD62962","combatmg_mk2":"0xDBBD7280","gusenberg":"0x61012683"},"sniper_rifles":{"sniperrifle":"0x5FC3C11","heavysniper":"0xC472FE2","heavysniper_mk2":"0xA914799","marksmanrifle":"0xC734385A","marksmanrifle_mk2":"0x6A6C02E0"},"heavy_weapons":{"rpg":"0xB1CA77B1","grenadelauncher":"0xA284510B","grenadelauncher_smoke":"0x4DD2DC56","minigun":"0x42BF8A85","firework":"0x7F7497E5","railgun":"0x6D544C99","hominglauncher":"0x63AB0442","compactlauncher":"0x781FE4A","rayminigun":"0xB62D1F67"},"throwables":{"grenade":"0x93E220BD","bzgas":"0xA0973D5E","smokegrenade":"0xFDBC8A50","flare":"0x497FACC3","molotov":"0x24B17070","stickybomb":"0x2C3731D9","proxmine":"0xAB564B93","snowball":"0x787F0BB","pipebomb":"0xBA45E8B8","ball":"0x23C9F95C"},"misc":{"petrolcan":"0x34A67B97","fireextinguisher":"0x60EC506","parachute":"0xFBAB5776"}}')
local vehiclesCars = {0,1,2,3,4,5,6,7,8,9,10,11,12,17,18,19,20};

-- Match HUD visibility to the active SG character and pause menu.
Citizen.CreateThread(function()
    local lastVisible
    while true do
        Citizen.Wait(0)
        local visible=SGHUD.visible()
        if visible~=lastVisible then SendNUIMessage({action='toggleUi',value=visible});lastVisible=visible end
        if visible then
            for _,component in ipairs({1,2,3,4,6,7,8,9,13,17,20}) do HideHudComponentThisFrame(component) end
        end
    end
end)

-- Date and time update
Citizen.CreateThread(function()
    while Config.ui.showDate do
        Wait(2000)
        SendNUIMessage({ action = 'setText', id = 'date', value = hudDate() })
    end
end)

-- Location update
Citizen.CreateThread(function()

    while Config.ui.showLocation do
        Citizen.Wait(200)
        local player = PlayerPedId()
        local position = GetEntityCoords(player)
        local zoneNameFull = zones[GetNameOfZone(position.x, position.y, position.z)]
        local streetName = GetStreetNameFromHashKey(GetStreetNameAtCoord(position.x, position.y, position.z))

        local locationMessage = nil

        if zoneNameFull then
            locationMessage = streetName .. ', ' .. zoneNameFull
        else
            locationMessage = streetName
        end

        locationMessage = string.format(
            Locales[Config.Locale]['you_are_on_location'],
            locationMessage
        )

        SendNUIMessage({ action = 'setText', id = 'location', value = locationMessage })
    end
end)


-- Vehicle Info
local vehicleCruiser
local vehicleSignalIndicator = 'off'
local seatbeltEjectSpeed = 45.0
local seatbeltEjectAccel = 100.0
local seatbeltIsOn = false
local currSpeed = 0.0
local prevVelocity = {x = 0.0, y = 0.0, z = 0.0}
local lastVehicle = 0

Citizen.CreateThread(function()
    while true do
        Wait(200)
        local player = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(player, false)
        local position = GetEntityCoords(player)
        if vehicle ~= lastVehicle then
            seatbeltIsOn=false;currSpeed=0;prevVelocity={x=0,y=0,z=0};vehicleSignalIndicator='off';lastVehicle=vehicle
        end
        local vehicleIsOn = vehicle~=0 and GetIsVehicleEngineRunning(vehicle)
        local vehicleInfo
        if IsPedInAnyVehicle(player, false) and vehicleIsOn then
            local vehicleClass = GetVehicleClass(vehicle)

            if not Config.ui.showMinimap then
                DisplayRadar(true)
            end

            -- Vehicle Speed
            local vehicleSpeedSource = GetEntitySpeed(vehicle)
            local vehicleSpeed
            if Config.vehicle.speedUnit == 'MPH' then
                vehicleSpeed = math.ceil(vehicleSpeedSource * 2.237)
            else
                vehicleSpeed = math.ceil(vehicleSpeedSource * 3.6)
            end

            -- Vehicle Gradient Speed
            local vehicleNailSpeed

            if vehicleSpeed > Config.vehicle.maxSpeed then
                vehicleNailSpeed = math.ceil(  280 - math.ceil( math.ceil(Config.vehicle.maxSpeed * 205) / Config.vehicle.maxSpeed) )
            else
                vehicleNailSpeed = math.ceil(  280 - math.ceil( math.ceil(vehicleSpeed * 205) / Config.vehicle.maxSpeed) )
            end

            -- Vehicle Fuel and Gear
            local vehicleFuel
            vehicleFuel = GetVehicleFuelLevel(vehicle)

            local vehicleGear = GetVehicleCurrentGear(vehicle)

            if (vehicleSpeed == 0 and vehicleGear == 0) or (vehicleSpeed == 0 and vehicleGear == 1) then
                vehicleGear = 'N'
            elseif vehicleSpeed > 0 and vehicleGear == 0 then
                vehicleGear = 'R'
            end

            -- Vehicle Lights
            local vehicleVal,vehicleLights,vehicleHighlights  = GetVehicleLightsState(vehicle)
            local vehicleIsLightsOn
            if vehicleLights == 1 and vehicleHighlights == 0 then
                vehicleIsLightsOn = 'normal'
            elseif (vehicleLights == 1 and vehicleHighlights == 1) or (vehicleLights == 0 and vehicleHighlights == 1) then
                vehicleIsLightsOn = 'high'
            else
                vehicleIsLightsOn = 'off'
            end

            -- Vehicle Siren
            local vehicleSiren

            if IsVehicleSirenOn(vehicle) then
                vehicleSiren = true
            else
                vehicleSiren = false
            end

            -- Vehicle Seatbelt
            if has_value(vehiclesCars, vehicleClass) == true and vehicleClass ~= 8 then

                local prevSpeed = currSpeed
                currSpeed = vehicleSpeedSource

                SetPedConfigFlag(PlayerPedId(), 32, not seatbeltIsOn)

                if not seatbeltIsOn then
                    local vehIsMovingFwd = GetEntitySpeedVector(vehicle, true).y > 1.0
                    local vehAcc = (prevSpeed - currSpeed) / 0.2
                    if (vehIsMovingFwd and (prevSpeed > (seatbeltEjectSpeed/2.237)) and (vehAcc > (seatbeltEjectAccel*9.81))) then

                        SetEntityCoords(player, position.x, position.y, position.z - 0.47, true, true, true)
                        SetEntityVelocity(player, prevVelocity.x, prevVelocity.y, prevVelocity.z)
                        SetPedToRagdoll(player, 1000, 1000, 0, 0, 0, 0)
                    else
                        -- Update previous velocity for ejecting player
                        prevVelocity = GetEntityVelocity(vehicle)
                    end

                else

                    DisableControlAction(0, 75, true)

                end
            end

            vehicleInfo = {
                action = 'updateVehicle',
                status = true,
                speed = vehicleSpeed,
                nail = vehicleNailSpeed,
                gear = vehicleGear,
                fuel = vehicleFuel,
                lights = vehicleIsLightsOn,
                signals = vehicleSignalIndicator,
                cruiser = vehicleCruiser,
                type = vehicleClass,
                siren = vehicleSiren,
                seatbelt = {},

                config = {
                    speedUnit = Config.vehicle.speedUnit,
                    maxSpeed = Config.vehicle.maxSpeed
                }
            }

            vehicleInfo['seatbelt']['status'] = seatbeltIsOn
        else
            vehicleCruiser = false
            vehicleNailSpeed = 0
            vehicleSignalIndicator = 'off'

            seatbeltIsOn = false

            vehicleInfo = {
                action = 'updateVehicle',

                status = false,
                nail = vehicleNailSpeed,
                seatbelt = { status = seatbeltIsOn },
                cruiser = vehicleCruiser,
                signals = vehicleSignalIndicator,
                type = 0,
            }

            if Config.ui.showMinimap == false then
                DisplayRadar(false)
            end

        end

        SendNUIMessage(vehicleInfo)
    end
end)




-- Player, account and status data is supplied by client/bridge.lua.

-- Voice detection and distance
Citizen.CreateThread(function()

    if Config.ui.showVoice then

        RequestAnimDict('facials@gen_male@variations@normal')
        RequestAnimDict('mp_facial')

        while true do
            Citizen.Wait(300)
            local playerID = PlayerId()

            for _,player in ipairs(GetActivePlayers()) do
                local boolTalking = NetworkIsPlayerTalking(player)

                if player ~= playerID then
                    if boolTalking then
                        PlayFacialAnim(GetPlayerPed(player), 'mic_chatter', 'mp_facial')
                    elseif not boolTalking then
                        PlayFacialAnim(GetPlayerPed(player), 'mood_normal_1', 'facials@gen_male@variations@normal')
                    end
                end
            end
        end

    end
end)



Citizen.CreateThread(function()
    if not Config.ui.showVoice then return end
    local talking, distance
    while true do
        Citizen.Wait(100)
        local nextTalking=NetworkIsPlayerTalking(PlayerId())
        local nextDistance=SGHUD.voiceDistance()
        if talking~=nextTalking then talking=nextTalking;SendNUIMessage({action='isTalking',value=talking}) end
        if distance~=nextDistance then distance=nextDistance;SendNUIMessage({action='setVoiceDistance',value=distance}) end
    end
end)

-- Weapons
Citizen.CreateThread(function()
    if Config.ui.showWeapons then
        while true do
            Citizen.Wait(100)

            local player = GetPlayerPed(-1)
            local status = {}

            if IsPedArmed(player, 7) then
                local weapon = GetSelectedPedWeapon(player)
                local ammoTotal = GetAmmoInPedWeapon(player,weapon)
                local bool,ammoClip = GetAmmoInClip(player,weapon)
                ammoClip = ammoClip or 0
                local ammoRemaining = math.max(0,math.floor(ammoTotal - ammoClip))

                status['armed'] = true
                status['weapon'] = 'unknown'

                for key,value in pairs(AllWeapons) do

                    for keyTwo,valueTwo in pairs(AllWeapons[key]) do
                        if weapon == GetHashKey('weapon_'..keyTwo) then
                            status['weapon'] = keyTwo


                            if key == 'melee' then
                                SendNUIMessage({ action = 'element', task = 'disable', value = 'weapon_bullets' })
                                SendNUIMessage({ action = 'element', task = 'disable', value = 'bullets' })
                            else
                                if keyTwo == 'stungun' then
                                    SendNUIMessage({ action = 'element', task = 'disable', value = 'weapon_bullets' })
                                    SendNUIMessage({ action = 'element', task = 'disable', value = 'bullets' })
                                else
                                    SendNUIMessage({ action = 'element', task = 'enable', value = 'weapon_bullets' })
                                    SendNUIMessage({ action = 'element', task = 'enable', value = 'bullets' })
                                end
                            end

                        end
                    end

                end

                SendNUIMessage({ action = 'setText', id = 'weapon_clip', value = ammoClip })
                SendNUIMessage({ action = 'setText', id = 'weapon_ammo', value = ammoRemaining })

            else
                status['armed'] = false
            end

            SendNUIMessage({ action = 'updateWeapon', status = status })

        end
    end
end)
-- Existing keys and driving behavior, using PMA for voice range.
local cruiseVehicle=nil
local function releaseCruise()
    if cruiseVehicle and DoesEntityExist(cruiseVehicle) then
        SetEntityMaxSpeed(cruiseVehicle,GetVehicleHandlingFloat(cruiseVehicle,'CHandlingData','fInitialDriveMaxFlatVel'))
    end
    cruiseVehicle=nil;vehicleCruiser='off'
end
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local player=PlayerPedId()
        local vehicle=GetVehiclePedIsIn(player,false)
        local class=vehicle~=0 and GetVehicleClass(vehicle) or -1
        local car=has_value(vehiclesCars,class)
        if cruiseVehicle and (cruiseVehicle~=vehicle or GetPedInVehicleSeat(vehicle,-1)~=player) then releaseCruise() end
        if SGHUD.player and Config.ui.showVoice and IsControlJustPressed(1,Keys[Config.voice.keys.distance] or 243) then ExecuteCommand('cycleproximity') end
        if vehicle~=0 and car then
            if class~=8 and GetIsVehicleEngineRunning(vehicle) then
                if IsControlJustReleased(0,Keys[Config.vehicle.keys.seatbelt]) then seatbeltIsOn=not seatbeltIsOn end
                if seatbeltIsOn then DisableControlAction(0,75,true);DisableControlAction(27,75,true) end
            end
            if GetPedInVehicleSeat(vehicle,-1)==player then
                if IsControlJustPressed(1,Keys[Config.vehicle.keys.cruiser]) then
                    if cruiseVehicle then releaseCruise() else cruiseVehicle=vehicle;vehicleCruiser='on';SetEntityMaxSpeed(vehicle,GetEntitySpeed(vehicle)) end
                end
                for _,signal in ipairs({{'signalLeft','left'},{'signalRight','right'},{'signalBoth','both'}}) do
                    if IsControlJustPressed(1,Keys[Config.vehicle.keys[signal[1]]]) then
                        vehicleSignalIndicator=vehicleSignalIndicator==signal[2] and 'off' or signal[2]
                        TriggerEvent('sg_hud:setCarSignalLights',vehicleSignalIndicator)
                    end
                end
            end
        end
    end
end)
AddEventHandler('onResourceStop',function(name)
    if name~=GetCurrentResourceName() then return end
    releaseCruise();SetPedConfigFlag(PlayerPedId(),32,true);DisplayRadar(true)
end)
AddEventHandler('SG:characterUnloaded',function() releaseCruise();seatbeltIsOn=false;DisplayRadar(false) end)

AddEventHandler('sg_hud:setCarSignalLights', function(status)
    local driver = GetVehiclePedIsIn(PlayerPedId(), false)
    if driver==0 or GetPedInVehicleSeat(driver,-1)~=PlayerPedId() then return end
    local hasTrailer,vehicleTrailer = GetVehicleTrailerVehicle(driver,vehicleTrailer)
    local leftLight
    local rightLight

    if status == 'left' then
        leftLight = false
        rightLight = true
        if hasTrailer then driver = vehicleTrailer end

    elseif status == 'right' then
        leftLight = true
        rightLight = false
        if hasTrailer then driver = vehicleTrailer end

    elseif status == 'both' then
        leftLight = true
        rightLight = true
        if hasTrailer then driver = vehicleTrailer end

    else
        leftLight = false
        rightLight = false
        if hasTrailer then driver = vehicleTrailer end

    end

    TriggerServerEvent('sg_hud:syncCarLights', status)
    SetVehicleIndicatorLights(driver, 0, leftLight)
    SetVehicleIndicatorLights(driver, 1, rightLight)
end)



RegisterNetEvent('sg_hud:syncCarLights')
AddEventHandler('sg_hud:syncCarLights', function(driver, status)
    local player=GetPlayerFromServerId(driver)
    if player~=-1 and player~=PlayerId() then
        local driver=GetVehiclePedIsIn(GetPlayerPed(player),false)
        if driver==0 then return end
        local leftLight,rightLight

        if status == 'left' then
            leftLight = false
            rightLight = true

        elseif status == 'right' then
            leftLight = true
            rightLight = false

        elseif status == 'both' then
            leftLight = true
            rightLight = true

        else
            leftLight = false
            rightLight = false
        end

        SetVehicleIndicatorLights(driver, 0, leftLight)
        SetVehicleIndicatorLights(driver, 1, rightLight)

    end
end)

function hudDate()
    local timeString = nil
    local day = _U('day_' .. GetClockDayOfMonth())
    local weekDay = _U('weekDay_' .. GetClockDayOfWeek())
    local month = _U('month_' .. GetClockMonth())
    local day = _U('day_' .. GetClockDayOfMonth())
    local year = GetClockYear()
    local hour = GetClockHours()
    local minutes = GetClockMinutes()
    local time = nil
    local AmPm = ''


    if Config.date.AmPm then
        if hour >= 13 and hour <= 24 then
            hour = hour - 12
            AmPm = 'PM'
        else
            if hour == 0 or hour == 24 then
                hour = 12
            end
            AmPm = 'AM'
        end

    end

    if hour <= 9 then
        hour = '0' .. hour
    end
    if minutes <= 9 then
        minutes = '0' .. minutes
    end

    time = hour .. ':' .. minutes .. ' ' .. AmPm




    local date_format = Locales[Config.Locale]['date_format'][Config.date.format]

    if Config.date.format == 'default' then
        timeString = string.format(
            date_format,
            day, month, year
        )
    elseif Config.date.format == 'simple' then
        timeString = string.format(
            date_format,
            day, month
        )

    elseif Config.date.format == 'simpleWithHours' then
        timeString = string.format(
            date_format,
            time, day, month
        )
    elseif Config.date.format == 'withWeekday' then
        timeString = string.format(
            date_format,
            weekDay, day, month, year
        )
    elseif Config.date.format == 'withHours' then
        timeString = string.format(
            date_format,
            time, day, month, year
        )
    elseif Config.date.format == 'withWeekdayAndHours' then
        timeString = string.format(
            date_format,
            time, weekDay, day, month, year
        )
    end




    return timeString
end

function has_value(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

local toggleui = false
RegisterCommand('toggleui', function()
    SGHUD.infoHidden=not toggleui
    if not toggleui then
        SendNUIMessage({ action = 'element', task = 'disable', value = 'job' })
        SendNUIMessage({ action = 'element', task = 'disable', value = 'society' })
        SendNUIMessage({ action = 'element', task = 'disable', value = 'bank' })
        SendNUIMessage({ action = 'element', task = 'disable', value = 'blackMoney' })
        SendNUIMessage({ action = 'element', task = 'disable', value = 'wallet' })
    else
        if (Config.ui.showJob == true) then
            SendNUIMessage({ action = 'element', task = 'enable', value = 'job' })
        end
        if (Config.ui.showSocietyMoney == true and SGHUD.extra.hasSociety) then
            SendNUIMessage({ action = 'element', task = 'enable', value = 'society' })
        end
        if (Config.ui.showBankMoney == true) then
            SendNUIMessage({ action = 'element', task = 'enable', value = 'bank' })
        end
        if (Config.ui.showBlackMoney == true) then
            SendNUIMessage({ action = 'element', task = 'enable', value = 'blackMoney' })
        end
        if (Config.ui.showWalletMoney == true) then
            SendNUIMessage({ action = 'element', task = 'enable', value = 'wallet' })
        end
    end

    toggleui = not toggleui
end)

exports('createStatus', function(args)
    local statusCreation = { action = 'createStatus', status = args['status'], color = args['color'], icon = args['icon'] }
    SendNUIMessage(statusCreation)
end)

exports('setStatus', function(args)
    local playerStatus = { action = 'setStatus', status = {
        { name = args['name'], value = args['value'] }
    }}
    SendNUIMessage(playerStatus)
end)
