Items = {
    key = {
        Label = "Nyckel",
        Weight = 0.1,
        Stackable = false,
        Model = GetHashKey("p_car_keys_01"),
        Description = "En nyckel."
    },
    ipad = {
        Label = "Padda Mini",
        Weight = 0.7,
        Model = GetHashKey("prop_cs_tablet"),
        Description = {
            {
                Title = "Tillhör:",
                Text = "Polismyndigheten"
            },
            {
                Title = "",
                Text = "Padda Mini (marknadsförs som Padda mini) är en serie mini-surfplattor designade, utvecklade och marknadsförda av Koi Inc. Det är en under-serie av padda-serien av surfplattor, med en reducerad skärmstorlek på 7,9 tum, däremot till standard 9,7 tum."
            }
        },
        UseButton = "STARTA",
        UseCallback = function(character, itemData)
            character.triggerEvent("x-licenses:openTablet", itemData)
        end
    },
    ipad_ambulance = {
        Label = "Padda Mini",
        Weight = 0.7,
        Model = GetHashKey("prop_cs_tablet"),
        Description = {
            {
                Title = "Tillhör:",
                Text = "Sjukvården"
            },
            {
                Title = "",
                Text = "Padda Mini (marknadsförs som Padda mini) är en serie mini-surfplattor designade, utvecklade och marknadsförda av Koi Inc. Det är en under-serie av padda-serien av surfplattor, med en reducerad skärmstorlek på 7,9 tum, däremot till standard 9,7 tum."
            }
        },
        UseButton = "STARTA",
        UseCallback = function(character, itemData)
            character.triggerEvent("x-ambulance:useIpad", itemData)
        end
    },
    chair1 = {
        Label = "Campingstol",
        Weight = 0.7,
        Model = GetHashKey("prop_skid_chair_01"),
        Description = {
            {
                Title = "",
                Text = "En grön campingstol ifrån ikea"
            }
        },
        UseButton = "ANVÄND",
        UseCallback = function(character, itemData)
            character.triggerEvent('khaoz-chairs:Chair1', source)
        end
    },
    id_card = {
        Label = "ID-Handling",
        Weight = 0.05,
        Stackable = false,
        Model = GetHashKey("p_ld_id_card_002"),
        Description = "Ett ID-kort utfärdat av Skatteverket."
    },
    driving_license = {
        Label = "Körkort",
        Weight = 0.05,
        Stackable = false,
        Model = GetHashKey("p_ld_id_card_002"),
        Description = "Ett Körkort utfärdat av Trafikverket."
    },
    lbphone = {
        Label = "Telefon",
        Weight = 0.148,
        Stackable = false,
        Description = {
            {
                Title = "Modell:",
                Text = "Telefon"
            },
            {
                Title = "Skärmstorlek:",
                Text = "6,1 tum"
            }
        },
        UseButton = "Stäng av",
        DefaultMetaData = {
            Disabled = false
        },
        Model = GetHashKey("lb_phone_prop")
    },
    lbphoneavstangd = {
        Label = "Avstängd Telefon",
        Weight = 0.148,
        Stackable = false,
        Description = {
            {
                Title = "Modell:",
                Text = "Telefon"
            },
            {
                Title = "Skärmstorlek:",
                Text = "6,1 tum"
            }
        },
        UseButton = "Starta",
        DefaultMetaData = {
            Disabled = false
        },
        Model = GetHashKey("lb_phone_prop")
    },
    nitrous_oxide = {
        Label = "Lustgas",
        Weight = 2.0,
        Description = {
            {
                Title = "",
                Text = "Systemet ökar motorns effekt genom att låta bränsle förbrännas med en högre hastighet än normalt, på grund av det högre partialtrycket av syre som injiceras med bränsleblandningen."
            }
        },
        UseButton = "MONTERA",
        UseCallback = function(character, itemData, inventoryName)
            character.triggerEvent("x-tuner:applyNitrous", itemData, inventoryName)
        end,
        Model = GetHashKey("prop_nitrocan")
    },
    envelope = {
        Label = "Kuvert",
        Weight = 0.1,
        Description = {
            {
                Title = "",
                Text = "Ett kuvert som det går att lägga kontanter inuti."
            }
        },
        UseButton = "LÄGG IN KONTANTER",
        UseCallback = function(character, itemData, inventoryName)
            if itemData.MetaData and itemData.MetaData.Cash then
                local cashInEnvelope = itemData.MetaData.Cash
                itemData.MetaData.Cash = nil
                itemData.MetaData.UseButton = "LäGG IN KONTANTER"
                local edited = EditInventoryItem(character, {
                    Item = itemData,
                    Inventory = inventoryName
                })
                if edited then
                    character.cash.add(cashInEnvelope)
                    character.triggerEvent("x-core:notify", "Kuvert", "Du tog ut " .. cashInEnvelope .. " kr i kontanter.", 7500, "success")
                end
            else
                character.triggerEvent("x-inventory:putInCash", itemData, inventoryName)
            end
        end,
        Model = GetHashKey("prop_cs_cashenvelope")
    },
    image = {
        Label = "Bild",
        Weight = 0.1,
        Description = {
            {
                Title = "",
                Text = "En utskriven bild."
            }
        },
        UseButton = "Kolla",
        UseCallback = function(character, itemData, inventoryName)
            character.triggerEvent("x-image:watchImage", itemData, inventoryName)
        end,
        Model = GetHashKey("prop_cs_cashenvelope")
    },
    image_printer = {
        Label = "Skrivare",
        Weight = 1.0,
        Description = {
            {
                Title = "",
                Text = "En skrivare för att skriva ut diverse bilder."
            }
        },
        UseButton = "Använd",
        UseCallback = function(character, itemData, inventoryName)
            character.triggerEvent("x-image:writeImage", itemData, inventoryName)
        end,
        Model = GetHashKey("v_res_printer")
    },
    ecstasy = {
        Label = "Ecstasy",
        Weight = 0.01,
        Stackable = true,
        Description = "Drogen är ett centralstimulerande amfetaminpreparat, och räknas som empatogen vilket innebär att det påverkar sinnestillståndet snarare än varseblivningen.",
        UseButton = "SVäLJ",
        UseCallback = function(character, itemData, inventoryName)
            local removed = RemoveInventoryItem(character, {
                Item = {
                    Name = itemData.Name,
                    Count = 1
                },
                Inventory = inventoryName
            })
            if not removed then return end
            character.triggerEvent("x-sells:eventHandler", "MDMA_USED", itemData)
            character.triggerEvent("x-addiction:addItemAddiction", "mdma", 5.0)
        end,
        Model = GetHashKey("ex_office_swag_pills1")
    },
    glass_bottle = {
        Label = "Glasflaska",
        Weight = 0.3,
        Description = "Tom glasflaska.",
        Stackable = true,
        Model = GetHashKey("ng_proc_beerbottle_01a")
    },
    cloth = {
        Label = "Tygbit",
        Weight = 0.01,
        Description = "En tygbit.",
        Stackable = true,
        Model = GetHashKey("prop_cs_clothes_box")
    },
    alcohol = {
        Label = "Alkohol",
        Weight = 0.3,
        Description = "En plastflaska med alkohol.",
        Stackable = true,
        Model = GetHashKey("bkr_prop_coke_bottle_02a")
    },
    joint = {
        Label = "Joint",
        Weight = 0.1,
        Stackable = true,
        Description = "Du kan bli fett hög av denna.",
        Model = GetHashKey("prop_sh_joint_01"),
        UseButton = "Rök",
        UseCallback = function(character, itemData, inventoryName)
            character.triggerEvent("x-useables:useItem", "Joint", itemData, inventoryName)
        end
    },
    dildo = {
        Label = "Dildo",
        Weight = 0.4,
        Description = "En dildo utrustad med praktisk sugpropp.",
        Model = GetHashKey("prop_cs_dildo_01"),
        PropAnimation = "jerkf",
    },
    handcuffs = {
        Label = "Handklovar",
        Weight = 0.6,
        Stackable = false,
        Model = GetHashKey("prop_cs_cuffs_01"),
        Description = "RPS/NIJ godkända handklovar."
    },
    handcuff_key = {
        Label = "Nyckel",
        Weight = 0.2,
        Stackable = false,
        Description = "Universalnyckel till polisens handklovar.",
        Model = GetHashKey("bkr_prop_jailer_keys_01a")
    },
    vehicle_tyre = {
        Label = "Bilhjul",
        Weight = 1.0,
        Description = "Detta är ett hjul till ett fordon.",
        Model = GetHashKey("imp_prop_impexp_tyre_01a")
    },
    vehicle_door = {
        Label = "Bildörr",
        Weight = 1.0,
        Description = "Detta är en dörr till ett fordon.",
        Model = GetHashKey("imp_prop_impexp_car_door_01a")
    },
    vehicle_repairkit = {
        Label = "Motorkit",
        Weight = 1.7,
        Description = "Reparerar motorn på ett fordon.",
        Model = GetHashKey("ch_prop_toolbox_01a")
    },
    vehicle_window = {
        Label = "Fönsteruta",
        Weight = 1.0,
        Description = "Detta är en fönsteruta till ett fordon.",
        Model = GetHashKey("ch_prop_toolbox_01a")
    },
    notepad = {
        Label = "Anteckningsblock",
        Weight = 0.150,
        Description = "Ett anteckningsblock med 30 sidor kvar.",
        DefaultMetaData = {
            PagesLeft = 30
        },
        UseButton = "BLäDDRA",
        UseCallback = function(character, itemData)
            character.triggerEvent("x-notes:eventHandler", "use_notebook", itemData)
        end,
        Model = GetHashKey("p_notepad_01_s")
    },
    ripped_paper = {
        Label = "Utriven Sida",
        Weight = 0.005,
        Description = "Detta är en utriven sida från ett anteckningsblock.",
        UseButton = "LäS",
        UseCallback = function(character, itemData)
            character.triggerEvent("x-notes:eventHandler", "use_paper", itemData)
        end,
        Model = GetHashKey("p_notepad_01_s")
    },
    comradio = {
        Label = "Zodiac Proline Plus 400",
        Weight = 0.285,
        Description = "Zodiac Proline Plus 400 är en komradio för proffs i robust och tålig design. Med det lilla formatet, den lätta vikten och det enkla handhavandet blir Proline en av de starkaste aktörerna på marknaden.",
        UseButton = "ANVÄND",
        UseCallback = function(character, itemData)
            character.triggerEvent("x-comradio:useComradio", itemData)
        end,
        Model = GetHashKey("prop_cs_walkie_talkie")
    },
    nokia = {
        Label = "Nokia 3310",
        Weight = 0.200,
        Description = {
            {
                Title = "",
                Text = "Bland de funktioner som medföljer telefonen kan nämnas SMS, klocka, spelet snake och alarm. Med hjälp av telefonens sifferpanel är det möjligt för användaren att generera egna ringsignaler."
            }
        },
        UseButton = "AKTIVERA",
        UseCallback = function(character, itemData)
            exports["x-carthief"]:UseBurnerPhone(character.source, itemData)
        end,
        Model = GetHashKey("prop_nokia")
    },
    quest_vpx = {
        Label = "VPX Flash Storage Module",
        Weight = 0.50,
        Description = "VPX Flash Storage Module (FSM) ger högpresterande solid state-lagring med AES-256-bitars kryptering med en applikationsspecifik integrerad krets (ASIC) med hög kapacitet.",
        Model = GetHashKey("prop_cs_server_drive")
    },
    fishing_rod = {
        Label = "Grim Reaper Pitch Black Haspel",
        Weight = 0.260,
        Description = "Detta haspelspö är snabbt, rappt och galet skönt. Faktum är att vi inte testat något spö som kastar så långt som dessa och ni känner minsta lilla hugg via den fantastiska klingan.",
        UseButton = "KASTA",
        UseCallback = function(character, itemData)
            character.triggerEvent("x-fishing:fishingRodUsed", itemData)
        end,
        Model = GetHashKey("prop_fishing_rod_01")
    },
    fishing_bait = {
        Label = "Bete",
        Weight = 0.005,
        Description = "Gunki Hedorah är en avlång popper som har en \"walk the dog\" rörelse i vattnet, det vill saäga att poppern hoppar från sida till sida. Vill du så går Hedorah även att poppa hem, gör då bara lite hårdare ryck nedåt med spötoppen. Ett fantastiskt roligt bete med brutala hugg.",
        Stackable = false
    },
    fish = {
        Label = "Fisk",
        Weight = 1,
        Description = "Den luktar illa.",
        DefaultMetaData = {
            Weight = 0.2
        }
    },
    boombox = {
        Label = "JGL Zoombox 2",
        Weight = 1,
        Description = "Spelar musik.",
        DefaultMetaData = {
            Weight = 1.0
        }
    },
    panties = {
        Label = "Trosor",
        Weight = 0.1,
        Description = "illaluktande använda trosor.",
        Model = GetHashKey("prop_cs_panties")
    },
    lockpick = {
        Label = "Dyrkset",
        Weight = 0.200,
        Model = GetHashKey("prop_lockpickset_01"),
        Description = "Prisvärt dyrkset i 14 delar och medföljande vinylhandtag. Vinylhandtagen gör att du får ett mycket bra grepp om dyrken medan du dyrkar.",
        UseButton = "DYRKA",
        UseCallback = function(character, itemData)
            exports["x-houserobbery"]:UseLockpick(character.source, itemData)
        end,
        DefaultMetaData = {
            Durability = 100
        }
    },
    pick_gun = {
        Label = "Låspistol",
        Weight = 0.200,
        Model = GetHashKey("p_pliers_01_s"),
        Description = "Prisvärd låspistol.",
        UseButton = "ANVÄND",
        UseCallback = function(character, itemData)
            character.triggerEvent("x-vehicles:usePickgun", itemData)
        end,
        DefaultMetaData = {
            Durability = 100
        }
    },
    bad_lockpick = {
        Label = "Hemmagjort Dyrkset",
        Weight = 0.200,
        Model = GetHashKey("p_pliers_01_s"),
        Description = "Egen gjort dyrkset.",
        UseButton = "DYRKA",
        UseCallback = function(character, itemData)
            exports["x-houserobbery"]:UseLockpick(character.source, itemData)
        end,
        DefaultMetaData = {
            Durability = 100
        }
    },
    ziptie = {
        Label = "Buntband",
        Weight = 0.01,
        Description = "Du kan knyta fast händer med dessa.",
        Model = GetHashKey("prop_ld_cable_tie_01")
    },
    water = {
        Label = "Vatten 50cl",
        Weight = 0.200,
        Description = "Mycket gott vatten.",
        UseButton = "Drick",
        UseCallback = function(character, itemData, inventoryName)
            character.triggerEvent("x-foodsystem:useUsable", itemData, "thirst", 30, inventoryName)
        end,
        Model = GetHashKey("prop_ld_flow_bottle")
    },
    julmust = {
        Label = "Julmust",
        Weight = 0.200,
        Description = "Bryggd julmust.",
        Model = GetHashKey("prop_julmust"),
        UseButton = "Drick",
        UseCallback = function(character, itemData, inventoryName)
            character.triggerEvent("x-foodsystem:useUsable", itemData, "thirst", 25, inventoryName)
        end,
    },
    bread = {
        Label = "Macka",
        Weight = 0.200,
        Description = "En macka tillagad med kärlek.",
        UseButton = "ät",
        UseCallback = function(character, itemData, inventoryName)
            character.triggerEvent("x-foodsystem:useUsable", itemData, "hunger", 30, inventoryName)
        end,
        Model = GetHashKey("prop_sandwich_01")
    },
    cake1 = {
        Label = "jordgubbstårta",
        Weight = 0.200,
        Description = "en jordgubbskaka blandat med kärlek",
        UseButton = "ät",
        UseCallback = function(character, itemData, inventoryName)
            character.triggerEvent("x-foodsystem:useUsable", itemData, "hunger", 30, inventoryName)
        end,
        Model = GetHashKey("prop_sandwich_01")
    },
    cake2 = {
        Label = "wienerbröd",
        Weight = 0.200,
        Description = "En bakelse med mormors sista hosta i sig.",
        UseButton = "ät",
        UseCallback = function(character, itemData, inventoryName)
            character.triggerEvent("x-foodsystem:useUsable", itemData, "hunger", 30, inventoryName)
        end,
        Model = GetHashKey("prop_sandwich_01")
    },
    cake3 = {
        Label = "smörgåstårta",
        Weight = 0.200,
        Description = "En bakelse med räkor.",
        UseButton = "ät",
        UseCallback = function(character, itemData, inventoryName)
            character.triggerEvent("x-foodsystem:useUsable", itemData, "hunger", 30, inventoryName)
        end,
        Model = GetHashKey("prop_sandwich_01")
    },
    cake4 = {
        Label = "prinsess tårta",
        Weight = 0.200,
        Description = "En bakelse med marsipan.",
        UseButton = "ät",
        UseCallback = function(character, itemData, inventoryName)
            character.triggerEvent("x-foodsystem:useUsable", itemData, "hunger", 30, inventoryName)
        end,
        Model = GetHashKey("prop_sandwich_01")
    },
    cake5 = {
        Label = "budapestbakelse",
        Weight = 0.200,
        Description = "En kladdigt tårtbit",
        UseButton = "ät",
        UseCallback = function(character, itemData, inventoryName)
            character.triggerEvent("x-foodsystem:useUsable", itemData, "hunger", 30, inventoryName)
        end,
        Model = GetHashKey("prop_sandwich_01")
    },
    cake6 = {
        Label = "Kanelbulle",
        Weight = 0.200,
        Description = "en runkbulle",
        UseButton = "ät",
        UseCallback = function(character, itemData, inventoryName)
            character.triggerEvent("x-foodsystem:useUsable", itemData, "hunger", 30, inventoryName)
        end,
        Model = GetHashKey("prop_sandwich_01")
    },
    cake7 = {
        Label = "chokladboll",
        Weight = 0.200,
        Description = "en riktigt chokladkula",
        UseButton = "ät",
        UseCallback = function(character, itemData, inventoryName)
            character.triggerEvent("x-foodsystem:useUsable", itemData, "hunger", 30, inventoryName)
        end,
        Model = GetHashKey("prop_sandwich_01")
    },
    cake8 = {
        Label = "kärleksmums",
        Weight = 0.200,
        Description = "en bakelse fylld utav kärlek",
        UseButton = "ät",
        UseCallback = function(character, itemData, inventoryName)
            character.triggerEvent("x-foodsystem:useUsable", itemData, "hunger", 30, inventoryName)
        end,
        Model = GetHashKey("prop_sandwich_01")
    },
    cake9 = {
        Label = "kakor",
        Weight = 0.200,
        Description = "knappriga kakor",
        UseButton = "ät",
        UseCallback = function(character, itemData, inventoryName)
            character.triggerEvent("x-foodsystem:useUsable", itemData, "hunger", 30, inventoryName)
        end,
        Model = GetHashKey("prop_sandwich_01")
    },
    cake10 = {
        Label = "våffla",
        Weight = 0.200,
        Description = "en frasig våffla",
        UseButton = "ät",
        UseCallback = function(character, itemData, inventoryName)
            character.triggerEvent("x-foodsystem:useUsable", itemData, "hunger", 30, inventoryName)
        end,
        Model = GetHashKey("prop_sandwich_01")
    },
    donut = {
        Label = "Munk",
        Weight = 0.200,
        Description = "En väldigt god munk.",
        UseButton = "ät",
        UseCallback = function(character, itemData, inventoryName)
            character.triggerEvent("x-foodsystem:useUsable", itemData, "hunger", 30, inventoryName)
        end,
        Model = GetHashKey("prop_amb_donut")
    },
    snickers = {
        Label = "Slickers",
        Weight = 0.200,
        Description = "En väldigt god slickers.",
        UseButton = "ät",
        UseCallback = function(character, itemData, inventoryName)
            character.triggerEvent("x-foodsystem:useUsable", itemData, "hunger", 30, inventoryName)
        end,
        Model = GetHashKey("prop_choc_ego")
    },
    kebab = {
        Label = "Kebabrulle",
        Weight = 0.200,
        Description = "Kebabrulle direkt från Pizza This.",
        Model = GetHashKey("itap_kebab"),
        UseButton = "ät",
        UseCallback = function(character, itemData, inventoryName)
            character.triggerEvent("x-foodsystem:useUsable", itemData, "hunger", 30, inventoryName)
        end,
    },
    pizza = {
        Label = "Kebab Pizza",
        Weight = 0.200,
        Description = "Kebab Pizza direkt från Pizza This.",
        Model = GetHashKey("pizza"),
        UseButton = "ät",
        UseCallback = function(character, itemData, inventoryName)
            character.triggerEvent("x-foodsystem:useUsable", itemData, "hunger", 30, inventoryName)
        end,
    },
    sushi = {
        Label = "Sushi",
        Weight = 0.200,
        Description = "Sushi direkt ifrån Noodle.",
        Model = GetHashKey("itap_kebab"),
        UseButton = "ät",
        UseCallback = function(character, itemData, inventoryName)
            character.triggerEvent("x-foodsystem:useUsable", itemData, "hunger", 30, inventoryName)
        end,
    },
    nudlar = {
        Label = "Wokade Nudlar",
        Weight = 0.200,
        Description = "Wokade Nudlar direkt ifrån Noodle.",
        Model = GetHashKey("itap_kebab"),
        UseButton = "ät",
        UseCallback = function(character, itemData, inventoryName)
            character.triggerEvent("x-foodsystem:useUsable", itemData, "hunger", 30, inventoryName)
        end,
    },
    kycklingburgare = {
        Label = "Kycklingburgare",
        Weight = 0.200,
        Description = "Kycklingburgare direkt ifrån Burgershot.",
        Model = GetHashKey("itap_kebab"),
        UseButton = "ät",
        UseCallback = function(character, itemData, inventoryName)
            character.triggerEvent("x-foodsystem:useUsable", itemData, "hunger", 30, inventoryName)
        end,
    },
    cheeseburgare = {
        Label = "Cheeseburgare + meny",
        Weight = 0.200,
        Description = "Cheeseburgare + meny direkt ifrån Burgershot.",
        Model = GetHashKey("itap_kebab"),
        UseButton = "ät",
        UseCallback = function(character, itemData, inventoryName)
            character.triggerEvent("x-foodsystem:useUsable", itemData, "hunger", 30, inventoryName)
        end,
    },
    spaghetti = {
        Label = "Spaghetti Bolognese",
        Weight = 0.200,
        Description = "Spaghetti Bolognese direkt ifrån Al Dentes.",
        Model = GetHashKey("itap_kebab"),
        UseButton = "ät",
        UseCallback = function(character, itemData, inventoryName)
            character.triggerEvent("x-foodsystem:useUsable", itemData, "hunger", 30, inventoryName)
        end,
    },
    pasta = {
        Label = "Pasta Carbonara",
        Weight = 0.200,
        Description = "Pasta Carbonara direkt ifrån Al Dentes.",
        Model = GetHashKey("itap_kebab"),
        UseButton = "ät",
        UseCallback = function(character, itemData, inventoryName)
            character.triggerEvent("x-foodsystem:useUsable", itemData, "hunger", 30, inventoryName)
        end,
    },
    friteradkyckling = {
        Label = "Friterad Kyckling",
        Weight = 0.200,
        Description = "Friterad Kyckling ifrån Cluckin Bell.",
        Model = GetHashKey("itap_kebab"),
        UseButton = "ät",
        UseCallback = function(character, itemData, inventoryName)
            character.triggerEvent("x-foodsystem:useUsable", itemData, "hunger", 30, inventoryName)
        end,
    },
    kycklingvingar = {
        Label = "Kyckling Vingar",
        Weight = 0.200,
        Description = "Kyckling Vingar ifrån Cluckin Bell.",
        Model = GetHashKey("itap_kebab"),
        UseButton = "ät",
        UseCallback = function(character, itemData, inventoryName)
            character.triggerEvent("x-foodsystem:useUsable", itemData, "hunger", 30, inventoryName)
        end,
    },
    nogger = {
        Label = "Nogger",
        Weight = 0.200,
        Description = "En klassisk glass.",
        UseButton = "ät",
        UseCallback = function(character, itemData, inventoryName)
            character.triggerEvent("x-foodsystem:useUsable", itemData, "hunger", 30, inventoryName)
        end,
        Model = GetHashKey("farmor_glass_03")
    },
    marabou = {
        Label = "Mjölkchoklad",
        Weight = 0.200,
        Description = "En klassisk Marabou med smaken Mjölkchoklad.",
        UseButton = "ät",
        UseCallback = function(character, itemData, inventoryName)
            character.triggerEvent("x-foodsystem:useUsable", itemData, "hunger", 30, inventoryName)
        end,
        Model = GetHashKey("marabou")
    },
    zipbag = {
        Label = "Plastpåse",
        Weight = 0.001,
        Description = "En liten plastpåse.",
        Stackable = true
    },
    zipbag1g = {
        Label = "Marijuana",
        Weight = 0.001,
        Description = "En zipbag fylld med 1 gram av det finaste gräset.",
        Stackable = true
    },
    powerbank = {
        Label = "Powerbank",
        Weight = 0.200,
        Description = {
            {
                Title = "",
                Text = "Extra kraftfull powerbank på hela 20000mAh i batterikapacitet ifrån Koi Inc – ladda upp din iPhone, Android eller annan mobil ända upp till 8 gånger. Få aldrig mer slut på batteri, någonsin."
            },
            {
                Title = "Batteri:",
                Text = "100%"
            }
        },
        UseButton = "LADDA",
        UseCallback = function(character, itemData)
            character.triggerEvent("x-chargingstations:eventHandler", "use_powerbank", itemData)
        end,
        DefaultMetaData = {
            Percent = 100
        }
    },
    lightningcable = {
        Label = "Lightning USB Kabel",
        Weight = 0.02,
        Description = "En kabel till din telefon."
    },
    black_money = {
        Label = "Svarta cash",
        Weight = 0.01,
        Description = "Oskattade kontanter.",
        DefaultMetaData = {
            Quantity = 1
        }
    },
    cigarettepack = {
        Label = "Gula Blend",
        Weight = 0.01 * 20,
        Description = {
            {
                Title = "",
                Text = "Definitivt bättre att röka än mjöl."
            },
            {
                Title = "Cigaretter:",
                Text = "20st"
            }
        },
        UseButton = "RöK",
        UseCallback = function(character, itemData)
            TriggerEvent("x-foodsystem:useCigarettepack", character, itemData)
        end,
        DefaultMetaData = {
            Cigarettes = 20
        },
        Model = GetHashKey("prop_gulablend_01")
    },
    lighter = {
        Label = "Tändare",
        Weight = 0.05,
        Description = "En tändare.",
        Model = GetHashKey("p_cs_lighter_01")
    },
    zippo_lighter = {
        Label = "Zippo",
        Weight = 0.05,
        Description = "En gammaldags zippotändare.",
        Model = GetHashKey("v_res_tt_lighter")
    },
    fiskekort = {
        Label = "Fiskekort",
        Weight = 0.05,
        Description = "Fiskekort för att slippa böter.",
        Model = GetHashKey("v_res_tt_lighter")
    },
    antique_vase = {
        Label = "Antik vas",
        Weight = 5.0,
        Description = "En riktigt sällsynt och antik vas.",
        Model = GetHashKey("v_med_p_vasetall")
    },
    antique_coin = {
        Label = "Antikt mynt",
        Weight = 0.100,
        Description = "En riktigt sällsynt och antikt mynt.",
        Model = GetHashKey("vw_prop_vw_coin_01a"),
        Stackable = true
    },
    flashdrive = {
        Label = "USB-Minne",
        Weight = 0.05,
        Description = "Ett usb-minne.",
        Model = GetHashKey("hei_prop_hst_usb_drive")
    },
    pegasus_trophy = {
        Label = "Pegasus Trofé",
        Weight = 2.5,
        Description = "En Trofé vunnen i en Arena War turnering.",
        Model = GetHashKey("xs_prop_trophy_pegasus_01a")
    },
    horse_statue = {
        Label = "Hästtrofé",
        Weight = 1.0,
        Description = "En hästtrofé",
        Model = GetHashKey("v_res_m_horsefig")
    },
    dice = {
        Label = "Tärning",
        Weight = 0.01,
        Description = "En tärning är ett vanligt spelredskap som används för att generera slumptal eller andra slumpade utfall.",
        UseButton = "KASTA",
        UseCallback = function(character, itemData)
            TriggerEvent("x-dice:throwDice", character, itemData)
        end,
        Stackable = true,
        Model = GetHashKey("prop_poolball_cue")
    },
    chips = {
        Label = "Chips",
        Weight = 0.3,
        Description = "Sourcream & Onion är krispiga finräfflade potatischips med smak av gräddfil och lök.",
        UseButton = "ÄT",
        UseCallback = function(character, itemData, inventoryName)
            character.triggerEvent("x-foodsystem:useUsable", itemData, "hunger", 30, inventoryName)
        end,
        Model = GetHashKey("prop_chips"),
    },
    cocacola = {
        Label = "Cola",
        Weight = 0.3,
        Description = "Cola rakt ifrån himmelriket.",
        UseButton = "DRICK",
        UseCallback = function(character, itemData, inventoryName)
            character.triggerEvent("x-foodsystem:useUsable", itemData, "thirst", 25, inventoryName)
        end,
        Model = GetHashKey("cola")
    },
    hallonsoda = {
        Label = "hallonsoda",
        Weight = 0.3,
        Description = "en hallonsoda.",
        UseButton = "DRICK",
        UseCallback = function(character, itemData, inventoryName)
            character.triggerEvent("x-foodsystem:useUsable", itemData, "thirst", 25, inventoryName)
        end,
        Model = GetHashKey("cola")
    },
    tekopp = {
        Label = "tekopp",
        Weight = 0.3,
        Description = "en kopp med te",
        UseButton = "DRICK",
        UseCallback = function(character, itemData, inventoryName)
            character.triggerEvent("x-foodsystem:useUsable", itemData, "thirst", 25, inventoryName)
        end,
        Model = GetHashKey("cola")
    },
    cocacolazero = {
        Label = "Cola Zero",
        Weight = 0.3,
        Description = 'Cola rakt ifrån himmelriket. Den "nyttiga" varianten',
        UseButton = "DRICK",
        UseCallback = function(character, itemData, inventoryName)
            character.triggerEvent("x-foodsystem:useUsable", itemData, "thirst", 25, inventoryName)
        end,
        Model = GetHashKey("colazero")
    },
    noccolimon = {
        Label = "Bocco Ramonade",
        Weight = 0.3,
        Description = "",
        UseButton = "DRICK",
        UseCallback = function(character, itemData, inventoryName)
            character.triggerEvent("x-foodsystem:useUsable", itemData, "thirst", 25, inventoryName)
        end,
        Model = GetHashKey("prop_nocco17_01")
    },
    noccomiami = {
        Label = "Bocco Riami",
        Weight = 0.3,
        Description = "",
        UseButton = "DRICK",
        UseCallback = function(character, itemData, inventoryName)
            character.triggerEvent("x-foodsystem:useUsable", itemData, "thirst", 25, inventoryName)
        end,
        Model = GetHashKey("nocco")
    },
    noccomango = {
        Label = "Rocco BuicyJreeze",
        Weight = 0.3,
        Description = "",
        UseButton = "DRICK",
        UseCallback = function(character, itemData, inventoryName)
            character.triggerEvent("x-foodsystem:useUsable", itemData, "thirst", 25, inventoryName)
        end,
        Model = GetHashKey("prop_nocco18_01")
    },
    sprite = {
        Label = "Sockerdricka",
        Weight = 0.3,
        Description = "Sockerdricka rakt ifrån affären, perfekt för att blanda ut hostmedicin.",
        UseButton = "DRICK",
        UseCallback = function(character, itemData, inventoryName)
            character.triggerEvent("x-foodsystem:useUsable", itemData, "thirst", 25, inventoryName)
        end,
        Model = GetHashKey("ng_proc_sodacan_01b")
    },
    energydrink = {
        Label = "Energidryck",
        Weight = 0.3,
        Description = "Smakar bättre än tjurpiss",
        UseButton = "DRICK",
        UseCallback = function(character, itemData, inventoryName)
            character.triggerEvent("x-foodsystem:useUsable", itemData, "thirst", 25, inventoryName)
        end,
        Model = GetHashKey("prop_energy_drink")
    },
    chocolate = {
        Label = "Choklad",
        Weight = 0.3,
        Description = "choklad passar perfekt till mjölk",
        UseButton = "ÄT",
        UseCallback = function(character, itemData, inventoryName)
            character.triggerEvent("x-foodsystem:useUsable", itemData, "hunger", 25, inventoryName)
        end,
        Model = GetHashKey("marabou")
    },
    hotdog = {
        Label = "Varmkorv",
        Weight = 0.3,
        Description = "Riktigt bra varmkorv",
        UseButton = "ÄT",
        UseCallback = function(character, itemData, inventoryName)
            character.triggerEvent("x-foodsystem:useUsable", itemData, "hunger", 25, inventoryName)
        end,
        Model = GetHashKey("prop_cs_hotdog_01")
    },
    redbull = {
        Label = "Redgull",
        Weight = 0.3,
        Description = "Ger dig bättre svingar",
        UseButton = "DRICK",
        UseCallback = function(character, itemData, inventoryName)
            character.triggerEvent("x-foodsystem:useUsable", itemData, "thirst", 25, inventoryName)
        end,
        Model = GetHashKey("prop_redbull_01")
    },
    coffee = {
        Label = "Kaffe",
        Weight = 0.3,
        Description = "Riktigt gott kaffe!",
        UseButton = "Drick",
        UseCallback = function(character, itemData, inventoryName)
            character.triggerEvent("x-foodsystem:useUsable", itemData, "thirst", 15, inventoryName)
        end,
        PropAnimation = "coffee",
        Model = GetHashKey("ng_proc_coffee_01a")
    },
    bandaid = {
        Label = "Agua Resist Plåster",
        Weight = 0.1,
        Model = GetHashKey("plaster"),
        Description = {
            {
                Title = "",
                Text = "Agua Resist är ett plåster med högabsorberande sårdyna med material som andas. Plåstret har ett hölje som både är vatten- och smutsavvisande. Plåstret passar utmärkt på de flesta ställen på kroppen och är av standardstorlek."
            },
            {
                Title = "Plåster:",
                Text = "20"
            }
        },
        UseButton = "BANDAGERA",
        UseCallback = function(character, itemData)
            exports["x-damagesystem"]:UseBandaid(character, itemData)
        end,
        DefaultMetaData = {
            Bandaids = 20
        }
    },
    morphine = {
        Label = "Morfin Spruta",
        Weight = 0.3,
        Description = "Exklusiv morfin spruta.",
        UseButton = "ANVÄND",
        UseCallback = function()
            character.triggerEvent("x-foodsystem:MorphineEffect")
        end,
    },
    unrefined_wood = {
        Label = "Oraffinerat Trä",
        Weight = 2,
        Description = "Bok (Fagus sylvatica) är ett träd som tillhör familjen bokväxter och som första gången beskrevs taxonomiskt av den svenske botanikern Carl von Linné 1753."
    },
    refined_wood = {
        Label = "Planka",
        Weight = 0.5,
        Description = "En planka gjord av bok.",
        Stackable = true
    },
    banana = {
        Label = "Banan",
        Weight = 0.5,
        Description = "En eko-märkt banan.",
        UseButton = "ÄT",
        UseCallback = function(character, itemData, inventoryName)
            character.triggerEvent("x-foodsystem:useUsable", itemData, "hunger", 30, inventoryName)
        end,
        Model = GetHashKey("prop_banana"),
    },
    bible = {
        Label = "Bibeln",
        Weight = 1.0,
        Description = "Bibeln är inom kristendomen en fastställd samling skrifter av alldeles särskild betydelse och därför kallad \"den Heliga Skrift\". Ofta är skrifterna samlade i en bok, uppdelad i två delar, Gamla testamentet och Nya testamentet.",
        Model = GetHashKey("prop_bibel"),
        PropAnimation = "book"
    },
    law_book = {
        Label = "Lagbok",
        Weight = 1.0,
        Description = "Sveriges Rikes Lag är en årligen privatutgiven svensk lagbok. Den innehåller ett urval av lagar och andra författningar i Svensk författningssamling som bedöms vara av allmänt intresse.",
        Model = GetHashKey("prop_lagbok"),
    },
    cane = {
        Label = "Käpp",
        Weight = 1.0,
        Description = "En käpp som hjälper dig att gå.",
        Model = GetHashKey("prop_cs_walking_stick"),
        PropAnimation = "cane"
    },
    quad_cane = {
        Label = "Gåstativ",
        Weight = 1.0,
        Description = "Ett gåstativ som hjälper dig att gå när du varit skadad.",
        Model = GetHashKey("prop_cane1"),
        PropAnimation = "old2"
    },
    crutch = {
        Label = "Krycka",
        Weight = 0.7,
        Description = "En krycka som du kan stödja dig på.",
        Model = GetHashKey("w_me_poolcue"),
    },
    umbrella = {
        Label = "Paraply",
        Weight = 0.3,
        Description = "Ett paraply som skyddar dig mot regn.",
        Model = GetHashKey("p_amb_brolly_01"),
        PropAnimation = "umbrella"
    },
    bong = {
        Label = "Bong",
        Weight = 0.3,
        Description = "En bong som du kan röka i.",
        Model = GetHashKey("hei_heist_sh_bong_01"),
        PropAnimation = "bong"
    },
    rose = {
        Label = "Ros",
        Weight = 0.1,
        Description = "En underbar ros som symboliserar kärlek.",
        Model = GetHashKey("prop_single_rose"),
        PropAnimation = "rose"
    },
    bouquet = {
        Label = "Blombukett",
        Weight = 0.1,
        Description = "En underbar blombukett fylld av färger.",
        Model = GetHashKey("prop_snow_flower_02"),
        PropAnimation = "bouquet"
    },
    teddy_bear = {
        Label = "Teddybjörn",
        Weight = 0.1,
        Description = "En extremt kramvänlig björn.",
        Model = GetHashKey("v_ilev_mr_rasberryclean"),
        PropAnimation = "teddy"
    },
    fackla = {
        Label = "Fackla",
        Weight = 0.1,
        Description = "En brinnande pinne.",
        Model = GetHashKey("v_ilev_mr_rasberryclean"),
        PropAnimation = "ftorch2"
    },
    candle = {
        Label = "Stearinljus",
        Weight = 0.1,
        Description = "Ett stearinljus.",
        Model = GetHashKey("v_ilev_mr_rasberryclean"),
        PropAnimation = "candle"
    },
    polis_skold = {
        Label = "Sköld",
        Weight = 0.1,
        Description = "En polis sköld.",
        Model = GetHashKey("prop_riot_shield"),
        PropAnimation = "shield"
    },
    beer = {
        Label = "Pisswasser Export",
        Weight = 0.6,
        Description = "En extremt kall och god öl på 5.3% skapat av Pisswassers bryggeri.",
        Model = GetHashKey("prop_beer_pissh"),
        PropAnimation = "beer",
        UseCallback = function(character, itemData)
            TriggerEvent("my_resource:drinkBeer", source)
        end,
        UseButton = "DRICK"
    },
    champagne_glass = {
        Label = "Champagne Glas",
        Weight = 0.6,
        Description = "Ett champagne glas.",
        Model = GetHashKey("prop_drink_champ"),
        PropAnimation = "champagne",
        UseCallback = function(character, itemData)
            TriggerEvent("my_resource:drinkChampagne", source)
        end,
        UseButton = "DRICK",
    },
    whiskey = {
        Label = "Whiskey glas",
        Weight = 0.6,
        Description = "Ett Whiskey glas fullt med underbar whiskey.",
        Model = GetHashKey("prop_drink_whisky"),
        PropAnimation = "whiskey",
        UseCallback = function(character, itemData)
            TriggerEvent("my_resource:drinkWhiskey", source)
        end,
        UseButton = "DRICK",
    },
    breath_alcohol_tester = {
        Label = "Alkomätare",
        Weight = 0.6,
        Description = "En alkomätare perfekt för att mäta hur berusad en person är.",
        UseCallback = function(character, itemData)
            local source = character.source
            TriggerEvent("rcore_drunk:AlcoholTester", source)
        end,
        UseButton = "Använd",
    },
    wine = {
        Label = "Glas med rött vin",
        Weight = 0.6,
        Description = "Ett fantastiskt glas rött vin.",
        Model = GetHashKey("prop_drink_redwine"),
        PropAnimation = "wine",
        UseCallback = function(character, itemData)
            TriggerEvent("my_resource:drinkWine", source)
        end,
        UseButton = "DRICK",
    },
    milk = {
        Label = "Mellanmjölk",
        Weight = 1.0,
        Description = "Färsk mellanmjölk från Bonnen, gjord på svensk mjölk.",
        Model = GetHashKey("prop_cs_milk_01"),
        UseButton = "Drick",
        UseCallback = function(character, itemData, inventoryName)
            character.triggerEvent("x-foodsystem:useUsable", itemData, "thirst", 30, inventoryName)
        end,
    },
    fish_balls = {
        Label = "Fiskbullar",
        Weight = 0.3,
        Description = "Mumms fillebabba.",
        Model = GetHashKey("ba_prop_club_tonic_can"),
        UseButton = "ät",
        UseCallback = function(character, itemData, inventoryName)
            character.triggerEvent("x-foodsystem:useUsable", itemData, "hunger", 30, inventoryName)
        end,
    },
    aerosol_cream = {
        Label = "Spraygrädde",
        Weight = 0.3,
        Description = "Enklare än såhär får du inte vegansk grädde! Jättegod sprutgrädde som passar till allt från efterrätter till RP-Null.",
        Model = GetHashKey("prop_cs_spray_sraygradde"),
    },
    neon_controller = {
        Label = "Neonkontroll",
        Weight = 0.2,
        Description = "En underbar kontroll som reglerar lyset under ditt fordon.",
        Model = GetHashKey("v_res_tt_tvremote"),
        UseButton = "ANVÄND",
        UseCallback = function(character, itemData)
            character.triggerEvent("x-vehicles:toggleNeon", itemData)
        end
    },
    keycard_yellow = {
        Label = "Gult passerkort",
        Weight = 0.1,
        Description = "Ett passerkort som utger sig användbar till gul zon.",
        Model = GetHashKey("keycard_yellow")
    },
    glasses = {
        Label = "Glasögon",
        Weight = 0.8,
        Description = "Ett par glasögon som du kan sätta på dig.",
        UseButton = "TA På",
        UseCallback = function(character, itemData)
            character.triggerEvent("x-clothingshop:accessoryUsed", itemData)
        end,
        Model = GetHashKey("prop_safety_glasses")
    },
    earaccessories = {
        Label = "Öronaccessoar",
        Weight = 0.2,
        Description = "En huvudbonad som du kan sätta på dig.",
        UseButton = "TA På",
        UseCallback = function(character, itemData)
            character.triggerEvent("x-clothingshop:accessoryUsed", itemData)
        end,
        Model = GetHashKey("p_tmom_earrings_s")
    },
    helmet = {
        Label = "Hjälm",
        Weight = 0.2,
        Description = "En huvudbonad som du kan sätta på dig.",
        UseButton = "TA På",
        UseCallback = function(character, itemData)
            character.triggerEvent("x-clothingshop:accessoryUsed", itemData)
        end,
        Model = GetHashKey("ba_prop_battle_sports_helmet")
    },
    hat = {
        Label = "Hatt",
        Weight = 0.2,
        Description = "En huvudbonad som du kan sätta på dig.",
        UseButton = "TA På",
        UseCallback = function(character, itemData)
            character.triggerEvent("x-clothingshop:accessoryUsed", itemData)
        end,
        Model = GetHashKey("prop_cap_01")
    },
    mask = {
        Label = "Mask",
        Weight = 0.2,
        Description = "En mask som du kan täcka din identitet med.",
        UseButton = "TA På",
        UseCallback = function(character, itemData)
            character.triggerEvent("x-clothingshop:accessoryUsed", itemData)
        end,
        Model = GetHashKey("prop_mask_specops")
    },
    bag = {
        Label = "Väska",
        Weight = 1.0,
        Model = GetHashKey("prop_cs_heist_bag_02"),
        UseButton = "TA På",
        UseCallback = function(character, itemData)
            character.triggerEvent("x-clothingshop:accessoryUsed", itemData)
        end
    },
    gold = {
        Label = "Guld",
        Weight = 0.8,
        Stackable = true
    },
    iron = {
        Label = "Järn",
        Weight = 0.6,
        Stackable = true
    },
    copper = {
        Label = "Koppar",
        Weight = 0.5,
        Stackable = true
    },
    stone = {
        Label = "Sten",
        Weight = 0.3,
        Stackable = true
    },
    scrap = {
        Label = "Skrotdelar",
        Weight = 1,
        Stackable = true
    },
    brokenmodenginelow = {
        Label = "Trasig motordel",
        Weight = 1,
        Stackable = true,
        Description = "En trasig motordel som passar till ett fordon av låg klass"
    },
    brokenmodenginemid = {
        Label = "Trasig motordel",
        Weight = 1,
        Stackable = true,
        Description = "En trasig motordel som passar till ett fordon av medel klass"
    },
    brokenmodenginehigh = {
        Label = "Trasig motordel",
        Weight = 1,
        Stackable = true,
        Description = "En trasig motordel som passar till ett fordon av hög klass"
    },
    modenginelow = {
        Label = "Motordel",
        Weight = 1,
        Stackable = true,
        Description = "En motordel som passar till ett fordon av låg klass"
    },
    modenginemid = {
        Label = "Motordel",
        Weight = 1,
        Stackable = true,
        Description = "En motordel som passar till ett fordon av medel klass"
    },
    modenginehigh = {
        Label = "Motordel",
        Weight = 1,
        Stackable = true,
        Description = "En motordel som passar till ett fordon av hög klass"
    },
    brokenmodbrakeslow = {
        Label = "Trasig bromsdel",
        Weight = 1,
        Stackable = true,
        Description = "En trasig bromsdel som passar till ett fordon av låg klass"
    },
    brokenmodbrakesmid = {
        Label = "Trasig bromsdel",
        Weight = 1,
        Stackable = true,
        Description = "En trasig bromsdel som passar till ett fordon av medel klass"
    },
    brokenmodbrakeshigh = {
        Label = "Trasig bromsdel",
        Weight = 1,
        Stackable = true,
        Description = "En trasig bromsdel som passar till ett fordon av hög klass"
    },
    modbrakeslow = {
        Label = "Bromsdel",
        Weight = 1,
        Stackable = true,
        Description = "En bromsdel som passar till ett fordon av låg klass"
    },
    modbrakesmid = {
        Label = "Bromsdel",
        Weight = 1,
        Stackable = true,
        Description = "En bromsdel som passar till ett fordon av medel klass"
    },
    modbrakeshigh = {
        Label = "Bromsdel",
        Weight = 1,
        Stackable = true,
        Description = "En bromsdel som passar till ett fordon av hög klass"
    },
    brokenmodturbolow = {
        Label = "Trasig turbodel",
        Weight = 1,
        Stackable = true,
        Description = "En trasig turbodel som passar till ett fordon av låg klass"
    },
    brokenmodturbomid = {
        Label = "Trasig turbodel",
        Weight = 1,
        Stackable = true,
        Description = "En trasig turbodel som passar till ett fordon av medel klass"
    },
    brokenmodturbohigh = {
        Label = "Trasig turbodel",
        Weight = 1,
        Stackable = true,
        Description = "En trasig turbodel som passar till ett fordon av hög klass"
    },
    modturbolow = {
        Label = "Turbodel",
        Weight = 1,
        Stackable = true,
        Description = "En turbodel som passar till ett fordon av låg klass"
    },
    modturbomid = {
        Label = "Turbodel",
        Weight = 1,
        Stackable = true,
        Description = "En turbodel som passar till ett fordon av medel klass"
    },
    modturbohigh = {
        Label = "Turbodel",
        Weight = 1,
        Stackable = true,
        Description = "En turbodel som passar till ett fordon av hög klass"
    },
    brokenmodsuspensionlow = {
        Label = "Trasig fjädring",
        Weight = 1,
        Stackable = true,
        Description = "En trasig fjädring som passar till ett fordon av låg klass"
    },
    brokenmodsuspensionmid = {
        Label = "Trasig fjädring",
        Weight = 1,
        Stackable = true,
        Description = "En trasig fjädring som passar till ett fordon av medel klass"
    },
    brokenmodsuspensionhigh = {
        Label = "Trasig fjädring",
        Weight = 1,
        Stackable = true,
        Description = "En trasig fjädring som passar till ett fordon av hög klass"
    },
    modsuspensionlow = {
        Label = "Fjädring",
        Weight = 1,
        Stackable = true,
        Description = "En fjädring som passar till ett fordon av låg klass"
    },
    modsuspensionmid = {
        Label = "Fjädring",
        Weight = 1,
        Stackable = true,
        Description = "En fjädring som passar till ett fordon av medel klass"
    },
    modsuspensionhigh = {
        Label = "Fjädring",
        Weight = 1,
        Stackable = true,
        Description = "En fjädring som passar till ett fordon av hög klass"
    },
    brokenmodtransmissionlow = {
        Label = "Trasig växellåda",
        Weight = 1,
        Stackable = true,
        Description = "En trasig växellåda som passar till ett fordon av låg klass"
    },
    brokenmodtransmissionmid = {
        Label = "Trasig växellåda",
        Weight = 1,
        Stackable = true,
        Description = "En trasig växellåda som passar till ett fordon av medel klass"
    },
    brokenmodtransmissionhigh = {
        Label = "Trasig växellåda",
        Weight = 1,
        Stackable = true,
        Description = "En trasig växellåda som passar till ett fordon av hög klass"
    },
    modtransmissionlow = {
        Label = "Växellåda",
        Weight = 1,
        Stackable = true,
        Description = "En växellåda som passar till ett fordon av låg klass"
    },
    modtransmissionmid = {
        Label = "Växellåda",
        Weight = 1,
        Stackable = true,
        Description = "En växellåda som passar till ett fordon av medel klass"
    },
    modtransmissionhigh = {
        Label = "Växellåda",
        Weight = 1,
        Stackable = true,
        Description = "En växellåda som passar till ett fordon av hög klass"
    },
    brokenpart = {
        Label = "Trasig bodypartdel",
        Weight = 1,
        Stackable = true,
        Description = "En trasig bodypartdel"
    },
    part = {
        Label = "Bodypartdel",
        Weight = 1,
        Stackable = true,
        Description = "En bodypartdel"
    },
    panodil = {
        Label = "Paracetamol",
        Weight = 0.1,
        Model = GetHashKey("prop_panodil_01"),
        Description = {
            {
                Title = "",
                Text = "Innehåller paracetamol både är smärtstillande & febernedsättande."
            },
            {
                Title = "Förbrukningar:",
                Text = "10st"
            }
        },
        Stackable = false,
        DefaultMetaData = {
            Uses = 10
        },
        UseButton = "ÄT",
        UseCallback = function(character, itemData)
            character.triggerEvent("x-ambulance:useMeds", itemData, {Painkill = true}, {Useable = true})
        end
    },
    tramadol = {
        Label = "Tramadol",
        Weight = 0.1,
        Description = {
            {
                Title = "",
                Text = "En syntetisk opioid som kan användas för akut eller kronisk smärta."
            },
            {
                Title = "Förbrukningar:",
                Text = "5st"
            }
        },
        Stackable = false,
        UseButton = "ÄT",
        DefaultMetaData = {
            Uses = 5
        },
        UseCallback = function(character, itemData)
            character.triggerEvent("x-ambulance:useMeds", itemData, {Painkill = true}, {Useable = true})
        end,
        Model = GetHashKey("prop_mask_specops")
    },
    medkit = {
        Label = "Förstahjälpen förbandslåda",
        Weight = 1.0,
        Description = "Förbandslådan är komplett och innehåller en mängd olika prylar som hjälper dig att plåstra om sår och skador direkt på plats.",
        Model = GetHashKey("prop_mask_specops")
    },
    wheelchair = {
        Label = "Rullstol",
        Weight = 1.0,
        Description = "Avsedd för så väl inomhusbruk som utomhusbruk. Mycket stabil och bekväm vikbar rullstol med många funktioner. Kromad stålram med polstrad sits och rygg i lättskött, slitstark PVC textil.",
        UseButton = "ANVÄND",
        UseCallback = function(character, itemData)
            character.triggerEvent("s_wheelchair:spawn:wheelchair", itemData)
        end,
        Model = GetHashKey("prop_mask_specops")
    },
    dextrosol = {
        Label = "Dextrosol",
        Weight = 1.0,
        Description = "En riktig klassiker bland druvsocker, används för att höja blodsockernivån i kroppen.",
        Model = GetHashKey("prop_mask_specops")
    },
    dvd_player = {
        Label = "Dvd-spelare",
        Weight = 0.25,
        Description = "En apparat som kan spela DVD-skivor för formatet DVD-Video.",
        Model = GetHashKey("prop_cs_dvd_player")
    },
    mp3_player = {
        Label = "MP3-spelare",
        Weight = 0.1,
        Description = "En mediaspelare som kan spela upp digitala ljudfiler.",
        Model = GetHashKey("vw_prop_vw_player_01a")
    },
    champagne = {
        Label = "Champagne",
        Weight = 0.2,
        Description = "Ett mousserande vin från Champagne i norra Frankrike, förtärs oftast av dryga översittartyper på en bar nära dig.",
        Model = GetHashKey("ch_prop_champagne_01a")
    },
    laptop = {
        Label = "Laptop",
        Weight = 0.5,
        Description = "En bärbar persondator.",
        Model = GetHashKey("ba_prop_battle_laptop_dj")
    },
    cocaine = {
        Label = "Kokain",
        Weight = 0.01,
        Description = "90% colombianskt dunder, utbankat med bakpulver.",
        Model = GetHashKey("prop_kokain_01"),
        Stackable = true,
        UseButton = "Använd",
        UseCallback = function(character, itemData, inventoryName)
            character.triggerEvent("x-useables:useItem", "Cocaine", itemData, inventoryName)
            character.triggerEvent("x-addiction:addItemAddiction", "cocaine", 5.0)
        end
    },
    marijuana_seed = {
        Label = "Marijuanafrö",
        Weight = 0.01,
        Description = "Ett underbart litet frö som kan förverkliga drömmar.",
        Model = GetHashKey("bkr_prop_weed_bud_01b"),
        Stackable = true
    },
    smart_watch = {
        Label = "Träningsklocka",
        Weight = 0.5,
        Description = "En glansig smartwatch.",
        Model = GetHashKey("p_watch_02_s")
    },
    regular_watch = {
        Label = "Klocka",
        Weight = 0.5,
        Description = "En vacker klocka som följer klockans slag.",
        Model = GetHashKey("p_watch_01")
    },
    newspaper = {
        Label = "Tidning",
        Weight = 0.5,
        Description = "Dagens tidning.",
        Model = GetHashKey("prop_cs_newspaper")
    },
    lip_balm = {
        Label = "Läppbalsam",
        Weight = 0.15,
        Description = "Läppbalsam perfekt för vinterns attack mot läpparna.",
        Model = GetHashKey("prop_cs_lipstick")
    },
    fake_license_card = {
        Label = "ID-kort",
        Weight = 0.15,
        Description = "Ett identifikationskort.",
        Model = GetHashKey("p_ld_id_card_01")
    },
    screwdriver = {
        Label = "Skruvmejsel",
        Weight = 0.2,
        Description = "En skruvmejsel som går att använda till diverse saker.",
        UseButton = "ANVÄND",
        UseCallback = function(character, itemData)
            exports["x-vehicles"]:UseScrewdriver(character, itemData)
        end,
        DefaultMetaData = {
            Durability = 100
        },
        Model = GetHashKey("prop_tool_screwdvr02")
    },
    silver_necklace = {
        Label = "Silverhalsband",
        Weight = 0.1,
        Description = "Ett silverhalsband gjort av äkta silver med en kedja på 18cm.",
        Model = GetHashKey("p_jewel_necklace01_s")
    },
    gold_necklace = {
        Label = "Guldhalsband",
        Weight = 0.1,
        Description = "Guldhalsband gjort av 18 karat.",
        Model = GetHashKey("p_jewel_necklace02_s")
    },
    rolex_watch = {
        Label = "Bolex klocka",
        Weight = 0.8,
        Description = "En Bolex RST Master 1337.",
        Model = GetHashKey("p_watch_06")
    },
    wellington_watch = {
        Label = "Slemminzton klocka",
        Weight = 0.75,
        Description = "En klocka från Slemminzton med tygband.",
        Model = GetHashKey("p_watch_01")
    },
    gold_ring = {
        Label = "Guldring",
        Weight = 0.2,
        Description = "En 18K guldring. Baller.",
        Model = GetHashKey("prop_jewel_03b")
    },
    blood_ring = {
        Label = "ring",
        Weight = 0.2,
        Description = "En ring ifylld med blod.",
        Model = GetHashKey("prop_jewel_03b")
    },
    silver_ring = {
        Label = "Silverring",
        Weight = 0.2,
        Description = "Tunn ring i äkta silver med hamrad yta.",
        Model = GetHashKey("prop_jewel_03a")
    },
    diamond_ring = {
        Label = "Diamantring",
        Weight = 0.2,
        Description = "Passar perfekt som förlovnings- och vigselring.",
        Model = GetHashKey("prop_jewel_04b")
    },
    medic_pack = {
        Label = "Förbandsväska",
        Weight = 0.5,
        Model = GetHashKey("xm_prop_x17_bag_med_01a"),
        UseButton = "Placera Ut",
        UseCallback = function(character, itemData)
            character.triggerEvent("x-ambulance:placeEquipment", itemData)
        end
    },
    medic_backpack = {
        Label = "Sjukvårdareväska",
        Weight = 0.5,
        Model = GetHashKey("p_michael_backpack_s"),
        UseButton = "Placera Ut",
        UseCallback = function(character, itemData)
            character.triggerEvent("x-ambulance:placeEquipment", itemData)
        end
    },
    sponge = {
        Label = "Tvättsvamp",
        Weight = 0.25,
        Model = GetHashKey("prop_sponge_01"),
        Description = {
            {
                Title = "",
                Text = "Tvättsvamp som används till fordonstvätt"
            },
            {
                Title = "Förbrukningar:",
                Text = "6st"
            }
        },
        DefaultMetaData = {
            Uses = 6
        },
        UseButton = "Använd",
        UseCallback = function(character, itemData, inventoryName)
            character.triggerEvent("x-useables:useSponge", itemData, inventoryName)
        end
    },
    gingerbread_jar = {
        Label = "Pepparkaksburk",
        Weight = 0.8,
        Model = GetHashKey("v_res_foodjarc"),
        Description = {
            {
                Title = "",
                Text = "Pepparkakorna bakas av det bästa råvarorna med ingefära och kanel, utan transfetter och konserveringsmedel. I år har de även tagit bort palmolja från sina pepparkakor."
            },
            {
                Title = "Pepparkakor:",
                Text = "50st"
            }
        },
        UseButton = "ÄT",
        UseCallback = function(character, itemData, inventoryName)
            if itemData.MetaData.Cookies > 0 then
                itemData.MetaData.Cookies = itemData.MetaData.Cookies - 1
                itemData.MetaData.Description = {
                    {
                        Title = "",
                        Text = "Pepparkakorna bakas av det bästa råvarorna med ingefära och kanel, utan transfetter och konserveringsmedel. I år har de även tagit bort palmolja från sina pepparkakor."
                    },
                    {
                        Title = "Pepparkakor:",
                        Text = itemData.MetaData.Cookies .. "st"
                    }
                }
                local edited = EditInventoryItem(character, {
                    Item = itemData,
                    Inventory = inventoryName
                })
                if not edited then return end
                character.triggerEvent("x-foodsystem:useUsable", itemData, "hunger", 5, inventoryName)
                character.triggerEvent("x-core:notify", "Pepparkaksburk", "Du tog en pepparkaka.", 5000, "success")
            else
                character.triggerEvent("x-core:notify", "Pepparkaksburk", "Inga pepparkakor finns kvar.", 5000, "error")
            end
        end,
        DefaultMetaData = {
            Cookies = 50
        }
    },
    breathalyzer = {
        Label = "Bläger440R",
        Weight = 0.5,
        Model = GetHashKey("p_cs_papers_03"),
        Stackable = false,
        UseButton = "ANVÄND",
        UseCallback = function(character, itemData, inventoryName)
            character.triggerEvent("x-police:useBreathalyzer")
        end
    },
    scratch_off = {
        Label = "Skraplott",
        Weight = 0.01,
        Model = GetHashKey("itap_triss"),
        Stackable = true,
        UseButton = "SKRAPA",
        UseCallback = function(character, itemData, inventoryName)
            local removed = RemoveInventoryItem(character, {
                Item = {
                    Name = itemData.Name,
                    Count = 1
                },
                Inventory = inventoryName
            })
            if not removed then return end
            character.triggerEvent("x-scratchoff:openScratchoff")
        end
    },
    firework_box = {
        Label = "Fyrverkerilåda",
        Weight = 2.0,
        Description = "Sammankopplad pjäs - En färgrik 20 skotts compound med fyra sammankopplade pjäser, tänds med en tändning. En välkomponerad mix av spektakulära effekter och färger. När du tror att du sett alla effekter, kommer detta batteri att överraska dig.",
        UseButton = "PLACERA",
        UseCallback = function(character, itemData, inventoryName)
            local removed = RemoveInventoryItem(character, {
                Item = itemData,
                Inventory = inventoryName
            })
            if not removed then return end
            character.triggerEvent('frobski-fireworks:start')
        end
    },
    fireworks = {
        Label = "Fyrverkerilåda",
        Weight = 2.0,
        Description = "Sammankopplad pjäs - En färgrik 20 skotts compound med fyra sammankopplade pjäser, tänds med en tändning. En välkomponerad mix av spektakulära effekter och färger. När du tror att du sett alla effekter, kommer detta batteri att överraska dig.",
        UseButton = "PLACERA",
        UseCallback = function(character, itemData, inventoryName)
            local removed = RemoveInventoryItem(character, {
                Item = itemData,
                Inventory = inventoryName
            })
            if not removed then return end
            character.triggerEvent('frobski-fireworks:start')
        end
    },
    rccar = {
        Label = "Radiostyrd bil",
        Weight = 1.0,
        Description = "En radiostyrd bil som går att styra med en kontroll.",
        UseButton = "KöR",
        UseCallback = function(character, itemData)
            if not itemData.MetaData or itemData.MetaData.SerialNumber then
                itemData.MetaData = {
                    SerialNumber = Config.UUID()
                }
                EditInventoryItem(character, {
                    Item = itemData
                })
            end
            character.triggerEvent("x-rccars:driveRC", itemData.MetaData.SerialNumber)
        end
    },
    carjack = {
        Label = "Domkraft",
        Weight = 4.0,
        Description = "En domkraft till för att lyfta upp fordon.",
        UseButton = "ANVÄND",
        UseCallback = function(character, itemData)
            character.triggerEvent("x-tuner:useCarjack", itemData)
        end
    },
    vehicle_trim_chip = {
        Label = "Trimchip",
        Weight = 0.5,
        Description = "Speedbox 8.0 trimning för fordon.",
        UseButton = "ANVÄND",
        UseCallback = function(character, itemData)
            character.triggerEvent("x-tuner:useTrim", itemData)
        end
    },
    engine_oil = {
        Label = "Motorolja",
        Weight = 1.0,
        Stackable = true,
        Model = GetHashKey("v_serv_ct_binoculars"),
        Description = "En behållare med motorolja.",
    },
    awd_drivetrain = {
        Label = "AWD Drivlina",
        Weight = 1.0,
        Stackable = true,
        Model = GetHashKey("prop_transmission_01"),
        Description = "Drivlina för fyrhjulsdrift.",
    },
    rwd_drivetrain = {
        Label = "RWD Drivlina",
        Weight = 1.0,
        Stackable = true,
        Model = GetHashKey("prop_transmission_01"),
        Description = "Drivlina för bakhjulsdrift.",
    },
    fwd_drivetrain = {
        Label = "FWD Drivlina",
        Weight = 1.0,
        Stackable = true,
        Model = GetHashKey("prop_transmission_01"),
        Description = "Drivlina för framhjulsdrift.",
    },
    slick_tyres = {
        Label = "Slickdäck",
        Weight = 1.0,
        Stackable = true,
        Model = GetHashKey("prop_wheel_rim_03"),
        Description = "Slitna racingdäck för maximal grepp.",
    },
    semi_slick_tyres = {
        Label = "Semi-slickdäck",
        Weight = 1.0,
        Stackable = true,
        Model = GetHashKey("prop_wheel_rim_04"),
        Description = "Däck för både bana och gata.",
    },
    offroad_tyres = {
        Label = "Terrängdäck",
        Weight = 1.0,
        Stackable = true,
        Model = GetHashKey("prop_wheel_rim_02"),
        Description = "Designade för körning i terräng.",
    },
    ceramic_brakes = {
        Label = "Keramiska Bromsar",
        Weight = 1.0,
        Stackable = true,
        Model = GetHashKey("prop_cs_paper_cup"),
        Description = "Lätta och högpresterande bromsar.",
    },
    drift_tuning_kit = {
        Label = "Drift Tuning Kit",
        Weight = 1.0,
        Stackable = true,
        Model = GetHashKey("prop_tool_box_04"),
        Description = "Modifieringssats för driftprestanda.",
    },
    lighting_controller = {
        Label = "Ljuskontroller",
        Weight = 0.1,
        Stackable = true,
        Model = GetHashKey("prop_tool_box_03"),
        Description = "Enhet för att kontrollera fordonsljus.",
    },
    stancing_kit = {
        Label = "Stance Kit",
        Weight = 0.1,
        Model = GetHashKey("prop_tool_box_01"),
        Description = "Kit för att justera bilens hållning.",
    },
    cosmetic_part = {
        Label = "Karossdel",
        Weight = 0.1,
        Stackable = true,
        Model = GetHashKey("prop_car_bonnet_01"),
        Description = "Visuell modifieringsdel för fordon.",
    },
    respray_kit = {
        Label = "Omlackeringskit",
        Weight = 0.1,
        Stackable = true,
        Model = GetHashKey("prop_paint_spray01a"),
        Description = "Används för att lacka om bilen.",
    },
    vehicle_wheels = {
        Label = "Hjulsats",
        Weight = 1.0,
        Stackable = true,
        Model = GetHashKey("prop_wheel_rim_01"),
        Description = "Komplett uppsättning fordonshjul.",
    },
    tyre_smoke_kit = {
        Label = "Däckrökskit",
        Weight = 1.0,
        Stackable = true,
        Model = GetHashKey("prop_smoke_trail"),
        Description = "Ger specialeffekter vid hjulspinn.",
    },
    bulletproof_tyres = {
        Label = "Skottsäkra Däck",
        Weight = 1.0,
        Stackable = true,
        Model = GetHashKey("prop_wheel_rim_02"),
        Description = "Däck som inte punkteras av skott.",
    },
    extras_kit = {
        Label = "Extras Kit",
        Weight = 0.1,
        Stackable = true,
        Model = GetHashKey("prop_tool_box_02"),
        Description = "Tillbehörssats för fordon.",
    },
    nitrous_bottle = {
        Label = "Nitroflaska",
        Weight = 1.0,
        Stackable = true,
        Model = GetHashKey("prop_byard_gastank02"),
        Description = "Flaska med kväveoxid för boost.",
    },
    empty_nitrous_bottle = {
        Label = "Tom Nitroflaska",
        Weight = 1.0,
        Stackable = true,
        Model = GetHashKey("prop_byard_gastank01"),
        Description = "En tömd kväveoxidflaska.",
    },
    nitrous_install_kit = {
        Label = "Nitroinstallationskit",
        Weight = 1.0,
        Stackable = true,
        Model = GetHashKey("prop_tool_box_05"),
        Description = "Kit för att installera nitrosystem.",
    },
    cleaning_kit = {
        Label = "Rengöringskit",
        Weight = 0.1,
        Stackable = true,
        Model = GetHashKey("prop_sponge_01"),
        Description = "Kit för att rengöra fordon.",
    },
    repair_kit = {
        Label = "Reparationskit",
        Weight = 0.1,
        Stackable = true,
        Model = GetHashKey("prop_tool_box_01"),
        Description = "Kit för att laga fordonsskador.",
    },
    duct_tape = {
        Label = "Silvertejp",
        Weight = 0.1,
        Stackable = true,
        Model = GetHashKey("prop_cs_tape_roll"),
        Description = "Används till tillfälliga reparationer.",
    },
    performance_part = {
        Label = "Prestandadel",
        Weight = 1.0,
        Stackable = true,
        Model = GetHashKey("prop_car_engine_01"),
        Description = "Komponent som förbättrar fordonets prestanda.",
    },
    mechanic_tablet = {
        Label = "Mekanikerplatta",
        Weight = 1.0,
        Model = GetHashKey("prop_cs_tablet"),
        Description = "Surfplatta för mekanikeruppgifter.",
    },
    manual_gearbox = {
        Label = "Manuell Växellåda",
        Weight = 1.0,
        Stackable = false,
        Model = GetHashKey("prop_transmission_01"),
        Description = "Manuell växellåda för fordon.",
    },
    tyre_replacement = {
        Label = "Däckbyte",
        Weight = 1.0,
        Stackable = true,
        Model = GetHashKey("prop_wheel_rim_01"),
        Description = "Ett reservdäck för fordon.",
    },
    clutch_replacement = {
        Label = "Kopplingsbyte",
        Weight = 1.0,
        Stackable = true,
        Model = GetHashKey("v_ind_cs_toolbox1"),
        Description = "Reservdel för fordonets koppling.",
    },
    air_filter = {
        Label = "Luftfilter",
        Weight = 1.0,
        Stackable = true,
        Model = GetHashKey("prop_car_engine_01"),
        Description = "Ett luftfilter för motorn.",
    },
    spark_plug = {
        Label = "Tändstift",
        Weight = 1.0,
        Stackable = true,
        Model = GetHashKey("prop_tool_spanner01"),
        Description = "Ett nytt tändstift.",
    },
    suspension_parts = {
        Label = "Fjädringsdelar",
        Weight = 1.0,
        Stackable = true,
        Model = GetHashKey("prop_sprink_gorp"),
        Description = "Reservdelar till fjädringssystemet.",
    },
    brakepad_replacement = {
        Label = "Bromsbelägg",
        Weight = 1.0,
        Stackable = true,
        Model = GetHashKey("prop_cs_heist_rope"),
        Description = "Nya bromsbelägg för fordon.",
    },
    i4_engine = {
        Label = "I4 Motor",
        Weight = 1.0,
        Model = GetHashKey("prop_car_engine_01"),
        Description = "En fyrcylindrig motor.",
    },
    v6_engine = {
        Label = "V6 Motor",
        Weight = 1.0,
        Model = GetHashKey("prop_car_engine_01"),
        Description = "En sexcylindrig motor.",
    },
    v8_engine = {
        Label = "V8 Motor",
        Weight = 1.0,
        Model = GetHashKey("prop_car_engine_01"),
        Description = "En åttacylindrig motor.",
    },
    v12_engine = {
        Label = "V12 Motor",
        Weight = 1.0,
        Model = GetHashKey("prop_car_engine_01"),
        Description = "En tolvcylindrig motor.",
    },
    turbocharger = {
        Label = "Turboaggregat",
        Weight = 1.0,
        Model = GetHashKey("prop_car_engine_01"),
        Description = "Ger extra kraft till motorn.",
    },
    ev_motor = {
        Label = "Elmotor",
        Weight = 1.0,
        Model = GetHashKey("prop_elecbox_11"),
        Description = "Elektrisk motor till elbilar.",
    },
    ev_battery = {
        Label = "Elbatteri",
        Weight = 1.0,
        Model = GetHashKey("prop_battery_01"),
        Description = "Batteri för eldrivna fordon.",
    },
    ev_coolant = {
        Label = "Kylvätska",
        Weight = 1.0,
        Model = GetHashKey("prop_wheel_rim_02"),
        Description = "Kylsystemets vätska för elbilar.",
    },
    dirty_sponge = {
        Label = "Smutsig tvättsvamp",
        Weight = 0.6,
        Model = GetHashKey("prop_sponge_01"),
        Description = "En smutsig tvättsvamp som är förbrukad"
    },
    rizla = {
        Label = "Rullpapper",
        Weight = 0.2,
        Model = GetHashKey("p_cs_papers_03"),
        Description = {
            {
                Title = "",
                Text = "Cigarettpapper avsett att rulla egna cigaretter med."
            },
            {
                Title = "Papper:",
                Text = "10st"
            }
        }
    },
    repairkit = {
        Label = "Reperationskit",
        Weight = 1.0,
        Description = {
            {
                Title = "",
                Text = "Ett reperaktionskit till fordon"
            },
            {
                Title = "Förbrukningar:",
                Text = "2st"
            }
        },
        Model = GetHashKey("ch_prop_toolbox_01a"),
        DefaultMetaData = {
            Uses = 2
        },
        UseButton = "Använd",
        UseCallback = function(character, itemData, inventoryName)
            character.triggerEvent("x-useables:useItem", "Repairkit", itemData, inventoryName)
        end
    },
    pepperspray = {
        Label = "Pepparsprej",
        Weight = 0.3,
        Description = "Pepparsprej (ibland stavat -spray), även kallat OC-sprej (Oleoresin Capsicum) är ett icke-dödande naturligt ämne som vanligtvis används av polisen, militärpolisen, tullen och kriminalvården vid upplopp, självförsvar och vid användande av våld i laga befogenhet.",
        Model = GetHashKey("w_am_flare"),
        UseButton = "ANVÄND",
        UseCallback = function(character)
            character.triggerEvent("pepperspray:Togglepepperspray")
        end
    },
    amulet = {
        Label = "Amulett",
        Weight = 0.3,
        Model = GetHashKey("p_jewel_necklace_02")
    },
    teddy = {
        Label = "Teddybjörn",
        Weight = 0.5,
        Model = GetHashKey("v_ilev_mr_rasberryclean")
    },
    metal_detector = {
        Label = "Metall Detektor",
        Weight = 1.0,
        Model = GetHashKey("w_am_metaldetector"),
        UseButton = "STARTA",
        UseCallback = function(character)
            character.triggerEvent("x-treasures:useDetector")
        end
    },
    hair_tie = {
        Label = "Hårsnodd",
        Weight = 0.01,
        Model = GetHashKey("prop_ld_cable_tie_01"),
        UseButton = "ANVÄND",
        UseCallback = function(character)
            character.triggerEvent("x-clothingshop:hairTieUsed")
        end
    },
    jewelery_box = {
        Label = "Smyckeslåda",
        Weight = 0.5,
        Model = GetHashKey("hei_prop_heist_deposit_box")
    },
    bulletproof_vest = {
        Label = "Skottsäkerväst",
        Description = {
            {
                Title = "",
                Text = "Skyddsväst som uppfyller kraven för US NIJ0101.06. level IIIA samt extra keramiska plattor, när plattorna används tillsammans med västen så uppfyller produkten kraven för NIJ Level III."
            }
        },
        Weight = 2,
        Model = GetHashKey("prop_bodyarmour_02"),
        UseButton = "ANVÄND",
        UseCallback = function(character, itemData, inventoryName)
            local removed = exports["x-inventory"]:RemoveInventoryItem(character, {
                Item = itemData,
                Inventory = inventoryName
            })
            if removed then
                character.triggerEvent("x-damagesystem:applyVest")
            end
        end
    },
    map = {
        Label = "Karta",
        Description = {
            {
                Title = "",
                Text = "En karta som kan hjälpa dig att navigera."
            }
        },
        Weight = 0.1,
        Model = GetHashKey("prop_tourist_map_01"),
        UseButton = "LÄS AV",
        UseCallback = function(character)
            character.triggerEvent("x-hud:gpsActivated")
        end
    },
    airpods = {
        Label = "Airpods Pro",
        Weight = 0.5,
        Description = "Airpods Pro från Apple.",
        Model = GetHashKey("prop_airpods")
    },
    hacking_kit_atm = {
        Label = "Hackningskit Bankomat",
        Description = {
            {
                Title = "",
                Text = "Ett kit för att hacka bankomater."
            }
        },
        Weight = 0.5,
        Model = GetHashKey("hei_prop_heist_card_hack")
    },
    hacking_kit_vehicle = {
        Label = "Hackningskit Fordon",
        Description = {
            {
                Title = "",
                Text = "Ett kit för att hacka fordon."
            }
        },
        Weight = 0.5,
        Model = GetHashKey("hei_prop_heist_card_hack")
    },
    spray_can = {
        Label = "Sprejburk",
        Description = {
            {
                Title = "",
                Text = "En burk som du kan använda för att göra en grafitti."
            }
        },
        Weight = 0.6,
        Model = GetHashKey("prop_cs_spray_can"),
        UseButton = "Spreja",
        UseCallback = function(character)
            character.triggerEvent("x-spraycan:useSprayCan")
        end
    },
    spray_remover = {
        Label = "Klotterborttagare",
        Description = {
            {
                Title = "",
                Text = "Tar bort graffiti från alla grova ytor såsom tegel, betong, puts mm"
            }
        },
        Weight = 0.6,
        Model = GetHashKey("p_loose_rag_01_s"),
        UseButton = "Använd",
        UseCallback = function(character)
            character.triggerEvent("x-spraycan:removeClosestSpray")
        end
    },
    evidence_bag = {
        Label = "Bevispåse",
        Description = {
            {
                Title = "Innehåll:",
                Text = "Tom"
            }
        },
        Weight = 0.1,
        Model = GetHashKey("prop_paper_bag_small"),
        UseButton = "ÖPPNA",
        UseCallback = function(character, itemData, inventoryName)
            character.triggerEvent("x-inventory:openEvidenceBag", itemData, inventoryName)
        end
    },
    evidence = {
        Label = "Bevis",
        Weight = 0.1,
        Model = GetHashKey("prop_paper_bag_small")
    },
    metal = {
        Label = "Metall",
        Description = "Metall, används för att tillverka något.",
        Weight = 0.1,
        Stackable = true,
        Model = GetHashKey("ch_prop_gold_bar_01a")
    },
    gunpowder = {
        Label = "Krut",
        Description = "Krut, används för att tillverka något.",
        Weight = 0.1,
        Stackable = true,
        Model = GetHashKey("ch_prop_gold_bar_01a")
    },
    technical_part = {
        Label = "Teknikdel",
        Description = "Teknikdel, används för att tillverka något.",
        Weight = 0.1,
        Stackable = true,
        Model = GetHashKey("hei_prop_heist_card_hack_02")
    },
    kevlar_part = {
        Label = "Kevlardel",
        Description = "Kevlardel, används för att tillverka något.",
        Weight = 0.1,
        Stackable = true,
        Model = GetHashKey("prop_bodyarmour_03")
    },
    plastic = {
        Label = "Plastbit",
        Description = "En Vacker Plastbit.",
        Weight = 0.1,
        Stackable = true,
        Model = GetHashKey("apa_prop_cs_plastic_cup_01")
    },
    steel_part = {
        Label = "Stålbit",
        Description = "En Vacker Stålbit.",
        Weight = 0.5,
        Stackable = true,
        Model = GetHashKey("ch_prop_gold_bar_01a")
    },
    lightweightvest = {
        Label = "Tunn väst",
        Description = "En tunn väst för att försvara dig mot penetration.",
        Weight = 0.2,
        Stackable = true,
        Model = GetHashKey("prop_bodyarmour_03"),
        UseButton = "ANVÄND",
        UseCallback = function(character, itemData, inventoryName)
            character.triggerEvent("x-useables:useItem", "lightweightvest", itemData, inventoryName)
        end
    },
    thermite = {
        Label = "Termit",
        Description = "Termit är en blandning av aluminium och olika metalloxider. Vid antändning startar en reaktion där aluminiumet oxideras och metalloxiden reduceras, och stora mängder värme avges.",
        Weight = 0.8,
        Model = GetHashKey("hei_prop_heist_thermite_flash")
    },
    gold_bar = {
        Label = "Guldtacka",
        Description = "En guldtacka är ett massivt gjutet stycke guld.",
        Weight = 2.0,
        Model = GetHashKey("ch_prop_gold_bar_01a")
    },
    weapon_crafting_kit = {
        Label = "Vapenvård & montering kit",
        Weight = 1,
        Description = "Ett kit för att montera ihop vapen samt vårda dem!",
    },
    ws = {
        Label = "Vapenvård & montering kit",
        Weight = 1,
        Description = "Ett kit för att montera ihop vapen samt vårda dem!",
    },
    draco_pipe = {
        Label = "AKMS Pipa",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    draco_body = {
        Label = "AKMS kropp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    draco_spring = {
        Label = "AKMS fjäder",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    draco_pistol_grip = {
        Label = "AKMS grepp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    pistol_mantle = {
        Label = "Colt M1911 mantel",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    pistol_pipe = {
        Label = "Colt M1911 pipa",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    revolver_pipe = {
        Label = "Python Magnum .357 pipa",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    revolver_grip = {
        Label = "Python Magnum .357 grepp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    revolver_mantle = {
        Label = "Python Magnum .357 cylinder",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    revolver_spring = {
        Label = "Python Magnum .357 fjäder",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    doubleaction_pipe = {
        Label = "S&W Modell 19 pipa",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    doubleaction_grip = {
        Label = "S&W Modell 19 grepp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    doubleaction_mantle = {
        Label = "S&W Modell 19 cylinder",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    doubleaction_spring = {
        Label = "S&W Modell 19 fjäder",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    pistol_grip = {
        Label = "Colt M1911 grepp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    pistol_spring = {
        Label = "Colt M1911 fjäder",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    heavy_mantle = {
        Label = "EWB 1911 mantel",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    heavy_pipe = {
        Label = "EWB 1911 pipa",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    heavy_spring = {
        Label = "EWB 1911 fjäder",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    heavy_grip = {
        Label = "EWB 1911 grepp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    pistolmk2_mantle = {
        Label = "Glock-17 mantel",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    pistolmk2_pipe = {
        Label = "Glock-17 pipa",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    pistolmk2_spring = {
        Label = "Glock-17 fjäder",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    pistolmk2_grip = {
        Label = "Glock-17 grepp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    sns_mantle = {
        Label = "Makarov mantel",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    sns_pipe = {
        Label = "Makarov pipa",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    sns_spring = {
        Label = "Makarov fjäder",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    sns_grip = {
        Label = "Makarov grepp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    vintage_grip = {
        Label = "Tokarev TT-33 grepp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    vintage_spring = {
        Label = "Tokarev TT-33 fjäder",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    vintage_pipe = {
        Label = "Tokarev TT-33 pipa",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    vintage_mantle = {
        Label = "Tokarev TT-33 mantel",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    tec9_body = {
        Label = "Tec-9 kropp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    tec9_pipe = {
        Label = "Tec-9 pipa",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    tec9_spring = {
        Label = "Tec-9 fjäder",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    tec9_pistol_grip = {
        Label = "Tec-9 pistolgrepp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    mp40_pipe = {
        Label = "MP 40 pipa",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    mp40_body = {
        Label = "MP 40 kropp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    mp40_spring = {
        Label = "MP 40 fjäder",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    mp40_pistol_grip = {
        Label = "MP 40 pistolgrepp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    m4a1_spring = {
        Label = "M4A1 fjäder",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    m4a1_pistol_grip = {
        Label = "M4A1 grepp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    m4a1_body = {
        Label = "M4A1 kropp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    m4a1_pipe = {
        Label = "M4A1 pipa",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    ak15_pipe = {
        Label = "AK-15 pipa",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    ak15_body = {
        Label = "AK-15 kropp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    ak15_pistol_grip = {
        Label = "AK-15 grepp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    ak15_spring = {
        Label = "AK-15 fjäder",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    ak47_pipe = {
        Label = "AK-47 pipa",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    ak47_body = {
        Label = "AK-47 kropp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    ak47_spring = {
        Label = "AK-47 fjäder",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    ak47_pistol_grip = {
        Label = "AK-47 grepp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    specialcarbine_pistol_grip = {
        Label = "FN FAL grepp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    specialcarbine_spring = {
        Label = "FN FAL fjäder",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    specialcarbine_body = {
        Label = "FN FAL kropp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    specialcarbine_pipe = {
        Label = "FN FAL pipa",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    uzi_spring = {
        Label = "Uzi fjäder",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    uzi_body = {
        Label = "Uzi kropp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    uzi_pipe = {
        Label = "Uzi pipa",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    uzi_pistol_grip = {
        Label = "Uzi grepp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    scorpion_spring = {
        Label = "Scorpion fjäder",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    scorpion_body = {
        Label = "Scorpion kropp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    scorpion_pipe = {
        Label = "Scorpion pipa",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    scorpion_pistol_grip = {
        Label = "Scorpion grepp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    combatpdw_pistol_grip = {
        Label = "AS val grepp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    combatpdw_pipe = {
        Label = "AS val pipa",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    combatpdw_body = {
        Label = "AS val kropp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    combatpdw_spring = {
        Label = "AS val fjäder",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    db_spring = {
        Label = "Zabala fjäder",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    db_body = {
        Label = "Zabala kropp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    db_pistol_grip = {
        Label = "Zabala grepp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    db_pipe = {
        Label = "Zabala pipa",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    sawedoff_spring = {
        Label = "Ithaca fjäder",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    sawedoff_body = {
        Label = "Ithaca kropp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    sawedoff_pipe = {
        Label = "Ithaca pipa",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    sawedoff_pistol_grip = {
        Label = "Ithaca grepp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    pistol50_mantle = {
        Label = "Deserteagle mantel",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    pistol50_pipe = {
        Label = "Deserteagle pipa",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    pistol50_spring = {
        Label = "Deserteagle fjäder",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    pistol50_grip = {
        Label = "Deserteagle pistol grepp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    pistol50_print = {
        Label = "Desert Eagle vapenskiss",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    dildosaurus = {
        Label = "dildosaurus",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    heavypistol_print = {
        Label = "EWB 1911 vapenskiss",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    revolver_print = {
        Label = "Python Magnum .357 vapenskiss",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    doubleaction_print = {
        Label = "S&W Modell 19 vapenskiss",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    snspistol_print = {
        Label = "Makarov vapenskiss",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    pistol_print = {
        Label = "Colt M1911 vapenskiss",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    vintagepistol_print = {
        Label = "Tokarev TT-33 vapenskiss",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    pistolmk2_print = {
        Label = "Glock-17 vapenskiss",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    ak47_print = {
        Label = "AK-47 vapenskiss",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    specialcarbine_print = {
        Label = "FN FAL vapenskiss",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    ak15_print = {
        Label = "AK-15 vapenskiss",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    m4a1_print = {
        Label = "M4a1 vapenskiss",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    draco_print = {
        Label = "AKMS vapenskiss",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    tec9_print = {
        Label = "Tec-9 vapenskiss",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    mp40_print = {
        Label = "MP 40 vapenskiss",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    scorpion_print = {
        Label = "Scorpion VZ.61 vapenskiss",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    combatpdw_print = {
        Label = "AS val vapenskiss",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    uzi_print = {
        Label = "Uzi vapenskiss",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    sawedoff_print = {
        Label = "Ithaca 37 vapenskiss",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    db_print = {
        Label = "Zabala vapenskiss",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    knife = {
        Label = "Kniv",
        Weight = 0.5,
        Description = "En vass kniv.",
        Model = GetHashKey("prop_w_me_knife_01")
    },
    nightstick = {
        Label = "ASP Batong",
        Weight = 0.3,
        Description = "En batong att klubba ner busar med.",
        Model = GetHashKey("w_me_nightstick")
    },
    hammer = {
        Label = "Hammare",
        Weight = 0.5,
        Description = "En hammare.",
        Model = GetHashKey("w_me_hammer")
    },
    bat = {
        Label = "Basebollträ",
        Weight = 2,
        Description = "Används vid utövande av sport eller vid misshandel.",
        Model = GetHashKey("p_cs_bbbat_01")
    },
    bbqfork = {
        Label = "BBQ Gaffel",
        Weight = 1,
        Description = "Används vid utövande av grillning & matlagning.",
        Model = GetHashKey("w_me_dagger")
    },
    lapalina = {
        Label = "La Palina ",
        Weight = 0.01 * 20,
        Description = {
            {
                Title = "",
                Text = "La Palina är ett amerikanskt cigarrmärke som har en betydande plats i radions och reklamhistorien."
            }
        },
        PropAnimation = "cigar",
        Model = GetHashKey("sf_prop_sf_box_cigar_01a")
    },
    golfclub = {
        Label = "Golfklubba",
        Weight = 0.7,
        Description = "Används vid utövande av sport eller vid misshandel.",
        Model = GetHashKey("prop_golf_iron_01")
    },
    crowbar = {
        Label = "Kofot",
        Weight = 3,
        Description = "En kofot som går att använda.",
        Model = GetHashKey("prop_ing_crowbar"),
        DefaultMetaData = {
            Durability = 100
        },
        UseButton = "ANVÄND",
        UseCallback = function(character, itemData)
            exports["x-houserobbery"]:UseLockpick(character.source, itemData)
        end
    },
    pistol = {
        Label = "Colt M1911",
        Weight = 1,
        Model = GetHashKey("w_pi_pistol")
    },
    pistol_mk2 = {
        Label = "Glock-17",
        Weight = 1,
        Model = GetHashKey("w_pi_pistolmk2")
    },
    combatpistol = {
        Label = "Sig sauer p226",
        Weight = 1.5,
        Model = GetHashKey("w_pi_combatpistol")
    },
    appistol = {
        Label = "Colt SCAMP",
        Weight = 1
    },
    pistol50 = {
        Label = "Desert Eagle",
        Weight = 1.5,
        Model = GetHashKey("w_pi_pistol50")
    },
    microsmg = {
        Label = "B&T MP9",
        Weight = 3,
        Model = GetHashKey("w_sb_microsmg")
    },
    smg = {
        Label = "MP5A3",
        Weight = 3,
        Model = GetHashKey("w_sb_smg")
    },
    assaultsmg = {
        Label = "MP 40",
        Weight = 3,
        Model = GetHashKey("w_sb_assaultsmg")
    },
    assaultrifle = {
        Label = "AK-47",
        Weight = 4,
        Model = GetHashKey("w_ar_assaultrifle")
    },
    assaultrifle_mk2 = {
        Label = "AK-15",
        Weight = 4,
        Model = GetHashKey("w_ar_assaultriflemk2")
    },
    carbinerifle = {
        Label = "M4A1",
        Weight = 4,
        Model = GetHashKey("w_ar_carbinerifle")
    },
    advancedrifle = {
        Label = "CTAR-21",
        Weight = 4
    },
    mg = {
        Label = "PKP Pecheneg",
        Weight = 4
    },
    combatmg = {
        Label = "M249E1",
        Weight = 4
    },
    pumpshotgun = {
        Label = "Remington 870",
        Weight = 4,
        Model = GetHashKey("w_sg_pumpshotgun")
    },
    sawnoffshotgun = {
        Label = "Ithaca 37",
        Weight = 4,
        Model = GetHashKey("w_sg_sawnoff")
    },
    assaultshotgun = {
        Label = "UTAS UTS-15",
        Weight = 4
    },
    bullpupshotgun = {
        Label = "Kel-Tec KSG",
        Weight = 4
    },
    stungun = {
        Label = "X26 Taser",
        Weight = 0.5,
        Model = GetHashKey("w_pi_stungun")
    },
    sniperrifle = {
        Label = "PSG-1",
        Weight = 18.0
    },
    heavysniper = {
        Label = "M107",
        Weight = 23
    },
    remotesniper = {
        Label = "Remote Sniper",
        Weight = 23
    },
    grenadelauncher = {
        Label = "Milkor MGL",
        Weight = 100000
    },
    rpg = {
        Label = "RPG-7",
        Weight = 100000
    },
    stinger = {
        Label = "stinger",
        Weight = 1
    },
    minigun = {
        Label = "minigun",
        Weight = 1
    },
    grenade = {
        Label = "SYN-TAX Granat",
        Weight = 0.2,
        Model = 0x93E220BD
    },
    stickybomb = {
        Label = "SYN-TAX C4",
        Weight = 0.5,
        Model = 0x2C3731D9
    },
    smokegrenade = {
        Label = "smokegrenade",
        Weight = 0.5,
        Model = 0xFDBC8A50
    },
    bzgas = {
        Label = "bzgas",
        Weight = 0.5,
        Model = 0xA0973D5E
    },
    molotov = {
        Label = "Molotov Cocktail",
        Weight = 0.2,
        Model = GetHashKey("w_ex_molotov")
    },
    fireextinguisher = {
        Label = "Brandsläckare",
        Description = "En pulversläckare.",
        Weight = 4,
        Model = 0x60EC506
    },
    petrolcan = {
        Label = "Bränsledunk",
        Model = 0x34A67B97,
        Weight = 5,
        Description = {
            {
                Title = "",
                Text = "Du kan fylla denna med bränsle."
            },
            {
                Title = "Liter:",
                Text = "10 L"
            }
        },
        DefaultMetaData = {
            Liters = 10
        }
    },
    digiscanner = {
        Label = "digiscanner",
        Weight = 2
    },
    ball = {
        Label = "Tennis Boll",
        Description = "Nånting som hunden kan tugga på.",
        Weight = 0.05
    },
    snspistol = {
        Label = "H&K P7",
        Weight = 2,
        Model = GetHashKey("prop_box_guncase_02a")
    },
    bottle = {
        Label = "Trasig Glasflaska",
        Description = "En trasig glasflaska du kan använda som tillhygge.",
        Weight = 0.4,
        Model = GetHashKey("w_me_bottle")
    },
    gusenberg = {
        Label = "M1928A1 Thompson SMG",
        Weight = 2
    },
    specialcarbine = {
        Label = "FN FAL",
        Weight = 4,
        Model = GetHashKey("w_ar_specialcarbine")
    },
    heavypistol = {
        Label = "EWB 1911",
        Weight = 2,
        Model = GetHashKey("w_pi_heavypistol")
    },
    bullpuprifle = {
        Label = "Type 86-S",
        Weight = 2
    },
    dagger = {
        Label = "Jaktkniv",
        Weight = 1,
        Model = GetHashKey("prop_w_me_dagger")
    },
    vintagepistol = {
        Label = "Tokarev TT-33",
        Model = GetHashKey("w_pi_vintage_pistol"),
        Weight = 0.7
    },
    firework = {
        Label = "Firework",
        Weight = 2
    },
    musket = {
        Label = "Brown Bess",
        Weight = 2,
        Model = 0xA89CB99E
    },
    heavyshotgun = {
        Label = "Saiga-12K",
        Weight = 2
    },
    marksmanrifle = {
        Label = "M39 EMR",
        Weight = 2
    },
    hominglauncher = {
        Label = "SA-7 Grail",
        Weight = 2
    },
    proxmine = {
        Label = "Proxmine Mine",
        Weight = 2
    },
    snowball = {
        Label = "Snöboll",
        Weight = 2,
        Model = 0x787F0BB
    },
    flaregun = {
        Label = "Signalpistol",
        Weight = 2,
        Model = 0x47757124
    },
    garbagebag = {
        Label = "Soppåse",
        Weight = 5
    },
    handcuffs = {
        Label = "Handfängsel",
        Weight = 0.4
    },
    combatpdw = {
        Label = "AS VAL",
        Weight = 2,
        model = GetHashKey("w_sb_pdw")
    },
    marksmanpistol = {
        Label = "Thompson-Center Contender G2",
        Weight = 2
    },
    knuckle = {
        Label = "Knogjärn",
        Weight = 0.4,
        Description = "Knogjärn är ett enkelt vapen som består av en rad tjocka metallringar som sitter fast i varandra och som träs över fingrarna för att skydda handen och ge tyngd i slagen..",
        Model = GetHashKey("prop_box_guncase_01a")
    },
    hatchet = {
        Label = "Yxa",
        Description = "En yxa.",
        Weight = 3,
        Model = 0xF9DCBF2D
    },
    railgun = {
        Label = "Railgun",
        Weight = 1
    },
    machete = {
        Label = "Machete",
        Weight = 1,
        Model = 0xDD5DF8D9
    },
    machinepistol = {
        Label = "TEC-9",
        Weight = 2,
        Model = GetHashKey("w_sb_compactsmg2")
    },
    switchblade = {
        Label = "Fällkniv",
        Weight = 0.5,
        Description = "En vass kniv.",
        Model = GetHashKey("prop_w_me_knife_01")
    },
    revolver = {
        Label = "Taurus Raging Bull",
        Weight = 2,
        Model = GetHashKey("w_pi_revolver2")
    },
    dbshotgun = {
        Label = "Zabala Short-Barreled Shotgun",
        Weight = 2,
        Model = GetHashKey("w_sg_doublebarrel3")
    },
    compactrifle = {
        Label = "AKMS",
        Weight = 2,
        Model = GetHashKey("w_ar_assaultrifle_smg")
    },
    autoshotgun = {
        Label = "AA-12",
        Weight = 2
    },
    battleaxe = {
        Label = "Krigsyxa",
        Weight = 3,
        Model = 0xCD274149
    },
    compactlauncher = {
        Label = "M79 GL",
        Weight = 2,
        Description = {
            {
                Title = "",
                Text = "Fokusgrupper som använde den vanliga modellen föreslog att den var för exakt och tyckte att det var besvärligt att använda med en hand på gasen. Enkel fix."
            }
        }
    },
    minismg = {
        Label = "Skorpion Vz. 61",
        Weight = 3,
        Model = GetHashKey("w_sb_minismg2")
    },
    pipebomb = {
        Label = "SYN-TAX PIPE",
        Weight = 0.5,
        Model = 0xBA45E8B8
    },
    poolcue = {
        Label = "Biljardkö",
        Description = "Används vid utövande av sport eller vid misshandel.",
        Weight = 1,
        Model = 0x94117305
    },
    wrench = {
        Label = "Rörtång",
        Description = "Används vid utövande av arbete eller vid misshandel.",
        Weight = 2,
        Model = 0x19044EE0
    },
    flashlight = {
        Label = "Ficklampa",
        Weight = 1,
        Model = 0x8BB05FD7
    },
    parachute = {
        Label = "Fallskärm",
        Weight = 4,
        Model = 0xFBAB5776
    },
    flare = {
        Label = "Flare",
        Weight = 1,
        Model = 0x497FACC3
    },
    doubleaction = {
        Label = "S&W Modell-19",
        Weight = 2,
        Model = GetHashKey("w_pi_wep1_gun2")
    },
    pistol_ammo_box = {
        Label = "Pistol Skottlåda",
        Weight = 5,
        Stackable = true,
        Description = "En låda med 24 st 9mm skott inuti.",
        Model = GetHashKey("prop_ld_ammo_pack_01")
    },
    pistol_ammo = {
        Label = "Pistolammunition",
        Weight = 0.05,
        Stackable = true,
        Description = "9mm kula.",
        Model = GetHashKey("w_pi_sns_pistol_mag1")
    },
    smg_ammo_box = {
        Label = "SMG Skottlåda",
        Weight = 5,
        Stackable = true,
        Model = GetHashKey("prop_ld_ammo_pack_01")
    },
    smg_ammo = {
        Label = "Smgammunition",
        Weight = 0.05,
        Stackable = true,
        Model = GetHashKey("w_sb_compactsmg_mag2")
    },
    rifle_ammo_box = {
        Label = "Rifle Skottlåda",
        Weight = 5,
        Stackable = true,
        Model = GetHashKey("prop_ld_ammo_pack_01")
    },
    rifle_ammo = {
        Label = "Rifleammunition",
        Weight = 0.05,
        Stackable = true,
        Model = GetHashKey("w_ar_assaultrifle_mag1")
    },
    shotgun_ammo_box = {
        Label = "Shotgun Skottlåda",
        Weight = 5,
        Stackable = true
    },
    shotgun_ammo = {
        Label = "Hagelpatron",
        Description = "Hagelammunition är en patrontyp för eldvapen som skjuter flera mindre projektiler i en konformation framför eldrörets mynning, så kallat hagel.",
        Weight = 0.1,
        Stackable = true,
        Model = GetHashKey("w_sg_pumpshotgunmk2_mag1")
    },
    sniper_ammo = {
        Label = ".308 Winchester",
        Weight = 0.1,
        Stackable = true
    },
    sniper_ammo_box = {
        Label = "Sniper Skottlåda",
        Weight = 0.1 * 16,
        Stackable = false
    },
    weapon_silencer = {
        Label = "Ljuddämpare",
        Weight = 0.2,
        Description = "En ljuddämpare, dämpare eller ljudmoderator, är en munstycksanordning som minskar den akustiska intensiteten i nosrapporten och rekylen när en pistol släpps ut.",
        Model = GetHashKey("v_ilev_gunhook"),
        UseButton = "APPLICERA",
        UseCallback = function(character, itemData)
            character.triggerEvent("x-weaponsync:applyAttachment", itemData)
        end
    },
    weapon_extended_mag = {
        Label = "Utökat Magasin",
        Weight = 0.2,
        Description = "Utökade magasin, ofta kända som magasin med hög kapacitet eller magasiner med stor kapacitet, är ett tillbehör som kan läggas till skjutvapen så att de bär fler kulor.",
        Model = GetHashKey("prop_ld_ammo_pack_03"),
        UseButton = "APPLICERA",
        UseCallback = function(character, itemData)
            character.triggerEvent("x-weaponsync:applyAttachment", itemData)
        end
    },
    weapon_flashlight = {
        Label = "Ficklampa tillsats",
        Weight = 0.5,
        Description = "En ljuddämpare, dämpare eller ljudmoderator, är en munstycksanordning som minskar den akustiska intensiteten i nosrapporten och rekylen när en pistol släpps ut.",
        Model = GetHashKey("v_ilev_gunhook"),
        UseButton = "APPLICERA",
        UseCallback = function(character, itemData)
            character.triggerEvent("x-weaponsync:applyAttachment", itemData)
        end
    },
    weapon_scope = {
        Label = "Sikte tillsats",
        Weight = 0.5,
        Description = "Ett sikte till flertalet lika vapen",
        Model = GetHashKey("v_ilev_gunhook"),
        UseButton = "APPLICERA",
        UseCallback = function(character, itemData)
            character.triggerEvent("x-weaponsync:applyAttachment", itemData)
        end
    },
    drug_package = {
        Label = "Inlindat paket",
        Weight = 1.0,
        Description = "Ett paket med okända substanser, hacka upp paketet för att se innehållet.",
        UseButton = "Hacka upp",
        UseCallback = function(character, itemData)
            character.triggerEvent("x-cayoperico:drugPackageItemUse", itemData)
        end
    },
    weapon_part_package = {
        Label = "Robust låda",
        Weight = 1.0,
        Description = "En låda med okänt innehåll, öppna upp och ta reda på vad den innehåller..",
        UseButton = "öppna",
        UseCallback = function(character, itemData)
            character.triggerEvent("x-weaponcrafting:weaponPartPackageItemUse", itemData)
        end
    },
    weapon_skin = {
        Label = "Guldplattering för vapen",
        Weight = 0.5,
        Description = "För dem riktiga mexikanska gangstersen.",
        Model = GetHashKey("v_ilev_gunhook"),
        UseButton = "APPLICERA",
        UseCallback = function(character, itemData)
            character.triggerEvent("x-weaponsync:applyAttachment", itemData)
        end
    },
    weapon_grip = {
        Label = "Grip",
        Weight = 0.8,
        Description = "På ett skjutvapen eller andra verktyg är ett pistolgrepp ett tydligt utskjutande handtag under huvudmekanismen som ska hållas av användarens hand i en mer vertikal vinkel, liknande den som man skulle hålla en konventionell pistol.",
        UseButton = "APPLICERA",
        UseCallback = function(character, itemData)
            character.triggerEvent("x-weaponsync:applyAttachment", itemData)
        end
    },
    tequila = {
        Label = "Tequila",
        Weight = 0.200,
        Description = "",
        UseButton = "Drick",
        UseCallback = function(character, itemData, inventoryName)
            TriggerEvent("my_resource:drinkTequila", source)
        end,
        Model = GetHashKey("prop_tequila")
    },
    vodka = {
        Label = "Vodka Shot",
        Weight = 0.200,
        Description = "",
        UseButton = "Drick",
        UseCallback = function(character, itemData, inventoryName)
            TriggerEvent("my_resource:drinkVodka", source)
        end,
        Model = GetHashKey("p_cs_shot_glass_2_s")
    },
    daiquiri = {
        Label = "Daiquiri",
        Weight = 0.200,
        Description = "",
        UseButton = "Drick",
        UseCallback = function(character, itemData, inventoryName)
            TriggerEvent("my_resource:drinkDaiquiri", source)
        end,
        Model = GetHashKey("prop_tequila")
    },
    mojito = {
        Label = "Mojito",
        Weight = 0.200,
        Description = "",
        UseButton = "Drick",
        UseCallback = function(character, itemData, inventoryName)
            TriggerEvent("my_resource:drinkMojito", source)
        end,
        Model = GetHashKey("prop_mojito")
    },
    pinacolada = {
        Label = "Pinacolada",
        Weight = 0.200,
        Description = "",
        UseButton = "Drick",
        UseCallback = function(character, itemData, inventoryName)
            TriggerEvent("my_resource:drinkPinacolada", source)
        end,
        Model = GetHashKey("prop_pinacolada")
    },
    sexonthebeach = {
        Label = "Sex on the beach",
        Weight = 0.200,
        Description = "",
        UseButton = "Drick",
        UseCallback = function(character, itemData, inventoryName)
            TriggerEvent("my_resource:drinkSexonthebeach", source)
        end,
        Model = GetHashKey("prop_brandy_glass")
    },
    racingtablet = {
        Label = "Racing Padda",
        Weight = 0.500,
        Description = "Ser ut att ha något med bilar att göra",
        Stackable = false,
        Model = GetHashKey("prop_cs_tablet"),
        UseButton = "Använd",
        UseCallback = function(character, itemData)
            character.triggerEvent("rahe-racing:client:openTablet", itemData)
        end,
    },
    handsprit = {
        Label = "Handsprit",
        Weight = 0.200,
        Description = "Används för att tvätta rent händerna",
        Stackable = false,
        UseButton = "Använd",
        UseCallback = function(character, itemData, inventoryName)
            local removed = RemoveInventoryItem(character, {
                Item = {
                    Name = itemData.Name,
                    Count = 1
                },
                Inventory = inventoryName
            })
            if not removed then return end
            TriggerClientEvent('smt:Killer', source)
        end,
    },
    drone_lspd = {
        Label = "Drönare",
        Weight = 0.500,
        Description = "En drönare som det står polis på",
        Stackable = false,
        UseButton = "Använd",
        UseCallback = function(character, itemData)
            character.triggerEvent("dz-drone:client:InitiateDroneLSPD", itemData)
        end,
    },
    binoculars = {
        Label = "Kikare",
        Weight = 0.3,
        Description = "En kikare för att kika på folk på avstånd.",
        UseButton = "ANVÄND",
        UseCallback = function(character, itemData)
            character.triggerEvent("x-binoculars:useBinoculars")
        end
    },
    koieventlapp = {
        Label = "Lapp",
        Weight = 0.3,
        Description = {
            {
                Title = "Lapp",
                Text = "Meet me at the Vinewood Radio Tower. I have a business proposal for you that could be highly profitable. But here's the deal: it's take it or leave it. No negotiations. The choice is yours."
            }
        },
    },
    halloween = {
        Label = "Halloweenmynt",
        Weight = 0.100,
        Stackable = true,
        Description = {
            {
                Title = "Mynt",
                Text = "Vad kan detta vara?"
            }
        },
    },
    shiv = {
        Label = "Shank",
        Weight = 1,
        Model = GetHashKey("w_me_shiv")
    },
    katana = {
        Label = "Katana",
        Weight = 1,
        Model = GetHashKey("w_me_katana")
    },
    sledgehammer = {
        Label = "Slägga",
        Weight = 1,
        Model = GetHashKey("w_me_sledgehammer")
    },
    bfknife = {
        Label = "Butterfly",
        Weight = 1,
        Model = GetHashKey("w_me_vanillabfknife_01")
    },
    bayonetknife = {
        Label = "Bajonett",
        Weight = 1,
        Model = GetHashKey("w_me_bayonetknife_01")
    },
    huntsmanknife = {
        Label = "Jägar Kniv",
        Weight = 1,
        Model = GetHashKey("w_me_huntsmanknife_01")
    },
    karambitknife = {
        Label = "Karambit",
        Weight = 1,
        Model = GetHashKey("w_me_karambitknife_01")
    },
    hk416 = {
        Label = "Heckler & Koch HK416",
        Weight = 1,
        Model = GetHashKey("w_ar_hk416")
    },
    fnx45 = {
        Label = "FN FNX",
        Weight = 1,
        Model = GetHashKey("w_pi_fnx45")
    },
    pistol_mk2pol = {
        Label = "Glock-17 Polis",
        Weight = 1,
        Model = GetHashKey("w_pi_pistolmk2pol")
    },
    pistol2 = {
        Label = "Colt M1911",
        Weight = 1,
        Model = GetHashKey("w_pi_pistol2")
    },
    pistol3 = {
        Label = "Colt M1911",
        Weight = 1,
        Model = GetHashKey("w_pi_pistol3")
    },
    pistol_mk22 = {
        Label = "Glock-17",
        Weight = 1,
        Model = GetHashKey("w_pi_pistolmk22")
    },
    pistol_mk23 = {
        Label = "Glock-17",
        Weight = 1,
        Model = GetHashKey("w_pi_pistolmk23")
    },
    pistol502 = {
        Label = "Desert Eagle",
        Weight = 1.5,
        Model = GetHashKey("w_pi_pistol502")
    },
    pistol503 = {
        Label = "Desert Eagle",
        Weight = 1.5,
        Model = GetHashKey("w_pi_pistol503")
    },
    assaultrifle2 = {
        Label = "AK-47",
        Weight = 1,
        Model = GetHashKey("w_ar_assaultrifle")
    },
    assaultrifle3 = {
        Label = "AK-47",
        Weight = 1,
        Model = GetHashKey("w_ar_assaultrifle")
    },
    assaultriflemk22 = {
        Label = "AK-15",
        Weight = 4,
        Model = GetHashKey("w_ar_assaultriflemk2")
    },
    assaultriflemk23 = {
        Label = "AK-15",
        Weight = 4,
        Model = GetHashKey("w_ar_assaultriflemk2")
    },
    assaultsmg2 = {
        Label = "MP 40",
        Weight = 3,
        Model = GetHashKey("w_sb_assaultsmg")
    },
    assaultsmg3 = {
        Label = "MP 40",
        Weight = 3,
        Model = GetHashKey("w_sb_assaultsmg")
    },
    combatpdw2 = {
        Label = "AS VAL",
        Weight = 2,
        model = GetHashKey("w_sb_pdw")
    },
    combatpdw3 = {
        Label = "AS VAL",
        Weight = 2,
        model = GetHashKey("w_sb_pdw")
    },
    compactrifle2 = {
        Label = "AKMS",
        Weight = 2,
        Model = GetHashKey("w_ar_assaultrifle_smg")
    },
    compactrifle3 = {
        Label = "AKMS",
        Weight = 2,
        Model = GetHashKey("w_ar_assaultrifle_smg")
    },
    dbshotgun2 = {
        Label = "Zabala Short-Barreled Shotgun",
        Weight = 2,
        Model = GetHashKey("w_sg_doublebarrel2")
    },
    dbshotgun3 = {
        Label = "Zabala Short-Barreled Shotgun",
        Weight = 2,
        Model = GetHashKey("w_sg_doublebarrel3")
    },
    doubleaction2 = {
        Label = "S&W Modell-19",
        Weight = 2,
        Model = GetHashKey("w_pi_wep1_gun2")
    },
    doubleaction3 = {
        Label = "S&W Modell-19",
        Weight = 2,
        Model = GetHashKey("w_pi_wep1_gun2")
    },
    heavypistol2 = {
        Label = "EWB 1911",
        Weight = 2,
        Model = GetHashKey("w_pi_heavypistol2")
    },
    heavypistol3 = {
        Label = "EWB 1911",
        Weight = 2,
        Model = GetHashKey("w_pi_heavypistol2")
    },
    machinepistol2 = {
        Label = "TEC-9",
        Weight = 2,
        Model = GetHashKey("w_sb_compactsmg2")
    },
    machinepistol3 = {
        Label = "TEC-9",
        Weight = 2,
        Model = GetHashKey("w_sb_compactsmg2")
    },
    microsmg2 = {
        Label = "B&T MP9",
        Weight = 3,
        Model = GetHashKey("w_sb_microsmg")
    },
    microsmg3 = {
        Label = "B&T MP9",
        Weight = 3,
        Model = GetHashKey("w_sb_microsmg")
    },
    minismg2 = {
        Label = "Skorpion Vz. 61",
        Weight = 3,
        Model = GetHashKey("w_sb_minismg2")
    },
    minismg3 = {
        Label = "Skorpion Vz. 61",
        Weight = 3,
        Model = GetHashKey("w_sb_minismg2")
    },
    revolver2 = {
        Label = "Taurus Raging Bull",
        Weight = 2,
        Model = GetHashKey("w_pi_revolver2")
    },
    revolver3 = {
        Label = "Taurus Raging Bull",
        Weight = 2,
        Model = GetHashKey("w_pi_revolver2")
    },
    sawnoffshotgun2 = {
        Label = "Ithaca 37",
        Weight = 4,
        Model = GetHashKey("w_sg_sawnoff")
    },
    sawnoffshotgun3 = {
        Label = "Ithaca 37",
        Weight = 4,
        Model = GetHashKey("w_sg_sawnoff")
    },
    snspistol2 = {
        Label = "H&K P7",
        Weight = 2,
        Model = GetHashKey("prop_box_guncase_02a")
    },
    snspistol3 = {
        Label = "H&K P7",
        Weight = 2,
        Model = GetHashKey("prop_box_guncase_02a")
    },
    specialcarbine2 = {
        Label = "FN FAL",
        Weight = 4,
        Model = GetHashKey("w_ar_specialcarbine2")
    },
    specialcarbine3 = {
        Label = "FN FAL",
        Weight = 4,
        Model = GetHashKey("w_ar_specialcarbine2")
    },
    vintagepistol2 = {
        Label = "Tokarev TT-33",
        Model = GetHashKey("w_pi_vintage_pistol"),
        Weight = 0.7
    },
    vintagepistol3 = {
        Label = "Tokarev TT-33",
        Model = GetHashKey("w_pi_vintage_pistol"),
        Weight = 0.7
    },
    draco_pipe2 = {
        Label = "AKMS Pipa",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    draco_body2 = {
        Label = "AKMS kropp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    draco_spring2 = {
        Label = "AKMS fjäder",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    draco_pistol_grip2 = {
        Label = "AKMS grepp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    pistol_mantle2 = {
        Label = "Colt M1911 mantel",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    pistol_pipe2 = {
        Label = "Colt M1911 pipa",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    pistol_grip2 = {
        Label = "Colt M1911 grepp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    pistol_spring2 = {
        Label = "Colt M1911 fjäder",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    revolver_pipe2 = {
        Label = "Python Magnum .357 pipa",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    revolver_grip2 = {
        Label = "Python Magnum .357 grepp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    revolver_mantle2 = {
        Label = "Python Magnum .357 cylinder",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    revolver_spring2 = {
        Label = "Python Magnum .357 fjäder",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    doubleaction_pipe2 = {
        Label = "S&W Modell 19 pipa",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    doubleaction_grip2 = {
        Label = "S&W Modell 19 grepp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    doubleaction_mantle2 = {
        Label = "S&W Modell 19 cylinder",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    doubleaction_spring2 = {
        Label = "S&W Modell 19 fjäder",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    heavy_mantle2 = {
        Label = "EWB 1911 mantel",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    heavy_pipe2 = {
        Label = "EWB 1911 pipa",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    heavy_spring2 = {
        Label = "EWB 1911 fjäder",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    heavy_grip2 = {
        Label = "EWB 1911 grepp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    pistolmk2_mantle2 = {
        Label = "Glock-17 mantel",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    pistolmk2_pipe2 = {
        Label = "Glock-17 pipa",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    pistolmk2_spring2 = {
        Label = "Glock-17 fjäder",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    pistolmk2_grip2 = {
        Label = "Glock-17 grepp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    sns_mantle2 = {
        Label = "Makarov mantel",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    sns_pipe2 = {
        Label = "Makarov pipa",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    sns_spring2 = {
        Label = "Makarov fjäder",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    sns_grip2 = {
        Label = "Makarov grepp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    vintage_grip2 = {
        Label = "Tokarev TT-33 grepp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    vintage_spring2 = {
        Label = "Tokarev TT-33 fjäder",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    vintage_pipe2 = {
        Label = "Tokarev TT-33 pipa",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    vintage_mantle2 = {
        Label = "Tokarev TT-33 mantel",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    tec9_body2 = {
        Label = "Tec-9 kropp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    tec9_pipe2 = {
        Label = "Tec-9 pipa",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    tec9_spring2 = {
        Label = "Tec-9 fjäder",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    tec9_pistol_grip2 = {
        Label = "Tec-9 pistolgrepp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    mp40_pipe2 = {
        Label = "MP 40 pipa",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    mp40_body2 = {
        Label = "MP 40 kropp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    mp40_spring2 = {
        Label = "MP 40 fjäder",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    mp40_pistol_grip2 = {
        Label = "MP 40 pistolgrepp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    m4a1_spring2 = {
        Label = "M4A1 fjäder",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    m4a1_pistol_grip2 = {
        Label = "M4A1 grepp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    m4a1_body2 = {
        Label = "M4A1 kropp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    m4a1_pipe2 = {
        Label = "M4A1 pipa",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    ak15_pipe2 = {
        Label = "AK-15 pipa",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    ak15_body2 = {
        Label = "AK-15 kropp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    ak15_pistol_grip2 = {
        Label = "AK-15 grepp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    ak15_spring2 = {
        Label = "AK-15 fjäder",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    ak47_pipe2 = {
        Label = "AK-47 pipa",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    ak47_body2 = {
        Label = "AK-47 kropp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    ak47_spring2 = {
        Label = "AK-47 fjäder",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    ak47_pistol_grip2 = {
        Label = "AK-47 grepp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    specialcarbine_pistol_grip2 = {
        Label = "FN FAL grepp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    specialcarbine_spring2 = {
        Label = "FN FAL fjäder",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    specialcarbine_body2 = {
        Label = "FN FAL kropp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    specialcarbine_pipe2 = {
        Label = "FN FAL pipa",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    uzi_spring2 = {
        Label = "Uzi fjäder",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    uzi_body2 = {
        Label = "Uzi kropp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    uzi_pipe2 = {
        Label = "Uzi pipa",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    uzi_pistol_grip2 = {
        Label = "Uzi grepp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    scorpion_spring2 = {
        Label = "Scorpion fjäder",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    scorpion_body2 = {
        Label = "Scorpion kropp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    scorpion_pipe2 = {
        Label = "Scorpion pipa",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    scorpion_pistol_grip2 = {
        Label = "Scorpion grepp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    combatpdw_pistol_grip2 = {
        Label = "AS val grepp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    combatpdw_pipe2 = {
        Label = "AS val pipa",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    combatpdw_body2 = {
        Label = "AS val kropp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    combatpdw_spring2 = {
        Label = "AS val fjäder",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    db_spring2 = {
        Label = "Zabala fjäder",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    db_body2 = {
        Label = "Zabala kropp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    db_pistol_grip2 = {
        Label = "Zabala grepp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    db_pipe2 = {
        Label = "Zabala pipa",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    sawedoff_spring2 = {
        Label = "Ithaca fjäder",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    sawedoff_body2 = {
        Label = "Ithaca kropp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    sawedoff_pipe2 = {
        Label = "Ithaca pipa",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    sawedoff_pistol_grip2 = {
        Label = "Ithaca grepp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    pistol50_mantle2 = {
        Label = "Deserteagle mantel",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    pistol50_pipe2 = {
        Label = "Deserteagle pipa",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    pistol50_spring2 = {
        Label = "Deserteagle fjäder",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    pistol50_grip2 = {
        Label = "Deserteagle pistol grepp",
        Stackable = true,
        Weight = 1,
        Model = GetHashKey("prop_tool_box_02")
    },
    pistol50_print2 = {
        Label = "Desert Eagle vapenskiss",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    heavypistol_print2 = {
        Label = "EWB 1911 vapenskiss",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    revolver_print2 = {
        Label = "Python Magnum .357 vapenskiss",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    doubleaction_print2 = {
        Label = "S&W Modell 19 vapenskiss",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    snspistol_print2 = {
        Label = "Makarov vapenskiss",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    pistol_print2 = {
        Label = "Colt M1911 vapenskiss",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    vintagepistol_print2 = {
        Label = "Tokarev TT-33 vapenskiss",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    pistolmk2_print2 = {
        Label = "Glock-17 vapenskiss",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    ak47_print2 = {
        Label = "AK-47 vapenskiss",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    specialcarbine_print2 = {
        Label = "FN FAL vapenskiss",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    ak15_print2 = {
        Label = "AK-15 vapenskiss",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    m4a1_print2 = {
        Label = "M4a1 vapenskiss",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    draco_print2 = {
        Label = "AKMS vapenskiss",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    tec9_print2 = {
        Label = "Tec-9 vapenskiss",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    mp40_print2 = {
        Label = "MP 40 vapenskiss",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    scorpion_print2 = {
        Label = "Scorpion VZ.61 vapenskiss",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    combatpdw_print2 = {
        Label = "AS val vapenskiss",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    uzi_print2 = {
        Label = "Uzi vapenskiss",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    sawedoff_print2 = {
        Label = "Ithaca 37 vapenskiss",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    db_print2 = {
        Label = "Zabala vapenskiss",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    pistol50_print3 = {
        Label = "Desert Eagle vapenskiss",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    heavypistol_print3 = {
        Label = "EWB 1911 vapenskiss",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    revolver_print3 = {
        Label = "Python Magnum .357 vapenskiss",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    doubleaction_print3 = {
        Label = "S&W Modell 19 vapenskiss",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    snspistol_print3 = {
        Label = "Makarov vapenskiss",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    pistol_print3 = {
        Label = "Colt M1911 vapenskiss",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    vintagepistol_print3 = {
        Label = "Tokarev TT-33 vapenskiss",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    pistolmk2_print3 = {
        Label = "Glock-17 vapenskiss",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    ak47_print3 = {
        Label = "AK-47 vapenskiss",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    specialcarbine_print3 = {
        Label = "FN FAL vapenskiss",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    ak15_print3 = {
        Label = "AK-15 vapenskiss",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    m4a1_print3 = {
        Label = "M4a1 vapenskiss",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    draco_print3 = {
        Label = "AKMS vapenskiss",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    tec9_print3 = {
        Label = "Tec-9 vapenskiss",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    mp40_print3 = {
        Label = "MP 40 vapenskiss",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    scorpion_print3 = {
        Label = "Scorpion VZ.61 vapenskiss",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    combatpdw_print3 = {
        Label = "AS val vapenskiss",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    uzi_print3 = {
        Label = "Uzi vapenskiss",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    sawedoff_print3 = {
        Label = "Ithaca 37 vapenskiss",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    db_print3 = {
        Label = "Zabala vapenskiss",
        Weight = 0.5,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    glass_cutter = {
        Label = "Glasskärare",
        Weight = 3,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    painting = {
        Label = "Tavla",
        Weight = 1,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    diamond = {
        Label = "Diamant",
        Weight = 1,
        Model = GetHashKey("prop_cd_folder_pile4")
    },
    cryptostick = {
        label = 'Crypto Stick',
        weight = 5,
        Model = GetHashKey("")
    },
    phone_dongle = {
        label = 'Phone Dongle',
        weight = 5,
        Model = GetHashKey("")
    },
    phone = {
        Label = "Mobiltelefon",
        Weight = 0.148,
        Stackable = false,
        Description = {
            {
                Title = "Modell:",
                Text = "Classic PearPhone"
            },
            {
                Title = "Skärmstorlek:",
                Text = "9 tum"
            }
        },
        Model = GetHashKey("ks_iphone_01")
    },
    black_phone = {
        Label = "Mobiltelefon",
        Weight = 0.148,
        Stackable = false,
        Description = {
            {
                Title = "Modell:",
                Text = "Black PearPhone"
            },
            {
                Title = "Skärmstorlek:",
                Text = "9 tum"
            }
        },
        Model = GetHashKey("ks_iphone_02")
    },
    yellow_phone = {
        Label = "Mobiltelefon",
        Weight = 0.148,
        Stackable = false,
        Description = {
            {
                Title = "Modell:",
                Text = "Yellow PearPhone"
            },
            {
                Title = "Skärmstorlek:",
                Text = "9 tum"
            }
        },
        Model = GetHashKey("ks_iphone_03")
    },
    red_phone = {
        Label = "Mobiltelefon",
        Weight = 0.148,
        Stackable = false,
        Description = {
            {
                Title = "Modell:",
                Text = "Red PearPhone"
            },
            {
                Title = "Skärmstorlek:",
                Text = "9 tum"
            }
        },
        Model = GetHashKey("ks_iphone_04")
    },
    green_phone = {
        Label = "Mobiltelefon",
        Weight = 0.148,
        Stackable = false,
        Description = {
            {
                Title = "Modell:",
                Text = "Green PearPhone"
            },
            {
                Title = "Skärmstorlek:",
                Text = "9 tum"
            }
        },
        Model = GetHashKey("ks_iphone_05")
    },
    white_phone = {
        Label = "Mobiltelefon",
        Weight = 0.148,
        Stackable = false,
        Description = {
            {
                Title = "Modell:",
                Text = "white PearPhone"
            },
            {
                Title = "Skärmstorlek:",
                Text = "9 tum"
            }
        },
        Model = GetHashKey("ks_iphone_06")
    },
}
