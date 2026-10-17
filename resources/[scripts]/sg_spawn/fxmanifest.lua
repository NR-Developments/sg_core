fx_version 'cerulean'
lua54 'yes'
game 'gta5' 
ui_page {
    'web/index.html',
}
client_scripts {
	'config.lua',
	'client/main.lua'
}

files {
	'web/index.html',
	'web/script.js',
	'web/style.css',
	'web/images/*.png',
}

dependency "sg_core"
