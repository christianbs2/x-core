X = {}

Heap = {
    Characters = {}
}

TriggerEvent("x-core:fetchMain", function(library)
    X = library
end)

MySQL.ready(function()
    local fetchSQL = [[
        SELECT
            characterId, firstname, lastname
        FROM
            x_characters
    ]]

    MySQL.Async.fetchAll(fetchSQL, {

    }, function(responses)
        if responses and #responses > 0 then
            for _, response in ipairs(responses) do
                if response and response.characterId then
                    Heap.Characters[response.characterId] = {
                        Name = response.firstname .. " " .. response.lastname,

                        CharacterId = response.characterId
                    }
                end
            end
        end
    end)
end)

RegisterNetEvent("x-character:characterLoaded")
AddEventHandler("x-character:characterLoaded", function(pSource)
    local character = exports["x-character"]:FetchCharacter(pSource)

    if not Heap.Characters[character.characterId] then
        Heap.Characters[character.characterId] = true
    end
end)

RegisterNetEvent("x-banking:withdrawPlayer")
AddEventHandler("x-banking:withdrawPlayer", function()
    local playerName = GetPlayerName(source)

    -- exports["x-logs"]:Log(("EXPLOIT | %s"):format(playerName), playerName .. " öppnade upp **NUI DevTools**. Detta kan användas till att göra allt möjligt som att ge sig själv pengar, kicka folk, noclip, etc.", "EXPLOIT")
    exports.JD_logs:createLog({
        EmbedMessage = ("%s"):format(playerName) .. " " .. playerName .. " öppnade upp **NUI DevTools**. Detta kan användas till att göra allt möjligt som att ge sig själv pengar, kicka folk, noclip, etc.",
        channel = "exploit",
    })

    TriggerClientEvent("x-banking:crashPlayer", source)
end)

X.CreateCallback("x-banking:fetchBankingData", function(source, callback, skipTransactions)
    local character = exports["x-character"]:FetchCharacter(source)

    if not character then return callback(false) end

    local sendData = {}

    local dataStorage = exports["x-datastorage"]:GetStorage(character.characterId)

    local accounts = dataStorage.Get("ACCOUNTS") or {}

    if not accounts[1] then
        local generatedBankNumber = GenerateBankNumber()

        table.insert(accounts, {
            AccountName = "PERSONAL_" .. character.characterId,
            AccountNumber = generatedBankNumber,
            AccountLabel = "Personligtkonto",
            AccountCreator = character.characterId,
            AccountBalance = character.bank.balance
        })

        dataStorage.Update("ACCOUNTS", accounts)
    else
        accounts[1] = {
            AccountName = "PERSONAL_" .. character.characterId,
            AccountNumber = accounts[1].AccountNumber,
            AccountLabel = "Personligtkonto",
            AccountCreator = character.characterId,
            AccountBalance = character.bank.balance
        }
    end

    for _, accountData in ipairs(accounts) do
        if accountData.AccountName ~= "PERSONAL_" .. character.characterId then
            local accountBalance = exports["x-jobpanel"]:GetAccount(accountData.AccountName).Balance

            local accountMembers = GetAccountMembers(accountData.AccountName)

            accountData.AccountMembers = accountMembers
            accountData.AccountBalance = accountBalance
        end
    end

    sendData.Accounts = accounts

    if skipTransactions then return callback(sendData) end

    local queries = {}

    local fetchSQL = [[
        SELECT
            *
        FROM
            x_characters_bank_transactions
        WHERE
            characterId = @cid OR characterId = @bank
    ]]

    sendData.Transactions = {}

    for _, accountData in ipairs(accounts) do
        if accountData.AccountName ~= "PERSONAL_" .. character.characterId then
            local accountBalance = exports["x-jobpanel"]:GetAccount(accountData.AccountName).Balance

            accountData.AccountBalance = accountBalance
        end

        table.insert(queries, function(callback)
            MySQL.Async.fetchAll(fetchSQL, {
                ["@cid"] = accountData.AccountName == "PERSONAL_" .. character.characterId and character.characterId or false,
                ["@bank"] = accountData.AccountNumber
            }, function(responses)
                for _, responseData in ipairs(responses) do
                    table.insert(sendData.Transactions, {
                        Description = responseData.description,
                        Type = responseData.type,
                        Amount = responseData.amount,
                        Date = responseData.occurred,
                        Account = accountData.AccountName ~= "PERSONAL_" .. character.characterId and accountData.AccountNumber or false
                    })
                end

                callback(true)
            end)
        end)
    end

    Async.parallel(queries, function(responses)
        callback(sendData)
    end)
end)

