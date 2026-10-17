local openAccounts
local function openAccount(account)
    local options = {}
    for _, action in ipairs({'deposit', 'withdraw'}) do
        options[#options+1] = {
            title = action == 'deposit' and 'Deposit from personal bank' or 'Withdraw to personal bank',
            onSelect = function()
                local input = lib.inputDialog(account.label, {{type='number', label='Amount', required=true, min=1, max=1000000000, precision=0}})
                if not input then return end
                local success = lib.callback.await('sg_banking:societyAction', false, account.name, action, input[1])
                lib.notify({title='Society banking', description=success and 'Transfer completed' or 'Transfer refused: check ownership and available funds', type=success and 'success' or 'error'})
                openAccounts()
            end
        }
    end
    options[#options+1] = {title='Transaction history', onSelect=function()
        local history = lib.callback.await('sg_banking:societyHistory', false, account.name)
        if not history then return end
        local rows = {}
        for _, entry in ipairs(history) do
            rows[#rows+1] = {title=('$%s | %s'):format(entry.amount, entry.reason), description=('Actor: %s | %s'):format(entry.actor, entry.created_at)}
        end
        if #rows == 0 then rows[1] = {title='No transactions yet', disabled=true} end
        lib.registerContext({id='sg_society_history', title=account.label, menu='sg_society_account', options=rows})
        lib.showContext('sg_society_history')
    end}
    lib.registerContext({id='sg_society_account', title=('%s — $%s'):format(account.label,account.balance), menu='sg_societies', options=options})
    lib.showContext('sg_society_account')
end
openAccounts = function()
    local accounts = lib.callback.await('sg_banking:societies', false) or {}
    if #accounts == 0 then return lib.notify({title='Society banking', description='You do not own a business account', type='error'}) end
    local options = {}
    for _, account in ipairs(accounts) do
        options[#options+1] = {title=account.label, description=('$%s'):format(account.balance), onSelect=function() openAccount(account) end}
    end
    lib.registerContext({id='sg_societies',title='Business accounts',options=options})
    lib.showContext('sg_societies')
end
RegisterCommand('societybank', openAccounts, false)
