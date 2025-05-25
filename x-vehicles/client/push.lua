local First = vector3(0.0, 0.0, 0.0)
local Second = vector3(5.0, 5.0, 5.0)

local Vehicle = {}

Citizen.CreateThread(function()
    Citizen.Wait(200)

    while true do
        local ped = PlayerPedId()

        local closestVehicle, closestVehicleDistance = X.GetClosestVehicle()

        local vehicleCoords = GetEntityCoords(closestVehicle)
        local dimension = GetModelDimensions(GetEntityModel(closestVehicle), First, Second)

        if closestVehicleDistance < 5.0 and not IsPedInAnyVehicle(ped, false) then
            Vehicle.Coords = vehicleCoords
            Vehicle.Dimensions = dimension
            Vehicle.Vehicle = closestVehicle
            Vehicle.Distance = closestVehicleDistance

            if GetDistanceBetweenCoords(GetEntityCoords(closestVehicle) + GetEntityForwardVector(closestVehicle), GetEntityCoords(ped), true) > GetDistanceBetweenCoords(GetEntityCoords(closestVehicle) + GetEntityForwardVector(closestVehicle) * -1, GetEntityCoords(ped), true) then
                Vehicle.IsInFront = false
            else
                Vehicle.IsInFront = true
            end
        else
            Vehicle = {}
        end

        Citizen.Wait(500)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)

        local ped = PlayerPedId()

        if Vehicle.Vehicle then
            local isPushable = IsVehicleSeatFree(Vehicle.Vehicle, -1) and (GetVehicleEngineHealth(Vehicle.Vehicle) <= 150.0 or GetVehicleFuelLevel(Vehicle.Vehicle) <= 1.0) and GetVehicleClass(Vehicle.Vehicle) ~= 13

            if isPushable then
                local offsetLoc = Vehicle.IsInFront and vector3(0.0, Vehicle.Dimensions.y * -1 + 0.1, Vehicle.Dimensions.z + 0.5) or vector3(0.0, Vehicle.Dimensions.y - 0.3, Vehicle.Dimensions.z + 0.5)
                local drawLocation = GetOffsetFromEntityInWorldCoords(Vehicle.Vehicle, offsetLoc)

                X.Draw3DText(drawLocation, "~g~SHIFT~s~ + ~g~B~s~")

                if IsControlPressed(0, 21) and IsControlJustPressed(0, 305) then
                    NetworkRequestControlOfEntity(Vehicle.Vehicle)

                    if Vehicle.IsInFront then
                        AttachEntityToEntity(PlayerPedId(), Vehicle.Vehicle, GetPedBoneIndex(6286), 0.0, Vehicle.Dimensions.y * -1 + 0.1 , Vehicle.Dimensions.z + 1.0, 0.0, 0.0, 180.0, 0.0, false, false, true, false, true)
                    else
                        AttachEntityToEntity(PlayerPedId(), Vehicle.Vehicle, GetPedBoneIndex(6286), 0.0, Vehicle.Dimensions.y - 0.3, Vehicle.Dimensions.z  + 1.0, 0.0, 0.0, 0.0, 0.0, false, false, true, false, true)
                    end

                    while not HasAnimDictLoaded("missfinale_c2ig_11") do
                        Citizen.Wait(0)

                        RequestAnimDict("missfinale_c2ig_11")
                    end

                    TaskPlayAnim(PlayerPedId(), "missfinale_c2ig_11", "pushcar_offcliff_m", 2.0, -8.0, -1, 35, 0, 0, 0, 0)

                    Citizen.Wait(200)

                    local currentVehicle = Vehicle.Vehicle

                    while true do
                        Citizen.Wait(5)

                        if IsDisabledControlPressed(0, 34) then
                            TaskVehicleTempAction(PlayerPedId(), currentVehicle, 11, 1000)
                        end

                        if IsDisabledControlPressed(0, 35) then
                            TaskVehicleTempAction(PlayerPedId(), currentVehicle, 10, 1000)
                        end

                        if Vehicle.IsInFront then
                            SetVehicleForwardSpeed(currentVehicle, -1.0)
                        else
                            SetVehicleForwardSpeed(currentVehicle, 1.0)
                        end

                        if HasEntityCollidedWithAnything(currentVehicle) then
                            SetVehicleOnGroundProperly(currentVehicle)
                        end

                        if not IsDisabledControlPressed(0, 305) then
                            DetachEntity(ped, false, false)

                            StopAnimTask(ped, "missfinale_c2ig_11", "pushcar_offcliff_m", 2.0)

                            FreezeEntityPosition(ped, false)

                            break
                        end
                    end
                end
            end
        end
    end
end)