local TimerData = require("timer")

print("[EffectRandomizer] Script initialized successfully!")

local UEHelpers = require("UEHelpers")
local EffectManager = require("effects")

local EffectLoop = nil

local FunctionPool = {
    EffectManager.ToggleDash,
    EffectManager.ToggleDoubleJump,
    EffectManager.SpawnDrum,
    EffectManager.SpawnYarnBall,
    EffectManager.LaunchRandomDirection,
}

RegisterHook("/Script/Engine.PlayerController:ClientRestart", function(self, newPawn)
    RegisterHook("/Game/AnimX/_Common/CharBP_Base.CharBP_Base_C:ReceiveEndPlay", function()
        if EffectLoop then
            StopLoopAsync(EffectLoop)
            EffectLoop = nil
        end
        EffectManager.Cleanup()
    end)

    EffectLoop = LoopAsync(TimerData.Seconds * 1000, function()
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
        local tempEffs = EffectManager.GetValidTempEffects()
        local validFuncs = {}
        for i = 1, #FunctionPool do
            validFuncs[#validFuncs+1] = FunctionPool[i]
        end
        if tempEffs then            
            for i = 1, #tempEffs do
                validFuncs[#validFuncs+1] = tempEffs[i]
            end
        end
        ExecuteWithDelay(500, function()
            local randomIndex = math.random(1, #validFuncs)
            validFuncs[randomIndex](Character)
        end)
        return false
    end)
end)
