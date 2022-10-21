//================================================================================
// PhysicsVolume.
//================================================================================
class PhysicsVolume extends Volume
	Native
	NativeReplication;

var() int Priority;
var() bool bPainCausing;
var() bool bDestructive;
var() bool bNoInventory;
var() bool bMoveProjectiles;
var() bool bBounceVelocity;
var() bool bNeutralZone;
var bool bWaterVolume;
var(VolumeFog) bool bDistanceFog;
var() float GroundFriction;
var() float TerminalVelocity;
var() float DamagePerSec;
var() float FluidFriction;
var(VolumeFog) float DistanceFogStart;
var(VolumeFog) float DistanceFogEnd;
var() Sound EntrySound;
var() Sound ExitSound;
var Info PainTimer;
var PhysicsVolume NextPhysicsVolume;
var() Class<DamageType> DamageType;
var() Class<Actor> EntryActor;
var() Class<Actor> ExitActor;
var() Vector ZoneVelocity;
var() Vector Gravity;
var() Vector ViewFlash;
var() Vector ViewFog;
var(VolumeFog) Color DistanceFogColor;

simulated function Destroyed ()
{
	Super.Destroyed();
	Level.RemovePhysicsVolume(self);
}

simulated function PostBeginPlay ()
{
	PostBeginPlay();
	Level.AddPhysicsVolume(self);
	if ( Role < Role_Authority )
	{
		return;
	}
	if ( bPainCausing )
	{
		PainTimer=Spawn(Class'VolumeTimer',self);
	}
}

event PhysicsChangedFor (Actor Other);

event ActorEnteredVolume (Actor Other);

event ActorLeavingVolume (Actor Other);

event PawnEnteredVolume (Pawn Other)
{
	if ( Other.IsPlayerPawn() )
	{
		TriggerEvent(Event,self,Other);
	}
}

event PawnLeavingVolume (Pawn Other)
{
	if ( Other.IsPlayerPawn() )
	{
		UntriggerEvent(Event,self,Other);
	}
}

function TimerPop (VolumeTimer t)
{
	local Actor A;

	if ( t == PainTimer )
	{
		if (  !bPainCausing )
		{
			return;
		}
		foreach TouchingActors(Class'Actor',A)
		{
			CausePainTo(A);
		}
	}
}

function Trigger (Actor Other, Pawn EventInstigator)
{
	if ( DamagePerSec != 0 )
	{
		bPainCausing= !bPainCausing;
		if ( bPainCausing && (PainTimer == None) )
		{
			PainTimer=Spawn(Class'VolumeTimer',self);
		}
	}
}

event Touch (Actor Other)
{
	Super.Touch(Other);
	if ( bNoInventory && Other.IsA('Inventory') && (Other.Owner == None) )
	{
		Other.LifeSpan=1.50;
		return;
	}
	if ( bMoveProjectiles && (ZoneVelocity != vect(0.00,0.00,0.00)) )
	{
		if ( Other.Physics == 6 )
		{
			Other.Velocity += ZoneVelocity;
		}
		else
		{
			if ( Other.IsA('Effects') && (Other.Physics == PHYS_None) )
			{
				Other.SetPhysics(PHYS_Projectile);
				Other.Velocity += ZoneVelocity;
			}
		}
	}
	if ( bPainCausing )
	{
		if ( Other.bDestroyInPainVolume )
		{
			Other.Destroy();
			return;
		}
		CausePainTo(Other);
	}
	if ( bWaterVolume && Other.CanSplash() )
	{
		PlayEntrySplash(Other);
	}
}

function PlayEntrySplash (Actor Other)
{
	local float SplashSize;
	local Actor splash;

	SplashSize=FClamp(0.00 * Other.Mass * (250 - 0.50 * FMax(-600.00,Other.Velocity.Z)),0.10,1.00);
	if ( EntrySound != None )
	{
		if ( Other.Instigator != None )
		{
			MakeNoise(SplashSize);
		}
	}
	if ( EntryActor != None )
	{
		splash=Spawn(EntryActor);
		if ( splash != None )
		{
			splash.SetDrawScale(SplashSize);
		}
	}
}

event UnTouch (Actor Other)
{
	if ( bWaterVolume && Other.CanSplash() )
	{
		PlayExitSplash(Other);
	}
}

function PlayExitSplash (Actor Other)
{
	local float SplashSize;
	local Actor splash;

	SplashSize=FClamp(0.00 * Other.Mass,0.10,1.00);
	if ( ExitActor != None )
	{
		splash=Spawn(ExitActor);
		if ( splash != None )
		{
			splash.SetDrawScale(SplashSize);
		}
	}
}

function CausePainTo (Actor Other)
{
	local float depth;
	local Pawn P;

	depth=1.00;
	P=Pawn(Other);
	if ( DamagePerSec > 0 )
	{
		Other.TakeDamage(DamagePerSec * depth,None,Location,vect(0.00,0.00,0.00),DamageType);
		if ( (P != None) && (P.Controller != None) )
		{
			P.Controller.PawnIsInPain(self);
		}
	}
	else
	{
		if ( (P != None) && (P.Health < P.Default.Health) )
		{
			P.Health=Min(P.Default.Health,P.Health - depth * DamagePerSec);
		}
	}
}

defaultproperties
{
    GroundFriction=8.00
    TerminalVelocity=2500.00
    FluidFriction=0.30
    Gravity=(X=0.00,Y=0.00,Z=-1500.00)
    bAlwaysRelevant=True
    m_bSeeThrough=True
}