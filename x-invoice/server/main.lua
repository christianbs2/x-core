Heap = {
    SentInvoices = {}
}

X = {}

TriggerEvent("x-core:fetchMain", function(library)
    X = library
end)

 MySQL.ready(function() -- Added to x-core
     local fetchSql = [[
            SELECT
                *
            FROM
                x_characters_invoice
        ]]

     MySQL.Async.fetchAll(fetchSql, {}, function(responses)
         if responses and #responses > 0 then
             for _, responseData in ipairs(responses) do
                 local invoiceData = json.decode(responseData.invoiceData)

                 if not Heap.SentInvoices[invoiceData.agency] then Heap.SentInvoices[invoiceData.agency] = {} end

                 table.insert(Heap.SentInvoices[invoiceData.agency], {
                     id = responseData.id,
                     owner = responseData.owner,
                     sender = responseData.sender,
                     invoiceData = invoiceData
                 })
             end
         end
     end)
 end)

RegisterServerEvent("x-invoice:createInvoice")
AddEventHandler("x-invoice:createInvoice", function(invoiceData)
    local src = source
    local character = exports["x-character"]:FetchCharacter(src)
    local sendingCharacter = exports["x-character"]:FetchCharacterWithCid(invoiceData["characterId"])

    if character and invoiceData then
        if invoiceData["total"] < 1 then
            X.Notify(src, "Faktura", "Du försöker med det omöjliga kompis", 5000, "error")
        else 
            
            local Owner

            local fetchSQL = [[
                SELECT 
                    * 
                FROM 
                    x_characters
                WHERE 
                    characterId = @characterId
            ]]

            local sqlQuery = [[
                INSERT
                    INTO
                x_characters_invoice
                    (id, owner, sender, invoiceData)
                VALUES
                    (@id, @owner, @sender, @invoiceData)
            ]]

            MySQL.Async.fetchAll(fetchSQL, {
                ["@characterId"] = invoiceData["characterId"]
            }, function(response)
                if invoiceData["company"] or response[1] then 
                    if invoiceData["characterId"] ~= "" and invoiceData["characterId"] and not invoiceData["job"] then 
                        Owner = invoiceData["characterId"]
                    else
                        Owner = GetJobDataWithLabel(invoiceData["company"])   
                    end
                    MySQL.Async.execute(sqlQuery, {
                        ["@id"] = invoiceData["id"],
                        ["owner"] = Owner,
                        ["sender"] = character["characterId"],
                        ["@invoiceData"] = json.encode(invoiceData)
                    }, function(rowsChanged)
                        if rowsChanged > 0 then
                            if response[1] and invoiceData["job"] then 
                                X.Notify(src, "Faktura", "Du skickade en faktura till " .. invoiceData["company"] .. " med referensperson " .. response[1]["firstname"] .. " " .. response[1]["lastname"], 5000, "success")
                            elseif response[1] then 
                                X.Notify(src, "Faktura", "Du skickade en faktura till " .. response[1]["firstname"] .. " " .. response[1]["lastname"] , 5000, "success")
                            else 
                                X.Notify(src, "Faktura", "Du skickade en faktura till " .. invoiceData["company"] , 5000, "success")
                            end

                            if not Heap.SentInvoices[invoiceData.agency] then Heap.SentInvoices[invoiceData.agency] = {} end

                            table.insert(Heap.SentInvoices[invoiceData.agency], {
                                id = invoiceData["id"],
                                owner = Owner,
                                sender = character["characterId"],
                                invoiceData = invoiceData
                            })

                            if sendingCharacter then 
                                X.Notify(sendingCharacter.source, "Faktura", "Du har fått en faktura utav " .. character.identification.firstname .. " " .. character.identification.lastname, 5000, "success")
                            end
                        end
                    end)
                else
                    X.Notify(src, "Faktura", "Hittade ingen person med det personnummret.. Försök igen", 5000, "error")
                end
            end)
        end
    end 
end) 

