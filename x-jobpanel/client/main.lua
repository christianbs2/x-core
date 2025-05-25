X = false

Heap = {}

Citizen.CreateThread(function()
    while not X do
        Citizen.Wait(0)

        X = exports["x-core"]:FetchMain()
    end
end)

Citizen.CreateThread(function()
	while true do
		local sleepThread = 5000

		local ped = PlayerPedId()
		
		if ped ~= Heap.Ped then
			Heap.Ped = ped
		end

		Citizen.Wait(sleepThread)
	end
end)