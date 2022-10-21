//================================================================================
// R6DZoneRandomPointNode.
//================================================================================
class R6DZoneRandomPointNode extends Actor
	Native
//	NoNativeReplication
	Placeable;

var(R6DZone) EStance m_eStance;
var(R6DZone) int m_iGroupID;
var(R6DZone) bool m_bHighPriority;
var R6DZoneRandomPoints m_pZone;

defaultproperties
{
    m_eStance=1
    bHidden=True
    m_bUseR6Availability=True
    bDirectional=True
    CollisionRadius=40.00
    CollisionHeight=85.00
}
/*
    Texture=Texture'R6Engine_T.Icons.DZoneTer'
*/

