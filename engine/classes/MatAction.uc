//================================================================================
// MatAction.
//================================================================================
class MatAction extends MatObject
	Native
	Abstract;

enum EPhysics {
	PHYS_None,
	PHYS_Walking,
	PHYS_Falling,
	PHYS_Swimming,
	PHYS_Flying,
	PHYS_Rotating,
	PHYS_Projectile,
	PHYS_Interpolating,
	PHYS_MovingBrush,
	PHYS_Spider,
	PHYS_Trailer,
	PHYS_Ladder,
	PHYS_RootMotion,
	PHYS_Karma,
	PHYS_KarmaRagDoll
};

var(R6Pawn) EPhysics m_PhysicsActor;
var(Path) bool bSmoothCorner;
var(Path) bool bConstantPathVelocity;
var(R6Pawn) bool m_bCollideActor;
var(Time) float Duration;
var(Path) float PathVelocity;
var float PathLength;
var() InterpolationPoint IntPoint;
var Texture Icon;
var(Sub) export editinlineuse array<MatSubAction> SubActions;
var(Path) Vector StartControlPoint;
var(Path) Vector EndControlPoint;
var() string Comment;
var transient float PctStarting;
var transient float PctEnding;
var transient float PctDuration;
var transient array<Vector> SampleLocations;

event Initialize ();

event ActionStart (Actor Viewer)
{
	if ( m_bCollideActor == True )
	{
		Viewer.SetCollision(True,True,True);
	}
	else
	{
		Viewer.SetCollision(True,False,False);
	}
//	Viewer.SetPhysics(m_PhysicsActor);
	Viewer.bInterpolating=True;
}

defaultproperties
{
    bSmoothCorner=True
    StartControlPoint=(X=800.00,Y=800.00,Z=0.00)
    EndControlPoint=(X=-800.00,Y=-800.00,Z=0.00)
}