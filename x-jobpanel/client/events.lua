RegisterNetEvent("x-character:characterLoaded")
AddEventHandler("x-character:characterLoaded", function(response)
    X.Character.Data = response
end)

RegisterNetEvent("x-character:jobUpdated")
AddEventHandler("x-character:jobUpdated", function(newData)
    X.Character.Data.job = newData
end)

RegisterNetEvent("x-jobpanel:accountChanged")
AddEventHandler("x-jobpanel:accountChanged", function(jobName, newBalance)
    if Heap.NuiOpened and string.lower(Heap.NuiOpened) == string.lower(jobName) then
        SendNUIMessage({
            Action = "EDIT_JOBPANEL_BALANCE",
            Data = newBalance
        })
    end
end)

RegisterNetEvent("x-jobpanel:action")
AddEventHandler("x-jobpanel:action", function(data)
    local action = data.Action

    if action == "ORDER_VEHICLE" then
        local vehicleData = data.Vehicle

        X.Callback("x-jobpanel:orderVehicle", function(ordered)
            if ordered then
                X.Notify("Transportbolaget", "Din beställning av fordonet har nu lagts, vänligen vänta på leverans!", 5000, "success")
            end
        end, vehicleData, data.Job)
    elseif action == "OPEN_INVOICE" then
        local invoiceData = data.Invoice.InvoiceData

        exports["x-invoice"]:OpenDeleteInvoice(invoiceData)
    end
end)

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        SetNuiFocus(false, false)
    end
end)