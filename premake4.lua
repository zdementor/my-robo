
rootdir = ".."

dofile(rootdir.."/deps/premake_common.lua")

local ROBO_PRJ_DIR  = rootdir.."/build"
local ROBO_PRJ_NAME = "MyEngine_Robo"

local ROBO_DIR  = rootdir.."/robo"
 
InitPackage(ROBO_PRJ_NAME, ROBO_PRJ_DIR,
	"RoboGame", "c++", "dll", "",
	{},
		{"MyCore", "MyEngine",},
			{},
	{"__MY_BUILD_ROBOGAME_LIB__"}, {}, {},
	{
		SRC_DIR.."/inc/**.h",
		ROBO_DIR.."/RoboGame/**.cpp",
		ROBO_DIR.."/RoboGame/**.h",
		SRC_DIR.."/CompileConf.h",
		SRC_DIR.."/MyDllEntry.cpp",
		SRC_DIR.."/MySingletons.cpp",
	},
		{},
	BASE_INC_PATH, BASE_LIB_PATH)

local releaseMainEntry = "main"
local debugMainEntry = "main"
if os.is("windows") then
	releaseMainEntry = "WinMain"
end

InitPackage(ROBO_PRJ_NAME, ROBO_PRJ_DIR,
	"RoboTroopers", "c++", "exe", "",
	{},
		{"MyCore", "MyCoreScript",},
			{},
	{}, {}, {},
	{
		SRC_DIR.."/inc/**.h",
		ROBO_DIR.."/RoboTroopers/**.cpp",
		ROBO_DIR.."/RoboTroopers/**.h",
		ROBO_DIR.."/RoboTroopers/**.rc",
		ROBO_DIR.."/RoboTroopers/**.manifest",
	},
		{},
	{BASE_INC_PATH, CEGUI_INC_DIR}, BASE_LIB_PATH,
	{}, {},
	{}, {},
	releaseMainEntry, debugMainEntry
)	