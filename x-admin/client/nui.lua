RegisterNetEvent("x-admin:closeNUI")
AddEventHandler("x-admin:closeNUI", function()
    SetNuiFocus(false, false)

    Heap.NuiOpened = false
end)

RegisterNetEvent("x-admin:updateNUI")
AddEventHandler("x-admin:updateNUI", function(response)
    if Heap.NuiOpened then
        OpenNUI(response)
    end
end)

RegisterNetEvent("x-admin:getPlayerInformation")
AddEventHandler("x-admin:getPlayerInformation", function(player)
    X.Callback("x-admin:fetchPlayerInformation", function(information)
        SendNUIMessage({
            Action = "OPEN_PLAYER_PAGE",
            Data = information
        })
    end, player)
end)