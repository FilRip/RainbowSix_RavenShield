//================================================================================
// R6DZonePoint.
//================================================================================
class R6DZonePoint extends R6DeploymentZone
	Native
	Placeable;

var(R6DZone) EStance m_eStance;
var(R6DZone) bool m_bUseReactionZone;
var(R6DZone) float m_fReactionZoneX;
var(R6DZone) float m_fReactionZoneY;
var(R6DZone) Vector m_vReactionZoneCenter;

defaultproperties
{
    m_fReactionZoneX=300.00
    m_fReactionZoneY=300.00
    bDirectional=True
}