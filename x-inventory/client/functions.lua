GlobalFunction = function(event, data)
    local options = {
        event = event,
        data = data
    }

    -- print("Triggering global function: " .. options["event"])

    TriggerServerEvent("qalle_inventory:globalEvent", options)
end

OpenInventory = function()
    UpdateInventory()

    SetNuiFocusKeepInput(true)
    SetNuiFocus(true, true)

    Heap.InventoryOpened = true
end

OpenSpecialInventory = function(specialInventoryData, hidden)
    Citizen.Wait(280)

    specialInventoryData.Hidden = hidden

    table.insert(Heap.SpecialInventories, specialInventoryData)

    OpenInventory()
end

SendInventoryNotification = function(notificationData)
    SendNUIMessage({
        ["Action"] = "SEND_NOTIFICATION",
        ["data"] = {
            ["header"] = notificationData["header"] or "Inventory",
            ["content"] = notificationData["content"] or "Ingen text vald mannen.",
            ["duration"] = notificationData["duration"] or 5000
        }
    })
end

UpdateInventory = function(skipOpen)
    local extraInventories = Heap.SpecialInventories

    X.Callback("x-inventory:fetchInventories", function(inventories)
        for _, inventoryData in ipairs(inventories) do
            local staticInventoryData = GetInventoryData(inventoryData.Inventory)

            if staticInventoryData and staticInventoryData.Character then
                UpdateKeys(inventoryData.Items, inventoryData.Inventory)
            end
        end

        UpdateInventoryNUI(inventories)

        if not skipOpen then
            SendNUIMessage({
                ["Action"] = "OPEN_INVENTORY"
            })
        end
    end, extraInventories)
end

UpdateInventoryNUI = function(inventories)
    local sendInventory = {
        leftContainer = {},
        rightContainer = {}
    }

   

    for _, inventoryData in ipairs(inventories) do
        local staticInventoryData = GetInventoryData(inventoryData.Inventory)
        local usercash = false;

        X.Callback("x-inventory:getCash", function(balance)
            usercash = balance
        end)

        while not usercash do
            Citizen.Wait(0)
        end

        table.insert(sendInventory[inventoryData.Container], {
            action = inventoryData.Inventory,
            actionLabel = staticInventoryData and staticInventoryData.Label or inventoryData.Label,
            slots = staticInventoryData and staticInventoryData.MaxSlots or inventoryData.MaxSlots,
            maxWeight = staticInventoryData and staticInventoryData.MaxWeight or inventoryData.MaxWeight,
            items = inventoryData.Inventory == "GROUND" and ScanVicinity(inventoryData.Items) or FixInventoryItems(inventoryData.Items, inventoryData.Hidden),
            kontanter = usercash;
        })
    end

    SendNUIMessage({
        ["Action"] = "UPDATE_INVENTORY",
        ["inventory"] = sendInventory
    })
end

