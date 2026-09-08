local UEHelpers = require("UEHelpers")

local Visibility_VISIBLE = 0
local Visibility_COLLAPSED = 1
local Visibility_HIDDEN = 2
local Visibility_HITTESTINVISIBLE = 3
local Visibility_SELFHITTESTINVISIBLE = 4
local Visibility_ALL = 5

local textWidget = nil
local textControl = nil
local defaultText = "Randomizer Mod v0.2.0 by Owen_Splat\nPress F5 to open the randomizer menu"

local timerWidget = nil
local timerControl = nil
local timerStart = 20.0
local timerRaw = 20.0

local modMenuHUD = nil
local modMenuVisible = true

local collectablesWidget = nil
local effectsWidget = nil
local effectsTimerWidget = nil
local meowSpeedWidget = nil

-- Alignment presets
local alignments = {
    center = {anchor = {0.5, 0.5}, align = {0.5, 0.5}, pos = {0, 0}},
    top = {anchor = {0.5, 0}, align = {0.5, 0}, pos = {0, 10}},
    bottom = {anchor = {0.5, 1}, align = {0.5, 1}, pos = {0, -10}},
    topleft = {anchor = {0, 0}, align = {0, 0}, pos = {10, 10}},
    topright = {anchor = {1, 0}, align = {1, 0}, pos = {-10, 10}},
    bottomleft = {anchor = {0, 1}, align = {0, 1}, pos = {10, -10}},
    bottomright = {anchor = {1, 1}, align = {1, 1}, pos = {-10, -10}}
}


local funcs = {}

local function FLinearColor(R,G,B,A) return {R=R,G=G,B=B,A=A} end
local function FSlateColor(R,G,B,A) return {SpecifiedColor=FLinearColor(R,G,B,A), ColorUseRule=0} end


local function CreateTextWidget()
    local alignment = "top"

    local gi = UEHelpers.GetGameInstance()
    local hud = StaticConstructObject(StaticFindObject("/Script/UMG.UserWidget"), gi, FName("SimpleHUD"))
    hud.WidgetTree = StaticConstructObject(StaticFindObject("/Script/UMG.WidgetTree"), hud, FName("SimpleTree"))

    local canvas = StaticConstructObject(StaticFindObject("/Script/UMG.CanvasPanel"), hud.WidgetTree, FName("SimpleCanvas"))
    hud.WidgetTree.RootWidget = canvas

    local border = StaticConstructObject(StaticFindObject("/Script/UMG.Border"), canvas, FName("SimpleBorder"))
    border:SetBrushColor(FLinearColor(0, 0, 0, .5))
    border:SetPadding({Left = 20, Top = 10, Right = 20, Bottom = 10})

    local textBlock = StaticConstructObject(StaticFindObject("/Script/UMG.TextBlock"), border, FName("SimpleText"))

    textBlock.Font.Size = 20
    textBlock:SetText(FText(defaultText))
    textBlock:SetColorAndOpacity(FSlateColor(1,1,1,1))
    textBlock:SetShadowOffset({X = 1, Y = 1})
    textBlock:SetShadowColorAndOpacity(FLinearColor(0, 0, 0, 0.75))

    border:SetContent(textBlock)

    local slot = canvas:AddChildToCanvas(border)
    slot:SetAutoSize(true)

    local a = alignments[alignment] or alignments.center
    slot:SetAnchors({Minimum = {X = a.anchor[1], Y = a.anchor[2]}, Maximum = {X = a.anchor[1], Y = a.anchor[2]}})
    slot:SetAlignment({X = a.align[1], Y = a.align[2]})
    slot:SetPosition({X = a.pos[1], Y = a.pos[2]})

    canvas.Visibility = 4
    border.Visibility = 4
    textBlock.Visibility = 4

    hud:AddToViewport(101)

    textWidget = canvas
    textControl = textBlock
end


