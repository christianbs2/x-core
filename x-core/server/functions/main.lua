Main.Log = function(...)
    if not Config.Debug then
        return
    end
    
    local resource = GetInvokingResource()

    local logLine = os.date('%Y-%m-%d %H:%M:%S', os.time()) .. " [" .. (resource or "LOG") .. "] "
    local logString = { ... }

    for i = 1, #logString do
        logLine = logLine .. tostring(logString[i]) .. " "
    end

    print(logLine)
end

Main.Log("Initiated.")

Main.Notify = function(source, label, text, timeout, type)
    TriggerClientEvent("x-core:notify", source, label, text, timeout, type)
end

Main.CreateCallback = function(name, callback)
    Main["Callbacks"][name] = callback
end

Main.GetPlayers = function()
    return Main.Users
end

Main.GetExtendedPlayers = function(key, val)
    local xPlayers = {}
    if type(val) == "table" then
        for _, v in pairs(Main.Users) do
            checkTable(key, val, v, xPlayers)
        end
    else
        for _, v in pairs(Main.Users) do
            if key then
                if (key == 'job' and v.job.name == val) or v[key] == val then
                    xPlayers[#xPlayers + 1] = v
                end
            else
                xPlayers[#xPlayers + 1] = v
            end
        end
    end

    return xPlayers
end