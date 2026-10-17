local bridgeResources = {
    {"sg_core", "nd"},
    {"es_extended", "esx"},
    {"qb-core", "qb"}
}

local function getBridge()
    for _, entry in ipairs(bridgeResources) do
        local resource, framework = entry[1], entry[2]
        if GetResourceState(resource):find("start") then
            return ("bridge.%s.%s"):format(framework, lib.context)
        end
    end
    return ("bridge.standalone.%s"):format(lib.context)
end

Bridge = require(getBridge())
