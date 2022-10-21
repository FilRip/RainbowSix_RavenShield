//================================================================================
// R6PlayerController.
//================================================================================
class R6PlayerController extends PlayerController
	Native
//	NoNativeReplication
	Config(User);

enum ERestKitID {
	ERestKit_SubMachineGuns,
	ERestKit_Shotguns,
	ERestKit_AssaultRifle,
	ERestKit_MachineGuns,
	ERestKit_SniperRifle,
	ERestKit_Pistol,
	ERestKit_MachinePistol,
	ERestKit_PriWpnGadget,
	ERestKit_SecWpnGadget,
	ERestKit_MiscGadget,
	ERestKit_Max
};

enum EButtonName {
	EBN_None,
	EBN_RoundPerMatch,
	EBN_RoundTime,
	EBN_NB_Players,
	EBN_BombTimer,
	EBN_Spectator,
	EBN_RoundPerMission,
	EBN_TimeBetRound,
	EBN_NB_of_Terro,
	EBN_InternetServer,
	EBN_DedicatedServer,
	EBN_FriendlyFire,
	EBN_AllowTeamNames,
	EBN_AutoBalTeam,
	EBN_TKPenalty,
	EBN_AllowRadar,
	EBN_RotateMap,
	EBN_AIBkp,
	EBN_ForceFPersonWp,
	EBN_Recruit,
	EBN_Veteran,
	EBN_Elite,
	EBN_DiffLevel,
	EBN_CamFirstPerson,
	EBN_CamThirdPerson,
	EBN_CamFreeThirdP,
	EBN_CamGhost,
	EBN_CamFadeToBk,
	EBN_CamTeamOnly,
	EBN_LogIn,
	EBN_LogOut,
	EBN_Join,
	EBN_JoinIP,
	EBN_Refresh,
	EBN_Create,
	EBN_Cancel,
	EBN_Launch,
	EBN_EditMsg,
	EBN_CancelUbiCom,
	EBN_Max
};

enum eWeaponGrenadeType {
	GT_GrenadeNone,
	GT_GrenadeFrag,
	GT_GrenadeGas,
	GT_GrenadeFlash,
	GT_GrenadeSmoke
};

enum eDeviceAnimToPlay {
	BA_ArmBomb,
	BA_DisarmBomb,
	BA_Keypad,
	BA_PlantDevice,
	BA_Keyboard
};

enum ePeekingMode {
	PEEK_none,
	PEEK_full,
	PEEK_fluid
};