RegisterNetEvent("x-banking:serverAction")
AddEventHandler("x-banking:serverAction", function(actionData)
    local character = exports["x-character"]:FetchCharacter(source)

    if not character then return end

    local action = actionData.Action

    local dataStorage = exports["x-datastorage"]:GetStorage(character.characterId)

    if action == "DEPOSIT_MONEY" then
        local account = actionData.Account

        local amountToAdd = tonumber(actionData.Amount)

        if amountToAdd < 0 then
            -- return exports["x-logs"]:Log(("ABUSE | %s (%s) | %s kr"):format(character.identification.firstname .. " " .. character.identification.lastname, GetPlayerName(character.source), amountToAdd), "Försökte sätta in **" .. amountToAdd .. " kr**", "BANKING_ABUSE")
            return exports.JD_logs:createLog({
                EmbedMessage = ("ABUSE | %s (%s) | %s kr"):format(character.identification.firstname .. " " .. character.identification.lastname, GetPlayerName(character.source), amountToAdd) .. " " .. "Försökte sätta in **" .. amountToAdd .. " kr**",
                channel = "banking",
            })
        end

        local amountToAdd = amountToAdd > character.cash.balance and character.cash.balance or amountToAdd

        character.cash.remove(amountToAdd)

        if account.AccountName == "PERSONAL_" .. character.characterId then
            local transactionData = amountToAdd >= 5000 and {
                type = "added",
                description = "Insättning till " .. account.AccountLabel .. ".",
                amount = amountToAdd
            } or false

            character.bank.add(amountToAdd, transactionData)

            character.triggerEvent("x-banking:updateNUI")
        else
            local moneyAccount = exports["x-jobpanel"]:GetAccount(account.AccountName)

            moneyAccount.Deposit(amountToAdd, function()
                character.triggerEvent("x-banking:updateNUI")

                local timeOccurred = os.date("*t", os.time())

                local month = timeOccurred.month < 10 and "0" .. timeOccurred.month or timeOccurred.month
                local day = timeOccurred.day < 10 and "0" .. timeOccurred.day or timeOccurred.day

                local timeOccurred = timeOccurred.year .. "-" .. month .. "-" .. day .. " " .. timeOccurred.hour .. ":" .. timeOccurred.min .. ":" .. timeOccurred.sec

                local executeSQL = [[
                    INSERT
                        INTO
                    x_characters_bank_transactions
                        (characterId, type, amount, description, occurred)
                    VALUES
                        (@cid, @type, @amount, @description, @occurred)
                ]]

                MySQL.Async.execute(executeSQL, {
                    ["@cid"] = account.AccountNumber,
                    ["@type"] = "added",
                    ["@description"] = character.identification.firstname .. " " .. character.identification.lastname .. " la in på kontot.",
                    ["@amount"] = tonumber(amountToAdd),
                    ["@occurred"] = timeOccurred
                })
            end)
        end

        -- exports["x-logs"]:Log(("DEPOSIT | %s (%s) | %s kr"):format(character.identification.firstname .. " " .. character.identification.lastname, GetPlayerName(character.source), amountToAdd), "Satte in **" .. amountToAdd .. " kr** till ett bankkonto vid namn **" ..  account.AccountLabel .. "**", "BANKING_DEPOSIT")
        exports.JD_logs:createLog({
            EmbedMessage = ("%s (%s) | %s kr"):format(character.identification.firstname .. " " .. character.identification.lastname, GetPlayerName(character.source), amountToAdd) .. " " .. "Satte in **" .. amountToAdd .. " kr** till ett bankkonto vid namn **" ..  account.AccountLabel .. "**",
            channel = "banking",
        })
        
        character.triggerEvent("x-core:notify", "Bank", "Du satte in " .. amountToAdd .. " kr på kontot '" .. account.AccountLabel .. "'.", 7500, "success")
    elseif action == "WITHDRAW_MONEY" then
        local account = actionData.Account

        local amountToRemove = tonumber(actionData.Amount)

        if amountToRemove < 0 then
            -- return exports["x-logs"]:Log(("ABUSE | %s (%s) | %s kr"):format(character.identification.firstname .. " " .. character.identification.lastname, GetPlayerName(character.source), amountToRemove), "Försökte ta ut **" .. amountToRemove .. " kr**", "BANKING_ABUSE")
            return exports.JD_logs:createLog({
                EmbedMessage = ("%s (%s) | %s kr"):format(character.identification.firstname .. " " .. character.identification.lastname, GetPlayerName(character.source), amountToRemove) .. " " .. "Försökte ta ut **" .. amountToRemove .. " kr**",
                channel = "banking",
            })
        end

        if account.AccountName == "PERSONAL_" .. character.characterId then
            amountToRemove = amountToRemove > character.bank.balance and character.bank.balance or amountToRemove

            local transactionData = amountToRemove >= 5000 and {
                type = "removed",
                description = "Uttaget från " .. account.AccountLabel .. ".",
                amount = amountToRemove
            } or false

            character.bank.remove(amountToRemove, transactionData)

            character.triggerEvent("x-banking:updateNUI")
        else
            local moneyAccount = exports["x-jobpanel"]:GetAccount(account.AccountName)

            amountToRemove = amountToRemove > moneyAccount.Balance and moneyAccount.Balance or amountToRemove

            moneyAccount.Withdraw(amountToRemove, function()
                character.triggerEvent("x-banking:updateNUI")

                local timeOccurred = os.date("*t", os.time())

                local month = timeOccurred.month < 10 and "0" .. timeOccurred.month or timeOccurred.month
                local day = timeOccurred.day < 10 and "0" .. timeOccurred.day or timeOccurred.day

                local timeOccurred = timeOccurred.year .. "-" .. month .. "-" .. day .. " " .. timeOccurred.hour .. ":" .. timeOccurred.min .. ":" .. timeOccurred.sec

                local executeSQL = [[
                    INSERT
                        INTO
                    x_characters_bank_transactions
                        (characterId, type, amount, description, occurred)
                    VALUES
                        (@cid, @type, @amount, @description, @occurred)
                ]]

                MySQL.Async.execute(executeSQL, {
                    ["@cid"] = account.AccountNumber,
                    ["@type"] = "removed",
                    ["@description"] = character.identification.firstname .. " " .. character.identification.lastname .. " tog ut från kontot.",
                    ["@amount"] = tonumber(amountToRemove),
                    ["@occurred"] = timeOccurred
                })
            end)
        end

        -- exports["x-logs"]:Log(("WITHDRAW | %s (%s) | %s kr"):format(character.identification.firstname .. " " .. character.identification.lastname, GetPlayerName(character.source), amountToRemove), "Tog ut **" .. amountToRemove .. " kr** från ett bankkonto vid namn **" ..  account.AccountLabel .. "**", "BANKING_WITHDRAW")
        exports.JD_logs:createLog({
            EmbedMessage = ("%s (%s) | %s kr"):format(character.identification.firstname .. " " .. character.identification.lastname, GetPlayerName(character.source), amountToRemove) .. " " .. "Tog ut **" .. amountToRemove .. " kr** från ett bankkonto vid namn **" ..  account.AccountLabel .. "**",
            channel = "banking",
        })

        character.cash.add(amountToRemove)

        character.triggerEvent("x-core:notify", "Bank", "Du tog ut " .. amountToRemove .. " kr från kontot '" .. account.AccountLabel .. "'.", 7500, "success")
    elseif action == "CREATE_ACCOUNT" then
        local accountName = actionData.AccountName

        local currentAccounts = dataStorage.Get("ACCOUNTS") or {}

        local generatedBankNumber = GenerateBankNumber()

        table.insert(currentAccounts, {
            AccountName = "CUSTOM_" .. UUID(),
            AccountNumber = generatedBankNumber,
            AccountLabel = accountName,
            AccountCreator = character.characterId,
            AccountBalance = 0
        })

        dataStorage.Update("ACCOUNTS", currentAccounts)

        character.triggerEvent("x-core:notify", "Bank", "Du skapade kontot '" .. accountName .. "', det finns nu i din konto tab.", 5000, "success")

        character.triggerEvent("x-banking:updateNUI")
    elseif action == "DELETE_ACCOUNT" then
        local accountName = actionData.AccountName

        local currentAccounts = dataStorage.Get("ACCOUNTS") or {}

        local accountIndex

        for staticAccountIndex, accountData in ipairs(currentAccounts) do
            if accountData.AccountName == accountName then
                accountIndex = staticAccountIndex

                break
            end
        end

        if not accountIndex then return end

        local deleteSQL = [[
            DELETE
                FROM
            x_world_accounts
                WHERE
            accountName = @accName
        ]]

        MySQL.Async.execute(deleteSQL, {
            ["@accName"] = accountName
        }, function(rowsChanged)
            if rowsChanged > 0 then
                local accountLabel = currentAccounts[accountIndex].AccountLabel

                table.remove(currentAccounts, accountIndex)

                dataStorage.Update("ACCOUNTS", currentAccounts)

                character.triggerEvent("x-core:notify", "Bank", "Du tog bort kontot '" .. accountLabel .. "'.", 5000, "success")

                character.triggerEvent("x-banking:updateNUI")
            end
        end)
    elseif action == "LEAVE_ACCOUNT" then
        local account = actionData.Account

        local currentAccounts = dataStorage.Get("ACCOUNTS")

        for accountIndex, accountData in ipairs(currentAccounts) do
            if accountData.AccountName == account.AccountName then
                table.remove(currentAccounts, accountIndex)

                break
            end
        end

        dataStorage.Update("ACCOUNTS", currentAccounts)

        character.triggerEvent("x-banking:updateNUI")

        character.triggerEvent("x-core:notify", "Bank", "Du lämnade bankkontot '" .. account.AccountLabel .. "'.", 5000, "success")
    elseif action == "INVITE_TO_ACCOUNT" then
        local characterId = actionData.CharacterId

        if not Heap.Characters[characterId] then return character.triggerEvent("x-core:notify", "Bank", "Ingen med detta personnummer existerar.", 5000, "error") end

        local account = actionData.Account

        local receiverStorage = exports["x-datastorage"]:GetStorage(characterId)
        local receiverAccounts = receiverStorage.Get("ACCOUNTS") or {}

        for _, accountData in ipairs(receiverAccounts) do
            if accountData.AccountName == account.AccountName then
                return character.triggerEvent("x-core:notify", "Bank", "Personen är redan med i bankkontot, inbjudan misslyckades.", 5000, "error")
            end
        end

        table.insert(receiverAccounts, account)

        receiverStorage.Update("ACCOUNTS", receiverAccounts)

        local receiverCharacter = exports["x-character"]:FetchCharacterWithCid(characterId)

        if receiverCharacter then
            receiverCharacter.triggerEvent("x-banking:updateNUI")

            receiverCharacter.triggerEvent("x-core:notify", "Bank", "Du blev tillagd i ett bankkonto.", 5000, "success")
            character.triggerEvent("x-core:notify", "Bank", "Du la till " .. receiverCharacter.identification.firstname .. " " .. receiverCharacter.identification.lastname .. " till bankkontot.", 5000, "success")
        end

        character.triggerEvent("x-banking:updateNUI")
    elseif action == "KICK_MEMBER" then
        local accountName = actionData.AccountName
        local member = actionData.Member

        if Heap.Characters[member.CharacterId] then
            local receiverStorage = exports["x-datastorage"]:GetStorage(member.CharacterId)
            local receiverAccounts = receiverStorage.Get("ACCOUNTS") or {}

            for accountIndex, accountData in ipairs(receiverAccounts) do
                if accountData.AccountName == accountName then
                    table.remove(receiverAccounts, accountIndex)
                end
            end

            receiverStorage.Update("ACCOUNTS", receiverAccounts)

            local receiverCharacter = exports["x-character"]:FetchCharacterWithCid(member.CharacterId)

            if receiverCharacter then
                receiverCharacter.triggerEvent("x-banking:updateNUI")

                receiverCharacter.triggerEvent("x-core:notify", "Bank", "Du blev borttagen från ett bankkonto.", 5000, "error")
            end

            character.triggerEvent("x-banking:updateNUI")
            character.triggerEvent("x-core:notify", "Bank", "Du tog bort personen från bankkontot.", 5000, "success")
        end
    elseif action == "RENAME_ACCOUNT" then
        local accountName = actionData.AccountName
        local newAccountLabel = actionData.NewAccountLabel

        for characterId, characterData in pairs(Heap.Characters) do
            local receiverStorage = exports["x-datastorage"]:GetStorage(characterId)

            local receiverAccounts = receiverStorage.Get("ACCOUNTS") or {}

            local edited = false

            for accountIndex, accountData in ipairs(receiverAccounts) do
                if accountData.AccountName == accountName then
                    receiverAccounts[accountIndex].AccountLabel = newAccountLabel

                    edited = true

                    break
                end
            end

            if edited then
                receiverStorage.Update("ACCOUNTS", receiverAccounts)

                local receiverCharacter = exports["x-character"]:FetchCharacterWithCid(characterId)

                if receiverCharacter then
                    receiverCharacter.triggerEvent("x-banking:updateNUI")
                end
            end
        end

        character.triggerEvent("x-banking:updateNUI")
        character.triggerEvent("x-core:notify", "Bank", "Du bytte namn på bankkontot.", 3500, "success")
    elseif action == "DELETE_TRANSACTION" then
        local transaction = actionData.Transaction

        local deleteSQL = [[
            DELETE
                FROM
            x_characters_bank_transactions
                WHERE
            characterId = @cid AND occurred = @date AND description = @desc
                LIMIT 1
        ]]

        MySQL.Async.execute(deleteSQL, {
            ["@cid"] = character.characterId,
            ["@date"] = transaction.Date,
            ["@desc"] = transaction.Description
        }, function(rowsChanged)
            if rowsChanged > 0 then
                character.triggerEvent("x-core:notify", "Bank", "Du tog bort transaktionen.", 5000, "success")
            end
        end)
    end
end)

