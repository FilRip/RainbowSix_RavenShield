//================================================================================
// FadeColor.
//================================================================================
class FadeColor extends ConstantMaterial
	Native;

enum EColorFadeType {
	FC_Linear,
	FC_Sinusoidal
};

var() EColorFadeType ColorFadeType;
var() float FadePeriod;
var() float FadePhase;
var() Color Color1;
var() Color Color2;