RegisterServerEvent("x-invoice:payInvoice")
AddEventHandler("x-invoice:payInvoice", function(invoiceData)
    local src = source 
    local character = exports["x-character"]:FetchCharacter(src)
    local payerAccount  
    local sendingCharacter = exports["x-character"]:FetchCharacterWithCid(invoiceData["sender"])

    if character and invoiceData then
        if invoiceData["job"] then 
            payerAccount = exports["x-jobpanel"]:GetAccount(string.upper(GetJobDataWithLabel(invoiceData["company"])))
        end

        if invoiceData["sender"] then
            local dataStorage = exports["x-datastorage"]:GetStorage(invoiceData["sender"])

            local jobName = GetJobDataWithLabel(invoiceData["agency"])

            local revenues = dataStorage and dataStorage.Get("REVENUE") or {}
            local lastRevenue = revenues[string.upper(jobName)] or 0

            revenues[jobName] = lastRevenue + invoiceData["total"]

            dataStorage.Update("REVENUE", revenues)
        end

        local societyAccount = exports["x-jobpanel"]:GetAccount(string.upper(GetJobDataWithLabel(invoiceData["agency"])))
        local usermoney = character.bank.balance

        if not invoiceData["job"] and usermoney >= invoiceData["total"] or invoiceData["job"] and payerAccount and payerAccount.Balance >= invoiceData["total"] then 
            local deleteSQL = [[
                DELETE
                    FROM
                x_characters_invoice
                    WHERE
                id = @id
            ]]

            MySQL.Async.execute(deleteSQL, {
                ["@id"] = invoiceData["id"],
            }, function(rowsChanged)
                if rowsChanged > 0 then
                    X.Notify(src, "Faktura", "Du betalade fakturan på " .. invoiceData["total"] .. "kr" , 5000, "success")

                    if sendingCharacter then 
                        X.Notify(sendingCharacter.source, "Faktura", character.identification.firstname .. " " .. character.identification.lastname .. " betalade sin faktura"  , 5000, "success")
                    end

                    RemoveInvoiceFromCache(invoiceData.id, invoiceData.agency)

                    if not invoiceData["job"] then
                        character["bank"]["remove"](invoiceData["total"], {
                            ["type"] = "removed",
                            ["description"] = "Betald faktura - " .. invoiceData["agency"],
                            ["amount"] = invoiceData["total"]
                        })
                        
                        if societyAccount then 
                            societyAccount.Deposit(invoiceData["total"])
                        end
                    else
                        if payerAccount then 
                            payerAccount.Withdraw(invoiceData["total"])
                        end

                        if societyAccount then 
                            societyAccount.Deposit(invoiceData["total"])
                        end
                    end

                    -- exports["x-logs"]:Log(("PAID | %s (%s) | %s kr"):format(character.identification.firstname .. " " .. character.identification.lastname, GetPlayerName(character.source), invoiceData["total"]), "Betalade en faktura till företaget **" .. invoiceData.agency .. "**.", "INVOICE_PAID")
                    exports.JD_logs:createLog({
                        EmbedMessage = ("%s (%s) | %s kr"):format(character.identification.firstname .. " " .. character.identification.lastname, GetPlayerName(character.source), invoiceData["total"]) .. " " .. "Betalade en faktura till företaget **" .. invoiceData.agency .. "**.",
                        channel = "invoice",
                    })
                end
            end)
        else
            X.Notify(src, "Faktura", "Du har inte råd att betala denna faktura! Du saknar " .. invoiceData["total"] - usermoney .. " kr", 5000, "error")
        end
    end
end)

