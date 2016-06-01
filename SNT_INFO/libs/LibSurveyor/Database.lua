-- LibSurveyor's Database
-- @author Ian 'Nevir' MacLeod <ian@nevir.net>
-- 
-- You're welcome to borrow or modify this code provided you give credit to the original author!
-- 
-- The database format used by LibSurveyor and conversion routines

local LibSurveyor = LibStub:GetLibrary("LibSurveyor")
if ( not LibSurveyor or LibSurveyor.VERSION.minor ~= 1 ) then
    return
end

--- LibSurveyorDB's format for LibSurveyor rev.1
-- 
-- LibSurveyorDB = {
--     version = {
--         major = "LibSurveyor",
--         minor = 1,
--     },
--     pins = {
--         ["PinType"] = {
--             ["pinId"] = {
--                 pinType = "PinType",
--                 id      = "pinId",
--                 point   = {
--                     zoneId = 1,
--                     worldX = 2,
--                     worldY = 3,
--                 },
--                 data    = whatever you like, or nil
--             },
--         },
--         ...
--     },
--     pinIncrements = {
--         ...
--     },
-- }

local _databases = {}
--- Register an external database to be used in pin queries and display
-- 
-- The given database must conform to the same format used by LibSurveyorDB.pins, or that of a 
-- previously release of LibSurveyor (database formats are backwards compatable)
-- 
-- If there is a conflict (e.g. multiple pins with the same pinType/id pair), behavior is undefined.
function LibSurveyor.RegisterExternalDB(database)
    table.insert(_databases, database)
end


-------------------
-- Pin Retrieval --
-------------------

-- quick helper functions to iterate over databases
local function _iterateOnPins(func)
    for i, db in ipairs(_databases) do
        for j, pinType in pairs(db) do
            for k, pin in pairs(pinType) do
                func(pin)
            end
        end
    end
end

--- Gets the specified pin, or returns nil
-- 
-- @string pinType: The pin type id for this pin
-- @string id:      The string or numeric (integer) identifier for this pin.
function LibSurveyor.GetPin(pinType, id)
    for i, db in ipairs(_databases) do
        if ( db[pinType] and db[pinType][id] ) then
            local pin = db[pinType][id]

            LibSurveyor.Pin(pin)
            return pin
        end
    end
end


--- Returns an array of pins within the given zone
-- 
-- @number zoneId: The zone id to query for
function LibSurveyor.GetPinsForZone(zoneId) 
    local result = {}
    
    _iterateOnPins(function(pin)
        if ( pin.point.zoneId == zoneId ) then
            LibSurveyor.Pin(pin)
            table.insert(result, pin)
        end
    end)
    
    return result
end

----------------
-- Validation --
----------------
function LibSurveyor.GlobalTable.ValidateDB()
    -- quick sanity checking.  
    -- 
    -- FUTURE VERSIONS MUST KEEP THE SAME STRUCTURE FOR THE VERSION TABLE!  DO NOT REMOVE ENTRIES
    -- FROM IT, ONLY ADD NEW ONES AS REQUIRED!  I LIKE YELLING!
    if ( type(LibSurveyorDB) ~= "table" or type(LibSurveyorDB.version) ~= "table" ) then
        -- sorry, but we're not going to try and autodetect the format...
        LibSurveyorDB = {
            version = LibSurveyor.VERSION,
        }
    end
    
    -- The minor version had better be numeric and increasing.  For DB versions higher than ours,
    -- we don't touch a thing (the user downgraded).  This means that future versions MUST be 
    -- backwards compatable with their database format!
    if ( LibSurveyorDB.version.minor < LibSurveyor.VERSION.minor ) then
        -- TODO: implement a database migration handler.  Rails' migrations are probably a good model to
        --       follow here.
    end
    
    -- now that migrations are hopefully out of the way... more sanity checking
    if ( LibSurveyorDB.version.minor == LibSurveyor.VERSION.minor ) then
        if ( type(LibSurveyorDB.pins) ~= "table" ) then
            LibSurveyorDB.pins = {}
        end
        
        if ( type(LibSurveyorDB.pinIncrements) ~= "table" ) then
            LibSurveyorDB.pinIncrements = {}
        end
    end
    
    -- first database, so we get precedence
    table.insert(_databases, LibSurveyorDB.pins)
end