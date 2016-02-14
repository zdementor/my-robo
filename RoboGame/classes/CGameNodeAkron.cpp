//|-------------------------------------------------------------------------
//| File:        CGameNodeAkron.cpp
//|
//| Descr:       This file is a part of the 'MyEngine'
//| Author:      Zhuk 'zdementor' Dmitry (aka ZDimitor)
//| Email:       zdimitor@pochta.ru, sibergames@nm.ru
//|
//|     Copyright (c) 2004-2009 by Zhuk Dmitry, Krasnoyarsk - Moscow
//|                      All Rights Reserved.
//|-------------------------------------------------------------------------

#include "CGameNodeAkron.h"

#include <dev/IDevice.h>
#include <game/IGameTasksManager.h>
#include <io/ILogger.h>
#include <scn/ITestSceneNode.h>

#include <game/GameClassesRegistry.h>

//----------------------------------------------------------------------------
namespace my {
namespace game {
namespace robo {
//----------------------------------------------------------------------------

enum
{
	AKRON_STAND_IDLE = 0,
	AKRON_IDLE_ACTION,
	AKRON_WALK,
	AKRON_ATTACK_A,
	AKRON_ATTACK_B,
	AKRON_DEATH
};

//----------------------------------------------------------------------------

CGameNodeAkron::CGameNodeAkron(
	scn::ISceneNode* n, SGameNodeParams &params
	) :
IGameNodePerson(n, SGameNodeParams(params, EGNT_PERSON))
{
#if MY_DEBUG_MODE 
	IGameNodePerson::setClassName("CGameNodeAkron");
#endif

	if (n)
	{
		//n->setDebugDataVisible(true);
	}
}

//----------------------------------------------------------------------------

CGameNodeAkron::~CGameNodeAkron()
{
}

//----------------------------------------------------------------------------

void CGameNodeAkron::OnPreDynamic(f64 delta_time_sec)
{
	IGameNodeAI::OnPreDynamic(delta_time_sec);		
}

//----------------------------------------------------------------------------

void CGameNodeAkron::OnPostDynamic(f64 delta_time_sec)
{
	IGameNodeAI::OnPostDynamic(delta_time_sec);

	if (isLive())
	{
		// setting current animation stand/walk

		s32 animation = m_SceneNode->getCurrentAnimation();		
		s32 new_animation = animation;			

		if (getState()==EAIS_IDLE)
		{
			if (animation != AKRON_IDLE_ACTION)
				new_animation = AKRON_STAND_IDLE;

			if (animation==AKRON_STAND_IDLE && m_StandingTimeMs>m_ParametersAI.StandReadyMaxTimeMs)
			{
				f32 prob = core::math::UnitRandom();

				if (prob>0.5f)
				{
					new_animation = AKRON_IDLE_ACTION;
				}

				m_StandingTimeMs = 0;
			}
			else if (animation==AKRON_STAND_IDLE)
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
			new_animation = AKRON_STAND_IDLE;
		}
		else 
		if (getState()==EAIS_SEEKING)
		{
			new_animation = AKRON_WALK;	
		}

		if (animation != new_animation)
		{
			m_SceneNode->setCurrentAnimation(new_animation);
		}
	}		
}

//----------------------------------------------------------------------------

bool CGameNodeAkron::finishAttack(IGameNode* victim)
{
	IGameNodeAI::finishAttack(victim);

	s32 animation = m_SceneNode->getCurrentAnimation();

	if (animation==AKRON_ATTACK_A || animation==AKRON_ATTACK_B)
	{
		return false;
	}

	return true;
}

//----------------------------------------------------------------------------

bool CGameNodeAkron::attack(bool can_mele_attack, IGameNode* victim)
{
	s32 animation = m_SceneNode->getCurrentAnimation();

	if (can_mele_attack)
	{
		if (animation!=AKRON_ATTACK_A && animation!=AKRON_ATTACK_B)
		{
			f32 a_idx = core::math::Random()%2;

			m_SceneNode->setCurrentAnimation(AKRON_ATTACK_A+a_idx);
		}

		f32 ani_progr = getAnimationProgress();

		if (ani_progr>=0.1f && ani_progr<=0.9f)
		{
			SGameTaskHited *hittask = new SGameTaskHited(this, victim);
			hittask->HitPower = m_ParametersAI.MeleAttackDamage;	

			GAME_TASK_MANAGER.registerGameTask( hittask ); 			

			setState(EAIS_FINISHING_ATTACK);
		}
		
		return true;
	}

	return false;
}

//----------------------------------------------------------------------------

bool CGameNodeAkron::die() 
{	
	if (!IGameNodeAI::die())
	{
		return false;		
	}
	
	m_SceneNode->setCurrentAnimation(AKRON_DEATH);
	
	return true;
}

//----------------------------------------------------------------------------

void CGameNodeAkron::OnAnimationEnd(scn::ISceneNode *node, u32 animation_idx)
{
	IGameNode::OnAnimationEnd(node, animation_idx);

	if (node != m_SceneNode || !GAME_MANAGER.isGameStarted())
		return;

	if (animation_idx == AKRON_DEATH)
	{
		setState(EAIS_DEAD);
	}
	else
	if (animation_idx==AKRON_ATTACK_A || animation_idx==AKRON_ATTACK_B)
	{
		m_SceneNode->setCurrentAnimation(AKRON_STAND_IDLE);
	}
	else 
	if (animation_idx == AKRON_IDLE_ACTION)
	{
		m_StandingTimeMs = 0;

		m_SceneNode->setCurrentAnimation(AKRON_STAND_IDLE);
	}
}

//----------------------------------------------------------------------------

//! Akron Person registry funcs

//----------------------------------------------------------------------------

IGameNode* Alloc__Akron(scn::ISceneNode* n, SGameNodeParams &params)
{
	return new CGameNodeAkron(n, params);
}

//----------------------------------------------------------------------------

CGameNodeBaseCreator AkronCreator;

IGameNode* Create_Akron(SGameNodeCommonParams &node_params, bool log_info)
{
	return AkronCreator.createGameNode(node_params, log_info);
} 

//----------------------------------------------------------------------------

CGameNodeBaseCloner AkronCloner;

IGameNode* Clone__Akron(IGameNode *game_node, bool log_info)
{			  
	return AkronCloner.cloneGameNode(game_node, log_info);
}

//----------------------------------------------------------------------------

CGameNodeBaseLoader AkronLoader;

IGameNode* Load___Akron(SGameNodeCommonParams &node_params, io::IReadFile* file)
{
	return AkronLoader.loadGameNode(node_params, file);
}

//----------------------------------------------------------------------------
} // end namespace robo
} // end namespace game
} // end namespace my
//----------------------------------------------------------------------------
