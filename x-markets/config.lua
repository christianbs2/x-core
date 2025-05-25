Config = {}

Config.EnableDebug = false

Config.PurchasePercentage = 0.04
Config.BustTime = {50000, 75000}
Config.MarketRobReward = {250, 850}
Config.RobPercentage = 0.2
Config.OfficersNeeded = Config.EnableDebug and 0 or 10

Config.MarketSettings = {
    ["LTD"] = {
        ["doors"] = {   
            ["left"] = 2065277225,
            ["right"] = -868672903
        },
        ["schedule"] = {
            ["closeHour"] = 22,
            ["openingHour"] = 6
        },
        ["managment"] = {
            ["entityHash"] = 1333557690,
            ["callback"] = function(marketName, entity)
                OpenManagmentMenu(marketName, entity)
            end
        },
        ["cashRegister"] = 303280717
    },
    
    ["247"] = {
        ["doors"] = {
            ["left"] = 997554217,
            ["right"] = 1196685123
        },
        ["managment"] = {
            ["entityHash"] = 810004487,
            ["callback"] = function(marketName, entity)
                OpenManagmentMenu(marketName, entity)
            end
        },
        ["cashRegister"] = 303280717
    },

    ["RobsLiquor"] = {
        ["doors"] = {
            ["left"] = -1212951353,
            ["right"] = -1212951353
        },
        ["schedule"] = {
            ["closeHour"] = 22,
            ["openingHour"] = 6
        },
        ["managment"] = {
            ["entityHash"] = 1333557690,
            ["callback"] = function(marketName, entity)
                OpenManagmentMenu(marketName, entity)
            end
        },
        ["cashRegister"] = 303280717
    },

}

Config.Seller = {
    ["pedData"] = {
        ["position"] = vector3(-1379.7354736328, -477.50378417969, 72.04207611084),
        ["heading"] = 97.45142364502,
        ["model"] = 0xF0D4BE2E,
    },
    ["buildingData"] = {
        ["entrance"] = vector3(-1370.6142578125, -503.40328979492, 33.157440185547),
        ["exit"] = vector3(-1394.2375488281, -479.60394287109, 72.042083740234)
    }
}

