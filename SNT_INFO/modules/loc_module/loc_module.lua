---------------------------------------------------------------------------------------------------------------------
-- Location plugin for snt_info by DonKaban (Axe Bite Pass EU)
---------------------------------------------------------------------------------------------------------------------

snt_info.loc_module = {}

function  snt_info.loc_module.update()
   local px,py = LibSurveyor.PlayerLocation.zoneX,LibSurveyor.PlayerLocation.zoneY
   i_loc:set_text(tostring(math.floor(px/1000)).."."..tostring(math.floor(py/1000)))
end

---------------------------------------------------------------------------------------------------------------------

local TT = Tooltips.SetTooltipText
local TC = Tooltips.SetTooltipColor

function snt_info.loc_module.tooltip()
   local px,py = LibSurveyor.PlayerLocation.zoneX,LibSurveyor.PlayerLocation.zoneY
   local data = GetAreaData()
   Tooltips.CreateTextOnlyTooltip(i_loc.wname.."_icon",nil)
   Tooltips.AnchorTooltip(Tooltips.ANCHOR_WINDOW_BOTTOM)
   TC(1,1,100,255,200)  TT(1,1,data[1].areaName) 
   TC(1,2,255,255,100)  TT(1,2,GetZoneName(GameData.Player.zone)) 
   TC(2,1,200,100,200)  TT(2,1,L"X position") TC(2,2,200,100,200) TT(2,2,towstring(math.floor(px)))
   TC(3,1,200,100,200)  TT(3,1,L"Y position") TC(3,2,200,100,200) TT(3,2,towstring(math.floor(py)))
   Tooltips.Finalize()
end

function snt_info.loc_module.click() WindowSetShowing("EA_Window_WorldMap",true) end

---------------------------------------------------------------------------------------------------------------------
-- ENTRY POINT 
---------------------------------------------------------------------------------------------------------------------

function snt_info.loc_module.entry_point()
   d("!> ENTRY")
   RegisterEventHandler(SystemData.Events.PLAYER_POSITION_UPDATED,"snt_info.loc_module.update")
   i_loc = snt_info.informer:new("i_loc",nil,5,nil,9,
                                "snt_info.loc_module.tooltip",
                                "snt_info.loc_module.click",nil)
   snt_info.loc_module.update()
end