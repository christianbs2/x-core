local equippedKeys = {
    [1] = 157,
    [2] = 158,
    [3] = 160,
    [4] = 164,
	[5] = 165
}

Citizen.CreateThread(function()
    Citizen.Wait(100)

    while true do
        Citizen.Wait(5)

        if not Heap.InventoryOpened then
            for itemSlot, keyValue in pairs(equippedKeys) do
                DisableControlAction(0, keyValue, true)
                ShowWeaponWheel(false)

                if UpdateOnscreenKeyboard() ~= 0 and IsDisabledControlJustReleased(0, keyValue) then
                    EquipSlot(itemSlot - 1)
                end
            end
        end
    end
end)

EquipSlot = function(itemSlot)
    local userInventories = GetCharacterInventories()

    local itemUsed = false

    for _, inventoryData in ipairs(userInventories) do
        if inventoryData.Inventory == "POCKETS_" .. X.Character.Data.characterId then
            for _, itemData in ipairs(inventoryData.Items) do
                if itemData.Slot == itemSlot then
                    itemUsed = itemData

                    break
                end
            end
        end
    end

    if itemUsed then
        if IsWeaponValid(GetHashKey("weapon_" .. itemUsed.Name)) then
            if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey("weapon_" .. itemUsed.Name) then
                Heap.Holding = false

                exports["x-weaponsync"]:UseWeapon(itemUsed, false)
            else
                Heap.Holding = itemUsed
                
                exports["x-weaponsync"]:UseWeapon(itemUsed, true)

                --FingerprintHandler(itemUsed)
            end
        else
            local itemData = GetItemData(itemUsed.Name)

            if itemData and itemData.PropAnimation then
                if Heap.Holding and Heap.Holding.Name == itemUsed.Name then
                    exports["dpemotes"]:EmoteCancel()

                    Heap.Holding = false
                else
                    exports["dpemotes"]:PropEmote(itemData.PropAnimation, PlayerPedId(), true)

                    Heap.Holding = itemUsed
                end
            else
                TriggerEvent("x-inventory:useItem", itemUsed)
            end
        end
    else
        Heap.Holding = false

        exports["dpemotes"]:EmoteCancel()

        SetCurrentPedWeapon(PlayerPedId(), GetHashKey("weapon_unarmed"), true)
    end
end

GetItemInHand = function()
    return Heap.Holding
end