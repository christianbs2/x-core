X = nil

Citizen.CreateThread(function()

    while not X do
      X = exports["x-core"]:FetchMain()
  
      Citizen.Wait(0)
    end
end)

FingerprintHandler = function(weaponItem)
     --print("Just picked up weapon:", weaponItem["name"])

    local usingGloves = ValidateGloves()

     --print("Character is using gloves:", usingGloves)

    --local putFingerprint = not usingGloves and math.random(3) == 2

    local putFingerprint = not usingGloves

    if putFingerprint then
        AddFingerprint(weaponItem)
    else
         --print("You got lucky no fingerprint added.")
    end
end

AddFingerprint = function(weaponItem)
    local cachedItemData = weaponItem["uniqueData"]

    if not cachedItemData then cachedItemData = {} end
    if not cachedItemData["fingerprints"] then cachedItemData["fingerprints"] = {} end
    if not X.character then return end

    local newFingerprintData = {
        ["fullName"] = X.character.identification.firstname .. " " .. X.character.identification.lastname,
        ["cid"] = ESX.PlayerData["character"]["id"],
        ["uuid"] = math.random(133742069)
    }

    --print("Generated UUID: " .. newFingerprintData["uuid"])

    for fingerprintIndex, fingerprintData in ipairs(cachedItemData["fingerprints"]) do
        if fingerprintData["cid"] == newFingerprintData["cid"] then
            return
        end
    end

    table.insert(cachedItemData["fingerprints"], newFingerprintData)

     --print("Should add data on item:", json.encode(fingerprintData))

    X.TriggerServerCallback("x-inventory:updateItem", function(updated)
        if updated then
             --print("Added data on item:", json.encode(newFingerprintData))
        else
             --print("Update failed and item remain without fingerprint.")
        end
    end, weaponItem["itemId"], cachedItemData)
end

ValidateGloves = function()
    local characterAppearance = exports["x-appearance"]:GetCharacterAppearance()

    local notGloves = {
        0,
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        10,
        11,
        12,
        13,
        14,
        15,
        52,
        53,
        54,
        55,
        56,
        57,
        58,
        59,
        60,
        61,
        62,
        112,
        113,
        114,
        118,
        125,
        132
    }

    for gloveIndex, gloveId in ipairs(notGloves) do
        if characterAppearance["arms"] == gloveId then
            return false
        end
    end

    return true
end