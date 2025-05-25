StoleFromCharacter = function(owner, fromInventory, toInventory)
    local isCharacterInventory, correctCid = IsCharacterInventory(toInventory, owner.characterId)

    if isCharacterInventory and correctCid then
        local characters = exports["x-character"]:FetchCharacters()

        for _, character in pairs(characters) do
            local isInv, isCorrect = IsCharacterInventory(fromInventory, character.characterId)

            if isInv and isCorrect and character.characterId ~= owner.characterId then
                return character
            end
        end
    end
end

IsCharacterInventory = function(inventoryName, cid)
    for _, inv in ipairs(Config.Inventories) do
        if inv.Character and string.find(inventoryName, inv.Name) then
            return true, ((inv.Name .. "_" .. cid) == inventoryName)
        end
    end

    return false
end

AddInventoryItem = function(character, data)
    if data.Inventory == "GROUND" then return end

    if not data.Inventory then data.Inventory = "POCKETS_" .. character.characterId end

    local inventory = Heap.Inventories[data.Inventory]

    if not inventory then Heap.Inventories[data.Inventory] = {}; inventory = Heap.Inventories[data.Inventory] end

    local itemData = GetItemData(data.Item.Name)

    if not itemData then
        X.Log("Tried adding non-existing item:", data.Item.Name)

        data.Item.MetaData.Description = "Bugged item: " .. data.Item.Name
        data.Item.Name = "bread"

        itemData = GetItemData(data.Item.Name)
    end

    local inventoryData = GetInventoryData(data.Inventory)
    local inventoryWeight = GetInventoryWeight(data.Inventory)

    local isStackable = itemData and itemData.Stackable

    local itemLimit = Config.LimitItems[data.Item.Name]

    local itemAdded = false

    local metaData = data.Item.MetaData or itemData and itemData.DefaultMetaData or {}

    if not metaData.PersistentUUID then
        metaData.PersistentUUID = Config.UUID()
    end

    if Config.Serials[data.Item.Name] then
        data.Item.MetaData = metaData
        data.Item = GenerateSerial(data.Item)
    end

    for _ = 1, isStackable and 1 or data.Item.Count do
        local freeSlot = GenerateFreeSlot(character, data)

        local itemBuild = {
            Name = data.Item.Name,
            Count = isStackable and data.Item.Count or 1,
            Slot = data.Item.Slot or freeSlot or math.random(10),
            UUID = Config.UUID(),
            MetaData = metaData
        }

        local itemsInInventory = 0

        if itemLimit and itemLimit > 0 then
            for _, inventoryData in ipairs(Config.Inventories) do
                if inventoryData.Character then
                    local inventoryItems = GetInventory(character, inventoryData.Name)

                    if inventoryItems and #inventoryItems > 0 then
                        for _, itemData in ipairs(inventoryItems) do
                            if itemData.Name == data.Item.Name then
                                itemsInInventory = itemsInInventory + 1
                            end
                        end
                    end
                end
            end
        end

        if freeSlot and (inventoryWeight + (itemData.Weight * data.Item.Count)) < (inventoryData and inventoryData.MaxWeight or 1000) and itemsInInventory < (itemLimit or 1000) then
            if itemData.Stackable and not data.Item.Slot then
                local hasItem = GetInventoryItem(character, {
                    Item = {
                        Name = itemBuild.Name
                    }
                })

                if hasItem then
                    hasItem.Count = hasItem.Count + itemBuild.Count

                    EditInventoryItem(character, {
                        Item = hasItem
                    })

                    --print(json.encode(hasItem), "\n", json.encode(itemBuild), "\n", json.encode(itemData), "\n", "added on the item instead")
                else
                    table.insert(inventory, itemBuild)
                end
            else
                table.insert(inventory, itemBuild)
            end

            --X.Log("Added item:", json.encode(itemBuild), "to inventory:", data.Inventory)

            itemAdded = itemBuild
        else
            local pedPosition = GetEntityCoords(GetPlayerPed(character.source))

            table.insert(Heap.DroppedItems, {
                Item = itemBuild,
                Location = {
                    X = pedPosition.x,
                    Y = pedPosition.y,
                    Z = pedPosition.z
                },
                Instance = 0
            })

            TriggerClientEvent("x-inventory:inventoryUpdated", -1, {
                Inventory = "GROUND",
                Items = Heap.DroppedItems
            })

            --X.Log("Dropped item because of full inventory:", json.encode(itemBuild))
        end

        Citizen.Wait(0)
    end

    TriggerClientEvent("x-inventory:inventoryUpdated", inventoryData and character.source or -1, {
        Inventory = data.Inventory,
        Items = inventory
    })

    if string.match(data.Inventory, "UPDATE") then
        TriggerClientEvent("x-inventory:updateInventoryLive", -1, {
            Inventory = data.Inventory,
            Items = inventory
        })
    end

    TriggerEvent("x-inventory:inventoryUpdated", {
        Inventory = data.Inventory,
        Items = inventory
    })

    Heap.SaveInventory[data.Inventory] = true

    return itemAdded
