//================================================================================
// Controller.
//================================================================================
class Controller extends Actor
	Native
	Abstract;

const LATENT_MOVETOWARD= 503;

enum EGrenadeType {
	GTYPE_None,
	GTYPE_Smoke,
	GTYPE_TearGas,
	GTYPE_FlashBang,
	GTYPE_BreachingCharge
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

enum EMoveToResult {
	eMoveTo_none,
	eMoveTo_success,
	eMoveTo_failed
};

enum EAttitude {
	ATTITUDE_Fear,
	ATTITUDE_Hate,
	ATTITUDE_Frenzy,
	ATTITUDE_Threaten,
	ATTITUDE_Ignore,
	ATTITUDE_Friendly,
	ATTITUDE_Follow
};

var(AI) EAttitude AttitudeToPlayer;
var input byte bRun;
var input byte bFire;
var input byte bAltFire;
var input byte m_bMoveUp;
var input byte m_bMoveDown;
var input byte m_bMoveLeft;
var input byte m_bMoveRight;
var input byte m_bRotateCW;
var input byte m_bRotateCCW;
var input byte m_bZoomIn;
var input byte m_bZoomOut;
var input byte m_bAngleUp;
var input byte m_bAngleDown;
var input byte m_bLevelUp;
var input byte m_bLevelDown;
var input byte m_bGoLevelUp;
var input byte m_bGoLevelDown;
var byte bDuck;
var EMoveToResult m_eMoveToResult;
var bool bIsPlayer;
var bool bGodMode;
var const bool bLOSflag;
var bool bAdvancedTactics;
var bool bCanOpenDoors;
var bool bCanDoSpecial;
var bool bAdjusting;
var bool bPreparingMove;
var bool bControlAnimations;
var bool bEnemyInfoValid;
var bool m_bCrawl;
var bool m_bLockWeaponActions;
var bool m_bHideReticule;
var float SightCounter;
var float FovAngle;
var float Handedness;
var float Stimulus;
var float MoveTimer;
var float MinHitWall;
var float LastSeenTime;
var float OldMessageTime;
var float RouteDist;
var float GroundPitchTime;
var float MonitorMaxDistSq;
var Pawn Pawn;
var const Controller nextController;
var Actor MoveTarget;
var Actor Focus;
var Mover PendingMover;
var Actor GoalList[4];
var NavigationPoint home;
var Pawn Enemy;
var Actor Target;
var Actor RouteCache[16];
var ReachSpec CurrentPath;
var Actor RouteGoal;
var PlayerReplicationInfo PlayerReplicationInfo;
var NavigationPoint StartSpot;
var R6PawnReplicationInfo m_PawnRepInfo;
var Pawn MonitoredPawn;
var name NextState;
var name NextLabel;
var() Class<PlayerReplicationInfo> PlayerReplicationInfoClass;
var Class<Pawn> PawnClass;
var Class<Pawn> PreviousPawnClass;
var Vector AdjustLoc;
var Vector Destination;
var Vector FocalPoint;
var Vector LastSeenPos;
var Vector LastSeeingPos;
var Vector ViewX;
var Vector ViewY;
var Vector ViewZ;
var Vector MonitorStartLoc;
var string VoiceType;

replication
{
	reliable if ( Role == Role_Authority )
		R6DamageAttitudeTo;
	reliable if ( Role < Role_Authority  )
		ServerReStartPlayer;
	reliable if ( ( !bDemoRecording || bClientDemoRecording && bClientDemoNetFunc) && (Role == Role_Authority  ) )
		ClientVoiceMessage;
	unreliable if ( Role < Role_Authority  )
		SendVoiceMessage;
	reliable if ( RemoteRole == ROLE_AutonomousProxy )
		ClientGameEnded,ClientDying,ClientSetRotation,ClientSetLocation;
	reliable if ( bNetDirty && (Role == Role_Authority ) )
		Pawn,PlayerReplicationInfo,m_PawnRepInfo;
	reliable if ( bNetDirty && (Role == Role_Authority ) && bNetOwner )
		PawnClass;
}

native(500) final latent function MoveTo (Vector NewDestination, optional Actor ViewFocus, optional float speed, optional bool bShouldWalk);

native(502) final latent function MoveToward (Actor NewTarget, optional Actor ViewFocus, optional float speed, optional float DestinationOffset, optional bool bUseStrafing, optional bool bShouldWalk);

native(508) final latent function FinishRotation ();

native(514) final function bool LineOfSightTo (Actor Other);

native(533) final function bool CanSee (Pawn Other);

native(518) final function Actor FindPathTo (Vector aPoint, optional bool bClearPaths);

native(517) final function Actor FindPathToward (Actor anActor, optional bool bClearPaths);

native final function Actor FindPathTowardNearest (Class<NavigationPoint> GoalClass);

native(525) final function NavigationPoint FindRandomDest (optional bool bClearPaths);

native(522) final function ClearPaths ();

native(523) final function Vector EAdjustJump (float BaseZ, float XYSpeed);

native(521) final function bool pointReachable (Vector aPoint);

native(520) final function bool actorReachable (Actor anActor);

native(526) final function bool PickWallAdjust (Vector HitNormal);

native(527) final latent function WaitForLanding ();

native(540) final function Actor FindBestInventoryPath (out float MinWeight, bool bPredictRespawns);

native(529) final function AddController ();

native(530) final function RemoveController ();

native(531) final function Pawn PickTarget (out float bestAim, out float bestDist, Vector FireDir, Vector projStart);

native(534) final function Actor PickAnyTarget (out float bestAim, out float bestDist, Vector FireDir, Vector projStart);

native final function bool InLatentExecution (int LatentActionNumber);

native function StopWaiting ();

native function EndClimbLadder ();

event MayFall ();

exec function Map (int iGotoMapId, string explanation);

function PendingStasis ()
{
	bStasis=True;
	Pawn=None;
}

function logX (string szText, optional int iSource)
{
	local string szSource;
	local string Time;

	Time=string(Level.TimeSeconds);
	Time=Left(Time,InStr(Time,".") + 3);
	if ( iSource == 1 )
	{
		szSource="(" $ Time $ ":P) ";
	}
	else
	{
		szSource="(" $ Time $ ":C) ";
	}
	Log(szSource $ string(Name) $ " [" $ string(GetStateName()) $ "|" $ string(Pawn.GetStateName()) $ "] " $ szText);
}

function DisplayDebug (Canvas Canvas, out float YL, out float YPos)
{
	if ( Pawn == None )
	{
		Super.DisplayDebug(Canvas,YL,YPos);
		return;
	}
	Canvas.SetDrawColor(255,0,0);
	Canvas.DrawText("CONTROLLER " $ GetItemName(string(self)) $ " Pawn " $ string(Pawn));
	YPos += YL;
	Canvas.SetPos(4.00,YPos);
	Canvas.DrawText("     STATE: " $ string(GetStateName()) $ " Timer: " $ string(TimerCounter) $ " Enemy " $ string(Enemy),False);
	YPos += YL;
	Canvas.SetPos(4.00,YPos);
	if ( PlayerReplicationInfo == None )
	{
		Canvas.DrawText("     NO PLAYERREPLICATIONINFO",False);
	}
	else
	{
		PlayerReplicationInfo.DisplayDebug(Canvas,YL,YPos);
	}
	YPos += YL;
	Canvas.SetPos(4.00,YPos);
}

function Rotator GetViewRotation ()
{
	return Rotation;
}

function Reset ()
{
	Super.Reset();
	Enemy=None;
	LastSeenTime=0.00;
	StartSpot=None;
}

function ClientSetLocation (Vector NewLocation, Rotator NewRotation)
{
	SetRotation(NewRotation);
	if ( (Rotation.Pitch > RotationRate.Pitch) && (Rotation.Pitch < 65536 - RotationRate.Pitch) )
	{
		if ( Rotation.Pitch < 32768 )
		{
			NewRotation.Pitch=RotationRate.Pitch;
		}
		else
		{
			NewRotation.Pitch=65536 - RotationRate.Pitch;
		}
	}
	if ( Pawn != None )
	{
		NewRotation.Roll=0;
		Pawn.SetRotation(NewRotation);
		Pawn.SetLocation(NewLocation);
	}
}

function ClientSetRotation (Rotator NewRotation)
{
	SetRotation(NewRotation);
	if ( Pawn != None )
	{
		NewRotation.Pitch=0;
		NewRotation.Roll=0;
		Pawn.SetRotation(NewRotation);
	}
}

function ClientDying (Class<DamageType> DamageType, Vector HitLocation)
{
	if ( Pawn != None )
	{
		Pawn.PlayDying(DamageType,HitLocation);
		Pawn.GotoState('Dying');
	}
}

event AIHearSound (Actor Actor, int ID, Sound S, Vector SoundLocation, Vector Parameters, bool Attenuate);

function Possess (Pawn aPawn)
{
	aPawn.PossessedBy(self);
	Pawn=aPawn;
	if ( PlayerReplicationInfo != None )
	{
		PlayerReplicationInfo.bIsFemale=Pawn.bIsFemale;
	}
	FocalPoint=Pawn.Location + 512 * vector(Pawn.Rotation);
	Restart();
}

function PawnDied ()
{
	if ( Pawn != None )
	{
		SetLocation(Pawn.Location);
		Pawn.UnPossessed();
	}
	Pawn=None;
	PendingMover=None;
	if ( bIsPlayer )
	{
		GotoState('Dead');
	}
	else
	{
		Destroy();
	}
}

function Restart ()
{
	Enemy=None;
}

event LongFall ();

event bool NotifyPhysicsVolumeChange (PhysicsVolume NewVolume);

event bool NotifyHeadVolumeChange (PhysicsVolume NewVolume);

event bool NotifyLanded (Vector HitNormal);

event bool NotifyHitWall (Vector HitNormal, Actor Wall);

event bool NotifyBump (Actor Other);

event NotifyHitMover (Vector HitNormal, Mover Wall);

function NotifyTakeHit (Pawn instigatedBy, Vector HitLocation, int Damage, Class<DamageType> DamageType, Vector Momentum)
{
	if ( (instigatedBy != None) && (instigatedBy != Pawn) )
	{
		damageAttitudeTo(instigatedBy,Damage);
	}
}

function SetFall ();

function PawnIsInPain (PhysicsVolume PainVolume);

event PreBeginPlay ()
{
//	AddPawn();
	m_PawnRepInfo=Spawn(Class'R6PawnReplicationInfo');
	m_PawnRepInfo.m_ControllerOwner=self;
	Super.PreBeginPlay();
	if ( bDeleteMe )
	{
		return;
	}
	SightCounter=0.20 * FRand();
}

event PostBeginPlay ()
{
	Super.PostBeginPlay();
}

function InitPlayerReplicationInfo ()
{
	if ( PlayerReplicationInfo.PlayerName == "" )
	{
		PlayerReplicationInfo.SetPlayerName(Class'GameInfo'.Default.DefaultPlayerName);
	}
}

function bool SameTeamAs (Controller C)
{
	if ( (PlayerReplicationInfo == None) || (C.PlayerReplicationInfo == None) || (PlayerReplicationInfo.Team == None) )
	{
		return False;
	}
	return Level.Game.IsOnTeam(C,PlayerReplicationInfo.Team.TeamIndex);
}

simulated event Destroyed ()
{
	if ( Role < Role_Authority )
	{
		return;
	}
//	RemovePawn();
	if ( bIsPlayer && (Level.Game != None) )
	{
		Level.Game.Logout(self);
	}
	if ( PlayerReplicationInfo != None )
	{
		PlayerReplicationInfo.Destroy();
	}
	if ( m_PawnRepInfo != None )
	{
		m_PawnRepInfo.Destroy();
		m_PawnRepInfo=None;
	}
	Super.Destroyed();
}

function AdjustView (float DeltaTime)
{
	local Controller C;

	for (C=Level.ControllerList;C != None;C=C.nextController)
	{
		if ( C.IsA('PlayerController') && (PlayerController(C).ViewTarget == Pawn) )
		{
			return;
		}
	}
}

function bool WantsSmoothedView ()
{
	return ((Pawn.Physics == 1) || (Pawn.Physics == 9)) &&  !Pawn.bJustLanded;
}

function ClientGameEnded ()
{
	GotoState('GameEnded');
}

simulated event RenderOverlays (Canvas Canvas)
{
	if ( Pawn.EngineWeapon != None )
	{
		Pawn.EngineWeapon.RenderOverlays(Canvas);
	}
}

function int GetFacingDirection ()
{
	return 0;
}

function byte GetMessageIndex (name PhraseName)
{
	return 0;
}

function SendMessage (PlayerReplicationInfo Recipient, name messagetype, byte MessageID, float Wait, name BroadcastType)
{
	SendVoiceMessage(PlayerReplicationInfo,Recipient,messagetype,MessageID,BroadcastType);
}

function SendVoiceMessage (PlayerReplicationInfo Sender, PlayerReplicationInfo Recipient, name messagetype, byte MessageID, name BroadcastType)
{
	local Controller P;
	local bool bNoSpeak;

	if ( Level.TimeSeconds - OldMessageTime < 2.50 )
	{
		bNoSpeak=True;
	}
	else
	{
		OldMessageTime=Level.TimeSeconds;
	}
	for (P=Level.ControllerList;P != None;P=P.nextController)
	{
		if ( PlayerController(P) != None )
		{
			if (  !bNoSpeak )
			{
				if ( (BroadcastType == 'Global') ||  !Level.Game.bTeamGame )
				{
					P.ClientVoiceMessage(Sender,Recipient,messagetype,MessageID);
				}
				else
				{
					if ( Sender.Team == P.PlayerReplicationInfo.Team )
					{
						P.ClientVoiceMessage(Sender,Recipient,messagetype,MessageID);
					}
				}
			}
		}
		else
		{
			if ( (P.PlayerReplicationInfo == Recipient) || (messagetype == 'ORDER') && (Recipient == None) )
			{
				P.BotVoiceMessage(messagetype,MessageID,self);
			}
		}
	}
}

function ClientVoiceMessage (PlayerReplicationInfo Sender, PlayerReplicationInfo Recipient, name messagetype, byte MessageID);

function BotVoiceMessage (name messagetype, byte MessageID, Controller Sender);

function bool WouldReactToNoise (float Loudness, Actor NoiseMaker)
{
	return False;
}

function bool WouldReactToSeeing (Pawn seen)
{
	return False;
}

function FearThisSpot (Actor ASpot);

event PrepareForMove (NavigationPoint Goal, ReachSpec Path);

function WaitForMover (Mover M);

function MoverFinished ();

function UnderLift (Mover M);

event HearNoise (float Loudness, Actor NoiseMaker, ENoiseType eType);

event SeePlayer (Pawn seen);

event SeeMonster (Pawn seen);

event EnemyNotVisible ();

function ShakeView (float shaketime, float RollMag, Vector OffsetMag, float RollRate, Vector OffsetRate, float OffsetTime);

function NotifyKilled (Controller Killer, Controller Killed, Pawn Other)
{
	if ( Enemy == Other )
	{
		Enemy=None;
	}
}

function damageAttitudeTo (Pawn Other, float Damage);

function EAttitude AttitudeTo (Pawn Other)
{
	if ( Other.IsPlayerPawn() )
	{
		return AttitudeToPlayer;
	}
	else
	{
		return ATTITUDE_Ignore;
	}
}

function bool FireWeaponAt (Actor A);

function StopFiring ()
{
	bFire=0;
	bAltFire=0;
}

function ReceiveWarning (Pawn shooter, float projSpeed, Vector FireDir)
{
}

exec function SwitchToBestWeapon ()
{
}

function bool CheckFutureSight (float DeltaTime)
{
	return True;
}

function ChangedWeapon ();

function ServerReStartPlayer ()
{
}

event MonitoredPawnAlert ();

function StartMonitoring (Pawn P, float MaxDist)
{
	MonitoredPawn=P;
	MonitorStartLoc=P.Location;
	MonitorMaxDistSq=MaxDist * MaxDist;
}

state Dead
{
	ignores  KilledBy;
	
	function PawnDied ()
	{
	}
	
	function ServerReStartPlayer ()
	{
		if ( Level.NetMode == NM_Client )
		{
			return;
		}
		Level.Game.RestartPlayer(self);
	}
	
}

state GameEnded
{
	ignores  ReceiveWarning, TakeDamage, KilledBy;
	
	function BeginState ()
	{
		if ( Pawn != None )
		{
			Pawn.bPhysicsAnimUpdate=False;
			Pawn.StopAnimating();
			Pawn.SimAnim.AnimRate=0;
			Pawn.SetCollision(False,False,False);
			Pawn.Velocity=vect(0.00,0.00,0.00);
			Pawn.SetPhysics(PHYS_None);
			Pawn.UnPossessed();
		}
		if (  !bIsPlayer )
		{
			Destroy();
		}
	}
	
}

simulated function R6DamageAttitudeTo (Pawn Other, eKillResult eKillFromTable, eStunResult eStunFromTable, Vector vBulletMomentum);

function PlaySoundDamage (Pawn instigatedBy);

function PlaySoundInflictedDamage (Pawn DeadPawn);

function PlaySoundCurrentAction (ERainbowTeamVoices eVoices);

function PlaySoundAffectedByGrenade (EGrenadeType eType);

function SetWeaponSound (R6PawnReplicationInfo PawnRepInfo, string szCurrentWeaponTxt, byte u8CurrentWepon);

defaultproperties
{
    AttitudeToPlayer=1
    m_bHideReticule=True
    FovAngle=90.00
    MinHitWall=-1.00
    PlayerReplicationInfoClass=Class'PlayerReplicationInfo'
    bHidden=True
    bHiddenEd=True
}