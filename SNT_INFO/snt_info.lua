-- (c) SNT INFO by Don Kaban

local VERSION     = "1.0"

snt_info          = {}
snt_info.informer = {}
snt_info.itable   = {}

local default     = {
                     VERSION  = VERSION,
                     PRESET   = 2,
                     FONT     = 1,
                     ICON     = 1,
                     TEXT_COL = {200,200,250},
                     SCALE    = 0.8,
                     ALPHA    = 1,
                     }
                     
local DB
local QUAD        = 32
local DQUAD       = 64
local FONT_W      = 16      
local FONT_H      = 24
local SPACE       = 256

---------------------------------------------------------------------------------------------------------------------
local function chat(msg) TextLogAddEntry("Chat",2,StringToWString(msg)) end
local function alert(msg)
   SystemData.AlertText.VecType = {SystemData.AlertText.Types.STATUS_ACHIEVEMENTS_PURPLE}
   SystemData.AlertText.VecText = {StringToWString(msg)}
   AlertTextWindow.AddAlert()
end
---------------------------------------------------------------------------------------------------------------------
local CreateWindowFromTemplate,WindowSetDimensions,WindowClearAnchors,WindowAddAnchor,
      WindowRegisterCoreEventHandler,WindowSetLayer,DestroyWindow,RegisterEventHandler,
      DynamicImageSetTextureDimensions,DynamicImageSetTexture,
      StatusBarSetMaximumValue,StatusBarSetCurrentValue,StatusBarSetForegroundTint,
      LabelSetText,LabelSetTextColor =
     _G["CreateWindowFromTemplate"],_G["WindowSetDimensions"],_G["WindowClearAnchors"],_G["WindowAddAnchor"],
     _G["WindowRegisterCoreEventHandler"],_G["WindowSetLayer"],_G["DestroyWindow"],_G["RegisterEventHandler"],
     _G["DynamicImageSetTextureDimensions"],_G["DynamicImageSetTexture"],
     _G["StatusBarSetMaximumValue"],_G["StatusBarSetCurrentValue"],_G["StatusBarSetForegroundTint"],
     _G["LabelSetText"],_G["LabelSetTextColor"] 
---------------------------------------------------------------------------------------------------------------------


local chars = 
   {
   [0x30] = 000,[0x31] = 016,[0x32] = 032,[0x33] = 048,[0x34] = 064,[0x35] = 080,[0x36] = 096,
   [0x37] = 112,[0x38] = 128,[0x39] = 144,[0x2E] = 160,[0x2C] = 176,[0x3A] = 190,[0x5B] = 206,
   [0x5D] = 222,[0x25] = 240,[0x20] = 256,[0x2F] = 272,[0x2A] = 288,}

-----------------------------------------------------------------------------------------------------------------------
-- INFORMER CLASS (icon - num on snt icons file)
-----------------------------------------------------------------------------------------------------------------------
function snt_info.informer:new(wname,tpl,slen,col,icon,ovf,lcf,rcf)
   local instance    = {}
   instance.wname    = wname 
   instance.icon     = icon   
   instance.slen     = slen
   instance.ovf      = ovf  
   instance.lcf      = lcf 
   instance.rcf      = rcf
   instance.tpl      = tpl or "SNT_INFO_TPL"
   instance.len      = slen* FONT_W + QUAD + 4
 
   CreateWindowFromTemplate(wname,instance.tpl,"Root")
   WindowSetDimensions(wname,instance.len,QUAD)
   WindowSetDimensions(wname.."_center",instance.len-DQUAD,QUAD)
   WindowSetDimensions(wname.."_status",instance.len-QUAD,QUAD)
   DynamicImageSetTextureDimensions(wname.."_center",QUAD,QUAD)
   DynamicImageSetTexture(wname.."_icon"  , "snt_info_icons"   ,DB.ICON*QUAD ,icon*QUAD)
   DynamicImageSetTexture(wname.."_left"  , "snt_info_textures",0    ,DB.PRESET*QUAD)
   DynamicImageSetTexture(wname.."_center","snt_info_textures" ,32   ,DB.PRESET*QUAD)
   DynamicImageSetTexture(wname.."_right" ,"snt_info_textures" ,64   ,DB.PRESET*QUAD) 
   if(ovf) then WindowRegisterCoreEventHandler(wname.."_icon","OnMouseOver",ovf)  end
   if(lcf) then WindowRegisterCoreEventHandler(wname,"OnLButtonDown" ,lcf)  end
   if(rcf) then WindowRegisterCoreEventHandler(wname,"OnRButtonDown" ,rcf)  end
   if(slen == 0 ) then WindowSetShowing(wname.."_center",false) WindowSetShowing(wname.."_right",false)
   else
      for ndx = 1,instance.slen do
         CreateWindowFromTemplate(wname.."l"..ndx,"SNT_LETTER",wname)
         WindowSetDimensions(wname.."l"..ndx,FONT_W,FONT_H)
         WindowSetScale(wname.."l"..ndx,DB.SCALE)
         if(ndx == 1) then WindowAddAnchor(wname.."l"..ndx,"left",wname.."_center","left",0,0)
         else WindowAddAnchor(wname.."l"..ndx,"right",wname.."l"..ndx-1,"left",0,0)
         end
         DynamicImageSetTexture(wname.."l"..ndx,"snt_info_font",SPACE,DB.FONT*FONT_H)
         WindowSetTintColor(wname.."l"..ndx,unpack(DB.TEXT_COL))
      end
   end
   WindowSetAlpha(wname,DB.ALPHA)
   WindowSetScale(wname,DB.SCALE)
   WindowSetShowing(wname,true)
   LayoutEditor.RegisterWindow(wname,StringToWString(wname),StringToWString(wname),true,true,true,nil)
   table.insert(snt_info.itable,instance)
   setmetatable(instance,self)   
   self.__index   = self
   return instance
