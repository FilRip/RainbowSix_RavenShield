//================================================================================
// SubActionCameraEffect.
//================================================================================
class SubActionCameraEffect extends MatSubAction
	Native
//	NoExport
	CollapseCategories;

var() editinlineuse CameraEffect CameraEffect;
var() float StartAlpha;
var() float EndAlpha;
var() bool DisableAfterDuration;

defaultproperties
{
    EndAlpha=1.00
    Desc="Camera effect"
}
/*
    Icon=Texture'SubActionFade'
*/

