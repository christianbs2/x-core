GetTopList = function(responses)
    if not responses or #responses <= 0 then return {} end

    for _, player in ipairs(responses) do
        local dataStorage = exports["x-datastorage"]:GetStorage(player.characterId)

        player.minutesInDuty = dataStorage.Get("MINUTES_IN_DUTY") or 0
    end

    local topList = {
        {
            Label = "Ekonomi",
            Players = {},
            Prefix = "",
            Suffix = ""
        },
        {
            Label = "Speltimmar",
            Players = {},
            Prefix = "",
            Suffix = ""
        },
        {
            Label = "Tjänstetimmar",
            Players = {},
            Prefix = "",
            Suffix = ""
        }
    }

    table.sort(responses, function(a, b)
        return a.cash + a.bank > b.cash + b.bank
    end)

    for index, player in ipairs(responses) do
        table.insert(topList[1].Players, {
            Name = player.name or player.firstname,
            Character = player.firstname .. " " .. player.lastname,
            Amount = player.cash .. " kr + " .. player.bank .. " kr"
        })

        if index >= 5 then
            break
        end
    end

    table.sort(responses, function(a, b)
        return a.timePlayed > b.timePlayed
    end)

    local convertTime = function(minutes)
        return math.floor(minutes / 60), (minutes % 60)
    end

    for index, player in ipairs(responses) do
        local hours, minutes = convertTime(player.timePlayed)

        table.insert(topList[2].Players, {
            Name = player.name or player.firstname,
            Character = player.firstname .. " " .. player.lastname,
            Amount = hours .. " timmar och " .. minutes .. " minuter"
        })

        if index >= 5 then
            break
        end
    end

    table.sort(responses, function(a, b)
        return a.minutesInDuty > b.minutesInDuty
    end)

    for index, player in ipairs(responses) do
        local hours, minutes = convertTime(player.minutesInDuty)

        table.insert(topList[3].Players, {
            Name = player.name or player.firstname,
            Character = player.firstname .. " " .. player.lastname,
            Amount = hours .. " timmar och " .. minutes .. " minuter"
        })

        if index >= 5 then
            break
        end
    end

    return topList
end

GetCompanies = function()
    local companies = {}

    local players = X.GetPlayers()

    for pSource, _ in pairs(players) do
        local character = exports["x-character"]:FetchCharacter(pSource)

        if character then
            local jobData = exports["x-jobs"]:GetJobData(character.job.name)

            if jobData then
                if not companies[jobData.Label] then companies[jobData.Label] = {
                    HasJob = 0,
                    InDuty = 0
                } end

                companies[jobData.Label].HasJob = companies[jobData.Label].HasJob + 1

                if character.custom["CHARACTER_IN_DUTY"] then
                    companies[jobData.Label].InDuty = companies[jobData.Label].InDuty + 1
                end
            end
        end
    end

    local actualTable = {}

    for companyLabel, companyData in pairs(companies) do
        table.insert(actualTable, {
            Name = companyLabel,

            HasJob = companyData.HasJob,
            InDuty = companyData.InDuty
        })
    end

    table.sort(actualTable, function(a, b)
        return a.Name < b.Name
    end)

    return actualTable
end 

RegisterCommand("wladd", function(src, args)
    local user = exports["x-core"]:FetchUser(src)
    local character = exports["x-character"]:FetchCharacter(src)

    if not user.isAdmin() then return end
    if not args[1] then return end
    local steamID = 'steam:' .. args[1]:lower()

    if string.len(steamID) ~= 21 then
        character.triggerEvent("x-core:notify", "System", "Invalid steam ID length", 5000, "success")
        return
    end

    MySQL.Async.fetchAll('SELECT * FROM x_users_whitelist WHERE steamHex = @identifier', {
        ['@identifier'] = steamID
    }, function(result)
        if result[1] ~= nil then
            character.triggerEvent("x-core:notify", "System", "Denna Spelare är redan whitelistad på denna server!", 5000, "success")
            else

            MySQL.Async.execute('INSERT INTO x_users_whitelist (SteamHex) VALUES (@identifier)', {
                ['@identifier'] = steamID
            }, function (rowsChanged)
            character.triggerEvent("x-core:notify", "System", "Spelaren har nu blivit Whitelistad!", 5000, "success")
            print('Whitelist: ' .. steamID .. ' DONE')
                end)
        end
    end)
end)

RegisterCommand("rwladd", function(src, args)

    if not args[1] then return end
    local steamID = 'steam:' .. args[1]:lower()

	if string.len(steamID) ~= 21 then
	end

    MySQL.Async.fetchAll('SELECT * FROM x_users_whitelist WHERE steamHex = @identifier', {
		['@identifier'] = steamID
	}, function(result)
		if result[1] ~= nil then
            else

			MySQL.Async.execute('INSERT INTO x_users_whitelist (SteamHex) VALUES (@identifier)', {
				['@identifier'] = steamID
			}, function (rowsChanged)
            print('Whitelist: ' .. steamID .. ' DONE')
                end)
		end
	end)
end)

RegisterCommand("wlrev", function(src, args)
	local user = exports["x-core"]:FetchUser(src)
    local character = exports["x-character"]:FetchCharacter(src)

	if not user.isAdmin() then return end
    if not args[1] then return end
    local steamID = 'steam:' .. args[1]:lower()

	if string.len(steamID) ~= 21 then
        character.triggerEvent("x-core:notify", "System", "Invalid steam ID length", 5000, "success")
		return
	end

    MySQL.Async.fetchAll('SELECT * FROM x_users_whitelist WHERE steamHex = @identifier', {
		['@identifier'] = steamID
	}, function(result)
		if result[1] == nil then
			character.triggerEvent("x-core:notify", "System", "Denna Spelare är inte whitelistad på denna server!", 5000, "success")		
            else
            MySQL.Async.execute('DELETE FROM x_users_whitelist WHERE SteamHex = @SteamHex',{["@SteamHex"] = steamID})
            --[[
			MySQL.Async.execute('DELETE FROM x_users_whitelist (SteamHex) VALUES (@identifier)', {
				['@identifier'] = steamID
			}, function (rowsChanged)
			--]]
			character.triggerEvent("x-core:notify", "System", "Spelaren har nu ingen Whitelistad på denna server!", 5000, "success")			
            print('Whitelist: ' .. steamID .. ' DONE')
                --end)
		end
	end)
end)


-- Command to refresh the whitelist
RegisterCommand("wlrefresh", function(src, args)
    MySQL.Async.fetchAll('SELECT * FROM x_users_whitelist', {}, function(result)
        if result then
            -- Clear the local cache of whitelisted players
            whitelistedPlayers = {}

            -- Update the cache with the new data
            for i, player in ipairs(result) do
                table.insert(whitelistedPlayers, player.steamHex)
            end

            print("Whitelist refreshed. Total players: " .. #whitelistedPlayers)
        else
            print("Failed to refresh the whitelist.")
        end
    end)
end)
