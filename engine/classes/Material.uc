//================================================================================
// Material.
//================================================================================
class Material extends Object
	Native
	CollapseCategories
	HideCategories(Object);

enum ESurfaceType {
	SURF_Generic,
	SURF_GenericHardSurface,
	SURF_DustyConcrete,
	SURF_CompactSnow,
	SURF_DeepSnow,
	SURF_Dirt,
	SURF_HardWood,
	SURF_BoomyWood,
	SURF_Carpet,
	SURF_Grate,
	SURF_HardMetal,
	SURF_SheetMetal,
	SURF_WaterPuddle,
	SURF_DeepWater,
	SURF_OilPuddle,
	SURF_DirtyGrass,
	SURF_CleanGrass,
	SURF_Gravel
};

var() Material FallbackMaterial;
var Material DefaultMaterial;
var const transient bool UseFallback;
var const transient bool Validated;
var(Rainbow) bool m_bForceNoSort;
var(Rainbow) bool m_bDynamicMaterial;
var(Rainbow) bool m_bProneTrail;
var int m_SpecificRenderData;
var(Rainbow) int m_iPenetration;
var(Rainbow) int m_iResistanceFactor;
var(Rainbow) Class<R6WallHit> m_pHitEffect;
var(Rainbow) Class<R6FootStep> m_pFootStep;
var(Rainbow) ESurfaceType m_eSurfIdForSnd;
var Material m_pUnused;
var(Rainbow) byte m_iNightVisionFactor;

function Trigger (Actor Other, Actor EventInstigator)
{
	if ( FallbackMaterial != None )
	{
		FallbackMaterial.Trigger(Other,EventInstigator);
	}
}

defaultproperties
{
    m_iNightVisionFactor=128
}
/*
    DefaultMaterial=Texture'DefaultTexture'
*/

