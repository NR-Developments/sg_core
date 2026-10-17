ESX = nil

RegisterServerEvent('sg_hygiene:syncshower')
AddEventHandler('sg_hygiene:syncshower', function(zone)
    local Source = source
    TriggerClientEvent('sg_hygiene:syncshower', -1, zone, GetEntityCoords(GetPlayerPed(Source)), Source)
end)

RegisterServerEvent('sg_hygiene:poosync')
AddEventHandler('sg_hygiene:poosync', function(sex)
    local Source = source
    TriggerClientEvent('sg_hygiene:poosync', -1, GetEntityCoords(GetPlayerPed(Source)), Source, sex)
end)

RegisterServerEvent('sg_hygiene:peesync')
AddEventHandler('sg_hygiene:peesync', function()
    local Source = source
    TriggerClientEvent('sg_hygiene:peesync', -1, GetEntityCoords(GetPlayerPed(Source)), Source, sex)
end)

RegisterServerEvent('sg_hygiene:odoreffectsync')
AddEventHandler('sg_hygiene:odoreffectsync', function()
    local Source = source
    TriggerClientEvent('sg_hygiene:odoreffect', -1, GetEntityCoords(GetPlayerPed(Source)), Source)
end)

RegisterServerEvent('sg_hygiene:flush')
AddEventHandler('sg_hygiene:flush', function(coord, id, sex)
    local Source = source
    TriggerClientEvent('sg_hygiene:flush', -1, GetEntityCoords(GetPlayerPed(Source)), Source)
end)

Citizen.CreateThread(function ()
    Wait(1000)
    if config.framework == 'ESX' then
        TriggerEvent('esx:getSharedObject', function(obj)ESX = obj end)
        Wait(500)
        for k,v in pairs(config.items) do
            results = SQLQuery(config.Mysql,'fetchAll',"SELECT * FROM items WHERE name = @name", {
                ['@name'] = k
            })
            if results[1] == nil then
                local weight = 'limit'
                if config.weight_type == 'weight' then
                    SQLQuery(config.Mysql,'execute',"INSERT INTO items (name, label, weight) VALUES (@name, @label, @weight)", {
                        ['@name'] = v.name,
                        ['@label'] = ""..v.name.."",
                        ['@weight'] = 1
                    })
                else
                    SQLQuery(config.Mysql,'execute',"INSERT INTO items (name, label) VALUES (@name, @label)", {
                        ['@name'] = v.name,
                        ['@label'] = ""..v.name.."",
                    })
                end
            end
            ESX.RegisterUsableItem(k, function(source)
                local _source = source
                local xPlayer = ESX.GetPlayerFromId(_source)
                xPlayer.removeInventoryItem(k, 1)
                TriggerClientEvent('sg_hygiene:addhygiene', _source,k)
                TriggerClientEvent('renzu_notify:Notify',_source, 'success','Hygiene', 'You have used a '..v.name..' anti odor')
            end)
        end
    end
end)

function SQLQuery(plugin,type,query,var)
    if type == 'fetchAll' and plugin == 'mysql-async' then
		local q = nil
		MySQL.Async.fetchAll(query, var, function(result)
            q = result
        end)
		while q == nil do Wait(0) end
		return q
    end
    if type == 'execute' and plugin == 'mysql-async' then
        MySQL.Sync.execute(query,var) 
    end
    if type == 'execute' and plugin == 'ghmattisql' then
        exports['ghmattimysql']:execute(query, var)
    end
    if type == 'fetchAll' and plugin == 'ghmattisql' then
        local data = nil
        exports.ghmattimysql:execute(query, var, function(result)
            data = result
        end)
        while data == nil do Wait(0) end
        return data
    end
end