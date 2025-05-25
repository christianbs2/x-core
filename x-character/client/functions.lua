FetchCharacters = function()
    print("[DEBUG] Börjar ladda FetchCharacters...")  -- Kolla om denna syns
    Heap.Scaleform = RequestScaleformMovie("MIDSIZED_MESSAGE")

    X.Callback("x-character:fetchCharacters", function(charactersFetched)
        --print("[DEBUG] Callback returnerad från x-character:fetchCharacters...")  -- Kolla om denna syns

        if charactersFetched then
            --print("[DEBUG] Karaktärer hämtade, kör SetupCharacters...")  -- Kolla om denna syns
            Characters = charactersFetched

            DoScreenFadeOut(500)

            while not IsScreenFadedOut() do
                Citizen.Wait(0)
            end

            SetupCharacters()
        else
            --print("[DEBUG] Inga karaktärer hittades!")
        end
    end)
end

ChooseCharacter = function(characterData)
    TriggerServerEvent("x-character:chooseCharacter", {
        id = characterData.characterId,
        position = "last"
    })
end

SwitchCharacter = function()
    DoScreenFadeOut(500)

    while not IsScreenFadedOut() do
        Citizen.Wait(0)
    end

    local genModel = GetHashKey("ig_bankman")

    while not HasModelLoaded(genModel) do
        RequestModel(genModel)

        Citizen.Wait(0)
    end

    SetPlayerModel(PlayerId(), genModel)

    if Heap.Selecting then
        Cleanup()
    end

    TriggerServerEvent("x-character:exitCharacter")

    FetchCharacters()
end

DrawButtons = function(buttonsToDraw)
    local instructionScaleform = RequestScaleformMovie("instructional_buttons")

    while not HasScaleformMovieLoaded(instructionScaleform) do
        Wait(0)
    end

    PushScaleformMovieFunction(instructionScaleform, "CLEAR_ALL")
    PushScaleformMovieFunction(instructionScaleform, "TOGGLE_MOUSE_BUTTONS")
    PushScaleformMovieFunctionParameterBool(0)
    PopScaleformMovieFunctionVoid()

    for buttonIndex, buttonValues in ipairs(buttonsToDraw) do
        PushScaleformMovieFunction(instructionScaleform, "SET_DATA_SLOT")
        PushScaleformMovieFunctionParameterInt(buttonIndex - 1)

        PushScaleformMovieMethodParameterButtonName(buttonValues["button"])
        PushScaleformMovieFunctionParameterString(buttonValues["label"])
        PopScaleformMovieFunctionVoid()
    end

    PushScaleformMovieFunction(instructionScaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PushScaleformMovieFunctionParameterInt(-1)
    PopScaleformMovieFunctionVoid()
    DrawScaleformMovieFullscreen(instructionScaleform, 255, 255, 255, 255)
end

LoadModels = function(models)
    for _, model in ipairs(models) do
        if IsModelValid(model) then
            while not HasModelLoaded(model) do
                RequestModel(model)

                Citizen.Wait(10)
            end
        else
            while not HasAnimDictLoaded(model) do
                RequestAnimDict(model)

                Citizen.Wait(10)
            end
        end
    end
end

CleanupModels = function(models)
    for _, model in ipairs(models) do
        if IsModelValid(model) then
            SetModelAsNoLongerNeeded(model)
        else
            RemoveAnimDict(model)
        end
    end
end

OpenInput = function(label, type)
    AddTextEntry(type, label)

    DisplayOnscreenKeyboard(1, type, "", "", "", "", "", 10)

    while UpdateOnscreenKeyboard() == 0 do
        DisableAllControlActions(0)
        Wait(0)
    end

    if GetOnscreenKeyboardResult() then
        return GetOnscreenKeyboardResult()
    end
end

IsLoaded = function()
    if not X then return false end

    return X.Character.IsLoaded
end

DrawBusySpinner = function(text)
    SetLoadingPromptTextEntry("STRING")
    AddTextComponentSubstringPlayerName(text)
    ShowLoadingPrompt(3)
end

DrawText3D = function(coords, text, scale)
    if not scale then scale = 0.35 end

    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())

    SetTextScale(scale, scale)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
end

