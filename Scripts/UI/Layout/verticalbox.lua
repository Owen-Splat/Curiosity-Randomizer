local VerticalBox = {}


function VerticalBox.new(name, parent)
    local self = StaticConstructObject(StaticFindObject("/Script/UMG.VerticalBox"), parent, FName(name))
    return self
end


function VerticalBox.AddChildren(self, ...)
    local children = {...}
    for i = 1, #children do
        self:AddChildToVerticalBox(children[i])
    end
end


return VerticalBox