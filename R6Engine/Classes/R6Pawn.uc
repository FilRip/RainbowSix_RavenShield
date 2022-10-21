//================================================================================
// R6Pawn.
//================================================================================
class R6Pawn extends R6AbstractPawn
	Native
	Abstract;

enum EWeaponSound {
	WSOUND_None,
	WSOUND_Initialize,
	WSOUND_PlayTrigger,
	WSOUND_PlayFireSingleShot,
	WSOUND_PlayFireEndSingleShot,
	WSOUND_PlayFireThreeBurst,
	WSOUND_PlayFireFullAuto,
	WSOUND_PlayEmptyMag,
	WSOUND_PlayReloadEmpty,
	WSOUND_PlayReload,
	WSOUND_StopFireFullAuto
};

enum eStrafeDirection {
	STRAFE_None,
	STRAFE_ForwardRight,
	STRAFE_ForwardLeft,
	STRAFE_BackwardRight,
	STRAFE_BackwardLeft
};

enum eMovementPace {
	PACE_None,
	PACE_Prone,
	PACE_CrouchWalk,
	PACE_CrouchRun,
	PACE_Walk,
	PACE_Run
};

enum eMovementDirection {
	MOVEDIR_Forward,
	MOVEDIR_Backward,
	MOVEDIR_Strafe
};

enum ETerroristType {
	TTYPE_B1T1,
	TTYPE_B1T3,
	TTYPE_B2T2,
	TTYPE_B2T4,
	TTYPE_M1T1,
	TTYPE_M1T3,
	TTYPE_M2T2,
	TTYPE_M2T4,
	TTYPE_P1T1,
	TTYPE_P2T2,
	TTYPE_P3T3,
	TTYPE_P1T4,
	TTYPE_P2T5,
	TTYPE_P3T6,
	TTYPE_P1T7,
	TTYPE_P2T8,
	TTYPE_P3T9,
	TTYPE_P1T10,
	TTYPE_P2T11,
	TTYPE_P3T12,
	TTYPE_P4T13,
	TTYPE_D1T1,
	TTYPE_D1T2,
	TTYPE_GOSP,
	TTYPE_GUTI,
	TTYPE_S1T1,
	TTYPE_S1T2,
	TTYPE_TXIC,
	TTYPE_T1T1,
	TTYPE_T2T2,
	TTYPE_T1T3,
	TTYPE_T2T4
};

enum EHeadAttachmentType {
	ATTACH_Glasses,
	ATTACH_Sunglasses,
	ATTACH_GasMask,
	ATTACH_None
};

enum eArmor {
	ARMOR_None,
	ARMOR_Light,
	ARMOR_Medium,
	ARMOR_Heavy
};

enum eBodyPart {
	BP_Head,
	BP_Chest,
	BP_Abdomen,
	BP_Legs,
	BP_Arms
};

struct STWeaponAnim
{
	var name nAnimToPlay;
	var name nBlendName;
	var float fTweenTime;
	var float fRate;
	var bool bPlayOnce;
	var bool bBackward;
};

enum EHostagePersonality {
	HPERSO_Coward,
	HPERSO_Normal,
	HPERSO_Brave,
	HPERSO_Bait,
	HPERSO_None
};

enum eDeviceAnimToPlay {
	BA_ArmBomb,
	BA_DisarmBomb,
	BA_Keypad,
	BA_PlantDevice,
	BA_Keyboard
};

enum eHands {
	HANDS_None,
	HANDS_Right,
	HANDS_Left,
	HANDS_Both
};

const C_MaxPendingAction= 5;

enum EPendingAction {
	PENDING_None,
	PENDING_Coughing,
	PENDING_StopCoughing,
	PENDING_Blinded,
	PENDING_OpenDoor,
	PENDING_StartClimbingLadder,
	PENDING_PostStartClimbingLadder,
	PENDING_EndClimbingLadder,
	PENDING_PostEndClimbingLadder,
	PENDING_DropWeapon,
	PENDING_ProneToCrouch,
	PENDING_CrouchToProne,
	PENDING_MoveHitBone,
	PENDING_StartClimbingObject,
	PENDING_PostStartClimbingObject,
	PENDING_SetRemoteCharge,
	PENDING_SetBreachingCharge,
	PENDING_SetClaymore,
	PENDING_InteractWithDevice,
	PENDING_LockPickDoor,
	PENDING_ComFollowMe,
	PENDING_ComCover,
	PENDING_ComGo,
	PENDING_ComRegroup,
	PENDING_ComHold,
	PENDING_ActivateNightVision,
	PENDING_DeactivateNightVision,
	PENDING_SecureWeapon,
	PENDING_EquipWeapon,
	PENDING_SecureTerrorist,
	PENDING_ThrowGrenade,
	PENDING_Surrender,
	PENDING_Kneeling,
	PENDING_Arrest,
	PENDING_CallBackup,
	PENDING_SpecialAnim,
	PENDING_LoopSpecialAnim,
	PENDING_StopSpecialAnim,
	PENDING_HostageAnim,
	PENDING_EndSurrender,
	PENDING_StartSurrender,
	PENDING_PostEndSurrender,
	PENDING_SetFree,
	PENDING_ArrestKneel,
	PENDING_ArrestWaiting,
	PENDING_EndArrest
};

const C_fHeadHeight= 26.f;
const C_fHeadRadius= 22.f;
const C_fPrePivotStairOffset= 5.0;
const C_iPawnSpecificChannel= 16;
const C_iWeaponLeftAnimChannel= 15;
const C_iWeaponRightAnimChannel= 14;
const C_iPeekingAnimChannel= 13;
const C_iPostureAnimChannel= 12;
const C_iBaseBlendAnimChannel= 1;
const C_iBaseAnimChannel= 0;
const C_iHeartRateMinOther= 90;
const C_iHeartRateMinTerrorist= 65;
const C_iHeartRateMaxOther= 182;
const C_iHeartRateMaxTerrorist= 184;
const C_NoiseTimerFrequency= 0.33f;
const C_iRotationOffsetBipod= 5600;
const C_iRotationOffsetProne= 3000;
const C_iRotationOffsetNormal= 5461;
const C_fPeekProneTime=  120.0;
const C_fPeekSpeedInMs= 3000.0;
const C_fPeekCrouchRightMax= 1600.0;
const C_fPeekCrouchLeftMax=  400.0;
const C_fPeekRightMax= 2000.0;
const C_fPeekMiddleMax= 1000.0;
const C_fPeekLeftMax=    0.0;
var eMovementPace m_eMovementPace;
var EPendingAction m_ePendingAction[5];
var byte m_iNetCurrentActionIndex;
var byte m_iLocalCurrentActionIndex;
var eHands m_ePlayerIsUsingHands;
var eDeviceAnimToPlay m_eDeviceAnim;
var eHands m_eLastUsingHands;
var eHands m_ePawnIsUsingHand;
var(Equip) eArmor m_eArmorType;
var ePeekingMode m_eOldPeekingMode;
var byte m_bSuicideType;
var eBodyPart m_eLastHitPart;
var eStrafeDirection m_eStrafeDirection;
var byte m_bRepPlayWaitAnim;
var byte m_bSavedPlayWaitAnim;
var byte m_byRemainingWaitZero;
var int m_iPendingActionInt[5];
var() int m_iID;
var() int m_iPermanentID;
var int m_iVisibilityTest;
var int m_iForceKill;
var int m_iForceStun;
var int m_iMaxRotationOffset;
var int m_iRepBipodRotationRatio;
var int m_iLastBipodRotation;
var int m_iUniqueID;
var int m_hLipSynchData;
var int m_iDesignRandomTweak;
var int m_iDesignLightTweak;
var int m_iDesignMediumTweak;
var int m_iDesignHeavyTweak;
var bool m_bIsClimbingStairs;
var bool m_bIsMovingUpStairs;
var bool m_bIsClimbingLadder;
var bool m_bSlideEnd;
var bool m_bCanClimbObject;
var bool m_bOldCanWalkOffLedges;
var bool m_bActivateHeatVision;
var bool m_bActivateNightVision;
var bool m_bActivateScopeVision;
var bool m_bWeaponGadgetActivated;
var bool m_bIsKneeling;
var bool m_bIsSniping;
var bool m_bPlayingComAnimation;
var bool m_bDontKill;
var bool m_bPreviousAnimPlayOnce;
var bool m_bToggleServerCancelPlacingCharge;
var bool m_bOldServerCancelPlacingCharge;
var bool m_bReAttachToRightHand;
var bool m_bReloadingWeapon;
var bool m_bReloadAnimLoop;
var bool m_bChangingWeapon;
var bool m_bIsFiringState;
var bool m_bPawnIsReloading;
var bool m_bPawnIsChangingWeapon;
var bool m_bPawnReloadShotgunLoop;
var bool m_bPeekingReturnToCenter;
var bool m_bWasPeeking;
var bool m_bWasPeekingLeft;
var bool m_bAutoClimbLadders;
var bool m_bAim;
var bool m_bPostureTransition;
var bool m_bWeaponTransition;
var bool m_bPawnSpecificAnimInProgress;
var bool m_bSoundChangePosture;
var bool m_bNightVisionAnimation;
var bool m_bSuicided;
var bool m_bAvoidFacingWalls;
var bool m_bWallAdjustmentDone;
var(Debug) bool m_bDontSeePlayer;
var(Debug) bool m_bDontHearPlayer;
var(Debug) bool m_bUseKarmaRagdoll;
var bool m_bTerroSawMeDead;
var bool m_bInteractingWithDevice;
var bool m_bCanDisarmBomb;
var bool m_bCanArmBomb;
var bool m_bUsingBipod;
var bool m_bLeftFootDown;
var(DEBUG_Bones) bool m_bModifyBones;
var bool m_bHelmetWasHit;
var bool m_bMovingDiagonally;
var bool m_bEngaged;
var bool m_bHasArmPatches;
var bool m_bCanFireFriends;
var bool m_bCanFireNeutrals;
var bool m_bDesignToggleLog;
var(Personality) float m_fSkillAssault;
var(Personality) float m_fSkillDemolitions;
var(Personality) float m_fSkillElectronics;
var(Personality) float m_fSkillSniper;
var(Personality) float m_fSkillStealth;
var(Personality) float m_fSkillSelfControl;
var(Personality) float m_fSkillLeadership;
var(Personality) float m_fSkillObservation;
var float m_fFallingHeight;
var float m_fWalkingSpeed;
var float m_fWalkingBackwardStrafeSpeed;
var float m_fRunningSpeed;
var float m_fRunningBackwardStrafeSpeed;
var float m_fCrouchedWalkingSpeed;
var float m_fCrouchedWalkingBackwardStrafeSpeed;
var float m_fCrouchedRunningSpeed;
var float m_fCrouchedRunningBackwardStrafeSpeed;
var float m_fProneSpeed;
var float m_fProneStrafeSpeed;
var float m_fLastValidPeeking;
var float m_fOldCrouchBlendRate;
var float m_fOldPeekBlendRate;
var float m_fPeekingGoalModifier;
var float m_fPeekingGoal;
var float m_fPeeking;
var float m_fWallCheckDistance;
var float m_fStunShakeTime;
var float m_fWeaponJump;
var float m_fZoomJumpReturn;
var float m_fNoiseTimer;
var float m_fLastFSPUpdate;
var float m_fLastVRPUpdate;
var float m_fBipodRotation;
var float m_fTimeStartBodyFallSound;
var float m_fFiringTimer;
var float m_fHBTime;
var float m_fHBMove;
var float m_fHBWound;
var float m_fHBDefcon;
var float m_fPrePivotLastUpdate;
var float m_fLeftDirtyFootStepRemainingTime;
var float m_fRightDirtyFootStepRemainingTime;
var float m_fTimeGrenadeEffectBeforeSound;
var R6AbstractBulletManager m_pBulletManager;
var R6Ladder m_Ladder;
var Actor m_potentialActionActor;
var R6Door m_Door;
var R6Door m_Door2;
var R6ClimbableObject m_climbObject;
var Sound m_sndNightVisionActivation;
var Sound m_sndNightVisionDeactivation;
var Sound m_sndCrouchToStand;
var Sound m_sndStandToCrouch;
var Sound m_sndThermalScopeActivation;
var Sound m_sndThermalScopeDeactivation;
var Sound m_sndDeathClothes;
var Sound m_sndDeathClothesStop;
var R6AbstractCorpse m_ragdoll;
var R6Pawn m_KilledBy;
var Actor m_TrackActor;
var Actor m_FOV;
var Emitter m_BreathingEmitter;
var R6ArmPatchGlow m_ArmPatches[2];
var R6TeamMemberReplicationInfo m_TeamMemberRepInfo;
var R6SoundReplicationInfo m_SoundRepInfo;
var name m_WeaponAnimPlaying;
var name m_standRunForwardName;
var name m_standRunLeftName;
var name m_standRunBackName;
var name m_standRunRightName;
var name m_standWalkForwardName;
var name m_standWalkBackName;
var name m_standWalkLeftName;
var name m_standWalkRightName;
var name m_hurtStandWalkLeftName;
var name m_hurtStandWalkRightName;
var name m_standTurnLeftName;
var name m_standTurnRightName;
var name m_standFallName;
var name m_standLandName;
var name m_crouchFallName;
var name m_crouchLandName;
var name m_crouchWalkForwardName;
var name m_standStairWalkUpName;
var name m_standStairWalkUpBackName;
var name m_standStairWalkUpRightName;
var name m_standStairWalkDownName;
var name m_standStairWalkDownBackName;
var name m_standStairWalkDownRightName;
var name m_standStairRunUpName;
var name m_standStairRunUpBackName;
var name m_standStairRunUpRightName;
var name m_standStairRunDownName;
var name m_standStairRunDownBackName;
var name m_standStairRunDownRightName;
var name m_crouchStairWalkDownName;
var name m_crouchStairWalkDownBackName;
var name m_crouchStairWalkDownRightName;
var name m_crouchStairWalkUpName;
var name m_crouchStairWalkUpBackName;
var name m_crouchStairWalkUpRightName;
var name m_crouchStairRunUpName;
var name m_crouchStairRunDownName;
var name m_crouchDefaultAnimName;
var name m_standDefaultAnimName;
var name m_standClimb64DefaultAnimName;
var name m_standClimb96DefaultAnimName;
var Class<Actor> m_FOVClass;
var Class<R6FootStep> m_LeftDirtyFootStep;
var Class<R6FootStep> m_RightDirtyFootStep;
var Vector m_vStairDirection;
var Rotator m_rHitDirection;
var Rotator m_rPrevRotationOffset;
var Vector m_vFiringStartPoint;
var Rotator m_rViewRotation;
var(DEBUG_Bones) Rotator m_rRoot;
var(DEBUG_Bones) Rotator m_rPelvis;
var(DEBUG_Bones) Rotator m_rSpine;
var(DEBUG_Bones) Rotator m_rSpine1;
var(DEBUG_Bones) Rotator m_rSpine2;
var(DEBUG_Bones) Rotator m_rNeck;
var(DEBUG_Bones) Rotator m_rHead;
var(DEBUG_Bones) Rotator m_rPonyTail1;
var(DEBUG_Bones) Rotator m_rPonyTail2;
var(DEBUG_Bones) Rotator m_rJaw;
var(DEBUG_Bones) Rotator m_rLClavicle;
var(DEBUG_Bones) Rotator m_rLUpperArm;
var(DEBUG_Bones) Rotator m_rLForeArm;
var(DEBUG_Bones) Rotator m_rLHand;
var(DEBUG_Bones) Rotator m_rLFinger0;
var(DEBUG_Bones) Rotator m_rRClavicle;
var(DEBUG_Bones) Rotator m_rRUpperArm;
var(DEBUG_Bones) Rotator m_rRForeArm;
var(DEBUG_Bones) Rotator m_rRHand;
var(DEBUG_Bones) Rotator m_rRFinger0;
var(DEBUG_Bones) Rotator m_rLThigh;
var(DEBUG_Bones) Rotator m_rLCalf;
var(DEBUG_Bones) Rotator m_rLFoot;
var(DEBUG_Bones) Rotator m_rLToe;
var(DEBUG_Bones) Rotator m_rRThigh;
var(DEBUG_Bones) Rotator m_rRCalf;
var(DEBUG_Bones) Rotator m_rRFoot;
var(DEBUG_Bones) Rotator m_rRToe;
var Vector m_vPrePivotProneBackup;

replication
{
	reliable if ( Role == Role_Authority )
		ClientSetFree,Arrested,ClientSurrender,m_ePendingAction,m_iNetCurrentActionIndex,m_iPendingActionInt;
	unreliable if ( Role == Role_Authority )
		R6ClientAffectedByFlashbang,ClientSetJumpValues;
	reliable if ( Role < Role_Authority )
		ServerGivesWeaponToClient,ServerClimbLadder,ServerActionRequest;
	unreliable if ( Role < Role_Authority )
		ServerPlayReloadAnimAgain,ServerForceStunResult,ServerForceKillResult,ServerPerformDoorAction,ServerSwitchReloadingWeapon,ServerSuicidePawn;
	reliable if ( Role == Role_Authority )
		m_ePlayerIsUsingHands,m_eDeviceAnim,m_bSuicideType,m_bRepPlayWaitAnim,m_iForceKill,m_iForceStun,m_iRepBipodRotationRatio,m_bIsClimbingLadder,m_bIsKneeling,m_bReloadingWeapon,m_bReloadAnimLoop,m_bChangingWeapon,m_bPawnSpecificAnimInProgress,m_bInteractingWithDevice,m_bCanDisarmBomb,m_bCanArmBomb,m_bEngaged,m_bHasArmPatches,m_bCanFireFriends,m_bCanFireNeutrals,m_fFallingHeight,m_fBipodRotation,m_Ladder,m_potentialActionActor,m_climbObject,m_KilledBy,m_TeamMemberRepInfo,m_SoundRepInfo,m_rHitDirection;
	reliable if (  !bNetOwner && (Role == Role_Authority) )
		m_bToggleServerCancelPlacingCharge,m_fPeekingGoal;
}

native(2002) final function eKillResult GetKillResult (int iKillDamage, int ePartHit, int eArmorType, int iBulletToArmorModifier, bool bHitBySilencedWeapon);

native(2003) final function eStunResult GetStunResult (int iStunDamage, int ePartHit, int eArmorType, int iBulletToArmorModifier, bool bHitBySilencedWeapon);

native(2006) final function int GetThroughResult (int iKillDamage, int ePartHit, Vector vBulletDirection);

native(2004) final function ToggleHeatProperties (bool bTurnItOn, Texture pMaskTexture, Texture pAddTexture);

native(2600) final function ToggleNightProperties (bool bTurnItOn, Texture pMaskTexture, Texture pAddTexture);

native(2605) final function ToggleScopeProperties (bool bTurnItOn, Texture pMaskTexture, Texture pAddTexture);

native(2200) final function bool AdjustFluidCollisionCylinder (float fBlendRate, optional bool bTest);

native(2212) final function SetPawnScale (float fNewScale);

native(1507) final function bool CheckCylinderTranslation (Vector vStart, Vector vDest, optional Actor ignoreActor1, optional bool bIgnoreAllActor1Class);

native(1508) final function float GetPeekingRatioNorm (float fPeeking);

native(1512) final function int GetMaxRotationOffset ();

native(1517) final function eMovementDirection GetMovementDirection ();

native(2611) final function StartLipSynch (Sound _hSound, Sound _hStopSound);

native(1603) final function StopLipSynch ();

native(1846) final function MoveHitBone (Rotator rHitDirection, int iHitBone);

native(1844) final function FootStep (name nBoneName, bool bLeftFoot);

native(2214) final function PawnLook (Rotator rLookDir, optional bool bAim, optional bool bNoBlend);

native(2215) final function PawnLookAbsolute (Rotator rLookDir, optional bool bAim, optional bool bNoBlend);

native(2216) final function PawnLookAt (Vector vTarget, optional bool bAim, optional bool bNoBlend);

native(2217) final function PawnTrackActor (Actor Target, optional bool bAim);

native(2218) final function UpdatePawnTrackActor (optional bool bNoBlend);

native(1841) final function Rotator R6GetViewRotation ();

native(1842) final function Rotator GetRotationOffset ();

native(1845) final function bool PawnCanBeHurtFrom (Vector vLocation);

native(2729) final function SendPlaySound (Sound S, ESoundSlot ID, optional bool bDoNotPlayLocallySound);

native(2730) final function PlayVoices (Sound sndPlayVoice, ESoundSlot eSlotUse, int iPriority, optional ESendSoundStatus eSend, optional bool bWaitToFinishSound, optional float fTime);

native(2731) final function SetAudioInfo ();

simulated event ZoneChange (ZoneInfo NewZone)
{
	local int i;
	local PlayerController PC;
	local ZoneInfo WZ;

	if ( (Level.m_WeatherEmitter == None) || (Level.m_WeatherEmitter.Emitters.Length == 0) )
	{
		return;
	}
	PC=PlayerController(Controller);
	if ( (PC == None) || (Viewport(PC.Player) == None) )
	{
		return;
	}
	WZ=Region.Zone;
	if ( WZ.m_bAlternateEmittersActive )
	{
		i=0;
JL0097:
		if ( i < WZ.m_AlternateWeatherEmitters.Length )
		{
			if ( WZ.m_AlternateWeatherEmitters[i].Emitters.Length > 0 )
			{
				WZ.m_AlternateWeatherEmitters[i].Emitters[0].m_iPaused=1;
				WZ.m_AlternateWeatherEmitters[i].Emitters[0].AllParticlesDead=False;
			}
			i++;
			goto JL0097;
		}
		WZ.m_bAlternateEmittersActive=False;
	}
	if (  !NewZone.m_bAlternateEmittersActive )
	{
		i=0;
JL015F:
		if ( i < NewZone.m_AlternateWeatherEmitters.Length )
		{
			if ( NewZone.m_AlternateWeatherEmitters[i].Emitters.Length > 0 )
			{
				NewZone.m_AlternateWeatherEmitters[i].Emitters[0].m_iPaused=0;
				NewZone.m_AlternateWeatherEmitters[i].Emitters[0].AllParticlesDead=False;
			}
			i++;
			goto JL015F;
		}
		NewZone.m_bAlternateEmittersActive=True;
	}
}

