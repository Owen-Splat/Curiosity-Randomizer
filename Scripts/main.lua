local UEHelpers = require("UEHelpers")
local EffectManager = require("effects")

print("[EffectRandomizer] Script initialized successfully!")

local EffectTimer = nil

local FunctionPool = {
    EffectManager.ToggleDash,
    EffectManager.ToggleDoubleJump,
    EffectManager.SpawnDrum,
    EffectManager.SpawnYarnBall,
    -- EffectManager.ToggleLowGravity, -- not finished
    EffectManager.LaunchRandomDirection,
}

RegisterHook("/Script/Engine.PlayerController:ClientRestart", function(self, newPawn)
    RegisterHook("/Game/AnimX/_Common/CharBP_Base.CharBP_Base_C:ReceiveEndPlay", function()
        if EffectTimer then
            StopLoopAsync(EffectTimer)
            EffectTimer = nil
        end
        EffectManager.Cleanup()
    end)

    EffectTimer = LoopAsync(10000, function()
        local PlayerController = UEHelpers.GetPlayerController()
        if not PlayerController or not PlayerController:IsValid() then
            return true
        end
        local Character = PlayerController.Character
        if not Character or not Character:IsValid() then
            return true
        end
        EffectManager:InitHooks()
        EffectManager.Cleanup()
        ExecuteWithDelay(500, function()
            local randomIndex = math.random(1, #FunctionPool)
            FunctionPool[randomIndex](Character)
        end)
        return false
    end)
end)
