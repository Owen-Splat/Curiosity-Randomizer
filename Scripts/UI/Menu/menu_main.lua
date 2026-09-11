local HorizontalBox = require("UI/Layout/horizontalbox")
local VerticalBox = require("UI/Layout/verticalbox")
local SizeBox = require("UI/Layout/sizebox")

local CheckBoxWidget = require("UI/Widget/checkbox")
local LabelWidget = require("UI/Widget/label")
local SliderWidget = require("UI/Widget/slider")

local MainMenu = {
    collectablesWidget = nil,
    effectsWidget = nil,
    effectsTimerWidget = nil,
}


function MainMenu.new(parent)
    local menuLayout = VerticalBox.new("MenuMainLayout", parent)

    -- randomize collectables
    local collectablesBox = HorizontalBox.new("CollectablesBox", menuLayout)
    MainMenu.collectablesWidget = CheckBoxWidget.new("CollectablesCheck", collectablesBox, true)
    local collectablesLabel = LabelWidget.new("CollectablesLabel", collectablesBox, 16, " Randomize Collectables")
    HorizontalBox.AddChildren(collectablesBox, MainMenu.collectablesWidget, collectablesLabel)
    menuLayout:AddChildToVerticalBox(collectablesBox)

    -- padding
    menuLayout:AddChildToVerticalBox(LabelWidget.new("EffectsPadding", menuLayout, 16, ""))

    -- random effects
    local effectsBox = HorizontalBox.new("EffectsBox", menuLayout)
    MainMenu.effectsWidget = CheckBoxWidget.new("EffectsCheck", effectsBox, true)
    local effectsLabel = LabelWidget.new("EffectsLabel", effectsBox, 16, " Random Effects")
    HorizontalBox.AddChildren(effectsBox, MainMenu.effectsWidget, effectsLabel)
    menuLayout:AddChildToVerticalBox(effectsBox)

    -- padding
    menuLayout:AddChildToVerticalBox(LabelWidget.new("TimerPadding", menuLayout, 16, ""))

    -- effects timer
    local timerBox = HorizontalBox.new("TimerBox", menuLayout)
    local timerLabel = LabelWidget.new("TimerLabel", timerBox, 16, "Effects Timer: 20 ")
    local sliderBox = SizeBox.new("SliderBox", timerBox, 200.0, 24.0)
    MainMenu.effectsTimerWidget = SliderWidget.new("TimerSlider", sliderBox, 10, 60, 20, 5, timerLabel, "Effects Timer: ")
    sliderBox:AddChild(MainMenu.effectsTimerWidget)
    HorizontalBox.AddChildren(timerBox, timerLabel, sliderBox)
    menuLayout:AddChildToVerticalBox(timerBox)

    return menuLayout
end


function MainMenu.GetSettings()
    return {
        ["Collectables"] = MainMenu.collectablesWidget:IsChecked(),
        ["Effects"] = MainMenu.effectsWidget:IsChecked(),
        ["EffectTimer"] = MainMenu.effectsTimerWidget.Value,
    }
end


return MainMenu