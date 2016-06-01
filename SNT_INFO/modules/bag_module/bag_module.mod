<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
   <UiMod name="SNT Info [BAG]" version="1.0" date="22/02/2009">
      <Author name="Don Kaban" email="k_shabordin@gmail.com" />
      <Description text="BAG module for SNT Info" />
      <Dependencies>
         <Dependency name="SNT_INFO" />
         <Dependency name="EA_BackpackWindow" />

      </Dependencies>
      <Files>
         <File name="bag_module.lua" />
      </Files>      
      <OnInitialize>
         <CallFunction name="snt_info.bag_module.entry_point" />
      </OnInitialize>
   </UiMod>
</ModuleFile>
