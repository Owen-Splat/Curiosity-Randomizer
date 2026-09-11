local UEHelpers = require("UEHelpers")

local EffectText = require("UI/effect_text")
local EffectTimer = require("UI/effect_timer")
local ModMenu = require("UI/mod_menu")

local Visibility_VISIBLE = 0
local Visibility_HIDDEN = 2
local Visibility_SELFHITTESTINVISIBLE = 4

local textWidget = nil
local textControl = nil
local defaultText = "Randomizer Mod v0.3.0 by Owen_Splat\nPress F5 to toggle the randomizer menu"

local timerWidget = nil
local timerControl = nil
local timerRaw = 20.0

local modMenuHUD = nil

local funcs = {}


local function ToggleModMenu()
    -- only allow the menu on the title screen / dont run if character exists
    local MainMenuState = FindFirstOf("BP_MainMenuState_C")
    if not MainMenuState or not MainMenuState:IsValid() then return end

    if not textWidget or not textWidget:IsValid() then return end
    if not timerWidget or not timerWidget:IsValid() then return end
    if not modMenuHUD or not modMenuHUD:IsValid() then return end

    if modMenuHUD:GetVisibility() == Visibility_HIDDEN then
        modMenuHUD:SetVisibility(Visibility_VISIBLE)
        timerWidget:SetVisibility(Visibility_HIDDEN)
    else
        modMenuHUD:SetVisibility(Visibility_HIDDEN)
        timerWidget:SetVisibility(Visibility_SELFHITTESTINVISIBLE)
        funcs.Reset()
    end
end


function funcs.Init()
    ExecuteInGameThread(function()
        textWidget, textControl = EffectText.new(defaultText)
        timerWidget, timerControl = EffectTimer.new(tostring(timerRaw))
        modMenuHUD = ModMenu.new()
        RegisterKeyBind(Key.F5, ToggleModMenu)
        ToggleModMenu()
    end)
end


function funcs.SetText(text)
    if not textControl then return end
    textControl:SetText(FText(text))
end


function funcs.UpdateTimer(DeltaSeconds)
    if not timerControl then return end
    timerRaw = timerRaw - DeltaSeconds
    if timerRaw <= 0.0 then
        timerRaw = 0.0
    end
    local timerString = string.format("%.2f", timerRaw)
    timerControl:SetText(FText(timerString))
    return timerRaw
end


local function SetTimerVisibility(visibility)
    if not timerWidget or not timerWidget:IsValid() then return end
    timerWidget:SetVisibility(visibility)
end


local function SetTextVisibility(visibility)
    if not textWidget or not textWidget:IsValid() then return end
    textWidget:SetVisibility(visibility)
end


function funcs.ShowText()
    SetTextVisibility(Visibility_SELFHITTESTINVISIBLE)
end


function funcs.HideText()
    SetTextVisibility(Visibility_HIDDEN)
end


function funcs.ShowTimer()
    SetTimerVisibility(Visibility_SELFHITTESTINVISIBLE)
end


function funcs.HideTimer()
    SetTimerVisibility(Visibility_HIDDEN)
end


function funcs.ResetTimer()
    if not modMenuHUD or not modMenuHUD:IsValid() then return end
    timerRaw = math.floor(ModMenu.GetSettings()["EffectTimer"])
end


function funcs.GetSettings()
    if not modMenuHUD or not modMenuHUD:IsValid() then return end
    return ModMenu.GetSettings()
end


function funcs.Reset()
    local settings = funcs.GetSettings()
    if settings and settings["Effects"] then
        funcs.ShowTimer()
        funcs.ResetTimer()
        funcs.UpdateTimer(0.0)
    else
        funcs.HideTimer()
    end
    funcs.ShowText()
    funcs.SetText(defaultText)
    if modMenuHUD and modMenuHUD:IsValid() then
        modMenuHUD:SetVisibility(Visibility_HIDDEN)
    end
end


function funcs.GetTotalEffectTime()
    if not modMenuHUD or not modMenuHUD:IsValid() then
        return 20
    end
    return ModMenu.GetSettings()["EffectTimer"]
end


return funcs