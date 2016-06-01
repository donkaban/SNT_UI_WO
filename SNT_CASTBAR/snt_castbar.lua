-- (c) SNT CASTBAR by Don Kaban

local VERSION = "1.0"

snt_castbar       = {}

local default = 
   {
   VERSION           = VERSION,
   PRESET            = 1,              
   NORMAL_COLOR      = {0,150,0},   
   CHANNEL_COLOR     = {150,150,0},
   CANCEL_COLOR      = {150,50,0},
   INTERACT_COLOR    = {0,100,150},
   LATENCY_COLOR     = {100,0,150},
   }
---------------------------------------------------------------------------------------------------------------------
local DEFICON        = 64

local WINDOW      = "SNT_CASTBAR_WINDOW"
local WSETUP      = "SNT_CASTBAR_SETUP_WINDOW"
local WSTATUS     = WINDOW.."_action_status"
local WICON       = WINDOW.."_action_icon"
local WNAME       = WINDOW.."_action_name"
local WTIME       = WINDOW.."_action_time"

local timer       = {current = 0,maximum = 0, desired = 0,latency = 0,action = 0,channel = false, autohide = false,}
local queue_flag  =  false

---------------------------------------------------------------------------------------------------------------------
local function chat(msg) TextLogAddEntry("Chat",3,StringToWString(msg)) end

local function cleanup()
   DestroyWindow("LayerTimerWindow")  
   LayoutEditor.UnregisterWindow("LayerTimerWindow")
   function LayerTimerWindow.Update() end
   function LayerTimerWindow.OnInitializeCustomSettings() end
   function LayerTimerWindow.ShowCastBar() end
   function LayerTimerWindow.HideCastBar() end
   function LayerTimerWindow.StartInteractTimer() end
   function LayerTimerWindow.SetActionName() end
end
---------------------------------------------------------------------------------------------------------------------

local function get_action_name(id)
   if (not id or id==0) then return L"" end
   local name = GetAbilityName(id)
   if (name and name ~= L"") then return name end
   return L""
end
local function set_icon(id)
   local data = GetAbilityData(id)
   icon = data.iconNum
   if(data == nil or icon == 0) then icon = DEFICON end
   local tex,x,y = GetIconData(icon)
   DynamicImageSetTextureScale(WICON,0.5)
   DynamicImageSetTexture(WICON,tex,x,y)
end

---------------------------------------------------------------------------------------------------------------------

local function reset_castbar (cast_time)
   StatusBarSetCurrentValue(WSTATUS,0)
   StatusBarSetMaximumValue(WSTATUS,cast_time)
   WindowStopAlphaAnimation(WINDOW)
   if (cast_time - timer.latency > 0 ) then
      LabelSetText(WTIME,wstring.format(L"%0.1f",cast_time - timer.latency))
   end
   WindowSetShowing(WINDOW,(cast_time - timer.latency > 0))
end

---------------------------------------------------------------------------------------------------------------------

function snt_castbar.show_castbar(id,channel,cast_time,latency)
   timer.latency = latency
   cast_time = cast_time + latency
   if ((timer.current > 0) and (timer.current < cast_time) and (not channel)) then
        timer.maximum = cast_time + (cast_time - timer.current)
   else
      timer.maximum = cast_time
   end
   timer.current = cast_time
   timer.desired = cast_time
   if (cast_time - latency == 0) then return end    
   timer.action     = id 
   timer.channel    = channel
   timer.autohide   = false
   if(channel) then  
      StatusBarSetForegroundTint(WSTATUS,unpack(SNTCAST_DB.CHANNEL_COLOR))
   else  
      StatusBarSetForegroundTint(WSTATUS,unpack(SNTCAST_DB.NORMAL_COLOR)) 
   end 
   reset_castbar(cast_time)
   LabelSetText(WNAME,get_action_name(id))   
   set_icon(id)
end

---------------------------------------------------------------------------------------------------------------------

function snt_castbar.hide_castbar(cancel,queue_call)
   if ((not cancel) and (timer.maximum < 1) and (not queue_call)) then queue_flag = true return end
   timer.latency = 0
   if (WindowGetAlpha(WINDOW) < 1) then return end
   local fade = 1
   if ((WindowGetAlpha(WINDOW) == 1) and (not cancel)) then
      WindowSetShowing(WINDOW,true)
      local fadeTime = math.max(fade,timer.current)
   else
      StatusBarSetForegroundTint(WSTATUS,unpack(SNTCAST_DB.CANCEL_COLOR))
      timer.current = 0
   end
   WindowStartAlphaAnimation(WINDOW,Window.AnimationType.SINGLE_NO_RESET,1,0,fade,false,0,0)
   queue_flag = false
end

