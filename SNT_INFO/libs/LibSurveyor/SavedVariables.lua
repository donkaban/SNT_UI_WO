-- LibSurveyor Saved Variables
-- @author Ian 'Nevir' MacLeod <ian@nevir.net>
-- 
-- You're welcome to borrow or modify this code provided you give credit to the original author!
-- 
-- The saved variable format used by LibSurveyor, as well as default values

LibSurveyor.SavedVariables = {}
LibSurveyor.SavedVariables.version = LibSurveyor.VERSION

-- Saved variable verification and sanity checking
LibSurveyor.SavedVariableValidation = {}

-- validate all of the saved variables
function LibSurveyor.SavedVariableValidation.Validate()
    -- When/if the library becomes "mature" enough to have to change the saved variable format, we
    -- need to convert any old formats to new here
    if ( LibSurveyor.SavedVariables.version ~= LibSurveyor.VERSION ) then
    
    end
    -- Now that we're up to date, we can move on
    LibSurveyor.SavedVariables.version = LibSurveyor.VERSION
    
    if ( type(LibSurveyor.SavedVariables) ~= "table" ) then
        LibSurveyor.SavedVariables = {}
    end
    
    for varType, validator in pairs(LibSurveyor.SavedVariableValidation) do
        if ( varType ~= "Validate" ) then
            validator()
        end
    end
end

----------
-- Pins --
----------

LibSurveyor.SavedVariables.Pins = {}

function LibSurveyor.SavedVariableValidation.Pins()
    if ( type(LibSurveyor.SavedVariables.Pins) ~= "table" ) then
        LibSurveyor.SavedVariables.Pins = {}
    end
    
    -- while it would be nice to validate each and every pin, but we don't want to lag the user!
end