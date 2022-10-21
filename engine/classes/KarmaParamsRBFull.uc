//================================================================================
// KarmaParamsRBFull.
//================================================================================
class KarmaParamsRBFull extends KarmaParams
	Native;

var() float KInertiaTensor[6];
var() Vector KCOMOffset;

defaultproperties
{
    KInertiaTensor(0)=0.40
    KInertiaTensor(3)=0.40
    KInertiaTensor(5)=0.40
}