BustOpenDoor = function(marketName, doorEntity, doorHash)
    while not HasAnimDictLoaded("missheistfbisetup1") do
        RequestAnimDict("missheistfbisetup1")

        Citizen.Wait(0)
    end

    local offsetCoords = GetOffsetFromEntityInWorldCoords(doorEntity, -1.0, -0.4, 0.0)
    local inDestination = X.GotoPlace(Heap["ped"], offsetCoords, 1.0, -1, GetEntityHeading(doorEntity), 0.1)

    if inDestination then
        Citizen.Wait(100)

        TaskPlayAnim(Heap["ped"], "missheistfbisetup1", "unlock_loop_janitor", 1.0, 1.0, -1, 1)

        DrawBusySpinner("Bryter upp dörr...")

        Citizen.Wait(math.random(Config.BustTime[1], Config.BustTime[2]))

        RemoveLoadingPrompt()

        ClearPedTasks(Heap["ped"])

        GlobalFunction("BUST_MARKET_DOOR", {
            ["marketName"] = marketName,
            ["doorHash"] = doorHash,
            ["doorState"] = false,
            ["save"] = true,
            ["data"] = Heap["doors"]
        })
    end
end

AlarmPolice = function(location)
    if not X then return end

    if X.Character.Data and X.Character.Data.job and X.Character.Data.job.name == "police" and exports["x-duty"]:IsCharacterInDuty() then
        Citizen.CreateThread(function()
            local timer = GetGameTimer()
            
            X.Notify("Butikslarm", "Larmet på en affär har gått, markering finns på GPS:en!", 10000, "warning")

            local blip = CreateScriptBlip({
                Location = location,
                Label = "Butikslarm",
                Sprite = 161,
                Scale = 0.8,
                Colour = 2,
                ShortRange = false
            })

            SetTimeout(60000 * 5, function()
                RemoveBlip(blip)
            end)
        end)
    end
end

AddRobberyContext = function(marketName)
    local ped = Heap["ped"]
    local pedCoords = GetEntityCoords(ped)
    
    local objects = X.GetObjects()
    local storeType = Config.WhatStore(marketName)
    local cashRegisterHash = Config.MarketSettings[storeType]["cashRegister"]
    
    for _, cashRegisterEntity in ipairs(objects) do
        local registerCoords = GetEntityCoords(cashRegisterEntity)
        local dstCheck = #(pedCoords - registerCoords)
        local model = GetEntityModel(cashRegisterEntity)

        if DoesEntityExist(cashRegisterEntity) and dstCheck <= 10.0 and not Heap["addedMenu"][cashRegisterEntity] then
            if model == cashRegisterHash then
                exports["x-context"]:AddCustomMenu(cashRegisterEntity, function()
                    local options = {}
                    local holdingCrowbar = exports["x-inventory"]:GetItemInHand() and exports["x-inventory"]:GetItemInHand()["Name"] == "crowbar"
                    local isOpened = Heap["cashRegisters"][marketName] and Heap["cashRegisters"][marketName][tostring(GetEntityCoords(cashRegisterEntity))]

                    table.insert(options, {
                        ["label"] = "~y~Kassaapparat"
                    })

                    if not Heap["robbedRegisters"][marketName] or Heap["robbedRegisters"][marketName] and not Heap["robbedRegisters"][marketName][tostring(registerCoords)] then
                        if holdingCrowbar and not isOpened then
                            table.insert(options, {
                                ["label"] = "~r~Bryt upp",
                                ["callback"] = function()
                                    LockPickRegister(marketName, cashRegisterEntity)
                                end
                            })
                        else
                            if isOpened then
                                table.insert(options, {
                                    ["label"] = "~g~Ta pengar",
                                    ["callback"] = function()
                                        RobCashRegister(marketName, cashRegisterEntity)
                                    end
                                })
                            else
                                table.insert(options, {
                                    ["label"] = "~r~Låst"
                                })
                            end
                        end
                    else
                        table.insert(options, {
                            ["label"] = "~o~Tomt"
                        })
                    end
                        
                    exports["x-context"]:OpenContextMenu({
                        menu = marketName .. "-" .. cashRegisterEntity,
                        entity = cashRegisterEntity,
                        options = options
                    })
                end)

                Heap["addedMenu"][cashRegisterEntity] = true
            end
        end
    end
