//================================================================================
// R6SubActionLookAt.
//================================================================================
class R6SubActionLookAt extends MatSubAction
	Native;

var(R6LookAt) bool m_bAim;
var(R6LookAt) bool m_bNoBlend;
var(R6LookAt) R6Pawn m_AffectedPawn;
var(R6LookAt) Actor m_TargetActor;

defaultproperties
{
    Desc="LookAtActor"
}
/*
    Icon=Texture'R6SubActionLookAtIcon'
*/