function bool ProcessBuildDeathMessage (Pawn Killer, out string szPlayerName)
{
	szPlayerName="";
	if ( PlayerReplicationInfo != None )
	{
		szPlayerName=PlayerReplicationInfo.PlayerName;
		return True;
	}
	return False;
}

static function string BuildDeathMessage (string Killer, string Killed, byte bDeathMsgType)
{
	local string DeathMessage;

	if ( bDeathMsgType == 1 )
	{
		DeathMessage=Killed $ " " $ Localize("MPDeathMessages","LeftTheGame","R6GameInfo");
	}
	else
	{
		if ( bDeathMsgType == 2 )
		{
			DeathMessage="" $ Localize("MPDeathMessages","PenaltyTo","R6GameInfo") $ " " $ Killer;
		}
		else
		{
			if ( bDeathMsgType == 5 )
			{
				DeathMessage=Localize("MPDeathMessages","HostageHasDied","R6GameInfo");
			}
			else
			{
				if ( bDeathMsgType == 9 )
				{
					DeathMessage=Killer $ " " $ Localize("MPDeathMessages","PlayerKilledByBomb","R6GameInfo");
				}
				else
				{
					if ( bDeathMsgType == 7 )
					{
						DeathMessage=Killer $ " " $ Localize("MPDeathMessages","TerroKilledHostage","R6GameInfo");
					}
					else
					{
						if ( (bDeathMsgType == 3) || (Killer == Killed) )
						{
							DeathMessage=Killer $ " " $ Localize("MPDeathMessages","PlayerSuicided","R6GameInfo");
						}
						else
						{
							if ( bDeathMsgType == 6 )
							{
								DeathMessage=Killer $ " " $ Localize("MPDeathMessages","KilledAHostage","R6GameInfo");
							}
							else
							{
								if ( bDeathMsgType == 8 )
								{
									DeathMessage=Localize("MPDeathMessages","TerroKilledPlayer","R6GameInfo") $ " " $ Killed;
								}
								else
								{
									DeathMessage=Killer $ " " $ Localize("MPDeathMessages","PlayerKilledPlayer","R6GameInfo") $ " " $ Killed;
								}
							}
						}
					}
				}
			}
		}
	}
	return DeathMessage;
}

simulated function logX (string szText)
{
	local string szSource;
	local string Time;

	if ( Controller != None )
	{
		Controller.logX(szText,1);
	}
	else
	{
		Time=string(Level.TimeSeconds);
		Time=Left(Time,InStr(Time,".") + 3);
		szSource="(" $ Time $ ":P) ";
		Log(szSource $ string(Name) $ " [ None |" $ string(GetStateName()) $ "] " $ szText);
	}
}

simulated function logWarning (string Text)
{
	Log(" *********************************************************************************** ");
	logX(" WARNING!!! " $ Text);
	Log(" *********************************************************************************** ");
}

event float GetSkill (ESkills eSkillName)
{
	local float fSkill;
	local float fLevelMul;

	switch (eSkillName)
	{
		case SKILL_Assault:
		fSkill=m_fSkillAssault;
		break;
		case SKILL_Demolitions:
		fSkill=m_fSkillDemolitions;
		break;
		case SKILL_Electronics:
		fSkill=m_fSkillElectronics;
		break;
		case SKILL_Sniper:
		fSkill=m_fSkillSniper;
		break;
		case SKILL_Stealth:
		fSkill=m_fSkillStealth;
		break;
		case SKILL_SelfControl:
		fSkill=m_fSkillSelfControl;
		break;
		case SKILL_Leadership:
		fSkill=m_fSkillLeadership;
		break;
		case SKILL_Observation:
		fSkill=m_fSkillObservation;
		break;
		default:
	}
	fLevelMul=1.00;
	if (  !m_bIsPlayer )
	{
		if ( m_ePawnType == 2 )
		{
			fLevelMul=Level.m_fTerroSkillMultiplier;
		}
		else
		{
			if ( m_ePawnType == 1 )
			{
				fLevelMul=Level.m_fRainbowSkillMultiplier;
			}
		}
	}
	return SkillModifier() * fSkill * fLevelMul;
}

function float SkillModifier ()
{
	local float fFactor;

	fFactor=1.00;
	if ( m_eHealth == 1 )
	{
		fFactor *= 0.75;
	}
	if ( m_eEffectiveGrenade == 2 )
	{
		fFactor *= 0.75;
	}
	return fFactor;
}

function float ArmorSkillEffect ()
{
	return 1.00;
}

function IncrementBulletsFired ();

function ClientSetJumpValues (float fNewValue)
{
	m_fWeaponJump=fNewValue;
	m_fZoomJumpReturn=1.00;
}

function bool HasBumpPriority (R6Pawn bumpedBy)
{
	return True;
}

event R6MakeMovementNoise ()
{
	if ( R6AbstractGameInfo(Level.Game) != None )
	{
		R6AbstractGameInfo(Level.Game).GetNoiseMgr().R6MakePawnMovementNoise(self);
	}
}

simulated event R6DeadEndedMoving ()
{
	local bool bSpawnBloodBath;
	local Vector vBloodBathLocation;
	local Rotator rBloodBathRotation;
	local R6BloodBath BloodBath;
	local Vector vFloorLocation;
	local Vector vFloorNormal;
	local Vector vTraceEnd;

	bProjTarget=False;
	if ( Level.NetMode != 1 )
	{
		SendPlaySound(m_sndDeathClothesStop,SLOT_SFX);
		switch (m_eLastHitPart)
		{
			case BP_Head:
			bSpawnBloodBath=True;
			vBloodBathLocation=GetBoneCoords('R6 Head',True).Origin;
			break;
			case BP_Chest:
			bSpawnBloodBath=True;
			vBloodBathLocation=GetBoneCoords('R6 Spine2',True).Origin;
			break;
			case BP_Abdomen:
			bSpawnBloodBath=True;
			vBloodBathLocation=GetBoneCoords('R6 Spine',True).Origin;
			break;
			case BP_Legs:
			bSpawnBloodBath=False;
			break;
			case BP_Arms:
			bSpawnBloodBath=False;
			break;
			default:
		}
		if ( bSpawnBloodBath == True )
		{
			rBloodBathRotation.Pitch=-16384;
			rBloodBathRotation.Yaw=0;
			rBloodBathRotation.Roll=Rand(65535);
			vTraceEnd=vBloodBathLocation + vector(rBloodBathRotation) * 250;
			if ( Trace(vFloorLocation,vFloorNormal,vTraceEnd,vBloodBathLocation) != None )
			{
				vFloorLocation.Z += 4;
//				Level.m_DecalManager.AddDecal(vFloorLocation,rBloodBathRotation,Texture'BloodBath',DECAL_BloodBaths,1,0.00,0.00,50.00);
			}
		}
	}
}

simulated function FirstPassReset ()
{
	m_KilledBy=None;
}

simulated event Destroyed ()
{
	local int iCounter;
	local Actor A;
	local R6PlayerController aPC;

	if ( m_collisionBox != None )
	{
		A=m_collisionBox;
		m_collisionBox=None;
		A.Destroy();
		A=None;
	}
	if ( m_collisionBox2 != None )
	{
		A=m_collisionBox2;
		m_collisionBox2=None;
		A.Destroy();
		A=None;
	}
	aPC=R6PlayerController(Controller);
	if ( (aPC != None) && (aPC.m_TeamManager != None) )
	{
		aPC.m_TeamManager.ResetTeam();
	}
	Super.Destroyed();
	iCounter=0;
JL00B6:
	if ( iCounter < 4 )
	{
		if ( m_WeaponsCarried[iCounter] != None )
		{
			m_WeaponsCarried[iCounter].Destroy();
			m_WeaponsCarried[iCounter]=None;
		}
		iCounter++;
		goto JL00B6;
	}
	iCounter=0;
JL0103:
	if ( iCounter < 2 )
	{
		if ( m_ArmPatches[iCounter] != None )
		{
			m_ArmPatches[iCounter].Destroy();
			m_ArmPatches[iCounter]=None;
		}
		iCounter++;
		goto JL0103;
	}
	if ( m_SoundRepInfo != None )
	{
		m_SoundRepInfo.Destroy();
		m_SoundRepInfo=None;
	}
	if ( EngineWeapon != None )
	{
		EngineWeapon.Destroy();
		EngineWeapon=None;
	}
	if ( m_pBulletManager != None )
	{
		m_pBulletManager.Destroy();
		m_pBulletManager=None;
	}
	if ( m_TeamMemberRepInfo != None )
	{
		m_TeamMemberRepInfo.Destroy();
		m_TeamMemberRepInfo=None;
	}
	if ( m_BreathingEmitter != None )
	{
		if ( m_BreathingEmitter.Emitters.Length != 0 )
		{
			m_BreathingEmitter.Emitters[0].AllParticlesDead=False;
			m_BreathingEmitter.Emitters[0].m_iPaused=1;
		}
		DetachFromBone(m_BreathingEmitter);
		m_BreathingEmitter.Destroy();
		m_BreathingEmitter=None;
	}
	foreach AllActors(Class'Actor',A)
	{
		if ( A.Instigator == self )
		{
			A.Instigator=None;
		}
	}
}

function Rotator GetFiringRotation ()
{
	return GetViewRotation();
}

function Vector GetHandLocation ()
{
	return GetBoneCoords('R6 R Hand').Origin;
}

event Vector GetFiringStartPoint ()
{
	if ( m_fLastFSPUpdate != Level.TimeSeconds )
	{
		m_fLastFSPUpdate=Level.TimeSeconds;
		m_vFiringStartPoint=Location + EyePosition();
	}
	return m_vFiringStartPoint;
}

function Vector GetGrenadeStartLocation (eGrenadeThrow eThrow)
{
	local Vector vStart;

	vStart=Location + EyePosition();
	if ( (eThrow == 4) || (eThrow == 5) || (eThrow == 2) )
	{
		if ( m_bIsProne )
		{
			vStart -= vect(0.00,0.00,10.00);
		}
		else
		{
			if ( bIsCrouched )
			{
				vStart -= vect(0.00,0.00,30.00);
			}
			else
			{
				vStart -= vect(0.00,0.00,40.00);
			}
		}
	}
	return vStart;
}

function RenderGunDirection (Canvas C)
{
	C.Draw3DLine(GetFiringStartPoint(),GetFiringStartPoint() + vector(GetFiringRotation()) * 10000,Class'Canvas'.static.MakeColor(255,0,0));
}

function DrawViewRotation (Canvas C)
{
	C.Draw3DLine(Location + EyePosition(),Location + EyePosition() + 70 * vector(GetViewRotation()),Class'Canvas'.static.MakeColor(255,0,0));
}

simulated function FaceRotation (Rotator NewRotation, float DeltaTime)
{
	if ( Physics == 11 )
	{
		if ( OnLadder != None )
		{
			SetRotation(OnLadder.LadderList.Rotation);
		}
		else
		{
			if ( Level.NetMode != 0 )
			{
				m_bPostureTransition=False;
				R6ResetAnimBlendParams(1);
				SetPhysics(PHYS_Walking);
			}
		}
	}
	else
	{
		if ( (Physics == 1) || (Physics == 2) || (Physics == 12) )
		{
			NewRotation.Pitch=0;
		}
		SetRotation(NewRotation);
	}
}

function PossessedBy (Controller C)
{
	Super.PossessedBy(C);
	if ( Controller.IsA('PlayerController') )
	{
		m_bIsPlayer=True;
		AvoidLedges(False);
	}
	else
	{
		AvoidLedges(True);
	}
	if ( m_SoundRepInfo != None )
	{
		m_SoundRepInfo.m_PawnRepInfo=Controller.m_PawnRepInfo;
	}
	Controller.FocalPoint=Location + vector(Rotation);
}

function SetDefaultWalkAnim ()
{
	m_standWalkForwardName=Default.m_standWalkForwardName;
	m_standWalkBackName=Default.m_standWalkBackName;
	m_standWalkLeftName=Default.m_standWalkLeftName;
	m_standWalkRightName=Default.m_standWalkRightName;
	m_standTurnLeftName=Default.m_standTurnLeftName;
	m_standTurnRightName=Default.m_standTurnRightName;
	m_standRunForwardName=Default.m_standRunForwardName;
	m_standRunLeftName=Default.m_standRunLeftName;
	m_standRunBackName=Default.m_standRunBackName;
	m_standRunRightName=Default.m_standRunRightName;
	m_standDefaultAnimName=Default.m_standDefaultAnimName;
	m_standClimb64DefaultAnimName=Default.m_standClimb64DefaultAnimName;
	m_standClimb96DefaultAnimName=Default.m_standClimb96DefaultAnimName;
	m_standStairWalkUpName=Default.m_standStairWalkUpName;
	m_standStairWalkDownName=Default.m_standStairWalkDownName;
}

simulated event PostNetBeginPlay ()
{
	Super.PostNetBeginPlay();
	if ( Level.NetMode != 3 )
	{
		m_iLocalCurrentActionIndex=0;
		m_iNetCurrentActionIndex=0;
	}
	if ( Controller == None )
	{
		return;
	}
	if ( Controller.IsA('PlayerController') && (PlayerController(Controller).Player != None) && PlayerController(Controller).Player.IsA('Viewport') )
	{
		m_bIsPlayer=True;
	}
}

simulated event PostBeginPlay ()
{
	local int iCounter;
	local R6GameOptions GameOptions;

	GameOptions=GetGameOptions();
	Super.PostBeginPlay();
	if ( Role == Role_Authority )
	{
		R6AbstractGameInfo(Level.Game).SetPawnTeamFriendlies(self);
		m_SoundRepInfo=Spawn(Class'R6SoundReplicationInfo');
		m_SoundRepInfo.m_pawnOwner=self;
		m_SoundRepInfo.m_NewWeaponSound=1;
		m_fHeartBeatTime[0]=Rand(1000 / m_fHeartBeatFrequency / 60);
		m_fHeartBeatTime[1]=m_fHeartBeatTime[0];
	}
	if ( Level.NetMode != 1 )
	{
		if ( m_bHasArmPatches )
		{
			m_ArmPatches[0]=Spawn(Class'R6ArmPatchGlow');
			m_ArmPatches[0].m_pOwnerNightVision=self;
			m_ArmPatches[0].m_AttachedBoneName='R6 L UpperArm';
			m_ArmPatches[0].m_fMatrixMul=1.00;
			m_ArmPatches[1]=Spawn(Class'R6ArmPatchGlow');
			m_ArmPatches[1].m_pOwnerNightVision=self;
			m_ArmPatches[1].m_AttachedBoneName='R6 R UpperArm';
			m_ArmPatches[1].m_fMatrixMul=-1.00;
		}
		if ( (Level.m_BreathingEmitterClass != None) && (m_BreathingEmitter == None) )
		{
			m_BreathingEmitter=Spawn(Level.m_BreathingEmitterClass);
			if ( m_BreathingEmitter != None )
			{
				AttachToBone(m_BreathingEmitter,'R6 Head');
				m_BreathingEmitter.SetRelativeLocation(vect(0.00,-20.00,0.00));
			}
		}
		if ( Class'Actor'.static.IsVideoHardwareAtLeast64M() && ((m_ePawnType == 1) && (GameOptions.RainbowsShadowLevel == 3) || (m_ePawnType == 3) && (GameOptions.HostagesShadowLevel == 3) || (m_ePawnType == 2) && (GameOptions.TerrosShadowLevel == 3)) )
		{
			Shadow=Spawn(Class'ShadowProjector',self,'None',Location);
			ShadowProjector(Shadow).ShadowActor=self;
			ShadowProjector(Shadow).UpdateShadow();
		}
		else
		{
			if ( (m_ePawnType == 1) && (GameOptions.RainbowsShadowLevel != 0) || (m_ePawnType == 3) && (GameOptions.HostagesShadowLevel != 0) || (m_ePawnType == 2) && (GameOptions.TerrosShadowLevel != 0) )
			{
				Shadow=Spawn(Class'R6ShadowProjector',self);
			}
		}
	}
	m_iMaxRotationOffset=GetMaxRotationOffset();
	R6BlendAnim(m_standDefaultAnimName,13,0.00,'R6 Spine',0.00,0.00,True);
	m_vEyeLocation=Location;
	m_vEyeLocation.Z += 70;
}

event TornOff ()
{
	local int i;

	DropWeaponToGround();
	i=0;
JL000D:
	if ( i < 4 )
	{
		if ( m_WeaponsCarried[i] != None )
		{
			m_WeaponsCarried[i].SetTearOff(True);
		}
		i++;
		goto JL000D;
	}
}

simulated function UpdateVisualEffects (float fDeltaTime)
{
/*	if ( m_BreathingEmitter != None )
	{
		m_BreathingEmitter.Emitters[0].AllParticlesDead=False;
		m_BreathingEmitter.Emitters[0].m_iPaused=Region.Zone.m_bInDoor.Remove (if ( m_LeftDirtyFootStep != None ),m_fLeftDirtyFootStepRemainingTime -= fDeltaTime);;
		// There are 1 jump destination(s) inside the last statement!
		{
			if ( m_fLeftDirtyFootStepRemainingTime <= 0.00 )
			{
				m_LeftDirtyFootStep=None;
				m_fLeftDirtyFootStepRemainingTime=0.00;
			}
		}
	}
	if ( m_RightDirtyFootStep != None )
	{
		m_fRightDirtyFootStepRemainingTime -= fDeltaTime;
		if ( m_fRightDirtyFootStepRemainingTime <= 0.00 )
		{
			m_RightDirtyFootStep=None;
			m_fRightDirtyFootStepRemainingTime=0.00;
		}
	}*/
}

simulated function Tick (float DeltaTime)
{
	local float tempDelta;
	local float sign;
	local float fHeartBeatRateMAX;
	local float fHeartBeatRateMIN;
	local float fHeartBeatFrequency;

	Super.Tick(DeltaTime);
	if ( m_fDecrementalBlurValue > 0 )
	{
		m_fDecrementalBlurValue -= DeltaTime * 8.00;
		m_fDecrementalBlurValue=Max(m_fDecrementalBlurValue,0);
	}
	if ( Role < Role_Authority )
	{
		if ( m_bRepPlayWaitAnim != m_bSavedPlayWaitAnim )
		{
			m_bSavedPlayWaitAnim=m_bRepPlayWaitAnim;
			PlayWaiting();
		}
	}
	if ( (Role == Role_Authority) && (m_bHelmetWasHit == True) )
	{
		m_bHelmetWasHit=False;
	}
	m_fHBTime += DeltaTime;
	if ( m_fHBTime > 1.00 )
	{
		m_fHBTime=m_fHBTime - 1.00;
		if ( m_ePawnType == 2 )
		{
			fHeartBeatRateMAX=184.00;
			fHeartBeatRateMIN=65.00;
		}
		else
		{
			fHeartBeatRateMAX=182.00;
			fHeartBeatRateMIN=90.00;
		}
		fHeartBeatFrequency=fHeartBeatRateMIN * m_fHBMove * m_fHBWound * m_fHBDefcon;
		if ( m_bEngaged )
		{
			fHeartBeatFrequency *= 1.20;
		}
		if ( fHeartBeatFrequency > m_fHeartBeatFrequency )
		{
			m_fHeartBeatFrequency += 5;
			if ( m_fHeartBeatFrequency > fHeartBeatRateMAX )
			{
				m_fHeartBeatFrequency=fHeartBeatRateMAX;
			}
		}
		else
		{
			if ( fHeartBeatFrequency < m_fHeartBeatFrequency )
			{
				m_fHeartBeatFrequency -= 1;
			}
		}
	}
	UpdateVisualEffects(DeltaTime);
}

simulated event Rotator GetViewRotation ()
{
	return R6GetViewRotation();
}

simulated event SetRotationOffset (int iPitch, int iYaw, int iRoll)
{
	m_fBoneRotationTransition=0.00;
	m_rPrevRotationOffset=m_rRotationOffset;
	m_rRotationOffset.Pitch=iPitch;
	m_rRotationOffset.Yaw=iYaw;
	m_rRotationOffset.Roll=iRoll;
}

simulated event Vector EyePosition ()
{
	local Vector vEyeHeight;
	local PlayerController PC;

	if ( m_bIsPlayer )
	{
		PC=PlayerController(Controller);
		if ( (PC != None) &&  !PC.bBehindView && (PC.ViewTarget == self) )
		{
			return m_vEyeLocation - Location;
		}
	}
	if ( bIsCrouched )
	{
		vEyeHeight.Z=30.00;
	}
	else
	{
		if ( m_bIsProne )
		{
			vEyeHeight.Z=0.00;
		}
		else
		{
			if ( m_bIsKneeling )
			{
				vEyeHeight.Z=20.00;
			}
			else
			{
				vEyeHeight.Z=70.00;
			}
		}
	}
	return vEyeHeight;
}

