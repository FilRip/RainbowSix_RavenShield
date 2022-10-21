//================================================================================
// KConstraint.
//================================================================================
class KConstraint extends KActor
	Native
	Abstract;

var(KarmaConstraint) const bool bKDisableCollision;
var const bool bKForceFrameUpdate;
var(KarmaConstraint) float KForceThreshold;
var(KarmaConstraint) Actor KConstraintActor1;
var(KarmaConstraint) Actor KConstraintActor2;
var(KarmaConstraint) name KConstraintBone1;
var(KarmaConstraint) name KConstraintBone2;
var Vector KPos1;
var Vector KPriAxis1;
var Vector KSecAxis1;
var Vector KPos2;
var Vector KPriAxis2;
var Vector KSecAxis2;
var const transient int KConstraintData;

native function KUpdateConstraintParams ();

native final function KGetConstraintForce (out Vector Force);

native final function KGetConstraintTorque (out Vector Torque);

event KForceExceed (float forceMag);

defaultproperties
{
    bKDisableCollision=True
    KPriAxis1=(X=1.00,Y=0.00,Z=0.00)
    KSecAxis1=(X=0.00,Y=1.00,Z=0.00)
    KPriAxis2=(X=1.00,Y=0.00,Z=0.00)
    KSecAxis2=(X=0.00,Y=1.00,Z=0.00)
    DrawType=1
    bHidden=True
    bCollideActors=False
    bBlockActors=False
    bBlockPlayers=False
    bProjTarget=False
    bBlockKarma=False
}
/*
    Texture=Texture'S_KConstraint'
*/

