local enabled = false

local prop = {
    Model = GetHashKey("w_me_poolcue"),

    Attach = {
        Position = vector3(0.0, 0.0, 0.0),

        Rotation = vector3(0.0, 0.0, 0.0),

        Bone = 28422
    },

    Animation = {
        Dictionary = "missbigscore2aleadinout@bs_2a_2b_int",
        Animation = "lester_base_idle",

        Data = {
            flag = 49
        }
    }
}

local buttons = {
    {
        Button = 172,

        Axis = "POSITION",

        Change = vector3(0.0, 0.0, 0.01)
    },
    {
        Button = 173,

        Axis = "POSITION",

        Change = vector3(0.0, 0.0, -0.01)
    },
    {
        Button = 174,

        Axis = "POSITION",

        Change = vector3(0.01, 0.0, 0.0)
    },
    {
        Button = 175,

        Axis = "POSITION",

        Change = vector3(-0.01, 0.0, 0.0)
    },
    {
        Button = 245,

        Axis = "POSITION",

        Change = vector3(0.0, 0.01, 0.0)
    },
    {
        Button = 183,

        Axis = "POSITION",

        Change = vector3(0.0, -0.01, 0.0)
    },
    {
        Button = 205,

        Axis = "ROTATION",

        Change = vector3(0.0, 1.0, 0.0)
    },
    {
        Button = 206,

        Axis = "ROTATION",

        Change = vector3(0.0, -1.0, 0.0)
    },
    {
        Button = 306,

        Axis = "ROTATION",

        Change = vector3(5.0, 0.0, 0.0)
    },
    {
        Button = 310,

        Axis = "ROTATION",

        Change = vector3(-5.0, 0.0, 0.0)
    },
    {
        Button = 311,

        Axis = "ROTATION",

        Change = vector3(0.0, 0.0, 5.0)
    },
    {
        Button = 328,

        Axis = "ROTATION",

        Change = vector3(0.0, 0.0, -5.0)
    },
    {
        Button = 186,

        Axis = "REMOVE"
    }
}

local function thread(handle)
    DisableControlAction(0, 69, true) -- INPUT_VEH_ATTACK
    DisableControlAction(0, 92, true) -- INPUT_VEH_PASSENGER_ATTACK
    DisableControlAction(0, 114, true) -- INPUT_VEH_FLY_ATTACK
    DisableControlAction(0, 140, true) -- INPUT_MELEE_ATTACK_LIGHT
    DisableControlAction(0, 141, true) -- INPUT_MELEE_ATTACK_HEAVY
    DisableControlAction(0, 142, true) -- INPUT_MELEE_ATTACK_ALTERNATE
    DisableControlAction(0, 257, true) -- INPUT_ATTACK2
    DisableControlAction(0, 263, true) -- INPUT_MELEE_ATTACK1
    DisableControlAction(0, 264, true) -- INPUT_MELEE_ATTACK2
    DisableControlAction(0, 24, true) -- INPUT_ATTACK
    DisableControlAction(0, 25, true) -- INPUT_AIM
    DisableControlAction(0, 22, true) -- SPACE
    DisableControlAction(0, 288, true) -- F1
    DisableControlAction(0, 289, true) -- F2
    DisableControlAction(0, 170, true) -- F3
    DisableControlAction(0, 167, true) -- F6
    DisableControlAction(0, 168, true) -- F7
    DisableControlAction(0, 57, true) -- F10
    DisableControlAction(0, 23, true) -- F
    DisableControlAction(0, 183, true) -- F

    for _, button in ipairs(buttons) do
        if IsDisabledControlJustPressed(0, button.Button) then
            if button.Axis == "POSITION" then
                prop.Attach.Position = prop.Attach.Position + button.Change

                print("Changing position:", prop.Attach.Position)
            elseif button.Axis == "ROTATION" then
                prop.Attach.Rotation = prop.Attach.Rotation + button.Change

                print("Changing rotation:", prop.Attach.Rotation)
            elseif button.Axis == "REMOVE" then
                DeleteEntity(handle)
            end
        end
    end

    AttachEntityToEntity(handle, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), prop.Attach.Bone), prop.Attach.Position, prop.Attach.Rotation, true, true, false, true, 1, true)
end

Citizen.CreateThread(function()
    if not enabled then return end

    while not HasModelLoaded(prop.Model) do
        Citizen.Wait(0)

        RequestModel(prop.Model)
    end

    local handle = CreateObject(prop.Model, GetEntityCoords(PlayerPedId()), true)

    PlayAnimation(PlayerPedId(), prop.Animation.Dictionary, prop.Animation.Animation, prop.Animation.Data)

    while true do
        local sleepThread = 500

        if enabled then
            sleepThread = 5

            thread(handle)
        end

        Citizen.Wait(sleepThread)
    end
end)