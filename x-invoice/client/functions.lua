

Initialize = function()
    Heap["Scaleform"] = RequestScaleformMovie("MIDSIZED_MESSAGE")
end

OpenInvoiceContext = function()
    local options = {
        {
            ["label"] = "~y~Fakturor"
        },
    }

    local jobData = exports["x-jobs"]:GetJobData(X.Character.Data.job.name)

    if jobData.Whitelisted then
        table.insert(options, {
            ["label"] = "~b~Skapa",
            ["callback"] = function()
                OpenNui()
            end
        })
    end

    table.insert(options, {
        ["label"] = "~b~Hantera",
        ["subMenu"] = {
            ["options"] = {
                {
                    ["label"] = "Mottagna",
                    ["callback"] = function()
                        FetchInvoices()
                    end
                },
                {
                    ["label"] = "Skickade",
                    ["callback"] = function()
                        FetchInvoicesSent()
                    end
                }
            }
        }
    })

    exports["x-context"]:OpenContextMenu({
		menu = "self-invoice-menu",
		entity = PlayerPedId(),
		options = options,
		oldPos = true
	})
end

FetchInvoices = function()
    X.Callback("x-invoice:fetchUserInvoices", function(invoices)
        GetUserInvoices(invoices)
    end)
end

FetchInvoicesSent = function()
    X.Callback("x-invoice:fetchSentInvoices", function(invoices)
        GetSentInvoices(invoices)
    end)
end

GetSentInvoices = function(invoices, pageIndex)
    local options = {
        {
            ["label"] = "~y~Skickade"
        }
    }
    
    if #invoices < 1 then 
        return X.Notify("Fakturor", "Du har inga skickade fakturor!", 5000, "error")
    end

    if not pageIndex then pageIndex = 1 end

    local invoicesPerPage = 6

    for currentInvoiceIndex = invoicesPerPage * pageIndex - (invoicesPerPage - 1), invoicesPerPage * pageIndex do
        local currentInvoice = invoices[currentInvoiceIndex] 

        if currentInvoice then
            local invoiceLabel = currentInvoice.invoiceData.job and currentInvoice.invoiceData.company or currentInvoice.owner

            table.insert(options, {
                label = "~b~Faktura~s~ | ~g~" .. invoiceLabel,
                callback = function()
                    OpenDeleteInvoice(currentInvoice)
                end
            })
        end
    end

    if pageIndex > 1 then
        table.insert(options, {
            label = "~r~⬅",
            callback = function()
                GetSentInvoices(invoices, pageIndex - 1)
            end
        })
    end

    if invoices[(invoicesPerPage * pageIndex) + 1] then
        table.insert(options, {
            label = "~g~➡",
            callback = function()
                GetSentInvoices(invoices, pageIndex + 1)
            end
        })
    end

    exports["x-context"]:OpenContextMenu({
        menu = "self-invoice-sent-your-menu",
        entity = PlayerPedId(),
        options = options
    })
end

GetUserInvoices = function(invoices, pageIndex)
    local options = {
        {
            ["label"] = "~y~Mottagna"
        }
    }
    
    if #invoices < 1 then 
        return X.Notify("Fakturor", "Du har inte mottagit någon faktura!", 5000, "error")
    end

    if not pageIndex then pageIndex = 1 end

    local invoicesPerPage = 6

    for currentInvoiceIndex = invoicesPerPage * pageIndex - (invoicesPerPage - 1), invoicesPerPage * pageIndex do
        local currentInvoice = invoices[currentInvoiceIndex]

        if currentInvoice then
            local invoiceLabel = currentInvoice.invoiceData.job and currentInvoice.invoiceData.company or currentInvoice.invoiceData.name

            table.insert(options, {
                label = "~b~Faktura~s~ | ~g~" .. invoiceLabel,
                callback = function()
                    OpenInvoice(currentInvoice)
                end
            })
        end
    end

    if pageIndex > 1 then
        table.insert(options, {
            label = "~r~⬅",
            callback = function()
                GetUserInvoices(invoices, pageIndex - 1)
            end
        })
    end

    if invoices[(invoicesPerPage * pageIndex) + 1] then
        table.insert(options, {
            label = "~g~➡",
            callback = function()
                GetUserInvoices(invoices, pageIndex + 1)
            end
        })
    end

    exports["x-context"]:OpenContextMenu({
        menu = "self-invoice-your-menu",
        entity = PlayerPedId(),
        options = options
    })
end

OpenDeleteInvoice = function(currentInvoice)
    Citizen.Wait(250)

    SetNuiFocus(true, true)

    SendNUIMessage({
        ["Action"] = "OPEN_DELETE_INVOICE",
        ["Data"] = {
            ["Type"] = "delete",
            ["invoiceData"] = currentInvoice["invoiceData"],
            ["Items"] = currentInvoice["invoiceData"]["articles"],
            ["id"] = currentInvoice["id"],
            ["sender"] = currentInvoice["sender"],
            ["reciever"] = currentInvoice["reciever"]
        }
    })
end


OpenInvoice = function(invoice)
    Citizen.Wait(250)

    SetNuiFocus(true, true)
    SendNUIMessage({
        ["Action"] = "OPEN_PAYMENT_INVOICE",
        ["Data"] = {
            ["Type"] = "pay",
            ["invoiceData"] = invoice["invoiceData"],
            ["Items"] = invoice["invoiceData"]["articles"],
            ["id"] = invoice["id"],
            ["sender"] = invoice["sender"],
            ["reciever"] = invoice["reciever"],
        }
    })
