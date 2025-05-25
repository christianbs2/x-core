local lastCacheTimes = {
    vehicles = 0,
    players = 0,
    objects = 0
}

local cachedEntities = {
    vehicles = {},
    players = {},
    objects = {}
}

Main.GetPlayerCoords = function()
    return GetEntityCoords(PlayerPedId())
end

Main.Connected = function()
    while not NetworkIsSessionStarted() do
        Citizen.Wait(500)
    end
    TriggerServerEvent("playerJoined")
end

Main.Notify = function(label, text, timeout, type)
    exports['dillen_notifications']:sendNotification({
        ["title"] = label,
        ["message"] = text,
        ["duration"] = timeout,
        ["type"] = type
    })
end

Main.Hint = function(hint)
    BeginTextCommandDisplayHelp('STRING')
    AddTextComponentSubstringPlayerName(hint)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

Main.Log = function(...)
    TriggerServerEvent("x-core:log", ...)
end

Main.Callback = function(name, callback, ...)
    local uniqueId = Main.GetRandomString(32)
    Main.Callbacks[uniqueId] = callback
    TriggerServerEvent("x-core:callback", name, uniqueId, ...)
end

Main.Draw3DText = function(coords, text)
    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)
    if onScreen then
        local camCoords = GetGameplayCamCoords()
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
        local factor = string.len(text) / 370
        DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
    end
end

Main.DrawFloatingText = function(coords, text)
    AddTextEntry("FLOATING_TEXT_MESSAGE", text)
    SetFloatingHelpTextWorldPosition(1, coords)
    SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
    BeginTextCommandDisplayHelp("FLOATING_TEXT_MESSAGE")
    EndTextCommandDisplayHelp(2, false, false, -1)
end

Main.ShowHelpNotification = function(displayText)
    SetTextComponentFormat("STRING")
    AddTextComponentString(displayText)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

Main.DrawScriptMarker = function(markerData)
    DrawMarker(
        markerData.type or 1,
        markerData.pos or vector3(0.0, 0.0, 0.0),
        0.0, 0.0, 0.0,
        (markerData.type == 6 and -90.0 or markerData.rotate and -180.0) or 0.0, 0.0, 0.0,
        markerData.sizeX or 1.0, markerData.sizeY or 1.0, markerData.sizeZ or 1.0,
        markerData.r or 1.0, markerData.g or 1.0, markerData.b or 1.0,
        100, false, true, 2, false, false, false, false
    )
end

Main.GetObjects = function()
    local currentTime = GetGameTimer()
    if currentTime - lastCacheTimes.objects > 100 then
        cachedEntities.objects = {}
        for object in EnumerateObjects() do
            if DoesEntityExist(object) then
                table.insert(cachedEntities.objects, object)
            end
        end
        lastCacheTimes.objects = currentTime
    end
    return cachedEntities.objects
end

Main.GetClosestObject = function(filter, coords)
    local objects = Main.GetObjects()
    coords = coords and vector3(coords.x, coords.y, coords.z) or Main.GetPlayerCoords()
    local closestDistance, closestObject = -1, -1

    if type(filter) == 'string' then
        filter = {filter}
    end

    for i = 1, #objects do
        local obj = objects[i]
        if DoesEntityExist(obj) then
            local isMatch = not filter or #filter == 0
            if not isMatch then
                local model = GetEntityModel(obj)
                for _, f in ipairs(filter) do
                    if model == GetHashKey(f) then
                        isMatch = true
                        break
                    end
                end
            end
            if isMatch then
                local dist = #(coords - GetEntityCoords(obj))
                if closestDistance == -1 or dist < closestDistance then
                    closestObject = obj
                    closestDistance = dist
                end
            end
        end
    end

    return closestObject, closestDistance
end

Main.GetPlayers = function()
    local currentTime = GetGameTimer()
    if currentTime - lastCacheTimes.players > 100 then
        cachedEntities.players = {}
        for _, player in ipairs(GetActivePlayers()) do
            local ped = GetPlayerPed(player)
            if DoesEntityExist(ped) then
                table.insert(cachedEntities.players, player)
            end
        end
        lastCacheTimes.players = currentTime
    end
    return cachedEntities.players
end

