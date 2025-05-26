resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

description "Admin resource, created for X, by qalle."

client_scripts {
    "client/*"
}

server_scripts {
    "@async/async.lua",
    "@mysql-async/lib/MySQL.lua",
    "server/*"
}

shared_scripts {
    "shared/*",
    "config.lua"
}

ui_page "assets/index.html"

files {
    "assets/*",
    "assets/js/*",
    "assets/css/*"
}