Config.ShelfItems = {
    [1437777724] = { -- Fucking shit
        {label = "Fiskespö", item = "fishing_rod", price = 125},
        {label = "fiskekort", item = "fiskekort", price = 300},
        {label = "Bete", item = "fishing_bait", price = 5},
        {label = "Telefon", item = "lbphone", price = 5000},
        {label = "Agua Resist Plåster", item = "bandaid", price = 1000},
        {label = "Tändare", item = "lighter", price = 30},
        --{label = "Fyrverkerilåda", item = "fireworks", price = 500},
        {label = "Bränsledunk", item = "petrolcan", price = 600},
    },
    [-1914723336] = { -- Fucking shit
        {label = "Kikare", item = "binoculars", price = 250},
        {label = "Fiskespö", item = "fishing_rod", price = 125},
        {label = "fiskekort", item = "fiskekort", price = 300},
        --{label = "Campingstol", item = "chair1", price = 750},
        {label = "Tvättsvamp", item = "sponge", price = 200},
        --{label = "Fyrverkerilåda", item = "fireworks", price = 500},
        {label = "Bete", item = "fishing_bait", price = 5},
        {label = "Teddybjörn", item = "teddy_bear", price = 150},
        {label = "Ros", item = "rose", price = 50},
        {label = "Bibeln", item = "bible", price = 250},
    },
    [1793329478] = { -- Fucking shit
        {label = "Kikare", item = "binoculars", price = 250},
        {label = "Fiskespö", item = "fishing_rod", price = 125},
        {label = "fiskekort", item = "fiskekort", price = 300},
        --{label = "Campingstol", item = "chair1", price = 750},
        {label = "Tvättsvamp", item = "sponge", price = 200},
       -- {label = "Fyrverkerilåda", item = "fireworks", price = 500},
        {label = "Bete", item = "fishing_bait", price = 5},
        {label = "Teddybjörn", item = "teddy_bear", price = 150},
        {label = "Ros", item = "rose", price = 50},
        {label = "Bibeln", item = "bible", price = 250},
    },
    [-1875208060] = { -- Fucking shit
        {label = "Kikare", item = "binoculars", price = 250},
        {label = "Fiskespö", item = "fishing_rod", price = 125},
        {label = "fiskekort", item = "fiskekort", price = 300},
        --{label = "Campingstol", item = "chair1", price = 750},
        {label = "Tvättsvamp", item = "sponge", price = 200},
        {label = "Bete", item = "fishing_bait", price = 5},
        {label = "Teddybjörn", item = "teddy_bear", price = 150},
        {label = "Ros", item = "rose", price = 50},
        {label = "Bibeln", item = "bible", price = 250},
       -- {label = "Fyrverkerilåda", item = "fireworks", price = 500},
        {label = "Telefon", item = "lbphone", price = 5000}
    },
    [-942878619] = { -- Fucking shit
        {label = "Kikare", item = "binoculars", price = 250},
        {label = "Fiskespö", item = "fishing_rod", price = 125},
        {label = "fiskekort", item = "fiskekort", price = 300},
        {label = "Tvättsvamp", item = "sponge", price = 200},
        --{label = "Campingstol", item = "chair1", price = 750},
        {label = "Anteckningsblock", item = "notepad", price = 150},
        {label = "Bete", item = "fishing_bait", price = 5},
        {label = "Teddybjörn", item = "teddy_bear", price = 150},
        {label = "Ros", item = "rose", price = 50},
        {label = "Bibeln", item = "bible", price = 250},
        {label = "Telefon", item = "lbphone", price = 5000},
        {label = "Agua Resist Plåster", item = "bandaid", price = 1000},
        {label = "Tändare", item = "lighter", price = 30},
       -- {label = "Fyrverkerilåda", item = "fireworks", price = 500},
        {label = "Bränsledunk", item = "petrolcan", price = 600},
    },
    [-532065181] = { -- Noodles
        {label = "Ostmacka", item = "bread", price = 45},
        {label = "Banan", item = "banana", price = 20}
    },
    [2067313593] = { -- Snacks
        {label = "Anteckningsblock", item = "notepad", price = 150},
        {label = "Zipbag", item = "zipbag", price = 50},
        {label = "Buntband", item = "ziptie", price = 50},
        {label = "Ficklampa", item = "flashlight", price = 500},
        {label = "Paraply", item = "umbrella", price = 250},
        -- {label = "Snickers", item = "snickers", price = 13},
        -- {label = "Twix", item = "twix", price = 14},
        -- {label = "Marabou mjölkchoklad", item = "marabou_milk", price = 11},
    },
    [643522702] = { -- Soda
        {label = "Vatten", item = "water", price = 25},
        {label = "Cola", item = "cocacola", price = 30},
        --{label = "Julmust", item = "julmust", price = 15},

    },
    [756199591] = { -- Snacks
        {label = "Slickers", item = "snickers", price = 15},
    },
    [663958207] = { -- Snacks
        {label = "Slickers", item = "snickers", price = 15},
    },
    [-54719154] = { -- Snacks
        
        {label = "Zipbag", item = "zipbag", price = 50},
        {label = "Paraply", item = "umbrella", price = 250},
        {label = "Buntband", item = "ziptie", price = 50},
        {label = "Ficklampa", item = "flashlight", price = 500}
    },
    [-220235377] = { -- Drickor
        
        {label = "Zipbag", item = "zipbag", price = 50},
        {label = "Buntband", item = "ziptie", price = 50},
        {label = "Anteckningsblock", item = "notepad", price = 150},
        {label = "Kikare", item = "binoculars", price = 250},
        {label = "Tvättsvamp", item = "sponge", price = 200},
       -- {label = "Fyrverkerilåda", item = "fireworks", price = 500},
        {label = "Telefon", item = "lbphone", price = 5000}
    },
    [-1406045366] = {
        {label = "Tändare", item = "lighter", price = 50},
        {label = "Trisslott", item = "scratch_off", price = 100},
        {label = "Kuvert", item = "envelope", price = 75},
        {label = "Tärning", item = "dice", price = 80},
        {label = "Sprejburk", item = "spray_can", price = 500},
        --{label = "Campingstol", item = "chair1", price = 750},
        {label = "Teddybjörn", item = "teddy_bear", price = 150},
        {label = "Ros", item = "rose", price = 50},
        {label = "Bibeln", item = "bible", price = 250},
        {label = "Cigarettpaket", item = "cigarettepack", price = 50},
        {label = "Rizla", item = "rizla", price = 300},
    },
    [-1240914379] = {
        {label = "Tändare", item = "lighter", price = 50},
        {label = "Trisslott", item = "scratch_off", price = 100},
        {label = "Kuvert", item = "envelope", price = 75},
        {label = "Tärning", item = "dice", price = 80},
        {label = "Sprejburk", item = "spray_can", price = 500},
        --{label = "Campingstol", item = "chair1", price = 750},
        {label = "Teddybjörn", item = "teddy_bear", price = 150},
        {label = "Ros", item = "rose", price = 50},
        {label = "Bibeln", item = "bible", price = 250},
        {label = "Cigarettpaket", item = "cigarettepack", price = 50},
        {label = "Rizla", item = "rizla", price = 300},
    },
    [-271115824] = {
        {label = "Tändare", item = "lighter", price = 50},
        {label = "Trisslott", item = "scratch_off", price = 100},
        {label = "Kuvert", item = "envelope", price = 75},
        {label = "Tärning", item = "dice", price = 80},
        {label = "Sprejburk", item = "spray_can", price = 500},
        --{label = "Campingstol", item = "chair1", price = 750},
        {label = "Teddybjörn", item = "teddy_bear", price = 150},
        {label = "Ros", item = "rose", price = 50},
        {label = "Bibeln", item = "bible", price = 250},
        {label = "Cigarettpaket", item = "cigarettepack", price = 50},
        {label = "Rizla", item = "rizla", price = 300},
    },
    [563739989] = {
        {label = "Tändare", item = "lighter", price = 50},
        {label = "Trisslott", item = "scratch_off", price = 100},
        {label = "Kuvert", item = "envelope", price = 75},
        {label = "Tärning", item = "dice", price = 80},
        {label = "Sprejburk", item = "spray_can", price = 500},
        --{label = "Campingstol", item = "chair1", price = 750},
        {label = "Teddybjörn", item = "teddy_bear", price = 150},
        {label = "Ros", item = "rose", price = 50},
        {label = "Bibeln", item = "bible", price = 250},
        {label = "Cigarettpaket", item = "cigarettepack", price = 50},
        {label = "Rizla", item = "rizla", price = 300},
    },
    [1263489215] = {
        {label = "Tändare", item = "lighter", price = 50},
        {label = "Trisslott", item = "scratch_off", price = 100},
        {label = "Kuvert", item = "envelope", price = 75},
        {label = "Tärning", item = "dice", price = 80},
        {label = "Sprejburk", item = "spray_can", price = 500},
        --{label = "Campingstol", item = "chair1", price = 750},
        {label = "Teddybjörn", item = "teddy_bear", price = 150},
        {label = "Ros", item = "rose", price = 50},
        {label = "Bibeln", item = "bible", price = 250},
        {label = "Cigarettpaket", item = "cigarettepack", price = 50},
        {label = "Rizla", item = "rizla", price = 300},
    },
    [-1479865927] = {
        {label = "Tändare", item = "lighter", price = 50},
        {label = "Trisslott", item = "scratch_off", price = 100},
        {label = "Kuvert", item = "envelope", price = 75},
        {label = "Tärning", item = "dice", price = 80},
        {label = "Sprejburk", item = "spray_can", price = 500},
        --{label = "Campingstol", item = "chair1", price = 750},
        {label = "Teddybjörn", item = "teddy_bear", price = 150},
        {label = "Ros", item = "rose", price = 50},
        {label = "Bibeln", item = "bible", price = 250},
        {label = "Cigarettpaket", item = "cigarettepack", price = 50},
        {label = "Rizla", item = "rizla", price = 300},
    },
    [990852227] = {
        {label = "Tändare", item = "lighter", price = 50},
        {label = "Trisslott", item = "scratch_off", price = 100},
        {label = "Kuvert", item = "envelope", price = 75},
        {label = "Tärning", item = "dice", price = 80},
        {label = "Sprejburk", item = "spray_can", price = 500},
        --{label = "Campingstol", item = "chair1", price = 750},
        {label = "Teddybjörn", item = "teddy_bear", price = 150},
        {label = "Ros", item = "rose", price = 50},
        {label = "Bibeln", item = "bible", price = 250},
        {label = "Cigarettpaket", item = "cigarettepack", price = 50},
        {label = "Rizla", item = "rizla", price = 300},
    },
}

