local ScrollBox = {}


function ScrollBox.new(name, parent, isHorizontal)
    local self = StaticConstructObject(StaticFindObject("/Script/UMG.ScrollBox"), parent, FName(name))
    self.Orientation = isHorizontal and 0 or 1
    return self
end


function ScrollBox.AddChildren(self, ...)
    local children = {...}
    for i = 1, #children do
        self:AddChild(children[i])
    end
end


return ScrollBox