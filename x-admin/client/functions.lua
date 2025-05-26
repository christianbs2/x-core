Initialize = function()
    if exports["x-character"]:IsLoaded() then
        Fetch()
    end
end

Fetch = function()

end

OpenAdminNUI = function()
    X.Callback("x-admin:fetchPlayers", function(players, gangs, topList, companies)
        OpenNUI(players or {}, gangs or {}, topList or {}, companies or {})
    end)
end

OpenNUI = function(players, gangs, topList, companies)
    local characterData = X.Character.Data.identification

    if not characterData then return end

    SendNUIMessage({
        Action = "OPEN_ADMIN_NUI",
        Data = {
            Character = characterData,
            Player = {
                Name = GetPlayerName(PlayerId())
            },
            Players = players,
            Gangs = gangs,
            TopList = topList,
            Companies = companies
        }
    })

    Heap.NuiOpened = true

    SetNuiFocus(true, true)
end

CloseNUI = function()
    SendNUIMessage({
        Action = "CLOSE_NUI"
    })
end

DrawScreenText = function(text)
    SetTextEntry("STRING")
    SetTextCentre(true)
    SetTextOutline()
    SetTextScale(0.8, 0.8)
    AddTextComponentString(text)
    DrawText(0.5, 0.0)
end

DrawScriptMarker = function(markerData)
    DrawMarker(markerData["type"] or 1, markerData["pos"] or vector3(0.0, 0.0, 0.0), 0.0, 0.0, 0.0, (markerData["type"] == 6 and -90.0 or markerData["rotate"] and -180.0) or 0.0, 0.0, 0.0, markerData["size"] or vector3(1.0, 1.0, 1.0), markerData["r"] or 1.0, markerData["g"] or 1.0, markerData["b"] or 1.0, 100, markerData["bob"] and true or false, true, 2, false, false, false, false)
end

DrawScriptText = function(coords, text)
    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
end

LoadModels = function(models)
    for index, model in ipairs(models) do
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
    for index, model in ipairs(models) do
        if IsModelValid(model) then
            SetModelAsNoLongerNeeded(model)
        else
            RemoveAnimDict(model)
        end
    end
end