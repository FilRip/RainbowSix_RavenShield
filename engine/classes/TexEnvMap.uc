//================================================================================
// TexEnvMap.
//================================================================================
class TexEnvMap extends TexModifier
	Native
	EditInLineNew;

enum ETexEnvMapType {
	EM_WorldSpace,
	EM_CameraSpace
};

var() ETexEnvMapType EnvMapType;

defaultproperties
{
    EnvMapType=1
    TexCoordCount=1
}