end

RobCashRegister = function(marketName, cashRegisterEntity)
    local registerCoords = GetEntityCoords(cashRegisterEntity)
    
    if not Heap["robbedRegisters"][tostring(registerCoords)] then
        Citizen.CreateThread(function()
            local offsetCoords = GetOffsetFromEntityInWorldCoords(cashRegisterEntity, 0.0, -0.6, 0.0)
            local inDestination = X.GotoPlace(Heap["ped"], offsetCoords, 1.0, -1, GetEntityHeading(cashRegisterEntity), 1.0)

            if inDestination then
                local dict = "oddjobs@shop_robbery@rob_till"
                local enterTime, exitTime = GetAnimDuration(dict, "enter"), GetAnimDuration(dict, "exit")
                
                DrawBusySpinner("Plockar pengar...")

                while not HasAnimDictLoaded(dict) do
                    RequestAnimDict(dict)
            
                    Citizen.Wait(0)
                end
                
                TaskPlayAnim(Heap["ped"], dict, "enter", 1.0, 1.0, -1, 0)

                Citizen.Wait(enterTime * 1000)

                TaskPlayAnim(Heap["ped"], dict, "loop", 1.0, 1.0, -1, 1)

                Citizen.Wait(15000)

                TaskPlayAnim(Heap["ped"], dict, "exit", 1.0, 1.0, -1, 0)

                Citizen.Wait(exitTime * 1000)

                RemoveLoadingPrompt()

                GlobalFunction("ROB_CASH_REGISTER", {
                    ["marketName"] = marketName,
                    ["save"] = true,
                    ["registerCoords"] = registerCoords
                })
                
                X.Callback("x-markets:robMarket", function(amount)
                    if amount then
                        X.Notify("Kassaapparat", "Du snodde " .. amount .. " kr.", 5000, "success")
                    end
                end, marketName)
            end
        end)
    end
end

LockPickRegister = function(marketName, cashRegisterEntity)
    Citizen.CreateThread(function()
        local offsetCoords = GetOffsetFromEntityInWorldCoords(cashRegisterEntity, 0.0, -0.6, 0.0)
        local inDestination = X.GotoPlace(Heap["ped"], offsetCoords, 1.0, -1, GetEntityHeading(cashRegisterEntity), 1.0)

        if inDestination then
            while not HasAnimDictLoaded("missheistfbisetup1") do
                RequestAnimDict("missheistfbisetup1")
        
                Citizen.Wait(0)
            end
            
            TaskPlayAnim(Heap["ped"], "missheistfbisetup1", "unlock_loop_janitor", 1.0, 1.0, -1, 1)

            DrawBusySpinner("Bryter upp...")

            Citizen.Wait(20000)

            RemoveLoadingPrompt()

            ClearPedTasks(Heap["ped"])

            X.Notify("Affär", "Du bröt upp kassapparaten!", 5000, "success")

            GlobalFunction("LOCKPICK_CASH_REGISTER", {
                ["marketName"] = marketName,
                ["save"] = true,
                ["registerCoords"] = GetEntityCoords(cashRegisterEntity)
            })
        end
    end)
end

