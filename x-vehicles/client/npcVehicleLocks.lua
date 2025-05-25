Citizen.CreateThread(function()
    while true do 
        local sleepThread = 50

        while not X do 
            Citizen.Wait(5)
        end

        local vehicle = X.GetClosestVehicle(GetEntityCoords(PlayerPedId()))

        if vehicle and #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(vehicle)) <= 7.5 then 
            Lock(vehicle)
        end

        Citizen.Wait(sleepThread)
    end
end)

Lock = function(vehicle)
    local status = GetVehicleDoorLockStatus(vehicle) 
    local pedInVehicle = GetPedInVehicleSeat(vehicle, -1)
    
    if status == 7 or status == 8 or not DecorExistOn(vehicle, "VEHICLE_FUEL_LEVEL") then 
        if not Entity(vehicle).state.unlocked and GetVehicleClass(vehicle) ~= 13 then 
            SetVehicleDoorsLocked(vehicle, 2)
        end
    end
end

RegisterNetEvent("x-vehicles:usePickgun")
AddEventHandler("x-vehicles:usePickgun", function(itemData)
    local vehicle = X.GetClosestVehicle(GetEntityCoords(PlayerPedId()))
    if not vehicle then return X.Notify("Dyrk", "Vilket fordon hade jag tänkt att dyrka..", 5000, "warning") end 

    if itemData and itemData.MetaData and itemData.MetaData.Durability <= 0 then
        return X.Notify("Dyrk", "Din låspistol är trasig och går därmed inte att använda.", 5000, "error")
    end

    local dstCheck = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(vehicle))
    if dstCheck >= 5.0 then return X.Notify("Dyrk", "Du är inte tillräckligt nära ett fordon för att göra detta!", 5000, "warning") end 

    while not HasAnimDictLoaded("missheistfbisetup1") do 
        RequestAnimDict("missheistfbisetup1")
        Citizen.Wait(5)
    end

    while not HasModelLoaded(GetHashKey("prop_piercing_gun")) do 
        RequestModel(GetHashKey("prop_piercing_gun"))
        Citizen.Wait(5)
    end

    local pickGun = CreateObject(GetHashKey("prop_piercing_gun"), 0, 0, 0, true, true, true)
    AttachEntityToEntity(pickGun, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.2, 0, 0, 0, 180.0, 0.0, true, true, false, true, 1, true)

    TaskTurnPedToFaceEntity(PlayerPedId(), vehicle, 1000)
    Citizen.Wait(1000)

    PlayAnimation(PlayerPedId(), "missheistfbisetup1", "unlock_loop_janitor", { flag = 31 })

    exports['boii_minigames']:button_mash({
        style = 'default',
        difficulty = 5
    }, function(success)
        X.Callback("x-vehicles:usePickgun", function(used)
            if used then
                if success then
                    X.Notify("Fordon", "Du lyckades att dyrka upp låset", 6000, "success")
                    Entity(vehicle).state.unlocked = true
                    SetVehicleDoorsLocked(vehicle, 1)
                else
                    X.Notify("Fordon", "Du misslyckades med att låsa upp fordonet", 6000, "error")
                end
            else
                X.Notify("Fordon", "Du har inte ens en låspistol i ryggsäcken.", 5000, "error")
            end

            while not NetworkHasControlOfEntity(pickGun) do
                NetworkRequestControlOfEntity(pickGun)
                Citizen.Wait(5)
            end

            DeleteEntity(pickGun)
            ClearPedTasks(PlayerPedId())
        end)
    end)
end)
