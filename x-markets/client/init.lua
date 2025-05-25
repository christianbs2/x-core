Initialize = function()
    local fetched = false

    X.Callback("x-markets:fetchMarkets", function(fetchedCache)
        if fetchedCache then
            Heap["markets"] = fetchedCache["markets"]

            if fetchedCache["doors"] then
                Heap["doors"] = fetchedCache["doors"]
            end

            if fetchedCache["robbedMarkets"] then
                Heap["robbedMarkets"] = fetchedCache["robbedMarkets"]
            end

            if fetchedCache["cashRegisters"] then
                Heap["cashRegisters"] = fetchedCache["cashRegisters"]
            end

            if fetchedCache["ongoingRobberies"] then
                Heap["ongoingRobberies"] = fetchedCache["ongoingRobberies"]
            end

            if fetchedCache["robbedRegisters"] then
                Heap["robbedRegisters"] = fetchedCache["robbedRegisters"]
            end

            fetched = true
        else
            fetched = true
        end
    end)

    while not fetched do
        Citizen.Wait(0)
    end

    for marketName, marketData in pairs(Config.Markets) do
    -- Define the specific positions where you want the market blips to be visible
        local desiredPositions = {
            vector3(1698.2028808594, 4924.51171875, 42.063674926758),
            vector3(-1820.7017822266, 792.45837402344, 138.11625671387),
            vector3(1163.2659912109, -323.79348754883, 69.205131530762),
            vector3(-48.62088394165, -1757.5234375, 29.421007156372),
            vector3(-707.43231201172, -914.62829589844, 19.215587615967),
            vector3(1165.9293212891, 2708.8120117188, 38.157688140869),
            vector3(1135.9046630859, -982.16296386719, 46.415824890137),
            vector3(-1223.0776367188, -906.86096191406, 12.326356887817),
            vector3(-1487.6353759766, -379.21444702148, 40.163391113281),
            vector3(-2968.3854980469, 390.94171142578, 15.043313026428),
            vector3(2679.1481933594, 3280.5629882813, 55.24112701416),
            vector3(1729.4488525391, 6414.3920898438, 35.037242889404),
            vector3(1961.5560302734, 3740.8024902344, 32.34375),
            vector3(547.24462890625, 2671.1149902344, 42.156513214111),
            vector3(-3241.8850097656, 1001.4508666992, 12.830711364746),
            vector3(-3039.0048828125, 586.11285400391, 7.9089303016663),
            vector3(2557.4396972656, 382.37594604492, 108.62294006348),
            vector3(26.134149551392, -1347.6729736328, 29.497022628784),
            vector3(374.05386352539, 325.85147094727, 103.56637573242)
        }

    -- Check if the current market position is one of the desired positions
        local isDesiredPosition = false
        for _, position in ipairs(desiredPositions) do
            if position == marketData["marketPos"] then
                isDesiredPosition = true
             break
            end
        end
        if isDesiredPosition then
            Heap["blips"][marketName] = AddBlipForCoord(marketData["marketPos"])
            
            SetBlipDisplay(Heap["blips"][marketName], 4)
            SetBlipScale(Heap["blips"][marketName], 0.8)
            SetBlipAsShortRange(Heap["blips"][marketName], true)
            SetBlipSprite(Heap["blips"][marketName], 52)

            BeginTextCommandSetBlipName("STRING")
        end
        local storeType = Config.WhatStore(marketName)

        for i=1, 2 do
            local doorHash = Config.MarketSettings[storeType]["doors"][i == 1 and "left" or "right"]
            local objects = X.GetObjects()

            for _, doorEntity in ipairs(objects) do
                local doorLocation = GetEntityCoords(doorEntity)
                local dstCheck = #(marketData["marketPos"] - doorLocation)
                local model = GetEntityModel(doorEntity)        
        
                if DoesEntityExist(doorEntity) and dstCheck <= 15.0 and model == doorHash then
                    Heap["doors"][marketName] = {}
                    Heap["doors"][marketName][doorEntity] = true
                    
                    exports["x-context"]:AddCustomMenu(doorEntity, function()					
                        local options = {}

                        table.insert(options, {
                            ["label"] = "~o~Dörr"
                        })
                        
                        table.insert(options, {
                            ["label"] = Heap["doors"][marketName][doorEntity] and "~g~Lås upp" or "~r~Lås",
                            ["callback"] = function()
                                GlobalFunction("UPDATE_DOORSTATE", {
                                    ["marketName"] = marketName,
                                    ["doorEntity"] = doorEntity,
                                    ["doorState"] = not Heap["doors"][marketName][doorEntity]
                                })
                            end
                        })
                        
                        exports["x-context"]:OpenContextMenu({
                            menu = marketName .. "-" .. doorEntity,
                            entity = doorEntity,
                            options = options
                        })
                    end)
                end
            end
        end

        if Heap["markets"][marketName] then
            SetBlipColour(Heap["blips"][marketName], 3)

            AddTextComponentString(Heap["markets"][marketName]["customName"] or marketName)
        else
            SetBlipColour(Heap["blips"][marketName], 1)

            AddTextComponentString("Affär - " .. storeType)
        end

        if Heap["markets"][marketName] and Heap["markets"][marketName]["marketOwner"] == X.Character.Data.characterId then
            SetBlipCategory(Heap["blips"][marketName], 11)
        else
            SetBlipCategory(Heap["blips"][marketName], 10)
        end

        EndTextCommandSetBlipName(Heap["blips"][marketName])

        if marketData["cashier"] then
            if Heap["markets"][marketName] and Heap["markets"][marketName]["marketState"] ~= "locked" or not Heap["markets"][marketName] then
                marketData["cashier"]["callback"] = function(pedEntity)
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
                                marketData["callback"](marketName, marketData)
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
                    Heap["peds"][marketName] = exports["x-pedstream"]:ConstructPed(marketData["cashier"])
                end
            end

            local interiorId = GetInteriorAtCoords(marketData["cashier"]["position"])
                
            Heap["interiorIds"][marketName] = interiorId
        end

        Wait(250)
    end
    
    Config.Seller["pedData"]["callback"] = function(pedEntity)
       TaskTurnPedToFaceEntity(PlayerPedId(), pedEntity, 750)
       TaskTurnPedToFaceEntity(pedEntity, PlayerPedId(), 750)
    
       local options = {}
    
       table.insert(options, {
           ["label"] = "Försäljare"
       })
    
       table.insert(options, {
           ["label"] = "Prata",
           ["action"] = "use",
           ["callback"] = function()
               OpenBuyMenu()
           end
       })
    
        exports["x-context"]:OpenContextMenu({
           ["menu"] = "Store Seller-" .. pedEntity,
           ["entity"] = pedEntity,
           ["options"] = options
        })
    end
    
    if not Heap["peds"]["seller"] or not DoesEntityExist(Heap["peds"]["seller"]["handle"]) then
       Heap["peds"]["seller"] = exports["x-pedstream"]:ConstructPed(Config.Seller["pedData"])
    end
end

UpdateMarkets = function()
    X.Callback("x-markets:fetchMarkets", function(fetchedCache)
        if fetchedCache then
            Heap["markets"] = fetchedCache["markets"]

        end

        for marketName, marketData in pairs(Config.Markets) do
            BeginTextCommandSetBlipName("STRING")
            
            if Heap["markets"][marketName] then
                SetBlipColour(Heap["blips"][marketName], 3)
                
                AddTextComponentString(Heap["markets"][marketName]["customName"] or marketName)
            else
                SetBlipColour(Heap["blips"][marketName], 1)
                
                AddTextComponentString("Affär-"..marketName)
            end
            
            if Heap["markets"][marketName] and Heap["markets"][marketName]["marketOwner"] == X.Character.Data.characterId then
                SetBlipCategory(Heap["blips"][marketName], 11)
            else
                SetBlipCategory(Heap["blips"][marketName], 10)
            end
            
            EndTextCommandSetBlipName(Heap["blips"][marketName])
        end
    end)
end