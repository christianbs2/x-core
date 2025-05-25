X = {}

Heap = {
	["markets"] = {},
	["fetching"] = true
}

TriggerEvent("x-core:fetchMain", function(library)
	X = library
end)

RegisterServerEvent("x-markets:globalEvent")
AddEventHandler("x-markets:globalEvent", function(options)
	if options["data"] and options["data"]["save"] then
		local marketName = options["data"]["marketName"]
		
		if options["event"] == "BUST_MARKET_DOOR" then
			if not Heap["doors"] then
				Heap["doors"] = options["data"]["data"]
			end
			
			if Heap["markets"][marketName] then
				Heap["markets"][marketName]["marketState"] = eventData["doorState"] and "locked" or "unlocked"
			end

			if not Heap["ongoingRobberies"] then
				Heap["ongoingRobberies"] = {}
			end

			Heap["ongoingRobberies"][marketName] = true
			Heap["doors"][marketName][options["data"]["doorHash"]]["bustedDoor"] = true
			Heap["doors"][marketName][options["data"]["doorHash"]]["doorState"] = options["data"]["doorState"]
		elseif options["event"] == "LOCKPICK_CASH_REGISTER" then
			if not Heap["cashRegisters"] then
				Heap["cashRegisters"] = {}
			end

			if not Heap["cashRegisters"][marketName] then
				Heap["cashRegisters"][marketName] = {}
			end

			Heap["cashRegisters"][marketName][tostring(options["data"]["registerCoords"])] = true
		elseif options["event"] == "ROB_CASH_REGISTER" then
			if not Heap["robbedRegisters"] then
				Heap["robbedRegisters"] = {}
			end

			if not Heap["robbedRegisters"][marketName] then
				Heap["robbedRegisters"][marketName] = {}
			end

			Heap["robbedRegisters"][marketName][tostring(options["data"]["registerCoords"])] = true
		elseif options["event"] == "ROBBED_MARKET" then
			if not Heap["robbedMarkets"] then
				Heap["robbedMarkets"] = {}
			end

			Heap["robbedMarkets"][marketName] = true
		elseif options.event == "BREAK_SAFE_COMPLETED" then 
			if not Heap.RobbedStores then Heap.RobbedStores = {} end 

			table.insert(Heap.RobbedStores, {Name = options.data.Store, ItemCoords = options.data.ItemCoords}) 
			CreateItems(options.data.ItemCoords, source)
		end
	end

    TriggerClientEvent("x-markets:eventHandler", -1, options["event"] or "none", options["data"] or nil)
end)

CreateItems = function(itemCoords, source)
	local character

	if source then 
		character = exports["x-character"]:FetchCharacter(source)
	end

	local spawnedItems = {}

	for _, data in pairs(Config.RobberyItems) do 
		local random = math.random(1, 100)

		if #spawnedItems >= 2 then break end

		if data.Luck and random <= data.Luck then
			table.insert(spawnedItems, data)
		end 
	end
	
	for itemIndex, itemData in pairs(spawnedItems) do 
		TriggerEvent("x-inventory:createDroppedItem", itemCoords[itemIndex], {
			Name = itemData.Name,
			Count = 1,
			Weight = 0.2,
			MetaData = itemData.Meta and itemData.Meta or {},
			Slot = itemIndex,
		})

		Citizen.Wait(200)
	end

	if character then
		local earnedCash = math.random(Config.CashAmount[1], Config.CashAmount[2])

		character.cash.add(earnedCash)

		character.triggerEvent("x-core:notify", "Kassaskåp", "Du plockade upp " .. earnedCash .. " kr i kontanter.", 7500, "success")
	end
end

HasMoney = function(character, amount, description, marketName, cb)
	if character["cash"]["balance"] >= amount then
		character["cash"]["remove"](amount)

		-- exports["x-logs"]:Log("MARKET PURCHASE | CASH | PURCHASED MARKET: " .. marketName .. " | " .. character["identification"]["firstname"] .. " " .. character["identification"]["lastname"] .. " | " .. amount .. " kr", "Köpte affär " .. marketName .. " för " .. amount .. " kr.", "MARKETS_PURCHASE_MARKET")
		exports.JD_logs:createLog({
			EmbedMessage = "MARKET PURCHASE | CASH | PURCHASED MARKET: " .. marketName .. " | " .. character["identification"]["firstname"] .. " " .. character["identification"]["lastname"] .. " | " .. amount .. " kr", "Köpte affär " .. marketName .. " för " .. amount .. " kr.",
			channel = "market",
		})
		
		cb(true)
	elseif character["bank"]["balance"] >= amount then
		character["bank"]["remove"](amount, {
			["type"] = "removed",
			["description"] = description or "Not specified",
			["amount"] = amount
		})

		-- exports["x-logs"]:Log("MARKET PURCHASE | BANK | PURCHASED MARKET: " .. marketName .. " | " .. character["identification"]["firstname"] .. " " .. character["identification"]["lastname"] .. " | " .. amount .. " kr", "Köpte affär " .. marketName .. " för " .. amount .. " kr.", "MARKETS_PURCHASE_MARKET")
		exports.JD_logs:createLog({
			EmbedMessage = "MARKET PURCHASE | BANK | PURCHASED MARKET: " .. marketName .. " | " .. character["identification"]["firstname"] .. " " .. character["identification"]["lastname"] .. " | " .. amount .. " kr", "Köpte affär " .. marketName .. " för " .. amount .. " kr.",
			channel = "market",
		})

		cb(true)
	else
		cb(false)
	end
end

Citizen.CreateThread(function()
	while true do
		local sleepThread = 500000
		
		local sqlQuery = [[
			UPDATE
				x_markets
			SET
				marketData = @marketData
			WHERE
				uuid = @uuid
		]]

		for marketName, marketData in pairs(Heap["markets"]) do
			MySQL.Async.execute(sqlQuery, {
				["@uuid"] = marketData["marketUUID"],
				["@marketData"] = json.encode(marketData["marketData"])
			}, function(rowsChanged)
				if rowsChanged > 0 then
					print("Succesfully updated market " .. marketName, "with data", json.encode(marketData["marketData"]))
				end
			end)
		end

		Citizen.Wait(sleepThread)
	end
end)

Citizen.CreateThread(function()
	Citizen.Wait(1500)

	local onlineOfficers = FetchOfficerCount()

	TriggerClientEvent("x-markets:officerCount", -1, onlineOfficers)

	while true do
		local sleepThread = 120000
		
		local onlineOfficers = FetchOfficerCount()

		TriggerClientEvent("x-markets:officerCount", -1, onlineOfficers)

		Citizen.Wait(sleepThread)
	end
end)

FetchOfficerCount = function()
	local onlineOfficers = 0
	local players = X.GetPlayers()

	for pSource, _ in pairs(players) do
		local player = exports["x-character"]:FetchCharacter(pSource)

		if player and player.job.name == "police" and player.custom.CHARACTER_IN_DUTY then
			onlineOfficers = onlineOfficers + 1
		end
	end

	return onlineOfficers
end