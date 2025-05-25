X = {}

Heap = {
	["vehicles"] = {}
}

TriggerEvent("x-core:fetchMain", function(library) 
	X = library 
end)

MySQL.ready(function()
	local sqlQuery = [[
		SELECT
			vehiclePlate, vehicleOwner, vehicleData
		FROM
			x_characters_vehicles
	]]

	MySQL.Async.fetchAll(sqlQuery, {}, function(responses)
		for responseIndex, responseData in ipairs(responses) do
			local vehicleData = json.decode(responseData["vehicleData"])

			local sqlQuery = [[
				SELECT
					firstname
				FROM
					x_characters
				WHERE
					characterId = @cid
			]]

			local playerExists = MySQL.Sync.fetchAll(sqlQuery, {
				["@cid"] = responseData.vehicleOwner
			})

			if not playerExists[1] then
				local deleteSQL = [[
					DELETE
						FROM
					x_characters_vehicles
						WHERE
					vehiclePlate = @plate
				]]

				MySQL.Sync.execute(deleteSQL, {
					["@plate"] = responseData.vehiclePlate
				})

				X.Log("Deleted:", responseData.vehiclePlate)
			end
		end
	end)
end)

RegisterServerEvent("x-core:playerDropped")
AddEventHandler("x-core:playerDropped", function(_source)
	
end)

RegisterServerEvent("x-vehicles:lowerDurability")
AddEventHandler("x-vehicles:lowerDurability", function(itemData)
	local character = exports["x-character"]:FetchCharacter(source)

	if not character then return end

	local screwdriverItem = exports["x-inventory"]:GetInventoryItem(character, {
		Item = {
			Name = "screwdriver"
		}
	})

	if not screwdriverItem then return end

	if screwdriverItem.MetaData and screwdriverItem.MetaData.Durability then
		local oldDurability = screwdriverItem.MetaData.Durability
		local newDurability = oldDurability - math.random(5, 7)

		if newDurability < 0 then
			newDurability = 0
		end

		screwdriverItem.MetaData.Durability = newDurability

		exports["x-inventory"]:EditInventoryItem(character, {
			Item = screwdriverItem,
			Inventory = screwdriverItem.Inventory
		})

		if character.custom["RELATIONSHIP_LUCY"] and character.custom["RELATIONSHIP_LUCY"].relation > 0 then
			exports["x-tuner"]:CompleteQuest(character, "QUEST_HOTWIRE_VEHICLE")
		end
	end
end)

X.CreateCallback("x-vehicles:addVehicle", function(source, callback, vehicleData, targetCharacterId, onlyKey)
	local character = exports["x-character"]:FetchCharacter(source)

	if targetCharacterId then
		character = exports["x-character"]:FetchCharacterWithCid(targetCharacterId)
	end

	if not character then return callback(false) end

	exports["x-inventory"]:AddInventoryItem(character, {
		Item = {
			Name = "key",
			Count = 1,
			MetaData = {
				Key = vehicleData.plate,
				Label = vehicleData.plate,
				Description = {
					{
						Title = "Fordonsnyckel",
						Text = ""
					},
					{
						Title = "Fordon:",
						Text = vehicleData.label
					},
					{
						Title = "Registreringsplåt:",
						Text = vehicleData.plate
					}
				},
				Logo = "vehicle_key"
			}
		},
		Inventory = "KEYCHAIN_" .. character.characterId
	})

	if onlyKey then return end

	CreateVehicle(character, vehicleData, function(created)
		callback(created)
	end)
end)

X.CreateCallback("x-vehicles:updatePosition", function(source, callback, vehiclePlate, vehiclePosition)
	local character = exports["x-character"]:FetchCharacter(source)

	if not character then return callback(false) end

	local vehicle = Heap["vehicles"][vehiclePlate]

	if not vehicle then return callback(false) end

	vehicle["position"]["edit"](vehiclePosition)

	callback(true)
end)

GetPlayerVehicles = function(charId)
	local playerVehicles = {}

	for vehiclePlate, vehicleObject in pairs(Heap["vehicles"]) do
		if vehicleObject["owner"]["current"] == charId then
			table.insert(playerVehicles, vehicleObject)
		end
	end

	return playerVehicles
end

X.CreateCallback("x-vehicles:fetchPlayerVehicles", function(source, callback)
	local character = exports["x-character"]:FetchCharacter(source)

	if not character then return callback(false) end

	local fetchSQL = [[
		SELECT
			*
		FROM
			x_characters_vehicles
		WHERE
			vehicleOwner = @owner
	]]

	MySQL.Async.fetchAll(fetchSQL, {
		["@owner"] = character.characterId
	}, function(responses)
		callback(responses)
	end)
end)

