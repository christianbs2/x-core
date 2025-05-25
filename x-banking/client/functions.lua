GlobalFunction = function(event, data)
    local options = {
        event = event,
        data = data
    }

    TriggerServerEvent("qalle_banking:globalEvent", options)
end

OpenContextMenu = function(entity, type)
	local options = {}

	table.insert(options, {
		["label"] = type == "atm" and "~y~Bankomat" or "~y~Bankkassör"
	})

	table.insert(options, {
		["label"] = type == "atm" and "~g~Använd" or "~g~Prata",
		["action"] = "use",
		["callback"] = function()
			if type == "atm" then
				UseAtm(entity)
			else
				UseTeller(entity)
			end
		end
	})

	exports["x-context"]:OpenContextMenu({
		["menu"] = type .. "-" .. entity,
		["entity"] = entity,
		["options"] = options
	})
end

UseAtm = function(atmEntity)
	exports["x-core"]:EditRichPresence("Använder en bankomat...")

	Heap["using"] = true

	local atmOffsetCoords = GetOffsetFromEntityInWorldCoords(atmEntity, 0.0, -0.6, 1.0)

	local _, taskSequence = OpenSequenceTask()
	TaskLookAtEntity(0, atmEntity)
	TaskGoStraightToCoord(0, atmOffsetCoords, 2.0, 2000, 1193033728, 1056964608)
	TaskAchieveHeading(0, GetEntityHeading(atmEntity))
	TaskClearLookAt(0)
	CloseSequenceTask(taskSequence)

	TaskPerformSequence(PlayerPedId(), taskSequence)

	Citizen.Wait(50)

	while GetSequenceProgress(PlayerPedId()) >= 0 do
		Citizen.Wait(0)
	end

	local atmOffsetCoords = GetOffsetFromEntityInWorldCoords(atmEntity, 0.0, -0.3, 1.3)
	local playerRotation = GetEntityRotation(PlayerPedId())

	local camPos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.6, -0.3, 0.8)

    Heap["cams"] = {
        ["first"] = CreateAnimatedCam({ ["x"] = camPos["x"], ["y"] = camPos["y"], ["z"] = camPos["z"], ["rotationX"] = playerRotation["x"] - 35.0, ["rotationY"] = playerRotation["y"], ["rotationZ"] = playerRotation["z"] })
    }

	PointCamAtCoord(Heap["cams"]["first"], GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.9, 0.1))

	RenderScriptCams(true, true, 1000, true, true)

    HandleCam("first", "first", 0)

	PlayAnimation(PlayerPedId(), false, "PROP_HUMAN_ATM")

	OpenBankNUI()
end

UseTeller = function(tellerEntity)
	exports["x-core"]:EditRichPresence("Pratar med en bankkassör...")

	Heap["using"] = true

	local forwardTellerPos = GetOffsetFromEntityInWorldCoords(tellerEntity, 0.0, 1.5, 0.0)

	local _, taskSequence = OpenSequenceTask()
	TaskLookAtEntity(0, tellerEntity)
	TaskGoStraightToCoord(0, forwardTellerPos, 2.0, 5000, 1193033728, 1056964608)
	TaskAchieveHeading(0, GetEntityHeading(tellerEntity) - 180.0)
	CloseSequenceTask(taskSequence)

	TaskPerformSequence(PlayerPedId(), taskSequence)

	Citizen.Wait(50)

	while GetSequenceProgress(PlayerPedId()) >= 0 do
		Citizen.Wait(0)
	end

	TaskLookAtEntity(0, tellerEntity)
	TaskStandStill(0, -1)

	local camPos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.6, -0.3, 0.8)

	Heap["cams"] = {
        ["first"] = CreateAnimatedCam({ ["x"] = camPos["x"], ["y"] = camPos["y"], ["z"] = camPos["z"], ["rotationX"] = 0.0, ["rotationY"] = 0.0, ["rotationZ"] = 0.0 })
	}
	
	PointCamAtCoord(Heap["cams"]["first"], GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.9, 0.3))

	RenderScriptCams(true, true, 1000, true, true)

	HandleCam("first", "first", 0)

	OpenBankNUI()
end

