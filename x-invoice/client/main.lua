Heap = {}

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
end)

RegisterNetEvent("x-character:jobUpdated")
AddEventHandler("x-character:jobUpdated", function(newData)
    X.Character.Data.job = newData
end)

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        SetNuiFocus(false, false)
    end
end)
