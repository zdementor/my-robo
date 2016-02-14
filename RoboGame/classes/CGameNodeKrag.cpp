//|-------------------------------------------------------------------------
//| File:        CGameNodeKrag.cpp
//|
//| Descr:       This file is a part of the 'MyEngine'
//| Author:      Zhuk 'zdementor' Dmitry (aka ZDimitor)
//| Email:       zdimitor@pochta.ru, sibergames@nm.ru
//|
//|     Copyright (c) 2004-2009 by Zhuk Dmitry, Krasnoyarsk - Moscow
//|                      All Rights Reserved.
//|-------------------------------------------------------------------------

#include "CGameNodeKrag.h"
#include <dev/IDevice.h>
#include <game/IGameTasksManager.h>
#include <io/ILogger.h>
#include <scn/ILightSceneNode.h>
#include <game/GameClassesRegistry.h>

//----------------------------------------------------------------------------
namespace my {
namespace game {
namespace robo {
//----------------------------------------------------------------------------

enum
{
	KRAG_STAND_IDLE = 0,
	KRAG_IDLE_ACTION,
	KRAG_WALK,
	KRAG_STAND_HIT,
	KRAG_STAND_SHOOT,

	KRAG_STANDING_UP,
	KRAG_SEATING_DOWN,
	KRAG_SEAT_HIT,
	KRAG_SEAT_SHOOT,

	KRAG_DEATH_A,
	KRAG_DEATH_B,
	KRAG_DEATH_C,

