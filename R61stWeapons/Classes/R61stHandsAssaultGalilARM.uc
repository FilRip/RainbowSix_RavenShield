//================================================================================
// R61stHandsAssaultGalilARM.
//================================================================================
class R61stHandsAssaultGalilARM extends R61stHandsGripMP5;

function PostBeginPlay ()
{
//	LinkSkelAnim(MeshAnimation'R61stHandsAssaultGalilARMA');
	Super.PostBeginPlay();
}

simulated function SwitchFPAnim ()
{
	UnLinkSkelAnim();
//	LinkSkelAnim(MeshAnimation'R61stHandsAssaultGalilARMWithScopeA');
	PostBeginPlay();
}
