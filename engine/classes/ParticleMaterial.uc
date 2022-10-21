//================================================================================
// ParticleMaterial.
//================================================================================
class ParticleMaterial extends RenderedMaterial
	Native;
//	Export;

struct ParticleProjectorInfo
{
	var BitmapMaterial BitmapMaterial;
	var Matrix Matrix;
	var int Projected;
	var int BlendMode;
};

var const int ParticleBlending;
var const int BlendBetweenSubdivisions;
var const int RenderTwoSided;
var const int UseTFactor;
var const int AlphaTest;
var const int AlphaRef;
var const int ZTest;
var const int ZWrite;
var const int Wireframe;
var const BitmapMaterial BitmapMaterial;
var const transient int NumProjectors;
var transient bool AcceptsProjectors;
var const transient ParticleProjectorInfo Projectors[8];
