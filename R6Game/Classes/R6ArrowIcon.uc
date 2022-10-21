//================================================================================
// R6ArrowIcon.
//================================================================================
class R6ArrowIcon extends R6ReferenceIcons;

var Vector m_vPointToReach;
var Vector m_vStartLocation;

state FollowPath
{
	function Tick (float DeltaTime)
	{
		if ( Physics == 5 )
		{
			if ( (Abs(DesiredRotation.Yaw - (Rotation.Yaw & 65535)) < 20) && (Abs(DesiredRotation.Pitch - (Rotation.Pitch & 65535)) < 20) )
			{
				R6PlanningPawn(Owner).ArrowRotationIsOK();
			}
		}
		else
		{
			if ( VSize(m_vPointToReach - m_vStartLocation) < VSize(Location - m_vStartLocation) )
			{
				R6PlanningPawn(Owner).ArrowReachedNavPoint();
			}
		}
		m_u8SpritePlanningAngle=Rotation.Yaw / 255 + 64;
	}

	function EndState ()
	{
		m_bSpriteShowOver=False;
		Velocity=vect(0.00,0.00,0.00);
	}

	function BeginState ()
	{
		m_bSpriteShowOver=True;
	}

}

defaultproperties
{
    Physics=6
    bHidden=True
    bIgnoreOutOfWorld=True
    bRotateToDesired=True
    m_bSpriteShownIn3DInPlanning=True
    DrawScale=1.25
    RotationRate=(Pitch=0,Yaw=5000,Roll=0)
}
/*
    Texture=Texture'R6Planning.Icons.PlanIcon_Arrow'
*/

