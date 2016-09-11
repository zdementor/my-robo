
require "options"
require "shadergen"
require "console"
require "items"

local gui_state=0

-----------------------------------------
-- Setup CEGUI System
-----------------------------------------

-- creating root window

local RootWnd = CEGUIWinMgr:createWindow("DefaultGUISheet", "RootWnd")
CEGUISystem:setGUISheet(RootWnd)

-- load schemes

CEGUISchemeMgr:create("TaharezLook.scheme")

-- set up defaults 

CEGUISystem:setDefaultMouseCursor("TaharezLook", "MouseArrow")
CEGUISystem:setDefaultFont("Tahoma-12")

MyCursor:setVisible(false)
CEGUICursor:show()

-- tooltip 

CEGUISystem:setDefaultTooltip("TaharezLook/Tooltip")

-- loading custom image sets

CEGUIImgsetMgr:create("RoboIngameGUI.imageset")
CEGUIImgsetMgr:create("RoboItems0.imageset")
CEGUIImgsetMgr:create("MyEngineZDimitorLogo.imageset", "CommonImagesets")

-----------------------------------------
-- Creating CEGUI controls
-----------------------------------------

-- loading layouts, creating controls

local RoboGUI =
{
	MainMenu     = CEGUIWinMgr:loadWindowLayout("myengine_mainmenu.layout"),
	AboutDlg     = CEGUIWinMgr:loadWindowLayout("myengine_about.layout"),
	IngameGUI    = CEGUIWinMgr:loadWindowLayout("myrobo_main.layout"),
	InventoryGUI = CEGUIWinMgr:loadWindowLayout("myrobo_inventory.layout"),
	CreditsDlg   = CEGUIWinMgr:loadWindowLayout("myengine_credits.layout"),
	OptionsDlg   = CEGUIWinMgr:loadWindowLayout("myengine_options.layout"),
	WaitDlg      = CEGUIWinMgr:loadWindowLayout("myengine_waitdialog.layout"),
}

-- setting up windows parent structure

for key, value in pairs(RoboGUI) do
	value:setVisible(false)
	RootWnd:addChildWindow(value)
end
RoboGUI.MainMenu:setVisible(true)

-- getting reference pointers

local InventoryFrame =CEGUIWinMgr:getWindow("InventoryFrame")
local ListBoxStartLevel = 
	tolua.cast(CEGUIWinMgr:getWindow("ListBoxStartLevel"),"CEGUI::Listbox")

local SceneFileNames = {
	{name = "robo_hangar_part1", filename = "scenes/robo_hangar_part1.scene"},
	{name = "robo_hangar_part2", filename = "scenes/robo_hangar_part2.scene"},
	{name = "robo_hangar_part3", filename = "scenes/robo_hangar_part3.scene"}}
local item_col = CEGUI.colour:new_local(0.6, 0.6, 0.6, 1)
for s=1, table.getn(SceneFileNames)-1 do
	local newItem = CEGUI.createListboxTextItem(
		SceneFileNames[s].name, 0, nil, false, true)   
	newItem:setSelectionBrushImage("TaharezLook", "MultiListSelectionBrush")
	newItem:setTextColours(item_col)
	ListBoxStartLevel:addItem(newItem)
	if s==0 then
		ListBoxStartLevel:setItemSelectState(newItem, true)
	end
end

local AboutLogo = CEGUIWinMgr:getWindow("MyEngineLogo")
local AboutInfo = CEGUIWinMgr:getWindow("AboutInfo")

local BackGroundImg   = CEGUIWinMgr:getWindow("BackGroundImg")

local LifeImg   = CEGUIWinMgr:getWindow("LifeImg")
local LifeBar   =
	tolua.cast(CEGUIWinMgr:getWindow("LifeBar"),"CEGUI::ProgressBar")
local LifeValue = CEGUIWinMgr:getWindow("LifeValue")

local AmmoImg   = CEGUIWinMgr:getWindow("AmmoImg")
local AmmoBar   =
	tolua.cast(CEGUIWinMgr:getWindow("AmmoBar"),"CEGUI::ProgressBar")
local AmmoValue = CEGUIWinMgr:getWindow("AmmoValue")

local ImgWeapon={
	[0]=CEGUIWinMgr:getWindow("ImgWeapon0"),
	[1]=CEGUIWinMgr:getWindow("ImgWeapon1"),
	[2]=CEGUIWinMgr:getWindow("ImgWeapon2")}

local CaptWeapon={
	[0]=CEGUIWinMgr:getWindow("CaptWeapon0"),
	[1]=CEGUIWinMgr:getWindow("CaptWeapon1"),
	[2]=CEGUIWinMgr:getWindow("CaptWeapon2")}

local ProgressAmmoWeapon = {
	[0] = tolua.cast(CEGUIWinMgr:getWindow("ProgressAmmoWeapon0"),"CEGUI::ProgressBar"),
	[1] = tolua.cast(CEGUIWinMgr:getWindow("ProgressAmmoWeapon1"),"CEGUI::ProgressBar"),
	[2] = tolua.cast(CEGUIWinMgr:getWindow("ProgressAmmoWeapon2"),"CEGUI::ProgressBar")}

local KeymapList = 
    tolua.cast(CEGUIWinMgr:getWindow("ActionMapList"),"CEGUI::MultiColumnList")
