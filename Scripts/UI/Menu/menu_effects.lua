local HorizontalBox = require("UI/Layout/horizontalbox")
local VerticalBox = require("UI/Layout/verticalbox")

local CheckBoxWidget = require("UI/Widget/checkbox")
local LabelWidget = require("UI/Widget/label")

local EffectMenu = {
    dashWidget = nil,
    doubleJumpWidget = nil,
    spawnsWidget = nil,
    colorWidget = nil,
    gravityWidget = nil,
    constantJumpWidget = nil,
    freezeWidget = nil,
    infiniteJumpsWidget = nil,
    invisibleWidget = nil,
    lockWidget = nil,
    reversedWidget = nil,
    upsideDownWidget = nil,
    rotateWidget = nil,
}


function EffectMenu.new(parent)
    local menuLayout = VerticalBox.new("MenuEffectLayout", parent)

    -- toggle dash
    local dashBox = HorizontalBox.new("EffectDashBox", menuLayout)
    EffectMenu.dashWidget = CheckBoxWidget.new("EffectDashCheck", dashBox, true)
    local dashLabel = LabelWidget.new("EffectDashLabel", dashBox, 16, " Toggle Dash Unlocked")
    HorizontalBox.AddChildren(dashBox, EffectMenu.dashWidget, dashLabel)
    menuLayout:AddChildToVerticalBox(dashBox)

    -- padding
    menuLayout:AddChildToVerticalBox(LabelWidget.new("DJPadding", menuLayout, 16, ""))

    -- toggle double jump
    local djBox = HorizontalBox.new("EffectDJBox", menuLayout)
    EffectMenu.doubleJumpWidget = CheckBoxWidget.new("EffectDJCheck", djBox, true)
    local effectsLabel = LabelWidget.new("EffectsLabel", djBox, 16, " Toggle Double Jump Unlocked")
    HorizontalBox.AddChildren(djBox, EffectMenu.doubleJumpWidget, effectsLabel)
    menuLayout:AddChildToVerticalBox(djBox)

    return menuLayout
end


function EffectMenu.GetSettings()
    return {
        ["Toggle Dash"] = EffectMenu.dashWidget:IsChecked(),
        ["Toggle Double Jump"] = EffectMenu.doubleJumpWidget:IsChecked(),
        -- ["Random Spawns"] = EffectMenu.spawnsWidget:IsChecked()
    }
end


return EffectMenu