RegisterServerEvent("x-invoice:deleteInvoice")
AddEventHandler("x-invoice:deleteInvoice", function(invoiceData)
    local src = source 
    local character = exports["x-character"]:FetchCharacter(src)

    if character and invoiceData then 
        local deleteSql = [[
            DELETE
            FROM 
                x_characters_invoice
            WHERE
                id = @id
        ]]
        
        MySQL.Async.execute(deleteSql, {
            ["@id"] = invoiceData["id"],
        }, function(rowsChanged)
            if rowsChanged > 0 then
                X.Notify(src, "Faktura", "Du rev sönder faktura - " .. invoiceData["id"] .. ".", 5000, "success")

                -- exports["x-logs"]:Log(("DELETED | %s (%s) | %s kr"):format(character.identification.firstname .. " " .. character.identification.lastname, GetPlayerName(character.source), invoiceData["total"]), "Rev sönder faktura #" .. invoiceData["id"], "INVOICE_DELETED")
                exports.JD_logs:createLog({
                    EmbedMessage = ("%s (%s) | %s kr"):format(character.identification.firstname .. " " .. character.identification.lastname, GetPlayerName(character.source), invoiceData["total"]) .. " " .. "Rev sönder faktura #" .. invoiceData["id"],
                    channel = "invoice",
                })
            end
        end)
    end
end)

X.CreateCallback("x-invoice:fetchSentInvoices", function(source, callback)
    local character = exports["x-character"]:FetchCharacter(source)
    local invoices = {}

    local jobData = exports["x-jobs"]:GetJobData(character["job"]["name"])

    if character then 
        local fetchSql = [[
            SELECT
                *
            FROM 
                x_characters_invoice
            WHERE
                sender = @characterId
        ]]

        MySQL.Async.fetchAll(fetchSql, {
            ["@characterId"] = character["characterId"],
        }, function(response)
            if response[1] then 
                for index, data in pairs(response) do 
                    table.insert(invoices, {
                        ["id"] = data["id"],
                        ["owner"] = data["owner"],
                        ["sender"] = data["sender"],
                        ["invoiceData"] = json.decode(data["invoiceData"])
                    })
                end
            end
            callback(invoices)
        end)
    end
end)

X.CreateCallback("x-invoice:fetchUserInvoices", function(source, callback)
    local character = exports["x-character"]:FetchCharacter(source)
    local invoices = {}

    local jobData = exports["x-jobs"]:GetJobData(character["job"]["name"])

    local dataStorage = exports["x-datastorage"]:GetStorage(character.characterId)
    local jobPermissions = dataStorage.Get("JOB_PERMISSIONS") or {
        ACCESS_ONE = jobData.Grades[character["job"]["grade"]].Boss and true or false,
        ACCESS_TWO = jobData.Grades[character["job"]["grade"]].Boss and true or false,
        ACCESS_THREE = jobData.Grades[character["job"]["grade"]].Boss and true or false
    }

    if character then 
        local fetchSql = [[
            SELECT
                *
            FROM 
                x_characters_invoice
            WHERE
                owner = @characterId
            OR 
                owner = @job
        ]]

        MySQL.Async.fetchAll(fetchSql, {
            ["@characterId"] = character["characterId"],
            ["@job"] = jobData.Grades[character["job"]["grade"]].Boss and string.upper(character["job"]["name"]) or jobPermissions.ACCESS_THREE and string.upper(character["job"]["name"]) or ""
        }, function(response)
            if response[1] then 
                for index, data in pairs(response) do 
                    table.insert(invoices, {
                        ["id"] = data["id"],
                        ["owner"] = data["owner"],
                        ["sender"] = data["sender"],
                        ["invoiceData"] = json.decode(data["invoiceData"])
                    })
                end

            end
            callback(invoices)
        end)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10000)

        for agency, invoices in pairs(Heap.SentInvoices) do
            for _, invoice in ipairs(invoices) do
                if InvoiceNeedsToBePaid(invoice) then
                    PayOutdatedInvoice(invoice, agency)

                    Citizen.Wait(50)
                end
            end
        end
    end
end)

X.CreateCallback("x-invoice:getDate", function(pSource, callback)
    local character = exports["x-character"]:FetchCharacter(pSource)

    if not character then return end 

    local dateCreated = os.date("*t", os.time())
    local payDate = os.time() + 1209600
    local realPayDate = os.date("*t", payDate)

    callback({ dateCreated = dateCreated, realPayDate = realPayDate })
end)
