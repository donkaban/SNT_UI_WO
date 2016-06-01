-- (c) SNT BUTTONS by Don Kaban

local VERSION = "1.6"

snt_buttons       = {}

local default = 
   {
   VERSION           =  VERSION,
   PRESET            =  3,
   LABEL_FONT        = "font_clear_small_bold",
   TIMER_FONT        = "font_clear_large_bold",
   TIMER_FONT_BIG    = "font_alert_outline_medium",
   CD_CLASSIC        = false,
   CD_FLAME          = true,
   CD_LOS            = true,
   HIDE_TT           = true,
   BAR               = {{columns = 12,back = false,empty = false, page  = false,},
                        {columns = 12,back = false,empty = false, page  = false,},
                        {columns = 12,back = false,empty = false, page  = false,},
                        {columns = 1, back = false,empty = true,  page  = false,},},
   TOGGLER           = {"center","Root","center",0,0},
   FLASHER           = {"center","Root","center",0,-250},
   FLASH_SIZE        = 150,
   CD_ALPHA          = 0.8,
   CDP_ENABLE        = true,
   CDP_ZOOM          = true,
   CDP_ALPHA         = true,
  }

snt_buttons.buttons_set    =  -- ny,dim,offset
   {{0,56,4},{64,56,4},{128,56,4},{192,44,10},{256,44,10},{320,44,10},{384,44,10},{448,40,12}, 
   {512,50,7},{576,50,7},{640,50,7},{704,50,7},{768,50,7},{832,50,7},{896,56,4},{960,56,4},}

local WSETUP      = "SNT_BUTTONS_SETUP"
local WTEMPLATE   = "SNT_BUTTONS_FLASH"
local WANCH       = "SNT_BUTTONS_FLASH_ANCHOR"
local DB
---------------------------------------------------------------------------------------------------------------------
local TextLogAddEntry,ButtonSetTexture,WindowClearAnchors,WindowAddAnchor,WindowSetDimensions,
      WindowGetAnchor,LabelSetFont,CooldownDisplaySetCooldown,GetHotbarCooldown,WindowSetShowing,
      WindowGetShowing,ButtonSetPressedFlag,CreateWindow,RegisterEventHandler,DoesWindowExist,
      WindowGetDimensions = 
     _G["TextLogAddEntry"],_G["ButtonSetTexture"],_G["WindowClearAnchors"],_G["WindowAddAnchor"],_G["WindowSetDimensions"],
     _G["WindowGetAnchor"],_G["LabelSetFont"],_G["CooldownDisplaySetCooldown"],_G["GetHotbarCooldown"],_G["WindowSetShowing"],
     _G["WindowGetShowing"],_G["ButtonSetPressedFlag"],_G["CreateWindow"],_G["RegisterEventHandler"],_G["DoesWindowExist"],
     _G["WindowGetDimensions"]  
---------------------------------------------------------------------------------------------------------------------
local function chat(msg) TextLogAddEntry("Chat",3,StringToWString(msg)) end
---------------------------------------------------------------------------------------------------------------------

local function actionbars_setup()
   d("!> CALL BUTTONS SETUP" )
   for ndx = 1,4 do
      if(DB.BAR[ndx].page) then ActionBarClusterManager.m_Settings:SetActionBarSetting(ndx,"selector",42)
      else ActionBarClusterManager.m_Settings:SetActionBarSetting(ndx,"selector",44) end
      if(DB.BAR[ndx].empty) then ActionBarClusterManager.m_Settings:SetActionBarSetting(ndx,"showEmptySlots",46)
      else ActionBarClusterManager.m_Settings:SetActionBarSetting(ndx,"showEmptySlots",45) end
      ActionBarClusterManager.m_Settings:SetActionBarSetting(ndx,"background",DB.BAR[ndx].back)
      ActionBarClusterManager.m_Settings:SetActionBarSetting(ndx,"columns",DB.BAR[ndx].columns) 
      ActionBarClusterManager.m_Settings:SetActionBarSetting(ndx,"caps",false)
   end
end

