//|-------------------------------------------------------------------------
//| File:        CGameNodeAkron.h
//|
//| Descr:       This file is a part of the 'MyEngine'
//| Author:      Zhuk 'zdementor' Dmitry (aka ZDimitor)
//| Email:       zdimitor@pochta.ru, sibergames@nm.ru
//|
//|     Copyright (c) 2004-2009 by Zhuk Dmitry, Krasnoyarsk - Moscow
//|                      All Rights Reserved.
//|-------------------------------------------------------------------------
#ifndef CGameNodeAkronHPP
#define CGameNodeAkronHPP
//----------------------------------------------------------------------------

#include <game/IGameNodePerson.h>
#include <scn/ISceneNode.h>

//----------------------------------------------------------------------------
namespace my {
namespace game {
namespace robo {
//----------------------------------------------------------------------------

class CGameNodeAkron : public IGameNodePerson
{
	friend class CGameManager;

public:

	CGameNodeAkron(scn::ISceneNode* n, SGameNodeParams &params);
	virtual ~CGameNodeAkron();

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

};

//----------------------------------------------------------------------------
} // end namespace robo
} // end namespace game
} // end namespace my
//----------------------------------------------------------------------------

#endif // #ifndef CGameNodeAkronHPP