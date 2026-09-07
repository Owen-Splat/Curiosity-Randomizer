local UEHelpers = require("UEHelpers")
local TimerData = require("timer")

local Visibility_VISIBLE = 0
local Visibility_COLLAPSED = 1
local Visibility_HIDDEN = 2
local Visibility_HITTESTINVISIBLE = 3
local Visibility_SELFHITTESTINVISIBLE = 4
local Visibility_ALL = 5

local textWidget = nil
local textControl = nil
local defaultText = "Randomizer Mod v0.2.0 by Owen_Splat"

local timerWidget = nil
local timerControl = nil
local timerRaw = 20.0

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

    hud:AddToViewport(99)

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

    hud:AddToViewport(99)

    timerWidget = canvas
    timerControl = textBlock
end


function funcs.Init()
    ExecuteInGameThread(function()
        CreateTextWidget()
        timerRaw = TimerData.Seconds / 1.0
        CreateTimerWidget(tostring(timerRaw))
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
    if not timerWidget or not timerWidget:IsValid() then return end
    timerWidget:SetVisibility(visibility)
end


function funcs.ShowText()
    SetTextVisibility(Visibility_VISIBLE)
end


function funcs.HideText()
    SetTextVisibility(Visibility_HIDDEN)
end


function funcs.ShowTimer()
    SetTimerVisibility(Visibility_VISIBLE)
end


function funcs.HideTimer()
    SetTimerVisibility(Visibility_HIDDEN)
end


function funcs.ResetTimer()
    timerRaw = TimerData.Seconds / 1.0
end


function funcs.Reset()
    funcs.ShowText()
    funcs.ShowTimer()
    funcs.SetText(defaultText)
    funcs.ResetTimer()
    funcs.UpdateTimer(0.0)
end


return funcs