local LoadGameButton   = CEGUIWinMgr:getWindow("LoadGameButton" )
local ExitButton       = CEGUIWinMgr:getWindow("ExitButton"     )
local AboutButton      = CEGUIWinMgr:getWindow("AboutButton"    )
local AboutMainFrame   = CEGUIWinMgr:getWindow("AboutMainFrame" )
local AboutOKButton    = CEGUIWinMgr:getWindow("AboutOKButton"  )
local CreditsButton    = CEGUIWinMgr:getWindow("CreditsButton"  )
local CreditsMainFrame = CEGUIWinMgr:getWindow("CreditsMainFrame")
local CreditsOKButton  = CEGUIWinMgr:getWindow("CreditsOKButton")
local OptionsButton    = CEGUIWinMgr:getWindow("OptionsButton"  )
local OptionsMainFrame = CEGUIWinMgr:getWindow("OptionsMainFrame")
local OptionsOKButton  = CEGUIWinMgr:getWindow("OptionsOKButton")
local WaitCapt         = CEGUIWinMgr:getWindow("WaitMainFrame"  )
local WaitMsg          = CEGUIWinMgr:getWindow("MessageText"    )
local BrightScroll       = tolua.cast(CEGUIWinMgr:getWindow("BrightScroll"),"CEGUI::Scrollbar")
local BrightSpinner      = tolua.cast(CEGUIWinMgr:getWindow("BrightSpinner"),"CEGUI::Spinner")
local MusicVolumeSlider  = tolua.cast(CEGUIWinMgr:getWindow("MusicVolumeSlider"),"CEGUI::Slider")
local EffectsVolumeSlider= tolua.cast(CEGUIWinMgr:getWindow("EffectsVolumeSlider"),"CEGUI::Slider")

local MusicVolCapt   = CEGUIWinMgr:getWindow("MusicVolCapt")
local EffectsVolCapt = CEGUIWinMgr:getWindow("EffectsVolCapt")

local SGStyleRadio      = tolua.cast(CEGUIWinMgr:getWindow("SGStyleRadio"),"CEGUI::RadioButton")
local ASStyleRadio      = tolua.cast(CEGUIWinMgr:getWindow("ASStyleRadio"),"CEGUI::RadioButton")
local CrimsonStyleRadio = tolua.cast(CEGUIWinMgr:getWindow("CrimsonStyleRadio"),"CEGUI::RadioButton")

local AutoZoomCheck= tolua.cast(CEGUIWinMgr:getWindow("AutoZoomCheck"),"CEGUI::Checkbox")

local SenseScroll   = 
	tolua.cast(CEGUIWinMgr:getWindow("SenseScroll"),"CEGUI::Scrollbar")
local SenseSpinner  = 
	tolua.cast(CEGUIWinMgr:getWindow("SenseSpinner"),"CEGUI::Spinner")

local InventoryItemsList=
    tolua.cast(CEGUIWinMgr:getWindow("InventoryItemsList"),"CEGUI::Listbox")
local InventoryItemName       = CEGUIWinMgr:getWindow("InventoryItemName")
local InventoryItemShortDescr = CEGUIWinMgr:getWindow("InventoryItemShortDescr")
local InventoryItemDescr      = CEGUIWinMgr:getWindow("InventoryItemDescr")
local InventoryItemImage      = CEGUIWinMgr:getWindow("InventoryItemImage")
local InventoryCloseButton    = CEGUIWinMgr:getWindow("InventoryCloseButton")

-- creating custom controls

local MappingCapt = CEGUIWinMgr:createWindow("TaharezLook/StaticText", "EditControls")
MappingCapt:setVisible(false)
KeymapList:addChildWindow(MappingCapt)

local OptionsLockerWnd = 
	CEGUIWinMgr:createWindow("DefaultWindow", "OptionsLocker")
OptionsLockerWnd:setVisible(false)
RoboGUI.OptionsDlg:addChildWindow(OptionsLockerWnd)

-- initializing GUI

LifeBar:setProgress(100)

AboutLogo:setProperty("Image", "set:MyEngineZDimitorLogo image:MyEngineZDimitorLogoImage")

AboutInfo:setText(MyDevice:getDescriptionString())

BackGroundImg:setProperty("Image", "set:RoboIngameGUI image:BackGroundImage")   

LifeImg:setProperty("Image", "set:RoboIngameGUI image:HeartImage")   
AmmoImg:setProperty("Image", "set:RoboIngameGUI image:AmmoImage")   

Helper.GUI.setMultiColumnListHeader(KeymapList, 0, {
		{Name = "Action",		Dim = CEGUI.UDim(0.5, 0)},
		{Name = "Key/Mouse",	Dim = CEGUI.UDim(0.45, 0)},})

MappingCapt:setProperty("UnifiedMaxSize", "{{1,0},{1,0}}")
MappingCapt:setProperty("HorzFormatting", "HorzCentred")

function GetActionControlString(action)     
	local kcode = MyInpDisp:getActionKey(action)
	local mcode = MyInpDisp:getActionMouse(action)
	local str = ""
	if kcode<io.E_KEY_CODE_COUNT then
		str = io.getKeyCodeName(kcode)
		if mcode<io.E_MOUSE_CODE_COUNT then
			str = string.format("%s or %s", str, io.getMouseCodeName(mcode))
		end
	elseif mcode<io.E_MOUSE_CODE_COUNT then
		str = io.getMouseCodeName(mcode)
	end  
	return str    
end

function RefreshActionsMappingList() 
	local vscrollbar = KeymapList:getVertScrollbar()
	local scrollpos  = vscrollbar:getScrollPosition()
	KeymapList:resetList()
	for i=0, game.E_GAME_ACTION_COUNT-1 do
		Helper.GUI.addMultiColumnListItem(KeymapList, OPTIONS.GameGUI.SchemeName, {
			[1] = {Name = game.GetGameActionName(i)},
			[2] = {Name = GetActionControlString(i)},})
	end
	vscrollbar:setScrollPosition(scrollpos)
end
RefreshActionsMappingList()

local scroll_pos = (MyDevice:getMonitorBrightness()-0.5)/2.5
BrightScroll:setScrollPosition(scroll_pos)
local spinner_val = math.floor((270*scroll_pos+2.5)/5)*5
BrightSpinner:setCurrentValue(spinner_val)

OptionsLockerWnd:setProperty("UnifiedMaxSize", "{{1,0},{1,0}}")
OptionsLockerWnd:setProperty("UnifiedAreaRect", "{{0,0},{0,0},{1,0},{1,0}}")
OptionsLockerWnd:setProperty("AlwaysOnTop","True")

