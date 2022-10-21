//================================================================================
// R6DZonePathNode.
//================================================================================
class R6DZonePathNode extends Actor
	Native
//	NoNativeReplication
	Placeable;

var(R6DZone) int m_AnimChance;
var(R6DZone) bool m_bWait;
var(R6DZone) float m_fRadius;
var R6DZonePath m_pPath;
var(R6DZone) Sound m_SoundToPlay;
var(R6DZone) Sound m_SoundToPlayStop;
var(R6DZone) name m_AnimToPlay;

event Destroyed ()
{
}

defaultproperties
{
    m_bWait=True
    m_fRadius=50.00
    bHidden=True
    m_bUseR6Availability=True
    CollisionRadius=40.00
    CollisionHeight=85.00
}
/*
    Texture=Texture'R6Engine_T.Icons.DZoneTer'
*/

