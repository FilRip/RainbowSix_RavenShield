//================================================================================
// PlayerController.
//================================================================================
class PlayerController extends Controller
	Native
//	Localized
	Config(User);

enum ePlayerTeamSelection {
	PTS_UnSelected,
	PTS_AutoSelect,
	PTS_Alpha,
	PTS_Bravo,
	PTS_Spectator
};

enum eCameraMode {
	CAMERA_FirstPerson,
	CAMERA_3rdPersonFixed,
	CAMERA_3rdPersonFree,
	CAMERA_Ghost
};

enum ECDKEYST_STATUS {
	ECDKEYST_PLAYER_UNKNOWN,
	ECDKEYST_PLAYER_INVALID,
	ECDKEYST_PLAYER_VALID,
	ECDKEYST_PLAYER_BANNED
};

enum ECDKEY_VALID_REQ {
	ECDKEY_NONE,
	ECDKEY_FIRSTPASS,
	ECDKEY_WAITING_FOR_RESPONSE,
	ECDKEY_NOT_VALID,
	ECDKEY_VALID,
	ECDKEY_TIMEOUT
};

struct PlayerPrefInfo
{
	var string m_CharacterName;
	var string m_ArmorName;
	var string m_WeaponName1;
	var string m_WeaponName2;
	var string m_WeaponGadgetName1;
	var string m_WeaponGadgetName2;
	var string m_BulletType1;
	var string m_BulletType2;
	var string m_GadgetName1;
	var string m_GadgetName2;
};

const K_GlobalID_size= 16;
var input byte bStrafe;
var input byte bSnapLevel;
var input byte bLook;
var input byte bFreeLook;
var input byte bTurn180;
var input byte bTurnToNearest;
var input byte bXAxis;
var input byte bYAxis;
var EDoubleClickDir DoubleClickDir;
var EMusicTransition Transition;
var ePlayerTeamSelection m_TeamSelection;
var ECDKEY_VALID_REQ m_eCDKeyRequest;
var ECDKEYST_STATUS m_eCDKeyStatus;
var eCameraMode m_eCameraMode;
var int ShowFlags;
var int Misc1;
var int Misc2;
var int RendMap;
var int WeaponUpdate;
var config int EnemyTurnSpeed;
var int GroundPitch;
var int DemoViewPitch;
var int DemoViewYaw;
var int m_iChangeNameLastTime;
var int m_iCDKeyReqID;
var int iPBEnabled;
var globalconfig bool bLookUpStairs;
var globalconfig bool bSnapToLevel;
var globalconfig bool bAlwaysMouseLook;
var globalconfig bool bKeyboardLook;
var bool bCenterView;
var bool bBehindView;
var bool bFrozen;
var bool bPressedJump;
var bool bUpdatePosition;
var bool bIsTyping;
var bool bFixedCamera;
var bool bJumpStatus;
var bool bUpdating;
var bool bZooming;
var bool bOnlySpectator;
var bool m_bReadyToEnterSpectatorMode;
var bool bSetTurnRot;
var bool bCheatFlying;
var bool bFreeCamera;
var bool bZeroRoll;
var bool bCameraPositionLocked;
var bool ReceivedSecretChecksum;
var bool m_bInitFirstTick;
var bool m_PreLogOut;
var bool m_bRadarActive;
var bool m_bHeatVisionActive;
var bool m_bLoadSoundGun;
var bool m_bCDKeyValSecondTry;
var bool m_bInstructionTouch;
var float AimingHelp;
var float WaitDelay;
var input float aBaseX;
var input float aBaseY;
var input float aBaseZ;
var input float aMouseX;
var input float aMouseY;
var input float aForward;
var input float aTurn;
var input float aStrafe;
var input float aUp;
var input float aLookUp;
var float OrthoZoom;
var float CameraDist;
var float DesiredFOV;
var float DefaultFOV;
var float ZoomLevel;
var float DesiredFlashScale;
var float ConstantGlowScale;
var float InstantFlash;
var float TargetEyeHeight;
var float LastPlaySound;
var float CurrentTimeStamp;
var float LastUpdateTime;
var float ServerTimeStamp;
var float TimeMargin;
var float ClientUpdateTime;
var globalconfig float MaxTimeMargin;
var float ProgressTimeOut;
var float MaxShakeRoll;
var float ShakeRollRate;
var float ShakeRollTime;
var globalconfig float NetClientMaxTickRate;
var float m_fNextUpdateTime;
var float m_fLoginTime;
var Player Player;
var Actor ViewTarget;
var HUD myHUD;
var SavedMove SavedMoves;
var SavedMove FreeMoves;
var SavedMove PendingMove;
var GameReplicationInfo GameReplicationInfo;
var Pawn TurnTarget;
var CheatManager CheatManager;
var R6RainbowStartInfo m_PlayerStartInfo;
var Actor m_SaveOldClientBase;
var Class<LocalMessage> LocalMessageClass;
var Class<CheatManager> CheatClass;
var Class<PlayerInput> InputClass;
var Vector FlashScale;
var Vector FlashFog;
var Vector DesiredFlashFog;
var Vector ConstantGlowFog;
var Vector InstantFog;
var Rotator TargetViewRotation;
var Vector TargetWeaponViewOffset;
var Color ProgressColor[4];
var Vector MaxShakeOffset;
var Vector ShakeOffsetRate;
var Vector ShakeOffset;
var Vector ShakeOffsetTime;
var Rotator TurnRot180;
var Vector OldFloor;
var PlayerPrefInfo m_PlayerPrefs;
var string Song;
var string ProgressMessage[4];
var localized string QuickSaveString;
var localized string NoPauseMessage;
var localized string ViewingFrom;
var localized string OwnCamera;
var globalconfig private string ngWorldSecret;
var string m_szGlobalID;
var string m_szIpAddr;
var string m_szAuthorizationID;
var string m_szOptAuthorizationID;
var transient private PlayerInput PlayerInput;
var transient array<CameraEffect> CameraEffects;

replication
{
	reliable if ( Role == Role_Authority )
		ClientPBKickedOutMessage,ClientReStart,SetProgressTime,SetProgressMessage,ClearProgressMessages,ClientChangeName,ClientCantRequestChangeNameYet,ClientAdjustGlow,ClientAdjustBase,ClientReplicateSkins,ClientSetBehindView,ClientSetFixedCamera,EndZoom,StopZoom,StartZoom,ToggleZoom,ClientSetMusic,ClientReliablePlaySound,ClientErrorMessageLocalized,ClientSetHUD,GivePawn,ClientGotoState,ResettingLevel;
	reliable if ( Role < Role_Authority )
		ServerToggleHeatVision,ServerToggleRadar,ChangeTeam,ChangeName,ServerChangeName,Suicide,ActivateItem,PrevItem,ThrowWeapon,Pause,SetPause,Speech,Typing,ServerRestartGame,AskForPawn,ServerPlayerPref,ServerReadyToLoadWeaponSound,ServerTeamRequested,ServerSetPlayerReadyStatus;
	unreliable if ( Role < Role_Authority )
		ServerViewSelf,ServerViewNextPlayer,ServerUse,ServerMove,ShortServerMove,ShorterServerMove,TeamSay,Say,ServerTKPopUpDone;
	unreliable if ( Role == Role_Authority )
		ClientShake,ClientInstantFlash,ClientSetFlash,ClientFlash,SetFOVAngle,LongClientAdjustPosition,ClientAdjustPosition,ShortClientAdjustPosition,VeryShortClientAdjustPosition;
	unreliable if ( (Role == Role_Authority) &&  !bDemoRecording )
		ClientStopSound,ClientPlaySound;
	reliable if ( (Role == Role_Authority) && ( !bDemoRecording || bClientDemoRecording && bClientDemoNetFunc) )
		TeamMessage,ClientMessage,ReceiveLocalizedMessage;
	unreliable if ( ( !bDemoRecording || bClientDemoRecording && bClientDemoNetFunc) && (Role == Role_Authority) )
		ClientHearSound;
	reliable if ( (Role == Role_Authority) &&  !bDemoRecording )
		ClientTravel;
	reliable if ( bNetDirty && bNetOwner && (Role == Role_Authority) )
		m_TeamSelection,m_eCameraMode,bOnlySpectator,ViewTarget,GameReplicationInfo;
	reliable if ( bDemoRecording && (Role == Role_Authority) )
		DemoViewPitch,DemoViewYaw;
	reliable if ( bNetDirty && (Role == Role_Authority) )
		m_bRadarActive;
	reliable if ( bNetOwner && (Role == Role_Authority) && (ViewTarget != Pawn) && (Pawn(ViewTarget) != None) )
		TargetEyeHeight,TargetViewRotation,TargetWeaponViewOffset;
}

function InitMatineeCamera ();

function EndMatineeCamera ();

simulated function ResettingLevel (int iNbOfRestart);

function ServerSetPlayerReadyStatus (bool _bPlayerReady);

function ServerTKPopUpDone (bool _bApplyTeamKillerPenalty);

function ServerTeamRequested (ePlayerTeamSelection eTeamSelected, optional bool bForceSelection);

native(1317) final function string GetPBConnectStatus ();

native(1318) final function int IsPBEnabled ();

native final function string GetPlayerNetworkAddress ();

native(1282) final function SpecialDestroy ();

native function string ConsoleCommand (string Command);

native final function LevelInfo GetEntryLevel ();

native(544) final function ResetKeyboard ();

native final function SetViewTarget (Actor NewViewTarget);

native event ClientTravel (string URL, ETravelType TravelType, bool bItems);

native(546) final function UpdateURL (string NewOption, string NewValue, bool bSaveDefault);

native final function string GetDefaultURL (string Option);

native function CopyToClipboard (string Text);

native function string PasteFromClipboard ();

simulated function bool IsPlayerPassiveSpectator ();

native(524) final function int FindStairRotation (float DeltaTime);

function ServerReadyToLoadWeaponSound ();

function ServerPlayerPref (PlayerPrefInfo newPlayerPrefs);

event SetMatchResult (string _UserUbiID, int iField, int iValue);

native(2706) final function byte GetKey (string szActionKey, optional bool bPlanningInput);

native(2707) final function string GetActionKey (byte Key, optional bool bPlanningInput);

native(2708) final function string GetEnumName (byte Key, optional bool bPlanningInput);

native(2709) final function ChangeInputSet (byte iInputSet);

native(2710) final function SetKey (string szKeyAndAction);

native(2713) final function SetSoundOptions ();

native(2714) final function ChangeVolumeTypeLinear (ESoundSlot eVolumeLine, float fVolumeLinear);

native(1320) final function bool PB_CanPlayerSpawn ();

native event ClientHearSound (Actor Actor, Sound S, ESoundSlot ID);

function bool ShouldDisplayIncomingMessages ()
{
	return True;
}

simulated function PlayerInput getPlayerInput ()
{
	return PlayerInput;
}

event PostBeginPlay ()
{
	Super.PostBeginPlay();
	SpawnDefaultHUD();
	if ( Level.LevelEnterText != "" )
	{
		ClientMessage(Level.LevelEnterText);
	}
	DesiredFOV=DefaultFOV;
	SetViewTarget(self);
	if ( Level.NetMode == NM_Standalone )
	{
		AddCheats();
	}
}

function PendingStasis ()
{
	bStasis=True;
	Pawn=None;
	GotoState('Scripting');
}

function AddCheats ()
{
	if ( Level.bKNoInit )
	{
		return;
	}
	if ( CheatManager == None )
	{
		CheatManager=new CheatClass;
	}
}

function SpawnDefaultHUD ()
{
	myHUD=Spawn(Class'HUD',self);
}

