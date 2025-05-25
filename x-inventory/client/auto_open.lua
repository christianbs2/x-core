exports("AddAutoOpen", function(inventoryData)
    if IsAlreadyInAutoOpen(inventoryData) then return end

    table.insert(Heap.AutoOpens, inventoryData)
end)

exports("RemoveAutoOpen", function(inventoryData)
    for autoOpenIndex, autoOpen in ipairs(Heap.AutoOpens) do
        if autoOpen.action == inventoryData.action then
            table.remove(Heap.AutoOpens, autoOpenIndex)

            break
        end
    end
end)

IsAlreadyInAutoOpen = function(inventoryData)
    for _, autoOpen in ipairs(Heap.AutoOpens) do
        if autoOpen.action == inventoryData.action then
            return true
        end
    end

    return false
end