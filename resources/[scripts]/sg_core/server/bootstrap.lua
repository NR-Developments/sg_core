-- Loaded after native exports are registered, so a warm oxmysql cannot race function definitions.
MySQL.ready(function()
    SGCore.loadSQL({"database/characters.sql", "database/vehicles.sql"}, GetCurrentResourceName())
    SGCore.databaseReady = true
    GlobalState.sgDatabaseReady = true
end)

CreateThread(function()
    while true do
        Wait(60000)
        if SGCore.databaseReady then
            for src, player in pairs(SGCore.players) do
                if SGCore.players[src] == player then
                    local ok, err = pcall(player.save)
                    if not ok then lib.print.error(("Character %s save failed: %s"):format(player.id,err)) end
                end
            end
        end
    end
end)
