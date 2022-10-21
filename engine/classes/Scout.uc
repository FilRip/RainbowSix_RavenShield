//================================================================================
// Scout.
//================================================================================
class Scout extends Pawn
	Native
//	NoNativeReplication
	NotPlaceable;

var const float MaxLandingVelocity;

function PreBeginPlay ()
{
	Destroy();
}

defaultproperties
{
    AccelRate=1.00
    bCollideActors=False
    bCollideWorld=False
    bBlockActors=False
    bBlockPlayers=False
    bProjTarget=False
    bPathColliding=True
    CollisionRadius=52.00
}