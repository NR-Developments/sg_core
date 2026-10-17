fx_version 'adamant'

game 'gta5'

author 'SG Studios'

description 'dispatch system'

client_scripts {
    'client/*.lua'
}

server_scripts {
    'server/*.lua'
}

shared_scripts {
    'config.lua'
}

ui_page 'ui/index.html'

files {
    'ui/*.html',
    'ui/*.js',
    'ui/vehicles/*.png',
    --'ui/vehicles/*.webp',
    'ui/*.css',
    'ui/*.svg',
    'ui/*.png',
    'ui/*.ttf'
    
}

dependency "sg_core"