simulated function Vector R6CalcDrawLocation (R6EngineWeapon Wep, out Rotator MoveRotation, Vector offset)
{
	local Vector drawLocation;
	local Vector bobOffset;
	local Vector vAxisX;
	local Vector vAxisY;
	local Vector vAxisZ;

	drawLocation=Location;
	if ( (Level.NetMode == NM_DedicatedServer) || (Level.NetMode == NM_ListenServer) && (RemoteRole == 3) )
	{
		drawLocation += EyePosition();
	}
	else
	{
		if ( R6PlayerController(Controller).m_bAttachCameraToEyes )
		{
			drawLocation=m_vEyeLocation;
		}
		else
		{
			drawLocation=Location + EyePosition();
		}
		GetAxes(GetViewRotation(),vAxisX,vAxisY,vAxisZ);
		drawLocation.X += vAxisX.X * offset.X + vAxisY.X * offset.Y + vAxisZ.X * offset.Z;
		drawLocation.Y += vAxisX.Y * offset.X + vAxisY.Y * offset.Y + vAxisZ.Y * offset.Z;
		drawLocation.Z += vAxisX.Z * offset.X + vAxisY.Z * offset.Y + vAxisZ.Z * offset.Z;
	}
	return drawLocation;
}

simulated function RotateBone (name BoneName, int Pitch, int Yaw, int Roll, optional float InTime)
{
	local Rotator rOffset;

	rOffset.Pitch=Pitch;
	rOffset.Yaw=Yaw;
	rOffset.Roll=Roll;
	SetBoneRotation(BoneName,rOffset,,1.00,InTime);
}

simulated function ResetBoneRotation ()
{
	SetBoneRotation('R6 PonyTail1',rot(0,0,0),,1.00,0.40);
	SetBoneRotation('R6 Head',rot(0,0,0),,1.00,0.40);
	SetBoneRotation('R6 Spine',rot(0,0,0),,1.00,0.40);
	SetBoneRotation('R6 Spine1',rot(0,0,0),,1.00,0.40);
	SetBoneRotation('R6 Neck',rot(0,0,0),,1.00,0.40);
	SetBoneRotation('R6 R Clavicle',rot(0,0,0),,1.00,0.40);
	SetBoneRotation('R6 L Clavicle',rot(0,0,0),,1.00,0.40);
}

function AimUp ()
{
	ResetBoneRotation();
	SetBoneRotation('R6 Spine',rot(0,-3000,0),,1.00);
	SetBoneRotation('R6 Neck',rot(0,-4000,0),,1.00);
}

function AimDown ()
{
	ResetBoneRotation();
	SetBoneRotation('R6 Spine',rot(0,3000,0),,1.00);
	SetBoneRotation('R6 Neck',rot(0,3000,0),,1.00);
}

function bool IsWalking ()
{
	return bIsWalking && (Velocity.X * Velocity.X + Velocity.Y * Velocity.Y + Velocity.Z * Velocity.Z > 1000);
}

function bool IsRunning ()
{
	return  !bIsWalking && (Velocity.X * Velocity.X + Velocity.Y * Velocity.Y + Velocity.Z * Velocity.Z > 1000);
}

function bool IsMovingForward ()
{
	if ( Velocity == vect(0.00,0.00,0.00) )
	{
		return True;
	}
/*	if ( (Normal(Velocity) Dot Rotation) > 0.50 )
	{
		return True;
	}
	else
	{*/
		return False;
//	}
}

function bool IsMovingUpLadder ()
{
	if ( Velocity.Z > 0 )
	{
		return True;
	}
	else
	{
		return False;
	}
}

simulated event AnimEnd (int iChannel)
{
	if ( iChannel == 0 )
	{
		if ( Physics != 12 )
		{
			PlayWaiting();
		}
	}
	else
	{
		if ( (iChannel == 1) && m_bPostureTransition )
		{
			m_bSoundChangePosture=False;
			m_bIsLanding=False;
			m_bPostureTransition=False;
		}
		else
		{
			if ( (iChannel == 14) && m_bWeaponTransition )
			{
				m_bWeaponTransition=False;
				if ( m_eGrenadeThrow != 3 )
				{
					PlayWeaponAnimation();
				}
			}
		}
	}
}

simulated function R6LoopAnim (name animName, optional float fRate, optional float fTween)
{
	if ( fRate == 0 )
	{
		fRate=1.00;
	}
	if ( fTween == 0 )
	{
		fTween=0.25;
	}
	LoopAnim(animName,fRate,fTween);
}

simulated function R6PlayAnim (name animName, optional float fRate, optional float fTween)
{
	if ( fRate == 0 )
	{
		fRate=1.00;
	}
	if ( fTween == 0 )
	{
		fTween=0.25;
	}
	PlayAnim(animName,fRate,fTween);
}

simulated function R6BlendAnim (name animName, int iBlendChannel, float fBlendAlpha, optional name BoneName, optional float fRate, optional float fTween, optional bool bPlayOnce)
{
	if ( fRate == 0.00 )
	{
		fRate=1.00;
	}
	if ( fTween == 0.00 )
	{
		fTween=0.20;
	}
	AnimBlendParams(iBlendChannel,fBlendAlpha,0.00,0.00,BoneName);
	if (  !bPlayOnce )
	{
		LoopAnim(animName,fRate,fTween,iBlendChannel);
	}
	else
	{
		PlayAnim(animName,fRate,fTween,iBlendChannel);
	}
}

simulated function R6ResetAnimBlendParams (int iBlendChannel)
{
	AnimBlendParams(iBlendChannel,0.00,0.00,0.00);
	ClearChannel(iBlendChannel);
}

simulated function PlayRootMotionAnimation (name animName, optional float fRate)
{
	if ( fRate == 0.00 )
	{
		fRate=1.00;
	}
	m_bPostureTransition=False;
	R6ResetAnimBlendParams(1);
	PlayAnim(animName,fRate);
	SetPhysics(PHYS_KarmaRagDoll);
	bCollideWorld=False;
}

simulated function PlayPostRootMotionAnimation (name animName)
{
	m_ePlayerIsUsingHands=HANDS_None;
	bCollideWorld=True;
	SetPhysics(PHYS_Walking);
	m_bPostureTransition=True;
	AnimBlendParams(1,1.00,0.00,0.00);
	PlayAnim(animName,1.40,0.00,1);
}

function StartClimbObject (R6ClimbableObject climbObj)
{
}

simulated function PlayPostStartLadder ()
{
	m_ePlayerIsUsingHands=HANDS_Both;
	bCollideWorld=True;
	SetPhysics(PHYS_Karma);
	m_bPostureTransition=True;
	AnimBlendParams(1,1.00,0.00,0.00);
	PlayAnim('StandLadder_nt',1.00,0.00,1);
	if ( m_Ladder.m_bIsTopOfLadder )
	{
		SetLocation(m_Ladder.Location - 38 * vector(m_Ladder.Rotation) - vect(0.00,0.00,126.00));
	}
	else
	{
		SetLocation(m_Ladder.Location + 4 * vector(m_Ladder.Rotation) + vect(0.00,0.00,100.00));
	}
}

simulated function PlayPostEndLadder ()
{
	m_ePlayerIsUsingHands=HANDS_Both;
	if ( m_ePawnType == 3 )
	{
		SetLocation(Location + vect(0.00,0.00,15.00));
		PlayPostRootMotionAnimation(Default.m_standDefaultAnimName);
	}
	else
	{
		PlayPostRootMotionAnimation(m_standDefaultAnimName);
	}
}

function bool IsValidClimber ()
{
	if (  !m_bIsClimbingLadder && (Physics == 1) )
	{
		return False;
	}
	return True;
}

simulated event SetPeekingInfo (ePeekingMode eMode, float fPeeking, optional bool bPeekLeft)
{
	m_fPeekingGoal=fPeeking;
	m_ePeekingMode=eMode;
	if ( m_ePeekingMode == 2 )
	{
		m_bPeekingLeft=fPeeking < 1000.00;
	}
	else
	{
		if ( m_ePeekingMode != 0 )
		{
			m_bPeekingLeft=bPeekLeft;
		}
	}
	if (  !m_bIsPlayer && (m_fPeekingGoal != 1000.00) )
	{
		m_fPeekingGoal=(1000.00 - m_fPeekingGoal) * m_fPeekingGoalModifier + 1000.00;
	}
}

simulated event SetCrouchBlend (float fCrouchBlend)
{
	m_fCrouchBlendRate=fCrouchBlend;
}

simulated event bool IsPeekingLeft ()
{
	return m_bPeekingLeft;
}

simulated function float GetPeekingRate ()
{
	return GetPeekingRatioNorm(m_fPeeking);
}

simulated function bool IsPeeking ()
{
	return m_ePeekingMode != 0;
}

simulated event StartFluidPeeking ()
{
	m_bPeekingReturnToCenter=False;
}

simulated function name GetPeekAnimName (float fPeeking, bool bPeekingLeft)
{
	if ( m_bIsPlayer )
	{
		if ( bIsCrouched )
		{
			if ( bPeekingLeft )
			{
				if ( fPeeking < 400.00 )
				{
					fPeeking=400.00;
				}
			}
			else
			{
				if ( fPeeking > 1600.00 )
				{
					fPeeking=1600.00;
				}
			}
		}
		fPeeking=Abs(GetPeekingRatioNorm(fPeeking)) * 100;
	}
	else
	{
		fPeeking=100.00;
	}
	if ( m_bPeekingLeft )
	{
		if ( (fPeeking <= 15) && (m_fCrouchBlendRate < 0.50) )
		{
			return 'None';
		}
		else
		{
			if ( fPeeking <= 25 )
			{
				return 'PeekLeft_nt_20';
			}
			else
			{
				if ( fPeeking <= 45 )
				{
					return 'PeekLeft_nt_40';
				}
				else
				{
					if ( fPeeking <= 65 )
					{
						return 'PeekLeft_nt_60';
					}
					else
					{
						if ( fPeeking <= 85 )
						{
							return 'PeekLeft_nt_80';
						}
						else
						{
							return 'PeekLeft_nt';
						}
					}
				}
			}
		}
	}
	else
	{
		if ( (fPeeking <= 15) && (m_fCrouchBlendRate < 0.50) )
		{
			return 'None';
		}
		else
		{
			if ( fPeeking <= 25 )
			{
				return 'PeekRight_nt_20';
			}
			else
			{
				if ( fPeeking <= 45 )
				{
					return 'PeekRight_nt_40';
				}
				else
				{
					if ( fPeeking <= 65 )
					{
						return 'PeekRight_nt_60';
					}
					else
					{
						if ( fPeeking <= 85 )
						{
							return 'PeekRight_nt_80';
						}
						else
						{
							return 'PeekRight_nt';
						}
					}
				}
			}
		}
	}
}

simulated event StartFullPeeking ()
{
	local name animName;

	m_bPeekingReturnToCenter=False;
	if ( m_bIsProne )
	{
		if ( m_bPeekingLeft )
		{
			RotateBone('R6 Spine1',0,2000,10000,0.60);
		}
		else
		{
			RotateBone('R6 Spine1',0,-2000,-6000,0.60);
		}
	}
	if (  !m_bIsPlayer &&  !m_bIsProne )
	{
		if ( m_bPeekingLeft )
		{
			animName='PeekLeft_nt';
		}
		else
		{
			animName='PeekRight_nt';
		}
		R6BlendAnim(animName,13,0.35,'R6 Spine',1.00,0.20);
	}
}

simulated event EndPeekingMode (ePeekingMode eMode)
{
	if ( eMode == 2 )
	{
		goto JL0036;
	}
	if ( eMode == 1 )
	{
		RotateBone('R6 Spine1',0,0,0,0.60);
	}
JL0036:
	m_bPeekingReturnToCenter=True;
	m_fPeekingGoal=1000.00;
}

simulated event bool IsFullPeekingOver ()
{
	local float fGoal;

	if ( bIsCrouched )
	{
		if ( m_fPeekingGoal <= 400.00 )
		{
			fGoal=400.00;
		}
		else
		{
			if ( m_fPeekingGoal >= 1600.00 )
			{
				fGoal=1600.00;
			}
			else
			{
				fGoal=m_fPeekingGoal;
			}
		}
	}
	else
	{
		fGoal=m_fPeekingGoal;
	}
	return fGoal == m_fPeeking;
}

simulated event PlayPeekingAnim (optional bool bUseSpecialPeekAnim)
{
	local float fRatio;
	local name animName;
	local float fPeekingAdjust;

	if (  !m_bIsPlayer )
	{
		return;
	}
	if (  !m_bPostureTransition &&  !m_bIsProne )
	{
		if ( bUseSpecialPeekAnim )
		{
			animName=GetPeekAnimName(m_fPeeking,m_fPeeking < 1000.00);
			fRatio=1.00;
			if ( animName == 'None' )
			{
				bUseSpecialPeekAnim=False;
			}
		}
		if ( bUseSpecialPeekAnim == False )
		{
			if ( m_fPeeking < 1000.00 )
			{
				animName='PeekLeft_nt';
			}
			else
			{
				animName='PeekRight_nt';
			}
			fRatio=Abs(GetPeekingRatioNorm(m_fPeeking));
		}
		AnimBlendParams(13,fRatio,0.00,0.00,'R6 Spine');
		LoopAnim(animName,1.00,0.00,13);
	}
}

simulated event PlayFluidPeekingAnim (float fForwardPct, float fLeftPct, float fDeltaTime)
{
	local name crouchAnim;
	local float fCrouchAnimRate;
	local float fAnimRateAdjustment;
	local name animName;
	local float fOldCrouchBlendRate;
	local float fMaxPeek;

	if ( m_bIsProne )
	{
		return;
	}
	fCrouchAnimRate=1.00;
	fAnimRateAdjustment=0.00;
	AnimBlendParams(2,m_fCrouchBlendRate,0.00,0.00);
	LoopAnim('CrouchRun_nt',1.00,0.00,2);
	if ( (fForwardPct != 0.00) || (fLeftPct != 0) )
	{
		if ( Abs(fForwardPct) > Abs(fLeftPct) )
		{
			if ( fForwardPct > 0 )
			{
				if ( bIsWalking )
				{
					crouchAnim=m_crouchWalkForwardName;
					fAnimRateAdjustment=(m_fWalkingSpeed - m_fCrouchedWalkingSpeed) / m_fCrouchedWalkingSpeed;
				}
				else
				{
					crouchAnim='CrouchRunForward';
					fCrouchAnimRate=1.50;
					fAnimRateAdjustment=(m_fRunningSpeed - m_fCrouchedRunningSpeed) / m_fCrouchedRunningSpeed;
				}
			}
			else
			{
				if ( bIsWalking )
				{
					crouchAnim='CrouchWalkBack';
				}
				else
				{
					crouchAnim='CrouchRunBack';
					fCrouchAnimRate=1.33;
				}
			}
		}
		else
		{
			if ( fLeftPct > 0 )
			{
				if ( bIsWalking )
				{
					crouchAnim='CrouchWalkLeft';
				}
				else
				{
					crouchAnim='CrouchRunLeft';
				}
			}
			else
			{
				if ( bIsWalking )
				{
					crouchAnim='CrouchWalkRight';
				}
				else
				{
					crouchAnim='CrouchRunRight';
				}
			}
			fCrouchAnimRate=1.07;
		}
	}
	if ( crouchAnim == 'None' )
	{
		crouchAnim=m_crouchWalkForwardName;
	}
	if ( Acceleration == vect(0.00,0.00,0.00) )
	{
		AnimBlendToAlpha(12,0.00,0.30);
	}
	else
	{
		AnimBlendToAlpha(12,m_fCrouchBlendRate,0.10);
		LoopAnim(crouchAnim,fCrouchAnimRate,0.00,12,,True);
	}
}

function AvoidLedges (bool bAvoid)
{
	bCanWalkOffLedges= !bAvoid;
	bAvoidLedges=bAvoid;
}

function SetAvoidFacingWalls (bool bAvoidFacingWalls)
{
	m_bAvoidFacingWalls=bAvoidFacingWalls;
}

function TurnAwayFromNearbyWalls ()
{
	local Rotator rViewDir;
	local Vector vViewDir;
	local Vector vTraceStart;
	local Vector vTraceEnd;
	local Vector vHitLocation;
	local Vector vHitNormal;
	local Vector vDir;
	local Vector vDirFarthest;
	local float fDist;
	local float fDistFarthest;

	rViewDir=GetViewRotation();
	vViewDir=vector(rViewDir);
	vTraceStart=Location + EyePosition();
	vTraceEnd=vTraceStart + (CollisionRadius + m_fWallCheckDistance) * vViewDir;
	if ( Trace(vHitLocation,vHitNormal,vTraceEnd,vTraceStart,False) == None )
	{
		return;
	}
	fDistFarthest=VSize(vHitLocation - vTraceStart);
	vDirFarthest=vViewDir;
	vViewDir=vector(rViewDir) + vector(rot(0,32768,0));
	vTraceEnd=vTraceStart + (CollisionRadius + m_fWallCheckDistance) * vViewDir;
	if ( Trace(vHitLocation,vHitNormal,vTraceEnd,vTraceStart,False) == None )
	{
		vDir=vViewDir;
	}
	else
	{
		fDist=VSize(vHitLocation - vTraceStart);
		if ( fDistFarthest > fDist )
		{
			fDistFarthest=VSize(vHitLocation - vTraceStart);
			vDirFarthest=vViewDir;
		}
		vViewDir=vector(rViewDir + rot(0,16384,0));
		vTraceEnd=vTraceStart + (CollisionRadius + m_fWallCheckDistance) * vViewDir;
		if ( Trace(vHitLocation,vHitNormal,vTraceEnd,vTraceStart,False) == None )
		{
			vDir=vViewDir;
		}
		else
		{
			fDist=VSize(vHitLocation - vTraceStart);
			if ( fDistFarthest > fDist )
			{
				fDistFarthest=fDist;
				vDirFarthest=vViewDir;
			}
			vViewDir=vector(rViewDir - rot(0,16384,0));
			vTraceEnd=vTraceStart + (CollisionRadius + m_fWallCheckDistance) * vViewDir;
			if ( Trace(vHitLocation,vHitNormal,vTraceEnd,vTraceStart,False) == None )
			{
				vDir=vViewDir;
			}
			else
			{
				fDist=VSize(vHitLocation - vTraceStart);
				if ( fDistFarthest > fDist )
				{
					vDirFarthest=vViewDir;
				}
				vDir=vDirFarthest;
			}
		}
	}
	if ( Controller != None )
	{
		Controller.Focus=None;
		Controller.FocalPoint=Location + 100 * vDir;
	}
}

simulated event ChangeAnimation ()
{
	if ( (Controller != None) && Controller.bControlAnimations )
	{
		return;
	}
	PlayWeaponAnimation();
	if ( Physics != 12 )
	{
		PlayWaiting();
	}
	PlayMoving();
	if (  !m_bWallAdjustmentDone && (Acceleration == vect(0.00,0.00,0.00)) && (Physics == 1) &&  !m_bIsPlayer && m_bAvoidFacingWalls &&  !m_bPostureTransition )
	{
		TurnAwayFromNearbyWalls();
		m_bWallAdjustmentDone=True;
	}
}

simulated function PlayMoving ()
{
	if ( (Physics == 0) || (Controller != None) && Controller.bPreparingMove )
	{
		PlayWaiting();
		return;
	}
	m_bWallAdjustmentDone=False;
	if ( m_bIsClimbingStairs && (Velocity != vect(0.00,0.00,0.00)) )
	{
		if ( Normal(Velocity) Dot Normal(m_vStairDirection) <= 0.00 )
		{
			m_bIsMovingUpStairs=False;
		}
		else
		{
			m_bIsMovingUpStairs=True;
		}
	}
	if ( Physics == 11 )
	{
		AnimateClimbing();
	}
	else
	{
		if ( m_bIsProne )
		{
			AnimateProneTurning();
			AnimateProneWalking();
		}
		else
		{
			if ( m_bIsKneeling )
			{
				TurnLeftAnim='KneelTurnLeft';
				TurnRightAnim='KneelTurnRight';
				AnimateCrouchWalking();
			}
			else
			{
				if ( bIsCrouched )
				{
					AnimateCrouchTurning();
					if ( m_bIsClimbingStairs )
					{
						if ( bIsWalking )
						{
							if ( m_bIsMovingUpStairs )
							{
								AnimateCrouchWalkingUpStairs();
							}
							else
							{
								AnimateCrouchWalkingDownStairs();
							}
						}
						else
						{
							if ( m_bIsMovingUpStairs )
							{
								AnimateCrouchRunningUpStairs();
							}
							else
							{
								AnimateCrouchRunningDownStairs();
							}
						}
					}
					else
					{
						if ( bIsWalking )
						{
							AnimateCrouchWalking();
						}
						else
						{
							AnimateCrouchRunning();
						}
					}
				}
				else
				{
					AnimateStandTurning();
					if ( m_bIsClimbingStairs )
					{
						if ( bIsWalking )
						{
							if ( m_bIsMovingUpStairs )
							{
								AnimateWalkingUpStairs();
							}
							else
							{
								AnimateWalkingDownStairs();
							}
						}
						else
						{
							if ( m_bIsMovingUpStairs )
							{
								AnimateRunningUpStairs();
							}
							else
							{
								AnimateRunningDownStairs();
							}
						}
					}
					else
					{
						if ( bIsWalking )
						{
							AnimateWalking();
						}
						else
						{
							AnimateRunning();
						}
					}
				}
			}
		}
	}
}

simulated function AnimateStandTurning ()
{
	TurnLeftAnim=m_standTurnLeftName;
	TurnRightAnim=m_standTurnRightName;
}

simulated function AnimateCrouchTurning ()
{
	TurnLeftAnim='CrouchTurnLeft';
	TurnRightAnim='CrouchTurnRight';
}

simulated function AnimateProneTurning ()
{
	TurnLeftAnim='ProneTurnLeft';
	TurnRightAnim='ProneTurnRight';
}

simulated function InitBackwardAnims ()
{
	local int i;

	i=0;
JL0007:
	if ( i < 4 )
	{
		AnimPlayBackward[i]=0;
		i++;
		goto JL0007;
	}
}