UpdateSpecificInventory = function(inventoryName, inventoryItems)
    local sendInventory = {}

    local fixedItems = FixInventoryItems(inventoryItems)

    local staticInventoryData = GetInventoryData(inventoryName)

    local found = false

    if string.match(inventoryName, "POCKETS") then
        
        local usercash = false;

        X.Callback("x-inventory:getCash", function(balance)
            usercash = balance
        end)

        while not usercash do
            Citizen.Wait(0)
        end

        sendInventory = {
            action = inventoryName,
            specificInventoryData = {
                action = inventoryName,
                actionLabel = staticInventoryData.Label,
                slots = staticInventoryData.MaxSlots,
                maxWeight = staticInventoryData.MaxWeight,
                items = fixedItems,
                kontanter = usercash
            }
        }

        found = true

        UpdateKeys(inventoryItems, inventoryName)
    elseif string.match(inventoryName, "KEYCHAIN") then
        
        local usercash = false;

        X.Callback("x-inventory:getCash", function(balance)
            usercash = balance
        end)

        while not usercash do
            Citizen.Wait(0)
        end

        sendInventory = {
            action = inventoryName,
            specificInventoryData = {
                action = inventoryName,
                actionLabel = staticInventoryData.Label,
                slots = staticInventoryData.MaxSlots,
                maxWeight = staticInventoryData.MaxWeight,
                items = fixedItems,
                kontanter = usercash
            }
        }

        found = true

        UpdateKeys(inventoryItems, inventoryName)
    elseif inventoryName == "GROUND" then
        sendInventory = {
            action = inventoryName,
            specificInventoryData = {
                action = inventoryName,
                actionLabel = staticInventoryData.Label,
                slots = staticInventoryData.MaxSlots,
                maxWeight = staticInventoryData.MaxWeight,
                items = ScanVicinity(inventoryItems)
            }
        }

        found = true

        RefreshObjects(inventoryItems)
    else
        for _, inventoryData in ipairs(Heap.SpecialInventories) do
            if inventoryData.action == inventoryName then
                local fixedItems = FixInventoryItems(inventoryItems, inventoryData.Hidden)

                sendInventory = {
                    action = inventoryName,
                    specificInventoryData = {
                        action = inventoryData.action,
                        actionLabel = inventoryData.actionLabel,
                        slots = inventoryData.slots,
                        maxWeight = inventoryData.maxWeight,
                        items = fixedItems
                    }
                }

                found = true
            end
        end
    end

    if found then
        SendNUIMessage({
            ["Action"] = "UPDATE_SPECIFIC_INVENTORY",
            ["action"] = sendInventory["action"],
            ["specificInventoryData"] = sendInventory["specificInventoryData"]
        })
    end
end

UpdateKeys = function(inventoryItems, inventoryName)
    Heap.Keys[inventoryName] = {}

    for _, itemData in ipairs(inventoryItems) do
        if itemData.Name == "key" then
            local key = itemData.MetaData and itemData.MetaData.Key or false

            if key then
                table.insert(Heap.Keys[inventoryName], key)
            end
        end
    end
end

AddCustomKey = function(keyName)
    Heap.CustomKeys[keyName] = true
end

RemoveCustomKey = function(keyName)
    Heap.CustomKeys[keyName] = nil
end

FixInventoryItems = function(items, hidden)
    local sendInventory = {}

    if not items then return sendInventory end

    for _, itemData in ipairs(items) do
        local defaultItemData = GetItemData(itemData.Name)

        local newData = itemData

        newData.Label = itemData.MetaData and itemData.MetaData.Label or defaultItemData and defaultItemData.Label or itemData.Name
        newData.Weight = itemData.MetaData and itemData.MetaData.Weight or defaultItemData and defaultItemData.Weight or 0.5
        newData.Count = tonumber(newData.Count)
        newData.Stackable = defaultItemData and defaultItemData.Stackable or false
        newData.Description = itemData.MetaData and itemData.MetaData.Description or defaultItemData and defaultItemData.Description
        newData.UseButton = itemData.MetaData and itemData.MetaData.UseButton or defaultItemData and defaultItemData.UseButton
        newData.Logo = itemData.MetaData and itemData.MetaData.Logo or itemData.Name
        newData.Durability = itemData.MetaData and itemData.MetaData.Durability
        newData.Image = itemData.MetaData and itemData.MetaData.Image
        newData.Hidden = hidden

        table.insert(sendInventory, newData)
    end

    return sendInventory
end

HasKey = function(keyUnit)
    local trim = function(value)
        if value then
            return (string.gsub(value, "^%s*(.-)%s*$", "%1"))
        else
            return nil
        end
    end

    if Heap.CustomKeys[keyUnit] then return true end

    for _, keys in pairs(Heap.Keys) do
        for _, key in ipairs(keys) do
            if trim(key) == trim(keyUnit) then
                return true
            end
        end
    end

    return false
end

GetCharacterInventories = function()
    local inventories = false

    X.Callback("x-inventory:fetchInventories", function(fetchedInventories)
        inventories = fetchedInventories or {}
    end)

    while not inventories do
        Citizen.Wait(0)
    end

    return inventories
end

GetInventory = function(inventoryName)
    local inventory = false

    X.Callback("x-inventory:fetchInventory", function(fetchedInventory)
        inventory = fetchedInventory or {}
    end, inventoryName)

    while not inventory do
        Citizen.Wait(0)
    end

    return inventory
end

