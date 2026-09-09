local UEHelpers = require("UEHelpers")

local EffectTimer = {}


local function FLinearColor(R,G,B,A) return {R=R,G=G,B=B,A=A} end
local function FSlateColor(R,G,B,A) return {SpecifiedColor=FLinearColor(R,G,B,A), ColorUseRule=0} end


function EffectTimer.new(text)
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

    local a = {anchor = {0, 1}, align = {0, 1}, pos = {10, -10}}
    slot:SetAnchors({Minimum = {X = a.anchor[1], Y = a.anchor[2]}, Maximum = {X = a.anchor[1], Y = a.anchor[2]}})
    slot:SetAlignment({X = a.align[1], Y = a.align[2]})
    slot:SetPosition({X = a.pos[1], Y = a.pos[2]})

    canvas.Visibility = 4
    border.Visibility = 4
    textBlock.Visibility = 4

    hud:AddToViewport(101)

    return canvas, textBlock
end


return EffectTimer