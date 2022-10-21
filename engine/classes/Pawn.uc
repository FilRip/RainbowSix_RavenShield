//================================================================================
// Pawn.
//================================================================================
class Pawn extends Actor
	Native
	Abstract
	Placeable;
//	Localized;

enum eHealth {
	HEALTH_Healthy,
	HEALTH_Wounded,
	HEALTH_Incapacitated,
	HEALTH_Dead
};

enum ERainbowTeamVoices {
	RTV_PlacingBug,
	RTV_BugActivated,
	RTV_AccessingComputer,
	RTV_ComputerHacked,
	RTV_EscortingHostage,
	RTV_HostageSecured,
	RTV_PlacingExplosives,
	RTV_ExplosivesReady,
	RTV_DesactivatingSecurity,
	RTV_SecurityDeactivated,
	RTV_GasThreat,
	RTV_GrenadeThreat
};

enum EMultiCommonVoices {
	MCV_FragThrow,
	MCV_FlashThrow,
	MCV_GasThrow,
	MCV_SmokeThrow,
	MCV_ActivatingBomb,
	MCV_BombActivated,
	MCV_DeactivatingBomb,
	MCV_BombDeactivated
};

enum EPreRecordedMsgVoices {
	PRMV_NeedBackup,
	PRMV_FollowMe,
	PRMV_CoverArea,
	PRMV_MoveOut,
	PRMV_CoverMe,
	PRMV_Retreat,
	PRMV_ReformOnMe,
	PRMV_Charge,
	PRMV_HoldPosition,
	PRMV_SecureArea,
	PRMV_WaitingOrders,
	PRMV_Assauting,
	PRMV_Defending,
	PRMV_EscortingCargo,
	PRMV_ObjectiveComplete,
	PRMV_ObjectiveReached,
	PRMV_Covering,
	PRMV_WeaponDry,
	PRMV_Move,
	PRMV_Roger,
	PRMV_Negative,
	PRMV_TakingFire,
	PRMV_PinnedDown,
	PRMV_TangoSpotted,
	PRMV_TangoDown,
	PRMV_StatusReport,
	PRMV_Clear
};

enum ERainbowOtherTeamVoices {
	ROTV_SniperHasTarget,
	ROTV_SniperLooseTarget,
	ROTV_SniperTangoDown,
	ROTV_MemberDown,
	ROTV_RainbowHitRainbow,
	ROTV_Objective1,
	ROTV_Objective2,
	ROTV_Objective3,
	ROTV_Objective4,
	ROTV_Objective5,
	ROTV_Objective6,
	ROTV_Objective7,
	ROTV_Objective8,
	ROTV_Objective9,
	ROTV_Objective10,
	ROTV_WaitAlpha,
	ROTV_WaitBravo,
	ROTV_WaitCharlie,
	ROTV_WaitZulu,
	ROTV_EntersSmoke,
	ROTV_EntersGas,
	ROTV_StatusEngaging,
	ROTV_StatusMoving,
	ROTV_StatusWaiting,
	ROTV_StatusWaitAlpha,
	ROTV_StatusWaitBravo,
	ROTV_StatusWaitCharlie,
	ROTV_StatusWaitZulu,
	ROTV_StatusSniperWaitAlpha,
	ROTV_StatusSniperWaitBravo,
	ROTV_StatusSniperWaitCharlie,
	ROTV_StatusSniperUntilAlpha,
	ROTV_StatusSniperUntilBravo,
	ROTV_StatusSniperUntilCharlie
};

enum ERainbowMembersVoices {
	RMV_Contact,
	RMV_ContactRear,
	RMV_ContactAndEngages,
	RMV_ContactRearAndEngages,
	RMV_TeamRegroupOnLead,
	RMV_TeamReformOnLead,
	RMV_TeamReceiveOrder,
	RMV_TeamOrderFromLeadNil,
	RMV_NoMoreFrag,
	RMV_NoMoreSmoke,
	RMV_NoMoreGas,
	RMV_NoMoreFlash,
	RMV_OnLadder,
	RMV_MemberDown,
	RMV_AmmoOut,
	RMV_FragNear,
	RMV_EntersGasCloud,
	RMV_TakingFire,
	RMV_TeamHoldUp,
	RMV_TeamMoveOut,
	RMV_HostageFollow,
	RMV_HostageStay,
	RMV_HostageSafe,
	RMV_HostageSecured,
	RMV_RainbowHitRainbow,
	RMV_RainbowHitHostage,
	RMV_DoorReform
};

enum ERainbowPlayerVoices {
	RPV_TeamRegroup,
	RPV_TeamMove,
	RPV_TeamHold,
	RPV_AllTeamsHold,
	RPV_AllTeamsMove,
	RPV_TeamMoveAndFrag,
	RPV_TeamMoveAndGas,
	RPV_TeamMoveAndSmoke,
	RPV_TeamMoveAndFlash,
	RPV_TeamOpenDoor,
	RPV_TeamCloseDoor,
	RPV_TeamOpenShudder,
	RPV_TeamCloseShudder,
	RPV_TeamOpenAndClear,
	RPV_TeamOpenAndFrag,
	RPV_TeamOpenAndGas,
	RPV_TeamOpenAndSmoke,
	RPV_TeamOpenAndFlash,
	RPV_TeamOpenFragAndClear,
	RPV_TeamOpenGasAndClear,
	RPV_TeamOpenSmokeAndClear,
	RPV_TeamOpenFlashAndClear,
	RPV_TeamFragAndClear,
	RPV_TeamGasAndClear,
	RPV_TeamSmokeAndClear,
	RPV_TeamFlashAndClear,
	RPV_TeamUseLadder,
	RPV_TeamSecureTerrorist,
	RPV_TeamGoGetHostage,
	RPV_TeamHostageStayPut,
	RPV_TeamStatusReport,
	RPV_TeamUseElectronic,
	RPV_TeamUseDemolition,
	RPV_AlphaGoCode,
	RPV_BravoGoCode,
	RPV_CharlieGoCode,
	RPV_ZuluGoCode,
	RPV_OrderTeamWithGoCode,
	RPV_HostageFollow,
	RPV_HostageStay,
	RPV_HostageSafe,
	RPV_HostageSecured,
	RPV_MemberDown,
	RPV_SniperFree,
	RPV_SniperHold
};

enum ECommonRainbowVoices {
	CRV_TerroristDown,
	CRV_TakeWound,
	CRV_GoesDown,
	CRV_EntersSmoke,
	CRV_EntersGas
};

