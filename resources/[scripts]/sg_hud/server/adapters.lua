-- Read-only balance adapters. Never trust a client-supplied job or balance.
HUDAccounts = {}

function HUDAccounts.blackMoney(player)
    if GetResourceState('ox_inventory') ~= 'started' then return 0 end
    local item = Config.BlackMoneyItem
    if not item or not exports.ox_inventory:Items(item) then return 0 end
    return exports.ox_inventory:Search(player.source, 'count', item) or 0
end

function HUDAccounts.society(player)
    -- SG Banking currently has personal accounts, not a society ledger.
    -- Replace this function with your society banking resource's read export.
    -- It is called only for a server-verified boss. nil keeps the unavailable balance hidden.
    return nil
end
