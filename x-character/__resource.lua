resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

loadscreen_manual_shutdown "yes"

server_scripts {
	"@mysql-async/lib/MySQL.lua",
	"server/main.lua",
	"server/character.lua"
}

client_scripts {
    "client/main.lua",
    "client/functions.lua",
    "client/camera.lua",
    "client/ped/main.lua",
    "client/ped/creation.lua",
    "client/ped/selection.lua"
}

shared_scripts {
	"config.lua"
}

ui_page "assets/index.html"

files {
    "assets/*",
    "assets/css/*"
}

exports {
	"IsLoaded"
}

server_exports {
    "FetchCharacter",
    "FetchCharacterWithCid",
    "FetchCharacterWithIdentifier",
    "FetchCharacters"
}