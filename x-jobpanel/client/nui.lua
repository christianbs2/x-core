RegisterNetEvent("x-jobpanel:closeNUI")
AddEventHandler("x-jobpanel:closeNUI", function()
    SetNuiFocus(false, false)

    Heap.NuiOpened = false
end)

RegisterNetEvent("x-jobpanel:updateNUI")
AddEventHandler("x-jobpanel:updateNUI", function(response)
    if Heap.NuiOpened then
        OpenNUI(response)
    end
end)