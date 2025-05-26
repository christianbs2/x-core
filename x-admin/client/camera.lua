Camera = {
    CameraHandles = {},

    CreateCam = function(camInformation)
        local camHandle = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", camInformation.Location, camInformation.Rotation, camInformation.Fov or 80.0)

        return camHandle
    end,

    HandleCam = function(camName, secondCamIndex, camDuration)
        if camName == "none" then
            RenderScriptCams(false, false, 0, 1, 0)

            return
        end

        local cam = Camera.CameraHandles[camName]
        local secondCam = Camera.CameraHandles[secondCamIndex]

        local InterpolateCams = function(cam1, cam2, duration)
            if not IsCamActive(cam1) then
                SetCamActive(cam1, true)
            end

            if not IsCamRendering(cam1) and not IsCamRendering(cam2) then
                if not secondCam then
                    RenderScriptCams(true, true, camDuration)
                else
                    RenderScriptCams(true, false, 0)
                end
            end

            SetCamActiveWithInterp(cam2, cam1, duration, true, true)
        end

        if secondCamIndex then
            InterpolateCams(cam, secondCam, camDuration or 1000)
        end
    end,
    ShakeCam = function(camName, shakeType, shakeAmplitude)
        local cam = Camera.CameraHandles[camName]

        if not DoesCamExist(cam) then return end

        ShakeCam(cam, shakeType, shakeAmplitude)
    end,

    Cleanup = function(easeOut)
        DestroyAllCams(true)

        RenderScriptCams(false, easeOut and true or false, 750)

        Camera.CameraHandles = {}
    end
}



