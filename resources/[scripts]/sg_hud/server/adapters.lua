-- Read-only balance adapters. Never trust a client-supplied job or balance.
HUDAccounts = {}

function HUDAccounts.blackMoney(player)
    if GetResourceState('ox_inventory') ~= 'started' then return 0 end
    local item = Config.BlackMoneyItem
    if not item or not exports.ox_inventory:Items(item) then return 0 end
    return exports.ox_inventory:Search(player.source, 'count', item) or 0
end

function HUDAccounts.society(player)
    if GetResourceState('sg_banking') ~= 'started' then return nil end
    local accounts = exports.sg_banking:getOwnedSocieties(player.source)
    -- Prefer the owner's current business; otherwise show their first owned account.
    for _, account in ipairs(accounts) do
        if account.name == player.job then return account.balance end
    end
    return accounts[1] and accounts[1].balance or nil
end
