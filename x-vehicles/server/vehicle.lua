NewVehicle = function(vehicleData)
    local self = {}

    self["plate"] = {
        ["current"] = vehicleData["plate"],
        ["edit"] = function(newPlate)
            self["plate"]["current"] = newPlate

            self["save"]()
        end
    }

    self["owner"] = {
        ["current"] = vehicleData["owner"],
        ["edit"] = function(newOwner)
            self["owner"]["current"] = newOwner

            self["save"]()
        end
    }

    self["garage"] = {
        ["current"] = vehicleData["garage"] or "MOTEL_GARAGE",
        ["edit"] = function(newGarage)
            self["garage"]["current"] = newGarage

            self["save"]()
        end
    }

    self["data"] = {
        ["current"] = vehicleData,
        ["edit"] = function(newData)
            self["data"]["current"] = newData

            self["save"]()
        end
    }

    self["position"] = {
        ["current"] = { 
            ["x"] = 0,
            ["y"] = 0,
            ["z"] = 0
        },
        ["edit"] = function(newPosition)
            self["position"]["current"] = newPosition
        end
    }

    self["save"] = function(callback)
        local sqlQuery = [[
            INSERT
                INTO
            x_characters_vehicles
                (vehiclePlate, vehicleOwner, vehicleData, vehicleGarage)
            VALUES
                (@plate, @owner, @data, @garage)
            ON DUPLICATE KEY UPDATE
                vehiclePlate = @plate, vehicleOwner = @owner, vehicleData = @data, vehicleGarage = @garage
        ]]

        MySQL.Async.execute(sqlQuery, {
            ["@plate"] = self["plate"]["current"],
            ["@owner"] = self["owner"]["current"],
            ["@data"] = json.encode(self["data"]["current"]["data"]),
            ["@garage"] = self["garage"]["current"]
        }, function(rowsChanged)
            if rowsChanged > 0 then
                X.Log("Successfully saved vehicle with plate:", self["plate"]["current"])

                TriggerClientEvent("x-vehicles:updateVehicle", -1, {
                    ["plate"] = self["plate"]["current"],
                    ["owner"] = self["owner"]["current"],
                    ["props"] = self["data"]["current"]["data"]
                })

                if callback then callback(true) end
            else
                if callback then callback(false) end
            end
        end)
    end

    return self
end

CreateVehicle = function(character, vehicleData, callback)
    local vehicleAdded = NewVehicle({
		["plate"] = vehicleData["plate"],
		["owner"] = character["characterId"],
		["data"] = vehicleData
	})

	if vehicleAdded then
		Heap["vehicles"][vehicleData["plate"]] = vehicleAdded

		vehicleAdded["save"](function(saved)
			if saved then
				callback(true)
			else
				callback(false)
			end
        end)
        
        X.Log("Created vehicle with data:", json.encode(vehicleData))
	end
end