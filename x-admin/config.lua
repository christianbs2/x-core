Config = {}

Config.EnableDebug = false

Config.Headquarters = {
    Job = "transport",

    Location = vector3(722.96, -1045.66, 21.78)
}

Config.Deliveries = {
    Vehicle = {
        Trailer = {
            Location = vector3(-457.46987915039, -2801.6484375, 6.0003871917725),
            Heading = 315.0,
            Model = GetHashKey("tr2"),
        },

        Truck = {
            Location = vector3(-448.44912719727, -2792.5727539063, 6.0003809928894),
            Heading = 315.0,
            Model = GetHashKey("hauler")
        }
    },

    Van = {
        Location = vector3(-448.44912719727, -2792.5727539063, 6.0003809928894),
        Heading = 315.0,
        Model = GetHashKey("boxville4")
    }
}

Config.PermissionNames = {
    "NORMAL",
    "FULL_ADMIN",
    "SUPPORT",
    "WHITELIST"
}