---------------------------------------------------------------------------------------------------------------------
local fq = {} -- flash queue
function snt_buttons.do_pulse(inum,flag,cd)
   local wname = WTEMPLATE.."#"..inum
   if(flag) then
      if(not fq[inum]) then 
         fq[inum] = true
         local PRESET = snt_buttons.buttons_set[DB.PRESET]
         CreateWindowFromTemplate(wname,WTEMPLATE,"Root") 
         WindowSetDimensions(wname,DB.FLASH_SIZE,DB.FLASH_SIZE)
         WindowAddAnchor(wname,unpack(DB.FLASHER))
         local tex,x,y = GetIconData (inum)         
         DynamicImageSetTexture(wname.."icon",tex,0,0)
         DynamicImageSetTexture(wname.."border","buttons",0,PRESET[1])
         DynamicImageSetTextureDimensions(wname.."icon",64,64)
         DynamicImageSetTextureDimensions(wname.."border",64,64)
         if(DB.CDP_ALPHA) then WindowSetAlpha(wname,0) end
      else                  
        if(DB.CDP_ALPHA) then WindowSetAlpha(wname,1-cd) end
        if(DB.CDP_ZOOM)  then WindowSetScale(wname,(1-cd)*1.5) end
      end
   else
      fq[inum] = nil
      if(DoesWindowExist(wname)) then DestroyWindow(wname) end
   end
end   

---------------------------------------------------------------------------------------------------------------------

local frames  = 
   {
   "ActionIcon","ActionText","ActionCooldown","ActionCooldownTimer",
   "OverlayFlash","OverlayActive","OverlayGlow"
   }

function snt_buttons.texture_buttons()
   local PRESET = snt_buttons.buttons_set[DB.PRESET]
   d("!> CALL TEXTURE FUNCTION")
   for _,bar in pairs(ActionBars.m_Bars) do
      for _,btn in ipairs(bar.m_Buttons) do
         ButtonSetTexture(btn.m_Name.."Action", Button.ButtonState.NORMAL, "buttons",0,PRESET[1])
         ButtonSetTexture(btn.m_Name.."Action", Button.ButtonState.HIGHLIGHTED, "buttons",64,PRESET[1])
         ButtonSetTexture(btn.m_Name.."Action", Button.ButtonState.PRESSED, "buttons",128,PRESET[1])
         ButtonSetTexture(btn.m_Name.."Action", Button.ButtonState.PRESSED_HIGHLIGHTED,"buttons",180,PRESET[1])
         for ndx = 1,#frames do
            WindowClearAnchors(btn.m_Name..frames[ndx])
            WindowSetDimensions(btn.m_Name..frames[ndx],PRESET[2],PRESET[2])
            WindowAddAnchor(btn.m_Name..frames[ndx],"topleft",btn.m_Name.."Action","topleft",PRESET[3],PRESET[3])
         end
      end
   end
end

function snt_buttons.save_position(id)
   DB.TOGGLER[3],DB.TOGGLER[1],DB.TOGGLER[2],DB.TOGGLER[4],DB.TOGGLER[5] = WindowGetAnchor("ActionBarLockToggler",1) 
   DB.FLASHER[3],DB.FLASHER[1],DB.FLASHER[2],DB.FLASHER[4],DB.FLASHER[5] = WindowGetAnchor(WANCH,1) 
end