enum EHostageVoices {
	HV_Run,
	HV_Frozen,
	HV_Foetal,
	HV_Hears_Shooting,
	HV_RnbFollow,
	HV_RndStayPut,
	HV_RnbHurt,
	HV_EntersSmoke,
	HV_EntersGas,
	HV_ClarkReprimand
};

enum ETerroristVoices {
	TV_Wounded,
	TV_Taunt,
	TV_Surrender,
	TV_SeesTearGas,
	TV_RunAway,
	TV_Grenade,
	TV_CoughsSmoke,
	TV_CoughsGas,
	TV_Backup,
	TV_SeesSurrenderedHostage,
	TV_SeesRainbow_LowAlert,
	TV_SeesRainbow_HighAlert,
	TV_SeesFreeHostage,
	TV_HearsNoize
};

enum EGunSoundType {
	GS_ExteriorStereo,
	GS_InteriorStereo,
	GS_ExteriorMono,
	GS_InteriorMono
};

enum EAnimStateType {
	SA_Generic,
	SA_Walk,
	SA_Run,
	SA_Turn,
	SA_CrouchToProne,
	SA_ProneToCrouch,
	SA_ProneWalk,
	SA_ProneSideWalk,
	SA_StairUp,
	SA_StairDown,
	SA_LadderHands,
	SA_LadderFoot,
	SA_LameWalkSlide,
	SA_Land,
	SA_DeadFall,
	SA_LameWalkLegOK
};

enum eGrenadeThrow {
	GRENADE_None,
	GRENADE_Throw,
	GRENADE_Roll,
	GRENADE_RemovePin,
	GRENADE_PeekLeft,
	GRENADE_PeekRight,
	GRENADE_PeekLeftThrow,
	GRENADE_PeekRightThrow
};

enum EGrenadeType {
	GTYPE_None,
	GTYPE_Smoke,
	GTYPE_TearGas,
	GTYPE_FlashBang,
	GTYPE_BreachingCharge
};

enum ePeekingMode {
	PEEK_none,
	PEEK_full,
	PEEK_fluid
};

var byte FlashCount;
var byte Visibility;
var const ENoiseType noiseType;
var EPhysics OldPhysics;
var byte AnimPlayBackward[4];
var ePeekingMode m_ePeekingMode;
var byte m_bIsFiringWeapon;
var EPawnType m_ePawnType;
var EGrenadeType m_eEffectiveGrenade;
var eGrenadeThrow m_eGrenadeThrow;
var eGrenadeThrow m_eRepGrenadeThrow;
var eHealth m_eHealth;
var travel int Health;
var int m_iIsInStairVolume;
var int m_iNoCircleBeat;
var int m_iTeam;
var int m_iFriendlyTeams;
var int m_iEnemyTeams;
var int m_iExtentX0;
var int m_iExtentY0;
var int m_iExtentZ0;
var int m_iExtentX1;
var int m_iExtentY1;
var int m_iExtentZ1;
var int m_iProneTrailPtr;
var int m_iCurrentFloor;
var bool bJustLanded;
var bool bUpAndOut;
var bool bIsWalking;
var bool bWarping;
var bool bWantsToCrouch;
var const bool bIsCrouched;
var const bool bTryToUncrouch;
var() bool bCanCrouch;
var bool m_bWantsToProne;
var const bool m_bIsProne;
var const bool m_bTryToUnProne;
var() bool m_bCanProne;
var bool bCrawler;
var const bool bReducedSpeed;
var bool bCanJump;
var bool bCanWalk;
var bool bCanSwim;
var bool bCanFly;
var bool bCanClimbLadders;
var bool bCanStrafe;
var bool bAvoidLedges;
var bool bStopAtLedges;
var bool bNoJumpAdjust;
var bool bCountJumps;
var const bool bSimulateGravity;
var bool bIgnoreForces;
var const bool bNoVelocityUpdate;
var bool bCanWalkOffLedges;
var bool bSteadyFiring;
var bool bCanBeBaseForPawns;
var bool bThumped;
var bool bInvulnerableBody;
var bool bIsFemale;
var bool bAutoActivate;
var bool bUpdatingDisplay;
var bool bAmbientCreature;
var(AI) bool bLOSHearing;
var(AI) bool bSameZoneHearing;
var(AI) bool bAdjacentZoneHearing;
var(AI) bool bMuffledHearing;
var(AI) bool bAroundCornerHearing;
var(AI) bool bDontPossess;
var bool bAutoFire;
var bool bRollToDesired;
var bool bIgnorePlayFiring;
var bool m_bArmPatchSet;
var bool bCachedRelevant;
var bool bUseCompressedPosition;
var bool m_bDroppedWeapon;
var bool m_bHaveGasMask;
var bool m_bUseHighStance;
var bool m_bWantsHighStance;
var bool m_bTurnRight;
var bool m_bTurnLeft;
var bool bPhysicsAnimUpdate;
var bool bWasProne;
var bool bWasCrouched;
var bool bWasWalking;
var bool bWasOnGround;
var bool bInitializeAnimation;
var bool bPlayedDeath;
var bool m_bIsLanding;
var bool m_bMakesTrailsWhenProning;
var bool m_bPeekingLeft;
var bool m_bHBJammerOn;
var bool m_bIsDeadBody;
var bool m_bAnimStopedForRG;
var bool m_bIsPlayer;
var bool m_bFlashBangVisualEffectRequested;
var bool m_bRepFinishShotgun;
var float NetRelevancyTime;
var float DesiredSpeed;
var float MaxDesiredSpeed;
var(AI) float Alertness;
var(AI) float SightRadius;
var(AI) float PeripheralVision;
var() float SkillModifier;
var const float AvgPhysicsTime;
var float MeleeRange;
var float DestinationOffset;
var float NextPathRadius;
var float SerpentineDist;
var float SerpentineTime;
var const float UncrouchTime;
var float GroundSpeed;
var float WaterSpeed;
var float AirSpeed;
var float LadderSpeed;
var float AccelRate;
var float JumpZ;
var float AirControl;
var float WalkingPct;
var float CrouchedPct;
var float MaxFallSpeed;
var float SplashTime;
var float CrouchHeight;
var float CrouchRadius;
var float BreathTime;
var float UnderWaterTime;
var float LastPainTime;
var float m_fProneHeight;
var float m_fProneRadius;
var const float noiseTime;
var const float noiseLoudness;
var float m_NextBulletImpact;
var float m_NextFireSound;
var float LastPainSound;
var float Bob;
var float LandBob;
var float AppliedBob;
var float bobtime;
var float SoundDampening;
var float DamageScaling;
var float CarcassCollisionHeight;
var float OldRotYaw;
var float BaseMovementRate;
var(AnimTweaks) float BlendChangeTime;
var float MovementBlendStartTime;
var float ForwardStrafeBias;
var float BackwardStrafeBias;
var float m_fCrouchBlendRate;
var float m_fHeartBeatTime[2];
var float m_fHeartBeatFrequency;
var float m_fBlurValue;
var float m_fDecrementalBlurValue;
var float m_fRepDecrementalBlurValue;
var float m_fRemainingGrenadeTime;
var float m_fFlashBangVisualEffectTime;
var float m_fXFlashBang;
var float m_fYFlashBang;
var float m_fDistanceFlashBang;
var float m_fLastCommunicationTime;
var float m_fPrePivotPawnInitialOffset;
var Controller Controller;
var PlayerController LastRealViewer;
var Actor LastViewer;
var NavigationPoint Anchor;
var R6EngineWeapon EngineWeapon;
var R6EngineWeapon PendingWeapon;
var R6EngineWeapon m_WeaponsCarried[4];
var PhysicsVolume HeadVolume;
var PlayerReplicationInfo PlayerReplicationInfo;
var LadderVolume OnLadder;
var Material m_HitMaterial;
var Texture m_pHeartBeatTexture;
var Sound m_sndHBSSound;
var Sound m_sndHearToneSound;
var Sound m_sndHearToneSoundStop;
var Texture m_ArmPatchTexture;
var(AI) name AIScriptTag;
var name LandMovementState;
var name WaterMovementState;
var name AnimStatus;
var name AnimAction;
var name MovementAnims[4];
var name TurnLeftAnim;
var name TurnRightAnim;
var Class<DamageType> ReducedDamageType;
var Class<Effects> BloodEffect;
var Class<Effects> LowDetailBlood;
var Class<Effects> LowGoreBlood;
var Class<AIController> ControllerClass;
var Class<DamageType> HitDamageType;
var Vector SerpentineDir;
var Vector ConstantAcceleration;
var const Vector Floor;
var const Vector m_vLastNetLocation;
var const Vector noiseSpot;
var Vector WalkBob;
var Vector TakeHitLocation;
var Vector TearOffMomentum;
var Vector OldAcceleration;
var Vector m_vEyeLocation;
var Rotator m_rRotationOffset;
var Vector m_vGrenadeLocation;
var Guid m_ArmPatchGUID;
var string OwnerName;
var localized string MenuName;
var string m_CharacterName;
var transient CompressedPosition PawnPosition;

