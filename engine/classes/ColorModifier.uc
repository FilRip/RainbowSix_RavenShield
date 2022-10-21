//================================================================================
// ColorModifier.
//================================================================================
class ColorModifier extends Modifier
	Native
	NotEditInLineNew;

var() bool RenderTwoSided;
var() bool AlphaBlend;
var() Color Color;

defaultproperties
{
    RenderTwoSided=True
    AlphaBlend=True
    Color=(R=255,G=255,B=255,A=255)
}