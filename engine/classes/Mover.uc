//================================================================================
// Mover.
//================================================================================
class Mover extends Actor
	Native;

enum EMoverEncroachType {
	ME_StopWhenEncroach,
	ME_ReturnWhenEncroach,
	ME_CrushWhenEncroach,
	ME_IgnoreWhenEncroach
};

enum EBumpType {
	BT_PlayerBump,
	BT_PawnBump,
	BT_AnyBump
};

enum EMoverGlideType {
	MV_MoveByTime,
	MV_GlideByTime
};

var() EMoverEncroachType MoverEncroachType;
var() EMoverGlideType MoverGlideType;
var() EBumpType BumpType;
var() byte KeyNum;
var byte PrevKeyNum;
var() const byte NumKeys;
var() const byte WorldRaytraceKey;
var() const byte BrushRaytraceKey;
var() int EncroachDamage;
var int numTriggerEvents;
var int SimOldRotPitch;
var int SimOldRotYaw;
var int SimOldRotRoll;
var int ClientUpdate;
var() bool bTriggerOnceOnly;
var() bool bSlave;
var() bool bUseTriggered;
var() bool bDamageTriggered;
var() bool bDynamicLightMover;
var bool bOpening;
var bool bDelaying;
var bool bClientPause;
var bool bClosed;
var bool bPlayerOnly;
var(AI) bool bAutoDoor;
var(AI) bool bNoAIRelevance;
var() float MoveTime;
var() float StayOpenTime;
var() float OtherTime;
var() float DamageThreshold;
var() float DelayTime;
var float PhysAlpha;
var float PhysRate;
var Actor SavedTrigger;
var Mover Leader;
var Mover Follower;
var(MoverSounds) Sound OpeningSound;
var(MoverSounds) Sound OpenedSound;
var(MoverSounds) Sound ClosingSound;
var(MoverSounds) Sound ClosedSound;
var(MoverSounds) Sound MoveAmbientSound;
var NavigationPoint myMarker;
var() name PlayerBumpEvent;
var() name BumpEvent;
var() name ReturnGroup;
var Vector KeyPos[8];
var Rotator KeyRot[8];
var Vector BasePos;
var Vector OldPos;
var Vector OldPrePivot;
var Vector SavedPos;
var Rotator BaseRot;
var Rotator OldRot;
var Rotator SavedRot;
var Vector SimOldPos;
var Vector SimInterpolate;
var Vector RealPosition;
var Rotator RealRotation;

replication
{
	reliable if ( Role == Role_Authority )
		SimOldRotPitch,SimOldRotYaw,SimOldRotRoll,SimOldPos,SimInterpolate,RealPosition,RealRotation;
}

simulated function StartInterpolation ()
{
	GotoState('None');
	bInterpolating=True;
	SetPhysics(PHYS_None);
}

simulated function Timer ()
{
	if ( Velocity != vect(0.00,0.00,0.00) )
	{
		bClientPause=False;
		return;
	}
	if ( Level.NetMode == NM_Client )
	{
		if ( ClientUpdate == 0 )
		{
			if ( bClientPause )
			{
				if ( VSize(RealPosition - Location) > 3 )
				{
					SetLocation(RealPosition);
				}
				else
				{
					RealPosition=Location;
				}
				SetRotation(RealRotation);
				bClientPause=False;
			}
			else
			{
				if ( RealPosition != Location )
				{
					bClientPause=True;
				}
			}
		}
		else
		{
			bClientPause=False;
		}
	}
	else
	{
		RealPosition=Location;
		RealRotation=Rotation;
	}
}