function Reset ()
{
	PawnDied();
	Super.Reset();
	SetViewTarget(self);
	bBehindView=False;
	WaitDelay=Level.TimeSeconds + 2;
	GotoState('BaseSpectating');
}

event InitMultiPlayerOptions ();

event InitInputSystem ()
{
	PlayerInput=new InputClass;
	UpdateOptions();
}

function UpdateOptions ()
{
	PlayerInput.UpdateMouseOptions();
}

function ClientGotoState (name NewState, name NewLabel)
{
	GotoState(NewState,NewLabel);
}

function AskForPawn ()
{
	if ( Pawn != None )
	{
		GivePawn(Pawn);
	}
	else
	{
		if ( IsInState('GameEnded') )
		{
			ClientGotoState('GameEnded','Begin');
		}
		else
		{
			if ( IsInState('Dead') )
			{
				bFrozen=False;
				ServerReStartPlayer();
			}
		}
	}
}

function GivePawn (Pawn NewPawn)
{
	if ( NewPawn == None )
	{
		return;
	}
	Pawn=NewPawn;
	NewPawn.Controller=self;
	ClientReStart();
}

function int GetFacingDirection ()
{
	local Vector X;
	local Vector Y;
	local Vector Z;
	local Vector Dir;

	GetAxes(Pawn.Rotation,X,Y,Z);
	Dir=Normal(Pawn.Acceleration);
	if ( Y Dot Dir > 0 )
	{
		return 49152 + 16384 * X Dot Dir;
	}
	else
	{
		return 16384 - 16384 * X Dot Dir;
	}
}

function Possess (Pawn aPawn)
{
	if ( bOnlySpectator )
	{
		return;
	}
	SetRotation(aPawn.Rotation);
	aPawn.PossessedBy(self);
	Pawn=aPawn;
	Pawn.bStasis=False;
	if ( PlayerReplicationInfo != None )
	{
		PlayerReplicationInfo.bIsFemale=Pawn.bIsFemale;
	}
	Restart();
}

function UnPossess ()
{
	if ( Pawn != None )
	{
		SetLocation(Pawn.Location);
		Pawn.RemoteRole=ROLE_SimulatedProxy;
		Pawn.UnPossessed();
		if ( ViewTarget == Pawn )
		{
			SetViewTarget(self);
		}
	}
	Pawn.Controller=None;
	Pawn=None;
	GotoState('Spectating');
}

function bool GetGender ();

function PawnDied ()
{
	EndZoom();
	if ( Pawn != None )
	{
		Pawn.RemoteRole=ROLE_SimulatedProxy;
	}
	if ( ViewTarget == Pawn )
	{
		bBehindView=True;
	}
	Super.PawnDied();
}

function ClientSetHUD (Class<HUD> newHUDType, Class<ScoreBoard> newScoringType)
{
	local HUD NewHUD;
	local HUD OldHUD;

	if ( Level.bKNoInit )
	{
		return;
	}
	if ( (myHUD == None) || (newHUDType != None) && (newHUDType != myHUD.Class) )
	{
		NewHUD=Spawn(newHUDType,self);
		if ( NewHUD != None )
		{
			OldHUD=myHUD;
			myHUD=NewHUD;
			if ( OldHUD != None )
			{
				OldHUD.Destroy();
			}
		}
	}
}

function ViewFlash (float DeltaTime)
{
	local Vector goalFog;
	local float goalscale;
	local float Delta;

	Delta=FMin(0.10,DeltaTime);
	goalscale=1.00 + DesiredFlashScale + ConstantGlowScale;
	goalFog=DesiredFlashFog + ConstantGlowFog;
	if ( Pawn != None )
	{
		goalscale += Pawn.HeadVolume.ViewFlash.X;
		goalFog += Pawn.HeadVolume.ViewFog;
	}
	DesiredFlashScale -= DesiredFlashScale * 2 * Delta;
	DesiredFlashFog -= DesiredFlashFog * 2 * Delta;
	FlashScale.X += (goalscale - FlashScale.X + InstantFlash) * 10 * Delta;
	FlashFog += (goalFog - FlashFog + InstantFog) * 10 * Delta;
	InstantFlash=0.00;
	InstantFog=vect(0.00,0.00,0.00);
	if ( FlashScale.X > 0.98 )
	{
		FlashScale.X=1.00;
	}
	FlashScale=FlashScale.X * vect(1.00,1.00,1.00);
	if ( FlashFog.X < 0.02 )
	{
		FlashFog.X=0.00;
	}
	if ( FlashFog.Y < 0.02 )
	{
		FlashFog.Y=0.00;
	}
	if ( FlashFog.Z < 0.02 )
	{
		FlashFog.Z=0.00;
	}
}

event ReceiveLocalizedMessage (Class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	Message.static.ClientReceive(self,Switch,RelatedPRI_1,RelatedPRI_2,OptionalObject);
}

function ClientErrorMessageLocalized (coerce string szKeyID)
{
	myHUD.AddTextMessage(Localize("Errors",szKeyID,"R6Engine"),Class'LocalMessage');
}

event ClientMessage (coerce string S, optional name type)
{
	if ( type == 'None' )
	{
		type='Event';
	}
	TeamMessage(PlayerReplicationInfo,S,type);
}

event TeamMessage (PlayerReplicationInfo PRI, coerce string S, name type)
{
	if ( (type == 'Say') || (type == 'TeamSay') )
	{
		S=PRI.PlayerName $ ": " $ S;
	}
	Player.InteractionMaster.Process_Message(S,6.00,Player.LocalInteractions);
}

simulated function PlayBeepSound ();

simulated function ClientPlaySound (Sound ASound, ESoundSlot eSlot)
{
	if ( Pawn != None )
	{
		Pawn.PlaySound(ASound,eSlot);
	}
	else
	{
		ViewTarget.PlaySound(ASound,eSlot);
	}
}

simulated function ClientStopSound (Sound ASound)
{
	if ( Pawn != None )
	{
		Pawn.StopSound(ASound);
	}
	else
	{
		ViewTarget.StopSound(ASound);
	}
}

simulated function ClientReliablePlaySound (Sound ASound, optional bool bVolumeControl)
{
	ClientPlaySound(ASound,SLOT_SFX);
}

simulated event Destroyed ()
{
	local SavedMove Next;

	if ( bOnlySpectator )
	{
		Pawn=None;
	}
	if ( Pawn != None )
	{
		Pawn.Health=0;
		Pawn.Died(self,Class'Suicided',Pawn.Location);
	}
	if ( CheatManager != None )
	{
		CheatManager.ClearOuter();
	}
	CheatManager=None;
	if ( PlayerInput != None )
	{
		PlayerInput.ClearOuter();
	}
	PlayerInput=None;
	Super.Destroyed();
	myHUD.Destroy();
	myHUD=None;
	while ( FreeMoves != None )
	{
		Next=FreeMoves.NextMove;
		FreeMoves.Destroy();
		FreeMoves=Next;
	}
	while ( SavedMoves != None )
	{
		Next=SavedMoves.NextMove;
		SavedMoves.Destroy();
		SavedMoves=Next;
	}
}

function ClientSetMusic (string NewSong, EMusicTransition NewTransition)
{
	Song=NewSong;
	Transition=NewTransition;
}

function ToggleZoom ()
{
	if ( DefaultFOV != DesiredFOV )
	{
		EndZoom();
	}
	else
	{
		StartZoom();
	}
}

function StartZoom ()
{
	ZoomLevel=0.00;
	bZooming=True;
}

function StopZoom ()
{
	bZooming=False;
}

function EndZoom ()
{
	bZooming=False;
	DesiredFOV=DefaultFOV;
}

function FixFOV ()
{
	FovAngle=Default.DefaultFOV;
	DesiredFOV=Default.DefaultFOV;
	DefaultFOV=Default.DefaultFOV;
}

function SetFOV (float NewFOV)
{
	DesiredFOV=NewFOV;
	FovAngle=NewFOV;
}

function ResetFOV ()
{
	DesiredFOV=DefaultFOV;
	FovAngle=DefaultFOV;
}

exec function SetSensitivity (float f)
{
	PlayerInput.UpdateSensitivity(f);
}

exec function Say (string Msg)
{
	if ( (Msg == "") || (Level.NetMode == NM_Standalone) )
	{
		return;
	}
	Level.Game.Broadcast(self,Msg,'Say');
}

exec function TeamSay (string Msg)
{
	if ( (Msg == "") || (Level.NetMode == NM_Standalone) )
	{
		return;
	}
	Level.Game.BroadcastTeam(self,Msg,'TeamSay');
}

event PreClientTravel ()
{
}

function ClientSetFixedCamera (bool B)
{
	bFixedCamera=B;
}

function ClientSetBehindView (bool B)
{
	bBehindView=B;
}

function ClientReplicateSkins (Material Skin1, optional Material Skin2, optional Material Skin3, optional Material Skin4)
{
	Log("Getting " $ string(Skin1) $ ", " $ string(Skin2) $ ", " $ string(Skin3) $ ", " $ string(Skin4));
	return;
}

function ClientVoiceMessage (PlayerReplicationInfo Sender, PlayerReplicationInfo Recipient, name messagetype, byte MessageID)
{
	local VoicePack V;

	if ( (Sender == None) || (Sender.VoiceType == None) || (Player.Console == None) )
	{
		return;
	}
	V=Spawn(Sender.VoiceType,self);
	if ( V != None )
	{
		V.ClientInitialize(Sender,Recipient,messagetype,MessageID);
	}
}

function ForceDeathUpdate ()
{
	LastUpdateTime=Level.TimeSeconds - 10;
}

function ShorterServerMove (float TimeStamp, Vector ClientLoc, int View, int iNewRotOffset)
{
	ServerMove(TimeStamp,vect(0.00,0.00,0.00),ClientLoc,False,False,False,View,iNewRotOffset);
}

function ShortServerMove (float TimeStamp, Vector ClientLoc, bool NewbRun, bool NewbDuck, bool NewbCrawl, int View, int iNewRotOffset)
{
	ServerMove(TimeStamp,vect(0.00,0.00,0.00),ClientLoc,NewbRun,NewbDuck,NewbCrawl,View,iNewRotOffset);
}

