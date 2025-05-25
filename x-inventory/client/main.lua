X = false

Heap = {
    SpecialInventories = {},
    Keys = {},
    CustomKeys = {},
    CustomMenus = {},

    AutoOpens = {}
}

Citizen.CreateThread(function()
    while not X do
        X = exports["x-core"]:FetchMain()

        Citizen.Wait(0)
	end

    if exports["x-character"]:IsLoaded() then
        UpdateInventory(true)

        Locksmith()
    end

	while true do
        local sleepThread = 500

        if not Heap.InventoryOpened then
            sleepThread = 5

            DisableControlAction(0, 211)

            if IsDisabledControlJustReleased(0, 211) then
                if exports["x-character"]:IsLoaded() then
                    OpenInventoryHandler()
                end
            end

            HudWeaponWheelIgnoreSelection()
            HudForceWeaponWheel()
        end

        Citizen.Wait(sleepThread)
    end
end)

RegisterNetEvent("x-inventory:inventoryUpdated")
AddEventHandler("x-inventory:inventoryUpdated", function(data)
    UpdateSpecificInventory(data.Inventory, data.Items)
end)

RegisterNetEvent("x-character:characterLoaded")
AddEventHandler("x-character:characterLoaded", function(data)
    X.Character.Data = data

    UpdateInventory(true)

    Locksmith()
end)

RegisterNetEvent("x-inventory:forceUpdate")
AddEventHandler("x-inventory:forceUpdate", function()
    UpdateInventory(true)
end)

RegisterNetEvent("x-inventory:dropItem")
AddEventHandler("x-inventory:dropItem", function(data)
    local target = data["target"]
    local droppedElement = data["element"]

    local createNew = data["createNew"]

    local fromInventory = droppedElement.action
    local toInventory = target.action

    if fromInventory == "GROUND" then
        if toInventory == "GROUND" then return UpdateInventory() end

        local fakeItem = json.decode(json.encode(droppedElement.item))

        if createNew then
            fakeItem.OldCount = createNew - fakeItem.Count
        end

        if not IsEntityPlayingAnim(PlayerPedId(), "pickup_object", "pickup_low", 3) then
            PlayAnimation(PlayerPedId(), "pickup_object", "pickup_low", { speed = 8.0, speedMultiplier = 8.0, duration = -1, flag = 16 })
        end

        fakeItem.Slot = target.slot

        TriggerServerEvent("x-inventory:pickupItem", {
            Item = fakeItem,
            Inventory = toInventory
        })
    end

    if toInventory == "GROUND" then
        if fromInventory == "GROUND" then return UpdateInventory() end

        X.Callback("x-inventory:deleteItem", function(deleted)
            if deleted then
                droppedElement.item.Slot = target.slot

                local pedLocation = GetEntityCoords(PlayerPedId())
                local pedLocForward = GetEntityForwardVector(PlayerPedId())
                local offsetPedLoc = pedLocation + pedLocForward

                if not IsEntityPlayingAnim(PlayerPedId(), "pickup_object", "putdown_low", 3) then
                    PlayAnimation(PlayerPedId(), "pickup_object", "putdown_low", { speed = 8.0, speedMultiplier = 8.0, duration = 1250, flag = 48 })
                end

                TriggerServerEvent("x-inventory:dropItem", {
                    Item = droppedElement.item,
                    Location = {
                        X = offsetPedLoc.x,
                        Y = offsetPedLoc.y,
                        Z = offsetPedLoc.z
                    },
                    Instance = DecorGetInt(PlayerPedId(), "CURRENT_INSTANCE")
                })
            else
                X.Notify("Föremål", "Du har ju inte ens detta föremål? (dupeförsök)", 5000, "error")

                UpdateInventory()
            end
        end, {
            Inventory = droppedElement.action,
            Item = droppedElement.item
        })
    else
        if fromInventory == "GROUND" then return end

        if createNew then
            local oldCount = math.floor(droppedElement.item.Count)

            droppedElement.item.Count = math.floor(createNew - droppedElement.item.Count)

            TriggerServerEvent("x-inventory:editItem", {
                Inventory = fromInventory,
                Item = droppedElement.item
            })

            droppedElement.item.Count = oldCount
            droppedElement.item.Slot = target.slot

            TriggerServerEvent("x-inventory:addItem", {
                Inventory = toInventory,
                Item = droppedElement.item
            })
        else
            droppedElement.item.Slot = target.slot

            TriggerServerEvent("x-inventory:moveItem", {
                From = fromInventory,
                To = toInventory,
                Item = droppedElement.item
            })
        end
    end
end)

