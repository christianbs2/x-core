RegisterNetEvent("x-inventory:inventoryUpdated")
AddEventHandler("x-inventory:inventoryUpdated", function(response)
    local inventoryName = response.Inventory
    local inventoryItems = response.Items

    if string.match(inventoryName, "EVIDENCE_BAG") then
        local persistentUUID = inventoryName:gsub("EVIDENCE_BAG_", "")

        local inventoryItem = GetPersistentInventoryItem(persistentUUID)

        if inventoryItem then
            local newWeight = 0
            local newDescription = #inventoryItems <= 0 and "Tom" or ""

            for itemIndex, item in ipairs(inventoryItems) do
                local itemData = exports["x-inventory"]:GetItemData(item.Name)

                local itemWeight = item.MetaData.Weight or itemData.Weight

                newWeight = newWeight + itemWeight
                newDescription = newDescription .. (itemData.Label .. " (" .. item.Count .. ")") .. (itemIndex < #inventoryItems and ", " or "")
            end

            inventoryItem.MetaData.Weight = newWeight
            inventoryItem.MetaData.Description = {
                {
                    Title = "Innehåll:",
                    Text = ""
                }
            }
            inventoryItem.MetaData.Description[1].Text = newDescription

            EditPersistentInventoryItem(persistentUUID, inventoryItem)
        end
    end
end)