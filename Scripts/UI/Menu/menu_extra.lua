local HorizontalBox = require("UI/Layout/horizontalbox")
local VerticalBox = require("UI/Layout/verticalbox")

local CheckBoxWidget = require("UI/Widget/checkbox")
local LabelWidget = require("UI/Widget/label")

local ExtraMenu = {
    meowSpeedWidget = nil
}


function ExtraMenu.new(parent)
    local menuLayout = VerticalBox.new("MenuExtraLayout", parent)

    -- meow gives speed boost
    local meowBox = HorizontalBox.new("MeowBox", menuLayout)
    ExtraMenu.meowSpeedWidget = CheckBoxWidget.new("MeowSpeedCheck", meowBox, true)
    local meowLabel = LabelWidget.new("MeowSpeedLabel", meowBox, 16, " Meow Gives Speed Boost")
    HorizontalBox.AddChildren(meowBox, ExtraMenu.meowSpeedWidget, meowLabel)
    menuLayout:AddChildToVerticalBox(meowBox)

    return menuLayout
end


function ExtraMenu.GetSettings()
    return {
        ["Meow Speed Boost"] = ExtraMenu.meowSpeedWidget:IsChecked()
    }
end


return ExtraMenu