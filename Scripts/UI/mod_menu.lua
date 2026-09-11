local UEHelpers = require("UEHelpers")

local HorizontalBox = require("UI/Layout/horizontalbox")
local VerticalBox = require("UI/Layout/verticalbox")

local ButtonWidget = require("UI/Widget/button")
local LabelWidget = require("UI/Widget/label")

local MenuPage1 = require("UI/Menu/menu_main")
local MenuPage2 = require("UI/Menu/menu_effects")
local MenuPage3 = require("UI/Menu/menu_extra")

local PageTitles = {
    "Randomizer Settings\n",
    "Effects To Include\n",
    "Extra Settings\n"
}

local ModMenu = {
    MenuTitle = nil,
    MenuLayout = nil,
    NextButton = nil,
    PrevButton = nil,
    ButtonLayout = nil,
    ButtonPadding = nil,
    CurrentPage = 1,
    Page1 = nil,
    Page2 = nil,
    Page3 = nil
}


local function UpdatePage()
    ModMenu.MenuTitle:SetText(FText(PageTitles[ModMenu.CurrentPage]))

    ModMenu.Page1:SetVisibility(ModMenu.CurrentPage == 1 and 0 or 1)
    ModMenu.Page2:SetVisibility(ModMenu.CurrentPage == 2 and 0 or 1)
    ModMenu.Page3:SetVisibility(ModMenu.CurrentPage == 3 and 0 or 1)

    if ModMenu.CurrentPage == 1 then
        ModMenu.PrevButton:SetVisibility(2)
        ModMenu.NextButton:SetVisibility(0)
    elseif ModMenu.CurrentPage == 3 then
        ModMenu.PrevButton:SetVisibility(0)
        ModMenu.NextButton:SetVisibility(2)
    else
        ModMenu.PrevButton:SetVisibility(0)
        ModMenu.NextButton:SetVisibility(0)
    end
end


local function NextPage()
    ModMenu.CurrentPage = ModMenu.CurrentPage + 1
    UpdatePage()
end


local function PrevPage()
    ModMenu.CurrentPage = ModMenu.CurrentPage - 1
    UpdatePage()
end


function ModMenu.new()
    local gi = UEHelpers.GetGameInstance()
    local hud = StaticConstructObject(StaticFindObject("/Script/UMG.UserWidget"), gi, FName("MenuHUD"))
    hud.WidgetTree = StaticConstructObject(StaticFindObject("/Script/UMG.WidgetTree"), hud, FName("MenuTree"))

    local canvas = StaticConstructObject(StaticFindObject("/Script/UMG.CanvasPanel"), hud.WidgetTree, FName("MenuCanvas"))
    hud.WidgetTree.RootWidget = canvas

    local border = StaticConstructObject(StaticFindObject("/Script/UMG.Border"), canvas, FName("MenuBorder"))
    border:SetBrushColor({R=0.05, G=0.05, B=0.05, A=0.95})
    border:SetPadding({Left = 30, Top = 30, Right = 30, Bottom = 30})

    ModMenu.MenuLayout = VerticalBox.new("MenuLayout", border)
    border:SetContent(ModMenu.MenuLayout)

    -- menu title
    ModMenu.MenuTitle = LabelWidget.new("TitleLabel", ModMenu.MenuLayout, 28, PageTitles[1])
    ModMenu.MenuTitle:SetJustification(1)
    ModMenu.MenuLayout:AddChildToVerticalBox(ModMenu.MenuTitle)

    -- page widgets
    ModMenu.Page1 = MenuPage1.new(ModMenu.MenuLayout)
    local page1Slot = ModMenu.MenuLayout:AddChildToVerticalBox(ModMenu.Page1)
    page1Slot:SetSize({SizeRule = 1, Value = 1.0})

    ModMenu.Page2 = MenuPage2.new(ModMenu.MenuLayout)
    local page2Slot = ModMenu.MenuLayout:AddChildToVerticalBox(ModMenu.Page2)
    page2Slot:SetSize({SizeRule = 1, Value = 1.0})

    ModMenu.Page3 = MenuPage3.new(ModMenu.MenuLayout)
    local page3Slot = ModMenu.MenuLayout:AddChildToVerticalBox(ModMenu.Page3)
    page3Slot:SetSize({SizeRule = 1, Value = 1.0})

    -- padding before page buttons
    ModMenu.MenuLayout:AddChildToVerticalBox(LabelWidget.new("PageToButtonPadding", ModMenu.MenuLayout, 28, ""))

    -- page buttons
    ModMenu.NextButton = ButtonWidget.new("PageNextButton", ModMenu.MenuLayout, NextPage)
    local nextText = LabelWidget.new("NextTextLabel", ModMenu.MenuLayout, 12, "->")
    ModMenu.NextButton:SetContent(nextText)

    ModMenu.PrevButton = ButtonWidget.new("PagePrevButton", ModMenu.MenuLayout, PrevPage)
    local prevText = LabelWidget.new("PrevTextLabel", ModMenu.MenuLayout, 12, "<-")
    ModMenu.PrevButton:SetContent(prevText)

    ModMenu.ButtonPadding = LabelWidget.new("ButtonPadding", ModMenu.MenuLayout, 16, "")

    ModMenu.ButtonLayout = HorizontalBox.new("PageButtonLayout", ModMenu.MenuLayout)
    ModMenu.ButtonLayout:AddChildToHorizontalBox(ModMenu.PrevButton)
    local buttonSlot = ModMenu.ButtonLayout:AddChildToHorizontalBox(ModMenu.ButtonPadding)
    buttonSlot:SetSize({SizeRule = 1, Value = 1.0})
    ModMenu.ButtonLayout:AddChildToHorizontalBox(ModMenu.NextButton)
    ModMenu.MenuLayout:AddChildToVerticalBox(ModMenu.ButtonLayout)

    -- update the page to the first one
    UpdatePage()

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


function ModMenu.GetSettings()
    local totalSettings = {}

    for key, value in pairs(MenuPage1.GetSettings()) do
        totalSettings[key] = value
    end
    for key, value in pairs(MenuPage2.GetSettings()) do
        totalSettings[key] = value
    end
    for key, value in pairs(MenuPage3.GetSettings()) do
        totalSettings[key] = value
    end

    return totalSettings
end


return ModMenu