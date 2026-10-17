return {
    ["shield"] = {
        label = "Police shield",
        weight = 8000,
        stack = false,
        consume = 0,
        client = {
            export = "sg_police.useShield",
            add = function(total)
                if total > 0 then
                        pcall(function() return exports["sg_police"]:hasShield(true) end)
                    end
                end,
            remove = function(total)
                if total < 1 then
                    pcall(function() return exports["sg_police"]:hasShield(false) end)
                end
            end
        }
    },
    ["spikestrip"] = {
        label = "Spikestrip",
        weight = 500,
        client = {
            export = "sg_police.deploySpikestrip"
        }
    },
    ["cuffs"] = {
        label = "Handcuffs",
        weight = 150,
        client = {
            export = "sg_police.cuff"
        }
    },
    ["zipties"] = {
        label = "Zipties",
        weight = 10,
        client = {
            export = "sg_police.ziptie"
        }
    },
    ["tools"] = {
	label = "Tools",
        description = "Can be used to hotwire vehicles.",
	weight = 800,
	consume = 1,
        stack = true,
        close = true,
		client = {
            export = "sg_core.hotwire",
            event = "sg_police:unziptie"
		}
	},
    ["handcuffkey"] = {
        label = "Handcuff key",
        weight = 10,
        client = {
            export = "sg_police.uncuff"
        }
    },
    ["casing"] = {
        label = "Bullet Casing"
    },
    ["projectile"] = {
        label = "Projectile"
    },
}
