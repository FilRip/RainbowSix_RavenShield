//================================================================================
// MotionBlur.
//================================================================================
class MotionBlur extends CameraEffect
	Native
	EditInLineNew
	CollapseCategories;

var() byte BlurAlpha;
var const int RenderTargets[2];
var const float LastFrameTime;

defaultproperties
{
    BlurAlpha=128
}