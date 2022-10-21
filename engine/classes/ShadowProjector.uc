//================================================================================
// ShadowProjector.
//================================================================================
class ShadowProjector extends Projector;

var byte m_bOpacity;
var() bool bUseLightAverage;
var bool m_bAttached;
var() float LightDistance;
var() Actor ShadowActor;
var ShadowBitmapMaterial ShadowTexture;
var() Vector LightDirection;

simulated event PostBeginPlay ()
{
	if ( bProjectActor )
	{
		SetCollision(True,False,False);
	}
//	ShadowTexture=new Class'ShadowBitmapMaterial';
	ProjTexture=ShadowTexture;
}

event UpdateShadow ()
{
	local Vector ShadowLocation;
	local Plane BoundingSphere;

	if ( bProjectActor )
	{
		SetCollision(False,False,False);
	}
	if ( (ShadowActor != None) &&  !ShadowActor.bHidden && (m_bOpacity > 0) )
	{
		BoundingSphere=ShadowActor.GetRenderBoundingSphere();
		BoundingSphere.W *= 4.00;
		FOV=Atan(BoundingSphere.W * 2 / LightDistance) * 180 / 3.14 + 5;
		if ( (ShadowActor.DrawType == 2) && (ShadowActor.Mesh != None) )
		{
			ShadowLocation=ShadowActor.GetBoneCoords('R6 Pelvis',True).Origin;
		}
		else
		{
			ShadowLocation=ShadowActor.Location;
		}
		ShadowTexture.m_LightLocation=ShadowLocation;
		SetLocation(ShadowLocation);
		SetRotation(rotator( -LightDirection));
		SetDrawScale(LightDistance * Tan(0.50 * FOV * 3.14 / 180) / 0.50 * ShadowTexture.USize);
		ShadowTexture.ShadowActor=ShadowActor;
		ShadowTexture.LightDirection=LightDirection;
		ShadowTexture.LightDistance=LightDistance;
		ShadowTexture.LightFOV=FOV;
		ShadowTexture.Dirty=True;
		ShadowTexture.m_bOpacity=m_bOpacity;
		AttachProjector();
		m_bAttached=True;
		if ( bProjectActor )
		{
			SetCollision(True,False,False);
		}
	}
}

simulated function Tick (float DeltaTime)
{
	if ( m_bAttached )
	{
		m_bAttached=False;
		DetachProjector(True);
	}
}

event Touch (Actor Other)
{
	if ( (Other != ShadowActor) && Other.bAcceptsProjectors && bProjectActor )
	{
		AttachActor(Other);
	}
}

simulated function LightUpdateDirect (Vector LightDir, float LightDist, byte bOpacity)
{
	LightDistance=LightDist;
	LightDirection=LightDir;
	m_bOpacity=bOpacity;
}

simulated event Destroyed ()
{
	if ( ShadowTexture != None )
	{
		ShadowTexture.ShadowActor=None;
	}
}

defaultproperties
{
    m_bOpacity=128
    bUseLightAverage=True
    FrameBufferBlendingOp=2
    MaxTraceDistance=250
    bProjectParticles=False
    bProjectActor=False
    m_bDirectionalModulation=True
    m_bProjectTransparent=False
    bGradient=True
    bProjectOnParallelBSP=True
    bLightInfluenced=True
    RemoteRole=ROLE_None
    bStatic=False
}