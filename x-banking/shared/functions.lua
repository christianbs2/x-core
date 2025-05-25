GenerateBankNumber = function()
    math.randomseed(os.time() + GetGameTimer() * math.pi * math.random())

    local bankNumber = math.random(1000, 9999) .. "-" .. math.random(9) .. "," .. math.random(100, 999) .. " " .. math.random(100, 999) .. " " .. math.random(100, 999) .. "-" .. math.random(9)

    return bankNumber
end

UUID = function()
    local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'

    math.randomseed(GetGameTimer() + math.random())

    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
        return string.format('%x', v)
    end)
end