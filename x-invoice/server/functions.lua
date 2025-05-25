GetJobDataWithLabel = function(label)
    local serverJobs = exports["x-jobs"]:GetJobs()

    for jobName, jobData in pairs(serverJobs) do
        if jobData.Label == label then 
            return jobName
        end
    end

    return false
end

RemoveInvoice = function(invoiceId)
    local deleteSql = [[
        DELETE
            FROM
        x_characters_invoice
            WHERE
        id = @id
    ]]

    MySQL.Async.execute(deleteSql, {
        ["@id"] = invoiceId,
    }, function(rowsChanged)
        if rowsChanged > 0 then
            RemoveInvoiceFromCache(invoiceId)
        end
    end)
end

GetInvoicesFromCache = function(sender)
    local invoices = sender and Heap.SentInvoices[sender] or {}

    return invoices or {}
end

RemoveInvoiceFromCache = function(invoiceId, sender)
    local invoices = sender and Heap.SentInvoices[sender] or Heap.SentInvoices

    if sender then
        for invoiceIndex, invoiceData in ipairs(invoices) do
            if invoiceData.id == invoiceId then
                table.remove(Heap.SentInvoices[sender], invoiceIndex)

                break
            end
        end
    else
        for _sender, _invoices in pairs(invoices) do
            for invoiceIndex, invoiceData in ipairs(_invoices) do
                if invoiceData.id == invoiceId then
                    table.remove(Heap.SentInvoices[_sender], invoiceIndex)

                    return
                end
            end
        end
    end
end

local function splitString(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end

    local t={}

    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end

    return t
end

InvoiceNeedsToBePaid = function(invoice)
    if not invoice.invoiceData.createdDate then return false end

    local dividedString = splitString(invoice.invoiceData.createdDate, "-")

    if #dividedString[2] == 1 then
        dividedString[2] = "0" .. dividedString[2]

        invoice.invoiceData.createdDate = dividedString[1] .. "-" .. dividedString[2] .. "-" .. dividedString[3]
    end

    if #dividedString[3] == 1 then
        invoice.invoiceData.createdDate = dividedString[1] .. "-" .. dividedString[2] .. "-0" .. dividedString[3]
    end

    local yearCreated, monthCreated, dayCreated = (invoice.invoiceData.createdDate):match("(%d%d%d%d)-(%d%d)-(%d%d)")

    local span = 14

    local currentTime = os.time()
    local endTime = os.time({ day = dayCreated + span, month = monthCreated, year = yearCreated })

    local daysFrom = os.difftime(endTime, currentTime) / (24 * 60 * 60)

    return math.floor(daysFrom) <= 0
end

PayOutdatedInvoice = function(invoice, agency)
    local companyInvoice = invoice.invoiceData.job
    local invoiceTotal = math.floor(invoice.invoiceData.total * 1.2)

    if companyInvoice then
        local receiverCompanyAccount = exports["x-jobpanel"]:GetAccount(invoice.owner)
        local senderCompanyAccount = exports["x-jobpanel"]:GetAccount(GetJobDataWithLabel(agency))

        receiverCompanyAccount.Withdraw(invoiceTotal, function(withdrawn)
            if withdrawn then
                senderCompanyAccount.Deposit(invoiceTotal, function(deposited)
                    if deposited then
                        RemoveInvoice(invoice.id)

                        -- exports["x-logs"]:Log(("PAID | %s (%s) | %s kr"):format(invoice.owner, "FöRETAG", invoiceTotal), "Betalade automatiskt en faktura till företaget **" .. agency .. "** som var försenad.", "INVOICE_PAID_LATE")
                        exports.JD_logs:createLog({
                            EmbedMessage = ("%s (%s) | %s kr"):format(invoice.owner, "FöRETAG", invoiceTotal) .. " " .. "Betalade automatiskt en faktura till företaget **" .. agency .. "** som var försenad.",
                            channel = "invoice",
                        })
                    end
                end)
            end
        end)
    else
        local character = exports["x-character"]:FetchCharacterWithCid(invoice.owner)

        if character then
            character.bank.remove(invoiceTotal)

            character.triggerEvent("x-core:notify", "Faktura", "Du betalade en faktura skickad ifrån " .. agency .. " på en totalkostnad av " .. invoiceTotal .. " kr med en ränta av 20%.", 10000, "success")
        else
            local dataStorage = exports["x-datastorage"]:GetStorage(invoice.owner)

            if not dataStorage then return end

            local currentPayments = dataStorage.Get("PAYMENTS") or {}

            table.insert(currentPayments, {
                Amount = invoiceTotal,

                Notification = "Du betalade en faktura skickad ifrån " .. agency .. " på en totalkostnad av " .. invoiceTotal .. " kr med en ränta av 20%."
            })

            dataStorage.Update("PAYMENTS", currentPayments)
        end

        RemoveInvoice(invoice.id)

        -- exports["x-logs"]:Log(("PAID | %s (%s) | %s kr"):format(invoice.owner, "SPELARE", invoiceTotal), "Betalade automatiskt en faktura till företaget **" .. agency .. "** som var försenad.", "INVOICE_PAID_LATE")
        exports.JD_logs:createLog({
            EmbedMessage = ("%s (%s) | %s kr"):format(invoice.owner, "SPELARE", invoiceTotal) .. " " .. "Betalade automatiskt en faktura till företaget **" .. agency .. "** som var försenad.",
            channel = "invoice",
        })
    end
end