enum eStrafeDirection {
	STRAFE_None,
	STRAFE_ForwardRight,
	STRAFE_ForwardLeft,
	STRAFE_BackwardRight,
	STRAFE_BackwardLeft
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

enum eDeathCameraMode {
	eDCM_FIRSTPERSON,
	eDCM_THIRDPERSON,
	eDCM_FREETHIRDPERSON,
	eDCM_GHOST,
	eDCM_FADETOBLACK
};

struct STImpactShake
{
	var() int iBlurIntensity;
	var() float fWaveTime;
	var() float fRollMax;
	var() float fRollSpeed;
	var() float fReturnTime;
};

enum eGamePasswordRes {
	GPR_None,
	GPR_MissingPasswd,
	GPR_PasswdSet,
	GPR_PasswdCleared
};

struct STBanPage
{
	var string szBanID[10];
};

const K_MaxBanPageSize= 10;
struct stSoundPriorityPtr
{
	var int Ptr;
};

struct stSoundPriority
{
	var R6SoundReplicationInfo aSoundRepInfo;
	var Sound sndPlayVoice;
	var int iPriority;
	var byte eSlotUse;
	var byte EPawnType;
	var float fTimeStart;
	var bool bIsPlaying;
	var bool bWaitToFinishSound;
};

enum eDefaultCircumstantialAction {
	PCA_None,
	PCA_TeamRegroup,
	PCA_TeamMoveTo,
	PCA_MoveAndGrenade,
	PCA_GrenadeFrag,
	PCA_GrenadeGas,
	PCA_GrenadeFlash,
	PCA_GrenadeSmoke
};

const Authority_Max= 1;
const Authority_Admin= 1;
const Authority_None= 0;
const K_KickFreqTime= 300;
const K_MaxVote= 3;
const K_EmptyBallot= 3;
const K_VotedNo= 2;
const K_VotedYes= 1;
const K_CanNotVote= 0;
const K_MinVote= 0;
const MAX_ProneSpeedRotation= 6600;
const MAX_Pitch= 2000;
var input byte m_bSpecialCrouch;
var input byte m_bSpeedUpDoor;
var input byte m_bPeekLeft;
var input byte m_bPeekRight;
var input byte m_bReloading;
var byte m_bOldPeekLeft;
var byte m_bOldPeekRight;
var byte m_wAutoAim;
var input byte m_bPlayerRun;
var EPawnType m_ePenaltyForKillingAPawn;
var config int m_iDoorSpeed;
var config int m_iFastDoorSpeed;
var config int m_iFluidMovementSpeed;
var() int m_iSpeedLevels[3];
var int m_iShakeBlurIntensity;
var int m_iReturnSpeed;
var int m_iPitchReturn;
var int m_iYawReturn;
var int m_iSpectatorYaw;
var int m_iSpectatorPitch;
var int m_iPlayerCAProgress;
var int m_iTeamId;
var int m_iVoteResult;
var int m_iAdmin;
var int m_iBanPage;
var bool m_bHelmetCameraOn;
var bool m_bScopeZoom;
var bool m_bSniperMode;
var bool m_bShowFPWeapon;
var bool m_bShowHitLogs;
var bool m_bCircumstantialActionInProgress;
var bool m_bAllTeamsHold;
var bool m_bFixCamera;
var() bool bShowLog;
var bool m_bShakeActive;
var bool m_bDisplayMilestoneMessage;
var bool m_bUseFirstPersonWeapon;
var bool m_bPlacedExplosive;
var bool m_bAttachCameraToEyes;
var bool m_bCameraGhost;
var bool m_bCameraFirstPerson;
var bool m_bCameraThirdPersonFixed;
var bool m_bCameraThirdPersonFree;
var bool m_bFadeToBlack;
var bool m_bSpectatorCameraTeamOnly;
var bool m_bSkipBeginState;
var bool m_bPreventTeamMemberUse;
var bool m_bDisplayMessage;
var bool m_bEndOfRoundDataReceived;
var bool m_bInAnOptionsPage;
var bool m_bPawnInitialized;
var bool m_bCanChangeMember;
var bool m_bDisplayActionProgress;
var bool m_bAMenuIsDisplayed;
var bool m_bMatineeRunning;
var bool m_bHasAPenalty;
var bool m_bPenaltyBox;
var bool m_bRequestTKPopUp;
var bool m_bProcessingRequestTKPopUp;
var bool m_bAlreadyPoppedTKPopUpBox;
var bool m_bPlayDeathMusic;
var bool m_bDeadAfterTeamSel;
var bool m_bShowCompleteHUD;
var bool m_bIsSecuringRainbow;
var bool m_bBombSearched;
var config float m_fTeamMoveToDistance;
var float m_fTimedBlurValue;
var float m_fBlurReturnTime;
var float m_fHitEffectTime;
var float m_fShakeTime;
var float m_fMaxShake;
var float m_fCurrentShake;
var float m_fMaxShakeTime;
var float m_fPostFluidMovementDelay;
var float m_fRetLockPosX;
var float m_fRetLockPosY;
var float m_fCurrRetPosX;
var float m_fCurrRetPosY;
var float m_fRetLockTime;
var float m_fShakeReturnTime;
var float m_fDesignerSpeedFactor;
var float m_fDesignerJumpFactor;
var float m_fMilestoneMessageDuration;
var float m_fMilestoneMessageLeft;
var float m_fCurrentDeltaTime;
var float LastDoorUpdateTime;
var float m_fLastVoteKickTime;
var float m_fStartSurrenderTime;
var R6Rainbow m_pawn;
var R6RainbowTeam m_TeamManager;
var R6Pawn m_targetedPawn;
var R6CircumstantialActionQuery m_CurrentCircumstantialAction;
var R6CircumstantialActionQuery m_RequestedCircumstantialAction;
var R6CircumstantialActionQuery m_PlayerCurrentCA;
var InteractionMaster m_InteractionMaster;
var R6InteractionCircumstantialAction m_InteractionCA;
var R6InteractionInventoryMnu m_InteractionInventory;
var R6Rainbow m_BackupTeamLeader;
var Actor m_PrevViewTarget;
var NavigationPoint StartSpot;
var R6GameMenuCom m_MenuCommunication;
var R6GameOptions m_GameOptions;
var R6PlayerController m_TeamKiller;
var Sound m_sndUpdateWritableMap;
var Sound m_sndDeathMusic;
var Sound m_sndMissionComplete;
var R6CommonRainbowVoices m_CommonPlayerVoicesMgr;
var R6AbstractGameService m_GameService;
var R6IOSelfDetonatingBomb m_pSelfDetonatingBomb;
var R6Pawn m_pInteractingRainbow;
var array<stSoundPriorityPtr> m_PlayVoicesPriority;
var Rotator m_rHitRotation;
var Vector m_vAutoAimTarget;
var Vector m_vCameraLocation;
var Rotator m_rCameraRotation;
var Rotator m_rCurrentShakeRotation;
var Rotator m_rTotalShake;
var(R6Impact) STImpactShake m_stImpactHit;
var(R6Impact) STImpactShake m_stImpactStun;
var(R6Impact) STImpactShake m_stImpactDazed;
var(R6Impact) STImpactShake m_stImpactKO;
var Vector m_vNewReturnValue;
var Rotator m_rLastBulletDirection;
var Vector m_vDefaultLocation;
var Vector m_vRequestedLocation;
var Color m_SpectatorColor;
var STBanPage m_BanPage;
var config string m_szLastAdminPassword;
var string m_szMileStoneMessage;
var string m_CharacterName;
var string m_szBanSearch;
var transient float m_fLastBroadcastTimeStamp;
var transient float m_fPreviousBroadcastTimeStamp;
var transient float m_fEndOfChatLockTime;
var transient float m_fLastVoteEmoteTimeStamp;

replication
{
	reliable if ( Role == Role_Authority )
		CountDownPopUpBoxDone,CountDownPopUpBox,ClientStopFadeToBlack,ClientSetMultiplayerSkins,ClientTeamIsDead,ClientGameMsg,ClientMissionObjMsg,ClientRestartMatchMsg,ClientRestartRoundMsg,ClientVoteResult,ClientPlayerVoteMessage,ClientKickVoteMessage,ClientKickBadId,ClientServerMap,ClientTeamFullMessage,ClientServerChangingInfo,ClientBanMatches,ClientPBVersionMismatch,ClientPlayerUnbanned,ClientNoBanMatches,ClientAdminLogin,ClientKickedOut,ClientBanned,ClientPlayVoices,ClientFadeCommonSound,ClientFadeSound,ClientForceUnlockWeapon,ToggleHelmetCameraZoom,ClientEndSurrended,TKPopUpBox,ClientNotifySendStartMatch,ClientNotifySendMatchResults,ClientUpdateLadderStat,ServerIndicatesInvalidCDKey,ClientFinalizeLoading,ClientSetWeaponSound,ClientPlayMusic,ClientDeathMessage,ClientNewLobbyConnection,ClientChangeMap;
	reliable if ( Role < Role_Authority )
		ServerRequestSkins,RestartRound,RestartMatch,ServerNewKitRestSettings,ServerNewMapListSettings,ServerNewGeneralSettings,SendSettingsAndRestartServer,ServerStartChangingInfo,ServerUnPausePreGameRoundTime,ServerPausePreGameRoundTime,LoadServer,Admin,UnBan,ServerBanList,BanId,Ban,KickId,Kick,NewPassword,LockServer,ServerAdminLogin,AutoAdminLogin,Vote,VoteKickID,VoteKick,ServerMap,ServerSwitchWeapon,ServerStartClimbingLadder,ServerStartSurrended,ServerActionKeyPressed,ServerSetGender,ServerPlayRecordedMsg,ServerSetUbiID,ServerEndOfRoundDataSent;
	unreliable if ( Role == Role_Authority )
		ClientGameTypeDescription,ClientResetGameMsg,ClientAdminBanOff,ClientAdminKickOff,ClientNoKickAdmin,ClientCantRequestKickYet,ClientVoteInProgress,ClientNoAuthority,ClientPasswordTooLong,ClientNewPassword,ClientVoteSessionAbort,ClientPasswordMessage,R6ClientWeaponShake,ResetBlur,ClientActionProgressDone,ClientDisableFirstPersonViewEffects,R6Shake,ClientShowWeapon,ClientHideReticule,ClientMPMiscMessage;
	unreliable if ( Role < Role_Authority )
		ServerLogBandWidth,ServerNetLogActor,ServerBroadcast,ServerWeaponUpAnimDone,ServerSetHelmetParams,ServerActionProgressStop,ServerPlayerActionProgress,ServerExecFire,ServerUpdatePeeking,ServerGraduallyCloseDoor,ServerGraduallyOpenDoor,ServerPreviousMember,ServerNextMember,ServerChangeTeams,ServerChangeOperative,RegroupOnMe,ServerSendGoCode,ToggleAllTeamsHold,ToggleTeamHold,ServerSetBipodRotation,ServerSetPeekingInfoRight,ServerSetPeekingInfoLeft,ServerSetCrouchBlend,ServerReloadWeapon,ServerNewPing,ServerActionKeyReleased,ServerSetPlayerStartInfo;
	reliable if ( Role == Role_Authority )
		m_iPlayerCAProgress,m_pawn,m_TeamManager,m_CurrentCircumstantialAction,m_rCurrentShakeRotation;
	reliable if ( Role == Role_Authority )
		m_iAdmin,m_bSkipBeginState,m_bRequestTKPopUp;
}

native(2211) final function UpdateCircumstantialAction ();

native(1843) final function UpdateReticule (float fDeltaTime);

native(2213) final function UpdateSpectatorReticule ();

native(1840) final function DebugFunction ();

native(1224) final function PlayerController FindPlayer (string inPlayerIdent, bool bIsIdInt);

native(2724) final function string LocalizeTraining (string SectionName, string KeyName, string PackageName, int iBox, int iParagraph);

native(1521) final function string GetLocStringWithActionKey (string szText, string szActionKey);

native(2726) final function PlayVoicesPriority (R6SoundReplicationInfo aAudioRepInfo, Sound sndPlayVoice, ESoundSlot eSlotUse, int iPriority, optional bool bWaitToFinishSound, optional float fTime);

simulated function ResetOriginalData ()
{
	if ( m_bResetSystemLog )
	{
		LogResetSystem(False);
	}
	Super.ResetOriginalData();
	m_GameOptions=Class'Actor'.static.GetGameOptions();
	m_bPawnInitialized=False;
	m_bEndOfRoundDataReceived=False;
	m_bCircumstantialActionInProgress=False;
	m_iPlayerCAProgress=0;
	m_TeamManager=None;
	m_bAMenuIsDisplayed=False;
	m_PrevViewTarget=None;
	LastDoorUpdateTime=Default.LastDoorUpdateTime;
	m_bShakeActive=True;
	CancelShake();
	m_bSniperMode=False;
	m_bCircumstantialActionInProgress=False;
	DesiredFOV=Default.DesiredFOV;
	DefaultFOV=Default.DefaultFOV;
	ResetFOV();
	m_bOldPeekLeft=0;
	m_bOldPeekRight=0;
	m_bHelmetCameraOn=False;
	m_bUseFirstPersonWeapon=Default.m_bUseFirstPersonWeapon;
	m_bHideReticule=Default.m_bHideReticule;
	m_bScopeZoom=False;
	m_bAllTeamsHold=False;
	m_bFixCamera=Default.m_bFixCamera;
	m_bAttachCameraToEyes=Default.m_bAttachCameraToEyes;
	bCheatFlying=Default.bCheatFlying;
	m_bInitFirstTick=Default.m_bInitFirstTick;
//	m_eCameraMode=0;
	m_bCrawl=False;
	bDuck=0;
	Enemy=None;
	Target=None;
	LastSeenPos=vect(0.00,0.00,0.00);
	LastSeeingPos=vect(0.00,0.00,0.00);
	LastSeenTime=0.00;
	m_bRequestTKPopUp=False;
	m_bProcessingRequestTKPopUp=False;
	m_TeamKiller=None;
	m_bPlayDeathMusic=False;
	m_bFirstTimeInZone=True;
	m_bLoadSoundGun=False;
	m_bInstructionTouch=False;
	if ( PlayerReplicationInfo != None )
	{
		PlayerReplicationInfo.iOperativeID=-1;
	}
	if ( (Level.NetMode == NM_Client) || (Level.NetMode == NM_ListenServer) && (Viewport(Player) != None) )
	{
		ServerSetGender(m_GameOptions.Gender > 0);
	}
	ResetBlur();
	if ( (m_CurrentCircumstantialAction == None) && (Role == Role_Authority) )
	{
		m_CurrentCircumstantialAction=Spawn(Class'R6CircumstantialActionQuery',self);
	}
	if ( m_CurrentCircumstantialAction != None )
	{
		m_CurrentCircumstantialAction.aQueryOwner=self;
	}
	if ( m_InteractionCA != None )
	{
		m_InteractionCA.DisplayMenu(False);
		m_InteractionCA.m_bActionKeyDown=False;
	}
	if ( m_InteractionInventory != None )
	{
		m_InteractionInventory.DisplayMenu(False);
		m_InteractionInventory.m_bActionKeyDown=False;
	}
	m_bAlreadyPoppedTKPopUpBox=False;
}

simulated function ResettingLevel (int iNbOfRestart)
{
	Pawn=None;
	m_pawn=None;
	SetViewTarget(None);
	if ( m_TeamManager != None )
	{
		m_TeamManager.ResetTeam();
	}
	if ( m_MenuCommunication != None )
	{
		m_MenuCommunication.SetStatMenuState(CMS_DisplayForceStat);
	}
	if ( Level.NetMode == NM_Client )
	{
		Level.ResetLevel(iNbOfRestart);
	}
}

simulated function FirstPassReset ()
{
	SetViewTarget(None);
	if ( m_TeamManager != None )
	{
		m_TeamManager.ResetTeam();
		m_TeamManager=None;
	}
}

function Reset ()
{
	Super.Reset();
	m_bFirstTimeInZone=True;
}

function bool ShouldDisplayIncomingMessages ()
{
	if ( m_MenuCommunication != None )
	{
		return m_MenuCommunication.GetPlayerDidASelection();
	}
	return True;
}

function ClientChangeMap ()
{
	if ( m_MenuCommunication != None )
	{
//		m_TeamSelection=0;
		m_MenuCommunication.SetStatMenuState(CMS_DisplayForceStatLocked);
		m_MenuCommunication.SetPlayerReadyStatus(False);
	}
}

function ClearReferences ()
{
	if ( m_MenuCommunication != None )
	{
		m_MenuCommunication.ClearLevelReferences();
	}
	DestroyInteractions();
}

function ClientNewLobbyConnection (int iLobbyID, int iGroupID)
{
	GameReplicationInfo.m_iGameSvrGroupID=iGroupID;
	GameReplicationInfo.m_iGameSvrLobbyID=iLobbyID;
	m_GameService.m_bMSClientRouterDisconnect=True;
}

function ClientDeathMessage (string Killer, string Killed, byte bSuicideType)
{
	if ( Level.NetMode == NM_Standalone )
	{
		return;
	}
	if ( myHUD != None )
	{
		if ( bSuicideType == 1 )
		{
//			myHUD.AddTextMessage(Class'R6Pawn'.BuildDeathMessage(Killer,Killed,bSuicideType),Class'LocalMessage');
		}
		else
		{
			if ( bSuicideType != 4 )
			{
				if ( GameReplicationInfo.m_eGameTypeFlag == RGM_CaptureTheEnemyAdvMode )
				{
//					myHUD.AddDeathTextMessage(Killed $ " " $ Localize("MPDeathMessages","PlayerHasBeenShot","ASGameMode") $ " " $ Killer $ " " $ Localize("MPDeathMessages","PlayerSurrender","ASGameMode"),Class'LocalMessage');
				}
				else
				{
//					myHUD.AddDeathTextMessage(Class'R6Pawn'.BuildDeathMessage(Killer,Killed,bSuicideType),Class'LocalMessage');
				}
			}
		}
	}
}

function ClientMPMiscMessage (string szMsgID, string Name, optional string szEndOfMsg)
{
	local string szMsg;

	if ( myHUD != None )
	{
		if ( Name != "" )
		{
			szMsg=Name $ " " $ Localize("MPMiscMessages",szMsgID,"R6GameInfo");
		}
		else
		{
			szMsg=Localize("MPMiscMessages",szMsgID,"R6GameInfo");
		}
		if ( szEndOfMsg != "" )
		{
			szMsg=szMsg $ " " $ szEndOfMsg;
		}
		myHUD.AddTextMessage(szMsg,Class'LocalMessage');
	}
}

function ClientPlayMusic (Sound Sound)
{
	if ( (Sound != None) && (Viewport(Player) != None) )
	{
		PlayMusic(Sound);
	}
}

function ServerReadyToLoadWeaponSound ()
{
	local Controller aController;
	local R6Terrorist aTerrorist;
	local R6Rainbow aRainbow;
	local ZoneInfo aZoneInfo;

	aController=Level.ControllerList;
JL0014:
	if ( aController != None )
	{
		if ( aController.IsA('R6PlayerController') || aController.IsA('R6RainbowAI') )
		{
			aRainbow=R6Rainbow(aController.Pawn);
			if ( aRainbow != None )
			{
				SetWeaponSound(aController.m_PawnRepInfo,aRainbow.m_szPrimaryWeapon,0);
				SetWeaponSound(aController.m_PawnRepInfo,aRainbow.m_szSecondaryWeapon,1);
				SetWeaponSound(aController.m_PawnRepInfo,aRainbow.m_szPrimaryItem,2);
				SetWeaponSound(aController.m_PawnRepInfo,aRainbow.m_szSecondaryItem,3);
			}
		}
		else
		{
			if ( aController.IsA('R6TerroristAI') )
			{
				aTerrorist=R6Terrorist(aController.Pawn);
				if ( aTerrorist != None )
				{
					SetWeaponSound(aController.m_PawnRepInfo,aTerrorist.m_szPrimaryWeapon,0);
					SetWeaponSound(aController.m_PawnRepInfo,aTerrorist.m_szGrenadeWeapon,2);
				}
			}
		}
		aController=aController.nextController;
		goto JL0014;
	}
	if ( Pawn != None )
	{
		aZoneInfo=Pawn.Region.Zone;
	}
	else
	{
		aZoneInfo=Region.Zone;
	}
	ClientFinalizeLoading(aZoneInfo);
}

function SetWeaponSound (R6PawnReplicationInfo PawnRepInfo, string szCurrentWeaponTxt, byte u8CurrentWepon)
{
	local Class<R6EngineWeapon> WeaponClass;
	local string caps_szWeaponName;

	caps_szWeaponName=Caps(szCurrentWeaponTxt);
	if ( (caps_szWeaponName == "R6WEAPONGADGETS.NONE") || (caps_szWeaponName == "PRIMARYMAGS") || (caps_szWeaponName == "SECONDARYMAGS") || (caps_szWeaponName == "LOCKPICKKIT") || (caps_szWeaponName == "DIFFUSEKIT") || (caps_szWeaponName == "ELECTRONICKIT") || (caps_szWeaponName == "GASMASK") || (caps_szWeaponName == "NONE") || (caps_szWeaponName == "") )
	{
		return;
	}
	WeaponClass=Class<R6EngineWeapon>(DynamicLoadObject(szCurrentWeaponTxt,Class'Class'));
	if ( WeaponClass != None )
	{
		ClientSetWeaponSound(PawnRepInfo,WeaponClass,u8CurrentWepon);
	}
}

function ClientSetWeaponSound (R6PawnReplicationInfo PawnRepInfo, Class<R6EngineWeapon> PrimaryWeaponClass, byte u8CurrentWeapon)
{
	if ( PawnRepInfo != None )
	{
		PawnRepInfo.AssignSound(PrimaryWeaponClass,u8CurrentWeapon);
	}
}

function ClientFinalizeLoading (ZoneInfo aZoneInfo)
{
	Level.FinalizeLoading();
	m_CurrentAmbianceObject=aZoneInfo;
	Level.m_bCanStartStartingSound=True;
}

function ServerIndicatesInvalidCDKey (string _szErrorMsgKey)
{
	Player.Console.R6ConnectionFailed(_szErrorMsgKey);
}

event InitInputSystem ()
{
	Super.InitInputSystem();
	InitInteractions();
}

event InitMultiPlayerOptions ()
{
	Super.InitMultiPlayerOptions();
	ToggleRadar(GetGameOptions().ShowRadar);
	AutoAdminLogin(m_szLastAdminPassword);
	ServerSetGender(m_GameOptions.Gender > 0);
	m_GameService=R6AbstractGameService(Player.Console.SetGameServiceLinks(self));
	ServerSetUbiID(m_GameService.m_szUserID);
}

simulated function ClientHideReticule (bool bNewReticuleValue)
{
	m_bHideReticule=bNewReticuleValue;
}

function ClientShowWeapon ()
{
	ShowWeapon();
}

simulated function bool ShouldDrawWeapon ()
{
	if ( (m_pawn != None) &&  !m_pawn.IsAlive() )
	{
		return False;
	}
	if ( (Level.NetMode != 0) && R6GameReplicationInfo(GameReplicationInfo).m_bFFPWeapon )
	{
		return True;
	}
	if (  !m_GameOptions.HUDShowFPWeapon )
	{
		return False;
	}
	return m_bShowFPWeapon || m_bShowCompleteHUD;
}

function ShowWeapon ()
{
	m_bShowFPWeapon=True;
}

function Set1stWeaponDisplay (bool bShowWeapon)
{
	m_bShowFPWeapon=bShowWeapon;
}

simulated event SetMatchResult (string _UserUbiID, int iField, int iValue)
{
	if ( (Level.NetMode == NM_DedicatedServer) || (m_GameService == None) )
	{
		return;
	}
	m_GameService.CallNativeSetMatchResult(_UserUbiID,iField,iValue);
}

function ClientUpdateLadderStat (string _UserUbiID, int _iKillStat, int _iDeathStat, float fPlayTime)
{
	if ( (Level.NetMode == NM_DedicatedServer) || (m_GameService == None) || (PlayerReplicationInfo.m_bClientWillSubmitResult == False) )
	{
		return;
	}
	m_GameService.CallNativeSetMatchResult(_UserUbiID,0,_iKillStat);
	m_GameService.CallNativeSetMatchResult(_UserUbiID,1,_iDeathStat);
	m_GameService.CallNativeSetMatchResult(_UserUbiID,2,0);
	m_GameService.CallNativeSetMatchResult(_UserUbiID,3,0);
	m_GameService.CallNativeSetMatchResult(_UserUbiID,4,fPlayTime);
}

function ClientNotifySendMatchResults ()
{
	local PlayerReplicationInfo aPRI;

	if ( bShowLog )
	{
		Log("Received ClientNotifySendMatchResults for player " $ string(self));
	}
	if ( (Level.NetMode == NM_DedicatedServer) || (m_GameService == None) || (PlayerReplicationInfo.m_bClientWillSubmitResult == False) )
	{
		return;
	}
//	m_GameService.7();
}

function ClientNotifySendStartMatch ()
{
	m_GameService.m_bClientWaitMatchStartReply=True;
	m_GameService.m_bClientWillSubmitResult=True;
}

function ServerEndOfRoundDataSent ()
{
	local Controller _itController;
	local R6PlayerController _playerController;

	m_bEndOfRoundDataReceived=True;
	PlayerReplicationInfo.m_bClientWillSubmitResult=False;
}

simulated event PostBeginPlay ()
{
	Super.PostBeginPlay();
	if ( Role == Role_Authority )
	{
		PlayerReplicationInfo=Spawn(PlayerReplicationInfoClass,self,,vect(0.00,0.00,0.00),rot(0,0,0));
		InitPlayerReplicationInfo();
		bIsPlayer=True;
		m_CommonPlayerVoicesMgr=R6CommonRainbowVoices(R6AbstractGameInfo(Level.Game).GetCommonRainbowPlayerVoicesMgr());
		if ( (Level.NetMode == NM_Standalone) || Level.IsGameTypeCooperative(Level.Game.m_eGameTypeFlag) )
		{
			if ( Level.m_sndMissionComplete == None )
			{
				Level.m_sndMissionComplete=m_sndMissionComplete;
				AddSoundBankName("Voices_Control_MissionSuccess");
			}
			AddSoundBankName("Voices_Control_MissionFailed");
		}
	}
	Level.m_bAllow3DRendering=True;
	SetPlanningMode(False);
	m_GameOptions=Class'Actor'.static.GetGameOptions();
}

simulated function HidePlanningActors ()
{
	local R6AbstractInsertionZone NavPoint;
	local R6AbstractExtractionZone ExtZone;
	local R6ReferenceIcons RefIco;
	local R6IORotatingDoor RotDoor;
	local ER6GameType eCurrentGameType;
	local bool bInTraining;

	eCurrentGameType=GameReplicationInfo.m_eGameTypeFlag;
	foreach AllActors(Class'R6AbstractInsertionZone',NavPoint)
	{
		NavPoint.bHidden=True;
	}
	foreach AllActors(Class'R6AbstractExtractionZone',ExtZone)
	{
		if (  !ExtZone.IsAvailableInGameType(eCurrentGameType) )
		{
			ExtZone.bHidden=True;
		}
	}
	if ( Level.NetMode == NM_Standalone )
	{
		bInTraining=Level.Game.IsA('R6TrainingMgr');
	}
	foreach AllActors(Class'R6ReferenceIcons',RefIco)
	{
		if ( RefIco.IsA('R6DoorIcon') || RefIco.IsA('R6DoorLockedIcon') )
		{
			RefIco.Destroy();
		}
		else
		{
			if (  !RefIco.IsA('R6ObjectiveIcon') &&  !bInTraining && (RefIco.IsA('R6HostageIcon') || RefIco.IsA('R6TerroristIcon')) &&  !(Level.NetMode != 0) && RefIco.IsA('R6HostageIcon') )
			{
				RefIco.bHidden=True;
				if ( (R6ActionPointAbstract(RefIco.Owner) != None) || RefIco.IsA('R6CameraDirection') || RefIco.IsA('R6ArrowIcon') )
				{
					RefIco.Destroy();
				}
			}
		}
	}
	foreach AllActors(Class'R6IORotatingDoor',RotDoor)
	{
//		RotDoor.m_eDisplayFlag=2;
	}
}

simulated event PostNetBeginPlay ()
{
	Super.PostNetBeginPlay();
	if ( Pawn != None )
	{
		Pawn.Controller=self;
		Pawn.PostNetBeginPlay();
	}
}

function ServerSetUbiID (string _szUBIUserID)
{
	if ( PlayerReplicationInfo.m_szUbiUserID == "" )
	{
		PlayerReplicationInfo.m_szUbiUserID=_szUBIUserID;
	}
}

function ServerPlayRecordedMsg (string Msg, EPreRecordedMsgVoices eRainbowVoices)
{
	Level.Game.BroadcastTeam(self,Msg,'PreRecMsg');
	if ( m_TeamManager == None )
	{
		return;
	}
	if ( m_TeamManager.m_PreRecMsgVoicesMgr == None )
	{
		return;
	}
	if ( Pawn.IsAlive() )
	{
//		m_TeamManager.m_PreRecMsgVoicesMgr.PlayRecordedMsgVoices(R6Pawn(Pawn),eRainbowVoices);
	}
}

event Destroyed ()
{
	if ( m_CurrentCircumstantialAction != None )
	{
		m_CurrentCircumstantialAction.aQueryOwner=None;
	}
	ClearReferences();
	if ( Player.Console != None )
	{
		Player.Console.SetGameServiceLinks(None);
	}
	if ( R6AbstractGameInfo(Level.Game) != None )
	{
		R6AbstractGameInfo(Level.Game).RemoveController(self);
	}
	Super.Destroyed();
}

function ServerSetGender (bool bIsFemale)
{
	if ( (PlayerReplicationInfo == None) || (PlayerReplicationInfo.iOperativeID >= 0) )
	{
		return;
	}
	PlayerReplicationInfo.bIsFemale=bIsFemale;
	PlayerReplicationInfo.iOperativeID=Level.Game.MPSelectOperativeFace(bIsFemale);
}

function string GetPrefixToMsg (PlayerReplicationInfo PRI, name MsgType)
{
	local string szMsg;
	local string szLifeState;
	local string szTeam;

	if ( PRI == None )
	{
		return "";
	}
	if ( PRI.bIsSpectator || (PRI.TeamID == 0) || (PRI.TeamID == 4) )
	{
		szLifeState="(" $ Localize("Game","SPECTATOR","R6GameInfo") $ ") ";
	}
	else
	{
		if ( PRI.m_iHealth > 1 )
		{
			szLifeState="(" $ Localize("Game","DEAD","R6GameInfo") $ ") ";
		}
	}
	if ( (MsgType == 'TeamSay') && (PRI.TeamID == PlayerReplicationInfo.TeamID) )
	{
		if ( PlayerReplicationInfo.TeamID == 2 )
		{
			szTeam=" [" $ Localize("Game","GREEN","R6GameInfo") $ "]";
		}
		else
		{
			if ( PlayerReplicationInfo.TeamID == 3 )
			{
				szTeam=" [" $ Localize("Game","RED","R6GameInfo") $ "]";
			}
			else
			{
				szTeam=" [" $ Localize("Game","NOTEAM","R6GameInfo") $ "]";
			}
		}
	}
	szMsg=szLifeState $ "" $ PRI.PlayerName $ " " $ szTeam;
	return szMsg;
}

event TeamMessage (PlayerReplicationInfo PRI, coerce string Msg, name MsgType)
{
	local R6Pawn Sender;
	local string szGroup;
	local string szID;
	local int pos;

	foreach AllActors(Class'R6Pawn',Sender)
	{
		if ( Sender.PlayerReplicationInfo == PRI )
		{
			if ( (Pawn != None) && Pawn.IsFriend(Sender) )
			{
				Sender.m_fLastCommunicationTime=5.00;
			}
		}
		else
		{
		}
	}
	if ( MsgType == 'Line' )
	{
		if ( PRI != PlayerReplicationInfo )
		{
			Level.AddEncodedWritableMapStrip(Msg);
			if ( Player != None )
			{
				Player.Console.Message(Localize("Game","MapUpdatedBy","R6GameInfo") $ " " $ PRI.PlayerName,6.00);
				if ( m_pawn != None )
				{
//					m_pawn.PlaySound(m_sndUpdateWritableMap,3);
				}
			}
		}
	}
	else
	{
		if ( MsgType == 'Icon' )
		{
			Level.AddWritableMapIcon(Msg);
			if ( (PRI != PlayerReplicationInfo) && (Player != None) )
			{
				Player.Console.Message(Localize("Game","MapUpdatedBy","R6GameInfo") $ " " $ PRI.PlayerName,6.00);
				if ( m_pawn != None )
				{
//					m_pawn.PlaySound(m_sndUpdateWritableMap,3);
				}
			}
		}
		else
		{
			if ( (MsgType == 'Say') || (MsgType == 'TeamSay') )
			{
				Msg=GetPrefixToMsg(PRI,MsgType) $ ": " $ Msg;
			}
			else
			{
				if ( MsgType == 'PreRecMsg' )
				{
					pos=InStr(Msg," ");
					szGroup=Left(Msg,pos);
					szID=Right(Msg,Len(Msg) - pos - 1);
					Msg=GetPrefixToMsg(PRI,'TeamSay') $ ": " $ Localize(szGroup,szID,"R6RecMessages");
				}
			}
			if ( Player != None )
			{
				Player.InteractionMaster.Process_Message(Msg,6.00,Player.LocalInteractions);
			}
		}
	}
}

function InitInteractions ()
{
	if ( Player != None )
	{
		if ( m_InteractionMaster == None )
		{
			m_InteractionMaster=Player.InteractionMaster;
		}
		if ( m_InteractionCA == None )
		{
			m_InteractionCA=R6InteractionCircumstantialAction(m_InteractionMaster.AddInteraction("R6Engine.R6InteractionCircumstantialAction",Player));
		}
		if ( m_InteractionInventory == None )
		{
			m_InteractionInventory=R6InteractionInventoryMnu(m_InteractionMaster.AddInteraction("R6Engine.R6InteractionInventoryMnu",Player));
		}
	}
}

function DestroyInteractions ()
{
	if ( m_InteractionMaster != None )
	{
		if ( m_InteractionCA != None )
		{
			m_InteractionMaster.RemoveInteraction(m_InteractionCA);
			m_InteractionCA=None;
		}
		if ( m_InteractionInventory != None )
		{
			m_InteractionMaster.RemoveInteraction(m_InteractionInventory);
			m_InteractionInventory=None;
		}
	}
}

simulated function SetPlayerStartInfo ()
{
}

function ServerSetPlayerStartInfo (string _armorName, string _WeaponName0, string _WeaponName1, string _BulletName0, string _BulletName1, string _WeaponGadgetName0, string _WeaponGadgetName1, string _GadgetName0, string _GadgetName1)
{
	if ( m_PlayerStartInfo == None )
	{
		m_PlayerStartInfo=Spawn(Class'R6RainbowStartInfo');
	}
	m_PlayerStartInfo.m_ArmorName=_armorName;
	m_PlayerStartInfo.m_WeaponName[0]=_WeaponName0;
	m_PlayerStartInfo.m_WeaponName[1]=_WeaponName1;
	m_PlayerStartInfo.m_BulletType[0]=_BulletName0;
	m_PlayerStartInfo.m_BulletType[1]=_BulletName1;
	m_PlayerStartInfo.m_WeaponGadgetName[0]=_WeaponGadgetName0;
	m_PlayerStartInfo.m_WeaponGadgetName[1]=_WeaponGadgetName1;
	m_PlayerStartInfo.m_GadgetName[0]=_GadgetName0;
	m_PlayerStartInfo.m_GadgetName[1]=_GadgetName1;
	if ( bShowLog )
	{
		Log(string(self) @ "SERVERSETPLAYERSTARTINFO weapons are :" $ m_PlayerStartInfo.m_WeaponName[0] $ " and " $ m_PlayerStartInfo.m_WeaponName[1]);
	}
}

event PostRender (Canvas Canvas)
{
	local int iBlurValue;
	local R6IOSelfDetonatingBomb AIt;

	if ( CheatManager != None )
	{
		R6CheatManager(CheatManager).PostRender(Canvas);
	}
	if ( Pawn != None )
	{
		if ( Pawn.EngineWeapon != None )
		{
			Pawn.EngineWeapon.PostRender(Canvas);
		}
		iBlurValue=Pawn.m_fBlurValue + Pawn.m_fDecrementalBlurValue;
		iBlurValue=Clamp(iBlurValue,0,235);
		Canvas.SetMotionBlurIntensity(iBlurValue);
	}
	else
	{
		Canvas.SetMotionBlurIntensity(0);
	}
	if (  !m_bBombSearched )
	{
		foreach AllActors(Class'R6IOSelfDetonatingBomb',AIt)
		{
			m_pSelfDetonatingBomb=AIt;
		}
		if ( (m_pSelfDetonatingBomb != None) && (GameReplicationInfo.m_eGameTypeFlag != 3) && (Level.NetMode != 3) )
		{
			foreach AllActors(Class'R6IOSelfDetonatingBomb',AIt)
			{
				m_pSelfDetonatingBomb=AIt;
				m_pSelfDetonatingBomb.StartTimer();
			}
		}
		if ( m_pSelfDetonatingBomb == None )
		{
			if ( (GameReplicationInfo != None) && (GameReplicationInfo.m_eGameTypeFlag == RGM_CountDownMode) )
			{
				R6AbstractGameInfo(Level.Game).StartTimer();
			}
		}
		m_bBombSearched=True;
	}
	if ( m_pSelfDetonatingBomb != None )
	{
		foreach AllActors(Class'R6IOSelfDetonatingBomb',AIt)
		{
			m_pSelfDetonatingBomb=AIt;
			if ( m_pSelfDetonatingBomb.m_bIsActivated )
			{
				m_pSelfDetonatingBomb.PostRender(Canvas);
			}
			else
			{
			}
		}
		foreach AllActors(Class'R6IOSelfDetonatingBomb',AIt)
		{
			m_pSelfDetonatingBomb=AIt;
			m_pSelfDetonatingBomb.PostRender2(Canvas);
		}
	}
	else
	{
		if ( (GameReplicationInfo != None) && (GameReplicationInfo.m_eGameTypeFlag == RGM_CountDownMode) )
		{
			RenderTimeLeft(Canvas);
		}
	}
}

simulated function RenderTimeLeft (Canvas C)
{
	local float fStrSizeX;
	local float fStrSizeY;
	local int X;
	local int Y;
	local string sTime;
	local int iTimeLeft;

	iTimeLeft=R6AbstractGameInfo(Level.Game).m_fEndingTime - Level.TimeSeconds;
	if ( iTimeLeft < 0 )
	{
		iTimeLeft=0;
	}
	sTime=Localize("Game","TimeLeft","R6GameMode") $ " ";
	sTime=sTime $ ConvertIntTimeToString(iTimeLeft,True);
	C.UseVirtualSize(True,640.00,480.00);
	X=C.HalfClipX;
	Y=C.HalfClipY / 16;
//	C.Font=Font'Rainbow6_14pt';
	if ( iTimeLeft > 20 )
	{
		C.SetDrawColor(255,255,255);
	}
	else
	{
		if ( iTimeLeft > 10 )
		{
			C.SetDrawColor(255,255,0);
		}
		else
		{
			C.SetDrawColor(255,0,0);
		}
	}
	C.StrLen(sTime,fStrSizeX,fStrSizeY);
	C.SetPos(X - fStrSizeX / 2,Y + 24);
	C.DrawText(sTime);
}

simulated function ServerActionKeyPressed ()
{
	SetRequestedCircumstantialAction();
}

simulated function ServerActionKeyReleased ()
{
	SetRequestedCircumstantialAction();
}

function ServerNewPing (int iNewPing)
{
	PlayerReplicationInfo.Ping=iNewPing;
}

event Tick (float fDeltaTime)
{
	if ( (m_pawn != None) && (Pawn != None) )
	{
		UpdateCircumstantialAction();
		UpdateReticule(fDeltaTime);
		if ( m_pawn.bInvulnerableBody )
		{
			if ( Level.TimeSeconds - m_fStartSurrenderTime > 3 )
			{
				m_pawn.bInvulnerableBody=False;
			}
		}
	}
}

simulated event ZoneChange (ZoneInfo NewZone)
{
	local int i;

	if ( (Level.m_WeatherEmitter == None) || (Level.m_WeatherEmitter.Emitters.Length == 0) || (Viewport(Player) == None) )
	{
		return;
	}
	if ( Region.Zone.m_bAlternateEmittersActive )
	{
		i=0;
JL0066:
		if ( i < Region.Zone.m_AlternateWeatherEmitters.Length )
		{
			Region.Zone.m_AlternateWeatherEmitters[i].Emitters[0].m_iPaused=1;
			Region.Zone.m_AlternateWeatherEmitters[i].Emitters[0].AllParticlesDead=False;
			i++;
			goto JL0066;
		}
		Region.Zone.m_bAlternateEmittersActive=False;
	}
	if (  !NewZone.m_bAlternateEmittersActive )
	{
		i=0;
JL011E:
		if ( i < NewZone.m_AlternateWeatherEmitters.Length )
		{
			NewZone.m_AlternateWeatherEmitters[i].Emitters[0].m_iPaused=0;
			NewZone.m_AlternateWeatherEmitters[i].Emitters[0].AllParticlesDead=False;
			i++;
			goto JL011E;
		}
		NewZone.m_bAlternateEmittersActive=True;
	}
}

simulated function UpdateWeatherEmitter ()
{
	local int i;
	local bool bInDoor;
	local Vector vViewDirection;
	local Vector vWeatherEmitterPos;
	local R6WeatherEmitter WE;
	local ZoneInfo WZ;

	if ( Level.m_WeatherEmitter == None )
	{
		return;
	}
	if ( (Level.m_WeatherEmitter.Emitters.Length == 0) || (Viewport(Player) == None) )
	{
		return;
	}
	if ( Level.m_WeatherViewTarget != ViewTarget )
	{
		foreach AllActors(Class'R6WeatherEmitter',WE)
		{
			if ( (WE != Level.m_WeatherEmitter) && (WE.Emitters.Length != 0) )
			{
				WE.Emitters[0].m_iPaused=1;
				WE.Emitters[0].AllParticlesDead=False;
			}
		}
		Level.m_WeatherViewTarget=ViewTarget;
	}
	if ( ViewTarget.Region.Zone.m_bInDoor )
	{
		Level.SetWeatherActive(False);
		WZ=ViewTarget.Region.Zone;
		if ( WZ.m_bAlternateEmittersActive == False )
		{
			i=0;
JL0151:
			if ( i < WZ.m_AlternateWeatherEmitters.Length )
			{
				if ( WZ.m_AlternateWeatherEmitters[i].Emitters.Length != 0 )
				{
					WZ.m_AlternateWeatherEmitters[i].Emitters[0].m_iPaused=0;
					WZ.m_AlternateWeatherEmitters[i].Emitters[0].AllParticlesDead=False;
				}
				i++;
				goto JL0151;
			}
			WZ.m_bAlternateEmittersActive=True;
		}
		return;
	}
	else
	{
		if ( ViewTarget.m_bInWeatherVolume > 0 )
		{
			Level.SetWeatherActive(False);
		}
		else
		{
			if ( ViewTarget.m_bInWeatherVolume == 0 )
			{
				vWeatherEmitterPos=ViewTarget.Location;
				vViewDirection=vect(1.00,0.00,0.00) >> ViewTarget.Rotation;
				vWeatherEmitterPos.X += 256 * vViewDirection.X;
				vWeatherEmitterPos.Y += 256 * vViewDirection.Y;
				vWeatherEmitterPos.Z += 100;
				Level.m_WeatherEmitter.SetLocation(vWeatherEmitterPos);
				Level.SetWeatherActive(True);
			}
		}
	}
}

simulated function R6Shake (float fTime, float fMaxShake, float fMaxShakeTime)
{
	m_fShakeTime=fTime;
	m_fMaxShake=fMaxShake;
	m_fMaxShakeTime=fMaxShakeTime;
	m_fCurrentShake=0.00;
}

function SetEyeLocation (Pawn pViewTarget, float fDeltaTime)
{
	local Coords cEyesPos;

	cEyesPos=pViewTarget.GetBoneCoords('R6 PonyTail1');
	pViewTarget.m_vEyeLocation=cEyesPos.Origin;
	if ( m_fShakeTime > 0 )
	{
		if ( m_fShakeTime > fDeltaTime )
		{
			m_fShakeTime -= fDeltaTime;
			if ( m_fCurrentShake > fDeltaTime )
			{
				m_rHitRotation *= (m_fCurrentShake - fDeltaTime) / m_fCurrentShake;
				m_fCurrentShake -= fDeltaTime;
			}
			else
			{
				m_rHitRotation.Pitch=RandRange( -m_fMaxShake,m_fMaxShake);
				m_rHitRotation.Yaw=RandRange( -m_fMaxShake,m_fMaxShake);
				m_rHitRotation.Roll=RandRange( -m_fMaxShake,m_fMaxShake);
				m_fCurrentShake=RandRange(0.00,m_fMaxShakeTime);
			}
			m_fMaxShake *= (m_fShakeTime - fDeltaTime) / m_fShakeTime;
		}
		else
		{
			m_rHitRotation=rot(0,0,0);
			m_fShakeTime=0.00;
		}
	}
	else
	{
		if ( m_fHitEffectTime > 0 )
		{
			if ( m_fHitEffectTime > fDeltaTime )
			{
				m_rHitRotation *= (m_fHitEffectTime - fDeltaTime) / m_fHitEffectTime;
				m_fHitEffectTime -= fDeltaTime;
			}
			else
			{
				m_rHitRotation=rot(0,0,0);
				m_fHitEffectTime=0.00;
			}
		}
	}
	if (  !pViewTarget.IsAlive() &&  !IsInState('PenaltyBox') )
	{
		SetRotation(OrthoRotation(cEyesPos.XAxis, -cEyesPos.ZAxis,cEyesPos.YAxis));
	}
	AdjustView(fDeltaTime);
}

event PlayerTick (float fDeltaTime)
{
	local int _iPingTime;

	if ( (m_GameService != None) && (Viewport(Player) != None) && (m_GameService.CallNativeProcessIcmpPing(WindowConsole(Player.Console).szStoreIP,_iPingTime) == True) )
	{
		ServerNewPing(_iPingTime);
	}
	if ( m_fBlurReturnTime != 0 )
	{
		m_fTimedBlurValue -= fDeltaTime * m_iShakeBlurIntensity / m_fBlurReturnTime;
		if ( m_fTimedBlurValue <= 0 )
		{
			m_fTimedBlurValue=0.00;
			m_fBlurReturnTime=0.00;
		}
		Blur(m_fTimedBlurValue);
	}
	if ( m_fMilestoneMessageLeft > 0 )
	{
		m_fMilestoneMessageLeft -= fDeltaTime;
		if ( m_fMilestoneMessageLeft < 0 )
		{
			m_fMilestoneMessageLeft=0.00;
			m_bDisplayMilestoneMessage=False;
		}
	}
/*	if ( (GameReplicationInfo != None) && (GameReplicationInfo.m_eCurrectServerState != GameReplicationInfo.3) )
	{
		if ( m_MenuCommunication != None )
		{
			m_MenuCommunication.RefreshReadyButtonStatus();
		}
		m_bReadyToEnterSpectatorMode=False;
	}*/
	if ( m_bAttachCameraToEyes &&  !bBehindView )
	{
		if ( m_pawn != None )
		{
			SetEyeLocation(m_pawn,fDeltaTime);
		}
		else
		{
			if ( (ViewTarget != None) && (ViewTarget != self) )
			{
				SetEyeLocation(R6Pawn(ViewTarget),fDeltaTime);
			}
		}
	}
	if ( (Pawn != None) &&  !bOnlySpectator )
	{
		if ( PlayerIsFiring() )
		{
			Pawn.m_bIsFiringWeapon=bFire;
		}
		else
		{
			Pawn.m_bIsFiringWeapon=0;
		}
	}
	UpdateWeatherEmitter();
	Super.PlayerTick(fDeltaTime);
}

function InitMatineeCamera ()
{
	m_bMatineeRunning=True;
	m_BackupTeamLeader=m_TeamManager.m_TeamLeader;
	m_TeamManager.m_TeamLeader=None;
}

function EndMatineeCamera ()
{
	m_bMatineeRunning=False;
	m_TeamManager.m_TeamLeader=m_BackupTeamLeader;
}

function DisplayMilestoneMessage (int iWhoReached, int iMilestoneNumber)
{
	local R6RainbowTeam aRainbowTeam;
	local ERainbowOtherTeamVoices eVoices;

	aRainbowTeam=R6RainbowTeam(R6AbstractGameInfo(Level.Game).GetRainbowTeam(iWhoReached));
	if (  !aRainbowTeam.m_bLeaderIsAPlayer && (aRainbowTeam.m_iMemberCount > 0) && (aRainbowTeam.m_OtherTeamVoicesMgr != None) )
	{
		switch (iMilestoneNumber)
		{
/*			case 1:
			eVoices=5;
			break;
			case 2:
			eVoices=6;
			break;
			case 3:
			eVoices=7;
			break;
			case 4:
			eVoices=8;
			break;
			case 5:
			eVoices=9;
			break;
			case 6:
			eVoices=10;
			break;
			case 7:
			eVoices=11;
			break;
			case 8:
			eVoices=12;
			break;
			case 9:
			eVoices=13;
			break;
			default: */
		}
//		aRainbowTeam.m_OtherTeamVoicesMgr.PlayRainbowOtherTeamVoices(aRainbowTeam.m_TeamLeader,eVoices);
	}
	else
	{
		m_szMileStoneMessage=Localize("Order","MilestoneReached","R6Menu") $ string(iMilestoneNumber);
		m_bDisplayMilestoneMessage=True;
		m_fMilestoneMessageLeft=m_fMilestoneMessageDuration;
	}
}

simulated event RenderOverlays (Canvas Canvas)
{
	if ( Pawn != None )
	{
		if ( Pawn.EngineWeapon != None )
		{
			Pawn.EngineWeapon.RenderOverlays(Canvas);
		}
	}
	if ( myHUD != None )
	{
		myHUD.RenderOverlays(Canvas);
	}
}

function ReloadWeapon ()
{
	if ( Pawn.EngineWeapon == None )
	{
		return;
	}
	if (  !m_bLockWeaponActions &&  !m_pawn.m_bPostureTransition &&  !Pawn.EngineWeapon.IsA('R6Gadget') /*&& (m_pawn.m_eEquipWeapon == m_pawn.3)*/ )
	{
		ToggleHelmetCameraZoom(True);
		m_pawn.ServerSwitchReloadingWeapon(True);
		ServerReloadWeapon();
		m_pawn.ReloadWeapon();
	}
}

function ServerReloadWeapon ()
{
	if ( (Level.NetMode == NM_Standalone) || (Role == Role_Authority) )
	{
		m_pawn.ServerSwitchReloadingWeapon(True);
	}
}

function int GetFacingDirection ()
{
	local Vector X;
	local Vector Y;
	local Vector Z;
	local Vector Dir;

	GetAxes(Pawn.Rotation,X,Y,Z);
	Dir=Normal(Pawn.Acceleration);
	if ( (Dir Dot X < 0.25) && (Dir != vect(0.00,0.00,0.00)) )
	{
		if ( Dir Dot X < -0.25 )
		{
			return 32768;
		}
		else
		{
			if ( Dir Dot Y > 0 )
			{
				return 16384;
			}
			else
			{
				return 49152;
			}
		}
	}
	return 0;
}

function CalcSmoothedRotation ()
{
	local Rotator rCurrent;
	local int iDesiredYaw;
	local int iDesiredPitch;
	local int iOldYaw;
	local int iOldPitch;
	local int iMaximum;

	iMaximum=100000 * m_fCurrentDeltaTime;
	rCurrent=Rotation;
	iOldPitch=m_iSpectatorPitch;
	iDesiredPitch=Rotation.Pitch;
	if ( iDesiredPitch > 32768 )
	{
		iDesiredPitch -= 65536;
	}
	else
	{
		if ( iDesiredPitch < -32768 )
		{
			iDesiredPitch += 65536;
		}
	}
	if ( iOldPitch > 32768 )
	{
		iOldPitch -= 65536;
	}
	else
	{
		if ( iOldPitch < -32768 )
		{
			iOldPitch += 65536;
		}
	}
	if ( Abs(iDesiredPitch - iOldPitch) < iMaximum )
	{
		m_iSpectatorPitch=iDesiredPitch;
	}
	else
	{
		if ( iDesiredPitch > iOldPitch )
		{
			m_iSpectatorPitch=iOldPitch + iMaximum;
		}
		else
		{
			m_iSpectatorPitch=iOldPitch - iMaximum;
		}
	}
	rCurrent.Pitch=m_iSpectatorPitch;
	iOldYaw=m_iSpectatorYaw & 65535;
	iDesiredYaw=Rotation.Yaw & 65535;
	if ( iDesiredYaw < iOldYaw )
	{
		if ( iOldYaw - iDesiredYaw < 32768 )
		{
			if ( iOldYaw - iDesiredYaw < iMaximum )
			{
				m_iSpectatorYaw=iDesiredYaw;
			}
			else
			{
				m_iSpectatorYaw=iOldYaw - iMaximum;
			}
		}
		else
		{
			iOldYaw -= 65536;
			if ( iDesiredYaw - iOldYaw < iMaximum )
			{
				m_iSpectatorYaw=iDesiredYaw;
			}
			else
			{
				m_iSpectatorYaw=iOldYaw + iMaximum;
			}
		}
	}
	else
	{
		if ( iDesiredYaw - iOldYaw < 32768 )
		{
			if ( iDesiredYaw - iOldYaw < iMaximum )
			{
				m_iSpectatorYaw=iDesiredYaw;
			}
			else
			{
				m_iSpectatorYaw=iOldYaw + iMaximum;
			}
		}
		else
		{
			iDesiredYaw -= 65536;
			if ( iOldYaw - iDesiredYaw < iMaximum )
			{
				m_iSpectatorYaw=iDesiredYaw;
			}
			else
			{
				m_iSpectatorYaw=iOldYaw - iMaximum;
			}
		}
	}
	rCurrent.Yaw=m_iSpectatorYaw;
	SetRotation(rCurrent);
}

function CalcFirstPersonView (out Vector CameraLocation, out Rotator CameraRotation)
{
	local Rotator rAdjust;
	local Rotator rPitchOnly;

	if ( bOnlySpectator )
	{
		if ( R6Pawn(ViewTarget).m_bIsPlayer )
		{
			if ( R6Pawn(ViewTarget).IsAlive() )
			{
				CalcSmoothedRotation();
			}
		}
		CameraRotation=Rotation;
		CameraLocation=ViewTarget.Location + Pawn(ViewTarget).EyePosition();
		return;
	}
	else
	{
		if ( Pawn == None )
		{
			if ( (ViewTarget != None) && (ViewTarget != self) )
			{
				CameraRotation=Rotation;
				CameraLocation=R6Pawn(ViewTarget).m_vEyeLocation;
			}
			return;
		}
	}
	if ( bRotateToDesired )
	{
		CameraRotation=DesiredRotation + Pawn.m_rRotationOffset + m_rHitRotation;
	}
	else
	{
		CameraRotation=Rotation + Pawn.m_rRotationOffset + m_rHitRotation;
	}
	if ( m_bAttachCameraToEyes )
	{
		CameraLocation=Pawn.m_vEyeLocation;
	}
	else
	{
		CameraLocation=CameraLocation + Pawn.EyePosition();
	}
}

function CheckBob (float DeltaTime, float Speed2D, Vector Y)
{
	return;
}

function WeaponBob (float BobDamping, out Rotator BobRotation, out Vector bobOffset)
{
	return;
}

function CalcBehindView (out Vector CameraLocation, out Rotator CameraRotation, float dist)
{
	local Vector View;
	local Vector HitLocation;
	local Vector HitNormal;
	local float ViewDist;

	if ( bOnlySpectator && (ViewTarget != None) )
	{
		if ( R6Pawn(ViewTarget).m_bIsPlayer && bFixedCamera )
		{
			CalcSmoothedRotation();
		}
		CameraRotation=Rotation;
	}
	else
	{
		if ( Pawn != None )
		{
			if ( bRotateToDesired )
			{
				CameraRotation=DesiredRotation + Pawn.m_rRotationOffset;
			}
			else
			{
				CameraRotation=Rotation + Pawn.m_rRotationOffset;
			}
		}
	}
	View=vect(1.00,0.00,0.00) >> CameraRotation;
/*	if ( Trace(HitLocation,HitNormal,CameraLocation - dist * CameraRotation,CameraLocation) != None )
	{
		ViewDist=FMin((CameraLocation - HitLocation) Dot View,dist);
	}
	else
	{
		ViewDist=dist;
	}*/
	CameraLocation -= ViewDist * View;
	m_vCameraLocation=CameraLocation;
	m_rCameraRotation=CameraRotation;
}

function bool DirectionChanged ()
{
	local eStrafeDirection eSDir;

	if ( aForward > 0 )
	{
		if ( aStrafe > 0 )
		{
//			eSDir=1;
		}
		else
		{
//			eSDir=2;
		}
	}
	else
	{
		if ( aStrafe > 0 )
		{
//			eSDir=3;
		}
		else
		{
//			eSDir=4;
		}
	}
	if ( eSDir == m_pawn.m_eStrafeDirection )
	{
		return False;
	}
//	m_pawn.m_eStrafeDirection=eSDir;
	return True;
}

simulated function AdjustViewPitch (out int iPitch)
{
	iPitch=iPitch & 65535;
	if ( (iPitch > 16384) && (iPitch < 49152) )
	{
		if ( aLookUp > 0 )
		{
			iPitch=16384;
		}
		else
		{
			iPitch=49152;
		}
	}
}

simulated function AdjustViewYaw (out int iYaw)
{
	iYaw=iYaw & 65535;
	if ( m_pawn.m_bIsClimbingLadder )
	{
		if ( (iYaw > 10923) && (iYaw < 54613) )
		{
			if ( aTurn > 0 )
			{
				iYaw=10923;
			}
			else
			{
				iYaw=54613;
			}
		}
	}
	if ( iYaw > 32768 )
	{
		iYaw -= 65536;
	}
	else
	{
		if ( iYaw < -32768 )
		{
			iYaw += 65536;
		}
	}
}

function HandleDiagonalStrafing ()
{
	if ( (aForward != 0) && (aStrafe != 0) )
	{
		if ( DirectionChanged() ||  !m_pawn.m_bMovingDiagonally )
		{
			m_pawn.m_bMovingDiagonally=True;
			m_pawn.AdjustPawnForDiagonalStrafing();
		}
	}
	else
	{
		if ( m_pawn.m_bMovingDiagonally )
		{
			m_pawn.ResetDiagonalStrafing();
		}
	}
}

simulated function bool PassedYawLimit (Rotator rRotationOffset)
{
	if ( m_pawn.m_bIsClimbingLadder )
	{
		return False;
	}
	else
	{
		if ( Abs(rRotationOffset.Yaw) > 0 )
		{
			return True;
		}
	}
	return False;
}

event SetCrouchBlend (float fCrouchBlend)
{
	m_pawn.SetCrouchBlend(fCrouchBlend);
	if ( Level.NetMode != 0 )
	{
		ServerSetCrouchBlend(fCrouchBlend);
	}
}

function ServerSetCrouchBlend (float fCrouchBlend)
{
	if ( m_pawn == None )
	{
		return;
	}
	m_pawn.SetCrouchBlend(fCrouchBlend);
}

function SetPeekingInfo (ePeekingMode eMode, float fPeekingRatio, optional bool bPeekLeft)
{
	local byte PackedPeekingRatio;
	local float fNormalizedPeekingRatio;

	if ( m_pawn == None )
	{
		return;
	}
//	m_pawn.SetPeekingInfo(eMode,fPeekingRatio,bPeekLeft);
	if ( Level.NetMode != 0 )
	{
//		fNormalizedPeekingRatio=(fPeekingRatio - m_pawn.0.00) / (m_pawn.2000.00 - m_pawn.0.00) * 255.00;
		PackedPeekingRatio=fNormalizedPeekingRatio;
		if ( bPeekLeft )
		{
			ServerSetPeekingInfoLeft(eMode,PackedPeekingRatio);
		}
		else
		{
			ServerSetPeekingInfoRight(eMode,PackedPeekingRatio);
		}
	}
}

function ServerSetPeekingInfoLeft (ePeekingMode eMode, byte PackedPeekingRatio)
{
	local float fPeekingRatio;

	if ( m_pawn == None )
	{
		return;
	}
	fPeekingRatio=PackedPeekingRatio;
//	fPeekingRatio=fPeekingRatio / 255.00 * (m_pawn.2000.00 - m_pawn.0.00) + m_pawn.0.00;
//	m_pawn.SetPeekingInfo(eMode,fPeekingRatio,True);
}

function ServerSetPeekingInfoRight (ePeekingMode eMode, byte PackedPeekingRatio)
{
	local float fPeekingRatio;

	if ( m_pawn == None )
	{
		return;
	}
	fPeekingRatio=PackedPeekingRatio;
//	fPeekingRatio=fPeekingRatio / 255.00 * (m_pawn.2000.00 - m_pawn.0.00) + m_pawn.0.00;
//	m_pawn.SetPeekingInfo(eMode,fPeekingRatio,False);
}

function ServerSetBipodRotation (float fRotation)
{
	if ( m_pawn != None )
	{
//		m_pawn.m_iRepBipodRotationRatio=fRotation / m_pawn.5600 * 100;
	}
}

function bool PlayerIsFiring ()
{
	if ( Pawn.EngineWeapon == None )
	{
		return False;
	}
	if ( (bFire > 0) && (Pawn.EngineWeapon.NumberOfBulletsLeftInClip() > 0) )
	{
		return True;
	}
	return False;
}

simulated function UpdateRotation (float DeltaTime, float maxPitch)
{
	local Rotator rNewRotation;
	local Rotator rViewRotation;
	local Rotator rRotationOffset;
	local bool bBoneRotationIsDone;
	local float fOffset;
	local float fBipodRotationToAdd;
	local R6AbstractWeapon AWeapon;

	if ( bCheatFlying )
	{
		Super.UpdateRotation(DeltaTime,maxPitch);
		return;
	}
	if ( bInterpolating || (Pawn != None) && Pawn.bInterpolating )
	{
		return;
	}
	if ( m_pawn == None )
	{
		return;
	}
	rRotationOffset=Pawn.m_rRotationOffset;
	if ( m_pawn.m_bPostureTransition )
	{
		aTurn=0.00;
	}
	if ( m_pawn.m_bUsingBipod )
	{
		fBipodRotationToAdd=32.00 * DeltaTime;
		DesiredRotation.Yaw=Rotation.Yaw;
		if ( Pawn.Velocity != vect(0.00,0.00,0.00) )
		{
			fBipodRotationToAdd *= 2000;
			if ( m_pawn.m_fBipodRotation == 0 )
			{
				goto JL01AC;
			}
			if ( m_pawn.m_fBipodRotation > 0 )
			{
				m_pawn.m_fBipodRotation -= fBipodRotationToAdd;
				m_pawn.m_fBipodRotation=FClamp(m_pawn.m_fBipodRotation,0.00,m_pawn.m_fBipodRotation);
			}
			else
			{
				m_pawn.m_fBipodRotation += fBipodRotationToAdd;
				m_pawn.m_fBipodRotation=FClamp(m_pawn.m_fBipodRotation,m_pawn.m_fBipodRotation,0.00);
			}
JL01AC:
		}
		else
		{
			m_pawn.m_fBipodRotation += fBipodRotationToAdd * aTurn;
/*			if ( m_pawn.m_fBipodRotation > m_pawn.5600 )
			{
				m_pawn.m_fBipodRotation=m_pawn.5600.00;
			}
			else
			{
				if ( m_pawn.m_fBipodRotation <  -m_pawn.5600 )
				{
					m_pawn.m_fBipodRotation= -m_pawn.5600;
				}
			}   */
		}
		ServerSetBipodRotation(m_pawn.m_fBipodRotation);
	}
	else
	{
		if ( (m_bSpecialCrouch > 0) &&  !m_pawn.m_bIsProne )
		{
			aTurn=0.00;
			aLookUp=0.00;
		}
	}
	AWeapon=R6AbstractWeapon(Pawn.EngineWeapon);
	rViewRotation=Rotation + rRotationOffset;
	rViewRotation.Yaw += 32.00 * DeltaTime * aTurn;
	if (  !Level.m_bInGamePlanningActive )
	{
		rViewRotation.Pitch += 32.00 * DeltaTime * aLookUp;
	}
	AdjustViewPitch(rViewRotation.Pitch);
	rViewRotation.Roll=0;
	if (  !bBehindView /*&& (m_pawn.m_fPeeking != m_pawn.1000.00)*/ )
	{
		rViewRotation.Roll=m_pawn.GetPeekingRatioNorm(m_pawn.m_fPeeking) * 2049;
	}
	rRotationOffset=rViewRotation - Rotation;
	AdjustViewYaw(rRotationOffset.Yaw);
	if ( bRotateToDesired )
	{
		DesiredRotation.Yaw=DesiredRotation.Yaw & 65535;
		if ( Rotation.Yaw != DesiredRotation.Yaw )
		{
			Pawn.m_rRotationOffset=rRotationOffset;
			return;
		}
	}
	bRotateToDesired=False;
	if ( ((Pawn.Acceleration != vect(0.00,0.00,0.00)) || (aForward != 0) || (aStrafe != 0)) &&  !m_pawn.m_bIsClimbingLadder )
	{
		if ( m_pawn.m_bIsProne )
		{
			rRotationOffset.Yaw=Clamp(rRotationOffset.Yaw, -m_pawn.m_iMaxRotationOffset,m_pawn.m_iMaxRotationOffset);
			if ( m_pawn.m_bUsingBipod )
			{
				if ( (rRotationOffset.Pitch > 5461) && (rRotationOffset.Pitch < 18001) )
				{
					rRotationOffset.Pitch=5461;
				}
				if ( (rRotationOffset.Pitch < 60075) && (rRotationOffset.Pitch > 49000) )
				{
					rRotationOffset.Pitch=60075;
				}
			}
			if ( rRotationOffset.Yaw != 0 )
			{
				DesiredRotation.Yaw=m_pawn.Rotation.Yaw;
				if ( rRotationOffset.Yaw > 0 )
				{
					fOffset=Clamp(rRotationOffset.Yaw,0,6600 * DeltaTime);
				}
				else
				{
					fOffset=Clamp(rRotationOffset.Yaw, -6600 * DeltaTime,0);
				}
				rRotationOffset.Yaw -= fOffset;
				DesiredRotation.Yaw += fOffset;
			}
		}
		else
		{
			rRotationOffset.Yaw=0;
			DesiredRotation.Yaw=rViewRotation.Yaw;
		}
		DesiredRotation.Pitch=0;
		DesiredRotation.Roll=0;
		HandleDiagonalStrafing();
		if ( Rotation.Yaw != DesiredRotation.Yaw )
		{
			SetRotation(DesiredRotation);
			bRotateToDesired=True;
		}
		else
		{
			if (  !bBehindView )
			{
				Pawn.FaceRotation(DesiredRotation,DeltaTime);
			}
		}
		if (  !bBoneRotationIsDone && m_pawn.m_bMovingDiagonally &&  !m_pawn.m_bIsProne )
		{
			if ( (m_pawn.m_eStrafeDirection == 1) || (m_pawn.m_eStrafeDirection == 4) )
			{
				rRotationOffset.Yaw=-6000;
			}
			else
			{
				rRotationOffset.Yaw=6000;
			}
			m_pawn.PawnLook(rRotationOffset,True,True);
			rRotationOffset.Yaw=0;
			bBoneRotationIsDone=True;
		}
		if (  !m_pawn.m_bMovingDiagonally && (PlayerIsFiring() || m_pawn.GunShouldFollowHead()) )
		{
			m_pawn.PawnLook(rRotationOffset,True,True);
			bBoneRotationIsDone=True;
		}
	}
	else
	{
		if ( m_pawn.m_bIsProne )
		{
			rRotationOffset.Yaw=Clamp(rRotationOffset.Yaw, -m_pawn.m_iMaxRotationOffset,m_pawn.m_iMaxRotationOffset);
			if ( m_pawn.m_bUsingBipod )
			{
				if ( (rRotationOffset.Pitch > 5461) && (rRotationOffset.Pitch < 18001) )
				{
					rRotationOffset.Pitch=5461;
				}
				if ( (rRotationOffset.Pitch < 60075) && (rRotationOffset.Pitch > 49000) )
				{
					rRotationOffset.Pitch=60075;
				}
			}
			if ( PlayerIsFiring() )
			{
				m_pawn.PawnLook(rRotationOffset,True,False);
				bBoneRotationIsDone=True;
			}
		}
		else
		{
			if ( (aForward == 0) && (aStrafe == 0) && m_pawn.m_bMovingDiagonally )
			{
				HandleDiagonalStrafing();
			}
			else
			{
				if ( PassedYawLimit(rRotationOffset) || (rRotationOffset.Yaw != 0) && m_pawn.IsPeeking() )
				{
					rNewRotation=Rotation + rRotationOffset;
					rNewRotation.Pitch=0;
					rNewRotation.Roll=0;
					SetRotation(rNewRotation);
					DesiredRotation=rViewRotation;
					DesiredRotation.Pitch=0;
					DesiredRotation.Roll=0;
					bRotateToDesired=True;
					rRotationOffset.Yaw=0;
					m_pawn.PawnLook(rRotationOffset,);
					bBoneRotationIsDone=True;
				}
			}
		}
	}
	if ( m_bShakeActive == True )
	{
		R6ViewShake(DeltaTime,rRotationOffset);
	}
	if (  !bBoneRotationIsDone )
	{
		m_pawn.PawnLook(rRotationOffset,,True);
	}
	ViewFlash(DeltaTime);
	rNewRotation=rViewRotation;
	rNewRotation.Roll=0;
	if (  !bRotateToDesired && (Pawn != None) && ( !bFreeCamera ||  !bBehindView) )
	{
		if ( rRotationOffset.Yaw == 0.00 )
		{
			Pawn.FaceRotation(rNewRotation,DeltaTime);
		}
	}
	Pawn.m_rRotationOffset=rRotationOffset;
}

function ResetFluidPeeking ()
{
	if ( m_pawn.m_ePeekingMode == 2 )
	{
//		SetPeekingInfo(PEEK_none,m_pawn.1000.00);
		SetCrouchBlend(0.00);
	}
}

function HandleFluidMovement (float DeltaTime)
{
	local float fCrouchRate;
	local float fPeekingRate;
	local float fBlendAlpha;

	if ( m_pawn == None )
	{
		return;
	}
	if ( (m_pawn.m_ePeekingMode == 1) ||  !m_pawn.CanPeek() )
	{
		return;
	}
	if ( (m_bSpecialCrouch > 0) &&  !m_pawn.m_bIsProne )
	{
		if ( m_pawn.m_ePeekingMode == 0 )
		{
			if ( Pawn.bIsCrouched )
			{
				SetCrouchBlend(1.00);
			}
			else
			{
				SetCrouchBlend(0.00);
			}
			if ( Pawn.bIsCrouched )
			{
				bDuck=0;
			}
		}
		fCrouchRate=m_pawn.m_fCrouchBlendRate;
		fCrouchRate -= aMouseY * DeltaTime / m_iFluidMovementSpeed;
		fCrouchRate=FClamp(fCrouchRate,0.00,1.00);
		fPeekingRate=m_pawn.GetPeekingRatioNorm(m_pawn.m_fPeeking);
		fPeekingRate += aMouseX * DeltaTime / m_iFluidMovementSpeed;
		fPeekingRate=FClamp(fPeekingRate,-1.00,1.00);
//		fPeekingRate *= m_pawn.1000.00;
//		fPeekingRate += m_pawn.1000.00;
//		fPeekingRate=FClamp(fPeekingRate,m_pawn.0.00,m_pawn.2000.00);
		SetPeekingInfo(PEEK_fluid,fPeekingRate);
		SetCrouchBlend(fCrouchRate);
	}
}

exec function ToggleTeamHold ()
{
	if ( m_TeamManager == None )
	{
		return;
	}
	if ( m_TeamManager.m_iMemberCount == 1 )
	{
		return;
	}
	if ( bOnlySpectator || bCheatFlying )
	{
		return;
	}
	if ( m_TeamManager.m_bTeamIsHoldingPosition &&  !m_TeamManager.m_Team[1].Controller.IsInState('FollowLeader') )
	{
		m_TeamManager.InstructPlayerTeamToFollowLead();
	}
	else
	{
		m_TeamManager.InstructPlayerTeamToHoldPosition();
	}
}

exec function ToggleAllTeamsHold ()
{
	local R6RainbowTeam AITeam;

	ToggleTeamHold();
	if ( m_bAllTeamsHold )
	{
		m_bAllTeamsHold=False;
		if ( R6AbstractGameInfo(Level.Game) != None )
		{
			R6AbstractGameInfo(Level.Game).InstructAllTeamsToFollowPlanning();
		}
	}
	else
	{
		m_bAllTeamsHold=True;
		if ( R6AbstractGameInfo(Level.Game) != None )
		{
			R6AbstractGameInfo(Level.Game).InstructAllTeamsToHoldPosition();
		}
	}
}

exec function ToggleSniperControl ()
{
	local R6RainbowTeam aRainbowTeam;
	local int i;
	local int iNbTeam;

	if ( Level.NetMode == NM_Standalone )
	{
		i=0;
JL0020:
		if ( i < 3 )
		{
			aRainbowTeam=R6RainbowTeam(R6AbstractGameInfo(Level.Game).GetRainbowTeam(i));
			if ( (aRainbowTeam != None) && (aRainbowTeam.m_iMemberCount > 0) )
			{
				aRainbowTeam.m_bSniperHold= !aRainbowTeam.m_bSniperHold;
				iNbTeam++;
			}
			i++;
			goto JL0020;
		}
		if ( iNbTeam > 1 )
		{
			m_TeamManager.PlaySniperOrder();
		}
	}
}

exec function TeamsStatus ()
{
	local R6RainbowTeam aRainbowTeam[3];
	local int i;
	local int iNbTeam;

	if ( Level.NetMode == NM_Standalone )
	{
		i=0;
JL0020:
		if ( i < 3 )
		{
			aRainbowTeam[i]=R6RainbowTeam(R6AbstractGameInfo(Level.Game).GetRainbowTeam(i));
			if ( (aRainbowTeam[i] != None) && (aRainbowTeam[i].m_iMemberCount > 0) )
			{
				iNbTeam++;
			}
			i++;
			goto JL0020;
		}
		if ( iNbTeam > 1 )
		{
			m_TeamManager.PlaySoundTeamStatusReport();
			i=0;
JL00BE:
			if ( i < 3 )
			{
				if ( (aRainbowTeam[i] != None) && (m_TeamManager != aRainbowTeam[i]) )
				{
					aRainbowTeam[i].PlaySoundTeamStatusReport();
				}
				i++;
				goto JL00BE;
			}
		}
	}
}

exec function GoCodeAlpha ()
{
	if ( Level.NetMode == NM_Standalone )
	{
//		ServerSendGoCode(0);
	}
}

exec function GoCodeBravo ()
{
	if ( Level.NetMode == NM_Standalone )
	{
//		ServerSendGoCode(1);
	}
}

exec function GoCodeCharlie ()
{
	if ( Level.NetMode == NM_Standalone )
	{
//		ServerSendGoCode(2);
	}
}

exec function GoCodeZulu ()
{
//	ServerSendGoCode(3);
}

function ServerSendGoCode (EGoCode eGo)
{
	local R6RainbowTeam aRainbowTeam;
	local int i;

	m_TeamManager.PlayGoCode(eGo);
	Player.Console.SendGoCode(eGo);
	if ( eGo == 3 )
	{
		if ( Level.NetMode == NM_Standalone )
		{
			i=0;
JL0061:
			if ( i < 3 )
			{
				aRainbowTeam=R6RainbowTeam(R6AbstractGameInfo(Level.Game).GetRainbowTeam(i));
				if ( aRainbowTeam != None )
				{
					aRainbowTeam.ReceivedZuluGoCode();
				}
				i++;
				goto JL0061;
			}
		}
		else
		{
			if ( m_TeamManager != None )
			{
				m_TeamManager.ReceivedZuluGoCode();
			}
		}
	}
}

exec function SkipDestination ()
{
	if ( bOnlySpectator == False )
	{
		m_pawn.GetTeamMgr().m_TeamPlanning.SkipCurrentDestination();
	}
}

exec function NextTeam ()
{
	ChangeTeams(True);
}

exec function PreviousTeam ()
{
	ChangeTeams(False);
}

exec function RegroupOnMe ()
{
	if ( m_TeamManager == None )
	{
		return;
	}
	if ( bOnlySpectator || bCheatFlying )
	{
		return;
	}
	if (  !m_TeamManager.m_Team[0].IsAlive() )
	{
		if ( m_TeamManager.m_iMemberCount > 0 )
		{
			if ( Level.NetMode != 0 )
			{
				ClientShowWeapon();
			}
			m_TeamManager.SwitchPlayerControlToNextMember();
		}
		else
		{
			ChangeTeams(True);
		}
	}
	else
	{
		if (  !m_TeamManager.m_bTeamIsClimbingLadder )
		{
			m_TeamManager.InstructPlayerTeamToFollowLead();
		}
	}
}

exec function NextMember ()
{
	if ( m_bCanChangeMember == True )
	{
		Pawn.EngineWeapon.StopFire(False);
		ServerNextMember();
		if ( Level.NetMode != 0 )
		{
			m_bCanChangeMember=False;
			SetTimer(1.00,False);
		}
	}
}

exec function PreviousMember ()
{
	if ( m_bCanChangeMember == True )
	{
		Pawn.EngineWeapon.StopFire(False);
		ServerPreviousMember();
		if ( Level.NetMode != 0 )
		{
			m_bCanChangeMember=False;
			SetTimer(1.00,False);
		}
	}
}

function Timer ()
{
	m_bCanChangeMember=True;
}

function ChangeOperative (int iTeamId, int iOperativeID)
{
	ServerChangeOperative(iTeamId,iOperativeID);
}

function ServerChangeOperative (int iTeamId, int iOperativeID)
{
	R6AbstractGameInfo(Level.Game).ChangeOperatives(self,iTeamId,iOperativeID);
}

exec function GraduallyOpenDoor ()
{
	if ( m_pawn == None )
	{
		return;
	}
	if (  !m_pawn.m_bIsProne &&  !m_pawn.m_bChangingWeapon &&  !m_pawn.m_bReloadingWeapon &&  !Level.m_bInGamePlanningActive )
	{
		ServerGraduallyOpenDoor(m_bSpeedUpDoor);
	}
}

exec function GraduallyCloseDoor ()
{
	if ( m_pawn == None )
	{
		return;
	}
	if (  !m_pawn.m_bIsProne &&  !m_pawn.m_bChangingWeapon &&  !m_pawn.m_bReloadingWeapon &&  !Level.m_bInGamePlanningActive )
	{
		ServerGraduallyCloseDoor(m_bSpeedUpDoor);
	}
}

exec function RaisePosture ()
{
	if ( m_pawn == None )
	{
		return;
	}
	if ( m_bSpecialCrouch > 0 )
	{
		return;
	}
	if ( m_pawn.m_bPostureTransition &&  !m_pawn.m_bIsLanding || m_pawn.m_bIsProne && (m_pawn.EngineWeapon != None) && R6AbstractWeapon(m_pawn.EngineWeapon).GotBipod() && m_bLockWeaponActions || m_pawn.m_bIsProne && m_pawn.m_bChangingWeapon )
	{
		return;
	}
	if ( m_pawn.m_bIsProne )
	{
		aForward=0.00;
		aStrafe=0.00;
		aTurn=0.00;
		Pawn.Acceleration=vect(0.00,0.00,0.00);
	}
	if ( m_pawn.m_ePeekingMode == 2 )
	{
		if (  !m_pawn.AdjustFluidCollisionCylinder(0.00,True) )
		{
			return;
		}
		m_pawn.AdjustFluidCollisionCylinder(0.00);
		ResetFluidPeeking();
	}
	if ( m_bCrawl )
	{
		m_bCrawl=False;
		bDuck=1;
		if ( m_pawn.m_ePeekingMode == 1 )
		{
//			SetPeekingInfo(PEEK_none,m_pawn.1000.00);
		}
	}
	else
	{
		if ( bDuck == 1 )
		{
			bDuck=0;
			R6Pawn(Pawn).CrouchToStand();
		}
	}
}

exec function LowerPosture ()
{
	if ( m_pawn == None )
	{
		return;
	}
	if ( m_bSpecialCrouch > 0 )
	{
		return;
	}
	if ( (bDuck == 1) && (m_pawn.EngineWeapon != None) && R6AbstractWeapon(m_pawn.EngineWeapon).GotBipod() && m_bLockWeaponActions )
	{
		return;
	}
	if ( m_pawn.m_ePeekingMode == 2 )
	{
		if ( bDuck == 0 )
		{
			m_pawn.AdjustFluidCollisionCylinder(0.96);
		}
		ResetFluidPeeking();
	}
	if ( bDuck == 0 )
	{
		bDuck=1;
		R6Pawn(Pawn).StandToCrouch();
	}
	else
	{
		if (  !m_bCrawl )
		{
			if ( m_pawn.m_ePeekingMode == 1 )
			{
//				SetPeekingInfo(PEEK_none,m_pawn.1000.00);
			}
			m_bCrawl=True;
		}
	}
}

exec function Zoom ()
{
	ToggleHelmetCameraZoom();
}

exec function ToggleAutoAim ()
{
	if ( Level.NetMode == NM_Standalone )
	{
		m_wAutoAim++;
		if ( m_wAutoAim > 3 )
		{
			m_wAutoAim=0;
		}
		ClientGameMsg("","","AutoAim" $ string(m_wAutoAim));
		Class'Actor'.static.GetGameOptions().AutoTargetSlider=m_wAutoAim;
	}
	else
	{
		m_wAutoAim=0;
	}
}

exec function ChangeRateOfFire ()
{
	if ( Pawn.EngineWeapon != None )
	{
		Pawn.EngineWeapon.SetNextRateOfFire();
	}
}

exec function PrimaryWeapon ()
{
	SwitchWeapon(1);
}

exec function SecondaryWeapon ()
{
	SwitchWeapon(2);
}

exec function GadgetOne ()
{
	SwitchWeapon(3);
}

exec function GadgetTwo ()
{
	SwitchWeapon(4);
}

exec function TeamMovementMode ()
{
	if ( m_TeamManager == None )
	{
		return;
	}
	switch (m_TeamManager.m_eMovementSpeed)
	{
/*		case 0:
		m_TeamManager.m_eMovementSpeed=1;
		break;
		case 1:
		m_TeamManager.m_eMovementSpeed=2;
		break;
		case 2:
		m_TeamManager.m_eMovementSpeed=0;
		break;
		default:              */
	}
}

exec function RulesOfEngagement ()
{
	if ( m_TeamManager == None )
	{
		return;
	}
	switch (m_TeamManager.m_eMovementMode)
	{
/*		case 0:
		m_TeamManager.m_eMovementMode=1;
		break;
		case 1:
		m_TeamManager.m_eMovementMode=2;
		break;
		case 2:
		m_TeamManager.m_eMovementMode=0;
		break;
		default:    */
	}
}

function ResetSpecialCrouch ()
{
	if ( m_pawn.m_ePeekingMode != 2 )
	{
		return;
	}
	if ( m_pawn.m_fCrouchBlendRate >= 0.50 )
	{
		bDuck=1;
	}
	else
	{
		if ( m_pawn.AdjustFluidCollisionCylinder(0.00,True) )
		{
			bDuck=0;
		}
		else
		{
			bDuck=1;
		}
	}
	if ( bDuck == 1 )
	{
		m_pawn.AdjustFluidCollisionCylinder(0.96);
	}
	else
	{
		m_pawn.AdjustFluidCollisionCylinder(0.00);
	}
	ResetFluidPeeking();
}

exec function PlayFiring ()
{
	if ( (Pawn != None) && (GameReplicationInfo.m_bGameOverRep == False) )
	{
		Pawn.EngineWeapon.Fire(0.00);
	}
}

exec function PlayAltFiring ()
{
	if ( Pawn.EngineWeapon != None )
	{
		Pawn.EngineWeapon.AltFire(0.00);
	}
}

exec function CycleHUDLayer ()
{
	R6AbstractHUD(myHUD).CycleHUDLayer();
}

exec function ToggleHelmet ()
{
	R6AbstractHUD(myHUD).ToggleHelmet();
}

function ChangeTeams (bool bNextTeam)
{
	Pawn.EngineWeapon.StopFire(False);
	ServerChangeTeams(bNextTeam);
}

function ServerChangeTeams (bool bNextTeam)
{
	R6AbstractGameInfo(Level.Game).ChangeTeams(self,bNextTeam);
}

function ServerNextMember ()
{
	if ( m_TeamManager == None )
	{
		return;
	}
	m_TeamManager.SwitchPlayerControlToNextMember();
}

function ServerPreviousMember ()
{
	if ( m_TeamManager == None )
	{
		return;
	}
	m_TeamManager.SwitchPlayerControlToPreviousMember();
}

function UpdatePlayerPostureAfterSwitch ()
{
	if ( Pawn.m_bIsProne )
	{
		m_bCrawl=True;
		bDuck=1;
	}
	else
	{
		if ( Pawn.bIsCrouched )
		{
			bDuck=1;
			m_bCrawl=False;
		}
		else
		{
			bDuck=0;
			m_bCrawl=False;
		}
	}
}

function bool PlayerIsInFrontOfDoubleDoors ()
{
	if ( (m_pawn.m_Door != None) && (m_pawn.m_Door2 != None) )
	{
		return True;
	}
	return False;
}

function bool PlayerLookingAtFirstDoor ()
{
	local Vector vLookDir;
	local Vector vCenter;
	local Vector vCutOff;
	local Vector vResult;
	local R6Door rightDoor;
	local R6Door leftDoor;
	local Vector vDoor1;
	local Vector vDoor2;

	vDoor1=Normal(m_pawn.m_Door.m_RotatingDoor.m_vCenterOfDoor - Pawn.Location + Pawn.EyePosition());
	vDoor2=Normal(m_pawn.m_Door2.m_RotatingDoor.m_vCenterOfDoor - Pawn.Location + Pawn.EyePosition());
	vResult=vDoor1 Cross vDoor2;
	if ( vResult.Z > 0 )
	{
		rightDoor=m_pawn.m_Door;
		leftDoor=m_pawn.m_Door2;
	}
	else
	{
		rightDoor=m_pawn.m_Door2;
		leftDoor=m_pawn.m_Door;
	}
	vLookDir=vector(Pawn.GetViewRotation());
	vCenter=(leftDoor.m_RotatingDoor.m_vCenterOfDoor + rightDoor.m_RotatingDoor.m_vCenterOfDoor) / 2;
	vCutOff=Normal(vCenter - Pawn.Location + Pawn.EyePosition());
	vResult=vCutOff Cross vLookDir;
	if ( vResult.Z > 0 )
	{
		if ( leftDoor == m_pawn.m_Door )
		{
			return True;
		}
		else
		{
			return False;
		}
	}
	else
	{
		if ( rightDoor == m_pawn.m_Door )
		{
			return True;
		}
		else
		{
			return False;
		}
	}
}

function bool GraduallyControlDoor (out R6Door aDoor)
{
	local bool bIsLookingAtFirstDoor;

	bIsLookingAtFirstDoor=True;
	if ( m_pawn.m_Door == None )
	{
		return False;
	}
	if ( m_pawn.m_Door.m_RotatingDoor == None )
	{
		return False;
	}
	if ( m_pawn.m_Door.m_RotatingDoor.m_bIsDoorLocked )
	{
		return False;
	}
	if ( PlayerIsInFrontOfDoubleDoors() )
	{
		if ( m_CurrentCircumstantialAction.aQueryTarget == m_pawn.m_Door.m_RotatingDoor )
		{
			bIsLookingAtFirstDoor=True;
		}
		else
		{
			if ( m_CurrentCircumstantialAction.aQueryTarget == m_pawn.m_Door2.m_RotatingDoor )
			{
				bIsLookingAtFirstDoor=False;
			}
			else
			{
				bIsLookingAtFirstDoor=PlayerLookingAtFirstDoor();
			}
		}
	}
	if ( LastDoorUpdateTime == 0 )
	{
		LastDoorUpdateTime=Level.TimeSeconds;
	}
	else
	{
		if ( Level.TimeSeconds - LastDoorUpdateTime >= 0.50 )
		{
			if ( bIsLookingAtFirstDoor )
			{
				aDoor=m_pawn.m_Door;
			}
			else
			{
				aDoor=m_pawn.m_Door2;
			}
			return True;
		}
	}
	return False;
}

function ServerGraduallyOpenDoor (byte bSpeedUpDoor)
{
	local int speed;
	local R6Door aDoor;
	local bool bStatus;

	bStatus=GraduallyControlDoor(aDoor);
	if (  !bStatus )
	{
		return;
	}
	speed=m_iDoorSpeed;
	if ( bSpeedUpDoor > 0 )
	{
		speed=m_iFastDoorSpeed;
	}
	aDoor.m_RotatingDoor.updateAction(speed,Pawn);
}

function ServerGraduallyCloseDoor (byte bSpeedUpDoor)
{
	local int speed;
	local R6Door aDoor;
	local bool bStatus;

	bStatus=GraduallyControlDoor(aDoor);
	if (  !bStatus )
	{
		return;
	}
	speed= -m_iDoorSpeed;
	if ( bSpeedUpDoor > 0 )
	{
		speed= -m_iFastDoorSpeed;
	}
	aDoor.m_RotatingDoor.updateAction(speed,Pawn);
}

function UpdatePlayerPeeking ()
{
	local bool bPeekingLeft;
	local bool bPeekingRight;

	if ( m_pawn.m_bIsProne && (Pawn.Acceleration != vect(0.00,0.00,0.00)) )
	{
		if ( m_pawn.m_ePeekingMode != 0 )
		{
//			SetPeekingInfo(PEEK_none,m_pawn.1000.00);
		}
		return;
	}
	if ( (m_bPeekLeft == 1) && (m_bOldPeekLeft == 1) || (m_bPeekRight == 1) && (m_bOldPeekRight == 1) )
	{
		if (  !m_pawn.IsPeeking() &&  !m_pawn.m_bPostureTransition )
		{
			if ( m_pawn.bIsCrouched && m_pawn.bWantsToCrouch && (m_bCrawl == False) || m_pawn.m_bWantsToProne && m_pawn.m_bIsProne )
			{
				m_bOldPeekRight=0;
				m_bOldPeekLeft=0;
			}
		}
	}
	if ( (m_bOldPeekLeft != m_bPeekLeft) || (m_bOldPeekRight != m_bPeekRight) )
	{
		if ( m_pawn.m_bPostureTransition )
		{
			return;
		}
		CommonUpdatePeeking(m_bPeekLeft,m_bPeekRight);
		if ( Level.NetMode != 0 )
		{
			bPeekingLeft=m_bPeekLeft != 0;
			bPeekingRight=m_bPeekRight != 0;
			ServerUpdatePeeking(bPeekingLeft,bPeekingRight);
		}
	}
	m_bOldPeekLeft=m_bPeekLeft;
	m_bOldPeekRight=m_bPeekRight;
}

function CommonUpdatePeeking (byte bPeekLeftButton, byte bPeekRightButton)
{
	if ( m_pawn.m_ePeekingMode == 1 )
	{
		if ( m_pawn.IsPeekingLeft() )
		{
			if ( bPeekLeftButton == 0 )
			{
				if ( bPeekRightButton == 1 )
				{
//					SetPeekingInfo(PEEK_full,m_pawn.2000.00);
				}
				else
				{
//					SetPeekingInfo(PEEK_none,m_pawn.1000.00);
				}
			}
		}
		else
		{
			if ( bPeekRightButton == 0 )
			{
				if ( bPeekLeftButton == 1 )
				{
//					SetPeekingInfo(PEEK_full,m_pawn.0.00,True);
				}
				else
				{
//					SetPeekingInfo(PEEK_none,m_pawn.1000.00);
				}
			}
		}
	}
	else
	{
		if (  !(m_pawn.m_ePeekingMode == 1) && m_pawn.CanPeek() )
		{
			if ( bPeekLeftButton > 0 )
			{
				ResetSpecialCrouch();
//				SetPeekingInfo(PEEK_full,m_pawn.0.00,True);
			}
			else
			{
				if ( bPeekRightButton > 0 )
				{
					ResetSpecialCrouch();
//					SetPeekingInfo(PEEK_full,m_pawn.2000.00,False);
				}
			}
		}
	}
}

function ServerUpdatePeeking (bool bPeekLeft, bool bPeekRight)
{
	local byte PeekLeftButton;
	local byte PeekRightButton;

	if ( bPeekLeft )
	{
		PeekLeftButton=1;
	}
	if ( bPeekRight )
	{
		PeekRightButton=1;
	}
	CommonUpdatePeeking(PeekLeftButton,PeekRightButton);
}

function HandleWalking ()
{
	if ( bOnlySpectator )
	{
		return;
	}
	if ( Pawn != None )
	{
		Pawn.bIsWalking=(bRun == 0) || (m_pawn.m_eHealth != 0);
	}
}

state PlayerFlying
{
	function BeginState ()
	{
		if ( Pawn != None )
		{
			SetRotation(Rotation + Pawn.m_rRotationOffset);
			Pawn.m_rRotationOffset=rot(0,0,0);
			m_pawn.PawnLook(Pawn.m_rRotationOffset,,True);
			Pawn.SetPhysics(PHYS_Flying);
		}
	}

}

state GameEnded
{
}

state PenaltyBox
{
	ignores  SwitchWeapon, KilledBy;

	function BeginState ()
	{
		m_pawn.m_eHealth=HEALTH_Incapacitated;
	}

	function PlayFiring ()
	{
	}

	function AltFiring ()
	{
	}

	function PlayerMove (float DeltaTime)
	{
	}

	function ServerReStartPlayer ()
	{
	}

	exec function ToggleHelmetCameraZoom (optional bool bTurnOff)
	{
	}

	exec function Fire (optional float f)
	{
	}

Begin:
	if ( R6AbstractGameInfo(Level.Game) != None )
	{
		if ( m_ePenaltyForKillingAPawn == 3 )
		{
			ClientGameMsg("","","PenaltyYouKilledAHostage");
		}
		else
		{
			ClientGameMsg("","","PenaltyYouKilledATeamMate");
		}
		Sleep(1.00);
		R6AbstractGameInfo(Level.Game).ApplyTeamKillerPenalty(Pawn);
	}
}

function TKPopUpBox (string _KillerName)
{
	m_MenuCommunication.TKPopUpBox(_KillerName);
}

function ServerTKPopUpDone (bool _bApplyTeamKillerPenalty)
{
	if ( (Level.NetMode == NM_Standalone) || (Level.NetMode == NM_Client) )
	{
		return;
	}
	m_bRequestTKPopUp=False;
	if ( (_bApplyTeamKillerPenalty == False) || (m_TeamKiller == None) )
	{
		return;
	}
	m_TeamKiller.m_bHasAPenalty=True;
//	m_TeamKiller.m_ePenaltyForKillingAPawn=1;
	m_TeamKiller=None;
}

state PlayerWalking
{
	function PlayerMove (float DeltaTime)
	{
		if ( WindowConsole(Player.Console).ConsoleState == 'UWindow' )
		{
			if ( Role < Role_Authority )
			{
				ReplicateMove(DeltaTime,vect(0.00,0.00,0.00),DCLICK_None,rot(0,0,0));
			}
			else
			{
				ProcessMove(DeltaTime,vect(0.00,0.00,0.00),DCLICK_None,rot(0,0,0));
			}
		}
		else
		{
			Super.PlayerMove(DeltaTime);
		}
	}

	function ProcessMove (float DeltaTime, Vector NewAccel, EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
	{
		if ( (Pawn == None) || (m_pawn == None) )
		{
			return;
		}
		Pawn.Acceleration=NewAccel;
		if ( bPressedJump )
		{
			Pawn.DoJump(bUpdating);
		}
		if ( Pawn.Physics != 2 )
		{
			if ( m_pawn.m_bPostureTransition &&  !m_pawn.m_bIsLanding )
			{
				aForward=0.00;
				aStrafe=0.00;
				aTurn=0.00;
				Pawn.Acceleration=vect(0.00,0.00,0.00);
			}
			if ( DoubleClickMove == 3 )
			{
				m_fPostFluidMovementDelay=0.10;
				ResetSpecialCrouch();
			}
			else
			{
				if ( m_fPostFluidMovementDelay <= 0 )
				{
					m_fPostFluidMovementDelay=0.00;
					HandleFluidMovement(DeltaTime);
				}
				else
				{
					m_fPostFluidMovementDelay -= DeltaTime;
				}
			}
			if ( bDuck == 0 )
			{
				Pawn.ShouldCrouch(False);
			}
			else
			{
				if ( Pawn.bCanCrouch )
				{
					Pawn.ShouldCrouch(True);
				}
			}
			if ( m_bCrawl )
			{
				Pawn.m_bWantsToProne=True;
			}
			else
			{
				Pawn.m_bWantsToProne=False;
			}
			UpdatePlayerPeeking();
			if ( Pawn.m_bIsLanding )
			{
				Pawn.Acceleration=vect(0.00,0.00,0.00);
			}
		}
		if ( (m_bReloading == 1) &&  !R6GameReplicationInfo(GameReplicationInfo).m_bGameOverRep )
		{
			ReloadWeapon();
		}
	}

	function BeginState ()
	{
		m_pawn=R6Rainbow(Pawn);
		if ( Pawn == None )
		{
			GotoState('BaseSpectating');
			return;
		}
		if ( Pawn.Mesh == None )
		{
			Pawn.SetMesh();
		}
//		DoubleClickDir=0;
		bPressedJump=False;
		if ( (Pawn.Physics != 2) && (Pawn.Physics != 14) )
		{
			Pawn.SetPhysics(PHYS_Walking);
		}
		GroundPitch=0;
		if ( m_GameOptions.HUDShowFPWeapon )
		{
			ShowWeapon();
		}
	}

	function EndState ()
	{
		GroundPitch=0;
	}

}

function ServerExecFire (optional float f)
{
	Fire(f);
}

exec function LogSpecialValues ()
{
}

function InitializeMenuCom ()
{
	if ( (GameReplicationInfo == None) || (m_MenuCommunication != None) && (m_MenuCommunication.m_GameRepInfo != None) )
	{
		return;
	}
	if ( Viewport(Player) != None )
	{
		m_MenuCommunication=Player.Console.Master.m_MenuCommunication;
		if ( m_MenuCommunication == None )
		{
			return;
		}
		m_MenuCommunication.m_GameRepInfo=GameReplicationInfo;
		m_MenuCommunication.m_PlayerController=self;
		ServerRequestSkins();
		GameReplicationInfo.ControllerStarted(m_MenuCommunication);
		m_MenuCommunication.SelectTeam();
		if ( bOnlySpectator )
		{
//			m_MenuCommunication.PlayerSelection(4);
		}
		if ( (Level.NetMode != 0) && (Level.NetMode != 1) )
		{
			if ( m_TeamSelection != 0 )
			{
				ServerTeamRequested(m_TeamSelection);
				if ( m_bDeadAfterTeamSel == True )
				{
					m_bDeadAfterTeamSel=False;
					GotoState('Dead');
				}
			}
		}
	}
}

auto state BaseSpectating
{
	simulated function BeginState ()
	{
	}

	simulated function EndState ()
	{
		InitializeMenuCom();
		if ( (Player != None) && (Viewport(Player) != None) && (m_GameService == None) && (Player.Console != None) )
		{
			m_GameService=R6AbstractGameService(Player.Console.SetGameServiceLinks(self));
		}
	}

	function ProcessMove (float DeltaTime, Vector NewAccel, EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
	{
		Acceleration=NewAccel;
		MoveSmooth(Acceleration * DeltaTime);
	}

	function PlayerMove (float DeltaTime)
	{
		local Rotator NewRotation;
		local Rotator OldRotation;
		local Rotator ViewRotation;
		local Vector X;
		local Vector Y;
		local Vector Z;

		GetAxes(Rotation,X,Y,Z);
		aForward=0.00;
		aStrafe=0.00;
		aUp=0.00;
		aTurn=0.00;
		Acceleration=0.02 * (aForward * X + aStrafe * Y + aUp * vect(0.00,0.00,1.00));
		ViewRotation=Rotation;
		SetRotation(ViewRotation);
		OldRotation=Rotation;
		UpdateRotation(DeltaTime,1.00);
		if ( Role < Role_Authority )
		{
			ReplicateMove(DeltaTime,Acceleration,DCLICK_None,OldRotation - Rotation);
		}
		else
		{
			ProcessMove(DeltaTime,Acceleration,DCLICK_None,OldRotation - Rotation);
		}
	}

	function Tick (float DeltaTime)
	{
		InitializeMenuCom();
	}

}

state PauseController extends PlayerWalking
{
	ignores  KilledBy;

	function BeginState ()
	{
	}

	function EndState ()
	{
	}

	exec function ToggleHelmetCameraZoom (optional bool bTurnOff)
	{
	}

	simulated function ProcessMove (float DeltaTime, Vector NewAccel, EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
	{
		bFire=0;
		Super.ProcessMove(DeltaTime,vect(0.00,0.00,0.00),DCLICK_None,DeltaRot);
	}

	simulated function PlayFiring ()
	{
	}

	simulated function AltFiring ()
	{
	}

	simulated function bool PlayerIsFiring ()
	{
		return False;
	}

	exec function Fire (optional float f)
	{
	}

	function PlayerMove (float DeltaTime)
	{
		aForward=0.00;
		aStrafe=0.00;
		R6PlayerMove(DeltaTime);
	}

	simulated function Tick (float fDeltaTime)
	{
		if ( (Pawn == None) || (m_bPawnInitialized == True) )
		{
			return;
		}
		m_bPawnInitialized=True;
		Pawn.m_bIsFiringWeapon=0;
		Pawn.SetPhysics(PHYS_Walking);
		if ( m_GameOptions.HUDShowFPWeapon )
		{
			ShowWeapon();
		}
	}

	function VeryShortClientAdjustPosition (float TimeStamp, float NewLocX, float NewLocY, float NewLocZ)
	{
		local Vector Floor;

		if ( Pawn != None )
		{
			Floor=Pawn.Floor;
		}
//		LongClientAdjustPosition(TimeStamp,'PauseController',1,NewLocX,NewLocY,NewLocZ,0.00,0.00,0.00,Floor.X,Floor.Y,Floor.Z);
	}

}

function ServerTeamRequested (ePlayerTeamSelection eTeamSelected, optional bool bForceSelection)
{
	local string szMessageLocTag;
	local bool bSameTeam;
	local int iTeamA;
	local int iTeamB;
	local int iMaxPlayerOnTeam;
	local PlayerReplicationInfo PRI;
	local Controller _P;
	local R6PlayerController P;

	if (  !bForceSelection && R6AbstractGameInfo(Level.Game).IsTeamSelectionLocked() )
	{
		return;
	}
	_P=Level.ControllerList;
JL0043:
	if ( _P != None )
	{
		if ( _P.IsA('PlayerController') && (_P.PlayerReplicationInfo != None) )
		{
			PRI=_P.PlayerReplicationInfo;
			if ( PRI != PlayerReplicationInfo )
			{
				if ( PRI.TeamID == 2 )
				{
					iTeamA++;
				}
				else
				{
					if ( PRI.TeamID == 3 )
					{
						iTeamB++;
					}
				}
			}
		}
		_P=_P.nextController;
		goto JL0043;
	}
	if ( PB_CanPlayerSpawn() == False )
	{
		eTeamSelected=PTS_Spectator;
		ClientPBVersionMismatch();
		if ( bShowLog )
		{
			Log("PlayerController " $ string(self) $ " has a PunkBuster version mismatch");
		}
	}
	if ( eTeamSelected == PTS_AutoSelect )
	{
		if ( iTeamA > iTeamB )
		{
			eTeamSelected=PTS_Bravo;
		}
		else
		{
			eTeamSelected=PTS_Alpha;
		}
	}
	bSameTeam=PlayerReplicationInfo.TeamID == eTeamSelected;
//	iMaxPlayerOnTeam=GetMissionDescription().GetMaxNbPlayers(GameReplicationInfo.m_eGameTypeFlag);
	if ( iMaxPlayerOnTeam <= iTeamA + iTeamB )
	{
		if ( (m_TeamSelection == 2) || (m_TeamSelection == 3) )
		{
			eTeamSelected=m_TeamSelection;
		}
		else
		{
//			eTeamSelected=PTS_Spectator;
		}
		bSameTeam=PlayerReplicationInfo.TeamID == eTeamSelected;
	}
	if (  !bSameTeam )
	{
//		iMaxPlayerOnTeam=GetMissionDescription().GetMaxNbPlayers(GameReplicationInfo.m_eGameTypeFlag);
/*		if ( Level.IsGameTypeTeamAdversarial(Level.ConvertGameTypeIntToEnum(Level.Game.m_iCurrGameType)) )
		{
			iMaxPlayerOnTeam=iMaxPlayerOnTeam / 2;
		}*/
		if ( (eTeamSelected == PTS_Alpha) && (iTeamA >= iMaxPlayerOnTeam) || (eTeamSelected == PTS_Bravo) && (iTeamB >= iMaxPlayerOnTeam) )
		{
			ClientTeamFullMessage();
			return;
		}
	}
	m_TeamSelection=eTeamSelected;
	PlayerReplicationInfo.TeamID=eTeamSelected;
	if ( (Level.NetMode != 0) && (Level.Game != None) )
	{
		if ( GameReplicationInfo.IsInAGameState() )
		{
			PlayerReplicationInfo.m_bJoinedTeamLate=True;
		}
		else
		{
			PlayerReplicationInfo.m_bJoinedTeamLate=False;
		}
		R6AbstractGameInfo(Level.Game).PlayerReadySelected(self);
	}
	if (  !bSameTeam )
	{
		szMessageLocTag="ChangedTeamSpectator";
/*		if ( Level.IsGameTypeTeamAdversarial(Level.ConvertGameTypeIntToEnum(Level.Game.m_iCurrGameType)) )
		{
			if ( eTeamSelected == PTS_Alpha )
			{
				szMessageLocTag="ChangedGreenTeam";
			}
			else
			{
				if ( eTeamSelected == PTS_Bravo )
				{
					szMessageLocTag="ChangedRedTeam";
				}
			}
		}
		else
		{*/
			if ( eTeamSelected == PTS_Alpha )
			{
				szMessageLocTag="HasJoinedTheGame";
			}
//		}
		foreach DynamicActors(Class'R6PlayerController',P)
		{
			P.ClientMPMiscMessage(szMessageLocTag,PlayerReplicationInfo.PlayerName);
		}
	}
	if ( Viewport(Player) != None )
	{
		PlayerTeamSelectionReceived();
	}
}

simulated function bool IsPlayerPassiveSpectator ()
{
	return (m_TeamSelection == 0) || (m_TeamSelection == 4);
}

event PlayerTeamSelectionReceived ()
{
	m_MenuCommunication.RefreshReadyButtonStatus();
}

function EnterSpectatorMode ();

function ResetCurrentState ();

function ClientGotoState (name NewState, name NewLabel)
{
	if ( (GetStateName() == 'BaseSpectating') && (NewState == 'Dead') )
	{
		m_bDeadAfterTeamSel=True;
		return;
	}
	if ( GetStateName() == NewState )
	{
		ResetCurrentState();
		return;
	}
	if ( NewLabel == 'None' )
	{
		GotoState(NewState);
	}
	else
	{
		GotoState(NewState,NewLabel);
	}
}

exec function Suicide ()
{
	if ( R6Pawn(Pawn) == None )
	{
		return;
	}
	if (  !m_pawn.IsAlive() )
	{
		return;
	}
	if ( GameReplicationInfo == None )
	{
		return;
	}
/*	if ( (Level.NetMode != 0) && (GameReplicationInfo.m_eCurrectServerState != GameReplicationInfo.3) )
	{
		return;
	}*/
	if ( GameReplicationInfo.m_bInPostBetweenRoundTime || GameReplicationInfo.m_bGameOverRep )
	{
		return;
	}
	R6Pawn(Pawn).ServerSuicidePawn(3);
	if ( Player.Console != None )
	{
		Player.Console.Message("Commited suicide",6.00);
	}
}

state WaitForGameRepInfo
{
	function BeginState ()
	{
		m_bReadyToEnterSpectatorMode=False;
	}

	event Tick (float fDeltaTime)
	{
		Super(Actor).Tick(fDeltaTime);
		if ( GameReplicationInfo != None )
		{
			InitializeMenuCom();
/*			if (  !m_bReadyToEnterSpectatorMode && (m_TeamSelection == 0) && (GameReplicationInfo.m_eCurrectServerState == GameReplicationInfo.3) )
			{
				m_bReadyToEnterSpectatorMode=True;
				SetTimer(5.00,False);
			}
			if ( m_TeamSelection != 0 )
			{
				SetTimer(0.00,False);
				GotoState('Dead');
			}*/
		}
	}

	function Timer ()
	{
		SetTimer(0.00,False);
		GotoState('Dead');
	}

}

state Dead
{
	function PlayFiring ()
	{
	}

	function AltFiring ()
	{
	}

	function PlayerMove (float DeltaTime)
	{
	}

	function ServerReStartPlayer ()
	{
	}

	exec function GraduallyOpenDoor ()
	{
	}

	exec function GraduallyCloseDoor ()
	{
	}

	exec function ToggleHelmetCameraZoom (optional bool bTurnOff)
	{
	}

	exec function Fire (optional float f)
	{
		local Class<R6Rainbow> rainbowPawnClass;

		if ( Level.NetMode == NM_Standalone )
		{
			return;
		}
		if (  !m_bReadyToEnterSpectatorMode )
		{
			return;
		}
		ResetBlur();
//		m_eCameraMode=0;
		m_bCameraFirstPerson=False;
		m_bCameraThirdPersonFree=False;
		m_bCameraThirdPersonFixed=False;
		m_bCameraGhost=False;
		m_bFadeToBlack=False;
		m_bSpectatorCameraTeamOnly=False;
/*		if ( (R6GameReplicationInfo(GameReplicationInfo).m_iDeathCameraMode & Level.1) > 0 )
		{
			m_bCameraFirstPerson=True;
			if ( bShowLog )
			{
				Log("Death Camera Mode = eDCM_FIRSTPERSON");
			}
		}
		if ( (R6GameReplicationInfo(GameReplicationInfo).m_iDeathCameraMode & Level.2) > 0 )
		{
			m_bCameraThirdPersonFixed=True;
			if ( bShowLog )
			{
				Log("Death Camera Mode = eDCM_THIRDPERSON");
			}
		}
		if ( (R6GameReplicationInfo(GameReplicationInfo).m_iDeathCameraMode & Level.4) > 0 )
		{
			m_bCameraThirdPersonFree=True;
			if ( bShowLog )
			{
				Log("Death Camera Mode = eDCM_FREETHIRDPERSON");
			}
		}
		if ( (R6GameReplicationInfo(GameReplicationInfo).m_iDeathCameraMode & Level.8) > 0 )
		{
			m_bCameraGhost=True;
			if ( bShowLog )
			{
				Log("Death Camera Mode = eDCM_GHOST");
			}
		}
		if ( (R6GameReplicationInfo(GameReplicationInfo).m_iDeathCameraMode & Level.16) > 0 )
		{
			m_bFadeToBlack=True;
			if ( bShowLog )
			{
				Log("Death Camera Mode = eDCM_FADETOBLACK");
			}
		}
		if ( (R6GameReplicationInfo(GameReplicationInfo).m_iDeathCameraMode & Level.32) > 0 )
		{
			m_bSpectatorCameraTeamOnly=True;
			if ( bShowLog )
			{
				Log("Spectator Camera is restricted to Team Only m_TeamSelection=" $ string(m_TeamSelection));
			}
			m_bCameraGhost=False;
		}*/
		if ( Level.NetMode != 0 )
		{
			if ( IsPlayerPassiveSpectator() || (m_TeamManager == None) || (m_TeamManager.m_iMemberCount == 0) )
			{
				if ( Role < Role_Authority )
				{
					ServerExecFire(f);
				}
				if ( Level.NetMode != 1 )
				{
					if ( Pawn != None )
					{
						Pawn.m_fRemainingGrenadeTime=0.00;
					}
					ClientFadeCommonSound(0.50,100);
				}
				if ( m_bCameraFirstPerson || m_bCameraThirdPersonFixed || m_bCameraThirdPersonFree || m_bCameraGhost )
				{
					GotoState('CameraPlayer');
				}
				else
				{
					if ( (myHUD != None) && (Viewport(Player) != None) )
					{
						R6AbstractHUD(myHUD).StartFadeToBlack(0,100);
						R6AbstractHUD(myHUD).ActivateNoDeathCameraMsg(True);
					}
				}
			}
		}
	}

	simulated function ResetCurrentState ()
	{
		if ( m_bSpectatorCameraTeamOnly && (m_MenuCommunication != None) && (m_TeamSelection == 4) )
		{
			BeginState();
			return;
		}
		if ( (Level.NetMode == NM_Client) || (Level.NetMode == NM_ListenServer) && (Viewport(Player) != None) )
		{
			if ( (m_MenuCommunication != None) && IsPlayerPassiveSpectator() )
			{
				m_bReadyToEnterSpectatorMode=True;
				Fire(0.00);
			}
		}
	}

	simulated function BeginState ()
	{
		local bool bCanEnterSpectator;

		if ( (Level.NetMode != 0) && (Viewport(Player) != None) && ((GameReplicationInfo == None) || (m_MenuCommunication == None)) )
		{
			GotoState('WaitForGameRepInfo');
			return;
		}
		bCanEnterSpectator=True;
		if ( bPendingDelete || (Pawn != None) && Pawn.bPendingDelete )
		{
			return;
		}
		if ( bDeleteMe || (Pawn != None) && Pawn.bDeleteMe )
		{
			return;
		}
		m_bReadyToEnterSpectatorMode=True;
/*		if ( (R6GameReplicationInfo(GameReplicationInfo).m_iDeathCameraMode & Level.32) > 0 )
		{
			m_bSpectatorCameraTeamOnly=True;
		}
		else
		{
			m_bSpectatorCameraTeamOnly=False;
		} */
		if ( (Level.NetMode == NM_DedicatedServer) || (Level.NetMode == NM_ListenServer) && (Viewport(Player) == None) )
		{
			ClientGotoState('Dead','None');
		}
		Super.BeginState();
		ClientDisableFirstPersonViewEffects();
		Blur(75);
		if ( (Level.NetMode == NM_Client) || (Level.NetMode == NM_ListenServer) && (Viewport(Player) != None) )
		{
			if ( (m_MenuCommunication != None) && (m_TeamSelection != 4) && ( !GameReplicationInfo.IsInAGameState() || (Pawn != None)) )
			{
				if ( m_TeamSelection == 0 )
				{
					m_MenuCommunication.SetStatMenuState(CMS_Initial);
					return;
				}
				else
				{
					if (  !Level.IsGameTypeCooperative(GameReplicationInfo.m_eGameTypeFlag) )
					{
						m_MenuCommunication.SetStatMenuState(CMS_PlayerDead);
					}
				}
			}
			else
			{
				if ( (Level.NetMode == NM_ListenServer) && (Viewport(Player) != None) && (m_TeamSelection != 4) )
				{
					if ( m_MenuCommunication == None )
					{
						InitializeMenuCom();
					}
				}
				else
				{
					if (  !m_bSpectatorCameraTeamOnly || (m_TeamSelection != 0) && (m_TeamSelection != 4) )
					{
						if ( GameReplicationInfo.IsInAGameState() && (Pawn == None) && (m_TeamSelection != 0) )
						{
							m_MenuCommunication.SetStatMenuState(CMS_PlayerDead);
							Fire(0.00);
						}
						else
						{
							m_MenuCommunication.SetStatMenuState(CMS_Initial);
						}
						return;
					}
					else
					{
						bCanEnterSpectator=False;
						m_bReadyToEnterSpectatorMode=False;
					}
				}
			}
		}
		if ( (myHUD != None) && (Viewport(Player) != None) )
		{
			if ( Level.NetMode == NM_Standalone )
			{
				R6AbstractHUD(myHUD).StartFadeToBlack(5,80);
			}
			else
			{
				if (  !bCanEnterSpectator )
				{
					R6AbstractHUD(myHUD).ActivateNoDeathCameraMsg(True);
					R6AbstractHUD(myHUD).StartFadeToBlack(1,100);
				}
				else
				{
					R6AbstractHUD(myHUD).StartFadeToBlack(5,100);
				}
			}
			if ( bCanEnterSpectator )
			{
				m_bReadyToEnterSpectatorMode=False;
				SetTimer(3.00,False);
			}
		}
	}

	function EnterSpectatorMode ()
	{
		if ( Level.NetMode != 0 )
		{
			Fire(0.00);
		}
	}

	function EndState ()
	{
		if ( (myHUD != None) && (Viewport(Player) != None) )
		{
			R6AbstractHUD(myHUD).StopFadeToBlack();
			R6AbstractHUD(myHUD).ActivateNoDeathCameraMsg(False);
		}
		m_bReadyToEnterSpectatorMode=False;
		ResetBlur();
	}

	function Timer ()
	{
		if ( PlayerCanSwitchToAIBackup() )
		{
			return;
		}
		InitializeMenuCom();
		if ( m_bSpectatorCameraTeamOnly && (m_MenuCommunication != None) && (m_TeamSelection == 4) )
		{
			return;
		}
		m_bReadyToEnterSpectatorMode=True;
		if ( Level.NetMode != 0 )
		{
/*			if ( (R6GameReplicationInfo(GameReplicationInfo).m_iDeathCameraMode & Level.16) > 0 )
			{
				R6AbstractHUD(myHUD).ActivateNoDeathCameraMsg(True);
			}
			else
			{
				if ( (GameReplicationInfo != None) && (GameReplicationInfo.m_eCurrectServerState == GameReplicationInfo.3) && (m_TeamSelection != 0) )
				{
					ClientGameMsg("","","PressFireToGoInObserverMode");
				}
			}  */
		}
	}

}

function ClientDisableFirstPersonViewEffects (optional bool bChangingPawn)
{
	DisableFirstPersonViewEffects(bChangingPawn);
	m_bLockWeaponActions=False;
}

function DisableFirstPersonViewEffects (optional bool bChangingPawn)
{
	local R6AbstractWeapon AWeapon;

	if ( Pawn != None )
	{
		if ( Pawn.IsLocallyControlled() )
		{
			DoZoom(True);
			bZooming=False;
			m_bHelmetCameraOn=False;
			DefaultFOV=Default.DefaultFOV;
			DesiredFOV=Default.DesiredFOV;
			FovAngle=Default.DesiredFOV;
			HelmetCameraZoom(1.00);
			R6Pawn(Pawn).ToggleHeatProperties(False,None,None);
			R6Pawn(Pawn).ToggleNightProperties(False,None,None);
			R6Pawn(Pawn).ToggleScopeProperties(False,None,None);
			Level.m_bHeartBeatOn=False;
			ResetBlur();
			Level.m_bInGamePlanningActive=False;
			SetPlanningMode(False);
			if ( (Level.NetMode == NM_Standalone) ||  !PlayerCanSwitchToAIBackup() )
			{
				AWeapon=R6AbstractWeapon(Pawn.EngineWeapon);
				if ( AWeapon != None )
				{
					AWeapon.GotoState('None');
					AWeapon.DisableWeaponOrGadget();
					if ( Level.NetMode != 1 )
					{
						AWeapon.RemoveFirstPersonWeapon();
					}
				}
			}
			else
			{
				if (  !bChangingPawn )
				{
					m_bShowFPWeapon=False;
					m_bHideReticule=True;
				}
				else
				{
					if ( (m_GameOptions.HUDShowFPWeapon == True) || (R6GameReplicationInfo(GameReplicationInfo).m_bFFPWeapon == True) )
					{
						m_bShowFPWeapon=True;
						m_bHideReticule=False;
						m_bUseFirstPersonWeapon=True;
					}
				}
			}
		}
		Pawn.m_fRemainingGrenadeTime=0.00;
	}
	bBehindView=False;
}

state CameraPlayer
{
	simulated function BeginState ()
	{
		local R6RainbowTeam rainbowTeam;

		PlayerReplicationInfo.bIsSpectator=True;
		bOnlySpectator=True;
		if ( Pawn != None )
		{
			Pawn.bOwnerNoSee=False;
		}
		Pawn=None;
		m_pawn=None;
		SetViewTarget(self);
		Acceleration=vect(0.00,0.00,0.00);
		SetPhysics(PHYS_Flying);
		m_PrevViewTarget=None;
//		m_eCameraMode=0;
		if (  !CameraIsAvailable() )
		{
			SelectCameraMode(True);
		}
		if ( Level.NetMode == NM_Standalone )
		{
			rainbowTeam=R6RainbowTeam(R6AbstractGameInfo(Level.Game).GetRainbowTeam(Player.Console.Master.m_StartGameInfo.m_iTeamStart));
			SetNewViewTarget(rainbowTeam.m_Team[0]);
			if ( ViewTarget != None )
			{
				SetCameraMode();
			}
		}
		else
		{
			if ( Level.NetMode != 3 )
			{
				SpectatorChangeTeams(True);
				if ( ViewTarget != None )
				{
					SetCameraMode();
				}
			}
		}
	}

	simulated function EndState ()
	{
		PlayerReplicationInfo.bIsSpectator=False;
		bOnlySpectator=False;
		bBehindView=False;
		SetViewTarget(self);
	}

	simulated function SetSpectatorRotation ()
	{
		local Rotator rViewRotation;

		if ( ViewTarget != None )
		{
			if (  !bBehindView )
			{
				SetRotation(ViewTarget.Rotation + R6Pawn(ViewTarget).GetRotationOffset());
			}
			else
			{
				rViewRotation=ViewTarget.Rotation;
				rViewRotation.Pitch=-6000;
				SetRotation(rViewRotation);
			}
			m_iSpectatorPitch=Rotation.Pitch;
			m_iSpectatorYaw=Rotation.Yaw;
		}
	}

	function NextCameraMode ()
	{
		switch (m_eCameraMode)
		{
/*			case 0:
			m_eCameraMode=1;
			break;
			case 1:
			m_eCameraMode=2;
			break;
			case 2:
			m_eCameraMode=3;
			break;
			case 3:
			m_eCameraMode=0;
			default:*/
		}
	}

	function PreviousCameraMode ()
	{
		switch (m_eCameraMode)
		{
/*			case 0:
			m_eCameraMode=3;
			break;
			case 1:
			m_eCameraMode=0;
			break;
			case 2:
			m_eCameraMode=1;
			break;
			case 3:
			m_eCameraMode=2;
			default:*/
		}
	}

	function SelectCameraMode (bool bNext)
	{
		if ( bNext )
		{
			NextCameraMode();
	JL000F:
			if (  !CameraIsAvailable() )
			{
				NextCameraMode();
				goto JL000F;
			}
		}
		else
		{
			PreviousCameraMode();
	JL002C:
			if (  !CameraIsAvailable() )
			{
				PreviousCameraMode();
				goto JL002C;
			}
		}
	}

	function bool CameraIsAvailable ()
	{
		switch (m_eCameraMode)
		{
/*			case 0:
			if ( m_bCameraFirstPerson )
			{
				return True;
			}
			break;
			case 1:
			if ( m_bCameraThirdPersonFixed )
			{
				return True;
			}
			break;
			case 2:
			if ( m_bCameraThirdPersonFree )
			{
				return True;
			}
			break;
			case 3:
			if ( m_bCameraGhost )
			{
				return True;
			}
			break;
			default:  */
		}
		return False;
	}

	exec function ToggleHelmetCameraZoom (optional bool bTurnOff)
	{
	}

	exec function Fire (optional float f)
	{
		if ( Role < Role_Authority )
		{
			ServerExecFire(f);
		}
		if ( ViewTarget == None )
		{
			return;
		}
		if ( Level.NetMode != 3 )
		{
			if ( f == 0 )
			{
				SelectCameraMode(True);
			}
			else
			{
				SelectCameraMode(False);
			}
			SetCameraMode();
		}
	}

	exec function AltFire (optional float f)
	{
		Fire(1.00);
	}

	function ProcessMove (float DeltaTime, Vector NewAccel, EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
	{
		if ( m_eCameraMode != 3 )
		{
			return;
		}
		if ( bRun > 0 )
		{
			Acceleration=1.60 * NewAccel;
		}
		else
		{
			Acceleration=NewAccel;
		}
		MoveSmooth(Acceleration * DeltaTime);
	}

	simulated function PlayerMove (float DeltaTime)
	{
		local Vector X;
		local Vector Y;
		local Vector Z;
		local Rotator rViewRotation;

		if ( m_eCameraMode == 3 )
		{
			GetAxes(Rotation,X,Y,Z);
			Acceleration=0.05 * (aForward * X + aStrafe * Y + aUp * vect(0.00,0.00,1.00));
			UpdateRotation(DeltaTime,1.00);
		}
		else
		{
			m_fCurrentDeltaTime=DeltaTime;
			if ( bBehindView )
			{
				if (  !bFixedCamera )
				{
					GetAxes(Rotation,X,Y,Z);
					rViewRotation=Rotation;
					rViewRotation.Yaw += 32.00 * DeltaTime * aTurn;
					rViewRotation.Pitch += 32.00 * DeltaTime * aLookUp;
					rViewRotation.Pitch=rViewRotation.Pitch & 65535;
					if ( (rViewRotation.Pitch > 16384) && (rViewRotation.Pitch < 49152) )
					{
						if ( aLookUp > 0 )
						{
							rViewRotation.Pitch=16384;
						}
						else
						{
							rViewRotation.Pitch=49152;
						}
					}
					SetRotation(rViewRotation);
				}
				else
				{
					if ( ViewTarget != None )
					{
						rViewRotation=ViewTarget.Rotation;
						rViewRotation.Pitch=-6000;
						SetRotation(rViewRotation);
					}
				}
			}
			if ( m_bShakeActive == True )
			{
				ViewShake(DeltaTime);
			}
			ViewFlash(DeltaTime);
			Acceleration=vect(0.00,0.00,0.00);
		}
		if ( Class'Actor'.static.GetModMgr().IsMissionPack() )
		{
			if ( m_pawn.m_bIsSurrended )
			{
				Pawn.Acceleration=vect(0.00,0.00,0.00);
				aForward=0.00;
				aStrafe=0.00;
				aTurn=0.00;
				bRun=0;
				Pawn.Velocity=vect(0.00,0.00,0.00);
				ProcessMove(DeltaTime,Acceleration,DCLICK_None,rot(0,0,0));
			}
			else
			{
				if ( Role < Role_Authority )
				{
					ReplicateMove(DeltaTime,Acceleration,DCLICK_None,rot(0,0,0));
				}
				else
				{
					ProcessMove(DeltaTime,Acceleration,DCLICK_None,rot(0,0,0));
				}
			}
		}
		else
		{
			if ( Role < Role_Authority )
			{
				ReplicateMove(DeltaTime,Acceleration,DCLICK_None,rot(0,0,0));
			}
			else
			{
				ProcessMove(DeltaTime,Acceleration,DCLICK_None,rot(0,0,0));
			}
		}
	}

	function ServerMove (float TimeStamp, Vector Accel, Vector ClientLoc, bool NewbRun, bool NewbDuck, bool NewbCrawl, int View, int iNewRotOffset, optional byte OldTimeDelta, optional int OldAccel)
	{
		if ( m_eCameraMode != 3 )
		{
			Accel=vect(0.00,0.00,0.00);
		}
		else
		{
			if ( Accel == vect(0.00,0.00,0.00) )
			{
				Velocity=vect(0.00,0.00,0.00);
			}
			if ( NewbRun )
			{
				Accel=1.60 * Accel;
			}
		}
		Super.ServerMove(TimeStamp,Accel,ClientLoc,False,False,False,View,iNewRotOffset);
	}

	simulated function Tick (float fDeltaTime)
	{
		local Rotator rPitchOffset;

		m_iTeamId=PlayerReplicationInfo.TeamID;
		if ( m_eCameraMode == 3 )
		{
			return;
		}
		if ( (ViewTarget == None) || (ViewTarget == self) )
		{
			if ( Level.NetMode != 3 )
			{
				SpectatorChangeTeams(True);
				if ( (ViewTarget != None) && (ViewTarget != self) )
				{
					SetCameraMode();
				}
			}
			return;
		}
		if (  !bBehindView )
		{
			SetRotation(ViewTarget.Rotation + R6Pawn(ViewTarget).GetRotationOffset());
		}
		else
		{
			if ( bFixedCamera )
			{
				SetRotation(ViewTarget.Rotation);
			}
		}
		SetLocation(ViewTarget.Location);
	}

	function SetCameraMode ()
	{
		local Rotator rViewRotation;
		local Actor CamSpot;

		if ( m_eCameraMode != 3 )
		{
			if ( ViewTarget == self )
			{
				if ( m_PrevViewTarget == None )
				{
					return;
				}
				if ( Level.NetMode == NM_Standalone )
				{
					m_TeamManager.SetVoicesMgr(R6AbstractGameInfo(Level.Game),False,True);
				}
				SetNewViewTarget(m_PrevViewTarget);
			}
		}
		switch (m_eCameraMode)
		{
/*			case 0:
			bBehindView=False;
			m_bAttachCameraToEyes=True;
			bCheatFlying=False;
			SetSpectatorRotation();
			DisplayClientMessage();
			break;
			case 1:
			bBehindView=True;
			bFixedCamera=True;
			m_bAttachCameraToEyes=True;
			bCheatFlying=False;
			SetSpectatorRotation();
			DisplayClientMessage();
			break;
			case 2:
			bBehindView=True;
			bFixedCamera=False;
			m_bAttachCameraToEyes=True;
			bCheatFlying=False;
			SetSpectatorRotation();
			DisplayClientMessage();
			break;
			case 3:
			if ( ViewTarget != self )
			{
				m_PrevViewTarget=ViewTarget;
			}
			SetViewTarget(self);
			if ( m_PrevViewTarget == None )
			{
				CamSpot=Level.GetCamSpot(GameReplicationInfo.m_eGameTypeFlag);
				if ( CamSpot != None )
				{
					SetRotation(CamSpot.Rotation);
					SetLocation(CamSpot.Location);
				}
			}
			else
			{
				rViewRotation=m_PrevViewTarget.Rotation;
				rViewRotation.Pitch=-6000;
				SetRotation(rViewRotation);
				SetLocation(m_PrevViewTarget.Location - CameraDist * R6Pawn(m_PrevViewTarget).Default.CollisionRadius * Rotation);
			}
			bBehindView=False;
			bFixedCamera=False;
			m_bAttachCameraToEyes=False;
			bCheatFlying=True;
			if ( Level.NetMode == NM_Standalone )
			{
				m_TeamManager.SetVoicesMgr(R6AbstractGameInfo(Level.Game),False,False,m_TeamManager.m_iIDVoicesMgr,True);
			}
			else
			{
				m_TeamManager=None;
			}
			DisplayClientMessage();
			break;
			default:     */
		}
	}

	simulated function ChangeTeams (bool bNextTeam)
	{
		local R6RainbowTeam rainbowTeam;

		if ( Level.NetMode != 0 )
		{
			return;
		}
		if ( m_eCameraMode == 3 )
		{
			return;
		}
		rainbowTeam=R6RainbowTeam(R6AbstractGameInfo(Level.Game).GetNewTeam(m_TeamManager,bNextTeam));
		if ( rainbowTeam == None )
		{
			return;
		}
		SetNewViewTarget(rainbowTeam.m_Team[0]);
		DisplayClientMessage();
	}

	function ServerChangeTeams (bool bNextTeam)
	{
		SpectatorChangeTeams(bNextTeam);
	}

	function ValidateCameraTeamId ()
	{
		if ( (m_MenuCommunication != None) && (m_TeamSelection != 2) )
		{
			m_iTeamId=2;
		}
		else
		{
			m_iTeamId=3;
		}
	}

	function SpectatorChangeTeams (bool bNextTeam)
	{
		local R6Rainbow Other;
		local R6Rainbow first;
		local R6Rainbow Last;
		local bool bFound;

		if ( (Level.Game != None) &&  !Level.Game.bCanViewOthers )
		{
			return;
		}
		if ( m_bSpectatorCameraTeamOnly && (m_iTeamId == 0) )
		{
			ValidateCameraTeamId();
		}
		if ( bNextTeam )
		{
			first=None;
			foreach AllActors(Class'R6Rainbow',Other)
			{
				if ( Other.IsAlive() )
				{
					if ( m_bSpectatorCameraTeamOnly && (Other.m_iTeam != m_iTeamId) )
					{
						continue;
					}
					else
					{
						if ( bFound || (first == None) )
						{
							first=Other;
							if ( bFound )
							{
								goto JL00EF;
							}
						}
						if ( Other == ViewTarget )
						{
							bFound=True;
						}
					}
				}
	JL00EF:
			}
			if ( first != None )
			{
				SetNewViewTarget(first);
			}
			else
			{
				return;
			}
		}
		else
		{
			Last=None;
			foreach AllActors(Class'R6Rainbow',Other)
			{
				if ( Other.IsAlive() )
				{
					if ( m_bSpectatorCameraTeamOnly && (Other.m_iTeam != m_iTeamId) )
					{
						continue;
					}
					else
					{
						if ( (Other == ViewTarget) && (Last != None) )
						{
							goto JL0189;
						}
						Last=Other;
					}
				}
	JL0189:
			}
			if ( Last != None )
			{
				SetNewViewTarget(Last);
			}
			else
			{
				return;
			}
		}
	}

	event ClientSetNewViewTarget ()
	{
		if ( Level.NetMode != 3 )
		{
			return;
		}
		if ( ViewTarget != self )
		{
			m_PrevViewTarget=ViewTarget;
		}
		SetNewViewTarget(ViewTarget);
		if ( ViewTarget != None )
		{
			SetCameraMode();
		}
	}

	simulated function SetNewViewTarget (Actor aViewTarget)
	{
		local R6Rainbow aPawn;
		local R6RainbowTeam aOldTeamManager;

		if ( m_eCameraMode == 3 )
		{
			return;
		}
		aPawn=R6Rainbow(aViewTarget);
		if ( aPawn == None )
		{
			return;
		}
		SetViewTarget(aPawn);
		if ( aPawn.Controller != None )
		{
			aOldTeamManager=m_TeamManager;
			if (  !aPawn.m_bIsPlayer )
			{
				m_TeamManager=R6RainbowAI(aPawn.Controller).m_TeamManager;
			}
			else
			{
				m_TeamManager=R6PlayerController(aPawn.Controller).m_TeamManager;
			}
			if ( (Role == Role_Authority) && (aOldTeamManager != None) && (aOldTeamManager != m_TeamManager) &&  !aOldTeamManager.m_bLeaderIsAPlayer &&  !m_TeamManager.m_bLeaderIsAPlayer )
			{
				aOldTeamManager.SetVoicesMgr(R6AbstractGameInfo(Level.Game),False,False,m_TeamManager.m_iIDVoicesMgr);
				m_TeamManager.SetVoicesMgr(R6AbstractGameInfo(Level.Game),False,True);
			}
		}
		SetSpectatorRotation();
		FixFOV();
		if ( (Level.NetMode == NM_ListenServer) && (Viewport(Player) != None) )
		{
			DisplayClientMessage();
		}
	}

	exec function NextMember ()
	{
		local int i;

		if ( m_eCameraMode == 3 )
		{
			return;
		}
		if ( Level.NetMode == NM_Standalone )
		{
			if ( m_TeamManager.m_iMemberCount > 0 )
			{
				i=R6Pawn(ViewTarget).m_iID + 1;
				if ( i >= m_TeamManager.m_iMemberCount )
				{
					i=0;
				}
				SetViewTarget(m_TeamManager.m_Team[i]);
				DisplayClientMessage();
			}
		}
		else
		{
			ServerChangeTeams(True);
		}
	}

	exec function PreviousMember ()
	{
		local int i;

		if ( m_eCameraMode == 3 )
		{
			return;
		}
		if ( Level.NetMode == NM_Standalone )
		{
			if ( m_TeamManager.m_iMemberCount > 0 )
			{
				i=R6Pawn(ViewTarget).m_iID - 1;
				if ( i < 0 )
				{
					i=m_TeamManager.m_iMemberCount - 1;
				}
				SetViewTarget(m_TeamManager.m_Team[i]);
				DisplayClientMessage();
			}
		}
		else
		{
			ServerChangeTeams(False);
		}
	}

	function string GetViewTargetName ()
	{
		local R6Pawn targetPawn;

		if ( ViewTarget == None )
		{
			return "";
		}
		targetPawn=R6Pawn(ViewTarget);
		if ( targetPawn == None )
		{
			return "";
		}
		if ( targetPawn.m_bIsPlayer )
		{
			if ( Level.NetMode == NM_Standalone )
			{
				return targetPawn.m_CharacterName;
			}
			else
			{
				if ( targetPawn.PlayerReplicationInfo != None )
				{
					return targetPawn.PlayerReplicationInfo.PlayerName;
				}
			}
		}
		else
		{
			return targetPawn.m_CharacterName;
		}
	}

	function DisplayClientMessage ()
	{
		local string targetName;

		if ( ViewTarget == None )
		{
			return;
		}
		if ( (Level.NetMode == NM_Client) || (Level.NetMode == NM_Standalone) || (Level.NetMode == NM_ListenServer) && (Viewport(Player) != None) )
		{
			if ( bCheatFlying )
			{
				ClientMessage(Localize("Game","GhostCamera","R6GameInfo"));
				return;
			}
			targetName=GetViewTargetName();
			if ( targetName == "" )
			{
				return;
			}
			if (  !bBehindView )
			{
				ClientMessage(Localize("Game","NowViewing","R6GameInfo") @ targetName @ Localize("Game","FirstCamera","R6GameInfo"));
			}
			else
			{
				if ( bFixedCamera )
				{
					ClientMessage(Localize("Game","NowViewing","R6GameInfo") @ targetName @ Localize("Game","FixedThirdCamera","R6GameInfo"));
				}
				else
				{
					ClientMessage(Localize("Game","NowViewing","R6GameInfo") @ targetName @ Localize("Game","FreeThirdCamera","R6GameInfo"));
				}
			}
		}
	}

}

function ServerStartSurrenderSequence ()
{
	m_bSkipBeginState=False;
	GotoState('PlayerStartSurrenderSequence');
}

state PlayerStartSurrenderSequence extends PlayerWalking
{
	function BeginState ()
	{
		local SavedMove Next;
		local SavedMove Current;

		if ( m_bSkipBeginState )
		{
			m_bSkipBeginState=False;
			return;
		}
		Pawn.Acceleration=vect(0.00,0.00,0.00);
		aForward=0.00;
		aStrafe=0.00;
		Pawn.Velocity=vect(0.00,0.00,0.00);
		if ( m_pawn.m_bMovingDiagonally )
		{
			m_pawn.ResetDiagonalStrafing();
		}
		bRun=0;
		m_bPeekLeft=0;
		m_bPeekRight=0;
		m_fStartSurrenderTime=Level.TimeSeconds;
		if ( m_pawn.m_eGrenadeThrow != 0 )
		{
			m_pawn.GrenadeAnimEnd();
		}
		if ( Pawn.IsLocallyControlled() )
		{
			ToggleHelmetCameraZoom(True);
			DoZoom(True);
		}
		ToggleHelmetCameraZoom(True);
//		SetPeekingInfo(PEEK_none,m_pawn.1000.00);
		ResetFluidPeeking();
		if ( m_pawn.m_bIsClimbingLadder )
		{
			Pawn.SetPhysics(PHYS_Falling);
			Pawn.OnLadder=None;
			m_pawn.m_bSlideEnd=False;
			m_pawn.m_bIsClimbingLadder=False;
			m_pawn.m_bPostureTransition=False;
			m_pawn.m_Ladder=None;
			Pawn.SetLocation(Pawn.Location + 25 * vector(Pawn.Rotation));
			m_pawn.PlayFalling();
		}
		else
		{
			if ( m_bCrawl )
			{
				m_pawn.m_bWantsToProne=False;
				if ( Level.NetMode == NM_Client )
				{
					m_pawn.ServerSetCrouch(True);
				}
				m_pawn.bWantsToCrouch=True;
				RaisePosture();
				m_pawn.EndCrawl();
			}
			else
			{
				if ( bDuck != 0 )
				{
					m_pawn.m_bPostureTransition=False;
					RaisePosture();
					if ( m_pawn.m_bReloadingWeapon || m_pawn.m_bChangingWeapon )
					{
						GotoState('PlayerFinishReloadingBeforeSurrender');
					}
					else
					{
						GotoState('PlayerPreBeginSurrending');
					}
				}
				else
				{
					if ( m_pawn.m_bReloadingWeapon || m_pawn.m_bChangingWeapon )
					{
						GotoState('PlayerFinishReloadingBeforeSurrender');
					}
					else
					{
						if ( Pawn.Physics != 2 )
						{
							GotoState('PlayerPreBeginSurrending');
						}
					}
				}
			}
		}
	}

	function EndState ()
	{
	}

	event Tick (float fDiffTime)
	{
		if ( (Pawn.Physics != 2) &&  !Pawn.m_bIsLanding &&  !m_bCrawl && (bDuck == 0) )
		{
			GotoState('PlayerPreBeginSurrending');
		}
	}

	function PlayerMove (float DeltaTime)
	{
		if ( Pawn.Physics != 2 )
		{
			Pawn.Acceleration=vect(0.00,0.00,0.00);
			Pawn.Velocity=vect(0.00,0.00,0.00);
		}
		aForward=0.00;
		aStrafe=0.00;
		aTurn=0.00;
		bRun=0;
		m_bPeekLeft=0;
		m_bPeekRight=0;
		if ( Role < Role_Authority )
		{
			ReplicateMove(DeltaTime,vect(0.00,0.00,0.00),DCLICK_None,rot(0,0,0));
		}
		else
		{
			ProcessMove(DeltaTime,vect(0.00,0.00,0.00),DCLICK_None,rot(0,0,0));
		}
	}

	function PlayFiring ()
	{
	}

	function AltFiring ()
	{
	}

	function ServerReStartPlayer ()
	{
	}

	exec function Say (string Msg)
	{
	}

	exec function TeamSay (string Msg)
	{
	}

	exec function Fire (optional float f)
	{
	}

	event AnimEnd (int iChannel)
	{
		if ( /*(iChannel == m_pawn.1) &&*/ (bDuck != 0) )
		{
			m_pawn.m_bPostureTransition=False;
			RaisePosture();
			if ( m_pawn.m_bReloadingWeapon || m_pawn.m_bChangingWeapon )
			{
				GotoState('PlayerFinishReloadingBeforeSurrender');
			}
			else
			{
				GotoState('PlayerPreBeginSurrending');
			}
		}
		else
		{
			m_pawn.AnimEnd(iChannel);
		}
	}

	function VeryShortClientAdjustPosition (float TimeStamp, float NewLocX, float NewLocY, float NewLocZ)
	{
		local Vector Floor;

		if ( Pawn != None )
		{
			Floor=Pawn.Floor;
		}
		if ( Pawn.Physics != 1 )
		{
			return;
		}
		m_bSkipBeginState=True;
//		LongClientAdjustPosition(TimeStamp,'PlayerStartSurrenderSequence',1,NewLocX,NewLocY,NewLocZ,0.00,0.00,0.00,Floor.X,Floor.Y,Floor.Z);
		m_bSkipBeginState=False;
	}

}

state PlayerFinishReloadingBeforeSurrender
{
	function BeginState ()
	{
	}

	event AnimEnd (int iChannel)
	{
		m_pawn.AnimEnd(iChannel);
/*		if ( iChannel == m_pawn.14 )
		{
			GotoState('PlayerPreBeginSurrending');
		}              */
	}

	function PlayFiring ()
	{
	}

	function AltFiring ()
	{
	}

	function ServerReStartPlayer ()
	{
	}

	exec function Say (string Msg)
	{
	}

	exec function TeamSay (string Msg)
	{
	}

	exec function Fire (optional float f)
	{
	}

	function ServerMove (float TimeStamp, Vector Accel, Vector ClientLoc, bool NewbRun, bool NewbDuck, bool NewbCrawl, int View, int iNewRotOffset, optional byte OldTimeDelta, optional int OldAccel)
	{
	}

	function PlayerMove (float DeltaTime)
	{
		Pawn.Acceleration=vect(0.00,0.00,0.00);
		aForward=0.00;
		aStrafe=0.00;
		aTurn=0.00;
		bRun=0;
		m_bPeekLeft=0;
		m_bPeekRight=0;
		if ( Role < Role_Authority )
		{
			ReplicateMove(DeltaTime,vect(0.00,0.00,0.00),DCLICK_None,rot(0,0,0));
		}
		else
		{
			ProcessMove(DeltaTime,vect(0.00,0.00,0.00),DCLICK_None,rot(0,0,0));
		}
	}

}

state PlayerPreBeginSurrending extends CameraPlayer
{
	function BeginState ()
	{
		local R6AbstractWeapon AWeapon;
		local Rotator newRot;

		if ( Pawn.IsLocallyControlled() && (m_eCameraMode == 0) && (Level.NetMode != 1) )
		{
			newRot.Pitch=ViewTarget.Rotation.Pitch;
			newRot.Yaw=ViewTarget.Rotation.Yaw;
			newRot.Roll=0;
			ViewTarget.SetRotation(newRot);
			DoZoom(True);
			bZooming=False;
			m_bHelmetCameraOn=False;
			DefaultFOV=Default.DefaultFOV;
			DesiredFOV=Default.DesiredFOV;
			FovAngle=Default.DesiredFOV;
			HelmetCameraZoom(1.00);
			R6Pawn(Pawn).ToggleHeatProperties(False,None,None);
			R6Pawn(Pawn).ToggleNightProperties(False,None,None);
			R6Pawn(Pawn).ToggleScopeProperties(False,None,None);
			Level.m_bHeartBeatOn=False;
			Level.m_bInGamePlanningActive=False;
			SetPlanningMode(False);
//			m_eCameraMode=2;
			if (  !CameraIsAvailable() )
			{
				SelectCameraMode(True);
			}
			SetCameraMode();
		}
		Pawn.m_fRemainingGrenadeTime=0.00;
		if ( (m_pawn.EngineWeapon != None) &&  !(Pawn.EngineWeapon.IsA('R6GrenadeWeapon') || Pawn.EngineWeapon.IsA('R6HBSSAJammerGadget')) &&  !Pawn.EngineWeapon.HasAmmo() )
		{
			if ( m_pawn.m_bIsFiringWeapon != 0 )
			{
				m_pawn.EngineWeapon.ServerStopFire();
			}
			if (  !m_pawn.EngineWeapon.IsInState('PutWeaponDown') )
			{
				m_pawn.EngineWeapon.GotoState('PutWeaponDown');
				if ( Level.NetMode != 3 )
				{
//					m_pawn.SetNextPendingAction(PENDING_StopCoughing7);
				}
			}
			else
			{
				m_bSkipBeginState=False;
				GotoState('PlayerStartSurrending');
			}
		}
		else
		{
			m_bSkipBeginState=False;
			GotoState('PlayerStartSurrending');
		}
	}

	function EndState ()
	{
		m_pawn.m_bWeaponTransition=False;
	}

	function PlayFiring ()
	{
	}

	function AltFiring ()
	{
	}

	function ServerReStartPlayer ()
	{
	}

	exec function Say (string Msg)
	{
	}

	exec function TeamSay (string Msg)
	{
	}

	exec function Fire (optional float f)
	{
	}

	event AnimEnd (int iChannel)
	{
/*		if ( iChannel == m_pawn.14 )
		{
			m_bSkipBeginState=False;
			GotoState('PlayerStartSurrending');
		}
		else
		{          */
			m_pawn.AnimEnd(iChannel);
//		}
	}

	function SwitchWeapon (byte f)
	{
	}

	exec function PreviousMember ()
	{
	}

	exec function NextMember ()
	{
	}

	simulated function ChangeTeams (bool bNextTeam)
	{
	}

	function ServerChangeTeams (bool bNextTeam)
	{
	}

	function ValidateCameraTeamId ()
	{
	}

	function SpectatorChangeTeams (bool bNextTeam)
	{
	}

	event ClientSetNewViewTarget ()
	{
	}

	simulated function SetNewViewTarget (Actor aViewTarget)
	{
	}

}

state PlayerStartSurrending extends CameraPlayer
{
	function BeginState ()
	{
		if ( m_bSkipBeginState )
		{
			m_bSkipBeginState=False;
			return;
		}
		if ( Level.NetMode != 3 )
		{
//			m_pawn.SetNextPendingAction(PENDING_OpenDoor0);
		}
	}

	function EndState ()
	{
		m_pawn.m_bPostureTransition=False;
		m_pawn.m_bPawnSpecificAnimInProgress=False;
	}

	event AnimEnd (int iChannel)
	{
/*		if ( iChannel == m_pawn.16 )
		{
			GotoState('PlayerSurrended');
		}   */
	}

	function SwitchWeapon (byte f)
	{
	}

	function PlayFiring ()
	{
	}

	function AltFiring ()
	{
	}

	function ServerReStartPlayer ()
	{
	}

	exec function Fire (optional float f)
	{
	}

	exec function Say (string Msg)
	{
	}

	exec function TeamSay (string Msg)
	{
	}

	exec function PreviousMember ()
	{
	}

	exec function NextMember ()
	{
	}

	simulated function ChangeTeams (bool bNextTeam)
	{
	}

	function ServerChangeTeams (bool bNextTeam)
	{
	}

	function ValidateCameraTeamId ()
	{
	}

	function SpectatorChangeTeams (bool bNextTeam)
	{
	}

	event ClientSetNewViewTarget ()
	{
	}

	simulated function SetNewViewTarget (Actor aViewTarget)
	{
	}

}

function ServerStartSurrended ()
{
	m_bSkipBeginState=False;
	GotoState('PlayerSurrended');
}

state PlayerSurrended extends CameraPlayer
{
	function BeginState ()
	{
		m_pawn.bInvulnerableBody=False;
		if ( Level.NetMode != 3 )
		{
//			m_pawn.SetNextPendingAction(PENDING_Blinded1);
		}
	}

	event AnimEnd (int iChannel)
	{
/*		if ( iChannel == m_pawn.16 )
		{
			if ( Level.NetMode != 3 )
			{
				m_pawn.SetNextPendingAction(PENDING_Blinded1);
			}
		}*/
	}

	function EndState ()
	{
		m_pawn.m_bPawnSpecificAnimInProgress=False;
	}

	function PlayFiring ()
	{
	}

	function AltFiring ()
	{
	}

	function ServerReStartPlayer ()
	{
	}

	exec function ToggleHelmetCameraZoom (optional bool bTurnOff)
	{
	}

	exec function Fire (optional float f)
	{
	}

	exec function Say (string Msg)
	{
	}

	exec function TeamSay (string Msg)
	{
	}

	function SwitchWeapon (byte f)
	{
	}

	event Tick (float fDeltaTime)
	{
		if ( (Role == Role_Authority) && (Level.TimeSeconds - m_fStartSurrenderTime > 10) &&  !m_pawn.m_bIsUnderArrest &&  !m_pawn.m_bIsBeingArrestedOrFreed )
		{
			m_bSkipBeginState=False;
			m_pawn.m_eHealth=HEALTH_Healthy;
			m_pawn.m_bIsSurrended=False;
			if ( Level.NetMode == NM_DedicatedServer )
			{
				ClientEndSurrended();
			}
			GotoState('PlayerEndSurrended');
		}
		else
		{
			if ( m_pawn.m_bIsBeingArrestedOrFreed )
			{
				GotoState('PlayerStartArrest');
			}
		}
	}

	exec function PreviousMember ()
	{
	}

	exec function NextMember ()
	{
	}

	simulated function ChangeTeams (bool bNextTeam)
	{
	}

	function ServerChangeTeams (bool bNextTeam)
	{
	}

	function ValidateCameraTeamId ()
	{
	}

	function SpectatorChangeTeams (bool bNextTeam)
	{
	}

	event ClientSetNewViewTarget ()
	{
	}

	simulated function SetNewViewTarget (Actor aViewTarget)
	{
	}

}

function ClientEndSurrended ()
{
	m_bSkipBeginState=False;
	m_pawn.m_eHealth=HEALTH_Healthy;
	m_pawn.m_bIsSurrended=False;
	GotoState('PlayerEndSurrended');
}

state PlayerEndSurrended extends CameraPlayer
{
	function BeginState ()
	{
		if ( m_bSkipBeginState )
		{
			m_bSkipBeginState=False;
			return;
		}
		m_fStartSurrenderTime=Level.TimeSeconds;
		m_pawn.bInvulnerableBody=True;
		if ( Level.NetMode != 3 )
		{
//			m_pawn.SetNextPendingAction(PENDING_Blinded9);
		}
	}

	function EndState ()
	{
		EndSurrenderSetUp();
		if ( Pawn.IsLocallyControlled() && (m_eCameraMode == 2) )
		{
//			m_eCameraMode=0;
			if (  !CameraIsAvailable() )
			{
				SelectCameraMode(True);
			}
			SetCameraMode();
		}
		m_pawn.m_bPawnSpecificAnimInProgress=False;
		if ( (m_pawn.EngineWeapon != None) &&  !(Pawn.EngineWeapon.IsA('R6GrenadeWeapon') || Pawn.EngineWeapon.IsA('R6HBSSAJammerGadget')) &&  !Pawn.EngineWeapon.HasAmmo() )
		{
			if ( Pawn.EngineWeapon.IsA('R6GrenadeWeapon') || Pawn.EngineWeapon.IsA('R6HBSSAJammerGadget') )
			{
				WeaponUpState();
			}
			Pawn.EngineWeapon.GotoState('BringWeaponUp');
			if ( Level.NetMode != 3 )
			{
//				m_pawn.SetNextPendingAction(PENDING_StopCoughing8);
			}
		}
	}

	event AnimEnd (int iChannel)
	{
/*		if ( iChannel == m_pawn.16 )
		{
			if ( Level.NetMode != 3 )
			{
				m_pawn.SetNextPendingAction(PENDING_OpenDoor1);
			}
			GotoState('PlayerWalking');
		}*/
	}

	function EndSurrenderSetUp ()
	{
		m_pawn.m_bPostureTransition=False;
		if ( Role == Role_Authority )
		{
			m_fStartSurrenderTime=Level.TimeSeconds;
		}
	}

	function SwitchWeapon (byte f)
	{
	}

	function PlayFiring ()
	{
	}

	function AltFiring ()
	{
	}

	function ServerReStartPlayer ()
	{
	}

	exec function Fire (optional float f)
	{
	}

	exec function Say (string Msg)
	{
	}

	exec function TeamSay (string Msg)
	{
	}

	function ValidateCameraTeamId ()
	{
	}

	exec function PreviousMember ()
	{
	}

	exec function NextMember ()
	{
	}

	simulated function ChangeTeams (bool bNextTeam)
	{
	}

	function ServerChangeTeams (bool bNextTeam)
	{
	}

	function SpectatorChangeTeams (bool bNextTeam)
	{
	}

	event ClientSetNewViewTarget ()
	{
	}

	simulated function SetNewViewTarget (Actor aViewTarget)
	{
	}

}

state PlayerSecureRainbow
{
	function BeginState ()
	{
		R6PlayerController(R6Rainbow(m_PlayerCurrentCA.aQueryTarget).Controller).m_fStartSurrenderTime=Level.TimeSeconds;
		if ( m_pawn.EngineWeapon != None )
		{
			if ( Pawn.IsLocallyControlled() )
			{
				ToggleHelmetCameraZoom(True);
				DoZoom(True);
				bZooming=False;
				m_bHelmetCameraOn=False;
				DefaultFOV=Default.DefaultFOV;
				DesiredFOV=Default.DesiredFOV;
				FovAngle=Default.DesiredFOV;
				HelmetCameraZoom(1.00);
				R6Pawn(Pawn).ToggleHeatProperties(False,None,None);
				R6Pawn(Pawn).ToggleNightProperties(False,None,None);
				R6Pawn(Pawn).ToggleScopeProperties(False,None,None);
				Level.m_bHeartBeatOn=False;
				Level.m_bInGamePlanningActive=False;
				SetPlanningMode(False);
			}
			Pawn.EngineWeapon.GotoState('PutWeaponDown');
			if ( Level.NetMode != 3 )
			{
//				m_pawn.SetNextPendingAction(PENDING_StopCoughing7);
			}
		}
//		SetPeekingInfo(PEEK_none,m_pawn.1000.00);
		ResetFluidPeeking();
	}

	function EndState ()
	{
		local R6AbstractGameInfo pGameInfo;
		local string arrestorName;

		if ( m_iPlayerCAProgress < 100 )
		{
//			m_pawn.R6ResetAnimBlendParams(m_pawn.1);
			if ( m_bIsSecuringRainbow && R6Rainbow(m_PlayerCurrentCA.aQueryTarget).m_bIsSurrended )
			{
				R6Rainbow(m_PlayerCurrentCA.aQueryTarget).ResetArrest();
			}
		}
		else
		{
			if ( Level.NetMode != 3 )
			{
				if ( m_bIsSecuringRainbow )
				{
					R6Rainbow(m_PlayerCurrentCA.aQueryTarget).m_bIsBeingArrestedOrFreed=False;
					if ( R6Rainbow(m_PlayerCurrentCA.aQueryTarget).m_bIsSurrended )
					{
						R6Rainbow(m_PlayerCurrentCA.aQueryTarget).m_bIsUnderArrest=True;
						R6AbstractGameInfo(Level.Game).PawnSecure(R6Rainbow(m_PlayerCurrentCA.aQueryTarget));
						m_pawn.IncrementFragCount();
						if ( m_pawn.PlayerReplicationInfo != None )
						{
							arrestorName=m_pawn.PlayerReplicationInfo.PlayerName;
						}
						else
						{
							arrestorName=m_pawn.m_CharacterName;
						}
						pGameInfo=R6AbstractGameInfo(Level.Game);
						if ( pGameInfo != None )
						{
							if ( (pGameInfo.m_bCompilingStats == True) || pGameInfo.m_bGameOver && pGameInfo.m_bGameOverButAllowDeath )
							{
								if ( R6Pawn(m_PlayerCurrentCA.aQueryTarget).PlayerReplicationInfo != None )
								{
									R6Pawn(m_PlayerCurrentCA.aQueryTarget).PlayerReplicationInfo.m_szKillersName=arrestorName;
									R6Pawn(m_PlayerCurrentCA.aQueryTarget).PlayerReplicationInfo.Deaths += 1.00;
									if (  !R6Pawn(m_PlayerCurrentCA.aQueryTarget).m_bSuicided && (R6Pawn(m_PlayerCurrentCA.aQueryTarget).m_KilledBy != None) && (R6Pawn(m_PlayerCurrentCA.aQueryTarget).m_KilledBy.Controller != None) && (R6Pawn(m_PlayerCurrentCA.aQueryTarget).m_KilledBy.Controller.PlayerReplicationInfo != None) )
									{
										R6Pawn(m_PlayerCurrentCA.aQueryTarget).m_KilledBy.Controller.PlayerReplicationInfo.Score += 1.00;
									}
								}
							}
						}
					}
				}
				else
				{
					R6PlayerController(R6Rainbow(m_PlayerCurrentCA.aQueryTarget).Controller).DispatchOrder(m_PlayerCurrentCA.iPlayerActionID,m_pawn);
				}
			}
		}
		m_iPlayerCAProgress=0;
		m_pawn.m_bPostureTransition=False;
		if (  !m_pawn.m_bIsSurrended )
		{
			m_pawn.m_ePlayerIsUsingHands=HANDS_None;
			if ( m_pawn.EngineWeapon != None )
			{
				Pawn.EngineWeapon.GotoState('BringWeaponUp');
				if ( Level.NetMode != 3 )
				{
//					m_pawn.SetNextPendingAction(PENDING_StopCoughing8);
				}
				m_pawn.RainbowEquipWeapon();
			}
		}
	}

	function PlayerMove (float fDeltaTime)
	{
		aForward=0.00;
		aStrafe=0.00;
		aMouseX=0.00;
		aMouseY=0.00;
		aTurn=0.00;
		m_bPeekLeft=0;
		m_bPeekRight=0;
		Global.PlayerMove(fDeltaTime);
	}

	event AnimEnd (int iChannel)
	{
		if ( /*(iChannel == m_pawn.1) &&*/ m_pawn.m_bPostureTransition )
		{
			Log("SecureRainbow: AnimEnd, END Secure/Free rainbow animation, switch playerwalking");
			m_pawn.m_bPostureTransition=False;
//			m_pawn.AnimBlendToAlpha(m_pawn.1,0.00,0.50);
			m_iPlayerCAProgress=100;
			if ( Level.NetMode == NM_DedicatedServer )
			{
				ClientActionProgressDone();
			}
			if ( m_InteractionCA != None )
			{
				m_InteractionCA.ActionProgressDone();
			}
			GotoState('PlayerWalking');
		}
		else
		{
/*			if ( (iChannel == m_pawn.14) && (m_pawn.m_eEquipWeapon == m_pawn.2) )
			{
				Log("SecureRainbow: AnimEnd, start Secure/Free rainbow animation");
				m_pawn.m_bWeaponTransition=False;
				m_pawn.m_bPostureTransition=False;
				m_pawn.PlaySecureTerrorist();
				m_PlayerCurrentCA.aQueryTarget.R6CircumstantialActionProgressStart(m_PlayerCurrentCA);
				m_bIsSecuringRainbow=m_PlayerCurrentCA.iPlayerActionID == m_pawn.1;
				Log("SecureRainbow: AnimEnd, start Secure/Free rainbow animation. CircAction=" $ string(m_PlayerCurrentCA.iPlayerActionID) $ " m_bIsSecuringRainbow=" $ string(m_bIsSecuringRainbow));
				if ( Level.NetMode != 3 )
				{
					m_pawn.SetNextPendingAction(PENDING_StopCoughing9);
					if ( m_PlayerCurrentCA.iPlayerActionID == m_pawn.1 )
					{
						R6PlayerController(R6Rainbow(m_PlayerCurrentCA.aQueryTarget).Controller).DispatchOrder(m_PlayerCurrentCA.iPlayerActionID,m_pawn);
					}
				}
			}   */
		}
	}

	event Tick (float fDeltaTime)
	{
		if ( (m_pawn.EngineWeapon != None) /*&& (m_pawn.m_eEquipWeapon != m_pawn.2)*/ )
		{
			return;
		}
		if (  !m_pawn.m_bPostureTransition )
		{
			return;
		}
		if ( Role == Role_Authority )
		{
			m_iPlayerCAProgress=m_PlayerCurrentCA.aQueryTarget.R6GetCircumstantialActionProgress(m_PlayerCurrentCA,m_pawn);
		}
	}

}

function DispatchOrder (int iOrder, R6Pawn pSource)
{
	switch (iOrder)
	{
/*		case m_pawn.1:
		SecureRainbow(pSource);
		break;
		case m_pawn.2:
		FreeRainbow(pSource);
		break;
		default:
		assert (False);*/
	}
}

function SecureRainbow (R6Pawn pOther)
{
	m_pawn.m_bIsBeingArrestedOrFreed=True;
	m_pInteractingRainbow=pOther;
}

function FreeRainbow (R6Pawn pOther)
{
	m_pInteractingRainbow=pOther;
	m_pawn.SetFree();
}

state PlayerStartArrest extends CameraPlayer
{
	function BeginState ()
	{
		if ( m_bSkipBeginState )
		{
			m_bSkipBeginState=False;
			return;
		}
		if ( Level.NetMode != 3 )
		{
//			m_pawn.SetNextPendingAction(PENDING_Blinded3);
		}
	}

	function EndState ()
	{
		m_pawn.m_bIsBeingArrestedOrFreed=False;
		m_pawn.m_bPawnSpecificAnimInProgress=False;
	}

	function PlayFiring ()
	{
	}

	function AltFiring ()
	{
	}

	function ServerReStartPlayer ()
	{
	}

	exec function ToggleHelmetCameraZoom (optional bool bTurnOff)
	{
	}

	exec function Fire (optional float f)
	{
	}

	exec function Say (string Msg)
	{
	}

	exec function TeamSay (string Msg)
	{
	}

	function SwitchWeapon (byte f)
	{
	}

	event AnimEnd (int iChannel)
	{
		local name Anim;
		local float fFrame;
		local float fRate;

/*		if ( iChannel == m_pawn.16 )
		{
			Pawn.GetAnimParams(m_pawn.16,Anim,fFrame,fRate);
			if ( Anim == 'SurrenderToKneel' )
			{
				if ( Level.NetMode != 3 )
				{
					m_pawn.SetNextPendingAction(PENDING_OpenDoor3);
				}
			}
			else
			{
				GotoState('PlayerArrested');
			}
		}*/
	}

	exec function PreviousMember ()
	{
	}

	exec function NextMember ()
	{
	}

	simulated function ChangeTeams (bool bNextTeam)
	{
	}

	function ServerChangeTeams (bool bNextTeam)
	{
	}

	function ValidateCameraTeamId ()
	{
	}

	function SpectatorChangeTeams (bool bNextTeam)
	{
	}

	event ClientSetNewViewTarget ()
	{
	}

	simulated function SetNewViewTarget (Actor aViewTarget)
	{
	}

}

state PlayerArrested extends CameraPlayer
{
	function BeginState ()
	{
		local string myName;
		local string arrestorName;

		if ( m_bSkipBeginState )
		{
			m_bSkipBeginState=False;
			return;
		}
		if ( m_pawn.PlayerReplicationInfo != None )
		{
			myName=m_pawn.PlayerReplicationInfo.PlayerName;
		}
		else
		{
			myName=m_pawn.m_CharacterName;
		}
		if ( m_pInteractingRainbow != None )
		{
			if ( m_pInteractingRainbow.PlayerReplicationInfo != None )
			{
				arrestorName=m_pInteractingRainbow.PlayerReplicationInfo.PlayerName;
			}
			else
			{
				arrestorName=m_pInteractingRainbow.m_CharacterName;
			}
			myHUD.AddDeathTextMessage(arrestorName $ " " $ Localize("MPMiscMessages","PlayerArrestedPlayer","ASGameMode") $ " " $ myName,Class'LocalMessage');
		}
		if ( Level.NetMode != 3 )
		{
//			m_pawn.SetNextPendingAction(PENDING_OpenDoor4);
		}
	}

	function EndState ()
	{
		m_pawn.m_bPawnSpecificAnimInProgress=False;
	}

	function PlayFiring ()
	{
	}

	function AltFiring ()
	{
	}

	function ServerReStartPlayer ()
	{
	}

	exec function ToggleHelmetCameraZoom (optional bool bTurnOff)
	{
	}

	exec function Fire (optional float f)
	{
	}

	exec function Say (string Msg)
	{
	}

	exec function TeamSay (string Msg)
	{
	}

	function SwitchWeapon (byte f)
	{
	}

	event AnimEnd (int iChannel)
	{
/*		if ( iChannel == m_pawn.16 )
		{
			if ( Level.NetMode != 3 )
			{
				m_pawn.SetNextPendingAction(PENDING_OpenDoor4);
			}
		}*/
	}

	exec function PreviousMember ()
	{
	}

	exec function NextMember ()
	{
	}

	simulated function ChangeTeams (bool bNextTeam)
	{
	}

	function ServerChangeTeams (bool bNextTeam)
	{
	}

	function ValidateCameraTeamId ()
	{
	}

	function SpectatorChangeTeams (bool bNextTeam)
	{
	}

	event ClientSetNewViewTarget ()
	{
	}

	simulated function SetNewViewTarget (Actor aViewTarget)
	{
	}

}

state PlayerSetFree extends CameraPlayer
{
	function BeginState ()
	{
		local string myName;
		local string rescuerName;

		if ( Pawn.IsLocallyControlled() && (m_eCameraMode == 2) )
		{
//			m_eCameraMode=0;
			if (  !CameraIsAvailable() )
			{
				SelectCameraMode(True);
			}
			SetCameraMode();
		}
		if ( m_bSkipBeginState )
		{
			m_bSkipBeginState=False;
			return;
		}
		m_pawn.m_bIsUnderArrest=False;
		m_pawn.m_bIsSurrended=False;
		m_fStartSurrenderTime=Level.TimeSeconds;
		m_pawn.bInvulnerableBody=True;
		if ( Level.NetMode != 3 )
		{
			R6AbstractGameInfo(Level.Game).PawnSecure(m_pawn);
		}
		if ( Level.NetMode != 3 )
		{
//			m_pawn.SetNextPendingAction(PENDING_OpenDoor5);
		}
		if ( m_pawn.PlayerReplicationInfo != None )
		{
			myName=m_pawn.PlayerReplicationInfo.PlayerName;
		}
		else
		{
			myName=m_pawn.m_CharacterName;
		}
		if ( m_pInteractingRainbow != None )
		{
			if ( m_pInteractingRainbow.PlayerReplicationInfo != None )
			{
				rescuerName=m_pInteractingRainbow.PlayerReplicationInfo.PlayerName;
			}
			else
			{
				rescuerName=m_pInteractingRainbow.m_CharacterName;
			}
			myHUD.AddDeathTextMessage(myName $ " " $ Localize("MPMiscMessages","PlayerRescued","ASGameMode") $ " " $ rescuerName,Class'LocalMessage');
		}
	}

	function PlayFiring ()
	{
	}

	function AltFiring ()
	{
	}

	function ServerReStartPlayer ()
	{
	}

	exec function Say (string Msg)
	{
	}

	exec function TeamSay (string Msg)
	{
	}

	exec function ToggleHelmetCameraZoom (optional bool bTurnOff)
	{
	}

	exec function Fire (optional float f)
	{
	}

	function EndState ()
	{
		if ( (m_pawn.EngineWeapon != None) &&  !(Pawn.EngineWeapon.IsA('R6GrenadeWeapon') || Pawn.EngineWeapon.IsA('R6HBSSAJammerGadget')) &&  !Pawn.EngineWeapon.HasAmmo() )
		{
			if ( Pawn.EngineWeapon.IsA('R6GrenadeWeapon') || Pawn.EngineWeapon.IsA('R6HBSSAJammerGadget') )
			{
				WeaponUpState();
			}
			Pawn.EngineWeapon.GotoState('BringWeaponUp');
			if ( Level.NetMode != 3 )
			{
//				m_pawn.SetNextPendingAction(PENDING_StopCoughing8);
			}
		}
		m_fStartSurrenderTime=Level.TimeSeconds;
		m_pawn.m_bPawnSpecificAnimInProgress=False;
		m_pawn.m_bIsBeingArrestedOrFreed=False;
		m_pawn.m_bPostureTransition=False;
	}

	event AnimEnd (int iChannel)
	{
		local name Anim;
		local float fFrame;
		local float fRate;

/*		if ( iChannel == m_pawn.16 )
		{
			Pawn.GetAnimParams(m_pawn.16,Anim,fFrame,fRate);
			if ( Anim == 'KneelArrest' )
			{
				if ( Level.NetMode != 3 )
				{
					m_pawn.SetNextPendingAction(PENDING_OpenDoor2);
				}
			}
			else
			{
				if ( Level.NetMode != 3 )
				{
					m_pawn.SetNextPendingAction(PENDING_OpenDoor1);
				}
				GotoState('PlayerWalking');
			}
		}*/
	}

	function SwitchWeapon (byte f)
	{
	}

	exec function PreviousMember ()
	{
	}

	exec function NextMember ()
	{
	}

	simulated function ChangeTeams (bool bNextTeam)
	{
	}

	function ServerChangeTeams (bool bNextTeam)
	{
	}

	function ValidateCameraTeamId ()
	{
	}

	function SpectatorChangeTeams (bool bNextTeam)
	{
	}

	event ClientSetNewViewTarget ()
	{
	}

	simulated function SetNewViewTarget (Actor aViewTarget)
	{
	}

Begin:
}

simulated function R6PlayerMove (float DeltaTime)
{
	local Vector X;
	local Vector Y;
	local Vector Z;
	local Vector NewAccel;
	local EDoubleClickDir DoubleClickMove;
	local Rotator OldRotation;
	local Rotator ViewRotation;
	local float Speed2D;
	local bool bSaveJump;

	if ( Pawn != None )
	{
		GetAxes(Pawn.Rotation,X,Y,Z);
	}
	NewAccel=aForward * X + aStrafe * Y;
	NewAccel.Z=0.00;
//	DoubleClickMove=getPlayerInput().CheckForDoubleClickMove(DeltaTime);
	GroundPitch=0;
	if ( Pawn != None )
	{
		ViewRotation=Pawn.Rotation;
		SetRotation(ViewRotation);
		OldRotation=Rotation;
		UpdateRotation(DeltaTime,1.00);
	}
	if ( Role < Role_Authority )
	{
		ReplicateMove(DeltaTime,NewAccel,DoubleClickMove,OldRotation - Rotation);
	}
	else
	{
		ProcessMove(DeltaTime,NewAccel,DoubleClickMove,OldRotation - Rotation);
	}
}

function ServerPlayerActionProgress ()
{
	m_PlayerCurrentCA=m_RequestedCircumstantialAction;
	if ( m_PlayerCurrentCA.aQueryTarget.IsA('R6Terrorist') )
	{
		GotoState('PlayerSecureTerrorist');
	}
	else
	{
		if ( Class'Actor'.static.GetModMgr().IsMissionPack() && m_PlayerCurrentCA.aQueryTarget.IsA('R6Rainbow') )
		{
			GotoState('PlayerSecureRainbow');
		}
		else
		{
			GotoState('PlayerActionProgress');
		}
	}
}

function ClientActionProgressDone ()
{
	m_InteractionCA.ActionProgressDone();
}

function ServerActionProgressStop ()
{
	m_RequestedCircumstantialAction.aQueryTarget.R6CircumstantialActionCancel();
	m_iPlayerCAProgress=0;
	if ( Class'Actor'.static.GetModMgr().IsMissionPack() )
	{
		if ( m_pawn.IsAlive() &&  !m_pawn.m_bIsSurrended )
		{
			GotoState('PlayerWalking');
		}
	}
	else
	{
		if ( m_pawn.IsAlive() )
		{
			GotoState('PlayerWalking');
		}
	}
	if ( m_InteractionCA != None )
	{
		m_InteractionCA.ActionProgressStop();
	}
}

state PlayerActionProgress extends PlayerWalking
{
	function BeginState ()
	{
		m_bHideReticule=True;
		m_bDisplayActionProgress=True;
		if ( (Level.NetMode != 0) && (Role == Role_Authority) && m_PlayerCurrentCA.aQueryTarget.IsA('R6IOBomb') )
		{
			if (  !R6IOObject(m_PlayerCurrentCA.aQueryTarget).m_bIsActivated )
			{
//				m_TeamManager.m_MultiCommonVoicesMgr.PlayMultiCommonVoices(m_pawn,4);
			}
			else
			{
//				m_TeamManager.m_MultiCommonVoicesMgr.PlayMultiCommonVoices(m_pawn,6);
			}
		}
		if ( m_pawn.EngineWeapon != None )
		{
			ToggleHelmetCameraZoom(True);
			m_pawn.EngineWeapon.GotoState('PutWeaponDown');
			if ( Level.NetMode != 3 )
			{
//				m_pawn.SetNextPendingAction(PENDING_StopCoughing7);
			}
		}
		else
		{
			StartProgressAction();
		}
		Pawn.Acceleration=vect(0.00,0.00,0.00);
	}

	function LongClientAdjustPosition (float TimeStamp, name NewState, EPhysics newPhysics, float NewLocX, float NewLocY, float NewLocZ, float NewVelX, float NewVelY, float NewVelZ, float NewFloorX, float NewFloorY, float NewFloorZ)
	{
		Super.LongClientAdjustPosition(TimeStamp,'PlayerActionProgress',newPhysics,NewLocX,NewLocY,NewLocZ,NewVelX,NewVelY,NewVelZ,NewFloorX,NewFloorY,NewFloorZ);
	}

	function PlayerMove (float fDeltaTime)
	{
		aForward=0.00;
		aStrafe=0.00;
		aMouseX=0.00;
		aMouseY=0.00;
		aTurn=0.00;
		Global.PlayerMove(fDeltaTime);
	}

	function StartProgressAction ()
	{
		m_PlayerCurrentCA.aQueryTarget.R6CircumstantialActionProgressStart(m_PlayerCurrentCA);
		if ( m_RequestedCircumstantialAction.aQueryTarget.IsA('R6IOObject') )
		{
			m_pawn.m_bInteractingWithDevice=True;
//			m_pawn.m_eDeviceAnim=R6IOObject(m_RequestedCircumstantialAction.aQueryTarget).m_eAnimToPlay;
			if ( Level.NetMode != 3 )
			{
//				m_pawn.SetNextPendingAction(PENDING_Coughing8);
			}
		}
		else
		{
			if ( m_RequestedCircumstantialAction.aQueryTarget.IsA('R6IORotatingDoor') )
			{
				m_pawn.m_bIsLockPicking=True;
				if ( Level.NetMode != 3 )
				{
//					m_pawn.SetNextPendingAction(PENDING_Coughing9);
				}
			}
		}
	}

	event AnimEnd (int iChannel)
	{
/*		if ( (iChannel == m_pawn.14) && (m_pawn.m_eEquipWeapon == m_pawn.2) )
		{
			m_pawn.m_bWeaponTransition=False;
			StartProgressAction();
		}*/
	}

	function EndState ()
	{
		m_bDisplayActionProgress=False;
		if ( m_pawn != None )
		{
			m_pawn.m_bPostureTransition=False;
			m_pawn.m_bIsLockPicking=False;
			m_pawn.m_bInteractingWithDevice=False;
			m_pawn.m_ePlayerIsUsingHands=HANDS_None;
			if ( (m_pawn.EngineWeapon != None) &&  !m_pawn.m_bIsSurrended )
			{
				m_pawn.EngineWeapon.GotoState('BringWeaponUp');
				if ( Level.NetMode != 3 )
				{
//					m_pawn.SetNextPendingAction(PENDING_StopCoughing8);
				}
			}
			if ( (Role == Role_Authority) &&  !m_pawn.IsAlive() && (m_iPlayerCAProgress < 105) )
			{
				m_RequestedCircumstantialAction.aQueryTarget.R6CircumstantialActionCancel();
			}
		}
		m_iPlayerCAProgress=0;
	}

	event Tick (float fDeltaTime)
	{
		if ( (m_pawn.EngineWeapon != None) /*&& (m_pawn.m_eEquipWeapon != m_pawn.2)*/ )
		{
			return;
		}
		if (  !m_pawn.m_bIsLockPicking &&  !m_pawn.m_bInteractingWithDevice )
		{
			return;
		}
		if ( Role == Role_Authority )
		{
			if ( m_PlayerCurrentCA == None )
			{
				m_iPlayerCAProgress=0;
			}
			else
			{
				if ( m_PlayerCurrentCA.aQueryTarget == None )
				{
					m_iPlayerCAProgress=0;
				}
				else
				{
					m_iPlayerCAProgress=m_PlayerCurrentCA.aQueryTarget.R6GetCircumstantialActionProgress(m_PlayerCurrentCA,m_pawn);
				}
			}
			if ( m_iPlayerCAProgress >= 105 )
			{
				m_iPlayerCAProgress=0;
				if ( (Level.NetMode != 0) && (Level.NetMode != 3) )
				{
					ClientActionProgressDone();
				}
				if ( m_InteractionCA != None )
				{
					m_InteractionCA.ActionProgressDone();
				}
				GotoState('PlayerWalking');
			}
		}
	}

}

state PlayerSecureTerrorist extends PlayerWalking
{
	function BeginState ()
	{
		m_bHideReticule=True;
		m_bDisplayActionProgress=True;
		if ( m_pawn.EngineWeapon != None )
		{
			ToggleHelmetCameraZoom(True);
			Pawn.EngineWeapon.GotoState('PutWeaponDown');
			if ( Level.NetMode != 3 )
			{
//				m_pawn.SetNextPendingAction(PENDING_StopCoughing7);
			}
		}
//		SetPeekingInfo(PEEK_none,m_pawn.1000.00);
		ResetFluidPeeking();
	}

	function EndState ()
	{
		m_bDisplayActionProgress=False;
		if ( m_iPlayerCAProgress < 100 )
		{
//			m_pawn.R6ResetAnimBlendParams(m_pawn.1);
			if ( Role == Role_Authority )
			{
				R6Terrorist(m_PlayerCurrentCA.aQueryTarget).ResetArrest();
			}
		}
		m_pawn.m_bPostureTransition=False;
		m_iPlayerCAProgress=0;
		m_pawn.m_ePlayerIsUsingHands=HANDS_None;
		if ( m_pawn.EngineWeapon != None )
		{
			Pawn.EngineWeapon.GotoState('BringWeaponUp');
			if ( Level.NetMode != 3 )
			{
//				m_pawn.SetNextPendingAction(PENDING_StopCoughing8);
			}
		}
	}

	function PlayerMove (float fDeltaTime)
	{
		aForward=0.00;
		aStrafe=0.00;
		aMouseX=0.00;
		aMouseY=0.00;
		aTurn=0.00;
		m_bPeekLeft=0;
		m_bPeekRight=0;
		Global.PlayerMove(fDeltaTime);
	}

	function LongClientAdjustPosition (float TimeStamp, name NewState, EPhysics newPhysics, float NewLocX, float NewLocY, float NewLocZ, float NewVelX, float NewVelY, float NewVelZ, float NewFloorX, float NewFloorY, float NewFloorZ)
	{
		Super.LongClientAdjustPosition(TimeStamp,'PlayerSecureTerrorist',newPhysics,NewLocX,NewLocY,NewLocZ,NewVelX,NewVelY,NewVelZ,NewFloorX,NewFloorY,NewFloorZ);
	}

	event AnimEnd (int iChannel)
	{
		if ( /*(iChannel == m_pawn.1) &&*/ m_pawn.m_bPostureTransition )
		{
			m_pawn.m_bPostureTransition=False;
//			m_pawn.AnimBlendToAlpha(m_pawn.1,0.00,0.50);
			m_iPlayerCAProgress=100;
			if ( Level.NetMode == NM_DedicatedServer )
			{
				ClientActionProgressDone();
			}
			if ( m_InteractionCA != None )
			{
				m_InteractionCA.ActionProgressDone();
			}
			GotoState('PlayerWalking');
		}
		else
		{
/*			if ( (iChannel == m_pawn.14) && (m_pawn.m_eEquipWeapon == m_pawn.2) )
			{
				m_pawn.m_bWeaponTransition=False;
				m_pawn.m_bPostureTransition=False;
				m_pawn.PlaySecureTerrorist();
				m_PlayerCurrentCA.aQueryTarget.R6CircumstantialActionProgressStart(m_PlayerCurrentCA);
				if ( Level.NetMode != 3 )
				{
					m_pawn.SetNextPendingAction(PENDING_StopCoughing9);
					R6Terrorist(m_PlayerCurrentCA.aQueryTarget).m_controller.DispatchOrder(m_PlayerCurrentCA.iPlayerActionID,m_pawn);
				}
			} */
		}
	}

	event Tick (float fDeltaTime)
	{
		if ( (m_pawn.EngineWeapon != None) /*&& (m_pawn.m_eEquipWeapon != m_pawn.2)*/ )
		{
			return;
		}
		if (  !m_pawn.m_bPostureTransition )
		{
			return;
		}
		if ( Role == Role_Authority )
		{
			m_iPlayerCAProgress=m_PlayerCurrentCA.aQueryTarget.R6GetCircumstantialActionProgress(m_PlayerCurrentCA,m_pawn);
		}
	}

}

state PlayerSetExplosive extends PlayerWalking
{
	function PlayerMove (float fDeltaTime)
	{
		aForward=0.00;
		aStrafe=0.00;
		aMouseX=0.00;
		aMouseY=0.00;
		aTurn=0.00;
		Global.PlayerMove(fDeltaTime);
	}

	function BeginState ()
	{
		Pawn.Acceleration=vect(0.00,0.00,0.00);
		m_iPlayerCAProgress=0;
		m_bPlacedExplosive=False;
	}

	function EndState ()
	{
		m_iPlayerCAProgress=0;
		m_pawn.m_bPostureTransition=False;
	}

	event AnimEnd (int iChannel)
	{
/*		if ( iChannel == m_pawn.1 )
		{
			if ( m_pawn.IsAlive() )
			{
				GotoState('PlayerWalking');
			}
		}  */
	}

	function int GetActionProgress ()
	{
		local name Anim;
		local float fFrame;
		local float fRate;

//		Pawn.GetAnimParams(m_pawn.1,Anim,fFrame,fRate);
		Clamp(fFrame,0,100);
		return fFrame * 110;
	}

	event Tick (float fDeltaTime)
	{
		m_iPlayerCAProgress=GetActionProgress();
		if ( m_iPlayerCAProgress > 75 )
		{
			m_bPlacedExplosive=True;
		}
	}

}

state PreBeginClimbingLadder
{
	function BeginState ()
	{
		ToggleHelmetCameraZoom(True);
		RaisePosture();
//		SetPeekingInfo(PEEK_none,m_pawn.1000.00);
		ResetFluidPeeking();
		if ( (Pawn.EngineWeapon != None) &&  !Pawn.EngineWeapon.IsA('R6GrenadeWeapon') &&  !Pawn.EngineWeapon.HasAmmo() )
		{
			DoZoom(True);
			Pawn.EngineWeapon.GotoState('PutWeaponDown');
			if ( Level.NetMode != 3 )
			{
//				m_pawn.SetNextPendingAction(PENDING_StopCoughing7);
			}
			m_pawn.RainbowSecureWeapon();
		}
		else
		{
			m_bSkipBeginState=False;
			GotoState('PlayerBeginClimbingLadder');
			if ( Level.NetMode == NM_Client )
			{
				ServerStartClimbingLadder();
			}
		}
		if ( Level.NetMode != 3 )
		{
			if ( (m_pawn.m_Ladder == None) || (m_pawn.OnLadder == None) )
			{
				ExtractMissingLadderInformation();
			}
			R6LadderVolume(m_pawn.OnLadder).EnableCollisions(m_pawn.m_Ladder);
		}
	}

	function EndState ()
	{
		m_pawn.m_bWeaponTransition=False;
	}

	function PlayFiring ()
	{
	}

	function AltFiring ()
	{
	}

	function ServerReStartPlayer ()
	{
	}

	exec function ToggleHelmetCameraZoom (optional bool bTurnOff)
	{
	}

	exec function Fire (optional float f)
	{
	}

	event AnimEnd (int iChannel)
	{
		if ( (Level.NetMode != 1) /*&& (iChannel == m_pawn.14)*/ )
		{
			m_bSkipBeginState=False;
			GotoState('PlayerBeginClimbingLadder');
			if ( Level.NetMode == NM_Client )
			{
				ServerStartClimbingLadder();
			}
		}
		else
		{
			m_pawn.AnimEnd(iChannel);
		}
	}

	function SwitchWeapon (byte f)
	{
	}

	function PlayerMove (float DeltaTime)
	{
		Pawn.Acceleration=vect(0.00,0.00,0.00);
		aForward=0.00;
		aStrafe=0.00;
		aTurn=0.00;
		bRun=0;
		m_bPeekLeft=0;
		m_bPeekRight=0;
		if ( Role < Role_Authority )
		{
			ReplicateMove(DeltaTime,vect(0.00,0.00,0.00),DCLICK_None,rot(0,0,0));
		}
		else
		{
			ProcessMove(DeltaTime,vect(0.00,0.00,0.00),DCLICK_None,rot(0,0,0));
		}
	}

}

function ServerStartClimbingLadder ()
{
	m_bSkipBeginState=False;
	GotoState('PlayerBeginClimbingLadder');
}

function ExtractMissingLadderInformation ()
{
	if ( (m_pawn.m_Ladder == None) && (Pawn.OnLadder != None) )
	{
		m_pawn.m_Ladder=R6Ladder(m_pawn.LocateLadderActor(Pawn.OnLadder));
		return;
	}
	if ( (Pawn.OnLadder == None) && (m_pawn.m_Ladder != None) )
	{
		Pawn.OnLadder=m_pawn.m_Ladder.MyLadder;
	}
}

state PlayerBeginClimbingLadder
{
	function BeginState ()
	{
		if ( (m_pawn.m_Ladder == None) || (m_pawn.OnLadder == None) )
		{
			ExtractMissingLadderInformation();
		}
		if ( m_pawn.m_Ladder.m_bIsTopOfLadder )
		{
			Pawn.SetRotation(Pawn.OnLadder.LadderList.Rotation + rot(0,32768,0));
		}
		else
		{
			Pawn.SetRotation(Pawn.OnLadder.LadderList.Rotation);
		}
		if ( m_bSkipBeginState )
		{
			m_bSkipBeginState=False;
			return;
		}
		if ( m_TeamManager != None )
		{
			m_TeamManager.TeamLeaderIsClimbingLadder();
		}
		m_bHideReticule=True;
		m_pawn.m_bIsClimbingLadder=True;
		Pawn.LockRootMotion(1,True);
		if ( Level.NetMode != 3 )
		{
//			m_pawn.SetNextPendingAction(PENDING_StartClimbingLadder);
		}
		m_pawn.PlayStartClimbing();
		if ( m_pawn.m_Ladder.m_bIsTopOfLadder )
		{
			Pawn.SetRotation(Pawn.OnLadder.LadderList.Rotation + rot(0,32768,0));
		}
		else
		{
			Pawn.SetRotation(Pawn.OnLadder.LadderList.Rotation);
		}
	}

	function EndState ()
	{
		if ( m_pawn.OnLadder != None )
		{
			if ( Pawn.Rotation != Pawn.OnLadder.LadderList.Rotation )
			{
				Pawn.SetRotation(Pawn.OnLadder.LadderList.Rotation);
			}
			if ( Level.NetMode != 3 )
			{
				R6LadderVolume(m_pawn.OnLadder).DisableCollisions(m_pawn.m_Ladder);
			}
		}
		m_pawn.m_bPostureTransition=False;
	}

	event AnimEnd (int iChannel)
	{
		if ( iChannel == 0 )
		{
			if ( Level.NetMode != 3 )
			{
//				m_pawn.SetNextPendingAction(PENDING_PostStartClimbingLadder);
			}
			m_pawn.PlayPostStartLadder();
			Pawn.SetRotation(Pawn.OnLadder.LadderList.Rotation);
			SetRotation(Pawn.OnLadder.LadderList.Rotation);
			GotoState('PlayerClimbing');
		}
	}

	function PlayerMove (float DeltaTime)
	{
		aForward=0.00;
		aStrafe=0.00;
		aTurn=0.00;
		R6PlayerMove(DeltaTime);
	}

}

state PlayerClimbing
{
	function bool NotifyPhysicsVolumeChange (PhysicsVolume NewVolume)
	{
		return False;
	}

	function PlayerMove (float DeltaTime)
	{
		if (  !m_bLockWeaponActions && (m_pawn.EngineWeapon != None) )
		{
			m_pawn.EngineWeapon.GotoState('PutWeaponDown');
		}
		if ( WindowConsole(Player.Console).ConsoleState == 'UWindow' )
		{
			if ( Role < Role_Authority )
			{
				ReplicateMove(DeltaTime,vect(0.00,0.00,0.00),DCLICK_None,rot(0,0,0));
			}
			else
			{
				ProcessMove(DeltaTime,vect(0.00,0.00,0.00),DCLICK_None,rot(0,0,0));
			}
		}
		else
		{
			Super.PlayerMove(DeltaTime);
		}
	}

}

state PlayerEndClimbingLadder
{
	function BeginState ()
	{
		if ( m_bSkipBeginState )
		{
			m_bSkipBeginState=False;
			return;
		}
		if ( m_pawn.m_Ladder.m_bIsTopOfLadder ||  !m_pawn.EndOfLadderSlide() )
		{
			Pawn.LockRootMotion(1,True);
			if ( Level.NetMode != 3 )
			{
//				m_pawn.SetNextPendingAction(PENDING_EndClimbingLadder);
			}
			m_pawn.PlayEndClimbing();
		}
		else
		{
			if ( Level.NetMode != 3 )
			{
//				m_pawn.SetNextPendingAction(PENDING_EndClimbingLadder);
			}
			m_pawn.PlayEndClimbing();
		}
	}

	function EndState ()
	{
		m_pawn.m_bSlideEnd=False;
		if ( m_pawn.m_bIsClimbingLadder )
		{
			EndClimbingSetUp();
		}
		if ( Class'Actor'.static.GetModMgr().IsMissionPack() )
		{
			if (  !m_pawn.m_bIsSurrended && (m_pawn.EngineWeapon != None) &&  !Pawn.EngineWeapon.IsA('R6GrenadeWeapon') &&  !Pawn.EngineWeapon.HasAmmo() )
			{
				Pawn.EngineWeapon.GotoState('BringWeaponUp');
				if ( Level.NetMode != 3 )
				{
//					m_pawn.SetNextPendingAction(PENDING_StopCoughing8);
				}
			}
		}
		else
		{
			if ( (m_pawn.EngineWeapon != None) &&  !Pawn.EngineWeapon.IsA('R6GrenadeWeapon') &&  !Pawn.EngineWeapon.HasAmmo() )
			{
				Pawn.EngineWeapon.GotoState('BringWeaponUp');
				if ( Level.NetMode != 3 )
				{
//					m_pawn.SetNextPendingAction(PENDING_StopCoughing8);
				}
			}
		}
	}

	event AnimEnd (int iChannel)
	{
		if ( (iChannel == 0) /*|| (iChannel == m_pawn.1)*/ )
		{
			if ( iChannel == 0 )
			{
				if ( m_pawn.m_Ladder.m_bIsTopOfLadder )
				{
					if ( Level.NetMode != 3 )
					{
//						m_pawn.SetNextPendingAction(PENDING_PostEndClimbingLadder);
					}
					m_pawn.PlayPostEndLadder();
					Pawn.SetLocation(Pawn.Location + 20 * vector(Pawn.Rotation));
				}
				else
				{
					if (  !m_pawn.m_bSlideEnd )
					{
						if ( Level.NetMode != 3 )
						{
//							m_pawn.SetNextPendingAction(PENDING_PostEndClimbingLadder);
						}
						m_pawn.PlayPostEndLadder();
						Pawn.SetLocation(Pawn.Location + 25 * vector(Pawn.Rotation));
					}
				}
			}
			EndClimbingSetUp();
			GotoState('PlayerWalking');
		}
	}

	function EndClimbingSetUp ()
	{
		Pawn.SetPhysics(PHYS_Walking);
		Pawn.OnLadder=None;
		m_pawn.m_bIsClimbingLadder=False;
		m_pawn.m_bPostureTransition=False;
		if ( m_TeamManager != None )
		{
			m_TeamManager.MemberFinishedClimbingLadder(m_pawn);
		}
	}

	function PlayerMove (float DeltaTime)
	{
		aForward=0.00;
		aStrafe=0.00;
		aTurn=0.00;
		R6PlayerMove(DeltaTime);
	}

}

simulated function ResetBlur ()
{
	local Canvas C;

	m_fBlurReturnTime=0.00;
	C=Class'Actor'.static.GetCanvas();
	if ( C != None )
	{
		C.SetMotionBlurIntensity(0);
	}
}

function Blur (int iValue)
{
	if ( Pawn != None )
	{
		iValue=Clamp(iValue,0,100);
		Pawn.m_fBlurValue=iValue * 2.35;
	}
}

function HelmetCameraZoom (float fZoomLevel)
{
	DefaultFOV=Default.DesiredFOV / fZoomLevel;
	DesiredFOV=DefaultFOV;
	m_bHelmetCameraOn=fZoomLevel != 1;
	if ( Level.NetMode == NM_Client )
	{
		ServerSetHelmetParams(fZoomLevel,m_bScopeZoom);
	}
}

function ServerSetHelmetParams (float fZoomLevel, bool bScopeZoom)
{
	if ( (m_pawn != None) &&  !m_pawn.IsAlive() )
	{
		return;
	}
	m_bHelmetCameraOn=fZoomLevel != 1;
	if ( fZoomLevel > 2.00 )
	{
		m_bSniperMode=m_bHelmetCameraOn;
	}
	m_bScopeZoom=bScopeZoom;
}

function ToggleHelmetCameraZoom (optional bool bTurnOff)
{
	if ( (bTurnOff == False) && m_bLockWeaponActions )
	{
		return;
	}
	if ( (Pawn.EngineWeapon != None) && (Pawn.EngineWeapon.HasScope() == True) && (m_bSniperMode == False) && (bTurnOff == False) )
	{
		Pawn.EngineWeapon.GotoState('ZoomIn');
	}
	else
	{
		DoZoom(bTurnOff);
	}
}

function DoZoom (optional bool bTurnOff)
{
	if ( (Pawn == None) || (Pawn.EngineWeapon == None) )
	{
		return;
	}
	if ( m_bHelmetCameraOn )
	{
		if ( (Pawn.EngineWeapon.IsSniperRifle() == True) && (m_bScopeZoom == False) && (bTurnOff == False) )
		{
			m_bScopeZoom=True;
			Pawn.EngineWeapon.WeaponZoomSound(False);
			HelmetCameraZoom(Pawn.EngineWeapon.m_fMaxZoom);
			m_pawn.m_fWeaponJump=Pawn.EngineWeapon.GetWeaponJump() / 2;
			m_pawn.m_fZoomJumpReturn=0.20;
		}
		else
		{
			if ( Pawn.EngineWeapon.HasScope() == True )
			{
				Pawn.EngineWeapon.GotoState('ZoomOut');
				m_bScopeZoom=False;
			}
			m_bSniperMode=False;
			m_bUseFirstPersonWeapon=True;
			R6Pawn(Pawn).ToggleScopeVision();
			HelmetCameraZoom(1.00);
			m_pawn.m_fWeaponJump=Pawn.EngineWeapon.GetWeaponJump();
			m_pawn.m_fZoomJumpReturn=1.00;
		}
	}
	else
	{
		if ( bTurnOff == True )
		{
			return;
		}
		R6Pawn(Pawn).ToggleScopeVision();
		if ( Pawn.EngineWeapon.IsSniperRifle() == True )
		{
			HelmetCameraZoom(3.50);
			m_bUseFirstPersonWeapon=False;
			m_bSniperMode=True;
			m_pawn.m_fWeaponJump=Pawn.EngineWeapon.GetWeaponJump() / 1.50;
			m_pawn.m_fZoomJumpReturn=0.50;
		}
		else
		{
			if ( Pawn.EngineWeapon.m_ScopeTexture != None )
			{
				m_bSniperMode=True;
				m_bUseFirstPersonWeapon=False;
				m_pawn.m_fWeaponJump=Pawn.EngineWeapon.GetWeaponJump() / 1.50;
				m_pawn.m_fZoomJumpReturn=0.50;
			}
			HelmetCameraZoom(Pawn.EngineWeapon.m_fMaxZoom);
		}
	}
}

event float GetZoomMultiplyFactor (float fWeaponMaxZoom)
{
	if ( (Pawn != None) && (Pawn.EngineWeapon.IsSniperRifle() == True) )
	{
		if ( m_bHelmetCameraOn == True )
		{
			if ( m_bScopeZoom == True )
			{
				return fWeaponMaxZoom * 0.50;
			}
			else
			{
				return fWeaponMaxZoom * 0.25;
			}
		}
	}
	else
	{
		if ( m_bHelmetCameraOn == True )
		{
			return fWeaponMaxZoom * 0.50;
		}
	}
	return 1.00;
}

function ShakeView (float fWaveTime, float fRollMax, Vector vImpactDirection, float fRollSpeed, Vector vPositionOffset, float fReturnTime)
{
	local Vector vRotationX;
	local Vector vRotationY;
	local Vector vRotationZ;
	local float fCosValue;
	local float fCosValueRoll;
	local float fAngle;
	local int iPitchOrientation;
	local int iRollOrientation;

	if ( (vImpactDirection.X == 0) && (vImpactDirection.Y == 0) )
	{
		return;
	}
	ShakeRollTime=fWaveTime + m_pawn.m_fStunShakeTime;
	if ( m_fShakeReturnTime < fReturnTime )
	{
		m_fShakeReturnTime=fReturnTime;
	}
	if ( MaxShakeRoll < fRollMax )
	{
		MaxShakeRoll=fRollMax;
	}
	GetAxes(Rotation,vRotationX,vRotationY,vRotationZ);
	vRotationX.Z=0.00;
	vRotationX=Normal(vRotationX);
	vRotationY.Z=0.00;
	vRotationY=Normal(vRotationY);
	MaxShakeOffset= -vImpactDirection;
	MaxShakeOffset.Z=0.00;
	MaxShakeOffset=Normal(MaxShakeOffset);
	iPitchOrientation=1;
	fCosValue=MaxShakeOffset Dot vRotationX;
	if ( fCosValue < 0 )
	{
		iPitchOrientation=-1;
	}
	iRollOrientation=1;
	fCosValueRoll=MaxShakeOffset Dot vRotationY;
	if ( fCosValueRoll > 0 )
	{
		iRollOrientation=-1;
	}
	MaxShakeOffset.X=fCosValue * fCosValue * iPitchOrientation;
	MaxShakeOffset.Z=(1.00 - Abs(MaxShakeOffset.X)) * iRollOrientation;
	ShakeRollRate=fRollSpeed;
	ShakeOffsetRate=vPositionOffset;
}

function CancelShake ()
{
	ShakeRollTime=0.00;
	ShakeRollRate=0.00;
	MaxShakeRoll=0.00;
	m_fShakeReturnTime=0.00;
	ShakeOffsetRate=vect(0.00,0.00,0.00);
	m_vNewReturnValue=vect(0.00,0.00,0.00);
}

function ResetPlayerVisualEffects ()
{
	ToggleHelmetCameraZoom(True);
	if ( (m_pawn != None) && m_pawn.m_bActivateNightVision )
	{
		m_pawn.ToggleNightVision();
	}
	CancelShake();
	ResetBlur();
}

function R6ViewShake (float fDeltaTime, out Rotator rRotationOffset)
{
	local Rotator rOriginalFiringDirection;
	local int iYawDifference;
	local float fJumpByStance;
	local float fStanceDeltaTime;

	if ( ShakeRollTime > 0 )
	{
		ShakeRollTime -= fDeltaTime;
		if ( ShakeRollTime < 0 )
		{
			ShakeRollTime=0.00;
		}
	}
	if ( (MaxShakeRoll != 0) && (Abs(m_rTotalShake.Pitch) < MaxShakeRoll) && (Abs(m_rTotalShake.Yaw) < MaxShakeRoll) && (Abs(m_rTotalShake.Roll) < MaxShakeRoll) )
	{
		m_rCurrentShakeRotation.Pitch=ShakeRollRate * fDeltaTime * MaxShakeOffset.X;
		m_rTotalShake.Pitch += m_rCurrentShakeRotation.Pitch;
		m_rCurrentShakeRotation.Yaw=ShakeRollRate * fDeltaTime * MaxShakeOffset.Y;
		m_rTotalShake.Yaw += m_rCurrentShakeRotation.Yaw;
		m_rCurrentShakeRotation.Roll=ShakeRollRate * fDeltaTime * MaxShakeOffset.Z;
		m_rTotalShake.Roll += m_rCurrentShakeRotation.Roll;
	}
	else
	{
		if ( ShakeRollTime != 0 )
		{
			MaxShakeOffset.X=FRand();
			MaxShakeOffset.Y=FRand();
			MaxShakeOffset.Z=FRand();
			if ( Abs(m_rTotalShake.Pitch) >= MaxShakeRoll )
			{
				if ( m_rTotalShake.Pitch > 0 )
				{
					m_rTotalShake.Pitch=MaxShakeRoll - 1;
					MaxShakeOffset.X= -MaxShakeOffset.X;
				}
				else
				{
					m_rTotalShake.Pitch= -MaxShakeRoll + 1;
				}
			}
			else
			{
				if ( FRand() < 0.50 )
				{
					MaxShakeOffset.X= -MaxShakeOffset.X;
				}
			}
			if ( Abs(m_rTotalShake.Yaw) >= MaxShakeRoll )
			{
				if ( m_rTotalShake.Yaw > 0 )
				{
					m_rTotalShake.Yaw=MaxShakeRoll - 1;
					MaxShakeOffset.Y= -MaxShakeOffset.Y;
				}
				else
				{
					m_rTotalShake.Yaw= -MaxShakeRoll + 1;
				}
			}
			else
			{
				if ( FRand() < 0.50 )
				{
					MaxShakeOffset.Y= -MaxShakeOffset.Y;
				}
			}
			if ( Abs(m_rTotalShake.Roll) >= MaxShakeRoll )
			{
				if ( m_rTotalShake.Roll > 0 )
				{
					m_rTotalShake.Roll=MaxShakeRoll - 1;
					MaxShakeOffset.Z= -MaxShakeOffset.Z;
				}
				else
				{
					m_rTotalShake.Roll= -MaxShakeRoll + 1;
				}
			}
			else
			{
				if ( FRand() < 0.50 )
				{
					MaxShakeOffset.Z= -MaxShakeOffset.Z;
				}
			}
			m_rCurrentShakeRotation.Pitch=ShakeRollRate * fDeltaTime * MaxShakeOffset.X;
			m_rTotalShake.Pitch += m_rCurrentShakeRotation.Pitch;
			m_rCurrentShakeRotation.Yaw=ShakeRollRate * fDeltaTime * MaxShakeOffset.Y;
			m_rTotalShake.Yaw += m_rCurrentShakeRotation.Yaw;
			m_rCurrentShakeRotation.Roll=ShakeRollRate * fDeltaTime * MaxShakeOffset.Z;
			m_rTotalShake.Roll += m_rCurrentShakeRotation.Roll;
		}
		else
		{
			if ( MaxShakeRoll != 0 )
			{
				MaxShakeRoll=0.00;
				MaxShakeOffset.X= -m_rTotalShake.Pitch / m_fShakeReturnTime;
				MaxShakeOffset.Y= -m_rTotalShake.Yaw / m_fShakeReturnTime;
				MaxShakeOffset.Z= -m_rTotalShake.Roll / m_fShakeReturnTime;
			}
			if ( m_fShakeReturnTime <= 0 )
			{
				m_rCurrentShakeRotation.Pitch=0;
				m_rCurrentShakeRotation.Yaw=0;
				m_rCurrentShakeRotation.Roll=0;
				m_rTotalShake.Pitch=0;
				m_rTotalShake.Yaw=0;
				m_rTotalShake.Roll=0;
			}
			else
			{
				m_fShakeReturnTime -= fDeltaTime;
				m_rCurrentShakeRotation.Pitch=fDeltaTime * MaxShakeOffset.X;
				m_rCurrentShakeRotation.Yaw=fDeltaTime * MaxShakeOffset.Y;
				m_rCurrentShakeRotation.Roll=fDeltaTime * MaxShakeOffset.Z;
			}
		}
	}
	if ( m_vNewReturnValue != vect(0.00,0.00,0.00) )
	{
		if ( m_rLastBulletDirection != rot(0,0,0) )
		{
			fJumpByStance=-1.00 * m_pawn.m_fWeaponJump * m_pawn.GetStanceJumpModifier();
			fJumpByStance *= m_fDesignerJumpFactor;
			m_rCurrentShakeRotation.Pitch=fJumpByStance * 50.00;
			if ( m_rCurrentShakeRotation.Pitch > -250 )
			{
				m_rCurrentShakeRotation.Pitch=-250;
			}
			if ( m_rLastBulletDirection.Yaw < 0 )
			{
				m_rCurrentShakeRotation.Yaw=Clamp(m_rLastBulletDirection.Yaw,-1570,-140);
			}
			else
			{
				m_rCurrentShakeRotation.Yaw=Clamp(m_rLastBulletDirection.Yaw,140,1570);
			}
			m_vNewReturnValue.X=m_rCurrentShakeRotation.Pitch;
			m_vNewReturnValue.Y=m_rCurrentShakeRotation.Yaw;
			if ( Abs(m_vNewReturnValue.X) > Abs(m_vNewReturnValue.Y) )
			{
				m_iPitchReturn=m_iReturnSpeed;
				m_iYawReturn=Abs(m_vNewReturnValue.Y) * m_iReturnSpeed / Abs(m_vNewReturnValue.X);
			}
			else
			{
				m_iPitchReturn=Abs(m_vNewReturnValue.X * m_iReturnSpeed / m_vNewReturnValue.Y);
				m_iYawReturn=m_iReturnSpeed;
			}
			m_iPitchReturn *= m_fDesignerSpeedFactor;
			m_iYawReturn *= m_fDesignerSpeedFactor;
			if ( m_vNewReturnValue.Y > 0 )
			{
				m_iYawReturn *= -1;
			}
			m_rLastBulletDirection=rot(0,0,0);
			m_vNewReturnValue.Z=0.00;
		}
		else
		{
			fStanceDeltaTime=m_pawn.GetStanceReticuleModifier() * m_pawn.m_fZoomJumpReturn * fDeltaTime;
			if ( Abs(m_vNewReturnValue.X) > m_iPitchReturn * fStanceDeltaTime )
			{
				m_vNewReturnValue.X += m_iPitchReturn * fStanceDeltaTime;
				m_rCurrentShakeRotation.Pitch += m_iPitchReturn * fStanceDeltaTime;
				m_vNewReturnValue.Y += m_iYawReturn * fStanceDeltaTime;
				m_rCurrentShakeRotation.Yaw += m_iYawReturn * fStanceDeltaTime;
			}
			else
			{
				m_rCurrentShakeRotation.Pitch -= m_vNewReturnValue.X;
				m_vNewReturnValue=vect(0.00,0.00,0.00);
			}
		}
	}
	rRotationOffset -= m_rCurrentShakeRotation;
	if ( (rRotationOffset.Pitch > 16384) && (rRotationOffset.Pitch < 32000) )
	{
		rRotationOffset.Pitch=16384;
	}
}

simulated function ClientForceUnlockWeapon ()
{
	m_bLockWeaponActions=False;
}

function ResetCameraShake ()
{
	m_vNewReturnValue=vect(0.00,0.00,0.00);
}

function R6ClientWeaponShake ()
{
	m_vNewReturnValue.Z=1.00;
}

function R6WeaponShake ()
{
	R6ClientWeaponShake();
}

simulated function R6DamageAttitudeTo (Pawn Other, eKillResult eKillResultFromTable, eStunResult eStunFromTable, Vector vBulletMomentum)
{
	if ( (eKillResultFromTable != 3) && (eKillResultFromTable != 2) )
	{
		if ( eStunFromTable == 0 )
		{
			if ( bShowLog )
			{
				Log("Hit");
			}
			m_iShakeBlurIntensity=m_stImpactHit.iBlurIntensity;
			m_fBlurReturnTime=m_stImpactHit.fReturnTime;
		}
		else
		{
			if ( eStunFromTable == 1 )
			{
				if ( bShowLog )
				{
					Log("Stunned");
				}
				m_iShakeBlurIntensity=m_stImpactStun.iBlurIntensity;
				m_fBlurReturnTime=m_stImpactStun.fReturnTime;
			}
			else
			{
				if ( eStunFromTable == 2 )
				{
					if ( bShowLog )
					{
						Log("Dazed");
					}
					m_iShakeBlurIntensity=m_stImpactDazed.iBlurIntensity;
					m_fBlurReturnTime=m_stImpactDazed.fReturnTime;
				}
				else
				{
					if ( eStunFromTable == 3 )
					{
						if ( bShowLog )
						{
							Log("KO");
						}
						m_iShakeBlurIntensity=m_stImpactKO.iBlurIntensity;
						m_fBlurReturnTime=m_stImpactKO.fReturnTime;
					}
				}
			}
		}
		m_fTimedBlurValue=m_iShakeBlurIntensity;
	}
}

event bool NotifyLanded (Vector HitNormal)
{
	return False;
}

function PawnDied ()
{
	StopZoom();
	if ( Pawn != None )
	{
		Pawn.RemoteRole=ROLE_SimulatedProxy;
		m_iTeamId=Pawn.m_iTeam;
		m_bPlayDeathMusic= !m_bPlayDeathMusic;
		if ( m_bPlayDeathMusic )
		{
			ClientPlayMusic(m_sndDeathMusic);
		}
		Pawn.m_fRemainingGrenadeTime=0.00;
		ClientFadeCommonSound(5.00,0);
	}
	ClientDisableFirstPersonViewEffects();
	if (  !PlayerCanSwitchToAIBackup() )
	{
		if ( Pawn != None )
		{
			SetLocation(Pawn.Location);
			Pawn.UnPossessed();
		}
	}
	GotoState('Dead');
}

function bool PlayerCanSwitchToAIBackup ()
{
	if ( Level.NetMode == NM_Standalone )
	{
		if ( R6AbstractGameInfo(Level.Game).RainbowOperativesStillAlive() )
		{
			return True;
		}
		else
		{
			return False;
		}
	}
	if ( (m_TeamManager == None) || (m_TeamManager.m_iMemberCount == 0) )
	{
		return False;
	}
	if (  !R6GameReplicationInfo(GameReplicationInfo).m_bAIBkp )
	{
		return False;
	}
	return True;
}

simulated function ClientFadeSound (float fTime, int iVolume, ESoundSlot eSlot)
{
	if ( Viewport(Player) != None )
	{
		FadeSound(fTime,iVolume,eSlot);
	}
}

simulated function ClientFadeCommonSound (float fTime, int iVolume)
{
	if ( Viewport(Player) != None )
	{
		FadeSound(fTime,iVolume,SLOT_Ambient);
		FadeSound(fTime,iVolume,SLOT_Guns);
		FadeSound(fTime,iVolume,SLOT_SFX);
		FadeSound(fTime,iVolume,SLOT_GrenadeEffect);
		FadeSound(fTime,iVolume,SLOT_Talk);
		FadeSound(fTime,iVolume,SLOT_HeadSet);
		FadeSound(fTime,iVolume,SLOT_Instruction);
		FadeSound(fTime,iVolume,SLOT_StartingSound);
	}
}

function SwitchWeapon (byte f)
{
	local R6EngineWeapon NewWeapon;

	if ( bShowLog )
	{
		Log("IN: SwitchWeapon() to " $ string(f) @ string(m_bLockWeaponActions) @ string(m_pawn.m_bWeaponTransition));
	}
	if ( m_pawn == None )
	{
		return;
	}
	if (  !m_bLockWeaponActions &&  !m_pawn.m_bPostureTransition &&  !R6GameReplicationInfo(GameReplicationInfo).m_bGameOverRep )
	{
		NewWeapon=m_pawn.GetWeaponInGroup(f);
		if ( (NewWeapon != None) && (NewWeapon != Pawn.EngineWeapon) )
		{
			if (  !NewWeapon.CanSwitchToWeapon() )
			{
				return;
			}
			m_pawn.m_bChangingWeapon=True;
			m_pawn.m_iCurrentWeapon=f;
			ToggleHelmetCameraZoom(True);
			if (  !(Level.NetMode == NM_Standalone) &&  !(Level.NetMode == NM_ListenServer) )
			{
				m_pawn.GetWeapon(R6AbstractWeapon(NewWeapon));
			}
			ServerSwitchWeapon(NewWeapon,f);
			if ( (bBehindView == False) || (Level.NetMode != 0) )
			{
				Pawn.EngineWeapon.GotoState('DiscardWeapon');
			}
		}
	}
}

simulated function ServerSwitchWeapon (R6EngineWeapon NewWeapon, byte u8CurrentWeapon)
{
	Pawn.R6MakeNoise(SNDTYPE_Equipping);
	if ( bShowLog )
	{
		Log("IN: ServerSwitchWeapon() - CurrentWeapon: " $ string(Pawn.EngineWeapon) $ " - NewWeapon: " $ string(NewWeapon));
	}
	m_pawn.m_bChangingWeapon=True;
	m_pawn.GetWeapon(R6AbstractWeapon(NewWeapon));
	m_pawn.m_ePlayerIsUsingHands=HANDS_None;
	m_pawn.PlayWeaponAnimation();
	m_pawn.m_iCurrentWeapon=u8CurrentWeapon;
	if ( m_pawn.m_SoundRepInfo != None )
	{
		m_pawn.m_SoundRepInfo.m_CurrentWeapon=u8CurrentWeapon - 1;
	}
}

function WeaponUpState ()
{
	if ( bShowLog )
	{
		Log("IN: WeaponUpState() : " $ string(Pawn.EngineWeapon) $ " : " $ string(Pawn.PendingWeapon));
	}
	if ( Pawn.PendingWeapon == None )
	{
		return;
	}
	Pawn.PendingWeapon.m_bPawnIsWalking=Pawn.EngineWeapon.m_bPawnIsWalking;
	Pawn.EngineWeapon=Pawn.PendingWeapon;
	if ( Pawn.EngineWeapon.IsInState('RaiseWeapon') )
	{
		Pawn.EngineWeapon.BeginState();
	}
	else
	{
		Pawn.EngineWeapon.GotoState('RaiseWeapon');
	}
	if ( bShowLog )
	{
		Log("OUT: ClientWeaponUpState()");
	}
}

function ServerWeaponUpAnimDone ()
{
	if ( m_pawn == None )
	{
		return;
	}
	if ( m_pawn.m_bUsingBipod )
	{
		m_pawn.m_ePlayerIsUsingHands=HANDS_Both;
	}
	m_pawn.m_bChangingWeapon=False;
}

simulated function bool TeamMemberHasGrenadeType (eWeaponGrenadeType grenadeType)
{
//	return m_TeamManager.FindRainbowWithGrenadeType(grenadeType,True) != None;
    return false;
}

function SetRequestedCircumstantialAction ()
{
	m_RequestedCircumstantialAction=m_CurrentCircumstantialAction;
	m_vRequestedLocation=m_vDefaultLocation;
}

function bool CanIssueTeamOrder ()
{
	if ( (m_TeamManager == None) || (m_TeamManager.m_iMemberCount <= 1) || m_TeamManager.m_bTeamIsClimbingLadder || Level.m_bInGamePlanningActive )
	{
		return False;
	}
	return True;
}

event R6QueryCircumstantialAction (float fDistance, out R6AbstractCircumstantialActionQuery Query, PlayerController PlayerController)
{
	local bool bIsOpen;

	Query.iHasAction=1;
	if ( bOnlySpectator )
	{
		Query.iInRange=1;
//		Query.textureIcon=Texture'Spectator';
		Query.iPlayerActionID=0;
		Query.iTeamActionID=0;
		Query.iTeamActionIDList[0]=0;
		Query.iTeamActionIDList[1]=0;
		Query.iTeamActionIDList[2]=0;
		Query.iTeamActionIDList[3]=0;
		return;
	}
	if ( (m_TeamManager == None) || (m_TeamManager.m_iMemberCount <= 1) || m_bPreventTeamMemberUse )
	{
		Query.iHasAction=0;
		return;
	}
	if ( fDistance < m_fCircumstantialActionRange )
	{
		Query.iInRange=1;
//		Query.textureIcon=Texture'RegroupOnMe';
	}
	else
	{
		Query.iInRange=0;
//		Query.textureIcon=Texture'TeamMoveTo';
	}
	Query.iPlayerActionID=1;
	Query.iTeamActionID=2;
	Query.iTeamActionIDList[0]=2;
	Query.iTeamActionIDList[1]=3;
	Query.iTeamActionIDList[2]=0;
	Query.iTeamActionIDList[3]=0;
	R6FillSubAction(Query,0,0);
	R6FillGrenadeSubAction(Query,1);
	R6FillSubAction(Query,2,0);
	R6FillSubAction(Query,3,0);
}

function R6FillGrenadeSubAction (out R6AbstractCircumstantialActionQuery Query, int iSubMenu)
{
	local int i;
	local int j;

	if ( R6ActionCanBeExecuted(4) )
	{
		Query.iTeamSubActionsIDList[iSubMenu * 4 + i]=4;
		i++;
	}
	if ( R6ActionCanBeExecuted(5) )
	{
		Query.iTeamSubActionsIDList[iSubMenu * 4 + i]=5;
		i++;
	}
	if ( R6ActionCanBeExecuted(6) )
	{
		Query.iTeamSubActionsIDList[iSubMenu * 4 + i]=6;
		i++;
	}
	if ( R6ActionCanBeExecuted(7) )
	{
		Query.iTeamSubActionsIDList[iSubMenu * 4 + i]=7;
		i++;
	}
	j=i;
JL00E3:
	if ( j < 4 )
	{
		Query.iTeamSubActionsIDList[iSubMenu * 4 + j]=0;
		j++;
		goto JL00E3;
	}
}

simulated function bool R6ActionCanBeExecuted (int iAction)
{
	if ( iAction == 0 )
	{
		return False;
	}
	switch (iAction)
	{
/*		case 4:
		return m_TeamManager.HaveRainbowWithGrenadeType(1);
		break;
		case 5:
		return m_TeamManager.HaveRainbowWithGrenadeType(2);
		break;
		case 6:
		return m_TeamManager.HaveRainbowWithGrenadeType(3);
		break;
		case 7:
		return m_TeamManager.HaveRainbowWithGrenadeType(4);
		break;
		default:*/
	}
	return True;
}

simulated function string R6GetCircumstantialActionString (int iAction)
{
	switch (iAction)
	{
/*		case 1:
		return Localize("RDVOrder","Order_Regroup","R6Menu");
		case 2:
		return Localize("RDVOrder","Order_TeamMoveTo","R6Menu");
		case 3:
		return Localize("RDVOrder","Order_MoveGrenade","R6Menu");
		case 4:
		return Localize("RDVOrder","Order_FragGrenade","R6Menu");
		case 5:
		return Localize("RDVOrder","Order_GasGrenade","R6Menu");
		case 6:
		return Localize("RDVOrder","Order_FlashGrenade","R6Menu");
		case 7:
		return Localize("RDVOrder","Order_SmokeGrenade","R6Menu");
		default:*/
	}
	return "";
}

function DoDbgLogActor (Actor anActor)
{
	if ( R6Pawn(anActor) != None )
	{
		if ( CheatManager != None )
		{
			R6CheatManager(CheatManager).LogR6Pawn(R6Pawn(anActor));
		}
	}
	else
	{
		anActor.dbgLogActor(False);
	}
	if ( Level.NetMode == NM_Client )
	{
		ServerDbgLogActor(anActor);
	}
}

function ServerDbgLogActor (Actor anActor)
{
	local R6Pawn P;

	P=R6Pawn(anActor);
	if ( P != None )
	{
		if ( CheatManager != None )
		{
			if ( P.m_ePawnType == 2 )
			{
				R6CheatManager(CheatManager).LogTerro(R6Terrorist(P));
			}
			else
			{
				R6CheatManager(CheatManager).LogR6Pawn(P);
			}
		}
	}
	else
	{
		anActor.dbgLogActor(False);
	}
}

exec function LogPawn ()
{
	DoLogPawn();
	if ( Level.NetMode != 0 )
	{
		ServerLogPawn();
	}
}

function DoLogPawn ()
{
	if ( CheatManager != None )
	{
		R6CheatManager(CheatManager).LogR6Pawn(m_pawn);
	}
}

function ServerLogPawn ()
{
	DoLogPawn();
}

function DoLogActors ()
{
	local Actor ActorIterator;

	Log("--- Actor List Begin ---");
	foreach AllActors(Class'Actor',ActorIterator)
	{
		Log(" Actor:" @ string(ActorIterator));
	}
	Log("--- Actor List End ---");
}

function ServerLogActors ()
{
	DoLogActors();
}

function PossessInit (Pawn aPawn)
{
	SetRotation(aPawn.Rotation);
	aPawn.PossessedBy(self);
	Pawn=aPawn;
	m_pawn=R6Rainbow(Pawn);
	m_pawn.SetFriendlyFire();
	if ( (Level.NetMode != 0) && (Level.NetMode != 2) )
	{
		Pawn.RemoteRole=ROLE_AutonomousProxy;
	}
	else
	{
		Pawn.RemoteRole=RemoteRole;
	}
}

function Possess (Pawn aPawn)
{
	if ( bOnlySpectator )
	{
		return;
	}
	PossessInit(aPawn);
	Pawn.bStasis=False;
	Restart();
}

function UnPossess ()
{
	Super.UnPossess();
	m_pawn=None;
}

function ServerBroadcast (PlayerController Sender, coerce string Msg, optional name type)
{
	Level.Game.BroadcastTeam(Sender,Msg,type);
}

function ServerMove (float TimeStamp, Vector InAccel, Vector ClientLoc, bool NewbRun, bool NewbDuck, bool NewbCrawl, int View, int iNewRotOffset, optional byte OldTimeDelta, optional int OldAccel)
{
	Super.ServerMove(TimeStamp,InAccel,ClientLoc,NewbRun,NewbDuck,NewbCrawl,View,iNewRotOffset,OldTimeDelta,OldAccel);
}

function ServerPlayerPref (PlayerPrefInfo newPlayerPrefs)
{
	m_PlayerPrefs=newPlayerPrefs;
	PawnClass=Class<Pawn>(DynamicLoadObject(m_PlayerPrefs.m_ArmorName,Class'Class'));
}

function ServerNetLogActor (Actor InActor)
{
	InActor.m_bLogNetTraffic=True;
}

function ServerLogBandWidth (bool bLogBandWidth)
{
	Level.m_bLogBandWidth=bLogBandWidth;
}

function ServerSetPlayerReadyStatus (bool _bPlayerReady)
{
	PlayerReplicationInfo.m_bPlayerReady=_bPlayerReady;
}

function PlaySoundAffectedByGrenade (EGrenadeType eType)
{
	switch (eType)
	{
		case GTYPE_TearGas:
		m_CommonPlayerVoicesMgr.PlayCommonRainbowVoices(m_pawn,CRV_EntersGas);
		break;
		case GTYPE_Smoke:
		m_CommonPlayerVoicesMgr.PlayCommonRainbowVoices(m_pawn,CRV_EntersSmoke);
		break;
		default:
	}
}

event ClientPlayVoices (R6SoundReplicationInfo aAudioRepInfo, Sound sndPlayVoice, ESoundSlot eSlotUse, int iPriority, optional bool bWaitToFinishSound, optional float fTime)
{
	if ( (aAudioRepInfo == None) && (eSlotUse != 8) && (eSlotUse != 7) )
	{
		return;
	}
	if ( (aAudioRepInfo != None) && (aAudioRepInfo.m_pawnOwner != None) )
	{
		aAudioRepInfo.m_pawnOwner.SetAudioInfo();
		aAudioRepInfo.m_pawnOwner.m_fLastCommunicationTime=5.00;
	}
	PlayVoicesPriority(aAudioRepInfo,sndPlayVoice,eSlotUse,iPriority,bWaitToFinishSound,fTime);
}

function PlaySoundActionCompleted (eDeviceAnimToPlay eAnimToPlay)
{
	if ( Level.NetMode != 0 )
	{
		switch (eAnimToPlay)
		{
/*			case 2:
			m_TeamManager.m_MultiCoopPlayerVoicesMgr.PlayRainbowTeamVoices(m_pawn,9);
			break;
			case 3:
			m_TeamManager.m_MultiCoopPlayerVoicesMgr.PlayRainbowTeamVoices(m_pawn,1);
			break;
			case 4:
			m_TeamManager.m_MultiCoopPlayerVoicesMgr.PlayRainbowTeamVoices(m_pawn,3);
			break;
			case 0:
			m_TeamManager.m_MultiCommonVoicesMgr.PlayMultiCommonVoices(m_pawn,5);
			break;
			case 1:
			m_TeamManager.m_MultiCommonVoicesMgr.PlayMultiCommonVoices(m_pawn,7);
			break;
			default:   */
		}
	}
}

function PlaySoundInflictedDamage (Pawn DeadPawn)
{
	switch (R6Pawn(DeadPawn).m_ePawnType)
	{
/*		case 2:
		m_CommonPlayerVoicesMgr.PlayCommonRainbowVoices(m_pawn,CRV_TerroristDown);
		break;
		case 3:
		if ( m_TeamManager.m_iMemberCount > 1 )
		{
			m_TeamManager.m_MemberVoicesMgr.PlayRainbowMemberVoices(m_TeamManager.m_Team[1],25);
		}
		break;
		default:   */
	}
}

function PlaySoundCurrentAction (ERainbowTeamVoices eVoices)
{
	if ( Role == Role_Authority )
	{
		if ( Level.IsGameTypeCooperative(Level.Game.m_eGameTypeFlag) )
		{
//			m_TeamManager.m_MultiCoopPlayerVoicesMgr.PlayRainbowTeamVoices(m_pawn,eVoices);
		}
		else
		{
			if ( eVoices == 5 )
			{
//				m_TeamManager.m_PlayerVoicesMgr.PlayRainbowPlayerVoices(m_pawn,41);
			}
		}
	}
}

function PlaySoundDamage (Pawn instigatedBy)
{
//	m_CommonPlayerVoicesMgr.PlayCommonRainbowVoices(m_pawn,CRV_TakeWound);
	switch (m_pawn.m_eHealth)
	{
/*		case 2:
		case 3:
		m_CommonPlayerVoicesMgr.PlayCommonRainbowVoices(m_pawn,CRV_GoesDown);
		if ( (m_TeamManager.m_iMemberCount > 0) && (m_TeamManager.m_MemberVoicesMgr != None) )
		{
			m_TeamManager.m_MemberVoicesMgr.PlayRainbowMemberVoices(m_TeamManager.m_Team[0],13);
		}
		break;
		default:             */
	}
}

exec function MapList ()
{
	local R6GameReplicationInfo _GRI;
	local int iIterator;
	local string szMapId;
	local string szMapName;
	local string szGameType;
	local ER6GameType eGameType;

	_GRI=R6GameReplicationInfo(GameReplicationInfo);
	szMapId=Localize("Game","MapId","R6GameInfo");
	szMapName=Localize("Game","MapName","R6GameInfo");
	szGameType=Localize("Game","GameType","R6GameInfo");
	iIterator=0;
JL008B:
	if ( /*(iIterator < _GRI.32) && */(_GRI.m_mapArray[iIterator] != "") )
	{
		eGameType=_GRI.Level.GetER6GameTypeFromClassName(_GRI.m_gameModeArray[iIterator]);
		Class'Actor'.static.AddMessageToConsole(szMapId $ ": " $ string(iIterator + 1) $ " " $ szMapName $ ": " $ _GRI.m_mapArray[iIterator] $ " " $ szGameType $ ": " $ _GRI.Level.GetGameNameLocalization(eGameType),myHUD.m_ServerMessagesColor);
		iIterator++;
		goto JL008B;
	}
}

exec function Map (int iGotoMapId, string explanation)
{
	local R6GameReplicationInfo _GRI;

	iGotoMapId--;
	_GRI=R6GameReplicationInfo(GameReplicationInfo);
	if ( /*(iGotoMapId >= _GRI.32) ||*/ (iGotoMapId < 0) || (_GRI.m_mapArray[iGotoMapId] == "") )
	{
		Class'Actor'.static.AddMessageToConsole(Localize("Game","BadMapId","R6GameInfo"),myHUD.m_ServerMessagesColor);
		return;
	}
	Class'Actor'.static.AddMessageToConsole(Localize("Game","RequestingMap","R6GameInfo") $ ": " $ _GRI.m_mapArray[iGotoMapId],myHUD.m_ServerMessagesColor);
	ServerMap(iGotoMapId,explanation);
}

function ServerMap (int iGotoMapId, string explanation)
{
	local R6GameReplicationInfo _GRI;
	local R6PlayerController _playerController;
	local string _mapName;
	local string _PlayerName;

	_GRI=R6GameReplicationInfo(GameReplicationInfo);
	if ( (CheckAuthority(1) == False) /*|| (iGotoMapId >= _GRI.32) */)
	{
		ClientNoAuthority();
		return;
	}
	_mapName=_GRI.m_mapArray[iGotoMapId];
	_PlayerName=PlayerReplicationInfo.PlayerName;
	foreach AllActors(Class'R6PlayerController',_playerController)
	{
		_playerController.ClientServerMap(_PlayerName,_mapName,explanation);
	}
	R6AbstractGameInfo(Level.Game).EndGameAndJumpToMapID(iGotoMapId);
}

exec function PlayerList ()
{
	local PlayerReplicationInfo _PRI;
	local string szID;
	local string szName;

	szID=Localize("Game","Id","R6GameInfo");
	szName=Localize("Game","Name","R6GameInfo");
	foreach AllActors(Class'PlayerReplicationInfo',_PRI)
	{
		Class'Actor'.static.AddMessageToConsole(szID $ ": " $ string(_PRI.PlayerID) $ " " $ szName $ ": " $ _PRI.PlayerName,myHUD.m_ServerMessagesColor);
	}
}

exec function VoteKick (string szKickName)
{
	ProcessVoteKickRequest(R6PlayerController(FindPlayer(szKickName,False)));
}

exec function VoteKickID (string szKickName)
{
	ProcessVoteKickRequest(R6PlayerController(FindPlayer(szKickName,True)));
}

simulated function ProcessVoteKickRequest (R6PlayerController _playerController)
{
	if ( (Level.NetMode == NM_Client) || (Level.NetMode == NM_Standalone) )
	{
		ClientNoAuthority();
		return;
	}
	if ( (m_fLastVoteKickTime > 0) && (Level.TimeSeconds < m_fLastVoteKickTime + 300) )
	{
		if ( bShowLog )
		{
			Log("Next possible votekick request time is " $ string(m_fLastVoteKickTime + 300) $ " current time is " $ string(Level.TimeSeconds));
		}
		ClientCantRequestKickYet();
		return;
	}
	if ( bShowLog )
	{
		Log("<<KICK>> " $ string(self) $ ": calling StartVoteKick on " $ _playerController.PlayerReplicationInfo.PlayerName);
	}
	if ( _playerController != None )
	{
		if ( Viewport(_playerController.Player) != None )
		{
			ClientNoAuthority();
			return;
		}
		if ( _playerController.CheckAuthority(1) == True )
		{
			ClientNoKickAdmin();
			return;
		}
		if ( R6AbstractGameInfo(Level.Game).ProcessKickVote(_playerController,PlayerReplicationInfo.PlayerName) == False )
		{
			ClientVoteInProgress();
		}
		else
		{
			m_fLastVoteKickTime=Level.TimeSeconds;
		}
	}
	else
	{
		ClientKickBadId();
	}
}

exec function Vote (int _bVoteResult)
{
	local Controller _itController;
	local R6PlayerController _playerController;
	local string _PlayerNameOne;
	local string _PlayerNameTwo;
	local int _iForKickVotes;
	local int _iAgainstKickVotes;
	local int _iTotalPlayers;
	local R6ServerInfo pServerInfo;
	local bool _VoteSpamCheckOk;

	if ( R6AbstractGameInfo(Level.Game).m_PlayerKick == None )
	{
		return;
	}
	if ( (_bVoteResult <= 0) || (_bVoteResult >= 3) )
	{
		return;
	}
	if ( bShowLog )
	{
		switch (_bVoteResult)
		{
/*			case 1:
			Log(string(self) $ " set vote  yes to kick " $ R6AbstractGameInfo(Level.Game).m_PlayerKick.PlayerReplicationInfo.PlayerName);
			break;
			case 2:
			Log(string(self) $ " set vote no to kick " $ R6AbstractGameInfo(Level.Game).m_PlayerKick.PlayerReplicationInfo.PlayerName);
			break;
			default:*/
		}
		Log(string(self) $ " how did we get here? Set invalid  vote " $ string(_bVoteResult) $ " to kick " $ R6AbstractGameInfo(Level.Game).m_PlayerKick.PlayerReplicationInfo.PlayerName);
	}
	else
	{
	}
	m_iVoteResult=_bVoteResult;
	pServerInfo=Class'Actor'.static.GetServerOptions();
	_PlayerNameOne=PlayerReplicationInfo.PlayerName;
	_PlayerNameTwo=R6AbstractGameInfo(Level.Game).m_PlayerKick.PlayerReplicationInfo.PlayerName;
	_VoteSpamCheckOk=m_fLastVoteEmoteTimeStamp + pServerInfo.VoteBroadcastMaxFrequency <= Level.TimeSeconds;
	_itController=Level.ControllerList;
JL021E:
	if ( _itController != None )
	{
		_playerController=R6PlayerController(_itController);
		if ( _playerController != None )
		{
			_iTotalPlayers++;
			switch (_playerController.m_iVoteResult)
			{
/*				case 1:
				_iForKickVotes++;
				break;
				case 2:
				_iAgainstKickVotes++;
				break;
				default:*/
			}
			if ( _VoteSpamCheckOk )
			{
				_playerController.ClientPlayerVoteMessage(_PlayerNameOne,m_iVoteResult,_PlayerNameTwo);
			}
		}
		_itController=_itController.nextController;
		goto JL021E;
	}
	if ( _VoteSpamCheckOk )
	{
		m_fLastVoteEmoteTimeStamp=Level.TimeSeconds;
	}
	else
	{
		ClientPlayerVoteMessage(_PlayerNameOne,m_iVoteResult,_PlayerNameTwo);
	}
	if ( (_iAgainstKickVotes >= _iTotalPlayers / 2) || (_iForKickVotes > _iTotalPlayers / 2) )
	{
		R6AbstractGameInfo(Level.Game).m_fEndKickVoteTime=Level.TimeSeconds;
	}
}

function ClientBanned ()
{
	Player.Console.R6ConnectionFailed("BannedIP");
}

function ClientKickedOut ()
{
	Player.Console.R6ConnectionFailed("YouWereKicked");
}

function AutoAdminLogin (string _Password)
{
	if ( (Viewport(Player) != None) || Level.m_ServerSettings.UseAdminPassword && (_Password == Level.m_ServerSettings.AdminPassword) )
	{
		m_iAdmin=1;
	}
}

exec function AdminLogin (string _Password)
{
	m_szLastAdminPassword=_Password;
	SaveConfig();
	ServerAdminLogin(_Password);
}

function ServerAdminLogin (string _Password)
{
	if ( (Viewport(Player) != None) || Level.m_ServerSettings.UseAdminPassword && (_Password == Level.m_ServerSettings.AdminPassword) )
	{
		m_iAdmin=1;
		ClientAdminLogin(True);
		if ( bShowLog )
		{
			Log(PlayerReplicationInfo.PlayerName $ " logged in as an Administrator");
		}
	}
	else
	{
		ClientAdminLogin(False);
	}
}

function ClientAdminLogin (bool _loginRes)
{
	if ( _loginRes == True )
	{
		m_iAdmin=1;
		Player.InteractionMaster.Process_Message(Localize("Game","AdminSuccess","R6GameInfo"),7.00,Player.LocalInteractions);
	}
	else
	{
		m_iAdmin=0;
		Player.InteractionMaster.Process_Message(Localize("Game","AdminFailure","R6GameInfo"),7.00,Player.LocalInteractions);
	}
}

exec function LockServer (bool _bFlagSetting, optional string _NewPassword)
{
	if ( CheckAuthority(1) == False )
	{
		ClientNoAuthority();
		return;
	}
	if ( Len(_NewPassword) > 16 )
	{
		ClientPasswordTooLong();
		return;
	}
	if ( _bFlagSetting == True )
	{
		if ( _NewPassword == "" )
		{
			ClientPasswordMessage(GPR_MissingPasswd);
		}
		else
		{
			ClientPasswordMessage(GPR_PasswdSet);
			Level.Game.SetGamePassword(_NewPassword);
		}
	}
	else
	{
		ClientPasswordMessage(GPR_PasswdCleared);
		Level.Game.SetGamePassword("");
	}
}

function ClientPasswordMessage (eGamePasswordRes iMessageType)
{
	switch (iMessageType)
	{
		case GPR_MissingPasswd:
		AddMessageToConsole(Localize("Game","GamePasswordMissing","R6GameInfo"),myHUD.m_ServerMessagesColor);
		break;
		case GPR_PasswdSet:
		AddMessageToConsole(Localize("Game","GamePasswordSet","R6GameInfo"),myHUD.m_ServerMessagesColor);
		break;
		case GPR_PasswdCleared:
		AddMessageToConsole(Localize("Game","GamePasswordCleared","R6GameInfo"),myHUD.m_ServerMessagesColor);
		break;
		default:
	}
}

exec function NewPassword (string _NewPassword)
{
	local R6PlayerController _playerController;
	local string _PlayerName;

	if ( CheckAuthority(1) == False )
	{
		ClientNoAuthority();
		return;
	}
	if ( Len(_NewPassword) > 16 )
	{
		ClientPasswordTooLong();
		return;
	}
	Level.m_ServerSettings.AdminPassword=_NewPassword;
	Level.m_ServerSettings.SaveConfig();
	_PlayerName=PlayerReplicationInfo.PlayerName;
	if ( bShowLog )
	{
		Log(_PlayerName $ " changed password to " $ _NewPassword);
	}
	foreach AllActors(Class'R6PlayerController',_playerController)
	{
		_playerController.ClientNewPassword(_PlayerName);
	}
}

function bool CheckAuthority (int _LevelNeeded)
{
	if ( Level.NetMode == NM_Standalone )
	{
		return False;
	}
	return (m_iAdmin >= _LevelNeeded) || (Level.NetMode == NM_ListenServer) && (Viewport(Player) != None);
}

exec function Kick (string szKickName)
{
	ProcessKickRequest(R6PlayerController(FindPlayer(szKickName,False)));
}

exec function KickId (string szKickName)
{
	ProcessKickRequest(R6PlayerController(FindPlayer(szKickName,True)));
}

exec function Ban (string szKickName)
{
	local R6PlayerController PC;

	PC=R6PlayerController(FindPlayer(szKickName,False));
	ProcessKickRequest(PC,True);
}

exec function BanId (string szKickName)
{
	local R6PlayerController PC;

	PC=R6PlayerController(FindPlayer(szKickName,True));
	ProcessKickRequest(PC,True);
}

function ClientNoBanMatches ()
{
	local int iPos;

	AddMessageToConsole(Localize("Game","NoBanMatchFound","R6GameInfo"),myHUD.m_ServerMessagesColor);
	iPos=0;
JL0041:
	if ( iPos < 10 )
	{
		m_BanPage.szBanID[iPos]="";
		iPos++;
		goto JL0041;
	}
	m_iBanPage=0;
	m_szBanSearch="";
}

function ClientPlayerUnbanned ()
{
	AddMessageToConsole(Localize("Game","PlayerUnBanned","R6GameInfo"),myHUD.m_ServerMessagesColor);
}

function ClientPBVersionMismatch ()
{
	AddMessageToConsole(Localize("Game","PBVersionMismatch","R6GameInfo"),myHUD.m_ServerMessagesColor);
}

function ClientBanMatches (STBanPage banPage, string _BanPrefix)
{
	local int iPos;

	m_BanPage=banPage;
	m_szBanSearch=_BanPrefix;
	iPos=0;
JL001D:
	if ( iPos < 10 )
	{
		if ( m_BanPage.szBanID[iPos] == "" )
		{
			goto JL007D;
		}
		AddMessageToConsole(string(iPos) $ "> " $ m_BanPage.szBanID[iPos],myHUD.m_ServerMessagesColor);
		iPos++;
		goto JL001D;
	}
JL007D:
	m_iBanPage++;
}

exec function UnBanPos (int iPosition)
{
	local int iPos;

	if ( CheckAuthority(1) == False )
	{
		ClientNoAuthority();
		return;
	}
	if ( m_BanPage.szBanID[iPosition] == "" )
	{
		AddMessageToConsole(Localize("Game","NoBannedInPos","R6GameInfo"),myHUD.m_ServerMessagesColor);
		return;
	}
	UnBan(m_BanPage.szBanID[iPosition]);
	iPos=0;
JL0083:
	if ( iPos < 10 )
	{
		m_BanPage.szBanID[iPos]="";
		iPos++;
		goto JL0083;
	}
	m_iBanPage=0;
	m_szBanSearch="";
}

exec function BanList (string szPrefixBanID)
{
	if ( CheckAuthority(1) == False )
	{
		ClientNoAuthority();
		return;
	}
	m_iBanPage=0;
	m_szBanSearch=szPrefixBanID;
	ServerBanList(m_iBanPage,szPrefixBanID);
}

exec function NextBanList ()
{
	if ( CheckAuthority(1) == False )
	{
		ClientNoAuthority();
		return;
	}
	if ( m_iBanPage == 0 )
	{
		AddMessageToConsole(Localize("Game","BanListFirst","R6GameInfo"),myHUD.m_ServerMessagesColor);
	}
	else
	{
		ServerBanList(m_iBanPage,m_szBanSearch);
	}
}

function ServerBanList (int _iPageNumber, string szPrefixBanID)
{
	local int i;
	local int iMatchesFound;
	local int iPosFound;
	local STBanPage banPage;

	if ( CheckAuthority(1) == False )
	{
		ClientNoAuthority();
		return;
	}
	i=-1;
JL0020:
	if ( _iPageNumber > 0 )
	{
		iMatchesFound=0;
JL0032:
		i++;
		i=Level.Game.AccessControl.NextMatchingID(szPrefixBanID,i);
		if ( i >= 0 )
		{
			iMatchesFound++;
		}
		if (! (iMatchesFound == 10) || (i == -1) ) goto JL0032;
		if ( i == -1 )
		{
			ClientNoBanMatches();
			return;
		}
		_iPageNumber--;
		goto JL0020;
	}
	iMatchesFound=0;
JL00C1:
	i++;
	i=Level.Game.AccessControl.NextMatchingID(szPrefixBanID,i);
	if ( i >= 0 )
	{
		banPage.szBanID[iMatchesFound++ ]=Level.Game.AccessControl.Banned[i];
	}
	if (! (iMatchesFound == 10) || (i == -1) ) goto JL00C1;
	if ( iMatchesFound > 0 )
	{
		ClientBanMatches(banPage,szPrefixBanID);
	}
	else
	{
		ClientNoBanMatches();
	}
}

exec function UnBan (string szPrefixBanID)
{
	local int _iMatchesFound;

	if ( CheckAuthority(1) == False )
	{
		ClientNoAuthority();
		return;
	}
	_iMatchesFound=Level.Game.AccessControl.RemoveBan(szPrefixBanID);
	if ( _iMatchesFound == 0 )
	{
		ClientNoBanMatches();
	}
	else
	{
		if ( _iMatchesFound == 1 )
		{
			ClientPlayerUnbanned();
		}
		else
		{
			BanList(szPrefixBanID);
		}
	}
}

exec function Admin (string CommandLine)
{
	local string Result;

	if ( CheckAuthority(1) == False )
	{
		ClientNoAuthority();
		Log("Admin command <<" $ CommandLine $ ">> issued by:" $ GetPlayerNetworkAddress() $ " ignored");
		return;
	}
	Result=ConsoleCommand(CommandLine);
	Log("Admin command <<" $ CommandLine $ ">> issued by:" $ GetPlayerNetworkAddress() $ " accepted");
	if ( Result != "" )
	{
		Log("Admin command returned <<" $ Result $ ">>");
		ClientMessage(Result);
	}
}

simulated function ProcessKickRequest (R6PlayerController _playerController, optional bool bBan)
{
	local R6PlayerController _pcIterator;
	local string _AdminName;
	local string _KickeeName;

	if ( CheckAuthority(1) == False )
	{
		ClientNoAuthority();
		return;
	}
	if ( _playerController == None )
	{
		ClientKickBadId();
		return;
	}
	if ( (Viewport(_playerController.Player) != None) || (_playerController.CheckAuthority(1) == True) )
	{
		ClientNoKickAdmin();
		return;
	}
	if ( bShowLog )
	{
		Log("<AdminKick> " $ PlayerReplicationInfo.PlayerName $ " kicked " $ _playerController.PlayerReplicationInfo.PlayerName $ " from server");
	}
	_AdminName=PlayerReplicationInfo.PlayerName;
	_KickeeName=_playerController.PlayerReplicationInfo.PlayerName;
	foreach AllActors(Class'R6PlayerController',_pcIterator)
	{
		if ( bBan )
		{
			_pcIterator.ClientAdminBanOff(_AdminName,_KickeeName);
		}
		else
		{
			_pcIterator.ClientAdminKickOff(_AdminName,_KickeeName);
		}
	}
	if ( bBan )
	{
		Level.Game.AccessControl.KickBan(_KickeeName);
		_playerController.ClientBanned();
	}
	else
	{
		_playerController.ClientKickedOut();
	}
	_playerController.SpecialDestroy();
}

exec function LoadServer (string FileName)
{
	local R6PlayerController _playerController;

	if ( CheckAuthority(1) == False )
	{
		ClientNoAuthority();
		return;
	}
	ConsoleCommand("INGAMELOADSERVER " $ FileName);
}

function ServerPausePreGameRoundTime ()
{
	m_bInAnOptionsPage=CheckAuthority(1);
	if ( m_bInAnOptionsPage == True )
	{
		R6AbstractGameInfo(Level.Game).PauseCountDown();
	}
}

function ServerUnPausePreGameRoundTime ()
{
	if ( m_bInAnOptionsPage == True )
	{
		m_bInAnOptionsPage=False;
		R6AbstractGameInfo(Level.Game).UnPauseCountDown();
	}
}

function ServerStartChangingInfo ()
{
	if ( CheckAuthority(1) == False )
	{
		ClientNoAuthority();
		ClientServerChangingInfo(False);
		return;
	}
	if ( (R6AbstractGameInfo(Level.Game).m_pCurPlayerCtrlMdfSrvInfo != self) && (R6AbstractGameInfo(Level.Game).m_pCurPlayerCtrlMdfSrvInfo != None) )
	{
		ClientServerChangingInfo(False);
		return;
	}
	R6AbstractGameInfo(Level.Game).m_pCurPlayerCtrlMdfSrvInfo=self;
	if ( bShowLog )
	{
		Log("ServerStartChangingInfo: Setting m_pCurPlayerCtrlMdfSrvInfo = " $ string(R6AbstractGameInfo(Level.Game).m_pCurPlayerCtrlMdfSrvInfo));
	}
	ClientServerChangingInfo(True);
}

function ClientServerChangingInfo (bool _bCanChangeOptions)
{
	m_MenuCommunication.SetClientServerSettings(_bCanChangeOptions);
}

function SendSettingsAndRestartServer (bool _bRestrictionKitChange, bool _bChangeWasMade)
{
	local R6ServerInfo pServerInfo;

	if ( R6AbstractGameInfo(Level.Game).m_pCurPlayerCtrlMdfSrvInfo != self )
	{
		return;
	}
	pServerInfo=Class'Actor'.static.GetServerOptions();
	if ( _bChangeWasMade )
	{
		pServerInfo.SaveConfig();
		pServerInfo.m_ServerMapList.SaveConfig(Class'Actor'.static.GetModMgr().GetServerIni());
		if (  !_bRestrictionKitChange )
		{
			pServerInfo.RestartServer();
		}
		else
		{
			R6AbstractGameInfo(Level.Game).UpdateRepResArrays();
			R6AbstractGameInfo(Level.Game).BroadcastGameMsg("",PlayerReplicationInfo.PlayerName,"RestOption");
		}
	}
	else
	{
		R6AbstractGameInfo(Level.Game).m_pCurPlayerCtrlMdfSrvInfo=None;
	}
}

exec function LogRest ()
{
	local int i;
	local R6GameReplicationInfo _GRI;

}

function bool ServerNewGeneralSettings (EButtonName _eButName, optional bool _bNewValue, optional int _iNewValue)
{
	local R6ServerInfo pServerInfo;
	local bool bValueChange;

	if ( R6AbstractGameInfo(Level.Game).m_pCurPlayerCtrlMdfSrvInfo != self )
	{
		return False;
	}
	pServerInfo=Class'Actor'.static.GetServerOptions();
	bValueChange=True;
	switch (_eButName)
	{
/*		case 1:
		case 6:
		pServerInfo.RoundsPerMatch=_iNewValue;
		break;
		case 2:
		pServerInfo.RoundTime=_iNewValue;
		break;
		case 3:
		pServerInfo.MaxPlayers=_iNewValue;
		break;
		case 4:
		pServerInfo.BombTime=_iNewValue;
		break;
		case 7:
		pServerInfo.BetweenRoundTime=_iNewValue;
		break;
		case 8:
		pServerInfo.NbTerro=_iNewValue;
		break;
		case 11:
		pServerInfo.FriendlyFire=_bNewValue;
		break;
		case 12:
		pServerInfo.ShowNames=_bNewValue;
		break;
		case 13:
		pServerInfo.Autobalance=_bNewValue;
		break;
		case 14:
		pServerInfo.TeamKillerPenalty=_bNewValue;
		break;
		case 15:
		pServerInfo.AllowRadar=_bNewValue;
		break;
		case 16:
		pServerInfo.RotateMap=_bNewValue;
		break;
		case 17:
		pServerInfo.AIBkp=_bNewValue;
		break;
		case 18:
		pServerInfo.ForceFPersonWeapon=_bNewValue;
		break;
		case 22:
		pServerInfo.DiffLevel=_iNewValue;
		break;
		case 23:
		pServerInfo.CamFirstPerson=_bNewValue;
		break;
		case 24:
		pServerInfo.CamThirdPerson=_bNewValue;
		break;
		case 25:
		pServerInfo.CamFreeThirdP=_bNewValue;
		break;
		case 26:
		pServerInfo.CamGhost=_bNewValue;
		break;
		case 27:
		pServerInfo.CamFadeToBlack=_bNewValue;
		break;
		case 28:
		pServerInfo.CamTeamOnly=_bNewValue;
		break;
		case 0:
		default:
		bValueChange=False;
		break;    */
	}
	return bValueChange;
}

function ServerNewMapListSettings (int iMapIndex, optional int iUpdateGameType, optional string _GameType, optional string _Map, optional int _iLastItem)
{
	local R6ServerInfo pServerInfo;
	local int i;
	local int iArrayCount;
	local bool bValueChange;

	if ( R6AbstractGameInfo(Level.Game).m_pCurPlayerCtrlMdfSrvInfo != self )
	{
		return;
	}
	pServerInfo=Class'Actor'.static.GetServerOptions();
	if ( _iLastItem != 0 )
	{
		iArrayCount=32;
		i=_iLastItem;
JL0054:
		if ( i < iArrayCount )
		{
			pServerInfo.m_ServerMapList.GameType[i]="";
			pServerInfo.m_ServerMapList.Maps[i]="";
			i++;
			goto JL0054;
		}
		return;
	}
	switch (iUpdateGameType)
	{
/*		case 1:
		pServerInfo.m_ServerMapList.Maps[iMapIndex]=_Map;
		break;
		case 2:
		pServerInfo.m_ServerMapList.GameType[iMapIndex]=_GameType;
		break;
		default:
		pServerInfo.m_ServerMapList.GameType[iMapIndex]=_GameType;
		pServerInfo.m_ServerMapList.Maps[iMapIndex]=_Map;
		break;     */
	}
}

function ServerNewKitRestSettings (ERestKitID _eKitRestID, bool _bRemoveRest, optional Class _pANewClassValue, optional string _szNewValue)
{
	local R6ServerInfo pServerInfo;
	local bool bValueChange;

	if ( R6AbstractGameInfo(Level.Game).m_pCurPlayerCtrlMdfSrvInfo != self )
	{
		return;
	}
	pServerInfo=Class'Actor'.static.GetServerOptions();
	switch (_eKitRestID)
	{
/*		case 0:
		SetRestKitWithAClass(_bRemoveRest,_pANewClassValue,pServerInfo.RestrictedSubMachineGuns);
		break;
		case 1:
		SetRestKitWithAClass(_bRemoveRest,_pANewClassValue,pServerInfo.RestrictedShotGuns);
		break;
		case 2:
		SetRestKitWithAClass(_bRemoveRest,_pANewClassValue,pServerInfo.RestrictedAssultRifles);
		break;
		case 3:
		SetRestKitWithAClass(_bRemoveRest,_pANewClassValue,pServerInfo.RestrictedMachineGuns);
		break;
		case 4:
		SetRestKitWithAClass(_bRemoveRest,_pANewClassValue,pServerInfo.RestrictedSniperRifles);
		break;
		case 5:
		SetRestKitWithAClass(_bRemoveRest,_pANewClassValue,pServerInfo.RestrictedPistols);
		break;
		case 6:
		SetRestKitWithAClass(_bRemoveRest,_pANewClassValue,pServerInfo.RestrictedMachinePistols);
		break;
		case 7:
		SetRestKitWithAsz(_bRemoveRest,_szNewValue,pServerInfo.RestrictedPrimary);
		break;
		case 8:
		SetRestKitWithAsz(_bRemoveRest,_szNewValue,pServerInfo.RestrictedSecondary);
		break;
		case 9:
		SetRestKitWithAsz(_bRemoveRest,_szNewValue,pServerInfo.RestrictedMiscGadgets);
		break;
		default:    */
	}
}

function SetRestKitWithAClass (bool _bRemoveRest, Class _pANewClassValue, out array<Class> _pARestKit)
{
	local int i;

	if ( _bRemoveRest )
	{
		i=0;
JL0010:
		if ( i < _pARestKit.Length )
		{
			if ( _pARestKit[i] == _pANewClassValue )
			{
				_pARestKit.Remove (i,1);
			}
			i++;
			goto JL0010;
		}
	}
	else
	{
		_pARestKit[_pARestKit.Length]=_pANewClassValue;
	}
}

function SetRestKitWithAsz (bool _bRemoveRest, string _szNewValue, out array<string> _szARestKit)
{
	local int i;

	if ( _bRemoveRest )
	{
		i=0;
JL0010:
		if ( i < _szARestKit.Length )
		{
			if ( _szARestKit[i] == _szNewValue )
			{
				_szARestKit.Remove (i,1);
			}
			i++;
			goto JL0010;
		}
	}
	else
	{
		_szARestKit[_szARestKit.Length]=_szNewValue;
	}
}

exec function RestartMatch (string explanation)
{
	local R6PlayerController _playerController;
	local string _AdminName;

	if ( CheckAuthority(1) == False )
	{
		ClientNoAuthority();
		return;
	}
	_AdminName=PlayerReplicationInfo.PlayerName;
	DisableFirstPersonViewEffects();
	foreach AllActors(Class'R6PlayerController',_playerController)
	{
		_playerController.ClientDisableFirstPersonViewEffects();
		_playerController.ClientRestartMatchMsg(_AdminName,explanation);
	}
	Level.Game.AbortScoreSubmission();
	Level.Game.RestartGame();
}

exec function RestartRound (string explanation)
{
	local R6PlayerController _playerController;
	local string _AdminName;

	if ( CheckAuthority(1) == False )
	{
		ClientNoAuthority();
		return;
	}
	_AdminName=PlayerReplicationInfo.PlayerName;
	DisableFirstPersonViewEffects();
	foreach AllActors(Class'R6PlayerController',_playerController)
	{
		_playerController.ClientDisableFirstPersonViewEffects();
		_playerController.ClientRestartRoundMsg(_AdminName,explanation);
	}
	Level.Game.AbortScoreSubmission();
	R6AbstractGameInfo(Level.Game).AdminResetRound();
	R6AbstractGameInfo(Level.Game).ResetRound();
	R6AbstractGameInfo(Level.Game).ResetPenalty();
}

function ClientTeamFullMessage ()
{
	HandleServerMsg(Localize("MPMiscMessages","TeamIsFull","R6GameInfo"));
}

function ClientServerMap (string _szPlayerName, string szNewMapname, string explanation)
{
	HandleServerMsg(_szPlayerName $ " " $ Localize("Game","AdminSwitchMap","R6GameInfo") $ " " $ szNewMapname);
	if ( explanation != "" )
	{
		HandleServerMsg(explanation);
	}
}

function ClientKickBadId ()
{
	HandleServerMsg(Localize("Game","BadNameOrId","R6GameInfo"));
}

function ClientKickVoteMessage (PlayerReplicationInfo PRIKickPlayer, string szRequestingPlayer)
{
	if ( bShowLog )
	{
		Log("ClientKickVoteMessage displaying: " $ szRequestingPlayer $ ": " $ Localize("Game","LetsKickOut","R6GameInfo") @ PRIKickPlayer.PlayerName);
	}
	m_MenuCommunication.ActiveVoteMenu(True,PRIKickPlayer.PlayerName);
	HandleServerMsg(szRequestingPlayer $ ": " $ Localize("Game","LetsKickOut","R6GameInfo") @ PRIKickPlayer.PlayerName);
}

function ClientPlayerVoteMessage (string _playerOne, int iResult, string _playerTwo)
{
	local string szVoteMessage;

	switch (iResult)
	{
/*		case 1:
		szVoteMessage=_playerOne @ Localize("Game","YesVoteKick","R6GameInfo") @ _playerTwo;
		break;
		case 2:
		szVoteMessage=_playerOne @ Localize("Game","NoVoteKick","R6GameInfo") @ _playerTwo;
		break;
		default:
		return;        */
	}
	Player.InteractionMaster.Process_Message(szVoteMessage,7.00,Player.LocalInteractions);
}

function ClientVoteResult (bool VoteResult, string _PlayerName)
{
	local string _stringOne;
	local string _stringTwo;

	if ( VoteResult )
	{
		_stringOne=Localize("Game","KickVotePassOne","R6GameInfo");
		_stringTwo=Localize("Game","KickVotePassTwo","R6GameInfo");
	}
	else
	{
		_stringOne=Localize("Game","KickVoteFailOne","R6GameInfo");
		_stringTwo=Localize("Game","KickVoteFailTwo","R6GameInfo");
	}
	HandleServerMsg(_stringOne $ " " $ _PlayerName $ " " $ _stringTwo);
	m_MenuCommunication.ActiveVoteMenu(False);
}

function ClientVoteSessionAbort (string _PlayerName)
{
	HandleServerMsg(_PlayerName @ Localize("Game","LeftTheServerVoteAborted","R6GameInfo"));
	m_MenuCommunication.ActiveVoteMenu(False);
}

function ClientNewPassword (string _AdminName)
{
	HandleServerMsg(_AdminName $ ": " $ Localize("Game","AdminPasswordChange","R6GameInfo"));
}

function ClientPasswordTooLong ()
{
	HandleServerMsg(Localize("Game","PasswordTooLong","R6GameInfo"));
}

function ClientNoAuthority ()
{
	HandleServerMsg(Localize("Game","NoAuthority","R6GameInfo"));
}

function ClientVoteInProgress ()
{
	HandleServerMsg(Localize("Game","VoteInProgress","R6GameInfo"));
}

function ClientCantRequestKickYet ()
{
	HandleServerMsg(Localize("Game","CantRequestKickYet","R6GameInfo"));
}

function ClientNoKickAdmin ()
{
	HandleServerMsg(Localize("Game","CantKickAdmin","R6GameInfo"));
}

function ClientAdminKickOff (string _AdminName, string _KickedName)
{
	HandleServerMsg(_KickedName $ " " $ Localize("Game","AdminKickOff","R6GameInfo") $ " " $ _AdminName);
}

function ClientAdminBanOff (string _AdminName, string _KickedName)
{
	HandleServerMsg(_KickedName $ " " $ Localize("Game","AdminBanOff","R6GameInfo") $ " " $ _AdminName);
}

function ClientRestartRoundMsg (string _AdminName, string explanation)
{
	HandleServerMsg(_AdminName $ " " $ Localize("Game","RestartsTheRound","R6GameInfo"));
	if ( explanation != "" )
	{
		HandleServerMsg(explanation);
	}
	m_MenuCommunication.SetPlayerReadyStatus(False);
}

function ClientRestartMatchMsg (string _AdminName, string explanation)
{
	HandleServerMsg(_AdminName $ " " $ Localize("Game","RestartsTheMatch","R6GameInfo"));
	if ( explanation != "" )
	{
		HandleServerMsg(explanation);
	}
}

function ClientResetGameMsg ()
{
	local int i;

	i=0;
JL0007:
/*	if ( i < myHUD.3 )
	{
		myHUD.TextServerMessages[i]="";
		myHUD.MessageServerLife[i]=0.00;
		i++;
		goto JL0007;
	}*/
}

function ClientGameTypeDescription (ER6GameType eGameTypeFlag)
{
	local string szObjective;

	if ( PlayerReplicationInfo.TeamID == 3 )
	{
		szObjective=Level.GetRedShortDescription(eGameTypeFlag);
		if ( szObjective != "" )
		{
			HandleServerMsg(szObjective);
		}
	}
	else
	{
		szObjective=Level.GetGreenShortDescription(eGameTypeFlag);
		if ( szObjective != "" )
		{
			HandleServerMsg(szObjective);
		}
	}
}

function ClientMissionObjMsg (string szLocFile, string szPreMsg, string szMsgID, optional Sound sndSound, optional int iLifeTime)
{
	if ( szLocFile == "" )
	{
		szLocFile=Level.m_szMissionObjLocalization;
	}
	SetGameMsg(szLocFile,szPreMsg,szMsgID,sndSound,iLifeTime);
}

function ClientGameMsg (string szLocFile, string szPreMsg, string szMsgID, optional Sound sndSound, optional int iLifeTime)
{
	if ( szLocFile == "" )
	{
		szLocFile="R6GameInfo";
	}
	SetGameMsg(szLocFile,szPreMsg,szMsgID,sndSound,iLifeTime);
}

function SetGameMsg (string szLocalization, string szPreMsg, string szMsgID, optional Sound sndSound, optional int iLifeTime)
{
	if ( (szPreMsg != "") && (szMsgID != "") )
	{
		HandleServerMsg(szPreMsg $ " " $ Localize("Game",szMsgID,szLocalization),iLifeTime);
	}
	else
	{
		if ( (szPreMsg != "") && (szMsgID == "") )
		{
			HandleServerMsg(szPreMsg,iLifeTime);
		}
		else
		{
			if ( szMsgID != "" )
			{
				HandleServerMsg(Localize("Game",szMsgID,szLocalization),iLifeTime);
			}
			else
			{
				HandleServerMsg("",iLifeTime);
			}
		}
	}
	if ( sndSound != None )
	{
//		ClientPlayVoices(None,sndSound,7,5,True,1.00);
	}
}

function ServerGhost (Pawn aPawn)
{
	if ( CheatManager != None )
	{
		R6CheatManager(CheatManager).DoGhost(aPawn);
	}
}

function ServerCompleteMission ()
{
	if ( CheatManager != None )
	{
		R6CheatManager(CheatManager).DoCompleteMission();
	}
}

function ServerAbortMission ()
{
	if ( CheatManager != None )
	{
		R6CheatManager(CheatManager).DoAbortMission();
	}
}

function ServerWalk (Pawn aPawn)
{
	if ( CheatManager != None )
	{
		R6CheatManager(CheatManager).DoWalk(aPawn);
	}
}

function ServerPlayerInvisible (bool bIsVisible)
{
	if ( CheatManager != None )
	{
		R6CheatManager(CheatManager).DoPlayerInvisible(bIsVisible);
	}
}

function ClientTeamIsDead ()
{
	if ( m_MenuCommunication != None )
	{
		m_MenuCommunication.SetStatMenuState(CMS_PlayerDead);
	}
}

simulated function ServerRequestSkins ()
{
	if ( Level.NetMode != 3 )
	{
		ClientSetMultiplayerSkins(Level.GreenTeamPawnClass,Level.RedTeamPawnClass);
	}
}

simulated function ClientSetMultiplayerSkins (string G, string R)
{
	Level.GreenTeamPawnClass=G;
	Level.RedTeamPawnClass=R;
}

function ClientStopFadeToBlack ()
{
	if ( (myHUD != None) && (Viewport(Player) != None) )
	{
		R6AbstractHUD(myHUD).StopFadeToBlack();
	}
}

function CountDownPopUpBox ()
{
	if ( m_MenuCommunication != None )
	{
		m_MenuCommunication.CountDownPopUpBox();
	}
}

function CountDownPopUpBoxDone ()
{
	if ( m_MenuCommunication != None )
	{
		m_MenuCommunication.CountDownPopUpBoxDone();
	}
}

exec function MyID ()
{
	Player.Console.Message(m_GameService.MyID(),6.00);
}

exec function Say (string Msg)
{
	local R6ServerInfo pServerInfo;

	if ( (Msg == "") || (Level.NetMode == NM_Standalone) )
	{
		return;
	}
	pServerInfo=Class'Actor'.static.GetServerOptions();
	if ( m_fPreviousBroadcastTimeStamp <= Level.TimeSeconds - pServerInfo.SpamThreshold )
	{
		if ( Level.TimeSeconds >= m_fEndOfChatLockTime )
		{
			m_fPreviousBroadcastTimeStamp=m_fLastBroadcastTimeStamp;
			m_fLastBroadcastTimeStamp=Level.TimeSeconds;
			Level.Game.Broadcast(self,Msg,'Say');
		}
		else
		{
			ClientMessage(Localize("Game","ChatDisabledMessage1","R6GameInfo") @ string(m_fEndOfChatLockTime - Level.TimeSeconds) @ Localize("Game","ChatDisabledMessage2","R6GameInfo"));
		}
	}
	else
	{
		m_fEndOfChatLockTime=Level.TimeSeconds + pServerInfo.ChatLockDuration;
		m_fPreviousBroadcastTimeStamp=-99.00;
		m_fLastBroadcastTimeStamp=-99.00;
		ClientMessage(Localize("Game","AbuseDetectedMessage1","R6GameInfo") @ string(pServerInfo.ChatLockDuration) @ Localize("Game","AbuseDetectedMessage2","R6GameInfo"));
	}
}

exec function TeamSay (string Msg)
{
	local R6ServerInfo pServerInfo;

	if ( (Msg == "") || (Level.NetMode == NM_Standalone) )
	{
		return;
	}
	pServerInfo=Class'Actor'.static.GetServerOptions();
	if ( m_fPreviousBroadcastTimeStamp <= Level.TimeSeconds - pServerInfo.SpamThreshold )
	{
		if ( Level.TimeSeconds >= m_fEndOfChatLockTime )
		{
			m_fPreviousBroadcastTimeStamp=m_fLastBroadcastTimeStamp;
			m_fLastBroadcastTimeStamp=Level.TimeSeconds;
			Level.Game.BroadcastTeam(self,Msg,'TeamSay');
		}
		else
		{
			ClientMessage(Localize("Game","ChatDisabledMessage1","R6GameInfo") @ string(m_fEndOfChatLockTime - Level.TimeSeconds) @ Localize("Game","ChatDisabledMessage2","R6GameInfo"));
		}
	}
	else
	{
		m_fEndOfChatLockTime=Level.TimeSeconds + pServerInfo.ChatLockDuration;
		m_fPreviousBroadcastTimeStamp=-99.00;
		m_fLastBroadcastTimeStamp=-99.00;
		ClientMessage(Localize("Game","AbuseDetectedMessage1","R6GameInfo") @ string(pServerInfo.ChatLockDuration) @ Localize("Game","AbuseDetectedMessage2","R6GameInfo"));
	}
}

defaultproperties
{
    m_iDoorSpeed=20
    m_iFastDoorSpeed=100
    m_iFluidMovementSpeed=900
    m_iSpeedLevels(0)=7500
    m_iSpeedLevels(1)=15500
    m_iSpeedLevels(2)=23500
    m_iReturnSpeed=3000
    m_bShowFPWeapon=True
    m_bShakeActive=True
    m_bUseFirstPersonWeapon=True
    m_bAttachCameraToEyes=True
    m_bCameraGhost=True
    m_bCameraFirstPerson=True
    m_bCameraThirdPersonFixed=True
    m_bCameraThirdPersonFree=True
    m_bFadeToBlack=True
    m_bSpectatorCameraTeamOnly=True
    m_bCanChangeMember=True
    m_fTeamMoveToDistance=6000.00
    m_fDesignerSpeedFactor=1.00
    m_fDesignerJumpFactor=1.00
    m_fMilestoneMessageDuration=2.00
    LastDoorUpdateTime=1.00
    m_stImpactHit=(iBlurIntensity=170002778,fWaveTime=35184372088832.00,fRollMax=0.00,fRollSpeed=0.00,fReturnTime=0.00)
    m_stImpactStun=(iBlurIntensity=337774938,fWaveTime=35184372088832.00,fRollMax=0.00,fRollSpeed=0.00,fReturnTime=0.00)
    m_stImpactDazed=(iBlurIntensity=673319258,fWaveTime=35184372088832.00,fRollMax=0.00,fRollSpeed=0.00,fReturnTime=-6.77000119191158972E25)
    m_stImpactKO=(iBlurIntensity=1260521818,fWaveTime=562949953421312.00,fRollMax=0.00,fRollSpeed=0.00,fReturnTime=0.00)
    m_SpectatorColor=(R=255,G=255,B=255,A=210)
    EnemyTurnSpeed=100000
    DesiredFOV=90.00
    DefaultFOV=90.00
    CheatClass=Class'R6CheatManager'
    InputClass=Class'R6PlayerInput'
    m_bFirstTimeInZone=True
}
/*
    m_sndUpdateWritableMap=Sound'Common_Multiplayer.Play_DrawingTool_Receive'
    m_sndDeathMusic=Sound'Music.Play_themes_Death'
    m_sndMissionComplete=Sound'Voices_Control_MissionSuccess.Play_Control_MissionCompleted'
*/

