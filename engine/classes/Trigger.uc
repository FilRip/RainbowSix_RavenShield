//================================================================================
// Trigger.
//================================================================================
class Trigger extends Triggers
	Native;
//	Localized;

enum ETriggerType {
	TT_PlayerProximity,
	TT_PawnProximity,
	TT_ClassProximity,
	TT_AnyProximity,
	TT_Shoot,
	TT_HumanPlayerProximity
};

var() ETriggerType TriggerType;
var() bool bTriggerOnceOnly;
var() bool bInitiallyActive;
var bool bSavedInitialCollision;
var bool bSavedInitialActive;
var(R6Alarm) bool m_bAlarm;
var() float RepeatTriggerTime;
var() float ReTriggerDelay;
var float TriggerTime;
var() float DamageThreshold;
var Actor TriggerActor;
var Actor TriggerActor2;
var(R6Alarm) R6Alarm m_pAlarm;
var() Class<Actor> ClassProximityType;
var() localized string Message;

function PreBeginPlay ()
{
	Super.PreBeginPlay();
	if ( (TriggerType == TT_PlayerProximity) || (TriggerType == TT_PawnProximity) || (TriggerType == TT_HumanPlayerProximity) || (TriggerType == TT_ClassProximity) && ClassIsChildOf(ClassProximityType,Class'Pawn') )
	{
		OnlyAffectPawns(True);
	}
}

function PostBeginPlay ()
{
	if (  !bInitiallyActive )
	{
		FindTriggerActor();
	}
	if ( TriggerType == TT_Shoot )
	{
		bHidden=False;
		bProjTarget=True;
		SetDrawType(DT_None);
	}
	bSavedInitialActive=bInitiallyActive;
	bSavedInitialCollision=bCollideActors;
	Super.PostBeginPlay();
}

function Reset ()
{
	Super.Reset();
	bInitiallyActive=bSavedInitialActive;
	SetCollision(bSavedInitialCollision,bBlockActors,bBlockPlayers);
}

simulated function ResetOriginalData ()
{
	if ( m_bResetSystemLog )
	{
		LogResetSystem(False);
	}
	Super.ResetOriginalData();
	bInitiallyActive=bSavedInitialActive;
	SetCollision(bSavedInitialCollision,bBlockActors,bBlockPlayers);
}

function FindTriggerActor ()
{
	local Actor A;

	TriggerActor=None;
	TriggerActor2=None;
	foreach AllActors(Class'Actor',A)
	{
		if ( A.Event == Tag )
		{
			if ( TriggerActor == None )
			{
				TriggerActor=A;
			}
			else
			{
				TriggerActor2=A;
				return;
			}
		}
	}
}

function Actor SpecialHandling (Pawn Other)
{
	local Actor A;

	if ( bTriggerOnceOnly &&  !bCollideActors )
	{
		return None;
	}
	if ( (TriggerType == TT_HumanPlayerProximity) &&  !Other.IsHumanControlled() )
	{
		return None;
	}
	if ( (TriggerType == TT_PlayerProximity) &&  !Other.IsPlayerPawn() )
	{
		return None;
	}
	if (  !bInitiallyActive )
	{
		if ( TriggerActor == None )
		{
			FindTriggerActor();
		}
		if ( TriggerActor == None )
		{
			return None;
		}
		if ( (TriggerActor2 != None) && (VSize(TriggerActor2.Location - Other.Location) < VSize(TriggerActor.Location - Other.Location)) )
		{
			return TriggerActor2;
		}
		else
		{
			return TriggerActor;
		}
	}
	if ( TriggerType == TT_Shoot )
	{
		return Other.ShootSpecial(self);
	}
	if ( IsRelevant(Other) )
	{
		foreach TouchingActors(Class'Actor',A)
		{
			if ( A == Other )
			{
				Touch(Other);
			}
		}
		return self;
	}
	return self;
}

function CheckTouchList ()
{
	local Actor A;

	foreach TouchingActors(Class'Actor',A)
	{
		Touch(A);
	}
}

state() NormalTrigger
{
}

state() OtherTriggerToggles
{
	function Trigger (Actor Other, Pawn EventInstigator)
	{
		bInitiallyActive= !bInitiallyActive;
		if ( bInitiallyActive )
		{
			CheckTouchList();
		}
	}

}

