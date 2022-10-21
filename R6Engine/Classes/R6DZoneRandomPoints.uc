//================================================================================
// R6DZoneRandomPoints.
//================================================================================
class R6DZoneRandomPoints extends R6DeploymentZone
	Native
	Placeable;

var(R6DZone) bool m_bSelectNodeInEditor;
var bool m_bInInit;
var(R6DZone) editinlineuse array<R6DZoneRandomPointNode> m_aNode;
var const array<R6DZoneRandomPointNode> m_aTempHighPriorityNode;
var const array<R6DZoneRandomPointNode> m_aTempNode;