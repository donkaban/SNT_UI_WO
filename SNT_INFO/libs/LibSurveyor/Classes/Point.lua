 -- LibSurveyor Points (Map Coordinates)
-- @author Ian 'Nevir' MacLeod <ian@nevir.net>
-- 
-- You're welcome to borrow or modify this code provided you give credit to the original author!
-- 
-- A class that embodies a point in world or zone coordinate systems, and related utility functions

local LibSurveyor = LibStub:GetLibrary("LibSurveyor")
if ( not LibSurveyor or LibSurveyor.VERSION.minor ~= 1 ) then
    return
end

LibSurveyor.Point = {}
setmetatable(LibSurveyor.Point, {
    __call = function(self, point)
        if ( point ) then
            setmetatable(point, LibSurveyor.Point)
        end
    end
})

--- Creates a new point from world coordinates
-- 
-- @number zoneId: The zone this point is associated with
-- @number worldX: The x value of the point in the game's world coordinate system
-- @number worldY: The y value of the point in the game's world coordinate system
function LibSurveyor.NewWorldPoint(zoneId, worldX, worldY)
    if ( type(zoneId) ~= "number" or type(worldX) ~= "number" or type(worldY) ~= "number" ) then
        ERROR(L"LibSurveyor: NewWorldPoint() was called with missing or invalid arguments")
        return nil
    end
    
    local newPoint = {
        zoneId = zoneId,
        worldX = worldX,
        worldY = worldY,
    }
    setmetatable(newPoint, LibSurveyor.Point)
    
    return newPoint
end

--- DEPRECATED: Places this point into compatability mode 
-- 
-- In compatability mode, unknown coordinates are returned as 0 instead of nil
-- 
-- @boolean enabled: whether compatability mode is enabled
function LibSurveyor.Point:SetCompatabilityMode(enabled)
    if ( enabled ) then
        self.compatMode = true
    else
        self.compatMode = nil
    end
end

--- Point Properties
-- 
-- @number zoneId: The zone this point is associated with
-- @number worldX: The x value of the point in the game's world coordinate system
-- @number worldY: The y value of the point in the game's world coordinate system
-- @number zoneX:  The x value of the point in the zone's coordinate system. nil if unknown
-- @number zoneY:  The y value of the point in the zone's coordinate system. nil if unknown
-- @number pctX:   The percentage of the x coordinate across the zone (0.0 to 1.0). nil if unknown
-- @number pctY:   The percentage of the x coordinate across the zone (0.0 to 1.0). nil if unknown
function LibSurveyor.Point:__index(key)
    if ( LibSurveyor.Point[key] ) then
        return LibSurveyor.Point[key]
    end
    
    local zoneOffset = LibSurveyor.Data.ZoneOffsets[self.zoneId]
    if ( zoneOffset ) then
        if ( key == "zoneX" ) then
            -- are we in bounds?
            local zoneX = self.worldX - zoneOffset.x
            
            if ( zoneX >= 0 and zoneX <= zoneOffset.w ) then
                return zoneX
            end
            
        elseif ( key == "zoneY" ) then
            -- are we in bounds?
            local zoneY = self.worldY - zoneOffset.y
            
            if ( zoneY >= 0 and zoneY <= zoneOffset.h ) then
                return zoneY
            end
            
        elseif ( key == "pctX" ) then
            local zoneX = self.zoneX
            if ( zoneX ) then
                return zoneX / zoneOffset.w
            end
            
        elseif ( key == "pctY" ) then
            local zoneY = self.zoneY
            if ( zoneY ) then
                return zoneY / zoneOffset.h
            end
        end
    elseif ( self.compatMode and (key == "zoneX" or key == "zoneY") ) then
        return 0
    end
    
    return nil
end