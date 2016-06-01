<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
   <UiMod name="SNT Info [SOCIAL]" version="1.0" date="22/02/2009">
      <Author name="Don Kaban" email="k_shabordin@gmail.com" />
      <Description text="Guild and Friends module for SNT Info" />
      <Dependencies>
         <Dependency name="SNT_INFO" />
      </Dependencies>
      <Files>
         <File name="social_module.lua" />
      </Files>      
      <OnInitialize>
         <CallFunction name="snt_info.social_module.entry_point" />
      </OnInitialize>
   </UiMod>
</ModuleFile>
