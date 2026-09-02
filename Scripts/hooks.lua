local settings = {
    LowGravity = false
}

RegisterHook("/Game/AnimX/_Common/CharBP_Base.CharBP_Base_C:SetGravity", function(Character, Gravity, IsTemporary)
    if not settings.LowGravity then
        return
    end

    local ActualCharacter = Character:get()
    if not ActualCharacter then return end

    -- ActualCharacter['Base Falling Gravity'] = Gravity:get() / 2.0
    if not IsTemporary then
        ActualCharacter.Gravity = Gravity:get() / 2.0
    else
        ActualCharacter.HasTemporaryGravity = IsTemporary
        ActualCharacter:SetTemporaryGravity(Gravity:get())
    end
    -- ActualCharacter.BaseGravity = Gravity:get() / 2.0
end)

return settings