OpenRegister = function(marketName, registerCoords)
    local objects = X.GetObjects()
    local storeType = Config.WhatStore(marketName)
    local cashRegisterHash = Config.MarketSettings[storeType]["cashRegister"]

    for _, cashRegisterEntity in ipairs(objects) do
        local dstCheck = #(registerCoords - GetEntityCoords(cashRegisterEntity))
        local model = GetEntityModel(cashRegisterEntity)
        
        if DoesEntityExist(cashRegisterEntity) and dstCheck <= 1.0 then
            if model == cashRegisterHash then
                CreateModelSwap(GetEntityCoords(cashRegisterEntity), 1.0, GetHashKey("prop_till_01"), GetHashKey("prop_till_01_dam"))
            end
        end
    end
end

RobRegister = function(eventData)
    local objects = X.GetObjects()
    local cashRegisterHash = GetHashKey("prop_till_01_dam")

    for _, cashRegisterEntity in ipairs(objects) do
        local dstCheck = #(eventData["registerCoords"] - GetEntityCoords(cashRegisterEntity))
        local model = GetEntityModel(cashRegisterEntity)

        if DoesEntityExist(cashRegisterEntity) and dstCheck <= 1.0 then
            if model == cashRegisterHash then
                if not Heap["robbedRegisters"][eventData["marketName"]] then
                    Heap["robbedRegisters"][eventData["marketName"]] = {}
                end

                Heap["robbedRegisters"][eventData["marketName"]][tostring(eventData["registerCoords"])] = true
            end
        end

    end
end

RobCashSequence = function(eventData)
    if not Heap["peds"][eventData["marketName"]] then return end
    if #(GetEntityCoords(Heap["ped"]) - Config.Markets[eventData["marketName"]]["marketPos"]) >= 75.0 then return end
    
    Heap["peds"][eventData["marketName"]]["cashSequence"] = true

    while not HasAnimDictLoaded("mp_am_hold_up") do
        RequestAnimDict("mp_am_hold_up")
        
        Citizen.Wait(0)
    end

    PlayAnimation(Heap["peds"][eventData["marketName"]]["handle"], "mp_am_hold_up", "handsup_base", 49)

    FreezeEntityPosition(Heap["peds"][eventData["marketName"]]["handle"])
end

Citizen.CreateThread(function()
    while not X do 
        Citizen.Wait(5)
    end

    while true do 
        local sleepThread = 500 
        local playerPed = PlayerPedId()
        local safeEntity = GetClosestObjectOfType(GetEntityCoords(playerPed), 5.0, -1346995970, false, false, false)
        local closestStore = GetClosestStore()

        if safeEntity and DoesEntityExist(safeEntity) and closestStore and closestStore.Distance <= 50.0 and IsStoreBeingHoldup(closestStore.Name) then
            local safeCoords = GetEntityCoords(safeEntity) 
            local distanceCheck = #(GetEntityCoords(playerPed) - safeCoords)

            if distanceCheck <= 1.5 then
                sleepThread = 5

                local displayText = Heap.Cracking and "Låser upp..." or "~INPUT_CONTEXT~ Försök att låsa upp."

                X.Hint(displayText)

                if IsControlJustReleased(0, 38) then 
                    CrackSafe(safeEntity, closestStore)
                end
            end
        end
        Citizen.Wait(sleepThread)
    end
end)

