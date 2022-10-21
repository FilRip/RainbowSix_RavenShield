//================================================================================
// WetTexture.
//================================================================================
class WetTexture extends WaterTexture
	Native;

var(WaterPaint) Texture SourceTexture;
var transient Texture OldSourceTex;
var transient int LocalSourceBitmap;