state() OtherTriggerTurnsOn
{
	function Trigger (Actor Other, Pawn EventInstigator)
	{
		local bool bWasActive;

		bWasActive=bInitiallyActive;
		bInitiallyActive=True;
		if (  !bWasActive )
		{
			CheckTouchList();
		}
	}

}

state() OtherTriggerTurnsOff
{
	function Trigger (Actor Other, Pawn EventInstigator)
	{
		bInitiallyActive=False;
	}

}

function bool IsRelevant (Actor Other)
{
	if (  !bInitiallyActive )
	{
		return False;
	}
	switch (TriggerType)
	{
		case TT_HumanPlayerProximity:
		return (Pawn(Other) != None) && Pawn(Other).IsHumanControlled();
		case TT_PlayerProximity:
		return (Pawn(Other) != None) && Pawn(Other).IsPlayerPawn();
		case TT_PawnProximity:
		return (Pawn(Other) != None) && Pawn(Other).CanTrigger(self);
		case TT_ClassProximity:
		return ClassIsChildOf(Other.Class,ClassProximityType);
		case TT_AnyProximity:
		return True;
		case TT_Shoot:
		return (Projectile(Other) != None) && (Projectile(Other).Damage >= DamageThreshold);
		default:
	}
}

function Touch (Actor Other)
{
	local int i;

	if ( IsRelevant(Other) )
	{
		if ( ReTriggerDelay > 0 )
		{
			if ( Level.TimeSeconds - TriggerTime < ReTriggerDelay )
			{
				return;
			}
			TriggerTime=Level.TimeSeconds;
		}
		TriggerEvent(Event,self,Other.Instigator);
		if ( m_bAlarm )
		{
			m_pAlarm.SetAlarm(Other.Location);
		}
		if ( (Pawn(Other) != None) && (Pawn(Other).Controller != None) )
		{
			for (i=0;i < 4;i++)
			{
				if ( Pawn(Other).Controller.GoalList[i] == self )
				{
					Pawn(Other).Controller.GoalList[i]=None;
					break;
				}
			}
		}
		if ( (Message != "") && (Other.Instigator != None) )
		{
			Other.Instigator.ClientMessage(Message);
		}
		if ( bTriggerOnceOnly )
		{
			SetCollision(False);
		}
		else
		{
			if ( RepeatTriggerTime > 0 )
			{
				SetTimer(RepeatTriggerTime,False);
			}
		}
	}
}

function Timer ()
{
	local bool bKeepTiming;
	local Actor A;

	bKeepTiming=False;
	foreach TouchingActors(Class'Actor',A)
	{
		if ( IsRelevant(A) )
		{
			bKeepTiming=True;
			Touch(A);
		}
	}
	if ( bKeepTiming )
	{
		SetTimer(RepeatTriggerTime,False);
	}
}

function TakeDamage (int Damage, Pawn instigatedBy, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType)
{
	if ( bInitiallyActive && (TriggerType == TT_Shoot) && (Damage >= DamageThreshold) && (instigatedBy != None) )
	{
		if ( ReTriggerDelay > 0 )
		{
			if ( Level.TimeSeconds - TriggerTime < ReTriggerDelay )
			{
				return;
			}
			TriggerTime=Level.TimeSeconds;
		}
		TriggerEvent(Event,self,instigatedBy);
		if ( m_bAlarm )
		{
			m_pAlarm.SetAlarm(HitLocation);
		}
		if ( Message != "" )
		{
			instigatedBy.Instigator.ClientMessage(Message);
		}
		if ( bTriggerOnceOnly )
		{
			SetCollision(False);
		}
	}
}

function int R6TakeDamage (int iKillValue, int iStunValue, Pawn instigatedBy, Vector vHitLocation, Vector vMomentum, int iBulletToArmorModifier, optional int iBulletGoup)
{
	TakeDamage(iKillValue,instigatedBy,vHitLocation,vMomentum,None);
	return iKillValue;
}

function UnTouch (Actor Other)
{
	if ( IsRelevant(Other) )
	{
		UntriggerEvent(Event,self,Other.Instigator);
	}
}

defaultproperties
{
    bInitiallyActive=True
    InitialState=NormalTrigger
}
/*
    Texture=Texture'S_Trigger'
*/

