<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
   <UiMod name="SNT_BUTTONS" version="1.6" date="22/02/2009" >
      <Author name="DonKaban" email="k.shabordin@gmail.com" />
      <Description text="SNT actionbar buttons customizer" />
         <Dependencies>
            <Dependency name="EA_ActionBars" />
            <Dependency name="EASystem_ActionBarClusterManager" />
            <Dependency name="LibSlash" />
         </Dependencies>
      <Files>
            <File name="snt_buttons.lua" />
            <File name="snt_buttons.xml" />
      </Files>
      <SavedVariables>
         <SavedVariable name="SNTBTN_DB"/>
      </SavedVariables>
      <OnInitialize> <CallFunction name="snt_buttons.entry_point"/>  </OnInitialize>
   </UiMod>
</ModuleFile>
