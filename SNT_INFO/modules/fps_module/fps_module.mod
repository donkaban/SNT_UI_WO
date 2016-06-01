<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
   <UiMod name="SNT Info [FPS]" version="1.0" date="22/02/2009">
      <Author name="Don Kaban" email="k_shabordin@gmail.com" />
      <Description text="FPS module for SNT Info" />
      <Dependencies>
         <Dependency name="SNT_INFO" />
      </Dependencies>
      <Files>
         <File name="fps_module.lua" />
      </Files>      
      <OnInitialize>
         <CallFunction name="snt_info.fps_module.entry_point" />
      </OnInitialize>
      <OnUpdate>
         <CallFunction name="snt_info.fps_module.update" />
      </OnUpdate>
   </UiMod>
</ModuleFile>