PlayAnimation = function(ped, dict, anim, settings)
    if dict then
        RequestAnimDict(dict)

        while not HasAnimDictLoaded(dict) do
            Citizen.Wait(0)
        end

        if settings == nil then
            TaskPlayAnim(ped, dict, anim, 1.0, -1.0, 1.0, 0, 0, 0, 0, 0)
        else
            local speed = 1.0
            local speedMultiplier = -1.0
            local duration = 1.0
            local flag = 0
            local playbackRate = 0

            if settings["speed"] then
                speed = settings["speed"]
            end

            if settings["speedMultiplier"] then
                speedMultiplier = settings["speedMultiplier"]
            end

            if settings["duration"] then
                duration = settings["duration"]
            end

            if settings["flag"] then
                flag = settings["flag"]
            end

            if settings["playbackRate"] then
                playbackRate = settings["playbackRate"]
            end

            TaskPlayAnim(ped, dict, anim, speed, speedMultiplier, duration, flag, playbackRate, 0, 0, 0)

            while not IsEntityPlayingAnim(ped, dict, anim, 3) do
                Citizen.Wait(0)
            end
        end

        RemoveAnimDict(dict)
    else
        TaskStartScenarioInPlace(ped, anim, 0, true)
    end
end

ModifyVehicle = function(vehicle, r, g, b)
    SetVehicleCustomPrimaryColour(vehicle, r, g, b)
    SetVehicleCustomSecondaryColour(vehicle, r, g, b)
    SetVehicleModKit(vehicle, 0)
    SetVehicleMod(vehicle, 0, GetNumVehicleMods(vehicle, 0) - 1, false)
    SetVehicleMod(vehicle, 1, GetNumVehicleMods(vehicle, 1) - 1, false)
    SetVehicleMod(vehicle, 2, GetNumVehicleMods(vehicle, 2) - 1, false)
    SetVehicleMod(vehicle, 3, GetNumVehicleMods(vehicle, 3) - 1, false)
    SetVehicleMod(vehicle, 4, GetNumVehicleMods(vehicle, 4) - 1, false)
    SetVehicleMod(vehicle, 5, GetNumVehicleMods(vehicle, 5) - 1, false)
    SetVehicleMod(vehicle, 6, GetNumVehicleMods(vehicle, 6) - 1, false)
    SetVehicleMod(vehicle, 7, GetNumVehicleMods(vehicle, 7) - 1, false)
    SetVehicleMod(vehicle, 8, GetNumVehicleMods(vehicle, 8) - 1, false)
    SetVehicleMod(vehicle, 9, GetNumVehicleMods(vehicle, 9) - 1, false)
    SetVehicleMod(vehicle, 10, GetNumVehicleMods(vehicle, 10) - 1, false)
    SetVehicleMod(vehicle, 11, GetNumVehicleMods(vehicle, 11) - 1, false)
    SetVehicleMod(vehicle, 12, GetNumVehicleMods(vehicle, 12) - 1, false)
    SetVehicleMod(vehicle, 13, GetNumVehicleMods(vehicle, 13) - 1, false)
    SetVehicleMod(vehicle, 14, 16, false)
    SetVehicleMod(vehicle, 15, GetNumVehicleMods(vehicle, 15) - 2, false)
    SetVehicleMod(vehicle, 16, GetNumVehicleMods(vehicle, 16) - 1, false)
    ToggleVehicleMod(vehicle, 17, true)
    ToggleVehicleMod(vehicle, 18, true)
    ToggleVehicleMod(vehicle, 19, true)
    ToggleVehicleMod(vehicle, 20, true)
    ToggleVehicleMod(vehicle, 21, true)
    ToggleVehicleMod(vehicle, 22, true)
    SetVehicleMod(vehicle, 23, 1, false)
    SetVehicleMod(vehicle, 24, 1, false)
    SetVehicleMod(vehicle, 25, GetNumVehicleMods(vehicle, 25) - 1, false)
    SetVehicleMod(vehicle, 27, GetNumVehicleMods(vehicle, 27) - 1, false)
    SetVehicleMod(vehicle, 28, GetNumVehicleMods(vehicle, 28) - 1, false)
    SetVehicleMod(vehicle, 30, GetNumVehicleMods(vehicle, 30) - 1, false)
    SetVehicleMod(vehicle, 33, GetNumVehicleMods(vehicle, 33) - 1, false)
    SetVehicleMod(vehicle, 34, GetNumVehicleMods(vehicle, 34) - 1, false)
    SetVehicleMod(vehicle, 35, GetNumVehicleMods(vehicle, 35) - 1, false)
    SetVehicleMod(vehicle, 38, GetNumVehicleMods(vehicle, 38) - 1, true)
    SetVehicleTyreSmokeColor(vehicle, 0, 0, 127)
end