end
---------------------------------------------------------------------------------------------------------------------
function snt_info.informer:set_text(txt) 
   for ndx = 1,self.slen do DynamicImageSetTexture(self.wname.."l"..ndx,"snt_info_font",SPACE,DB.FONT*FONT_H) end
   if (type(txt) == "string") then
      for ndx = 1, string.len(txt) do
         local char = string.byte(txt,ndx)
         if(ndx <= self.slen) then
            local tex
            if(char > 0x60 and char < 0x7A) then tex = 304+FONT_W*(char-0x61)
            else tex = chars[char] or SPACE
            end
            DynamicImageSetTexture(self.wname.."l"..ndx,"snt_info_font",tex,DB.FONT*FONT_H) 
         end
      end
   end
end 
---------------------------------------------------------------------------------------------------------------------
function snt_info.informer:set_text_col(col)    
   for ndx = 1,self.slen do WindowSetTintColor(self.wname.."l"..ndx,unpack(col)) end
end
---------------------------------------------------------------------------------------------------------------------
function snt_info.informer:set_gradient(val,bad,good)
   local percent,r,g
   if (good > bad) then percent = val/(good-bad) else percent = 1-val/(bad-good) end
   if (percent > 1) then percent = 1 end if (percent < 0) then percent = 0 end
   if(percent < 0.5) then r,g = 1,2*percent   else  r,g = (1-percent)*2,1 end
   for ndx = 1,self.slen do WindowSetTintColor(self.wname.."l"..ndx,r*255,g*255,0) end
end
---------------------------------------------------------------------------------------------------------------------
function snt_info.informer:set_status_val(val,val_max) 
   StatusBarSetMaximumValue(self.wname.."_status",val_max)
   StatusBarSetCurrentValue(self.wname.."_status",val)
end 
---------------------------------------------------------------------------------------------------------------------
function snt_info.informer:set_status_col(col) StatusBarSetForegroundTint(self.wname.."_status",unpack(col)) end

--  add more functionality to informer class in next version
--



function snt_info.update_informers()
   for ndx = 1 ,#snt_info.itable do
      local self =  snt_info.itable[ndx]
      WindowSetScale(self.wname,DB.SCALE)
      WindowSetAlpha(self.wname,DB.ALPHA)
      DynamicImageSetTexture(self.wname.."_icon"  , "snt_info_icons"   ,DB.ICON*QUAD ,self.icon*QUAD)
      DynamicImageSetTexture(self.wname.."_left"  , "snt_info_textures",0    ,DB.PRESET*QUAD)
      DynamicImageSetTexture(self.wname.."_center","snt_info_textures" ,32   ,DB.PRESET*QUAD)
      DynamicImageSetTexture(self.wname.."_right" ,"snt_info_textures" ,64   ,DB.PRESET*QUAD) 
    for xxl = 1,self.slen do
         WindowSetScale(self.wname.."l"..xxl,DB.SCALE)
         WindowSetTintColor(self.wname.."l"..xxl,unpack(DB.TEXT_COL))
      end
   end