MusicVolumeSlider:setCurrentValue	(MyGameMgr:getSoundTracksVolume()	)
EffectsVolumeSlider:setCurrentValue	(MyGameMgr:getSoundEffectsVolume())

MusicVolCapt:setProperty	("Text",	string.format("Music %d%%",		MyGameMgr:getSoundTracksVolume ()*100))
EffectsVolCapt:setProperty	("Text",	string.format("Effects %d%%",	MyGameMgr:getSoundEffectsVolume()*100))

if CameraStyle==0 then
	SGStyleRadio:setSelected(true)
elseif CameraStyle==1 then
	ASStyleRadio:setSelected(true)
elseif CameraStyle==2 then
	CrimsonStyleRadio:setSelected(true)
end

AutoZoomCheck:setSelected(CameraAutoZoom)

local sense_pos = (MyCursor:getSensitivity()-0.1)/0.9
SenseScroll:setScrollPosition(sense_pos)
local sense_val = math.floor((270*sense_pos+2.5)/5)*5
SenseSpinner:setCurrentValue(sense_val)

-- setting control handlers
   
LoadGameButton:subscribeEvent	("Clicked",				"ButtonHandler"	)
ExitButton:subscribeEvent		("Clicked",				"ButtonHandler"	)
AboutButton:subscribeEvent		("Clicked",				"ButtonHandler"	)
AboutOKButton:subscribeEvent	("Clicked",				"ButtonHandler"	)
AboutMainFrame:subscribeEvent	("CloseClicked",		"ButtonHandler"	)
CreditsButton:subscribeEvent	("Clicked",				"ButtonHandler"	)
CreditsOKButton:subscribeEvent	("Clicked",				"ButtonHandler"	)
CreditsMainFrame:subscribeEvent	("CloseClicked",		"ButtonHandler"	)
OptionsButton:subscribeEvent	("Clicked",				"ButtonHandler"	)
OptionsMainFrame:subscribeEvent	("CloseClicked",		"ButtonHandler"	)
OptionsOKButton:subscribeEvent	("Clicked",				"ButtonHandler"	)
KeymapList:subscribeEvent		("SelectionChanged",	"ActionMapSelectionChanged"	)
OptionsLockerWnd:subscribeEvent	("KeyDown",				"KeyDownMappingHandler"		)
OptionsLockerWnd:subscribeEvent	("KeyUp",				"KeyUpMappingHandler"		)
OptionsLockerWnd:subscribeEvent	("MouseButtonDown",		"MouseClickDownMappingHandler"	)
OptionsLockerWnd:subscribeEvent	("MouseClick",			"MouseClickMappingHandler"	)
OptionsLockerWnd:subscribeEvent	("MouseWheel",			"MouseWheelMappingHandler"	)

BrightSpinner:subscribeEvent("ValueChanged",		"BrightSpinnerHandler"	)
BrightScroll:subscribeEvent	("ScrollPosChanged",	"BrightScrollHandler"	)

MusicVolumeSlider:subscribeEvent  ("ValueChanged", "MusicVolumeSliderHandler"  )
EffectsVolumeSlider:subscribeEvent("ValueChanged", "EffectsVolumeSliderHandler")

SGStyleRadio:subscribeEvent		("SelectStateChanged",	"SGStyleRadioHandler"		)
ASStyleRadio:subscribeEvent		("SelectStateChanged",	"ASStyleRadioHandler"		)
CrimsonStyleRadio:subscribeEvent("SelectStateChanged",	"CrimsonStyleRadioHandler"	)
AutoZoomCheck:subscribeEvent	("CheckStateChanged",	"AutoZoomCheckHandler"		)

SenseSpinner:subscribeEvent	("ValueChanged",     "SenseSpinnerHandler"	)
SenseScroll:subscribeEvent	("ScrollPosChanged", "SenseScrollHandler"	)

InventoryFrame:subscribeEvent		("CloseClicked",		"InventoryCloseButtonHandler"	)
InventoryItemsList:subscribeEvent	("ItemSelectionChanged","InventoryItemsListHandler"		)
InventoryCloseButton:subscribeEvent	("Clicked",				"InventoryCloseButtonHandler"	)

MyScript:setScriptCallback(scr.ESCT_SHOW_MESSAGE,					"ShowMessage"				)
MyScript:setScriptCallback(scr.ESCT_ON_BEFORE_LOAD_SCENE,			"BeforeLoadScene"			)
MyScript:setScriptCallback(scr.ESCT_ON_AFTER_LOAD_SCENE,			"AfterLoadScene"			)
MyScript:setScriptCallback(scr.ESCT_ON_DELETE_GAME_NODE,			"OnDeleteNode"				)
MyScript:setScriptCallback(scr.ESCT_ON_CREATE_GAME_NODE,			"OnCreateNode"				)
MyScript:setScriptCallback(scr.ESCT_ON_DIE_GAME_NODE,				"OnDieNode"					)
MyScript:setScriptCallback(scr.ESCT_ON_COLLECT_GAME_ITEM,			"OnCollectItem"				)
MyScript:setScriptCallback(scr.ESCT_ON_THROW_GAME_ITEM,				"OnThrowItem"				)
MyScript:setScriptCallback(scr.ESCT_ON_USE_GAME_ITEM,				"OnUseItem"					)
MyScript:setScriptCallback(scr.ESCT_ON_IO_EVENT, 					"OnEvent"					)
MyScript:setScriptCallback(scr.ESCT_ON_GAME_STARTED,				"OnGameStarted")
MyScript:setScriptCallback(scr.ESCT_ON_GAME_STOPPED,				"OnGameStopped")

ShaderGen.init()
		
-----------------------------------------

function CloseAll()
	for key, value in pairs(RoboGUI) do
		value:setVisible(false)
	end
end

-----------------------------------------

