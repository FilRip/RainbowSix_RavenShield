//================================================================================
// KarmaParamsSkel.
//================================================================================
class KarmaParamsSkel extends KarmaParams
	Native;

var() bool bKDoConvulsions;
var() Range KConvulseSpacing;
var() string KSkeleton;
var transient bool bKImportantRagdoll;
var transient float KShotStrength;
var transient Vector KShotStart;
var transient Vector KShotEnd;

defaultproperties
{
    KConvulseSpacing=(Min=0.00,Max=0.00)
}