replication
{
	reliable if ( Role < Role_Authority )
		ServerChangedWeapon,ServerFinishShotgunAnimation;
	reliable if (  !bNetOwner && (Role == Role_Authority) )
		m_ePeekingMode,m_bPeekingLeft,m_fCrouchBlendRate;
	reliable if ( bNetOwner && (Role < Role_Authority) ||  !bNetOwner && (Role == Role_Authority) )
		m_bIsFiringWeapon,m_bTurnRight,m_bTurnLeft;
	reliable if ( bNetDirty && (Role == Role_Authority) )
		m_eRepGrenadeThrow,m_eHealth,m_iTeam,m_iFriendlyTeams,m_iEnemyTeams,bIsWalking,bIsCrouched,m_bIsProne,bSimulateGravity,m_bHaveGasMask,m_bWantsHighStance,m_bHBJammerOn,Controller,m_WeaponsCarried,PlayerReplicationInfo,OnLadder,AnimStatus,AnimAction,HitDamageType,TakeHitLocation,m_ArmPatchGUID;
	reliable if ( bNetDirty && bNetOwner && (Role == Role_Authority) )
		Health,GroundSpeed,WaterSpeed,AirSpeed,AccelRate,JumpZ,AirControl;
	reliable if ( bNetDirty &&  !bNetOwner && (Role == Role_Authority) )
		bSteadyFiring,EngineWeapon,PendingWeapon;
	reliable if ( Role == Role_Authority )
		m_bIsPlayer;
	reliable if (  !bNetOwner && (Role == Role_Authority) && m_bIsPlayer )
		m_bRepFinishShotgun,m_rRotationOffset;
	reliable if ( Role == Role_Authority )
		m_fRepDecrementalBlurValue;
	reliable if ( (bTearOff || m_bUseRagdoll) && bNetDirty && (Role == Role_Authority) )
		TearOffMomentum;
	reliable if (  !bNetOwner && (Role == Role_Authority) )
		PawnPosition;
}

simulated event R6DeadEndedMoving ();

simulated event StopAnimForRG ();

native function bool ReachedDestination (Actor Goal);

native function bool IsFriend (Pawn aPawn);

native function bool IsEnemy (Pawn aPawn);

native function bool IsNeutral (Pawn aPawn);

native function bool IsAlive ();

simulated event ReceivedWeapons ();

simulated event ReceivedEngineWeapon ();

function float GetPeekingRate ();

simulated event PlayWeaponAnimation ();

function ServerFinishShotgunAnimation ()
{
	m_bRepFinishShotgun= !m_bRepFinishShotgun;
}

function Reset ()
{
	if ( (Controller == None) || Controller.bIsPlayer )
	{
		Destroy();
	}
	else
	{
		Super.Reset();
	}
}

function string GetHumanReadableName ()
{
	if ( PlayerReplicationInfo != None )
	{
		return PlayerReplicationInfo.PlayerName;
	}
	return MenuName;
}

function PlayTeleportEffect (bool bOut, bool bSound)
{
	MakeNoise(1.00);
}

function PossessedBy (Controller C)
{
	Controller=C;
	NetPriority=3.00;
	if ( C.PlayerReplicationInfo != None )
	{
		PlayerReplicationInfo=C.PlayerReplicationInfo;
		OwnerName=PlayerReplicationInfo.PlayerName;
	}
	if ( C.IsA('PlayerController') )
	{
		if ( Level.NetMode != 0 )
		{
			RemoteRole=ROLE_AutonomousProxy;
		}
		BecomeViewTarget();
		if ( PlayerController(C).Player != None )
		{
			m_ArmPatchGUID=PlayerController(C).Player.m_ArmPatchGUID;
			m_bArmPatchSet=False;
		}
	}
	else
	{
		RemoteRole=Default.RemoteRole;
	}
	SetOwner(Controller);
	ChangeAnimation();
}

