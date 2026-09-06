local EffectManager = require("effects")
local Randomizer = require("randomizer")
local UIManager = require("ui")


-- reset the mod UI when the player object is destroyed
RegisterHook("/Game/AnimX/Cats/Realistic/CharBP_Cat_R_Player.CharBP_Cat_R_Player_C:ReceiveEndPlay", function(self, EndPlayReason)
    if not self then return end
    UIManager.Reset()
end)


-- Grab and set necessary mod data when the player object is created
RegisterHook("/Game/AnimX/Cats/Realistic/CharBP_Cat_R_Player.CharBP_Cat_R_Player_C:ReceiveBeginPlay", function(self)
    Randomizer.Start()
    UIManager.Reset()
    UIManager.SetText("Pending effect...")
    UIManager.ResetTimer()
    UIManager.UpdateTimer(0.0)
end)


-- Updates once a frame for our player object, this is where we handle appying temporary effects
-- We also now handle the effect timer here, it will stop counting down when the player pauses
RegisterHook("/Game/AnimX/Cats/Realistic/CharBP_Cat_R_Player.CharBP_Cat_R_Player_C:ReceiveTick", function(self, DeltaSeconds)
    local Player = FindFirstOf("CharBP_Cat_R_Player_C")
    if not Player or not Player:IsValid() then return end

    local timeLeft = UIManager.UpdateTimer(DeltaSeconds:get())
    if timeLeft == 0.0 then
        EffectManager.ApplyRandomEffect(Player)
        UIManager.ResetTimer()
        return
    end

    if EffectManager.settings.CameraLock then
        Player['Camera Speed - Pitch'] = 0.0
        Player['Camera Speed - Yaw'] = 0.0
    else
        if EffectManager.settings.ReversedCamera then
            Player['Camera Speed - Pitch'] = -0.6
            Player['Camera Speed - Yaw'] = -0.6
        else
            Player['Camera Speed - Pitch'] = 0.6
            Player['Camera Speed - Yaw'] = 0.6
        end
    end

    if EffectManager.settings.ForcedJumps then
        if Player['Is OnGround'] then
            Player:DoJump(false, 1.0)
            Player['Jump in Place'] = false
        end
    end

    -- This property is updated every frame so we don't need to manually set it back
    if EffectManager.settings.UpsideDown then
        local Cam = Player.Camera
        if Cam and Cam:IsValid() then
            Cam.RelativeRotation.Roll = 180.0
        end
    end

    -- From this point on are effects that edit movement properties
    local MovementComp = Player.CharacterMovement
    if MovementComp and MovementComp:IsValid() then return end

    if EffectManager.settings.Frozen then
        -- Launch player to end states like walls runs, mantling, etc
        local v3 = {X=0.0, Y=0.0, Z=0.0}
        Player:LaunchWithForce(v3, 9.0, v3, true)
        -- Freeze player vel, still falls slowly so we make upward vel the default 9.8
        -- idk if it's perfect but it seems to work well
        -- MovementComp.Velocity = {X=0.0, Y=0.0, Z=9.8}
    end

    -- The player would still have low gravity after the effect ended as long as they held jump
    -- This means that this property doesnt immediately update, so we need to do it ourselves
    if EffectManager.settings.LowGravity then
        MovementComp.GravityScale = 0.25
    else
        MovementComp.GravityScale = 1.0
    end
end)
