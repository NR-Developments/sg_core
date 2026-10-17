local casinoIpl = require "data.ipl"
IsCasinoVIP = false

local function unloadIpl(ipl)
    return IsIplActive(ipl) and RemoveIpl(ipl)
end

local function loadIpl(ipl)
    return not IsIplActive(ipl) and RequestIpl(ipl)
end

AddEventHandler("onResourceStart", function(resourceName)
    if cache.resource ~= resourceName then return end
    for i=1, #casinoIpl do
        loadIpl(casinoIpl[i])
    end
end)

AddEventHandler("onResourceStop", function(resourceName)
    if cache.resource ~= resourceName then return end
    for i=1, #casinoIpl do
        unloadIpl(casinoIpl[i])
    end
end)

RegisterNetEvent("sg_casino:updateMembershipStatus", function(isMember)
    IsCasinoVIP = isMember
end)

exports("isMember", function()
    return IsCasinoVIP
end)

if GetResourceState("sg_appearanceshops") == "started" then
    local clothing = require("data.clothing")
    exports["sg_appearanceshops"]:createClothingStore(clothing)
end
