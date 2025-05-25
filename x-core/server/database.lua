local databaseTables = {
    [[
        CREATE DATABASE IF NOT EXISTS `x` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_bin */;
    ]],
    [[
        CREATE TABLE IF NOT EXISTS `x_characters` (
            `steamHex` varchar(50) COLLATE utf8mb4_bin NOT NULL,
            `characterId` varchar(50) COLLATE utf8mb4_bin NOT NULL,
            `firstname` varchar(150) COLLATE utf8mb4_bin NOT NULL,
            `lastname` varchar(150) COLLATE utf8mb4_bin NOT NULL,
            `dateofbirth` varchar(150) COLLATE utf8mb4_bin NOT NULL,
            `lastdigits` int(4) NOT NULL DEFAULT '0',
            `gender` varchar(1) COLLATE utf8mb4_bin NOT NULL DEFAULT 'M',
            `length` int(3) NOT NULL DEFAULT '0',
            `bloodType` char(2) COLLATE utf8mb4_bin NOT NULL DEFAULT 'A',
            `phoneNumber` varchar(50) COLLATE utf8mb4_bin NOT NULL DEFAULT '0',
            `position` longtext COLLATE utf8mb4_bin NOT NULL,
            `appearance` longtext COLLATE utf8mb4_bin NOT NULL,
            `cash` bigint(20) NOT NULL DEFAULT '0',
            `bank` bigint(20) NOT NULL DEFAULT '0',
            `job` varchar(50) COLLATE utf8mb4_bin NOT NULL DEFAULT 'unemployed',
            `jobGrade` tinyint(2) NOT NULL DEFAULT '1',
            `timePlayed` int(20) NOT NULL DEFAULT '0',
            `timeLocked` bigint(20) NOT NULL DEFAULT '0',
            `timeCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`characterId`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
    ]],
    [[
        CREATE TABLE IF NOT EXISTS `x_characters_bank_transactions` (
            `characterId` varchar(100) COLLATE utf8mb4_bin NOT NULL,
            `type` varchar(50) COLLATE utf8mb4_bin NOT NULL DEFAULT 'default',
            `description` text COLLATE utf8mb4_bin NOT NULL,
            `amount` int(100) NOT NULL DEFAULT '0',
            `occured` varchar(50) COLLATE utf8mb4_bin NOT NULL
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
    ]],
    [[
        CREATE TABLE IF NOT EXISTS `x_characters_discoveries` (
          `characterId` varchar(50) COLLATE utf8mb4_bin NOT NULL,
          `discovered` int(50) NOT NULL DEFAULT '0'
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
    ]],
    [[
        CREATE TABLE IF NOT EXISTS `x_characters_housings` (
          `houseUUID` varchar(165) COLLATE utf8mb4_bin NOT NULL,
          `houseIndex` int(5) NOT NULL,
          `houseData` longtext COLLATE utf8mb4_bin NOT NULL,
          PRIMARY KEY (`houseUUID`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
    ]],
    [[
        CREATE TABLE IF NOT EXISTS `x_characters_tattoos` (
          `characterId` varchar(50) COLLATE utf8mb4_bin NOT NULL,
          `tattoos` longtext COLLATE utf8mb4_bin NOT NULL,
          PRIMARY KEY (`characterId`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
    ]],
    [[
        CREATE TABLE IF NOT EXISTS `x_users` (
        `name` varchar(50) COLLATE utf8mb4_bin NOT NULL,
        `identifier` varchar(150) COLLATE utf8mb4_bin NOT NULL,
        `admin` smallint(1) NOT NULL DEFAULT '0',
        `license` varchar(150) COLLATE utf8mb4_bin NOT NULL,
        `ip` varchar(150) COLLATE utf8mb4_bin NOT NULL,
        `discord` varchar(150) COLLATE utf8mb4_bin NOT NULL,
        `timeCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
        `lastLogin` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        PRIMARY KEY (`identifier`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
    ]],
    [[
        CREATE TABLE IF NOT EXISTS `x_users_whitelist` (
            `steamHex` varchar(50) COLLATE utf8mb4_bin NOT NULL,
            `timeWhitelisted` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (`steamHex`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
    ]],
    [[
        CREATE TABLE IF NOT EXISTS `x_markets` (
            `uuid` varchar(155) COLLATE utf8mb4_bin NOT NULL,
            `marketName` varchar(155) COLLATE utf8mb4_bin NOT NULL,
            `marketState` varchar(155) COLLATE utf8mb4_bin NOT NULL DEFAULT 'Locked',
            `marketData` longtext COLLATE utf8mb4_bin NOT NULL,
            `marketOwner` varchar(50) COLLATE utf8mb4_bin NOT NULL,
            PRIMARY KEY (`uuid`),
            UNIQUE KEY `marketName` (`marketName`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
    ]],
    [[
        CREATE TABLE IF NOT EXISTS `x_world_doors` (
          `id` int(3) NOT NULL AUTO_INCREMENT,
          `doorData` longtext COLLATE utf8mb4_bin NOT NULL,
          PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
    ]],
    [[
        CREATE TABLE IF NOT EXISTS `x_characters_status` (
        `characterID` varchar(100) NOT NULL,
        `thirst` int(11) DEFAULT NULL,
        `hunger` int(11) DEFAULT NULL,
        PRIMARY KEY (`characterID`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]],
    [[
        CREATE TABLE IF NOT EXISTS `x_inventories` (
            `name` varchar(50) COLLATE utf8mb4_bin NOT NULL,
            `items` longtext COLLATE utf8mb4_bin NOT NULL,
            `timeCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (`name`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
    ]],
    [[
        CREATE TABLE IF NOT EXISTS `x_characters_vehicles` (
            `vehiclePlate` varchar(8) COLLATE utf8mb4_bin NOT NULL,
            `vehicleOwner` varchar(50) COLLATE utf8mb4_bin NOT NULL,
            `vehicleData` longtext COLLATE utf8mb4_bin NOT NULL,
            `vehicleGarage` varchar(50) COLLATE utf8mb4_bin NOT NULL DEFAULT 'MOTEL_GARAGE',
            `vehicleInside` int(1) NOT NULL DEFAULT '1',
            `timeCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (`vehiclePlate`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
    ]],
    [[
        CREATE TABLE IF NOT EXISTS `x_characters_damages` (
            `characterId` varchar(50) COLLATE utf8mb4_bin NOT NULL,
            `damages` longtext COLLATE utf8mb4_bin NOT NULL,
            PRIMARY KEY (`characterId`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
    ]],
    [[
        CREATE TABLE IF NOT EXISTS `x_world_orders` (
            `uuid` varchar(50) COLLATE utf8mb4_bin NOT NULL,
            `orderData` longtext COLLATE utf8mb4_bin NOT NULL,
            PRIMARY KEY (`uuid`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
    ]],
    [[
        CREATE TABLE IF NOT EXISTS `x_dealership_vehicles` (
            `dealership` varchar(50) COLLATE utf8mb4_bin NOT NULL,
            `vehicleData` longtext COLLATE utf8mb4_bin NOT NULL
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
    ]],
    [[
        CREATE TABLE IF NOT EXISTS `x_characters_animations` (
            `characterId` varchar(50) COLLATE utf8mb4_bin NOT NULL,
            `animations` longtext COLLATE utf8mb4_bin NOT NULL,
            `animSet` varchar(50) COLLATE utf8mb4_bin NOT NULL,
            PRIMARY KEY (`characterId`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
    ]],
    [[
        CREATE TABLE IF NOT EXISTS `x_characters_skills` (
            `characterId` varchar(50) COLLATE utf8mb4_bin NOT NULL,
            `skills` longtext COLLATE utf8mb4_bin NOT NULL,
            PRIMARY KEY (`characterId`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
    ]],
    [[
        CREATE TABLE IF NOT EXISTS `x_characters_invoice` (
            `id` int(11) NOT NULL,
            `owner` varchar(50) NOT NULL,
            `sender` varchar(50) NOT NULL,
            `invoiceData` longtext NOT NULL
        ) ENGINE=InnoDB DEFAULT CHARSET=latin1;
    ]],
    [[
        CREATE TABLE IF NOT EXISTS `x_characters_relationships` (
            `characterId` varchar(50) NOT NULL,
            `questCharacter` varchar(50) NOT NULL,
            `relation` int(11) NOT NULL,
            PRIMARY KEY (`characterId`)
        ) ENGINE=InnoDB DEFAULT CHARSET=latin1;
    ]],
    [[
        CREATE TABLE IF NOT EXISTS `x_world_accounts` (
            `accountName` varchar(50) COLLATE utf8mb4_bin NOT NULL,
            `accountData` longtext COLLATE utf8mb4_bin NOT NULL,
            PRIMARY KEY (`accountName`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
    ]],
    [[
        CREATE TABLE IF NOT EXISTS `x_world_notes` (
            `noteUUID` varchar(65) COLLATE utf8mb4_bin NOT NULL,
            `noteData` longtext COLLATE utf8mb4_bin NOT NULL,
            PRIMARY KEY (`noteUUID`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
    ]],
    [[
        CREATE TABLE IF NOT EXISTS `x_world_scooters` (
            `uuid` bigint(20) NOT NULL DEFAULT '0',
            `scooterIndex` int(2) NOT NULL DEFAULT '0',
            `stationIndex` int(2) NOT NULL,
            `data` longtext NOT NULL,
            PRIMARY KEY (`uuid`)
        ) ENGINE=InnoDB DEFAULT CHARSET=latin1;
    ]],
    [[
        CREATE TABLE IF NOT EXISTS `x_characters_comradio_favorites` (
            `characterId` varchar(50) COLLATE utf8mb4_bin NOT NULL,
            `favorites` longtext COLLATE utf8mb4_bin NOT NULL,
            PRIMARY KEY (`characterId`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
    ]],
    [[
        CREATE TABLE IF NOT EXISTS `x_world_carthief_management` (
            `characterId` varchar(50) NOT NULL,
            `dialogueLevel` int(2) NOT NULL DEFAULT '1'
        ) ENGINE=InnoDB DEFAULT CHARSET=latin1;
    ]],
    [[
        CREATE TABLE IF NOT EXISTS `x_world_gangs` (
            `creator` varchar(20) NOT NULL,
            `members` longtext NOT NULL,
            `data` longtext NOT NULL,
            `hideout` longtext NOT NULL
        ) ENGINE=InnoDB DEFAULT CHARSET=latin1;
    ]],
    [[
        CREATE TABLE IF NOT EXISTS `x_world_police_computer` (
            `recordUUID` varchar(165) COLLATE utf8mb4_bin NOT NULL,
            `recordData` longtext COLLATE utf8mb4_bin NOT NULL,
            PRIMARY KEY (`recordUUID`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
    ]],
    [[
        CREATE TABLE IF NOT EXISTS `x_world_moneywash_system` (
            `username` varchar(50) NOT NULL,
            `label` varchar(50) NOT NULL,
            `quantity` int(10) NOT NULL DEFAULT '0',
            `started` bigint(20) NOT NULL DEFAULT '0',
            PRIMARY KEY (`label`)
        ) ENGINE=InnoDB DEFAULT CHARSET=latin1;
    ]],
    [[
        CREATE TABLE IF NOT EXISTS `x_characters_cooldowns` (
            `characterId` VARCHAR(50) NOT NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
            `cooldownId` VARCHAR(50) NOT NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
            `timestamp` INT(11) NOT NULL DEFAULT '0',
            PRIMARY KEY (`characterId`) USING BTREE
        ) ENGINE=InnoDB DEFAULT CHARSET=latin1;
    ]],
    [[
        CREATE TABLE IF NOT EXISTS `x_world_datastorages` (
            `storageOwner` varchar(50) COLLATE utf8mb4_bin NOT NULL,
            `storageData` longtext COLLATE utf8mb4_bin NOT NULL,
            PRIMARY KEY (`storageOwner`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
    ]],
    [[
        CREATE TABLE IF NOT EXISTS `x_world_ambulance_panel` (
            `characterId` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_general_ci',
            `firstname` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_general_ci',
            `lastname` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_general_ci',
            `casenumber` INT(11) NOT NULL DEFAULT '0',
            `Journal` LONGTEXT NOT NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
            PRIMARY KEY (`characterId`) USING BTREE
        )
    ]],
    [[
        CREATE TABLE IF NOT EXISTS `x_world_police_computer` (
            `recordUUID` varchar(165) COLLATE utf8mb4_bin NOT NULL,
            `recordData` longtext COLLATE utf8mb4_bin NOT NULL,
            PRIMARY KEY (`recordUUID`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
    ]],
    [[
        CREATE TABLE IF NOT EXISTS `x_world_inmates` (
            `inmateId` varchar(50) COLLATE utf8mb4_bin NOT NULL,
            `inmateData` longtext COLLATE utf8mb4_bin NOT NULL,
            `inmateTime` bigint(20) NOT NULL,
            PRIMARY KEY (`inmateId`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
    ]],
    [[
        CREATE TABLE IF NOT EXISTS `x_users_settings` (
            `steamHex` varchar(50) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
            `userSettings` longtext COLLATE utf8mb4_bin NOT NULL,
            PRIMARY KEY (`steamHex`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
    ]]
}

MySQL.ready(function()
    if not Config.CreateDatabase then return end

    local sqlQueries = {}

    for tableIndex, tableQuery in ipairs(databaseTables) do
        table.insert(sqlQueries, function(callback)
            MySQL.Async.execute(tableQuery, {}, function(rowsChanged)
                callback(rowsChanged > 0)
            end)
        end)
    end

    Async.parallel(sqlQueries, function(responses)
        if #responses >= #databaseTables then
            Main.Log("Updated all tables in database.")
        else
            Main.Log("Something wrong occured database correct?")
        end
    end)

    RefreshWhitelist()
end)

RefreshWhitelist = function()
    local sqlQuery = [[
        SELECT
            steamHex, timeWhitelisted
        FROM
            x_users_whitelist
    ]]

    MySQL.Async.fetchAll(sqlQuery, {}, function(responses)
        Main.Whitelists = responses
    end)

    Main.Log("Refreshing whitelist.")
end