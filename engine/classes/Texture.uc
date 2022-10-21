//================================================================================
// Texture.
//================================================================================
class Texture extends BitmapMaterial
	Native;
//	DontCollapseCategories
//	SafeReplace;

enum ELODSet {
	LODSET_None,
	LODSET_World,
	LODSET_Skin,
	LODSET_Lightmap
};

enum EEnvMapTransformType {
	EMTT_ViewSpace,
	EMTT_WorldSpace,
	EMTT_LightSpace
};

var() Palette Palette;
var Color MipZero;
var Color MaxColor;
var int InternalTime[2];
var deprecated Texture DetailTexture;
var deprecated Texture EnvironmentMap;
var deprecated EEnvMapTransformType EnvMapTransformType;
var deprecated float Specular;
var(Surface) editconst bool bMasked;
var(Surface) bool bAlphaTexture;
var(Quality) private bool bHighColorQuality;
var(Quality) private bool bHighTextureQuality;
var private bool bRealtime;
var private bool bParametric;
var transient private bool bRealtimeChanged;
var editconst private bool bHasComp;
var int m_dwSize;
var int m_dwGetSizeLastFrame;
var(Quality) ELODSet LODSet;
var(Animation) Texture AnimNext;
var transient Texture AnimCurrent;
var(Animation) byte PrimeCount;
var transient byte PrimeCurrent;
var(Animation) float MinFrameRate;
var(Animation) float MaxFrameRate;
var transient float Accumulator;
var native array<int> Mips;
var editconst ETextureFormat CompFormat;
var transient int RenderInterface;
var transient int __LastUpdateTime[2];

defaultproperties
{
    MipZero=(R=64,G=128,B=64,A=0)
    MaxColor=(R=255,G=255,B=255,A=255)
    LODSet=1
}