function UnPossessed ()
{
	if ( (Level.NetMode != 0) && (PlayerReplicationInfo != None) )
	{
		m_CharacterName=PlayerReplicationInfo.PlayerName;
	}
	SetOwner(None);
	Controller=None;
}

simulated function bool PointOfView ()
{
	return False;
}

function BecomeViewTarget ()
{
}

function DropToGround ()
{
	bCollideWorld=True;
	bInterpolating=False;
	if ( Health > 0 )
	{
		SetCollision(True,True,True);
		SetPhysics(PHYS_Falling);
		AmbientSound=None;
		if ( IsHumanControlled() )
		{
			Controller.GotoState(LandMovementState);
		}
	}
}

function bool CanGrabLadder ()
{
	return bCanClimbLadders && (Controller != None) && (Physics != 11) && ((Physics != 2) || (Abs(Velocity.Z) <= JumpZ));
}

event SetWalking (bool bNewIsWalking)
{
	if ( bNewIsWalking != bIsWalking )
	{
		bIsWalking=bNewIsWalking;
		ChangeAnimation();
	}
}

function bool CanSplash ()
{
	if ( (Level.TimeSeconds - SplashTime > 0.25) && ((Physics == 2) || (Physics == 4)) && (Abs(Velocity.Z) > 100) )
	{
		SplashTime=Level.TimeSeconds;
		return True;
	}
	return False;
}

event EndClimbLadder (LadderVolume OldLadder)
{
	if ( Controller != None )
	{
		Controller.EndClimbLadder();
	}
	if ( Physics == PHYS_Ladder )
	{
		SetPhysics(PHYS_Falling);
	}
}

function ClimbLadder (LadderVolume L)
{
	OnLadder=L;
	SetRotation(OnLadder.WallDir);
	SetPhysics(PHYS_Ladder);
	if ( IsHumanControlled() )
	{
		Controller.GotoState('PlayerClimbing');
	}
}

simulated function DisplayDebug (Canvas Canvas, out float YL, out float YPos)
{
	local string t;

	Super.DisplayDebug(Canvas,YL,YPos);
	Canvas.SetDrawColor(255,255,255);
	Canvas.DrawText("Animation Action " $ string(AnimAction) $ " Status " $ string(AnimStatus));
	YPos += YL;
	Canvas.SetPos(4.00,YPos);
	Canvas.DrawText("Anchor " $ string(Anchor) $ " Serpentine Dist " $ string(SerpentineDist) $ " Time " $ string(SerpentineTime));
	YPos += YL;
	Canvas.SetPos(4.00,YPos);
	t="Floor " $ string(Floor) $ " DesiredSpeed " $ string(DesiredSpeed) $ " Crouched " $ string(bIsCrouched) $ " Try to uncrouch " $ string(UncrouchTime);
	if ( (OnLadder != None) || (Physics == 11) )
	{
		t=t $ " on ladder " $ string(OnLadder);
	}
	Canvas.DrawText(t);
	YPos += YL;
	Canvas.SetPos(4.00,YPos);
	if ( Controller == None )
	{
		Canvas.SetDrawColor(255,0,0);
		Canvas.DrawText("NO CONTROLLER");
		YPos += YL;
		Canvas.SetPos(4.00,YPos);
	}
	else
	{
		Controller.DisplayDebug(Canvas,YL,YPos);
	}
}

function Vector WeaponBob (float BobDamping)
{
	local Vector WBob;

	WBob=BobDamping * WalkBob;
	WBob.Z=(0.45 + 0.55 * BobDamping) * WalkBob.Z;
	if ( PlayerController(Controller) != None )
	{
		WBob += 0.90 * PlayerController(Controller).ShakeOffset;
	}
	return WBob;
}

function CheckBob (float DeltaTime, Vector Y)
{
	local float Speed2D;

	if ( Physics == 1 )
	{
		Speed2D=VSize(Velocity);
		if ( Speed2D < 10 )
		{
			bobtime += 0.20 * DeltaTime;
		}
		else
		{
			bobtime += DeltaTime * (0.30 + 0.70 * Speed2D / GroundSpeed);
		}
		WalkBob=Y * Bob * Speed2D * Sin(8.00 * bobtime);
		AppliedBob=AppliedBob * (1 - FMin(1.00,16.00 * DeltaTime));
		WalkBob.Z=AppliedBob;
		if ( Speed2D > 10 )
		{
			WalkBob.Z=WalkBob.Z + 0.75 * Bob * Speed2D * Sin(16.00 * bobtime);
		}
		if ( LandBob > 0.01 )
		{
			AppliedBob += FMin(1.00,16.00 * DeltaTime) * LandBob;
			LandBob *= 1 - 8 * DeltaTime;
		}
	}
	else
	{
		if ( Physics == 3 )
		{
			Speed2D=Sqrt(Velocity.X * Velocity.X + Velocity.Y * Velocity.Y);
			WalkBob=Y * Bob * 0.50 * Speed2D * Sin(4.00 * Level.TimeSeconds);
			WalkBob.Z=Bob * 1.50 * Speed2D * Sin(8.00 * Level.TimeSeconds);
		}
		else
		{
			bobtime=0.00;
			WalkBob=WalkBob * (1 - FMin(1.00,8.00 * DeltaTime));
		}
	}
}

simulated function bool IsPlayerPawn ()
{
	return (Controller != None) && Controller.bIsPlayer;
}

simulated function bool IsHumanControlled ()
{
	return PlayerController(Controller) != None;
}

simulated function bool IsLocallyControlled ()
{
	if ( Level.NetMode == NM_Standalone )
	{
		return True;
	}
	if ( Controller == None )
	{
		return False;
	}
	if ( PlayerController(Controller) == None )
	{
		return True;
	}
	return Viewport(PlayerController(Controller).Player) != None;
}

simulated event Rotator GetViewRotation ()
{
	if ( Controller == None )
	{
		return Rotation;
	}
	else
	{
		return Controller.GetViewRotation();
	}
}

simulated function SetViewRotation (Rotator NewRotation)
{
	if ( Controller != None )
	{
		Controller.SetRotation(NewRotation);
	}
}

final function bool InGodMode ()
{
	return (Controller != None) && Controller.bGodMode;
}