--AKTIVERA NEDAN STÅENDE FÖR REPUTATION HOS RÅN SNUBBEN
-- Citizen.CreateThread(function()
--     local reputation = tonumber(exports["x-relationship"]:GetRelation("RÅN"))
--     local relationAdded = false
--     local lastAddTime = 0
--     local cooldownTime = 5 * 60 * 1000 -- 5 minutes in milliseconds

--     while not X do 
--         Citizen.Wait(5)
--     end

--     while true do 
--         local sleepThread = 500 
--         local playerPed = PlayerPedId()
--         local safeEntity = GetClosestObjectOfType(GetEntityCoords(playerPed), 5.0, -1346995970, false, false, false)
--         local closestStore = GetClosestStore()

--         if safeEntity and DoesEntityExist(safeEntity) and closestStore and closestStore.Distance <= 50.0 and IsStoreBeingHoldup(closestStore.Name) then
--             local safeCoords = GetEntityCoords(safeEntity) 
--             local distanceCheck = #(GetEntityCoords(playerPed) - safeCoords)

--             if distanceCheck <= 1.5 then
--                 sleepThread = 5
--                 if reputation < 25 then 
--                     return X.Notify("Rånare", "Du känner dig inte redigt redo för detta än!", 5000, "error")  
--                 elseif reputation >= 25 and reputation < 100 and not relationAdded then
--                     if reputation >= 25 and reputation < 49 then
--                         local displayText = Heap.Cracking and "Låser upp..." or "~y~E~ Försök att låsa upp."

--                         X.Hint(displayText)

--                         if IsControlJustReleased(0, 38) then 
--                             if GetGameTimer() - lastAddTime >= cooldownTime then
--                                 CrackSafe(safeEntity, closestStore)
--                                 exports["x-relationship"]:AddRelationINBROTT("RÅN")
--                                 relationAdded = true  
--                                 lastAddTime = GetGameTimer()
--                             else
--                                 CrackSafe(safeEntity, closestStore)
--                             end
--                         end
--                     elseif reputation >= 50 and reputation < 74 then
--                         local displayText = Heap.Cracking and "Låser upp..." or "~y~E~ Försök att låsa upp."

--                         X.Hint(displayText)

--                         if IsControlJustReleased(0, 38) then 
--                             if GetGameTimer() - lastAddTime >= cooldownTime then
--                                 CrackSafe(safeEntity, closestStore)
--                                 exports["x-relationship"]:AddRelationSELL("RÅN")
--                                 relationAdded = true  
--                                 lastAddTime = GetGameTimer()
--                             end
--                         end
--                     elseif reputation >= 75 and reputation < 100 then
--                         local displayText = Heap.Cracking and "Låser upp..." or "~y~E~ Försök att låsa upp."

--                         X.Hint(displayText)

--                         if IsControlJustReleased(0, 38) then 
--                             if GetGameTimer() - lastAddTime >= cooldownTime then
--                                 CrackSafe(safeEntity, closestStore)
--                                 exports["x-relationship"]:AddRelationSELL("RÅN")
--                                 relationAdded = true  
--                                 lastAddTime = GetGameTimer()
--                             end
--                         end
--                     elseif reputation >= 49 and reputation < 50 then
--                         local displayText = Heap.Cracking and "Låser upp..." or "~y~E~ Försök att låsa upp."

--                         X.Hint(displayText)

--                         if IsControlJustReleased(0, 38) then 
--                             if GetGameTimer() - lastAddTime >= cooldownTime then
--                                 CrackSafe(safeEntity, closestStore)
--                                 X.Notify("Rånare", "Kom till mig när du har tid att prata!", 5000, "success") 
--                             end
--                         end
--                     elseif reputation >= 74 and reputation < 75 then
--                         local displayText = Heap.Cracking and "Låser upp..." or "~y~E~ Försök att låsa upp."

--                         X.Hint(displayText)

--                         if IsControlJustReleased(0, 38) then 
--                             if GetGameTimer() - lastAddTime >= cooldownTime then
--                                 CrackSafe(safeEntity, closestStore)
--                                 X.Notify("Rånare", "Kom till mig när du har tid att prata!", 5000, "success") 
--                             end
--                         end
--                     end

--                 end
--             else
--                 relationAdded = false
--             end
--         end
--         Citizen.Wait(sleepThread)
--     end
-- end)

GetClosestStore = function()
    local closestStore

    for storeIndex, storeData in pairs(Config.Markets) do 
        local dstCheck = #(GetEntityCoords(PlayerPedId()) - storeData.marketPos)
        if dstCheck <= 25.0 then 
            closestStore = {
                Distance = dstCheck, 
                Name = storeIndex,
                Data = storeData
            }

            break
        end
    end

    return closestStore 
end

