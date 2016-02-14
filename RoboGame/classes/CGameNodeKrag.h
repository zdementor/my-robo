//|-------------------------------------------------------------------------
//| File:        CGameNodeKrag.h
//|
//| Descr:       This file is a part of the 'MyEngine'
//| Author:      Zhuk 'zdementor' Dmitry (aka ZDimitor)
//| Email:       zdimitor@pochta.ru, sibergames@nm.ru
//|
//|     Copyright (c) 2004-2009 by Zhuk Dmitry, Krasnoyarsk - Moscow
//|                      All Rights Reserved.
//|-------------------------------------------------------------------------
#ifndef CGameNodeKragHPP
#define CGameNodeKragHPP
//----------------------------------------------------------------------------

#include <game/IGameNodePerson.h>
#include <scn/ISceneNode.h>

//----------------------------------------------------------------------------
namespace my {
namespace game {
namespace robo {
//----------------------------------------------------------------------------

//! Game Node Class used as base class for all game nodes
class CGameNodeKrag : public IGameNodePerson
{
	friend class CGameManager;

public:

	CGameNodeKrag(scn::ISceneNode* n, SGameNodeParams &params);
	virtual ~CGameNodeKrag();

	virtual void OnPreDynamic(f64 delta_time_sec);
	virtual void OnPostDynamic(f64 delta_time_sec);

	virtual void OnAnimationEnd(scn::ISceneNode *node, u32 animation_idx);	

	virtual E_WAR_SIDE getWarSide()
	{ return EWS_ENEMY; }

protected:

	virtual bool finishAttack(IGameNode* victim);
	virtual bool attack(bool can_mele_attack, IGameNode* victim);	
	virtual bool die();

private:

	bool m_Standing;
	s32 m_SeatingTime;	
};

//----------------------------------------------------------------------------
} // end namespace robo
} // end namespace game
} // end namespace my
//----------------------------------------------------------------------------

#endif // #ifndef CGameNodeKragHPP