end

RemoveInventoryItem = function(character, data)
    if data.Inventory == "GROUND" then return end

    if not data.Inventory then data.Inventory = "POCKETS_" .. character.characterId end

    local inventory = Heap.Inventories[data.Inventory]

    if not inventory then Heap.Inventories[data.Inventory] = {}; inventory = Heap.Inventories[data.Inventory] end

    table.sort(inventory, function(itemA, itemB)
        return itemA.Slot < itemB.Slot
    end)

    local staticItemData = GetItemData(data.Item.Name)
    local inventoryData = GetInventoryData(data.Inventory)

    local itemRemoved = false

    if data.LowestDurability and not data.Item.UUID and staticItemData.DefaultMetaData and staticItemData.DefaultMetaData.Durability then
        local itemData, itemDurability = GetLowestDurabilityItem(inventory, data.Item)

        data.Item = itemData
    end

    for itemIndex, itemData in ipairs(inventory) do
        if not data.Item.UUID and data.Item.Name == itemData.Name or itemData.UUID == data.Item.UUID then
            if tonumber(itemData.Count) > tonumber(data.Item.Count) then
                itemData.Count = tonumber(itemData.Count - data.Item.Count)
            else
                table.remove(inventory, itemIndex)
            end

            itemRemoved = true

            --X.Log("Removed item in inventory:", data.Inventory, "with data:", json.encode(data.Item))

            break
        end
    end

    TriggerClientEvent("x-inventory:inventoryUpdated", inventoryData and character.source or -1, {
        Inventory = data.Inventory,
        Items = inventory
    })

    if string.match(data.Inventory, "UPDATE") then
        TriggerClientEvent("x-inventory:updateInventoryLive", -1, {
            Inventory = data.Inventory,
            Items = inventory
        })
    end

    TriggerEvent("x-inventory:inventoryUpdated", {
        Inventory = data.Inventory,
        Items = inventory
    })

    Heap.SaveInventory[data.Inventory] = true

    return itemRemoved
end

RemovePersistentInventoryItem = function(persistentUUID)
    for inventoryName, inventoryItems in pairs(Heap.Inventories) do
        for itemIndex, itemData in ipairs(inventoryItems) do
            if itemData.MetaData and itemData.MetaData.PersistentUUID == persistentUUID then
                table.remove(Heap.Inventories[inventoryName], itemIndex)

                Heap.SaveInventory[inventoryName] = true

                TriggerClientEvent("x-inventory:inventoryUpdated", -1, {
                    Inventory = inventoryName,
                    Items = Heap.Inventories[inventoryName]
                })

                return true
            end
        end
    end

    for itemIndex, itemData in ipairs(Heap.DroppedItems) do
        if itemData.Item.MetaData and itemData.Item.MetaData.PersistentUUID == persistentUUID then
            table.remove(Heap.DroppedItems, itemIndex)

            TriggerClientEvent("x-inventory:inventoryUpdated", -1, {
                Inventory = "GROUND",
                Items = Heap.DroppedItems
            })

            return true
        end
    end

    return false