function bool NearMoveTarget ()
{
	if ( (Controller == None) || (Controller.MoveTarget == None) )
	{
		return False;
	}
	return ReachedDestination(Controller.MoveTarget);
}

final simulated function bool PressingFire ()
{
	return (Controller != None) && (Controller.bFire != 0);
}

final simulated function bool PressingAltFire ()
{
	return (Controller != None) && (Controller.bAltFire != 0);
}

function Actor GetMoveTarget ()
{
	if ( Controller == None )
	{
		return None;
	}
	return Controller.MoveTarget;
}

function SetMoveTarget (Actor NewTarget)
{
	if ( Controller != None )
	{
		Controller.MoveTarget=NewTarget;
	}
}

function bool LineOfSightTo (Actor Other)
{
	return (Controller != None) /* && Controller.Super.LineOfSightTo(Other)*/;
}

function Actor ShootSpecial (Actor A)
{
	return None;
	Controller.FireWeaponAt(A);
	Controller.bFire=0;
	return A;
}

function ReceiveLocalizedMessage (Class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	if ( PlayerController(Controller) != None )
	{
		PlayerController(Controller).ReceiveLocalizedMessage(Message,Switch,RelatedPRI_1,RelatedPRI_2,OptionalObject);
	}
}

event ClientMessage (coerce string S, optional name type)
{
	if ( PlayerController(Controller) != None )
	{
		PlayerController(Controller).ClientMessage(S,type);
	}
}

function Trigger (Actor Other, Pawn EventInstigator)
{
	if ( Controller != None )
	{
		Controller.Trigger(Other,EventInstigator);
	}
}

function bool CanTrigger (Trigger t)
{
	return True;
}

function GiveWeapon (string aClassName)
{
}

function SetDisplayProperties (ERenderStyle NewStyle, Material NewTexture, bool bLighting)
{
	Style=NewStyle;
	Texture=NewTexture;
	bUnlit=bLighting;
	bUpdatingDisplay=False;
}

function SetDefaultDisplayProperties ()
{
	Style=Default.Style;
	Texture=Default.Texture;
	bUnlit=Default.bUnlit;
	bUpdatingDisplay=False;
}

function FinishedInterpolation ()
{
	DropToGround();
}

function JumpOutOfWater (Vector jumpDir)
{
	Falling();
	Velocity=jumpDir * WaterSpeed;
	Acceleration=jumpDir * AccelRate;
	Velocity.Z=FMax(380.00,JumpZ);
	bUpAndOut=True;
}

event FellOutOfWorld ()
{
	if ( Role < Role_Authority )
	{
		return;
	}
	Health=-1;
	SetPhysics(PHYS_None);
	Died(None,Class'Gibbed',Location);
}

function ShouldCrouch (bool Crouch)
{
	bWantsToCrouch=Crouch;
}

event EndCrouch (float HeightAdjust)
{
}

event StartCrouch (float HeightAdjust)
{
}

function RestartPlayer ();

function AddVelocity (Vector NewVelocity)
{
	if ( bIgnoreForces )
	{
		return;
	}
	if ( (Physics == 1) || ((Physics == 11) || (Physics == 9)) && (NewVelocity.Z > Default.JumpZ) )
	{
		SetPhysics(PHYS_Falling);
	}
	if ( (Velocity.Z > 380) && (NewVelocity.Z > 0) )
	{
		NewVelocity.Z *= 0.50;
	}
	Velocity += NewVelocity;
}

function KilledBy (Pawn EventInstigator)
{
	local Controller Killer;

	Health=0;
	if ( EventInstigator != None )
	{
		Killer=EventInstigator.Controller;
	}
	Died(Killer,Class'Suicided',Location);
}

function TakeFallingDamage ()
{
	local float Shake;

	if ( Velocity.Z < -0.50 * MaxFallSpeed )
	{
		MakeNoise(FMin(2.00,-0.50 * Velocity.Z / FMax(JumpZ,150.00)));
		if ( Velocity.Z < -1 * MaxFallSpeed )
		{
			if ( Role == Role_Authority )
			{
				TakeDamage(-100 * (Velocity.Z + MaxFallSpeed) / MaxFallSpeed,None,Location,vect(0.00,0.00,0.00),Class'fell');
			}
		}
		if ( Controller != None )
		{
			Shake=FMin(1.00,-1.00 * Velocity.Z / MaxFallSpeed);
			Controller.ShakeView(0.17 + 0.10 * Shake,850.00 * Shake,Shake * vect(0.00,0.00,1.50),120000.00,vect(0.00,0.00,10.00),1.00);
		}
	}
}

function ClientReStart ()
{
	Velocity=vect(0.00,0.00,0.00);
	Acceleration=vect(0.00,0.00,0.00);
	PlayWaiting();
}

function ClientSetLocation (Vector NewLocation, Rotator NewRotation)
{
	if ( Controller != None )
	{
		Controller.ClientSetLocation(NewLocation,NewRotation);
	}
}

function ClientSetRotation (Rotator NewRotation)
{
	if ( Controller != None )
	{
		Controller.ClientSetRotation(NewRotation);
	}
}

simulated function FaceRotation (Rotator NewRotation, float DeltaTime)
{
	if ( Physics == 11 )
	{
		SetRotation(OnLadder.WallDir);
	}
	else
	{
		if ( (Physics == 1) || (Physics == 2) )
		{
			NewRotation.Pitch=0;
		}
		SetRotation(NewRotation);
	}
}

function ClientDying (Class<DamageType> DamageType, Vector HitLocation)
{
	if ( Controller != None )
	{
		Controller.ClientDying(DamageType,HitLocation);
	}
}

function TossWeapon (Vector TossVel)
{
}

function ChangedWeapon ()
{
}

function ServerChangedWeapon (R6EngineWeapon OldWeapon, R6EngineWeapon W)
{
}

event bool EncroachingOn (Actor Other)
{
	if ( Other.bWorldGeometry )
	{
		return True;
	}
	if ( ((Controller == None) ||  !Controller.bIsPlayer || bWarping) && (Pawn(Other) != None) )
	{
		return True;
	}
	return False;
}

event EncroachedBy (Actor Other)
{
	if ( Pawn(Other) != None )
	{
		gibbedBy(Other);
	}
}

function gibbedBy (Actor Other)
{
	local Controller Killer;

	if ( Role < Role_Authority )
	{
		return;
	}
	if ( Pawn(Other) != None )
	{
		Killer=Pawn(Other).Controller;
	}
	Died(Killer,Class'Gibbed',Location);
}