MainThread = function()
	while Heap["using"] do
		Citizen.Wait(5)

		DisableAllControlActions(0)

		DrawButtons({
			{
				["button"] = "~INPUT_CELLPHONE_CANCEL~",
				["label"] = "Avbryt"
			},
			{
				["button"] = "~INPUT_MOVE_RIGHT_ONLY~",
				["label"] = "Ta ut"
			},
			{
				["button"] = "~INPUT_MOVE_LEFT_ONLY~",
				["label"] = "Sätt in"
			},
			{
				["button"] = "",
				["label"] = "Banken: " .. X.Character.Data["bank"]["balance"] .. " SEK"
			},
			{
				["button"] = "",
				["label"] = "Kontanter: " .. X.Character.Data["cash"]["balance"] .. " SEK"
			}
		})

		if IsDisabledControlJustPressed(0, 177) then
			Heap["using"] = false
		elseif IsDisabledControlJustPressed(0, 35) then
			DoAction("withdraw")
		elseif IsDisabledControlJustPressed(0, 34) then
			DoAction("deposit")
		end
	end

	HandleCam(0)

	ClearPedTasks(PlayerPedId())

	exports["x-core"]:EditRichPresence()
end

DoAction = function(type)
	local actionAmount = 0

	if type == "withdraw" then
		actionAmount = OpenInput("Ta ut", "withdraw")
	else
		actionAmount = OpenInput("Sätt in", "deposit")
	end

	actionAmount = tonumber(actionAmount)

	if actionAmount and actionAmount > 0 then
		X.Callback("x-banking:doAction", function(actionConfirmed, error)
			if actionConfirmed then
				X.Notify("Bank", "Transaktion validerad.", 3000, "success")
			else
				X.Notify("Bank", error, 3000, "error")
			end
		end, type, actionAmount)
	else
		X.Notify("Bank", "Siffran måste vara över 0.", 3000, "error")
	end
end

OpenBankNUI = function(skipTransactions)
	X.Callback("x-banking:fetchBankingData", function(bankingData)
		OpenNUI(bankingData)
	end, skipTransactions)
end

OpenNUI = function(bankingData)
	local characterData = X.Character.Data.identification

	if not characterData then return end

	bankingData.Character = characterData

	SendNUIMessage({
		Action = "OPEN_BANKING_NUI",
		Data = bankingData
	})

	Heap.NuiOpened = true

	SetNuiFocus(true, true)
end

OpenInput = function(label, type)
	AddTextEntry(type, label)

	DisplayOnscreenKeyboard(1, type, "", "", "", "", "", 10)

	while UpdateOnscreenKeyboard() == 0 do
		DisableAllControlActions(0)
		Wait(0)
	end

	if GetOnscreenKeyboardResult() then
	  	return GetOnscreenKeyboardResult()
	end
end

SpawnTellers = function()
	Heap["tellers"] = {}

	for tellerIndex, tellerData in ipairs(Config.Tellers) do
		tellerData["model"] = Config.TellerHash

		tellerData["callback"] = function(pedEntity)
			TaskTurnPedToFaceEntity(PlayerPedId(), pedEntity, 750)
			TaskTurnPedToFaceEntity(pedEntity, PlayerPedId(), 750)
	
			OpenContextMenu(pedEntity, "teller")
		end 
	
		local createdPed = exports["x-pedstream"]:ConstructPed(tellerData)

		tellerData["ped"] = createdPed
	
		table.insert(Heap["tellers"], createdPed)
	end
end