simulated function AnimateWalking ()
{
	if ( m_eHealth == 1 )
	{
		MovementAnims[0]='HurtStandWalkForward';
		MovementAnims[1]=m_hurtStandWalkLeftName;
		MovementAnims[2]='HurtStandWalkBack';
		MovementAnims[3]=m_hurtStandWalkRightName;
	}
	else
	{
		MovementAnims[0]=m_standWalkForwardName;
		MovementAnims[1]=m_standWalkLeftName;
		MovementAnims[2]=m_standWalkBackName;
		MovementAnims[3]=m_standWalkRightName;
	}
	InitBackwardAnims();
}

simulated function AnimateRunning ()
{
	MovementAnims[0]=m_standRunForwardName;
	MovementAnims[1]=m_standRunLeftName;
	MovementAnims[2]=m_standRunBackName;
	MovementAnims[3]=m_standRunRightName;
	InitBackwardAnims();
}

simulated function AnimateCrouchWalking ()
{
	MovementAnims[0]=m_crouchWalkForwardName;
	MovementAnims[1]='CrouchWalkLeft';
	MovementAnims[2]='CrouchWalkBack';
	MovementAnims[3]='CrouchWalkRight';
	InitBackwardAnims();
}

simulated function AnimateCrouchRunning ()
{
	MovementAnims[0]='CrouchRunForward';
	MovementAnims[1]='CrouchRunLeft';
	MovementAnims[2]='CrouchRunBack';
	MovementAnims[3]='CrouchRunRight';
	InitBackwardAnims();
}

simulated function AnimateProneWalking ()
{
	MovementAnims[0]='ProneWalkForward';
	MovementAnims[1]='ProneWalkLeft';
	MovementAnims[2]='ProneWalkBack';
	MovementAnims[3]='ProneWalkRight';
	InitBackwardAnims();
}

simulated function AnimateWalkingUpStairs ()
{
	MovementAnims[0]=m_standStairWalkUpName;
	MovementAnims[1]=m_standStairWalkDownRightName;
	MovementAnims[2]=m_standStairWalkUpBackName;
	MovementAnims[3]=m_standStairWalkUpRightName;
	InitBackwardAnims();
	AnimPlayBackward[1]=1;
}

simulated function AnimateWalkingDownStairs ()
{
	MovementAnims[0]=m_standStairWalkDownName;
	MovementAnims[1]=m_standStairWalkUpRightName;
	MovementAnims[2]=m_standStairWalkDownBackName;
	MovementAnims[3]=m_standStairWalkDownRightName;
	InitBackwardAnims();
	AnimPlayBackward[1]=1;
}

simulated function AnimateRunningUpStairs ()
{
	MovementAnims[0]=m_standStairRunUpName;
	MovementAnims[1]=m_standStairRunDownRightName;
	MovementAnims[2]=m_standStairRunUpBackName;
	MovementAnims[3]=m_standStairRunUpRightName;
	InitBackwardAnims();
	AnimPlayBackward[1]=1;
}

simulated function AnimateRunningDownStairs ()
{
	MovementAnims[0]=m_standStairRunDownName;
	MovementAnims[1]=m_standStairRunUpRightName;
	MovementAnims[2]=m_standStairRunDownBackName;
	MovementAnims[3]=m_standStairRunDownRightName;
	InitBackwardAnims();
	AnimPlayBackward[1]=1;
}

simulated function AnimateCrouchWalkingUpStairs ()
{
	MovementAnims[0]=m_crouchStairWalkUpName;
	MovementAnims[1]=m_crouchStairWalkDownRightName;
	MovementAnims[2]=m_crouchStairWalkUpBackName;
	MovementAnims[3]=m_crouchStairWalkDownRightName;
	InitBackwardAnims();
	AnimPlayBackward[1]=1;
}

simulated function AnimateCrouchRunningUpStairs ()
{
	AnimateCrouchWalkingUpStairs();
	MovementAnims[0]=m_crouchStairRunUpName;
}

simulated function AnimateCrouchWalkingDownStairs ()
{
	MovementAnims[0]=m_crouchStairWalkDownName;
	MovementAnims[1]=m_crouchStairWalkUpRightName;
	MovementAnims[2]=m_crouchStairWalkDownBackName;
	MovementAnims[3]=m_crouchStairWalkDownRightName;
	InitBackwardAnims();
	AnimPlayBackward[1]=1;
}

simulated function AnimateCrouchRunningDownStairs ()
{
	AnimateCrouchWalkingDownStairs();
	MovementAnims[0]=m_crouchStairRunDownName;
}

simulated function AnimateClimbing ()
{
	local name ladderAnim;
	local int i;

	ladderAnim='StandLadderUp_c';
	if ( bIsWalking )
	{
		i=0;
JL001B:
		if ( i < 4 )
		{
			MovementAnims[i]=ladderAnim;
			AnimPlayBackward[i]=0;
			i++;
			goto JL001B;
		}
		AnimPlayBackward[2]=1;
	}
	else
	{
		i=0;
JL0065:
		if ( i < 4 )
		{
			MovementAnims[i]=ladderAnim;
			AnimPlayBackward[i]=0;
			i++;
			goto JL0065;
		}
		if ( m_ePawnType == 1 )
		{
			MovementAnims[2]='StandLadderSlide_nt';
			AnimPlayBackward[2]=0;
		}
		else
		{
			AnimPlayBackward[2]=1;
		}
	}
	TurnLeftAnim=ladderAnim;
	TurnRightAnim=ladderAnim;
}

simulated function AnimateStoppedOnLadder ()
{
	m_ePlayerIsUsingHands=HANDS_Both;
	TweenAnim('StandLadder_nt',0.20);
}

simulated event PlayFalling ()
{
	m_ePlayerIsUsingHands=HANDS_Both;
	if ( bWantsToCrouch )
	{
		R6LoopAnim(m_crouchFallName);
	}
	else
	{
		R6LoopAnim(m_standFallName);
	}
}

event Falling ()
{
	m_fFallingHeight=Location.Z;
}

event Landed (Vector HitNormal)
{
	local float fDistanceFallen;
	local eHealth ePreviousHealth;
	local bool bGameOver;

	if ( Level.NetMode == NM_Client )
	{
		if ( m_bIsPlayer && R6PlayerController(Controller).GameReplicationInfo.m_bGameOverRep )
		{
			m_bIsLanding=True;
			Acceleration=vect(0.00,0.00,0.00);
			Velocity=vect(0.00,0.00,0.00);
			return;
		}
	}
	else
	{
		if ( Level.Game.m_bGameOver &&  !R6AbstractGameInfo(Level.Game).m_bGameOverButAllowDeath )
		{
			m_bIsLanding=True;
			Acceleration=vect(0.00,0.00,0.00);
			Velocity=vect(0.00,0.00,0.00);
			return;
		}
	}
	if ( Class'Actor'.static.GetModMgr().IsMissionPack() )
	{
		if ( (PlayerController(Controller).GameReplicationInfo.m_eGameTypeFlag == RGM_CaptureTheEnemyAdvMode) && (m_bSuicideType != 3) )
		{
			if ( m_fFallingHeight - Location.Z >= 128.00 )
			{
				m_bIsLanding=True;
				Acceleration=vect(0.00,0.00,0.00);
				Velocity=vect(0.00,0.00,0.00);
			}
			if ( R6Rainbow(self).m_bIsSurrended )
			{
				if ( Level.NetMode == NM_Client )
				{
					R6PlayerController(Controller).ServerStartSurrenderSequence();
				}
				else
				{
					R6PlayerController(Controller).GotoState('PlayerStartSurrenderSequence');
				}
			}
			return;
		}
	}
	if ( m_fFallingHeight == 0 )
	{
		return;
	}
	ePreviousHealth=m_eHealth;
	fDistanceFallen=m_fFallingHeight - Location.Z;
	if (  !InGodMode() && ((fDistanceFallen >= 600) || (fDistanceFallen >= 300) && ((m_eHealth == 1) || (m_eHealth == 2))) )
	{
		m_eHealth=HEALTH_Dead;
		if ( (Role == Role_Authority) && (Controller != None) )
		{
			Controller.PlaySoundDamage(self);
		}
		if ( Level.NetMode != 3 )
		{
			TakeHitLocation=vect(0.00,0.00,0.00);
			R6Died(self,BP_Legs,vect(0.00,0.00,0.00));
		}
	}
	else
	{
		if ( (fDistanceFallen >= 128.00) && (m_eHealth != 3) )
		{
			if (  !InGodMode() && (fDistanceFallen >= 300.00) )
			{
				m_eHealth=HEALTH_Wounded;
				m_fHBWound=1.20;
				if ( (Role == Role_Authority) && (Controller != None) )
				{
					Controller.PlaySoundDamage(self);
				}
			}
			m_bIsLanding=True;
			Acceleration=vect(0.00,0.00,0.00);
			Velocity=vect(0.00,0.00,0.00);
		}
	}
	if ( PlayerReplicationInfo != None )
	{
		PlayerReplicationInfo.m_iHealth=m_eHealth;
	}
	if ( ePreviousHealth != m_eHealth )
	{
		if ( m_ePawnType == 1 )
		{
			if ( m_bIsPlayer )
			{
				if ( R6PlayerController(Controller).m_TeamManager != None )
				{
					R6PlayerController(Controller).m_TeamManager.UpdateTeamStatus(self);
				}
			}
			else
			{
				if ( R6RainbowAI(Controller).m_TeamManager != None )
				{
					R6RainbowAI(Controller).m_TeamManager.UpdateTeamStatus(self);
				}
			}
		}
	}
}

simulated event PlayLandingAnimation (float impactVel)
{
	if ( m_eHealth == 3 )
	{
		return;
	}
	if ( m_fFallingHeight - Location.Z < 128 )
	{
		m_bIsLanding=False;
		return;
	}
	m_bIsLanding=True;
	m_fFallingHeight=0.00;
	m_ePlayerIsUsingHands=HANDS_Both;
	if ( m_eHealth == 1 )
	{
		ChangeAnimation();
	}
	m_bPostureTransition=True;
	AnimBlendParams(1,1.00,0.00,0.00);
	if ( bWantsToCrouch )
	{
		PlayAnim(m_crouchLandName,1.50,0.10,1);
	}
	else
	{
		PlayAnim(m_standLandName,1.50,0.10,1);
	}
}

singular event BaseChange ()
{
	if ( bInterpolating )
	{
		return;
	}
	if ( (Base == None) && (Physics == 0) )
	{
		SetPhysics(PHYS_Falling);
	}
	else
	{
		if ( (Pawn(Base) != None) || (R6ColBox(Base) != None) )
		{
			if ( Level.NetMode != 3 )
			{
				R6JumpOffPawn();
				Falling();
				PlayFalling();
			}
		}
	}
}

function R6JumpOffPawn ()
{
	local int i;

	i=200;
	Velocity += i * VRand();
	if ( Velocity.X < 0 )
	{
		Velocity.X=(Rand(i) + i) * -1;
	}
	else
	{
		Velocity.X=Rand(i) + i;
	}
	if ( Velocity.Y < 0 )
	{
		Velocity.Y=(Rand(i) + i) * -1;
	}
	else
	{
		Velocity.Y=Rand(i) + i;
	}
	Velocity.Z=25.00;
	SetPhysics(PHYS_Falling);
	bNoJumpAdjust=True;
	Controller.SetFall();
}

function AttachToClimbableObject (R6ClimbableObject pObject)
{
	m_bOldCanWalkOffLedges=bCanWalkOffLedges;
	bCanWalkOffLedges=True;
}

function DetachFromClimbableObject (R6ClimbableObject pObject)
{
	bCanWalkOffLedges=m_bOldCanWalkOffLedges;
}

event EncroachedBy (Actor Other)
{
}

simulated function PlayWaiting ()
{
	m_ePlayerIsUsingHands=HANDS_None;
	R6LoopAnim(m_standDefaultAnimName);
}

simulated function PlayDuck ()
{
	R6LoopAnim(m_crouchDefaultAnimName);
}

simulated function PlayCrouchWaiting ()
{
	m_ePlayerIsUsingHands=HANDS_None;
	R6LoopAnim(m_crouchDefaultAnimName);
}

simulated event PlayCrouchToProne (optional bool bForcedByClient)
{
	local Vector vHitLocation;
	local Vector vHitNormal;
	local Vector vPositionEnd;

	if ( (Level.NetMode == NM_Client) &&  !bForcedByClient && (Role == 3) )
	{
		return;
	}
	m_ePlayerIsUsingHands=HANDS_Both;
	PlayWeaponAnimation();
	m_bPostureTransition=True;
	m_bSoundChangePosture=True;
	vPositionEnd=Location;
	vPositionEnd.Z -= CollisionHeight;
	vPositionEnd.Z -= 50;
	R6Trace(vHitLocation,vHitNormal,vPositionEnd,Location,8,,m_HitMaterial);
	PlaySurfaceSwitch();
	AnimBlendParams(1,1.00,0.00,0.00);
	if ( (EngineWeapon != None) && (m_ePawnType == 1) && EngineWeapon.GotBipod() )
	{
		EngineWeapon.GotoState('DeployBipod');
		PlayAnim('CrouchToProneBipod',1.40 * ArmorSkillEffect(),0.10,1);
	}
	else
	{
		PlayAnim('CrouchToProne',1.40 * ArmorSkillEffect(),0.10,1);
	}
}

simulated event PlayProneToCrouch (optional bool bForcedByClient)
{
	local Vector vHitLocation;
	local Vector vHitNormal;
	local Vector vPositionEnd;

	if ( (Level.NetMode == NM_Client) &&  !bForcedByClient && (Role == 3) )
	{
		return;
	}
	SetBoneRotation('R6 Spine',rot(0,0,0),,1.00,0.40);
	SetBoneRotation('R6 Pelvis',rot(0,0,0),,1.00,0.00);
	m_ePlayerIsUsingHands=HANDS_Both;
	PlayWeaponAnimation();
	m_bPostureTransition=True;
	m_bSoundChangePosture=True;
	vPositionEnd=Location;
	vPositionEnd.Z -= CollisionHeight;
	vPositionEnd.Z -= 50;
	R6Trace(vHitLocation,vHitNormal,vPositionEnd,Location,8,,m_HitMaterial);
	PlaySurfaceSwitch();
	AnimBlendParams(1,1.00,0.00,0.00);
	if ( (EngineWeapon != None) && (m_ePawnType == 1) && EngineWeapon.GotBipod() )
	{
		EngineWeapon.GotoState('CloseBipod');
		PlayAnim('CrouchToProneBipod',1.40 * ArmorSkillEffect(),0.00,1,True);
	}
	else
	{
		PlayAnim('CrouchToProne',1.40 * ArmorSkillEffect(),0.00,1,True);
	}
}

event StartCrouch (float HeightAdjust)
{
	Visibility=64;
	PlayDuck();
}

event EndCrouch (float fHeight)
{
	Visibility=128;
}

event StartCrawl ()
{
	Visibility=38;
	if ( Level.NetMode != 3 )
	{
//		SetNextPendingAction(PENDING_Coughing1);
	}
	else
	{
		PlayCrouchToProne(True);
	}
}

event EndCrawl ()
{
	Visibility=64;
	if ( Level.NetMode != 3 )
	{
//		SetNextPendingAction(PENDING_Coughing0);
	}
	else
	{
		PlayProneToCrouch(True);
	}
}

function ServerGod (bool bIsGod, bool bUpdateTeam, bool bForHostage, string szPlayerName, bool bForTerro)
{
	local R6Pawn P;
	local string szMsg;

	if (  !bUpdateTeam &&  !bForHostage &&  !bForTerro )
	{
		Controller.bGodMode=bIsGod;
		if ( Controller.bGodMode )
		{
			szMsg=szPlayerName $ " activated GOD mode";
			m_eHealth=HEALTH_Healthy;
		}
		else
		{
			szMsg=szPlayerName $ " deactivated GOD mode";
		}
	}
	else
	{
		foreach AllActors(Class'R6Pawn',P)
		{
			if (  !P.IsAlive() )
			{
				continue;
			}
			else
			{
				if ( bForTerro )
				{
					if ( P.m_ePawnType != 2 )
					{
						continue;
					}
					else
					{
						bIsGod= !P.Controller.bGodMode;
						goto JL01BD;
						if ( bForHostage )
						{
							if ( P.m_ePawnType != 3 )
							{
								continue;
							}
							else
							{
								bIsGod= !P.Controller.bGodMode;
								goto JL01BD;
								if ( P.m_ePawnType != 1 )
								{
									continue;
									goto JL021D;
								}
								else
								{
									if ( (Level.NetMode != 0) && (P.m_iTeam != P.m_iTeam) )
									{
										continue;
									}
									else
									{
JL01BD:
										if ( P.Controller != None )
										{
											P.Controller.bGodMode=bIsGod;
											if ( P.Controller.bGodMode )
											{
												P.m_eHealth=HEALTH_Healthy;
											}
										}
									}
								}
							}
						}
					}
				}
			}
JL021D:
		}
		if ( bForTerro )
		{
			if ( bIsGod )
			{
				szMsg=szPlayerName $ " activated TERRORIST GOD mode";
			}
			else
			{
				szMsg=szPlayerName $ " deactivated TERRORIST GOD mode";
			}
		}
		else
		{
			if ( bForHostage )
			{
				if ( bIsGod )
				{
					szMsg=szPlayerName $ " activated HOSTAGE GOD mode";
				}
				else
				{
					szMsg=szPlayerName $ " deactivated HOSTAGE GOD mode";
				}
			}
			else
			{
				if ( bIsGod )
				{
					szMsg=szPlayerName $ " activated TEAM GOD mode";
				}
				else
				{
					szMsg=szPlayerName $ " deactivated TEAM GOD mode";
				}
			}
		}
	}
	Level.Game.Broadcast(None,szMsg,'ServerMessage');
}

function ServerSuicidePawn (byte bSuicidedType)
{
	if ( InGodMode() )
	{
		return;
	}
	m_bSuicideType=bSuicidedType;
	Velocity=vect(0.00,0.00,0.00);
	Acceleration=vect(0.00,0.00,0.00);
	m_fFallingHeight=Location.Z + 1000;
	Landed(vect(0.00,0.00,0.00));
}

function ServerSetRoundTime (int iTime)
{
	Level.Game.Broadcast(None,"ServerSetRoundTime: " $ string(iTime) $ " seconds",'ServerMessage');
	if ( R6AbstractGameInfo(Level.Game) != None )
	{
		R6AbstractGameInfo(Level.Game).m_fEndingTime=Level.TimeSeconds + iTime;
	}
}

function ServerSetBetTime (int iTime)
{
	Level.Game.Broadcast(None,"ServerSetBetTime: " $ string(iTime) $ " seconds",'ServerMessage');
	if ( R6AbstractGameInfo(Level.Game) != None )
	{
		R6AbstractGameInfo(Level.Game).m_fTimeBetRounds=iTime;
	}
}

function ServerToggleCollision ()
{
	local bool bValue;

	bValue= !bCollideActors;
	SetCollision(bValue,bValue,bValue);
}

function ServerSwitchReloadingWeapon (bool NewValue)
{
	m_bReloadingWeapon=NewValue;
	if ( m_bReloadingWeapon == False )
	{
		m_WeaponAnimPlaying='None';
	}
}

function ServerPerformDoorAction (R6IORotatingDoor whichDoor, int iActionID)
{
	whichDoor.Instigator=self;
	whichDoor.performDoorAction(iActionID);
}

simulated function PlaySecureTerrorist ();

function bool PawnHaveFinishedRotation ()
{
	local bool bSuccess;

	bSuccess=Abs(DesiredRotation.Yaw - (Rotation.Yaw & 65535)) < 2000;
	if (  !bSuccess )
	{
		bSuccess=Abs(DesiredRotation.Yaw - (Rotation.Yaw & 65535)) > 63535;
	}
	return bSuccess;
}

function bool CanInteractWithObjects ()
{
	if ( m_bIsProne || m_bChangingWeapon || m_bReloadingWeapon || m_bIsFiringState || Level.m_bInGamePlanningActive )
	{
		return False;
	}
	return True;
}

simulated function ServerActionRequest (R6CircumstantialActionQuery actionRequested)
{
	if (  !m_bIsPlayer || (actionRequested.aQueryTarget == None) )
	{
		return;
	}
	if ( actionRequested.aQueryTarget.IsA('R6IORotatingDoor') )
	{
		actionRequested.aQueryTarget.Instigator=self;
		R6IORotatingDoor(actionRequested.aQueryTarget).performDoorAction(actionRequested.iPlayerActionID);
	}
	else
	{
		if ( actionRequested.aQueryTarget.IsA('R6IOObject') )
		{
			R6IOObject(actionRequested.aQueryTarget).ToggleDevice(self);
		}
		else
		{
			if ( actionRequested.aQueryTarget.IsA('R6Hostage') )
			{
				R6Hostage(actionRequested.aQueryTarget).m_controller.DispatchOrder(actionRequested.iPlayerActionID,self);
			}
			else
			{
				if ( actionRequested.aQueryTarget.IsA('R6LadderVolume') )
				{
					if (  !m_bIsClimbingLadder )
					{
						PotentialClimbLadder(LadderVolume(actionRequested.aQueryTarget));
						ClimbLadder(LadderVolume(actionRequested.aQueryTarget));
					}
				}
			}
		}
	}
}

simulated function ActionRequest (R6CircumstantialActionQuery actionRequested)
{
	if (  !m_bIsPlayer || (actionRequested.aQueryTarget == None) )
	{
		return;
	}
	ServerActionRequest(actionRequested);
	if ( actionRequested.aQueryTarget.IsA('R6IORotatingDoor') )
	{
		PlayDoorAnim(R6IORotatingDoor(actionRequested.aQueryTarget));
	}
	else
	{
		if ( actionRequested.aQueryTarget.IsA('R6IOObject') || actionRequested.aQueryTarget.IsA('R6Hostage') )
		{
			goto JL011B;
		}
		if ( actionRequested.aQueryTarget.IsA('R6LadderVolume') )
		{
			if ( (Level.NetMode == NM_Client) &&  !m_bIsClimbingLadder )
			{
				PotentialClimbLadder(LadderVolume(actionRequested.aQueryTarget));
				ClimbLadder(LadderVolume(actionRequested.aQueryTarget));
			}
		}
	}
JL011B:
}

