//================================================================================
// Fragment.
//================================================================================
class Fragment extends Effects;

var int numFragmentTypes;
var bool bFirstHit;
var() float SplashTime;
var() Mesh Fragments[11];
var() Sound ImpactSound;
var() Sound AltImpactSound;

function bool CanSplash ()
{
	if ( (Level.TimeSeconds - SplashTime > 0.25) && (Physics == 2) && (Abs(Velocity.Z) > 100) )
	{
		SplashTime=Level.TimeSeconds;
		return True;
	}
	return False;
}

simulated function CalcVelocity (Vector Momentum)
{
	local float ExplosionSize;

	ExplosionSize=0.01 * VSize(Momentum);
	Velocity=0.00 * Momentum + 0.70 * VRand() * (ExplosionSize + FRand() * 100.00 + 100.00);
	Velocity.Z += 0.50 * ExplosionSize;
}

simulated function HitWall (Vector HitNormal, Actor HitWall)
{
	local float speed;

	Velocity=0.50 * (Velocity Dot HitNormal * HitNormal * -2.00 + Velocity);
	speed=VSize(Velocity);
	if ( bFirstHit && (speed < 400) )
	{
		bFirstHit=False;
		bRotateToDesired=True;
		bFixedRotationDir=False;
		DesiredRotation.Pitch=0;
		DesiredRotation.Yaw=FRand() * 65536;
		DesiredRotation.Roll=0;
	}
	RotationRate.Yaw=RotationRate.Yaw * 0.75;
	RotationRate.Roll=RotationRate.Roll * 0.75;
	RotationRate.Pitch=RotationRate.Pitch * 0.75;
	if ( (speed < 60) && (HitNormal.Z > 0.70) )
	{
		SetPhysics(PHYS_None);
		bBounce=False;
		GotoState('Dying');
	}
	else
	{
		if ( speed > 80 )
		{
			if ( FRand() < 0.50 )
			{
				PlaySound(ImpactSound,SLOT_SFX);
			}
			else
			{
				PlaySound(AltImpactSound,SLOT_SFX);
			}
		}
	}
}

final simulated function RandSpin (float spinRate)
{
	DesiredRotation=RotRand();
	RotationRate.Yaw=spinRate * 2 * FRand() - spinRate;
	RotationRate.Pitch=spinRate * 2 * FRand() - spinRate;
	RotationRate.Roll=spinRate * 2 * FRand() - spinRate;
}

auto state Flying
{
	simulated function Timer ()
	{
		GotoState('Dying');
	}
	
	singular simulated function PhysicsVolumeChange (PhysicsVolume NewVolume)
	{
		if ( NewVolume.bWaterVolume )
		{
			Velocity=0.20 * Velocity;
			if ( bFirstHit )
			{
				bFirstHit=False;
				bRotateToDesired=True;
				bFixedRotationDir=False;
				DesiredRotation.Pitch=0;
				DesiredRotation.Yaw=FRand() * 65536;
				DesiredRotation.Roll=0;
			}
			RotationRate=0.20 * RotationRate;
			GotoState('Dying');
		}
	}
	
	simulated function BeginState ()
	{
		RandSpin(125000.00);
		if ( Abs(RotationRate.Pitch) < 10000 )
		{
			RotationRate.Pitch=10000;
		}
		if ( Abs(RotationRate.Roll) < 10000 )
		{
			RotationRate.Roll=10000;
		}
		LinkMesh(Fragments[FRand() * numFragmentTypes]);
		if ( Level.NetMode == NM_Standalone )
		{
			LifeSpan=20.00 + 40 * FRand();
		}
		SetTimer(5.00,True);
	}
	
}

state Dying
{
	function TakeDamage (int Dam, Pawn instigatedBy, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType)
	{
		Destroy();
	}
	
	simulated function Timer ()
	{
		if (  !PlayerCanSeeMe() )
		{
			Destroy();
		}
	}
	
	simulated function BeginState ()
	{
		SetTimer(1.00 + FRand(),True);
		SetCollision(True,False,False);
	}
	
}

defaultproperties
{
    bFirstHit=True
    Physics=2
    DrawType=2
    bDestroyInPainVolume=True
    bCollideWorld=True
    bBounce=True
    bFixedRotationDir=True
    LifeSpan=20.00
    CollisionRadius=18.00
    CollisionHeight=4.00
}