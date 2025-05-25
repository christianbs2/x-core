Main.User = {}
Main.User.Loaded = false

Main.User.IsAdmin = function()
    return Main.User.Data["data"]["admin"] == 1, Main.User.Data["data"]["admin"]
end

GeneratePlayer = function()
    local genPos = vector3(450.2160949707, 5573.0141601563, 796.41479492188 - 0.985)

    DoScreenFadeOut(100)

    NetworkResurrectLocalPlayer(genPos, 0.0)

    local genModel = GetHashKey("ig_bankman")

    while not HasModelLoaded(genModel) do
        RequestModel(genModel)
        
        Citizen.Wait(0)
    end

    SetPlayerModel(PlayerId(), genModel)

    while not GetEntityModel(PlayerPedId()) == genModel do
        Citizen.Wait(100)
    end

    local ped = PlayerPedId()
    
    SetPedDefaultComponentVariation(ped)
    SetEntityCollision(ped, true, true)
    SetEntityVisible(ped, true)
    FreezeEntityPosition(ped, false)

    DoScreenFadeIn(100)
end