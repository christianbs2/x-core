Config = {}

Config.VicinityScanDistance = 2.5
Config.GiveCashDistance = 1.5
Config.SearchDistance = 3.0

Config.Inventories = {
    {
        Name = "POCKETS",
        Label = "FICKOR",
        MaxSlots = 25,
        MaxWeight = 50.0,
        Container = "leftContainer",
        Character = true
    },
    {
        Name = "KEYCHAIN",
        Label = "NYCKLAR",
        MaxSlots = 20,
        MaxWeight = 20,
        Container = "leftContainer",
        Character = true
    },
    {
        Name = "ACCESSORIES",
        Label = "TILLBEHÖR",
        MaxSlots = 20,
        MaxWeight = 6,
        Container = "leftContainer",
        Character = true
    },
    {
        Name = "GROUND",
        Label = "MARKEN",
        MaxSlots = 25,
        Container = "rightContainer",
        MaxWeight = -1
    }
}

Config.Serials = {
    -- Pistoler
    pistol = true,
    combatpistol = true,
    appistol = true,
    pistol50 = true,
    snspistol = true,
    revolver = true,
    heavypistol = true,
    vintagepistol = true,
    pistol_mk2 = true,


    -- Shotguns
    pumpshotgun = true,
    bullpupshotgun = true,
    sawnoffshotgun = true,
    dbshotgun = true,

    -- Smgs
    microsmg = true,
    smg = true,
    minismg = true,
    combatpdw = true,
    assaultsmg = true,
    machinepistol = true,



    -- Större Vapen
    assaultrifle = true,
    bullpuprifle = true,
    carbinerifle = true,
    specialcarbine = true,
    compactrifle = true,
    musket = true,
    assaultrifle_mk2 = true,
    advancedrifle = true,

    -- Maskingevärr
    combatmg = true,
    gusenberg = true,
    compactlauncher = true,

    -- Snipers
    sniperrifle = true,

    --ADDON VAPEN POLISEN
    hk416 = true,
    fnx45 = true,
    pistol_mk2pol = true,

    --SILVER OCH GULD VAPNEN -------------------------------

    --ADDON PISTOLER
    pistol2 = true,
    pistol3 = true,
    pistol_mk22 = true,
    pistol_mk23 = true,
    pistol502 = true,
    pistol503 = true,
    revolver2 = true,
    revolver3 = true,
    snspistol2 = true,
    snspistol3 = true,
    vintagepistol2 = true,
    vintagepistol3 = true,
    heavypistol2 = true,
    heavypistol3 = true,
    doubleaction2 = true,
    doubleaction3 = true,

    --ADDON SHOTGUNS
    sawnoffshotgun2 = true,
    sawnoffshotgun3 = true,
    dbshotgun2 = true,
    dbshotgun3 = true,

    --ADDON SMGS
    assaultsmg2 = true,
    assaultsmg3 = true,
    combatpdw2 = true,
    combatpdw3 = true,
    machinepistol2 = true,
    machinepistol3 = true,
    microsmg2 = true,
    microsmg3 = true,
    minismg2 = true,
    minismg3 = true,

    --ADDON RIFLES
    assaultrifle2 = true,
    assaultrifle3 = true,
    assaultriflemk22 = true,
    assaultriflemk23 = true,
    compactrifle2 = true,
    compactrifle3 = true,
    specialcarbine2 = true,
    specialcarbine3 = true
    
}

Config.KeyPrice = 500

Config.LimitItems = {
    bag = 16
}

Config.UUID = function()
    local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'

    math.randomseed(GetGameTimer() + math.random())

    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
        return string.format('%x', v)
    end)
end

Config.Trim = function(value)
	if value then
		return (string.gsub(value, "^%s*(.-)%s*$", "%1"))
	else
		return nil
	end
end

Config.Replace = function(str, what, with)
    what = string.gsub(what, "[%(%)%.%+%-%*%?%[%]%^%$%%]", "%%%1") -- escape pattern
    with = string.gsub(with, "[%%]", "%%%%") -- escape replacement
    return string.gsub(str, what, with)
end

Config.GloveBox = {
    ["MaxSlots"] = 16,
    ["MaxWeight"] = 16.0
}

Config.Trunk = {
    ["MaxSlots"] = 16,
    ["MaxWeight"] = 16.0
}

Config.Bag = {
    ["MaxSlots"] = 25,
    ["MaxWeight"] = 45.0
}

Config.MedicBag = {
    ["MaxSlots"] = 10,
    ["MaxWeight"] = 15.0
}