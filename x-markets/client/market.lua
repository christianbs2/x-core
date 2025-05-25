OpenMarketMenu = function(marketName, marketData)
    local ped = PlayerPedId()
    local menuElements = {}

    for _, itemData in ipairs(Config.DefaultItems) do

        table.insert(menuElements, {
            ["label"] = itemData["label"].." - "..itemData["price"],
            ["rawLabel"] = itemData["label"],
            ["item"] = itemData["item"],
            ["price"] = itemData["price"],
            ["type"] = "slider",
            ["min"] = 0,
            ["value"] = 1,
            ["max"] = 50,
            ["marketName"] = Heap["markets"][marketName] and Heap["markets"][marketName]["marketName"] or "Affär-"..marketName
        })

    end

    X.UI.Menu.Open("default", GetCurrentResourceName(), "market_buy_menu", {
        ["title"] = "Vad vill du handla.",
        ["align"] = "right",
        ["elements"] = menuElements
    }, function(menuData, menuHandle)
        menuHandle.close()

        local menuAction = menuData["current"]["item"]

        if menuAction then
            X.UI.Menu.Open("default", GetCurrentResourceName(), "confirm_market_menu", {
                ["title"] = "Välj.",
                ["align"] = "right",
                ["elements"] = {
                    {
                        ["label"] = "Godkänn köp, " .. menuData["current"]["price"]*menuData["current"]["value"] .. " SEK.", 
                        ["action"] = "yes"
                    },
                    {
                        ["label"] = "Avbryt.", 
                        ["action"] = "no"
                    }
                }
            }, function(menuData2, menuHandle2)
                menuHandle2.close()
    
                local menuAction2 = menuData2["current"]["action"]
    
                if menuAction2 == "yes" then
                    X.Callback("x-markets:buyItem", function(validated)
                        if validated then
                            X.Notify(Heap["markets"][marketName] and Heap["markets"][marketName]["marketName"] or "Affär", "Du köpte "..menuData["current"]["value"].."st "..menuData["current"]["rawLabel"].." för "..menuData["current"]["price"]*menuData["current"]["value"].."SEK", 3000, "success")
                        else
                            X.Notify(Heap["markets"][marketName] and Heap["markets"][marketName]["marketName"] or "Affär", "Du har inte tillräckligt med pengar.", 3000, "error")
                        end
                    end, menuData["current"])
                else
                    menuHandle2.close()
                end
            end, function(menuData2, menuHandle2)
                menuHandle2.close()
            end)
        else
            X.Notify(Heap["markets"][marketName] and Heap["markets"][marketName]["marketName"] or "Affär", "Valde du något?", 3000, "error")
            menuHandle.close()
        end
    end, function(menuData, menuHandle)
        menuHandle.close()
    end)
end

AddMarketContext = function(marketName, pedCoords)
    local objects = X.GetObjects()
    local storeType = Config.WhatStore(marketName)

    for _, interactebleEntity in ipairs(objects) do
        local dstCheck = #(pedCoords - GetEntityCoords(interactebleEntity))
        local model = GetEntityModel(interactebleEntity)        
        
        if DoesEntityExist(interactebleEntity) and dstCheck <= 10.0 and not Heap["addedMenu"][interactebleEntity] then
            if Config.ShelfItems[model] then
                local options = {}

                table.insert(options, {
                    ["label"] = "~y~Hylla"
                })
                
                for _, itemData in ipairs(Config.ShelfItems[model]) do
                    table.insert(options, {
                        ["label"] = itemData["label"] .. " ~g~"..itemData["price"] .. " SEK",
                        ["callback"] = function()
                            if Heap["shopping"] then
                                exports["x-context"]:CloseContextMenu()
            
                                ChooseAmount(itemData, interactebleEntity)
                            else 
                                X.Notify("Butik", "Prata med kassören för att börja handla.", 2500, "warning")
                            end
                        end
                    })
                end

                exports["x-context"]:AddCustomMenu(interactebleEntity, function()					
                    exports["x-context"]:OpenContextMenu({
                        menu = marketName .. "-" .. interactebleEntity,
                        entity = interactebleEntity,
                        options = options
                    })
                end)

                Heap["addedMenu"][interactebleEntity] = true
            else
                if Heap["markets"][marketName] then
                    for type, data in pairs(Config.MarketSettings) do
                        if data["managment"] and data["managment"]["entityHash"] == model then
                            local options = {}

                            table.insert(options, {
                                ["label"] = "~o~Dator"
                            })
                        
                            table.insert(options, {
                                ["label"] = "~g~Använd",
                                ["callback"] = function()
                                    if Heap["markets"][marketName]["marketOwner"] == X.Character.Data.characterId then
                                        data["managment"]["callback"](marketName, interactebleEntity)
                                    else
                                        X.Notify("Dator", "Fel lösenord!", 5000, "error")
                                    end
                                end
                            })
        
                            exports["x-context"]:AddCustomMenu(interactebleEntity, function()					
                                exports["x-context"]:OpenContextMenu({
                                    menu = marketName .. "-" .. interactebleEntity,
                                    entity = interactebleEntity,
                                    options = options
                                })
                            end)
        
                            Heap["addedMenu"][interactebleEntity] = true
                        end 
                    end
                end
            end

             if Heap["robbingMarket"] == marketName then
                 table.insert(options, {
                     ["label"] = "~o~Kassa"
                 })

                 table.insert(options, {
                     ["label"] = exports["x-inventory"]:GetItemInHand()["Name"] == "crowbar" and (Heap["robbing"][interactebleEntity] and "~r~Sno pengar" or "~r~Dyrka upp") or "~r~Låst",
                     ["callback"] = function()
                         local functionName = Heap["robbing"][interactebleEntity] and TakeMoney or LockPick
                        
                         functionName(interactebleEntity)
                     end
                 })

                 exports["x-context"]:AddCustomMenu(interactebleEntity, function()					
                     exports["x-context"]:OpenContextMenu({
                         menu = marketName .. "-" .. interactebleEntity,
                         entity = interactebleEntity,
                         options = options
                     })
                 end)
             end
        end
    end
