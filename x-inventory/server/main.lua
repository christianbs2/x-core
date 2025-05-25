X = {}

Heap = {
    Inventories = {},
    SaveInventory = {},
    DroppedItems = {}
}

TriggerEvent("x-core:fetchMain", function(response)
    X = response
end)

MySQL.ready(function()
    local deleteSQL = [[
        DELETE
            FROM
        x_inventories
            WHERE
        items = @items
    ]]

    MySQL.Async.execute(deleteSQL, {
        ["@items"] = "[]"
    }, function(rowsChanged)
        X.Log("Removed", rowsChanged, "empty inventories.")
    end)

    Citizen.Wait(1000)

    local fetchSQL = [[
        SELECT
            name, items
        FROM
            x_inventories
        ORDER BY NAME DESC
    ]]

    MySQL.Async.fetchAll(fetchSQL, {

    }, function(responses)
        if responses and #responses > 0 then
            for _, responseData in ipairs(responses) do
                Heap.Inventories[responseData.name] = json.decode(responseData.items)
            end

            GenerateSerials()

            X.Log("Fetched", #responses, "inventories.")
        end
    end)
end)

RegisterNetEvent("x-inventory:getCash")
AddEventHandler("x-inventory:getCash", function(response)
   
end)

X.CreateCallback("x-inventory:getCash", function(source, callback)
    local character = exports["x-character"]:FetchCharacter(source)

    if not character then return end

    callback(character.cash.balance)
end)

RegisterNetEvent("x-inventory:useItem")
AddEventHandler("x-inventory:useItem", function(response)
    local character = exports["x-character"]:FetchCharacter(source)

    if not character then return end

    local itemData = GetItemData(response.Name)

    if itemData then
        if itemData.UseCallback then
            local hasItem = false

            local inventories = GetInventories(character)

            for _, inventoryData in ipairs(inventories) do
                local found

                for _, cItemData in ipairs(inventoryData.Items) do
                    if cItemData.UUID == response.UUID then
                        hasItem = inventoryData.Inventory; found = true

                        break
                    end
                end

                if found then break end
            end

            if hasItem then
                itemData.UseCallback(character, response, hasItem)
            else
                character.triggerEvent("x-core:notify", "Föremål", "Föremålet finns ej i din ryggsäck.", 5000, "error")
            end
        end
    end
end)

X.CreateCallback("x-inventory:fetchInventories", function(source, callback, extraInventories)
    local character = exports["x-character"]:FetchCharacter(source)

    if not character then return end

    local inventories = {}

    for _, staticInventoryData in ipairs(Config.Inventories) do
        if staticInventoryData.Character then
            local inventory = Heap.Inventories[staticInventoryData.Name .. "_" .. character.characterId]

            table.insert(inventories, {
                Container = staticInventoryData.Container,
                Inventory = staticInventoryData.Name .. "_" .. character.characterId,
                Items = inventory or {}
            })
        else
            local inventory = staticInventoryData.Name == "GROUND" and Heap.DroppedItems or Heap.Inventories[staticInventoryData.Name]

            table.insert(inventories, {
                Container = staticInventoryData.Container,
                Inventory = staticInventoryData.Name,
                Items = inventory or {}
            })
        end
    end

    if extraInventories then
        for _, inventoryData in ipairs(extraInventories) do
            local inventory = Heap.Inventories[inventoryData.action]

            table.insert(inventories, {
                Container = inventoryData.container or "rightContainer",
                Inventory = inventoryData.action,
                Items = inventory or {},

                Label = inventoryData.actionLabel,
                MaxSlots = inventoryData.slots,
                MaxWeight = inventoryData.maxWeight,

                Hidden = inventoryData.Hidden
            })
        end
    end

    callback(inventories)
end)

X.CreateCallback("x-inventory:fetchInventory", function(source, callback, inventoryName)
    local character = exports["x-character"]:FetchCharacter(source)

    if not character then return end

    local inventory = Heap.Inventories[inventoryName] or {}

    callback(inventory)
end)

X.CreateCallback("x-inventory:copyKey", function(source, callback, keyUnit)
    local character = exports["x-character"]:FetchCharacter(source)

    if not character then return callback(false) end

    local inventories = GetInventories(character)
    local inventoryItem

    for _, inventory in ipairs(inventories) do
        for _, itemData in ipairs(inventory.Items) do
            if itemData.Name == "key" then
                if itemData.MetaData and itemData.MetaData.Key == keyUnit then
                    inventoryItem = itemData

                    break
                end
            end
        end
    end

    if not inventoryItem then return callback(false) end

    local validated = false

    if character.cash.balance >= Config.KeyPrice then
        character.cash.remove(Config.KeyPrice)

        validated = true
    elseif character.bank.balance >= Config.KeyPrice then
        character.bank.remove(Config.KeyPrice, {
            type = "removed",
            description = "Nyckelkopiering | " .. keyUnit,
            amount = Config.KeyPrice
        })

        validated = true
    end

    if validated then
        AddInventoryItem(character, {
            Item = {
                Name = "key",
                Count = 1,
                MetaData = inventoryItem.MetaData
            },
            Inventory = "KEYCHAIN_" .. character.characterId
        })
    end

    callback(validated)
end)

RegisterCommand("item", function(source, args)
    local player = exports["x-core"]:FetchUser(source)

    local hasAccess, permissionGroup = player.isAdmin()

    if hasAccess or permissionGroup == 2 then
        local typeHandler = args[1] and string.upper(args[1]) or "NOTHING"

        local playerId = args[2] and tonumber(args[2]) or -1

        local character = exports["x-character"]:FetchCharacter(playerId)

        local itemName = args[3]

        if not itemName then return exports["chat"]:SendChatMessage(source, '<div class="chat-message server"><b>FöREMåL:</b> Du måste skriva ett föremål.</div>', {}) end

        local itemData = GetItemData(itemName)

        if typeHandler == "ADD" then
            if itemData then
                if character then
                    local itemCount = args[4] and tonumber(args[4]) or 1

                    if AddInventoryItem(character, {
                        Item = {
                            Name = itemName,
                            Count = itemCount
                        },
                        Inventory = args[5] or "POCKETS_" .. character.characterId
                    }) then
                        exports["chat"]:SendChatMessage(source, '<div class="chat-message success"><b>FöREMåL:</b> "{0}" | "+{1}" - "{2}".</div>', {
                            character.identification.firstname .. " " .. character.identification.lastname,
                            itemCount,
                            itemData.Label
                        })
                    else
                        exports["chat"]:SendChatMessage(source, '<div class="chat-message server"><b>FöREMåL:</b> "{0}\'s" fickor är fulla.</div>', {
                            character.identification.firstname .. " " .. character.identification.lastname
                        })
                    end

                    -- exports["x-logs"]:Log(("ITEM | %s"):format(player.name), "La till **" .. itemCount .. "x " .. itemData.Label .. "** på på karaktären **" .. character.identification.firstname .. " " .. character.identification.lastname .. "**", "ADMIN_ITEM")
                    exports.JD_logs:createLog({
                        EmbedMessage = ("ITEM | %s"):format(player.name) .. " " .. "La till **" .. itemCount .. "x " .. itemData.Label .. "** på på karaktären **" .. character.identification.firstname .. " " .. character.identification.lastname .. "**",
                        channel = "admin",
                    })
                else
                    exports["chat"]:SendChatMessage(source, '<div class="chat-message server"><b>FöREMåL:</b> ID {0} finns ej i systemet, testa igen.</div>', {
                        playerId
                    })
                end
            else
                exports["chat"]:SendChatMessage(source, '<div class="chat-message server"><b>FöREMåL:</b> "{0}" hittades inte i systemet, försök igen.</div>', {
                    itemName
                })
            end
        elseif typeHandler == "REMOVE" then
            if character then
                local itemCount = args[4] and tonumber(args[4]) or 1

                RemoveInventoryItem(character, {
                    Item = {
                        Name = itemName,
                        Count = itemCount
                    },
                    Inventory = "POCKETS_" .. character.characterId,

                    LowestDurability = true
                })

                exports["chat"]:SendChatMessage(source, '<div class="chat-message system"><b>FöREMåL:</b> "{0}" | "-{1}" - "{2}".</div>', {
                    character.identification.firstname .. " " .. character.identification.lastname,
                    itemCount,
                    itemData.Label
                })
            else
                exports["chat"]:SendChatMessage(source, '<div class="chat-message server"><b>FöREMåL:</b> ID {0} finns ej i systemet, testa igen.</div>', {
                    playerId
                })
            end
        elseif typeHandler == "KEY" then
            if character then
                AddInventoryItem(character, {
                    Item = {
                        Name = "key",
                        Count = 1,
                        MetaData = {
                            Key = itemName,
                            Label = itemName,
                            Description = {
                                {
                                    Title = "Fordonsnyckel",
                                    Text = ""
                                },
                                {
                                    Title = "Fordon:",
                                    Text = "EJ IDENTIFIERAD"
                                },
                                {
                                    Title = "Registreringsplåt:",
                                    Text = itemName
                                }
                            },
                            Logo = "vehicle_key"
                        }
                    },
                    Inventory = "KEYCHAIN_" .. character.characterId
                })

                exports["chat"]:SendChatMessage(source, '<div class="chat-message success"><b>FöREMåL:</b> "{0}" | "+{1}".</div>', {
                    character.identification.firstname .. " " .. character.identification.lastname,
                    itemName
                })
            else
                exports["chat"]:SendChatMessage(source, '<div class="chat-message server"><b>FöREMåL:</b> ID {0} finns ej i systemet, testa igen.</div>', {
                    playerId
                })
            end
        elseif typeHandler == "LICENSE" then
            AddInventoryItem(character, {
                Item = {
                    Name = "id_card",
                    Count = 1,
                    MetaData = {
                        Identification = {
                            Firstname = character.identification.firstname,
                            Lastname = character.identification.lastname,
                            Dateofbirth = character.identification.dateofbirth,
                            Lastdigits = character.identification.lastdigits
                        },
                        Label = character.identification.firstname .. " " .. character.identification.lastname,
                        Description = {
                            {
                                Title = "ID-Handling",
                                Text = ""
                            },
                            {
                                Title = "Namn:",
                                Text = character.identification.firstname .. " " .. character.identification.lastname
                            },
                            {
                                Title = "Personnummer:",
                                Text = character.characterId
                            },
                            {
                                Title = "Kön:",
                                Text = character.appearance.current.sex == 0 and "Man" or "Kvinna"
                            }
                        }
                    }
                },
                Inventory = "POCKETS_" .. character.characterId
            })
        elseif typeHandler == "DRIVING" then
            AddInventoryItem(character, {
                Item = {
                    Name = "driving_license",
                    Count = 1,
                    MetaData = {
                        Identification = {
                            Firstname = character.identification.firstname,
                            Lastname = character.identification.lastname,
                            Dateofbirth = character.identification.dateofbirth,
                            Lastdigits = character.identification.lastdigits
                        },
                        Label = character.identification.firstname .. " " .. character.identification.lastname,
                        Description = {
                            {
                                Title = "Körkort",
                                Text = ""
                            },
                            {
                                Title = "Namn:",
                                Text = character.identification.firstname .. " " .. character.identification.lastname
                            },
                            {
                                Title = "Personnummer:",
                                Text = character.characterId
                            },
                            {
                                Title = "Kön:",
                                Text = character.appearance.current.sex == 0 and "Man" or "Kvinna"
                            }
                        }
                    }
                },
                Inventory = "POCKETS_" .. character.characterId
            })
        else
            exports["chat"]:SendChatMessage(source, '<div class="chat-message server"><b>FöREMåL:</b> Missad parameter, antingen "add" eller "remove".</div>', {})
        end
    else
        exports["chat"]:SendChatMessage(source, '<div class="chat-message server"><b>FöREMåL:</b> Du har ej behörighet att utföra detta.</div>', {})
    end
end)

local dropEvents = {
    comradio = "x-comradio:comradioDropped",
    glasses = "x-clothingshop:accessoryDropped",
    earaccessories = "x-clothingshop:accessoryDropped",
    helmet = "x-clothingshop:accessoryDropped",
    hat = "x-clothingshop:accessoryDropped",
    bag = "x-clothingshop:accessoryDropped",
    mask = "x-clothingshop:accessoryDropped"
}

RegisterServerEvent("x-inventory:addItem")
AddEventHandler("x-inventory:addItem", function(data)
    local character = exports["x-character"]:FetchCharacter(source)

    if not character then return end

    if data.Item.OldCount then data.Item.OldCount = nil end

    AddInventoryItem(character, data)
end)

RegisterServerEvent("x-inventory:moveItem")
AddEventHandler("x-inventory:moveItem", function(data)
    local character = exports["x-character"]:FetchCharacter(source)

    if not character then return end

    if data.Item.OldCount then data.Item.OldCount = nil end

    MoveInventoryItem(character, data)
end)

RegisterServerEvent("x-inventory:editItem")
AddEventHandler("x-inventory:editItem", function(data)
    local character = exports["x-character"]:FetchCharacter(source)

    if not character then return end

    if data.Item.OldCount then data.Item.OldCount = nil end

    EditInventoryItem(character, data)
end)

RegisterServerEvent("x-inventory:deleteItem")
AddEventHandler("x-inventory:deleteItem", function(data)
    local character = exports["x-character"]:FetchCharacter(source)

    if not character then return end

    if data.Item.OldCount then data.Item.OldCount = nil end

    RemoveInventoryItem(character, data)
end)

X.CreateCallback("x-inventory:deleteItem", function(source, callback, itemData)
    local character = exports["x-character"]:FetchCharacter(source)

    if not character then return end

    if itemData.Item.OldCount then itemData.Item.OldCount = nil end

    return callback(RemoveInventoryItem(character, itemData))
end)

RegisterServerEvent("x-inventory:dropItem")
AddEventHandler("x-inventory:dropItem", function(data)
    local character = exports["x-character"]:FetchCharacter(source)

    if not character then return end

    if data.Item.OldCount then data.Item.OldCount = nil end

    data.Item.UUID = Config.UUID()

    table.insert(Heap.DroppedItems, data)

    if dropEvents[data.Item.Name] then
        character.triggerEvent(dropEvents[data.Item.Name], data.Item)
    end

    local itemData = GetItemData(data.Item.Name)

    -- exports["x-logs"]:Log(("DROP | %s (%s) | %s"):format(character.identification.firstname .. " " .. character.identification.lastname, GetPlayerName(character.source), itemData and itemData.Label or data.Item.Name), data.Item.Count .. "x " .. (itemData and itemData.Label or data.Item.Name), "INVENTORY_DROP")
    exports.JD_logs:createLog({
        EmbedMessage = ("DROP |  %s (%s) | %s"):format(character.identification.firstname .. " " .. character.identification.lastname, GetPlayerName(character.source), itemData and itemData.Label or data.Item.Name), data.Item.Count .. "x " .. (itemData and itemData.Label or data.Item.Name),
        channel = "inventory",
    })

    local itemLabel = itemData and itemData.Label or data.Item.Name

    character.triggerEvent("x-core:notify", "Föremål", "Du la ner " .. data.Item.Count .. "x " .. itemLabel .. ".", 5000, "warning")

    TriggerClientEvent("x-inventory:inventoryUpdated", -1, {
        Inventory = "GROUND",
        Items = Heap.DroppedItems
    })
end)

RegisterServerEvent("x-inventory:pickupItem")
AddEventHandler("x-inventory:pickupItem", function(data)
    local character = exports["x-character"]:FetchCharacter(source)

    if not character then return end

    local pickedUp = false

    for itemIndex, itemData in ipairs(Heap.DroppedItems) do
        if itemData.Item.UUID == data.Item.UUID then
            if tonumber(itemData.Item.Count) > tonumber(data.Item.Count) then
                Heap.DroppedItems[itemIndex].Item.Count = data.Item.OldCount or data.Item.Count
            else
                table.remove(Heap.DroppedItems, itemIndex)
            end

            pickedUp = true

            break
        end
    end

    if data.Item.OldCount then data.Item.OldCount = nil end

    local itemData = GetItemData(data.Item.Name)

    local itemLabel = itemData and itemData.Label or data.Item.Name

    if not pickedUp then
        -- exports["x-logs"]:Log(("PICKUP NON EXISTING | %s (%s) | %s"):format(character.identification.firstname .. " " .. character.identification.lastname, GetPlayerName(character.source), itemData and itemData.Label or data.Item.Name), "Försökte dupea " .. data.Item.Count .. "x " .. (itemData and itemData.Label or data.Item.Name), "INVENTORY_PICKUP_BUG")
        exports.JD_logs:createLog({
            EmbedMessage = ("%s (%s) | %s"):format(character.identification.firstname .. " " .. character.identification.lastname, GetPlayerName(character.source), itemData and itemData.Label or data.Item.Name), "Försökte dupea " .. data.Item.Count .. "x " .. (itemData and itemData.Label or data.Item.Name),
            channel = "inventory",
        })

        character.triggerEvent("x-core:notify", "Föremål", "Föremålet du försökte plocka upp, finns egentligen inte.", 5000, "error")

        TriggerClientEvent("x-inventory:inventoryUpdated", -1, {
            Inventory = "GROUND",
            Items = Heap.DroppedItems
        })

        TriggerClientEvent("x-inventory:forceUpdate", character.source)

        return
    end

    -- exports["x-logs"]:Log(("PICKUP | %s (%s) | %s"):format(character.identification.firstname .. " " .. character.identification.lastname, GetPlayerName(character.source), itemData and itemData.Label or data.Item.Name), data.Item.Count .. "x " .. (itemData and itemData.Label or data.Item.Name), "INVENTORY_PICKUP")
    exports.JD_logs:createLog({
        EmbedMessage = ("PICKUP | %s (%s) | %s"):format(character.identification.firstname .. " " .. character.identification.lastname, GetPlayerName(character.source), itemData and itemData.Label or data.Item.Name), data.Item.Count .. "x " .. (itemData and itemData.Label or data.Item.Name),
        channel = "inventory",
    })

    character.triggerEvent("x-core:notify", "Föremål", "Du plockade upp " .. data.Item.Count .. "x " .. itemLabel .. ".", 5000, "success")

    AddInventoryItem(character, {
        Item = data.Item,
        Inventory = data.Inventory
    })

    TriggerClientEvent("x-inventory:inventoryUpdated", -1, {
        Inventory = "GROUND",
        Items = Heap.DroppedItems
    })
end)

RegisterServerEvent("x-inventory:createDroppedItem")
AddEventHandler("x-inventory:createDroppedItem", function(location, itemData, instance)
    itemData.UUID = Config.UUID()

    local data = {
        Item = itemData,
        Location = {
            X = location.x,
            Y = location.y,
            Z = location.z
        },
        Instance = instance and instance or 0
    }

    table.insert(Heap.DroppedItems, data)

    TriggerClientEvent("x-inventory:inventoryUpdated", -1, {
        Inventory = "GROUND",
        Items = Heap.DroppedItems
    })
end)

--RegisterServerEvent("x-inventory:pickupItemContext")
--AddEventHandler("x-inventory:pickupItemContext", function(uuid)
--    local character = exports["x-character"]:FetchCharacter(source)
--
--    if not character then return end
--
--    local removed = false
--
--    for itemIndex, itemData in ipairs(Heap.DroppedItems) do
--        if itemData.Item.UUID == uuid then
--            table.remove(Heap.DroppedItems, itemIndex)
--
--            removed = itemData.Item
--        end
--    end
--
--    if removed then
--        removed.Slot = nil
--
--        local itemLabel = GetItemData(removed.Name) and GetItemData(removed.Name).Label or removed.Name
--
--        character.triggerEvent("x-core:notify", "Föremål", "Du plockade upp " .. removed.Count .. "x " .. itemLabel .. ".", 5000, "success")
--
--        AddInventoryItem(character, {
--            Item = removed
--        })
--    end
--
--    TriggerClientEvent("x-inventory:inventoryUpdated", -1, {
--        Inventory = "GROUND",
--        Items = Heap.DroppedItems
--    })
--end)

RegisterServerEvent("x-inventory:updateGroundItem")
AddEventHandler("x-inventory:updateGroundItem", function(data)
    local character = exports["x-character"]:FetchCharacter(source)

    if not character then return end

    if data.Item.OldCount then data.Item.OldCount = nil end

    for itemIndex, itemData in ipairs(Heap.DroppedItems) do
        if itemData.Item.UUID == data.Item.UUID then
            if tonumber(itemData.Item.Count) ~= tonumber(data.Item.Count) and data.Item.Count > 0 then
                Heap.DroppedItems[itemIndex].Item = data.Item
            else
                table.remove(Heap.DroppedItems, itemIndex)
            end

            break
        end
    end

    TriggerClientEvent("x-inventory:inventoryUpdated", -1, {
        Inventory = "GROUND",
        Items = Heap.DroppedItems
    })
end)

X.CreateCallback("x-inventory:saveCashEnvelope", function(pSource, callback, itemData, inventoryName, amount)
    local character = exports["x-character"]:FetchCharacter(pSource)

    if not character then return callback(false) end

    if character.cash.balance >= amount then
        itemData.MetaData.Cash = amount
        itemData.MetaData.UseButton = "TA UT KONTANTER"

        local edited = exports["x-inventory"]:EditInventoryItem(character, {
            Item = itemData,

            Inventory = inventoryName
        })

        if edited then
            character.cash.remove(amount)
        end

        return callback(edited)
    else
        return callback(false)
    end
end)

Citizen.CreateThread(function()
    while true do
        local sleepThread = 60000

        SaveInventories()

        Citizen.Wait(sleepThread)
    end
end)