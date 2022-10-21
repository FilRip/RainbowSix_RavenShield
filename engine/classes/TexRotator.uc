//================================================================================
// TexRotator.
//================================================================================
class TexRotator extends TexModifier
	Native
	EditInLineNew;

enum ETexRotationType {
	TR_FixedRotation,
	TR_ConstantlyRotating,
	TR_OscillatingRotation
};

var() ETexRotationType TexRotationType;
var deprecated bool ConstantRotation;
var() float UOffset;
var() float VOffset;
var Matrix M;
var() Rotator Rotation;
var() Rotator OscillationRate;
var() Rotator OscillationAmplitude;
var() Rotator OscillationPhase;
