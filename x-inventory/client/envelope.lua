RegisterNetEvent("x-inventory:putInCash")
AddEventHandler("x-inventory:putInCash", function(itemData, inventoryName)
    local input = exports["x-input"]:Input({
        Header = "Kuvert",

        Rows = {
            {
                Text = "Hur mycket vill du lägga in?"
            }
        }
    })

    if not input then return end
    if not input[1].Input then return end
    if #input[1].Input <= 0 then return end
    if not tonumber(input[1].Input) then return end

    input[1].Input = tonumber(input[1].Input)

    if input[1].Input > 10000 then return end

    X.Callback("x-inventory:saveCashEnvelope", function(saved)
        if saved then
            X.Notify("Kuvert", "Du la in " .. input[1].Input .. " kr i kuvertet.", 7500, "success")
        else
            X.Notify("Kuvert", "Försök igen, något gick fel.", 7500, "error")
        end
    end, itemData, inventoryName, input[1].Input)
end)

OpenInput = function(label, type)
    AddTextEntry(type, label)

    DisplayOnscreenKeyboard(1, type, "", "", "", "", "", 30)

    while UpdateOnscreenKeyboard() == 0 do
        DisableAllControlActions(0)
        Wait(0)
    end

    if GetOnscreenKeyboardResult() then
        return GetOnscreenKeyboardResult()
    end
end