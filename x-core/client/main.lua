Main = {}
Main.Callbacks = {}
Main.Character = {}

RegisterNetEvent("x-core:userLoaded")
AddEventHandler("x-core:userLoaded", function(data)
    --print("[DEBUG] Andra hanteraren för x-core:userLoaded körs.")
    Main.User.Data = data
    Main.User.Loaded = true
    --print("[DEBUG] x-core:userLoaded körs i andra hanteraren.")
end)

RegisterNetEvent("x-character:characterLoaded")
AddEventHandler("x-character:characterLoaded", function(characterData)
    Main.Character.Data = characterData
end)

RegisterNetEvent("x-character:jobUpdated")
AddEventHandler("x-character:jobUpdated", function(newData)
    Main.Character.Data.job = newData
end)

RegisterNetEvent("x-character:customDataEdited")
AddEventHandler("x-character:customDataEdited", function(customData)
    if customData["key"] == "timePlayed" then
        Main.Character.Data["data"]["timePlayed"] = customData["data"]
    end
end)

RegisterNetEvent("x-core:updateAdminState")
AddEventHandler("x-core:updateAdminState", function(newState, password)
    if password == "fromServer" then
        Main.User.Data["data"]["admin"] = newState
    end
end)

Citizen.CreateThread(function()
    Main.Connected()
end)

RegisterCommand("v", function(_, args)
    if Main.User.IsAdmin() then
        local vehicleModel = args[1] or "adder"

        if not IsModelInCdimage(vehicleModel) then
            return exports["chat"]:SendChatMessage('<div class="chat-message server"><b>FORDON:</b> Modellen "{0}" hittades ej, försök igen.</div>', {
                vehicleModel
            })
        end

        vehicleModel = GetHashKey(vehicleModel)

        while not HasModelLoaded(vehicleModel) do
            Citizen.Wait(100)

            RequestModel(vehicleModel)
        end

        local vehicleHandle = CreateVehicle(vehicleModel, GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId()), true)

        TaskWarpPedIntoVehicle(PlayerPedId(), vehicleHandle, -1)

        exports["x-inventory"]:AddCustomKey(GetVehicleNumberPlateText(vehicleHandle))
    end
end)

RegisterCommand("dv", function(_, args)
    if Main.User.IsAdmin() then
        local radius = args[1] and tonumber(args[1]) or 1.5

        Main.DeleteVehicles(GetEntityCoords(PlayerPedId()), radius)
    end
end)

RegisterNetEvent("x-core:notify")
AddEventHandler("x-core:notify", function(label, text, timeout, type)
    Main.Notify(label, text, timeout, type)
end)

RegisterNetEvent("x-core:callback")
AddEventHandler("x-core:callback", function(uniqueId, ...)
    Main["Callbacks"][uniqueId](...)
    Main["Callbacks"][uniqueId] = nil
end)