-- (c) SNT PANEL by Don Kaban

local VERSION = "2.0"

snt_panel         = {}   -- addon namespace

local default     = {VERSION = VERSION,}

---------------------------------------------------------------------------------------------------------------------
local WSETUP      = "SNT_PANEL_SETUP_WINDOW"
local PNAME       = "SNT_PNL#"
local CUR_WIN     = 1
local DB
local SCR_X,SCR_Y         = GetScreenResolution()
 
---------------------------------------------------------------------------------------------------------------------
local CreateWindowFromTemplate,WindowSetDimensions,WindowClearAnchors,WindowAddAnchor,
      WindowSetAlpha,WindowSetTintColor,WindowSetLayer,DestroyWindow =
     _G["CreateWindowFromTemplate"],_G["WindowSetDimensions"],_G["WindowClearAnchors"],_G["WindowAddAnchor"],
     _G["WindowSetAlpha"],_G["WindowSetTintColor"],_G["WindowSetLayer"],_G["DestroyWindow"]
---------------------------------------------------------------------------------------------------------------------
local function chat(msg) TextLogAddEntry("Chat",3,StringToWString(msg)) end
---------------------------------------------------------------------------------------------------------------------

function snt_panel.new()
   local pnl     = {}
   pnl.col1, pnl.col2                     = {0,0,0},{255,255,255}
   pnl.alpha1,pnl.alpha2,pnl.alpha3       = 0.7,0.7,0.7
   pnl.sizex,pnl.sizey,pnl.scrx,pnl.scry  = 300,300,SCR_X/2,SCR_Y/2
   pnl.tex,pnl.layer,pnl.tilex,pnl.tiley  = "",0,64,64
   table.insert(DB,pnl)
   snt_panel.create(#DB)
   snt_panel.set(#DB)
   snt_panel.update_gui()
end

function snt_panel.set(val)
   WindowSetDimensions(PNAME..val,DB[val].sizex,DB[val].sizey)
   WindowClearAnchors(PNAME..val)
   WindowAddAnchor(PNAME..val,"topleft","Root","topleft",DB[val].scrx,DB[val].scry)
   WindowSetAlpha(PNAME..val.."_layer1",DB[val].alpha1)
   WindowSetAlpha(PNAME..val.."_layer2",DB[val].alpha2)
   WindowSetAlpha(PNAME..val.."_layer3",DB[val].alpha3)
   WindowSetTintColor(PNAME..val.."_layer1",unpack(DB[val].col1))
   WindowSetTintColor(PNAME..val.."_layer2",unpack(DB[val].col2))
   WindowSetLayer(PNAME..val,DB[val].layer)
   DynamicImageSetTexture(PNAME..val.."_layer3",DB[val].tex,0,0) 
   DynamicImageSetTextureDimensions(PNAME..val.."_layer3",DB[val].tilex,DB[val].tiley)
end

function snt_panel.create(val)
   CreateWindowFromTemplate(PNAME..val,"snt_panel_template","Root")
   LayoutEditor.RegisterWindow(PNAME..val,StringToWString(PNAME..val),StringToWString(PNAME..val),true,true,true,nil)
   WindowSetShowing(PNAME..val,true)
end

function snt_panel.del()
   for ndx = 1,#DB do LayoutEditor.UnregisterWindow(PNAME..ndx) DestroyWindow(PNAME..ndx) end
   table.remove(DB,CUR_WIN)
   if(CUR_WIN > #DB) then CUR_WIN = #DB end
   if(CUR_WIN == 0) then CUR_WIN = 1 end
   for ndx = 1,#DB do snt_panel.create(ndx) snt_panel.set(ndx) end
   snt_panel.update_gui()
end

function snt_panel.editor_save(id)
   if(id ~= 2) then return end
   for ndx = 1,#DB do
      DB[ndx].sizex, DB[ndx].sizey  = WindowGetDimensions(PNAME..ndx)
      DB[ndx].scrx ,DB[ndx].scry    = WindowGetScreenPosition(PNAME..ndx)
      DB[ndx].scrx = DB[ndx].scrx/InterfaceCore.GetScale()
      DB[ndx].scry = DB[ndx].scry/InterfaceCore.GetScale()
   end
end

function snt_panel.text_input()
   local x = tonumber(TextEditBoxGetText(WSETUP.."_T2"))
   local y = tonumber(TextEditBoxGetText(WSETUP.."_T3"))
   if(x < 1) then x = 1 end
   if(y < 1) then y = 1 end
   if(x > SCR_X) then x = SCR_X end
   if(y > SCR_Y) then y = SCR_Y end
   DB[CUR_WIN].tex      = tostring(TextEditBoxGetText(WSETUP.."_T1"))
   DB[CUR_WIN].tilex    = tonumber(TextEditBoxGetText(WSETUP.."_T4"))
   DB[CUR_WIN].tiley    = tonumber(TextEditBoxGetText(WSETUP.."_T5"))
   DB[CUR_WIN].sizex = x
   DB[CUR_WIN].sizey = y
   snt_panel.set(CUR_WIN)
   snt_panel.update_gui()
end

---------------------------------------------------------------------------------------------------------------------
-- GUI crap
---------------------------------------------------------------------------------------------------------------------
function snt_panel.slider_change()
      DB[CUR_WIN].col1[1] = math.floor(SliderBarGetCurrentPosition(WSETUP.."_R1")*255)
      DB[CUR_WIN].col1[2] = math.floor(SliderBarGetCurrentPosition(WSETUP.."_G1")*255)
      DB[CUR_WIN].col1[3] = math.floor(SliderBarGetCurrentPosition(WSETUP.."_B1")*255)
      DB[CUR_WIN].col2[1] = math.floor(SliderBarGetCurrentPosition(WSETUP.."_R2")*255)
      DB[CUR_WIN].col2[2] = math.floor(SliderBarGetCurrentPosition(WSETUP.."_G2")*255)
      DB[CUR_WIN].col2[3] = math.floor(SliderBarGetCurrentPosition(WSETUP.."_B2")*255)
      DB[CUR_WIN].alpha1  = SliderBarGetCurrentPosition(WSETUP.."_A1")
      DB[CUR_WIN].alpha2  = SliderBarGetCurrentPosition(WSETUP.."_A2")
      DB[CUR_WIN].alpha3  = SliderBarGetCurrentPosition(WSETUP.."_A3")
      for ndx = 1,#DB do snt_panel.set(ndx) end
end

local gui_element = {"_delete","_R1","_G1","_B1","_R2","_G2","_B2","_A1","_A2","_A3","_T1","_T2","_T3","_T4",}
local function hide() for ndx = 1,#gui_element do WindowSetShowing(WSETUP..gui_element[ndx],false) end end
local function show() for ndx = 1,#gui_element do WindowSetShowing(WSETUP..gui_element[ndx],true)  end end

function snt_panel.update_gui()
   if(#DB == 0) then hide() LabelSetText(WSETUP.."_wname",L"NO PANELS") return end
   show()    
   LabelSetText(WSETUP.."_wname",L"PANEL # "..CUR_WIN..L" / "..#DB) 
   WindowSetShowing(WSETUP.."_delete",true) 
   SliderBarSetCurrentPosition(WSETUP.."_R1",DB[CUR_WIN].col1[1]/255) 
   SliderBarSetCurrentPosition(WSETUP.."_G1",DB[CUR_WIN].col1[2]/255) 
   SliderBarSetCurrentPosition(WSETUP.."_B1",DB[CUR_WIN].col1[3]/255) 
   SliderBarSetCurrentPosition(WSETUP.."_R2",DB[CUR_WIN].col2[1]/255) 
   SliderBarSetCurrentPosition(WSETUP.."_G2",DB[CUR_WIN].col2[2]/255) 
   SliderBarSetCurrentPosition(WSETUP.."_B2",DB[CUR_WIN].col2[3]/255) 
   SliderBarSetCurrentPosition(WSETUP.."_A1",DB[CUR_WIN].alpha1) 
   SliderBarSetCurrentPosition(WSETUP.."_A2",DB[CUR_WIN].alpha2) 
   SliderBarSetCurrentPosition(WSETUP.."_A3",DB[CUR_WIN].alpha3)
   TextEditBoxSetText(WSETUP.."_T1",towstring(DB[CUR_WIN].tex))
   TextEditBoxSetText(WSETUP.."_T2",towstring(DB[CUR_WIN].sizex))
   TextEditBoxSetText(WSETUP.."_T3",towstring(DB[CUR_WIN].sizey))
   TextEditBoxSetText(WSETUP.."_T4",towstring(DB[CUR_WIN].tilex))
   TextEditBoxSetText(WSETUP.."_T5",towstring(DB[CUR_WIN].tiley))

 end

function snt_panel.toggle_setup() WindowSetShowing(WSETUP,not WindowGetShowing(WSETUP)) snt_panel.update_gui() end

function snt_panel.inc() 
   if((CUR_WIN == #DB) or (#DB == 0)) then return end
   CUR_WIN=CUR_WIN+1 snt_panel.update_gui()
end

function snt_panel.dec() 
   if((CUR_WIN ==1) or (#DB ==0)) then return end
   CUR_WIN=CUR_WIN-1 snt_panel.update_gui() 
end

---------------------------------------------------------------------------------------------------------------------
function snt_panel.on_load()
   d("!> LOAD OR RELOAD")
   table.insert(LayoutEditor.EventHandlers,snt_panel.editor_save)
   CreateWindow(WSETUP,false)
   for ndx = 1,#DB do snt_panel.create(ndx) snt_panel.set(ndx) end
end




function snt_panel.entry_point()
   d("!> ENTRY POINT") 
   if((not SNTPNL_DB) or (SNTPNL_DB.VERSION ~= VERSION)) then SNTPNL_DB = default  SNTPNL_DB.ITABLE = {} end
   DB = SNTPNL_DB.ITABLE 
   chat("snt panel v "..SNTPNL_DB.VERSION.." type /sntpnl for settings")
   RegisterEventHandler(SystemData.Events.LOADING_END, "snt_panel.on_load")
   RegisterEventHandler(SystemData.Events.RELOAD_INTERFACE,"snt_panel.on_load")
   LibSlash.RegisterSlashCmd("sntpnl",snt_panel.toggle_setup)
end       




