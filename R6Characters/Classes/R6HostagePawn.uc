//================================================================================
// R6HostagePawn.
//================================================================================
class R6HostagePawn extends R6Hostage
	Abstract;

simulated event PostBeginPlay ()
{
//	LinkSkelAnim(MeshAnimation'HostageAnims');
	Super.PostBeginPlay();
}

defaultproperties
{
    m_FOVClass=Class'R6FieldOfView'
}
/*
    KParams=KarmaParamsSkel'KarmaParamsSkel196'
*/