X.CreateCallback("x-vehicles:saveVehicle", function(source, callback, vehicleProperties)
	local character = exports["x-character"]:FetchCharacter(source)

	if not character then return callback(false) end

	local saveSQL = [[
		UPDATE
			x_characters_vehicles
		SET
			vehicleData = @data
		WHERE
			vehiclePlate = @plate
	]]

	MySQL.Async.execute(saveSQL, {
		["@plate"] = vehicleProperties.plate,
		["@data"] = json.encode(vehicleProperties)
	}, function(rowsChanged)


		callback(rowsChanged > 0)
	end)
end)

UseScrewdriver = function(character, itemData)
	if not character then return end

	local durability = itemData.MetaData and itemData.MetaData.Durability

	if durability > 0 then
		TriggerClientEvent("x-vehicles:screwdriverUsed", character.source, itemData)
	else
		character.triggerEvent("x-core:notify", "Skruvmejsel", "Din skruvmejsel är trasig.", 3500, "error")
	end
end

X.CreateCallback("x-vehicles:usePickgun", function(pSource, callback)
	local character = exports["x-character"]:FetchCharacter(pSource)

	if not character then return callback(false) end

	local pickgunItem = exports["x-inventory"]:GetInventoryItem(character, {
		Item = {
			Name = "pick_gun"
		}
	})

	if not pickgunItem then return callback(false) end

	if pickgunItem.MetaData and pickgunItem.MetaData.Durability then
		local oldDurability = pickgunItem.MetaData.Durability
		local newDurability = oldDurability - math.random(16, 38)

		if newDurability < 0 then
			newDurability = 0
		end

		pickgunItem.MetaData.Durability = newDurability

		local edited = exports["x-inventory"]:EditInventoryItem(character, {
			Item = pickgunItem,
			Inventory = pickgunItem.Inventory
		})

		if character.custom["RELATIONSHIP_LUCY"] and character.custom["RELATIONSHIP_LUCY"].relation > 0 then
			exports["x-tuner"]:CompleteQuest(character, "QUEST_USE_PICK_GUN")
		end

		return callback(edited)
	end

	return callback(false)
end)

RegisterNetEvent("x-vehicles:applyValues")
AddEventHandler("x-vehicles:applyValues", function(vehicleEntity, vehicleProperties)
	local vehicleHandle = NetworkGetEntityFromNetworkId(vehicleEntity)

	if vehicleHandle and DoesEntityExist(vehicleHandle) then
		local stateBag = Entity(vehicleHandle).state

		if vehicleProperties.wheelPositionFront then
			stateBag.VEHICLE_POSITION_FRONT = vehicleProperties.wheelPositionFront
			stateBag.VEHICLE_POSITION_REAR = vehicleProperties.wheelPositionRear
			stateBag.VEHICLE_CAMBER_FRONT = vehicleProperties.wheelCamberFront
			stateBag.VEHICLE_CAMBER_REAR = vehicleProperties.wheelCamberRear

			stateBag.VEHICLE_WHEEL_WIDTH = vehicleProperties.wheelWidth
		end

		if vehicleProperties.coatingApplied then
			stateBag.VEHICLE_COATING_APPLIED = vehicleProperties.coatingApplied
		end

		if vehicleProperties.nitrousOxideLevel then
			stateBag.VEHICLE_NITROUS_OXIDE_LEVEL = vehicleProperties.nitrousOxideLevel + 0.0
		end

		if vehicleProperties.accelerationMultiplier then
			stateBag.VEHICLE_ACCELERATION_MULTIPLIER = vehicleProperties.accelerationMultiplier + 0.0
		end

		if vehicleProperties.speedMultiplier then
			stateBag.VEHICLE_SPEED_MULTIPLIER = vehicleProperties.speedMultiplier + 0.0
		end

		if vehicleProperties.distanceTraveled then
			stateBag.VEHICLE_TRAVELED_METERS = vehicleProperties.distanceTraveled + 0.0
		end

		if vehicleProperties.hasNeon then
			stateBag.VEHICLE_HAS_NEON = true
		end

		if vehicleProperties.neonEnabled then
			if not stateBag.VEHICLE_HAS_NEON then
				stateBag.VEHICLE_HAS_NEON = vehicleProperties.hasNeon or vehicleProperties.neonEnabled[1]
			end
		end
	end
end)