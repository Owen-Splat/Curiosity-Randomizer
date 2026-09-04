local UEHelpers = require("UEHelpers")

local Visibility_VISIBLE = 0
local Visibility_COLLAPSED = 1
local Visibility_HIDDEN = 2
local Visibility_HITTESTINVISIBLE = 3
local Visibility_SELFHITTESTINVISIBLE = 4
local Visibility_ALL = 5

local textWidget = nil
local textControl = nil

local funcs = {}

local function FLinearColor(R,G,B,A) return {R=R,G=G,B=B,A=A} end
local function FSlateColor(R,G,B,A) return {SpecifiedColor=FLinearColor(R,G,B,A), ColorUseRule=0} end


local function CreateTextWidget(text)
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
    textBlock:SetText(FText(text))
    textBlock:SetColorAndOpacity(FSlateColor(1,1,1,1))
    textBlock:SetShadowOffset({X = 1, Y = 1})
    textBlock:SetShadowColorAndOpacity(FLinearColor(0, 0, 0, 0.75))

    border:SetContent(textBlock)

    local slot = canvas:AddChildToCanvas(border)
    slot:SetAutoSize(true)

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
    print("TEST, TEXT WIDGET SHOULD HAVE BEEN MADE")
end


function funcs.AddText()
    ExecuteInGameThread(function()
        CreateTextWidget("Random Effects Mod v0.1.1 by Owen_Splat")
    end)
end


function funcs.SetText(text)
    if not textControl then return end
    textControl:SetText(FText(text))
end


local function SetTextVisibility(visibility)
    if not textWidget or not textWidget:IsValid() then return end
    textWidget:SetVisibility(visibility)
end


function funcs.ToggleText()
    if not textWidget or not textWidget:IsValid() then return end
    local current = textWidget:GetVisibility()
    SetTextVisibility(current == Visibility_SELFHITTESTINVISIBLE and Visibility_HIDDEN or Visibility_SELFHITTESTINVISIBLE)
end

return funcs