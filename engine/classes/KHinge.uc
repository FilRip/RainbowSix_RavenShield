//================================================================================
// KHinge.
//================================================================================
class KHinge extends KConstraint
	Native;

enum EHingeType {
	HT_Normal,
	HT_Springy,
	HT_Motor,
	HT_Controlled
};

var(KarmaConstraint) EHingeType KHingeType;
var bool KUseAltDesired;
var(KarmaConstraint) float KStiffness;
var(KarmaConstraint) float KDamping;
var(KarmaConstraint) float KDesiredAngVel;
var(KarmaConstraint) float KMaxTorque;
var(KarmaConstraint) float KDesiredAngle;
var(KarmaConstraint) float KProportionalGap;
var(KarmaConstraint) float KAltDesiredAngle;
var const float KCurrentAngle;

auto state Default
{
}

state() ToggleMotor
{
	function Trigger (Actor Other, Pawn EventInstigator)
	{
		if ( KHingeType == HT_Motor )
		{
			KDesiredAngle=KCurrentAngle;
			KUseAltDesired=False;
			KHingeType=HT_Controlled;
		}
		else
		{
			KHingeType=HT_Motor;
		}
		KUpdateConstraintParams();
		KConstraintActor1.KWake();
	}

Begin:
	KHingeType=HT_Controlled;
	KUseAltDesired=False;
	KUpdateConstraintParams();
}

state() ControlMotor
{
	function Trigger (Actor Other, Pawn EventInstigator)
	{
		if ( KHingeType != HT_Motor )
		{
			KHingeType=HT_Motor;
			KUpdateConstraintParams();
			KConstraintActor1.KWake();
		}
	}

	function UnTrigger (Actor Other, Pawn EventInstigator)
	{
		if ( KHingeType == HT_Motor )
		{
			KDesiredAngle=KCurrentAngle;
			KUseAltDesired=False;
			KHingeType=HT_Controlled;
			KUpdateConstraintParams();
			KConstraintActor1.KWake();
		}
	}

Begin:
	KHingeType=HT_Controlled;
	KUseAltDesired=False;
	KUpdateConstraintParams();
}

state() ToggleDesired
{
	function Trigger (Actor Other, Pawn EventInstigator)
	{
		if ( KUseAltDesired )
		{
			KUseAltDesired=False;
		}
		else
		{
			KUseAltDesired=True;
		}
		KUpdateConstraintParams();
		KConstraintActor1.KWake();
	}

}

state() ControlDesired
{
	function Trigger (Actor Other, Pawn EventInstigator)
	{
		KUseAltDesired=True;
		KUpdateConstraintParams();
		KConstraintActor1.KWake();
	}

	function UnTrigger (Actor Other, Pawn EventInstigator)
	{
		KUseAltDesired=False;
		KUpdateConstraintParams();
		KConstraintActor1.KWake();
	}

}

defaultproperties
{
    KStiffness=50.00
    KProportionalGap=8200.00
    bDirectional=True
}
/*
    Texture=Texture'S_KHinge'
*/

