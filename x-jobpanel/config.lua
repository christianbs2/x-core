Config = {}

Config.EnableDebug = false

Config.Delivery = {
    POLICE = {
        Location = vector3(569.7848, -66.26015, 71.33731), --vector4(569.7848, -66.26015, 71.33731, 108.5842)
        Garage = "POLICE_GARAGE"
    },
    MECHANIC = {
        Location = vector3(293.4952, -1811.917, 27.03865), --vector4(293.4952, -1811.917, 27.03865, 228.2574)
        Garage = "MECHANIC_GARAGE"
    },
    AMBULANCE = {
        Location = vector3(-739.0647, 305.4311, 85.2897), --vector4(294.0408, -583.3475, 43.18187, 340.0359)
        Garage = "AMBULANCE_GARAGE"
    },
    TRANSPORT = {
        Location = vector3(722.96, -1045.66, 21.78),
        Garage = "TRANSPORT_GARAGE"
    },
    PARKENFORCER = {
        Location = vector3(-1051.5637207031, -249.90036010742, 37.844520568848),
        Garage = "PARKENFORCER_GARAGE"
    }
}

Config.Vehicles = {
    POLICE = {
        {
            VehicleLabel = "buffalociv", VehicleName = "buffalociv", Price = 25000
        },
        {
            VehicleLabel = "radiobil", VehicleName = "radiobil", Price = 25000
        },
        {
            VehicleLabel = "umkomodarb", VehicleName = "umkomodarb", Price = 25000
        },
        {
            VehicleLabel = "riot", VehicleName = "riot", Price = 100000
        }
    },
    MECHANIC = {
        {
            VehicleLabel = "burrito3", VehicleName = "burrito3", Price = 10000
        }
    },
    AMBULANCE = {
        {
            VehicleLabel = "ambulance", VehicleName = "ambulance", Price = 15000
        },
    },
    TRANSPORT = {
        {
            VehicleLabel = "hauler", VehicleName = "hauler", Price = 18500
        },
        {
            VehicleLabel = "phantom", VehicleName = "phantom", Price = 18500
        }
    },
    PARKENFORCER = {
        {
            VehicleLabel = "caddy2", VehicleName = "caddy2", Price = 18500
        }
    }
}