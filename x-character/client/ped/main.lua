CachedMugshot = {}
CachedMugshot.Cams = {}
CachedMugshot.Boards = {}

RetreiveCharacterAnimation = function(param, pedModel)
    if not param then return end

    local male = pedModel == GetHashKey("mp_m_freemode_01")

    if param == "lineup" then
        if male then
            return "mp_character_creation@lineup@male_b"
        else
            return "mp_character_creation@lineup@female_b"
        end
    elseif param == "lineup_one" then
        if male then
            return "mp_character_creation@lineup@male_a"
        else
            return "mp_character_creation@lineup@female_a"
        end
    elseif param == "creator" then
        if male then
            return "mp_character_creation@customise@male_a"
        else
            return "mp_character_creation@customise@female_a"
        end
    end

    return "mp_character_creation@customise@male_a"
end

CachedMugshot.CreateScaleformHandle = function(name, model)
    local handle = 0

    if not IsNamedRendertargetRegistered(name) then
        RegisterNamedRendertarget(name, false)
    end

    if not IsNamedRendertargetLinked(model) then
        LinkNamedRendertarget(model)
    end

    if IsNamedRendertargetRegistered(name) then
        handle = GetNamedRendertargetRenderId(name)
    end

    return handle
end

GetStartPosition = function()
    return vector3(404.834, -997.838, -98.841)
end

GetStartRotation = function()
    return vector3(0.0, 0.0, -40.0)
end

GetSpawnPosition = function()
    return vector3(-1037.81, -2737.76, 20.16)
end

GetTotalCalculation = function()
    local totalCharacters = #Characters

    if totalCharacters == 4 then
        return 0.5
    elseif totalCharacters == 3 then
        return 0.0
    elseif totalCharacters == 2 then
        return 1.0
    elseif totalCharacters == 1 then
        return 0.8
    end
end

CreateBoard = function(pedHandle, characterData, pedIndex)
    if not characterData.firstname then characterData = {
        cash = 500,
        bank = 0,
        firstname = "Förnamn",
        lastname = "Efternamn",
        dateofbirth = "0000-00-00",
        lastdigits = "0000"
    } end

    local boardModel = GetHashKey("prop_police_id_board")
    local textModel = GetHashKey(pedIndex == 1 and "prop_police_id_text" or "prop_police_id_text_02")

    LoadModels({
        textModel,
        boardModel
    })

    local boardEntity = CreateObject(boardModel, selectionPos)
    local textEntity = CreateObject(textModel, selectionPos)

    AttachEntityToEntity(boardEntity, pedHandle, GetPedBoneIndex(pedHandle, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
    AttachEntityToEntity(textEntity, boardEntity, 4103, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)

    local scaleformHandle = CachedMugshot.CreateScaleformHandle(pedIndex == 1 and "ID_Text" or "ID_Text_02", textModel)
    local scaleformMovie = RequestScaleformMovie("MUGSHOT_BOARD_0" .. pedIndex)

    while not HasScaleformMovieLoaded(scaleformMovie) do
        Citizen.Wait(0)
    end

    SetEntityVisible(PlayerPedId(), false)

    Citizen.CreateThread(function()
        while DoesEntityExist(pedHandle) and HasScaleformMovieLoaded(scaleformMovie) do
            PushScaleformMovieFunction(scaleformMovie, "SET_BOARD")
            PushScaleformMovieFunctionParameterString("KONTANTER: " .. (characterData["cash"] or 500) .. " SEK")
            PushScaleformMovieFunctionParameterString(characterData["firstname"] .. " " .. characterData["lastname"])
            PushScaleformMovieFunctionParameterString(characterData["dateofbirth"] .. "-" .. characterData["lastdigits"])
            PushScaleformMovieFunctionParameterString("Bank: " .. (characterData["bank"] or 0) .. " SEK")
            PopScaleformMovieFunctionVoid()
            SetTextRenderId(scaleformHandle)

            Citizen.InvokeNative(0x40332D115A898AF5, scaleformMovie, true)

            SetUiLayer(4)

            Citizen.InvokeNative(0xc6372ecd45d73bcd, scaleformMovie, true)

            DrawScaleformMovie(scaleformMovie, 0.4, 0.35, 0.8, 0.75, 255, 255, 255, 255, 255)
            SetTextRenderId(GetDefaultScriptRendertargetRenderId())

            Citizen.InvokeNative(0x40332D115A898AF5, scaleformMovie, false)

            NetworkOverrideClockTime(16, 0, 0)

            Citizen.Wait(0)
        end

        DeleteEntity(boardEntity)
        DeleteEntity(textEntity)

        SetScaleformMovieAsNoLongerNeeded(scaleformHandle)

        CleanupModels({
            textModel,
            boardModel
        })
    end)
end