---------------------------------------------------------------------------------------------------------------------
local function add_hooks() 
   d("!> ADD HOOKS")
   ActionBar.ShowCaps   = function(...) end
   ActionBar.CreateCaps = function(...) end
   ActionButtonCreateOld = ActionButton.Create
   ActionButton.Create = function(...)
      local self = ActionButtonCreateOld(...)
      if (not self) then return nil end
      LabelSetFont(self.m_Windows[3].m_Name,DB.TIMER_FONT,22)
      LabelSetFont(self.m_Windows[1].m_Name,DB.LABEL_FONT,22)
      return self
   end

  --------------------------------------------------------------------------------------------------
    ActionButtonUpdateEnabledStateOld = ActionButton.UpdateEnabledState
    ActionButton.UpdateEnabledState = function(self, ...)
      ActionButtonUpdateEnabledStateOld(self, ...)
      if(DB.CD_LOS) then
         local icon = self.m_Windows[0]
         if (self.m_IsEnabled) and (self.m_IsTargetValid) then icon:SetTintColor(255,255,255)
         elseif (not self.m_IsEnabled) then icon:SetTintColor(255,20,0)
         elseif (not self.m_IsTargetValid) then icon:SetTintColor(255,20,0)
         elseif (not self.m_IsEnabled) and (iconType == 42) then icon:SetTintColor(150,150,150)
         else icon:SetTintColor(255, 255, 255)
         end 
      end
    end
   --------------------------------------------------------------------------------------------------
   ActionButtonUpdateCooldownAnimationOld = ActionButton.UpdateCooldownAnimation

if(not DB.CD_CLASSIC) then  
   ActionButton.UpdateCooldownAnimation = function(self,elapsed,cd_update)
      local cd_frame    = self.m_Windows[2]
      local timer       = self.m_Windows[3]
      local old_cd      = self.m_Cooldown
      self.m_Windows[2]:SetAlpha(DB.CD_ALPHA)
      self.m_Cooldown, self.m_MaxCooldown = GetHotbarCooldown(self:GetSlot())
      CooldownDisplaySetCooldown(cd_frame:GetName(),self.m_Cooldown,self.m_MaxCooldown)
      timer:Show(self.m_MaxCooldown > ActionButton.GLOBAL_COOLDOWN)
      self.m_Cooldown = self.m_Cooldown - elapsed
      if(self.m_Cooldown > 0) then 
         if(self.m_MaxCooldown > ActionButton.GLOBAL_COOLDOWN) then 
            cd_frame:Show(true)
            LabelSetFont(timer.m_Name,DB.TIMER_FONT,22)
            if(self.m_Cooldown < old_cd) then
               if (self.m_Cooldown > 60) then 
                  timer:SetTextColor(0,100,255) 
                  timer:SetText(wstring.format(L"%d",self.m_Cooldown/60))
               elseif (self.m_Cooldown > 4) then 
                  timer:SetTextColor(100,255,0) 
                  timer:SetText(wstring.format(L"%d",self.m_Cooldown))
               else 
                  LabelSetFont(timer.m_Name,DB.TIMER_FONT_BIG,22)
                  timer:SetTextColor(255,0,0)
                  timer:SetText(wstring.format(L"%d",self.m_Cooldown))
                  if(DB.CDP_ENABLE) then
                     if (self.m_Cooldown < 1) then 
                        snt_buttons.do_pulse(self.m_IconNum,true,self.m_Cooldown) 
                     end
                  end
               end
            end
         end      
      elseif(self.m_Cooldown < 0) then
         snt_buttons.do_pulse(self.m_IconNum,false)
         cd_frame:Show(false)
         self.m_Cooldown     = 0
         self.m_MaxCooldown  = 0
      end
   end
end   
   --------------------------------------------------------------------------------------------------
   if(not DB.CD_FLAME) then
      ActionButton.UpdateBurning = function(...) end
   end

   if(DB.HIDE_TT) then
      ActionButton.OnMouseOver = function(...) end
   end

end
----------------------------------------------------------------------------------------------------------------------
-- GUI setup crap
----------------------------------------------------------------------------------------------------------------------

