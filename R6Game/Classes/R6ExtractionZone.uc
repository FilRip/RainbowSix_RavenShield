//================================================================================
// R6ExtractionZone.
//================================================================================
class R6ExtractionZone extends R6AbstractExtractionZone
	Placeable;

function Touch (Actor Other)
{
	if ( (R6Pawn(Other) != None) && (Level.Game != None) )
	{
		R6Pawn(Other).EnteredExtractionZone(self);
		R6AbstractGameInfo(Level.Game).EnteredExtractionZone(Other);
	}
}

function UnTouch (Actor Other)
{
	if ( (R6Pawn(Other) != None) && (Level.Game != None) )
	{
		R6AbstractGameInfo(Level.Game).LeftExtractionZone(Other);
		R6Pawn(Other).LeftExtractionZone(self);
	}
}

defaultproperties
{
    bHidden=False
    m_bUseR6Availability=True
    m_bSkipHitDetection=True
    bCollideActors=True
    bCollideWorld=True
    DrawScale=12.00
    CollisionRadius=128.00
    CollisionHeight=20.00
    m_PlanningColor=(R=181,G=134,B=24,A=255)
}
/*
    Texture=Texture'R6Planning.Icons.PlanIcon_ZoneDefault'
*/

