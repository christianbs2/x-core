Initialize = function()

end

SaveLastVehicle = function(vehicle)
	if not DoesEntityExist(vehicle) then return end

	local vehicleProperties = GetVehicleProperties(vehicle)

	X.Callback("x-vehicles:saveVehicle", function(saved)
	end, vehicleProperties)
end

GetVehicleProperties = function(vehicle)
	if not DoesEntityExist(vehicle) then return {} end

	local stateBag = Entity(vehicle).state

	local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
	local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
	local extras = {}

	for id = 0, 12 do
		if DoesExtraExist(vehicle, id) then
			local state = IsVehicleExtraTurnedOn(vehicle, id) == 1
			
			extras[tostring(id)] = state
		end
	end

	local vehicleModel = GetEntityModel(vehicle)
	local displayName = GetDisplayNameFromVehicleModel(vehicleModel)
	local displayLabel = GetLabelText(displayName)

	local displayText = displayLabel == "NULL" and displayName or displayLabel

	local vehicleProps = {
		model             = GetEntityModel(vehicle),

		label 			  = displayText,

		plate             = GetVehicleNumberPlateText(vehicle),
		plateIndex        = GetVehicleNumberPlateTextIndex(vehicle),

		bodyHealth        = GetVehicleBodyHealth(vehicle),
		engineHealth      = GetVehicleEngineHealth(vehicle),

		fuelLevel         = GetVehicleFuelLevel(vehicle),
		dirtLevel         = GetVehicleDirtLevel(vehicle),
		color1            = colorPrimary,
		color2            = colorSecondary,

		pearlescentColor  = pearlescentColor,
		wheelColor        = wheelColor,

		wheels            = GetVehicleWheelType(vehicle),
		windowTint        = GetVehicleWindowTint(vehicle),

		neonEnabled       = {
			IsVehicleNeonLightEnabled(vehicle, 0),
			IsVehicleNeonLightEnabled(vehicle, 1),
			IsVehicleNeonLightEnabled(vehicle, 2),
			IsVehicleNeonLightEnabled(vehicle, 3)
		},

		interiorColor     = GetVehicleInteriorColour(vehicle),
		neonColor         = table.pack(GetVehicleNeonLightsColour(vehicle)),
		extras            = extras,
		tyreSmokeColor    = table.pack(GetVehicleTyreSmokeColor(vehicle)),
		xenonColor        = GetVehicleXenonLightsColor(vehicle),

		modSpoilers       = GetVehicleMod(vehicle, 0),
		modFrontBumper    = GetVehicleMod(vehicle, 1),
		modRearBumper     = GetVehicleMod(vehicle, 2),
		modSideSkirt      = GetVehicleMod(vehicle, 3),
		modExhaust        = GetVehicleMod(vehicle, 4),
		modFrame          = GetVehicleMod(vehicle, 5),
		modGrille         = GetVehicleMod(vehicle, 6),
		modHood           = GetVehicleMod(vehicle, 7),
		modFender         = GetVehicleMod(vehicle, 8),
		modRightFender    = GetVehicleMod(vehicle, 9),
		modRoof           = GetVehicleMod(vehicle, 10),

		modEngine         = GetVehicleMod(vehicle, 11),
		modBrakes         = GetVehicleMod(vehicle, 12),
		modTransmission   = GetVehicleMod(vehicle, 13),
		modHorns          = GetVehicleMod(vehicle, 14),
		modSuspension     = GetVehicleMod(vehicle, 15),
		modArmor          = GetVehicleMod(vehicle, 16),

		modTurbo          = IsToggleModOn(vehicle, 18),
		modSmokeEnabled   = IsToggleModOn(vehicle, 20),
		modXenon          = IsToggleModOn(vehicle, 22),

		modFrontWheels    = GetVehicleMod(vehicle, 23),
		modBackWheels     = GetVehicleMod(vehicle, 24),

		modPlateHolder    = GetVehicleMod(vehicle, 25),
		modVanityPlate    = GetVehicleMod(vehicle, 26),
		modTrimA          = GetVehicleMod(vehicle, 27),
		modOrnaments      = GetVehicleMod(vehicle, 28),
		modDashboard      = GetVehicleMod(vehicle, 29),
		modDial           = GetVehicleMod(vehicle, 30),
		modDoorSpeaker    = GetVehicleMod(vehicle, 31),
		modSeats          = GetVehicleMod(vehicle, 32),
		modSteeringWheel  = GetVehicleMod(vehicle, 33),
		modShifterLeavers = GetVehicleMod(vehicle, 34),
		modAPlate         = GetVehicleMod(vehicle, 35),
		modSpeakers       = GetVehicleMod(vehicle, 36),
		modTrunk          = GetVehicleMod(vehicle, 37),
		modHydrolic       = GetVehicleMod(vehicle, 38),
		modEngineBlock    = GetVehicleMod(vehicle, 39),
		modAirFilter      = GetVehicleMod(vehicle, 40),
		modStruts         = GetVehicleMod(vehicle, 41),
		modArchCover      = GetVehicleMod(vehicle, 42),
		modAerials        = GetVehicleMod(vehicle, 43),
		modTrimB          = GetVehicleMod(vehicle, 44),
		modTank           = GetVehicleMod(vehicle, 45),
		modWindows        = GetVehicleMod(vehicle, 46),
		modLivery         = GetVehicleLivery(vehicle)
	}

	vehicleProps["tyres"] = {}
	vehicleProps["windows"] = {}
	vehicleProps["doors"] = {}

	for id = 1, 7 do
		local tyreId = IsVehicleTyreBurst(vehicle, id, false)
	
		if tyreId then
			vehicleProps["tyres"][#vehicleProps["tyres"] + 1] = tyreId
	
			if tyreId == false then
				tyreId = IsVehicleTyreBurst(vehicle, id, true)
				vehicleProps["tyres"][ #vehicleProps["tyres"]] = tyreId
			end
		else
			vehicleProps["tyres"][#vehicleProps["tyres"] + 1] = false
		end
	end

	for id = 1, 13 do
		local windowId = IsVehicleWindowIntact(vehicle, id)

		if windowId ~= nil then
			vehicleProps["windows"][#vehicleProps["windows"] + 1] = windowId
		else
			vehicleProps["windows"][#vehicleProps["windows"] + 1] = true
		end
	end
	
	for id = 0, 5 do
		local doorId = IsVehicleDoorDamaged(vehicle, id)
	
		if doorId then
			vehicleProps["doors"][#vehicleProps["doors"] + 1] = doorId
		else
			vehicleProps["doors"][#vehicleProps["doors"] + 1] = false
		end
	end

	vehicleProps["fuelLevel"] = DecorExistOn(vehicle, "VEHICLE_FUEL_LEVEL") and DecorGetFloat(vehicle, "VEHICLE_FUEL_LEVEL") or 100.0

	if stateBag and stateBag.VEHICLE_TRAVELED_METERS then
		vehicleProps["distanceTraveled"] = stateBag.VEHICLE_TRAVELED_METERS
	end

	vehicleProps["timesServiced"] = DecorGetInt(vehicle, "VEHICLE_TIMES_SERVICED")
	vehicleProps["timesRepaired"] = DecorGetInt(vehicle, "VEHICLE_TIMES_REPAIRED")

	if stateBag and stateBag.VEHICLE_COATING_APPLIED then
		vehicleProps["coatingApplied"] = stateBag.VEHICLE_COATING_APPLIED
	end

	vehicleProps["lockUUID"] = DecorGetInt(vehicle, "VEHICLE_LOCK_UUID")

	if stateBag and stateBag.VEHICLE_POSITION_FRONT then
		vehicleProps["wheelPositionFront"] = stateBag.VEHICLE_POSITION_FRONT
		vehicleProps["wheelPositionRear"] = stateBag.VEHICLE_POSITION_REAR

		vehicleProps["wheelCamberFront"] = stateBag.VEHICLE_CAMBER_FRONT
		vehicleProps["wheelCamberRear"] = stateBag.VEHICLE_CAMBER_REAR

		vehicleProps["wheelWidth"] = stateBag.VEHICLE_WHEEL_WIDTH
	end

	if stateBag and stateBag.VEHICLE_NITROUS_OXIDE_LEVEL then
		vehicleProps["nitrousOxideLevel"] = stateBag.VEHICLE_NITROUS_OXIDE_LEVEL
	end

	if DecorExistOn(vehicle, "VEHICLE_PARKING_INDEX") then
		vehicleProps["parkingIndex"] = DecorGetInt(vehicle, "VEHICLE_PARKING_INDEX")
	end

	if stateBag and stateBag.VEHICLE_ACCELERATION_MULTIPLIER then
		vehicleProps["accelerationMultiplier"] = stateBag.VEHICLE_ACCELERATION_MULTIPLIER + 0.0
	end

	if stateBag and stateBag.VEHICLE_SPEED_MULTIPLIER then
		vehicleProps["speedMultiplier"] = stateBag.VEHICLE_SPEED_MULTIPLIER + 0.0
	end

	if stateBag and stateBag.VEHICLE_HAS_NEON then
		vehicleProps["hasNeon"] = stateBag.VEHICLE_HAS_NEON
	end

	return vehicleProps
end

SetVehicleProperties = function(vehicle, vehicleProps)
	if not DoesEntityExist(vehicle) then return end

	while not NetworkHasControlOfEntity(vehicle) do
		Citizen.Wait(0)

		NetworkRequestControlOfEntity(vehicle)
	end

	local stateBag = Entity(vehicle).state

	local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
	local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)

	SetVehicleModKit(vehicle, 0)

	if vehicleProps["extras"] then
		for id,enabled in pairs(vehicleProps["extras"]) do
			if enabled then
				SetVehicleExtra(vehicle, tonumber(id), 0)
			else
				SetVehicleExtra(vehicle, tonumber(id), 1)
			end
		end
	end

	if vehicleProps.plate then SetVehicleNumberPlateText(vehicle, vehicleProps.plate) end
	if vehicleProps.plateIndex then SetVehicleNumberPlateTextIndex(vehicle, vehicleProps.plateIndex) end
	if vehicleProps.bodyHealth then SetVehicleBodyHealth(vehicle, vehicleProps.bodyHealth + 0.0) end
	if vehicleProps.engineHealth then SetVehicleEngineHealth(vehicle, vehicleProps.engineHealth + 0.0) end
	if vehicleProps.tankHealth then SetVehiclePetrolTankHealth(vehicle, vehicleProps.tankHealth + 0.0) end
	if vehicleProps.fuelLevel then SetVehicleFuelLevel(vehicle, vehicleProps.fuelLevel + 0.0) end
	if vehicleProps.dirtLevel then SetVehicleDirtLevel(vehicle, vehicleProps.dirtLevel + 0.0) end
	if vehicleProps.color1 then SetVehicleColours(vehicle, vehicleProps.color1, colorSecondary) end
	if vehicleProps.color2 then SetVehicleColours(vehicle, vehicleProps.color1 or colorPrimary, vehicleProps.color2) end
	if vehicleProps.pearlescentColor then SetVehicleExtraColours(vehicle, vehicleProps.pearlescentColor, vehicleProps.wheelColor or wheelColor) end
	if vehicleProps.wheelColor then SetVehicleExtraColours(vehicle, vehicleProps.pearlescentColor or pearlescentColor, vehicleProps.wheelColor) end
	if vehicleProps.wheels then SetVehicleWheelType(vehicle, vehicleProps.wheels) end
	if vehicleProps.windowTint then SetVehicleWindowTint(vehicle, vehicleProps.windowTint) end

	--if vehicleProps["hasNeon"] then
	--	Entity(vehicle).state:set("VEHICLE_HAS_NEON", true, true)
	--end

	if vehicleProps["neonEnabled"] then
		SetVehicleNeonLightEnabled(vehicle, 0, vehicleProps["neonEnabled"][1])
		SetVehicleNeonLightEnabled(vehicle, 1, vehicleProps["neonEnabled"][2])
		SetVehicleNeonLightEnabled(vehicle, 2, vehicleProps["neonEnabled"][3])
		SetVehicleNeonLightEnabled(vehicle, 3, vehicleProps["neonEnabled"][4])

		--if not stateBag or stateBag and not stateBag.VEHICLE_HAS_NEON then
		--	Entity(vehicle).state:set("VEHICLE_HAS_NEON", vehicleProps["hasNeon"] or vehicleProps["neonEnabled"][1], true)
		--end
	end

	if vehicleProps["neonColor"] then SetVehicleNeonLightsColour(vehicle, vehicleProps["neonColor"][1], vehicleProps["neonColor"][2], vehicleProps["neonColor"][3]) end
	if vehicleProps["modSmokeEnabled"] then ToggleVehicleMod(vehicle, 20, true) end
	if vehicleProps["tyreSmokeColor"] then SetVehicleTyreSmokeColor(vehicle, vehicleProps["tyreSmokeColor"][1], vehicleProps["tyreSmokeColor"][2], vehicleProps["tyreSmokeColor"][3]) end
	if vehicleProps["modSpoilers"] then SetVehicleMod(vehicle, 0, vehicleProps["modSpoilers"], false) end
	if vehicleProps["modFrontBumper"] then SetVehicleMod(vehicle, 1, vehicleProps["modFrontBumper"], false) end
	if vehicleProps["modRearBumper"] then SetVehicleMod(vehicle, 2, vehicleProps["modRearBumper"], false) end
	if vehicleProps["modSideSkirt"] then SetVehicleMod(vehicle, 3, vehicleProps["modSideSkirt"], false) end
	if vehicleProps["modExhaust"] then SetVehicleMod(vehicle, 4, vehicleProps["modExhaust"], false) end
	if vehicleProps["modFrame"] then SetVehicleMod(vehicle, 5, vehicleProps["modFrame"], false) end
	if vehicleProps["modGrille"] then SetVehicleMod(vehicle, 6, vehicleProps["modGrille"], false) end
	if vehicleProps["modHood"] then SetVehicleMod(vehicle, 7, vehicleProps["modHood"], false) end
	if vehicleProps["modFender"] then SetVehicleMod(vehicle, 8, vehicleProps["modFender"], false) end
	if vehicleProps["modRightFender"] then SetVehicleMod(vehicle, 9, vehicleProps["modRightFender"], false) end
	if vehicleProps["modRoof"] then SetVehicleMod(vehicle, 10, vehicleProps["modRoof"], false) end
	if vehicleProps["modEngine"] then SetVehicleMod(vehicle, 11, vehicleProps["modEngine"], false) end
	if vehicleProps["modBrakes"] then SetVehicleMod(vehicle, 12, vehicleProps["modBrakes"], false) end
	if vehicleProps["modTransmission"] then SetVehicleMod(vehicle, 13, vehicleProps["modTransmission"], false) end
	if vehicleProps["modHorns"] then SetVehicleMod(vehicle, 14, vehicleProps["modHorns"], false) end
	if vehicleProps["modSuspension"] then SetVehicleMod(vehicle, 15, vehicleProps["modSuspension"], false) end
	if vehicleProps["modArmor"] then SetVehicleMod(vehicle, 16, vehicleProps["modArmor"], false) end
	if vehicleProps["modTurbo"] then ToggleVehicleMod(vehicle,  18, vehicleProps["modTurbo"]) end
	if vehicleProps["modXenon"] then ToggleVehicleMod(vehicle,  22, vehicleProps["modXenon"]) end
	if vehicleProps["modFrontWheels"] then SetVehicleMod(vehicle, 23, vehicleProps["modFrontWheels"], false) end
	if vehicleProps["modBackWheels"] then SetVehicleMod(vehicle, 24, vehicleProps["modBackWheels"], false) end
	if vehicleProps["modPlateHolder"] then SetVehicleMod(vehicle, 25, vehicleProps["modPlateHolder"], false) end
	if vehicleProps["modVanityPlate"] then SetVehicleMod(vehicle, 26, vehicleProps["modVanityPlate"], false) end
	if vehicleProps["modTrimA"] then SetVehicleMod(vehicle, 27, vehicleProps["modTrimA"], false) end
	if vehicleProps["modOrnaments"] then SetVehicleMod(vehicle, 28, vehicleProps["modOrnaments"], false) end
	if vehicleProps["modDashboard"] then SetVehicleMod(vehicle, 29, vehicleProps["modDashboard"], false) end
	if vehicleProps["modDial"] then SetVehicleMod(vehicle, 30, vehicleProps["modDial"], false) end
	if vehicleProps["modDoorSpeaker"] then SetVehicleMod(vehicle, 31, vehicleProps["modDoorSpeaker"], false) end
	if vehicleProps["modSeats"] then SetVehicleMod(vehicle, 32, vehicleProps["modSeats"], false) end
	if vehicleProps["modSteeringWheel"] then SetVehicleMod(vehicle, 33, vehicleProps["modSteeringWheel"], false) end
	if vehicleProps["modShifterLeavers"] then SetVehicleMod(vehicle, 34, vehicleProps["modShifterLeavers"], false) end
	if vehicleProps["modAPlate"] then SetVehicleMod(vehicle, 35, vehicleProps["modAPlate"], false) end
	if vehicleProps["modSpeakers"] then SetVehicleMod(vehicle, 36, vehicleProps["modSpeakers"], false) end
	if vehicleProps["modTrunk"] then SetVehicleMod(vehicle, 37, vehicleProps["modTrunk"], false) end
	if vehicleProps["modHydrolic"] then SetVehicleMod(vehicle, 38, vehicleProps["modHydrolic"], false) end
	if vehicleProps["modEngineBlock"] then SetVehicleMod(vehicle, 39, vehicleProps["modEngineBlock"], false) end
	if vehicleProps["modAirFilter"] then SetVehicleMod(vehicle, 40, vehicleProps["modAirFilter"], false) end
	if vehicleProps["modStruts"] then SetVehicleMod(vehicle, 41, vehicleProps["modStruts"], false) end
	if vehicleProps["modArchCover"] then SetVehicleMod(vehicle, 42, vehicleProps["modArchCover"], false) end
	if vehicleProps["modAerials"] then SetVehicleMod(vehicle, 43, vehicleProps["modAerials"], false) end
	if vehicleProps["modTrimB"] then SetVehicleMod(vehicle, 44, vehicleProps["modTrimB"], false) end
	if vehicleProps["modTank"] then SetVehicleMod(vehicle, 45, vehicleProps["modTank"], false) end
	if vehicleProps["modWindows"] then SetVehicleMod(vehicle, 46, vehicleProps["modWindows"], false) end

	if vehicleProps["distanceTraveled"] then
		Entity(vehicle).state:set("VEHICLE_TRAVELED_METERS", tonumber(vehicleProps["distanceTraveled"]) + 0.0, true)
	end

	if vehicleProps["timesServiced"] then DecorSetInt(vehicle, "VEHICLE_TIMES_SERVICED", vehicleProps["timesServiced"] or 0) end
	if vehicleProps["timesRepaired"] then DecorSetInt(vehicle, "VEHICLE_TIMES_REPAIRED", vehicleProps["timesRepaired"] or 0) end 

	if vehicleProps["modLivery"] then
		SetVehicleMod(vehicle, 48, vehicleProps["modLivery"], false)
		SetVehicleLivery(vehicle, vehicleProps["modLivery"])
	end

    if vehicleProps["windows"] then
        for windowId = 1, 13, 1 do
            if vehicleProps["windows"][windowId] == false then
                SmashVehicleWindow(vehicle, windowId)
            end
        end
    end

    if vehicleProps["tyres"] then
        for tyreId = 1, 7, 1 do
            if vehicleProps["tyres"][tyreId] ~= false then
                SetVehicleTyreBurst(vehicle, tyreId, true, 1000)
            end
        end
    end

    if vehicleProps["doors"] then
        for doorId = 0, 5, 1 do
            if vehicleProps["doors"][doorId] ~= false then
                SetVehicleDoorBroken(vehicle, doorId - 1, true)
            end
        end
    end

	if vehicleProps["fuelLevel"] then
		DecorSetFloat(vehicle, "VEHICLE_FUEL_LEVEL", tonumber(vehicleProps["fuelLevel"]) + 0.1)
		SetVehicleFuelLevel(vehicle, tonumber(vehicleProps["fuelLevel"]) + 0.1)
	end

	if vehicleProps["lockUUID"] then
		DecorSetInt(vehicle, "VEHICLE_LOCK_UUID", vehicleProps["lockUUID"])
	end

	if vehicleProps["interiorColor"] then
		SetVehicleInteriorColor(vehicle, vehicleProps["interiorColor"])
		SetVehicleDashboardColor(vehicle, vehicleProps["interiorColor"])
	end

	if vehicleProps["xenonColor"] then
		local color = vehicleProps["xenonColor"] == 255 and -1 or vehicleProps["xenonColor"]

		SetVehicleXenonLightsColor(vehicle, color)
	end

	if not NetworkGetEntityIsNetworked(vehicle) then
		if vehicleProps["coatingApplied"] then
			Entity(vehicle).state:set("VEHICLE_COATING_APPLIED", vehicleProps["coatingApplied"], true)
		end

		if vehicleProps["wheelPositionFront"] then
			Entity(vehicle).state:set("VEHICLE_POSITION_FRONT", vehicleProps["wheelPositionFront"], true)
			Entity(vehicle).state:set("VEHICLE_POSITION_REAR", vehicleProps["wheelPositionRear"], true)

			Entity(vehicle).state:set("VEHICLE_CAMBER_FRONT", vehicleProps["wheelCamberFront"], true)
			Entity(vehicle).state:set("VEHICLE_CAMBER_REAR", vehicleProps["wheelCamberRear"], true)

			Entity(vehicle).state:set("VEHICLE_WHEEL_WIDTH", vehicleProps["wheelWidth"], true)
		end

		if vehicleProps["nitrousOxideLevel"] then
			Entity(vehicle).state:set("VEHICLE_NITROUS_OXIDE_LEVEL", tonumber(vehicleProps["nitrousOxideLevel"]) + 0.0, true)
		end
	end

	--if vehicleProps["accelerationMultiplier"] then
	--	Entity(vehicle).state:set("VEHICLE_ACCELERATION_MULTIPLIER", tonumber(vehicleProps["accelerationMultiplier"]) + 0.0, true)
	--end
	--
	--if vehicleProps["speedMultiplier"] then
	--	Entity(vehicle).state:set("VEHICLE_SPEED_MULTIPLIER", tonumber(vehicleProps["speedMultiplier"]) + 0.0, true)
	--end

	if NetworkGetEntityIsNetworked(vehicle) then
		TriggerServerEvent("x-vehicles:applyValues", NetworkGetNetworkIdFromEntity(vehicle), vehicleProps)
	end
end

ToggleNeon = function(vehicleHandle)
	local vehicleProperties = GetVehicleProperties(vehicleHandle)

	if vehicleProperties.neonEnabled[1] == 1 then
		SetVehicleProperties(vehicleHandle, {
			neonEnabled = { false, false, false, false }
		})
	else
		if Entity(vehicleHandle).state.VEHICLE_HAS_NEON then
			SetVehicleProperties(vehicleHandle, {
				neonEnabled = { 1, 1, 1, 1 }
			})
		end
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

DrawBusySpinner = function(text)
    SetLoadingPromptTextEntry("STRING")
    AddTextComponentSubstringPlayerName(text)
    ShowLoadingPrompt(3)
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

DrawScriptMarker = function(markerData)
    DrawMarker(markerData["type"] or 1, markerData["pos"] or vector3(0.0, 0.0, 0.0), 0.0, 0.0, 0.0, (markerData["type"] == 6 and -90.0 or markerData["rotate"] and -180.0) or 0.0, 0.0, 0.0, markerData["sizeX"] or 1.0, markerData["sizeY"] or 1.0, markerData["sizeZ"] or 1.0, markerData["r"] or 1.0, markerData["g"] or 1.0, markerData["b"] or 1.0, 100, false, true, 2, false, false, false, false)
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

DrawText3D = function(coords, text, scale)
    if not scale then scale = 0.35 end 

    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    
    SetTextScale(scale, scale)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
end