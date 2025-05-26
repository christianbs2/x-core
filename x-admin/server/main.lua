X = {}

Heap = {
    Players = {}
}

TriggerEvent("x-core:fetchMain", function(library)
    X = library
end)

RegisterCommand("admin", function(source, args)
    if source ~= 0 then return end

    local typeHandler = args[1] and string.upper(args[1]) or "NOTHING"

    local playerId = args[2] and tonumber(args[2]) or -1

    local player = exports["x-core"]:FetchUser(playerId)

    if typeHandler == "SET" then
        if player then
            local adminState = tonumber(args[3]) or 0

            if adminState > #Config.PermissionNames - 1 then
                return X.Log("Rank " .. adminState .. " finns ej i systemet, testa igen.")
            end

            player.updatePermission(adminState)

            X.Log("Du satte " .. player.name .. " som rank " .. adminState .. " (" .. Config.PermissionNames[adminState + 1] .. ").")
        else
            X.Log("ID " .. playerId .. " finns ej i systemet, testa igen.")
        end
    end
end)

RegisterCommand("players", function(src)
    local players = X.GetPlayers()

    local playerCount = 1

    for _, _ in pairs(players) do
        playerCount = playerCount + 1
    end

    exports["chat"]:SendChatMessage(src, '<div class="chat-message system"><b>SPELARE:</b> Det är {0} spelare inne på servern just nu.</div>', {
        playerCount
    })
end)

RegisterCommand("report", function(source, args)
    local player = exports["x-core"]:FetchUser(source)
    local reportMessage = table.concat(args, " ")

    if not reportMessage then return end
    if #reportMessage <= 0 then return end

    local players = X.GetPlayers()

    for _, user in pairs(players) do
        local character = exports["x-character"]:FetchCharacter(user.source)
        local hasAccess, accessRank = user.isAdmin()

        if (hasAccess or accessRank == 2) and character and not character.custom.REPORTS_HIDDEN and user.source ~= source then
            exports["chat"]:SendChatMessage(user.source, '<div class="chat-message server"><b>REPORT:</b> {0} | {1} | {2} | {3}</div>', {
                player.source,
                os.date('%H:%M:%S', os.time()),
                player.name,
                reportMessage
            })
        end
    end

    exports["chat"]:SendChatMessage(player.source, '<div class="chat-message server"><b>REPORT:</b> {0} | {1} | {2} | {3}</div>', {
        player.source,
        os.date('%H:%M:%S', os.time()),
        player.name,
        reportMessage
    })

    -- Log the report
    exports.JD_logs:createLog({
        EmbedMessage = ("%s skickade en rapport: %s"):format(
            GetPlayerName(player.source),
            reportMessage
        ),
        channel = "reports",
    })
end)

RegisterCommand("reply", function(source, args)
    local player = exports["x-core"]:FetchUser(source)

    if not player.isAdmin() then return exports["chat"]:SendChatMessage(source, '<div class="chat-message server"><b>ADMIN:</b> Du har ej behörighet att utföra detta.</div>', {}) end

    local id = args[1] and tonumber(args[1]) or false

    if not id then return end

    local userToSend = exports["x-core"]:FetchUser(id)

    if not userToSend then return exports["chat"]:SendChatMessage(player.source, '<div class="chat-message server"><b>REPORT:</b> ID: {0} finns ej på servern.</div>', {
        id
    }) end

    table.remove(args, 1)

    local replyMessage = table.concat(args, " ")

    if not replyMessage then return end
    if #replyMessage <= 0 then return end

    exports["chat"]:SendChatMessage(userToSend.source, '<div class="chat-message server"><b>ADMIN:</b> {0} | {1}.</div>', {
        player.name,
        replyMessage
    })

    exports["chat"]:SendChatMessage(player.source, '<div class="chat-message server"><b>ADMIN:</b> {0} | {1}.</div>', {
        userToSend.name,
        replyMessage
    })
end)

