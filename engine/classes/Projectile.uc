//================================================================================
// Projectile.
//================================================================================
class Projectile extends Actor
	Native
	Abstract;
//	NoNativeReplication;

var float speed;
var float MaxSpeed;
var float TossZ;
var float Damage;
var float DamageRadius;
var float MomentumTransfer;
var float ExploWallOut;
var Sound SpawnSound;
var Sound ImpactSound;
var Class<DamageType> MyDamageType;
var Class<Projector> ExplosionDecal;

function bool EncroachingOn (Actor Other)
{
	if ( (Other.Brush != None) || (Brush(Other) != None) )
	{
		return True;
	}
	return False;
}

singular simulated function Touch (Actor Other)
{
	local Actor HitActor;
	local Vector HitLocation;
	local Vector HitNormal;
	local Vector VelDir;
	local bool bBeyondOther;
	local float BackDist;
	local float DirZ;

	if ( Other.bProjTarget || Other.bBlockActors && Other.bBlockPlayers )
	{
		if ( Velocity == vect(0.00,0.00,0.00) )
		{
			ProcessTouch(Other,Location);
			return;
		}
		bBeyondOther=Velocity Dot (Location - Other.Location) > 0;
		VelDir=Normal(Velocity);
		DirZ=Sqrt(VelDir.Z);
		BackDist=Other.CollisionRadius * (1 - DirZ) + Other.CollisionHeight * DirZ;
		if ( bBeyondOther )
		{
			BackDist += VSize(Location - Other.Location);
		}
		else
		{
			BackDist -= VSize(Location - Other.Location);
		}
		HitActor=Trace(HitLocation,HitNormal,Location,Location - 1.10 * BackDist * VelDir,True);
		if ( HitActor == Other )
		{
			ProcessTouch(Other,HitLocation);
		}
		else
		{
			if ( bBeyondOther )
			{
				ProcessTouch(Other,Other.Location - Other.CollisionRadius * VelDir);
			}
			else
			{
				ProcessTouch(Other,Location);
			}
		}
	}
}

simulated function ProcessTouch (Actor Other, Vector HitLocation)
{
	if ( Other != Instigator )
	{
		Explode(HitLocation,Normal(HitLocation - Other.Location));
	}
}

simulated function HitWall (Vector HitNormal, Actor Wall)
{
	if ( Role == Role_Authority )
	{
		if ( Mover(Wall) != None )
		{
			Wall.TakeDamage(Damage,Instigator,Location,MomentumTransfer * Normal(Velocity),MyDamageType);
		}
		MakeNoise(1.00);
	}
	Explode(Location + ExploWallOut * HitNormal,HitNormal);
	if ( (ExplosionDecal != None) && (Level.NetMode != 1) )
	{
		Spawn(ExplosionDecal,self,,Location,rotator( -HitNormal));
	}
}

simulated function BlowUp (Vector HitLocation)
{
	HurtRadius(Damage,DamageRadius,MyDamageType,MomentumTransfer,HitLocation);
	if ( Role == Role_Authority )
	{
		MakeNoise(1.00);
	}
}

simulated function Explode (Vector HitLocation, Vector HitNormal)
{
	Destroy();
}

final simulated function RandSpin (float spinRate)
{
	DesiredRotation=RotRand();
	RotationRate.Yaw=spinRate * 2 * FRand() - spinRate;
	RotationRate.Pitch=spinRate * 2 * FRand() - spinRate;
	RotationRate.Roll=spinRate * 2 * FRand() - spinRate;
}

static function Vector GetTossVelocity (Pawn P, Rotator R)
{
	local Vector V;

	V=vector(R);
	V *= P.Velocity Dot V * 0.40 + Default.speed;
	V.Z += Default.TossZ;
	return V;
}

defaultproperties
{
    MaxSpeed=2000.00
    TossZ=100.00
    DamageRadius=220.00
    MyDamageType=Class'DamageType'
    Physics=6
    RemoteRole=ROLE_SimulatedProxy
    DrawType=2
    bNetTemporary=True
    bReplicateInstigator=True
    bUnlit=True
    bGameRelevant=True
    bCollideActors=True
    bCollideWorld=True
    LifeSpan=140.00
    NetPriority=2.50
}
/*
    Texture=Texture'S_Camera'
*/

