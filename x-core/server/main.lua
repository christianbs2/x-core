Main = {}
Main.Callbacks = {}
Main.Users = {}

RegisterServerEvent("x-core:log")
AddEventHandler("x-core:log", function(...)
    Main.Log(...)
end)

RegisterServerEvent("x-core:fetchMain")
AddEventHandler("x-core:fetchMain", function(callback)
    callback(Main)
end)

-- Lägg till funktionen RegisterServerCallback här
function RegisterServerCallback(name, cb)
    if not name or not cb then
        Main.Log("Error: Missing name or callback function for RegisterServerCallback")
        return
    end
    Main.Callbacks[name] = cb
end

Main.Callback = function(name, id, source, callback, ...)
    if Main.Callbacks[name] then
        Main["Callbacks"][name](source, callback, ...)
    else
        Main.Log("The callback:", name, "does not exist!")
    end
end

RegisterServerEvent("x-core:callback")
AddEventHandler("x-core:callback", function(name, id, ...)
    local src = source

    Main.Callback(name, id, src, function(...)
        TriggerClientEvent("x-core:callback", src, id, ...)
    end, ...)
end)

-- Sätt namnet på kartan
Citizen.CreateThread(function()
    SetMapName("Los Santos Project")
end)

-- Exempelkommando för att uppdatera whitelist
RegisterCommand("refreshwhitelist", function(src)
    local user = FetchUser(src)

    if src ~= 0 then
        if not user then return end
        if not user.isAdmin() then return end

        RefreshWhitelist()
    else
        RefreshWhitelist()
    end
end)