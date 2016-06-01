-- LibSurveyor Zone Offsets
-- @author Ian 'Nevir' MacLeod <ian@nevir.net>
-- 
-- You're welcome to borrow or modify this code provided you give credit to the original author!
-- 
-- LibSurveyor uses the "raw" world coordinates to map values.  Unfortunately, zones provide a 
-- "human readable" coordinate system that is offset from the world coordinates.
-- 
-- Currently, the only known way to determine a zone's offset (top left) is to travel to that zone
-- and guess based on the map offset that you can find while mousing over the player on the world
-- map, and the world coordinates given by LibSurveyor.  Zone offsets are usually (always?) some
-- factor of 65536 - usually 65536 * (# * 0.125)
-- 
-- Please, please: if you find a better way to determine these values in game or without, contribute
-- it back!  Also, some of these offsets are bound to be off; let me know so I can fix them!
-- 
-- Finally, if you use these values within your own addon, and for some reason don't use the utility
-- functions provided by LibSurveyor - *please* give credit!  These took a great deal of running
-- around to figure out.

local LibSurveyor = LibStub:GetLibrary("LibSurveyor")
if ( not LibSurveyor or LibSurveyor.VERSION.minor ~= 1 ) then
    return
end

LibSurveyor.Data.ZoneOffsets = {}

-- Dwarves vs Greenskins --
---------------------------
LibSurveyor.Data.ZoneOffsets[6]   = {x = 737280,  y = 843776,  h = 65536, w = 65536} -- Ekrund
LibSurveyor.Data.ZoneOffsets[11]  = {x = 802816,  y = 843776,  h = 65536, w = 65536} -- Mount Bloodhorn
LibSurveyor.Data.ZoneOffsets[7]   = {x = 1032192, y = 794624,  h = 65536, w = 65536} -- Barak Varr
LibSurveyor.Data.ZoneOffsets[1]   = {x = 1032192, y = 860160,  h = 65536, w = 65536} -- Marshes of Madness
LibSurveyor.Data.ZoneOffsets[8]   = {x = 1236992, y = 958464,  h = 65536, w = 65536} -- Black Fire Pass (Thanks to burfo for correcting this)
LibSurveyor.Data.ZoneOffsets[2]   = {x = 1236992, y = 892928,  h = 65536, w = 65536} -- The Badlands (Thanks to burfo for correcting this)
LibSurveyor.Data.ZoneOffsets[10]  = {x = 1368064, y = 761856,  h = 65536, w = 65536} -- Stonewatch
LibSurveyor.Data.ZoneOffsets[9]   = {x = 1368064, y = 827392,  h = 65536, w = 65536} -- Kadrin Valley
LibSurveyor.Data.ZoneOffsets[5]   = {x = 1368064, y = 892928,  h = 65536, w = 65536} -- Thunder Mountain
LibSurveyor.Data.ZoneOffsets[26]  = {x = 1302528, y = 892928,  h = 65536, w = 65536} -- Cinderfall
LibSurveyor.Data.ZoneOffsets[27]  = {x = 1433600, y = 892928,  h = 65536, w = 65536} -- Death Peak
LibSurveyor.Data.ZoneOffsets[3]   = {x = 1368064, y = 958464,  h = 65536, w = 65536} -- Black Crag
LibSurveyor.Data.ZoneOffsets[4]   = {x = 1368064, y = 1024000, h = 65536, w = 65536} -- Butchers Pass

-- Empire vs Chaos --
---------------------
LibSurveyor.Data.ZoneOffsets[100] = {x = 819200,  y = 819200, h = 65536, w = 65536} -- Norsca
LibSurveyor.Data.ZoneOffsets[106] = {x = 819200,  y = 884736, h = 65536, w = 65536} -- Nordland
LibSurveyor.Data.ZoneOffsets[101] = {x = 1015808, y = 819200, h = 65536, w = 65536} -- Troll Country
LibSurveyor.Data.ZoneOffsets[107] = {x = 1015808, y = 884736, h = 65536, w = 65536} -- Ostland
LibSurveyor.Data.ZoneOffsets[102] = {x = 1212416, y = 819200, h = 65536, w = 65536} -- High Pass
LibSurveyor.Data.ZoneOffsets[108] = {x = 1212416, y = 884736, h = 65536, w = 65536} -- Talabecland
LibSurveyor.Data.ZoneOffsets[161] = {x = 420300,  y = 114032, h = 44064, w = 44064} -- Inevitable City (VERY ROUGH GUESS)
LibSurveyor.Data.ZoneOffsets[104] = {x = 1409024, y = 688128, h = 65536, w = 65536} -- The Maw
LibSurveyor.Data.ZoneOffsets[103] = {x = 1409024, y = 753664, h = 65536, w = 65536} -- Chaos Wastes
LibSurveyor.Data.ZoneOffsets[105] = {x = 1409024, y = 819200, h = 65536, w = 65536} -- Praag
LibSurveyor.Data.ZoneOffsets[120] = {x = 1343488, y = 819200, h = 65536, w = 65536} -- West Praag
LibSurveyor.Data.ZoneOffsets[109] = {x = 1409024, y = 884736, h = 65536, w = 65536} -- Reikland
LibSurveyor.Data.ZoneOffsets[110] = {x = 1409024, y = 950272, h = 65536, w = 65536} -- Reikwald
LibSurveyor.Data.ZoneOffsets[162] = {x = 104857,  y = 112264, h = 41760, w = 41760} -- Altdorf (VERY ROUGH GUESS)

-- High Elf vs Dark Elf --
--------------------------
LibSurveyor.Data.ZoneOffsets[200] = {x = 1015808, y = 1015808, h = 65536, w = 65536} -- The Blighted Isle
LibSurveyor.Data.ZoneOffsets[206] = {x = 1015808, y = 1081344, h = 65536, w = 65536} -- Chrace
LibSurveyor.Data.ZoneOffsets[201] = {x = 819200,  y = 1212416, h = 65536, w = 65536} -- The Shadowlands
LibSurveyor.Data.ZoneOffsets[207] = {x = 819200,  y = 1277952, h = 65536, w = 65536} -- Ellyrion
LibSurveyor.Data.ZoneOffsets[202] = {x = 1409024, y = 1409024, h = 65536, w = 65536} -- Avelorn
LibSurveyor.Data.ZoneOffsets[208] = {x = 1409024, y = 1474560, h = 65536, w = 65536} -- Saphery
LibSurveyor.Data.ZoneOffsets[204] = {x = 819200,  y = 1605632, h = 65536, w = 65536} -- Fell Landing
LibSurveyor.Data.ZoneOffsets[203] = {x = 884736,  y = 1605632, h = 65536, w = 65536} -- Caledor
LibSurveyor.Data.ZoneOffsets[205] = {x = 950272,  y = 1605632, h = 65536, w = 65536} -- Dragonwake
LibSurveyor.Data.ZoneOffsets[220] = {x = 950272,  y = 1474560, h = 65536, w = 65536} -- Isle of the Dead
LibSurveyor.Data.ZoneOffsets[209] = {x = 1015808, y = 1605632, h = 65536, w = 65536} -- Eataine
LibSurveyor.Data.ZoneOffsets[210] = {x = 1081344, y = 1605632, h = 65536, w = 65536} -- Shining Way