local settings = {
    CameraLock = false,
    ForcedJumps = false,
    Frozen = false,
    LowGravity = false,
    ReversedCamera = false,
    UpsideDown = false,
}


RegisterHook("/Game/AnimX/_Common/CharBP_Base.CharBP_Base_C:ReceiveTick", function(self, DeltaSeconds)
    local Character = self:get()
    if not Character or not Character:IsValid() then return end

    if settings.CameraLock then
        Character['Camera Speed - Pitch'] = 0.0
        Character['Camera Speed - Yaw'] = 0.0
    else
        if settings.ReversedCamera then
            Character['Camera Speed - Pitch'] = -0.6
            Character['Camera Speed - Yaw'] = -0.6
        else
            Character['Camera Speed - Pitch'] = 0.6
            Character['Camera Speed - Yaw'] = 0.6
        end
    end

    if settings.ForcedJumps then
        if Character['Is OnGround'] then
            Character:DoJump(false, 1.0)
            Character['Jump in Place'] = false
        end
    end

    -- This property is updated every frame so we don't need to manually set it back
    if settings.UpsideDown then
        local Cam = Character.Camera
        if Cam and Cam:IsValid() then
            Cam.RelativeRotation.Roll = 180.0
        end
    end

    -- Same thing
    if settings.Frozen then
        local MovementComp = Character.CharacterMovement
        if MovementComp and MovementComp:IsValid() then
            -- Launch player to end states like walls runs, mantling, etc
            local v3 = {X=0.0, Y=0.0, Z=0.0}
            Character:LaunchWithForce(v3, 9.0, v3, true)
            -- Freeze player vel, still falls slowly so we make upward vel the default 9.8
            -- idk if it's perfect but it seems to work well
            MovementComp.Velocity = {X=0.0, Y=0.0, Z=9.8}
        end
    end

    if settings.LowGravity then
        local MovementComp = Character.CharacterMovement
        if MovementComp and MovementComp:IsValid() then
            MovementComp.GravityScale = 0.25
        end
    end
end)


return settings