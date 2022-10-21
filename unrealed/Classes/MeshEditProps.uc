//================================================================================
// MeshEditProps.
//================================================================================
class MeshEditProps extends Object
	Native
//	Export
	HideCategories(Object);

struct LODLevel
{
	var() float DistanceFactor;
	var() float ReductionFactor;
	var() float Hysteresis;
	var() int MaxInfluences;
	var() bool SwitchRedigest;
};

var const int WBrowserAnimationPtr;
var(Redigest) int LODStyle;
var(Mesh) float VisSphereRadius;
var(LOD) float LOD_Strength;
var(Animation) MeshAnimation DefaultAnimation;
var(Skin) array<Material> Material;
var(LOD) array<LODLevel> LODLevels;
var(Mesh) Vector Scale;
var(Mesh) Vector Translation;
var(Mesh) Rotator Rotation;
var(Mesh) Vector MinVisBound;
var(Mesh) Vector MaxVisBound;
var(Mesh) Vector VisSphereCenter;

defaultproperties
{
    Scale=(X=1.00,Y=1.00,Z=1.00)
}