RegisterCommand("goto", function(source, args)
    local player = exports["x-core"]:FetchUser(source)

    local _, accessRank = player.isAdmin()

    if accessRank <= 0 then
        return exports["chat"]:SendChatMessage(source, '<div class="chat-message server"><b>ADMIN:</b> Du har ej behörighet att utföra detta.</div>', {})
    end

    local id = args[1] and tonumber(args[1]) or false

    if not id then return end

    local userToSend = exports["x-core"]:FetchUser(id)

    if not userToSend then return exports["chat"]:SendChatMessage(player.source, '<div class="chat-message server"><b>REPORT:</b> ID: {0} finns ej på servern.</div>', {
        id
    }) end

    TriggerClientEvent("x-admin:teleport", player.source, GetEntityCoords(GetPlayerPed(userToSend.source)) + vector3(0.0, 0.0, 4.0))

    exports["chat"]:SendChatMessage(player.source, '<div class="chat-message success"><b>ADMIN:</b> Du teleporterade dig till {0}.</div>', {
        userToSend.name
    })
end)

RegisterCommand("bring", function(source, args)
    local player = exports["x-core"]:FetchUser(source)

    local _, accessRank = player.isAdmin()

    if accessRank <= 0 then
        return exports["chat"]:SendChatMessage(source, '<div class="chat-message server"><b>ADMIN:</b> Du har ej behörighet att utföra detta.</div>', {})
    end

    local id = args[1] and tonumber(args[1]) or false


    if not id then return end

    local userToSend = exports["x-core"]:FetchUser(id)

    if not userToSend then return exports["chat"]:SendChatMessage(player.source, '<div class="chat-message server"><b>REPORT:</b> ID: {0} finns ej på servern.</div>', {
        id
    }) end

    TriggerClientEvent("x-admin:teleport", userToSend.source, GetEntityCoords(GetPlayerPed(player.source)))

    exports["chat"]:SendChatMessage(player.source, '<div class="chat-message success"><b>ADMIN:</b> Du teleporterade {0} till dig.</div>', {
        userToSend.name
    })
end)

RegisterCommand("registerkey", function(source, args)
    local player = exports["x-core"]:FetchUser(source)
    local character = exports["x-character"]:FetchCharacter(source)

    -- Kontrollera om spelaren är en administratör
    local _, accessRank = player.isAdmin()
    if accessRank <= 0 then
        return exports["chat"]:SendChatMessage(source, '<div class="chat-message server"><b>ADMIN:</b> Du har ej behörighet att utföra detta.</div>', {})
    end

    -- Hämta ID och nyckelnamn från argumenten
    local id = args[1] and tonumber(args[1]) or false
    local keyname = args[2] and tostring(args[2]) or false

    -- Kontrollera att både ID och nyckelnamn är giltiga
    if not id or not keyname then
        return exports["chat"]:SendChatMessage(source, '<div class="chat-message error"><b>ADMIN:</b> Felaktiga argument! Använd: /registerkey [playerID] [keyName].</div>', {})
    end

    -- Hämta användaren att ge nyckeln till
    local userToSend = exports["x-core"]:FetchUser(id)
    if not userToSend then
        return exports["chat"]:SendChatMessage(source, '<div class="chat-message server"><b>REPORT:</b> ID: ' .. id .. ' finns ej på servern.</div>', {})
    end

    -- Hämta karaktären för den specifika användaren
    local targetCharacter = exports["x-character"]:FetchCharacter(id)
    if not targetCharacter then
        return exports["chat"]:SendChatMessage(source, '<div class="chat-message error"><b>ADMIN:</b> Karaktär kunde inte hittas för ID: ' .. id .. '.</div>', {})
    end

    -- Lägg till nyckeln till spelarens inventarie
    exports["x-inventory"]:AddInventoryItem(targetCharacter, {
        Item = {
            Name = "key",
            Count = 1,
            MetaData = {
                Key = keyname,
                Label = "Dörrnyckel",
                Description = {
                    {
                        Title = "",
                        Text = "Nyckel som passar " .. keyname .. " dörrar och portar",
                    }
                }
            }
        },
        Inventory = "KEYCHAIN_" .. targetCharacter.characterId
    })

    -- Skicka bekräftelsemeddelande till administratören
    exports["chat"]:SendChatMessage(source, '<div class="chat-message success"><b>ADMIN:</b> Du fixade fram en nyckel med namnet "' .. keyname .. '" till spelare: ' .. userToSend.name .. ' (ID: ' .. id .. ').</div>', {})
end)

