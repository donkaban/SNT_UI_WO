-- LibSurveyor Displays
-- @author Ian 'Nevir' MacLeod <ian@nevir.net>
-- 
-- You're welcome to borrow or modify this code provided you give credit to the original author!
-- 
-- A class that manages the display of a zone map

local LibSurveyor = LibStub:GetLibrary("LibSurveyor")
if ( not LibSurveyor or LibSurveyor.VERSION.minor ~= 1 ) then
    return
end

LibSurveyor.Display = {}

local _displays = {}

--- Returns a table of displays that are currently active
function LibSurveyor.GetDisplays()
    return _displays
end

--- Create a new pin display on the given window (canvas)
-- 
-- @string   window:    The name of the window
-- @function pinFilter: A function that, given a pin, returns a boolean indiciating whether the pin 
--                      should be shown on the display
function LibSurveyor.NewDisplay(window, pinFilter)
    if ( _displays[window] ) then
        ERROR(L"LibSurveyor: In NewDisplay(), a display already exists for the window: "..StringToWString(window))
    end
    
    local newDisplay = {
        window     = window,
        pinFilter  = pinFilter,
        zoneId     = -1,
        pinWindows = {},
        hoverPins  = {},
    }
    setmetatable(newDisplay, LibSurveyor.Display)
    
    _displays[window] = newDisplay
    
    return newDisplay
end

--- Sets the zone for the display, which will update appropriately
-- 
-- @number zoneId: the id of the zone to display
function LibSurveyor.Display:SetZone(zoneId)
    if ( self.zoneId ~= zoneId ) then
        self.zoneId = zoneId
        
        self:Refresh()
    end
end

--- Fully refreshes the display
function LibSurveyor.Display:Refresh()
    -- TODO: optimize this (reuse icon windows, etc?)
    for window, pin in pairs(self.pinWindows) do
        if ( DoesWindowExist(window ) ) then
            DestroyWindow(window)
        end
    end
    self.pinWindows = {}
    
    if ( DoesWindowExist(self.window) ) then
        local windowWidth, windowHeight = WindowGetDimensions(self.window)
        
        local pins = LibSurveyor.GetPinsForZone(self.zoneId)
        
        for i, pin in ipairs(pins) do
            local show = self.pinFilter(pin)
            
            local pctX = pin.point.pctX
            local pctY = pin.point.pctY
            
            if ( show and pctX and pctY ) then
                local pinWindow = self.window.."_Pin_"..pin.pinType.."_"..pin.id
                
                -- create a new pin
                CreateWindowFromTemplate(pinWindow, "LibSurveyor_1_PinTemplate", self.window)
                
                -- set the event handlers
                WindowSetHandleInput(pinWindow, true)
                
                WindowRegisterCoreEventHandler(pinWindow, "OnMouseOver",    LibSurveyor.globalTableName..".OnPinMouseOver")
                WindowRegisterCoreEventHandler(pinWindow, "OnMouseOverEnd", LibSurveyor.globalTableName..".OnPinMouseOverEnd")
                
                -- set the icon
                local texture, textureX, textureY, sizeX, sizeY, colorR, colorG, colorB = pin:icon()
                -- TODO: handle a no icon case with a default pin icon
                DynamicImageSetTexture(pinWindow, texture, textureX, textureY)
                
                -- default to no tint
                if ( not colorR or not colorG or not colorB ) then
                    colorR = 255
                    colorG = 255
                    colorB = 255
                end
                WindowSetTintColor(pinWindow, colorR, colorG, colorB)
                
                WindowSetDimensions(pinWindow, sizeX, sizeY)
                
                -- position the pin
                WindowClearAnchors(pinWindow) -- just to be safe
                WindowAddAnchor(pinWindow, "topleft", self.window, "center", windowWidth * pctX, windowHeight * pctY)
                
                self.pinWindows[pinWindow] = pin
            end
        end
    end
end

LibSurveyor.Display.__index = LibSurveyor.Display


