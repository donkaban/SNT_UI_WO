<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
   <UiMod name="SNT_INFO" version="1.0" date="22/02/2009" >
      <Author name="DonKaban" email="k.shabordin@gmail.com" />
      <Description text="SNT Informers (SNT BAR reborn project)" />
         <Dependencies>
            <Dependency name="LibSlash" />
            <Dependency name="EASystem_LayoutEditor" />
         </Dependencies>
      <Files>
            <File name="snt_info.lua" />
            <File name="snt_info.xml" />
      </Files>
      <SavedVariables>
         <SavedVariable name="SNTINFO_DB"/>
      </SavedVariables>
      <OnInitialize>
            <CallFunction name="snt_info.entry_point" />
      </OnInitialize>
      <OnUpdate/>
      <OnShutdown/>
   </UiMod>
</ModuleFile>
