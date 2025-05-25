local currentPed

OpenCharacterCreationNUI = function()
    TriggerScreenblurFadeIn(100.0)

    RemoveLoadingPrompt()

    SetNuiFocus(true, true)

    SendNUIMessage({
        ["action"] = "OPEN_CHARACTER_CREATION_NUI"
    })
end

InitiateCharacterCreator = function(characterData)
    TriggerEvent("hud", false)

    Camera.Cleanup()

    SetEntityVisible(PlayerPedId(), false)

    TriggerScreenblurFadeIn(100.0)

    SetEntityCoords(PlayerPedId(), vector3(397.25701904297, -1004.4926147461, -99.004035949707))

    local characterModel = characterData["gender"] == "Man" and GetHashKey("mp_m_freemode_01") or GetHashKey("mp_f_freemode_01")

    DestroyAllCams(true)

    Camera.CameraHandles = {
        Default = Camera.CreateCam({
            Location = vector3(402.7391, -1003.981, -98.43439),
            Rotation = vector3(-3.589798, 0.0, -0.276381),
            Fov = 20.95373
        }),
        Face = Camera.CreateCam({
            Location = vector3(402.6515, -1000.129, -98.46554),
            Rotation = vector3(2.017746, 0.0, -2.348175),
            Fov = 11.36276
        })
    }

    DoScreenFadeOut(100)

    while not IsScreenFadedOut() do
        Citizen.Wait(0)
    end

    while not HasModelLoaded(characterModel) do
        Citizen.Wait(0)

        RequestModel(characterModel)
    end

    currentPed = CreatePed(5, characterModel, GetStartPosition(), GetStartRotation())

    local pedIndex = characterData["gender"] == "Man" and 1 or 2

    exports["x-appearance"]:ApplySkin(Config.DefaultAppearances[pedIndex], Config.NakedClothings[pedIndex], currentPed, true)

    Citizen.Wait(500)

    Camera.HandleCam("Default", "NONE")

    DisplayRadar(false)

    local animDict = RetreiveCharacterAnimation("character", characterModel)

    while not HasAnimDictLoaded(animDict) do
        RequestAnimDict(animDict)

        Citizen.Wait(5)
    end

    CachedMugshot.CharacterCreator(characterData)

    TriggerScreenblurFadeOut(5500.0)

    --local taskSequence = OpenSequenceTask()
    TaskPlayAnimAdvanced(currentPed, animDict, "Intro", GetStartPosition(), GetStartRotation(), 8.0, -8.0, -1, 4608, 0, 2, 0)
    --TaskPlayAnim(0, animDict, "Loop", 8.0, -4.0, -1, 513, 0, 0, 0, 0)
    --CloseSequenceTask(taskSequence)
    --
    --TaskPerformSequence(currentPed, taskSequence)

    Citizen.Wait(300)

    while IsEntityPlayingAnim(currentPed, animDict, "Intro", 3) do
        Citizen.Wait(0)
    end

    TaskPlayAnim(currentPed, animDict, "Loop", 8.0, -4.0, -1, 513, 0, 0, 0, 0)
end