function ServerMove (float TimeStamp, Vector InAccel, Vector ClientLoc, bool NewbRun, bool NewbDuck, bool NewbCrawl, int View, int iNewRotOffset, optional byte OldTimeDelta, optional int OldAccel)
{
	local float DeltaTime;
	local float clientErr;
	local float OldTimeStamp;
	local Rotator DeltaRot;
	local Rotator Rot;
	local Rotator ViewRot;
	local Vector Accel;
	local Vector LocDiff;
	local Vector ClientVel;
	local Vector ClientFloor;
	local Rotator rNewRotOffset;
	local int maxPitch;
	local int ViewPitch;
	local int ViewYaw;
	local bool OldbCrawl;
	local bool OldbRun;
	local bool OldbDuck;
	local EDoubleClickDir OldDoubleClickMove;
	local Actor ClientBase;
	local EPhysics ClientPhysics;

	if ( CurrentTimeStamp >= TimeStamp )
	{
		return;
	}
	if ( OldTimeDelta != 0 )
	{
		OldTimeStamp=TimeStamp - OldTimeDelta / 500 - 0.00;
		if ( CurrentTimeStamp < OldTimeStamp - 0.00 )
		{
			Accel.X=OldAccel >>> 23;
			if ( Accel.X > 127 )
			{
				Accel.X=-1.00 * (Accel.X - 128);
			}
			Accel.Y=OldAccel >>> 15 & 255;
			if ( Accel.Y > 127 )
			{
				Accel.Y=-1.00 * (Accel.Y - 128);
			}
			Accel.Z=OldAccel >>> 7 & 255;
			if ( Accel.Z > 127 )
			{
				Accel.Z=-1.00 * (Accel.Z - 128);
			}
			Accel *= 20;
			OldbRun=(OldAccel & 64) != 0;
			OldbDuck=(OldAccel & 32) != 0;
			OldbCrawl=(OldAccel & 16) != 0;
			OldDoubleClickMove=DCLICK_None;
			MoveAutonomous(OldTimeStamp - CurrentTimeStamp,OldbRun,OldbDuck,OldbCrawl,OldDoubleClickMove,Accel,rot(0,0,0));
			CurrentTimeStamp=OldTimeStamp;
		}
	}
	ViewPitch=View / 32768;
	ViewYaw=2 * (View - 32768 * ViewPitch);
	ViewPitch *= 2;
	Accel=InAccel / 10;
	DeltaTime=TimeStamp - CurrentTimeStamp;
	if ( ServerTimeStamp > 0 )
	{
		TimeMargin += DeltaTime - 1.01 * (Level.TimeSeconds - ServerTimeStamp);
		if ( TimeMargin > MaxTimeMargin )
		{
			TimeMargin -= DeltaTime;
			if ( TimeMargin < 0.50 )
			{
				MaxTimeMargin=Default.MaxTimeMargin;
			}
			else
			{
				MaxTimeMargin=0.50;
			}
			DeltaTime=0.00;
		}
	}
	CurrentTimeStamp=TimeStamp;
	ServerTimeStamp=Level.TimeSeconds;
	ViewRot.Pitch=ViewPitch;
	ViewRot.Yaw=ViewYaw;
	ViewRot.Roll=0;
	SetRotation(ViewRot);
	if ( Pawn != None )
	{
		rNewRotOffset.Pitch=2 * iNewRotOffset / 32768;
		rNewRotOffset.Yaw=2 * (32767 & iNewRotOffset);
		Pawn.m_rRotationOffset=rNewRotOffset;
		Rot.Roll=0;
		Rot.Yaw=ViewYaw;
		if ( (Pawn.Physics == 3) || (Pawn.Physics == 4) )
		{
			maxPitch=2;
		}
		else
		{
			maxPitch=1;
		}
		if ( (ViewPitch > maxPitch * RotationRate.Pitch) && (ViewPitch < 65536 - maxPitch * RotationRate.Pitch) )
		{
			if ( ViewPitch < 32768 )
			{
				Rot.Pitch=maxPitch * RotationRate.Pitch;
			}
			else
			{
				Rot.Pitch=65536 - maxPitch * RotationRate.Pitch;
			}
		}
		else
		{
			Rot.Pitch=ViewPitch;
		}
		DeltaRot=Rotation - Rot;
		Pawn.SetRotation(Rot);
	}
	if ( (Level.Pauser == None) && (DeltaTime > 0) )
	{
		MoveAutonomous(DeltaTime,NewbRun,NewbDuck,NewbCrawl,DCLICK_None,Accel,DeltaRot);
	}
	if ( Level.TimeSeconds - LastUpdateTime > 0.30 )
	{
		clientErr=10000.00;
	}
	else
	{
		if ( Level.TimeSeconds - LastUpdateTime > 180.00 / Player.CurrentNetSpeed )
		{
			if ( Pawn == None )
			{
				LocDiff=Location - ClientLoc;
			}
			else
			{
				LocDiff=Pawn.Location - ClientLoc;
			}
			clientErr=LocDiff Dot LocDiff;
		}
	}
	if ( clientErr > 3 )
	{
		if ( Pawn == None )
		{
			ClientPhysics=Physics;
			ClientLoc=Location;
			ClientVel=Velocity;
		}
		else
		{
			ClientPhysics=Pawn.Physics;
			ClientVel=Pawn.Velocity;
			ClientBase=Pawn.Base;
			if ( Mover(Pawn.Base) != None )
			{
				ClientLoc=Pawn.Location - Pawn.Base.Location;
			}
			else
			{
				ClientLoc=Pawn.Location;
			}
			ClientFloor=Pawn.Floor;
		}
		LastUpdateTime=Level.TimeSeconds;
		if ( m_SaveOldClientBase != ClientBase )
		{
			m_SaveOldClientBase=ClientBase;
			ClientAdjustBase(ClientBase);
		}
		if ( (Pawn == None) || (Pawn.Physics != 9) )
		{
			if ( ClientVel == vect(0.00,0.00,0.00) )
			{
				if ( IsInState('PlayerWalking') && (Pawn != None) && (Pawn.Physics == 1) )
				{
					VeryShortClientAdjustPosition(TimeStamp,ClientLoc.X,ClientLoc.Y,ClientLoc.Z);
				}
				else
				{
					ShortClientAdjustPosition(TimeStamp,GetStateName(),ClientPhysics,ClientLoc.X,ClientLoc.Y,ClientLoc.Z);
				}
			}
			else
			{
				ClientAdjustPosition(TimeStamp,GetStateName(),ClientPhysics,ClientLoc.X,ClientLoc.Y,ClientLoc.Z,ClientVel.X,ClientVel.Y,ClientVel.Z);
			}
		}
		else
		{
			LongClientAdjustPosition(TimeStamp,GetStateName(),ClientPhysics,ClientLoc.X,ClientLoc.Y,ClientLoc.Z,ClientVel.X,ClientVel.Y,ClientVel.Z,ClientFloor.X,ClientFloor.Y,ClientFloor.Z);
		}
	}
}

