resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

description "Invoice resource created by Magnus made for X"

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

server_exports {
    "RemoveInvoice",
    "GetInvoicesFromCache",
    "RemoveInvoiceFromCache"
}

exports {
    "GetJobMenu",
    "GetJobVehicleMenu",
    "OpenInvoiceContext",
    "OpenDeleteInvoice",
    "OpenForcedInvoice"
}

ui_page "assets/index.html"

files {
    "assets/*",
    "assets/css/*"
}