
rootdir = ".."

dopackage(rootdir.."/deps/premake_common.lua")

local MY_PRJ_DIR = rootdir.."/build"

local ROBO_DIR  = rootdir.."/robo"

project.name = "MyEngine_Robo"
project.path = MY_PRJ_DIR

package = newpackage()
InitPackage("RoboGame", MY_PRJ_DIR, "c++", "dll", "",
	{ "MyCore", "MyEngine", },
		{},
			{},
	{"__MY_BUILD_ROBOGAME_LIB__"}, {}, {},
	{
		matchrecursive(SRC_DIR.."/inc/*.h"),
		matchrecursive(ROBO_DIR.."/RoboGame/*.cpp"),
		matchrecursive(ROBO_DIR.."/RoboGame/*.h"),
		SRC_DIR.."/CompileConf.h",
		SRC_DIR.."/MyDllEntry.cpp",
		SRC_DIR.."/MySingletons.cpp",
	},
		{},
	BASE_INC_PATH, BASE_LIB_PATH)

package = newpackage()
InitPackage("RoboTroopers", MY_PRJ_DIR, "c++", "exe", "",
	{ "MyCore", "MyCoreScript", },
		{},
			{},
	{}, {}, {},
	{
		matchrecursive(SRC_DIR.."/inc/*.h"),
		matchrecursive(ROBO_DIR.."/RoboTroopers/*.cpp"),
		matchrecursive(ROBO_DIR.."/RoboTroopers/*.h"),
		matchrecursive(ROBO_DIR.."/RoboTroopers/*.rc"),
		matchrecursive(ROBO_DIR.."/RoboTroopers/*.manifest"),
	},
		{},
	{BASE_INC_PATH, CEGUI_INC_DIR}, BASE_LIB_PATH,
	{}, {"/SUBSYSTEM:WINDOWS"},
	{}, {"/SUBSYSTEM:CONSOLE"})	