CachedMugshot.CharacterCreator = function(characterData)
    local animDict = RetreiveCharacterAnimation("character", GetEntityModel(currentPed))

    while not HasAnimDictLoaded(animDict) do
        RequestAnimDict(animDict)

        Citizen.Wait(5)
    end

    DoScreenFadeIn(1000)

    exports["x-core"]:EditRichPresence("Skapar " .. characterData["firstname"] .. "...")

    CachedMugshot.Creating = true

    CreateBoard(currentPed, characterData, 1)

    while not RequestScriptAudioBank("Mugshot_Character_Creator", 0) do
        Citizen.Wait(0)
    end

    Citizen.Wait(1000)

    Citizen.CreateThread(function()
        while CachedMugshot.Creating do
            Citizen.Wait(5)

            if not IsCamInterpolating(Camera.CameraHandles[Camera.LastCamera] or 0) then
                if Camera.LastCamera == "Default" then
                    if IsEntityPlayingAnim(currentPed, animDict, "drop_loop", 3) then
                        local _, taskSequence = OpenSequenceTask()
                        TaskPlayAnim(0, animDict, "drop_outro", 8.0, -8.0, -1, 512, 0, 0, 0, 0)
                        TaskPlayAnim(0, animDict, "loop", 8.0, -4.0, -1, 513, 0, 0, 0, 0)
                        CloseSequenceTask(taskSequence)

                        TaskPerformSequence(currentPed, taskSequence)
                    end
                else
                    if IsEntityPlayingAnim(currentPed, animDict, "loop", 3) then
                        local _, taskSequence = OpenSequenceTask()
                        TaskPlayAnim(0, animDict, "drop_intro", 8.0, -8.0, -1, 512, 0, 0, 0, 0)
                        TaskPlayAnim(0, animDict, "drop_loop", 8.0, -4.0, -1, 513, 0, 0, 0, 0)
                        CloseSequenceTask(taskSequence)

                        TaskPerformSequence(currentPed, taskSequence)
                    end
                end
            end
        end

        DeleteEntity(currentPed)
    end)

    Citizen.CreateThread(function()
        local available = {
            "skin",
            "face",
            "wrinkles",
            "lipstick",
            "hair",
            "eyebrow",
            "beard",
            "eyecolor",
            "makeup",
            "tshirt",
            "torso",
            "bulletproof",
            "arms",
            "pants",
            "shoes"
        }

        TriggerEvent("x-appearance:openAppearanceMenu", available, currentPed, function(data, menu)
            while IsEntityPlayingAnim(currentPed, animDict, "drop_outro", 3) do
                Citizen.Wait(0)
            end

            local _, taskSequence = OpenSequenceTask()
            TaskPlayAnim(0, animDict, "outro", 8.0, -8.0, -1, 512, 0, 0, 0, 0)
            TaskPlayAnim(0, animDict, "outro_loop", 8.0, -8.0, -1, 513, 0, 0, 0, 0)
            CloseSequenceTask(taskSequence)

            TaskPerformSequence(currentPed, taskSequence)

            DoScreenFadeOut(5000)
            
            Citizen.Wait(2000)

            PlaySound(-1, "Take_Picture", "MUGSHOT_CHARACTER_CREATION_SOUNDS", 0, 0, 1)

            while not IsScreenFadedOut() do
                Citizen.Wait(0)
            end

            Camera.Cleanup()

            local doneTimer = GetGameTimer()

            FreezeEntityPosition(PlayerPedId(), false)

            while (GetGameTimer() - doneTimer) / 7500 * 100 <= 100 do
                Citizen.Wait(0)

                if not IsScreenFadedOut() then
                    DoScreenFadeOut(0)
                end

                local timer = (GetGameTimer() - doneTimer)

                Set_2dLayer(7)
                SetTextCentre(true)
                SetTextFont(0)
                SetTextProportional(true)
                SetTextScale(0.45, 0.45)
                SetTextColour(255, 255, 255, timer / 10 > 255 and 255 or math.floor(timer / 10))
                SetTextDropshadow(0, 0, 0, 0, 255)
                SetTextEdge(1, 0, 0, 0, 255)
                SetTextDropShadow()
                SetTextOutline()
                SetTextEntry("STRING")
                AddTextComponentString("Välkommen~s~, " .. characterData["firstname"] .. ".")
                DrawText(0.5, 0.5 - GetTextScaleHeight(0.45, 0) / 2.0)
                HideLoadingOnFadeThisFrame()
            end

            CachedMugshot.Attached = false
            CachedMugshot.Creating = false

            local skin = exports["x-appearance"]:GetCharacterAppearance()
            -- local defaultClothing = exports["x-appearance"]:GetDefaultClothing(skin["sex"] + 1)

            exports["x-appearance"]:ApplySkin(skin, skin, PlayerPedId())

            TriggerServerEvent("x-character:createCharacter", characterData)

            PlaySoundFrontend(-1, "CHECKPOINT_NORMAL", "HUD_MINI_GAME_SOUNDSET", true)

            Citizen.Wait(2500)

            TriggerServerEvent("x-appearance:saveAppearance", skin)

            exports["x-housing"]:StartIntroScene()

            TriggerEvent("hud", true)

            exports["x-core"]:EditRichPresence()
        end, function()
            CachedMugshot.Attached = false
            CachedMugshot.Creating = false

            FetchCharacters()
        end, function(subMenu)
            local subMenuCameras = {
                ["Face"] = { "face", "wrinkles", "beard", "hair", "eyecolor", "eyebrow", "makeup", "lipstick", "earaccessories", "mask", "helmet", "glasses" }
            }

            for camIndex, subMenus in pairs(subMenuCameras) do
                for i = 1, #subMenus do
                    if subMenu == subMenus[i] then
                        if subMenu ~= CachedMugshot.LastSubMenu then
                            Camera.HandleCam("Default", camIndex, 300)

                            Camera.FuckCamera(4.0, 1.0, 1.2, 1.0)

                            PlaySound(-1, "Zoom_In", "MUGSHOT_CHARACTER_CREATION_SOUNDS", 0, 0, 1)
                        end

                        CachedMugshot.LastSubMenu = subMenu

                        return
                    end
                end
            end

            if Camera.LastCamera ~= "Default" then
                Camera.HandleCam(Camera.LastCamera, "Default", 300)

                CachedMugshot.LastSubMenu = "Default"

                PlaySound(-1, "Zoom_Out", "MUGSHOT_CHARACTER_CREATION_SOUNDS", 0, 0, 1)
            end
        end, false, true)
    end)
end