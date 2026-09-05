local Randomizer = require("randomizer")
local TimerData = require("timer")
local UIManager = require("ui")
print("[EffectRandomizer] Script initialized successfully!")

local UEHelpers = require("UEHelpers")
local EffectManager = require("effects")

local EffectLoop = nil
local TimerLoop = nil
local LoopCount = 0
local LoopRunning = false

-- These are the basic funcs that always have a chance to appear
local FunctionPool = {
    EffectManager.ToggleDash,
    EffectManager.ToggleDoubleJump,
    EffectManager.SpawnDrum,
    EffectManager.SpawnYarnBall,
    EffectManager.InvertColors,
}


local function ResetUI()
    LoopRunning = false
    if TimerLoop then
        StopLoopAsync(TimerLoop)
        TimerLoop = nil
    end
    if EffectLoop then
        StopLoopAsync(EffectLoop)
        EffectLoop = nil
    end
    EffectManager.Cleanup()
    LoopCount = 0
    UIManager.SetText("Random Effects Mod v0.1.1 by Owen_Splat")
    UIManager.timerRaw = TimerData.Seconds + 1
    UIManager.UpdateTimer()
end


-- We want to clear effects and reset data when the player returns to the title screen
RegisterHook("/Game/AnimX/_Common/CharBP_Base.CharBP_Base_C:ReceiveEndPlay", function(self)
    if not self then return end
    ResetUI()
end)


-- Start our loop when the player has been created
RegisterHook("/Script/Engine.PlayerController:ClientRestart", function(self, newPawn)
    if not self then return end

    if not LoopRunning then
        ResetUI()
    end

    Randomizer.Start()

    EffectManager:InitHooks()
    UIManager.SetText("Pending effect...")
    UIManager.timerRaw = TimerData.Seconds
    UIManager.UpdateTimer()
    LoopRunning = true

    TimerLoop = LoopAsync(1000, function()
        if not LoopRunning then
            return true
        end
        UIManager.UpdateTimer()
        return false
    end)

    EffectLoop = LoopAsync(TimerData.Seconds * 1000, function()
        -- We still need to validate that the player exists
        -- Otherwise we may run into a nil reference when the player exits to the title screen
        local PlayerController = UEHelpers.GetPlayerController()
        if not PlayerController or not PlayerController:IsValid() then
            return true
        end
        local Character = PlayerController.Character
        if not Character or not Character:IsValid() then
            return true
        end

        -- We want to cleanup old effects (text and spawned objs) before adding a new effect
        EffectManager.Cleanup()
        UIManager.timerRaw = TimerData.Seconds

        -- Keep track of the number of loops to control how likely some effects are
        LoopCount = LoopCount + 1
        local tempEffs = EffectManager.GetValidTempEffects()

        -- Create our total list of effect funcs to run
        local validFuncs = {}
        for i = 1, #FunctionPool do
            validFuncs[#validFuncs+1] = FunctionPool[i]
        end
        if LoopCount % 2 == 0 then
            if tempEffs then
                for i = 1, #tempEffs do
                    validFuncs[#validFuncs+1] = tempEffs[i]
                end
            end
        end

        -- Random launches SUCK so we make them rare
        -- 1/5 chance just to be included, then it still has to be randomly selected
        if LoopCount % 5 == 0 then
            validFuncs[#validFuncs+1] = EffectManager.LaunchRandomDirection
        end

        local randomIndex = math.random(1, #validFuncs)
        validFuncs[randomIndex](Character)
        return false
    end)
end)

-- Create the seed when the mod loads
math.randomseed(os.time())

-- Init our custom text
UIManager.timerRaw = TimerData.Seconds
UIManager.Init()