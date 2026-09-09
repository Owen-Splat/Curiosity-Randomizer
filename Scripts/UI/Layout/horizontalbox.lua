local HorizontalBox = {}


function HorizontalBox.new(name, parent)
    local self = StaticConstructObject(StaticFindObject("/Script/UMG.HorizontalBox"), parent, FName(name))
    return self
end


function HorizontalBox.AddChildren(self, ...)
    local children = {...}
    for i = 1, #children do
        self:AddChildToHorizontalBox(children[i])
    end
end


return HorizontalBox