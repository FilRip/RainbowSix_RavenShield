//================================================================================
// TexScaler.
//================================================================================
class TexScaler extends TexModifier
	Native
	EditInLineNew;

var() float UScale;
var() float VScale;
var() float UOffset;
var() float VOffset;
var Matrix M;

defaultproperties
{
    UScale=1.00
    VScale=1.00
}