OpenInventoryHandler = function()
    for _, autoOpen in ipairs(Heap.AutoOpens) do
        OpenSpecialInventory(autoOpen)
    end

    local inventories = GetCharacterInventories()

    for _, inventoryData in ipairs(inventories) do
        local bagFound = false

        for _, itemData in ipairs(inventoryData.Items) do
            if itemData.Name == "bag" and itemData.MetaData.Bag then
                local characterAppearance = exports["x-appearance"]:GetCharacterAppearance()

                local validated = 0

                if itemData.MetaData.Accessories then
                    for accessoryIndex, accessoryValue in pairs(itemData.MetaData.Accessories) do
                        if characterAppearance[accessoryIndex] == accessoryValue then
                            validated = validated + 1
                        end
                    end
                end

                if validated >= 2 then
                    OpenSpecialInventory({
                        action = "BAG_" .. (itemData.MetaData.Bag and itemData.MetaData.Bag or itemData.UUID),
                        actionLabel = "Väska",
                        slots = Config.Bag.MaxSlots,
                        maxWeight = Config.Bag.MaxWeight,
                        container = "rightContainer"
                    })

                    bagFound = true

                    break
                end
            elseif itemData.Name == "medic_bag" then 
                OpenSpecialInventory({
                    action = "MEDIC_BAG_" .. (itemData.MetaData.Bag and itemData.MetaData.Bag or itemData.UUID),
                    actionLabel = "Förbandsväska",
                    slots = Config.MedicBag.MaxSlots,
                    maxWeight = Config.MedicBag.MaxWeight,
                    container = "rightContainer"
                })

                break
            end
        end

        if bagFound then
            break
        end
    end

    local closestVehicle, _ = X.GetClosestVehicle(GetEntityCoords(PlayerPedId()))

    local dimension, _ = GetModelDimensions(GetEntityModel(closestVehicle))
    local trunkLocation = GetOffsetFromEntityInWorldCoords(closestVehicle, 0.0, dimension["y"] - 0.5, 0.0)

    local dstCheck = GetDistanceBetweenCoords(trunkLocation, GetEntityCoords(PlayerPedId()))

    if dstCheck < 1.0 then
        local doorAngle = GetVehicleDoorAngleRatio(closestVehicle, 5)

        if doorAngle == 0.0 then
            return OpenInventory()
        end

        OpenSpecialInventory({
            action = "VEHICLE_TRUNK_" .. GetVehicleNumberPlateText(closestVehicle),
            actionLabel = "Bagage",
            slots = 16,
            maxWeight = 35.0,
            container = "rightContainer"
        })

        if not IsPedInAnyVehicle(PlayerPedId()) then
            PlayAnimation(PlayerPedId(), "mini@repair", "fixing_a_ped", { speed = 8.0, speedMultiplier = 8.0, duration = 5000, flag = 1 })
        end
    else
        OpenInventory()

        if not IsPedInAnyVehicle(PlayerPedId()) then
            PlayAnimation(PlayerPedId(), "pickup_object", "putdown_low", { speed = 8.0, speedMultiplier = 8.0, duration = 1250, flag = 48 })
        end
    end

end

ScanVicinity = function(inventoryItems)
    local vicinity = {}

    local ped = PlayerPedId()

    local pedLocation = GetEntityCoords(ped)

    local currentInstance = DecorGetInt(ped, "CURRENT_INSTANCE")

    for _, itemData in ipairs(inventoryItems) do
        if itemData.Location and itemData.Instance == currentInstance then
            local dstCheck = #(pedLocation - vector3(itemData.Location.X, itemData.Location.Y, itemData.Location.Z))

            if dstCheck <= Config.VicinityScanDistance then
                table.insert(vicinity, itemData.Item)
            end
        end
    end

    return FixInventoryItems(vicinity)
end

ToggleObjects = function(instanceId, visible)
    if Heap.SpawnedObjects then
        for _, entityData in ipairs(Heap.SpawnedObjects) do
            if DoesEntityExist(entityData.Handle) and entityData.Instance ~= instanceId then
                SetEntityVisible(entityData.Handle, visible)
            end
        end
    end
end

