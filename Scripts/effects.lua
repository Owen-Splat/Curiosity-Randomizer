local UEHelpers = require("UEHelpers")
local UIManager = require("ui")

local LoopCount = 0
local SpawnedObj = nil
local WasLastTemp = false

local effects = {
    settings = {
        CameraLock = false,
        ReversedCamera = false,
        UpsideDown = false,
        CameraRotate = false,
        ForcedJumps = false,
        Frozen = false,
        LowGravity = false,
        InfiniteJumps = false,
        IsInvisible = false
    }
}


local function ShowText(RawText, IsTemp)
    if IsTemp then
        RawText = RawText .. " (" .. tostring(UIManager.GetTotalEffectTime()) .. "s)"
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


local function SpawnCannon(Character)
    local CannonOrig = FindFirstOf("BP_CannonAttacker_C")
    if not CannonOrig or not CannonOrig:IsValid() then return end
    ShowText("And so I started blastin'...")

    -- we want to spawn the cannon relative to the direction the player is currently facing
    -- and also to have it pointing at the player
    local PlayerLocation = Character:K2_GetActorLocation()
    local ForwardVector = Character:GetActorForwardVector()
    local SpawnDistance = 1250.0
    local SpawnLocation = {
        X = PlayerLocation.X + (ForwardVector.X * SpawnDistance),
        Y = PlayerLocation.Y + (ForwardVector.Y * SpawnDistance),
        Z = PlayerLocation.Z + 200.0
    }
    local SpawnRotation = Character:K2_GetActorRotation()

    local World = CannonOrig:GetWorld()
    local ActorClass = CannonOrig:GetClass()
    SpawnedObj = World:SpawnActor(ActorClass, SpawnLocation, SpawnRotation)
    SpawnedObj:ReceiveActorBeginOverlap(Character) -- trigger the attack
end


local function SpawnHand(Character)
    local HandOrig = FindFirstOf("BP_Hand_Chaser_C")
    if not HandOrig or not HandOrig:IsValid() then return end
    ShowText("I know a guy who's pretty handy...")

    local PlayerLocation = Character:K2_GetActorLocation()
    local ForwardVector = Character:GetActorForwardVector()
    local SpawnDistance = 1250.0
    local SpawnLocation = {
        X = PlayerLocation.X + (ForwardVector.X * SpawnDistance),
        Y = PlayerLocation.Y + (ForwardVector.Y * SpawnDistance),
        Z = PlayerLocation.Z + 200.0
    }
    local SpawnRotation = Character:K2_GetActorRotation()

    local World = HandOrig:GetWorld()
    local ActorClass = HandOrig:GetClass()
    SpawnedObj = World:SpawnActor(ActorClass, SpawnLocation, SpawnRotation)
    SpawnedObj.HandID = -1
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
local function LockCamera(Character)
    ShowText("Locked camera", true)
    effects.settings.CameraLock = true
end


local function ReverseCamera(Character)
    ShowText("Inverted camera", true)
    effects.settings.ReversedCamera = true
end


local function UpsideDown(Character)
    ShowText("Upside-Down View", true)
    effects.settings.UpsideDown = true
end


local function RotateCamera(Character)
    ShowText("Rotating camera...", true)
    effects.settings.CameraRotate = true
end


local function ConstantJump(Character)
    ShowText("Forced jumps", true)
    effects.settings.ForcedJumps = true
end


local function ToggleLowGravity(Character)
    ShowText("Low Gravity", true)
    effects.settings.LowGravity = true
end


local function Freeze(Character)
    ShowText("Frozen", true)
    effects.settings.Frozen = true
end


local function InfiniteJumps(Character)
    ShowText("Infinite Jumps", true)
    effects.settings.InfiniteJumps = true
end


local function GoInvisible(Character)
    ShowText("Invisible", true)
    Character:SetActorHiddenInGame(true)
    effects.settings.IsInvisible = true
end


-- funcs for our tick hook to call
local function Cleanup(Player)
    -- destroy any spawned objects
    if SpawnedObj and SpawnedObj:IsValid() then
        SpawnedObj:K2_DestroyActor()
    end
    SpawnedObj = nil

    if effects.settings.IsInvisible then
        Player:SetActorHiddenInGame(false)
    end

    -- clear any temp effect at the next cycle
    for key, value in pairs(effects.settings) do
        if value == true then
            effects.settings[key] = false
            WasLastTemp = true
        end
    end
end


function effects.ApplyRandomEffect(Player)
    Cleanup(Player)
    LoopCount = LoopCount + 1

    local validFuncs = {
        ToggleDash,
        ToggleDoubleJump,
        SpawnDrum,
        SpawnYarnBall,
        InvertColors,
        SpawnConfetti,
        SpawnCannon,
        SpawnHand
    }

    if not WasLastTemp then
        validFuncs[#validFuncs+1] = ToggleLowGravity
        validFuncs[#validFuncs+1] = LockCamera
        validFuncs[#validFuncs+1] = ReverseCamera
        validFuncs[#validFuncs+1] = UpsideDown
        validFuncs[#validFuncs+1] = RotateCamera
        validFuncs[#validFuncs+1] = ConstantJump
        validFuncs[#validFuncs+1] = Freeze
        validFuncs[#validFuncs+1] = InfiniteJumps
        validFuncs[#validFuncs+1] = GoInvisible
    end
    WasLastTemp = false

    if LoopCount % 4 == 0 then
        validFuncs[#validFuncs+1] = LaunchRandomDirection
    end

    local randomIndex = math.random(1, #validFuncs)
    validFuncs[randomIndex](Player)
end


return effects