function SetCameraStyle()
	local style = CameraStyle
	local cnt = MyGameMgr:getGameNodesCount(game.EGNT_MAIN_PLAYER)
	for i=0, cnt-1 do
		local player  = tolua.cast(MyGameMgr:getGameNode(i), "game::IGameNodeMainPlayer")
		if style==0 then
			player:setCameraStyle("ShadowGround")
		elseif style==1 then
			player:setCameraStyle("AlienShooter3D")
		elseif style==2 then
			player:setCameraStyle("CrimsonLand")
		end  
		player:setCameraAutoZoom(CameraAutoZoom)
		if CameraAutoZoom==false then           
			player:setCameraZoom(0.5)
		end
	end
end

-----------------------------------------

function ShowMessage(show, capt_msg)
	local profiling = MyProfiler:isProfiling()
	if profiling then
		MyProfiler:suspendProfiling()
	end
	if show==true then          
		local pos = string.find(capt_msg, ";");
		local len = string.len(capt_msg);
		if pos~=nil and len>pos then       
			local capt = string.sub(capt_msg, 0,     pos-1)
			local msg  = string.sub(capt_msg, pos+1, len  )
			WaitCapt:setProperty("Text", capt)
			WaitMsg:setProperty("Text", msg )
		end
		CloseAll()        
		RoboGUI.WaitDlg:setVisible(true)
		RoboGUI.WaitDlg:moveToFront()
		MyCEGUI.registerForRendering()
		if MyDriver:beginRendering() then
			MyDriver:renderAll()
			MyDriver:endRendering()
		end		
	else        
		RoboGUI.WaitDlg:setVisible(false)
	end
	if profiling then
		MyProfiler:resumeProfiling()
	end
end

-----------------------------------------

function OnDeleteNode(arg)
	local game_node = tolua.cast(arg, "game::IGameNode")
	--LOG_INFO("~GAME NODE "..tostring(game_node).." "..
	--	game.getGameNodeTypeReadableName(game_node:getGameNodeType()))
end

-----------------------------------------

function OnCreateNode(arg)
	local game_node = tolua.cast(arg, "game::IGameNode") 
	--LOG_INFO("GAME NODE "..tostring(game_node).." "..
	--	game.getGameNodeTypeReadableName(game_node:getGameNodeType()))
end

-----------------------------------------

function OnDieNode(arg)
	local node = tolua.cast(arg, "game::IGameNode") 
end

-----------------------------------------

function ActionMapSelectionChanged(args)
	MappingCapt:setProperty("UnifiedAreaRect", "{{0.25,0},{0.325,0},{0.75,0},{0.675,0}}")
	MappingCapt:setVisible(true)
	MappingCapt:setText("Press key/mouse\nor Esc for reset")
	OptionsLockerWnd:setVisible(true)
	OptionsLockerWnd:moveToFront()
end

-----------------------------------------

function KeyDownMappingHandler(args)

	local item = KeymapList:getFirstSelectedItem()

	if item==nil then
		return 0
	end

	local row  = KeymapList:getItemRowIndex(item)     

	local key_event = tolua.cast(args,"const CEGUI::KeyEventArgs")
	local kcode =key_event.scancode 

	MappingCapt:setProperty("UnifiedAreaRect", "{{0.35,0},{0.4,0},{0.65,0},{0.6,0}}")
	MappingCapt:setText(string.format("%s",io.getKeyCodeName(kcode)))

	if kcode~=io.EKC_ESCAPE then
		MyInpDisp:mapKey(kcode, row)
	else
		MyInpDisp:mapKey  (io.E_KEY_CODE_COUNT, row)  
		MyInpDisp:mapMouse(io.E_MOUSE_CODE_COUNT, row)
	end

end

-----------------------------------------

function KeyUpMappingHandler(args)
	MappingCapt:setVisible(false)
	OptionsLockerWnd:setVisible(false) 
	OptionsLockerWnd:moveToBack()
	RefreshActionsMappingList()
end
-----------------------------------------

function MouseClickDownMappingHandler(args)

   	local mouse_event = tolua.cast(args,"const CEGUI::MouseEventArgs")
	local mcode = mouse_event.button

	MappingCapt:setProperty("UnifiedAreaRect", "{{0.35,0},{0.425,0},{0.65,0},{0.575,0}}")
	MappingCapt:setText(string.format("%s",io.getMouseCodeName(mcode)))

	local item = KeymapList:getFirstSelectedItem()
	local row  = KeymapList:getItemRowIndex(item)  

	MyInpDisp:mapMouse(mcode, row)  
end

-----------------------------------------

function MouseClickMappingHandler(args)
	MappingCapt:setVisible(false)
	OptionsLockerWnd:setVisible(false) 
	OptionsLockerWnd:moveToBack()  
	RefreshActionsMappingList() 
end

-----------------------------------------

function MouseWheelMappingHandler(args)

	local mouse_event = tolua.cast(args,"const CEGUI::MouseEventArgs")
	local wheel = mouse_event.wheelChange

	local item = KeymapList:getFirstSelectedItem()
	local row  = KeymapList:getItemRowIndex(item)

	MappingCapt:setProperty("UnifiedAreaRect", "{{0.35,0},{0.425,0},{0.65,0},{0.575,0}}")

	if wheel>0 then
		MappingCapt:setText(string.format("%s",io.getMouseCodeName(io.EMC_MWHEEL_UP)))
		MyInpDisp:mapMouse(io.EMC_MWHEEL_UP, row)
	elseif wheel<0 then
		MappingCapt:setText(string.format("%s",io.getMouseCodeName(io.EMC_MWHEEL_DOWN)))
		MyInpDisp:mapMouse(io.EMC_MWHEEL_DOWN, row)
	end

	MappingCapt:setVisible(false)
	OptionsLockerWnd:setVisible(false)
	OptionsLockerWnd:moveToBack()

	RefreshActionsMappingList()

end 

-----------------------------------------

