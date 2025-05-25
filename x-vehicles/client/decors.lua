local decors = {
    {
        Name = "VEHICLE_FUEL_LEVEL",
        Type = 1
    },
    {
        Name = "VEHICLE_TRAVELED_METERS",
        Type = 1
    },
    {  
        Name = "VEHICLE_TIMES_SERVICED",
        Type = 3
    },
    {
        Name = "VEHICLE_PARKING_INDEX",
        Type = 3
    },
    {
        Name = "VEHICLE_TIMES_REPAIRED",
        Type = 3
    },
    {
        Name = "VEHICLE_SERVICE_NEEDED",
        Type = 2
    },
    {
        Name = "VEHICLE_COATING_APPLIED",
        Type = 3
    },
    {
        Name = "VEHICLE_LOCK_UUID",
        Type = 3
    },
    {
        Name = "VEHICLE_HAS_NEON",
        Type = 2
    },

    {
        Name = "VEHICLE_POSITION_FRONT",
        Type = 1
    },
    {
        Name = "VEHICLE_POSITION_REAR",
        Type = 1
    },
    {
        Name = "VEHICLE_CAMBER_FRONT",
        Type = 1
    },
    {
        Name = "VEHICLE_CAMBER_REAR",
        Type = 1
    },
    {
        Name = "VEHICLE_WHEEL_WIDTH",
        Type = 1
    },
    {
        Name = "VEHICLE_NITROUS_OXIDE_LEVEL",
        Type = 1
    },

    {
        Name = "VEHICLE_HAS_TRIM",
        Type = 2
    },
    {
        Name = "VEHICLE_ACCELERATION_MULTIPLIER",
        Type = 3
    },
    {
        Name = "VEHICLE_SPEED_MULTIPLIER",
        Type = 3
    }
}

for _, decorData in ipairs(decors) do
    DecorRegister(decorData.Name, decorData.Type)
end