final function InterpolateTo (byte NewKeyNum, float Seconds)
{
	NewKeyNum=Clamp(NewKeyNum,0,8 - 1);
	if ( (NewKeyNum == PrevKeyNum) && (KeyNum != PrevKeyNum) )
	{
		PhysAlpha=1.00 - PhysAlpha;
		OldPos=BasePos + KeyPos[KeyNum];
		OldRot=BaseRot + KeyRot[KeyNum];
	}
	else
	{
		OldPos=Location;
		OldRot=Rotation;
		PhysAlpha=0.00;
	}
	SetPhysics(PHYS_MovingBrush);
	bInterpolating=True;
	PrevKeyNum=KeyNum;
	KeyNum=NewKeyNum;
	PhysRate=1.00 / FMax(Seconds,0.00);
	ClientUpdate++;
	SimOldPos=OldPos;
	SimOldRotYaw=OldRot.Yaw;
	SimOldRotPitch=OldRot.Pitch;
	SimOldRotRoll=OldRot.Roll;
	SimInterpolate.X=100.00 * PhysAlpha;
	SimInterpolate.Y=100.00 * FMax(0.01,PhysRate);
	SimInterpolate.Z=256.00 * PrevKeyNum + KeyNum;
}

final function SetKeyframe (byte NewKeyNum, Vector NewLocation, Rotator NewRotation)
{
	KeyNum=Clamp(NewKeyNum,0,8 - 1);
	KeyPos[KeyNum]=NewLocation;
	KeyRot[KeyNum]=NewRotation;
}

event KeyFrameReached ()
{
	local byte OldKeyNum;

	OldKeyNum=PrevKeyNum;
	PrevKeyNum=KeyNum;
	PhysAlpha=0.00;
	ClientUpdate--;
	if ( (KeyNum > 0) && (KeyNum < OldKeyNum) )
	{
		InterpolateTo(KeyNum - 1,MoveTime);
	}
	else
	{
		if ( (KeyNum < NumKeys - 1) && (KeyNum > OldKeyNum) )
		{
			InterpolateTo(KeyNum + 1,MoveTime);
		}
		else
		{
			AmbientSound=None;
			if ( (ClientUpdate == 0) && (Level.NetMode != 3) )
			{
				RealPosition=Location;
				RealRotation=Rotation;
			}
		}
	}
}

function FinishNotify ()
{
	local Controller C;

	for (C=Level.ControllerList;C != None;C=C.nextController)
	{
		if ( (C.Pawn != None) && (C.PendingMover == self) )
		{
			C.MoverFinished();
		}
	}
}

function FinishedClosing ()
{
	PlaySound(ClosedSound,SLOT_SFX);
	if ( SavedTrigger != None )
	{
		SavedTrigger.EndEvent();
	}
	SavedTrigger=None;
	Instigator=None;
	if ( myMarker != None )
	{
		myMarker.MoverClosed();
	}
	bClosed=True;
	FinishNotify();
}

function FinishedOpening ()
{
	PlaySound(OpenedSound,SLOT_SFX);
	TriggerEvent(Event,self,Instigator);
	if ( myMarker != None )
	{
		myMarker.MoverOpened();
	}
	FinishNotify();
}

function DoOpen ()
{
	bOpening=True;
	bDelaying=False;
	InterpolateTo(1,MoveTime);
	PlaySound(OpeningSound,SLOT_SFX);
	AmbientSound=MoveAmbientSound;
}

function DoClose ()
{
	bOpening=False;
	bDelaying=False;
	InterpolateTo(Max(0,KeyNum - 1),MoveTime);
	PlaySound(ClosingSound,SLOT_SFX);
	UntriggerEvent(Event,self,Instigator);
	AmbientSound=MoveAmbientSound;
}

simulated function BeginPlay ()
{
	if ( Level.NetMode != 0 )
	{
		if ( Level.NetMode == NM_Client )
		{
			SetTimer(4.00,True);
		}
		else
		{
			SetTimer(1.00,True);
		}
		if ( Role < Role_Authority )
		{
			return;
		}
	}
	if ( Level.NetMode != 3 )
	{
		RealPosition=Location;
		RealRotation=Rotation;
	}
	Super.BeginPlay();
	KeyNum=Clamp(KeyNum,0,8 - 1);
	PhysAlpha=0.00;
	Move(BasePos + KeyPos[KeyNum] - Location);
	SetRotation(BaseRot + KeyRot[KeyNum]);
	if ( ReturnGroup == 'None' )
	{
		ReturnGroup=Tag;
	}
}