function ButtonHandler(args)
	local we = CEGUI.toWindowEventArgs(args)
	local name = we.window:getName()
	if name == "LoadGameButton" then
		local selItem = ListBoxStartLevel:getFirstSelectedItem()
		if selItem==nil then
			return
		end
		-- loading scene
		local selIndex = ListBoxStartLevel:getItemIndex(selItem) + 1
		MyGameMgr:loadGameScene(SceneFileNames[selIndex].filename)
	elseif name == "ExitButton" then
		MyDevice:close()
	elseif name == "AboutButton" then
		CloseAll()
		RoboGUI.AboutDlg:setVisible(true)
	elseif name == "AboutOKButton" then
		CloseAll()
		RoboGUI.MainMenu:setVisible(true)
	elseif name == "AboutMainFrame" then
		CloseAll()
		RoboGUI.MainMenu:setVisible(true)
	elseif name == "CreditsButton" then
		CloseAll()
		RoboGUI.CreditsDlg:setVisible(true)
	elseif name == "CreditsOKButton" then
		CloseAll()
		RoboGUI.MainMenu:setVisible(true)
	elseif name == "CreditsMainFrame" then
		CloseAll()
		RoboGUI.MainMenu:setVisible(true)
	elseif name == "OptionsButton" then
		CloseAll()
		RoboGUI.OptionsDlg:setVisible(true)
	elseif name == "OptionsOKButton" then
		SaveGameOptions()
		CloseAll()
		RoboGUI.MainMenu:setVisible(true)
	elseif name == "OptionsMainFrame" then
		SaveGameOptions()
		CloseAll()
		RoboGUI.MainMenu:setVisible(true)
	end
end

-----------------------------------------

function BrightSpinnerHandler(args)
	local val = BrightSpinner:getCurrentValue()
	local pos = val/270;
	BrightScroll:setScrollPosition(val/270)
	MyDevice:setMonitorBrightness(0.5+2.5*pos)
end

-----------------------------------------

function BrightScrollHandler(args)
	local pos = 270*BrightScroll:getScrollPosition()
	local val = math.floor((pos+2.5)/5)*5
	BrightSpinner:setCurrentValue(val)
end

-----------------------------------------

function MusicVolumeSliderHandler(args)
	local val = MusicVolumeSlider:getCurrentValue()
	MyGameMgr:setSoundTracksVolume(val)
	MusicVolCapt:setProperty  ("Text", string.format("Music %d%%", val*100))
end

-----------------------------------------

function EffectsVolumeSliderHandler(args)
	local val = EffectsVolumeSlider:getCurrentValue()
	MyGameMgr:setSoundEffectsVolume(val)
	EffectsVolCapt:setProperty  ("Text", string.format("Effects %d%%", val*100))
end

-----------------------------------------

function SGStyleRadioHandler(args)
	if SGStyleRadio:isSelected() then
		CameraStyle = 0
		SetCameraStyle()
	end
end

-----------------------------------------

function ASStyleRadioHandler(args)
	if ASStyleRadio:isSelected() then       
		CameraStyle=1
		SetCameraStyle()
	end     
end

-----------------------------------------

function CrimsonStyleRadioHandler(args)
	if CrimsonStyleRadio:isSelected() then       
		CameraStyle=2
		SetCameraStyle()
	end     
end

-----------------------------------------

function AutoZoomCheckHandler(args)
	CameraAutoZoom = AutoZoomCheck:isSelected()
	SetCameraStyle()
end

-----------------------------------------

function SenseSpinnerHandler(args)
	local val = SenseSpinner:getCurrentValue()
	local pos = val/270;
	SenseScroll:setScrollPosition(val/270)
	MyCursor:setSensitivity(0.1+pos)
end

-----------------------------------------

function SenseScrollHandler(args)
	local pos = 270*SenseScroll:getScrollPosition()
	local val = math.floor((pos+2.5)/5)*5
	SenseSpinner:setCurrentValue(val)
end

-----------------------------------------

function InventoryCloseButtonHandler(args)
	ChangeInventoryState() 
end

----------------------------------------------------------

local tex_dir = MyResMgr:getMediaDirFull ( res.EMT_TEXTURES )
local cam_style = -1
local sel_weapon= -1

----------------------------------------------------------

function InventoryItemSelect(item_ptr) 
	local item = tolua.cast(item_ptr, "game::IGameNodeItem") 
	if item==nil then
		InventoryItemImage:setProperty     ("Image","") 
		InventoryItemName:setProperty      ("Text", "")
		InventoryItemShortDescr:setProperty("Text", "")
		InventoryItemDescr:setProperty     ("Text", "")
		return  
	end
	InventoryItemImage:setProperty     ("Image", item:getItemImageName() ) 
	InventoryItemName:setProperty      ("Text",  item:getItemName()      )
	InventoryItemShortDescr:setProperty("Text",  item:getItemShortDescr())
	InventoryItemDescr:setProperty     ("Text",  item:getItemDescr()     )
end

----------------------------------------------------------

function InventoryItemsListHandler(args)        
	local list_item = InventoryItemsList:getFirstSelectedItem()
	if list_item==nil then
		return
	end
	local item_idx = list_item:getID()
	local item_ptr = list_item:getUserData()
	InventoryItemSelect(item_ptr) 
end

----------------------------------------------------------

local item_col = CEGUI.colour(0.6, 0.6, 0.6, 1)
local size   = core.dimension2df(0.0375,0.05)
local offset = core.vector2df(0,0)

