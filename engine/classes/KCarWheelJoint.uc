//================================================================================
// KCarWheelJoint.
//================================================================================
class KCarWheelJoint extends KConstraint
	Native;

var(KarmaConstraint) bool bKSteeringLocked;
var(KarmaConstraint) float KSteerAngle;
var(KarmaConstraint) float KProportionalGap;
var(KarmaConstraint) float KMaxSteerTorque;
var(KarmaConstraint) float KMaxSteerSpeed;
var(KarmaConstraint) float KMotorTorque;
var(KarmaConstraint) float KMaxSpeed;
var(KarmaConstraint) float KBraking;
var(KarmaConstraint) float KSuspLowLimit;
var(KarmaConstraint) float KSuspHighLimit;
var(KarmaConstraint) float KSuspStiffness;
var(KarmaConstraint) float KSuspDamping;
var(KarmaConstraint) float KSuspRef;
var const float KWheelHeight;

defaultproperties
{
    bKSteeringLocked=True
    KProportionalGap=8200.00
    KMaxSteerTorque=1000.00
    KMaxSteerSpeed=2600.00
    KMaxSpeed=1310700.00
    KSuspLowLimit=-1.00
    KSuspHighLimit=1.00
    KSuspStiffness=50.00
    KSuspDamping=5.00
}