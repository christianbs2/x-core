GetItemData = function(itemName)
    return Items[itemName]
end

GetInventoryData = function(inventoryName)
    for _, staticInventoryData in ipairs(Config.Inventories) do
        if string.match(inventoryName, staticInventoryData.Name) then
            return staticInventoryData
        end
    end

    return false
end