
snt_info.tt_module = {}

function snt_info.tt_module.lclick() TTitan.UI.ToggleShowing() end

function snt_info.tt_module.rclick() TTitan.UI.ExpandCurrentZone() TTitan.UI.Show() end

function snt_info.tt_module.entry_point()
   WindowSetShowing("TTitanTTButtonWindow",false)
   i_tt = snt_info.informer:new("i_tt",nil,2,nil,11,nil,"snt_info.tt_module.lclick","snt_info.tt_module.rclick")
   i_tt:set_text("tt")
end
