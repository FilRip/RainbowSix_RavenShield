//================================================================================
// StaticMeshActor.
//================================================================================
class StaticMeshActor extends Actor
	Native
//	NoNativeReplication
	Placeable;

var(Display) int SkinsIndex;
var(Modifier) bool m_bWave;
var() bool m_bBlockCoronas;
var(Tessellation) bool m_bUseTesselletation;
var(Modifier) float m_fScale;
var(Modifier) float m_fFrequency;
var(Modifier) float m_fNormalScale;
var(Modifier) float m_fMinZero;
var(Tessellation) float m_fTesseletationLevel;
var(Modifier) Vector m_vScalePerAxis;

defaultproperties
{
    SkinsIndex=255
    m_bBlockCoronas=True
    m_fScale=1.00
    m_fFrequency=1.00
    m_fNormalScale=0.10
    m_fTesseletationLevel=4.00
    m_vScalePerAxis=(X=1.00,Y=1.00,Z=1.00)
    DrawType=8
    bStatic=True
    bWorldGeometry=True
    bAcceptsProjectors=True
    bShadowCast=True
    bStaticLighting=True
    bCollideActors=True
    bBlockActors=True
    bBlockPlayers=True
    bEdShouldSnap=True
    CollisionRadius=1.00
    CollisionHeight=1.00
}