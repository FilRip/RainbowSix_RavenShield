//================================================================================
// TexPanner.
//================================================================================
class TexPanner extends TexModifier
	Native
	EditInLineNew;

var() float PanRate;
var() Rotator PanDirection;
var Matrix M;

defaultproperties
{
    PanRate=0.10
}