---------------------------------------------------------------------------------------------------------------------
-- Guild and Friends plugin for snt_info by DonKaban 
---------------------------------------------------------------------------------------------------------------------

snt_info.social_module = {}

-----------------------------------------------------------------------------------------------------------------------

function  snt_info.social_module.gl_update()
   local gl_list,online = GetGuildMemberData(),0
   local total = #gl_list
   for ndx = 1, total do if (gl_list[ndx].zoneID ~= 0) then online = online+1 end end
   i_gl:set_text(tostring(online).."/"..tostring(total))
end

-----------------------------------------------------------------------------------------------------------------------

function snt_info.social_module.fr_update()
   local fr_list, online = GetFriendsList(),0
   local total = #fr_list
  for ndx = 1, total do if (fr_list[ndx].zoneID ~= 0) then online = online+1 end end
   i_fr:set_text(tostring(online).."/"..tostring(total))
end

-----------------------------------------------------------------------------------------------------------------------

function snt_info.social_module.fr_click() WindowUtils.ToggleShowing("SocialWindow") end
function snt_info.social_module.gl_click() WindowUtils.ToggleShowing("GuildWindow")  end

local TT = Tooltips.SetTooltipText
local TC = Tooltips.SetTooltipColor

function snt_info.social_module.gl_tooltip()
   local gl_list,line,lvl_col = GetGuildMemberData(),3 
   local pack,out_str,rank,online = 4,L"",0,0
   local xp = math.floor(GameData.Guild.m_GuildExpInCurrentLevel/1000000)
   local xp_need = math.floor(GameData.Guild.m_GuildExpNeeded/1000000)

   Tooltips.CreateTextOnlyTooltip(i_gl.wname.."_icon",nil)
   Tooltips.AnchorTooltip(Tooltips.ANCHOR_WINDOW_BOTTOM)
   TC(1,1,200,255,200)  TT(1,1,GameData.Guild.m_GuildName) 
   TC(1,2,200,255,200)  TT(1,2,towstring(GameData.Guild.m_GuildRank)..L" Rank")
   TC(2,2,100,255,100)  TT(2,2,towstring(xp)..L"M XP")
   TC(3,2,200,100,100)  TT(3,2,towstring(xp_need)..L"M Need")
   TC(4,2,200,255,50)   TT(4,2,towstring(xp_need-xp)..L"M Rem")
   for ndx = 1, #gl_list do 
      if(gl_list[ndx].zoneID ~= 0) then 
         online = online+1;rank = rank + gl_list[ndx].rank;pack = pack - 1
         out_str = out_str..towstring(gl_list[ndx].name)..L"  "
         if(pack == 0) then TT(line,1,out_str);out_str  = L"";pack = 4;line = line + 1 end
      end
      if(out_str ~= L"") then TT(line,1,out_str) end
   end
   rank = math.floor(rank/online)
   TC(2,1,255,255,000)  TT(2,1,L"Online : "..towstring(online)..L" AverageRank : "..towstring(rank)) 
   Tooltips.Finalize()
end

function snt_info.social_module.fr_tooltip()
   local fr_list,line = GetFriendsList(),3
   Tooltips.CreateTextOnlyTooltip(i_fr.wname.."_icon",nil)
   Tooltips.AnchorTooltip(Tooltips.ANCHOR_WINDOW_BOTTOM)
   TC(1,1,200,255,200)  TT(1,1,L"Friends Info") 
   TC(2,1,255,255,000)  TT(2,1,L"-----------------------------------")
   for ndx = 1,#fr_list do 
      if (fr_list[ndx].zoneID ~= 0) then
         local rank = fr_list[ndx].rank
         if(rank > GameData.Player.level + 5)      then lvl_col = {255,200,150}
         elseif(rank < GameData.Player.level - 5)  then lvl_col = {150,250,100}
         else lvl_col = {250,250,20} end
         TC(line,1,unpack(lvl_col))              TC(line,2,unpack(lvl_col)) 
         TT(line,1,towstring(fr_list[ndx].name)) TT(line,2,towstring(rank))
         line  = line + 1
      end
   end
  Tooltips.Finalize()
end





---------------------------------------------------------------------------------------------------------------------
-- ENTRY POINT 
---------------------------------------------------------------------------------------------------------------------

function snt_info.social_module.entry_point()
   d("!> ENTRY")

   RegisterEventHandler(SystemData.Events.GUILD_MEMBER_UPDATED,   "snt_info.social_module.gl_update")
   RegisterEventHandler(SystemData.Events.SOCIAL_FRIENDS_UPDATED, "snt_info.social_module.fr_update")
   i_fr = snt_info.informer:new("i_fr",nil,5,nil,4,"snt_info.social_module.fr_tooltip","snt_info.social_module.fr_click",nil)
   i_gl = snt_info.informer:new("i_gl",nil,7,nil,5,"snt_info.social_module.gl_tooltip","snt_info.social_module.gl_click",nil)
   snt_info.social_module.fr_update()
   snt_info.social_module.gl_update()
end