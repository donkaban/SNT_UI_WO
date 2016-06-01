---------------------------------------------------------------------------------------------------------------------
-- Clock plugin for SNT Info by DonKaban 
---------------------------------------------------------------------------------------------------------------------

snt_info.time_module = {}

local cur_s,cur_m,cur_h 

function snt_info.time_module.update(elapsed)
   local last_entry,last_time = TextLogGetNumEntries("Chat") - 1,0
   if (last_entry >= 0) then last_time = TextLogGetEntry("Chat",last_entry)
   else return end
   if (not snt_info.time_module.clock_update) then snt_info.time_module.clock_update = last_time end
   if (last_time ~= snt_info.time_module.last_update) then
      snt_info.time_module.last_update = last_time
      local h,m,s = last_time:match(L"([0-9]+):([0-9]+):([0-9]+)")
      cur_h = tonumber(h);cur_m = tonumber(m); cur_s = tonumber(s)
   else
      cur_s = cur_s + elapsed
      while (cur_s >= 60) do cur_m = cur_m+1; cur_s = cur_s-60; end
      while (cur_s >= 60) do cur_h = cur_h+1; cur_m = cur_m-60; end
      if(cur_h >= 24) then cur_h = (cur_h % 24) end
   end
   
   i_time:set_text(string.format("%02d:%02d:%02d",cur_h,cur_m,cur_s))
   i_time:set_status_val(cur_s,60)

end

---------------------------------------------------------------------------------------------------------------------
-- ENTRY POINT 
---------------------------------------------------------------------------------------------------------------------

function snt_info.time_module.entry_point()
   d("!> ENTRY")
   i_time = snt_info.informer:new("snt_info_time",nil,8,nil,2,nil,nil,nil)
   i_time:set_status_col({50,50,25})
end