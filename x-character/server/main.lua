X = {}

TriggerEvent("x-core:fetchMain", function(library)
    X = library

    X.LoadedCharacters = {}
end)

X.CreateCallback("x-character:fetchCharacters", function(source, callback)
    local user = exports["x-core"]:FetchUser(source)

    if user then
        local query = [[
            SELECT
                x_characters.*, x_characters_tattoos.tattoos
            FROM
                x_characters
            LEFT JOIN x_characters_tattoos
                ON x_characters.characterId = x_characters_tattoos.characterId
            WHERE
                steamHex = @hex
            ORDER BY timeCreated ASC
        ]]

        MySQL.Async.fetchAll(query, {
            ["@hex"] = user["identifier"]
        }, function(response)
            for _, responseData in ipairs(response) do
                if responseData.timeLocked > 0 then
                    local currentTime = os.time()

                    local hoursSinceLock = os.difftime(currentTime, responseData.timeLocked) / 60 / 60

                    responseData.timeLocked = 72 - hoursSinceLock
                end
            end

            callback(response)
        end)
    end
end)

RegisterServerEvent("x-character:chooseCharacter")
AddEventHandler("x-character:chooseCharacter", function(characterData)
    LoadCharacter(source, characterData)
end)

RegisterServerEvent("x-character:createCharacter")
AddEventHandler("x-character:createCharacter", function(characterData)
    CreateCharacterInDatabase(source, characterData)
end)

RegisterServerEvent("x-character:deleteCharacter")
AddEventHandler("x-character:deleteCharacter", function(characterId)
    DeleteCharacterInDatabase(source, characterId)
end)

RegisterServerEvent("x-character:characterCreated")
AddEventHandler("x-character:characterCreated", function(source, characterId)
    LoadCharacter(source, {
        id = characterId
    })
end)

RegisterServerEvent("x-character:exitCharacter")
AddEventHandler("x-character:exitCharacter", function()
    local src = source

    if X.LoadedCharacters[src] then
        X.LoadedCharacters[src]["save"](function()
            X.LoadedCharacters[src].triggerEvent("x-character:exitedCharacter")

            X.LoadedCharacters[src] = nil
        end)
    end
end)

RegisterServerEvent("x-core:playerDropped")
AddEventHandler("x-core:playerDropped", function(source)
    if X.LoadedCharacters[source] then
        X.LoadedCharacters[source]["save"](function()
            X.LoadedCharacters[source] = nil
        end)
    end
end)

RegisterServerEvent("x-character:updatePosition")
AddEventHandler("x-character:updatePosition", function(newPosition)
    local character = FetchCharacter(source)

    if not character then return end

    character["position"]["update"](newPosition)
end)

RegisterServerEvent("x-character:lockCharacter")
AddEventHandler("x-character:lockCharacter", function(targetSource)
    local character = exports["x-character"]:FetchCharacter(targetSource)

    if not character then return end

    local sqlQuery = [[
        UPDATE
            x_characters
        SET
            timeLocked = @time
        WHERE
            characterId = @cid
    ]]

    MySQL.Async.execute(sqlQuery, {
        ["@cid"] = character.characterId,
        ["@time"] = os.time()
    }, function(rowsChanged)
        if rowsChanged > 0 then
            character.triggerEvent("x-character:switch")
        end
    end)
end)

Citizen.CreateThread(function()
    local saveCooldown = 60000 * 2
    local lastSaved = GetGameTimer() + saveCooldown

    local salaryCooldown = 60000 * 30
    local lastSalaryPayment = GetGameTimer() + salaryCooldown

    local playTimeCooldown = 60000 * 5
    local lastPlayTimeAdded = GetGameTimer() + playTimeCooldown
    
    while true do
        if GetGameTimer() - lastSaved > saveCooldown then
            for _, characterData in pairs(X.LoadedCharacters) do
                characterData["save"]()
            end

            lastSaved = GetGameTimer()
        end

        if GetGameTimer() - lastPlayTimeAdded > playTimeCooldown then
            for _, characterData in pairs(X.LoadedCharacters) do
                local lastPlayTime = characterData["custom"]["timePlayed"] or 0

                characterData["custom"]["add"]("timePlayed", lastPlayTime + 5)

                if characterData.custom.CHARACTER_IN_DUTY then
                    local dataStorage = exports["x-datastorage"]:GetStorage(characterData.characterId)

                    local lastTotalDutyTime = dataStorage and dataStorage.Get("MINUTES_IN_DUTY") or 0

                    dataStorage.Update("MINUTES_IN_DUTY", lastTotalDutyTime + 5)
                end
            end

            X.Log("5 minutes playtime added to each and everyone.")

            lastPlayTimeAdded = GetGameTimer()
        end

        if GetGameTimer() - lastSalaryPayment > salaryCooldown then
            for _, characterData in pairs(X.LoadedCharacters) do
                local jobData = exports["x-jobs"]:GetJobData(characterData.job.name)

                local salary = math.floor(jobData.Grades[characterData.job.grade].Salary / 2)

                local shouldReceiveFullSalary = characterData.job.name == "unemployed" or (characterData.custom.CHARACTER_IN_DUTY and (os.difftime(os.time(), characterData.custom.CHARACTER_IN_DUTY) / 60) or 0) > 10

                characterData.bank.add(shouldReceiveFullSalary and salary or math.floor(salary / 2))

                -- characterData.triggerEvent("x-core:notify", "Lön", "Du tog emot en banköverförning på " .. (shouldReceiveFullSalary and salary or math.floor(salary / 2)) .. " kr.", 5000, "success")
            
                exports["lb-phone"]:SendNotification(characterData.source, {
                    app = "Wallet",
                    title = "Lön",
                    content = "Du tog emot en banköverförning på " .. (shouldReceiveFullSalary and salary or math.floor(salary / 2)) .. " kr.",
                    icon = "",
                }, function(res)
                    -- print("Notification sent:", res)
                end)
            end

            X.Log("Salary payments given to each and everyone.")

            lastSalaryPayment = GetGameTimer()
        end

        Citizen.Wait(10000)
    end
end)