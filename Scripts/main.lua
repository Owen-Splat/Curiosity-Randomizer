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

local CurrentSessionID = 0

-- These are the basic funcs that always have a chance to appear
local BaseEffs = {
    EffectManager.ToggleDash,
    EffectManager.ToggleDoubleJump,
    EffectManager.SpawnDrum,
    EffectManager.SpawnYarnBall,
    EffectManager.InvertColors,
}

local TempEffs = {
    EffectManager.ToggleLowGravity,
    EffectManager.LockCamera,
    EffectManager.ReverseCamera,
    EffectManager.UpsideDown,
    EffectManager.ConstantJump,
    EffectManager.Freeze
}


local function ResetUI()
    LoopRunning = false
    TimerLoop = nil
    EffectLoop = nil
    EffectManager.Cleanup()
    LoopCount = 0
    UIManager.ResetText()
    UIManager.ShowTimer()
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

    local PCon = UEHelpers.GetPlayerController()
    if PCon and PCon:IsValid() then
        local PChar = PCon.Character
        if PChar and PChar:IsValid() then
            print(PChar:GetFullName(), "\n")
        end
    end

    CurrentSessionID = CurrentSessionID + 1
    local MySessionID = CurrentSessionID

    -- If the player is at the vet, don't run our randomizer or effect loops
    local IsAtVet = false
    local Carrier = FindFirstOf("BP_CatCarrierFromVet_C")
    if Carrier and Carrier:IsValid() then
        IsAtVet = true
        Carrier:K2_DestroyActor()
    end

    if IsAtVet then
        UIManager.HideTimer()
        UIManager.SetText("You've been a bad kitty...")
    else
        ResetUI()
        Randomizer.Start()
        EffectManager:InitHooks()
        UIManager.SetText("Pending effect...")
        UIManager.timerRaw = TimerData.Seconds
        UIManager.UpdateTimer()
        LoopRunning = true
    end

    TimerLoop = LoopAsync(1000, function()
        if not LoopRunning or MySessionID ~= CurrentSessionID then
            return true
        end
        if IsAtVet then
            return true
        end
        UIManager.UpdateTimer()
        return false
    end)

    EffectLoop = LoopAsync(TimerData.Seconds * 1000, function()
        if not LoopRunning or MySessionID ~= CurrentSessionID then
            return true
        end
        if IsAtVet then
            return true
        end

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

        -- Create our total list of effect funcs to run
        local validFuncs = {}
        for i = 1, #BaseEffs do
            validFuncs[#validFuncs+1] = BaseEffs[i]
        end

        -- Some temporary effects are nuisances
        -- So temp effects are only included in the pool every other loop
        if LoopCount % 2 == 0 then
            for i = 1, #TempEffs do
                validFuncs[#validFuncs+1] = TempEffs[i]
            end
        end

        -- Random launches SUCK so they are only included in the pool every 5 loops
        if LoopCount % 5 == 0 then
            validFuncs[#validFuncs+1] = EffectManager.LaunchRandomDirection
        end

        -- Vet visit isnt that bad since you can just leave
        -- If I decide to force the player to complete it, then I'll lower the odds
        -- I need to create a check that the player has beds
        if LoopCount % 5 == 0 then
            validFuncs[#validFuncs+1] = EffectManager.VetVisit
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