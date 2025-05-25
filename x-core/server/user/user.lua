playerConnecting = function(playerName, _, deferral, src)
    deferral.defer()

    -- Wait before validation starts
    Citizen.Wait(100)
    deferral.update("Validerar...")

    local steamHex

    -- Get the player's Steam identifier
    for _, identifier in ipairs(GetPlayerIdentifiers(src)) do
        if string.match(identifier, "steam:") then
            steamHex = identifier
        end
    end

    -- Check if Steam identifier was found
    if not steamHex then
        deferral.done("Steam identifierare krävs för att ansluta.")
        return
    end

    -- Skip the whitelist check, just log the player and proceed
    Main.Log(playerName, "ansluter nu!")
    deferral.update("Välkommen, " .. playerName .. ". Ansluter...")
    Citizen.Wait(1000)
    deferral.done()
end

playerJoined = function(source)
    local playerName = GetPlayerName(source)
    Main.Log(playerName, "anslöt just!")

    local playerData = {
        ["name"] = playerName,
        ["source"] = source
    }

    -- Get all identifiers for the player
    for _, identifier in ipairs(GetPlayerIdentifiers(source)) do
        if string.match(identifier, "steam:") then
            playerData["identifier"] = identifier
        elseif string.match(identifier, "license:") then
            playerData["license"] = identifier
        elseif string.match(identifier, "ip:") then
            playerData["ip"] = identifier
        elseif string.match(identifier, "discord:") then
            playerData["discord"] = identifier 
        end
    end

    -- Insert or update player data in the database
    MySQL.Async.execute([[
        INSERT INTO x_users (name, identifier, license, ip, discord)
        VALUES (@name, @identifier, @license, @ip, @discord)
        ON DUPLICATE KEY UPDATE
            license = @license, ip = @ip, discord = @discord, lastLogin = @lastLogin
    ]], {
        ["@name"] = playerData["name"] or "not authenticated",
        ["@identifier"] = playerData["identifier"] or "not authenticated",
        ["@license"] = playerData["license"] or "not authenticated",
        ["@ip"] = playerData["ip"] or "not authenticated",
        ["@discord"] = playerData["discord"] or "not authenticated",
        ["@lastLogin"] = os.date('%Y-%m-%d %H:%M:%S', os.time())
    }, function(rowsChanged)
        if rowsChanged > 0 then
            Main.Log("Spelare uppdaterades framgångsrikt:", playerData["name"])

            -- Check if the player is admin
            MySQL.Async.fetchScalar([[
                SELECT admin
                FROM x_users
                WHERE identifier = @identifier
            ]], {
                ["@identifier"] = playerData["identifier"]
            }, function(isAdmin)
                playerData["admin"] = tonumber(isAdmin)

                -- Create user and send data to the client
                Main.Users[source] = CreateUser(playerData)
                TriggerClientEvent("x-core:userLoaded", source, Main.Users[source])

                -- Log connection
                exports.JD_logs:createLog({
                    EmbedMessage = ("%s Loggade in"):format(playerData.name),
                    channel = "connect",
                })

                -- Play connection sound
                TriggerClientEvent('startLoadingAudio', source)
            end)
        end
    end)
end

playerDropped = function(reason)
    local player = Main.Users[source]
    
    if player then
        Main.Log(player["name"], "lämnade servern med anledningen:", reason)

        -- Trigger event for player dropping
        TriggerEvent("x-core:playerDropped", source)

        -- Log disconnection
        exports.JD_logs:createLog({
            EmbedMessage = ("%s %s"):format(player.name, reason),
            channel = "connect",
        })

        -- Remove player data from memory
        Main.Users[source] = nil
    end
end