CrackSafe = function(safeEntity, store)
    X.Callback("x-markets:canRobSafe", function(robbed) 
        if not robbed then
            GlobalFunction("BREAK_SAFE", {
                Store = store.Name,
                save = true
            })

            StartCrackingSafe(safeEntity)
        else
            X.Notify("Kassaskåp", "Detta kassaskåp är redan rånat.", 5000, "error")

            ControlDoor(false, store.Name)
        end
    end, store.Name)
end

IsStoreBeingHoldup = function(storeName)
    if Config.EnableDebug then
        return true
    end

    if Heap.peds and Heap.peds[storeName] and Heap.peds[storeName]["handle"] and IsEntityPlayingAnim(Heap.peds[storeName]["handle"], "mp_am_hold_up", "handsup_base", 3) and Heap.peds[storeName]["beingRobbed"] ~= GetPlayerServerId(PlayerId()) then
        return true  
    else
        return false 
    end
end

--Qalle

StartCrackingSafe = function(safeEntity)
    if Heap.Cracking then
        return
    end

    Heap.Cracking = true

    currentSafeCorrectPosition = math.random(1, 350)

    while not HasStreamedTextureDictLoaded("MPSafeCracking") do
        Citizen.Wait(0)

        RequestStreamedTextureDict("MPSafeCracking", false) 
    end

    RequestAmbientAudioBank("SAFE_CRACK", false)

    while not HasAnimDictLoaded("mini@safe_cracking") do
        Citizen.Wait(0)

        RequestAnimDict("mini@safe_cracking")
    end

    TaskPlayAnim(PlayerPedId(), "mini@safe_cracking", "dial_turn_clock_normal", 0.5, 1.0, -1, 11, 0.0, 0, 0, 0)

    HandleControls(safeEntity)

    Citizen.CreateThread(function()
        while Heap.Cracking do
            Citizen.Wait(0)

            DrawSprite("MPSafeCracking", "Dial_BG", 0.5, 0.4, 0.2, 0.3, 0.0, 255, 255, 255, 255)
            DrawSprite("MPSafeCracking", "Dial", 0.5, 0.4, 0.2 * 0.5, 0.3 * 0.5, dialRotation, 255, 255, 255, 255)

            DrawButtons({
                {
                    ["label"] = "Höger snabbt",
                    ["button"] = "~INPUT_CELLPHONE_RIGHT~"
                },
                {
                    ["label"] = "Höger sakta",
                    ["button"] = "~INPUT_CELLPHONE_DOWN~"
                },
                {
                    ["label"] = "Vänster sakta",
                    ["button"] = "~INPUT_CELLPHONE_UP~"
                },
                {
                    ["label"] = "Vänster snabbt",
                    ["button"] = "~INPUT_CELLPHONE_LEFT~"
                },
                {
                    ["label"] = "Testa (Vid fel, startas det om)",
                    ["button"] = "~INPUT_JUMP~"
                },
                {
                    ["label"] = "Avbryt",
                    ["button"] = "~INPUT_DETONATE~"
                }
            })

            if not IsEntityPlayingAnim(PlayerPedId(), "mini@safe_cracking", "dial_turn_clock_normal", 3) and Heap.Cracking then
                TaskPlayAnim(PlayerPedId(), "mini@safe_cracking", "dial_turn_clock_normal", 0.5, 1.0, -1, 11, 0.0, 0, 0, 0)
            end

            for i = 1, Config.TotalLocks do
                local lockState = safeLocks[i] and "lock_open" or "lock_closed"

                DrawSprite("MPSafeCracking", lockState, 0.7 - ((Config.TotalLocks - i) / 10 / 2), 0.6, 0.2 * 0.2, 0.3 * 0.2, 0.0, 255, 255, 255, 255)
            end
        end

        RemoveAnimDict("mini@safe_cracking")
    end)
end

