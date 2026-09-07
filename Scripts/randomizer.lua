local Placements = {}


-- turn the obj location into a unique string for the placements key
local function GetLocationKey(loc)
    if not loc then return "" end
    return string.format("%.0f,%.0f,%.0f", loc.X, loc.Y, loc.Z)
end


-- returns a list of all game objects that we will randomize the locations of
local function GetPickups()
    local TargetClasses = {
        "BP_CatSkinPickup_C",
        "BP_Coin_C",
        "BP_BedSinglePickup_C"
    }
    local PickUps = {}
    for _, className in ipairs(TargetClasses) do
        local objs = FindAllOf(className)
        if objs then
            for _, obj in pairs(objs) do
                if obj:IsValid() then
                    PickUps[#PickUps+1] = obj
                end
            end
        end
    end
    return PickUps
end


-- Uses the placements to swap the locations of collectables
local function SetPlacements()
    local Pickups = GetPickups()
    for _, obj in ipairs(Pickups) do
        obj:K2_SetActorLocation(Placements[GetLocationKey(obj:K2_GetActorLocation())], false, {}, true)
    end
end


-- Makes the placements
local function MakePlacements()
    local PickUps = GetPickups()
    local Locations = {}
    if PickUps and #PickUps > 1 then
        for i, obj in ipairs(PickUps) do
            Locations[i] = obj:K2_GetActorLocation()
        end
        for i = #Locations, 2, -1 do
            local j = math.random(i)
            Locations[i], Locations[j] = Locations[j], Locations[i]
        end
        for i, obj in ipairs(PickUps) do
            Placements[GetLocationKey(obj:K2_GetActorLocation())] = Locations[i]
        end
    end
end


local rando = {}


-- Called every time the player object is created and not at the vet
-- Placements are only made the first time
-- This results in objects being in the same location even if you go to the vet or return to the title screen
-- The locations will be different each launch of the game
function rando.Start()
    if next(Placements) == nil then
        MakePlacements()
    end
    SetPlacements()
end


return rando