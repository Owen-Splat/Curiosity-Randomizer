local settings = {
    CameraLock = false,
    ForcedJumps = false,
    Frozen = false,
    LowGravity = false,
    ReversedCamera = false,
    UpsideDown = false,
}


RegisterHook("/Game/AnimX/Cats/Realistic/CharBP_Cat_R_Player.CharBP_Cat_R_Player_C:ReceiveTick", function(self, DeltaSeconds)
    local Player = FindFirstOf("CharBP_Cat_R_Player_C")
    if not Player or not Player:IsValid() then return end

    if settings.CameraLock then
        Player['Camera Speed - Pitch'] = 0.0
        Player['Camera Speed - Yaw'] = 0.0
    else
        if settings.ReversedCamera then
            Player['Camera Speed - Pitch'] = -0.6
            Player['Camera Speed - Yaw'] = -0.6
        else
            Player['Camera Speed - Pitch'] = 0.6
            Player['Camera Speed - Yaw'] = 0.6
        end
    end

    if settings.ForcedJumps then
        if Player['Is OnGround'] then
            Player:DoJump(false, 1.0)
            Player['Jump in Place'] = false
        end
    end

    -- This property is updated every frame so we don't need to manually set it back
    if settings.UpsideDown then
        local Cam = Player.Camera
        if Cam and Cam:IsValid() then
            Cam.RelativeRotation.Roll = 180.0
        end
    end

    -- Same thing
    if settings.Frozen then
        local MovementComp = Player.CharacterMovement
        if MovementComp and MovementComp:IsValid() then
            -- Launch player to end states like walls runs, mantling, etc
            local v3 = {X=0.0, Y=0.0, Z=0.0}
            Player:LaunchWithForce(v3, 9.0, v3, true)
            -- Freeze player vel, still falls slowly so we make upward vel the default 9.8
            -- idk if it's perfect but it seems to work well
            MovementComp.Velocity = {X=0.0, Y=0.0, Z=9.8}
        end
    end

    if settings.LowGravity then
        local MovementComp = Player.CharacterMovement
        if MovementComp and MovementComp:IsValid() then
            MovementComp.GravityScale = 0.25
        end
    end
end)


return settings