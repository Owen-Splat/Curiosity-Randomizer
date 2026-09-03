local settings = {
    CameraLock = false,
    ForcedJumps = false,
    LowGravity = false
}

local BaseGrav = nil
local JumpGrav = nil


RegisterHook("/Game/AnimX/_Common/CharBP_Base.CharBP_Base_C:ReceiveTick", function(self, DeltaSeconds)
    local Character = self:get()
    if not Character or not Character:IsValid() then return end

    if settings.CameraLock then
        Character['Camera Speed - Pitch'] = 0.0
        Character['Camera Speed - Yaw'] = 0.0
    else
        Character['Camera Speed - Pitch'] = 0.6
        Character['Camera Speed - Yaw'] = 0.6
    end

    if settings.ForcedJumps then
        if Character['Is OnGround'] then
            Character:DoJump(false, 1.0)
            Character['Jump in Place'] = false
            -- Character['Jump Winding Up'] = false
        end
    end
end)


RegisterHook("/Game/AnimX/_Common/CharBP_Base.CharBP_Base_C:SetGravity", function(self, Gravity, IsTemporary)
    local Character = self:get()
    if not Character or not Character:IsValid() then return end

    if settings.LowGravity then
        Character['Base Falling Gravity'] = Character['Base Falling Gravity'] / 2.0
        Character['Jumping Hold Gravity'] = Character['Jumping Hold Gravity'] / 2.0
    else
        if not BaseGrav and not JumpGrav then
            BaseGrav = Character['Base Falling Gravity']
            JumpGrav = Character['Jumping Hold Gravity']
        else
            Character['Base Falling Gravity'] = BaseGrav
            Character['Jumping Hold Gravity'] = JumpGrav
        end
    end
end)


return settings