RefreshObjects = function(items)
    if Heap.SpawnedObjects then
        for _, entityData in ipairs(Heap.SpawnedObjects) do
            if DoesEntityExist(entityData.Handle) then
                DeleteEntity(entityData.Handle)
            end
        end
    end

    Heap.SpawnedObjects = {}

    for _, itemData in ipairs(items) do
        local defaultItemData = GetItemData(itemData.Item.Name)

        local model = defaultItemData and IsModelValid(defaultItemData.Model) and defaultItemData.Model or GetHashKey("prop_cs_package_01")

        if model and itemData.Location then
            LoadModel(model)

            local entityHandle = CreateObject(model, vector3(itemData.Location.X, itemData.Location.Y, itemData.Location.Z - 0.985), false)

            table.insert(Heap.SpawnedObjects, {
                Handle = entityHandle,
                Location = vector3(itemData.Location.X, itemData.Location.Y, itemData.Location.Z - 0.985),
                UUID = itemData.Item.UUID,
                Label = defaultItemData and defaultItemData.Label or itemData.Item.Name,
                Instance = itemData.Instance
            })

            SetEntityDynamic(entityHandle, true)
            SetEntityAsMissionEntity(entityHandle, true, true)

            SetEntityVisible(entityHandle, DecorGetInt(PlayerPedId(), "CURRENT_INSTANCE") == itemData.Instance)

            SetModelAsNoLongerNeeded(model)
        end
    end
end

PlayAnimation = function(ped, dict, anim, settings)
	if dict then
		Citizen.CreateThread(function()
			RequestAnimDict(dict)

			while not HasAnimDictLoaded(dict) do
        Citizen.Wait(100)
      end

      if settings == nil then
        TaskPlayAnim(ped, dict, anim, 1.0, -1.0, 1.0, 0, 0, 0, 0, 0)
      else 
        local speed = 1.0
        local speedMultiplier = -1.0
        local duration = 1.0
        local flag = 0
        local playbackRate = 0

        if settings["speed"] ~= nil then
          speed = settings["speed"]
        end

        if settings["speedMultiplier"] ~= nil then
          speedMultiplier = settings["speedMultiplier"]
        end

        if settings["duration"] ~= nil then
          duration = settings["duration"]
        end

        if settings["flag"] ~= nil then
          flag = settings["flag"]
        end

        if settings["playbackRate"] ~= nil then
          playbackRate = settings["playbackRate"]
        end

        TaskPlayAnim(ped, dict, anim, speed, speedMultiplier, duration, flag, playbackRate, 0, 0, 0)
      end
      
      RemoveAnimDict(dict)
		end)
	else
		TaskStartScenarioInPlace(ped, anim, 0, true)
	end
end

LoadModel = function(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(10)
    end
end

GetItems = function(items, wantItems)
    if not type(items) == "table" then return end

    local returnData = {}

    local inventories = GetCharacterInventories()

    for _, inventoryData in pairs(inventories) do
        for _, itemData in ipairs(inventoryData.Items) do
            for _, checkItemName in ipairs(items) do
                if itemData.Name == checkItemName then
                    table.insert(returnData, itemData)
                end
            end
        end
    end

    if wantItems then
        return returnData
    else
        return #returnData >= #items
    end
end

GetItem = function(item)
    if not item then return end

    local inventories = GetCharacterInventories()

    for _, inventoryData in pairs(inventories) do
        for _, itemData in ipairs(inventoryData.Items) do
            if itemData.Name == item then
                return itemData
            end
        end
    end

    return false
end

Draw3DText = function(coords, text)
    local onScreen,_x,_y=World3dToScreen2d(coords.x,coords.y,coords.z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.25, 0.25)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)

    --local factor = (string.len(text)) / 370
    --DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

DrawScriptMarker = function(markerData)
    DrawMarker(markerData["type"] or 1, markerData["pos"] or vector3(0.0, 0.0, 0.0), 0.0, 0.0, 0.0, (markerData["type"] == 6 and -90.0 or markerData["rotate"] and -180.0) or 0.0, 0.0, 0.0, markerData["size"] or vector3(1.0, 1.0, 1.0), markerData["color"] or vector3(0, 0, 0), 100, markerData["bob"] and true or false, true, 2, false, false, false, false)
end

table.count = function(t)
    local c = 0

    for k, v in pairs(t) do
        c = c + 1
    end

    return c
end