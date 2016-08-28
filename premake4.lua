
ROOT_DIR = ".."

dofile(ROOT_DIR.."/deps/premake_common.lua")

local SRC_DIR  = ROOT_DIR.."/base/src"
local SRC_INC_DIR  = SRC_DIR.."/inc"

local ROBO_PRJ_DIR  = ROOT_DIR.."/build"
local ROBO_PRJ_NAME = "MyEngine_Robo"

local ROBO_DIR  = ROOT_DIR.."/robo"
local ROBO_INC_DIR = { SRC_INC_DIR }
local ROBO_LIB_DIR = { LIBS_DIR }

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
	{ ROBO_INC_DIR }, { ROBO_LIB_DIR },
	{}, {},  nil, nil,
	nil, nil
)

local releaseMainEntry = nil
local debugMainEntry = nil
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
	{ROBO_INC_DIR, CEGUI_INC_DIR}, { ROBO_LIB_DIR },
	{}, {}, nil, nil,
	releaseMainEntry, debugMainEntry
)	