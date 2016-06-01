<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
   <UiMod name="SNT_PANEL" version="2.0" date="16/02/2009" >
      <Author name="DonKaban" email="k.shabordin@gmail.com" />
      <Description text="SNT custom panelizer" />
         <Dependencies>
            <Dependency name="LibSlash" />
         </Dependencies>
      <Files>
            <File name="snt_panel.lua" />
            <File name="snt_panel.xml" />
            <File name="user_textures/user_textures.xml" />

      </Files>
      <SavedVariables>
         <SavedVariable name="SNTPNL_DB"/>
      </SavedVariables>
      <OnInitialize>
            <CallFunction name="snt_panel.entry_point" />
      </OnInitialize>
      <OnUpdate/>
      <OnShutdown/>
   </UiMod>
</ModuleFile>
