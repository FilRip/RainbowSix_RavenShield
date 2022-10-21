//================================================================================
// R6Decal.
//================================================================================
class R6Decal extends Projector
	Native;

var bool m_bActive;
var bool m_bNeedScale;

state ScaleProjector
{
	function BeginState ()
	{
		bStasis=False;
		bClipBSP=False;
		m_bClipStaticMesh=False;
	}
	
	function EndState ()
	{
		bStasis=True;
	}
	
	simulated function Tick (float DeltaTime)
	{
		local Vector NewScale3D;
		local Rotator NewRotation;
		local RandomTweenNum RandomValue;
	
		if ( (m_bNeedScale == False) || (DrawScale3D.X >= 1.00) && (DrawScale3D.Y >= 1.00) )
		{
			bClipBSP=True;
			m_bClipStaticMesh=True;
			DetachProjector(True);
			AttachProjector();
			GotoState('None');
		}
		else
		{
			DetachProjector(True);
			NewScale3D=DrawScale3D;
			RandomValue.m_fMin=8.00;
			RandomValue.m_fMax=16.00;
			NewScale3D.X += DeltaTime / (GetRandomTweenNum(RandomValue) + NewScale3D.X * 25.00);
			NewScale3D.Y += DeltaTime / (GetRandomTweenNum(RandomValue) + NewScale3D.Y * 25.00);
			SetDrawScale3D(NewScale3D);
			NewRotation=Rotation;
			NewRotation.Roll += DeltaTime * 65536.00 / 256.00;
			SetRotation(NewRotation);
			AttachProjector();
		}
	}
	
}

defaultproperties
{
    FOV=1
    MaxTraceDistance=5
    bProjectParticles=False
    bProjectActor=False
    bProjectOnParallelBSP=True
    RemoteRole=ROLE_None
    DrawType=0
    bStatic=False
    bStasis=True
    DrawScale=0.40
}