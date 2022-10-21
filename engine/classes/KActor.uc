//================================================================================
// KActor.
//================================================================================
class KActor extends Actor
	Native
//	NoNativeReplication
	Placeable;

var(Karma) bool bKTakeShot;
var() bool bOrientImpactEffect;
var() float ImpactVolume;
var() float ImpactInterval;
var() Class<Actor> ImpactEffect;
var() array<Sound> ImpactSounds;
var transient float LastImpactTime;

function TakeDamage (int Damage, Pawn instigatedBy, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType)
{
	local Vector ApplyImpulse;

}

function Trigger (Actor Other, Pawn EventInstigator)
{
	KWake();
}

event KImpact (Actor Other, Vector pos, Vector impactVel, Vector impactNorm)
{
	local int numSounds;
	local int soundNum;

	if ( Level.TimeSeconds > LastImpactTime + ImpactInterval )
	{
		numSounds=ImpactSounds.Length;
		if ( numSounds > 0 )
		{
			soundNum=Rand(numSounds);
		}
		LastImpactTime=Level.TimeSeconds;
	}
}

defaultproperties
{
    bKTakeShot=True
    Physics=13
    RemoteRole=ROLE_None
    DrawType=8
    bNoDelete=True
    bAcceptsProjectors=True
    bCollideActors=True
    bBlockActors=True
    bBlockPlayers=True
    bProjTarget=True
    bBlockKarma=True
    bEdShouldSnap=True
    CollisionRadius=1.00
    CollisionHeight=1.00
}