--- Map Tooltips (and Private Hooks) --
---------------------------------------

-- Handle pin mouse over and end events to keep track of interesting pins
function LibSurveyor.GlobalTable.OnPinMouseOver()
    local display = _displays[WindowGetParent(SystemData.MouseOverWindow.name)]
    
    if ( display ) then
        local pin = display.pinWindows[SystemData.MouseOverWindow.name]
        
        if ( pin ) then
            display.hoverPins[pin] = true
            
            local mapHoverPoints = _G[display.window].MouseoverPoints
            Tooltips.CreateMapPointTooltip("EA_Window_WorldMapZoneViewMapDisplay", mapHoverPoints, Tooltips.ANCHOR_CURSOR)
        end
    end
end

function LibSurveyor.GlobalTable.OnPinMouseOverEnd()
    local display = _displays[WindowGetParent(SystemData.MouseOverWindow.name)]
    
    if ( display ) then
        local pin = display.pinWindows[SystemData.MouseOverWindow.name]
        
        if ( pin ) then
            display.hoverPins[pin] = nil
            
            local mapHoverPoints = _G[display.window].MouseoverPoints
            Tooltips.CreateMapPointTooltip("EA_Window_WorldMapZoneViewMapDisplay", mapHoverPoints, Tooltips.ANCHOR_CURSOR)
            
            -- make sure our tooltip is hooked into the right window
            Tooltips.curMouseOverWindow = display.window
        end
    end
end


local hooked = {}

-- Hook into the pin tooltip function to display our entries in the tooltip as well=
hooked["Tooltips.CreateMapPointTooltip"] = Tooltips.CreateMapPointTooltip
function Tooltips.CreateMapPointTooltip(mapDisplay, points, anchor)
    local display = _displays[mapDisplay]
    
    -- insert any pins we might be hovering over
    if ( display ) then
        -- make a copy of the regular hover points, so we don't hork the map's data structures
        local newPoints = {}
        
        for i, point in ipairs(points) do
            table.insert(newPoints, point)
        end
        
        for pin, key in pairs(display.hoverPins) do
            table.insert(newPoints, pin)
        end
        
        points = newPoints
    end
    
    return hooked["Tooltips.CreateMapPointTooltip"](mapDisplay, points, anchor)
end

-- We need to make sure the tooltip is hooked onto the correct window
hooked["Tooltips.CreateCustomTooltip"] = Tooltips.CreateCustomTooltip
function Tooltips.CreateCustomTooltip(mouseOverWindow, tooltipWindow)
    hooked["Tooltips.CreateCustomTooltip"](mouseOverWindow, tooltipWindow)
    
    local display = _displays[mouseOverWindow]
    -- is this a map display that we care about?
    if ( display ) then
        if ( display.pinWindows[SystemData.MouseOverWindow.name] ) then
            -- reanchor the tooltip to our pin
            Tooltips.curMouseOverWindow = SystemData.MouseOverWindow.name
        end
    end
end

-- Hook into the native get map point function, so we can handle our own points
hooked["GetMapPointData"] = GetMapPointData
function GetMapPointData(mapDisplay, ptIndex)
    -- is this a Surveyor pin?
    if ( type(ptIndex) == "table" ) then
        -- build our emulated point data
        local pointType = SystemData.MapPips.MAILBOX -- mailboxes don't have a displayed type
        local pointId   = 0
        local pointIcon = ptIndex
        local pointName = ptIndex:title()
        local pointText = ptIndex:description()
        local pointCtrl = 0
        
        return pointType, pointId, pointIcon, pointName, pointText, pointCtrl
    else
        return hooked["GetMapPointData"](mapDisplay, ptIndex)
    end
end

hooked["GetMapIconData"] = GetMapIconData
function GetMapIconData(icon)
    -- is this a surveyor pin?
    if ( type(icon) == "table" ) then
        -- TODO: handle missing values
        return icon:icon()
    end
    
    return hooked["GetMapIconData"](icon)
end