function UpdateIngameGUI(timeMs)
	Console.update()
	if Scened.isStarted() then
		Scened.update(timeMs)
	end
	local player = MyGameMgr:getMainPlayerGameNode()
	if player~=nil then
		local life     = player:getLife()
		local max_life = player:getMaxLife()
		local life_pers = (life/max_life)
		if LifeBar:getProgress()~=life_pers then
			LifeValue:setText(string.format("%.f%%", life_pers*100))
			LifeBar:setProgress(life_pers)
		end 
		local inventory=player:getInventory()
		local weapon_count = inventory:getWeaponsCount()
		local _sel_weapon = player:getSelectedWeaponNumber()
		if sel_weapon~=_sel_weapon or cam_style~=CameraStyle or MustRefreshGUI then 
			sel_weapon=_sel_weapon
			cam_style = CameraStyle                     
			 for w=0,2 do
				if w<weapon_count then
					local weapon = inventory:getWeapon(w,0)
					if weapon:isWeaponEnabled() then
						if w==sel_weapon then
							ImgWeapon[w]:setProperty("Image", weapon:getWeaponSelectedImageName())
							CaptWeapon[w]:setProperty("TextColours", "tl:FF40FF40 tr:FF40FF40 bl:FF40FF40 br:FF40FF40")
						else
							ImgWeapon[w]:setProperty("Image", weapon:getWeaponImageName())
							CaptWeapon[w]:setProperty("TextColours", "tl:FFFFFFFF tr:FFFFFFFF bl:FFFFFFFF br:FFFFFFFF")
						end 
					else
						ImgWeapon[w]:setProperty("Image", "")
						CaptWeapon[w]:setProperty("TextColours", "tl:FFFFFFFF tr:FFFFFFFF bl:FFFFFFFF br:FF60FFFF")             
					end
				end
			 end
			if cam_style==0 or true then
				local tex_fnam = ""                 
				size:set(0.0375,0.05)
				offset:set(0,0)
				local centered = true
				if sel_weapon==0 then 
					tex_fname = string.format("%s%s",tex_dir,"sprites/aim_blaster.bmp")
				elseif sel_weapon==1 then 
					tex_fname = string.format("%s%s",tex_dir,"sprites/aim_chainmachine.bmp")
				elseif sel_weapon==2 then 
					tex_fname = string.format("%s%s",tex_dir,"sprites/aim_rocketlauncher.bmp")
				end                 
				local mips_flag = MyDriver:getTextureCreationFlag(vid.ETCF_AUTOGEN_MIP_MAPS)
				MyDriver:setTextureCreationFlag(vid.ETCF_AUTOGEN_MIP_MAPS, false)
				local tex = MyDriver:getTexture(tex_fname)                
				MyCursor:setGraphicCursor(tex, size, offset, centered)
				MyDriver:setTextureCreationFlag(vid.ETCF_AUTOGEN_MIP_MAPS, mips_flag)
			else
				local cur_fname = ""
				if sel_weapon==0 then 
					cur_fname = string.format("%s%s",tex_dir,"cursors/aim_blaster.cur")
				elseif sel_weapon==1 then 
					cur_fname = string.format("%s%s",tex_dir,"cursors/aim_chainmachine.cur")
				elseif sel_weapon==2 then 
					cur_fname = string.format("%s%s",tex_dir,"cursors/aim_rocketlauncher.cur")
				end                 
				MyCursor:resetGraphicCursor()
				MyCursor:setCursor(cur_fname)         
			end
		end
		for w=0,2 do
			if w<weapon_count then
				local ammo_count=0  
				local max_ammo_count=0
				local ammo_progess=0
				local weapon_sub_count = inventory:getWeaponsSubCount(w)
				for wi=0,weapon_sub_count-1 do
					local weapon = inventory:getWeapon(w,wi)
					local bullet_idx = weapon:getChoosedBulletIndex()
					ammo_count    = ammo_count     + weapon:getBulletAmmoCount(bullet_idx)
					max_ammo_count= max_ammo_count + weapon:getBulletMaxAmmoCount(bullet_idx)
				end 
				if max_ammo_count>0 then
					ammo_progess = ammo_count/max_ammo_count
				end
				if w==sel_weapon then
					AmmoValue:setText(string.format("%d", ammo_count))
					AmmoBar:setProgress(ammo_progess)
				end             
				ProgressAmmoWeapon[w]:setProgress(ammo_progess)     
			end
		end
		if MustRefreshGUI==true then
			if gui_state==2 then                    
				InventoryItemsList:resetList()
				InventoryItemSelect(0) 
				item_col:set(0.6, 0.6, 0.6, 1)
				local inventory=player:getInventory()
				local item_cnt = inventory:getItemsCount()
				for i=0, item_cnt-1 do  
					local item = inventory:getItem(i)   
					local item_params=item:getGameCommonParams()
					local item_name = item_params.Scene.Parameters.name:c_str()
					local list_item=CEGUI.createListboxTextItem(item_name, i , item, false, true)   
					list_item:setSelectionBrushImage("TaharezLook", "MultiListSelectionBrush")
					list_item:setTextColours(colourCEGUI)
					InventoryItemsList:addItem(list_item)
					if i==0 then
						InventoryItemsList:setItemSelectState(list_item, true)
						InventoryItemSelect(item) 
					end
				end
			end
		end
	end

	if MustRefreshGUI==true then
		MustRefreshGUI=false
		CloseAll()	
		if Scened.isStarted() then
			MyCursor:setVisible(false)
			CEGUICursor:show()
		elseif Console.isVisible() then
			MyCursor:setVisible(false)
			CEGUICursor:show()
		else
			if gui_state==0 or gui_state==2 then
				MyCursor:setVisible(false)
				CEGUICursor:show()              
			elseif gui_state==1 then
				MyCursor:setVisible(true)
				CEGUICursor:hide()
			end
			if gui_state==1 then 
				RoboGUI.IngameGUI:setVisible(true)             
			elseif gui_state==0 then
				RoboGUI.MainMenu:setVisible(true)             
			end
		end
	end
end

function OnConsoleStateChange(state)
	if Console.isVisible() then
		MyGameMgr:stopGame()
	elseif not Scened.isStarted() then
		MyGameMgr:startGame()
	end
	MustRefreshGUI=true
end
Console.setStateChangeCallback(OnConsoleStateChange)

