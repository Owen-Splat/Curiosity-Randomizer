local CheckBox = {}


function CheckBox.new(name, parent, checkedState)
    local self = StaticConstructObject(StaticFindObject("/Script/UMG.CheckBox"), parent, FName(name))
    self:SetIsChecked(checkedState)
    return self
end


return CheckBox