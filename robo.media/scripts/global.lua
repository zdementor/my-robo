
GUI_SCHEME_NAME = "TaharezLook"

local MediaRoot       = "../../robo/robo.media/"
local CommonMediaRoot = "../../base/base.media/"

OPTIONS =
{
	StartupOptionsFileName	= "RoboTroopers.cfg",
	GameOptionsFileName		= "RoboOptions.cfg",
	CEGUIOptionsFileName	= MediaRoot.."CEGUI.ini",
	Window = {
		Caption = "RoboTroopers",
		Icon = {
			FileName = "icons/RoboTroopers.ico",
			Width = 32,
			Height = 32}
		},
	MediaDirectories = {
		{media = res.EMT_ROOT,			dir = MediaRoot			},
		{media = res.EMT_TEXTURES,		dir = "textures/"		},
		{media = res.EMT_FONTS,			dir = "gui/fonts/"		},
		{media = res.EMT_MESHES,		dir = "models/"			},
		{media = res.EMT_XML_SCRIPTS,	dir = "xml/"			},
		{media = res.EMT_GAME_SCRIPTS,	dir = "scripts/"		},
		{media = res.EMT_SOUND_TRACKS,	dir = "sounds/tracks/"	},
		{media = res.EMT_SOUND_EFFECTS,	dir = "sounds/effects/"	},
		{media = res.EMT_TEMP_DATA,		dir = "temp/"			},
		{media = res.EMT_MATERIALS,		dir = "materials/"		},
		{media = res.EMT_GPU_PROGRAMS,	dir = "materials/gpu/"	},
		},
	CommonMediaDirectories = {
		{media = res.EMT_ROOT,			dir = CommonMediaRoot	},
		{media = res.EMT_TEXTURES,		dir = "textures/"		},
		{media = res.EMT_FONTS,			dir = "gui/fonts/"		},
		{media = res.EMT_MESHES,		dir = "models/"			},
		{media = res.EMT_XML_SCRIPTS,	dir = "xml/"			},
		{media = res.EMT_GAME_SCRIPTS,	dir = "scripts/"		},
		{media = res.EMT_SOUND_TRACKS,	dir = "sounds/tracks/"	},
		{media = res.EMT_SOUND_EFFECTS,	dir = "sounds/effects/"	},
		{media = res.EMT_TEMP_DATA,		dir = "temp/"			},
		{media = res.EMT_MATERIALS,		dir = "materials/"		},
		{media = res.EMT_GPU_PROGRAMS,	dir = "materials/gpu/"	},
		},
	ConsoleGUI = {
		SchemeName		= GUI_SCHEME_NAME,
		Scheme			= GUI_SCHEME_NAME..".scheme",
		SchemeAliases	= GUI_SCHEME_NAME.."ConsoleAliases.scheme",
		ResourceGroup	= "",
		InfoFont		= "cour.ttf"},
	HelperGUI = {
		SchemeName		= GUI_SCHEME_NAME,
		Scheme			= GUI_SCHEME_NAME..".scheme",
		SchemeAliases	= GUI_SCHEME_NAME.."HelperAliases.scheme",
		ResourceGroup	= ""},
	ScenedGUI = {
		SchemeName		= GUI_SCHEME_NAME,
		Scheme			= GUI_SCHEME_NAME..".scheme",
		SchemeAliases	= GUI_SCHEME_NAME.."ScenedAliases.scheme",
		ResourceGroup	= ""},
	GameGUI = {
		SchemeName		= GUI_SCHEME_NAME,
		Scheme			= GUI_SCHEME_NAME..".scheme",
		SchemeAliases	= GUI_SCHEME_NAME.."ScenedAliases.scheme",
		ResourceGroup	= ""},
	LogLevel				= io.ELL_INFORMATION,
	ConsoleLogLevel			= io.ELL_INFORMATION,
	CacheShaders			= true,
}

CameraStyle = 0
CameraAutoZoom = false