function PostBeginPlay ()
{
	local Mover M;

	if (  !bSlave )
	{
		foreach DynamicActors(Class'Mover',M,Tag)
		{
			if ( M.bSlave )
			{
				M.GotoState('None');
				M.SetBase(self);
			}
		}
	}
	if ( Leader == None )
	{
		Leader=self;
		foreach DynamicActors(Class'Mover',M)
		{
			if ( (M != self) && (M.ReturnGroup == ReturnGroup) )
			{
				M.Leader=self;
				M.Follower=Follower;
				Follower=M;
			}
		}
	}
}

function MakeGroupStop ()
{
	bInterpolating=False;
	AmbientSound=None;
	GotoState(,'None');
	if ( Follower != None )
	{
		Follower.MakeGroupStop();
	}
}

function MakeGroupReturn ()
{
	bInterpolating=False;
	AmbientSound=None;
	if ( KeyNum < PrevKeyNum )
	{
		GotoState(,'Open');
	}
	else
	{
		GotoState(,'Close');
	}
	if ( Follower != None )
	{
		Follower.MakeGroupReturn();
	}
}

function bool EncroachingOn (Actor Other)
{
	local Pawn P;

	if ( (Pawn(Other) != None) && (Pawn(Other).Controller == None) || Other.IsA('Decoration') )
	{
		Other.TakeDamage(10000,None,Other.Location,vect(0.00,0.00,0.00),Class'Crushed');
		return False;
	}
	if ( Other.IsA('Pickup') )
	{
		if (  !Other.bAlwaysRelevant && (Other.Owner == None) )
		{
			Other.Destroy();
		}
		return False;
	}
	if ( Other.IsA('Fragment') )
	{
		Other.Destroy();
		return False;
	}
	if ( EncroachDamage != 0 )
	{
		Other.TakeDamage(EncroachDamage,Instigator,Other.Location,vect(0.00,0.00,0.00),Class'Crushed');
	}
	P=Pawn(Other);
	if ( (P != None) && (P.Controller != None) && P.IsPlayerPawn() )
	{
		if ( PlayerBumpEvent != 'None' )
		{
			Bump(Other);
		}
		if ( (P.Base != self) && (P.Controller.PendingMover == self) )
		{
			P.Controller.UnderLift(self);
		}
	}
	if ( MoverEncroachType == 0 )
	{
		Leader.MakeGroupStop();
		return True;
	}
	else
	{
		if ( MoverEncroachType == 1 )
		{
			Leader.MakeGroupReturn();
			if ( Other.IsA('Pawn') )
			{
				Pawn(Other).PlayMoverHitSound();
			}
			return True;
		}
		else
		{
			if ( MoverEncroachType == 2 )
			{
				Other.KilledBy(Instigator);
				return False;
			}
			else
			{
				if ( MoverEncroachType == 3 )
				{
					return False;
				}
			}
		}
	}
}

function Bump (Actor Other)
{
	local Pawn P;

	P=Pawn(Other);
	if ( bUseTriggered && (P != None) &&  !P.IsHumanControlled() && P.IsPlayerPawn() )
	{
		Trigger(P,P);
		P.Controller.WaitForMover(self);
	}
	if ( (BumpType != 2) && (P == None) )
	{
		return;
	}
	if ( (BumpType == 0) &&  !P.IsPlayerPawn() )
	{
		return;
	}
	if ( (BumpType == 1) && P.bAmbientCreature )
	{
		return;
	}
	TriggerEvent(BumpEvent,self,P);
	if ( (P != None) && P.IsPlayerPawn() )
	{
		TriggerEvent(PlayerBumpEvent,self,P);
	}
}

