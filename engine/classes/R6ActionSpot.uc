//================================================================================
// R6ActionSpot.
//================================================================================
class R6ActionSpot extends Actor
	Native
//	NoNativeReplication
	Placeable;

var() EStance m_eCover;
var() EStance m_eFire;
var int m_iLastInvestigateID;
var bool m_bValidTarget;
var() bool m_bInvestigate;
var NavigationPoint m_Anchor;
var Pawn m_pCurrentUser;
var R6ActionSpot m_NextSpot;

simulated function FirstPassReset ()
{
	m_pCurrentUser=None;
}

defaultproperties
{
    m_bInvestigate=True
    bStatic=True
    bHidden=True
    bCollideWhenPlacing=True
    bDirectional=True
    CollisionRadius=80.00
    CollisionHeight=135.00
}
/*
    Texture=Texture'ASBase'
*/