Main.GetClosestPlayer = function(coords)
    coords = coords and vector3(coords.x, coords.y, coords.z) or Main.GetPlayerCoords()
    local players = Main.GetPlayers()
    local closestPlayer, closestDistance = -1, -1

    for _, player in ipairs(players) do
        if player ~= PlayerId() then
            local ped = GetPlayerPed(player)
            local dist = #(coords - GetEntityCoords(ped))
            if closestDistance == -1 or dist < closestDistance then
                closestPlayer = player
                closestDistance = dist
            end
        end
    end

    return closestPlayer, closestDistance
end

Main.GetPlayersInArea = function(coords, radius)
    coords = vector3(coords.x, coords.y, coords.z)
    local inArea = {}
    for _, player in ipairs(Main.GetPlayers()) do
        local ped = GetPlayerPed(player)
        if #(coords - GetEntityCoords(ped)) <= radius then
            table.insert(inArea, player)
        end
    end
    return inArea
end

Main.GetVehicles = function()
    local currentTime = GetGameTimer()
    if currentTime - lastCacheTimes.vehicles > 100 then
        cachedEntities.vehicles = {}
        for vehicle in EnumerateVehicles() do
            if DoesEntityExist(vehicle) then
                table.insert(cachedEntities.vehicles, vehicle)
            end
        end
        lastCacheTimes.vehicles = currentTime
    end
    return cachedEntities.vehicles
end

Main.GetClosestVehicle = function(coords)
    coords = coords and vector3(coords.x, coords.y, coords.z) or Main.GetPlayerCoords()
    local closestVehicle, closestDistance = -1, -1

    for _, vehicle in ipairs(Main.GetVehicles()) do
        local dist = #(coords - GetEntityCoords(vehicle))
        if closestDistance == -1 or dist < closestDistance then
            closestVehicle = vehicle
            closestDistance = dist
        end
    end

    return closestVehicle, closestDistance
end

Main.GetVehiclesInArea = function(coords, radius)
    coords = vector3(coords.x, coords.y, coords.z)
    local result = {}
    for _, vehicle in ipairs(Main.GetVehicles()) do
        if #(coords - GetEntityCoords(vehicle)) <= radius then
            table.insert(result, vehicle)
        end
    end
    return result
end

Main.GetPeds = function(ignoreList)
    ignoreList = ignoreList or {}
    local peds = {}
    for ped in EnumeratePeds() do
        if DoesEntityExist(ped) then
            local skip = false
            for _, ignore in ipairs(ignoreList) do
                if ignore == ped then
                    skip = true
                    break
                end
            end
            if not skip then
                table.insert(peds, ped)
            end
        end
    end
    return peds
end

Main.GetClosestPed = function(coords, ignoreList)
    coords = vector3(coords.x, coords.y, coords.z)
    local closestPed, closestDistance = -1, -1
    for _, ped in ipairs(Main.GetPeds(ignoreList)) do
        local dist = #(coords - GetEntityCoords(ped))
        if closestDistance == -1 or dist < closestDistance then
            closestPed = ped
            closestDistance = dist
        end
    end
    return closestPed, closestDistance
end

Main.GotoPlace = function(ped, coords, speed, timeout, heading, distToSlide)
    TaskGoStraightToCoord(ped, coords.x, coords.y, coords.z, speed, timeout, heading, distToSlide)
    while GetScriptTaskStatus(ped, 0x7d8f4411) ~= 7 do
        if ped == PlayerPedId() then
            if IsControlJustPressed(0, 32) or IsControlJustPressed(0, 33) or IsControlJustPressed(0, 34) or IsControlJustPressed(0, 35) then
                ClearPedTasks(ped)
                return false
            end
        end
        Citizen.Wait(100)
    end
    return true
end

Main.DeleteVehicles = function(coords, radius)
    coords = vector3(coords.x, coords.y, coords.z)
    radius = radius or 5.0
    local toDelete = {}
    for _, vehicle in ipairs(Main.GetVehicles()) do
        if #(coords - GetEntityCoords(vehicle)) <= radius then
            table.insert(toDelete, vehicle)
        end
    end
    for _, vehicle in ipairs(toDelete) do
        if DoesEntityExist(vehicle) then
            while not NetworkHasControlOfEntity(vehicle) do
                NetworkRequestControlOfEntity(vehicle)
                Citizen.Wait(0)
            end
            DeleteEntity(vehicle)
        end
    end
end

-- Hook up to existing optimized nearby detection
Main.GetVehiclesInArea = function(coords, radius)
    return EnumerateEntitiesWithinDistance(Main.GetVehicles(), false, coords, radius)
end

Main.IsSpawnPointClear = function(coords, radius)
    return #Main.GetVehiclesInArea(coords, radius) == 0
end
