CreateUser = function(userData)
    local self = {}

    self["source"] = userData["source"]

    self["name"] = userData["name"]

    self["identifier"] = userData["identifier"]
    self["data"] = userData

    self["kick"] = function(reason)
        DropPlayer(self["source"], reason)
    end

    self["isAdmin"] = function()
        return tonumber(self["data"]["admin"]) == 1, tonumber(self["data"]["admin"])
    end

    self["updatePermission"] = function(newState)
        self["data"]["admin"] = newState

        local query = [[
            INSERT
                INTO
            x_users
                (name, identifier, admin, license, ip, discord)
            VALUES
                (@name, @identifier, @admin, @license, @ip, @discord)
            ON DUPLICATE KEY UPDATE
                name = name, admin = @admin, license = @license, ip = @ip, discord = @discord, lastLogin = @lastLogin
        ]]

        MySQL.Async.execute(query, {
            ["@name"] = self["name"] or "not authenticated",
            ["@admin"] = self["data"]["admin"],
            ["@identifier"] = self["data"]["identifier"] or "not authenticated",
            ["@license"] = self["data"]["license"] or "not authenticated",
            ["@ip"] = self["data"]["ip"] or "not authenticated",
            ["@discord"] = self["data"]["discord"] or "not authenticated",
            ["@lastLogin"] = os.date('%Y-%m-%d %H:%M:%S', os.time())
        }, function(rowsChanged)
            if rowsChanged > 0 then
                TriggerClientEvent("x-core:updateAdminState", self["source"], newState, "fromServer")
            end
        end)
    end

    return self
end

FetchUser = function(source)
    if Main.Users[source] then
        return Main.Users[source]
    end

    return false
end

FetchUserWithIdentifier = function(identifier)
    for _, userData in pairs(Main.Users) do
        if userData.identifier == identifier then
            return userData
        end
    end

    return false
end

IsWhitelisted = function(identifier)
    for _, whitelist in ipairs(Main.Whitelists) do
        if whitelist.steamHex == identifier then
            return whitelist.timeWhitelisted
        end
    end

    return false
end

AddEventHandler("playerConnecting", function(playerName, kick, deferral)
    playerConnecting(playerName, kick, deferral, source)
end)

RegisterServerEvent("playerJoined")
AddEventHandler("playerJoined", function()
    playerJoined(source)
end)

AddEventHandler("playerDropped", function(reason)
    playerDropped(reason)
end)
