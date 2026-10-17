local sg_core = exports["sg_core"]

SGCore = setmetatable({}, {
    __index = function(self, index)
        self[index] = function(...)
            return sg_core[index](nil, ...)
        end

        return self[index]
    end
})

-- Support both manifest imports and require("@sg_core.init").
return SGCore
