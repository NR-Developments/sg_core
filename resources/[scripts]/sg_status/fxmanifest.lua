-- For support join my discord: https://discord.gg/Z9Mxu72zZ6

author "Andyyy7666"
description "Status for ND"
version "1.0.0"

fx_version "cerulean"
game "gta5"
lua54 "yes"

files {
    "ui/style.css",
    "ui/script.js",
    "ui/circle.js",
    "ui/index.html",
    "data/**",
    "source/actions.lua",
}
ui_page "ui/index.html"

shared_scripts {
    "@sg_core/init.lua",
    "@ox_lib/init.lua"
}
server_scripts {
    "source/server.lua"
}
client_scripts {
    "config.lua",
    "source/client.lua"
}

dependencies {
    "sg_core",
    "ox_lib"
}

exports {
    "setStats",
    "changeStatus",
    "setMaxStatus",
    "getStatus"
}

dependency "sg_core"