local function CreateTimerWidget(text)
    local alignment = "bottomleft"

    local gi = UEHelpers.GetGameInstance()
    local hud = StaticConstructObject(StaticFindObject("/Script/UMG.UserWidget"), gi, FName("TimerHUD"))
    hud.WidgetTree = StaticConstructObject(StaticFindObject("/Script/UMG.WidgetTree"), hud, FName("TimerTree"))

    local canvas = StaticConstructObject(StaticFindObject("/Script/UMG.CanvasPanel"), hud.WidgetTree, FName("TimerCanvas"))
    hud.WidgetTree.RootWidget = canvas

    local border = StaticConstructObject(StaticFindObject("/Script/UMG.Border"), canvas, FName("TimerBorder"))
    border:SetBrushColor(FLinearColor(0, 0, 0, .5))
    border:SetPadding({Left = 20, Top = 10, Right = 20, Bottom = 10})

    local textBlock = StaticConstructObject(StaticFindObject("/Script/UMG.TextBlock"), border, FName("TimerText"))

    textBlock.Font.Size = 20
    textBlock:SetText(FText(text))
    textBlock:SetColorAndOpacity(FSlateColor(1,1,1,1))
    textBlock:SetShadowOffset({X = 1, Y = 1})
    textBlock:SetShadowColorAndOpacity(FLinearColor(0, 0, 0, 0.75))

    border:SetContent(textBlock)

    local slot = canvas:AddChildToCanvas(border)
    slot:SetAutoSize(true)

    local a = alignments[alignment] or alignments.center
    slot:SetAnchors({Minimum = {X = a.anchor[1], Y = a.anchor[2]}, Maximum = {X = a.anchor[1], Y = a.anchor[2]}})
    slot:SetAlignment({X = a.align[1], Y = a.align[2]})
    slot:SetPosition({X = a.pos[1], Y = a.pos[2]})

    canvas.Visibility = 4
    border.Visibility = 4
    textBlock.Visibility = 4

    hud:AddToViewport(101)

    timerWidget = canvas
    timerControl = textBlock
end


local function CreateModMenu()
    -- fluff
    local gi = UEHelpers.GetGameInstance()
    local hud = StaticConstructObject(StaticFindObject("/Script/UMG.UserWidget"), gi, FName("MenuHUD"))
    hud.WidgetTree = StaticConstructObject(StaticFindObject("/Script/UMG.WidgetTree"), hud, FName("MenuTree"))

    local canvas = StaticConstructObject(StaticFindObject("/Script/UMG.CanvasPanel"), hud.WidgetTree, FName("MenuCanvas"))
    hud.WidgetTree.RootWidget = canvas

    local border = StaticConstructObject(StaticFindObject("/Script/UMG.Border"), canvas, FName("MenuBorder"))
    border:SetBrushColor(FLinearColor(0.05, 0.05, 0.05, .95))
    border:SetPadding({Left = 30, Top = 30, Right = 30, Bottom = 30})

    local verticalBox = StaticConstructObject(StaticFindObject("/Script/UMG.VerticalBox"), border, FName("MenuVerticalBox"))
    border:SetContent(verticalBox)

    -- menu title
    local titleLabel = StaticConstructObject(StaticFindObject("/Script/UMG.TextBlock"), verticalBox, FName("TitleLabel"))
    titleLabel.Font.Size = 24
    titleLabel:SetText(FText("Randomizer Mod Menu\n"))
    verticalBox:AddChildToVerticalBox(titleLabel)

    -- randomize collectables
    local collectablesBox = StaticConstructObject(StaticFindObject("/Script/UMG.HorizontalBox"), border, FName("CollectablesBox"))

    collectablesWidget = StaticConstructObject(StaticFindObject("/Script/UMG.CheckBox"), collectablesBox, FName("CollectablesCheck"))
    collectablesWidget:SetIsChecked(true)

    local collectablesLabel = StaticConstructObject(StaticFindObject("/Script/UMG.TextBlock"), collectablesBox, FName("CollectablesLabel"))
    collectablesLabel.Font.Size = 16
    collectablesLabel:SetText(FText(" Randomize Collectables"))

    collectablesBox:AddChildToHorizontalBox(collectablesWidget)
    collectablesBox:AddChildToHorizontalBox(collectablesLabel)
    verticalBox:AddChildToVerticalBox(collectablesBox)

    -- random effects
    local effectsBox = StaticConstructObject(StaticFindObject("/Script/UMG.HorizontalBox"), border, FName("EffectsBox"))

    effectsWidget = StaticConstructObject(StaticFindObject("/Script/UMG.CheckBox"), effectsBox, FName("EffectsCheck"))
    effectsWidget:SetIsChecked(true)

    local effectsLabel = StaticConstructObject(StaticFindObject("/Script/UMG.TextBlock"), effectsBox, FName("EffectsLabel"))
    effectsLabel.Font.Size = 16
    effectsLabel:SetText(FText(" Random Effects"))

    effectsBox:AddChildToHorizontalBox(effectsWidget)
    effectsBox:AddChildToHorizontalBox(effectsLabel)
    verticalBox:AddChildToVerticalBox(effectsBox)

    -- effects timer
    local timerBox = StaticConstructObject(StaticFindObject("/Script/UMG.HorizontalBox"), border, FName("TimerBox"))

    local timerLabel = StaticConstructObject(StaticFindObject("/Script/UMG.TextBlock"), effectsBox, FName("TimerLabel"))
    timerLabel.Font.Size = 16
    timerLabel:SetText(FText("Effects Timer: 20 "))

    effectsTimerWidget = StaticConstructObject(StaticFindObject("/Script/UMG.Slider"), timerBox, FName("TimerSlider"))
    effectsTimerWidget:SetVisibility(0)
    effectsTimerWidget:SetMinValue(10.0)
    effectsTimerWidget:SetMaxValue(60.0)
    effectsTimerWidget:SetValue(20.0)

    local sliderSizeBox = StaticConstructObject(StaticFindObject("/Script/UMG.SizeBox"), timerBox, FName("SliderSizeBox"))
    sliderSizeBox:SetWidthOverride(200.0)
    sliderSizeBox:SetHeightOverride(24.0)
    sliderSizeBox:AddChild(effectsTimerWidget)
    verticalBox:AddChildToVerticalBox(timerBox)

    timerBox:AddChildToHorizontalBox(timerLabel)
    timerBox:AddChildToHorizontalBox(sliderSizeBox)
    verticalBox:AddChildToVerticalBox(timerBox)

    LoopAsync(100, function()
        if not effectsTimerWidget or not effectsTimerWidget:IsValid() then
            return true
        end

        local currentValue = effectsTimerWidget.Value
        if currentValue ~= timerRaw then
            timerStart = math.floor(currentValue)
            timerLabel:SetText(FText("Effects Timer: " .. tostring(timerStart) .. " "))
        end
        return false
    end)

    -- meow speed boost check
    local meowBox = StaticConstructObject(StaticFindObject("/Script/UMG.HorizontalBox"), border, FName("MeowBox"))

    meowSpeedWidget = StaticConstructObject(StaticFindObject("/Script/UMG.CheckBox"), meowBox, FName("MeowCheck"))
    meowSpeedWidget:SetIsChecked(true)

    local MeowLabel = StaticConstructObject(StaticFindObject("/Script/UMG.TextBlock"), meowBox, FName("MeowLabel"))
    MeowLabel.Font.Size = 16
    MeowLabel:SetText(FText(" Meow Gives Speed Boost"))

    meowBox:AddChildToHorizontalBox(meowSpeedWidget)
    meowBox:AddChildToHorizontalBox(MeowLabel)
    local meowPaddingLabel = StaticConstructObject(StaticFindObject("/Script/UMG.TextBlock"), border, FName("MeowPaddingLabel"))
    verticalBox:AddChildToVerticalBox(meowPaddingLabel)
    verticalBox:AddChildToVerticalBox(meowBox)

    -- fluff
    local slot = canvas:AddChildToCanvas(border)
    slot:SetSize({X = 400, Y = 500})
    slot:SetAnchors({Minimum = {X = 0.5, Y = 0.5}, Maximum = {X = 0.5, Y = 0.5}})
    slot:SetAlignment({X = 0.5, Y = 0.5})
    slot:SetPosition({X = 0, Y = 0})

    hud:AddToViewport(102)
    hud:SetVisibility(0)
    modMenuHUD = hud
