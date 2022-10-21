//================================================================================
// TexOscillator.
//================================================================================
class TexOscillator extends TexModifier
	Native
	EditInLineNew;

enum ETexOscillationType {
	OT_Pan,
	OT_Stretch,
	OT_StretchRepeat
};

var() ETexOscillationType UOscillationType;
var() ETexOscillationType VOscillationType;
var() float UOscillationRate;
var() float VOscillationRate;
var() float UOscillationPhase;
var() float VOscillationPhase;
var() float UOscillationAmplitude;
var() float VOscillationAmplitude;
var() float UOffset;
var() float VOffset;
var Matrix M;

defaultproperties
{
    UOscillationRate=1.00
    VOscillationRate=1.00
    UOscillationAmplitude=0.10
    VOscillationAmplitude=0.10
}