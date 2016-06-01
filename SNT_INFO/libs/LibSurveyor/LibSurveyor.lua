 -- LibSurveyor Core
-- @author Ian 'Nevir' MacLeod <ian@nevir.net>
-- 
-- You're welcome to borrow or modify this code provided you give credit to the original author!
-- 
-- LibSurveyor is a library that does its best to handle all your needs for mapping locations in
-- Warhammer's world, as well as providing a means to get at and display that information.

local MAJOR = "LibSurveyor"
local MINOR = 1

local LibSurveyor = LibStub:NewLibrary(MAJOR, MINOR)
if ( not LibSurveyor ) then 
    return
end

LibSurveyor.VERSION = {
    major = MAJOR,
    minor = MINOR,
}

-- global table for event handlers and the like
LibSurveyor.globalTableName = MAJOR.."_"..MINOR
_G[LibSurveyor.globalTableName] = {}
LibSurveyor.GlobalTable = _G[LibSurveyor.globalTableName]

-- Superglobal LibSurveyor table - DEPRECATED!
if ( not _G["LibSurveyor"] or _G["LibSurveyor"].version.minor < LibSurveyor.VERSION.minor ) then
    -- don't clobber a newer version's superglobal table
    _G["LibSurveyor"] = {
        version = LibSurveyor.VERSION,
    }
end

-- To be filled out by includes
LibSurveyor.Data = {}


--------------------
-- Event handlers --
--------------------
function LibSurveyor.GlobalTable.OnInitialize()
    RegisterEventHandler(SystemData.Events.PLAYER_POSITION_UPDATED, LibSurveyor.globalTableName..".OnPlayerPositionUpdated")
end