function OnScenedStartStop(start)
	if Scened.isStarted() then
		MyGameMgr:stopGame()
	elseif not Console.isVisible() then
		MyGameMgr:startGame()
	end
	gui_state=1
	MustRefreshGUI=true
end
Scened.setStartStopCallback(OnScenedStartStop)

-----------------------------------------

function ChangeInventoryState()
	if gui_state==1 or gui_state==2 then
		if RoboGUI.InventoryGUI:isVisible()==false then
			RoboGUI.InventoryGUI:setVisible(true)
			RoboGUI.InventoryGUI:moveToFront()
			gui_state = 2
		else    
			RoboGUI.InventoryGUI:setVisible(false)
			gui_state = 1
		end
		MustRefreshGUI=true
	end     
end

-----------------------------------------

function OnEvent(args)
	local event = tolua.cast(args,"const io::SEvent")
	if event.EventType == io.EET_KEY_INPUT_EVENT then
		if event.KeyInput.Key == io.EKC_GRAVE then 
			if event.KeyInput.Event == io.EKIE_KEY_PRESSED_UP then
				Console.changeState()
				MustRefreshGUI=true
			end
			return true
		end	
		if event.KeyInput.Event == io.EKIE_KEY_PRESSED_DOWN then
			if event.KeyInput.Control then
				if event.KeyInput.Key == io.EKC_C then
					if Helper.copyToClipboard() then
						return true
					end
				elseif event.KeyInput.Key == io.EKC_V then
					if Helper.pasteFromClipboard() then
						return true
					end
				end
			end
		end
		if event.KeyInput.Event == io.EKIE_KEY_PRESSED_UP then
			if event.KeyInput.Key == io.EKC_E
					and event.KeyInput.Control then
				if Scened.isStarted() then
					Scened.exit()
				else
					Scened.start()
				end
				return true
			end
		end
	end
	if not Console:isVisible() and Scened.isStarted() then
		if Scened.onEvent(event) then
			return true
		end
	end
	if event.EventType == io.EET_LOG_TEXT_EVENT then
		Console.onLog(event.LogEvent)
		return true
	end
	if event.EventType ~= io.EET_LOG_TEXT_EVENT then
		local adsorbed = false
		if Scened.isStarted() and
			event.EventType == io.EET_MOUSE_INPUT_EVENT and (
				event.MouseInput.Event == io.EMIE_LMOUSE_PRESSED_DOWN or
				event.MouseInput.Event == io.EMIE_MMOUSE_PRESSED_DOWN or
				event.MouseInput.Event == io.EMIE_RMOUSE_PRESSED_DOWN) then
			adsorbed = true
			local w = CEGUISystem:getWindowContainingMouse()
			if w ~= nil then
				local rootWnd = CEGUISystem:getGUISheet()
				if core.isPtrsEq(w, rootWnd) then
					adsorbed = false
				end
			end
		else
			adsorbed = false
		end
		if not MyCEGUI.onEvent(event) then
			adsorbed = false
		end
		if adsorbed then
			return true
		end
	end
	if event.EventType == io.EET_KEY_INPUT_EVENT then       
		if event.KeyInput.Event == io.EKIE_KEY_PRESSED_DOWN then
			if event.KeyInput.Key == io.EKC_ESCAPE then
				if not Console.isVisible()
						and not Scened:isStarted()
						and not OptionsLockerWnd:isVisible() then
					if RoboGUI.InventoryGUI:isVisible() or RoboGUI.MainMenu:isVisible() then  
						gui_state = 0           
					else
						gui_state = -1          
					end
					gui_state = gui_state + 1
					MustRefreshGUI = true
				end
				return true
			elseif event.KeyInput.Key == MyInpDisp:getActionKey(game.EGA_ENTER_INVENTORY) then                
				ChangeInventoryState()  
				return true
			end      
		end
	end
	if event.EventType == io.EET_MOUSE_INPUT_EVENT then
	end
	return false
end

-----------------------------------------

function BeforeLoadScene(args)    
	MyCursor:setRelativePosition(0.5, 0.5)
	MyGameMgr:stopGame()
	CloseAll()
	CEGUICursor:hide()
end

-----------------------------------------

function AfterLoadScene(args)
	MyCursor:setRelativePosition(0.5, 0.5)
	SetCameraStyle()
	MyGameMgr:startGame()
	CEGUICursor:hide()
	RoboGUI.IngameGUI:setVisible(true)    
	gui_state=1
	-- feel rechargable weapons ammo
	local player = MyGameMgr:getMainPlayerGameNode()
	if player~=nil then    
		local inventory=player:getInventory()
		local weapon_count = inventory:getWeaponsCount()
		for w=0,weapon_count-1 do           
			local weapon_sub_count = inventory:getWeaponsSubCount(w)                
			for wi=0,weapon_sub_count-1 do
				local weapon = inventory:getWeapon(w,wi)
				local bullet_count = weapon:getBulletsCount()
				for bi=0,bullet_count-1 do
					local wb_params = weapon:getWeaponBulletParameters(bi)
					if wb_params.AutoFeelBulletsPerSecond>0 then
						weapon:feelBulletAmmo(bi,weapon:getBulletMaxAmmoCount(bi))                  
					end
				end
			end
		end
	end
	MustRefreshGUI = true
end
	
function OnGameStarted()
	if MyTimer:isSuspended() then
		MyTimer:resume()
	end
end

function OnGameStopped()
	if not MyTimer:isSuspended() then
		MyTimer:suspend()
	end 
end

MyDevice:show()

----------------------------------------------------------
-- loading media
----------------------------------------------------------

-- adding pakage files
local media_fname = 
    string.format("%s%s", MyResMgr:getMediaDirRel ( res.EMT_ROOT ), "robo.zip")

if (not MyFileSys:addZipFileArchive(media_fname)) then
	MyLogger:log("Can't open pakage file", io.ELL_INFORMATION)
end  