end

StartShopping = function(marketName, marketData)
    Heap["shopping"] = true
    Heap["shoppingCart"] = {}
    Heap["totalPrice"] = 0

    Citizen.CreateThread(function()
        
        while Heap["shopping"] do
            local sleepThread = 5

            local y = 0.3

            if #Heap["shoppingCart"] > 0 then
                for _, itemData in ipairs(Heap["shoppingCart"]) do
                    DrawText2D(itemData["amount"].."st "..itemData["label"].." - "..itemData["price"] * itemData["amount"].." SEK", 0.05, y+(0.025*_), 0.4, 4, 219, 219, 219, 255)
                end
            else
                DrawText2D("Kundvagn tom.", 0.05, y+0.025, 0.4, 4, 219, 219, 219, 255)
            end

            DrawText2D("Kundvagn - ".. Heap["totalPrice"].." SEK", 0.05, 0.295, 0.45, 4, 219, 219, 219, 255)

            Citizen.Wait(sleepThread)
        end
    end)
end

PurchaseItems = function(marketName)
    X.Callback("x-markets:completePurchase", function(validated)
        if validated then
            X.Notify("Kvitto", "Du handlade föremål för totalt " .. Heap["totalPrice"] .. " kr.", 7500, "success")

            Heap["shopping"] = false
        else
            X.Notify("Köp", "Köpet genomfördes ej, pengar saknas.", 5000, "error")
        end
    end, Heap["shoppingCart"], marketName)
end

OpenShelfMenu = function(entity)
    local entityHash = GetEntityModel(entity)

    local options = {}
    
    table.insert(options, {
        ["label"] = "~y~Hylla"
    })
    
    for _, itemList in ipairs(Config.ShelfItems[entityHash]) do
        table.insert(options, {
            ["label"] = itemList["label"] .. " ~g~"..itemList["price"] .. " SEK",
            ["callback"] = function()
                if Heap["shopping"] then
                    exports["x-context"]:CloseContextMenu()

                    ChooseAmount(itemList, entity)
                else 
                    X.Notify("Butik", "Prata med kassören för att börja handla.", 2500, "error")
                end
            end
        })
    end
    
    exports["x-context"]:OpenContextMenu({
        ["menu"] = "market-shelf-" .. entity,
        ["entity"] = entity,
        ["options"] = options
    })
end

ChooseAmount = function(itemList, entity)
    local options = {}

    local differentAmounts = { 1, 2, 5, 10 }
    
    table.insert(options, {
        ["label"] = "~y~Välj antal"
    })
    
    for currentAmountIndex = 1, #differentAmounts do
        table.insert(options, {
            ["label"] = differentAmounts[currentAmountIndex] .. "st för ~g~" .. differentAmounts[currentAmountIndex] * itemList["price"] .. " kr",
            ["callback"] = function()
                AddItemToCart(itemList, differentAmounts[currentAmountIndex])
            end
        })
    end

    exports["x-context"]:OpenContextMenu({
        ["menu"] = "market-amount-shelf-" .. entity,
        ["entity"] = entity,
        ["options"] = options,
        ["oldPos"] = true
    })
end

AddItemToCart = function(itemList, amount)
    Heap["totalPrice"] = Heap["totalPrice"] + (itemList["price"] * amount)

    local isExisting

    if #Heap["shoppingCart"] > 0 then
        for id, itemData in ipairs(Heap["shoppingCart"]) do
            if itemData["item"] == itemList["item"] then
                Heap["shoppingCart"][id]["amount"] = Heap["shoppingCart"][id]["amount"] + amount

                isExisting = true

                break
            end
        end
    end

    if isExisting then return end

    table.insert(Heap["shoppingCart"], {
        ["label"] = itemList["label"],
        ["amount"] = amount,
        ["price"] = itemList["price"],
        ["item"] = itemList["item"]
    })
end