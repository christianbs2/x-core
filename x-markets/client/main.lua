X = false

Heap = {
    ["markets"] = {},
    ["peds"] = {},
    ["cashBag"] = {},
    ["blips"] = {},
    ["doors"] = {},
    ["interiorIds"] = {},
    ["addedMenu"] = false,
    ["robbedMarkets"] = {},
    ["ongoingRobberies"] = {},
    ["cashRegisters"] = {},
    ["robbedRegisters"] = {},
    Cracking = false
}

safeLocks = {}
currentSafeCorrectPosition = 0.0
oldSafeCorrectPosition = 0.0
dialRotation = 0.0

Citizen.CreateThread(function()
    while not X do
        Citizen.Wait(10)

        X = exports["x-core"]:FetchMain()
    end

    if exports["x-character"]:IsLoaded() then
        Initialize()
    end
end)

RegisterNetEvent("x-character:characterLoaded")
AddEventHandler("x-character:characterLoaded", function(response)
    X.Character.Data = response

    Initialize()
end)

RegisterNetEvent("x-character:jobUpdated")
AddEventHandler("x-character:jobUpdated", function(newData)
    X.Character.Data.Job = newData
end)

Citizen.CreateThread(function()
    Citizen.Wait(150)

    while true do
        local sleepThread = 5000

        local ped = PlayerPedId()

        if Heap["ped"] ~= ped then
            Heap["ped"] = ped
        end

        Citizen.Wait(sleepThread)
    end
end)

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        for pedHandle, pedData in pairs(Heap["peds"]) do
            pedData["destroy"]()
        end
    end
end)

RegisterNetEvent("x-markets:updateMarkets")
AddEventHandler("x-markets:updateMarkets", function()
    Wait(1000)
    UpdateMarkets()
end)

RegisterNetEvent("x-markets:updateState")
AddEventHandler("x-markets:updateState", function(state)
    Heap["marketClosed"] = state
end)

RegisterNetEvent("x-markets:officerCount")
AddEventHandler("x-markets:officerCount", function(officerCount)
    Heap["officerCount"] = officerCount
end)

RegisterNetEvent("x-markets:eventHandler")
AddEventHandler("x-markets:eventHandler", function(event, eventData)
    if event == "UPDATE_DOORSTATE" then
        if Heap["markets"][eventData["marketName"]] then
            Heap["markets"][eventData["marketName"]]["marketState"] = eventData["doorState"] and "locked" or "unlocked"
        else
            Heap["doors"][eventData["marketName"]][eventData["doorHash"]]["doorState"] = eventData["doorState"]
        end
    elseif event == "MARKET_STATE_HANDLER" then
        MarketStateHandler(eventData["marketName"])
    elseif event == "LOCKPICK_CASH_REGISTER" then
        if not Heap["cashRegisters"][eventData["marketName"]] then
            Heap["cashRegisters"][eventData["marketName"]] = {}
        end

        Heap["cashRegisters"][eventData["marketName"]][tostring(eventData["registerCoords"])] = true

        OpenRegister(eventData["marketName"], eventData["registerCoords"])
    elseif event == "ROB_CASH_REGISTER" then
        RobRegister(eventData)
    elseif event == "BUST_MARKET_DOOR" then
        Heap["doors"][eventData["marketName"]][eventData["doorHash"]]["bustedDoor"] = true

        if Heap["markets"][eventData["marketName"]] then
            Heap["markets"][eventData["marketName"]]["marketState"] = eventData["doorState"] and "locked" or "unlocked"
        end

        Heap["ongoingRobberies"][eventData["marketName"]] = true

        Heap["doors"][eventData["marketName"]][eventData["doorHash"]]["doorState"] = eventData["doorState"]

        AlarmPolice(eventData["marketName"])
    elseif event == "CASHIER_ROB_ANIMATION_START" then
        if Heap["peds"][eventData["marketName"]] then
            PlayAnimation(Heap["peds"][eventData["marketName"]]["handle"], "mp_am_hold_up", "handsup_base", { ["flag"] = 11 })

            Heap["peds"][eventData["marketName"]]["beingRobbed"] = eventData["playerId"]

            if not Heap["alarmSent"] then
                AlarmPolice(eventData["marketName"], true)
            
                Heap["alarmSent"] = true
            end
        end
    elseif event == "SILENT_MARKET_ALARM" then
        AlarmPolice(eventData["marketName"], true)
    elseif event == "CASHIER_ROB_ANIMATION_CANCEL" then
        if Heap["peds"][eventData["marketName"]] then
            Heap["peds"][eventData["marketName"]]["beingRobbed"] = false
            ClearPedTasks(Heap["peds"][eventData["marketName"]]["handle"])
        end
    elseif event == "START_ROB_CASH_SEQUENCE" then
        if Heap["peds"][eventData["marketName"]] then
            if not Heap["peds"][eventData["marketName"]]["cashSequence"] then
                RobCashSequence(eventData)
            end
        end
    elseif event == "UPDATE_ROB_STATE" then
        if Heap["peds"][eventData["marketName"]] then
            Heap["peds"][eventData["marketName"]]["beingRobbed"] = eventData["playerId"]
        end
    elseif event == "PICKUP_BAG" then
        if Heap["cashBag"] and Heap["cashBag"][eventData["marketName"]] and DoesEntityExist(Heap["cashBag"][eventData["marketName"]]) then
            DeleteEntity(Heap["cashBag"][eventData["marketName"]])
        end
    elseif event == "ROBBED_MARKET" then
        Heap["robbedMarkets"][eventData["marketName"]] = true

        if Heap["markets"][eventData["marketName"]] then
            SetBlipColour(Heap["blips"][eventData["marketName"]], 3)
        else
            SetBlipColour(Heap["blips"][eventData["marketName"]], 1)
        end
    elseif event == "BREAK_SAFE" then
        if not Heap.CurrentlyBeingRobbed then Heap.CurrentlyBeingRobbed = {} end

        table.insert(Heap.CurrentlyBeingRobbed, {name = eventData.Name})
    elseif event == "OPEN_DOOR" then
        ControlDoor(false, eventData.Store)
    elseif event == "ALARM_POLICE" then
        AlarmPolice(eventData.Location)
    end
end)

