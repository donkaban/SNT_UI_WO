-- LibSurveyor Pins
-- @author Ian 'Nevir' MacLeod <ian@nevir.net>
-- 
-- You're welcome to borrow or modify this code provided you give credit to the original author!
-- 
-- 

local LibSurveyor = LibStub:GetLibrary("LibSurveyor")
if ( not LibSurveyor or LibSurveyor.VERSION.minor ~= 1 ) then
    return
end

LibSurveyor.Pin = {}
setmetatable(LibSurveyor.Pin, {
    __call = function(self, pin)
        if ( pin ) then
            LibSurveyor.Point(pin.point)
            setmetatable(pin, LibSurveyor.Pin)
        end
    end
})

--- Creates a new map pin
-- 
-- @Point  point:   The point where this pin is located.
-- @string pinType: The pin type to register this pin under.
-- #string id:      An identifier, when coupled with the pin type, uniquely identifies this pin.  If
--                  no id is given, one will be generated.  (optional)
function LibSurveyor.NewPin(point, pinType, id)
    -- simple argument and type checking
    if ( getmetatable(point) ~= LibSurveyor.Point ) then
        ERROR(L"LibSurveyor: NewPin() was called with an invalid or missing point")
    end
    
    if ( not LibSurveyorDB.pins[pinType] ) then
        LibSurveyorDB.pins[pinType] = {}
    end
    
    -- do we need to generate an id?
    local generate = false
    if ( not id ) then
        -- so we can keep the increment down
        generate = true
        
        if ( not LibSurveyorDB.pinIncrements[pinType] ) then
            LibSurveyorDB.pinIncrements[pinType] = 1
        end
        
        id = LibSurveyorDB.pinIncrements[pinType]
    end
    
    if ( LibSurveyorDB.pins[pinType][id] ) then
        ERROR(L"LibSurveyor: A pin already exists for pin type '"..StringToWString(pinType)..L"' and id "..StringToWString(""..id))
        return nil
    end
    
    if ( generate ) then
        LibSurveyorDB.pinIncrements[pinType] = LibSurveyorDB.pinIncrements[pinType] + 1
    end
    
    -- actually create the pin now...
    local newPin = {
        point   = point,
        pinType = pinType,
        id      = id,
    }
    setmetatable(newPin, LibSurveyor.Pin)
    
    LibSurveyorDB.pins[pinType][id] = newPin
    
    return newPin
end


--- Map pin properties
-- 
function LibSurveyor.Pin:__index(key)
    local pinType = LibSurveyor.GetPinType(self.pinType)
    
    if ( pinType and pinType.handlers[key] ) then
        return pinType.handlers[key]
    end
    
    return nil
end