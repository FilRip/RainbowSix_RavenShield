//================================================================================
// KarmaParams.
//================================================================================
class KarmaParams extends KarmaParamsCollision
	Native;

var() bool KStartEnabled;
var() bool bKNonSphericalInertia;
var() bool bHighDetailOnly;
var bool bClientOnly;
var() const bool bKDoubleTickRate;
var() bool bKStayUpright;
var() bool bKAllowRotate;
var bool bDestroyOnSimError;
var() float KMass;
var() float KLinearDamping;
var() float KAngularDamping;
var() float KBuoyancy;
var() float KActorGravScale;
var() float KVelDropBelowThreshold;
var() Vector KStartLinVel;
var() Vector KStartAngVel;
var const transient int KAng3;
var const transient int KTriList;
var const transient float KLastVel;

defaultproperties
{
    bHighDetailOnly=True
    bClientOnly=True
    bDestroyOnSimError=True
    KMass=1.00
    KLinearDamping=0.20
    KAngularDamping=0.20
    KActorGravScale=1.00
    KVelDropBelowThreshold=1000000.00
}