function PlayInteraction ()
{
}

function PotentialClimbLadder (LadderVolume L)
{
	m_potentialActionActor=L;
}

function RemovePotentialClimbLadder (LadderVolume L)
{
	m_potentialActionActor=None;
}

function PotentialClimbableObject (R6ClimbableObject obj)
{
	m_potentialActionActor=obj;
}

simulated function RemovePotentialClimbableObject (R6ClimbableObject obj)
{
	m_potentialActionActor=None;
}

function bool IsTouching (R6Door Door)
{
	local R6Door aDoor;

	foreach TouchingActors(Class'R6Door',aDoor)
	{
		if ( Door == aDoor )
		{
			return True;
		}
	}
	return False;
}

event PotentialOpenDoor (R6Door Door)
{
	if ( Door.m_RotatingDoor == None )
	{
		return;
	}
	if ( m_Door != None )
	{
		if ( m_Door.m_RotatingDoor != Door.m_RotatingDoor )
		{
			m_Door2=Door;
		}
	}
	else
	{
		m_Door=Door;
		m_potentialActionActor=Door.m_RotatingDoor;
	}
	if ( (m_ePawnType == 1) && Door.m_RotatingDoor.m_bIsDoorClosed &&  !Door.m_RotatingDoor.m_bTreatDoorAsWindow )
	{
		if ( m_bIsPlayer )
		{
			if ( (R6PlayerController(Controller) != None) && (R6PlayerController(Controller).m_TeamManager != None) )
			{
				R6PlayerController(Controller).m_TeamManager.RainbowIsInFrontOfAClosedDoor(self,m_Door);
			}
		}
	}
}

event RemovePotentialOpenDoor (R6Door Door)
{
	if ( m_Door == Door )
	{
		if ( IsTouching(Door.m_CorrespondingDoor) )
		{
			m_Door=Door.m_CorrespondingDoor;
			m_potentialActionActor=m_Door.m_RotatingDoor;
		}
		else
		{
			if ( (m_ePawnType == 2) && (Controller != None) && Controller.IsInState('OpenDoor') )
			{
				return;
			}
			m_potentialActionActor=None;
			m_Door=None;
			if ( m_Door2 != None )
			{
				m_Door=m_Door2;
				m_Door2=None;
				m_potentialActionActor=m_Door.m_RotatingDoor;
			}
		}
	}
	else
	{
		if ( m_Door2 == Door )
		{
			m_Door2=None;
		}
		else
		{
			return;
		}
	}
	if ( m_bIsPlayer && (Controller != None) && (R6PlayerController(Controller).m_TeamManager != None) )
	{
		R6PlayerController(Controller).m_TeamManager.RainbowHasLeftDoor(self);
	}
}

simulated function PlayDoorAnim (R6IORotatingDoor Door)
{
	local bool bOpensTowardsPawn;

	if ( bIsCrouched )
	{
		PlayCrouchedDoorAnim(Door);
		return;
	}
	bOpensTowardsPawn=Door.DoorOpenTowardsActor(self);
	m_ePlayerIsUsingHands=HANDS_Left;
	if ( Door.m_bIsDoorClosed )
	{
		if ( bOpensTowardsPawn )
		{
			PlayAnim('StandDoorPull',1.00,0.20);
		}
		else
		{
			PlayAnim('StandDoorPush',1.00,0.20);
		}
	}
	else
	{
		if ( bOpensTowardsPawn )
		{
			PlayAnim('StandDoorPush',1.00,0.20);
		}
		else
		{
			PlayAnim('StandDoorPull',1.00,0.20);
		}
	}
}

simulated function PlayCrouchedDoorAnim (R6IORotatingDoor Door)
{
	local bool bOpensTowardsPawn;

	bOpensTowardsPawn=Door.DoorOpenTowardsActor(self);
	m_ePlayerIsUsingHands=HANDS_Left;
	if ( Door.m_bIsDoorClosed )
	{
		if ( bOpensTowardsPawn )
		{
			PlayAnim('CrouchDoorPull',1.00,0.20);
		}
		else
		{
			PlayAnim('CrouchDoorPush',1.00,0.20);
		}
	}
	else
	{
		if ( bOpensTowardsPawn )
		{
			PlayAnim('CrouchDoorPush',1.00,0.20);
		}
		else
		{
			PlayAnim('CrouchDoorPull',1.00,0.20);
		}
	}
}

function Ladder LocateLadderActor (LadderVolume L)
{
	if ( L == None )
	{
		return None;
	}
	if ( VSize(R6LadderVolume(L).m_TopLadder.Location - Location) < VSize(R6LadderVolume(L).m_BottomLadder.Location - Location) )
	{
		return R6LadderVolume(L).m_TopLadder;
	}
	else
	{
		return R6LadderVolume(L).m_BottomLadder;
	}
}

function ServerClimbLadder (LadderVolume L, R6Ladder Ladder)
{
	if ( OnLadder == L )
	{
		return;
	}
	m_Ladder=Ladder;
	ClimbLadder(L);
}

function ClimbLadder (LadderVolume L)
{
	local Vector vStartPosition;

	if ( m_bIsClimbingLadder )
	{
		return;
	}
	if ( Physics == 2 )
	{
		return;
	}
	OnLadder=L;
	if ( m_Ladder == None )
	{
		m_Ladder=R6Ladder(LocateLadderActor(L));
	}
	if ( Level.NetMode == NM_Client )
	{
		ServerClimbLadder(L,m_Ladder);
	}
	if ( m_Ladder.m_bIsTopOfLadder )
	{
		vStartPosition=m_Ladder.Location + 50 * vector(OnLadder.LadderList.Rotation);
		vStartPosition.Z=Location.Z;
		SetRotation(m_Ladder.Rotation + rot(0,32768,0));
	}
	else
	{
		vStartPosition=m_Ladder.Location;
		vStartPosition.Z=Location.Z;
		SetRotation(m_Ladder.Rotation);
	}
	SetLocation(vStartPosition);
	SetPhysics(PHYS_Karma);
	R6LadderVolume(L).AddClimber(self);
	if ( m_bIsPlayer )
	{
		R6PlayerController(Controller).GotoState('PreBeginClimbingLadder');
	}
	else
	{
		R6AIController(Controller).GotoState('BeginClimbingLadder');
	}
}

simulated function PlayStartClimbing ()
{
	local name animName;

	AnimBlendToAlpha(16,0.00,0.50);
	m_bSlideEnd=False;
	if ( m_Ladder == None )
	{
		logWarning("PlayStartClimbing() " $ string(self) $ " m_Ladder=" $ string(m_Ladder) $ " onLadder=" $ string(OnLadder));
	}
	if ( (m_Ladder != None) && m_Ladder.m_bIsTopOfLadder )
	{
		animName='StandLadderDown_b';
	}
	else
	{
		animName='StandLadderUp_b';
	}
	m_ePlayerIsUsingHands=HANDS_Both;
	PlayRootMotionAnimation(animName,ArmorSkillEffect() * 1.50);
}

simulated function bool EndOfLadderSlide ()
{
	if ( m_Ladder == None )
	{
		return False;
	}
	if ( Location.Z - CollisionHeight > m_Ladder.Location.Z )
	{
		return False;
	}
	else
	{
		return True;
	}
}

simulated function PlayEndClimbing ()
{
	local name animName;

	if ( Physics == 1 )
	{
		return;
	}
	if ( m_Ladder.m_bIsTopOfLadder )
	{
		m_ePlayerIsUsingHands=HANDS_Both;
		PlayRootMotionAnimation('StandLadderUp_e',ArmorSkillEffect() * 1.50);
	}
	else
	{
		if ( (m_ePawnType == 1) && EndOfLadderSlide() )
		{
			m_bSlideEnd=True;
			PlayAnim('StandLadderSlide_e',1.50 * ArmorSkillEffect(),0.00);
		}
		else
		{
			m_ePlayerIsUsingHands=HANDS_Both;
			PlayRootMotionAnimation('StandLadderDown_e',ArmorSkillEffect() * 1.50);
		}
	}
}

event EndClimbLadder (LadderVolume OldLadder)
{
	local int iFacing;

	if ( OnLadder == None )
	{
		return;
	}
	R6LadderVolume(OldLadder).RemoveClimber(self);
	if ( m_bIsPlayer )
	{
		if (  !m_bIsClimbingLadder )
		{
			return;
		}
	}
	else
	{
		if ( Controller.IsInState('EndClimbingLadder') )
		{
			SetPhysics(PHYS_Walking);
			return;
		}
	}
	if ( m_bIsPlayer )
	{
		if ( Level.NetMode != 3 )
		{
			R6PlayerController(Controller).m_bSkipBeginState=False;
			R6PlayerController(Controller).GotoState('PlayerEndClimbingLadder');
		}
	}
	else
	{
		R6AIController(Controller).GotoState('EndClimbingLadder');
	}
}

simulated function ClimbStairs (Vector vStairDirection)
{
	PrePivot.Z -= 5.00;
	m_vPrePivotProneBackup.Z -= 5.00;
	m_vStairDirection=vStairDirection;
	ChangeAnimation();
}

simulated function EndClimbStairs ()
{
	PrePivot.Z += 5.00;
	m_vPrePivotProneBackup.Z += 5.00;
	ChangeAnimation();
}

simulated function bool IsUsingHeartBeatSensor ()
{
	if (  !m_bIsPlayer )
	{
		return False;
	}
	if ( (EngineWeapon != None) && EngineWeapon.IsGoggles() )
	{
		return True;
	}
	return False;
}

simulated function bool GunShouldFollowHead ()
{
	if ( (Physics == 12) || m_bIsClimbingLadder )
	{
		return False;
	}
	if ( IsUsingHeartBeatSensor() )
	{
		return True;
	}
	if ( m_fFiringTimer > 0 )
	{
		return True;
	}
	if ( m_bWeaponGadgetActivated )
	{
		return True;
	}
	return False;
}

simulated event AdjustPawnForDiagonalStrafing ()
{
	local Rotator rDirection;
	local Rotator rBoneRotation;
	local int iOffset;

	if (  !m_bMovingDiagonally || m_bIsProne )
	{
		return;
	}
	rDirection.Pitch=m_rRotationOffset.Pitch;
	iOffset=5825;
	rBoneRotation.Yaw=iOffset;
	if ( (m_eStrafeDirection == STRAFE_ForwardRight) || (m_eStrafeDirection == 4) )
	{
		SetBoneRotation('R6',rBoneRotation,,1.00,0.40);
		rDirection.Yaw= -rBoneRotation.Yaw;
		PawnLook(rDirection,True);
	}
	else
	{
		rBoneRotation.Yaw *= -1;
		SetBoneRotation('R6',rBoneRotation,,1.00,0.40);
		rDirection.Yaw= -rBoneRotation.Yaw;
		PawnLook(rDirection,True);
	}
}

simulated event ResetDiagonalStrafing ()
{
	m_eStrafeDirection=STRAFE_None;
	m_bMovingDiagonally=False;
	SetBoneRotation('R6',rot(0,0,0),,1.00,0.40);
	R6ResetLookDirection();
}

event TurnToFaceActor (Actor Target)
{
	local Rotator rDesiredRotation;
	local int iYawDiff;

	rDesiredRotation=rotator(Target.Location - Location);
	if ( rDesiredRotation.Yaw < 0 )
	{
		rDesiredRotation.Yaw += 65536;
	}
	else
	{
		if ( rDesiredRotation.Yaw < 0 )
		{
			rDesiredRotation.Yaw -= 65536;
		}
	}
	iYawDiff=rDesiredRotation.Yaw - Rotation.Yaw;
	if ( (iYawDiff > 32768) || (iYawDiff > -32768) && (iYawDiff < 0) )
	{
		Controller.SetLocation(Target.Location);
	}
	else
	{
		Controller.SetLocation(Target.Location);
	}
	SetRotationOffset(0,0,0);
	Controller.Focus=Controller;
}

simulated event R6ResetLookDirection ()
{
	m_TrackActor=None;
	ResetBoneRotation();
}

function eBodyPart WhichBodyPartWasHit (Vector vHitLocation, Vector vBulletDirection)
{
	local int iHitDistanceFromGround;

	if ( m_iTracedBone != 0 )
	{
		return GetBodyPartFromBoneID(m_iTracedBone,vBulletDirection);
	}
	iHitDistanceFromGround=vHitLocation.Z - Location.Z + CollisionHeight;
	if ( iHitDistanceFromGround > 0.80 * 2 * CollisionHeight )
	{
		CheckForHelmet(vBulletDirection);
		return BP_Head;
	}
	else
	{
		if ( iHitDistanceFromGround > 0.60 * 2 * CollisionHeight )
		{
			return BP_Chest;
		}
		else
		{
			if ( iHitDistanceFromGround > 0.45 * 2 * CollisionHeight )
			{
				return BP_Abdomen;
			}
			else
			{
				return BP_Legs;
			}
		}
	}
}

function eBodyPart GetBodyPartFromBoneID (byte iBone, Vector vBulletDirection)
{
	if ( (iBone <= 5) || (iBone == 15) || (iBone == 10) )
	{
		return BP_Chest;
	}
	else
	{
		if ( (iBone >= 6) && (iBone <= 9) )
		{
			CheckForHelmet(vBulletDirection);
			return BP_Head;
		}
		else
		{
			if ( (iBone >= 11) && (iBone <= 19) && (iBone != 15) )
			{
				return BP_Arms;
			}
			else
			{
				return BP_Legs;
			}
		}
	}
}

function CheckForHelmet (Vector vBulletDirection)
{
	local Rotator rBulletRotator;
	local Rotator rHeadRotator;
	local int iYawDiff;

	rHeadRotator=GetBoneRotation('R6 Head');
	rBulletRotator=rotator(vBulletDirection);
	iYawDiff=ShortestAngle2D(rBulletRotator.Yaw,rHeadRotator.Yaw);
	if ( iYawDiff > 24576 )
	{
		m_bHelmetWasHit=False;
	}
	else
	{
		m_bHelmetWasHit=True;
	}
}

event TakeDamage (int Damage, Pawn EventInstigator, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType)
{
	logWarning("Called TakeDamage for a R6Pawn.  Not safe!!");
}

function PlayerController GetHumanLeaderForAIPawn ()
{
	local R6RainbowTeam _TeamManager;

	if ( R6RainbowAI(Controller) == None )
	{
		return None;
	}
	_TeamManager=R6RainbowAI(Controller).m_TeamManager;
	if ( (_TeamManager == None) || (_TeamManager.m_TeamLeader == None) || (_TeamManager.m_TeamLeader.Owner == None) )
	{
		return None;
	}
	return PlayerController(_TeamManager.m_TeamLeader.Owner);
}

function int R6TakeDamage (int iKillValue, int iStunValue, Pawn instigatedBy, Vector vHitLocation, Vector vMomentum, int iBulletToArmorModifier, optional int iBulletGoup)
{
	local eKillResult eKillFromTable;
	local eStunResult eStunFromTable;
	local eBodyPart eHitPart;
	local int iKillFromHit;
	local Vector vBulletDirection;
	local int iSndIndex;
	local bool bIsSilenced;
	local R6BloodSplat BloodSplat;
	local Rotator BloodRotation;
	local R6WallHit aBloodEffect;
	local bool _bAffectedActor;
	local PlayerController _playerController;

	if ( (PlayerController(Controller) != None) && (PlayerController(Controller).GameReplicationInfo != None) && (PlayerController(Controller).GameReplicationInfo.m_eGameTypeFlag == RGM_CaptureTheEnemyAdvMode) )
	{
		return R6TakeDamageCTE(iKillValue,iStunValue,instigatedBy,vHitLocation,vMomentum,iBulletToArmorModifier,iBulletGoup);
	}
	if ( (instigatedBy != None) && (instigatedBy.EngineWeapon != None) )
	{
		_bAffectedActor=instigatedBy.EngineWeapon.AffectActor(iBulletGoup,self);
	}
	else
	{
		_bAffectedActor=False;
	}
	if ( IsEnemy(instigatedBy) && _bAffectedActor )
	{
		if ( Level.NetMode == NM_Standalone )
		{
			if ( (instigatedBy != None) && (instigatedBy.m_ePawnType == 1) )
			{
				R6Rainbow(instigatedBy).IncrementRoundsHit();
			}
		}
		else
		{
			if ( (instigatedBy != None) && (Level.Game.m_bCompilingStats == True) )
			{
				if ( instigatedBy.PlayerReplicationInfo != None )
				{
					instigatedBy.PlayerReplicationInfo.m_iRoundsHit++;
				}
				else
				{
					_playerController=R6Pawn(instigatedBy).GetHumanLeaderForAIPawn();
					if ( _playerController != None )
					{
						_playerController.PlayerReplicationInfo.m_iRoundsHit++;
					}
				}
			}
		}
	}
	TakeHitLocation=vHitLocation;
	if (  !IsAlive() )
	{
		if ( Level.NetMode != 1 )
		{
			KAddImpulse(Normal(vMomentum) * 50000,vHitLocation);
		}
		return 0;
	}
	if ( Level.NetMode == NM_Client )
	{
		if ( m_bIsPlayer && R6PlayerController(Controller).GameReplicationInfo.m_bGameOverRep )
		{
			return 0;
		}
	}
	else
	{
		if ( Level.Game.m_bGameOver &&  !R6AbstractGameInfo(Level.Game).m_bGameOverButAllowDeath )
		{
			return 0;
		}
	}
	if ( (m_ePawnType == 1) &&  !m_bIsPlayer )
	{
		R6RainbowAI(Controller).IsBeingAttacked(instigatedBy);
	}
	if ( InGodMode() )
	{
		return 0;
	}
	eHitPart=WhichBodyPartWasHit(vHitLocation,vMomentum);
	m_eLastHitPart=eHitPart;
	if ( (instigatedBy != None) && (instigatedBy.EngineWeapon != None) )
	{
		bIsSilenced=instigatedBy.EngineWeapon.m_bIsSilenced;
	}
	else
	{
		bIsSilenced=False;
	}
	if ( m_eHealth != 3 )
	{
		if ( m_iForceKill != 0 )
		{
			switch (m_iForceKill)
			{
				case 1:
				eKillFromTable=KR_None;
				break;
				case 2:
				eKillFromTable=KR_Wound;
				break;
				case 3:
				eKillFromTable=KR_Incapacitate;
				break;
				case 4:
				eKillFromTable=KR_Killed;
				break;
				default:
			}
		}
		else
		{
			eKillFromTable=GetKillResult(iKillValue,eHitPart,m_eArmorType,iBulletToArmorModifier,bIsSilenced);
		}
		if ( (m_iForceStun != 0) && (m_iForceStun < 5) )
		{
			switch (m_iForceStun)
			{
				case 1:
				eStunFromTable=SR_None;
				break;
				case 2:
				eStunFromTable=SR_Stunned;
				break;
				case 3:
				eStunFromTable=SR_Dazed;
				break;
				case 4:
				eStunFromTable=SR_KnockedOut;
				break;
				default:
			}
		}
		else
		{
			eStunFromTable=GetStunResult(iStunValue,eHitPart,m_eArmorType,iBulletToArmorModifier,bIsSilenced);
		}
		vBulletDirection=Normal(vMomentum);
		BloodRotation=rotator(vBulletDirection);
		BloodRotation.Roll=0;
		if (  !InGodMode() && (eKillFromTable != 0) )
		{
			aBloodEffect=Spawn(Class'R6BloodEffect',,,vHitLocation);
			if ( (aBloodEffect != None) &&  !_bAffectedActor )
			{
				aBloodEffect.m_bPlayEffectSound=False;
			}
		}
		if ( eKillFromTable == 3 )
		{
			BloodSplat=Spawn(Class'R6BloodSplat',,,vHitLocation,BloodRotation);
		}
		else
		{
			if ( eKillFromTable != 0 )
			{
				BloodSplat=Spawn(Class'R6BloodSplatSmall',,,vHitLocation,BloodRotation);
			}
		}
		if ( m_iTracedBone != 0 )
		{
			m_rHitDirection=rotator(vBulletDirection);
			if ( Level.NetMode != 3 )
			{
//				SetNextPendingAction(PENDING_Coughing2,m_iTracedBone);
			}
		}
		if ( (eKillFromTable == 3) || ((eKillFromTable == 2) || (eKillFromTable == 1)) && (m_eHealth == 2) || (eKillFromTable == 2) && (m_eHealth == 1) )
		{
			m_eHealth=HEALTH_Dead;
		}
		else
		{
			if ( (eKillFromTable == 2) || (eKillFromTable == 1) && (m_eHealth == 1) )
			{
				m_eHealth=HEALTH_Incapacitated;
			}
			else
			{
				if ( eKillFromTable == 1 )
				{
					m_eHealth=HEALTH_Wounded;
					m_fHBWound=1.20;
					ChangeAnimation();
				}
			}
		}
		if ( (instigatedBy != None) && (R6PlayerController(instigatedBy.Controller) != None) )
		{
			if ( R6PlayerController(instigatedBy.Controller).m_bShowHitLogs )
			{
				Log("Player HIT : " $ string(self) $ " Bullet Energy : " $ string(iKillValue) $ " body part : " $ string(eHitPart) $ " KillResult : " $ string(eKillFromTable) $ " Armor type : " $ string(m_eArmorType));
			}
		}
		if ( (m_ePawnType == 1) && (eKillFromTable != 0) )
		{
			if ( m_bIsPlayer )
			{
				R6PlayerController(Controller).m_TeamManager.m_eMovementMode=MOVE_Assault;
				R6PlayerController(Controller).m_TeamManager.UpdateTeamStatus(self);
			}
			else
			{
				if ( R6RainbowAI(Controller).m_TeamManager != None )
				{
					R6RainbowAI(Controller).m_TeamManager.m_eMovementMode=MOVE_Assault;
					R6RainbowAI(Controller).m_TeamManager.UpdateTeamStatus(self);
				}
			}
		}
		if ( Controller != None )
		{
			Controller.R6DamageAttitudeTo(instigatedBy,eKillFromTable,eStunFromTable,vMomentum);
			if ( eKillFromTable != 0 )
			{
				Controller.PlaySoundDamage(instigatedBy);
			}
		}
		else
		{
		}
		if ( eKillFromTable != 0 )
		{
			iStunValue=Min(iStunValue,5000);
			vMomentum=Normal(vMomentum) * iStunValue * 100;
			if (  !IsAlive() )
			{
				R6Died(instigatedBy,eHitPart,vMomentum);
			}
		}
	}
	iKillFromHit=GetThroughResult(iKillValue,eHitPart,vMomentum);
	if ( PlayerReplicationInfo != None )
	{
		switch (m_eHealth)
		{
			case HEALTH_Healthy:
			PlayerReplicationInfo.m_iHealth=0;
			break;
			case HEALTH_Wounded:
			PlayerReplicationInfo.m_iHealth=1;
			break;
			case HEALTH_Incapacitated:
			case HEALTH_Dead:
			PlayerReplicationInfo.m_iHealth=2;
			break;
			default:
		}
	}
	return iKillFromHit;
}

