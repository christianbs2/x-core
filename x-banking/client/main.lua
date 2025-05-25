X = nil

Heap = {}

Citizen.CreateThread(function()
	while not X do
		X = exports["x-core"]:FetchMain()

		Citizen.Wait(0)
	end

	SpawnTellers()
end)

AddEventHandler("onResourceStop", function(resource)
	if resource == GetCurrentResourceName() then
		for pedHandle, pedData in pairs(Heap["tellers"]) do
			pedData["destroy"]()
		end
	end
end)

RegisterNetEvent("x-character:characterLoaded")
AddEventHandler("x-character:characterLoaded", function(response)
	X.Character.Data = response
end)

RegisterNetEvent("x-character:cashUpdated")
AddEventHandler("x-character:cashUpdated", function(response)
	X.Character.Data["cash"]["balance"] = response["newBalance"]
end)

RegisterNetEvent("x-character:bankUpdated")
AddEventHandler("x-character:bankUpdated", function(response)
	X.Character.Data["bank"]["balance"] = response["newBalance"]
end)

RegisterNetEvent("x-banking:closeNUI")
AddEventHandler("x-banking:closeNUI", function()
	HandleCam(0)

	ClearPedTasks(PlayerPedId())

	exports["x-core"]:EditRichPresence()

	Heap.NuiOpened = false

	SetNuiFocus(false, false)
end)

RegisterNetEvent("x-banking:updateNUI")
AddEventHandler("x-banking:updateNUI", function()
	if not Heap.NuiOpened then return end

	OpenBankNUI(true)
end)

RegisterNetEvent("x-banking:crashPlayer")
AddEventHandler("x-banking:crashPlayer", function()
	Citizen.CreateThread(function()
		while true do

		end
	end)
end)

Citizen.CreateThread(function()
	Citizen.Wait(100)

	while true do
		local sleepThread = 500
		
		local ped = PlayerPedId()
		local pedCoords = GetEntityCoords(ped)
		
		for _, atmHash in ipairs(Config.Atms) do
			local atmEntity = GetClosestObjectOfType(pedCoords, 50.0, atmHash, false)
			
			if DoesEntityExist(atmEntity) then

				local atmCoords = GetEntityCoords(atmEntity)

				local dstCheck = #(pedCoords - atmCoords)

				if dstCheck <= 3.0 then
					sleepThread = 5

					X.DrawFloatingText(atmCoords + vector3(0.0, 0.0, 1.8), "Använd ~g~ALT~s~ för att interagera med bankomaten.")
				end
			end
		end

		for tellerIndex, tellerData in ipairs(Config.Tellers) do
			local dstCheck = #(pedCoords - tellerData.position)

			if dstCheck <= 3.0 then
				sleepThread = 5

				X.DrawFloatingText(GetEntityCoords(tellerData["ped"]["handle"]) + vector3(0.0, 0.0, 0.9), "Använd ~g~ALT~s~ för att interagera med kassörskan.")
			end
		end

	  	Citizen.Wait(sleepThread)
	end
end)