local function update_gui(need_reload)
   d("!> UPDATE GUI")
   for ndx = 1,16 do ButtonSetPressedFlag(WSETUP..ndx.."_chk",(DB.PRESET == ndx)) end
   for ndx = 1,4 do
      LabelSetText(WSETUP.."_b"..ndx.."_lab",towstring(DB.BAR[ndx].columns)) 
      ButtonSetPressedFlag(WSETUP.."_b"..ndx.."2",DB.BAR[ndx].back) 
      ButtonSetPressedFlag(WSETUP.."_b"..ndx.."3",DB.BAR[ndx].empty) 
      ButtonSetPressedFlag(WSETUP.."_b"..ndx.."4",DB.BAR[ndx].page)
   end  
   ButtonSetPressedFlag(WSETUP.."_cd1",DB.CD_FLAME)
   ButtonSetPressedFlag(WSETUP.."_cd2",DB.CD_CLASSIC)
   ButtonSetPressedFlag(WSETUP.."_cd3",DB.CD_LOS)
   ButtonSetPressedFlag(WSETUP.."_cd4",DB.HIDE_TT)
   ButtonSetPressedFlag(WSETUP.."_cd5",DB.CDP_ENABLE)
   ButtonSetPressedFlag(WSETUP.."_cd6",DB.CDP_ZOOM)
   ButtonSetPressedFlag(WSETUP.."_cd7",DB.CDP_ALPHA)
   SliderBarSetCurrentPosition(WSETUP.."_A1",DB.CD_ALPHA) 
   TextEditBoxSetText(WSETUP.."_T1",towstring(DB.FLASH_SIZE))
   if(need_reload) then
      ButtonSetText(WSETUP.."_reload", L"NeedReload")
      WindowSetShowing(WSETUP.."_reload",true)
   else
      snt_buttons.texture_buttons()
   end
end

function snt_buttons.toggle_setup()
   if(not DoesWindowExist(WSETUP)) then
      CreateWindow(WSETUP,false)
      ButtonSetText(WSETUP.."_close", L"Close")
   end
   WindowSetShowing(WSETUP,not WindowGetShowing(WSETUP))    
   WindowSetShowing(WSETUP.."_reload",false)
   update_gui(false)
end

local function inc(ndx) 
   DB.BAR[ndx].columns = DB.BAR[ndx].columns + 1 
   if(DB.BAR[ndx].columns > 12) then DB.BAR[ndx].columns = 1 end
   update_gui(true)
end
local function dec(ndx) 
   DB.BAR[ndx].columns = DB.BAR[ndx].columns - 1 
   if(DB.BAR[ndx].columns < 1) then DB.BAR[ndx].columns = 12 end
   update_gui(true)
end

-- bad but very simple technic. its crap but its working crap :) -----------------------------------------