RegisterNetEvent("x-core:playerDropped")
AddEventHandler("x-core:playerDropped", function(source)
    local character = exports["x-character"]:FetchCharacter(source)

    if not character then return end
end)

RegisterNetEvent("x-admin:action")
AddEventHandler("x-admin:action", function(actionData)
    local issuer = exports["x-character"]:FetchCharacter(source)
    local issuerUser = exports["x-core"]:FetchUser(source)

    if not issuer then return end
    if not issuerUser.isAdmin() and actionData.Action ~= "KICK_PLAYER" then return X.Log(issuerUser.name, "tried doing", actionData.Action, "without permission.") end

    if actionData.Action == "REMOVE_DAMAGE" then
        local character = exports["x-character"]:FetchCharacterWithCid(actionData.CharacterId)

        if character then
            local damages = character.custom.DAMAGESYSTEM_DAMAGES

            for boneIndex, _ in pairs(damages) do
                X.Log(boneIndex, actionData.Damage.Bone, type(boneIndex), type(actionData.Damage.Bone))

                if boneIndex == actionData.Damage.Bone then
                    damages[boneIndex] = nil

                    break
                end
            end

            character.custom.add("DAMAGESYSTEM_DAMAGES", damages)

            character.triggerEvent("x-damagesystem:updateDamages", damages)

            issuer.triggerEvent("x-core:notify", "Admin", "Skadan är nu borttagen.", 5000, "success")

            Citizen.Wait(50)

            character.triggerEvent("x-core:notify", "Admin", actionData.Damage.Label .. " är nu läkt.", 5000, "warning")

            exports.JD_logs:createLog({
                EmbedMessage = ("%s"):format(GetPlayerName(issuer.source)) .. " Tog bort skada " .. actionData.Damage.Label .. " på **" .. character.identification.firstname .. " " .. character.identification.lastname .. "**",
                channel = "admin",
            })
        end
    elseif actionData.Action == "REMOVE_DAMAGES" then
        local character = exports["x-character"]:FetchCharacterWithCid(actionData.CharacterId)

        if character then
            character.custom.add("DAMAGESYSTEM_DAMAGES", {})

            character.triggerEvent("x-damagesystem:updateDamages", {})

            issuer.triggerEvent("x-core:notify", "Admin", "Skadorna är nu borttagna.", 5000, "success")

            Citizen.Wait(50)

            character.triggerEvent("x-core:notify", "Admin", "Dina skador är nu läkta.", 5000, "warning")

            -- exports["x-logs"]:Log(("DAMAGES | %s (%s)"):format(issuer.identification.firstname .. " " .. issuer.identification.lastname, GetPlayerName(issuer.source)), "Tog bort skador på **" .. character.identification.firstname .. " " .. character.identification.lastname .. "**", "ADMIN_DAMAGES")
            exports.JD_logs:createLog({
                EmbedMessage = ("%s"):format(GetPlayerName(issuer.source)) .. " Tog bort skador på **" .. character.identification.firstname .. " " .. character.identification.lastname .. "**",
                channel = "admin",
            })
        end
    elseif actionData.Action == "EDIT_SKILLS" then
        exports["x-skills"]:SetSkills(actionData.CharacterId, actionData.Skills, function(saved)
            if saved then
                issuer.triggerEvent("x-core:notify", "Admin", "Färdigheterna sparades.", 5000, "success")
    
                
                local character = exports["x-character"]:FetchCharacterWithCid(actionData.CharacterId)
                if character then
                    exports.JD_logs:createLog({
                        EmbedMessage = ("%s redigerade färdigheterna för %s %s"):format(
                            GetPlayerName(issuer.source),
                            character.identification.firstname,
                            character.identification.lastname
                        ),
                        channel = "admin",
                    })
                else
                    exports.JD_logs:createLog({
                        EmbedMessage = ("%s redigerade färdigheterna för en okänd karaktär med ID %s"):format(
                            GetPlayerName(issuer.source),
                            actionData.CharacterId
                        ),
                        channel = "admin",
                    })
                end
            end
        end)
    elseif actionData.Action == "KICK_PLAYER" then
        local user = exports["x-core"]:FetchUser(actionData.Player)
    
        if user then
            user.kick(actionData.Why)
            issuer.triggerEvent("x-core:notify", "Admin", "Spelaren har blivit kickad.", 5000, "success")
    
            exports.JD_logs:createLog({
                EmbedMessage = ("%s kickade %s för följande anledning: %s"):format(
                    GetPlayerName(issuer.source),
                    GetPlayerName(user.source),
                    actionData.Why
                ),
                channel = "admin",
            })
        end
    elseif actionData.Action == "SAVE_CHARACTER" then
        local character = exports["x-character"]:FetchCharacterWithCid(actionData.Character.characterId)
    
        local newJob = actionData.Character.job
        local newGrade = actionData.Character.jobGrade
    
        local jobs = exports["x-jobs"]:GetJobs()
    
        for jobName, jobData in pairs(jobs) do
            if jobData.Label == newJob then
                newJob = string.lower(jobName)
    
                for gradeIndex, gradeData in ipairs(jobData.Grades) do
                    if gradeData.Label == newGrade then
                        newGrade = gradeIndex
                        break
                    end
                end
    
                break
            end
        end
    
        if character then
            local oldCash = character.cash.balance
            local oldBank = character.bank.balance
    
            local newCash = actionData.Character.cash
            local newBank = actionData.Character.bank
    
            local oldJob = character.job.name
            local oldGrade = character.job.grade
    
            
            if newJob and tonumber(newGrade) and (newJob ~= oldJob or tonumber(newGrade) ~= oldGrade) then
                character.job.change({
                    job = newJob,
                    grade = newGrade
                })
    
                
                exports.JD_logs:createLog({
                    EmbedMessage = ("%s ändrade job för %s %s från %s (Grade %d) till %s (Grade %d)"):format(
                        GetPlayerName(issuer.source),
                        character.identification.firstname,
                        character.identification.lastname,
                        oldJob,
                        oldGrade,
                        newJob,
                        newGrade
                    ),
                    channel = "admin",
                })
            end
    
            
            if oldCash ~= newCash or oldBank ~= newBank then
                character.cash.set(newCash)
                character.bank.set(newBank)
    
                
                exports.JD_logs:createLog({
                    EmbedMessage = ("%s ändrade pengar för %s %s: Kontanter från %d till %d, Bank från %d till %d"):format(
                        GetPlayerName(issuer.source),
                        character.identification.firstname,
                        character.identification.lastname,
                        oldCash,
                        newCash,
                        oldBank,
                        newBank
                    ),
                    channel = "admin",
                })
            end
    
            character.save()
    
            Trace("Changed online job:", newJob, "grade:", newGrade, "balance:", newCash, "balance2:", newBank)
        else
            if not newJob or not tonumber(newGrade) then return end
    
            local oldCash, oldBank
    
            
            local result = MySQL.Sync.fetchAll("SELECT cash, bank FROM x_characters WHERE characterId = @cid", {
                ["@cid"] = actionData.Character.characterId
            })
            
            if result and result[1] then
                oldCash = result[1].cash
                oldBank = result[1].bank
            else
                oldCash, oldBank = 0, 0 
            end
    
            local newCash = actionData.Character.cash
            local newBank = actionData.Character.bank
    
            local changeSQL = [[
                UPDATE
                    x_characters
                SET
                    job = @newJob, jobGrade = @newGrade, cash = @newCash, bank = @newBank
                WHERE
                    characterId = @cid
            ]]
    
            MySQL.Async.execute(changeSQL, {
                ["@cid"] = actionData.Character.characterId,
                ["@newJob"] = newJob,
                ["@newGrade"] = newGrade,
                ["@newCash"] = newCash,
                ["@newBank"] = newBank
            }, function(rowsChanged)
                if rowsChanged > 0 then
                    Trace("Changed offline job:", newJob, "grade:", newGrade, "balance:", newCash, "balance2:", newBank)
    
                    
                    if newJob ~= oldJob or tonumber(newGrade) ~= oldGrade then
                        exports.JD_logs:createLog({
                            EmbedMessage = ("%s ändrade job för en offline karaktär med ID %s från %s (Grade %d) till %s (Grade %d)"):format(
                                GetPlayerName(issuer.source),
                                actionData.Character.characterId,
                                oldJob,
                                oldGrade,
                                newJob,
                                newGrade
                            ),
                            channel = "admin",
                        })
                    end
    
                    
                    if oldCash ~= newCash or oldBank ~= newBank then
                        exports.JD_logs:createLog({
                            EmbedMessage = ("%s ändrade pengar för en offline karaktär med ID %s: Kontanter från %d till %d, Bank från %d till %d"):format(
                                GetPlayerName(issuer.source),
                                actionData.Character.characterId,
                                oldCash,
                                newCash,
                                oldBank,
                                newBank
                            ),
                            channel = "admin",
                        })
                    end
                end
            end)
        end
    
        issuer.triggerEvent("x-core:notify", "Admin", "Karaktärens information sparades.", 5000, "success")
    elseif actionData.Action == "HEAL_CHARACTER" then
        local character = exports["x-character"]:FetchCharacterWithCid(actionData.CharacterId)
    
        if not character then return end
    
        TriggerClientEvent("x-admin:healCharacter", character.source, "HP")
        issuer.triggerEvent("x-core:notify", "Admin", "Du helade karaktären.", 5000, "success")
    
        
        exports.JD_logs:createLog({
            EmbedMessage = ("%s helade %s %s"):format(
                GetPlayerName(issuer.source),
                character.identification.firstname,
                character.identification.lastname
            ),
            channel = "admin",
        })
    elseif actionData.Action == "REVIVE_CHARACTER" then
        local character = exports["x-character"]:FetchCharacterWithCid(actionData.CharacterId)
    
        if not character then return end
    
        TriggerClientEvent("x-admin:healCharacter", character.source, "REVIVE")
        issuer.triggerEvent("x-core:notify", "Admin", "Du återupplivade karaktären.", 5000, "success")
    
        
        exports.JD_logs:createLog({
            EmbedMessage = ("%s återupplivade %s %s"):format(
                GetPlayerName(issuer.source),
                character.identification.firstname,
                character.identification.lastname
            ),
            channel = "admin",
        })
    elseif actionData.Action == "KILL_CHARACTER" then
        local character = exports["x-character"]:FetchCharacterWithCid(actionData.CharacterId)

        if not character then return end

        TriggerClientEvent("x-admin:healCharacter", character.source, "KILL")

        issuer.triggerEvent("x-core:notify", "Admin", "Du dödade karaktären.", 5000, "error")
    elseif actionData.Action == "REMOVE_WHITELIST" then
        local targetUser = exports["x-core"]:FetchUserWithIdentifier(actionData.Player.Identifier)

        if not targetUser then return end

        local sqlQuery = [[
            DELETE
                FROM
            x_users_whitelist
                WHERE
            steamHex = @hex
        ]]

        MySQL.Async.execute(sqlQuery, {
            ["@hex"] = actionData.Player.Identifier
        }, function(rowsChanged)
            if rowsChanged > 0 then
                targetUser.kick("Din åtkomst till servern har blivit indragen, vänligen kontakta staff ifall något fel har inträffat.")

                exports["x-core"]:RefreshWhitelist()
            end
        end)
    elseif actionData.Action == "UPDATE_PERMISSION" then
        local targetUser = exports["x-core"]:FetchUserWithIdentifier(actionData.Player.Identifier)

        if not targetUser then return end

        local newPermissionName = actionData.Permission

        local newPermissionIndex

        for pIndex, pName in ipairs(Config.PermissionNames) do
            if pName == newPermissionName then
                newPermissionIndex = pIndex - 1

                break
            end
        end

        if newPermissionIndex then
            targetUser.updatePermission(newPermissionIndex)
        end
    elseif actionData.Action == "UPDATE_IMPOUND" then
        local sqlQuery = [[
            UPDATE
                x_characters_vehicles
            SET
                vehicleInside = @newState
            WHERE
                vehiclePlate = @plate
        ]]

        local vehicle = actionData.Vehicle

        MySQL.Async.execute(sqlQuery, {
            ["@plate"] = vehicle.vehiclePlate,
            ["@newState"] = not vehicle.vehicleInside
        }, function(rowsChanged)
            if rowsChanged > 0 then
                TriggerClientEvent("x-core:notify", issuerUser.source, "Admin", "Fordonet uppdaterades.", 5000, "success")
            end
        end)
    elseif actionData.Action == "REMOVE_COOLDOWN" then
        exports["x-cooldown"]:RemoveCooldown(actionData.CharacterId, actionData.Cooldown)
    end
end)
