if not lib.table.contains(Config.compatibility,'qb') then return end
local QB={Functions={},Shared={Jobs={},Gangs={},Items={},Vehicles={},Weapons={}},PlayerData={}}
local F=QB.Functions
RegisterNetEvent('QBCore:Player:SetPlayerData',function(data) QB.PlayerData=data or {};LocalPlayer.state:set('isLoggedIn',next(QB.PlayerData)~=nil,false) end)
RegisterNetEvent('QBCore:Client:OnPlayerUnload',function() QB.PlayerData={};LocalPlayer.state:set('isLoggedIn',false,false) end)
F.GetPlayerData=function(cb) if cb then cb(QB.PlayerData) end return QB.PlayerData end
F.Notify=function(text,kind,length) lib.notify({description=type(text)=='table' and text.text or text,type=(kind=='primary' or kind=='info') and 'inform' or kind,duration=length}) end
RegisterNetEvent('QBCore:Notify',F.Notify)
F.TriggerCallback=function(name,cb,...) lib.callback(name,false,cb,...) end
F.GetCoords=function(entity) local c=GetEntityCoords(entity);return vector4(c.x,c.y,c.z,GetEntityHeading(entity)) end
F.GetPlate=function(vehicle) return GetVehicleNumberPlateText(vehicle):match('^%s*(.-)%s*$') end
F.GetVehicleProperties=lib.getVehicleProperties;F.SetVehicleProperties=lib.setVehicleProperties
F.GetVehicles=function() return GetGamePool('CVehicle') end
F.GetPlayers=function() return GetActivePlayers() end
F.GetClosestVehicle=function(coords) local p=coords or GetEntityCoords(PlayerPedId());local v,c=lib.getClosestVehicle(p,1000,false);return v or 0,c and #(p-c) or -1 end
F.GetClosestPlayer=function(coords) local p=coords or GetEntityCoords(PlayerPedId());local id,ped,c=lib.getClosestPlayer(p,1000,false);return id or -1,c and #(p-c) or -1 end
F.GetPlayersFromCoords=SGCore.getPlayersFromCoords
F.HasItem=function(item,amount) return (exports.ox_inventory:Search('count',item) or 0)>=(amount or 1) end
F.SpawnVehicle=function(model,cb,coords,networked)
    model=type(model)=='number' and model or joaat(model)
    lib.requestModel(model);coords=coords or F.GetCoords(PlayerPedId())
    local v=CreateVehicle(model,coords.x,coords.y,coords.z,coords.w or 0,networked~=false,false)
    SetModelAsNoLongerNeeded(model);if cb then cb(v) end return v
end
F.DeleteVehicle=DeleteEntity
F.Progressbar=function(name,label,duration,useWhileDead,canCancel,disable,anim,prop,propTwo,onFinish,onCancel)
    local ok=lib.progressBar({label=label,duration=duration,useWhileDead=useWhileDead,canCancel=canCancel,
        disable={move=disable and disable.disableMovement,car=disable and disable.disableCarMovement,combat=disable and disable.disableCombat},
        anim=anim and {dict=anim.animDict,clip=anim.anim,flag=anim.flags},prop=prop})
    if ok and onFinish then onFinish() elseif not ok and onCancel then onCancel() end
end
exports('GetQBObject',function() return QB end)