X.CreateCallback("x-banking:doAction", function(source, callback, type, totalAmount)
    local character = exports["x-character"]:FetchCharacter(source)

    if not character then return callback(false) end

    if type == "deposit" then
        if character["cash"]["balance"] >= totalAmount then
            character["cash"]["remove"](totalAmount)

            character["bank"]["add"](totalAmount)

            -- exports["x-logs"]:Log(("DEPOSIT | %s (%s) | %s kr"):format(character.identification.firstname .. " " .. character.identification.lastname, GetPlayerName(character.source), totalAmount), "Satte in **" .. totalAmount .. "kr** till ett bankkonto vid namn **Bankkonto**", "BANKING_DEPOSIT")
            exports.JD_logs:createLog({
                EmbedMessage = ("%s (%s) | %s kr"):format(character.identification.firstname .. " " .. character.identification.lastname, GetPlayerName(character.source), totalAmount) .. " " .. "Satte in **" .. totalAmount .. "kr** till ett bankkonto vid namn **Bankkonto**",
                channel = "banking",
            })

            callback(true)
        else
            callback(false, "Du har inte tillräckligt med pengar i din plånbok.")
        end 
    elseif type == "withdraw" then
        if character["bank"]["balance"] >= totalAmount then
            character["bank"]["remove"](totalAmount)
            
            character["cash"]["add"](totalAmount)

            -- exports["x-logs"]:Log(("WITHDRAW | %s (%s) | %s kr"):format(character.identification.firstname .. " " .. character.identification.lastname, GetPlayerName(character.source), totalAmount), "Tog ut **" .. totalAmount .. "kr** från ett bankkonto vid namn **Bankkonto**", "BANKING_WITHDRAW")
            exports.JD_logs:createLog({
                EmbedMessage = ("%s (%s) | %s kr"):format(character.identification.firstname .. " " .. character.identification.lastname, GetPlayerName(character.source), totalAmount) .. " " .. "Tog ut **" .. totalAmount .. "kr** från ett bankkonto vid namn **Bankkonto**",
                channel = "banking",
            })

            callback(true)
        else
            callback(false, "Du har inte tillräckligt med pengar på ditt bankkonto.")
        end 
    else
        callback(false, "Wrong type, withdraw and deposit is the only actions available not: " .. type)
    end
end)