function ProcessMove (float DeltaTime, Vector NewAccel, EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
{
	if ( Pawn != None )
	{
		Pawn.Acceleration=NewAccel;
	}
}

final function MoveAutonomous (float DeltaTime, bool NewbRun, bool NewbDuck, bool NewbCrawl, EDoubleClickDir DoubleClickMove, Vector NewAccel, Rotator DeltaRot)
{
	if ( NewbRun )
	{
		bRun=1;
	}
	else
	{
		bRun=0;
	}
	if ( Level.NetMode != 3 )
	{
		if ( NewbDuck )
		{
			bDuck=1;
		}
		else
		{
			bDuck=0;
		}
		if ( NewbCrawl )
		{
			m_bCrawl=True;
		}
		else
		{
			m_bCrawl=False;
		}
	}
	HandleWalking();
	ProcessMove(DeltaTime,NewAccel,DoubleClickMove,DeltaRot);
	if ( Pawn != None )
	{
		Pawn.AutonomousPhysics(DeltaTime);
	}
	else
	{
		AutonomousPhysics(DeltaTime);
	}
	if ( Pawn != None )
	{
		Pawn.m_vEyeLocation=Pawn.GetBoneCoords('R6 PonyTail1').Origin;
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
	LongClientAdjustPosition(TimeStamp,'PlayerWalking',PHYS_Walking,NewLocX,NewLocY,NewLocZ,0.00,0.00,0.00,Floor.X,Floor.Y,Floor.Z);
}

function ShortClientAdjustPosition (float TimeStamp, name NewState, EPhysics newPhysics, float NewLocX, float NewLocY, float NewLocZ)
{
	local Vector Floor;

	if ( Pawn != None )
	{
		Floor=Pawn.Floor;
	}
	LongClientAdjustPosition(TimeStamp,NewState,newPhysics,NewLocX,NewLocY,NewLocZ,0.00,0.00,0.00,Floor.X,Floor.Y,Floor.Z);
}

function ClientAdjustPosition (float TimeStamp, name NewState, EPhysics newPhysics, float NewLocX, float NewLocY, float NewLocZ, float NewVelX, float NewVelY, float NewVelZ)
{
	local Vector Floor;

	if ( Pawn != None )
	{
		Floor=Pawn.Floor;
	}
	LongClientAdjustPosition(TimeStamp,NewState,newPhysics,NewLocX,NewLocY,NewLocZ,NewVelX,NewVelY,NewVelZ,Floor.X,Floor.Y,Floor.Z);
}

function LongClientAdjustPosition (float TimeStamp, name NewState, EPhysics newPhysics, float NewLocX, float NewLocY, float NewLocZ, float NewVelX, float NewVelY, float NewVelZ, float NewFloorX, float NewFloorY, float NewFloorZ)
{
	local Vector NewLocation;
	local Vector NewFloor;
	local Actor MoveActor;

	if ( Pawn != None )
	{
		if (  !bNetOwner )
		{
			Pawn.m_vEyeLocation=Pawn.GetBoneCoords('R6 PonyTail1').Origin;
		}
		if ( Pawn.bTearOff || Pawn.m_bUseRagdoll )
		{
			GotoState('Dead');
			return;
		}
		MoveActor=Pawn;
	}
	else
	{
		MoveActor=self;
	}
	if ( CurrentTimeStamp > TimeStamp )
	{
		return;
	}
	CurrentTimeStamp=TimeStamp;
	NewLocation.X=NewLocX;
	NewLocation.Y=NewLocY;
	NewLocation.Z=NewLocZ;
	MoveActor.Velocity.X=NewVelX;
	MoveActor.Velocity.Y=NewVelY;
	MoveActor.Velocity.Z=NewVelZ;
	NewFloor.X=NewFloorX;
	NewFloor.Y=NewFloorY;
	NewFloor.Z=NewFloorZ;
	if ( NewLocation != MoveActor.Location )
	{
		MoveActor.bCanTeleport=False;
		MoveActor.SetLocation(NewLocation);
		MoveActor.bCanTeleport=True;
	}
	if ( newPhysics != MoveActor.Physics )
	{
		if ( (newPhysics != 14) && (MoveActor.Physics != 14) )
		{
			MoveActor.SetPhysics(newPhysics);
		}
	}
	if ( GetStateName() != NewState )
	{
		GotoState(NewState);
	}
	bUpdatePosition=True;
}

function ClientAdjustBase (Actor newClientBase)
{
	local Actor MoveActor;

	if ( Pawn != None )
	{
		MoveActor=Pawn;
	}
	else
	{
		MoveActor=self;
	}
	MoveActor.SetBase(newClientBase);
}

function ClientUpdatePosition ()
{
	local SavedMove CurrentMove;
	local int realbRun;
	local int realbDuck;
	local bool realbCrawl;
	local float TotalTime;

	bUpdatePosition=False;
	realbRun=bRun;
	realbDuck=bDuck;
	realbCrawl=m_bCrawl;
	CurrentMove=SavedMoves;
	bUpdating=True;
	while ( CurrentMove != None )
	{
		if ( CurrentMove.TimeStamp <= CurrentTimeStamp )
		{
			SavedMoves=CurrentMove.NextMove;
			CurrentMove.NextMove=FreeMoves;
			FreeMoves=CurrentMove;
			FreeMoves.Clear();
			CurrentMove=SavedMoves;
		}
		else
		{
			TotalTime += CurrentMove.Delta;
			MoveAutonomous(CurrentMove.Delta,CurrentMove.bRun,CurrentMove.bDuck,CurrentMove.m_bCrawl,CurrentMove.DoubleClickMove,CurrentMove.Acceleration,rot(0,0,0));
			CurrentMove=CurrentMove.NextMove;
		}
	}
	bUpdating=False;
	bDuck=realbDuck;
	bRun=realbRun;
	m_bCrawl=realbCrawl;
}

function AdjustRadius (float MaxMove)
{
	local Pawn P;
	local Vector Dir;

	foreach DynamicActors(Class'Pawn',P)
	{
		if ( (P != Pawn) && (P.Velocity != vect(0.00,0.00,0.00)) && P.bBlockPlayers )
		{
			Dir=Normal(P.Location - Pawn.Location);
			if ( (Pawn.Velocity Dot Dir > 0) && (P.Velocity Dot Dir > 0) )
			{
				if ( VSize(P.Location - Pawn.Location) < P.CollisionRadius + Pawn.CollisionRadius + MaxMove )
				{
					P.MoveSmooth(P.Velocity * 0.50 * PlayerReplicationInfo.Ping);
				}
			}
		}
	}
}

final function SavedMove GetFreeMove ()
{
	local SavedMove S;
	local SavedMove first;
	local int i;

	if ( FreeMoves == None )
	{
		for (S=SavedMoves;S != None;S=S.NextMove)
		{
			i++;
			if ( i > 30 )
			{
				first=SavedMoves;
				SavedMoves=SavedMoves.NextMove;
				first.Clear();
				first.NextMove=None;
				while ( SavedMoves != None )
				{
					S=SavedMoves;
					SavedMoves=SavedMoves.NextMove;
					S.Clear();
					S.NextMove=FreeMoves;
					FreeMoves=S;
				}
				return first;
			}
		}
		return Spawn(Class'SavedMove');
	}
	else
	{
		S=FreeMoves;
		FreeMoves=FreeMoves.NextMove;
		S.NextMove=None;
		return S;
	}
}

function int CompressAccel (int C)
{
	if ( C >= 0 )
	{
		C=Min(C,127);
	}
	else
	{
		C=Min(Abs(C),127) + 128;
	}
	return C;
}

function ReplicateMove (float DeltaTime, Vector NewAccel, EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
{
	local SavedMove NewMove;
	local SavedMove OldMove;
	local SavedMove LastMove;
	local float OldTimeDelta;
	local float NetMoveDelta;
	local int i;
	local int OldAccel;
	local Vector BuildAccel;
	local Vector AccelNorm;
	local Vector MoveLoc;
	local Rotator rSendRot;

	if ( PendingMove != None )
	{
		PendingMove.SetMoveFor(self,DeltaTime,NewAccel,DoubleClickMove);
	}
	if ( SavedMoves != None )
	{
		NewMove=SavedMoves;
		AccelNorm=Normal(NewAccel);
		while ( NewMove.NextMove != None )
		{
			if ( (NewMove.DoubleClickMove != 0) && (NewMove.DoubleClickMove < 5) || (NewMove.Acceleration != NewAccel) && (Normal(NewMove.Acceleration) Dot AccelNorm < 0.95) )
			{
				OldMove=NewMove;
			}
			NewMove=NewMove.NextMove;
		}
		if ( (NewMove.DoubleClickMove != 0) && (NewMove.DoubleClickMove < 5) || (NewMove.Acceleration != NewAccel) && (Normal(NewMove.Acceleration) Dot AccelNorm < 0.95) )
		{
			OldMove=NewMove;
		}
	}
	LastMove=NewMove;
	NewMove=GetFreeMove();
	if ( NewMove == None )
	{
		return;
	}
	NewMove.SetMoveFor(self,DeltaTime,NewAccel,DoubleClickMove);
	ProcessMove(NewMove.Delta,NewMove.Acceleration,NewMove.DoubleClickMove,DeltaRot);
	if ( Pawn != None )
	{
		Pawn.AutonomousPhysics(NewMove.Delta);
	}
	else
	{
		AutonomousPhysics(DeltaTime);
	}
	if ( PendingMove == None )
	{
		PendingMove=NewMove;
	}
	else
	{
		NewMove.NextMove=FreeMoves;
		FreeMoves=NewMove;
		FreeMoves.Clear();
		NewMove=PendingMove;
	}
	NetMoveDelta=FMax(80.00 / Player.CurrentNetSpeed,0.01);
	if ( PendingMove.Delta < NetMoveDelta - ClientUpdateTime )
	{
		return;
	}
	else
	{
		if ( (ClientUpdateTime < 0) && (PendingMove.Delta < NetMoveDelta - ClientUpdateTime) )
		{
			return;
		}
		else
		{
			ClientUpdateTime=PendingMove.Delta - NetMoveDelta;
			if ( SavedMoves == None )
			{
				SavedMoves=PendingMove;
			}
			else
			{
				LastMove.NextMove=PendingMove;
			}
			PendingMove=None;
		}
	}
	if ( OldMove != None )
	{
		OldTimeDelta=FMin(255.00,(Level.TimeSeconds - OldMove.TimeStamp) * 500);
		BuildAccel=0.05 * OldMove.Acceleration + vect(0.50,0.50,0.50);
		OldAccel=(CompressAccel(BuildAccel.X) << 23) + (CompressAccel(BuildAccel.Y) << 15) + (CompressAccel(BuildAccel.Z) << 7);
		if ( OldMove.bRun )
		{
			OldAccel += 64;
		}
		if ( OldMove.bDuck )
		{
			OldAccel += 32;
		}
		if ( OldMove.m_bCrawl )
		{
			OldAccel += 16;
		}
		OldAccel += OldMove.DoubleClickMove;
	}
	if ( Pawn == None )
	{
		MoveLoc=Location;
	}
	else
	{
		rSendRot=Pawn.m_rRotationOffset;
		MoveLoc=Pawn.Location;
	}
	if ( Level.TimeSeconds > m_fNextUpdateTime )
	{
		m_fNextUpdateTime=Level.TimeSeconds + 1 / NetClientMaxTickRate;
	}
	else
	{
		return;
	}
	if ( (NewMove.Acceleration == vect(0.00,0.00,0.00)) && (NewMove.DoubleClickMove == 0) )
	{
		if ( (NewMove.bDuck == False) && (NewMove.bRun == False) && (NewMove.m_bCrawl == False) )
		{
			ShorterServerMove(NewMove.TimeStamp,MoveLoc,(32767 & Rotation.Pitch / 2) * 32768 + (32767 & Rotation.Yaw / 2),(32767 & rSendRot.Pitch / 2) * 32768 + (32767 & rSendRot.Yaw / 2));
		}
		else
		{
			ShortServerMove(NewMove.TimeStamp,MoveLoc,NewMove.bRun,NewMove.bDuck,NewMove.m_bCrawl,(32767 & Rotation.Pitch / 2) * 32768 + (32767 & Rotation.Yaw / 2),(32767 & rSendRot.Pitch / 2) * 32768 + (32767 & rSendRot.Yaw / 2));
		}
	}
	else
	{
		ServerMove(NewMove.TimeStamp,NewMove.Acceleration * 10,MoveLoc,NewMove.bRun,NewMove.bDuck,NewMove.m_bCrawl,(32767 & Rotation.Pitch / 2) * 32768 + (32767 & Rotation.Yaw / 2),(32767 & rSendRot.Pitch / 2) * 32768 + (32767 & rSendRot.Yaw / 2),OldTimeDelta,OldAccel);
	}
}

function HandleWalking ()
{
	if ( Pawn != None )
	{
		Pawn.SetWalking(((bRun != 0) || (bDuck != 0)) &&  !Region.Zone.IsA('WarpZoneInfo'));
	}
}

function ServerRestartGame ()
{
}

function SetFOVAngle (float NewFOV)
{
	FovAngle=NewFOV;
}

function ClientFlash (float Scale, Vector fog)
{
	DesiredFlashScale=Scale;
	DesiredFlashFog=0.00 * fog;
}

function ClientSetFlash (Vector Scale, Vector fog)
{
	FlashScale=Scale;
	FlashFog=fog;
}

function ClientInstantFlash (float Scale, Vector fog)
{
	InstantFlash=Scale;
	InstantFog=0.00 * fog;
}

function ClientAdjustGlow (float Scale, Vector fog)
{
	ConstantGlowScale += Scale;
	ConstantGlowFog += 0.00 * fog;
}

function ClientShake (Vector ShakeRoll, Vector OffsetMag, Vector ShakeRate, float OffsetTime)
{
	if ( (MaxShakeRoll < ShakeRoll.X) || (ShakeRollTime < 0.01 * ShakeRoll.Y) )
	{
		MaxShakeRoll=ShakeRoll.X;
		ShakeRollTime=0.01 * ShakeRoll.Y;
		ShakeRollRate=0.01 * ShakeRoll.Z;
	}
	if ( VSize(OffsetMag) > VSize(MaxShakeOffset) )
	{
		ShakeOffsetTime=OffsetTime * vect(1.00,1.00,1.00);
		MaxShakeOffset=OffsetMag;
		ShakeOffsetRate=ShakeRate;
	}
}

function ShakeView (float shaketime, float RollMag, Vector OffsetMag, float RollRate, Vector OffsetRate, float OffsetTime)
{
	local Vector ShakeRoll;

	ShakeRoll.X=RollMag;
	ShakeRoll.Y=100.00 * shaketime;
	ShakeRoll.Z=100.00 * RollRate;
	ClientShake(ShakeRoll,OffsetMag,OffsetRate,OffsetTime);
}

function damageAttitudeTo (Pawn Other, float Damage)
{
	if ( (Other != None) && (Other != Pawn) && (Damage > 0) )
	{
		Enemy=Other;
	}
}

function Typing (bool bTyping)
{
	bIsTyping=bTyping;
	if ( bTyping && (Pawn != None) &&  !Pawn.bTearOff )
	{
		Pawn.ChangeAnimation();
	}
	if ( Level.Game.StatLog != None )
	{
		Level.Game.StatLog.LogTypingEvent(bTyping,self);
	}
}

exec function Bind (string szKeyAndCommand)
{
	local string szResult;
	local int iPos;

	if ( InPlanningMode() && !Level.m_bInGamePlanningActive )
	{
		szResult="INPUTPLANNING" @ szKeyAndCommand;
	}
	else
	{
		szResult="INPUT" @ szKeyAndCommand;
	}
	SetKey(szResult);
	iPos=InStr(szKeyAndCommand," ");
	szResult=Right(szKeyAndCommand,Len(szKeyAndCommand) - iPos - 1);
	if ( szResult ~= "CONSOLE" )
	{
		if ( InPlanningMode() &&  !Level.m_bInGamePlanningActive )
		{
			szResult="INPUT" @ szKeyAndCommand;
		}
		else
		{
			szResult="INPUTPLANNING" @ szKeyAndCommand;
		}
		SetKey(szResult);
	}
}

exec function SetOption (string szKeyAndCommand)
{
	local string szResult;

	szResult="R6GAMEOPTIONS" @ szKeyAndCommand;
	SetKey(szResult);
}

exec function Jump (optional float f)
{
}

exec function Speech (name type, int Index, int Callsign)
{
}

exec function RestartLevel ()
{
}

function bool SetPause (bool bPause)
{
	return Level.Game.SetPause(bPause,self);
}

exec function Pause ()
{
}

exec function ActivateInventoryItem (Class InvItem)
{
}

exec function ThrowWeapon ()
{
}

exec function PrevWeapon ()
{
}

exec function NextWeapon ()
{
}

exec function SwitchWeapon (byte f)
{
}

exec function PrevItem ()
{
}

exec function ActivateItem ()
{
}

exec function Fire (optional float f)
{
	if ( Level.Pauser == PlayerReplicationInfo )
	{
		SetPause(False);
		return;
	}
	if ( (Pawn != None) && (Pawn.EngineWeapon != None) &&  !GameReplicationInfo.m_bGameOverRep )
	{
		Pawn.EngineWeapon.Fire(f);
	}
}

exec function AltFire (optional float f)
{
	if ( Level.Pauser == PlayerReplicationInfo )
	{
		SetPause(False);
		return;
	}
	if ( Pawn.EngineWeapon != None )
	{
		Pawn.EngineWeapon.AltFire(f);
	}
}

exec function Use ()
{
	ServerUse();
}

function ServerUse ()
{
}

exec function Suicide ()
{
}

function HandleServerMsg (string _szServerMsg, optional int iLifeTime)
{
	myHUD.AddTextServerMessage(_szServerMsg,Class'LocalMessage',iLifeTime);
}

function ClientCantRequestChangeNameYet ()
{
	HandleServerMsg(Localize("Game","CantRequestChangeNameYet","R6GameInfo"));
}

simulated function ServerChangeName (string S)
{
	local int iChangeNameTime;

//	iChangeNameTime=Class'Actor'.GetGameOptions().ChangeNameTime;
	if ( (m_iChangeNameLastTime == 0) || (Level.TimeSeconds > m_iChangeNameLastTime + iChangeNameTime) )
	{
		m_iChangeNameLastTime=Level.TimeSeconds;
		ClientChangeName(S);
	}
	else
	{
		ClientCantRequestChangeNameYet();
	}
}

simulated function ClientChangeName (string S)
{
	ChangeName(S);
	UpdateURL("Name",S,True);
	SaveConfig();
	Class'Actor'.static.GetGameOptions().characterName=S;
	Class'Actor'.static.GetGameOptions().SaveConfig();
}

exec function Name (coerce string S)
{
	ServerChangeName(S);
}

exec function SetName (coerce string S)
{
	ServerChangeName(S);
}

simulated function ChangeName (out coerce string S)
{
	if ( Len(S) > 15 )
	{
		S=Left(S,15);
	}
	ReplaceText(S," ","_");
	ReplaceText(S,"~","_");
	ReplaceText(S,"?","_");
	ReplaceText(S,",","_");
	ReplaceText(S,"#","_");
	ReplaceText(S,"/","_");
	S=RemoveInvalidChars(S);
	if ( Level.NetMode != 0 )
	{
		Level.Game.ChangeName(self,S,False);
	}
}

function ChangeTeam (int N)
{
	local TeamInfo OldTeam;

	OldTeam=PlayerReplicationInfo.Team;
	Level.Game.ChangeTeam(self,N);
	if ( Level.Game.bTeamGame && (PlayerReplicationInfo.Team != OldTeam) )
	{
		Pawn.Died(None,Class'DamageType',Pawn.Location);
	}
}

exec function ClearProgressMessages ()
{
}

exec event SetProgressMessage (int Index, string S, Color C)
{
}

exec event SetProgressTime (float t)
{
	ProgressTimeOut=t + Level.TimeSeconds;
}

function Restart ()
{
	Super.Restart();
	ServerTimeStamp=0.00;
	TimeMargin=0.00;
	EnterStartState();
	SetViewTarget(Pawn);
	bBehindView=Pawn.PointOfView();
	ClientReStart();
}

function EnterStartState ()
{
	local name NewState;

	if ( Pawn.PhysicsVolume.bWaterVolume )
	{
		if ( Pawn.HeadVolume.bWaterVolume )
		{
			Pawn.BreathTime=Pawn.UnderWaterTime;
		}
		NewState=Pawn.WaterMovementState;
	}
	else
	{
		NewState=Pawn.LandMovementState;
	}
	if ( IsInState(NewState) )
	{
		BeginState();
	}
	else
	{
		GotoState(NewState);
	}
}

function ClientReStart ()
{
	if ( Pawn == None )
	{
		GotoState('WaitingForPawn');
		return;
	}
	Pawn.ClientReStart();
	SetViewTarget(Pawn);
	bBehindView=Pawn.PointOfView();
	EnterStartState();
}

exec function BehindView (bool B)
{
	if (  !CheatManager.CanExec() )
	{
		return;
	}
	bBehindView=B;
	ClientSetBehindView(bBehindView);
}

function ChangedWeapon ()
{
}

event TravelPostAccept ()
{
	if ( Pawn.Health <= 0 )
	{
		Pawn.Health=Pawn.Default.Health;
	}
}

event PlayerTick (float DeltaTime)
{
	PlayerInput.PlayerInput(DeltaTime);
	if ( bUpdatePosition )
	{
		ClientUpdatePosition();
	}
	PlayerMove(DeltaTime);
}

function PlayerMove (float DeltaTime);

function bool NotifyLanded (Vector HitNormal)
{
	return bUpdating;
}

function EAttitude AttitudeTo (Pawn Other)
{
	if ( Other.Controller == None )
	{
		return Attitude_Ignore;
	}
	if ( Other.IsPlayerPawn() )
	{
		return AttitudeToPlayer;
	}
	return Other.Controller.AttitudeToPlayer;
}

function AdjustView (float DeltaTime)
{
	if ( FovAngle != DesiredFOV )
	{
		if ( FovAngle > DesiredFOV )
		{
			FovAngle=FovAngle - FMax(7.00,0.90 * DeltaTime * (FovAngle - DesiredFOV));
		}
		else
		{
			FovAngle=FovAngle - FMin(-7.00,0.90 * DeltaTime * (FovAngle - DesiredFOV));
		}
		if ( Abs(FovAngle - DesiredFOV) <= 10 )
		{
			FovAngle=DesiredFOV;
		}
	}
	if ( bZooming )
	{
		ZoomLevel += DeltaTime * 1.00;
		if ( ZoomLevel > 0.90 )
		{
			ZoomLevel=0.90;
		}
		DesiredFOV=FClamp(90.00 - ZoomLevel * 88.00,1.00,170.00);
	}
}

function CalcBehindView (out Vector CameraLocation, out Rotator CameraRotation, float dist)
{
	local Vector View;
	local Vector HitLocation;
	local Vector HitNormal;
	local float ViewDist;

	CameraRotation=Rotation;
	View=vect(1.00,0.00,0.00) >> CameraRotation;
	if ( Trace(HitLocation,HitNormal,CameraLocation - (dist + 30) * vector(CameraRotation),CameraLocation) != None )
	{
		ViewDist=FMin((CameraLocation - HitLocation) Dot View,dist);
	}
	else
	{
		ViewDist=dist;
	}
	CameraLocation -= (ViewDist - 30) * View;
}

function CalcFirstPersonView (out Vector CameraLocation, out Rotator CameraRotation)
{
	CameraRotation=Rotation;
	CameraLocation=CameraLocation + Pawn.EyePosition() + ShakeOffset;
}

event AddCameraEffect (CameraEffect NewEffect, optional bool RemoveExisting)
{
	if ( RemoveExisting )
	{
		RemoveCameraEffect(NewEffect);
	}
	CameraEffects.Length=CameraEffects.Length + 1;
	CameraEffects[CameraEffects.Length - 1]=NewEffect;
}

event RemoveCameraEffect (CameraEffect ExEffect)
{
	local int EffectIndex;

	EffectIndex=0;
	while ( EffectIndex < CameraEffects.Length )
	{
		if ( CameraEffects[EffectIndex] == ExEffect )
		{
			CameraEffects.Remove (EffectIndex,1);
			return;
		}
		EffectIndex++;
	}
}

function Rotator GetViewRotation ()
{
	if ( bBehindView && (Pawn != None) )
	{
		return Pawn.Rotation;
	}
	return Rotation;
}

event PlayerCalcView (out Actor ViewActor, out Vector CameraLocation, out Rotator CameraRotation)
{
	local Pawn PTarget;

	if ( (ViewTarget == None) || ViewTarget.bDeleteMe )
	{
		Log("No VIEWTARGET in PlayerCalcView");
		if ( (Pawn != None) &&  !Pawn.bDeleteMe )
		{
			SetViewTarget(Pawn);
		}
		else
		{
			SetViewTarget(self);
		}
	}
	ViewActor=ViewTarget;
	CameraLocation=ViewTarget.Location;
	if ( ViewTarget == Pawn )
	{
		if ( bBehindView )
		{
			CalcBehindView(CameraLocation,CameraRotation,CameraDist * Pawn.Default.CollisionRadius);
		}
		else
		{
			CalcFirstPersonView(CameraLocation,CameraRotation);
		}
		return;
	}
	if ( ViewTarget == self )
	{
		if ( bCameraPositionLocked )
		{
			CameraRotation=CheatManager.LockedRotation;
		}
		else
		{
			CameraRotation=Rotation;
		}
		return;
	}
	else
	{
		if ( ViewTarget != None )
		{
			if ( bBehindView )
			{
				CalcBehindView(CameraLocation,CameraRotation,CameraDist * Pawn(ViewTarget).Default.CollisionRadius);
			}
			else
			{
				CalcFirstPersonView(CameraLocation,CameraRotation);
			}
			return;
		}
	}
	CameraRotation=ViewTarget.Rotation;
	PTarget=Pawn(ViewTarget);
	if ( PTarget != None )
	{
		if ( Level.NetMode == NM_Client )
		{
			if ( PTarget.IsPlayerPawn() )
			{
				PTarget.SetViewRotation(TargetViewRotation);
				CameraRotation=TargetViewRotation;
			}
		}
		else
		{
			if ( PTarget.IsPlayerPawn() )
			{
				CameraRotation=PTarget.GetViewRotation();
			}
		}
		if (  !bBehindView )
		{
			CameraLocation += PTarget.EyePosition();
		}
	}
	if ( bBehindView )
	{
		CameraLocation=CameraLocation + (ViewTarget.Default.CollisionHeight - ViewTarget.CollisionHeight) * vect(0.00,0.00,1.00);
		CalcBehindView(CameraLocation,CameraRotation,CameraDist * ViewTarget.Default.CollisionRadius);
	}
}

function CheckShake (out float MaxOffset, out float offset, out float Rate, out float Time)
{
	if ( Abs(offset) < Abs(MaxOffset) )
	{
		return;
	}
	offset=MaxOffset;
	if ( Time > 1 )
	{
		if ( Time * Abs(MaxOffset / Rate) <= 1 )
		{
			MaxOffset=MaxOffset * (1 / Time - 1);
		}
		else
		{
			MaxOffset *= -1;
		}
		Time -= 1;
		Rate *= -1;
	}
	else
	{
		MaxOffset=0.00;
		offset=0.00;
		Rate=0.00;
	}
}

function ViewShake (float DeltaTime)
{
	local Rotator ViewRotation;
	local float FRoll;

	if ( ShakeOffsetRate != vect(0.00,0.00,0.00) )
	{
		ShakeOffset.X += DeltaTime * ShakeOffsetRate.X;
		CheckShake(MaxShakeOffset.X,ShakeOffset.X,ShakeOffsetRate.X,ShakeOffsetTime.X);
		ShakeOffset.Y += DeltaTime * ShakeOffsetRate.Y;
		CheckShake(MaxShakeOffset.Y,ShakeOffset.Y,ShakeOffsetRate.Y,ShakeOffsetTime.Y);
		ShakeOffset.Z += DeltaTime * ShakeOffsetRate.Z;
		CheckShake(MaxShakeOffset.Z,ShakeOffset.Z,ShakeOffsetRate.Z,ShakeOffsetTime.Z);
	}
	ViewRotation=Rotation;
	if ( ShakeRollRate != 0 )
	{
		ViewRotation.Roll=(ViewRotation.Roll & 65535) + ShakeRollRate * DeltaTime & 65535;
		if ( ViewRotation.Roll > 32768 )
		{
			ViewRotation.Roll -= 65536;
		}
		FRoll=ViewRotation.Roll;
		CheckShake(MaxShakeRoll,FRoll,ShakeRollRate,ShakeRollTime);
		ViewRotation.Roll=FRoll;
	}
	else
	{
		if ( bZeroRoll )
		{
			ViewRotation.Roll=0;
		}
	}
	SetRotation(ViewRotation);
}

function bool TurnTowardNearestEnemy ();

function TurnAround ()
{
	if (  !bSetTurnRot )
	{
		TurnRot180=Rotation;
		TurnRot180.Yaw += 32768;
		bSetTurnRot=True;
	}
	DesiredRotation=TurnRot180;
	bRotateToDesired=DesiredRotation.Yaw != Rotation.Yaw;
}

function UpdateRotation (float DeltaTime, float maxPitch)
{
	local Rotator NewRotation;
	local Rotator ViewRotation;

	if ( bInterpolating || (Pawn != None) && Pawn.bInterpolating )
	{
		ViewShake(DeltaTime);
		return;
	}
	ViewRotation=Rotation;
	DesiredRotation=ViewRotation;
	if ( bTurnToNearest != 0 )
	{
		TurnTowardNearestEnemy();
	}
	else
	{
		if ( bTurn180 != 0 )
		{
			TurnAround();
		}
		else
		{
			TurnTarget=None;
			bRotateToDesired=False;
			bSetTurnRot=False;
			ViewRotation.Yaw += 32.00 * DeltaTime * aTurn;
			ViewRotation.Pitch += 32.00 * DeltaTime * aLookUp;
		}
	}
	ViewRotation.Pitch=ViewRotation.Pitch & 65535;
	if ( (ViewRotation.Pitch > 18000) && (ViewRotation.Pitch < 49152) )
	{
		if ( aLookUp > 0 )
		{
			ViewRotation.Pitch=18000;
		}
		else
		{
			ViewRotation.Pitch=49152;
		}
	}
	SetRotation(ViewRotation);
	ViewShake(DeltaTime);
	ViewFlash(DeltaTime);
	NewRotation=ViewRotation;
	NewRotation.Roll=Rotation.Roll;
	if (  !bRotateToDesired && (Pawn != None) && ( !bFreeCamera ||  !bBehindView) )
	{
		Pawn.FaceRotation(NewRotation,DeltaTime);
	}
}

function ClearDoubleClick ()
{
	if ( PlayerInput != None )
	{
		PlayerInput.DoubleClickTimer=0.00;
	}
}

state PlayerWalking
{
	function bool NotifyPhysicsVolumeChange (PhysicsVolume NewVolume)
	{
		if ( NewVolume.bWaterVolume )
		{
			GotoState(Pawn.WaterMovementState);
		}
		return False;
	}

	function ProcessMove (float DeltaTime, Vector NewAccel, EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
	{
		local Vector OldAccel;
		local bool OldCrouch;

		if ( Pawn == None )
		{
			return;
		}
		OldAccel=Pawn.Acceleration;
		Pawn.Acceleration=NewAccel;
		if ( bPressedJump )
		{
			Pawn.DoJump(bUpdating);
		}
		if ( Pawn.Physics != 2 )
		{
			OldCrouch=Pawn.bWantsToCrouch;
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
		}
	}

	function PlayerMove (float DeltaTime)
	{
		local Vector X;
		local Vector Y;
		local Vector Z;
		local Vector NewAccel;
		local EDoubleClickDir DoubleClickMove;
		local Rotator OldRotation;
		local Rotator ViewRotation;
		local bool bSaveJump;

		GetAxes(Pawn.Rotation,X,Y,Z);
		NewAccel=aForward * X + aStrafe * Y;
		NewAccel.Z=0.00;
		if ( VSize(NewAccel) < 1.00 )
		{
			NewAccel=vect(0.00,0.00,0.00);
		}
//		DoubleClickMove=PlayerInput.CheckForDoubleClickMove(DeltaTime);
		GroundPitch=0;
		ViewRotation=Rotation;
		if ( Pawn.Physics != 1 )
		{
			if (  !bKeyboardLook && (bLook == 0) && bCenterView )
			{
				ViewRotation.Pitch=ViewRotation.Pitch & 65535;
				if ( ViewRotation.Pitch > 32768 )
				{
					ViewRotation.Pitch -= 65536;
				}
				ViewRotation.Pitch=ViewRotation.Pitch * (1 - 12 * FMin(0.08,DeltaTime));
				if ( Abs(ViewRotation.Pitch) < 1000 )
				{
					ViewRotation.Pitch=0;
				}
			}
		}
		Pawn.CheckBob(DeltaTime,Y);
		SetRotation(ViewRotation);
		OldRotation=Rotation;
		UpdateRotation(DeltaTime,1.00);
		if ( bPressedJump && Pawn.CannotJumpNow() )
		{
			bSaveJump=True;
			bPressedJump=False;
		}
		else
		{
			bSaveJump=False;
		}
		if ( Role < Role_Authority )
		{
			ReplicateMove(DeltaTime,NewAccel,DoubleClickMove,OldRotation - Rotation);
		}
		else
		{
			ProcessMove(DeltaTime,NewAccel,DoubleClickMove,OldRotation - Rotation);
		}
		bPressedJump=bSaveJump;
	}

	function BeginState ()
	{
		if ( Pawn.Mesh == None )
		{
			Pawn.SetMesh();
		}
		DoubleClickDir=DCLICK_None;
		Pawn.ShouldCrouch(False);
		bPressedJump=False;
		if ( (Pawn.Physics != PHYS_Falling) && (Pawn.Physics != PHYS_Karma) )
		{
			Pawn.SetPhysics(PHYS_None);
		}
		GroundPitch=0;
	}

	function EndState ()
	{
		GroundPitch=0;
		if ( (Pawn != None) && (bDuck == 0) )
		{
			Pawn.ShouldCrouch(False);
		}
	}

}

state PlayerClimbing
{
	function bool NotifyPhysicsVolumeChange (PhysicsVolume NewVolume)
	{
		if ( NewVolume.bWaterVolume )
		{
			GotoState(Pawn.WaterMovementState);
		}
		else
		{
			GotoState(Pawn.LandMovementState);
		}
		return False;
	}

	function ProcessMove (float DeltaTime, Vector NewAccel, EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
	{
		local Vector OldAccel;

		OldAccel=Pawn.Acceleration;
		Pawn.Acceleration=NewAccel;
		if ( bPressedJump )
		{
			Pawn.DoJump(bUpdating);
			if ( Pawn.Physics == 2 )
			{
				GotoState('PlayerWalking');
			}
		}
	}

	function PlayerMove (float DeltaTime)
	{
		local Vector X;
		local Vector Y;
		local Vector Z;
		local Vector NewAccel;
		local EDoubleClickDir DoubleClickMove;
		local Rotator OldRotation;
		local Rotator ViewRotation;
		local bool bSaveJump;

		GetAxes(Rotation,X,Y,Z);
		if ( Pawn.OnLadder != None )
		{
			NewAccel=aForward * Pawn.OnLadder.ClimbDir;
		}
		else
		{
			NewAccel=aForward * X + aStrafe * Y;
		}
		if ( VSize(NewAccel) < 1.00 )
		{
			NewAccel=vect(0.00,0.00,0.00);
		}
		ViewRotation=Pawn.Rotation;
		SetRotation(ViewRotation);
		OldRotation=Rotation;
		UpdateRotation(DeltaTime,1.00);
		if ( Role < Role_Authority )
		{
			ReplicateMove(DeltaTime,NewAccel,DoubleClickMove,OldRotation - Rotation);
		}
		else
		{
			ProcessMove(DeltaTime,NewAccel,DoubleClickMove,OldRotation - Rotation);
		}
		bPressedJump=bSaveJump;
	}

	function BeginState ()
	{
		Pawn.ShouldCrouch(False);
		bPressedJump=False;
	}

	function EndState ()
	{
		if ( Pawn != None )
		{
			Pawn.ShouldCrouch(False);
		}
	}

}

state PlayerSpidering
{
	event bool NotifyHitWall (Vector HitNormal, Actor HitActor)
	{
		Pawn.SetPhysics(PHYS_Spider);
		Pawn.SetBase(HitActor,HitNormal);
		return True;
	}

	function UpdateRotation (float DeltaTime, float maxPitch)
	{
		local Rotator TempRot;
		local Rotator ViewRotation;
		local Vector MyFloor;
		local Vector CrossDir;
		local Vector FwdDir;
		local Vector OldFwdDir;
		local Vector OldX;
		local Vector RealFloor;

		if ( bInterpolating || Pawn.bInterpolating )
		{
			ViewShake(DeltaTime);
			return;
		}
		TurnTarget=None;
		bRotateToDesired=False;
		bSetTurnRot=False;
		if ( (Pawn.Base == None) || (Pawn.Floor == vect(0.00,0.00,0.00)) )
		{
			MyFloor=vect(0.00,0.00,1.00);
		}
		else
		{
			MyFloor=Pawn.Floor;
		}
		if ( MyFloor != OldFloor )
		{
			RealFloor=MyFloor;
			MyFloor=Normal(6 * DeltaTime * MyFloor + (1 - 6 * DeltaTime) * OldFloor);
			if ( RealFloor Dot MyFloor > 1.00 )
			{
				MyFloor=RealFloor;
			}
			CrossDir=Normal(RealFloor Cross OldFloor);
			FwdDir=CrossDir Cross MyFloor;
			OldFwdDir=CrossDir Cross OldFloor;
//			ViewX=MyFloor * OldFloor Dot ViewX + CrossDir * CrossDir Dot ViewX + FwdDir * OldFwdDir Dot ViewX;
            ViewX = MyFloor * (OldFloor Dot ViewX)
                        + CrossDir * (CrossDir Dot ViewX)
                        + FwdDir * (OldFwdDir Dot ViewX);
			ViewX=Normal(ViewX);
//			ViewZ=MyFloor * OldFloor Dot ViewZ + CrossDir * CrossDir Dot ViewZ + FwdDir * OldFwdDir Dot ViewZ;
            ViewZ = MyFloor * (OldFloor Dot ViewZ)
                        + CrossDir * (CrossDir Dot ViewZ)
                        + FwdDir * (OldFwdDir Dot ViewZ);
			ViewZ=Normal(ViewZ);
			OldFloor=MyFloor;
			ViewY=Normal(MyFloor Cross ViewX);
		}
		if ( (aTurn != 0) || (aLookUp != 0) )
		{
			if ( aTurn != 0 )
			{
				ViewX=Normal(ViewX + 2 * ViewY * Sin(0.00 * DeltaTime * aTurn));
			}
			if ( aLookUp != 0 )
			{
				OldX=ViewX;
				ViewX=Normal(ViewX + 2 * ViewZ * Sin(0.00 * DeltaTime * aLookUp));
				ViewZ=Normal(ViewX Cross ViewY);
				if ( ViewZ Dot MyFloor < 0.71 )
				{
					OldX=Normal(OldX - MyFloor * (MyFloor Dot OldX));
					if ( ViewX Dot MyFloor > 0 )
					{
						ViewX=Normal(OldX + MyFloor);
					}
					else
					{
						ViewX=Normal(OldX - MyFloor);
					}
					ViewZ=Normal(ViewX Cross ViewY);
				}
			}
			ViewY=Normal(MyFloor Cross ViewX);
		}
		ViewRotation=OrthoRotation(ViewX,ViewY,ViewZ);
		SetRotation(ViewRotation);
		ViewShake(DeltaTime);
		ViewFlash(DeltaTime);
		Pawn.FaceRotation(ViewRotation,DeltaTime);
	}

	function bool NotifyLanded (Vector HitNormal)
	{
		Pawn.SetPhysics(PHYS_Spider);
		return bUpdating;
	}

	function bool NotifyPhysicsVolumeChange (PhysicsVolume NewVolume)
	{
		if ( NewVolume.bWaterVolume )
		{
			GotoState(Pawn.WaterMovementState);
		}
		return False;
	}

	function ProcessMove (float DeltaTime, Vector NewAccel, EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
	{
		local Vector OldAccel;

		OldAccel=Pawn.Acceleration;
		Pawn.Acceleration=NewAccel;
		if ( bPressedJump )
		{
			Pawn.DoJump(bUpdating);
		}
	}

	function PlayerMove (float DeltaTime)
	{
		local Vector NewAccel;
		local EDoubleClickDir DoubleClickMove;
		local Rotator OldRotation;
		local Rotator ViewRotation;
		local bool bSaveJump;

		GroundPitch=0;
		ViewRotation=Rotation;
/*		if (! ( !bKeyboardLook) && (bLook == 0) && bCenterView ) goto JL0037;
	JL0037:*/
		Pawn.CheckBob(DeltaTime,vect(0.00,0.00,0.00));
		SetRotation(ViewRotation);
		OldRotation=Rotation;
		UpdateRotation(DeltaTime,1.00);
		NewAccel=aForward * Normal(ViewX - OldFloor * (OldFloor Dot ViewX)) + aStrafe * ViewY;
        NewAccel = aForward*Normal(ViewX - OldFloor * (OldFloor Dot ViewX)) + aStrafe*ViewY;
		if ( VSize(NewAccel) < 1.00 )
		{
			NewAccel=vect(0.00,0.00,0.00);
		}
		if ( bPressedJump && Pawn.CannotJumpNow() )
		{
			bSaveJump=True;
			bPressedJump=False;
		}
		else
		{
			bSaveJump=False;
		}
		if ( Role < Role_Authority )
		{
			ReplicateMove(DeltaTime,NewAccel,DoubleClickMove,OldRotation - Rotation);
		}
		else
		{
			ProcessMove(DeltaTime,NewAccel,DoubleClickMove,OldRotation - Rotation);
		}
		bPressedJump=bSaveJump;
	}

	function BeginState ()
	{
		local Rotator newRot;

		if ( Pawn.Mesh == None )
		{
			Pawn.SetMesh();
		}
		OldFloor=vect(0.00,0.00,1.00);
		GetAxes(Rotation,ViewX,ViewY,ViewZ);
		DoubleClickDir=DCLICK_None;
		Pawn.ShouldCrouch(False);
		bPressedJump=False;
		if ( Pawn.Physics != PHYS_Falling )
		{
			Pawn.SetPhysics(PHYS_Spider);
		}
		GroundPitch=0;
		Pawn.bCrawler=True;
		Pawn.SetCollisionSize(Pawn.Default.CollisionHeight,Pawn.Default.CollisionHeight);
	}

	function EndState ()
	{
		GroundPitch=0;
		if ( Pawn != None )
		{
			Pawn.SetCollisionSize(Pawn.Default.CollisionRadius,Pawn.Default.CollisionHeight);
			Pawn.ShouldCrouch(False);
			Pawn.bCrawler=Pawn.Default.bCrawler;
		}
	}

}

state PlayerSwimming
{
	function bool WantsSmoothedView ()
	{
		return  !Pawn.bJustLanded;
	}

	function bool NotifyLanded (Vector HitNormal)
	{
		if ( Pawn.PhysicsVolume.bWaterVolume )
		{
			Pawn.SetPhysics(PHYS_Swimming);
		}
		else
		{
			GotoState(Pawn.LandMovementState);
		}
		return bUpdating;
	}

	function bool NotifyPhysicsVolumeChange (PhysicsVolume NewVolume)
	{
		local Actor HitActor;
		local Vector HitLocation;
		local Vector HitNormal;
		local Vector checkpoint;

		if (  !NewVolume.bWaterVolume )
		{
			Pawn.SetPhysics(PHYS_Falling);
			if ( Pawn.bUpAndOut && Pawn.CheckWaterJump(HitNormal) )
			{
				Pawn.Velocity.Z=FMax(Pawn.JumpZ,420.00) + 2 * Pawn.CollisionRadius;
				GotoState(Pawn.LandMovementState);
			}
			else
			{
				if ( (Pawn.Velocity.Z > 160) ||  !Pawn.TouchingWaterVolume() )
				{
					GotoState(Pawn.LandMovementState);
				}
				else
				{
					checkpoint=Pawn.Location;
					checkpoint.Z -= Pawn.CollisionHeight + 6.00;
					HitActor=Trace(HitLocation,HitNormal,checkpoint,Pawn.Location,False);
					if ( HitActor != None )
					{
						GotoState(Pawn.LandMovementState);
					}
					else
					{
						Enable('Timer');
						SetTimer(0.70,False);
					}
				}
			}
		}
		else
		{
			Disable('Timer');
			Pawn.SetPhysics(PHYS_Swimming);
		}
		return False;
	}

	function ProcessMove (float DeltaTime, Vector NewAccel, EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
	{
		local Vector X;
		local Vector Y;
		local Vector Z;
		local Vector OldAccel;

		GetAxes(Rotation,X,Y,Z);
		OldAccel=Pawn.Acceleration;
		Pawn.Acceleration=NewAccel;
		Pawn.bUpAndOut=(X Dot Pawn.Acceleration > 0) && ((Pawn.Acceleration.Z > 0) || (Rotation.Pitch > 2048));
		if (  !Pawn.PhysicsVolume.bWaterVolume )
		{
			NotifyPhysicsVolumeChange(Pawn.PhysicsVolume);
		}
	}

	function PlayerMove (float DeltaTime)
	{
		local Rotator OldRotation;
		local Vector X;
		local Vector Y;
		local Vector Z;
		local Vector NewAccel;

		GetAxes(Rotation,X,Y,Z);
		NewAccel=aForward * X + aStrafe * Y + aUp * vect(0.00,0.00,1.00);
		if ( VSize(NewAccel) < 1.00 )
		{
			NewAccel=vect(0.00,0.00,0.00);
		}
		Pawn.CheckBob(DeltaTime,Y);
		OldRotation=Rotation;
		UpdateRotation(DeltaTime,2.00);
		if ( Role < Role_Authority )
		{
			ReplicateMove(DeltaTime,NewAccel,DCLICK_None,OldRotation - Rotation);
		}
		else
		{
			ProcessMove(DeltaTime,NewAccel,DCLICK_None,OldRotation - Rotation);
		}
		bPressedJump=False;
	}

	function Timer ()
	{
		if (  !Pawn.PhysicsVolume.bWaterVolume && (Role == Role_Authority) )
		{
			GotoState(Pawn.LandMovementState);
		}
		Disable('Timer');
	}

	function BeginState ()
	{
		Disable('Timer');
		Pawn.SetPhysics(PHYS_Swimming);
	}

}

state PlayerFlying
{
	function PlayerMove (float DeltaTime)
	{
		local Vector X;
		local Vector Y;
		local Vector Z;

		GetAxes(Rotation,X,Y,Z);
		Pawn.Acceleration=aForward * X + aStrafe * Y;
		if ( VSize(Pawn.Acceleration) < 1.00 )
		{
			Pawn.Acceleration=vect(0.00,0.00,0.00);
		}
		if ( bCheatFlying && (Pawn.Acceleration == vect(0.00,0.00,0.00)) )
		{
			Pawn.Velocity=vect(0.00,0.00,0.00);
		}
		UpdateRotation(DeltaTime,2.00);
		if ( Role < Role_Authority )
		{
			ReplicateMove(DeltaTime,Pawn.Acceleration,DCLICK_None,rot(0,0,0));
		}
		else
		{
			ProcessMove(DeltaTime,Pawn.Acceleration,DCLICK_None,rot(0,0,0));
		}
	}

	function BeginState ()
	{
		Pawn.SetPhysics(PHYS_Flying);
	}

}

state PlayerHelicoptering extends PlayerFlying
{
	function PlayerMove (float DeltaTime)
	{
		local Vector X;
		local Vector Y;
		local Vector Z;

		GetAxes(Rotation,X,Y,Z);
		Pawn.Acceleration=aForward * X + aStrafe * Y + aUp * vect(0.00,0.00,1.00);
		if ( VSize(Pawn.Acceleration) < 1.00 )
		{
			Pawn.Acceleration=vect(0.00,0.00,0.00);
		}
		if ( bCheatFlying && (Pawn.Acceleration == vect(0.00,0.00,0.00)) )
		{
			Pawn.Velocity=vect(0.00,0.00,0.00);
		}
		UpdateRotation(DeltaTime,2.00);
		if ( Role < Role_Authority )
		{
			ReplicateMove(DeltaTime,Pawn.Acceleration,DCLICK_None,rot(0,0,0));
		}
		else
		{
			ProcessMove(DeltaTime,Pawn.Acceleration,DCLICK_None,rot(0,0,0));
		}
	}

}

state BaseSpectating
{
	function ProcessMove (float DeltaTime, Vector NewAccel, EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
	{
		Acceleration=NewAccel;
		MoveSmooth(Acceleration * DeltaTime);
	}

	function PlayerMove (float DeltaTime)
	{
		local Rotator NewRotation;
		local Vector X;
		local Vector Y;
		local Vector Z;

		GetAxes(Rotation,X,Y,Z);
		Acceleration=0.02 * (aForward * X + aStrafe * Y + aUp * vect(0.00,0.00,1.00));
		UpdateRotation(DeltaTime,1.00);
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

state Scripting
{
	exec function Fire (optional float f)
	{
	}

	exec function AltFire (optional float f)
	{
		Fire(f);
	}

}

function ServerViewNextPlayer ()
{
	local Controller C;
	local Pawn Pick;
	local bool bFound;
	local bool bRealSpec;

	bRealSpec=bOnlySpectator;
	bOnlySpectator=True;
	for (C=Level.ControllerList;C != None;C=C.nextController)
	{
		Log("Check spectate " $ string(C.Pawn) $ " can " $ string(Level.Game.CanSpectate(self,True,C.Pawn)));
		if ( (C.Pawn != None) && Level.Game.CanSpectate(self,True,C.Pawn) )
		{
			if ( Pick == None )
			{
				Pick=C.Pawn;
			}
			if ( bFound )
			{
				Pick=C.Pawn;
				break;
			}
			else
			{
				bFound=ViewTarget == C.Pawn;
			}
		}
	}
	Log("best is " $ string(Pick));
	SetViewTarget(Pick);
	Log("Viewtarget is " $ string(ViewTarget));
	if ( ViewTarget == self )
	{
		bBehindView=False;
	}
	else
	{
		bBehindView=True;
	}
	bOnlySpectator=bRealSpec;
}

event ClientSetNewViewTarget ();

function ServerViewSelf ()
{
	bBehindView=False;
	SetViewTarget(self);
	ClientMessage(OwnCamera,'Event');
}

state Spectating extends BaseSpectating
{
	ignores  ThrowWeapon, Suicide, ClientReStart, RestartLevel, SwitchWeapon;

	exec function Fire (optional float f)
	{
		bBehindView=True;
		ServerViewNextPlayer();
	}

	exec function AltFire (optional float f)
	{
		bBehindView=False;
		ServerViewSelf();
	}

	function BeginState ()
	{
		if ( Pawn != None )
		{
			SetLocation(Pawn.Location);
			UnPossess();
		}
		bCollideWorld=True;
	}

	function EndState ()
	{
		if ( PlayerReplicationInfo != None )
		{
			PlayerReplicationInfo.bIsSpectator=False;
		}
		bCollideWorld=False;
	}

}

auto state PlayerWaiting extends BaseSpectating
{
	ignores  TakeDamage;

	exec function Jump (optional float f)
	{
	}

	exec function Suicide ()
	{
	}

	function ChangeTeam (int N)
	{
		Level.Game.ChangeTeam(self,N);
	}

	function ServerReStartPlayer ()
	{
		if ( Level.TimeSeconds < WaitDelay )
		{
			return;
		}
		if ( Level.NetMode == NM_Client )
		{
			return;
		}
		if ( Level.Game.bWaitingToStartMatch )
		{
			PlayerReplicationInfo.bReadyToPlay=True;
		}
		else
		{
			Level.Game.RestartPlayer(self);
		}
	}

	exec function Fire (optional float f)
	{
		ServerReStartPlayer();
	}

	exec function AltFire (optional float f)
	{
		ServerReStartPlayer();
	}

	function EndState ()
	{
		if ( Pawn != None )
		{
			Pawn.SetMesh();
		}
		if ( PlayerReplicationInfo != None )
		{
			PlayerReplicationInfo.SetWaitingPlayer(False);
		}
		bCollideWorld=False;
	}

	function BeginState ()
	{
		if ( PlayerReplicationInfo != None )
		{
			PlayerReplicationInfo.SetWaitingPlayer(True);
		}
		bCollideWorld=True;
		myHUD.bShowScores=False;
	}

}

state WaitingForPawn extends BaseSpectating
{
	ignores  SwitchWeapon, KilledBy;

	exec function Fire (optional float f)
	{
	}

	exec function AltFire (optional float f)
	{
	}

	function LongClientAdjustPosition (float TimeStamp, name NewState, EPhysics newPhysics, float NewLocX, float NewLocY, float NewLocZ, float NewVelX, float NewVelY, float NewVelZ, float NewFloorX, float NewFloorY, float NewFloorZ)
	{
	}

	function PlayerTick (float DeltaTime)
	{
		Global.PlayerTick(DeltaTime);
		if ( Pawn != None )
		{
			Pawn.Controller=self;
			ClientReStart();
		}
	}

	function Timer ()
	{
		AskForPawn();
	}

	function BeginState ()
	{
		SetTimer(0.20,True);
	}

	function EndState ()
	{
		SetTimer(0.00,False);
	}

}

state GameEnded
{
	ignores  Suicide, TakeDamage, KilledBy;

	exec function ThrowWeapon ()
	{
	}

	function ServerRestartGame ()
	{
		Level.Game.RestartGame();
	}

	exec function Fire (optional float f)
	{
		if ( Role < Role_Authority )
		{
			return;
		}
		if (  !bFrozen )
		{
			ServerRestartGame();
		}
		else
		{
			if ( TimerRate <= 0 )
			{
				SetTimer(1.50,False);
			}
		}
	}

	exec function AltFire (optional float f)
	{
		Fire(f);
	}

	function PlayerMove (float DeltaTime)
	{
		local Vector X;
		local Vector Y;
		local Vector Z;
		local Rotator ViewRotation;

		GetAxes(Rotation,X,Y,Z);
		if (  !bFixedCamera )
		{
			ViewRotation=Rotation;
			ViewRotation.Yaw += 32.00 * DeltaTime * aTurn;
			ViewRotation.Pitch += 32.00 * DeltaTime * aLookUp;
			ViewRotation.Pitch=ViewRotation.Pitch & 65535;
			if ( (ViewRotation.Pitch > 18000) && (ViewRotation.Pitch < 49152) )
			{
				if ( aLookUp > 0 )
				{
					ViewRotation.Pitch=18000;
				}
				else
				{
					ViewRotation.Pitch=49152;
				}
			}
			SetRotation(ViewRotation);
		}
		else
		{
			if ( ViewTarget != None )
			{
				SetRotation(ViewTarget.Rotation);
			}
		}
		ViewShake(DeltaTime);
		ViewFlash(DeltaTime);
		if ( Role < Role_Authority )
		{
			ReplicateMove(DeltaTime,vect(0.00,0.00,0.00),DCLICK_None,rot(0,0,0));
		}
		else
		{
			ProcessMove(DeltaTime,vect(0.00,0.00,0.00),DCLICK_None,rot(0,0,0));
		}
		bPressedJump=False;
	}

	function ServerMove (float TimeStamp, Vector InAccel, Vector ClientLoc, bool NewbRun, bool NewbDuck, bool NewbCrawl, int View, int iNewRotOffset, optional byte OldTimeDelta, optional int OldAccel)
	{
		Global.ServerMove(TimeStamp,InAccel,ClientLoc,NewbRun,NewbDuck,NewbCrawl,(32767 & Rotation.Pitch / 2) * 32768 + (32767 & Rotation.Yaw / 2),0);
	}

	function FindGoodView ()
	{
		local Vector cameraLoc;
		local Rotator cameraRot;
		local Rotator ViewRotation;
		local int tries;
		local int besttry;
		local float bestDist;
		local float newdist;
		local int startYaw;
		local Actor ViewActor;

		ViewRotation=Rotation;
		ViewRotation.Pitch=56000;
		tries=0;
		besttry=0;
		bestDist=0.00;
		startYaw=ViewRotation.Yaw;
		tries=0;
		while ( tries < 16 )
		{
			cameraLoc=ViewTarget.Location;
			PlayerCalcView(ViewActor,cameraLoc,cameraRot);
			newdist=VSize(cameraLoc - ViewTarget.Location);
			if ( newdist > bestDist )
			{
				bestDist=newdist;
				besttry=tries;
			}
			ViewRotation.Yaw += 4096;
			tries++;
		}
		ViewRotation.Yaw=startYaw + besttry * 4096;
		SetRotation(ViewRotation);
	}

	function Timer ()
	{
		bFrozen=False;
	}

	function BeginState ()
	{
		local Pawn P;

		Level.m_bInGamePlanningActive=False;
		EndZoom();
		bFire=0;
		bAltFire=0;
		if ( Pawn != None )
		{
			Pawn.SimAnim.AnimRate=0;
			Pawn.bPhysicsAnimUpdate=False;
			Pawn.StopAnimating();
			Pawn.SetCollision(False,False,False);
		}
		myHUD.bShowScores=True;
		bFrozen=True;
		if (  !bFixedCamera )
		{
			bBehindView=True;
		}
		SetTimer(1.50,False);
		SetPhysics(PHYS_None);
		foreach DynamicActors(Class'Pawn',P)
		{
			P.Velocity=vect(0.00,0.00,0.00);
			P.SetPhysics(PHYS_None);
		}
	}

}

state Dead
{
	ignores  SwitchWeapon, KilledBy;

	function ServerReStartPlayer ()
	{
		Super.ServerReStartPlayer();
	}

	exec function Fire (optional float f)
	{
		ServerReStartPlayer();
	}

	exec function AltFire (optional float f)
	{
		if ( myHUD.bShowScores )
		{
			Fire(f);
		}
		else
		{
			Timer();
		}
	}

	function ServerMove (float TimeStamp, Vector Accel, Vector ClientLoc, bool NewbRun, bool NewbDuck, bool NewbCrawl, int View, int iNewRotOffset, optional byte OldTimeDelta, optional int OldAccel)
	{
		Global.ServerMove(TimeStamp,Accel,ClientLoc,False,False,False,View,iNewRotOffset);
	}

	function PlayerMove (float DeltaTime)
	{
		local Vector X;
		local Vector Y;
		local Vector Z;
		local Rotator ViewRotation;

		if (  !bFrozen )
		{
			if ( bPressedJump )
			{
				Fire(0.00);
				bPressedJump=False;
			}
			GetAxes(Rotation,X,Y,Z);
			ViewRotation=Rotation;
			ViewRotation.Yaw += 32.00 * DeltaTime * aTurn;
			ViewRotation.Pitch += 32.00 * DeltaTime * aLookUp;
			ViewRotation.Pitch=ViewRotation.Pitch & 65535;
			if ( (ViewRotation.Pitch > 18000) && (ViewRotation.Pitch < 49152) )
			{
				if ( aLookUp > 0 )
				{
					ViewRotation.Pitch=18000;
				}
				else
				{
					ViewRotation.Pitch=49152;
				}
			}
			SetRotation(ViewRotation);
			if ( Role < Role_Authority )
			{
				ReplicateMove(DeltaTime,vect(0.00,0.00,0.00),DCLICK_None,rot(0,0,0));
			}
		}
		ViewShake(DeltaTime);
		ViewFlash(DeltaTime);
	}

	function FindGoodView ()
	{
		local Vector cameraLoc;
		local Rotator cameraRot;
		local Rotator ViewRotation;
		local int tries;
		local int besttry;
		local float bestDist;
		local float newdist;
		local int startYaw;
		local Actor ViewActor;

		if ( ViewTarget == None )
		{
			return;
		}
		ViewRotation=Rotation;
		ViewRotation.Pitch=56000;
		tries=0;
		besttry=0;
		bestDist=0.00;
		startYaw=ViewRotation.Yaw;
		tries=0;
		while ( tries < 16 )
		{
			cameraLoc=ViewTarget.Location;
			PlayerCalcView(ViewActor,cameraLoc,cameraRot);
			newdist=VSize(cameraLoc - ViewTarget.Location);
			if ( newdist > bestDist )
			{
				bestDist=newdist;
				besttry=tries;
			}
			ViewRotation.Yaw += 4096;
			tries++;
		}
		ViewRotation.Yaw=startYaw + besttry * 4096;
		SetRotation(ViewRotation);
	}

	function Timer ()
	{
		if (  !bFrozen )
		{
			return;
		}
		bFrozen=False;
		myHUD.bShowScores=True;
		bPressedJump=False;
	}

	function BeginState ()
	{
		local SavedMove Next;
		local SavedMove Current;

		Enemy=None;
		bBehindView=True;
		bFrozen=True;
		bPressedJump=False;
		while ( SavedMoves != None )
		{
			Next=SavedMoves.NextMove;
			Current=SavedMoves;
			SavedMoves=Next;
			Current.Destroy();
		}
		if ( PendingMove != None )
		{
			Current=PendingMove;
			PendingMove=None;
			Current.Destroy();
		}
	}

	function EndState ()
	{
		local SavedMove Next;

		while ( SavedMoves != None )
		{
			Next=SavedMoves.NextMove;
			SavedMoves.Destroy();
			SavedMoves=Next;
		}
		if ( PendingMove != None )
		{
			PendingMove.Destroy();
			PendingMove=None;
		}
		Velocity=vect(0.00,0.00,0.00);
		Acceleration=vect(0.00,0.00,0.00);
		bBehindView=False;
		myHUD.bShowScores=False;
		bPressedJump=False;
	}

}

function string GetNGSecret ()
{
	return ngWorldSecret;
}

function SetNGSecret (string newSecret)
{
	ngWorldSecret=newSecret;
}

function ChangeStairLook (bool B)
{
	bLookUpStairs=B;
	if ( bLookUpStairs )
	{
		bAlwaysMouseLook=False;
	}
}

function ChangeAlwaysMouseLook (bool B)
{
	bAlwaysMouseLook=B;
	if ( bAlwaysMouseLook )
	{
		bLookUpStairs=False;
	}
}

event ToggleRadar (bool _bRadar)
{
	ServerToggleRadar(_bRadar);
}

function ServerToggleRadar (bool _bRadar)
{
	m_bRadarActive=_bRadar;
}

function ServerToggleHeatVision (bool bHeatVisionActive)
{
	m_bHeatVisionActive=bHeatVisionActive;
}

event ClientPBKickedOutMessage (string PBMessage)
{
	Player.Console.R6ConnectionFailed(PBMessage);
}

defaultproperties
{
    EnemyTurnSpeed=45000
    bAlwaysMouseLook=True
    bKeyboardLook=True
    bZeroRoll=True
    OrthoZoom=40000.00
    CameraDist=9.00
    DesiredFOV=85.00
    DefaultFOV=85.00
    MaxTimeMargin=1.00
    NetClientMaxTickRate=15.00
    LocalMessageClass=Class'LocalMessage'
    CheatClass=Class'CheatManager'
    InputClass=Class'PlayerInput'
    FlashScale=(X=1.00,Y=1.00,Z=1.00)
    QuickSaveString="Quick Saving"
    NoPauseMessage="Game is not pauseable"
    ViewingFrom="Now viewing from"
    OwnCamera="Now viewing from own camera"
    bIsPlayer=True
    bCanOpenDoors=True
    bCanDoSpecial=True
    FovAngle=85.00
    Handedness=1.00
    bTravel=True
    NetPriority=3.00
}