end

GetPersistentInventoryItem = function(persistentUUID)
    for inventoryName, inventoryItems in pairs(Heap.Inventories) do
        for itemIndex, itemData in ipairs(inventoryItems) do
            if itemData.MetaData and itemData.MetaData.PersistentUUID == persistentUUID then
                return itemData
            end
        end
    end

    for itemIndex, itemData in ipairs(Heap.DroppedItems) do
        if itemData.Item.MetaData and itemData.Item.MetaData.PersistentUUID == persistentUUID then
            return itemData.Item
        end
    end

    return false
end

EditPersistentInventoryItem = function(persistentUUID, newData)
    for inventoryName, inventoryItems in pairs(Heap.Inventories) do
        for itemIndex, itemData in ipairs(inventoryItems) do
            if itemData.MetaData and itemData.MetaData.PersistentUUID == persistentUUID then
                Heap.Inventories[inventoryName][itemIndex] = newData

                Heap.SaveInventory[inventoryName] = true

                TriggerClientEvent("x-inventory:inventoryUpdated", -1, {
                    Inventory = inventoryName,
                    Items = Heap.Inventories[inventoryName]
                })

                return true
            end
        end
    end

    for itemIndex, itemData in ipairs(Heap.DroppedItems) do
        if itemData.Item.MetaData and itemData.Item.MetaData.PersistentUUID == persistentUUID then
            Heap.DroppedItems[itemIndex].Item = newData

            TriggerClientEvent("x-inventory:inventoryUpdated", -1, {
                Inventory = "GROUND",
                Items = Heap.DroppedItems
            })

            return true
        end
    end

    return false
end

MoveInventoryItem = function(character, data)
    if data.To == "GROUND" then return end

    local fromInventory = Heap.Inventories[data.From]

    if not fromInventory then Heap.Inventories[data.From] = {}; fromInventory = Heap.Inventories[data.From] end

    local toInventory = Heap.Inventories[data.To]

    if not toInventory then Heap.Inventories[data.To] = {}; toInventory = Heap.Inventories[data.To] end

    local firstInventoryData = GetInventoryData(data.From)
    local secondInventoryData = GetInventoryData(data.To)

    local removed = false

    for itemIndex, itemData in ipairs(fromInventory) do
        if itemData.UUID == data.Item.UUID then
            table.remove(fromInventory, itemIndex)

            removed = true

            break
        end
    end

    if removed or data.From == "GROUND" then
        table.insert(toInventory, {
            Name = data.Item.Name,
            Count = data.Item.Count,
            Slot = data.Item.Slot,
            UUID = data.Item.UUID,
            MetaData = data.Item.MetaData
        })
    end

    TriggerClientEvent("x-inventory:inventoryUpdated", firstInventoryData and character.source or -1, {
        Inventory = data.From,
        Items = data.From == "GROUND" and Heap.DroppedItems or fromInventory
    })
    TriggerClientEvent("x-inventory:inventoryUpdated", secondInventoryData and character.source or -1, {
        Inventory = data.To,
        Items = toInventory
    })

    if character then
        local stoleFrom = StoleFromCharacter(character, data.From, data.To)

        if stoleFrom then
            TriggerClientEvent("x-core:notify", stoleFrom.source, "Föremål", "Någon stal ett föremål från dig.", 2000, "error")

            local isWeapon = exports["x-weaponsync"]:IsItemWeapon(data.Item.Name)

            TriggerEvent("chat:fakeMe", (isWeapon and "Stal " .. (data.Item.Label or data.Item.Name) or "Stal ett mindre föremål"), character.source)
        end
    end

    if data.From ~= data.To and data.From ~= "GROUND" and data.To ~= "GROUND" then
        local itemData = GetItemData(data.Item.Name)

        -- exports["x-logs"]:Log(("FLYTTADE | %s (%s)"):format(character.identification.firstname .. " " .. character.identification.lastname, GetPlayerName(character.source)), "Flyttade " .. data.Item.Count .. "x " .. (itemData and itemData.Label or data.Item.Name) .. " från " .. data.From .. " till " .. data.To, "INVENTORY_MOVED")
        exports.JD_logs:createLog({
            EmbedMessage = ("%s (%s)"):format(character.identification.firstname .. " " .. character.identification.lastname, GetPlayerName(character.source)) .. " Flyttade " .. data.Item.Count .. "x " .. (itemData and itemData.Label or data.Item.Name) .. " från " .. data.From .. " till " .. data.To,
            channel = "inventory",
        })
    end

    if string.match(data.From, "UPDATE") then
        TriggerClientEvent("x-inventory:updateInventoryLive", -1, {
            Inventory = data.From,
            Items = fromInventory
        })
    elseif string.match(data.To, "UPDATE") then
        TriggerClientEvent("x-inventory:updateInventoryLive", -1, {
            Inventory = data.To,
            Items = toInventory
        })
    end

    TriggerEvent("x-inventory:inventoryUpdated", {
        Inventory = data.From,
        Items = fromInventory
    })
    TriggerEvent("x-inventory:inventoryUpdated", {
        Inventory = data.To,
        Items = toInventory
    })

    Heap.SaveInventory[data.From] = true
    Heap.SaveInventory[data.To] = true

    return true
