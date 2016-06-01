-- LibSurveyor Pin Types
-- @author Ian 'Nevir' MacLeod <ian@nevir.net>
-- 
-- You're welcome to borrow or modify this code provided you give credit to the original author!
-- 
-- A pin type is a classification of pins and associated handler functions that generate the data
-- necessary to display and interact with pins in the UI
-- 
-- Throughout the LibSurveyor API, pin types are referenced by their unique string identifier.  
-- There is no need to keep a handle of a pin type after all the handlers and properties have been
-- set on it.  

local LibSurveyor = LibStub:GetLibrary("LibSurveyor")
if ( not LibSurveyor or LibSurveyor.VERSION.minor ~= 1 ) then
    return
end

LibSurveyor.PinType = {}
LibSurveyor.PinType.handlers = {}

local PinTypeHandlers_MT = {
    __index = LibSurveyor.PinType.handlers
}

local _pinTypes = {}

--- Registers a new pin type
-- 
-- @string pinType: The identifier for this pin type
function LibSurveyor.RegisterPinType(pinType)
    if ( pinType and _pinTypes[pinType] ) then
        ERROR(L"LibSurveyor: NewPinType() was called with an invalid or duplicate pin type")
    end
    
    -- set up our defaults
    local newPinType = {
        id       = pinType,
        title    = StringToWString(pinType),
        handlers = {},
        filters  = {},
        
        defaultHiddenFilters = {},
    }
    setmetatable(newPinType.handlers, PinTypeHandlers_MT)
    setmetatable(newPinType,          LibSurveyor.PinType)
    
    _pinTypes[pinType] = newPinType
    
    return newPinType
end

--- Returns the specified pin type's object
-- 
-- @string pinType: The identifier for this pin type
function LibSurveyor.GetPinType(pinType)
    return _pinTypes[pinType]
end

--- Returns a table of pin types (id -> pin type object)
function LibSurveyor.GetPinTypes()
    return _pinTypes
end

--- Pin type properties
-- 
-- @wstring title:   a localized name for this pin type
-- @table   filters: a mapping of available filters (string) to their localized titles (wstring)
-- 
-- @array   defaultHiddenFilters: an array of filters that should be hidden by default

--- Pin type handlers
-- 
-- Handlers are methods defined by a pin type, that are mixed into each pin.  Each handler
-- implicitely takes the pin (self) as the first argument, followed by any additional arguments
-- for that handler.  It's strongly recommended that you use the :handler(args) shortcut for clarity
-- when defining them.

--- handlers:title()
-- 
-- Returns the title of the current pin (self) as a wstring.  This should be localized where at
-- all possible.
function LibSurveyor.PinType.handlers:title()
    ERROR(L"LibSurveyor: Pin:title() was not defined for the pin type: "..StringToWString(self.pinType))
end

--- handlers:description()
-- 
-- Returns the description, if any, of the pin as a wstring.  Returns an empty wstring if there is
-- no description for this pin.  Should be localized where at all possible.
function LibSurveyor.PinType.handlers:description()
    return L""
end

--- handlers:filters()
--
-- Returns an array of filters that apply to this pin
function LibSurveyor.PinType.handlers:filters()
    return {}
end