function snt_buttons.set01() DB.PRESET = 1  update_gui(false) end
function snt_buttons.set02() DB.PRESET = 2  update_gui(false) end
function snt_buttons.set03() DB.PRESET = 3  update_gui(false) end
function snt_buttons.set04() DB.PRESET = 4  update_gui(false) end
function snt_buttons.set05() DB.PRESET = 5  update_gui(false) end
function snt_buttons.set06() DB.PRESET = 6  update_gui(false) end
function snt_buttons.set07() DB.PRESET = 7  update_gui(false) end
function snt_buttons.set08() DB.PRESET = 8  update_gui(false) end
function snt_buttons.set09() DB.PRESET = 9  update_gui(false) end
function snt_buttons.set10() DB.PRESET = 10 update_gui(false) end
function snt_buttons.set11() DB.PRESET = 11 update_gui(false) end
function snt_buttons.set12() DB.PRESET = 12 update_gui(false) end
function snt_buttons.set13() DB.PRESET = 13 update_gui(false) end
function snt_buttons.set14() DB.PRESET = 14 update_gui(false) end
function snt_buttons.set15() DB.PRESET = 15 update_gui(false) end
function snt_buttons.set16() DB.PRESET = 16 update_gui(false) end
function snt_buttons.b1l() dec(1) end
function snt_buttons.b1r() inc(1) end
function snt_buttons.b2l() dec(2) end
function snt_buttons.b2r() inc(2) end
function snt_buttons.b3l() dec(3) end
function snt_buttons.b3r() inc(3) end
function snt_buttons.b4l() dec(4) end
function snt_buttons.b4r() inc(4) end
function snt_buttons.b12() DB.BAR[1].back   = not DB.BAR[1].back   update_gui(true) end
function snt_buttons.b13() DB.BAR[1].empty  = not DB.BAR[1].empty  update_gui(true) end
function snt_buttons.b14() DB.BAR[1].page   = not DB.BAR[1].page   update_gui(true) end
function snt_buttons.b22() DB.BAR[2].back   = not DB.BAR[2].back   update_gui(true) end
function snt_buttons.b23() DB.BAR[2].empty  = not DB.BAR[2].empty  update_gui(true) end
function snt_buttons.b24() DB.BAR[2].page   = not DB.BAR[2].page   update_gui(true) end
function snt_buttons.b32() DB.BAR[3].back   = not DB.BAR[3].back   update_gui(true) end
function snt_buttons.b33() DB.BAR[3].empty  = not DB.BAR[3].empty  update_gui(true) end
function snt_buttons.b34() DB.BAR[3].page   = not DB.BAR[3].page   update_gui(true) end
function snt_buttons.b42() DB.BAR[4].back   = not DB.BAR[4].back   update_gui(true) end
function snt_buttons.b43() DB.BAR[4].empty  = not DB.BAR[4].empty  update_gui(true) end
function snt_buttons.b44() DB.BAR[4].page   = not DB.BAR[4].page   update_gui(true) end
function snt_buttons.cd1() DB.CD_FLAME      = not DB.CD_FLAME      update_gui(true) end
function snt_buttons.cd2() DB.CD_CLASSIC    = not DB.CD_CLASSIC    update_gui(true) end
function snt_buttons.cd3() DB.CD_LOS        = not DB.CD_LOS        update_gui(true) end
function snt_buttons.cd4() DB.HIDE_TT       = not DB.HIDE_TT       update_gui(true) end
function snt_buttons.cd5() DB.CDP_ENABLE    = not DB.CDP_ENABLE    update_gui(false) end
function snt_buttons.cd6() DB.CDP_ZOOM      = not DB.CDP_ZOOM      update_gui(false) end
function snt_buttons.cd7() DB.CDP_ALPHA     = not DB.CDP_ALPHA     update_gui(false) end

function snt_buttons.slider_change() DB.CD_ALPHA  = SliderBarGetCurrentPosition(WSETUP.."_A1") end
function snt_buttons.text_input() DB.FLASH_SIZE  = tonumber(TextEditBoxGetText(WSETUP.."_T1")) update_gui(true) end

----------------------------------------------------------------------------------------------------------------------
-- ON LOAD / ON INITALIZE / ON SHOOTDOWN
----------------------------------------------------------------------------------------------------------------------
function snt_buttons.on_load()
   d("!> LOADING")
   CreateWindow(WANCH,true)
   WindowAddAnchor(WANCH,unpack(DB.FLASHER))
   WindowSetDimensions(WANCH,DB.FLASH_SIZE,DB.FLASH_SIZE)
   LayoutEditor.RegisterWindow("ActionBarLockToggler",L"ActionBarToggler",L"ActionBarToggler",false,false,true,nil)
   LayoutEditor.RegisterWindow(WANCH,L"CD_Pulse",L"CD Pulse placeholder",true,true,true,nil)
   table.insert(LayoutEditor.EventHandlers,snt_buttons.save_position)
   LibSlash.RegisterSlashCmd("sntbtn",snt_buttons.toggle_setup)
   WindowClearAnchors("ActionBarLockToggler")
   WindowAddAnchor("ActionBarLockToggler",unpack(DB.TOGGLER))
   snt_buttons.texture_buttons()
end

function snt_buttons.entry_point()
   d("!> ENTRY POINT")
   chat("snt buttons v "..VERSION.." type /sntbtn for settings")
   if((not SNTBTN_DB) or (SNTBTN_DB.VERSION ~= VERSION)) then SNTBTN_DB = default end
   DB = SNTBTN_DB
   add_hooks()
   actionbars_setup()
   RegisterEventHandler(SystemData.Events.LOADING_END, "snt_buttons.on_load")
   RegisterEventHandler(SystemData.Events.RELOAD_INTERFACE,"snt_buttons.on_load")
end       

----------------------------------------------------------------------------------------------------------------------




