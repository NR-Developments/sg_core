local callbacks={}
local function register(name,cb)
    lib.callback.register(name,cb);callbacks[name]=true
end
register('getcharacters',function(src)
    if exports.sg_core:getPlayer(src) then return {characters={},slots=Config.Slots} end
    SetPlayerRoutingBucket(src,10000+src)
    return GetCharacters(src)
end)
register('sg_multicharacter:choosecharacter',function(src,slot) return Login(src,slot) end)
register('sg_multicharacter:createcharacter',function(src,data)
    if type(data)~='table' then return false end
    return Login(src,data.slot,data.info)
end)
register('sg_multicharacter:deletecharacter',DeleteCharacter)
register('sg_multicharacter:saveappearance',SaveSkin)
-- Last-vehicle preview never trusts arbitrary client network ids for teleportation.
register('setplayertolastvehicle',function() return false end)
RegisterNetEvent('esx_multicharacter:relog',function()
    local src=source;local p=exports.sg_core:getPlayer(src)
    if not Config.Relog or not p or p.metadata.dead then return end
    p.unload();Player(src).state:set('identifier',nil,true)
end)
exports('RegisterComplete',function(src,info)
    -- Identity providers must use the same server-validated registration callback.
    if type(info)~='table' or not info.slot then return false end
    return Login(src,info.slot,info)
end)
GlobalState.PlayerStates=json.decode(GetResourceKvpString('char_status') or '{}')
