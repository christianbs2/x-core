local hideAmmo = true

Citizen.CreateThread(function()
    local DrawText3D = function(msg, x, y, z, scale, fontType, r, g, b, a, useOutline, useDropShadow, layer)
        SetDrawOrigin(x, y, z, 0)
        BeginTextCommandDisplayText('STRING')
        AddTextComponentSubstringPlayerName(msg)
        SetTextFont(fontType)
        SetTextScale(1, scale)
        SetTextWrap(0.0, 1.0)
        SetTextCentre(true)
        SetTextColour(r, g, b, a)
    
        if useOutline then
            SetTextOutline()
        end
    
        if useDropShadow then
            SetTextDropShadow()
        end
    
        EndTextCommandDisplayText(0, 0)
        ClearDrawOrigin()
    end

    local noAmmoWeapons = { [GetHashKey("weapon_snowball")] = true }

	while true do
		Citizen.Wait(0)

        if IsPlayerFreeAiming(PlayerId()) and not hideAmmo then
            local ped = PlayerPedId()

			local currentWeapon = GetSelectedPedWeapon(ped)

            if not noAmmoWeapons[currentWeapon] then
                local _, ammoCount = GetAmmoInClip(ped, currentWeapon, 0)

                if ammoCount > 0 then
                    local totalAmmo = GetAmmoInPedWeapon(ped, currentWeapon) - ammoCount

                    local hand = GetPedBoneCoords(
                        ped,
                        6286,
                        0,
                        0,
                        0.15
                    )

                    DrawText3D(
                        "~r~" .. ammoCount,
                        hand.x,
                        hand.y,
                        hand.z,
                        0.6,
                        8,
                        255,
                        255,
                        255,
                        155,
                        true,
                        false,
                        99
                    )
                end
            end
		end
    end
end)

Citizen.CreateThread(function()
    while true do
        local sleepThread = 5000

        hideAmmo = not exports["x-settings"]:GetSetting("SHOW_AMMO")

        Citizen.Wait(sleepThread)
    end
end)