---------------------------------------------------------------------------------------------------------------------

function snt_castbar.start_interact()
   timer.current    = GameData.InteractTimer.time
   timer.maximum    = GameData.InteractTimer.time
   timer.desired    = GameData.InteractTimer.time
   timer.action     = 0
   timer.autohide   = true
   StatusBarSetForegroundTint(WSTATUS,unpack(SNTCAST_DB.INTERACT_COLOR))
   LabelSetText(WNAME,GameData.InteractTimer.objectName)
   reset_castbar(timer.desired)         
end

---------------------------------------------------------------------------------------------------------------------

function snt_castbar.set_back(cast_time)
    assert(timer.current > 0)
    timer.current = cast_time
end

---------------------------------------------------------------------------------------------------------------------

function snt_castbar.update(elapsed)
   local normalized     = -1 
   local val = 0 
   if ((timer.current > 0) and (timer.maximum > 0)) then
      timer.current   = timer.current - elapsed
      if (timer.current < 0) then timer.current = 0 end
      normalized = (timer.current / timer.maximum) * timer.desired  
   end
   if(normalized >= 0) then
      LabelSetText(WTIME,wstring.format(L"%0.1f",timer.current))
      if(timer.channel) then 
         val = normalized
      else 
         val = timer.desired - normalized end
      StatusBarSetCurrentValue(WSTATUS,val)
   end
end

---------------------------------------------------------------------------------------------------------------------
-- GUI setup crap
---------------------------------------------------------------------------------------------------------------------
local function update_gui() 
   for ndx = 1,8 do ButtonSetPressedFlag(WSETUP..ndx.."_chk",(SNTCAST_DB.PRESET == ndx)) end
end
local function create_gui()
   CreateWindow(WSETUP,false)
   ButtonSetText(WSETUP.."_reload_ui", L"ReloadUI")
   ButtonSetText(WSETUP.."_close", L"Close")
   WindowSetShowing(WSETUP,false)
   update_gui()
end
function snt_castbar.toggle_setup(val) WindowSetShowing(WSETUP,not WindowGetShowing(WSETUP)) end

function snt_castbar.set1() SNTCAST_DB.PRESET = 1 update_gui() end
function snt_castbar.set2() SNTCAST_DB.PRESET = 2 update_gui() end
function snt_castbar.set3() SNTCAST_DB.PRESET = 3 update_gui() end
function snt_castbar.set4() SNTCAST_DB.PRESET = 4 update_gui() end
function snt_castbar.set5() SNTCAST_DB.PRESET = 5 update_gui() end
function snt_castbar.set6() SNTCAST_DB.PRESET = 6 update_gui() end
function snt_castbar.set7() SNTCAST_DB.PRESET = 7 update_gui() end
function snt_castbar.set8() SNTCAST_DB.PRESET = 8 update_gui() end

function snt_castbar.entry_point()
   d("! SNT CASTBAR LOADED !") 
   if((not SNTCAST_DB) or (not SNTCAST_DB.VERSION) or (SNTCAST_DB.VERSION ~= VERSION)) then SNTCAST_DB = default end
   chat("snt castbar v "..SNTCAST_DB.VERSION.." type /sntcast for settings")
   cleanup()
   CreateWindowFromTemplate(WINDOW,"SNT_CAST_TPL_"..SNTCAST_DB.PRESET,"Root")
   WindowSetShowing(WINDOW,false)
   WindowSetShowing(WINDOW,"ST"..SNTCAST_DB.PRESET,false)
   WindowSetAlpha(WINDOW,1)
   reset_castbar(0)
   LayoutEditor.RegisterWindow(WINDOW,L"SNT_CAST",L"SNT CAST",true,true,true,nil)
   WindowRegisterEventHandler (WINDOW, SystemData.Events.PLAYER_START_INTERACT_TIMER,  "snt_castbar.start_interact")
   WindowRegisterEventHandler (WINDOW, SystemData.Events.INTERACT_DONE,                "snt_castbar.hide_castbar")
   WindowRegisterEventHandler (WINDOW, SystemData.Events.PLAYER_BEGIN_CAST,            "snt_castbar.show_castbar")
   WindowRegisterEventHandler (WINDOW, SystemData.Events.PLAYER_END_CAST,              "snt_castbar.hide_castbar")
   WindowRegisterEventHandler (WINDOW, SystemData.Events.PLAYER_CAST_TIMER_SETBACK,    "snt_castbar.set_back")
   WindowRegisterEventHandler (WINDOW, SystemData.Events.PLAYER_DEAD,                  "snt_castbar.hide_castbar")
   create_gui()
   LibSlash.RegisterSlashCmd("sntcast",snt_castbar.toggle_setup)

end       




