//|-------------------------------------------------------------------------
//| File:        CGameNodeIronWarrior.cpp
//|
//| Descr:       This file is a part of the 'MyEngine'
//| Author:      Zhuk 'zdementor' Dmitry (aka ZDimitor)
//| Email:       zdimitor@pochta.ru, sibergames@nm.ru
//|
//|     Copyright (c) 2004-2009 by Zhuk Dmitry, Krasnoyarsk - Moscow
//|                      All Rights Reserved.
//|-------------------------------------------------------------------------

#include "CGameNodeIronWarrior.h"

#include <dev/IDevice.h>
#include <game/IGameTasksManager.h>
#include <io/ILogger.h>
#include <os/ITimer.h>
#include <io/IInputDispatcher.h>
#include <mm/ISoundDriver.h>
#include <mm/ISound.h>
#include <scn/ISceneNode.h>
#include <game/IGameNodeWeapon.h>
#include <scn/ISceneManager.h>
#include <scn/ILightSceneNode.h>
#include <io/ICursorControl.h>
#include <scn/ICameraSceneNode.h>
#include <dyn/IDynamicManager.h>
#include <scn/IPathFinderManager.h>
#include <scn/IPathFinder.h>

#include <game/GameClassesRegistry.h>

//----------------------------------------------------------------------------
namespace my {
namespace game {
namespace robo {
//----------------------------------------------------------------------------

enum 
{
	IRON_WARRIOR_STAND_IDLE = 0,
	IRON_WARRIOR_STAND_IDLE_ACTION,
	IRON_WARRIOR_STAND_READY,
	IRON_WARRIOR_STAND_SHOOT,

	IRON_WARRIOR_WALK_FORWARD_SHOOT,
	IRON_WARRIOR_WALK_STRAFE_LEFT_FORWARD_SHOOT,  
	IRON_WARRIOR_WALK_STRAFE_RIGHT_FORWARD_SHOOT,
	IRON_WARRIOR_WALK_STRAFE_LEFT_SHOOT,  
	IRON_WARRIOR_WALK_STRAFE_RIGHT_SHOOT,
	IRON_WARRIOR_WALK_BACK_SHOOT,
	IRON_WARRIOR_WALK_STRAFE_LEFT_BACK_SHOOT,
	IRON_WARRIOR_WALK_STRAFE_RIGHT_BACK_SHOOT,

	IRON_WARRIOR_RUN_FORWARD,
	IRON_WARRIOR_RUN_STRAFE_LEFT_FORWARD, 
	IRON_WARRIOR_RUN_STRAFE_RIGHT_FORWARD,
	IRON_WARRIOR_RUN_STRAFE_LEFT, 
	IRON_WARRIOR_RUN_STRAFE_RIGHT,
	IRON_WARRIOR_RUN_BACK,
	IRON_WARRIOR_RUN_STRAFE_LEFT_BACK, 
	IRON_WARRIOR_RUN_STRAFE_RIGHT_BACK,

	IRON_WARRIOR_DEATH_A,
	IRON_WARRIOR_DEATH_B,
	IRON_WARRIOR_DEATH_C,
	IRON_WARRIOR_DEATH_D,