function R6Died (Pawn Killer, eBodyPart eHitPart, Vector vMomentum)
{
	local R6AbstractGameInfo pGameInfo;
	local int i;
	local R6PlayerController P;
	local R6AbstractWeapon AWeapon;
	local string KillerName;
	local string szPlayerName;

	if ( Killer == None )
	{
		Log(" R6Died() : WARNING : Killer=none");
	}
	if ( Killer.PlayerReplicationInfo != None )
	{
		KillerName=Killer.PlayerReplicationInfo.PlayerName;
	}
	else
	{
		KillerName=Killer.m_CharacterName;
	}
	if ( m_bIsClimbingLadder || (Physics == 11) )
	{
		if ( (m_Ladder == None) || (m_Ladder.MyLadder == None) )
		{
			Log(" R6Died() : WARNING : m_Ladder=" $ string(m_Ladder) $ " m_Ladder.myLadder=" $ string(m_Ladder.MyLadder));
		}
		R6LadderVolume(m_Ladder.MyLadder).RemoveClimber(self);
		if ( m_bIsPlayer && (m_Ladder != None) )
		{
			R6LadderVolume(m_Ladder.MyLadder).DisableCollisions(m_Ladder);
		}
	}
	if ( Physics == 12 )
	{
		if ( Controller != None )
		{
			Controller.GotoState('None');
		}
		if ( bIsCrouched )
		{
			PlayPostRootMotionAnimation(m_crouchDefaultAnimName);
		}
		else
		{
			PlayPostRootMotionAnimation(m_standDefaultAnimName);
		}
	}
	AWeapon=R6AbstractWeapon(EngineWeapon);
	if ( (AWeapon != None) && (AWeapon.m_SelectedWeaponGadget != None) )
	{
		AWeapon.m_SelectedWeaponGadget.ActivateGadget(False);
	}
	if ( vMomentum == vect(0.00,0.00,0.00) )
	{
		vMomentum=vect(1.00,1.00,1.00);
	}
	TearOffMomentum=vMomentum;
	bAlwaysRelevant=True;
	i=0;
JL023A:
	if ( i <= 3 )
	{
		if ( m_WeaponsCarried[i] != None )
		{
			m_WeaponsCarried[i].SetRelevant(True);
		}
		i++;
		goto JL023A;
	}
	m_bUseRagdoll=True;
	bProjTarget=False;
	SpawnRagDoll();
	m_KilledBy=R6Pawn(Killer);
	if ( ProcessBuildDeathMessage(Killer,szPlayerName) )
	{
		foreach DynamicActors(Class'R6PlayerController',P)
		{
			P.ClientDeathMessage(KillerName,szPlayerName,m_bSuicideType);
		}
	}
	if ( m_KilledBy == None )
	{
		Log("  R6Died() : Warning!!  m_KilledBy=" $ string(m_KilledBy));
	}
	if ( m_KilledBy == self )
	{
		m_bSuicided=True;
	}
	else
	{
		if ( IsEnemy(m_KilledBy) )
		{
			m_KilledBy.IncrementFragCount();
		}
	}
	if ( R6PlayerController(Controller) != None )
	{
		R6PlayerController(Controller).ClientDisableFirstPersonViewEffects();
		R6PlayerController(Controller).PlayerReplicationInfo.m_szKillersName=KillerName;
	}
	pGameInfo=R6AbstractGameInfo(Level.Game);
	if ( pGameInfo != None )
	{
		if ( (pGameInfo.m_bCompilingStats == True) || pGameInfo.m_bGameOver && pGameInfo.m_bGameOverButAllowDeath )
		{
			if ( Controller.PlayerReplicationInfo != None )
			{
				Controller.PlayerReplicationInfo.Deaths += 1.00;
				if (  !m_bSuicided && (m_KilledBy != None) && (m_KilledBy.Controller != None) && (m_KilledBy.Controller.PlayerReplicationInfo != None) )
				{
					m_KilledBy.Controller.PlayerReplicationInfo.Score += 1.00;
				}
			}
			else
			{
				P=R6PlayerController(GetHumanLeaderForAIPawn());
				if ( P != None )
				{
					P.PlayerReplicationInfo.Deaths += 1.00;
				}
			}
		}
		pGameInfo.PawnKilled(self);
		pGameInfo.SetTeamKillerPenalty(self,Killer);
	}
}

function IncrementFragCount ()
{
	local PlayerController _playerController;

	if ( Level.NetMode == NM_Standalone )
	{
		if ( Instigator.IsA('R6Rainbow') )
		{
			R6Rainbow(Instigator).IncrementKillCount();
		}
	}
	else
	{
		if ( (Level.Game != None) && (Level.Game.m_bCompilingStats == True) )
		{
			if ( PlayerReplicationInfo != None )
			{
				PlayerReplicationInfo.m_iKillCount += 1;
				PlayerReplicationInfo.m_iRoundKillCount += 1;
			}
			else
			{
				_playerController=GetHumanLeaderForAIPawn();
				if ( _playerController != None )
				{
					_playerController.PlayerReplicationInfo.m_iKillCount++;
					_playerController.PlayerReplicationInfo.m_iRoundKillCount++;
				}
			}
		}
	}
}

function ServerForceKillResult (int iKillResult)
{
	m_iForceKill=iKillResult;
}

function ServerForceStunResult (int iStunResult)
{
	m_iForceStun=iStunResult;
}

function ToggleHeatVision ()
{
	if ( Level.m_bHeartBeatOn == True )
	{
		return;
	}
	if ( m_bActivateScopeVision == True )
	{
		m_bActivateHeatVision= !m_bActivateHeatVision;
		R6PlayerController(Controller).m_bHeatVisionActive=m_bActivateHeatVision;
		R6PlayerController(Controller).ServerToggleHeatVision(m_bActivateHeatVision);
		if ( m_bActivateNightVision == True )
		{
			m_bActivateNightVision=False;
			ToggleNightProperties(False,None,None);
//			R6PlayerController(Controller).ClientPlaySound(m_sndNightVisionDeactivation,3);
		}
		if ( m_bActivateHeatVision == True )
		{
			ToggleScopeProperties(False,None,None);
			ToggleHeatProperties(m_bActivateHeatVision,EngineWeapon.m_ScopeTexture,EngineWeapon.m_ScopeAdd);
//			R6PlayerController(Controller).ClientPlaySound(m_sndThermalScopeActivation,3);
		}
		else
		{
			if ( (m_bActivateScopeVision == True) && (m_bActivateHeatVision == False) )
			{
//				R6PlayerController(Controller).ClientPlaySound(m_sndThermalScopeDeactivation,3);
				ToggleHeatProperties(False,None,None);
				ToggleScopeProperties(True,EngineWeapon.m_ScopeTexture,EngineWeapon.m_ScopeAdd);
			}
		}
	}
}

exec function ToggleNightVision ()
{
	if ( Level.m_bHeartBeatOn == True )
	{
		return;
	}
	m_bActivateNightVision= !m_bActivateNightVision;
	if ( R6Rainbow(self) != None )
	{
		R6Rainbow(self).ServerToggleNightVision(m_bActivateNightVision);
	}
	if ( m_bActivateHeatVision == True )
	{
		m_bActivateHeatVision=False;
		R6PlayerController(Controller).m_bHeatVisionActive=m_bActivateHeatVision;
		R6PlayerController(Controller).ServerToggleHeatVision(m_bActivateHeatVision);
		ToggleHeatProperties(False,None,None);
//		R6PlayerController(Controller).ClientPlaySound(m_sndThermalScopeDeactivation,3);
	}
	if ( (m_bActivateScopeVision == True) && (m_bActivateNightVision == True) && (EngineWeapon.m_ScopeTexture != None) )
	{
//		R6PlayerController(Controller).ClientPlaySound(m_sndNightVisionActivation,3);
		ToggleScopeProperties(False,None,None);
		ToggleNightProperties(m_bActivateNightVision,EngineWeapon.m_ScopeTexture,EngineWeapon.m_ScopeAdd);
	}
	else
	{
		if ( (m_bActivateScopeVision == True) && (m_bActivateNightVision == False) )
		{
//			R6PlayerController(Controller).ClientPlaySound(m_sndNightVisionDeactivation,3);
			ToggleNightProperties(False,None,None);
			ToggleScopeProperties(True,EngineWeapon.m_ScopeTexture,EngineWeapon.m_ScopeAdd);
		}
		else
		{
			if ( m_bActivateNightVision )
			{
//				R6PlayerController(Controller).ClientPlaySound(m_sndNightVisionActivation,3);
			}
			else
			{
//				R6PlayerController(Controller).ClientPlaySound(m_sndNightVisionDeactivation,3);
			}
//			ToggleNightProperties(m_bActivateNightVision,Texture'NightVisionTex',None);
		}
	}
}

function ToggleScopeVision ()
{
	if ( Level.m_bHeartBeatOn == True )
	{
		return;
	}
	if ( Level.NetMode == NM_DedicatedServer )
	{
		return;
	}
	m_bActivateScopeVision= !m_bActivateScopeVision;
	if ( (m_bActivateNightVision == False) && (m_bActivateHeatVision == False) )
	{
		ToggleScopeProperties(m_bActivateScopeVision,EngineWeapon.m_ScopeTexture,EngineWeapon.m_ScopeAdd);
	}
	else
	{
		if ( m_bActivateNightVision == True )
		{
			if ( (m_bActivateScopeVision == True) && (EngineWeapon.m_ScopeTexture != None) )
			{
				ToggleNightProperties(True,EngineWeapon.m_ScopeTexture,EngineWeapon.m_ScopeAdd);
			}
			else
			{
//				ToggleNightProperties(True,Texture'NightVisionTex',None);
			}
		}
		else
		{
			if ( m_bActivateHeatVision == True )
			{
				if ( m_bActivateScopeVision == True )
				{
					ToggleHeatProperties(True,EngineWeapon.m_ScopeTexture,EngineWeapon.m_ScopeAdd);
				}
				else
				{
					m_bActivateHeatVision=False;
					R6PlayerController(Controller).m_bHeatVisionActive=m_bActivateHeatVision;
					R6PlayerController(Controller).ServerToggleHeatVision(m_bActivateHeatVision);
					ToggleHeatProperties(False,None,None);
				}
			}
		}
	}
}

exec function ToggleGadget ()
{
	local R6AbstractWeapon AWeapon;

	AWeapon=R6AbstractWeapon(EngineWeapon);
	if ( (AWeapon != None) && (AWeapon.m_SelectedWeaponGadget != None) )
	{
		m_bWeaponGadgetActivated= !m_bWeaponGadgetActivated;
		AWeapon.m_SelectedWeaponGadget.ActivateGadget(m_bWeaponGadgetActivated,R6PlayerController(Controller).bBehindView);
	}
}

function ReloadWeapon ()
{
	EngineWeapon.PlayReloading();
}

simulated function ReloadingWeaponEnd ()
{
	if (  !m_bIsPlayer ||  !(Controller != None) && (R6PlayerController(Controller).bBehindView == False) )
	{
		EngineWeapon.ChangeClip();
		EngineWeapon.GotoState('None');
	}
}

simulated function BoltActionSwitchToRight ();

simulated function WeaponBipod ()
{
	local bool bSetBipod;
	local R6AbstractWeapon pWeaponWithTheBipod;

	pWeaponWithTheBipod=R6AbstractWeapon(EngineWeapon);
	if ( (EngineWeapon == PendingWeapon) || (PendingWeapon == None) )
	{
		bSetBipod=False;
	}
	if ( (Level.NetMode == NM_DedicatedServer) || (Level.NetMode == NM_ListenServer) )
	{
		pWeaponWithTheBipod.m_bDeployBipod=bSetBipod;
	}
	if ( (Level.NetMode == NM_Standalone) || (Level.NetMode == NM_ListenServer) )
	{
		pWeaponWithTheBipod.DeployWeaponBipod(bSetBipod);
	}
}

simulated function WeaponBipodLast ()
{
	local bool bSetBipod;
	local R6AbstractWeapon pWeaponWithTheBipod;

	pWeaponWithTheBipod=R6AbstractWeapon(EngineWeapon);
	if ( (EngineWeapon == PendingWeapon) || (PendingWeapon == None) )
	{
		bSetBipod=m_bWantsToProne;
	}
	else
	{
		if ( PendingWeapon.GotBipod() )
		{
			pWeaponWithTheBipod=R6AbstractWeapon(PendingWeapon);
			bSetBipod=True;
		}
	}
	if ( (Level.NetMode == NM_DedicatedServer) || (Level.NetMode == NM_ListenServer) )
	{
		pWeaponWithTheBipod.m_bDeployBipod=bSetBipod;
	}
	if ( (Level.NetMode == NM_Standalone) || (Level.NetMode == NM_ListenServer) )
	{
		pWeaponWithTheBipod.DeployWeaponBipod(bSetBipod);
	}
}

function ServerPlayReloadAnimAgain ()
{
	m_bReloadAnimLoop= !m_bReloadAnimLoop;
}

simulated function PutShellInWeapon ()
{
	if (  !m_bIsPlayer ||  !(Controller != None) && (R6PlayerController(Controller).bBehindView == False) )
	{
		EngineWeapon.ServerPutBulletInShotgun();
	}
}

simulated function float PrepareDemolitionsAnimation ()
{
	local float fSkillDemolitions;

	fSkillDemolitions=GetSkill(SKILL_Demolitions);
	R6ResetAnimBlendParams(13);
	m_ePlayerIsUsingHands=HANDS_Both;
	PlayWeaponAnimation();
	m_bPostureTransition=True;
	AnimBlendParams(1,1.00,0.00,0.00);
	if ( Controller != None )
	{
//		Controller.PlaySoundCurrentAction(6);
	}
	if ( fSkillDemolitions < 0.60 )
	{
		return 0.80;
	}
	else
	{
		return 0.80 + (fSkillDemolitions - 0.60) / 0.40 * 0.45;
	}
}

simulated function PlayClaymoreAnimation ()
{
	local float fAnimRate;
	local float fTween;

	if ( (Controller != None) &&  !Controller.IsInState('PlayerSetExplosive') )
	{
		if ( Controller.bFire == 1 )
		{
			Controller.GotoState('PlayerSetExplosive');
		}
		else
		{
			return;
		}
	}
	fAnimRate=PrepareDemolitionsAnimation();
	if ( m_bIsProne )
	{
		fTween=0.20;
		PlayAnim('ProneClaymore',fAnimRate,fTween,1);
	}
	else
	{
		if (  !bIsCrouched )
		{
			fTween=1.00;
		}
		PlayAnim('CrouchClaymore',fAnimRate,fTween,1);
	}
}

simulated function PlayRemoteChargeAnimation ()
{
	local float fAnimRate;
	local float fTween;

	if ( (Controller != None) &&  !Controller.IsInState('PlayerSetExplosive') )
	{
		if ( Controller.bFire == 1 )
		{
			Controller.GotoState('PlayerSetExplosive');
		}
		else
		{
			return;
		}
	}
	fAnimRate=PrepareDemolitionsAnimation();
	if ( m_bIsProne )
	{
		fTween=0.20;
		PlayAnim('ProneC4',fAnimRate,fTween,1);
	}
	else
	{
		if (  !bIsCrouched )
		{
			fTween=1.00;
		}
		PlayAnim('CrouchC4',fAnimRate,fTween,1);
	}
}

simulated function PlayBreachDoorAnimation ()
{
	local float fAnimRate;

	if ( m_bIsPlayer && (Controller != None) &&  !Controller.IsInState('PlayerSetExplosive') )
	{
		if ( Controller.bFire == 1 )
		{
			Controller.GotoState('PlayerSetExplosive');
		}
		else
		{
			return;
		}
	}
	fAnimRate=PrepareDemolitionsAnimation();
	if ( bIsCrouched )
	{
		PlayAnim('CrouchPlaceBreach',fAnimRate,0.00,1);
	}
	else
	{
		PlayAnim('StandPlaceBreach',fAnimRate,0.00,1);
	}
}

simulated function PlayInteractWithDeviceAnimation ()
{
	local float fAnimRate;
	local float fSkillDevice;

	if ( (m_eDeviceAnim == 1) || (m_eDeviceAnim == 0) )
	{
		fSkillDevice=GetSkill(SKILL_Demolitions);
	}
	else
	{
		fSkillDevice=GetSkill(SKILL_Electronics);
	}
	if ( fSkillDevice < 0.80 )
	{
		fAnimRate=1.00 + (0.80 - fSkillDevice) / 0.80 * 0.25;
	}
	else
	{
		fAnimRate=0.80 + (1 - fSkillDevice) / 0.20 * 0.20;
	}
	R6ResetAnimBlendParams(13);
	m_ePlayerIsUsingHands=HANDS_Both;
	PlayWeaponAnimation();
	m_bPostureTransition=True;
	AnimBlendParams(1,1.00,0.00,0.00);
	switch (m_eDeviceAnim)
	{
		case BA_Keypad:
		if ( Controller != None )
		{
//			Controller.PlaySoundCurrentAction(8);
		}
		if ( bIsCrouched )
		{
			LoopAnim('CrouchKeyPad_c',fAnimRate,0.50,1);
		}
		else
		{
			LoopAnim('StandKeyPad_c',fAnimRate,0.50,1);
		}
		break;
		case BA_ArmBomb:
		case BA_DisarmBomb:
		LoopAnim('CrouchDisarmBomb_c',fAnimRate,0.50,1);
		break;
		case BA_PlantDevice:
		if ( Controller != None )
		{
//			Controller.PlaySoundCurrentAction(0);
		}
		if ( bIsCrouched )
		{
			LoopAnim('CrouchPlaceBug_c',fAnimRate,0.50,1);
		}
		else
		{
			LoopAnim('StandPlaceBug_c',fAnimRate,0.50,1);
		}
		break;
		case BA_Keyboard:
		if ( Controller != None )
		{
//			Controller.PlaySoundCurrentAction(2);
		}
		if ( bIsCrouched )
		{
			LoopAnim('CrouchKeyboard_c',fAnimRate,0.50,1);
		}
		else
		{
			LoopAnim('StandKeyboard_c',fAnimRate,0.50,1);
		}
		break;
		default:
	}
}

simulated function PlayProneFireAnimation ()
{
	local name animName;
	local float fRatio;

	if ( m_ePawnType == 2 )
	{
		return;
	}
	fRatio=100.00;
	if ( m_iRepBipodRotationRatio > 0 )
	{
		if ( EngineWeapon.IsLMG() == True )
		{
			animName='ProneBipodRightFireLMG';
		}
		else
		{
			if ( EngineWeapon.GetProneFiringAnimName() == 'ProneBipodFireAndBoltRifle' )
			{
				animName='ProneBipodRightFireAndBoltRifle';
			}
			else
			{
				animName='ProneBipodRightFireSniper';
			}
		}
	}
	else
	{
		if ( EngineWeapon.IsLMG() == True )
		{
			animName='ProneBipodLeftFireLMG';
		}
		else
		{
			if ( EngineWeapon.GetProneFiringAnimName() == 'ProneBipodFireAndBoltRifle' )
			{
				animName='ProneBipodLeftFireAndBoltRifle';
			}
			else
			{
				animName='ProneBipodLeftFireSniper';
			}
		}
	}
	if ( IsLocallyControlled() && (Level.NetMode != 0) )
	{
		fRatio=Abs(m_fBipodRotation / 5600);
	}
	else
	{
		fRatio=Abs(m_iRepBipodRotationRatio / fRatio);
	}
	AnimBlendParams(12,fRatio,0.00,0.00,'R6');
	PlayAnim(animName,1.50,0.00,12);
}

simulated function bool GetReloadWeaponAnimation (out STWeaponAnim stAnim)
{
	return False;
}

simulated function bool GetChangeWeaponAnimation (out STWeaponAnim stAnim)
{
	return False;
}

simulated function bool GetFireWeaponAnimation (out STWeaponAnim stAnim)
{
	return False;
}

simulated function bool GetThrowGrenadeAnimation (out STWeaponAnim stAnim)
{
	return False;
}

simulated function bool GetNormalWeaponAnimation (out STWeaponAnim stAnim)
{
	return False;
}

simulated function bool GetPawnSpecificAnimation (out STWeaponAnim stAnim)
{
	return False;
}

simulated function bool HasPawnSpecificWeaponAnimation ()
{
	return False;
}

