X = {}

Heap = {
    Accounts = {}
}

TriggerEvent("x-core:fetchMain", function(library)
    X = library
end)

MySQL.ready(function()
    local fetchSQL = [[
        SELECT
            *
        FROM
            x_world_accounts
    ]]

    MySQL.Async.fetchAll(fetchSQL, {}, function(responses)
        if not responses or #responses <= 0 then return end

        for _, responseData in ipairs(responses) do
            Heap.Accounts[responseData.accountName] = CreateAccount(json.decode(responseData.accountData))
        end
    end)
end)

RegisterNetEvent("x-core:playerDropped")
AddEventHandler("x-core:playerDropped", function(source)
    local character = exports["x-character"]:FetchCharacter(source)

    if not character then return end
end)

RegisterNetEvent("x-jobpanel:action")
AddEventHandler("x-jobpanel:action", function(actionData)
    local event = actionData.Action

    local character = exports["x-character"]:FetchCharacter(source)

    if not character then return end

    local jobName = string.upper(actionData.Job)

    local jobData = exports["x-jobs"]:GetJobData(jobName)

    if event == "WITHDRAW_BALANCE" then
        local account = GetAccount(jobName)

        account.Withdraw(tonumber(actionData.Amount), function(removed)
            if removed then
                character.triggerEvent("x-core:notify", "System", "Du tog ut " .. actionData.Amount .. " kr från kontot.", 5000, "success")

                character.bank.add(tonumber(actionData.Amount), {
                    ["type"] = "added",
                    ["description"] = "Uttaget från " .. jobData.Label .. "'s konto.",
                    ["amount"] = tonumber(actionData.Amount)
                })

                -- exports["x-logs"]:Log(("WITHDRAW | %s (%s) | %s kr"):format(character.identification.firstname .. " " .. character.identification.lastname, GetPlayerName(character.source), actionData.Amount), "Tog ut **" .. actionData.Amount .. "kr** från **" .. jobData.Label .. "'s** konto", "JOB_WITHDRAW")
                exports.JD_logs:createLog({
                    EmbedMessage = ("%s (%s) | %s kr"):format(character.identification.firstname .. " " .. character.identification.lastname, GetPlayerName(character.source), actionData.Amount) .. " " .. "Tog ut **" .. actionData.Amount .. "kr** från **" .. jobData.Label .. "'s** konto",
                    channel = "job",
                })
            else
                character.triggerEvent("x-core:notify", "System", "överförningen misslyckades försök igen.", 5000, "error")
            end
        end)
    elseif event == "DEPOSIT_BALANCE" then
        if character.bank.balance >= tonumber(actionData.Amount) then
            local account = GetAccount(jobName)

            account.Deposit(tonumber(actionData.Amount), function(added)
                if added then
                    character.triggerEvent("x-core:notify", "System", "Du satte in " .. actionData.Amount .. " kr på kontot.", 5000, "success")

                    character.bank.remove(tonumber(actionData.Amount), {
                        ["type"] = "removed",
                        ["description"] = "Insättning på " .. jobData.Label .. "'s konto.",
                        ["amount"] = tonumber(actionData.Amount)
                    })

                    -- exports["x-logs"]:Log(("DEPOSIT | %s (%s) | %s kr"):format(character.identification.firstname .. " " .. character.identification.lastname, GetPlayerName(character.source), actionData.Amount), "Satte in **" .. actionData.Amount .. "kr** till **" .. jobData.Label .. "'s** konto", "JOB_DEPOSIT")
                    exports.JD_logs:createLog({
                        EmbedMessage = ("%s (%s) | %s kr"):format(character.identification.firstname .. " " .. character.identification.lastname, GetPlayerName(character.source), actionData.Amount) .. " " .. "Satte in **" .. actionData.Amount .. "kr** till **" .. jobData.Label .. "'s** konto",
                        channel = "job",
                    })
                else
                    character.triggerEvent("x-core:notify", "System", "överförningen misslyckades försök igen.", 5000, "error")
                end
            end)
        else
            character.triggerEvent("x-core:notify", "System", "överförningen misslyckades försök igen.", 5000, "error")
        end
    elseif event == "EDIT_CHARACTER_GRADE" then
        local characterToEdit = actionData.Character

        local targetCharacter = exports["x-character"]:FetchCharacterWithCid(characterToEdit.CharacterId)

        local newGradeIndex

        for gradeIndex, gradeData in ipairs(jobData.Grades) do
            if gradeData.Label == characterToEdit.Grade then
                newGradeIndex = gradeIndex

                break
            end
        end

        if not newGradeIndex then return character.triggerEvent("x-core:notify", "System", "Något misslyckades, försök igen.", 5000, "error") end

        if character.characterId == characterToEdit.CharacterId and newGradeIndex < character.job.grade then return character.triggerEvent("x-core:notify", "System", "Du kan inte sänka din egen rang.", 5000, "error") end

        if targetCharacter then
            targetCharacter.job.change({
                job = string.lower(jobName),
                grade = newGradeIndex
            })
            targetCharacter.save()

            Trace("Edited grade on online character:", characterToEdit.CharacterId, "to grade:", newGradeIndex)
        else
            local executeSQL = [[
                UPDATE
                    x_characters
                SET
                    jobGrade = @newGrade
                WHERE
                    characterId = @cid
            ]]

            MySQL.Async.execute(executeSQL, {
                ["@cid"] = characterToEdit.CharacterId,
                ["@newGrade"] = newGradeIndex
            }, function(rowsChanged)
                if rowsChanged > 0 then
                    Trace("Edited grade on offline character:", characterToEdit.CharacterId, "to grade:", newGradeIndex)
                end
            end)
        end

        character.triggerEvent("x-core:notify", "System", "Du ändrade rangen på indivden.", 5000, "success")
    elseif event == "HIRE_CHARACTER" then
        local characterToHire = actionData.CharacterId

        if character.characterId == characterToHire then return character.triggerEvent("x-core:notify", "System", "Du kan inte anställa dig själv.", 5000, "error") end

        local targetCharacter = exports["x-character"]:FetchCharacterWithCid(characterToHire)

        if targetCharacter then
            targetCharacter.job.change({
                job = string.lower(jobName),
                grade = 1
            })
            targetCharacter.save()

            Trace("Hired online character:", characterToHire)
        else
            local executeSQL = [[
                UPDATE
                    x_characters
                SET
                    job = @newJob, jobGrade = @newGrade
                WHERE
                    characterId = @cid
            ]]

            MySQL.Async.execute(executeSQL, {
                ["@cid"] = characterToHire,
                ["@newJob"] = string.lower(jobName),
                ["@newGrade"] = 1
            }, function(rowsChanged)
                if rowsChanged > 0 then
                    Trace("Hired offline character:", characterToHire)
                end
            end)
        end

        -- exports["x-logs"]:Log(("RECRUITED | %s (%s)"):format(character.identification.firstname .. " " .. character.identification.lastname, GetPlayerName(character.source)), "En anställning på **" .. characterToHire .. "** till företaget **" .. jobName .. "**", "JOB_RECRUIT")
        exports.JD_logs:createLog({
            EmbedMessage = ("%s (%s)"):format(character.identification.firstname .. " " .. character.identification.lastname, GetPlayerName(character.source)) "En anställning på **" .. characterToHire .. "** till företaget **" .. jobName .. "**",
            channel = "job",
        })

        character.triggerEvent("x-core:notify", "System", "Du anställde individen.", 5000, "success")
    elseif event == "KICK_CHARACTER" then
        local characterToEdit = actionData.Character

        if character.characterId == characterToEdit.CharacterId then return character.triggerEvent("x-core:notify", "System", "Du kan inte sparka dig själv.", 5000, "error") end

        local targetCharacter = exports["x-character"]:FetchCharacterWithCid(characterToEdit.CharacterId)

        if targetCharacter then
            targetCharacter.job.change("unemployed", 1)
            targetCharacter.save()

            Trace("Kicked online character:", characterToEdit.CharacterId)
        else
            local executeSQL = [[
                UPDATE
                    x_characters
                SET
                    job = @newJob, jobGrade = @newGrade
                WHERE
                    characterId = @cid
            ]]

            MySQL.Async.execute(executeSQL, {
                ["@cid"] = characterToEdit.CharacterId,
                ["@newJob"] = "unemployed",
                ["@newGrade"] = 1
            }, function(rowsChanged)
                if rowsChanged > 0 then
                    Trace("Kicked offline character:", characterToEdit.CharacterId)
                end
            end)
        end

        character.triggerEvent("x-core:notify", "System", "Du sparkade indivden.", 5000, "success")
    elseif event == "EDIT_PERMISSION_CHARACTER" then
        local characterToEdit = actionData.CharacterId

        if character.characterId == characterToEdit then return character.triggerEvent("x-core:notify", "System", "Du får inte ändra dina egna behörigheter.", 5000, "error") end

        local dataStorage = exports["x-datastorage"]:GetStorage(characterToEdit)

        local permissions = dataStorage and dataStorage.Get("JOB_PERMISSIONS") or {
            ACCESS_ONE = false,
            ACCESS_TWO = false
        }

        permissions[actionData.Permission] = actionData.Value

        dataStorage.Update("JOB_PERMISSIONS", permissions)
    elseif event == "CANCEL_INVOICE" then
        local invoiceId = actionData.Invoice.Id

        exports["x-invoice"]:RemoveInvoice(invoiceId)
    end
end)