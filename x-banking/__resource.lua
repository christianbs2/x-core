resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

server_scripts {
    "@async/async.lua",
	"@mysql-async/lib/MySQL.lua",
	"server/*"
}

client_scripts {
    "client/*"
}

shared_scripts {
	"config.lua",
    "shared/*"
}

ui_page "assets/index.html"

files {
    "assets/*",
    "assets/css/*",
    "assets/js/*"
}

exports {
    "OpenContextMenu"
}