ResetCrackingGame = function()
    Heap.Cracking = false
    
    safeLocks = {}

    ReleaseAmbientAudioBank("SAFE_CRACK")
    SetStreamedTextureDictAsNoLongerNeeded("MPSafeCracking")

    if IsEntityPlayingAnim(PlayerPedId(), "mini@safe_cracking", "dial_turn_clock_normal", 3) then
        ClearPedTasks(PlayerPedId())
    end
end

HandleControls = function(safeEntity)
    Citizen.CreateThread(function()
        while Heap.Cracking do 
            DisableControlAction(0, 38, true)

            if IsControlJustPressed(0, 22) then
                if dialRotation == currentSafeCorrectPosition then
                    PlaySoundFrontend(0, "TUMBLER_PIN_FALL", "SAFE_CRACK_SOUNDSET", 1)

                    safeLocks[#safeLocks + 1] = true

                    if #safeLocks == 1 then
                        -- Get the current position of the player or entity for the location
                        local ped = GetPlayerPed(-1)
                        local location = GetEntityCoords(ped)

                        -- Convert location to a table format that is usable
                        location = {x = location.x, y = location.y, z = location.z}

                        -- Debug: Print the location to ensure it's being used correctly
                        print("HandleControls location: ", location.x, location.y, location.z)

                        GlobalFunction("ALARM_POLICE", location)
                    end

                    if #safeLocks < Config.TotalLocks then
                        oldSafeCorrectPosition = currentSafeCorrectPosition
                        currentSafeCorrectPosition = math.random(1, 350)
                    else
                        ResetCrackingGame()

                        local store = GetClosestStore()
        
                        GlobalFunction("BREAK_SAFE_COMPLETED", {
                            Store = store.Name,
                            ItemCoords = {
                                GetOffsetFromEntityInWorldCoords(safeEntity, -0.45, 0.25, 0.35),
                                GetOffsetFromEntityInWorldCoords(safeEntity, -0.15, 0.35, 1.05),
                                GetOffsetFromEntityInWorldCoords(safeEntity, -0.3, 0.35, 1.05)
                            },
                            save = true 
                        })

                        GlobalFunction("OPEN_DOOR", {
                            Store = store.Name,
                            Entity = safeEntity
                        })
                            
                        X.Notify("Kassaskåp", "Du lyckades låsa upp skåpet.", 5000, "success")
                    end
                else
                    if oldSafeCorrectPosition ~= dialRotation then
                        X.Notify("Kassaskåp", "Fel kombination, du får börja om.", 5000, "error")

                        safeLocks = {}
                    end
                end
            elseif IsControlJustPressed(0, 47) then
                ResetCrackingGame()
            elseif IsControlJustPressed(0, 172) then
                MoveSafeDial(true)
            elseif IsControlJustPressed(0, 173) then
                MoveSafeDial(false)
            elseif IsControlPressed(0, 174) then
                MoveSafeDial(true)
            elseif IsControlPressed(0, 175) then
                MoveSafeDial(false)
            end

            Citizen.Wait(5)
        end
    end)
end

MoveSafeDial = function(clockwise)
    if clockwise then
        dialRotation = dialRotation + 1

        if dialRotation == currentSafeCorrectPosition then
            PlaySoundFrontend(0, "TUMBLER_PIN_FALL", "SAFE_CRACK_SOUNDSET", 1)
        else
            PlaySoundFrontend(0, "TUMBLER_TURN", "SAFE_CRACK_SOUNDSET", 1)
        end

        if dialRotation >= 360 then
            dialRotation = 0.0
        end
    else
        dialRotation = dialRotation - 1

        if dialRotation == currentSafeCorrectPosition then
            PlaySoundFrontend(0, "TUMBLER_PIN_FALL", "SAFE_CRACK_SOUNDSET", 1)
        else
            PlaySoundFrontend(0, "TUMBLER_TURN", "SAFE_CRACK_SOUNDSET", 1)
        end

        if dialRotation <= 0 then
            dialRotation = 360.0
        end
    end

    Citizen.Wait(10)
end

ControlDoor = function(close, storeName)
    local storeLocation = Config.Markets[storeName].marketPos

    if #(storeLocation - GetEntityCoords(PlayerPedId())) >= 50 then return end

    local safeEntity = GetClosestObjectOfType(storeLocation, 25.0, -1346995970)

    if not DoesEntityExist(safeEntity) then return end

    Citizen.CreateThread(function()
        LoadModels({
            "mini@safe_cracking"
        })

        local rotation = vector3(0.0, 0.0, GetEntityHeading(safeEntity) + 90.0)
        local coordinates = vector3(GetEntityCoords(safeEntity, true) - GetAnimInitialOffsetPosition("mini@safe_cracking", "DOOR_OPEN_SUCCEED_STAND_SAFE", 0.0, 0.0, 0.0, rotation, 0, 2))
        local scene = NetworkCreateSynchronisedScene(coordinates, rotation, 2, false, false, 1065353216, 0, 1065353216)
        
        local s = NetworkConvertSynchronisedSceneToSynchronizedScene(scene)
        
        --NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, "mini@safe_cracking", "DOOR_OPEN_SUCCEED_STAND", 8.0, -8.0, 1421, 16, 1148846080, 0)
        --NetworkAddEntityToSynchronisedScene(safeEntity, scene, "mini@safe_cracking", "DOOR_OPEN_SUCCEED_STAND_SAFE", 8.0, -8.0, 137)
        
        --NetworkStartSynchronisedScene(scene)

        --local scene = CreateSynchronizedScene(coordinates, rotation, 2)
        
        --TaskSynchronizedScene(PlayerPedId(), scene, "mini@safe_cracking", "DOOR_OPEN_SUCCEED_STAND", 8.0, -8.0, 1421, 16, 1148846080, 0)
        --PlaySynchronizedEntityAnim(safeEntity, scene, "DOOR_OPEN_SUCCEED_STAND_SAFE", "mini@safe_cracking", 8.0, -8.0, 137)
        
        Citizen.Wait(500)
        
        local lol = false
        local lol2 = false
        
        while true do
            Citizen.Wait(0)
        
            if GetSynchronizedScenePhase(s) >= 0.096 and not lol then
                PlaySoundFromCoord(-1, "Safe_Handle_Spin", GetEntityCoords(PlayerPedId()), "DLC_Biker_Cracked_Sounds", false, 0, 0)
        
                lol = true
            end
        
            if GetSynchronizedScenePhase(scene) >= 0.362 and not lol2 then
                PlaySoundFromCoord(-1, "Safe_Door_Open", GetEntityCoords(PlayerPedId()), "DLC_Biker_Cracked_Sounds", false, 0, 0)
        
                lol2 = true
            end
        
            if PED:GET_SYNCHRONIZED_SCENE_PHASE(iVar1) >= 0.096 then
            
            vVar2 = { func_257() };
            AUDIO:PLAY_SOUND_FROM_COORD(-1, "Safe_Handle_Spin", vVar2, "DLC_Biker_Cracked_Sounds", false, 0, 0);
            func_5456(21);
            if (PED:GET_SYNCHRONIZED_SCENE_PHASE(iVar1) >= 0.362) then
            end
            AUDIO:PLAY_SOUND_FROM_COORD(-1, "Safe_Door_Open", vVar2, "DLC_Biker_Cracked_Sounds", false, 0, 0);
            func_5456(22);
            end
        end

        local runs = 0

        while runs < 140 do
            Citizen.Wait(10)

            local oldSafeHeading = GetEntityHeading(safeEntity)

            if close then
                SetEntityHeading(safeEntity, oldSafeHeading - 0.7)
            else
                SetEntityHeading(safeEntity, oldSafeHeading + 0.7)
            end

            runs = runs + 1
        end

        FreezeEntityPosition(safeEntity, true)
    end)
end
