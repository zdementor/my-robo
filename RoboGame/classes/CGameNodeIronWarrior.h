//|-------------------------------------------------------------------------
//| File:        CGameNodeIronWarrior.h
//|
//| Descr:       This file is a part of the 'MyEngine'
//| Author:      Zhuk 'zdementor' Dmitry (aka ZDimitor)
//| Email:       zdimitor@pochta.ru, sibergames@nm.ru
//|
//|     Copyright (c) 2004-2009 by Zhuk Dmitry, Krasnoyarsk - Moscow
//|                      All Rights Reserved.
//|-------------------------------------------------------------------------
#ifndef CGameNodeIronWarriorHPP
#define CGameNodeIronWarriorHPP
//----------------------------------------------------------------------------

#include <game/IGameNodeMainPlayer.h>
#include <game/IGameNodeWeapon.h>

//----------------------------------------------------------------------------
namespace my {
namespace game {
namespace robo {
//----------------------------------------------------------------------------

enum E_CAMERA_TYPE
{
	ECT_ALIEN_SHOOTER_3D=0,
	ECT_CRIMSONLAND,
	ECT_SHADOW_GROUND
};

//----------------------------------------------------------------------------

class CGameNodeIronWarrior :
	public IGameNodeMainPlayer, public scn::ICameraController
{

public:

	CGameNodeIronWarrior(scn::ISceneNode* n, SGameNodeParams &params);
	virtual ~CGameNodeIronWarrior();

	virtual bool pushInDir(core::vector3df dir,   f32 speed = 1.0f);

	virtual bool isGaming()
	{
		if (IGameManager::getSingleton().getMainPlayerGameNode()==this)
			return true;
		return	IGameNodeAI::isGaming();
	}

	virtual void OnPreDynamic(f64 delta_time_sec);
	virtual void OnPostDynamic(f64 delta_time_sec);

    virtual void OnPreGame(s32 now_time_ms);
    virtual void OnPostGame(s32 now_time_ms);

	virtual void OnAnimationEnd(scn::ISceneNode *node, u32 animation_idx);

	virtual E_WAR_SIDE getWarSide()
	{ return EWS_FRIEND; }

	virtual void addCameraStyle(const SGameCameraStyle& style);
	virtual bool setCameraStyle(const c8* name);

	//! Implementation of the ICameraController
	virtual void animate(scn::ICameraSceneNode *camera, u32 timeMs);
	virtual void reset() {}

protected:

	virtual bool die();

private:

	s32 m_TryToFire;

	s32 m_FootSteps;
	u32 m_FootStepProgress;

	core::math::li2df m_WalkSoundSpeedKoeff;

	core::position2d<f32>  m_CursorCurrentPos;  
	core::dimension2d<s32> m_EtalonScrSize;

	f32 m_DistNow, m_Dist; 

	core::vector3df m_Rotations;

	E_CAMERA_TYPE m_CameraType;

	core::line3df m_AimRay;
	core::vector3df m_AimPos;

	s32 m_LastTime;

	core::filter<f32, 16, 0, 0> m_CameraFilterPosX;
	core::filter<f32, 16, 0, 0> m_CameraFilterPosY;
	core::filter<f32, 16, 0, 0> m_CameraFilterPosZ;

	core::filter<f32, 16, 0, 0> m_CameraFilterLookX;
	core::filter<f32, 16, 0, 0> m_CameraFilterLookY;
	core::filter<f32, 16, 0, 0> m_CameraFilterLookZ;

	f32 m_KMovSpdCollid, m_KRotSpdCollid;
	f32 m_KMovSpdNoCollid, m_KRotSpdNoCollid;

	core::array <scn::SPathCell> m_AimCellLine;

	core::vector3df m_CamPos, m_CamLookAt;
	f32 m_NearValue, m_FarValue, m_FOV;
	core::dimension2df m_ViewVolume;
};

//----------------------------------------------------------------------------
} // end namespace robo
} // end namespace game
} // end namespace my
//----------------------------------------------------------------------------

#endif // #ifndef CGameNodeIronWarriorHPP