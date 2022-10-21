//================================================================================
// BitmapMaterial.
//================================================================================
class BitmapMaterial extends RenderedMaterial
	Native
	Abstract;

enum ETexClampMode {
	TC_Wrap,
	TC_Clamp
};

enum ETextureFormat {
	TEXF_P8,
	TEXF_RGBA7,
	TEXF_RGB16,
	TEXF_DXT1,
	TEXF_RGB8,
	TEXF_RGBA8,
	TEXF_NODATA,
	TEXF_DXT3,
	TEXF_DXT5,
	TEXF_L8,
	TEXF_G16,
	TEXF_RRRGGGBBB
};

var(TextureFormat) const editconst ETextureFormat Format;
var(Texture) ETexClampMode UClampMode;
var(Texture) ETexClampMode VClampMode;
var const byte UBits;
var const byte VBits;
var const int USize;
var const int VSize;
var(Texture) const int UClamp;
var(Texture) const int VClamp;
