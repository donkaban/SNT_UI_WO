<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
   <UiMod name="SNT Info [STAT]" version="1.0" date="22/02/2009">
      <Author name="Don Kaban" email="k_shabordin@gmail.com" />
      <Description text="XP and Renown module for SNT Info" />
      <Dependencies>
         <Dependency name="SNT_INFO" />
      </Dependencies>
      <Files>
         <File name="stat_module.lua" />
      </Files>      
      <OnInitialize>
         <CallFunction name="snt_info.stat_module.entry_point" />
      </OnInitialize>
   </UiMod>
</ModuleFile>
