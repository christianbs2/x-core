Citizen.CreateThread(function()
	Citizen.Wait(500)

	Heap.LastChecked = GetGameTimer() + 10000

	while true do
		local sleepThread = 500

		local ped = PlayerPedId()

		if IsPedInAnyVehicle(ped, false) then
			sleepThread = 0

			local vehicleEntity = GetVehiclePedIsUsing(ped)

			CheckDistanceVehicle(ped)

			if GetPedInVehicleSeat(vehicleEntity, -1) == ped then
				Heap.LastVehicle = vehicleEntity

				if GetIsVehicleEngineRunning(vehicleEntity) then
					local vehicleModel = GetEntityModel(vehicleEntity)

					if not IsThisModelABoat(vehicleModel) and not IsThisModelAHeli(vehicleModel) and not IsThisModelAPlane(vehicleModel) and IsEntityInAir(vehicleEntity) and not IsThisModelAnAmphibiousCar(vehicleModel) then
						DisableControlAction(0, 59)
						DisableControlAction(0, 60)
					end

					if IsControlPressed(0, 75) and not IsEntityDead(ped) then
						Citizen.Wait(250)

						SetVehicleEngineOn(vehicleEntity, true, true, false)

						TaskLeaveVehicle(ped, vehicleEntity, 0)
					end
				else
					SetVehicleEngineOn(vehicleEntity, false, true, true)
				end
			elseif GetPedInVehicleSeat(GetVehiclePedIsIn(ped, false), 0) == ped and Heap.ShuffleDisabled then
				if GetIsTaskActive(ped, 165) then
					SetPedIntoVehicle(ped, GetVehiclePedIsIn(ped, false), 0)
				end
			end
		else
			if Heap.LastVehicle and DoesEntityExist(Heap.LastVehicle) then
				SaveLastVehicle(Heap.LastVehicle)

				Heap.LastVehicle = false
			end
		end

		Citizen.Wait(sleepThread)
	end
end)