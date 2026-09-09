local Label = {}


function Label.new(name, parent, fontSize, text)
    local self = StaticConstructObject(StaticFindObject("/Script/UMG.TextBlock"), parent, FName(name))
    self.Font.Size = fontSize
    self:SetText(FText(text))
    return self
end


return Label