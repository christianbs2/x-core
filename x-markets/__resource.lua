resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

description "Market resource created by Zeaqy made for X"

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "server/*"
}

client_scripts {
    "client/*"
}

shared_scripts {
    "config.lua"
}

exports {
    "OpenShelfMenu",
    "GetPolice"
}