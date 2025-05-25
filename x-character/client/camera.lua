Camera = {
    CameraHandles = {},

    CreateCam = function(camInformation, camHash)
        local camHandle = camHash and CreateCamera(camHash, 1) or CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", camInformation.Location, camInformation.Rotation, camInformation.Fov or 80.0)

        return camHandle
    end,

    HandleCam = function(camName, secondCamIndex, camDuration)
        if camName == "NONE" then
            RenderScriptCams(false, camDuration and (camDuration > 0 and true or false) or false, camDuration and (camDuration > 0 and camDuration or 1000) or 1000, 1, 0)

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
            Camera.LastCamera = secondCamIndex

            InterpolateCams(cam, secondCam, camDuration or 1000)
        end
    end,
    ShakeCam = function(camName, shakeType, shakeAmplitude)
        local cam = Camera.CameraHandles[camName]

        if not DoesCamExist(cam) then return end

        ShakeCam(cam, shakeType, shakeAmplitude)
    end,
    AnimateCam = function(camName, animationName, animationDictionary, animCoords, animRotation)
        local cam = Camera.CameraHandles[camName]

        if not DoesCamExist(cam) then return end

        PlayCamAnim(cam, animationName, animationDictionary, animCoords, animRotation, 0, 2)
    end,
    FuckCamera = function(param0, param1, param2, param3, param4)
        --N_0xf55e4046f6f831dc(param0, param1)
        --N_0xe111a7c0d200cbc5(param0, param2)
        --SetCamDofFnumberOfLens(param0, param3)
        --SetCamDofMaxNearInFocusDistanceBlendLevel(param0, param4)
    end,

    Cleanup = function(easeOut)
        DestroyAllCams(true)

        RenderScriptCams(false, easeOut and true or false, 750)

        Camera.CameraHandles = {}
    end
}



