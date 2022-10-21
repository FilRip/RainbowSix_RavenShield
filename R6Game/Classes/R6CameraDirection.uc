//================================================================================
// R6CameraDirection.
//================================================================================
class R6CameraDirection extends R6ReferenceIcons;

function SetPlanningRotation (Rotator PointRotation)
{
	m_u8SpritePlanningAngle=PointRotation.Yaw / 255;
}

defaultproperties
{
    bHidden=True
    DrawScale=6.00
}
/*
    Texture=Texture'R6Planning.Icons.PlanIcon_CamDirection'
*/