simulated event PlayWeaponAnimation ()
{
	local STWeaponAnim stAnim;
	local bool bContinue;

	if ( m_bWeaponTransition || m_bPostureTransition )
	{
		return;
	}
	if ( m_ePlayerIsUsingHands == 3 )
	{
		if ( m_eLastUsingHands != m_ePlayerIsUsingHands )
		{
			m_eLastUsingHands=m_ePlayerIsUsingHands;
			R6ResetAnimBlendParams(14);
			R6ResetAnimBlendParams(15);
		}
		return;
	}
	if ( EngineWeapon == None )
	{
		bContinue=GetNormalWeaponAnimation(stAnim);
	}
	else
	{
		if ( HasPawnSpecificWeaponAnimation() )
		{
			bContinue=GetPawnSpecificAnimation(stAnim);
		}
		else
		{
			if ( m_bReloadingWeapon )
			{
				bContinue=GetReloadWeaponAnimation(stAnim);
			}
			else
			{
				if ( m_bChangingWeapon )
				{
					bContinue=GetChangeWeaponAnimation(stAnim);
				}
				else
				{
					if ( EngineWeapon.bFiredABullet == True )
					{
						bContinue=GetFireWeaponAnimation(stAnim);
						EngineWeapon.bFiredABullet=False;
					}
					else
					{
						if ( m_eGrenadeThrow != 0 )
						{
							bContinue=GetThrowGrenadeAnimation(stAnim);
						}
						else
						{
							bContinue=GetNormalWeaponAnimation(stAnim);
						}
					}
				}
			}
		}
	}
	if ( m_bReAttachToRightHand == True )
	{
		BoltActionSwitchToRight();
	}
	if ( bContinue )
	{
		if ( m_bPreviousAnimPlayOnce || (m_WeaponAnimPlaying != stAnim.nAnimToPlay) || (m_eLastUsingHands != m_ePlayerIsUsingHands) )
		{
			m_bPreviousAnimPlayOnce=stAnim.bPlayOnce;
			m_eLastUsingHands=m_ePlayerIsUsingHands;
			if ( (m_ePlayerIsUsingHands == 0) || (m_ePlayerIsUsingHands == 2) )
			{
				AnimBlendParams(14,1.00,,,stAnim.nBlendName);
				if ( stAnim.bPlayOnce )
				{
					PlayAnim(stAnim.nAnimToPlay,stAnim.fRate,stAnim.fTweenTime,14,stAnim.bBackward);
				}
				else
				{
					LoopAnim(stAnim.nAnimToPlay,stAnim.fRate,stAnim.fTweenTime,14);
				}
				m_WeaponAnimPlaying=stAnim.nAnimToPlay;
			}
			else
			{
				if (  !m_bNightVisionAnimation )
				{
					R6ResetAnimBlendParams(14);
				}
			}
			if ( ((m_ePlayerIsUsingHands == 0) || (m_ePlayerIsUsingHands == 1)) && (stAnim.nBlendName == 'R6 R Clavicle') )
			{
				AnimBlendParams(15,1.00,,,'R6 L Clavicle');
				if ( stAnim.bPlayOnce )
				{
					PlayAnim(stAnim.nAnimToPlay,stAnim.fRate,stAnim.fTweenTime,15,stAnim.bBackward);
				}
				else
				{
					LoopAnim(stAnim.nAnimToPlay,stAnim.fRate,stAnim.fTweenTime,15);
					m_WeaponAnimPlaying=stAnim.nAnimToPlay;
				}
			}
			else
			{
				if (  !m_bNightVisionAnimation )
				{
					R6ResetAnimBlendParams(15);
				}
			}
		}
	}
}

function ServerChangedWeapon (R6EngineWeapon OldWeapon, R6EngineWeapon W)
{
	local Vector vTagLocation;
	local Rotator rTagRotator;

	if ( W == None )
	{
		return;
	}
	if ( OldWeapon != None )
	{
		OldWeapon.SetDefaultDisplayProperties();
		DetachFromBone(OldWeapon);
	}
	EngineWeapon=W;
	m_pBulletManager.SetBulletParameter(EngineWeapon);
	AttachWeapon(EngineWeapon,EngineWeapon.m_AttachPoint);
	EngineWeapon.SetRelativeLocation(vect(0.00,0.00,0.00));
	if ( Level.NetMode == NM_ListenServer )
	{
		PlayWeaponAnimation();
	}
}

simulated function GetClipInHand ()
{
	if ( (R6AbstractWeapon(EngineWeapon) != None) && (R6AbstractWeapon(EngineWeapon).m_MagazineGadget != None) )
	{
		R6AbstractWeapon(EngineWeapon).m_MagazineGadget.SetBase(None);
		AttachToBone(R6AbstractWeapon(EngineWeapon).m_MagazineGadget,'TagMagazineHand');
		R6AbstractWeapon(EngineWeapon).m_MagazineGadget.SetRelativeLocation(vect(0.00,0.00,0.00));
		R6AbstractWeapon(EngineWeapon).m_MagazineGadget.SetRelativeRotation(rot(0,0,0));
	}
}

simulated function AttachClipToWeapon ()
{
	if ( R6AbstractWeapon(EngineWeapon).m_MagazineGadget != None )
	{
		DetachFromBone(R6AbstractWeapon(EngineWeapon).m_MagazineGadget);
		R6AbstractWeapon(EngineWeapon).m_MagazineGadget.UpdateAttachment(EngineWeapon);
	}
}

simulated function FootStepLadder ()
{
	if ( m_Ladder != None )
	{
		SendPlaySound(R6LadderVolume(m_Ladder.MyLadder).m_FootSound,SLOT_SFX);
	}
}

simulated function HandGripLadder ()
{
	if ( m_Ladder != None )
	{
		SendPlaySound(R6LadderVolume(m_Ladder.MyLadder).m_HandSound,SLOT_SFX);
	}
}

simulated function FootStepRight ()
{
	m_bLeftFootDown=False;
	FootStep('R6 R Foot',False);
}

simulated function FootStepLeft ()
{
	m_bLeftFootDown=True;
	FootStep('R6 L Foot',True);
}

simulated event PlaySurfaceSwitch ()
{
	if ( m_ePawnType == 1 )
	{
		SendPlaySound(Level.m_SurfaceSwitchSnd,SLOT_SFX);
	}
	else
	{
		SendPlaySound(Level.m_SurfaceSwitchForOtherPawnSnd,SLOT_SFX);
	}
}

function bool IsFighting ()
{
	return False;
}

function bool IsStationary ()
{
	if ( (Velocity == vect(0.00,0.00,0.00)) && (Acceleration == vect(0.00,0.00,0.00)) )
	{
		return True;
	}
	else
	{
		return False;
	}
}

simulated function bool CheckForPassiveGadget (string aClassName)
{
	return False;
}

function CreateBulletManager ()
{
	local Class<R6AbstractBulletManager> aBulletMgrClass;

	aBulletMgrClass=Class<R6AbstractBulletManager>(DynamicLoadObject("R6Weapons.R6BulletManager",Class'Class'));
	m_pBulletManager=Spawn(aBulletMgrClass);
	if ( m_pBulletManager != None )
	{
		m_pBulletManager.InitBulletMgr(self);
	}
}

simulated function ServerGivesWeaponToClient (string aClassName, int iWeaponOrItemSlot, optional string bulletType, optional string weaponGadget)
{
	local Class<R6AbstractWeapon> WeaponClass;
	local R6AbstractWeapon NewWeapon;

	if ( m_pBulletManager == None )
	{
		CreateBulletManager();
	}
	if ( iWeaponOrItemSlot == 4 )
	{
		if ( (m_WeaponsCarried[2] != None) && (m_WeaponsCarried[3] != None) )
		{
			return;
		}
	}
	else
	{
		if ( m_WeaponsCarried[iWeaponOrItemSlot - 1] != None )
		{
			return;
		}
	}
	if ( m_SoundRepInfo != None )
	{
		if ( (iWeaponOrItemSlot == 2) && (m_WeaponsCarried[0] == None) )
		{
			m_SoundRepInfo.m_CurrentWeapon=1;
		}
		else
		{
			if ( iWeaponOrItemSlot == 1 )
			{
				m_SoundRepInfo.m_CurrentWeapon=0;
			}
		}
	}
	if ( CheckForPassiveGadget(aClassName) )
	{
		return;
	}
	WeaponClass=Class<R6AbstractWeapon>(DynamicLoadObject(aClassName,Class'Class'));
	NewWeapon=Spawn(WeaponClass,self);
	if ( NewWeapon != None )
	{
		NewWeapon.m_InventoryGroup=iWeaponOrItemSlot;
		if ( (iWeaponOrItemSlot == 4) && (m_WeaponsCarried[2] == None) )
		{
			NewWeapon.m_InventoryGroup=3;
		}
		NewWeapon.SetHoldAttachPoint();
		if ( Level.NetMode != 0 )
		{
			NewWeapon.RemoteRole=ROLE_AutonomousProxy;
		}
		NewWeapon.Instigator=self;
		if ( m_ePawnType == 1 )
		{
			AttachWeapon(NewWeapon,NewWeapon.m_HoldAttachPoint);
			if ( NewWeapon.m_bHiddenWhenNotInUse )
			{
				NewWeapon.bHidden=True;
			}
		}
		if ( weaponGadget != "" )
		{
			NewWeapon.m_WeaponGadgetClass=Class<R6AbstractGadget>(DynamicLoadObject(weaponGadget,Class'Class'));
		}
		if ( Level.NetMode != 1 )
		{
			NewWeapon.SetGadgets();
		}
		if ( bulletType != "" )
		{
			NewWeapon.GiveBulletToWeapon(bulletType);
		}
		m_WeaponsCarried[NewWeapon.m_InventoryGroup - 1]=NewWeapon;
	}
}

simulated function GetWeapon (R6AbstractWeapon NewWeapon)
{
}

simulated function R6EngineWeapon GetWeaponInGroup (int iGroup)
{
	if ( iGroup == 0 )
	{
		Log(string(self) $ "  Error : GetWeaponInGroup() : iGroup==0, iGroup must be between 1 and 4 ");
		return None;
	}
	return m_WeaponsCarried[iGroup - 1];
}

simulated function AttachWeapon (R6EngineWeapon WeaponToAttach, name Attachment)
{
	if ( WeaponToAttach == None )
	{
		return;
	}
	if ( WeaponToAttach.bNetOwner || (WeaponToAttach.Role == Role_Authority) )
	{
		AttachToBone(WeaponToAttach,Attachment);
	}
}

simulated function AttachCollisionBox (int iNbOfColBox)
{
	if ( (m_collisionBox == None) && (1 <= iNbOfColBox) )
	{
		m_collisionBox=Spawn(Class'R6ColBox',self);
	}
	if ( (m_collisionBox2 == None) && (m_collisionBox != None) && (2 <= iNbOfColBox) )
	{
		m_collisionBox2=Spawn(Class'R6ColBox',m_collisionBox);
		m_collisionBox2.SetCollision(False,False,False);
		m_collisionBox2.bCollideWorld=False;
		m_collisionBox2.bBlockActors=False;
		m_collisionBox2.bBlockPlayers=False;
		m_collisionBox2.m_fFeetColBoxRadius=28.00;
	}
}

event float GetStanceReticuleModifier ()
{
	if ( m_bIsProne )
	{
		if ( EngineWeapon.GotBipod() )
		{
			return 1.30;
		}
		else
		{
			return 1.20;
		}
	}
	else
	{
		if ( bIsCrouched )
		{
			return 1.10;
		}
	}
	return 1.00;
}

function float GetStanceJumpModifier ()
{
	if ( m_bIsProne )
	{
		if ( EngineWeapon.GotBipod() )
		{
			return 0.55;
		}
		else
		{
			return 0.75;
		}
	}
	else
	{
		if ( bIsCrouched )
		{
			return 0.85;
		}
	}
	return 1.00;
}

simulated function bool CanBeAffectedByGrenade (Actor aGrenade, EGrenadeType eType)
{
	if ( m_bIsClimbingLadder || (m_climbObject != None) )
	{
		return False;
	}
	return True;
}

simulated function R6ClientAffectedByFlashbang (Vector vGrenadeLocation)
{
	m_vGrenadeLocation=vGrenadeLocation;
	m_eEffectiveGrenade=GTYPE_FlashBang;
	m_bFlashBangVisualEffectRequested=True;
	m_fRemainingGrenadeTime=5.00;
}

function AffectedByGrenade (Actor aGrenade, EGrenadeType eType)
{
	local R6AIController AIController;

	m_fRemainingGrenadeTime=5.00;
	if ( m_eEffectiveGrenade != eType )
	{
		if ( m_eEffectiveGrenade != 0 )
		{
			EndOfGrenadeEffect(m_eEffectiveGrenade);
		}
		m_eEffectiveGrenade=eType;
		m_fTimeGrenadeEffectBeforeSound=Level.TimeSeconds;
	}
	if ( ((eType != 2) ||  !m_bHaveGasMask) && CanBeAffectedByGrenade(aGrenade,eType) )
	{
		AIController=R6AIController(Controller);
		if ( AIController != None )
		{
//			AIController.AIAffectedByGrenade(aGrenade,eType);
		}
	}
	if ( (eType == 3) && m_bIsPlayer )
	{
		m_vGrenadeLocation=aGrenade.Location;
		R6ClientAffectedByFlashbang(m_vGrenadeLocation);
	}
	if (  !m_bHaveGasMask && (Level.TimeSeconds > m_fTimeGrenadeEffectBeforeSound) )
	{
		m_fTimeGrenadeEffectBeforeSound=Level.TimeSeconds + 7.00 + RandRange(0.00,6.00);
		if ( Controller != None )
		{
//			Controller.PlaySoundAffectedByGrenade(eType);
		}
	}
}

event EndOfGrenadeEffect (EGrenadeType eType)
{
}

function SetRandomWaiting (int iMax, optional bool bDontUseWaitZero)
{
	if ( Role == Role_Authority )
	{
		if ( m_bEngaged )
		{
			m_bRepPlayWaitAnim=0;
		}
		else
		{
			if ( bDontUseWaitZero || (m_byRemainingWaitZero <= 0) )
			{
				m_byRemainingWaitZero=Rand(5) + 1;
				m_bRepPlayWaitAnim=Rand(iMax);
			}
			else
			{
				m_byRemainingWaitZero--;
				m_bRepPlayWaitAnim=0;
			}
		}
	}
}

function SetNextPendingAction (EPendingAction eAction, optional int i)
{
	if ( Level.NetMode == NM_Client )
	{
		logWarning(" client shouldn't call SetNextPendingAction " $ string(eAction));
		return;
	}
	m_iNetCurrentActionIndex++;
	if ( m_iNetCurrentActionIndex >= 5 )
	{
		m_iNetCurrentActionIndex=0;
	}
	m_ePendingAction[m_iNetCurrentActionIndex]=eAction;
	m_iPendingActionInt[m_iNetCurrentActionIndex]=i;
	if ( Level.NetMode != 3 )
	{
		m_iLocalCurrentActionIndex++;
		if ( m_iLocalCurrentActionIndex >= 5 )
		{
			m_iLocalCurrentActionIndex=0;
		}
		if ( IsAlive() )
		{
			PlaySpecialPendingAction(m_ePendingAction[m_iLocalCurrentActionIndex]);
		}
	}
}

simulated event PlaySpecialPendingAction (EPendingAction eAction)
{
	switch (eAction)
	{
		case PENDING_None:
		break;
		case PENDING_Coughing:
		PlayCoughing();
		break;
		case PENDING_Blinded:
		PlayBlinded();
		break;
		case PENDING_OpenDoor:
		PlayDoorAnim(m_Door.m_RotatingDoor);
		break;
		case PENDING_InteractWithDevice:
		PlayInteractWithDeviceAnimation();
		break;
		case PENDING_StartClimbingLadder:
		PlayStartClimbing();
		break;
		case PENDING_PostStartClimbingLadder:
		PlayPostStartLadder();
		break;
		case PENDING_EndClimbingLadder:
		PlayEndClimbing();
		break;
		case PENDING_PostEndClimbingLadder:
		PlayPostEndLadder();
		break;
		case PENDING_DropWeapon:
		DropWeaponToGround();
		break;
		case PENDING_CrouchToProne:
		PlayCrouchToProne();
		break;
		case PENDING_ProneToCrouch:
		PlayProneToCrouch();
		break;
		case PENDING_MoveHitBone:
		MoveHitBone(m_rHitDirection,m_iPendingActionInt[m_iLocalCurrentActionIndex]);
		break;
		default:
		logWarning("Received PlaySpecialPendingAction not defined for " $ string(eAction));
	}
}

simulated function PlayCoughing ();

simulated function PlayBlinded ();

event KImpact (Actor Other, Vector pos, Vector impactVel, Vector impactNorm)
{
	local Vector vHitLocation;
	local Vector vHitNormal;

	if ( Level.TimeSeconds > m_fTimeStartBodyFallSound )
	{
		if ( Level.NetMode != 3 )
		{
			R6MakeNoise(SNDTYPE_Dead);
		}
		R6Trace(vHitLocation,vHitNormal,pos - vect(0.00,0.00,50.00),pos + vect(0.00,0.00,10.00),8,,m_HitMaterial);
		m_fTimeStartBodyFallSound=Level.TimeSeconds + 1;
		if ( m_ePawnType == 1 )
		{
			SendPlaySound(Level.m_BodyFallSwitchSnd,SLOT_SFX);
		}
		else
		{
			SendPlaySound(Level.m_BodyFallSwitchForOtherPawnSnd,SLOT_SFX);
		}
	}
}

simulated function DropWeaponToGround ()
{
	if ( EngineWeapon != None )
	{
		EngineWeapon.StartFalling();
		m_bDroppedWeapon=True;
	}
}

simulated event SpawnRagDoll ()
{
	local Class<R6AbstractCorpse> corpseClass;
	local KarmaParamsSkel skelParams;
	local Vector shotDir;
	local Vector shotDir2D;
	local Vector hitLocRel;
	local float maxDim;
	local int i;

	StopWeaponSound();
	DropWeaponToGround();
	bPlayedDeath=True;
	m_fTimeStartBodyFallSound=Level.TimeSeconds + 0.50;
	SendPlaySound(m_sndDeathClothes,SLOT_SFX);
	if (  !m_bUseKarmaRagdoll )
	{
		SetPhysics(PHYS_None);
		m_ragdoll=Spawn(Class'R6RagDoll',self,,Location,Rotation);
		m_ragdoll.FirstInit(self);
	}
	else
	{
		if ( Level.NetMode != 1 )
		{
			KMakeRagdollAvailable();
			if ( KIsRagdollAvailable() )
			{
				skelParams=KarmaParamsSkel(KParams);
				shotDir=Normal(TearOffMomentum);
				if ( TakeHitLocation != vect(0.00,0.00,0.00) )
				{
					hitLocRel=(TakeHitLocation - GetBoneCoords('R6 Spine').Origin) * 1000.00;
					hitLocRel.Z=0.00;
					shotDir2D=shotDir;
					shotDir2D.Z=0.00;
					skelParams.KStartAngVel=hitLocRel Cross Normal(shotDir2D);
				}
				skelParams.KStartLinVel.X=0.60 * Velocity.X;
				skelParams.KStartLinVel.Y=0.60 * Velocity.Y;
				skelParams.KStartLinVel.Z=1.00 * Velocity.Z;
				skelParams.KStartLinVel += shotDir * 200;
				maxDim=Max(CollisionRadius,CollisionHeight);
				skelParams.KShotStart=TakeHitLocation - 1 * shotDir;
				skelParams.KShotEnd=TakeHitLocation + 2 * maxDim * shotDir;
				skelParams.KShotStrength=VSize(TearOffMomentum);
				KParams=skelParams;
				KSetBlockKarma(True);
				SetPhysics(PHYS_KarmaRagDoll);
			}
		}
	}
	if ( m_BreathingEmitter != None )
	{
		m_BreathingEmitter.Emitters[0].AllParticlesDead=False;
		m_BreathingEmitter.Emitters[0].m_iPaused=1;
		DetachFromBone(m_BreathingEmitter);
		m_BreathingEmitter.Destroy();
		m_BreathingEmitter=None;
	}
	GotoState('Dead');
}

simulated event StopAnimForRG ()
{
	local Rotator Rot;

	StopAnimating(True);
	m_bAnimStopedForRG=True;
	Rot.Yaw=1500;
	SetBoneRotation('R6 PonyTail1',Rot,,1.00,1.00);
}

simulated state Dead
{
	ignores  PlayWaiting, PlayWeaponAnimation;

	simulated function BeginState ()
	{
	}

	event Vector EyePosition ()
	{
		return GetBoneCoords('R6 Head').Origin - Location;
	}

	event Timer ()
	{
		bProjTarget=False;
	}

Begin:
	if ( IsPeeking() )
	{
		SetPeekingInfo(PEEK_none,1000.00);
	}
	bProjTarget=True;
	SetCollision(True,False,False);
	SetCollisionSize(1.50 * Default.CollisionRadius,1.00 * Default.CollisionHeight);
	SetTimer(0.50,False);
	if ( m_collisionBox != None )
	{
		m_collisionBox.EnableCollision(False);
	}
	if ( m_collisionBox2 != None )
	{
		m_collisionBox2.EnableCollision(False);
	}
	if ( Controller != None )
	{
		Controller.FocalPoint=vect(0.00,0.00,0.00);
		Controller.Focus=None;
		Controller.bRotateToDesired=False;
		Controller.PawnDied();
	}
	bRotateToDesired=False;
	if ( Level.NetMode != 3 )
	{
		R6MakeNoise(SNDTYPE_Dead);
	}
}

