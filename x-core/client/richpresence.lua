local customRichText

local convertTime = function(minutes)
    return math.floor(minutes / 60), (minutes % 60)
end

Citizen.CreateThread(function()
    while not NetworkIsPlayerActive(PlayerId()) do
        Citizen.Wait(500)
    end

    SetDiscordAppId(1278790673843355728)
    SetDiscordRichPresenceAsset("logo-large")
    SetDiscordRichPresenceAssetSmall("logo-small")
    SetDiscordRichPresenceAssetSmallText("Laddar...")
    SetDiscordRichPresenceAssetText("Laddar...")
    SetRichPresence("Laddar...")

    local currentDot = 1

    while true do
        Citizen.Wait(1000)

        local assetText = "Laddar..."
        local smallAssetText = "Laddar..."
        local richText = "Laddar..."

        if exports["x-character"] and exports["x-character"]:IsLoaded() then
            if Main.Character.Data then
                richText = "Rollspelar som " .. Main.Character.Data["identification"]["firstname"] .. "."

                local hoursPlayed, minutesPlayed = convertTime(Main.Character.Data["data"]["timePlayed"])

                smallAssetText = "Spelat karaktären i " .. hoursPlayed .. " " .. (hoursPlayed == 1 and "timma" or "timmar") .. " och " .. minutesPlayed .. " minuter."
            end
        else
            richText = "Väljer karaktär" .. (currentDot == 1 and "." or currentDot == 2 and ".." or "...")

            currentDot = currentDot + 1 > 3 and 1 or currentDot + 1
        end

        assetText = "Violent Networks"

        SetRichPresence(customRichText or richText)
        SetDiscordRichPresenceAssetText(assetText)
        SetDiscordRichPresenceAssetSmallText(smallAssetText)
        SetDiscordRichPresenceAction(0, "Discord", "https://Discord.gg/ViolentNetworks")
    end
end)

GetPlayerCount = function()
    local playerCount = 0

    for _, _ in ipairs(GetActivePlayers()) do
        playerCount = playerCount + 1
    end
    
    return playerCount
end

EditRichPresence = function(newPresence)
    customRichText = newPresence or nil
end