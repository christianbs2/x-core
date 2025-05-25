Citizen.CreateThread(function()
    X.CreateCallback("x-jobpanel:fetchPanelData", function(source, callback, jobName)
        local character = exports["x-character"]:FetchCharacter(source)

        if not character then return callback(false) end

        local jobData = exports["x-jobs"]:GetJobData(jobName)

        if not jobData then return callback(false) end

        local grades = {}

        for _, grade in ipairs(jobData.Grades) do
            table.insert(grades, grade.Label)
        end

        local account = GetAccount(string.upper(jobName))

        local dataStorage = exports["x-datastorage"]:GetStorage(character.characterId)

        local isBoss = jobData.Grades[character.job.grade].Boss

        local permissions = dataStorage and dataStorage.Get("JOB_PERMISSIONS") or {
            ACCESS_ONE = isBoss and true or false,
            ACCESS_TWO = isBoss and true or false,
            ACCESS_THREE = isBoss and true or false
        }

        local returnData = {
            Job = {
                Name = string.lower(jobName),

                Label = jobData.Label,

                Permissions = permissions,

                Boss = isBoss,

                Grade = {
                    Label = jobData.Grades[character.job.grade].Label,
                    Index = character.job.grade
                },
                Grades = grades,

                Balance = account.Balance
            },

            Employees = {},

            Invoices = {}
        }

        local invoices = exports["x-invoice"]:GetInvoicesFromCache(jobData.Label)

        for _, invoiceData in ipairs(invoices) do
            if invoiceData.id then
                local jobInfo = exports["x-jobs"]:GetJobData(invoiceData.owner)

                table.insert(returnData.Invoices, {
                    Id = invoiceData.id,
                    Name = invoiceData.invoiceData.name,
                    Receiver = jobInfo and jobInfo.Label or invoiceData.owner,
                    TotalAmount = invoiceData.invoiceData.total,
                    Date = invoiceData.invoiceData.createdDate,
                    InvoiceData = invoiceData
                })
            end
        end

        local fetchSQL = [[
            SELECT
                characterId, firstname, lastname, jobGrade
            FROM
                x_characters
            WHERE
                LOWER(job) = @job
        ]]

        MySQL.Async.fetchAll(fetchSQL, {
            ["@job"] = string.lower(jobName)
        }, function(responses)
            if not responses then return callback(returnData) end

            for _, responseData in ipairs(responses) do
                local dataStorage = exports["x-datastorage"]:GetStorage(responseData.characterId)

                local revenues = dataStorage and dataStorage.Get("REVENUE") or {}

                local revenue = revenues and revenues[string.upper(jobName)] or 0

                local minutesInDuty = dataStorage and dataStorage.Get("MINUTES_IN_DUTY") or 0

                local permissions = dataStorage and dataStorage.Get("JOB_PERMISSIONS") or {
                    ACCESS_ONE = false,
                    ACCESS_TWO = false
                }

                table.insert(returnData.Employees, {
                    Name = responseData.firstname .. " " .. responseData.lastname,
                    CharacterId = responseData.characterId,
                    Grade = grades[responseData.jobGrade],
                    Revenue = revenue,
                    MinutesInDuty = minutesInDuty,
                    Permissions = permissions
                })
            end

            callback(returnData)
        end)
    end)

    X.CreateCallback("x-jobpanel:orderVehicle", function(source, callback, vehicleData, jobName)
        local character = exports["x-character"]:FetchCharacter(source)
        if not character then return callback(false) end
    
    
        local price = tonumber(vehicleData.Price)
    
        MySQL.Async.execute([[
            INSERT INTO x_dealership_orders (characterId, dealership, vehicleData)
            VALUES (@characterId, @dealership, @vehicleData)
        ]], {
            ["@characterId"] = character.characterId,
            ["@dealership"] = "benefactor", -- eller använd companyName om du vill ändå logga korrekt
            ["@vehicleData"] = json.encode(vehicleData)
        }, function(rowsChanged)
            if rowsChanged > 0 then
                --X.Notify(source, companyName, ("Du beställde %s för %s kr."):format(vehicleData.Name or vehicleData.ModelName, price), 5000, "success")
            else
                X.Notify(source, "Beställning", "Något gick fel vid beställningen.", 5000, "error")
            end
            callback(rowsChanged > 0)
        end)
    end)

    X.CreateCallback("x-jobpanel:deliverVehicle", function(source, callback, orderData, vehicleProps)
        local character = exports["x-character"]:FetchCharacter(source)

        if not character then return callback(false) end

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
            ["@plate"] = vehicleProps.plate,
            ["@owner"] = orderData.Order.Owner,
            ["@data"] = json.encode(vehicleProps),
            ["@garage"] = orderData.Order.GarageName
        }, function(rowsChanged)
            if rowsChanged > 0 then
                exports["x-inventory"]:AddInventoryItem(character, {
                    Item = {
                        Name = "key",
                        Count = 1,
                        MetaData = {
                            Key = vehicleProps.plate,
                            Label = vehicleProps.plate,
                            Description = {
                                {
                                    Title = "Fordonsnyckel",
                                    Text = ""
                                },
                                {
                                    Title = "Fordon:",
                                    Text = vehicleProps.label
                                },
                                {
                                    Title = "Registreringsplåt:",
                                    Text = vehicleProps.plate
                                }
                            },
                            Logo = "vehicle_key"
                        }
                    },
                    Inventory = "KEYCHAIN_" .. character.characterId
                })

                callback(true)
            else
                callback(false)
            end
        end)
    end)
end)