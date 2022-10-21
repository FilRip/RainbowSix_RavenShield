//================================================================================
// R6PlanningSnipe.
//================================================================================
class R6PlanningSnipe extends R6ReferenceIcons;

function Rotator SetDirectionRotator (Vector vTowards)
{
	local Rotator rActionRotator;
	local Vector vResultVector;

	vResultVector=Normal(vTowards - Location);
	rActionRotator=rotator(vResultVector);
	m_u8SpritePlanningAngle=rActionRotator.Yaw / 255;
	return rActionRotator;
}

defaultproperties
{
    DrawScale=2.50
}
/*
    Texture=Texture'R6Planning.Icons.PlanIcon_Snipe'
*/

