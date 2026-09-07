local EffectManager = require("effects")
local Randomizer = require("randomizer")
local UIManager = require("ui")

local IsAtVet = false


-- reset the mod UI when the player object is destroyed
RegisterHook("/Game/AnimX/Cats/Realistic/CharBP_Cat_R_Player.CharBP_Cat_R_Player_C:ReceiveEndPlay", function(self, EndPlayReason)
    if not self then return end
    UIManager.Reset()
end)


-- Grab and set necessary mod data when the player object is created
RegisterHook("/Game/AnimX/Cats/Realistic/CharBP_Cat_R_Player.CharBP_Cat_R_Player_C:ReceiveBeginPlay", function(self)
    -- Don't run our mod stuff when at the vet
    local Carrier = FindFirstOf("BP_CatCarrierFromVet_C")
    if Carrier and Carrier:IsValid() then
        IsAtVet = true
        UIManager.HideText()
        UIManager.HideTimer()
        return
    end

    Randomizer.Start()
    UIManager.Reset()
    UIManager.SetText("Pending effect...")
end)


-- Updates once a frame for our player object, this is where we handle appying temporary effects
-- We also now handle the effect timer here, it will stop counting down when the player pauses
RegisterHook("/Game/AnimX/Cats/Realistic/CharBP_Cat_R_Player.CharBP_Cat_R_Player_C:ReceiveTick", function(self, DeltaSeconds)
    if IsAtVet then return end

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
    if not MovementComp or not MovementComp:IsValid() then return end

    -- The player would still have low gravity for a bit after the effect
    -- This means the GravityScale property isn't updated every frame, but on entering states
    -- The player object has a Gravity variable that matches the intended GravityScale
    -- Setting it has no effect, but if it is set at the same time as GravityScale...
    -- That means we can just use Gravity to determine the GravityScale
    if EffectManager.settings.LowGravity then
        MovementComp.GravityScale = Player.Gravity * 0.25
    else
        MovementComp.GravityScale = Player.Gravity
    end

    if EffectManager.settings.Frozen then
        -- Launch player to end states like walls runs, mantling, etc
        local v3 = {X=0.0, Y=0.0, Z=0.0}
        Player:LaunchWithForce(v3, 0.0, v3, true)
        -- Player still has some gravity so set it to 0
        MovementComp.GravityScale = 0.0
    end
end)