simulated event InitBiPodPosture (bool bEnable)
{
	ResetBipodPosture();
	m_bUsingBipod=bEnable;
	if ( m_bUsingBipod && (m_ePeekingMode != 0) )
	{
		SetPeekingInfo(PEEK_none,1000.00);
	}
	m_iMaxRotationOffset=GetMaxRotationOffset();
}

simulated event ResetBipodPosture ()
{
	m_fBipodRotation=0.00;
	m_iLastBipodRotation=0;
	m_iRepBipodRotationRatio=0;
}

simulated event UpdateBipodPosture ()
{
	local name animName;
	local float fRatio;

	if ( EngineWeapon.bFiredABullet == True )
	{
		PlayProneFireAnimation();
		EngineWeapon.bFiredABullet=False;
		return;
	}
	if ( m_iLastBipodRotation == m_iRepBipodRotationRatio )
	{
		return;
	}
	if ( m_iRepBipodRotationRatio > 0 )
	{
		if ( EngineWeapon.IsLMG() == True )
		{
			animName='ProneBipodRightLMGBreathe';
		}
		else
		{
			animName='ProneBipodRightSniperBreathe';
		}
	}
	else
	{
		if ( EngineWeapon.IsLMG() == True )
		{
			animName='ProneBipodLeftLMGBreathe';
		}
		else
		{
			animName='ProneBipodLeftSniperBreathe';
		}
	}
	fRatio=100.00;
	if ( IsLocallyControlled() && (Level.NetMode != 0) )
	{
		fRatio=Abs(m_fBipodRotation / 5600);
	}
	else
	{
		fRatio=Abs(m_iRepBipodRotationRatio / fRatio);
	}
	AnimBlendParams(12,fRatio,0.00,0.00,'R6');
	PlayAnim(animName,1.00,0.00,12);
	m_iLastBipodRotation=m_iRepBipodRotationRatio;
}

function bool CanPeek ()
{
	return  !m_bUsingBipod;
}

function EnteredExtractionZone (R6AbstractExtractionZone Zone);

function LeftExtractionZone (R6AbstractExtractionZone Zone);

function SetFriendlyFire ()
{
	local bool bFriendlyFire;

	if ( Controller.IsA('AIController') )
	{
		m_bCanFireFriends=Default.m_bCanFireFriends;
		m_bCanFireNeutrals=Default.m_bCanFireNeutrals;
	}
	else
	{
		if ( m_ePawnType != 1 )
		{
			Log("WARNING: SetFriendlyFire unknow m_ePawnType for " $ string(self));
		}
		if ( Level.IsGameTypeMultiplayer(R6AbstractGameInfo(Level.Game).m_eGameTypeFlag) )
		{
			bFriendlyFire=R6AbstractGameInfo(Level.Game).m_bFriendlyFire;
		}
		else
		{
			bFriendlyFire=True;
		}
		m_bCanFireFriends=bFriendlyFire;
		m_bCanFireNeutrals=bFriendlyFire;
	}
}

simulated function CrouchToStand ()
{
	SendPlaySound(m_sndCrouchToStand,SLOT_SFX);
}

simulated function StandToCrouch ()
{
	SendPlaySound(m_sndStandToCrouch,SLOT_SFX);
}

function PlayLocalWeaponSound (EWeaponSound EWeaponSound)
{
	if ( m_SoundRepInfo != None )
	{
//		m_SoundRepInfo.PlayLocalWeaponSound(EWeaponSound);
	}
}

function PlayWeaponSound (EWeaponSound EWeaponSound)
{
	if ( m_SoundRepInfo != None )
	{
		SetAudioInfo();
//		m_SoundRepInfo.PlayWeaponSound(EWeaponSound);
	}
}

simulated function StopWeaponSound ()
{
	if ( m_SoundRepInfo != None )
	{
		m_SoundRepInfo.StopWeaponSound();
	}
}

event FellOutOfWorld ()
{
	if ( Role < Role_Authority )
	{
		return;
	}
	if (  !m_bIsPlayer )
	{
		ServerSuicidePawn(3);
	}
}

function int R6TakeDamageCTE (int iKillValue, int iStunValue, Pawn instigatedBy, Vector vHitLocation, Vector vMomentum, int iBulletToArmorModifier, optional int iBulletGoup)
{
	local eKillResult eKillFromTable;
	local eStunResult eStunFromTable;
	local eBodyPart eHitPart;
	local int iKillFromHit;
	local Vector vBulletDirection;
	local int iSndIndex;
	local bool bIsSilenced;
	local bool bIsSurrended;
	local R6BloodSplat BloodSplat;
	local Rotator BloodRotation;
	local R6WallHit aBloodEffect;
	local bool _bAffectedActor;

	if ( bInvulnerableBody || IsA('R6Rainbow') && R6Rainbow(self).m_bIsSurrended )
	{
		return 0;
	}
	if ( (instigatedBy != None) && (instigatedBy.EngineWeapon != None) )
	{
		_bAffectedActor=instigatedBy.EngineWeapon.AffectActor(iBulletGoup,self);
	}
	else
	{
		_bAffectedActor=False;
	}
	if ( IsEnemy(instigatedBy) && _bAffectedActor )
	{
		if ( Level.NetMode == NM_Standalone )
		{
			if ( (instigatedBy != None) && (instigatedBy.m_ePawnType == 1) )
			{
				R6Rainbow(instigatedBy).IncrementRoundsHit();
			}
		}
		else
		{
			if ( (instigatedBy != None) && (instigatedBy.PlayerReplicationInfo != None) && (Level.Game.m_bCompilingStats == True) )
			{
				instigatedBy.PlayerReplicationInfo.m_iRoundsHit++;
			}
		}
	}
	else
	{
		return 0;
	}
	TakeHitLocation=vHitLocation;
	if ( Level.NetMode == NM_Client )
	{
		if ( m_bIsPlayer && R6PlayerController(Controller).GameReplicationInfo.m_bGameOverRep )
		{
			return 0;
		}
	}
	else
	{
		if ( Level.Game.m_bGameOver &&  !R6AbstractGameInfo(Level.Game).m_bGameOverButAllowDeath )
		{
			return 0;
		}
	}
	if (  !InGodMode() && (iKillValue != 0) )
	{
		aBloodEffect=Spawn(Class'R6BloodEffect',,,vHitLocation);
		if ( (aBloodEffect != None) &&  !_bAffectedActor )
		{
			aBloodEffect.m_bPlayEffectSound=False;
		}
	}
	if ( (m_ePawnType == 1) &&  !m_bIsPlayer )
	{
		R6RainbowAI(Controller).IsBeingAttacked(instigatedBy);
	}
	if ( InGodMode() )
	{
		return 0;
	}
	eHitPart=WhichBodyPartWasHit(vHitLocation,vMomentum);
	m_eLastHitPart=eHitPart;
	if ( (instigatedBy != None) && (instigatedBy.EngineWeapon != None) )
	{
		bIsSilenced=instigatedBy.EngineWeapon.m_bIsSilenced;
	}
	else
	{
		bIsSilenced=False;
	}
	if ( m_iForceKill != 0 )
	{
		switch (m_iForceKill)
		{
			case 1:
			eKillFromTable=KR_None;
			break;
			case 2:
			eKillFromTable=KR_Wound;
			break;
			case 3:
			eKillFromTable=KR_Incapacitate;
			break;
			case 4:
			eKillFromTable=KR_Killed;
			break;
			default:
		}
	}
	else
	{
		eKillFromTable=GetKillResult(iKillValue,eHitPart,m_eArmorType,iBulletToArmorModifier,bIsSilenced);
	}
	if ( (eKillFromTable == 3) || (eKillFromTable == 2) )
	{
		eKillFromTable=KR_Wound;
		bIsSurrended=True;
	}
	if ( (m_iForceStun != 0) && (m_iForceStun < 5) )
	{
		switch (m_iForceStun)
		{
			case 1:
			eStunFromTable=SR_None;
			break;
			case 2:
			eStunFromTable=SR_Stunned;
			break;
			case 3:
			eStunFromTable=SR_Dazed;
			break;
			case 4:
			eStunFromTable=SR_KnockedOut;
			break;
			default:
		}
	}
	else
	{
		eStunFromTable=GetStunResult(iStunValue,eHitPart,m_eArmorType,iBulletToArmorModifier,bIsSilenced);
	}
	vBulletDirection=Normal(vMomentum);
	BloodRotation=rotator(vBulletDirection);
	BloodRotation.Roll=0;
	if ( eKillFromTable != 0 )
	{
		BloodSplat=Spawn(Class'R6BloodSplatSmall',,,vHitLocation,BloodRotation);
	}
	if ( m_iTracedBone != 0 )
	{
		m_rHitDirection=rotator(vBulletDirection);
	}
	if ( bIsSurrended )
	{
		m_eHealth=HEALTH_Healthy;
		m_fHBWound=1.00;
	}
	else
	{
		if ( eKillFromTable == 1 )
		{
			m_eHealth=HEALTH_Wounded;
			m_fHBWound=1.20;
		}
	}
	if ( (instigatedBy != None) && (R6PlayerController(instigatedBy.Controller) != None) )
	{
		if ( R6PlayerController(instigatedBy.Controller).m_bShowHitLogs )
		{
			Log("Player HIT : " $ string(self) $ " Bullet Energy : " $ string(iKillValue) $ " body part : " $ string(eHitPart) $ " KillResult : " $ string(eKillFromTable) $ " Armor type : " $ string(m_eArmorType));
		}
	}
	if ( (m_ePawnType == 1) && (eKillFromTable != 0) )
	{
		if ( m_bIsPlayer )
		{
			R6PlayerController(Controller).m_TeamManager.m_eMovementMode=MOVE_Assault;
			R6PlayerController(Controller).m_TeamManager.UpdateTeamStatus(self);
		}
	}
	if ( Controller != None )
	{
		Controller.R6DamageAttitudeTo(instigatedBy,eKillFromTable,eStunFromTable,vMomentum);
		if ( eKillFromTable != 0 )
		{
			Controller.PlaySoundDamage(instigatedBy);
		}
	}
	else
	{
	}
	if ( eKillFromTable != 0 )
	{
		iStunValue=Min(iStunValue,5000);
		vMomentum=Normal(vMomentum) * iStunValue * 100;
		if ( bIsSurrended )
		{
			if ( (m_ePawnType == 1) && m_bIsPlayer )
			{
				R6Surrender(instigatedBy,eHitPart,vMomentum);
			}
		}
	}
	iKillFromHit=GetThroughResult(iKillValue,eHitPart,vMomentum);
	if ( PlayerReplicationInfo != None )
	{
		switch (m_eHealth)
		{
			case HEALTH_Healthy:
			PlayerReplicationInfo.m_iHealth=0;
			break;
			case HEALTH_Wounded:
			PlayerReplicationInfo.m_iHealth=1;
			break;
			case HEALTH_Dead:
			PlayerReplicationInfo.m_iHealth=2;
			break;
			default:
		}
	}
	return iKillFromHit;
}

function ClientSurrender ()
{
	if ( IsA('R6Rainbow') && R6PlayerController(Controller).IsInState('PlayerStartSurrenderSequence') )
	{
		return;
	}
	Surrender();
}

function Surrender ()
{
	if ( IsA('R6Rainbow') && R6Rainbow(self).m_bIsSurrended )
	{
		return;
	}
	if ( IsA('R6Rainbow') && R6PlayerController(Controller).IsInState('PlayerStartSurrenderSequence') )
	{
		return;
	}
	R6PlayerController(Controller).GotoState('PlayerStartSurrenderSequence');
	if ( IsA('R6Rainbow') )
	{
		R6Rainbow(self).m_bIsSurrended=True;
	}
	if ( Level.NetMode == NM_DedicatedServer )
	{
		ClientSurrender();
	}
}

simulated function Arrested ()
{
	R6Rainbow(self).m_bIsBeingArrestedOrFreed=True;
	R6PlayerController(Controller).GotoState('PlayerStartArrest');
}

function ClientSetFree ()
{
	if ( R6Rainbow(self).m_bIsBeingArrestedOrFreed )
	{
		return;
	}
	SetFree();
}

function SetFree ()
{
	if ( R6Rainbow(self).m_bIsBeingArrestedOrFreed )
	{
		return;
	}
	R6Rainbow(self).m_bIsBeingArrestedOrFreed=True;
	if ( Level.NetMode != 3 )
	{
		ClientSetFree();
	}
	R6PlayerController(Controller).GotoState('PlayerSetFree');
}

function R6Surrender (Pawn Killer, eBodyPart eHitPart, Vector vMomentum)
{
	local R6AbstractGameInfo pGameInfo;
	local int i;
	local R6PlayerController P;
	local R6AbstractWeapon AWeapon;
	local string KillerName;
	local string szPlayerName;

	if ( Killer == None )
	{
		Log(" R6Surrender() : WARNING : Killer=none");
	}
	if ( Killer.PlayerReplicationInfo != None )
	{
		KillerName=Killer.PlayerReplicationInfo.PlayerName;
	}
	else
	{
		KillerName=Killer.m_CharacterName;
	}
	if ( m_bIsClimbingLadder || (Physics == 11) )
	{
		if ( (m_Ladder == None) || (m_Ladder.MyLadder == None) )
		{
			Log(" R6Surrender() : WARNING : m_Ladder=" $ string(m_Ladder) $ " m_Ladder.myLadder=" $ string(m_Ladder.MyLadder));
		}
		R6LadderVolume(m_Ladder.MyLadder).RemoveClimber(self);
		if ( m_bIsPlayer && (m_Ladder != None) )
		{
			R6LadderVolume(m_Ladder.MyLadder).DisableCollisions(m_Ladder);
		}
	}
	if ( Physics == 12 )
	{
		if ( Controller != None )
		{
			Controller.GotoState('None');
		}
		if ( bIsCrouched )
		{
			PlayPostRootMotionAnimation(m_crouchDefaultAnimName);
		}
		else
		{
			PlayPostRootMotionAnimation(m_standDefaultAnimName);
		}
	}
	AWeapon=R6AbstractWeapon(EngineWeapon);
	if ( (AWeapon != None) && (AWeapon.m_SelectedWeaponGadget != None) )
	{
		AWeapon.m_SelectedWeaponGadget.ActivateGadget(False);
	}
	if ( vMomentum == vect(0.00,0.00,0.00) )
	{
		vMomentum=vect(1.00,1.00,1.00);
	}
	TearOffMomentum=vMomentum;
	bAlwaysRelevant=True;
	i=0;
JL0244:
	if ( i <= 3 )
	{
		if ( m_WeaponsCarried[i] != None )
		{
			m_WeaponsCarried[i].SetRelevant(True);
		}
		i++;
		goto JL0244;
	}
	bProjTarget=False;
	m_KilledBy=R6Pawn(Killer);
	if ( ProcessBuildDeathMessage(Killer,szPlayerName) )
	{
		foreach DynamicActors(Class'R6PlayerController',P)
		{
			P.ClientDeathMessage(KillerName,szPlayerName,m_bSuicideType);
		}
	}
	if ( m_KilledBy == None )
	{
		Log("  R6Surrender() : Warning!!  m_KilledBy=" $ string(m_KilledBy));
	}
	if ( IsEnemy(m_KilledBy) )
	{
		m_KilledBy.IncrementFragCount();
	}
	if ( R6PlayerController(Controller) != None )
	{
		R6PlayerController(Controller).PlayerReplicationInfo.m_szKillersName=KillerName;
	}
	Surrender();
}

defaultproperties
{
    m_iNetCurrentActionIndex=255
    m_iLocalCurrentActionIndex=255
    m_eLastUsingHands=3
    m_iUniqueID=1
    m_iDesignRandomTweak=50
    m_iDesignLightTweak=10
    m_iDesignMediumTweak=30
    m_iDesignHeavyTweak=50
    m_bAvoidFacingWalls=True
    m_bUseKarmaRagdoll=True
    m_fSkillAssault=0.80
    m_fSkillDemolitions=0.80
    m_fSkillElectronics=0.80
    m_fSkillSniper=0.80
    m_fSkillStealth=0.80
    m_fSkillSelfControl=0.80
    m_fSkillLeadership=0.80
    m_fSkillObservation=0.80
    m_fWalkingSpeed=170.00
    m_fWalkingBackwardStrafeSpeed=170.00
    m_fRunningSpeed=290.00
    m_fRunningBackwardStrafeSpeed=290.00
    m_fCrouchedWalkingSpeed=80.00
    m_fCrouchedWalkingBackwardStrafeSpeed=80.00
    m_fCrouchedRunningSpeed=150.00
    m_fCrouchedRunningBackwardStrafeSpeed=150.00
    m_fProneSpeed=45.00
    m_fProneStrafeSpeed=17.00
    m_fPeekingGoalModifier=1.00
    m_fPeekingGoal=1000.00
    m_fPeeking=1000.00
    m_fWallCheckDistance=300.00
    m_fZoomJumpReturn=1.00
    m_fHBMove=1.00
    m_fHBWound=1.00
    m_fHBDefcon=1.00
    m_standRunForwardName=StandRunForward
    m_standRunLeftName=StandRunLeft
    m_standRunBackName=StandRunBack
    m_standRunRightName=StandRunRight
    m_standWalkForwardName=StandWalkForward
    m_standWalkBackName=StandWalkBack
    m_standWalkLeftName=StandWalkLeft
    m_standWalkRightName=StandWalkRight
    m_hurtStandWalkLeftName=HurtStandWalkLeft
    m_hurtStandWalkRightName=HurtStandWalkRight
    m_standTurnLeftName=StandTurnLeft
    m_standTurnRightName=StandTurnRight
    m_standFallName=StandFall_nt
    m_standLandName=StandLand
    m_crouchFallName=CrouchFall_nt
    m_crouchLandName=CrouchLand
    m_crouchWalkForwardName=CrouchWalkForward
    m_standStairWalkUpName=StandStairWalkUpForward
    m_standStairWalkUpBackName=StandStairWalkUpBack
    m_standStairWalkUpRightName=StandStairWalkUpRight
    m_standStairWalkDownName=StandStairWalkDownForward
    m_standStairWalkDownBackName=StandStairWalkDownBack
    m_standStairWalkDownRightName=StandStairWalkDownRight
    m_standStairRunUpName=StandStairRunUpForward
    m_standStairRunUpBackName=StandStairRunUpBack
    m_standStairRunUpRightName=StandStairRunUpRight
    m_standStairRunDownName=StandStairRunDownForward
    m_standStairRunDownBackName=StandStairRunDownBack
    m_standStairRunDownRightName=StandStairRunDownRight
    m_crouchStairWalkDownName=CrouchStairWalkDownForward
    m_crouchStairWalkDownBackName=CrouchStairWalkDownBack
    m_crouchStairWalkDownRightName=CrouchStairWalkDownRight
    m_crouchStairWalkUpName=CrouchStairWalkUpForward
    m_crouchStairWalkUpBackName=CrouchStairWalkUpBack
    m_crouchStairWalkUpRightName=CrouchStairWalkUpRight
    m_crouchStairRunUpName=CrouchStairRunUpForward
    m_crouchStairRunDownName=CrouchStairRunDownForward
    m_crouchDefaultAnimName=CrouchSubGunHigh_nt
    m_standDefaultAnimName=StandSubGunHigh_nt
    m_standClimb64DefaultAnimName=StandClimb64Up
    m_standClimb96DefaultAnimName=StandClimb96Up
    bCanCrouch=True
    m_bCanProne=True
    bCanClimbLadders=True
    bCanWalkOffLedges=True
    bSameZoneHearing=True
    bMuffledHearing=True
    bAroundCornerHearing=True
    bDontPossess=True
    m_bWantsHighStance=True
    bPhysicsAnimUpdate=True
    PeripheralVision=0.50
    GroundSpeed=340.00
    LadderSpeed=50.00
    WalkingPct=1.00
    CrouchHeight=60.00
    CrouchRadius=35.00
    m_fProneHeight=28.00
    m_fProneRadius=40.00
    m_fHeartBeatFrequency=90.00
    MovementAnims(0)=StandWalkForward
    MovementAnims(1)=StandWalkLeft
    MovementAnims(2)=StandWalkBack
    MovementAnims(3)=StandWalkRight
    TurnLeftAnim=StandTurnLeft
    TurnRightAnim=StandTurnRight
    m_HeatIntensity=255
    m_bReticuleInfo=True
    m_bShowInHeatVision=True
    m_bDeleteOnReset=True
    m_bPlanningAlwaysDisplay=True
    CollisionRadius=35.00
    CollisionHeight=75.00
    m_fBoneRotationTransition=1.00
    RotationRate=(Pitch=4096,Yaw=30000,Roll=0)
}
/*
    KParams=KarmaParamsSkel'R6AllRagDoll'
    m_pHeartBeatTexture=Texture'Inventory_t.HeartBeat.SphereBeat'
    m_sndHBSSound=Sound'Foley_HBSensor.Play_HBSensorAction2'
    m_sndHearToneSound=Sound'Grenade_FlashBang.Play_HearTone'
    m_sndHearToneSoundStop=Sound'Grenade_FlashBang.Stop_HearTone'
    m_sndNightVisionActivation=Sound'Gadgets_NightVision.Play_NightActivation'
    m_sndNightVisionDeactivation=Sound'Gadgets_NightVision.Stop_NightActivation_Go'
    m_sndCrouchToStand=Sound'Foley_RainbowGear.Play_Crouch_Stand_Gear'
    m_sndStandToCrouch=Sound'Foley_RainbowGear.Play_Stand_Crouch_Gear'
    m_sndThermalScopeActivation=Sound'CommonSniper.Play_ThermScopeActivation'
    m_sndThermalScopeDeactivation=Sound'CommonSniper.Stop_ThermScopeActivation_Go'
    m_sndDeathClothes=Sound'Foley_RainbowClothesLight.Play_DeathClothes'
    m_sndDeathClothesStop=Sound'Foley_RainbowClothesLight.Stop_DeathClothes'
*/

