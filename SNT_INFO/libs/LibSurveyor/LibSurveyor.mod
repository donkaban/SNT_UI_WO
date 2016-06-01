<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<UiMod name="LibSurveyor" version="1.1" date="19/11/2008" >
		<Author name="Nevir" email="ian@nevir.net" />
		<Description text="Mapping library and data store. Never get lost again!" />
		
		<Files>
			<File name="LibStub.lua"/>
			<File name="LibSurveyor.lua"/>
			
			<File name="Classes\Display.lua"/>
			<File name="Classes\Pin.lua"/>
			<File name="Classes\PinType.lua"/>
			<File name="Classes\Point.lua"/>
			
			<File name="Database.lua"/>
			<File name="PlayerLocation.lua"/>
			
			<File name="Data\ZoneOffsets.lua"/>
			
			<File name="Windows.xml"/>
		</Files>
		
		<SavedVariables>
			<SavedVariable name="LibSurveyorDB"/>
		</SavedVariables>
		
		<OnInitialize>
			<CallFunction name="LibSurveyor_1.ValidateDB"/>
			<CallFunction name="LibSurveyor_1.OnInitialize"/>
		</OnInitialize>
	</UiMod>
</ModuleFile>