//=============================================================================
// Projectile.
//
// A delayed-hit projectile that moves around for some time after it is created.
//=============================================================================
class Projectile extends Actor
	abstract
	native;

//-----------------------------------------------------------------------------
// Projectile variables.

// Motion information.
var		float   Speed;               // Initial speed of projectile.
var		float   MaxSpeed;            // Limit on speed of projectile (0 means no limit)
var		float	TossZ;
var		Actor	ZeroCollider;
var		bool	bSwitchToZeroCollision; // if collisionextent nonzero, and hit actor with bBlockNonZeroExtents=0, switch to zero extent collision

// Damage attributes.
var   float    Damage; 
var	  float	   DamageRadius;        
var   float	   MomentumTransfer; // Momentum magnitude imparted by impacting projectile.
var   class<DamageType>	   MyDamageType;

// Projectile sound effects
var   sound    SpawnSound;		// Sound made when projectile is spawned.
var   sound	   ImpactSound;		// Sound made when projectile hits something.

// explosion effects
var   class<Projector> ExplosionDecal;
var   float		ExploWallOut;	// distance to move explosions out from wall
var Controller	InstigatorController;

/* HurtRadius()
 Hurt locally authoritative actors within the radius.
*/
simulated function DelayedHurtRadius( float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation )
{
	local actor Victims;
	local float damageScale, dist;
	local vector dir;
	
	if( bHurtEntry )
		return;

	bHurtEntry = true;
	foreach VisibleCollidingActors( class 'Actor', Victims, DamageRadius, HitLocation )
	{
		// don't let blast damage affect fluid - VisibleCollisingActors doesn't really work for them - jag
		if( (Victims != self) && (Victims.Role == ROLE_Authority) && (!Victims.IsA('FluidSurfaceInfo')) )
		{
			dir = Victims.Location - HitLocation;
			dist = FMax(1,VSize(dir));
			dir = dir/dist; 
			damageScale = 1 - FMax(0,(dist - Victims.CollisionRadius)/DamageRadius);
			if ( DamageType.Default.bDelayedDamage && (Instigator == None) && (Pawn(Victims) != None) )
				Pawn(Victims).DelayedDamageInstigatorController = InstigatorController;
			Victims.TakeDamage
			(
				damageScale * DamageAmount,
				Instigator, 
				Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir,
				(damageScale * Momentum * dir),
				DamageType
			);
		} 
	}
	bHurtEntry = false;
}

//==============
// Encroachment
function bool EncroachingOn( actor Other )
{
	if ( (Other.Brush != None) || (Brush(Other) != None) )
		return true;
		
	return false;
}

//==============
// Touching
simulated singular function Touch(Actor Other)
{
	local actor HitActor;
	local vector HitLocation, HitNormal, VelDir, AdjustedLocation;
	local bool bBeyondOther;
	local float BackDist, DirZ;

	if ( Other == None ) // Other just got destroyed in its touch?
		return;
	if ( Other.bProjTarget || (Other.bBlockActors && Other.bBlockPlayers) )
	{
		if ( Velocity == vect(0,0,0) || Other.IsA('Mover') ) 
		{
			ProcessTouch(Other,Location);
			return;
		}
		
		//get exact hitlocation - trace back along velocity vector
		bBeyondOther = ( (Velocity Dot (Location - Other.Location)) > 0 );
		VelDir = Normal(Velocity);
		DirZ = sqrt(abs(VelDir.Z));
		BackDist = Other.CollisionRadius * (1 - DirZ) + Other.CollisionHeight * DirZ;
		if ( bBeyondOther )
			BackDist += VSize(Location - Other.Location);
		else
			BackDist -= VSize(Location - Other.Location);

	 	HitActor = Trace(HitLocation, HitNormal, Location, Location - 1.1 * BackDist * VelDir, true);
		if (HitActor == Other)
			AdjustedLocation = HitLocation;
		else if ( bBeyondOther )
			AdjustedLocation = Other.Location - Other.CollisionRadius * VelDir;
		else
			AdjustedLocation = Location;
		ProcessTouch(Other, AdjustedLocation);
		if ( (Role < ROLE_Authority) && (Other.Role == ROLE_Authority) && (Pawn(Other) != None) )
			ClientSideTouch(Other, AdjustedLocation);
	}
}

simulated function ClientSideTouch(Actor Other, Vector HitLocation)
{
	Other.TakeDamage(Damage, instigator, Location, MomentumTransfer * Normal(Velocity), MyDamageType);
}

simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
	if ( Other != Instigator )
		Explode(HitLocation,Normal(HitLocation-Other.Location));
}

simulated function HitWall (vector HitNormal, actor Wall)
{
	if ( Role == ROLE_Authority )
	{
		if ( Mover(Wall) != None )
			Wall.TakeDamage( Damage, instigator, Location, MomentumTransfer * Normal(Velocity), MyDamageType);

		MakeNoise(1.0);
	}
	Explode(Location + ExploWallOut * HitNormal, HitNormal);
	if ( (ExplosionDecal != None) && (Level.NetMode != NM_DedicatedServer) )
		Spawn(ExplosionDecal,self,,Location, rotator(-HitNormal));
}

simulated function BlowUp(vector HitLocation)
{
	HurtRadius(Damage,DamageRadius, MyDamageType, MomentumTransfer, HitLocation );
	if ( Role == ROLE_Authority )
		MakeNoise(1.0);
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	Destroy();
}

simulated final function RandSpin(float spinRate)
{
	DesiredRotation = RotRand();
	RotationRate.Yaw = spinRate * 2 *FRand() - spinRate;
	RotationRate.Pitch = spinRate * 2 *FRand() - spinRate;
	RotationRate.Roll = spinRate * 2 *FRand() - spinRate;	
}

defaultproperties
{
	bCanBeDamaged=true
	 bAcceptsProjectors=false
	 bUseCylinderCollision=true
	 DamageRadius=+220.0
     MaxSpeed=+02000.000000
     DrawType=DT_Mesh
     Texture=S_Camera
     SoundVolume=0
     CollisionRadius=+00000.000000
     CollisionHeight=+00000.000000
     bCollideActors=True
     bCollideWorld=True
	 bNetTemporary=true
	 bGameRelevant=true
	 bReplicateInstigator=true
     Physics=PHYS_Projectile
     LifeSpan=+0014.000000
     NetPriority=+00002.500000
	 MyDamageType=class'DamageType'
	 RemoteRole=ROLE_SimulatedProxy
	 bUnlit=true
	 TossZ=+100.0
     bNetInitialRotation=true
	 bDisturbFluidSurface=true
}
