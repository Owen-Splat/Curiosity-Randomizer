local UEHelpers = require("UEHelpers")
local TimerData = require("timer")
local HookManager = nil

local SpawnedText = nil
local SpawnedObj = nil

local effects = {}


function effects.InitHooks()
    if not HookManager then
        HookManager = require("hooks")
    end
end


function effects.Cleanup()
    if SpawnedText and SpawnedText:IsValid() then
        SpawnedText:K2_DestroyActor()
    end
    SpawnedText = nil

    if SpawnedObj and SpawnedObj:IsValid() then
        SpawnedObj:K2_DestroyActor()
    end
    SpawnedObj = nil

    if not HookManager then return end

    -- key any temp effect at the next cycle
    for key, value in pairs(HookManager) do
        if value == true then
            HookManager[key] = false
        end
    end
end


function effects.ShowText(Character, RawText)
    local TargetClassPath = "/Game/Blueprints/Tutorial/BP_TutorialInputTrigger.BP_TutorialInputTrigger_C"
    local ActorClass = StaticFindObject(TargetClassPath)
    if not ActorClass or not ActorClass:IsValid() then return end
    local World = Character:GetWorld()
    local SpawnLocation = {X = 0.0, Y = 0.0, Z = 0.0}
    local SpawnRotation = {Pitch = 0.0, Yaw = 0.0, Roll = 0.0}
    SpawnedText = World:SpawnActor(ActorClass, SpawnLocation, SpawnRotation)
    SpawnedText['Action Text'] = FText(RawText)
    SpawnedText:Show()
    ExecuteWithDelay(500, function()
    end)
end


function effects.ToggleDoubleJump(Character)
    if Character.DoubleJump then
        effects.ShowText(Character, "DOUBLE JUMP DISABLED")
        Character:SetDoubleJump(false)
    else
        effects.ShowText(Character, "DOUBLE JUMP ENABLED")
        Character:SetDoubleJump(true)
    end
end


function effects.ToggleDash(Character)
    if Character.dashenablediguess then
        effects.ShowText(Character, "DASH HAS BEEN DISABLED")
        Character:SetDashEnabled(false)
    else
        effects.ShowText(Character, "DASH HAS BEEN ENABLED")
        Character:SetDashEnabled(true)
    end
end


function effects.SpawnDrum(Character)
    local TargetClassPath = "/Game/Blueprints/BouncyPlatforms/Bouncy_Drums.Bouncy_Drums_C"
    local ActorClass = StaticFindObject(TargetClassPath)
    if not ActorClass or not ActorClass:IsValid() then return end
    effects.ShowText(Character, "Ba-dum-tss")
    local World = Character:GetWorld()
    local SpawnLocation = Character:K2_GetActorLocation()
    local SpawnRotation = {Pitch = 0.0, Yaw = 0.0, Roll = 0.0}
    SpawnedObj = World:SpawnActor(ActorClass, SpawnLocation, SpawnRotation)
end


function effects.SpawnYarnBall(Character)
    local TargetClassPath = "/Game/Blueprints/Yarn/BP_YarnBall.BP_YarnBall_C"
    local ActorClass = StaticFindObject(TargetClassPath)
    if not ActorClass or not ActorClass:IsValid() then return end
    effects.ShowText(Character, "You're on a roll!")
    local World = Character:GetWorld()
    local SpawnLocation = Character:K2_GetActorLocation()
    SpawnLocation.Z = SpawnLocation.Z + 150.0
    local SpawnRotation = {Pitch = 0.0, Yaw = 0.0, Roll = 0.0}
    SpawnedObj = World:SpawnActor(ActorClass, SpawnLocation, SpawnRotation)
    SpawnedObj:SetActorScale3D({X=3.0, Y=3.0, Z=3.0})
    local Mesh = SpawnedObj.StaticMesh
    if Mesh:IsValid() then
        Mesh:SetSimulatePhysics(true)
        Mesh:WakeAllRigidBodies()
    end
end


function effects.LaunchRandomDirection(Character)
    local vel = {X = math.random(-500, 500), Y = math.random(-500, 500), Z = math.random(1000, 1500)}
    local off = {X = 0.0, Y = 0.0, Z = 0.0}
    effects.ShowText(Character, "You're going places!")
    Character:LaunchWithForce(vel, 5.0, off, true)
end


-- TEMP EFFECTS

-- WIP, CURRENTLY BROKEN
function effects.ToggleLowGravity(Character)
    if not HookManager then return end
    effects.ShowText(Character, "Low Gravity (" .. tostring(TimerData.Seconds) .. "s)")
    HookManager.LowGravity = true
end


function effects.LockCamera(Character)
    if not HookManager then return end
    effects.ShowText(Character, "Locked camera (" .. tostring(TimerData.Seconds) .. "s)")
    HookManager.CameraLock = true
end


function effects.ConstantJump(Character)
    if not HookManager then return end
    effects.ShowText(Character, "Forced jumps (" .. tostring(TimerData.Seconds) .. "s)")
    HookManager.ForcedJumps = true
end


-- Returns each temp effect func if it is free
function effects.GetValidTempEffects()
    if not HookManager then return end

    local tempEffects = {}
    if not HookManager.CameraLock then
        tempEffects[#tempEffects+1] = effects.LockCamera
    end
    -- if not HookManager.LowGravity then
    --     tempEffects[#tempEffects+1] = effects.ToggleLowGravity
    -- end
    if not HookManager.ForcedJumps then
        tempEffects[#tempEffects+1] = effects.ConstantJump
    end

    return tempEffects
end


return effects