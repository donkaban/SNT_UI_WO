---------------------------------------------------------------------------------------------------------------------
-- Influence plugin for snt_info by DonKaban (Axe Bite Pass EU)
---------------------------------------------------------------------------------------------------------------------

snt_info.inf_module = {}

---------------------------------------------------------------------------------------------------------------------

local function getID()
   local area_data = GetAreaData()
    if(not area_data) then return end
    for _,val in ipairs(area_data) do
      if (val.influenceID ~= 0) then return val.influenceID end
    end
    return nil
end

local function get_inf_info()
   local ID    = getID()
   local data  = DataUtils.GetInfluenceData(ID)
   local rew_lvl,perc 
   if(not data) then return nil end
   local race  = StringUtils.GetFriendlyRaceForCurrentPairing(zonePairing,true)
   local chapt = GetChapterShortName(ID)
   local cur   = data.curValue
   local need_1 = data.rewardLevel[1].amountNeeded
   local need_2 = data.rewardLevel[2].amountNeeded
   local need_3 = data.rewardLevel[3].amountNeeded
   if(cur > need_1 and cur < need_2)      then rew_lvl = 1  
   elseif(cur > need_2 and cur < need_3)  then rew_lvl = 2
   elseif(cur == need_3) then  rew_lvl = 3 
   else rew_lvl = 0 end
   perc = math.floor(cur/need_3*100)
   return race,chapt,cur,need_1,need_2,need_3,rew_lvl,perc
end  

--------------------------------------------------------------------------------------------------------------------

function snt_info.inf_module.update()
   local race,chapt,cur,need_1,need_2,need_3,rew_lvl,perc = get_inf_info()

   if(race) then 
      i_inf:set_gradient(perc,0,100)
      i_inf:set_text(string.format("%d %02d%%",rew_lvl,perc))
      i_inf:set_status_val(perc,100)
   else
      i_inf:set_text_col({50,100,100}) 
      i_inf:set_text("no pq") 
      i_inf:set_status_val(0,100)

   end
 end

--------------------------------------------------------------------------------------------------------------------

function snt_info.inf_module.show_ea_bar()
   WindowUtils.ToggleShowing("EA_Window_PublicQuestTrackerInfluenceBar")
   WindowUtils.ToggleShowing("EA_Window_PublicQuestTrackerLocationPublicQuestIcon")
   WindowUtils.ToggleShowing("EA_Window_PublicQuestTrackerLocationPairingLabel")
   WindowUtils.ToggleShowing("EA_Window_PublicQuestTrackerLocationChapterLabel")
end
--------------------------------------------------------------------------------------------------------------------
function snt_info.inf_module.show_tome()
   local data = DataUtils.GetInfluenceData(getID())
   if(WindowGetShowing("TomeWindow")) then WindowSetShowing("TomeWindow",false)
   else
      if(data.tomeSection) then
         TomeWindow.OpenTomeToEntry(data.tomeSection,data.tomeEntry)
      else
         TomeWindow.OpenTomeToEntry(0,0)
      end
   end
end
--------------------------------------------------------------------------------------------------------------------
local TT = Tooltips.SetTooltipText
local TC = Tooltips.SetTooltipColor

function snt_info.inf_module.tooltip()
   local race,chapt,cur,need_1,need_2,need_3,rew_lvl,perc = get_inf_info()
   Tooltips.CreateTextOnlyTooltip(i_inf.wname.."_icon",nil)
   Tooltips.AnchorTooltip(Tooltips.ANCHOR_WINDOW_BOTTOM)
   if(race) then
      TC(1,1,100,200,200) TT(1,1,L"Influence Info")  
      TC(2,1,200,200,000) TT(2,1,L"--------------------------------------")
      TC(3,1,200,200,000) TT(3,1,L"Race")               TC(3,2,200,200,000)   TT(3,2,towstring(race))
      TC(4,1,100,200,100) TT(4,1,L"Chapter")            TC(4,2,100,200,100)   TT(4,2,towstring(chapt))
      TC(5,1,050,200,200) TT(5,1,L"Current inf")        TC(5,2,050,200,200)   TT(5,2,towstring(cur))
      TC(6,1,200,200,000) TT(6,1,L"Reward level")       TC(6,2,200,200,000)   TT(6,2,towstring(rew_lvl))
      TC(7,1,000,200,200) TT(7,1,L"Need to max reward") TC(7,2,000,200,200)   TT(7,2,towstring(need_3-cur))
   else
     TT(1,1,L"NO PQ HERE") 
   end
   Tooltips.Finalize()
end

---------------------------------------------------------------------------------------------------------------------
-- ENTRY POINT 
---------------------------------------------------------------------------------------------------------------------

function snt_info.inf_module.entry_point()
   d("!> ENTRY")

   RegisterEventHandler(SystemData.Events.PLAYER_INFLUENCE_UPDATED,"snt_info.inf_module.update")
   RegisterEventHandler(SystemData.Events.PLAYER_POSITION_UPDATED,"snt_info.inf_module.update")

   i_inf = snt_info.informer:new("i_inf",nil,5,nil,6,
                                 "snt_info.inf_module.tooltip",
                                 "snt_info.inf_module.show_tome",
                                 "snt_info.inf_module.show_ea_bar")
   i_inf:set_status_col({50,150,150})
   snt_info.inf_module.show_ea_bar()
   snt_info.inf_module.update()

end