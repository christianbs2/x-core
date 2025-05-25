FetchMain = function()
    return Main
end

UpdateUser = function(response)
    if response and type(response) == "table" and response["table"] and response["data"] then
        User[response["table"]] = response["data"]
    end
end

Main.TableToString = function(...)
    local args = {...}
    local msgString = ""

    for i = 1, #args do
        if type(args[i]) == "table" then
            msgString = msgString .. json.encode(args[i])
        else
            msgString = msgString .. tostring(args[i])
        end
    end

    return msgString
end

Main.GetRandomString = function(count)
    if count < 1 then return nil end
    local result = {}
    for i = 1, count do
        result[i] = string.char(math.random(32, 126))
    end
    return table.concat(result) -- More efficient string construction
end
