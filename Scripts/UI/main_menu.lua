local UEHelpers = require("UEHelpers")

local HorizontalBox = require("UI/Layout/horizontalbox")
local VerticalBox = require("UI/Layout/verticalbox")
local SizeBox = require("UI/Layout/sizebox")

local ButtonWidget = require("UI/Widget/button")
local CheckBoxWidget = require("UI/Widget/checkbox")
local LabelWidget = require("UI/Widget/label")
local SliderWidget = require("UI/Widget/slider")

local MainMenu = {
    collectablesWidget = nil,
    effectsWidget = nil,
    effectsTimerWidget = nil,
    meowSpeedWidget = nil
}


local function FLinearColor(R,G,B,A) return {R=R,G=G,B=B,A=A} end
local function FSlateColor(R,G,B,A) return {SpecifiedColor=FLinearColor(R,G,B,A), ColorUseRule=0} end


function MainMenu.new()
    local gi = UEHelpers.GetGameInstance()
    local hud = StaticConstructObject(StaticFindObject("/Script/UMG.UserWidget"), gi, FName("MenuHUD"))
    hud.WidgetTree = StaticConstructObject(StaticFindObject("/Script/UMG.WidgetTree"), hud, FName("MenuTree"))

    local canvas = StaticConstructObject(StaticFindObject("/Script/UMG.CanvasPanel"), hud.WidgetTree, FName("MenuCanvas"))
    hud.WidgetTree.RootWidget = canvas

    local border = StaticConstructObject(StaticFindObject("/Script/UMG.Border"), canvas, FName("MenuBorder"))
    border:SetBrushColor(FLinearColor(0.05, 0.05, 0.05, .95))
    border:SetPadding({Left = 30, Top = 30, Right = 30, Bottom = 30})

    local menuLayout = VerticalBox.new("MenuLayout", border)
    border:SetContent(menuLayout)

    -- menu title
    local titleLabel = LabelWidget.new("TitleLabel", menuLayout, 24, "Randomizer Mod Menu\n")
    menuLayout:AddChildToVerticalBox(titleLabel)

    -- randomize collectables
    local collectablesBox = HorizontalBox.new("CollectablesBox", border)
    MainMenu.collectablesWidget = CheckBoxWidget.new("CollectablesCheck", collectablesBox, true)
    local collectablesLabel = LabelWidget.new("CollectablesLabel", collectablesBox, 16, " Randomize Collectables")
    HorizontalBox.AddChildren(collectablesBox, MainMenu.collectablesWidget, collectablesLabel)
    menuLayout:AddChildToVerticalBox(collectablesBox)

    -- random effects
    local effectsBox = HorizontalBox.new("EffectsBox", menuLayout)
    MainMenu.effectsWidget = CheckBoxWidget.new("EffectsCheck", effectsBox, true)
    local effectsLabel = LabelWidget.new("EffectsLabel", effectsBox, 16, " Random Effects")
    HorizontalBox.AddChildren(effectsBox, MainMenu.effectsWidget, effectsLabel)
    menuLayout:AddChildToVerticalBox(effectsBox)

    -- effects timer
    local timerBox = HorizontalBox.new("TimerBox", menuLayout)
    local timerLabel = LabelWidget.new("TimerLabel", timerBox, 16, "Effects Timer: 20 ")
    local sliderBox = SizeBox.new("SliderBox", timerBox, 200.0, 24.0)
    MainMenu.effectsTimerWidget = SliderWidget.new("TimerSlider", sliderBox, 10, 60, 20, 5, timerLabel, "Effects Timer: ")
    sliderBox:AddChild(MainMenu.effectsTimerWidget)
    HorizontalBox.AddChildren(timerBox, timerLabel, sliderBox)
    menuLayout:AddChildToVerticalBox(timerBox)

    -- padding between randomizer and extra settings
    menuLayout:AddChildToVerticalBox(LabelWidget.new("MeowPadding", menuLayout, 20, ""))

    -- meow speed boost check
    local meowBox = HorizontalBox.new("MeowBox", menuLayout)
    MainMenu.meowSpeedWidget = CheckBoxWidget.new("MeowCheck", meowBox, false)
    local MeowLabel = LabelWidget.new("MeowLabel", meowBox, 16, " Meow Gives Speed Boost")
    HorizontalBox.AddChildren(meowBox, MainMenu.meowSpeedWidget, MeowLabel)
    menuLayout:AddChildToVerticalBox(meowBox)

    -- add the menu hud
    local slot = canvas:AddChildToCanvas(border)
    slot:SetSize({X = 400, Y = 500})
    slot:SetAnchors({Minimum = {X = 0.5, Y = 0.5}, Maximum = {X = 0.5, Y = 0.5}})
    slot:SetAlignment({X = 0.5, Y = 0.5})
    slot:SetPosition({X = 0, Y = 0})

    hud:AddToViewport(102)
    hud:SetVisibility(0)
    return hud
end


function MainMenu.GetSettings()
    return {
        ["Collectables"] = MainMenu.collectablesWidget:IsChecked(),
        ["Effects"] = MainMenu.effectsWidget:IsChecked(),
        ["Meow Speed Boost"] = MainMenu.meowSpeedWidget:IsChecked()
    }
end


return MainMenu