end

OpenForcedInvoice = function(invoiceData)
    Citizen.Wait(250)

    local characterData = X.Character.Data.identification

    if not characterData then return end

    local jobs = {}

    local jobPair = exports["x-jobs"]:GetJobs()

    for jobName, jobData in pairs(jobPair) do 
        if jobName ~= "UNEMPLOYED" then 
            table.insert(jobs, jobData["Label"])
        end
    end

    local createDate, payDate = GetPayDate()

    SetNuiFocus(true, true)

    X.Callback("x-invoice:getDate", function(date)
        SendNUIMessage({
            Action = "OPEN_FORCED_INVOICE",
            Data = {
                Character = {
                    Name = characterData.firstname .. " " .. characterData.lastname,
                    CharacterId = characterData.dateofbirth ..  "-" .. characterData.lastdigits,
                    Agency = exports["x-jobs"]:GetJobData(X.Character.Data.job.name).Label,
                    Reciever = invoiceData.Reciever
                },

                Articles = invoiceData.Articles,

                Image = invoiceData.Image,
                createDate = date.dateCreated.year .. "-" .. date.dateCreated.month .. "-" .. date.dateCreated.day,
                payDate = date.realPayDate.year .. "-" .. date.realPayDate.month .. "-" .. date.realPayDate.day,
                identificationId = math.random(10000, 99999),
                Jobs = jobs
            }
        })
    end)
end

 GetPayDate = function()
     local year,month,day = GetLocalTime()
     local payDay = tonumber(day) + 14


     if month == 1 then
         if payDay > 27 then
             local daysToThirty = 28 - tonumber(day)
             month = tonumber(month) + 1
             payDay = 14 - daysToThirty
         end
     else
         if payDay > 30 then
             local daysToThirty = 31 - tonumber(day)
             month = tonumber(month) + 1
             payDay = 14 - daysToThirty
         end
     end

     if month < 10 then month = "0" .. month end
     if day < 10 then day = "0" .. day end
     if payDay < 10 then payDay = "0" .. payDay end

     local createDate = (year .. "-" .. month .. "-" .. day)
     local payDate = (year .. "-" .. month .. "-" .. payDay)
 end

GetJobMenu = function(playerEntity, vehicleEntity)
    local options = {}

    return options
end

DrawScriptMarker = function(markerData)
    DrawMarker(markerData["type"] or 1, markerData["pos"] or vector3(0.0, 0.0, 0.0), 0.0, 0.0, 0.0, (markerData["type"] == 6 and -90.0 or markerData["rotate"] and -180.0) or 0.0, 0.0, 0.0, markerData["size"] or vector3(1.0, 1.0, 1.0), markerData["r"] or 1.0, markerData["g"] or 1.0, markerData["b"] or 1.0, 100, markerData["bob"] and true or false, true, 2, false, false, false, false)
end

DrawBusySpinner = function(text)
    SetLoadingPromptTextEntry("STRING")
    AddTextComponentSubstringPlayerName(text)
    ShowLoadingPrompt(3)
end

OpenInput = function(label, type)
	AddTextEntry(type, label)

	DisplayOnscreenKeyboard(1, type, "", "", "", "", "", 30)

	while UpdateOnscreenKeyboard() == 0 do
		DisableAllControlActions(0)
		Wait(0)
	end

	if GetOnscreenKeyboardResult() then
	  	return GetOnscreenKeyboardResult()
	end
end

DrawMissionText = function(InfoText)
	local InfoText = InfoText .. " "
    local InfoTextWidth = GetTextWidth(InfoText, 0, 0.4)

    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(0.4, 0.4)
    SetTextColour(255, 255, 255, 255)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextEntry("STRING")
    AddTextComponentString(InfoText)
    DrawRect(0.5, 0.915, InfoTextWidth + 0.01, 0.04, 10, 10, 10, 100)
    DrawText(0.5 - InfoTextWidth / 2, 0.9)
end

GetTextWidth = function(text, font, scale)
    SetTextEntryForWidth("STRING")
    AddTextComponentSubstringPlayerName(text)
    SetTextFont(font)
    SetTextScale(scale, scale)

    return EndTextCommandGetWidth(true)
end

DrawPointText = function(pointData)
    if Heap["Scaleform"] and HasScaleformMovieLoaded(Heap["Scaleform"]) then
        if not IsPauseMenuActive() then
            PushScaleformMovieFunction(Heap["Scaleform"], "SHOW_MIDSIZED_MESSAGE")
            PushScaleformMovieFunctionParameterString("~y~" .. pointData.Label)
            PushScaleformMovieFunctionParameterString(
                    pointData.Text
            )
            PopScaleformMovieFunctionVoid()

            DrawScaleformMovie_3dSolid(
                Heap["Scaleform"],
                pointData.Location,
                pointData.Rotation,
                1.0,
                1.0,
                1.0,
                pointData.Scale,
                pointData.Scale * 0.8,
                1.0,
                5
            )
        end
    end
end

RequestNetwork = function(entity)
    while not NetworkHasControlOfEntity(entity) do 
        NetworkRequestControlOfEntity(entity)  
        Citizen.Wait(0)    
    end
end

fuckthisvector = function(param1, param2)
    local fuckedvector = vector3(0.0, 0.0, (180.0 - GetHeadingFromVector_2d((param2.x - param1.x), (param2.y - param1.y))))

    return fuckedvector
end