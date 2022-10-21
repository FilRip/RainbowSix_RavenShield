//================================================================================
// KTire.
//================================================================================
class KTire extends KActor
	Native
	Abstract;

var const bool bTireOnGround;
var bool bReceiveStateNew;
var float RollFriction;
var float LateralFriction;
var float RollSlip;
var float LateralSlip;
var float MinSlip;
var float SlipRate;
var float Softness;
var float Adhesion;
var float Restitution;
var const float GroundSlipVel;
var const float SpinSpeed;
var KCarWheelJoint WheelJoint;
var const Material GroundMaterial;
var const Vector GroundSlipVec;

function TakeDamage (int Damage, Pawn instigatedBy, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType)
{
}

defaultproperties
{
    RollFriction=0.30
    LateralFriction=0.30
    RollSlip=0.09
    LateralSlip=0.06
    MinSlip=0.00
    SlipRate=0.00
    Softness=0.00
    Restitution=0.10
    bNoDelete=False
    bDisturbFluidSurface=True
}