end

EditInventoryItem = function(character, data)
    if data.Inventory == "GROUND" then return end

    if not data.Inventory then data.Inventory = "POCKETS_" .. character.characterId end

    local inventory = Heap.Inventories[data.Inventory]

    if not inventory then Heap.Inventories[data.Inventory] = {}; inventory = Heap.Inventories[data.Inventory] end

    if data.Item.Count <= 0 then return RemoveInventoryItem(character, data) end

    local itemEdited = false

    for itemIndex, itemData in ipairs(inventory) do
        if itemData.UUID == data.Item.UUID then
            inventory[itemIndex] = data.Item

            --X.Log("Edited item on inventory:", data.Inventory, "with data:", json.encode(data.Item))

            itemEdited = true

            break
        end
    end

    TriggerClientEvent("x-inventory:inventoryUpdated", character.source, {
        Inventory = data.Inventory,
        Items = inventory
    })

    TriggerEvent("x-inventory:inventoryUpdated", {
        Inventory = data.Inventory,
        Items = inventory
    })

    Heap.SaveInventory[data.Inventory] = true

    return itemEdited
end

GetInventoryItem = function(character, data)
    if not data.Inventory then data.Inventory = "POCKETS_" .. character.characterId end

    local inventory = Heap.Inventories[data.Inventory]

    if not inventory then return false end

    for _, itemData in ipairs(inventory) do
        if data.Item.UUID and data.Item.UUID == itemData.UUID or data.Item.Name == itemData.Name then
            return itemData
        end
    end
end

GetLowestDurabilityItem = function(inventoryItems, checkItemData)
    local lastItem
    local lastDurability = 101

    for _, itemData in ipairs(inventoryItems) do
        if itemData.Name == checkItemData.Name then
            if itemData.MetaData.Durability and itemData.MetaData.Durability < lastDurability then
                lastItem = itemData
                lastDurability = itemData.MetaData.Durability
            end
        end
    end

    return lastItem, lastDurability
end

GetInventories = function(character)
    local inventories = {}

    for inventoryName, inventoryItems in pairs(Heap.Inventories) do
        for _, staticInventoryData in ipairs(Config.Inventories) do
            if inventoryName == staticInventoryData.Name .. "_" .. character.characterId then
                table.insert(inventories, {
                    Inventory = inventoryName,
                    Items = inventoryItems
                })
            end
        end
    end

    return inventories
end

