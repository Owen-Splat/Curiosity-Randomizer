local Slider = {}


function Slider.new(name, parent, min, max, value, stepSize, label, prefix)
    local self = StaticConstructObject(StaticFindObject("/Script/UMG.Slider"), parent, FName(name))

    self:SetMinValue(min)
    self:SetMaxValue(max)
    self:SetValue(value)
    self.StepSize = stepSize
    self.MouseUsesStep = true

    local lastValue = value

    LoopAsync(100, function()
        if not self:IsValid() then
            return true
        end
        if not parent or not parent:IsValid() then
            return true
        end
        if not label or not label:IsValid() then
            return true
        end

        local currentValue = self.Value
        if currentValue ~= lastValue then
            label:SetText(FText(prefix .. tostring(math.tointeger(currentValue)) .. " "))
            lastValue = currentValue
        end
    end)

    return self
end


return Slider