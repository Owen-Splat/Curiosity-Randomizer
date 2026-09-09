local Button = {}


function Button.new(name, parent, funcToTrigger)
    local self = StaticConstructObject(StaticFindObject("/Script/UMG.Button"), parent, FName(name))

    local wasPressedLastTick = false

    LoopAsync(100, function()
        if not parent or not parent:IsValid() or not self:IsValid() then
            return true
        end

        if self:IsPressed() then
            wasPressedLastTick = true
        else
            if wasPressedLastTick then
                wasPressedLastTick = false
                if funcToTrigger then
                    funcToTrigger()
                end
            end
        end
    end)

    return self
end


return Button