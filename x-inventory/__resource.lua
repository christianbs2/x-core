resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

client_scripts {
    "client/*"
}

server_scripts {
    "@async/async.lua",
    "@mysql-async/lib/MySQL.lua",
    "server/*"
}

shared_scripts {
    "config.lua",
    "shared/*"
}

exports {
    "CreatePickup",
    "OpenSpecialInventory",
    "SendInventoryNotification",
    "GetItemInHand",
    "EquipSlot",
    "HasKey",
    "OpenInventory",
    "GetCharacterInventories",
    "GetInventoryData",
    "GetItems",
    "GetItem",
    "GetItemData",
    "AddCustomKey",
    "RemoveCustomKey",
    "GetInventory"
}

server_exports {
    "AddInventoryItem",
    "RemoveInventoryItem",
    "RemovePersistentInventoryItem",
    "MoveInventoryItem",
    "GetInventoryItem",
    "GetPersistentInventoryItem",
    "EditInventoryItem",
    "EditPersistentInventoryItem",
    "HandleAddMoney",
    "HandleRemoveMoney",
    "HandleGetMoney",
    "GetInventory",
    "GetInventories",
    "GetEmptySlot",
    "RegisterUniqueUsableItem",
    "GetItemData"
}

ui_page "index.html"
ui_page_preload "yes"

files {
    "index.html",
    
    "static/*",
    "static/css/*",
    "static/js/*",
    "static/media/*"
}