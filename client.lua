local lastShotTime = 0
local recoilIntensity = 0.0
local unarmed = `WEAPON_UNARMED`
local CONTROL_CAM = 19

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local sleep = 1000
        local _, weapon = GetCurrentPedWeapon(ped)
        local currentCam = GetFollowPedCamViewMode()

        if IsPedInAnyVehicle(ped, false) then
            if weapon ~= unarmed then
                sleep = 1
                if IsControlJustPressed(0, 25) then
                    SetFollowVehicleCamViewMode(3)
                elseif IsControlJustReleased(0, 25) then
                    SetFollowVehicleCamViewMode(0)
                end
            end
        elseif IsPedOnAnyBike(ped) then
            if weapon ~= unarmed then
                sleep = 1
                if IsControlJustPressed(0, 25) then
                    SetCamViewModeForContext(2, 3)
                elseif IsControlJustReleased(0, 25) then
                    SetCamViewModeForContext(2, 0)
                end
            end
        else
            sleep = 1
            if weapon == unarmed then
                if currentCam ~= 1 then
                    SetFollowPedCamViewMode(1)
                end
            else
                DisableControlAction(0, CONTROL_CAM, true)
                DisableControlAction(2, CONTROL_CAM, true)
                if currentCam ~= 4 then
                    SetFollowPedCamViewMode(4)
                end
                local t = GetGameTimer()
                if t - lastShotTime > 500 and IsPedShooting(ped) then
                    ShakeGameplayCam("SMALL_EXPLOSION_SHAKE", 0.3)
                    local r = GetEntityRotation(ped)
                    SetEntityRotation(ped,
                        r.x + math.random(-1, 1) * recoilIntensity,
                        r.y + math.random(-1, 1) * recoilIntensity,
                        r.z + math.random(-1, 1) * recoilIntensity,
                        0, true)
                    lastShotTime = t
                end
            end
        end

        Wait(sleep)
    end
end)