function TakeDamage (int Damage, Pawn instigatedBy, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType)
{
	if ( bDamageTriggered && (Damage >= DamageThreshold) )
	{
		self.Trigger(self,instigatedBy);
	}
}

state OpenTimedMover
{
//	ignores  EnableTrigger, DisableTrigger;

Open:
	bClosed=False;
//	DisableTrigger();
	if ( DelayTime > 0 )
	{
		bDelaying=True;
		Sleep(DelayTime);
	}
	DoOpen();
	FinishInterpolation();
	FinishedOpening();
	Sleep(StayOpenTime);
	if ( bTriggerOnceOnly )
	{
		GotoState('None');
	}
Close:
	DoClose();
	FinishInterpolation();
	FinishedClosing();
//	EnableTrigger();
}

state() StandOpenTimed extends OpenTimedMover
{
	function Attach (Actor Other)
	{
		local Pawn P;

		P=Pawn(Other);
		if ( (BumpType != 2) && (P == None) )
		{
			return;
		}
		if ( (BumpType == 0) &&  !P.IsPlayerPawn() )
		{
			return;
		}
		if ( (BumpType == 1) && (Other.Mass < 10) )
		{
			return;
		}
		SavedTrigger=None;
		GotoState('StandOpenTimed','Open');
	}

	function DisableTrigger ()
	{
		Disable('Attach');
	}

	function EnableTrigger ()
	{
		Enable('Attach');
	}

}

state() BumpOpenTimed extends OpenTimedMover
{
	function Bump (Actor Other)
	{
		if ( (BumpType != 2) && (Pawn(Other) == None) )
		{
			return;
		}
		if ( (BumpType == 0) &&  !Pawn(Other).IsPlayerPawn() )
		{
			return;
		}
		if ( (BumpType == 1) && (Other.Mass < 10) )
		{
			return;
		}
		Global.Bump(Other);
		SavedTrigger=None;
		Instigator=Pawn(Other);
		if ( Instigator != None )
		{
			Instigator.Controller.WaitForMover(self);
		}
		GotoState('BumpOpenTimed','Open');
	}

	function DisableTrigger ()
	{
		Disable('Bump');
	}

	function EnableTrigger ()
	{
		Enable('Bump');
	}

}

state() TriggerOpenTimed extends OpenTimedMover
{
	function Trigger (Actor Other, Pawn EventInstigator)
	{
		SavedTrigger=Other;
		Instigator=EventInstigator;
		if ( SavedTrigger != None )
		{
			SavedTrigger.BeginEvent();
		}
		GotoState('TriggerOpenTimed','Open');
	}

	function DisableTrigger ()
	{
		Disable('Trigger');
	}

	function EnableTrigger ()
	{
		Enable('Trigger');
	}

}

state() TriggerToggle
{
	function Trigger (Actor Other, Pawn EventInstigator)
	{
		SavedTrigger=Other;
		Instigator=EventInstigator;
		if ( SavedTrigger != None )
		{
			SavedTrigger.BeginEvent();
		}
		if ( (KeyNum == 0) || (KeyNum < PrevKeyNum) )
		{
			GotoState('TriggerToggle','Open');
		}
		else
		{
			GotoState('TriggerToggle','Close');
		}
	}

Open:
	bClosed=False;
	if ( DelayTime > 0 )
	{
		bDelaying=True;
		Sleep(DelayTime);
	}
	DoOpen();
	FinishInterpolation();
	FinishedOpening();
	if ( SavedTrigger != None )
	{
		SavedTrigger.EndEvent();
	}
//	stop
Close:
	DoClose();
	FinishInterpolation();
	FinishedClosing();
}

