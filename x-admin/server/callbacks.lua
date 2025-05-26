Citizen.CreateThread(function()
    X.CreateCallback("x-admin:fetchPlayers", function(source, callback)
        local character = exports["x-character"]:FetchCharacter(source)

        if not character then return end

        local players = X.GetPlayers()

        local users = {}

        for _, user in pairs(players) do
            if user then
                local character = exports["x-character"]:FetchCharacter(user.source)

                table.insert(users, {
                    Id = user.source,
                    Identifier = user.identifier,
                    Name = user.name,
                    Character = character and (character.identification.firstname .. " " .. character.identification.lastname) or "Väljer karaktär...",
                    Ping = GetPlayerPing(user.source),
                    Data = user.data
                })
            end
        end

        local fetchCharactersSQL = [[
            SELECT
                x_characters.*, x_users.name
            FROM
                x_characters
            LEFT JOIN x_users
                ON x_characters.steamHex = x_users.identifier
        ]]

        MySQL.Async.fetchAll(fetchCharactersSQL, {}, function(responses)
            local topList = GetTopList(responses)

            local gangs = exports["x-gangsystem"]:GetGangs()

            local companies = GetCompanies()

            callback(users, gangs, topList, companies)
        end)

    end)

    X.CreateCallback("x-admin:fetchPlayerInformation", function(source, callback, player)
        local character = exports["x-character"]:FetchCharacter(source)

        if not character then return end

        local fetchCharactersSQL = [[
            SELECT
                x_characters.*, x_users.name
            FROM
                x_characters
            LEFT JOIN x_users
                ON x_characters.steamHex = x_users.identifier
            WHERE
                x_characters.steamHex = @identifier
        ]]

        local fetchVehiclesSQL = [[
            SELECT
                *
            FROM
                x_characters_vehicles
            WHERE
                vehicleOwner = @cid
        ]]

        MySQL.Async.fetchAll(fetchCharactersSQL, {
            ["@identifier"] = player.Identifier
        }, function(responses)
            if responses and #responses > 0 then
                local isAdmin, permissionRank = exports["x-core"]:FetchUser(player.Id).isAdmin()

                local permissionRankName = Config.PermissionNames[permissionRank + 1] or "NORMAL"

                local dataToSendBack = {
                    Name = player.Name,

                    Identifier = player.Identifier,

                    Admin = isAdmin,

                    Status = {
                        {
                            Label = "Steam Hex",
                            Value = player.Identifier,
                            Icon = "mdi-account"
                        },
                        {
                            Label = "Tillstånd",
                            Value = permissionRankName,
                            Icon = "mdi-security"
                        },
                        {
                            Label = "Whitelist",
                            Value = "Ja",
                            Icon = "mdi-receipt",
                            Event = "x-admin:removeWhitelist"
                        }
                    },

                    Characters = {},

                    Jobs = {},
                    JobGrades = {}
                }

                local serverJobs = exports["x-jobs"]:GetJobs()

                for _, jobData in pairs(serverJobs) do
                    table.insert(dataToSendBack.Jobs, jobData.Label)

                    for _, gradeData in ipairs(jobData.Grades) do
                        if not dataToSendBack.JobGrades[jobData.Label] then dataToSendBack.JobGrades[jobData.Label] = {} end

                        table.insert(dataToSendBack.JobGrades[jobData.Label], gradeData.Label)
                    end
                end

                for responseIndex, responseData in ipairs(responses) do
                    MySQL.Async.fetchAll(fetchVehiclesSQL, {
                        ["@cid"] = responseData.characterId
                    }, function(vehicleResponses)
                        local character = exports["x-character"]:FetchCharacterWithIdentifier(responseData.steamHex)

                        responseData.vehicles = {}

                        if vehicleResponses and #vehicleResponses > 0 then
                            for _, vehicleData in ipairs(vehicleResponses) do
                                vehicleData.vehicleInside = vehicleData.vehicleInside == 0

                                table.insert(responseData.vehicles, vehicleData)
                            end
                        end

                        if character and character.characterId == responseData.characterId then
                            responseData.job = character.job.name
                            responseData.jobGrade = character.job.grade

                            responseData.dead = character.custom.IS_DEAD
                            responseData.health = GetEntityHealth(GetPlayerPed(character.source))
                            responseData.damages = exports["x-damagesystem"]:GetDamages(character)
                        end

                        local job = exports["x-jobs"]:GetJobData(responseData.job)

                        responseData.job = job.Label
                        responseData.jobGrade = job.Grades[responseData.jobGrade].Label

                        responseData.skills = exports["x-skills"]:GetSkills(responseData.characterId)
                        responseData.cooldowns = exports["x-cooldown"]:GetCooldowns(responseData.characterId)

                        local fetchPropertiesSQL = 'SELECT houseData FROM x_characters_housings WHERE houseData LIKE "%' .. responseData.characterId .. '%"'

                        MySQL.Async.fetchAll(fetchPropertiesSQL, {

                        }, function(propertyResponses)
                            responseData.properties = {}

                            if propertyResponses and #propertyResponses > 0 then
                                for _, propertyResponse in ipairs(propertyResponses) do
                                    propertyResponse.houseData = json.decode(propertyResponse.houseData)

                                    table.insert(responseData.properties, propertyResponse.houseData)
                                end
                            end
                            
                            dataToSendBack.Characters[responseIndex] = responseData
                        end)
                    end)
                end

                while #dataToSendBack.Characters < #responses do
                    Citizen.Wait(0)
                end

                callback(dataToSendBack)
            end
        end)
    end)

    X.CreateCallback("x-admin:changeVehicleGarage", function(source, callback, vehicle)
        local character = exports["x-character"]:FetchCharacter(source)

        if not character then return end

        local sqlQuery = [[
            UPDATE
                x_characters_vehicles
            SET
                vehicleGarage = @newGarage
            WHERE
                vehiclePlate = @plate
        ]]

        MySQL.Async.execute(sqlQuery, {
            ["@plate"] = vehicle.vehiclePlate,
            ["@newGarage"] = vehicle.vehicleGarage
        }, function(rowsChanged)
            callback(rowsChanged > 0)
        end)
    end)
end)