//|-------------------------------------------------------------------------
//| File:        RoboGame.cpp
//|
//| Descr:       This file is a part of the 'MyEngine'
//| Author:      Zhuk 'zdementor' Dmitry (aka ZDimitor)
//| Email:       zdimitor@pochta.ru, sibergames@nm.ru
//|
//|     Copyright (c) 2004-2009 by Zhuk Dmitry, Krasnoyarsk - Moscow
//|                      All Rights Reserved.
//|-------------------------------------------------------------------------

#include <game/IGameManager.h>

//----------------------------------------------------------------------------
namespace my {
namespace game {
namespace robo {
//----------------------------------------------------------------------------

//! IronWarrior registry funcs
IGameNode* Alloc__IronWarrior(scn::ISceneNode* n, SGameNodeParams &params);
IGameNode* Create_IronWarrior(SGameNodeCommonParams &node_params, bool log_info);
IGameNode* Clone__IronWarrior(IGameNode *game_node, bool log_info);
IGameNode* Load___IronWarrior(SGameNodeCommonParams &node_params, io::IReadFile* file);

//----------------------------------------------------------------------------

//! Akron registry funcs
IGameNode* Alloc__Akron(scn::ISceneNode* n, SGameNodeParams &params);
IGameNode* Create_Akron(SGameNodeCommonParams &node_params, bool log_info);
IGameNode* Clone__Akron(IGameNode *game_node, bool log_info);
IGameNode* Load___Akron(SGameNodeCommonParams &node_params, io::IReadFile* file);

//----------------------------------------------------------------------------

//! Akron registry funcs
IGameNode* Alloc__Krag(scn::ISceneNode* n, SGameNodeParams &params);
IGameNode* Create_Krag(SGameNodeCommonParams &node_params, bool log_info);
IGameNode* Clone__Krag(IGameNode *game_node, bool log_info);
IGameNode* Load___Krag(SGameNodeCommonParams &node_params, io::IReadFile* file);

//----------------------------------------------------------------------------

//! 
extern "C" __MY_EXPORT__ void startPlugin()
{
	//////////////////////////////////////////////////////
	// registering robo game classes
	//////////////////////////////////////////////////////

	GAME_MANAGER.registerGameNodeClass( 
		"IronWarrior", game::EGNT_MAIN_PLAYER, 
		game::robo::Alloc__IronWarrior, 
		game::robo::Create_IronWarrior, 
		game::robo::Clone__IronWarrior, 
		game::robo::Load___IronWarrior    
		);

	GAME_MANAGER.registerGameNodeClass( 
		"Akron", game::EGNT_PERSON, 
		game::robo::Alloc__Akron, 
		game::robo::Create_Akron, 
		game::robo::Clone__Akron, 
		game::robo::Load___Akron
		);

	GAME_MANAGER.registerGameNodeClass( 
		"Krag", game::EGNT_PERSON, 
		game::robo::Alloc__Krag, 
		game::robo::Create_Krag, 
		game::robo::Clone__Krag, 
		game::robo::Load___Krag
		);
}

//----------------------------------------------------------------------------

//! 
extern "C" __MY_EXPORT__ void shutPlugin()
{
}

//----------------------------------------------------------------------------
} // end namespace wrap
} // end namespace game
} // end namespace my
//----------------------------------------------------------------------------