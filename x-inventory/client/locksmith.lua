local locksmith = {
    Ped = {
        position = vector3(170.33345031738, -1799.2381591797, 29.315874099731),
        heading = 320.53,
        model = "s_m_y_construct_01",

        callback = function(pedEntity)
            TalkToLocksmith(pedEntity)
        end
    }
}

local pedInstance

Locksmith = function()
    local constructedPed = exports["x-pedstream"]:ConstructPed(locksmith.Ped)
    
    pedInstance = constructedPed
end

TalkToLocksmith = function(pedEntity, pageIndex)
    local contextOptions = {
        {
            label = "~y~Morgan~s~ | ~y~Låssmed~s~"
        }
    }

    local keys = Heap.Keys["KEYCHAIN_" .. X.Character.Data.characterId]

    if not keys then return X.Notify("Morgan", "Du har inga nycklar!", 5000, "error") end
    if not (#keys > 0) then return X.Notify("Morgan", "Du har inga nycklar!", 5000, "error") end

    local restrictedKeys = {
        POLICE_KEY = true,
        AMBULANCE_KEY = true
    }

    local first

    if not pageIndex then first = true; pageIndex = 1 end

    local keysPerPage = 5

    for currentKeyIndex = keysPerPage * pageIndex - (keysPerPage - 1), keysPerPage * pageIndex do
        local currentKey = keys[currentKeyIndex]

        if currentKey and not restrictedKeys[currentKey] then
            table.insert(contextOptions, {
                label = "~b~" .. currentKey .. "~s~",
                subMenu = {
                    options = {
                        {
                            label = "~y~Kopiera~s~ | ~g~" .. Config.KeyPrice .. " kr",
                            callback = function()
                                CopyKey(currentKey)
                            end
                        }
                    }
                }
            })
        end
    end

    if pageIndex > 1 then
        table.insert(contextOptions, {
            label = "~r~⬅",
            callback = function()
                TalkToLocksmith(pedEntity, pageIndex - 1)
            end
        })
    end

    if keys[(keysPerPage * pageIndex) + 1] then
        table.insert(contextOptions, {
            label = "~g~➡",
            callback = function()
                TalkToLocksmith(pedEntity, pageIndex + 1)
            end
        })
    end

    exports["x-context"]:OpenContextMenu({
        menu = "LOCKSMITH_PED_" .. pageIndex,
        entity = pedEntity,
        options = contextOptions,
        oldPos = not first
    })
end

CopyKey = function(keyUnit)
    X.Callback("x-inventory:copyKey", function(copied)
        if copied then
            X.Notify("Morgan", "Varsegod, här har du din nyckel.", 5000, "success")
        else
            X.Notify("Morgan", "Har du verkligen råd med detta?", 5000, "error")
        end
    end, keyUnit)
end

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        --pedInstance.destroy()
    end
end)