CheckDistanceVehicle = function(ped)
    local vehicleEntity = GetVehiclePedIsUsing(ped)

    if not DoesEntityExist(vehicleEntity) then return end
    if not GetPedInVehicleSeat(vehicleEntity, -1) == ped then return end

    if GetGameTimer() - Heap.LastChecked < 7500 then return end

    Heap.LastChecked = GetGameTimer()

    local vehiclePosition = GetEntityCoords(vehicleEntity)

    if Heap.LastPos then
        local distanceTraveled = #(vehiclePosition - Heap.LastPos)
        
        local oldDistanceTraveled = Entity(vehicleEntity).state.VEHICLE_TRAVELED_METERS or 0

        --SetVehicleProperties(vehicleEntity, {
        --    distanceTraveled = oldDistanceTraveled + distanceTraveled + 0.0
        --})
    end

    Heap.LastPos = vehiclePosition
end