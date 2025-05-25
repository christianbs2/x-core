-- Cache to store entity coordinates for optimization
local entityCoordsCache = {}
local ENTITY_CACHE_INTERVAL = 5000 -- 5 seconds
local LAST_CACHE_TIME = 0

local entityEnumerator = {
    __gc = function(enum)
        if enum.destructor and enum.handle then
            enum.destructor(enum.handle)
        end
        enum.destructor = nil
        enum.handle = nil
    end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
        local iter, id = initFunc()
        if not id or id == 0 then
            disposeFunc(iter)
            return
        end

        local enum = {handle = iter, destructor = disposeFunc}
        setmetatable(enum, entityEnumerator)

        local next = true
        repeat
            coroutine.yield(id)
            next, id = moveFunc(iter)
        until not next

        enum.destructor, enum.handle = nil, nil
        disposeFunc(iter)
    end)
end

-- Caching entity coords every interval
local function CacheEntityCoords(entities)
    local currentTime = GetGameTimer()
    if currentTime - LAST_CACHE_TIME > ENTITY_CACHE_INTERVAL then
        local count = 0
        for _, entity in pairs(entities) do
            if DoesEntityExist(entity) then
                entityCoordsCache[entity] = GetEntityCoords(entity)
                count = count + 1

                -- Yield every 25 entities to prevent CPU spike
                if count % 25 == 0 then
                    Citizen.Wait(0)
                end
            end
        end
        LAST_CACHE_TIME = currentTime
    end
end

-- Check entities within a limited number per iteration to optimize
local ENTITY_CHECK_LIMIT = 10

function EnumerateEntitiesWithinDistance(entities, isPlayerEntities, coords, maxDistance)
    local nearbyEntities = {}
    local entityCount = 0

    if coords then
        coords = vector3(coords.x, coords.y, coords.z)
    else
        local playerPed = PlayerPedId()
        coords = GetEntityCoords(playerPed)
    end

    CacheEntityCoords(entities)

    for k, entity in pairs(entities) do
        if entityCount >= ENTITY_CHECK_LIMIT then break end

        local entityCoords = entityCoordsCache[entity]
        if entityCoords then
            -- Quick 2D check before full 3D distance
            local roughDistance = #(coords.xy - entityCoords.xy)

            if roughDistance <= maxDistance + 50 then
                local distance = #(coords - entityCoords)

                if distance <= maxDistance then
                    table.insert(nearbyEntities, isPlayerEntities and k or entity)
                    entityCount = entityCount + 1
                end
            end
        end
    end

    return nearbyEntities
end

function EnumerateObjects()
    return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

function EnumeratePeds()
    return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function EnumerateVehicles()
    return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function EnumeratePickups()
    return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
end
