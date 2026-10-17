-- Ownership belongs to a character, never to a client-supplied job/rank.
local ready, busy = false, {}
local function validName(name)
    return type(name) == 'string' and #name > 0 and #name <= 64 and name:match('^[%w_-]+$') ~= nil
end
local function validAmount(amount)
    return type(amount) == 'number' and amount == amount and amount > 0 and amount <= 1000000000 and amount % 1 == 0
end
local function owns(src, name)
    local player = SGCore.getPlayer(src)
    return ready and player and validName(name) and MySQL.scalar.await(
        'SELECT 1 FROM sg_banking_society_owners WHERE society = ? AND character_id = ?', {name, player.id}) ~= nil
end
local function accounts(src)
    local player = SGCore.getPlayer(src)
    if not ready or not player then return {} end
    return MySQL.query.await([[SELECT s.name, s.label, s.balance FROM sg_banking_societies s
        JOIN sg_banking_society_owners o ON o.society = s.name WHERE o.character_id = ? ORDER BY s.name]], {player.id}) or {}
end
local function change(name, delta, actor, reason)
    if not ready or not validName(name) or not validAmount(math.abs(delta)) then return false end
    return MySQL.startTransaction(function(query)
        local result = query([[UPDATE sg_banking_societies SET balance = balance + ?
            WHERE name = ? AND balance + ? BETWEEN 0 AND 9000000000000000]], {delta, name, delta})
        if not result or result.affectedRows ~= 1 then return false end
        query('INSERT INTO sg_banking_society_history (society, actor, amount, reason) VALUES (?, ?, ?, ?)',
            {name, tostring(actor):sub(1,100), delta, tostring(reason or 'Business transaction'):sub(1,255)})
        return true
    end) == true
end
CreateThread(function()
    SGCore.loadSQL('database/societies.sql')
    ready = true
end)
lib.callback.register('sg_banking:societies', accounts)
lib.callback.register('sg_banking:societyHistory', function(src, name)
    if not owns(src, name) then return nil end
    return MySQL.query.await('SELECT actor, amount, reason, created_at FROM sg_banking_society_history WHERE society = ? ORDER BY id DESC LIMIT 50', {name})
end)
lib.callback.register('sg_banking:societyAction', function(src, name, action, amount)
    if not validAmount(amount) or (action ~= 'deposit' and action ~= 'withdraw') then return false end
    if busy[src] then return false end
    busy[src] = true -- acquire before the ownership query yields
    local player, debited
    local ok, result = pcall(function()
        if not owns(src, name) then return false end
        player = SGCore.getPlayer(src)
        if not player then return false end
        if action == 'deposit' then
            if not player.deductMoney('bank', amount, 'Society deposit: '..name) then return false end
            debited = true
        end
        local success = change(name, action == 'deposit' and amount or -amount, player.id, action)
        if not success then
            if debited then player.addMoney('bank', amount, 'Society deposit refunded') end
            debited = false
            return false
        end
        debited = false
        if action == 'withdraw' then player.addMoney('bank', amount, 'Society withdrawal: '..name) end
        player.save('bank')
        return true
    end)
    if not ok then
        if debited then player.addMoney('bank', amount, 'Society deposit refunded') end
        print(('[sg_banking] Society transfer failed for character %s: %s'):format(player and player.id or 'unknown', result))
    end
    busy[src] = nil
    return ok and result == true
end)
-- Server-only integration exports; financial writes require an explicit resource allowlist.
local function trusted()
    return (config.societyResources or {})[GetInvokingResource()] == true
end
exports('getOwnedSocieties', accounts)
exports('isSocietyOwner', owns)
exports('getSocietyBalance', function(src, name)
    if not owns(src, name) then return nil end
    return MySQL.scalar.await('SELECT balance FROM sg_banking_societies WHERE name = ?', {name})
end)
exports('addSocietyMoney', function(name, amount, reason)
    if not trusted() or not validAmount(amount) then return false end
    return change(name, amount, GetInvokingResource(), reason)
end)
exports('removeSocietyMoney', function(name, amount, reason)
    if not trusted() or not validAmount(amount) then return false end
    return change(name, -amount, GetInvokingResource(), reason)
end)
-- Console only: societyowner add/remove <business> <character ID> [label]
RegisterCommand('societyowner', function(src, args)
    if src ~= 0 or not ready then return end
    local action, name, id = args[1], args[2], tonumber(args[3])
    if not validName(name) or not id or id < 1 or id % 1 ~= 0 or (action ~= 'add' and action ~= 'remove') then
        return print('Usage: societyowner add/remove <business> <character ID> [label]')
    end
    if action == 'remove' then
        MySQL.update.await('DELETE FROM sg_banking_society_owners WHERE society = ? AND character_id = ?', {name,id})
    else
        if not MySQL.scalar.await('SELECT 1 FROM nd_characters WHERE charid = ?', {id}) then return print('Character does not exist') end
        local label = table.concat(args, ' ', 4); if label == '' then label = name end
        MySQL.query.await('INSERT IGNORE INTO sg_banking_societies (name,label) VALUES (?,?)', {name,label:sub(1,100)})
        MySQL.query.await('INSERT IGNORE INTO sg_banking_society_owners (society,character_id) VALUES (?,?)', {name,id})
    end
    print(('Society ownership %s: %s / character %s'):format(action,name,id))
end, true)
