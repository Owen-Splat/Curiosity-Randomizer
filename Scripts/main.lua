local UIManager = require("ui")

print("[EffectRandomizer] Script initialized successfully!")

RegisterHook("/Script/Engine.PlayerController:ClientRestart", function(self, newPawn)
    require("hooks")
end)

-- Create the seed when the mod loads
math.randomseed(os.time())

-- Init our custom text
UIManager.Init()