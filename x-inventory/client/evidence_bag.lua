RegisterNetEvent("x-inventory:openEvidenceBag")
AddEventHandler("x-inventory:openEvidenceBag", function(itemData)
    OpenSpecialInventory({
        action = "EVIDENCE_BAG_" .. itemData.MetaData.PersistentUUID,
        actionLabel = "Bevispåse",
        slots = 12,
        maxWeight = 8.0,
        container = "rightContainer"
    })
end)