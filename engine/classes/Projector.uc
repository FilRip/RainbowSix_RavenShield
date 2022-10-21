//================================================================================
// Projector.
//================================================================================
class Projector extends Actor
	Native
//	NoNativeReplication
	Placeable;

enum EProjectorBlending {
	PB_None,
	PB_Modulate,
	PB_Modulate1X,
	PB_AlphaBlend,
	PB_Add,
	PB_Darken
};

var() EProjectorBlending MaterialBlendingOp;
var() EProjectorBlending FrameBufferBlendingOp;
var() int FOV;
var() int MaxTraceDistance;
var() bool bProjectBSP;
var() bool bProjectTerrain;
var() bool bProjectStaticMesh;
var() bool bProjectParticles;
var() bool bProjectActor;
var() bool bLevelStatic;
var() bool bClipBSP;
var() bool m_bClipStaticMesh;
var() bool m_bRelative;
var bool m_bDirectionalModulation;
var bool m_bProjectTransparent;
var bool m_bProjectOnlyOnFloor;
var() bool bProjectOnUnlit;
var() bool bGradient;
var() bool bProjectOnAlpha;
var() bool bProjectOnParallelBSP;
var bool bLightInfluenced;
var() Material ProjTexture;
var() Texture GradientTexture;
var() name ProjectTag;
var const transient Plane FrustumPlanes[6];
var const transient Vector FrustumVertices[8];
var const transient Box Box;
var const transient ProjectorRenderInfoPtr RenderInfo;
var transient Matrix GradientMatrix;
var transient Matrix Matrix;
var transient Vector OldLocation;

native function AttachProjector ();

native function DetachProjector (optional bool Force);

native function AbandonProjector (optional float Lifetime);

native function AttachActor (Actor A);

native function DetachActor (Actor A);

event PostBeginPlay ()
{
	AttachProjector();
	if ( bLevelStatic )
	{
		AbandonProjector();
		Destroy();
	}
	if ( bProjectActor )
	{
		SetCollision(True,False,False);
	}
}

simulated event Touch (Actor Other)
{
	if ( Other.bAcceptsProjectors && ((ProjectTag == 'None') || (Other.Tag == ProjectTag)) && (bProjectStaticMesh || (Other.StaticMesh == None)) )
	{
		AttachActor(Other);
	}
}

event UnTouch (Actor Other)
{
	DetachActor(Other);
}

event LightUpdateDirect (Vector LightDir, float LightDist, byte bOpacity)
{
}

event UpdateShadow ()
{
}

defaultproperties
{
    FrameBufferBlendingOp=1
    MaxTraceDistance=1000
    bProjectBSP=True
    bProjectTerrain=True
    bProjectStaticMesh=True
    bProjectParticles=True
    bProjectActor=True
    m_bProjectTransparent=True
    bStatic=True
    bHidden=True
    bDirectional=True
    Texture=Texture'Proj_Icon'
}
/*
    GradientTexture=Texture'GRADIENT_Fade'
*/

