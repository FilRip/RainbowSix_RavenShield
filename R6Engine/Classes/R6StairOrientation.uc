//================================================================================
// R6StairOrientation.
//================================================================================
class R6StairOrientation extends Actor
	Native;
//	NoNativeReplication;

var() R6StairVolume m_pStairVolume;

simulated function PostBeginPlay ()
{
	Super.PostBeginPlay();
	if ( m_pStairVolume == None )
	{
		Log("WARNING: " $ string(Name) $ " is not linked to a stair volume. Remove it.");
	}
}

defaultproperties
{
    m_eDisplayFlag=0
    bStatic=True
    bHidden=True
    m_bSkipHitDetection=True
    m_bSpriteShowFlatInPlanning=True
}
/*
    Texture=Texture'R6Planning.Icons.PlanIcon_Stairs'
*/

