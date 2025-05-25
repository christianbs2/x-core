X = false

Heap = {
	ShuffleDisabled = true
}

Citizen.CreateThread(function()
    while not X do
        Citizen.Wait(10)

        X = exports["x-core"]:FetchMain()
	end

	if exports["x-character"]:IsLoaded() then
		Initialize()
	end
end)

RegisterNetEvent("x-character:characterLoaded")
AddEventHandler("x-character:characterLoaded", function(response)
	X.Character.Data = response

	Initialize()
end)

RegisterNetEvent("x-vehicles:shuffleSeat")
AddEventHandler("x-vehicles:shuffleSeat", function()
	Heap.ShuffleDisabled = false

	Citizen.Wait(5000)

	Heap.ShuffleDisabled = true
end)

RegisterNetEvent("x-vehicles:toggleNeon")
AddEventHandler("x-vehicles:toggleNeon", function()
	local ped = PlayerPedId()
	local vehicleToSave = GetVehiclePedIsUsing(ped)

	if not DoesEntityExist(vehicleToSave) then return end
	if not GetPedInVehicleSeat(vehicleToSave, -1) == ped then return end

	ToggleNeon(vehicleToSave)
end)

RegisterNetEvent("x-vehicles:screwdriverUsed")
AddEventHandler("x-vehicles:screwdriverUsed", function(itemData)
	if IsPedInAnyVehicle(PlayerPedId()) then
		local vehicle = GetVehiclePedIsUsing(PlayerPedId())

		if GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() then
			if not GetIsVehicleEngineRunning(vehicle) then
				PlayAnimation(PlayerPedId(), "anim@veh@std@issi3@ds@base", "hotwire", {
					flag = 49
				})

				exports['progressbar']:Progress({
					label = "Tjuvkopplar...",
					duration = 35000,
					useWhileDead = false,
					canCancel = true,
					controlDisables = {
						disableMovement = true,
						disableCarMovement = false,
						disableMouse = false,
						disableCombat = true,
					},
				}, function(cancelled)
					if not cancelled then
						TriggerServerEvent("x-vehicles:lowerDurability", itemData)

						SetVehicleAlarm(vehicle, true)
						SetVehicleAlarmTimeLeft(vehicle, 35000)

						SetVehicleEngineOn(vehicle, true, true, false)

						ClearPedTasks(PlayerPedId())

						RemoveLoadingPrompt()

						DecorSetBool(vehicle, "HOTWIRED", true)

						X.Notify("Fordon", "Du tjuvkopplade fordonet.", 5000, "success")
					else
						X.Notify("Fordon", "Du avbröt tjuvkopplingen.", 5000, "error")
					end
				end)
			else
				X.Notify("Fordon", "Fordonet är igång?", 5000, "error")
			end
		else
			X.Notify("Fordon", "Du måste vara förare av fordonet.", 5000, "error")
		end
	else
		X.Notify("Fordon", "Du måste sitta i ett fordon.", 5000, "error")
	end
end)