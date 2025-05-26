RegisterNetEvent("x-character:characterLoaded")
AddEventHandler("x-character:characterLoaded", function(response)
    X.Character.Data = response

    Fetch()
end)

RegisterNetEvent("x-character:jobUpdated")
AddEventHandler("x-character:jobUpdated", function(newData)
    X.Character.Data.job = newData
end)

RegisterNetEvent("x-admin:action")
AddEventHandler("x-admin:action", function(actionData)
    if actionData.Action == "EDIT_GARAGE" then
        X.Callback("x-admin:changeVehicleGarage", function(saved)
            if saved then
                X.Notify("Admin", "Du bytte garage på fordonet" .. actionData.Vehicle.vehiclePlate .. "till " .. actionData.Vehicle.vehicleGarage .. ".", 5000, "success")
            end
        end, actionData.Vehicle)
    end
end)

RegisterNetEvent("x-admin:teleport")
AddEventHandler("x-admin:teleport", function(coordinates)
    SetEntityCoords(Heap.Ped, coordinates)
end)

RegisterNetEvent("x-admin:healCharacter")
AddEventHandler("x-admin:healCharacter", function(type)
    if type == "HP" then
        SetEntityHealth(Heap.Ped, GetEntityMaxHealth(Heap.Ped))
    elseif type == "REVIVE" then
        exports["x-ambulance"]:RevivePlayer()
    elseif type == "KILL" then
        SetEntityHealth(Heap.Ped, 0)
    end
end)

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        SetNuiFocus(false, false)
    end
end)