end


function HideModMenu()
    if not modMenuHUD or not modMenuHUD:IsValid() then return end
    modMenuHUD:SetVisibility(Visibility_HIDDEN)
end


local function ToggleModMenu()
    -- only allow the menu on the title screen / dont run if character exists
    local MainMenu = FindFirstOf("BP_MainMenuState_C")
    if not MainMenu or not MainMenu:IsValid() then return end

    if not textWidget or not textWidget:IsValid() then return end
    if not timerWidget or not timerWidget:IsValid() then return end
    if not modMenuHUD or not modMenuHUD:IsValid() then return end

    modMenuVisible = not modMenuVisible

    if modMenuVisible then
        modMenuHUD:SetVisibility(Visibility_VISIBLE)
        textWidget:SetVisibility(Visibility_HIDDEN)
        timerWidget:SetVisibility(Visibility_HIDDEN)
    else
        modMenuHUD:SetVisibility(Visibility_HIDDEN)
        textWidget:SetVisibility(Visibility_SELFHITTESTINVISIBLE)
        timerWidget:SetVisibility(Visibility_SELFHITTESTINVISIBLE)
        funcs.Reset()
    end
end


function funcs.Init()
    ExecuteInGameThread(function()
        CreateTextWidget()
        CreateTimerWidget(tostring(timerRaw))
        CreateModMenu()
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
    timerRaw = timerStart
end


function funcs.GetSettings()
    if not collectablesWidget then return end
    if not effectsWidget then return end
    if not meowSpeedWidget then return end

    return {
        ["Collectables"] = collectablesWidget:IsChecked(),
        ["Effects"] = effectsWidget:IsChecked(),
        ["Meow Speed Boost"] = meowSpeedWidget:IsChecked()
    }
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
    HideModMenu()
end


function funcs.GetTotalEffectTime()
    return math.tointeger(timerStart)
end


return funcs