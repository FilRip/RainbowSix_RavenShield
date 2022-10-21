//================================================================================
// FractalTextureFactory.
//================================================================================
class FractalTextureFactory extends MaterialFactory;

enum EResolution {
	Pixels_1,
	Pixels_2,
	Pixels_4,
	Pixels_8,
	Pixels_16,
	Pixels_32,
	Pixels_64,
	Pixels_128,
	Pixels_256
};

var() EResolution Width;
var() EResolution Height;

defaultproperties
{
    Width=8
    Height=8
    Description="Real-time Procedural Texture"
}