Citizen.CreateThread(function()
    local greeted = false
    local ciao = true
    local latestPed

    while true do

        local sleepThread = 500
        local ped = Heap["ped"]
        local pedCoords = GetEntityCoords(ped)
        local interiorId = GetInteriorFromEntity(ped)

        if interiorId ~= 0 then
            for marketName, marketInterior in pairs(Heap["interiorIds"]) do
                if interiorId == marketInterior then
                    if Heap["peds"][marketName] and not greeted then
                        PlayAmbientSpeech1(Heap["peds"][marketName]["handle"], "SHOP_GREET", "SPEECH_PARAMS_FORCE")
                        greeted = true
                        ciao = false
                        latestPed = Heap["peds"][marketName]["handle"]
                    end

                    if not Heap["addedMenu"] then
                        Heap["addedMenu"] = {}

                        AddMarketContext(marketName, pedCoords)
                    end

                    for marketRobberyName, ongoingRobbery in pairs(Heap["ongoingRobberies"]) do
                    	if marketName == marketRobberyName then
                    		AddRobberyContext(marketName)
                    	end
                    end
                end
            end
        else
            if Heap["shopping"] then
                Heap["shopping"] = false
                Heap["shoppingCart"] = {}
                X.Notify("Kassör", "Din kundvagn tömdes eftersom du gick ur butiken. Välkommen Åter!", 5000, "warning")
            end

            if latestPed and not ciao and #(pedCoords - GetEntityCoords(latestPed)) <= 20.0 then
                PlayAmbientSpeech1(latestPed, "SHOP_GOODBYE", "SPEECH_PARAMS_FORCE")
                greeted = false
                ciao = true
                latestPed = nil
            end

            Heap["addedMenu"] = false
        end

        Citizen.Wait(sleepThread)
    end
end)

Citizen.CreateThread(function()
    local hasKey = false

    while true do

        local sleepThread = 500
        local ped = Heap["ped"]
        local pedCoords = GetEntityCoords(ped)

        for marketName, marketData in pairs(Config.Markets) do
            local dstCheck = #(pedCoords - marketData["marketPos"])
            local storeType = Config.WhatStore(marketName)

            if dstCheck <= 15.0 then
                for i=1, 2 do
                    local doorHash = Config.MarketSettings[storeType]["doors"][i == 1 and "left" or "right"]
                    local doorEntity = GetClosestObjectOfType(pedCoords, 10.0, doorHash)
                    local doorCoords = GetEntityCoords(doorEntity)
                    local marketClosed = ClosingHour(marketName)

                    if not Heap["doors"][marketName] then
                        Heap["doors"][marketName] = {}
                    end

                    if DoesEntityExist(doorEntity) then
                        if not IsDoorRegisteredWithSystem(doorEntity) then
                            AddDoorToSystem(doorEntity, doorHash, doorCoords, true, false, true)

                            if not Heap["doors"][marketName][doorHash] then
                                Heap["doors"][marketName][doorHash] = {}
                                Heap["doors"][marketName][doorHash]["doorState"] = marketClosed
                            end
                        end

                        if Heap["markets"][marketName] and Heap["doors"][marketName][doorHash] then
                            Heap["doors"][marketName][doorHash]["doorState"] = Heap["markets"][marketName]["marketState"] == "locked" and true or false
                        else
                            if storeType == "247" then
                                if Heap["doors"][marketName][doorHash] then
                                    Heap["doors"][marketName][doorHash]["doorState"] = false
                                end
                            else
                                if Heap["doors"][marketName][doorHash] and not Heap["doors"][marketName][doorHash]["bustedDoor"] then
                                    Heap["doors"][marketName][doorHash]["doorState"] = marketClosed
                                end
                            end
                        end

                        if Heap["doors"][marketName][doorHash] then
                            if DoorSystemGetDoorState(doorEntity) ~= Heap["doors"][marketName][doorHash]["doorState"] or not Heap["doors"][marketName][doorHash]["bustedDoor"] then
                                DoorSystemSetDoorState(doorEntity, Heap["doors"][marketName][doorHash]["doorState"], true, true)
                            end
                        else
                            Heap["doors"][marketName][doorHash] = {}
                        end

                        exports["x-context"]:AddCustomMenu(doorEntity, function()
                            local options = {}

                            table.insert(options, {
                                ["label"] = "~o~Dörr"
                            })

                            table.insert(options, {
                                ["label"] = Heap["doors"][marketName][doorHash]["doorState"] and "~g~Lås upp" or "~r~Lås",
                                ["callback"] = function()
                                    if hasKey or (Heap["markets"][marketName] and Heap["markets"][marketName]["marketOwner"] == X.Character.Data.characterId) then
                                        GlobalFunction("UPDATE_DOORSTATE", {
                                            ["marketName"] = marketName,
                                            ["doorHash"] = doorHash,
                                            ["doorState"] = not Heap["doors"][marketName][doorHash]["doorState"]
                                        })
                                    else
                                        X.Notify("Dörr", "Du kan ej låsa upp denna dörr!", 5000, "error")
                                    end
                                end
                            })

                            if Heap["doors"][marketName][doorHash]["doorState"] and exports["x-inventory"]:GetItemInHand() and exports["x-inventory"]:GetItemInHand()["Name"] == "crowbar" then
                                table.insert(options, {
                                	["label"] = "Bryt upp dörr",
                                	["callback"] = function()
                                		BustOpenDoor(marketName, doorEntity, doorHash)
                                	end
                                })
                            end

                            exports["x-context"]:OpenContextMenu({
                                menu = marketName .. "-" .. doorEntity,
                                entity = doorEntity,
                                options = options
                            })
                        end)
                    end
                end
            end
        end

        Citizen.Wait(sleepThread)
    end
end)

