//================================================================================
// ShadowBitmapMaterial.
//================================================================================
class ShadowBitmapMaterial extends BitmapMaterial
	Native;
//	Export;

var byte m_bOpacity;
var bool Dirty;
var bool m_bValid;
var float LightDistance;
var float LightFOV;
var Actor ShadowActor;
var Vector LightDirection;
var Vector m_LightLocation;
var const transient int TextureInterfaces[2];

defaultproperties
{
    m_bOpacity=128
    Dirty=True
    Format=5
    UClampMode=1
    VClampMode=1
    UBits=7
    VBits=7
    USize=128
    VSize=128
    UClamp=128
    VClamp=128
}