//================================================================================
// R6PlanningBreach.
//================================================================================
class R6PlanningBreach extends R6ReferenceIcons;

function SetSpriteAngle (int iDoorClosedYaw, Vector vPointLocation)
{
	local Vector vDirection;
	local Rotator rPointDoorRotator;
	local int iYawDifference;

	m_u8SpritePlanningAngle=iDoorClosedYaw / 255;
	rPointDoorRotator=rotator(vPointLocation - Location);
	if ( rPointDoorRotator.Yaw < 0 )
	{
		rPointDoorRotator.Yaw += 65536;
	}
	iYawDifference=rPointDoorRotator.Yaw - iDoorClosedYaw;
	if ( iYawDifference < 0 )
	{
		iYawDifference += 65536;
	}
	if ( iYawDifference < 0 )
	{
		iYawDifference += 65536;
	}
	if ( iYawDifference > 32767 )
	{
		vDirection=DrawScale3D;
		vDirection.Y *= -1;
		SetDrawScale3D(vDirection);
	}
}

defaultproperties
{
    m_bSkipHitDetection=False
}
/*
    Texture=Texture'R6Planning.Icons.PlanIcon_BreachDoor'
*/

