//================================================================================
// JumpPad.
//================================================================================
class JumpPad extends NavigationPoint
	Native;

var Actor JumpTarget;
var Vector JumpVelocity;
var() Vector JumpModifier;

event Touch (Actor Other)
{
	if ( Pawn(Other) == None )
	{
		return;
	}
	PendingTouch=Other.PendingTouch;
	Other.PendingTouch=self;
}

event PostTouch (Actor Other)
{
	local Pawn P;

	P=Pawn(Other);
	if ( P == None )
	{
		return;
	}
	if ( AIController(P.Controller) != None )
	{
		P.Controller.MoveTarget=JumpTarget;
		P.Controller.Focus=JumpTarget;
		P.Controller.MoveTimer=2.00;
		P.DestinationOffset=JumpTarget.CollisionRadius;
	}
	if ( P.Physics == PHYS_Walking )
	{
		P.SetPhysics(PHYS_Falling);
	}
	P.Velocity=JumpVelocity + JumpModifier;
	P.Acceleration=vect(0.00,0.00,0.00);
}

defaultproperties
{
    JumpVelocity=(X=0.00,Y=0.00,Z=1200.00)
    bDestinationOnly=True
    bCollideActors=True
}