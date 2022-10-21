//================================================================================
// KConeLimit.
//================================================================================
class KConeLimit extends KConstraint
	Native;

var(KarmaConstraint) float KHalfAngle;
var(KarmaConstraint) float KStiffness;
var(KarmaConstraint) float KDamping;

defaultproperties
{
    KHalfAngle=8200.00
    KStiffness=50.00
    bDirectional=True
}
/*
    Texture=Texture'S_KConeLimit'
*/

