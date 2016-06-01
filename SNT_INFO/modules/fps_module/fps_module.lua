---------------------------------------------------------------------------------------------------------------------
-- FPS plugin for SNT Info by DonKaban 
---------------------------------------------------------------------------------------------------------------------

snt_info.fps_module = {}

local delay,curr,fps = 2,4,0

function snt_info.fps_module.update(elapsed)
   fps = math.floor((fps + 1/elapsed)/2)
   curr = curr - elapsed
   if(curr > 0) then return end
   curr = delay
   i_fps:set_gradient(fps,0,45)
   i_fps:set_text(tostring(fps))
end

function snt_info.fps_module.entry_point()
   d("!> ENTRY")
   i_fps = snt_info.informer:new("snt_info_fps",nil,2,nil,3,nil,nil,nil)
end