state() TriggerControl
{
	function Trigger (Actor Other, Pawn EventInstigator)
	{
		numTriggerEvents++;
		SavedTrigger=Other;
		Instigator=EventInstigator;
		if ( SavedTrigger != None )
		{
			SavedTrigger.BeginEvent();
		}
		GotoState('TriggerControl','Open');
	}

	function UnTrigger (Actor Other, Pawn EventInstigator)
	{
		numTriggerEvents--;
		if ( numTriggerEvents <= 0 )
		{
			numTriggerEvents=0;
			SavedTrigger=Other;
			Instigator=EventInstigator;
			SavedTrigger.BeginEvent();
			GotoState('TriggerControl','Close');
		}
	}

	function BeginState ()
	{
		numTriggerEvents=0;
	}

Open:
	bClosed=False;
	if ( DelayTime > 0 )
	{
		bDelaying=True;
		Sleep(DelayTime);
	}
	DoOpen();
	FinishInterpolation();
	FinishedOpening();
	SavedTrigger.EndEvent();
	if ( bTriggerOnceOnly )
	{
		GotoState('None');
	}
//	stop
Close:
	DoClose();
	FinishInterpolation();
	FinishedClosing();
}

state() TriggerPound
{
	function Trigger (Actor Other, Pawn EventInstigator)
	{
		numTriggerEvents++;
		SavedTrigger=Other;
		Instigator=EventInstigator;
		GotoState('TriggerPound','Open');
	}

	function UnTrigger (Actor Other, Pawn EventInstigator)
	{
		numTriggerEvents--;
		if ( numTriggerEvents <= 0 )
		{
			numTriggerEvents=0;
			SavedTrigger=None;
			Instigator=None;
			GotoState('TriggerPound','Close');
		}
	}

	function BeginState ()
	{
		numTriggerEvents=0;
	}

Open:
	bClosed=False;
	if ( DelayTime > 0 )
	{
		bDelaying=True;
		Sleep(DelayTime);
	}
	DoOpen();
	FinishInterpolation();
	Sleep(OtherTime);
Close:
	DoClose();
	FinishInterpolation();
	Sleep(StayOpenTime);
	if ( bTriggerOnceOnly )
	{
		GotoState('None');
	}
	if ( SavedTrigger != None )
	{
		goto ('Open');
	}
}

state() BumpButton
{
	function Bump (Actor Other)
	{
		if ( (BumpType != 2) && (Pawn(Other) == None) )
		{
			return;
		}
		if ( (BumpType == 0) &&  !Pawn(Other).IsPlayerPawn() )
		{
			return;
		}
		if ( (BumpType == 1) && (Other.Mass < 10) )
		{
			return;
		}
		Global.Bump(Other);
		SavedTrigger=Other;
		Instigator=Pawn(Other);
		Instigator.Controller.WaitForMover(self);
		GotoState('BumpButton','Open');
	}

	function BeginEvent ()
	{
		bSlave=True;
	}

	function EndEvent ()
	{
		bSlave=False;
		Instigator=None;
		GotoState('BumpButton','Close');
	}

Open:
	bClosed=False;
	Disable('Bump');
	if ( DelayTime > 0 )
	{
		bDelaying=True;
		Sleep(DelayTime);
	}
	DoOpen();
	FinishInterpolation();
	FinishedOpening();
	if ( bTriggerOnceOnly )
	{
		GotoState('None');
	}
	if ( bSlave )
	{
//		stop
	}
Close:
	DoClose();
	FinishInterpolation();
	FinishedClosing();
	Enable('Bump');
}

defaultproperties
{
    MoverEncroachType=1
    MoverGlideType=1
    NumKeys=2
    bClosed=True
    MoveTime=1.00
    StayOpenTime=4.00
    Physics=8
    RemoteRole=ROLE_None
    bNoDelete=True
    bAcceptsProjectors=True
    m_bHandleRelativeProjectors=True
    bAlwaysRelevant=True
    bShadowCast=True
    bCollideActors=True
    bBlockActors=True
    bBlockPlayers=True
    bEdShouldSnap=True
    bPathColliding=True
    m_bTickOnlyWhenVisible=True
    TransientSoundVolume=3.00
    CollisionRadius=160.00
    CollisionHeight=160.00
    NetPriority=2.70
    InitialState=BumpOpenTimed
}
