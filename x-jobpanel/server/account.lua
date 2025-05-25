CreateAccount = function(accountData)
    local account = {}

    account.Name = accountData.Name or "UNDEFINED"
    account.Balance = accountData.Balance or 0

    account.Deposit = function(amount, callback)
        if not tonumber(amount) then return callback and callback(false) end
        if not (amount >= 0) then return callback and callback(false) end

        account.Balance = math.floor(account.Balance + amount)

        Trace("Increased account:", account.Name, "balance with:", amount, "new balance:", account.Balance)

        account.Save(function(saved)
            if saved then
                TriggerClientEvent("x-jobpanel:accountChanged", -1, account.Name, account.Balance)
            end

            if not callback then return end 

            callback(saved)
        end)
    end
    account.Withdraw = function(amount, callback)
        if not tonumber(amount) then return callback and callback(false) end
        if not (amount >= 0) then return callback and callback(false) end

        account.Balance = math.floor(account.Balance - amount)

        Trace("Lowered account:", account.Name, "balance with:", amount, "new balance:", account.Balance)

        account.Save(function(saved)
            if saved then
                TriggerClientEvent("x-jobpanel:accountChanged", -1, account.Name, account.Balance)
            end
            
            if not callback then return end 

            callback(saved)
        end)
    end

    account.Save = function(callback)
        if account.Name == "UNDEFINED" then return callback and callback(false) end

        local query = [[
            INSERT
                INTO
            x_world_accounts
                (accountName, accountData)
            VALUES
                (@name, @data)
            ON DUPLICATE KEY UPDATE
                accountData = @data
        ]]

        local saveData = {
            Name = account.Name,
            Balance = account.Balance
        }

        MySQL.Async.execute(query, {
            ["@name"] = accountData.Name,
            ["@data"] = json.encode(saveData)
        }, function(rowsChanged)
            if callback then
                callback(rowsChanged > 0)
            end

            Heap.Accounts[account.Name] = account

            Trace("Saved account:", account.Name, "Successful:", rowsChanged > 0)
        end)
    end

    return account
end

GetAccount = function(accountName)
    for name, account in pairs(Heap.Accounts) do
        if name == accountName then
            return account
        end
    end

    return CreateAccount({
        Name = accountName
    })
end