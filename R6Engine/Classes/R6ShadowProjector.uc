//================================================================================
// R6ShadowProjector.
//================================================================================
class R6ShadowProjector extends Projector;

var bool m_bAttached;

function PostBeginPlay ()
{
	local Rotator Dir;

	Dir.Pitch=-16384;
	Dir.Yaw=0;
	Dir.Roll=0;
	SetRotation(Dir);
}

event UpdateShadow ()
{
	SetLocation(R6Pawn(Owner).GetBoneCoords('R6 Spine',True).Origin);
	AttachProjector();
	m_bAttached=True;
}

simulated function Tick (float DeltaTime)
{
	if ( m_bAttached )
	{
		m_bAttached=False;
		DetachProjector(True);
	}
}

defaultproperties
{
    FrameBufferBlendingOp=2
    MaxTraceDistance=200
    bProjectParticles=False
    bProjectActor=False
    m_bDirectionalModulation=True
    m_bProjectTransparent=False
    bGradient=True
    bProjectOnParallelBSP=True
    RemoteRole=ROLE_None
    bStatic=False
    DrawScale=1.50
}
/*
    ProjTexture=Texture'Inventory_t.Shadow.ShadowTexSimple'
*/

