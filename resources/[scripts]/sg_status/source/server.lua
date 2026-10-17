RegisterNetEvent("sg_status:update", function(data)
    local src = source
    local player = SGCore.getPlayer(src)
    if not player then return end
    player.setMetadata("status", data)
end)

RegisterNetEvent("sg_status:setBAC", function(status)
    local src = source
    if GetResourceState("Breathalyzer") ~= "started" then return end

    if status < 0 then
        status = 0
    elseif status > 100 then
        status = 100
    end
        
    local lvl = status*(math.random(6, 10)/2000)
    exports["Breathalyzer"]:setBAC(src, lvl)
end)
