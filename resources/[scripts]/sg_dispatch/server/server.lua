ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("sg_dispatch:sendAlert")
AddEventHandler("sg_dispatch:sendAlert", function(text, coords, id)
    TriggerClientEvent("sg_dispatch:alertToClient", -1, text, coords, id)
end)

RegisterServerEvent("sg_dispatch:sendAmbuAlert")
AddEventHandler("sg_dispatch:sendAmbuAlert", function(text, coords, id)
    TriggerClientEvent("sg_dispatch:auxToClient", -1, text, coords, id)
end)

RegisterServerEvent("sg_dispatch:sendMecaAlert")
AddEventHandler("sg_dispatch:sendMecaAlert", function(text, coords, id)
    TriggerClientEvent("sg_dispatch:mecaToClient", -1, text, coords, id)
end)

RegisterServerEvent("sg_dispatch:sendVehRob")
AddEventHandler("sg_dispatch:sendVehRob", function(coords, model, color, id)
    TriggerClientEvent("sg_dispatch:vehToClient", -1, coords, model, color, id)
end)

RegisterServerEvent("sg_dispatch:sendTaxiaAlert")
AddEventHandler("sg_dispatch:sendTaxiaAlert", function(text, coords, id)
    TriggerClientEvent("sg_dispatch:taxiToClient", -1, text, coords, id)
end)

RegisterServerEvent("sg_dispatch:sendRobaAlert")
AddEventHandler("sg_dispatch:sendRobaAlert", function(type, coords, id)
    TriggerClientEvent("sg_dispatch:robberyToClient", -1, type, coords, id)
end)
