OpenJobNUI = function(jobName)
    X.Callback("x-jobpanel:fetchPanelData", function(panelData)
        local nuiData = panelData

        OpenNUI(nuiData)
    end, jobName)
end

OpenNUI = function(nuiData)
    local characterData = X.Character.Data.identification

    if not characterData then return end

    nuiData.Character = characterData
    nuiData.Vehicles = Config.Vehicles[string.upper(nuiData.Job.Name)] or {}

    SendNUIMessage({
        Action = "OPEN_JOBPANEL_NUI",
        Data = nuiData
    })

    Heap.NuiOpened = nuiData.Job.Name

    SetNuiFocus(true, true)
end

CloseNUI = function()
    SendNUIMessage({
        Action = "CLOSE_NUI"
    })
end

CompleteOrder = function(order)
    local vehicleModel = order.Order.Vehicle

    local usePlate = exports["x-vehicles"]:GeneratePlate()

    local setVehicleMaxMods = function(vehicle)
        local props = {
            modEngine       = 3,
            modBrakes       = 3,
            modTransmission = 3,
            modTurbo        = true,
        }

        exports["x-vehicles"]:SetVehicleProperties(vehicle, props)
    end

    while not HasModelLoaded(vehicleModel) do
        Citizen.Wait(0)

        RequestModel(vehicleModel)
    end

    local vehicle = CreateVehicle(vehicleModel, vector3(-1502.6407470703, -2996.1784667969, -82.20719909668), 359.63943481445)

    setVehicleMaxMods(vehicle)

    local vehicleProps = exports["x-vehicles"]:GetVehicleProperties(vehicle)

    vehicleProps.plate = usePlate

    SetVehicleNumberPlateText(vehicle, usePlate)

    X.Callback("x-jobpanel:deliverVehicle", function(delivered)
        if delivered then
            X.Notify("Transportbolaget", "Fordonsnyckeln ligger nu inuti din nyckelknippa, leverera den till någon inom företaget.", 7500, "success")
        end
    end, order, vehicleProps)

    DeleteVehicle(vehicle)
end

TransportDelivery = function(order, vehicles)
    for _, vehicleData in ipairs(vehicles) do
        if vehicleData.Type == "SHOWCASE_VEHICLE" then
            if DoesEntityExist(vehicleData.Handle) then
                DeleteEntity(vehicleData.Handle)
            end
        end
    end

    CompleteOrder(order)
end

DrawScreenText = function(text)
    SetTextEntry("STRING")
    SetTextCentre(true)
    SetTextOutline()
    SetTextScale(0.8, 0.8)
    AddTextComponentString(text)
    DrawText(0.5, 0.0)
end

DrawScriptMarker = function(markerData)
    DrawMarker(markerData["type"] or 1, markerData["pos"] or vector3(0.0, 0.0, 0.0), 0.0, 0.0, 0.0, (markerData["type"] == 6 and -90.0 or markerData["rotate"] and -180.0) or 0.0, 0.0, 0.0, markerData["size"] or vector3(1.0, 1.0, 1.0), markerData["r"] or 1.0, markerData["g"] or 1.0, markerData["b"] or 1.0, 100, markerData["bob"] and true or false, true, 2, false, false, false, false)
end

DrawScriptText = function(coords, text)
    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
end

LoadModels = function(models)
    for index, model in ipairs(models) do
        if IsModelValid(model) then
            while not HasModelLoaded(model) do
                RequestModel(model)

                Citizen.Wait(10)
            end
        else
            while not HasAnimDictLoaded(model) do
                RequestAnimDict(model)

                Citizen.Wait(10)
            end
        end
    end
end

CleanupModels = function(models)
    for index, model in ipairs(models) do
        if IsModelValid(model) then
            SetModelAsNoLongerNeeded(model)
        else
            RemoveAnimDict(model)
        end
    end
end