	E_IRON_WARRIOR_ANIMATION_COUNT
};

//----------------------------------------------------------------------------

s32 SELECT_NEXT_WEAPON_SOUND = 4;
s32 SELECT_PREV_WEAPON_SOUND = 5;

#define MIN_KSPD 0.01f

//----------------------------------------------------------------------------

CGameNodeIronWarrior::CGameNodeIronWarrior( 
	scn::ISceneNode* n, SGameNodeParams &params) : 
IGameNodeMainPlayer(n, SGameNodeParams(params, EGNT_MAIN_PLAYER)), 
m_FootSteps(0), m_FootStepProgress(-1), m_EtalonScrSize(1024,768),
m_DistNow(0), m_Dist(0), m_CameraType(ECT_SHADOW_GROUND), m_LastTime(0),
m_AimPos(0.f, 0.f, 0.f),
m_CamPos(0.f, 0.f, 0.f),
m_CamLookAt(1.f, 0.f, 0.f),
m_NearValue(1.f),
m_FarValue(1000.f),
m_FOV(1.f),
m_ViewVolume(0.f, 0.f)
{
#if MY_DEBUG_MODE 
	IGameNodeMainPlayer::setClassName("CGameNodeIronWarrior IGameNodeMainPlayer");	
	scn::ICameraController::setClassName("CGameNodeIronWarrior ICameraController");	
#endif	

	m_WalkSoundSpeedKoeff.init(1.0f, 10.0f, 1.2f, 5.0f);

	//m_SceneNode->setDebugDataVisible(true);

	m_CursorCurrentPos = CURSOR_CONTROL.getRelativePosition();

	m_KMovSpdCollid = m_KRotSpdCollid =
		m_KMovSpdNoCollid = m_KRotSpdNoCollid = MIN_KSPD;
	
	scn::ICameraSceneNode *camera = m_SceneNode->getCamera();
	setAutoCaptureInput(false);
	if (camera)
		camera->setCustomController(this);
}

//----------------------------------------------------------------------------

CGameNodeIronWarrior::~CGameNodeIronWarrior()
{
}

//----------------------------------------------------------------------------

bool CGameNodeIronWarrior::pushInDir(core::vector3df dir, f32 speed)
{
	if (!isLive())
		return false;;

	CHECK_RANGE(speed, 0.0f, 1.0f);

	dir.normalize();

	s32 now = TIMER.getTime();
	s32 animation = m_SceneNode->getCurrentAnimation();
	s32 new_animation = animation % E_IRON_WARRIOR_ANIMATION_COUNT;	
	f32 switch_animation_time = 0.3f;
		
	// changing weapon 

	s32 weapon_select = 0;

	if (getActionControlState(game::EGA_SELECT_PREV_WEAPON))
	{
		resetActionControlState(game::EGA_SELECT_PREV_WEAPON);
		s32 sel_wpn = getSelectedWeaponNumber();
		selectPrevWeapon();	
		if (sel_wpn != getSelectedWeaponNumber())
			playSoundEffect(SELECT_PREV_WEAPON_SOUND);			
		switch_animation_time = m_WeaponParameters.SelectSpeed / 1000.0f;
	}
	else
	if (getActionControlState(game::EGA_SELECT_NEXT_WEAPON))
	{
		resetActionControlState(game::EGA_SELECT_NEXT_WEAPON);
		s32 sel_wpn = getSelectedWeaponNumber();
		selectNextWeapon();	
		if (sel_wpn != getSelectedWeaponNumber())
			playSoundEffect(SELECT_NEXT_WEAPON_SOUND);	
		switch_animation_time = m_WeaponParameters.SelectSpeed / 1000.0f;
	}
	else if (
		getActionControlState((E_GAME_ACTION)(weapon_select=EGA_SELECT_WEAPON_0)) ||
		getActionControlState((E_GAME_ACTION)(weapon_select=EGA_SELECT_WEAPON_1)) ||
		getActionControlState((E_GAME_ACTION)(weapon_select=EGA_SELECT_WEAPON_2)))
	{
		s32 sel_wpn = getSelectedWeaponNumber();
		selectWeapon(weapon_select-game::EGA_SELECT_WEAPON_0);
		s32 sel_wpn_now = getSelectedWeaponNumber();
		if (sel_wpn_now>sel_wpn)
			playSoundEffect(SELECT_NEXT_WEAPON_SOUND);	
		else if (sel_wpn_now<sel_wpn)
			playSoundEffect(SELECT_PREV_WEAPON_SOUND);	
		switch_animation_time = m_WeaponParameters.SelectSpeed / 1000.0f;
	}

	// shooting weapon

	fireWeapon(m_PrepareForFiring || (m_Firing && !m_WeaponFired)
		|| getActionControlState(game::EGA_ATTACK_PRIMARY));

	// other controls

	bool forward	= getActionControlState(game::EGA_MOVE_FORWARD);
	bool backward	= getActionControlState(game::EGA_MOVE_BACKWARD);
	bool srafeleft	= getActionControlState(game::EGA_MOVE_LEFT_STRAFE);
	bool sraferight	= getActionControlState(game::EGA_MOVE_RIGHT_STRAFE);

	if ((forward && backward) || (srafeleft && sraferight) || 
			!(forward||backward||srafeleft||sraferight))
	{
		if (m_Firing || m_PrepareForFiring) new_animation = IRON_WARRIOR_STAND_SHOOT; 
		else                                new_animation = IRON_WARRIOR_STAND_READY;
	}
	else 
	{
		if (m_CameraType==ECT_ALIEN_SHOOTER_3D || m_CameraType==ECT_CRIMSONLAND)
		{
			core::vector3df look_dir = getLookDir();
			core::vector3df right_dir = getRightDir();
			f32 angle_look = look_dir.getAngleDeg(dir);
			f32 angle_right = right_dir.getAngleDeg(dir);

			if (angle_look<22.5f)
			{
				if (m_Firing || m_PrepareForFiring)
					new_animation = IRON_WARRIOR_WALK_FORWARD_SHOOT; 
				else
					new_animation = IRON_WARRIOR_RUN_FORWARD; 		
			}
			else if (angle_look<67.5f)
			{
				if (angle_right>90.0f)
				{
					if (m_Firing || m_PrepareForFiring)
						new_animation = IRON_WARRIOR_WALK_STRAFE_LEFT_FORWARD_SHOOT; 
					else
						new_animation = IRON_WARRIOR_RUN_STRAFE_LEFT_FORWARD;
				}
				else
				{
					if (m_Firing || m_PrepareForFiring)
						new_animation = IRON_WARRIOR_WALK_STRAFE_RIGHT_FORWARD_SHOOT; 
					else
						new_animation = IRON_WARRIOR_RUN_STRAFE_RIGHT_FORWARD;
				}
			}
			else if (angle_look<112.5f)
			{
				if (angle_right>90.0f)
				{
					if (m_Firing || m_PrepareForFiring)
						new_animation = IRON_WARRIOR_WALK_STRAFE_LEFT_SHOOT; 
					else
						new_animation = IRON_WARRIOR_RUN_STRAFE_LEFT; 
				}
				else
				{
					if (m_Firing || m_PrepareForFiring)
						new_animation = IRON_WARRIOR_WALK_STRAFE_RIGHT_SHOOT; 
					else
						new_animation = IRON_WARRIOR_RUN_STRAFE_RIGHT; 
				}
			}
			else if (angle_look<154.5f)
			{
				if (angle_right>90.0f)
				{
					if (m_Firing || m_PrepareForFiring)
						new_animation = IRON_WARRIOR_WALK_STRAFE_LEFT_BACK_SHOOT; 
					else
						new_animation = IRON_WARRIOR_RUN_STRAFE_LEFT_BACK;
				}
				else
				{
					if (m_Firing || m_PrepareForFiring)
						new_animation = IRON_WARRIOR_WALK_STRAFE_RIGHT_BACK_SHOOT; 
					else
						new_animation = IRON_WARRIOR_RUN_STRAFE_RIGHT_BACK;
				}
			}
			else
			{
				if (m_Firing || m_PrepareForFiring)
					new_animation = IRON_WARRIOR_WALK_BACK_SHOOT; 
				else
					new_animation = IRON_WARRIOR_RUN_BACK;
			}
		}
		else
		{
			if (forward &&	srafeleft)
			{
				if (m_Firing || m_PrepareForFiring)
					new_animation = IRON_WARRIOR_WALK_STRAFE_LEFT_FORWARD_SHOOT; 
				else
					new_animation = IRON_WARRIOR_RUN_STRAFE_LEFT_FORWARD; 			
			}
			else if (forward &&	sraferight)
			{
				if (m_Firing || m_PrepareForFiring)
					new_animation = IRON_WARRIOR_WALK_STRAFE_RIGHT_FORWARD_SHOOT; 
				else
					new_animation = IRON_WARRIOR_RUN_STRAFE_RIGHT_FORWARD; 				
			}
			else if (forward && !backward)
			{
				if (m_Firing || m_PrepareForFiring)
					new_animation = IRON_WARRIOR_WALK_FORWARD_SHOOT; 
				else
					new_animation = IRON_WARRIOR_RUN_FORWARD; 		
			}
			else if (backward && srafeleft)
			{
				if (m_Firing || m_PrepareForFiring)
					new_animation = IRON_WARRIOR_WALK_STRAFE_LEFT_BACK_SHOOT; 
				else
					new_animation = IRON_WARRIOR_RUN_STRAFE_LEFT_BACK; 			
			}
			else if (backward && sraferight)
			{
				if (m_Firing || m_PrepareForFiring)
					new_animation = IRON_WARRIOR_WALK_STRAFE_RIGHT_BACK_SHOOT; 
				else
					new_animation = IRON_WARRIOR_RUN_STRAFE_RIGHT_BACK; 				
			}
			else if (!forward && backward)
			{
				if (m_Firing || m_PrepareForFiring)
					new_animation = IRON_WARRIOR_WALK_BACK_SHOOT; 
				else
					new_animation = IRON_WARRIOR_RUN_BACK; 			
			}
			else if (srafeleft && !sraferight)
			{
				if (m_Firing || m_PrepareForFiring)
					new_animation = IRON_WARRIOR_WALK_STRAFE_LEFT_SHOOT; 
				else
					new_animation = IRON_WARRIOR_RUN_STRAFE_LEFT; 
			}				
			else if (!srafeleft && sraferight)
			{
				if (m_Firing || m_PrepareForFiring)
					new_animation = IRON_WARRIOR_WALK_STRAFE_RIGHT_SHOOT; 
				else
					new_animation = IRON_WARRIOR_RUN_STRAFE_RIGHT; 		
			}	
		}
	}
	
	bool need_to_play_walk_step = false;

	if (!m_Firing && new_animation >= IRON_WARRIOR_WALK_FORWARD_SHOOT &&
			new_animation <= IRON_WARRIOR_RUN_STRAFE_RIGHT_BACK)
		need_to_play_walk_step = true;			

	static bool last_need_to_play_walk_step = need_to_play_walk_step;
	static s32 time_ms = 0;

	if (last_need_to_play_walk_step!= need_to_play_walk_step)
	{     
		if (need_to_play_walk_step)
			time_ms = TIMER.getSystemTime();
	}  

	last_need_to_play_walk_step = need_to_play_walk_step;

	if (new_animation==IRON_WARRIOR_STAND_IDLE || 
			new_animation==IRON_WARRIOR_STAND_READY || 
			new_animation==IRON_WARRIOR_STAND_IDLE_ACTION)
		m_StandingTimeMs += m_DeltaTimeSec*1000;
	else
		m_StandingTimeMs = 0;

	if (m_StandingTimeMs>m_ParametersAI.StandReadyMaxTimeMs)
	{
		if (m_StandingTimeMs>3*m_ParametersAI.StandReadyMaxTimeMs)
		{
			if (new_animation!=IRON_WARRIOR_STAND_IDLE_ACTION)
				new_animation = IRON_WARRIOR_STAND_IDLE_ACTION;
		}
		else
			new_animation = IRON_WARRIOR_STAND_IDLE;			
	}

	if (m_SelectedWeaponNumber != -1)
		new_animation += m_SelectedWeaponNumber*E_IRON_WARRIOR_ANIMATION_COUNT;			

	if (animation != new_animation)
	{
		m_SceneNode->setCurrentAnimation(new_animation, switch_animation_time);
		m_FootSteps = 0;
	}		
	
	if (need_to_play_walk_step)
	{
		u32 progress = m_SceneNode->getCurrentAnimationProgress() / 0.25;
		if (m_FootStepProgress != progress && (progress == 0 || progress == 2))
		{
			m_FootStepProgress = progress;
			m_FootSteps++;
			m_FootSteps = m_FootSteps % 4;				
			playSoundEffect(m_FootSteps);	
		}
	}
	
	speed = (m_Firing || m_PrepareForFiring) ? (0.5f*speed) : (speed);

	return IGameNodeAI::pushInDir(dir, speed);		
}

//----------------------------------------------------------------------------

void CGameNodeIronWarrior::OnPreDynamic(f64 delta_time_sec)
{
	IGameNodeAI::OnPreDynamic(delta_time_sec);

	scn::ISceneManager &smgr = SCENE_MANAGER;   

	scn::ICameraSceneNode *camera = m_SceneNode->getCamera();
	if (!isLive() || !camera || smgr.getActiveCamera()!=camera)
		return;

	captureInput();

	// movement

	bool forward   = getActionControlState(game::EGA_MOVE_FORWARD);
	bool backward  = getActionControlState(game::EGA_MOVE_BACKWARD);
	bool srafeleft = getActionControlState(game::EGA_MOVE_LEFT_STRAFE);
	bool sraferight= getActionControlState(game::EGA_MOVE_RIGHT_STRAFE);

	core::vector3df forward_vec, left;

	if (m_CameraType == ECT_ALIEN_SHOOTER_3D ||
			m_CameraType == ECT_CRIMSONLAND)
	{
		forward_vec.set(0.f, 0.f, 1.f);
		left.set(-1.f, 0.f, 0.f);

		if (m_CameraType==ECT_CRIMSONLAND)
		{
			forward_vec.set(-1,0,1);
			left.set(-1,0,-1);
		}
	}
	else
	{
		forward_vec = camera->getTarget() - camera->getPosition();
		forward_vec.Y = 0;
		left = forward_vec.getCrossProduct(camera->getUpVector());
	    
		forward_vec = forward_vec.normalize();
		left = left.normalize();
	}

	core::vector3df movement(0.f, 0.f, 0.f);
	if		(forward && srafeleft)		movement = forward_vec+left;
	else if	(forward && sraferight)		movement = forward_vec-left;
	else if (backward && srafeleft)		movement = left-forward_vec;
	else if (backward && sraferight)	movement = (forward_vec*-1)-left;
	else if (forward)					movement = forward_vec;  
	else if (backward)					movement = forward_vec*(-1.0f);
	else if (srafeleft)					movement = left;   
	else if (sraferight)				movement = left*(-1.0f);
	movement.normalize();  

	pushInDir(movement);

	if (m_CameraType==ECT_ALIEN_SHOOTER_3D || m_CameraType==ECT_CRIMSONLAND)
		orientInHorizDir(m_Rotations);        
}

//----------------------------------------------------------------------------

void CGameNodeIronWarrior::OnPostDynamic(f64 delta_time_sec)
{	
	IGameNodeAI::OnPostDynamic(delta_time_sec);
}

//----------------------------------------------------------------------------

void CGameNodeIronWarrior::OnPreGame(s32 now_time_ms)
{
	IGameNode::OnPreGame(now_time_ms);

	core::vector3df player_pos = getDislocation();
	const SGameCameraStyle& cam_style = getCurrentCameraStyle();

	io::IInputDispatcher &inpd		= INPUT_DISPATCHER;
	io::ICursorControl   &cursor	= CURSOR_CONTROL;
	vid::IVideoDriver    &driver	= VIDEO_DRIVER;   
	scn::ISceneManager   &smgr		= SCENE_MANAGER;   

	scn::ICameraSceneNode *camera = m_SceneNode->getCamera();
	if (!camera || smgr.getActiveCamera()!=camera)
		return;

	// aiming weapon

	core::position2di cpos = CURSOR_CONTROL.getPosition() +
        CURSOR_CONTROL.getPositionOffset();

    m_AimRay = smgr.getRayFromScreenCoordinates(cpos);
	
	core::vector3df ray_vec = m_AimRay.getVector();
	core::plane3df floor_plane(player_pos, core::vector3df(0,1,0));  
	CHECK_MAX_RANGE(ray_vec.Y, -0.001f);        		
	floor_plane.getIntersectionWithLine(m_AimRay.start, ray_vec, m_AimPos);

    aimWeaponByRay(m_AimRay);

	// Create rotation angles

	core::position2d<f32> cursorpos = cursor.getRelativePosition();
     
    f32 rotX = (m_CursorCurrentPos.X - cursorpos.X);
    f32 rotY = (m_CursorCurrentPos.Y - cursorpos.Y);  	

    core::dimension2d<s32> scr_size = driver.getScreenSize();   

    f32 hk = (f32)scr_size.Height/(f32)m_EtalonScrSize.Height;
    f32 wk = (f32)scr_size.Width /(f32)m_EtalonScrSize.Width;

	rotX *= 10.f * hk * cursor.getSensitivity()*cam_style.MouseSenseX;
	rotY *= 10.f * wk * cursor.getSensitivity()*cam_style.MouseSenseY;

	// rotation

	if (m_CameraType == ECT_ALIEN_SHOOTER_3D || m_CameraType == ECT_CRIMSONLAND)
	{
		m_Rotations.set(m_AimPos - player_pos);  
		m_Rotations.normalize();
		m_Rotations.Y=0;
	}
	else
	{	
		m_Rotations.set(0, rotX,0);
	}

	m_CursorCurrentPos.X -= rotX;
	m_CursorCurrentPos.Y -= rotY;

	CHECK_RANGE(m_CursorCurrentPos.X, cam_style.getCursorLockRect().Left,
		cam_style.getCursorLockRect().Right);	
	CHECK_RANGE(m_CursorCurrentPos.Y, cam_style.getCursorLockRect().Top,
		cam_style.getCursorLockRect().Bottom);

    cursor.setRelativePosition( m_CursorCurrentPos );    
	
	m_CursorCurrentPos = cursor.getRelativePosition();
}

//----------------------------------------------------------------------------

void CGameNodeIronWarrior::OnPostGame(s32 now_time_ms)
{	
	IGameNode::OnPostGame(now_time_ms);

	scn::ISceneManager &smgr   = SCENE_MANAGER; 

	scn::ICameraSceneNode *camera = m_SceneNode->getCamera();
    if (!camera || smgr.getActiveCamera()!=camera)
        return;

	if (isLive() && m_CameraType == ECT_SHADOW_GROUND)
	{   
		orientByAngles(m_Rotations*(-1.0f));
		m_Rotations.set(0, 0, 0);
	}

    s32 delta_time = m_LastTime?(now_time_ms-m_LastTime):(m_DeltaTimeSec*1000);
    m_LastTime = now_time_ms;
    
    io::ICursorControl		&cursor = CURSOR_CONTROL;
    vid::IVideoDriver		&driver = VIDEO_DRIVER;
	dyn::IDynamicManager	&dynmgr = DYNAMIC_MANAGER;
	scn::IPathFinderManager	&pfinder= PATH_FINDER_MANAGER;

    const SGameCameraStyle	&cam_style = getCurrentCameraStyle(); 

    core::vector3df player_pos = getDislocation();

	core::dimension2df scrSize;
	scrSize = driver.getScreenSize();

    //////////////////////////////////////////////////////////
    //               Animate camera
    //////////////////////////////////////////////////////////    

    // ( assumes the camera is NOT a child of the player node )

    // Zoom only if one or other button is pressed

	f32 kZoomSpd= cam_style.ZoomSpeed		* 0.00010f * delta_time;
	f32 kRotSpd	= cam_style.RotationSpeed	* 0.00050f * delta_time;
	f32 kMovSpd	= cam_style.MoveSpeed		* 0.00025f * delta_time;

	f32 kkRotMovSpd = 0.25f * delta_time;

	const core::rectf &active_rect = cam_style.getCursorActiveRect();
	const core::rectf &lock_rect = cam_style.getCursorLockRect();

	static core::position2df cur_cpos = m_CursorCurrentPos;

	if (m_CameraAutoZoom)
	{
		core::position2df lock_center(0.5f, 0.5f);
		f32 ampl_val = 0.5f;

		if (m_CameraType==ECT_ALIEN_SHOOTER_3D || m_CameraType==ECT_CRIMSONLAND)
		{
			lock_center = smgr.getScreenCoordinatesFrom3DPosition(player_pos);
			lock_center.X /= scrSize.Width;
			lock_center.Y /= scrSize.Height;
		}

		core::vector2df centerOffs(
			m_CursorCurrentPos.X - lock_center.X,
			m_CursorCurrentPos.Y - lock_center.Y);
		f32 offset = centerOffs.getLength();

		if (m_CameraType==ECT_ALIEN_SHOOTER_3D || m_CameraType==ECT_CRIMSONLAND)
		{
			core::vector2df amplitude(
				lock_rect.Right - lock_center.X,
				lock_rect.Bottom - lock_center.Y);

			if ((lock_center.X - lock_rect.Left) > amplitude.X)
				amplitude.X = lock_center.X - lock_rect.Left;
			if (lock_center.Y - lock_rect.Top > amplitude.Y)
				amplitude.Y = lock_center.Y - lock_rect.Top;
			ampl_val = amplitude.X < amplitude.Y ? amplitude.X : amplitude.Y;
		}
		
		CHECK_RANGE(offset, 0.0f, ampl_val);
		f32 curZoomValue = offset / ampl_val;

		if (m_CameraType==ECT_ALIEN_SHOOTER_3D || m_CameraType == ECT_CRIMSONLAND)
		{
			if (!core::math::Equals(m_CameraZoomValue, curZoomValue))
			{
				if (m_CameraZoomValue < curZoomValue)
				{
					m_CameraZoomValue +=  kZoomSpd;
					CHECK_MAX_RANGE(m_CameraZoomValue, curZoomValue);
				}
				else
				{
					m_CameraZoomValue -= kZoomSpd;
					CHECK_MIN_RANGE(m_CameraZoomValue, curZoomValue);
				}
			}
		}
		else
		{
			m_CameraZoomValue = curZoomValue;
		}
	}
	else
	{        
		bool zoom_in  = getActionControlState(game::EGA_VIEW_ZOOM_IN);     
		bool zoom_out = getActionControlState(game::EGA_VIEW_ZOOM_OUT);
		if((zoom_in && !zoom_out) || (!zoom_in && zoom_out))
		{
			s32 dir = (zoom_in) ? -1 : 1;
			m_CameraZoomValue    += dir * kZoomSpd;
		} 
	}
	CHECK_RANGE(m_CameraZoomValue, 0.0f, 1.0f);

	m_Dist = cam_style.MinZoomValue +
		(cam_style.MaxZoomValue - cam_style.MinZoomValue) * m_CameraZoomValue;
	m_DistNow = m_Dist;  

    // Ensure Distance is bounded correctly   
   
    core::matrix4 player_transf = getTransformation();
    core::vector3df cam_pos, cam_lookat;

	SCameraState cam_state;

    if (m_CameraType == ECT_ALIEN_SHOOTER_3D || m_CameraType == ECT_CRIMSONLAND)
    {
		core::position2df cpos = m_CursorCurrentPos;

		core::vector2df pointsw[] = {
			core::vector2df(0,					lock_rect.Left),
			core::vector2df(lock_rect.Left,		lock_rect.Left),
			core::vector2df(active_rect.Left,	cur_cpos.X),
			core::vector2df(active_rect.Right,	cur_cpos.X),
			core::vector2df(lock_rect.Right,	lock_rect.Right),
			core::vector2df(1,					lock_rect.Right)};
		core::vector2df pointsh[] = {
			core::vector2df(0,					lock_rect.Top),
			core::vector2df(lock_rect.Top,		lock_rect.Top),
			core::vector2df(active_rect.Top,	cur_cpos.Y),
			core::vector2df(active_rect.Bottom,	cur_cpos.Y),
			core::vector2df(lock_rect.Bottom,	lock_rect.Bottom),
			core::vector2df(1,					lock_rect.Bottom)};

        core::math::pli2df liw(pointsw, sizeof(pointsw) / sizeof(*pointsw));
		core::math::pli2df lih(pointsh, sizeof(pointsw) / sizeof(*pointsh));

        cpos.set(
			liw.getValue(m_CursorCurrentPos.X),
			lih.getValue(m_CursorCurrentPos.Y));

		static f32 centerInterpK = 1.0f;

		core::position2df pos_delta = cpos - cur_cpos;
		f32 kinterp_delta = 0.0f;

        cam_state = cam_style.getState(cur_cpos, m_Dist, centerInterpK);
        cam_lookat = cam_state.LookatTranslation + player_pos;
        cam_pos.set(0, m_DistNow, 0);   
        player_transf.transformVect(cam_pos);
        cam_pos += cam_state.PositionTranslation;

		if (m_CameraType == ECT_ALIEN_SHOOTER_3D)
		{
			core::vector2df lock_center = lock_rect.getCenter();
			core::line2df cursor_line(lock_center, cpos);
			bool next_cpos_found = true;

			core::vector2df next_cpos	= cpos;
			f32 next_kinterp= 1.0f;

			const core::aabbox3df &tbb = getTransformedBBox();
			f32 player_height = tbb.MaxEdge.Y - tbb.MinEdge.Y;
			core::vector3df player_center = getTransformedBBoxCenter();

			core::vector3df aim_pos(m_AimPos);
			pfinder.validatePositionToGround(aim_pos);
			
			core::array <scn::SPathCell> &aim_cell_line = m_AimCellLine;

			pfinder.getPathCellLine(player_center, aim_pos, aim_cell_line);

			s32 c = 0, accnt = aim_cell_line.size();
			u32 cullcell = 0, nocullcell = 0;
			while (c < accnt)
			{
				core::line3df ray(aim_cell_line[c].Position, cam_pos);
				if (pfinder.checkIntersectionWithRay(ray))
					cullcell++;
				else
					nocullcell++;
				if (!aim_cell_line[c].Walkable)
					break;
				c++;
			}

			core::line3df ray(player_center, cam_pos);
			bool collided = pfinder.checkIntersectionWithRay(ray);

			if (cullcell == 0 && !collided)
			{
				// simulating next camera animation step
				core::vector2df _next_cpos = cpos;
				f32 _next_kinterp = 1.0f;
				core::vector2df _cur_cpos = cur_cpos;
				f32 _centerInterpK = centerInterpK;
				core::vector2df _pos_delta = _next_cpos - _cur_cpos;
				f32 _kinterp_delta = _next_kinterp - _centerInterpK;

				CHECK_RANGE(_pos_delta.X, -1.0f, 1.0f);
				CHECK_RANGE(_pos_delta.Y, -1.0f, 1.0f);
				_pos_delta *= 1.0f * kMovSpd;

				CHECK_RANGE(_kinterp_delta, -1.0f, 1.0f);
				_kinterp_delta *= 1.0f * kRotSpd;

				_cur_cpos		+= _pos_delta;
				_centerInterpK	+= _kinterp_delta;

				cam_state = cam_style.getState(_cur_cpos, m_Dist, _centerInterpK);
				cam_lookat = cam_state.LookatTranslation + player_pos;
				cam_pos.set(0, m_DistNow, 0);   
				player_transf.transformVect(cam_pos);
				cam_pos += cam_state.PositionTranslation;

				ray.end = cam_pos;
				collided = pfinder.checkIntersectionWithRay(ray);
				
				if (collided)
				{
					next_cpos	= cur_cpos;
					next_kinterp= centerInterpK;

					m_KMovSpdCollid *= 2.0f * kkRotMovSpd;
					m_KRotSpdCollid *= 2.0f * kkRotMovSpd;

					m_KMovSpdNoCollid = MIN_KSPD;
					m_KRotSpdNoCollid = MIN_KSPD;

					CHECK_RANGE(m_KMovSpdCollid, MIN_KSPD, 1.0f);
					CHECK_RANGE(m_KRotSpdCollid, MIN_KSPD, 1.0f);

					kMovSpd *= m_KMovSpdCollid;
					kRotSpd *= m_KMovSpdCollid;
				}
				else
				{
					next_cpos	= cpos;
					next_kinterp= 1.0f;

					m_KMovSpdNoCollid *= 2.0f * kkRotMovSpd;
					m_KRotSpdNoCollid *= 2.0f * kkRotMovSpd;

					m_KMovSpdCollid = MIN_KSPD;
					m_KRotSpdCollid = MIN_KSPD;

					CHECK_RANGE(m_KMovSpdNoCollid, MIN_KSPD, 1.0f);
					CHECK_RANGE(m_KRotSpdNoCollid, MIN_KSPD, 1.0f);

					kMovSpd *= 0.5 * m_KMovSpdNoCollid;
					kRotSpd *= 0.5 * m_KMovSpdNoCollid;
				}
			}
			else
			{
				m_KMovSpdCollid *= 2.0f * kkRotMovSpd;
				m_KRotSpdCollid *= 2.0f * kkRotMovSpd;

				m_KMovSpdNoCollid = MIN_KSPD;
				m_KRotSpdNoCollid = MIN_KSPD;

				CHECK_RANGE(m_KMovSpdCollid, MIN_KSPD, 1.0f);
				CHECK_RANGE(m_KRotSpdCollid, MIN_KSPD, 1.0f);

				kMovSpd *= m_KMovSpdCollid;
				kRotSpd *= m_KMovSpdCollid;

				if (!collided)
				{
					f32 k = (f32)cullcell / f32(cullcell + nocullcell);
					kMovSpd *= k;
					kRotSpd *= k;
				}
				next_cpos	= lock_center;
				next_kinterp= 0.0f;
			}

			pos_delta = next_cpos - cur_cpos;
			kinterp_delta = next_kinterp - centerInterpK;
		}

		// real camera animation

		CHECK_RANGE(pos_delta.X, -1.0f, 1.0f);
		CHECK_RANGE(pos_delta.Y, -1.0f, 1.0f);
		pos_delta *= kMovSpd;

		CHECK_RANGE(kinterp_delta, -1.0f, 1.0f);
		kinterp_delta *= kRotSpd;

		cur_cpos		+= pos_delta;
		centerInterpK	+= kinterp_delta;

		CHECK_RANGE(cur_cpos.X, lock_rect.Left, lock_rect.Right);
		CHECK_RANGE(cur_cpos.Y, lock_rect.Top, lock_rect.Bottom);
		CHECK_RANGE(centerInterpK, 0.0f, 1.0f);

		cam_state = cam_style.getState(cur_cpos, m_Dist, centerInterpK);
		cam_lookat = cam_state.LookatTranslation + player_pos;
		cam_pos.set(0, m_DistNow, 0);   
        player_transf.transformVect(cam_pos);
        cam_pos += cam_state.PositionTranslation;

		if (m_CameraType == ECT_ALIEN_SHOOTER_3D)
		{
			m_CameraFilterPosX.insertValue(cam_pos.X);
			m_CameraFilterPosY.insertValue(cam_pos.Y);
			m_CameraFilterPosZ.insertValue(cam_pos.Z);
			m_CameraFilterLookX.insertValue(cam_lookat.X);
			m_CameraFilterLookY.insertValue(cam_lookat.Y);
			m_CameraFilterLookZ.insertValue(cam_lookat.Z);

			cam_pos.X		= m_CameraFilterPosX.getFilteredValue();
			cam_pos.Y		= m_CameraFilterPosY.getFilteredValue();
			cam_pos.Z		= m_CameraFilterPosZ.getFilteredValue();
			cam_lookat.X	= m_CameraFilterLookX.getFilteredValue();
			cam_lookat.Y	= m_CameraFilterLookY.getFilteredValue();
			cam_lookat.Z	= m_CameraFilterLookZ.getFilteredValue();
		}
    }
    else
    {
        cam_state = cam_style.getState(m_CursorCurrentPos, m_Dist);
        cam_lookat = cam_state.LookatTranslation;  
        player_transf.transformVect(cam_lookat);    
        core::vector3df pos_transl = cam_state.PositionTranslation;
        player_transf.transformVect(pos_transl);
        pos_transl -=  player_pos;  
        cam_pos.set(0, m_DistNow, 0 );   
        player_transf.transformVect(cam_pos);
        cam_pos += pos_transl;
    }

	m_CamPos		= cam_pos;
	m_CamLookAt		= cam_lookat;
	m_NearValue		= cam_state.NearClip;
	m_FarValue		= cam_state.FarClip;   
	m_FOV			= core::DEG2RAD*(cam_state.FOVDegrees);
	m_ViewVolume	= cam_state.ViewVolume;
}

//----------------------------------------------------------------------------

void CGameNodeIronWarrior::OnAnimationEnd(scn::ISceneNode *node, u32 animation_idx)
{
	IGameNode::OnAnimationEnd(node, animation_idx);

	if (node != m_SceneNode || !GAME_MANAGER.isGameStarted())
		return;

	animation_idx = animation_idx % E_IRON_WARRIOR_ANIMATION_COUNT;

	if (animation_idx>=IRON_WARRIOR_DEATH_A ||
			animation_idx<= IRON_WARRIOR_DEATH_D)
	{
		if (!isLive())
			m_SceneNode->detachDynamicObject();	
	}
	else if (animation_idx == IRON_WARRIOR_STAND_IDLE_ACTION)
	{
		m_StandingTimeMs = 0;
		s32 new_animation = IRON_WARRIOR_STAND_IDLE;
		if (m_SelectedWeaponNumber != -1)
			new_animation += m_SelectedWeaponNumber*E_IRON_WARRIOR_ANIMATION_COUNT;			
		m_SceneNode->setCurrentAnimation(new_animation);
	}
}

//----------------------------------------------------------------------------

void CGameNodeIronWarrior::addCameraStyle(const SGameCameraStyle& style)
{
	IGameNodeMainPlayer::addCameraStyle(style);
}

//----------------------------------------------------------------------------

bool CGameNodeIronWarrior::setCameraStyle(const c8* name)
{
	if (!IGameNodeMainPlayer::setCameraStyle(name))
		return false;
	m_Rotations.set( 0, 0, 0);
	if (core::stringc(name)=="AlienShooter3D")
		m_CameraType = ECT_ALIEN_SHOOTER_3D;
	else
	if (core::stringc(name)=="CrimsonLand")
		m_CameraType = ECT_CRIMSONLAND;
	else
		m_CameraType = ECT_SHADOW_GROUND;
	return true;
} 
      
//----------------------------------------------------------------------------

bool CGameNodeIronWarrior::die()
{
	if (!IGameNodeAI::die())
		return false;		
	f32 a_idx = core::math::Random()%4;
	m_SceneNode->setCurrentAnimation(IRON_WARRIOR_DEATH_A+a_idx);
	selectWeapon(0);	
	return true;
}

//----------------------------------------------------------------------------

void CGameNodeIronWarrior::animate(scn::ICameraSceneNode *camera, u32 timeMs)
{
	ICameraController::animate(camera, timeMs);

    // set new camera position and orientation

    camera->setPosition(m_CamPos);    
    camera->setTarget(m_CamLookAt);

	// set camera new projection parameters

	camera->setNearValue	(m_NearValue);
	camera->setFarValue		(m_FarValue);   
	camera->setFOV			(m_FOV);
	camera->setViewVolume	(m_ViewVolume);
}

//----------------------------------------------------------------------------

//! Main Player registry funcs

//----------------------------------------------------------------------------

IGameNode* Alloc__IronWarrior(scn::ISceneNode* n, SGameNodeParams &params)
{
	return new CGameNodeIronWarrior(n, params);
}

//----------------------------------------------------------------------------

CGameNodeBaseCreator IronWarriorCreator;

IGameNode* Create_IronWarrior(SGameNodeCommonParams &node_params, bool log_info)
{
	return IronWarriorCreator.createGameNode(node_params, log_info);
}

//----------------------------------------------------------------------------

CGameNodeBaseCloner IronWarriorCloner;

IGameNode* Clone__IronWarrior(IGameNode *game_node, bool log_info)
{
	return IronWarriorCloner.cloneGameNode(game_node, log_info);
}

//----------------------------------------------------------------------------

class CIronWarriorLoader : public CGameNodeBaseLoader
{

public:

	virtual IGameNode* loadGameNode(SGameNodeCommonParams &node_params, io::IReadFile* file)
	{
		_preLoadGameNode(node_params, file);   
		_loadGameNode(node_params, false);  
		_postLoadGameNode(node_params);		

		return GameNode;
	}
}
IronWarriorLoader;

IGameNode* Load___IronWarrior(SGameNodeCommonParams &node_params, io::IReadFile* file)
{
	return IronWarriorLoader.loadGameNode(node_params, file);
}

//----------------------------------------------------------------------------
} // end namespace robo
} // end namespace game
} // end namespace my
//----------------------------------------------------------------------------
