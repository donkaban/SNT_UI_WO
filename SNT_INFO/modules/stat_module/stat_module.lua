---------------------------------------------------------------------------------------------------------------------
-- XP and Renown module for SNT Info by Don Kaban
---------------------------------------------------------------------------------------------------------------------

snt_info.stat_module = {}

local function get_xp()
   return  GameData.Player.Experience.curXpEarned,GameData.Player.Experience.curXpNeeded,GameData.Player.Experience.restXp
end
local function get_rn()
   return GameData.Player.Renown.curRenownEarned,GameData.Player.Renown.curRenownNeeded
end

local SF = string.format

function snt_info.stat_module.xp_update()
   if (GameData.Player.level == 40) then i_xp:set_text("levelcap") return end
   local xp,xp_need,xp_rest = get_xp() 
   i_xp:set_text(SF("%d:%02d%%",GameData.Player.level,xp/xp_need*100,(xp_need-xp)/1000)) 
   i_xp:set_status_val(xp,xp_need)

end

function snt_info.stat_module.rn_update()
   if (GameData.Player.Renown.curRank == 80) then i_rn:set_text("levelcap") return end
   local rn,rn_need = get_rn()
   i_rn:set_text(SF("%d:%02d%%",GameData.Player.Renown.curRank,rn/rn_need*100,(rn_need-rn)/1000))
   i_rn:set_status_val(rn,rn_need)

end

function snt_info.stat_module.click() WindowUtils.ToggleShowing("CharacterWindow") end
---------------------------------------------------------------------------------------------------------------------

local TT = Tooltips.SetTooltipText
local TC = Tooltips.SetTooltipColor

function snt_info.stat_module.xp_tooltip()
   local xp,xp_need,xp_rest = get_xp() 
   Tooltips.CreateTextOnlyTooltip(i_xp.wname.."_icon",nil)
   Tooltips.AnchorTooltip(Tooltips.ANCHOR_WINDOW_BOTTOM)
   TC(1,1,200,255,200)  TT(1,1,L"XP Info")
   TC(2,1,255,255,000)  TT(2,1,L"---------------------------------------")   
   TC(3,1,050,200,050)  TT(3,1,L"XP")        TC(3,2,050,200,050) TT(3,2,towstring(xp))
   TC(4,1,050,200,100)  TT(4,1,L"Needed")    TC(4,2,050,200,100) TT(4,2,towstring(xp_need))
   TC(5,1,200,150,050)  TT(5,1,L"Remaining") TC(5,2,200,150,050) TT(5,2,towstring(xp_need-xp))
   TC(6,1,255,255,050)  TT(6,1,L"Rested")    TC(6,2,255,255,050) TT(6,2,towstring(xp_rest))
   Tooltips.Finalize()
end

function snt_info.stat_module.rn_tooltip()
   local rn,rn_need = get_rn()
   Tooltips.CreateTextOnlyTooltip(i_rn.wname.."_icon",nil)
   Tooltips.AnchorTooltip(Tooltips.ANCHOR_WINDOW_BOTTOM)
   TC(1,1,255,200,255)  TT(1,1,L"Renown Info")
   TC(2,1,255,255,000)  TT(2,1,L"----------------------------------------")   
   TC(3,1,200,050,200)  TT(3,1,L"Renown")    TC(3,2,200,050,200) TT(3,2,towstring(rn))
   TC(4,1,050,200,100)  TT(4,1,L"Needed")    TC(4,2,050,200,100) TT(4,2,towstring(rn_need))
   TC(5,1,200,150,050)  TT(5,1,L"Remaining") TC(5,2,200,150,050) TT(5,2,towstring(rn_need-rn))
   Tooltips.Finalize()
end

---------------------------------------------------------------------------------------------------------------------
-- ENTRY POINT 
---------------------------------------------------------------------------------------------------------------------

function snt_info.stat_module.entry_point()
   d("!> ENTRY")
   RegisterEventHandler(SystemData.Events.PLAYER_EXP_UPDATED,   "snt_info.stat_module.xp_update")
   RegisterEventHandler(SystemData.Events.PLAYER_RENOWN_UPDATED,"snt_info.stat_module.rn_update")
   i_xp = snt_info.informer:new("i_xp",nil,6,nil,0,"snt_info.stat_module.xp_tooltip","snt_info.stat_module.click",nil)
   i_rn = snt_info.informer:new("i_rn",nil,6,nil,1,"snt_info.stat_module.rn_tooltip","snt_info.stat_module.click",nil)
   i_xp:set_status_col({25,150,25})
   i_rn:set_status_col({150,25,150})  
   snt_info.stat_module.xp_update()
   snt_info.stat_module.rn_update()
end