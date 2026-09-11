local HorizontalBox = require("UI/Layout/horizontalbox")
local VerticalBox = require("UI/Layout/verticalbox")

local CheckBoxWidget = require("UI/Widget/checkbox")
local LabelWidget = require("UI/Widget/label")
local ScrollBoxWidget = require("UI/Widget/scrollbox")

local EffectMenu = {
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
    local pageScroll = ScrollBoxWidget.new("PageEffectScroll", parent, false)

    -- lock camera
    local lockBox = HorizontalBox.new("EffectLockBox", pageScroll)
    EffectMenu.lockWidget = CheckBoxWidget.new("EffectLockCheck", lockBox, true)
    local lockLabel = LabelWidget.new("EffectLockLabel", lockBox, 16, " Locked Camera")
    HorizontalBox.AddChildren(lockBox, EffectMenu.lockWidget, lockLabel)

    -- reversed camera
    local reverseBox = HorizontalBox.new("EffectReverseBox", pageScroll)
    EffectMenu.reversedWidget = CheckBoxWidget.new("EffectDJCheck", reverseBox, true)
    local reversedLabel = LabelWidget.new("EffectReverseLabel", reverseBox, 16, " Reversed Camera Controls")
    HorizontalBox.AddChildren(reverseBox, EffectMenu.reversedWidget, reversedLabel)

    -- upsidedown camera
    local upsidedownBox = HorizontalBox.new("EffectUpsidedownBox", pageScroll)
    EffectMenu.upsideDownWidget = CheckBoxWidget.new("EffectUpsidedownCheck", upsidedownBox, true)
    local upsidedownLabel = LabelWidget.new("EffectUpsidedownLabel", upsidedownBox, 16, " Upside-Down Camera")
    HorizontalBox.AddChildren(upsidedownBox, EffectMenu.upsideDownWidget, upsidedownLabel)

    -- rotating camera
    local rotateBox = HorizontalBox.new("EffectRotateBox", pageScroll)
    EffectMenu.rotateWidget = CheckBoxWidget.new("EffectRotateCheck", rotateBox, false)
    local rotateLabel = LabelWidget.new("EffectRotateLabel", rotateBox, 16, " Rotate Camera")
    HorizontalBox.AddChildren(rotateBox, EffectMenu.rotateWidget, rotateLabel)

    -- freeze
    local freezeBox = HorizontalBox.new("EffectFreezeBox", pageScroll)
    EffectMenu.freezeWidget = CheckBoxWidget.new("EffectFreezeCheck", freezeBox, false)
    local freezeLabel = LabelWidget.new("EffectFreezeLabel", freezeBox, 16, " Freeze Player")
    HorizontalBox.AddChildren(freezeBox, EffectMenu.freezeWidget, freezeLabel)

    -- forced jump
    local forcedBox = HorizontalBox.new("EffectForcedJumpBox", pageScroll)
    EffectMenu.constantJumpWidget = CheckBoxWidget.new("EffectForcedJumpCheck", forcedBox, false)
    local forcedLabel = LabelWidget.new("EffectForcedJumpLabel", forcedBox, 16, " Forced Jumps")
    HorizontalBox.AddChildren(forcedBox, EffectMenu.constantJumpWidget, forcedLabel)

    -- infinite jumps
    local infiniteBox = HorizontalBox.new("EffectInfiniteBox", pageScroll)
    EffectMenu.infiniteJumpsWidget = CheckBoxWidget.new("EffectInfiniteCheck", infiniteBox, false)
    local infiniteLabel = LabelWidget.new("EffectInfiniteLabel", infiniteBox, 16, " Infinite Jumps")
    HorizontalBox.AddChildren(infiniteBox, EffectMenu.infiniteJumpsWidget, infiniteLabel)

    -- low gravity
    local gravityBox = HorizontalBox.new("EffectLowGravBox", pageScroll)
    EffectMenu.gravityWidget = CheckBoxWidget.new("EffectLowGravCheck", gravityBox, false)
    local gravityLabel = LabelWidget.new("EffectLowGravLabel", gravityBox, 16, " Low Gravity")
    HorizontalBox.AddChildren(gravityBox, EffectMenu.gravityWidget, gravityLabel)

    -- invisible
    local invisBox = HorizontalBox.new("EffectInvisBox", pageScroll)
    EffectMenu.invisibleWidget = CheckBoxWidget.new("EffectInvisCheck", invisBox, false)
    local invisLabel = LabelWidget.new("EffectInvisLabel", invisBox, 16, " Invisible")
    HorizontalBox.AddChildren(invisBox, EffectMenu.invisibleWidget, invisLabel)

    -- add all to scrollbox
    ScrollBoxWidget.AddChildren(pageScroll,
        lockBox, LabelWidget.new("EffectPadding1", pageScroll, 16, ""),
        reverseBox, LabelWidget.new("EffectPadding2", pageScroll, 16, ""),
        upsidedownBox, LabelWidget.new("EffectPadding3", pageScroll, 16, ""),
        rotateBox, LabelWidget.new("EffectPadding4", pageScroll, 16, ""),
        freezeBox, LabelWidget.new("EffectPadding5", pageScroll, 16, ""),
        forcedBox, LabelWidget.new("EffectPadding6", pageScroll, 16, ""),
        infiniteBox, LabelWidget.new("EffectPadding7", pageScroll, 16, "")
    )

    return pageScroll
end


function EffectMenu.GetSettings()
    return {
        ["Locked Camera"] = EffectMenu.lockWidget:IsChecked(),
        ["Reversed Camera"] = EffectMenu.reversedWidget:IsChecked(),
        ["Upside-Down Camera"] = EffectMenu.upsideDownWidget:IsChecked(),
        ["Rotating Camera"] = EffectMenu.rotateWidget:IsChecked(),
        ["Freeze Player"] = EffectMenu.freezeWidget:IsChecked(),
        ["Forced Jump"] = EffectMenu.constantJumpWidget:IsChecked(),
        ["Infinite Jumps"] = EffectMenu.infiniteJumpsWidget:IsChecked(),
        ["Low Gravity"] = EffectMenu.gravityWidget:IsChecked(),
        ["Invisible"] = EffectMenu.invisibleWidget:IsChecked()
    }
end


return EffectMenu