---------------------------------------------------------------------------------------------------------------------
-- BAG module for SNT Info by DonKaban 
---------------------------------------------------------------------------------------------------------------------

snt_info.bag_module = {}

local LOC = "RU"

local items    = 0
local total    = 0 
local q_items  = 0 


local function GS(id) return GetStringFromTable("BAG_LOCALIZE",id) end



  
---------------------------------------------------------------------------------------------------------------------

local function get_num_items(bag)
   local mode
   local item_data
   local count = 0
   if (bag == EA_Window_Backpack.POCKET_QUEST_ITEMS_INDEX)  then mode = EA_Window_Backpack.VIEW_MODE_QUEST 
   else mode = EA_Window_Backpack.VIEW_MODE_INVENTORY end
   if(EA_Window_Backpack.pockets[bag]) then
         for slot = EA_Window_Backpack.pockets[bag].firstSlotID, EA_Window_Backpack.pockets[bag].lastSlotID do
         item_data = EA_Window_Backpack.GetItem(slot,mode)
         if(EA_Window_Backpack.ValidItem(item_data)) then count = count + 1 end
      end
      return count
   end
   return nil
end
---------------------------------------------------------------------------------------------------------------------

function  snt_info.bag_module.update()
   items,total = 0,0
   q_items  = get_num_items(1) 
   for ndx = 2,7  do 
      local i = get_num_items(ndx) 
      if(i) then
         items = items + i
         total = total + 16
      end   
   end
   i_bag:set_gradient(items,total,0)
   i_bag:set_text(string.format("%02d/%02d",items,total,q_items))
end

---------------------------------------------------------------------------------------------------------------------

function snt_info.bag_module.click() EA_Window_Backpack.ToggleShowing()  end


local TT = Tooltips.SetTooltipText
local TC = Tooltips.SetTooltipColor

function snt_info.bag_module.tooltip()
   Tooltips.CreateTextOnlyTooltip(i_bag.wname.."_icon",nil)
   Tooltips.AnchorTooltip(Tooltips.ANCHOR_WINDOW_BOTTOM)
   TC(1,1,200,255,200)  TT(1,1,L"Bags Info")
   TC(2,1,255,255,000)  TT(2,1,L"---------------------------------------")   
   TC(3,1,050,200,050)  TT(3,1,L"Total")        TC(3,2,050,200,050) TT(3,2,towstring(total))
   TC(4,1,050,200,050)  TT(4,1,L"Quest Items")  TC(4,2,050,200,050) TT(4,2,towstring(q_items))
   TC(5,1,050,200,050)  TT(5,1,L"Items")        TC(5,2,050,200,050) TT(5,2,towstring(items))
   TC(6,1,050,200,050)  TT(6,1,L"Empty")        TC(6,2,050,200,050) TT(6,2,towstring(total-items))
   Tooltips.Finalize()
end




---------------------------------------------------------------------------------------------------------------------
-- ENTRY POINT 
---------------------------------------------------------------------------------------------------------------------

function snt_info.bag_module.entry_point()
   d("!> ENTRY")
   RegisterEventHandler(SystemData.Events.PLAYER_INVENTORY_SLOT_UPDATED, "snt_info.bag_module.update")
   RegisterEventHandler(SystemData.Events.PLAYER_QUEST_ITEM_SLOT_UPDATED,"snt_info.bag_module.update")
   i_bag = snt_info.informer:new("i_bag",nil,5,nil,7,"snt_info.bag_module.tooltip","snt_info.bag_module.click",nil)
   snt_info.bag_module.update()
end