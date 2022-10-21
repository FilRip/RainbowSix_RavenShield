//================================================================================
// Decoration.
//================================================================================
class Decoration extends Actor
	Native
	Abstract
//	NoNativeReplication
	Placeable;

var const int numLandings;
var() int NumFrags;
var() int Health;
var() bool bPushable;
var() bool bDamageable;
var bool bPushSoundPlaying;
var bool bSplash;
var() float SplashTime;
var() Sound PushSound;
var() Sound EndPushSound;
var() Texture FragSkin;
var() Class<Actor> EffectWhenDestroyed;
var() Class<Fragment> FragType;
var Vector FragMomentum;

function bool CanSplash ()
{
	if ( (Level.TimeSeconds - SplashTime > 0.25) && (Physics == 2) && (Abs(Velocity.Z) > 100) )
	{
		SplashTime=Level.TimeSeconds;
		return True;
	}
	return False;
}

function Drop (Vector newVel);

function Landed (Vector HitNormal)
{
	local Rotator newRot;

	if ( Velocity.Z < -500 )
	{
		TakeDamage(100,Pawn(Owner),HitNormal,HitNormal * 10000,Class'Crushed');
	}
	Velocity=vect(0.00,0.00,0.00);
	newRot=Rotation;
	newRot.Pitch=0;
	newRot.Roll=0;
	SetRotation(newRot);
}

function HitWall (Vector HitNormal, Actor Wall)
{
	Landed(HitNormal);
}

function TakeDamage (int NDamage, Pawn instigatedBy, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType)
{
	Instigator=instigatedBy;
	if (  !bDamageable || (Health < 0) )
	{
		return;
	}
	if ( Instigator != None )
	{
		MakeNoise(1.00);
	}
	Health -= NDamage;
	FragMomentum=Momentum;
	if ( Health < 0 )
	{
		Destroy();
	}
	else
	{
		SetPhysics(PHYS_Falling);
		Momentum.Z=1000.00;
		Velocity=Momentum / Mass;
	}
}

singular function PhysicsVolumeChange (PhysicsVolume NewVolume)
{
	if ( NewVolume.bWaterVolume )
	{
		if ( bSplash &&  !PhysicsVolume.bWaterVolume && (Mass <= Buoyancy) && ((Abs(Velocity.Z) < 100) || (Mass == 0)) && (FRand() < 0.05) &&  !PlayerCanSeeMe() )
		{
			bSplash=False;
			SetPhysics(PHYS_None);
		}
	}
	if ( PhysicsVolume.bWaterVolume && (Buoyancy > Mass) )
	{
		if ( Buoyancy > 1.10 * Mass )
		{
			Buoyancy=0.95 * Buoyancy;
		}
		else
		{
			if ( Buoyancy > 1.03 * Mass )
			{
				Buoyancy=0.99 * Buoyancy;
			}
		}
	}
}

function Trigger (Actor Other, Pawn EventInstigator)
{
	Instigator=EventInstigator;
	TakeDamage(1000,Instigator,Location,vect(0.00,0.00,1.00) * 900,Class'Crushed');
}

singular function BaseChange ()
{
	if ( Velocity.Z < -500 )
	{
		TakeDamage(1 - Velocity.Z / 30,Instigator,Location,vect(0.00,0.00,0.00),Class'Crushed');
	}
	if ( Base == None )
	{
		if (  !bInterpolating && bPushable && (Physics == PHYS_None) )
		{
			SetPhysics(PHYS_Falling);
		}
	}
	else
	{
		if ( Pawn(Base) != None )
		{
			Base.TakeDamage((1 - Velocity.Z / 400) * Mass / Base.Mass,Instigator,Location,0.50 * Velocity,Class'Crushed');
			Velocity.Z=100.00;
			if ( FRand() < 0.50 )
			{
				Velocity.X += 70;
			}
			else
			{
				Velocity.Y += 70;
			}
			SetPhysics(PHYS_Falling);
		}
		else
		{
			if ( (Decoration(Base) != None) && (Velocity.Z < -500) )
			{
				Base.TakeDamage(1 - Mass / Base.Mass * Velocity.Z / 30,Instigator,Location,0.20 * Velocity,Class'Crushed');
				Velocity.Z=100.00;
				if ( FRand() < 0.50 )
				{
					Velocity.X += 70;
				}
				else
				{
					Velocity.Y += 70;
				}
				SetPhysics(PHYS_Falling);
			}
			else
			{
				Instigator=None;
			}
		}
	}
}

simulated function Destroyed ()
{
	local int i;
	local Fragment S;
	local float BaseSize;

	if ( Role == Role_Authority )
	{
		TriggerEvent(Event,self,None);
	}
	if ( (Level.NetMode != 1) &&  !PhysicsVolume.bDestructive && (NumFrags > 0) && (FragType != None) )
	{
		BaseSize=0.80 * Sqrt(CollisionRadius * CollisionHeight) / NumFrags;
		i=0;
		while ( i < NumFrags )
		{
			S=Spawn(FragType,Owner,,Location + CollisionRadius * VRand());
			S.CalcVelocity(FragMomentum);
			if ( FragSkin != None )
			{
				S.Skins[0]=FragSkin;
			}
			S.SetDrawScale(BaseSize * (0.50 + 0.70 * FRand()));
			i++;
		}
	}
	Super.Destroyed();
}

function Timer ()
{
	bPushSoundPlaying=False;
}

function Bump (Actor Other)
{
	local float speed;
	local float oldZ;

	if ( bPushable && (Pawn(Other) != None) && (Other.Mass > 40) )
	{
		oldZ=Velocity.Z;
		speed=VSize(Other.Velocity);
		Velocity=Other.Velocity * FMin(120.00,20.00 + speed) / speed;
		if ( Physics == 0 )
		{
			Velocity.Z=25.00;
			if (  !bPushSoundPlaying )
			{
				bPushSoundPlaying=True;
			}
		}
		else
		{
			Velocity.Z=oldZ;
		}
		SetPhysics(PHYS_Falling);
		SetTimer(0.30,False);
		Instigator=Pawn(Other);
	}
}

defaultproperties
{
    DrawType=2
    bStatic=True
    bStasis=True
    bOrientOnSlope=True
    bShouldBaseAtStartup=True
    NetUpdateFrequency=10.00
}