DrawButtons = function(buttonsToDraw)
	local instructionScaleform = RequestScaleformMovie("instructional_buttons")

	while not HasScaleformMovieLoaded(instructionScaleform) do
		Wait(0)
	end

	PushScaleformMovieFunction(instructionScaleform, "CLEAR_ALL")
	PushScaleformMovieFunction(instructionScaleform, "TOGGLE_MOUSE_BUTTONS")
	PushScaleformMovieFunctionParameterBool(0)
	PopScaleformMovieFunctionVoid()

	for buttonIndex, buttonValues in ipairs(buttonsToDraw) do
		PushScaleformMovieFunction(instructionScaleform, "SET_DATA_SLOT")
		PushScaleformMovieFunctionParameterInt(buttonIndex - 1)

		PushScaleformMovieMethodParameterButtonName(buttonValues["button"])
		PushScaleformMovieFunctionParameterString(buttonValues["label"])
		PopScaleformMovieFunctionVoid()
	end

	PushScaleformMovieFunction(instructionScaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
	PushScaleformMovieFunctionParameterInt(-1)
	PopScaleformMovieFunctionVoid()
	DrawScaleformMovieFullscreen(instructionScaleform, 255, 255, 255, 255)
end

DrawScriptMarker = function(markerData)
    DrawMarker(markerData["type"] or 1, markerData["pos"] or vector3(0.0, 0.0, 0.0), 0.0, 0.0, 0.0, (markerData["type"] == 6 and -90.0 or markerData["rotate"] and -180.0) or 0.0, 0.0, 0.0, markerData["sizeX"] or 1.0, markerData["sizeY"] or 1.0, markerData["sizeZ"] or 1.0, markerData["r"] or 1.0, markerData["g"] or 1.0, markerData["b"] or 1.0, 100, false, true, 2, false, false, false, false)
end

DrawScriptText = function(coords, text)
    local onScreen, _x, _y = World3dToScreen2d(coords["x"], coords["y"], coords["z"])
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)

    local factor = string.len(text) / 370

    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
end

PlayAnimation = function(ped, dict, anim, settings)
	if dict then
        Citizen.CreateThread(function()
            RequestAnimDict(dict)

            while not HasAnimDictLoaded(dict) do
                Citizen.Wait(100)
            end

            if settings == nil then
                TaskPlayAnim(ped, dict, anim, 1.0, -1.0, 1.0, 0, 0, 0, 0, 0)
            else 
                local speed = 1.0
                local speedMultiplier = -1.0
                local duration = 1.0
                local flag = 0
                local playbackRate = 0

                if settings["speed"] then
                    speed = settings["speed"]
                end

                if settings["speedMultiplier"] then
                    speedMultiplier = settings["speedMultiplier"]
                end

                if settings["duration"] then
                    duration = settings["duration"]
                end

                if settings["flag"] then
                    flag = settings["flag"]
                end

                if settings["playbackRate"] then
                    playbackRate = settings["playbackRate"]
                end

                TaskPlayAnim(ped, dict, anim, speed, speedMultiplier, duration, flag, playbackRate, 0, 0, 0)
            end
      
            RemoveAnimDict(dict)
		end)
	else
		TaskStartScenarioInPlace(ped, anim, 0, true)
	end
end

CreateAnimatedCam = function(camIndex)
    local camInformation = camIndex

    if not Heap["cams"] then
        Heap["cams"] = {}
    end

    if Heap["cams"][camIndex] then
        DestroyCam(Heap["cams"][camIndex])
    end

    Heap["cams"][camIndex] = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)

    SetCamCoord(Heap["cams"][camIndex], camInformation["x"], camInformation["y"], camInformation["z"])
    SetCamRot(Heap["cams"][camIndex], camInformation["rotationX"], camInformation["rotationY"], camInformation["rotationZ"])

    return Heap["cams"][camIndex]
end

HandleCam = function(camIndex, secondCamIndex, camDuration)
    if camIndex == 0 then
        RenderScriptCams(false, true, 1000, true, true)
        
        return
    end

    local cam = Heap["cams"][camIndex]
    local secondCam = Heap["cams"][secondCamIndex] or nil

    local InterpolateCams = function(cam1, cam2, duration)
        SetCamActive(cam1, true)
        SetCamActiveWithInterp(cam2, cam1, duration, true, true)
    end

    if secondCamIndex then
        InterpolateCams(cam, secondCam, camDuration or 5000)
    end
end

LoadModels = function(models)
	for index, model in ipairs(models) do
		if IsModelValid(model) then
			while not HasModelLoaded(model) do
				RequestModel(model)
	
				Citizen.Wait(10)
			end
		else
			while not HasAnimDictLoaded(model) do
				RequestAnimDict(model)
	
				Citizen.Wait(10)
			end    
		end
	end
end

CleanupModels = function(models)
	for index, model in ipairs(models) do
		if IsModelValid(model) then
			SetModelAsNoLongerNeeded(model)
		else
			RemoveAnimDict(model)  
		end
	end
end

RequestNetworkControl = function(entitys)
	for index, entity in ipairs(entitys) do
		while not NetworkHasControlOfEntity(entity) do
			NetworkRequestControlOfEntity(entity)

			Citizen.Wait(0)
		end
	end
end