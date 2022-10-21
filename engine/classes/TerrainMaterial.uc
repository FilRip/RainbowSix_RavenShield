//================================================================================
// TerrainMaterial.
//================================================================================
class TerrainMaterial extends RenderedMaterial
	Native;
//	Export;

struct TerrainMaterialLayer
{
	var Material Texture;
	var BitmapMaterial AlphaWeight;
	var Matrix TextureMatrix;
};

var const byte RenderMethod;
var const bool FirstPass;
var const array<TerrainMaterialLayer> Layers;
