local UEHelpers = require("UEHelpers")
local TimerData = require("timer")
local UIManager = require("ui")

local LoopCount = 0
local SpawnedObj = nil

local effects = {
    settings = {
        CameraLock = false,
        ForcedJumps = false,
        Frozen = false,
        LowGravity = false,
        ReversedCamera = false,
        UpsideDown = false,
    }
}


local function ShowText(RawText, IsTemp)
    if IsTemp then
        RawText = RawText .. " (" .. tostring(TimerData.Seconds) .. "s)"
    end
    UIManager.SetText(RawText)
end


local function ToggleDoubleJump(Character)
    if Character.DoubleJump then
        ShowText("DOUBLE JUMP has been disabled")
        Character:SetDoubleJump(false)
    else
        ShowText("DOUBLE JUMP has been enabled")
        Character:SetDoubleJump(true)
    end
end


local function ToggleDash(Character)
    if Character.dashenablediguess then
        ShowText("DASH has been disabled")
        Character:SetDashEnabled(false)
    else
        ShowText("DASH has been enabled")
        Character:SetDashEnabled(true)
    end
end


local function SpawnDrum(Character)
    local TargetClassPath = "/Game/Blueprints/BouncyPlatforms/Bouncy_Drums.Bouncy_Drums_C"
    local ActorClass = StaticFindObject(TargetClassPath)
    if not ActorClass or not ActorClass:IsValid() then return end
    ShowText("Ba-dum-tss")
    local World = Character:GetWorld()
    local SpawnLocation = Character:K2_GetActorLocation()
    local SpawnRotation = {Pitch = 0.0, Yaw = 0.0, Roll = 0.0}
    SpawnedObj = World:SpawnActor(ActorClass, SpawnLocation, SpawnRotation)
end


local function SpawnYarnBall(Character)
    local TargetClassPath = "/Game/Blueprints/Yarn/BP_YarnBall.BP_YarnBall_C"
    local ActorClass = StaticFindObject(TargetClassPath)
    if not ActorClass or not ActorClass:IsValid() then return end
    ShowText("You're on a roll!")
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


local function SpawnConfetti(Character)
    local TargetClassPath = "/Game/Blueprints/Challenges/Utils/BP_ChallengeConfetti.BP_ChallengeConfetti_C"
    local ActorClass = StaticFindObject(TargetClassPath)
    if not ActorClass or not ActorClass:IsValid() then return end
    ShowText("You're doing great!")
    local SpawnLocation = Character:K2_GetActorLocation()
    SpawnLocation.Z = SpawnLocation.Z + 150.0
    local SpawnRotation = {Pitch=0.0, Yaw=0.0, Roll=0.0}
    SpawnedObj = Character:GetWorld():SpawnActor(ActorClass, SpawnLocation, SpawnRotation)
    SpawnedObj['Start Celebration']()
end



local function LaunchRandomDirection(Character)
    local vel = {X = math.random(-500, 500), Y = math.random(-500, 500), Z = math.random(1000, 1500)}
    local off = {X = 0.0, Y = 0.0, Z = 0.0}
    ShowText("You're going places!")
    Character:LaunchWithForce(vel, 5.0, off, true)
end


local function InvertColors(Character)
    local Cam = Character.Camera
    if not Cam or not Cam:IsValid() then return end
    Character.Camera.PostProcessSettings.bOverride_ColorSaturation = true
    if Cam.PostProcessSettings.ColorSaturation.X == -1.0 then
        ShowText("Normal Colors")
        Cam.PostProcessSettings.ColorSaturation = {X=1.0, Y=1.0, Z=1.0, W=1.0}
    else
        ShowText("Inverted Colors")
        Cam.PostProcessSettings.ColorSaturation = {X=-1.0, Y=-1.0, Z=-1.0, W=1.0}
    end
end


-- local function VetVisit(Character)
--     local LevelManager = FindFirstOf("LevelManager_C")
--     if LevelManager and LevelManager:IsValid() then
--         ExecuteInGameThread(function()
--             LevelManager['SwitchToLevel (By Name)'](LevelManager, "Hell")
--         end)
--     end
-- end


-- TEMP EFFECTS
local function ToggleLowGravity(Character)
    ShowText("Low Gravity (" .. tostring(TimerData.Seconds) .. "s)")
    effects.settings.LowGravity = true
end


local function LockCamera(Character)
    ShowText("Locked camera (" .. tostring(TimerData.Seconds) .. "s)")
    effects.settings.CameraLock = true
end


local function ReverseCamera(Character)
    ShowText("Inverted camera (" .. tostring(TimerData.Seconds) .. "s)")
    effects.settings.ReversedCamera = true
end


local function ConstantJump(Character)
    ShowText("Forced jumps (" .. tostring(TimerData.Seconds) .. "s)")
    effects.settings.ForcedJumps = true
end


local function UpsideDown(Character)
    ShowText("Upside-Down View (" .. tostring(TimerData.Seconds) .. "s)")
    effects.settings.UpsideDown = true
end


local function Freeze(Character)
    ShowText("Frozen (" .. tostring(TimerData.Seconds) .. "s)")
    effects.settings.Frozen = true
end


-- funcs for our tick hook to call
local function Cleanup()
    -- destroy any spawned objects
    if SpawnedObj and SpawnedObj:IsValid() then
        SpawnedObj:K2_DestroyActor()
    end
    SpawnedObj = nil

    -- clear any temp effect at the next cycle
    for key, value in pairs(effects.settings) do
        effects.settings[key] = false
    end
end


function effects.ApplyRandomEffect(Player)
    Cleanup()
    LoopCount = LoopCount + 1

    local validFuncs = {
        ToggleDash,
        ToggleDoubleJump,
        SpawnDrum,
        SpawnYarnBall,
        InvertColors,
        SpawnConfetti
    }

    if LoopCount % 2 == 0 then
        validFuncs[#validFuncs+1] = ToggleLowGravity
        validFuncs[#validFuncs+1] = LockCamera
        validFuncs[#validFuncs+1] = ReverseCamera
        validFuncs[#validFuncs+1] = UpsideDown
        validFuncs[#validFuncs+1] = ConstantJump
        validFuncs[#validFuncs+1] = Freeze
    end

    if LoopCount % 4 == 0 then
        validFuncs[#validFuncs+1] = LaunchRandomDirection
    end

    local randomIndex = math.random(1, #validFuncs)
    validFuncs[randomIndex](Player)
end


return effects