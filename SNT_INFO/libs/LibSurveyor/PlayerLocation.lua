-- LibSurveyor Player Location Tracking
-- @author Ian 'Nevir' MacLeod <ian@nevir.net>
-- 
-- You're welcome to borrow or modify this code provided you give credit to the original author!
-- 
-- A handy tracker for the player location so that other addons can display and use it

local LibSurveyor = LibStub:GetLibrary("LibSurveyor")
if ( not LibSurveyor or LibSurveyor.VERSION.minor ~= 1 ) then
    return
end

-- TODO: save last known loc, and flight master deposit locations
LibSurveyor.PlayerLocation = LibSurveyor.NewWorldPoint(0, 0, 0)

if ( _G["LibSurveyor"].version.minor == LibSurveyor.VERSION.minor ) then
    _G["LibSurveyor"].PlayerLocation = LibSurveyor.NewWorldPoint(0, 0, 0)
    _G["LibSurveyor"].PlayerLocation:SetCompatabilityMode(true)
end

function LibSurveyor.GlobalTable.OnPlayerPositionUpdated(worldX, worldY)
    -- update the point
    LibSurveyor.PlayerLocation.zoneId = GameData.Player.zone
    LibSurveyor.PlayerLocation.worldX = worldX
    LibSurveyor.PlayerLocation.worldY = worldY
    
    -- update the deprecated superglobal point (compatability mode)
    if ( _G["LibSurveyor"].version.minor == LibSurveyor.VERSION.minor ) then
        -- update the compat point
        _G["LibSurveyor"].PlayerLocation.zoneId = GameData.Player.zone
        _G["LibSurveyor"].PlayerLocation.worldX = worldX
        _G["LibSurveyor"].PlayerLocation.worldY = worldY
    end
end