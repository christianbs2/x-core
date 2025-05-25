X = nil

Heap = {}

Characters = {}

Citizen.CreateThread(function()
    while not X do
        Citizen.Wait(50)
        --print("[DEBUG] Väntar på att `X` ska laddas...")
        X = exports["x-core"]:FetchMain()
    end

    -- Vänta tills `X.User.Loaded` verkligen är `true`:
    while not X.User or not X.User.Loaded do
        Citizen.Wait(50)
       -- print("[DEBUG] Väntar på att `X.User.Loaded` ska bli true...")
    end

    --print("[DEBUG] `X.User.Loaded` är nu true! Kör FetchCharacters...")
    FetchCharacters()

    FreezeEntityPosition(PlayerPedId(), false)
    DoScreenFadeIn(500)
end)

RegisterCommand("switch", function()
    SwitchCharacter()
end)

RegisterNetEvent("x-core:userLoaded")
AddEventHandler("x-core:userLoaded", function(userData)
    --print("[DEBUG] Första hanteraren för x-core:userLoaded körs.")
    --("[DEBUG] x-core:userLoaded triggat med data: ", userData)
    DoScreenFadeOut(0)

    FetchCharacters()  -- Om `X` eller `X.User.Loaded` är nil, kommer detta misslyckas.
end)

RegisterNetEvent("x-character:characterCreation")
AddEventHandler("x-character:characterCreation", function(characterData)
    Cleanup(true)

    InitiateCharacterCreator(characterData)
end)

RegisterNetEvent("x-character:refreshSelection")
AddEventHandler("x-character:refreshSelection", function()
    FetchCharacters()
end)

RegisterNetEvent("x-character:switchCharacter")
AddEventHandler("x-character:switchCharacter", function(characterIndex)
    if #Characters <= 0 then
        return
    end

    ChangeCharacter(characterIndex)
end)

RegisterNetEvent("x-character:switch")
AddEventHandler("x-character:switch", function()
    SwitchCharacter()
end)

RegisterNetEvent("x-character:characterLoaded")
AddEventHandler("x-character:characterLoaded", function(characterData)
    DoScreenFadeOut(50)
    
    X.Character = {}
    
    X.Character.IsLoaded = true
    
    X.Character.Data = characterData

    if not X.Character.Data["position"]["coords"] then
        X.Character.Data["position"]["coords"] = vector3(-2640.3855, 1869.9690, 160.1405)

        NetworkResurrectLocalPlayer(X.Character.Data["position"]["coords"], 0.0)
    else
        DoScreenFadeIn(100)

        if not IsPlayerSwitchInProgress() then
            SwitchOutPlayer(PlayerPedId(), 0, 1)
        end

        local savedPedCoords = vector3(X.Character.Data["position"]["coords"]["x"], X.Character.Data["position"]["coords"]["y"], X.Character.Data["position"]["coords"]["z"] - 0.985)

        NetworkResurrectLocalPlayer(savedPedCoords, 0.0)

        SetEntityCoords(PlayerPedId(), savedPedCoords)

        FreezeEntityPosition(PlayerPedId(), true)

        DrawBusySpinner("Laddar...")

        while GetPlayerSwitchState() ~= 5 do
            Citizen.Wait(0)
        end

        SwitchInPlayer(PlayerPedId())

        Citizen.Wait(5000)

        TriggerEvent("hud", true)
    end

    RemoveLoadingPrompt()

    FreezeEntityPosition(PlayerPedId(), false)

    SetEntityVisible(PlayerPedId(), true)

    DisplayRadar(true)
end)

RegisterNetEvent("x-character:jobUpdated")
AddEventHandler("x-character:jobUpdated", function(newData)
    X.Character.Data.job = newData
end)

RegisterNetEvent("x-character:exitedCharacter")
AddEventHandler("x-character:exitedCharacter", function()
    X.Character.IsLoaded = false
end)

RegisterNetEvent("x-character:closeNUI")
AddEventHandler("x-character:closeNUI", function()
    SetNuiFocus(false, false)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)

        if X.Character.IsLoaded then
            local ped = PlayerPedId()
            local pedCoords = GetEntityCoords(ped)

            if X.Character.Data["position"] and X.Character.Data["position"]["coords"] then
                local savedPedCoords = vector3(X.Character.Data["position"]["coords"]["x"], X.Character.Data["position"]["coords"]["y"], X.Character.Data["position"]["coords"]["z"])

                if #(pedCoords - savedPedCoords) > 3.0 then
                    X.Character.Data["position"]["coords"] = {
                        ["x"] = pedCoords["x"],
                        ["y"] = pedCoords["y"],
                        ["z"] = pedCoords["z"]
                    }

                    TriggerServerEvent("x-character:updatePosition", X.Character.Data["position"]["coords"])
                end
            end
        end
    end
end)

-- Helper to clear all violent_ui prompts
local function ClearViolentUI()
    exports['violent_ui']:displayMultilineText({})
    exports['violent_ui']:displayButtonPrompt({}, 0)
end

Citizen.CreateThread(function()
    local lastState = nil

    while true do
        local sleepThread = 250 -- Slightly faster for quicker UI responsiveness

        if Heap.Selecting then
            sleepThread = 0

            if IsDisabledControlPressed(0, 19) then -- ALT
                if lastState ~= "alt-held" then
                    ClearViolentUI()
                    exports['violent_ui']:displayButtonPrompt({
                        { key = "LMB", label = "VÄLJ KARAKTÄREN" },
                        { key = "RMB", label = "TA BORT KARAKTÄREN" }
                    }, 0)
                    lastState = "alt-held"
                end
            else
                if lastState ~= "alt-free" then
                    ClearViolentUI()
                    exports['violent_ui']:displayButtonPrompt({
                        { key = "ALT", label = "FÖR ATT VÄLJA KARAKTÄR" }
                    }, 0)
                    lastState = "alt-free"
                end
            end

            DisableControlAction(0, 200, true) -- ESC
        elseif lastState ~= nil then
            ClearViolentUI()
            lastState = nil
        end

        Citizen.Wait(sleepThread)
    end
end)
