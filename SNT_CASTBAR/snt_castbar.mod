<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
   <UiMod name="SNT_CASTBAR" version="1.0" date="14/02/2009" >
      <Author name="DonKaban" email="k.shabordin@gmail.com" />
      <Description text="SNT castbar customizer" />
         <Dependencies>
            <Dependency name="EA_CastTimerWindow" />
            <Dependency name="LibSlash" />
         </Dependencies>
      <Files>
            <File name="snt_castbar.lua" />
            <File name="snt_castbar.xml" />
      </Files>
      <SavedVariables>
         <SavedVariable name="SNTCAST_DB"/>
      </SavedVariables>
      <OnInitialize>
            <CallFunction name="snt_castbar.entry_point" />
      </OnInitialize>
      <OnUpdate/>
      <OnShutdown/>
   </UiMod>
</ModuleFile>
