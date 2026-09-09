local SizeBox = {}


function SizeBox.new(name, parent, width, height)
    local self = StaticConstructObject(StaticFindObject("/Script/UMG.SizeBox"), parent, FName(name))
    self:SetWidthOverride(width)
    self:SetHeightOverride(height)
    return self
end


return SizeBox