RegisterNetEvent("x-inventory:combineItems")
AddEventHandler("x-inventory:combineItems", function(data)
    local initiator = data.initiator
    local initiatorElement = initiator.element
    local target = data.target
    local targetElement = target.element

    local newCount = initiatorElement.item.Count + targetElement.item.Count

    if initiatorElement.action == "GROUND" then
        if targetElement.action == "GROUND" then return UpdateInventory() end

        local oldInitCount = initiatorElement.item.OldCount or initiatorElement.item.Count
        local newInitCount = oldInitCount - initiatorElement.item.Count

        initiatorElement.item.Count = math.floor(newInitCount)

        TriggerServerEvent("x-inventory:updateGroundItem", {
            Item = initiatorElement.item
        })
    elseif targetElement.action == "GROUND" then
        if initiatorElement.action == "GROUND" then return UpdateInventory() end

        local oldInitElementCount = initiatorElement.item.Count

        targetElement.item.Count = math.floor(targetElement.item.Count + oldInitElementCount)

        TriggerServerEvent("x-inventory:updateGroundItem", {
            Item = targetElement.item
        })
    end

    if initiatorElement.item.OldCount and math.floor(tonumber(initiatorElement.item.OldCount)) < math.floor(tonumber(initiatorElement.item.Count)) then
        local oldInitElementCount = initiatorElement.item.Count
        local oldInitCount = initiatorElement.item.OldCount
        local newInitCount = oldInitCount - initiatorElement.item.Count

        initiatorElement.item.Count = math.floor(newInitCount)

        TriggerServerEvent("x-inventory:editItem", {
            Inventory = initiatorElement.action,
            Item = initiatorElement.item
        })

        targetElement.item.Count = math.floor(targetElement.item.Count + oldInitElementCount)

        TriggerServerEvent("x-inventory:editItem", {
            Inventory = targetElement.action,
            Item = targetElement.item
        })
    else
        TriggerServerEvent("x-inventory:deleteItem", {
            Inventory = initiatorElement.action,
            Item = initiatorElement.item
        })

        targetElement.item.Count = newCount

        TriggerServerEvent("x-inventory:editItem", {
            Inventory = targetElement.action,
            Item = targetElement.item
        })
    end
end)

RegisterNetEvent("x-inventory:useItem")
AddEventHandler("x-inventory:useItem", function(response)
    TriggerServerEvent("x-inventory:useItem", response)
end)

RegisterNetEvent("x-inventory:closeInventory")
AddEventHandler("x-inventory:closeInventory", function()
    SetNuiFocusKeepInput(false)
    SetNuiFocus(false, false)

    Heap.SpecialInventories = {}
    Heap.InventoryOpened = false
end)

RegisterNetEvent("x-instance:enteredInstance")
AddEventHandler("x-instance:enteredInstance", function(instanceId)
    ToggleObjects(instanceId, false)
end)

RegisterNetEvent("x-instance:exitedInstance")
AddEventHandler("x-instance:exitedInstance", function(instanceId)
    ToggleObjects(instanceId, true)
end)

Citizen.CreateThread(function()
    Citizen.Wait(100)

    while true do
        local sleepThread = 500

        if Heap.SpawnedObjects and #Heap.SpawnedObjects > 0 then
            local pedCoords = GetEntityCoords(PlayerPedId())

            for _, spawnedObject in ipairs(Heap.SpawnedObjects) do
                local dstCheck = #(pedCoords - spawnedObject.Location)

                if dstCheck <= 8.0 and (DoesEntityExist(spawnedObject.Handle) and IsEntityVisible(spawnedObject.Handle) or not DoesEntityExist(spawnedObject.Handle)) then
                    sleepThread = 5

                    DrawScriptMarker({
                        type = 20,
                        rotate = true,
                        pos = spawnedObject.Location + vector3(0.0, 0.0, 0.3),
                        color = vector3(0, 255, 0),
                        size = vector3(0.05, 0.05, 0.05),
                        bob = true
                    })

                    Draw3DText(spawnedObject.Location, spawnedObject.Label)
                else
                    if Heap.CustomMenus[spawnedObject.Handle] then
                        Heap.CustomMenus[spawnedObject.Handle] = nil
                    end
                end
            end
        end

        Citizen.Wait(sleepThread)
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(100)

    while true do
        local sleepThread = 500

        if Heap.InventoryOpened then
            sleepThread = 1

            DisableControlAction(0, 1)
            DisableControlAction(0, 2)
            DisableControlAction(0, 211)
            DisableControlAction(0, 157, true)
            DisableControlAction(0, 158, true)
            DisableControlAction(0, 160, true)
            DisableControlAction(0, 164, true)
            DisableControlAction(0, 69, true) -- INPUT_VEH_ATTACK
            DisableControlAction(0, 92, true) -- INPUT_VEH_PASSENGER_ATTACK
            DisableControlAction(0, 114, true) -- INPUT_VEH_FLY_ATTACK
            DisableControlAction(0, 140, true) -- INPUT_MELEE_ATTACK_LIGHT
            DisableControlAction(0, 141, true) -- INPUT_MELEE_ATTACK_HEAVY
            DisableControlAction(0, 142, true) -- INPUT_MELEE_ATTACK_ALTERNATE
            DisableControlAction(0, 257, true) -- INPUT_ATTACK2
            DisableControlAction(0, 263, true) -- INPUT_MELEE_ATTACK1
            DisableControlAction(0, 264, true) -- INPUT_MELEE_ATTACK2
            DisableControlAction(0, 24, true) -- INPUT_ATTACK
            DisableControlAction(0, 25, true) -- INPUT_AIM
            DisableControlAction(0, 22, true) -- SPACE
            DisableControlAction(0, 200)
            DisableControlAction(0, 288, true) -- F1
            DisableControlAction(0, 289, true) -- F2
            DisableControlAction(0, 170, true) -- F3
            DisableControlAction(0, 167, true) -- F6
            DisableControlAction(0, 168, true) -- F7
            DisableControlAction(0, 57, true) -- F10
            DisableControlAction(0, 73, true) -- X

            if IsDisabledControlJustReleased(0, 200) then
                SetNuiFocus(false, false)

                Heap.InventoryOpened = false
            end
        end

        Citizen.Wait(sleepThread)
    end
end)