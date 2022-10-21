//================================================================================
// R6RHeavyHelmet.
//================================================================================
class R6RHeavyHelmet extends R6RHelmet;

function SetHelmetStaticMesh (bool bOpen)
{
	if ( bOpen )
	{
//		SetStaticMesh(StaticMesh'R6RHeavyHatOpen');
	}
	else
	{
//		SetStaticMesh(StaticMesh'R6RHeavyHat');
	}
}

defaultproperties
{
    DrawScale=1.10
}
/*
    StaticMesh=StaticMesh'R6RHeavyHat'
    Skins=[0]=Texture'R6Characters_T.Rainbow.R6RHeavyHelm'
[1]=FinalBlend'R6Characters_T.Rainbow.R6RVisor'
*/

