local NumberCharset = {}
local Charset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end

for i = 65, 90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

GetRandomNumber = function(length)
	Citizen.Wait(0)

	math.randomseed(GetGameTimer())

	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ""
	end
end

GetRandomLetter = function(length)
	Citizen.Wait(0)

	math.randomseed(GetGameTimer())

	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ""
	end
end

GeneratePlate = function()
	Citizen.Wait(0)

	math.randomseed(GetGameTimer())

	return string.upper(" " .. GetRandomLetter(3) .. GetRandomNumber(3) .. " ")
end