-- loading shaders cache
if OPTIONS.CacheShaders == true then
	local tmp_dir = MyResMgr:getMediaDirFull(res.EMT_TEMP_DATA)
	MyDriver:loadGPUProgramsFromDir(tmp_dir, ShaderGen.getCurrentTag(), false)
end

-- loading materials
local mat_dir = MyResMgr:getMediaDirFull(res.EMT_MATERIALS)
MyMatMgr:loadMaterialsFromDir(mat_dir, true, false)

-- getting background material

local robomaterial = vid.SMaterial()
robomaterial:set(MyMatMgr:getMaterialByName("textures/robo_sfx/robo_title"))
local pass_cnt = robomaterial:getPassesCount()          
for p = 0, pass_cnt - 1 do
	local pass = robomaterial:getPass(p)
	pass:setDepthTest ( vid.ECT_ALWAYS )
	pass:setFlag ( vid.EMF_FOG_ENABLE,	false )
	pass:setFlag ( vid.EMF_MIP_MAP_OFF,	false )
	pass:setFlag ( vid.EMF_ZWRITE_ENABLE,	false )
end

local MyRT = nil
if MyDriver:queryFeature(vid.EVDF_RENDER_TO_TARGET) then
	MyRT = MyDriver:addRenderTarget(MyDriver:getScreenSize(),
		img.ECF_A8R8G8B8, vid.ERTDF_DEPTH24_STENCIL8)
end

local rtmaterial = vid.SMaterial()
if MyRT then
	local pass = rtmaterial:getPass(0)
	pass:setDepthTest(vid.ECT_ALWAYS)
	pass:setAlphaTest(vid.ECT_ALWAYS)
	pass:setFlag(vid.EMF_BLENDING, false)
	pass:setFlag(vid.EMF_BACK_FACE_CULLING, true)
	pass:setFlag(vid.EMF_ZWRITE_ENABLE, false)
	pass:setFlag(vid.EMF_FRONT_FACE_CCW, true)
	pass:setFlag(vid.EMF_FOG_ENABLE, false)
	pass:setFlag(vid.EMF_GOURAUD_SHADING, false)
	pass.Layers[0]:setTexture(MyRT:getColorTexture())
end

----------------------------------------------------------
-- setup engine
----------------------------------------------------------

-- setting frame background color
local col = img.SColor(0,0,0,0)
MyDriver:setBackgroundColor(col)

-- hiding system cursor
--MyCursor:setVisible(false)
MyCursor:setRelativePosition(0.5, 0.5)

RoboGUI.MainMenu:setVisible(true)

----------------------------------------------------------
-- setup GUI default resolution
----------------------------------------------------------

Helper.GUI.setupCurrentScreenResolution()

----------------------------------------------------------
-- main render cycle
----------------------------------------------------------

local last_fps = 0
local rect_tc = core.rectf(0.0, 0.0, 1.0, 1.0)
local color_white = img.SColor(255,255,255,255)
local viewport_f = core.rectf()

while MyDevice:run() do

	-- update GUI state
	UpdateIngameGUI(MyDevice:getDeviceTime())
	
	-- prepare for rendering
	MyGameMgr:preRenderFrame()
	
	-- register GUI for rendering
	
	MyCEGUI.registerForRendering()
	Console.registerForRendering()
	MyCursor:registerForRendering()
	
	-- pre render
	if gui_state>0 then
		-- scene pre render stuff
		MyScnMgr:preRenderScene()
	else
		-- register custom rendering
		local viewport = MyDriver:getViewPort()
		viewport_f:set(
			viewport.UpperLeftCorner.X, viewport.UpperLeftCorner.Y,
			viewport.LowerRightCorner.X, viewport.LowerRightCorner.Y)
		rect_tc:set(0, 0, 1, 1)
		MyDriver:register2DImageForRendering(
			robomaterial, viewport_f, rect_tc, color_white)
	end

	-- render
	if MyDriver:beginRendering() then

		if MyRT then
			local msk = MyDriver:getColorMask()
			local rt = MyDriver:getRenderTarget()

			---------------------------------
			-- render 3D into RT

			MyDriver:setRenderTarget(MyRT)
			MyDriver:setColorMask(true, true, true, true)
			MyDriver:clearColor(MyDriver:getBackgroundColor())
			MyDriver:clearDepth()
			MyDriver:clearStencil()
			MyDriver:setColorMask(msk)
			for i = 0, vid.ERP_2D_PASS - 1 do
				MyDriver:renderPass(i)
			end
			MyDriver:setRenderTarget(rt)

			---------------------------------
			-- render into main FB

			-- render 3D
			if MyDriver:getDriverFamily() == vid.EDF_OPENGL then
			-- swap TCoords vertically, because texture in OpenGL FBO Y-inversed
				rect_tc:set(0, 1, 1, 0)
			else
				rect_tc:set(0, 0, 1, 1)
			end
			viewport_f:set(0, 0, 1, 1)
			MyDriver:render2DRect(rtmaterial, viewport_f, rect_tc)

			-- render 2D + GUI
			for i = vid.ERP_2D_PASS, vid.E_RENDER_PASS_COUNT - 1 do
				MyDriver:renderPass(i)
			end
		else
			MyDriver:renderAll()
		end

		MyDriver:endRendering()
	end

	-- do game
	if gui_state>0 then
		MyGameMgr:doGame()
	end
	
	-- post render stuff
	if gui_state>0 then
		MyScnMgr:postRenderScene()
	end	

	local fps = MyDriver:getCurrentFPS()
	if last_fps ~= fps then
		local str = string.format("Robo Troopers FPS=%d, tris=%d, DIPs=%d",
			fps, MyDriver:getRenderedTrianglesCount(), MyDriver:getRenderedDIPsCount())
		MyDevice:setWindowCaption ( str )
		last_fps = fps
	end
	
	MyGameMgr:postRenderFrame()

end

if MyRT then
	MyDriver:removeRenderTarget(MyRT)
	MyRT = nil
end