GetInventory = function(character, inventoryName)
    return Heap.Inventories[inventoryName .. "_" .. character.characterId]
end

GetInventoryWeight = function(inventory)
    local inventory = Heap.Inventories[inventory]

    if not inventory then return 0 end

    local weight = 0

    for _, itemData in ipairs(inventory) do
        local staticItemData = GetItemData(itemData.Name)

        if staticItemData and staticItemData.Weight then
            weight = weight + (staticItemData.Weight * itemData.Count)
        end
    end

    return weight
end

GenerateFreeSlot = function(character, data)
    local inventory = Heap.Inventories[data.Inventory]

    if not inventory then inventory = {} end

    local occupiedSlots = {}

    for _, itemData in ipairs(inventory) do
        if itemData.Slot then
            occupiedSlots[itemData.Slot + 1] = true
        end
    end

    local maxSlots

    for _, staticInventoryData in ipairs(Config.Inventories) do
        if data.Inventory == staticInventoryData.Name .. "_" .. character.characterId then
            maxSlots = staticInventoryData.MaxSlots

            break
        end
    end

    if not maxSlots then maxSlots = 500 end

    for i = 1, maxSlots do
        if not occupiedSlots[i] then
            return i - 1
        end
    end

    return false
end

GenerateSerials = function()
    for inventoryName, inventoryItems in pairs(Heap.Inventories) do
        for itemIndex, itemData in ipairs(inventoryItems) do
            if exports["x-weaponsync"]:IsItemWeapon(itemData.Name) and Config.Serials[itemData.Name] then
                -- Check if serial number exists
                if not itemData.MetaData.Serial or itemData.MetaData.Serial == "" then
                    itemData = GenerateSerial(itemData)
                    Heap.Inventories[inventoryName][itemIndex] = itemData -- Ensure inventory is updated
                    Heap.SaveInventory[inventoryName] = true
                    --print("Generated serial number for item: " .. itemData.Name .. " Serial: " .. itemData.MetaData.Serial)
                else
                    --print("Item already has a serial number: " .. itemData.MetaData.Serial)
                end
                Citizen.Wait(5)
            end
        end
    end
end

GenerateSerial = function(itemData)
    -- Check if the item already has a serial number before generating a new one
    if itemData.MetaData.Serial and itemData.MetaData.Serial ~= "" then
        --print("Item already has a serial number: " .. itemData.MetaData.Serial)
        return itemData
    end

    local weaponSerial = exports["x-weaponsync"]:GenerateRandomWeaponSerial()
    --print("Generating new serial number: " .. weaponSerial)

    itemData.MetaData.Serial = weaponSerial
    itemData.MetaData.Description = {
        {
            Title = "Serienummer:",
            Text = weaponSerial
        }
    }

    return itemData
end

DropItem = function(itemData)
    TriggerEvent("x-inventory:dropItem", itemData)
end

DoesInventoryNeedsToBeSaved = function(inventoryName)
    return Heap.SaveInventory[inventoryName]
end

SaveInventories = function()
    local inventories = Heap.Inventories

    local sqlQueries = {}

    for inventoryName, inventoryItems in pairs(inventories) do
        if DoesInventoryNeedsToBeSaved(inventoryName) then
            table.insert(sqlQueries, function(callback)
                local sqlQuery = [[
                    INSERT
                        INTO
                    x_inventories
                        (name, items)
                    VALUES
                        (@name, @items)
                    ON DUPLICATE KEY UPDATE
                        items = @items
                ]]

                MySQL.Async.execute(sqlQuery, {
                    ["@name"] = inventoryName,
                    ["@items"] = json.encode(inventoryItems)
                }, function(rowsChanged)
                    Heap.SaveInventory[inventoryName] = false

                    callback(rowsChanged > 0)
                end)
            end)
        end
    end

    Async.parallel(sqlQueries, function(responses)
        X.Log("Saved a total of", #responses, "inventories that needed to be saved.")
    end)
end