function JumpOffPawn ()
{
	Velocity += (100 + CollisionRadius) * VRand();
	Velocity.Z=200.00 + CollisionHeight;
	SetPhysics(PHYS_Falling);
	bNoJumpAdjust=True;
	Controller.SetFall();
}

singular event BaseChange ()
{
	local float decorMass;

	if ( bInterpolating )
	{
		return;
	}
	if ( (Base == None) && (Physics == PHYS_None) )
	{
		SetPhysics(PHYS_Falling);
	}
	else
	{
		if ( Pawn(Base) != None )
		{
			if (  !Pawn(Base).bCanBeBaseForPawns )
			{
				Base.TakeDamage((1 - Velocity.Z / 400) * Mass / Base.Mass,self,Location,0.50 * Velocity,Class'Crushed');
				JumpOffPawn();
			}
		}
		else
		{
			if ( (Decoration(Base) != None) && (Velocity.Z < -400) )
			{
				decorMass=FMax(Decoration(Base).Mass,1.00);
				Base.TakeDamage(-2 * Mass / decorMass * Velocity.Z / 400,self,Location,0.50 * Velocity,Class'Crushed');
			}
		}
	}
}

event Vector EyePosition ()
{
	return WalkBob;
}

simulated event Destroyed ()
{
	if ( Shadow != None )
	{
		Shadow.Destroy();
		Shadow=None;
	}
	if ( Controller != None )
	{
		Controller.PawnDied();
	}
	if ( Role < Role_Authority )
	{
		return;
	}
	if ( EngineWeapon != None )
	{
		EngineWeapon.Destroy();
	}
	if ( PendingWeapon != None )
	{
		PendingWeapon.Destroy();
	}
	EngineWeapon=None;
	PendingWeapon=None;
	Super.Destroyed();
}

event PreBeginPlay ()
{
	Super.PreBeginPlay();
	Instigator=self;
	DesiredRotation=Rotation;
	if ( bDeleteMe )
	{
		return;
	}
	if ( MenuName == "" )
	{
		MenuName=GetItemName(string(Class));
	}
}

event PostBeginPlay ()
{
	local AIScript A;

	Super.PostBeginPlay();
	SplashTime=0.00;
	OldRotYaw=Rotation.Yaw;
	if ( Level.bStartup && (Health > 0) &&  !bDontPossess )
	{
		if ( (AIScriptTag != 'None') && (AIScriptTag != 'None') )
		{
			foreach AllActors(Class'AIScript',A,AIScriptTag)
			{
/*				goto JL0088;
JL0088:*/
			}
			if ( A != None )
			{
				A.SpawnControllerFor(self);
				if ( Controller != None )
				{
					return;
				}
			}
		}
		if ( (ControllerClass != None) && (Controller == None) )
		{
			Controller=Spawn(ControllerClass);
		}
		if ( Controller != None )
		{
			Controller.Possess(self);
			AIController(Controller).Skill += SkillModifier;
		}
	}
}

simulated event PostNetBeginPlay ()
{
	if ( Role == Role_Authority )
	{
		return;
	}
	if ( Controller != None )
	{
		Controller.Pawn=self;
	}
	if ( (PlayerReplicationInfo != None) && (PlayerReplicationInfo.Owner == None) )
	{
		PlayerReplicationInfo.SetOwner(Controller);
	}
	PlayWaiting();
}

simulated function SetMesh ()
{
	LinkMesh(Default.Mesh);
}

function Gasp ();

function SetMovementPhysics ();

function TakeDamage (int Damage, Pawn instigatedBy, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType)
{
}

function Died (Controller Killer, Class<DamageType> DamageType, Vector HitLocation)
{
	if ( bDeleteMe )
	{
		return;
	}
	if ( Level.Game.PreventDeath(self,Killer,DamageType,HitLocation) )
	{
		Health=Max(Health,1);
		return;
	}
	Health=Min(0,Health);
	Level.Game.Killed(Killer,Controller,self,DamageType);
	if ( Killer != None )
	{
		TriggerEvent(Event,self,Killer.Pawn);
	}
	else
	{
		TriggerEvent(Event,self,None);
	}
	Velocity.Z *= 1.30;
	if ( IsHumanControlled() )
	{
		PlayerController(Controller).ForceDeathUpdate();
	}
	if ( (DamageType != None) && (DamageType.Default.GibModifier >= 100) )
	{
		ChunkUp(-1 * Health);
	}
	else
	{
		PlayDying(DamageType,HitLocation);
		if ( Level.Game.bGameEnded )
		{
			return;
		}
		if (  !bPhysicsAnimUpdate &&  !IsLocallyControlled() )
		{
			ClientDying(DamageType,HitLocation);
		}
	}
}

function bool Gibbed (Class<DamageType> DamageType)
{
	if ( DamageType.Default.GibModifier == 0 )
	{
		return False;
	}
	if ( DamageType.Default.GibModifier >= 100 )
	{
		return True;
	}
	if ( (Health < -80) || (Health < -40) && (FRand() < 0.60) )
	{
		return True;
	}
	return False;
}

event Falling ()
{
	if ( Controller != None )
	{
		Controller.SetFall();
	}
}

event HitWall (Vector HitNormal, Actor Wall);

event Landed (Vector HitNormal)
{
	LandBob=FMin(50.00,0.05 * Velocity.Z);
	TakeFallingDamage();
	if ( Health > 0 )
	{
		PlayLanded(Velocity.Z);
	}
	if ( Velocity.Z < -1.40 * JumpZ )
	{
		MakeNoise(-0.50 * Velocity.Z / FMax(JumpZ,150.00));
	}
	bJustLanded=True;
}

event HeadVolumeChange (PhysicsVolume newHeadVolume)
{
	if ( (Level.NetMode == NM_Client) || (Controller == None) )
	{
		return;
	}
	if ( HeadVolume.bWaterVolume )
	{
		if (  !newHeadVolume.bWaterVolume )
		{
			if ( Controller.bIsPlayer && (BreathTime > 0) && (BreathTime < 8) )
			{
				Gasp();
			}
			BreathTime=-1.00;
		}
	}
	else
	{
		if ( newHeadVolume.bWaterVolume )
		{
			BreathTime=UnderWaterTime;
		}
	}
}

function bool TouchingWaterVolume ()
{
	local PhysicsVolume V;

	foreach TouchingActors(Class'PhysicsVolume',V)
	{
		if ( V.bWaterVolume )
		{
			return True;
		}
	}
	return False;
}