Config.Markets = {
    ["247 Clinton"] = {
        ["marketPos"] = vector3(374.05386352539, 325.85147094727, 103.56637573242),
        ["marketPrice"] = 10,
        ["Account"] = vector3(372.2799987793, 326.44705200195, 103.56637573242),
        ["Stash"] = vector3(378.02529907227, 333.18618774414, 103.56637573242),
        ["cashier"] = {
            ["position"] = vector3(372.29217529297, 326.39370727539, 103.56636047363),
            ["heading"] = 246.00857543945,
            ["model"] = 416176080
        },
        ["marketCamera"] = {
            ["camPos"] = vector3(363.08270263672, 318.51977539063, 109.72122192383), 
            ["camRotation"] = vector3(-21.448818668723, 0.0, -67.811022549868)
        },
        ["callback"] = function(storeId, storeData)
            StartShopping(storeId, storeData)
        end
    },
    
    ["247 Strawberry"] = {
        ["marketPos"] = vector3(26.134149551392, -1347.6729736328, 29.497022628784),
        ["marketPrice"] = 0,
        ["Account"] = vector3(28.244354248047, -1339.2269287109, 29.49702262878),
        ["Stash"] = vector3(30.725185394287, -1339.0025634766, 29.497041702271),
        ["cashier"] = {
            ["position"] = vector3(24.215274810791, -1347.2624511719, 29.497016906738),
            ["heading"] = 248.67747497559,
            ["model"] = 416176080
        },
        ["marketCamera"] = {
            ["camPos"] = vector3(22.746061325073, -1353.9599609375, 32.508754730225), 
            ["camRotation"] = vector3(-8.1259842514992, 0.0, -54.299212008715)
        },
        ["callback"] = function(storeId, storeData)
            StartShopping(storeId, storeData)
        end
    },

    ["247 Palomino"] = {
        ["marketRestricted"] = true,
        ["marketPos"] = vector3(2557.4396972656, 382.37594604492, 108.62294006348),
        ["marketPrice"] = 10,
        ["Account"] =  vector3(2554.8637695313, 380.73486328125, 108.62294006348),
        ["Stash"] = vector3(2549.5876464844, 384.8434753418, 108.62302398682),
        ["cashier"] = {
            ["position"] = vector3(2557.1748046875, 380.64489746094, 108.62294006348),
            ["heading"] = 340.8776550293,
            ["model"] = 416176080
        },
        ["marketCamera"] = {
            ["camPos"] = vector3(2567.0515136719, 400.82662963867, 114.6311416626), 
            ["camRotation"] = vector3(-18.771653473377, 0.0, -191.71653702855)
        },
        ["callback"] = function(storeId, storeData)
            StartShopping(storeId, storeData)
        end
    },

    ["247 Ineseno"] = {
        ["marketPos"] = vector3(-3039.0048828125, 586.11285400391, 7.9089303016663),
        ["marketPrice"] = 10,
        ["Account"] = vector3(-3041.2377929688, 583.71124267578, 7.908935546875),
        ["Stash"] = vector3(-3047.0974121094, 585.77386474609, 7.9089283943176),
        ["cashier"] = {
            ["position"] = vector3(-3038.2673339844, 584.47491455078, 7.908935546875),
            ["heading"] = 23.610481262207,
            ["model"] = 416176080
        },
        ["marketCamera"] = {
            ["camPos"] = vector3(-3037.0065917969, 597.82012939453, 11.633289337158), 
            ["camRotation"] = vector3(-16.283463776112, 0.0, -183.14960667491)
        },
        ["callback"] = function(storeId, storeData)
            StartShopping(storeId, storeData)
        end
    },

    ["247 Barbareno"] = {
        ["marketPos"] = vector3(-3241.8850097656, 1001.4508666992, 12.830711364746),
        ["marketPrice"] = 10,
        ["Account"] = vector3(-3244.5473632813, 1000.0726928711, 12.830704689026),
        ["Stash"] = vector3(-3249.6071777344, 1004.3414916992, 12.83071231842),
        ["cashier"] = {
            ["position"] = vector3(-3242.2670898438, 999.76306152344, 12.830704689026),
            ["heading"] = 345.36389160156,
            ["model"] = 416176080
        },
        ["marketCamera"] = {
            ["camPos"] = vector3(-3235.4401855469, 1012.3790893555, 16.149250030518), 
            ["camRotation"] = vector3(-15.244094416499, 0.0, -204.85039398074)
        },
        ["callback"] = function(storeId, storeData)
            StartShopping(storeId, storeData)
        end
    },

    ["247 Route 68"] = {
        ["marketPos"] = vector3(547.24462890625, 2671.1149902344, 42.156513214111),
        ["marketPrice"] = 10,
        ["Account"] = vector3(549.52746582031, 2668.8432617188, 42.156490325928),
        ["Stash"] = vector3(546.29022216797, 2663.484375, 42.156513214111),
        ["cashier"] = {
            ["position"] = vector3(549.44256591797, 2671.2185058594, 42.156513214111),
            ["heading"] = 75.037734985352,
            ["model"] = 416176080
        },
        ["marketCamera"] = {
            ["camPos"] = vector3(552.6259765625, 2680.7622070313, 45.856605529785), 
            ["camRotation"] = vector3(-15.653543159366, 0.0, 132.22047203779)
        },
        ["callback"] = function(storeId, storeData)
            StartShopping(storeId, storeData)
        end
    },

    ["247 Alhambra"] = {
        ["marketPos"] = vector3(1961.5560302734, 3740.8024902344, 32.34375),
        ["marketPrice"] = 10,
        ["Account"] = vector3(1958.7155761719, 3741.9855957031, 32.343738555908),
        ["Stash"] = vector3(1959.5352783203, 3748.2397460938, 32.343742370605),
        ["cashier"] = {
            ["position"] = vector3(1959.9187011719, 3740.0014648438, 32.343738555908),
            ["heading"] = 293.646484375,
            ["model"] = 416176080
        },
        ["marketCamera"] = {
            ["camPos"] = vector3(1959.3897705078, 3730.2954101563, 36.428009033203), 
            ["camRotation"] = vector3(-16.913385659456, 0.0, -30.14173220098)
        },
        ["callback"] = function(storeId, storeData)
            StartShopping(storeId, storeData)
        end
    },

    ["247 Senora"] = {
        ["marketPos"] = vector3(1729.4488525391, 6414.3920898438, 35.037242889404),
        ["marketPrice"] = 10,
        ["Account"] = vector3(1728.7150878906, 6417.4887695313, 35.037250518799),
        ["Stash"] = vector3(1734.5455322266, 6420.4477539063, 35.037265777588),
        ["cashier"] = {
            ["position"] = vector3(1727.7840576172, 6415.3408203125, 35.037250518799),
            ["heading"] = 226.98921203613,
            ["model"] = 416176080
        },
        ["marketCamera"] = {
            ["camPos"] = vector3(1738.3282470703, 6400.9233398438, 39.277648925781), 
            ["camRotation"] = vector3(-14.551181003451, 0.0, 33.921259611845)
        },
        ["callback"] = function(storeId, storeData)
            StartShopping(storeId, storeData)
        end
    },

    ["247 Route 13"] = {
        ["marketPos"] = vector3(2679.1481933594, 3280.5629882813, 55.24112701416),
        ["marketPrice"] = 10,
        ["Account"] = vector3(2675.8498535156, 3280.4284667969, 55.241123199463),
        ["Stash"] = vector3(2674.1748046875, 3288.4660644531, 55.24227142334),
        ["cashier"] = {
            ["position"] = vector3(2677.9306640625, 3279.3017578125, 55.241123199463),
            ["heading"] = 317.35440063477,
            ["model"] = 416176080
        },
        ["marketCamera"] = {
            ["camPos"] = vector3(2695.1047363281, 3287.3430175781, 60.30753326416), 
            ["camRotation"] = vector3(-14.204724177718, 0.0, -234.61417250335)
        },
        ["callback"] = function(storeId, storeData)
            StartShopping(storeId, storeData)
        end
    },

    ["247 Gallerian"] = {
        ["marketPos"] = vector3(-552.3918, -585.296, 34.68179),
        ["marketPrice"] = 10,
        ["Account"] = vector3(2675.8498535156, 3280.4284667969, 55.241123199463),
        ["Stash"] = vector3(2674.1748046875, 3288.4660644531, 55.24227142334),
        ["cashier"] = {
            ["position"] = vector3(-547.7436, -583.0448, 34.68178),
            ["heading"] = 181.6319,
            ["model"] = 416176080
        },
        ["marketCamera"] = {
            ["camPos"] = vector3(2695.1047363281, 3287.3430175781, 60.30753326416), 
            ["camRotation"] = vector3(-14.204724177718, 0.0, -234.61417250335)
        },
        ["callback"] = function(storeId, storeData)
            StartShopping(storeId, storeData)
        end
    },


    

    ----------------------RobsLiquor

    ["RobsLiquor Great Ocean"] = {
        ["marketPos"] = vector3(-2968.3854980469, 390.94171142578, 15.043313026428),
        ["marketPrice"] = 10,
        ["Account"] = vector3(-2965.8957519531, 390.85223388672, 15.043308258057),
        ["Stash"] = vector3(-2959.5737304688, 387.77221679688, 14.043127059937),
        ["cashier"] = {
            ["position"] = vector3(-2966.3012695313, 391.58193969727, 15.043300628662),
            ["heading"] = 86.15234375,
            ["model"] = 416176080
        },
        ["marketCamera"] = {
            ["camPos"] = vector3(-2980.6491699219, 383.86352539063, 19.678293228149), 
            ["camRotation"] = vector3(-14.992125526071, 0.0, -43.622047126293)
        },
        ["callback"] = function(storeId, storeData)
            StartShopping(storeId, storeData)
        end
    },

    ["RobsLiquor Prosperity"] = {
        ["marketPos"] = vector3(-1487.6353759766, -379.21444702148, 40.163391113281),
        ["marketPrice"] = 10,
        ["Account"] = vector3(-1485.8237304688, -377.79556274414, 40.163410186768),
        ["Stash"] = vector3(-1479.2570800781, -374.98236083984, 39.163265228271),
        ["cashier"] = {
            ["position"] = vector3(-1487.2850341797, -376.92288208008, 40.163436889648),
            ["heading"] = 153.55458068848,
            ["model"] = 416176080
        },
        ["marketCamera"] = {
            ["camPos"] = vector3(-1489.4686279297, -391.59518432617, 43.426902770996), 
            ["camRotation"] = vector3(-6.8346457034349, 0.0, 16.440944820642) 
        },
        ["callback"] = function(storeId, storeData)
            StartShopping(storeId, storeData)
        end
    },

    ["RobsLiquor San Andreas"] = {
        ["marketPos"] = vector3(-1223.0776367188, -906.86096191406, 12.326356887817),
        ["marketPrice"] = 10,
        ["Account"] = vector3(-1221.7371826172, -908.63525390625, 12.326356887817),
        ["Stash"] = vector3(-1220.2508544922, -915.49151611328, 11.326153755188),
        ["cashier"] = {
            ["position"] = vector3(-1221.3229980469, -908.12780761719, 12.326356887817),
            ["heading"] = 37.299858093262,
            ["model"] = 416176080
        },
        ["marketCamera"] = {
            ["camPos"] = vector3(-1240.4791259766, -903.94854736328, 17.191709518433), 
            ["camRotation"] = vector3(-4.3779526501894, 0.0, -82.992125928402)
        },
        ["callback"] = function(storeId, storeData)
            StartShopping(storeId, storeData)
        end
    },

    ["RobsLiquor El Rancho"] = {
        ["marketPos"] = vector3(1135.9046630859, -982.16296386719, 46.415824890137),
        ["marketPrice"] = 10,
        ["Account"] = vector3(1133.7742919922, -982.53356933594, 46.415836334229),
        ["Stash"] = vector3(1130.7456054688, -982.84240722656, 46.415836334229),
        ["cashier"] = {
            ["position"] = vector3(1134.0545654297, -983.3251953125, 46.415802001953),
            ["heading"] = 282.5920715332,
            ["model"] = 416176080
        },
        ["marketCamera"] = {
            ["camPos"] = vector3(1147.5047607422, -986.27392578125, 48.656597137451), 
            ["camRotation"] = vector3(-14.362204551697, 0.0, 38.204724088311)
        },
        ["callback"] = function(storeId, storeData)
            StartShopping(storeId, storeData)
        end
    },

    ["RobsLiquor Route 68"] = {
        ["marketPos"] = vector3(1165.9293212891, 2708.8120117188, 38.157688140869),
        ["marketPrice"] = 10,
        ["Account"] = vector3(1165.9105224609, 2711.3620605469, 38.157703399658),
        ["Stash"] = vector3(1168.8082275391, 2717.8669433594, 37.157558441162),
        ["cashier"] = {
            ["position"] = vector3(1165.2305908203, 2710.9692382813, 38.157665252686),
            ["heading"] = 188.72573852539,
            ["model"] = 416176080
        },
        ["marketCamera"] = {
            ["camPos"] = vector3(1174.3161621094, 2694.2377929688, 40.132030487061), 
            ["camRotation"] = vector3(-5.4488189667463, 0.0, 46.204723522067)
        },
        ["callback"] = function(storeId, storeData)
            StartShopping(storeId, storeData)
        end
    },


    -------------------LTDS


    ["LTD Vespucci"] = {
        ["marketPos"] = vector3(-707.43231201172, -914.62829589844, 19.215587615967),
        ["marketPrice"] = 10,
        ["Account"] = vector3(-709.68310546875, -904.29260253906, 19.215591430664),
        ["Stash"] = vector3(-709.82189941406, -907.26995849609, 19.215591430664),
        ["cashier"] = {
            ["position"] = vector3(-705.91625976563, -913.41326904297, 19.215585708618),
            ["heading"] = 89.320465087891,
            ["model"] = 416176080
        },
        ["marketCamera"] = {
            ["camPos"] = vector3(-702.52313232422, -924.419921875, 23.156839370728), 
            ["camRotation"] = vector3(-16.03149600327, 0.0, 74.488189280033)
        },
        ["callback"] = function(storeId, storeData)
            StartShopping(storeId, storeData)
        end
    },

    ["LTD Davis"] = {
        ["marketPos"] = vector3(-48.62088394165, -1757.5234375, 29.421007156372),
        ["marketPrice"] = 10,
        ["Account"] = vector3(-46.33837890625, -1758.4305419922, 29.421016693115),
        ["Stash"] = vector3(-40.559505462646, -1751.7536621094, 29.421016693115),
        ["cashier"] = {
            ["position"] = vector3(-46.958980560303, -1758.9643554688, 29.420999526978),
            ["heading"] = 48.277374267578,
            ["model"] = 416176080
        },
        ["marketCamera"] = {
            ["camPos"] = vector3(-49.745944976807, -1766.6589355469, 32.479110717773), 
            ["camRotation"] = vector3(-14.740157321095, 0.0, 32.755905374885)
        },
        ["callback"] = function(storeId, storeData)
            StartShopping(storeId, storeData)
        end
    },

    ["LTD Mirror Park"] = {
        ["marketPos"] = vector3(1163.2659912109, -323.79348754883, 69.205131530762),
        ["marketPrice"] = 0,
        ["Account"] = vector3(1164.9334716797, -322.50381469727, 69.205047607422),
        ["Stash"] = vector3(1164.1267089844, -313.83737182617, 69.205101013184),
        ["cashier"] = {
            ["position"] = vector3(1165.1630859375, -323.87414550781, 69.205047607422),
            ["heading"] = 101.4720993042,
            ["model"] = 416176080
        },
        ["marketCamera"] = {
            ["camPos"] = vector3(1151.8258056641, -331.20745849609, 72.396987915039), 
            ["camRotation"] = vector3(-13.00787396729, 0.0, -68.755905851722)
        },
        ["callback"] = function(storeId, storeData)
            StartShopping(storeId, storeData)
        end
    },

    ["LTD Banham Canyon"] = {
        ["marketPos"] = vector3(-1820.7017822266, 792.45837402344, 138.11625671387),
        ["marketPrice"] = 10,
        ["Account"] = vector3(-1819.9514160156, 794.44708251953, 138.08351135254),
        ["Stash"] = vector3(-1828.9105224609, 799.09197998047, 138.18316650391),
        ["cashier"] = {
            ["position"] = vector3(-1819.5125732422, 793.64141845703, 138.08486938477),
            ["heading"] = 132.9716796875,
            ["model"] = 416176080
        },
        ["marketCamera"] = {
            ["camPos"] = vector3(-1825.8010253906, 779.90808105469, 140.82894897461), 
            ["camRotation"] = vector3(-10.141732290387, 0.0, -35.401574626565)
        },
        ["callback"] = function(storeId, storeData)
            StartShopping(storeId, storeData)
        end
    },

    ["LTD Grapeseed"] = {
        ["marketPos"] = vector3(1698.2028808594, 4924.51171875, 42.063674926758),
        ["marketPrice"] = 10,
        ["Account"] = vector3(1698.0074462891, 4922.9169921875, 42.063632965088),
        ["Stash"] = vector3(1705.0642089844, 4917.5791015625, 42.063674926758),
        ["cashier"] = {
            ["position"] = vector3(1697.1395263672, 4923.4130859375, 42.063632965088),
            ["heading"] = 325.30218505859,
            ["model"] = 416176080
        },
        ["marketCamera"] = {
            ["camPos"] = vector3(1701.0096435547, 4943.4741210938, 46.328422546387), 
            ["camRotation"] = vector3(-18.677165001631, 0.0, 172.56692881882)
        },
        ["callback"] = function(storeId, storeData)
            StartShopping(storeId, storeData)
        end
    }
}

Config.UUID = function()
	local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
	
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
        return string.format('%x', v)
    end)
end

Config.WhatStore = function(str)
    if string.match(str, "247") then
        return "247"
    elseif string.match(str, "LTD") then
        return "LTD"
    elseif string.match(str, "RobsLiquor") then
        return "RobsLiquor"
    end
end

Config.CashAmount = { 1000, 2500 }
Config.TotalLocks = 8

Config.RobberyItems = {
    {
        Name = "antique_coin",
        Luck = 37
    },
    {
        Name = "flashdrive",
        Luck = 37
    },
    {
        Name = "rolex_watch",
        Luck = 20
    },
    {
        Name = "diamond_ring",
        Luck = 20
    },
    {
        Name = "gold_ring",
        Luck = 20
    },
    {
        Name = "gold_necklace",
        Luck = 20
    },
	{
        Name = "lockpick",
        Luck = 13,
        Meta = {
            Durability = 100
        }
    },
	{
        Name = "security_card_01",
        Luck = 5
    },
    {
        Name = "antique_vase",
        Luck = 3
    },
    {
        Name = "pegasus_trophy",
        Luck = 2
    }
}