	KRAG_SEAT_DEATH_A,
	KRAG_SEAT_DEATH_B
};

//----------------------------------------------------------------------------

//! constructor
CGameNodeKrag::CGameNodeKrag(
	scn::ISceneNode* n, SGameNodeParams &params
	) :
IGameNodePerson(n, SGameNodeParams(params, EGNT_PERSON)), 
m_Standing(true)
{
#if MY_DEBUG_MODE 
	IGameNodePerson::setClassName("CGameNodeKrag");
#endif

	if (n)
	{ 
		//n->setDebugDataVisible(true);
	}
}

//----------------------------------------------------------------------------

//! destructor
CGameNodeKrag::~CGameNodeKrag()
{
}

//----------------------------------------------------------------------------

//! calling every time before doing adynamic
void CGameNodeKrag::OnPreDynamic(f64 delta_time_sec)
{
	IGameNodeAI::OnPreDynamic(delta_time_sec);		
}

//----------------------------------------------------------------------------

//! calling every time after doing dynamic
void CGameNodeKrag::OnPostDynamic(f64 delta_time_sec)
{
	IGameNodeAI::OnPostDynamic(delta_time_sec);

	if (isLive())
	{
		// setting current animation stand/walk

		s32 animation = m_SceneNode->getCurrentAnimation();

		s32 new_animation = animation;			

		if (getState()==EAIS_IDLE)
		{
			if (animation!=KRAG_IDLE_ACTION)
				new_animation = KRAG_STAND_IDLE;

			if (animation==KRAG_STAND_IDLE && m_StandingTimeMs>m_ParametersAI.StandReadyMaxTimeMs)
			{
				new_animation = KRAG_IDLE_ACTION;

				m_StandingTimeMs = 0;
			}
			else if (animation==KRAG_STAND_IDLE)
			{
				m_StandingTimeMs += m_DeltaTimeSec*1000;
			}
			else
			{
				m_StandingTimeMs = 0;
			}			
		}
		else 		
		if (getState()==EAIS_WAIT_A_TURN)
		{
			new_animation = KRAG_STAND_IDLE;
		}
		else
		if (getState()==EAIS_SEEKING)
		{
			new_animation = KRAG_WALK;	
		}

		if (animation != new_animation)
		{
			m_SceneNode->setCurrentAnimation(new_animation);
		}		
	}
}

//----------------------------------------------------------------------------

bool CGameNodeKrag::finishAttack(IGameNode* victim)
{
	IGameNodeAI::finishAttack(victim);

	s32 animation = m_SceneNode->getCurrentAnimation();

	if (!m_Standing)
	{
		if (animation!=KRAG_STANDING_UP && animation!=KRAG_SEAT_HIT)
		{
			m_SceneNode->setCurrentAnimation(KRAG_STANDING_UP);			
		}
	}
	else if (animation != KRAG_STAND_HIT)
	{	 
		return true;
	}

	return false;
}

//----------------------------------------------------------------------------

bool CGameNodeKrag::attack(bool can_mele_attack, IGameNode* victim)
{	
	s32 animation = m_SceneNode->getCurrentAnimation();

	// here we decide wich attack type we are want

	if (!can_mele_attack && victim->getMoveSpeed()<0.1f)
	{
		if (m_Standing)
		{
			if (animation != KRAG_SEATING_DOWN)
			{
				fireWeapon(false);

				m_SceneNode->setCurrentAnimation(KRAG_SEATING_DOWN);
			}
			
			return true;
		}				
	}

	if (can_mele_attack)
	{	
		fireWeapon(false);

		if (m_Standing && animation != KRAG_SEATING_DOWN)
		{
			if (animation != KRAG_STAND_HIT)
			{
				m_SceneNode->setCurrentAnimation(KRAG_STAND_HIT);
			}

			f32 ani_progr = getAnimationProgress();

			if (ani_progr>=0.1f && ani_progr<=0.9f)
			{
				SGameTaskHited *hittask = new SGameTaskHited(this, victim);
				hittask->HitPower = m_ParametersAI.MeleAttackDamage;	

				GAME_TASK_MANAGER.registerGameTask( hittask ); 
				
				setState(EAIS_FINISHING_ATTACK);
			}
		}
		else if (animation != KRAG_STANDING_UP && animation != KRAG_SEATING_DOWN)
		{
			if (animation != KRAG_SEAT_HIT)
			{
				m_SceneNode->setCurrentAnimation(KRAG_SEAT_HIT);
			}

			f32 ani_progr = getAnimationProgress();

			if (ani_progr>=0.1f && ani_progr<=0.9f)
			{
				SGameTaskHited *hittask = new SGameTaskHited(this, victim);
				hittask->HitPower = m_ParametersAI.MeleAttackDamage;	

				GAME_TASK_MANAGER.registerGameTask( hittask ); 	
				
				setState(EAIS_FINISHING_ATTACK);
			}
		}
	}
	else
	{	
		if (m_Standing && animation != KRAG_SEATING_DOWN)
		{	
			aimWeaponAtPos(victim->getTransformedBBoxCenter());

			if (animation != KRAG_STAND_SHOOT)
			{
				m_SceneNode->setCurrentAnimation(KRAG_STAND_SHOOT);					
			}

			bool with_delay = true;

			fireWeapon(true, with_delay);
		}
		else if (animation != KRAG_STANDING_UP && animation != KRAG_SEATING_DOWN)
		{
			aimWeaponAtPos(victim->getTransformedBBoxCenter());

			bool with_delay = false;

			if (animation != KRAG_SEAT_SHOOT)
			{
				m_SceneNode->setCurrentAnimation(KRAG_SEAT_SHOOT);	
				
				with_delay = true;
			}
			
			fireWeapon(true, with_delay);
		}
	}

	return true;
}

//----------------------------------------------------------------------------

//! die this game node
bool CGameNodeKrag::die() 
{
	if (!IGameNodeAI::die())
	{
		return false;		
	}

	if (m_Standing)
	{
		f32 a_idx = core::math::Random()%3;

		m_SceneNode->setCurrentAnimation(KRAG_DEATH_A+a_idx);
	}
	else
	{
		f32 a_idx = core::math::Random()%2;

		m_SceneNode->setCurrentAnimation(KRAG_SEAT_DEATH_A+a_idx);
	}

	return true;
}

//----------------------------------------------------------------------------

void CGameNodeKrag::OnAnimationEnd(scn::ISceneNode *node, u32 animation_idx)
{
	IGameNode::OnAnimationEnd(node, animation_idx);

	if (node != m_SceneNode || !GAME_MANAGER.isGameStarted())
		return;

	if ((animation_idx>=KRAG_DEATH_A && animation_idx<=KRAG_DEATH_C)
			|| (animation_idx>=KRAG_SEAT_DEATH_A && animation_idx<=KRAG_SEAT_DEATH_B))		
	{
		setState(EAIS_DEAD);
	}
	else 
	if (animation_idx==KRAG_IDLE_ACTION)
	{
		m_StandingTimeMs = 0;
		m_SceneNode->setCurrentAnimation(KRAG_STAND_IDLE);
	}
	else 
    if (animation_idx==KRAG_STAND_SHOOT)
    {
        setState(EAIS_FINISHING_ATTACK);
    }
	else 
    if (animation_idx==KRAG_STAND_HIT)
    {
        setState(EAIS_FINISHED_ATTACK);
    }
	else
	if (animation_idx==KRAG_SEATING_DOWN)
	{
		m_Standing = false;	
		m_SceneNode->setCurrentAnimation(KRAG_SEAT_SHOOT);
	}
	else
	if (animation_idx==KRAG_SEAT_HIT)
	{	
		m_SceneNode->setCurrentAnimation(KRAG_STANDING_UP);

		setState(EAIS_FINISHING_ATTACK);
	}
	else
	if (animation_idx==KRAG_STANDING_UP)
	{		
		m_Standing = true; 	       
	}
}

//----------------------------------------------------------------------------

//! Krag Person registry funcs

//----------------------------------------------------------------------------

IGameNode* Alloc__Krag(scn::ISceneNode* n, SGameNodeParams &params)
{
	return new CGameNodeKrag(n, params);
}

//----------------------------------------------------------------------------

CGameNodeBaseCreator KragCreator;

IGameNode* Create_Krag(SGameNodeCommonParams &node_params, bool log_info)
{
	return KragCreator.createGameNode(node_params, log_info);
}

//----------------------------------------------------------------------------

CGameNodeBaseCloner KragCloner;

IGameNode* Clone__Krag(IGameNode *game_node, bool log_info)
{
	return KragCloner.cloneGameNode(game_node, log_info);
}

//----------------------------------------------------------------------------

CGameNodeBaseLoader KragLoader;

IGameNode* Load___Krag(SGameNodeCommonParams &node_params, io::IReadFile* file)
{
	return KragLoader.loadGameNode(node_params, file);
}

//----------------------------------------------------------------------------
} // end namespace robo
} // end namespace game
} // end namespace my
//----------------------------------------------------------------------------