function bool IsInPain ()
{
	local PhysicsVolume V;

	foreach TouchingActors(Class'PhysicsVolume',V)
	{
		if ( V.bPainCausing && (V.DamageType != ReducedDamageType) && (V.DamagePerSec > 0) )
		{
			return True;
		}
	}
	return False;
}

event BreathTimer ()
{
	if ( (Health < 0) || (Level.NetMode == NM_Client) )
	{
		return;
	}
	TakeDrowningDamage();
	if ( Health > 0 )
	{
		BreathTime=2.00;
	}
}

function TakeDrowningDamage ();

function bool CheckWaterJump (out Vector WallNormal)
{
	local Actor HitActor;
	local Vector HitLocation;
	local Vector HitNormal;
	local Vector checkpoint;
	local Vector Start;
	local Vector checkNorm;
	local Vector Extent;

	checkpoint=vector(Rotation);
	checkpoint.Z=0.00;
	checkNorm=Normal(checkpoint);
	checkpoint=Location + CollisionRadius * checkNorm;
	Extent=CollisionRadius * vect(1.00,1.00,0.00);
	Extent.Z=CollisionHeight;
	HitActor=Trace(HitLocation,HitNormal,checkpoint,Location,True,Extent);
	if ( (HitActor != None) && (Pawn(HitActor) == None) )
	{
		WallNormal=-1 * HitNormal;
		Start=Location;
		Start.Z += 1.10 * 33.00;
		checkpoint=Start + 2 * CollisionRadius * checkNorm;
		HitActor=Trace(HitLocation,HitNormal,checkpoint,Start,True);
		if ( HitActor == None )
		{
			return True;
		}
	}
	return False;
}

function DoJump (bool bUpdating)
{
	if (  !bIsCrouched &&  !bWantsToCrouch && ((Physics == 1) || (Physics == 11) || (Physics == 9)) )
	{
		if ( Role == Role_Authority )
		{
			if ( (Level.Game != None) && (Level.Game.Difficulty > 0) )
			{
				MakeNoise(0.10 * Level.Game.Difficulty);
			}
		}
		if ( Physics == 9 )
		{
			Velocity=JumpZ * Floor;
		}
		else
		{
			if ( Physics == 11 )
			{
				Velocity.Z=0.00;
			}
			else
			{
				if ( bIsWalking )
				{
					Velocity.Z=Default.JumpZ;
				}
				else
				{
					Velocity.Z=JumpZ;
				}
			}
		}
		if ( (Base != None) &&  !Base.bWorldGeometry )
		{
			Velocity.Z += Base.Velocity.Z;
		}
		SetPhysics(PHYS_Falling);
	}
}

function PlayMoverHitSound ();

function PlayDyingSound ();

function PlayHit (float Damage, Vector HitLocation, Class<DamageType> DamageType, Vector Momentum)
{
	local Vector BloodOffset;
	local Vector Mo;
	local Vector HitNormal;
	local Class<Effects> DesiredEffect;
	local Class<Emitter> DesiredEmitter;

	if ( (Damage <= 0) &&  !Controller.bGodMode )
	{
		return;
	}
	if ( Damage > DamageType.Default.DamageThreshold )
	{
		HitNormal=Normal(HitLocation - Location);
		DesiredEffect=DamageType.static.GetPawnDamageEffect(HitLocation,Damage,Momentum,self,Level.bDropDetail ||  !Level.bHighDetailMode);
		if ( DesiredEffect != None )
		{
			BloodOffset=0.20 * CollisionRadius * HitNormal;
			BloodOffset.Z=BloodOffset.Z * 0.50;
			Mo=Momentum;
			if ( Mo.Z > 0 )
			{
				Mo.Z *= 0.50;
			}
			Spawn(DesiredEffect,self,,HitLocation + BloodOffset,rotator(Mo));
		}
		DesiredEmitter=DamageType.static.GetPawnDamageEmitter(HitLocation,Damage,Momentum,self,Level.bDropDetail ||  !Level.bHighDetailMode);
		if ( DesiredEmitter != None )
		{
			Spawn(DesiredEmitter,,,HitLocation + HitNormal,rotator(HitNormal));
		}
	}
	if ( Health <= 0 )
	{
		if ( PhysicsVolume.bDestructive && (PhysicsVolume.ExitActor != None) )
		{
			Spawn(PhysicsVolume.ExitActor);
		}
		return;
	}
	if ( Level.TimeSeconds - LastPainTime > 0.10 )
	{
		PlayTakeHit(HitLocation,Damage,DamageType);
		LastPainTime=Level.TimeSeconds;
	}
}

simulated function ChunkUp (int Damage)
{
	if ( (Level.NetMode != 3) && (Controller != None) )
	{
		if ( Controller.bIsPlayer )
		{
			Controller.PawnDied();
		}
		else
		{
			Controller.Destroy();
		}
	}
	Destroy();
}

