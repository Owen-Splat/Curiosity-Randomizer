local timer_data = {
    Seconds = 20,
}

local directories = IterateGameDirectories().Game.Binaries.Win64
local base_win64_path = directories.__absolute_path
local file_path = base_win64_path .. "/ue4ss/Mods/RandomizerMod/timer.txt"

local file = io.open(file_path, "r")
if file then
    timer_data.Seconds = math.modf(file:read("*n")) or 20
    file:close()
end

if timer_data.Seconds < 5 then
    timer_data.Seconds = 5
end

return timer_data
