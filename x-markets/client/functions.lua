GlobalFunction = function(event, data)
    local options = {
        event = event,
        data = data
    }

    TriggerServerEvent("x-markets:globalEvent", options)
end

GetPolice = function()
	if not Heap.officerCount then 
		return(0) 
	else
		return(Heap.officerCount)
	end 
end

ClosingHour = function(marketName)
	local storeType = Config.WhatStore(marketName)

	if storeType == "247" then return false end
	
	local marketSetting = Config.MarketSettings[storeType]
	local _, _, _, hour, minute, _ = GetLocalTime()

	hour = hour + 2

	if hour >= 24 then
		hour = hour - 24
	end

	local marketClosed = hour > marketSetting["schedule"]["closeHour"] or (hour >= 0 and hour < marketSetting["schedule"]["openingHour"] or false)
	
	return marketClosed
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

DrawBusySpinner = function(text)
    SetLoadingPromptTextEntry("STRING")
    AddTextComponentSubstringPlayerName(text)
    ShowLoadingPrompt(6)
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

DrawTimerBar = function(percent, text)
	if not percent then percent = 0 end

	local correction = ((1.0 - math.floor(GetSafeZoneSize(), 2)) * 100) * 0.005
	local X, Y, W, H = 1.415 - correction, 1.475 - correction, percent * 0.00085, 0.0125
	
	if not HasStreamedTextureDictLoaded("timerbars") then
		RequestStreamedTextureDict("timerbars")

		while not HasStreamedTextureDictLoaded("timerbars") do
			Citizen.Wait(0)
		end
	end
	
	Set_2dLayer(0)
	DrawSprite("timerbars", "all_black_bg", X, Y, 0.15, 0.0325, 0.0, 255, 255, 255, 180)
	
	Set_2dLayer(1)
	DrawRect(X + 0.0275, Y, 0.085, 0.0125, 100, 0, 0, 180)
	
	Set_2dLayer(2)
	DrawRect(X - 0.015 + (W / 2), Y, W, H, 150, 0, 0, 180)
	
	SetTextColour(255, 255, 255, 180)
	SetTextFont(0)
	SetTextScale(0.3, 0.3)
	SetTextCentre(true)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	Set_2dLayer(3)
	DrawText(X - 0.04, Y - 0.012)
end

DrawText2D = function(msg, x, y, scale, fontType, r, g, b, a, useOutline, useDropshadow)
    BeginTextCommandDisplayText('STRING')
    AddTextComponentSubstringPlayerName(msg)
    SetTextFont(fontType)
    SetTextScale(1, scale)
    SetTextWrap(0.0, 1.0)
    SetTextCentre(true)
    SetTextColour(r, g, b, a)
    SetTextJustification(0)

    if useOutline then 
        SetTextOutline()
    end

    if useDropshadow then
        SetTextDropShadow()
    end

    EndTextCommandDisplayText(x, y)
end

PlayAnimation = function(ped, dict, anim, settings)
	if dict then
        RequestAnimDict(dict)

        while not HasAnimDictLoaded(dict) do
            Citizen.Wait(0)
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
	else
		TaskStartScenarioInPlace(ped, anim, 0, true)
	end
end

OpenInput = function(label, type, length)
    AddTextEntry(type, label)

    DisplayOnscreenKeyboard(1, type, "", "", "", "", "", length or 30)

    while UpdateOnscreenKeyboard() == 0 do
        DisableAllControlActions(0)
        Wait(0)
    end

    if GetOnscreenKeyboardResult() then
        return GetOnscreenKeyboardResult()
    end
end

CreateScriptBlip = function(blipData)
	local createdBlip = AddBlipForCoord(blipData.Location)

	SetBlipSprite(createdBlip, blipData.Sprite or 1)
	SetBlipScale(createdBlip, blipData.Scale or 0.5)
	SetBlipColour(createdBlip, blipData.Colour or 1)
	SetBlipAsShortRange(createdBlip, blipData.ShortRange == nil and true or blipData.ShortRange)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(blipData.Label or "Blip")
	EndTextCommandSetBlipName(createdBlip)

	return createdBlip
end