state Dying
{
	ignores  BreathTimer;

	event ChangeAnimation ()
	{
	}

	event StopPlayFiring ()
	{
	}

	function PlayFiring (float Rate, name FiringMode)
	{
	}

	function PlayTakeHit (Vector HitLoc, int Damage, Class<DamageType> DamageType)
	{
	}

	simulated function PlayNextAnimation ()
	{
	}

	function Died (Controller Killer, Class<DamageType> DamageType, Vector HitLocation)
	{
	}

	function Timer ()
	{
		if (  !PlayerCanSeeMe() )
		{
			Destroy();
		}
		else
		{
			SetTimer(2.00,False);
		}
	}

	function Landed (Vector HitNormal)
	{
		local Rotator finalRot;

		LandBob=FMin(50.00,0.05 * Velocity.Z);
		if ( Velocity.Z < -500 )
		{
			TakeDamage(1 - Velocity.Z / 30,Instigator,Location,vect(0.00,0.00,0.00),Class'Crushed');
		}
		finalRot=Rotation;
		finalRot.Roll=0;
		finalRot.Pitch=0;
		SetRotation(finalRot);
		SetPhysics(PHYS_None);
		SetCollision(True,False,False);
		if (  !IsAnimating(0) )
		{
			LieStill();
		}
	}

	function ReduceCylinder ()
	{
		local float OldHeight;
		local float OldRadius;
		local Vector OldLocation;

		SetCollision(True,False,False);
		OldHeight=CollisionHeight;
		OldRadius=CollisionRadius;
		SetCollisionSize(1.50 * Default.CollisionRadius,CarcassCollisionHeight);
		PrePivot=vect(0.00,0.00,1.00) * (OldHeight - CollisionHeight);
		OldLocation=Location;
		if (  !SetLocation(OldLocation - PrePivot) )
		{
			SetCollisionSize(OldRadius,CollisionHeight);
			if (  !SetLocation(OldLocation - PrePivot) )
			{
				SetCollisionSize(CollisionRadius,OldHeight);
				SetCollision(False,False,False);
				PrePivot=vect(0.00,0.00,0.00);
				if (  !SetLocation(OldLocation) )
				{
					ChunkUp(200);
				}
			}
		}
		PrePivot=PrePivot + vect(0.00,0.00,3.00);
	}

	function LandThump ()
	{
		if ( Physics == 0 )
		{
			bThumped=True;
		}
	}

	event AnimEnd (int Channel)
	{
		if ( Channel != 0 )
		{
			return;
		}
		if ( Physics == 0 )
		{
			LieStill();
		}
		else
		{
			if ( PhysicsVolume.bWaterVolume )
			{
				bThumped=True;
				LieStill();
			}
		}
	}

	function LieStill ()
	{
		if (  !bThumped )
		{
			LandThump();
		}
		if ( CollisionHeight != CarcassCollisionHeight )
		{
			ReduceCylinder();
		}
	}

	singular function BaseChange ()
	{
		if ( Base == None )
		{
			SetPhysics(PHYS_Falling);
		}
		else
		{
			if ( Pawn(Base) != None )
			{
				ChunkUp(200);
			}
		}
	}

	function TakeDamage (int Damage, Pawn instigatedBy, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType)
	{
		SetPhysics(PHYS_Falling);
		if ( (Physics == 0) && (Momentum.Z < 0) )
		{
			Momentum.Z *= -1;
		}
		Velocity += 3 * Momentum / (Mass + 200);
		if ( bInvulnerableBody )
		{
			return;
		}
		Damage *= DamageType.Default.GibModifier;
		Health -= Damage;
		if ( ((Damage > 30) ||  !IsAnimating()) && (Health < -80) )
		{
			ChunkUp(Damage);
		}
	}

	function BeginState ()
	{
		if ( bTearOff && (Level.NetMode == NM_DedicatedServer) )
		{
			LifeSpan=1.00;
		}
		else
		{
			SetTimer(12.00,False);
		}
		SetPhysics(PHYS_Falling);
		bInvulnerableBody=True;
		if ( Controller != None )
		{
			if ( Controller.bIsPlayer )
			{
				Controller.PawnDied();
			}
			else
			{
				Controller.Destroy();
			}
		}
	}

Begin:
	Sleep(0.20);
	bInvulnerableBody=False;
}

simulated event SetAnimAction (name NewAction);

simulated function SetAnimStatus (name NewStatus)
{
	if ( NewStatus != AnimStatus )
	{
		AnimStatus=NewStatus;
		ChangeAnimation();
	}
}

simulated event PlayDying (Class<DamageType> DamageType, Vector HitLoc)
{
	GotoState('Dying');
	if ( bPhysicsAnimUpdate )
	{
		bReplicateMovement=False;
		bTearOff=True;
		Velocity += TearOffMomentum;
		SetPhysics(PHYS_Falling);
	}
	bPlayedDeath=True;
}

simulated function PlayFiring (float Rate, name FiringMode);

simulated event StopPlayFiring ()
{
	bSteadyFiring=False;
}

function PlayTakeHit (Vector HitLoc, int Damage, Class<DamageType> DamageType)
{
	local Sound DesiredSound;

	if ( Damage == 0 )
	{
		return;
	}
	DesiredSound=DamageType.static.GetPawnDamageSound();
	if ( DesiredSound != None )
	{
		PlayOwnedSound(DesiredSound,SLOT_SFX,1.00);
	}
}

simulated event ChangeAnimation ()
{
	if ( (Controller != None) && Controller.bControlAnimations )
	{
		return;
	}
	PlayWaiting();
	PlayMoving();
}

simulated event AnimEnd (int Channel)
{
	if ( Channel == 0 )
	{
		PlayWaiting();
	}
}

function bool CannotJumpNow ()
{
	return False;
}

simulated event PlayJump ();

simulated event PlayFalling ();

simulated function PlayMoving ();

simulated function PlayWaiting ();

function PlayLanded (float impactVel)
{
	if (  !bPhysicsAnimUpdate )
	{
		PlayLandingAnimation(impactVel);
	}
}

simulated event PlayLandingAnimation (float impactVel);

defaultproperties
{
    Visibility=128
    Health=100
    bCanJump=True
    bCanWalk=True
    bLOSHearing=True
    bUseCompressedPosition=True
    m_bUseHighStance=True
    DesiredSpeed=1.00
    MaxDesiredSpeed=1.00
    SightRadius=5000.00
    AvgPhysicsTime=0.10
    GroundSpeed=600.00
    WaterSpeed=300.00
    AirSpeed=600.00
    LadderSpeed=200.00
    AccelRate=2048.00
    JumpZ=420.00
    AirControl=0.05
    WalkingPct=0.50
    CrouchedPct=0.50
    MaxFallSpeed=1200.00
    CrouchHeight=40.00
    CrouchRadius=34.00
    Bob=0.02
    SoundDampening=1.00
    DamageScaling=1.00
    CarcassCollisionHeight=23.00
    BaseMovementRate=525.00
    BlendChangeTime=0.25
    LandMovementState=PlayerWalking
    WaterMovementState=PlayerSwimming
    ControllerClass=Class'AIController'
    RemoteRole=ROLE_SimulatedProxy
    DrawType=2
    bCanTeleport=True
    bOwnerNoSee=True
    bStasis=True
    bAcceptsProjectors=True
    bDisturbFluidSurface=True
    bUpdateSimulatedPosition=True
    bTravel=True
    bShouldBaseAtStartup=True
    bCollideActors=True
    bCollideWorld=True
    bBlockActors=True
    bBlockPlayers=True
    bProjTarget=True
    bRotateToDesired=True
    bDirectional=True
    SoundRadius=9.00
    TransientSoundVolume=2.00
    CollisionRadius=34.00
    CollisionHeight=78.00
    NetPriority=2.00
    RotationRate=(Pitch=4096,Yaw=20000,Roll=3072)
}
/*
    Texture=Texture'S_Pawn'
*/