Citizen.CreateThread(function()

    while true do

        local sleepThread = 2500

        for marketName, marketData in pairs(Config.Markets) do

            if not Heap["markets"][marketName] then
                local marketClosed = ClosingHour(marketName)

                if marketClosed then
                    if Heap["peds"][marketName] and DoesEntityExist(Heap["peds"][marketName]["handle"]) then
                        DeleteEntity(Heap["peds"][marketName]["handle"])
                        Heap["peds"][marketName] = nil
                    end
                else
                    if not Heap["peds"][marketName] then
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

                        Heap["peds"][marketName] = exports["x-pedstream"]:ConstructPed(marketData["cashier"])
                    end
                end
            end
        end

        Citizen.Wait(sleepThread)
    end
end)

Citizen.CreateThread(function()
    local hasAimed = false
    local lastAimed

    Citizen.Wait(500)

    while true do

        local sleepThread = 500

        if Heap["officerCount"] and Heap["officerCount"] >= Config.OfficersNeeded or Config.EnableDebug then
            local ped = Heap["ped"]
            local interiorId = GetInteriorFromEntity(ped)
            local player = PlayerId()

            for marketName, marketInterior in pairs(Heap["interiorIds"]) do
                if interiorId == marketInterior then
                    if Heap["peds"][marketName] and not IsPedDeadOrDying(Heap["peds"][marketName]["handle"]) then
                        sleepThread = 5

                        local marketPed = Heap["peds"][marketName]["handle"]

                        local isAiming, entityFound, entityAimingAt = IsPlayerFreeAiming(player), GetEntityPlayerIsFreeAimingAt(player)

                        local meleeAiming, aimingPed = GetPlayerTargetEntity(player)

                        local aiming = isAiming and entityFound or (meleeAiming and aimingPed == marketPed)

                        local currWeap, currWeaponHash = GetCurrentPedWeapon(PlayerPedId(), 1)

                        local isArmed = IsPedArmed(ped, 5) and currWeaponHash ~= GetHashKey("WEAPON_CROWBAR") and currWeaponHash ~= GetHashKey("WEAPON_MUSKET")

                        if isArmed then
                            if aiming and (entityAimingAt == marketPed or meleeAiming and aimingPed == marketPed) then
                                if not Heap["peds"][marketName]["beingRobbed"] or Heap["peds"][marketName]["beingRobbed"] == GetPlayerServerId(player) then
                                    hasAimed = true
                                    lastAimed = GetGameTimer()

                                    if not IsEntityPlayingAnim(marketPed, "mp_am_hold_up", "handsup_base", 3) then
                                        GlobalFunction("CASHIER_ROB_ANIMATION_START", {
                                            ["marketName"] = marketName,
                                            ["playerId"] = GetPlayerServerId(player)
                                        })
                                    end
                                end
                            elseif not isAiming and lastAimed and GetGameTimer() - lastAimed > 5000 and hasAimed then
                                GlobalFunction("CASHIER_ROB_ANIMATION_CANCEL", {
                                    ["marketName"] = marketName
                                })

                                hasAimed = false
                            end
                        end
                    end
                end
            end
        end

        Citizen.Wait(sleepThread)
    end
end)