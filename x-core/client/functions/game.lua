-- Disable wanted level and remove helmets
Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playerId = PlayerId()

        if Config.DisableWantedLevel and GetPlayerWantedLevel(playerId) > 0 then
            ClearPlayerWantedLevel(playerId)
            SetPlayerWantedLevelNow(playerId, false)
            SetPlayerWantedLevel(playerId, 0)
        end

        if DoesPedHaveHelmet(playerPed) then
            SetPedHelmet(playerPed, false)
            RemovePedHelmet(playerPed, true)
        end

        Citizen.Wait(1000)
    end
end)

-- Disable dispatch services once at startup
Citizen.CreateThread(function()
    for i = 1, 12 do
        Citizen.InvokeNative(0xDC0F817884CDD856, i, false)
    end
end)

-- Clear cops and remove pickups
Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)

        ClearAreaOfCops(coords, 400.0)
        RemoveAllPickupsOfType(0xDF711959)  -- Carbine Rifle
        RemoveAllPickupsOfType(0xF9AFB48F)  -- Pistol
        RemoveAllPickupsOfType(0xA9355DCD)  -- Pump Shotgun

        Citizen.Wait(10000)
    end
end)
