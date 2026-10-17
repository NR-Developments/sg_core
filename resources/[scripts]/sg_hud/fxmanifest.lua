fx_version 'cerulean'
game 'gta5'
lua54 'yes'
name 'sg_hud'
author 'Trew HUD UI contributors; SG Framework integration by SG Studios'
description 'Original Trew HUD UI adapted to native SG Framework'
version '1.0.0'
ui_page 'html/ui.html'
shared_scripts {'@ox_lib/init.lua', 'locales/init.lua', 'locales/br.lua', 'locales/en.lua', 'locales/es.lua', 'config.lua'}
client_scripts {'client/bridge.lua', 'client/client.lua'}
server_scripts {'server/adapters.lua', 'server/server.lua'}
files {'html/**'}
dependencies {'sg_core', 'sg_status', 'pma-voice', 'ox_lib'}