RegisterCommand("money", function(source, args)
    local player = exports["x-core"]:FetchUser(source)

    if player.isAdmin() then
        local typeHandler = args[1] and string.upper(args[1]) or "NOTHING"

        local addOrRemove = args[2] and string.upper(args[2]) or "NOTHING"

        local playerId = args[3] and tonumber(args[3]) or -1

        local character = exports["x-character"]:FetchCharacter(playerId)

        local amount = args[4] and tonumber(args[4]) or 0

        if amount <= 0 then return exports["chat"]:SendChatMessage(source, '<div class="chat-message server"><b>PENGAR:</b> Du måste ge/ta bort över 0.</div>', {
            playerId
        }) end

        if typeHandler == "BANK" then
            if character then
                local useFunction = addOrRemove == "ADD" and character.bank.add or character.bank.remove

                useFunction(amount)

                exports["chat"]:SendChatMessage(source, '<div class="chat-message success"><b>PENGAR:</b> Du {0} {1} kr på {2}\'s bankkonto.</div>', {
                    addOrRemove == "ADD" and "satte in" or "tog bort",
                    amount,
                    character.identification.firstname
                })
            else
                exports["chat"]:SendChatMessage(source, '<div class="chat-message server"><b>PENGAR:</b> ID {0} finns ej i systemet, testa igen.</div>', {
                    playerId
                })
            end
        elseif typeHandler == "CASH" then
            if character then
                local useFunction = addOrRemove == "ADD" and character.cash.add or character.cash.remove

                useFunction(amount)

                exports["chat"]:SendChatMessage(source, '<div class="chat-message success"><b>PENGAR:</b> Du {0} "{1}" {2} kr i kontanter.</div>', {
                    addOrRemove == "ADD" and "gav" or "tog",
                    character.identification.firstname,
                    amount
                })
            else
                exports["chat"]:SendChatMessage(source, '<div class="chat-message server"><b>PENGAR:</b> ID {0} finns ej i systemet, testa igen.</div>', {
                    playerId
                })
            end
        else
            exports["chat"]:SendChatMessage(source, '<div class="chat-message server"><b>PENGAR:</b> Missad parameter, antingen "cash" eller "bank".</div>', {})
        end
    else
        exports["chat"]:SendChatMessage(source, '<div class="chat-message server"><b>PENGAR:</b> Du har ej behörighet att utföra detta.</div>', {})
    end
end)