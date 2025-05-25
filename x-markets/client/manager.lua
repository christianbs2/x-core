OpenManagmentMenu = function(marketName, computerEntity)
    local options = {}
    local subMenuOptions = {}
	
    table.insert(options, {
        ["label"] = "~o~Dator"
    })
    
    table.insert(options, {
        ["label"] = Heap["markets"][marketName]["marketState"] == "locked" and "~g~Lås upp" or "~r~Lås",
        ["callback"] = function()
            if hasKey or Heap["markets"][marketName]["marketOwner"] == X.Character.Data.characterId then
                GlobalFunction("MARKET_STATE_HANDLER", {
                    ["marketName"] = marketName
                })
            else
                X.Notify("Dörr", "Du har ej nyckeln till denna dörr!", 5000, "error")
            end
        end
    })

    subMenuOptions = {
        {
            ["label"] = "Ta ut pengar",
            ["callback"] = function()
                while IsControlPressed(0, 19) do
                    X.Hint("Släpp ~ALT~ för att ~o~fortsätta~s~.")
                    
                    Citizen.Wait(0)                    
                end

                local amount = OpenInput("Välj hur mycket pengar som ska tas ut.", "MARKET_WITHDRAW_SAFE")

                if amount and tonumber(amount) and tonumber(amount) > 0 then
                    X.Callback("x-markets:safeHandler", function(validated)
                        if validated then
                            X.Notify("Kassa", "Du tog ut " .. tonumber(amount) .. " kr ur kassan.")
                        else
                            X.Notify("Kassa", "Det gick inte att ta ut så mycket pengar, finns det tillräckligt?")
                        end
                    end, tonumber(amount), "withdraw", marketName)
                else
                    return X.Notify("Kassa", "Du måste skriva en siffra över 0.", 5000, "error")
                end
            end
        },

        {
            ["label"] = "Sätt in pengar",
            ["callback"] = function()
                while IsControlPressed(0, 19) do
                    X.Hint("Släpp ~ALT~ för att ~o~fortsätta~s~.")
                    
                    Citizen.Wait(0)                    
                end

                local amount = OpenInput("Välj hur mycket pengar som ska sättas in.", "MARKET_DEPOSIT_SAFE")

                if amount and tonumber(amount) and tonumber(amount) > 0 then
                    X.Callback("x-markets:safeHandler", function(validated)
                        if validated then
                            X.Notify("Kassa", "Du satte in " .. tonumber(amount) .. " kr i kassan.")
                        else
                            X.Notify("Kassa", "Det gick inte att sätta in så mycket pengar, har du tillräckligt?")
                        end
                    end, tonumber(amount), "deposit", marketName)
                else
                    return X.Notify("Kassa", "Du måste skriva en siffra över 0.", 5000, "error")
                end
            end
        },
    }
    
    table.insert(options, {
        ["label"] = "Kassa: " .. Heap["markets"][marketName]["marketAccount"]["Balance"],
        ["subMenu"] = {
            ["options"] = subMenuOptions
        }
    })
    
    exports["x-context"]:OpenContextMenu({
        menu = "Computer - " .. computerEntity,
        entity = computerEntity,
        options = options
    })
end

MarketStateHandler = function(marketName)
    Citizen.CreateThread(function()
        local cashier = Heap["peds"][marketName] and Heap["peds"][marketName]["handle"] or nil
        local marketState = Heap["markets"][marketName]["marketState"]
        local cashierData = Config.Markets[marketName]

        if marketState ~= "locked" then
            if DoesEntityExist(cashier) then
                NetworkFadeOutEntity(cashier, false, true)
                Citizen.Wait(2500)
                DeleteEntity(cashier)
                Heap["peds"][marketName] = nil
            end
        else
            cashierData["cashier"]["callback"] = function(pedEntity)
                TaskTurnPedToFaceEntity(PlayerPedId(), pedEntity, 750)
                TaskTurnPedToFaceEntity(pedEntity, PlayerPedId(), 750)
        
                local options = {}
        
                table.insert(options, {
                    ["label"] = "~y~Kassör"
                })

                if Heap["shopping"] then
                    table.insert(options, {
                        ["label"] = "Sluta handla",
                        ["callback"] = function()
                            Heap["shopping"] = false
                        end
                    })

                    if #Heap["shoppingCart"] > 0 then
                        table.insert(options, {
                            ["label"] = "~g~Betala",
                            ["callback"] = function()
                                PurchaseItems(marketName)
                            end
                        })
                    end
                else
                    table.insert(options, {
                        ["label"] = "Börja handla",
                        ["callback"] = function()
                            cashierData["callback"](marketName, cashierData)
                        end
                    })
                end
            
                exports["x-context"]:OpenContextMenu({
                    ["menu"] = "store-clerk-" .. pedEntity,
                    ["entity"] = pedEntity,
                    ["options"] = options
                })
            end 

            if not Heap["peds"][marketName] or not DoesEntityExist(Heap["peds"][marketName]["handle"]) then
                Heap["peds"][marketName] = exports["x-pedstream"]:ConstructPed(cashierData["cashier"])
            end
        end

        Heap["markets"][marketName]["marketState"] = Heap["markets"][marketName]["marketState"] ~= "locked" and "locked" or "unlocked"
    end)
end