RegisterNetEvent("x-invoice:closeNUI")
AddEventHandler("x-invoice:closeNUI", function()
    SetNuiFocus(false, false)

    Heap["NuiOpened"] = false
end)

RegisterNetEvent("x-invoice:updateNUI")
AddEventHandler("x-invoice:updateNUI", function(response)
    if Heap["NuiOpened"] then
        OpenNUI(response)
    end
end)

RegisterNetEvent("x-invoice:createInvoice")
AddEventHandler("x-invoice:createInvoice", function(data)
    TriggerServerEvent("x-invoice:createInvoice", data)
end)

RegisterNetEvent("x-invoice:payInvoice")
AddEventHandler("x-invoice:payInvoice", function(data)
    TriggerServerEvent("x-invoice:payInvoice", data)
end)

RegisterNetEvent("x-invoice:deleteInvoice")
AddEventHandler("x-invoice:deleteInvoice", function(data)
    TriggerServerEvent("x-invoice:deleteInvoice", data)
end)

OpenNui = function()
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
    
    X.Callback("x-invoice:getDate", function(date)
        print(json.encode(date))
        SendNUIMessage({
            Action = "OPEN_INVOICE_NUI",
            Data = {
                Character = {
                    Name = characterData.firstname .. " " .. characterData.lastname,
                    CharacterId = characterData.dateofbirth ..  "-" .. characterData.lastdigits,
                    Agency = exports["x-jobs"]:GetJobData(X.Character.Data.job.name).Label,
                    Reciever = ""
                },
                createDate = date.dateCreated.year .. "-" .. date.dateCreated.month .. "-" .. date.dateCreated.day,
                payDate = date.realPayDate.year .. "-" .. date.realPayDate.month .. "-" .. date.realPayDate.day,
                identificationId = math.random(10000, 99999),
                Jobs = jobs
            }
        })
    end)

    Heap["NuiOpened"] = true

    SetNuiFocus(true, true)
end
