//================================================================================
// KarmaParamsCollision.
//================================================================================
class KarmaParamsCollision extends Object
	Native
//	Export
	EditInLineNew;

var const float KScale;
var() float KFriction;
var() float KRestitution;
var() float KImpactThreshold;
var const Vector KScale3D;
var const transient int KarmaData;

defaultproperties
{
    KScale=1.00
    KFriction=1.00
    KImpactThreshold=1000000.00
    KScale3D=(X=1.00,Y=1.00,Z=1.00)
}