LoadCharacter = function(source, loadData)
    local query = [[
        SELECT
            *
        FROM
            x_characters
        WHERE
            characterId = @cid
    ]]

    MySQL.Async.fetchAll(query, {
        ["@cid"] = loadData["id"]
    }, function(response)
        if response and #response > 0 then
            local characterData = response[1]

            local characterLoaded = CreateCharacter(source, characterData)

            X.LoadedCharacters[source] = characterLoaded
            
            local characterPosition = loadData["position"]

            if characterPosition ~= "last" then
                characterLoaded["position"].update(Config.SpawnPositions[characterPosition])
            end

            characterLoaded.triggerEvent("x-character:characterLoaded", X.LoadedCharacters[source])
            TriggerEvent("x-character:characterLoaded", source, X.LoadedCharacters[source])

            characterLoaded["custom"]["add"]("timePlayed", characterData["timePlayed"])

            Player(source).state.identification = characterLoaded.identification

            X.Log("Player", GetPlayerName(source), "selected the character:", loadData["id"])
        end
    end)
end

CreateCharacterInDatabase = function(source, characterData)
    local user = exports["x-core"]:FetchUser(source)

    if user then
        local firstname = characterData["firstname"]
        local lastname = characterData["lastname"]
        local dateofbirth = characterData["dateofbirth"]

        if firstname and #firstname > 0 and lastname and #lastname > 0 and dateofbirth and #dateofbirth > 0 then
            local query = [[
                INSERT
                    INTO
                x_characters
                    (steamHex, characterId, firstname, lastname, dateofbirth, lastdigits, length, gender, bloodType, position)
                VALUES
                    (@hex, @cid, @firstname, @lastname, @dob, @lastdigits, @length, @gender, @blood, @position)
            ]]

            math.randomseed(os.time() * GetGameTimer() + source)

            local generatedLastDigits = math.random(1000, 9999)
            local generatedBloodGroup = Config.BloodTypes[math.random(#Config.BloodTypes)]

            MySQL.Async.execute(query, {
                ["@hex"] = user["identifier"],
                ["@cid"] = dateofbirth .. "-" .. generatedLastDigits,
                ["@firstname"] = firstname,
                ["@lastname"] = lastname,
                ["@dob"] = dateofbirth,
                ["@lastdigits"] = generatedLastDigits,
                ["@length"] = characterData["length"],
                ["@gender"] = characterData["gender"] == "Man" and "M" or "F",
                ["@blood"] = generatedBloodGroup,
                ["@position"] = json.encode(vector3(0.0, 0.0, 0.0))
            }, function(rowsChanged)
                if rowsChanged > 0 then
                    X.Log("Created character with cid:", dateofbirth .. "-" .. generatedLastDigits, "on hex:", user["identifier"])

                    TriggerEvent("x-character:characterCreated", source, dateofbirth .. "-" .. generatedLastDigits)
                else
                    X.Log("Failed to create character on hex:", user["identifier"])
                end
            end)
        else
            X.Log("Wrong arguments.")
        end
    else
        X.Log("User with source:", source, "could not get fetched?")
    end
end

DeleteCharacterInDatabase = function(source, characterId)
    if not characterId then return end

    local deleteSQL = [[
        DELETE
            FROM
        x_characters
            WHERE
        characterId = @cid
    ]]

    MySQL.Async.execute(deleteSQL, {
        ["@cid"] = characterId
    }, function(rowsChanged)
        if rowsChanged > 0 then
            TriggerClientEvent("x-character:refreshSelection", source)
        end
    end)
end

CreateCharacter = function(source, characterData)
    local self = {}

    self["data"] = characterData

    self["characterId"] = characterData["characterId"]
    
    self["source"] = source

    self["triggerEvent"] = function(eventName, ...)
        TriggerClientEvent(eventName, self["source"], ...)
    end

    self["custom"] = {
        ["add"] = function(customKey, customData)
            if not customKey then return end
            if customKey == "add" then return end

            self["custom"][customKey] = customData

            self.triggerEvent("x-character:customDataEdited", {
                ["key"] = customKey,
                ["data"] = customData
            })
        end
    }

    -- Identification
    self["identification"] = {
        ["firstname"] = characterData["firstname"],
        ["lastname"] = characterData["lastname"],
        ["dateofbirth"] = characterData["dateofbirth"],
        ["lastdigits"] = characterData["lastdigits"],
        ["bloodtype"] = characterData["bloodType"]
    }

    -- Position
    self["position"] = {
        ["coords"] = json.decode(characterData["position"]),
        ["update"] = function(newPos, setPos)
            self["position"]["coords"] = newPos

            if not setPos then return end

            self.triggerEvent("x-core:setPosition", newPos)
        end
    }

    -- Appearance
    self["appearance"] = {
        ["current"] = json.decode(characterData["appearance"]),
        ["update"] = function(newAppearance, setAppearance)
            self["appearance"]["current"] = newAppearance

            if not setAppearance then return end

            self.triggerEvent("x-appearance:setAppearance", newAppearance)
        end
    }

    -- Money Management
    self["cash"] = {
        ["balance"] = characterData["cash"],
        ["remove"] = function(sub)
            self["cash"]["balance"] = self["cash"]["balance"] - sub

            self.triggerEvent("x-character:cashUpdated", {
                ["oldBalance"] = self["cash"]["balance"] + sub,
                ["newBalance"] = self["cash"]["balance"]
            })
        end,
        ["add"] = function(add)
            self["cash"]["balance"] = self["cash"]["balance"] + add

            self.triggerEvent("x-character:cashUpdated", {
                ["oldBalance"] = self["cash"]["balance"] - add,
                ["newBalance"] = self["cash"]["balance"]
            })
        end,
        ["set"] = function(amount)
            local oldAmount = self["cash"]["balance"]

            self["cash"]["balance"] = tonumber(amount)

            self.triggerEvent("x-character:cashUpdated", {
                ["oldBalance"] = oldAmount,
                ["newBalance"] = tonumber(amount)
            })
        end
    }

    self["bank"] = {
        ["balance"] = characterData["bank"],
        ["remove"] = function(sub, transactionData)
            self["bank"]["balance"] = self["bank"]["balance"] - sub

            self.triggerEvent("x-character:bankUpdated", {
                ["oldBalance"] = self["bank"]["balance"] + sub,
                ["newBalance"] = self["bank"]["balance"]
            })

            if not transactionData then return end

            self["bank"]["transaction"]["add"](transactionData)
        end,
        ["add"] = function(add, transactionData)
            self["bank"]["balance"] = self["bank"]["balance"] + add

            self.triggerEvent("x-character:bankUpdated", {
                ["oldBalance"] = self["bank"]["balance"] - add,
                ["newBalance"] = self["bank"]["balance"]
            })

            if not transactionData then return end

            self["bank"]["transaction"]["add"](transactionData)
        end,
        ["set"] = function(amount)
            local oldAmount = self["bank"]["balance"]

            self["bank"]["balance"] = tonumber(amount)

            self.triggerEvent("x-character:bankUpdated", {
                ["oldBalance"] = oldAmount,
                ["newBalance"] = tonumber(amount)
            })
        end,
        ["transaction"] = {
            ["add"] = function(transactionData)
                local transactionQuery = [[
                    INSERT
                        INTO
                    x_characters_bank_transactions
                        (characterId, type, description, amount, occurred)
                    VALUES
                        (@cid, @type, @desc, @amount, @occurred)
                ]]

                local timeOccurred = os.date("*t", os.time())

                local month = timeOccurred.month < 10 and "0" .. timeOccurred.month or timeOccurred.month
                local day = timeOccurred.day < 10 and "0" .. timeOccurred.day or timeOccurred.day

                timeOccurred = timeOccurred.year .. "-" .. month .. "-" .. day .. " " .. timeOccurred.hour .. ":" .. timeOccurred.min .. ":" .. timeOccurred.sec

                MySQL.Async.execute(transactionQuery, {
                    ["@cid"] = self["characterId"],
                    ["@type"] = transactionData["type"],
                    ["@desc"] = transactionData["description"],
                    ["@amount"] = transactionData["amount"],
                    ["@occurred"] = timeOccurred
                }, function(rowsChanged)
                    if rowsChanged > 0 then
                        -- Future maybe client event to bank job?
                    end
                end)
            end
        }
    }

    -- Job Management
    self["job"] = {
        ["name"] = characterData["job"],
        ["grade"] = characterData["jobGrade"],
        ["change"] = function(newData)
            local oldJob = {
                ["name"] = self["job"]["name"],
                ["grade"] = self["job"]["grade"]
            }

            self["job"]["name"] = newData["job"] or "unemployed"
            self["job"]["grade"] = newData["grade"] or 1

            self.triggerEvent("x-character:jobUpdated", {
                ["name"] = newData["job"],
                ["grade"] = newData["grade"]
            })
            TriggerEvent("x-character:jobUpdated", self["source"], {
                ["last"] = oldJob,
                ["new"] = {
                    ["name"] = newData["job"],
                    ["grade"] = newData["grade"]
                }
            })
        end
    }

    self["save"] = function(callback)
        local query = [[
            UPDATE
                x_characters
            SET
                cash = @newCash, bank = @newBank, job = @newJob, jobGrade = @newJobGrade, appearance = @newAppearance, position = @newPosition, timePlayed = @newTimePlayed
            WHERE
                characterId = @cid
        ]]

        MySQL.Async.execute(query, {
            ["@cid"] = self["characterId"],
            ["@newCash"] = self["cash"]["balance"],
            ["@newBank"] = self["bank"]["balance"],
            ["@newJob"] = self["job"]["name"],
            ["@newJobGrade"] = self["job"]["grade"],
            ["@newAppearance"] = json.encode(self["appearance"]["current"]),
            ["@newPosition"] = json.encode(self["position"]["coords"]),
            ["@newTimePlayed"] = self["custom"]["timePlayed"] or 0
        }, function(rowsChanged)
            if rowsChanged > 0 then
                X.Log("Successfully saved character:", self["characterId"])
            end

            if callback then
                callback(rowsChanged > 0)
            end
        end)
    end

    return self
end

FetchCharacter = function(source)
    if X.LoadedCharacters[source] then
        return X.LoadedCharacters[source]
    end

    return false
end

FetchCharacters = function()
    return X.LoadedCharacters
end

FetchCharacterWithCid = function(cid)
    for characterSource, characterData in pairs(X.LoadedCharacters) do
        if characterData["characterId"] == cid then
            return characterData
        end
    end
    
    return false
end

FetchCharacterWithIdentifier = function(identifier)
    local user = exports["x-core"]:FetchUserWithIdentifier(identifier)

    if not user then return false end

    for _, characterData in pairs(X.LoadedCharacters) do
        if user.source == characterData.source then
            return characterData
        end
    end

    return false
end