end
----------------------------------------------------------------------------------------------------------------------
-- GUI setup crap
----------------------------------------------------------------------------------------------------------------------
local WSETUP = "SNT_INFO_SETUP_WINDOW"

local function update_gui(need_reload)
   d("!> UPDATE GUI")
   for ndx = 0,3 do ButtonSetPressedFlag(WSETUP.."_B"..ndx,(DB.PRESET   == ndx)) end
   for ndx = 0,3 do ButtonSetPressedFlag(WSETUP.."_I"..ndx,(DB.ICON     == ndx)) end
   for ndx = 0,7 do ButtonSetPressedFlag(WSETUP.."_F"..ndx,(DB.FONT     == ndx)) end
   SliderBarSetCurrentPosition(WSETUP.."_SR",DB.TEXT_COL[1]/255) 
   SliderBarSetCurrentPosition(WSETUP.."_SG",DB.TEXT_COL[2]/255) 
   SliderBarSetCurrentPosition(WSETUP.."_SB",DB.TEXT_COL[3]/255) 
   SliderBarSetCurrentPosition(WSETUP.."_SA",DB.ALPHA) 
   SliderBarSetCurrentPosition(WSETUP.."_SS",DB.SCALE) 
   if(need_reload) then WindowSetShowing(WSETUP.."_reload_ui",true)
   else snt_info.update_informers() end
end

function snt_info.toggle_setup()
   if(not DoesWindowExist(WSETUP)) then
      CreateWindow(WSETUP,false)
      ButtonSetText(WSETUP.."_close", L"Close")
      ButtonSetText(WSETUP.."_reload_ui", L"NeedReload")
   end
   WindowSetShowing(WSETUP,not WindowGetShowing(WSETUP))
   WindowSetShowing(WSETUP.."_reload_ui",false)
   update_gui(false)
end

-- bad but very simple technic. its crap but its working crap :) -----------------------------------------

function snt_info.F0()  DB.FONT     = 0 update_gui(true) end
function snt_info.F1()  DB.FONT     = 1 update_gui(true) end
function snt_info.F2()  DB.FONT     = 2 update_gui(true) end
function snt_info.F3()  DB.FONT     = 3 update_gui(true) end
function snt_info.F4()  DB.FONT     = 4 update_gui(true) end
function snt_info.F5()  DB.FONT     = 5 update_gui(true) end
function snt_info.F6()  DB.FONT     = 6 update_gui(true) end
function snt_info.F7()  DB.FONT     = 7 update_gui(true) end
function snt_info.I0()  DB.ICON     = 0 update_gui(false) end
function snt_info.I1()  DB.ICON     = 1 update_gui(false) end
function snt_info.I2()  DB.ICON     = 2 update_gui(false) end
function snt_info.I3()  DB.ICON     = 3 update_gui(false) end
function snt_info.B0()  DB.PRESET   = 0 update_gui(false) end
function snt_info.B1()  DB.PRESET   = 1 update_gui(false) end
function snt_info.B2()  DB.PRESET   = 2 update_gui(false) end
function snt_info.B3()  DB.PRESET   = 3 update_gui(false) end

function snt_info.slider_change()
   DB.TEXT_COL[1] = math.floor(SliderBarGetCurrentPosition(WSETUP.."_SR")*255)
   DB.TEXT_COL[2] = math.floor(SliderBarGetCurrentPosition(WSETUP.."_SG")*255)
   DB.TEXT_COL[3] = math.floor(SliderBarGetCurrentPosition(WSETUP.."_SB")*255)
   DB.ALPHA       = SliderBarGetCurrentPosition(WSETUP.."_SA")
   DB.SCALE       = SliderBarGetCurrentPosition(WSETUP.."_SS")
   snt_info.update_informers()
end


---------------------------------------------------------------------------------------------------------------------
-- ENTRY POINT
---------------------------------------------------------------------------------------------------------------------

function snt_info.on_load()
   chat("snt info v "..DB.VERSION) 
   i_setup = snt_info.informer:new("i_setup",nil,0,nil,8,nil,"snt_info.toggle_setup",nil)
end

function snt_info.entry_point()
   d("!> ENTRY POINT") 
   if((not SNTINFO_DB) or (SNTINFO_DB.VERSION ~= VERSION)) then SNTINFO_DB = default end
   DB = SNTINFO_DB
   RegisterEventHandler(SystemData.Events.LOADING_END, "snt_info.on_load")
   RegisterEventHandler(SystemData.Events.RELOAD_INTERFACE,"snt_info.on_load")
end       




