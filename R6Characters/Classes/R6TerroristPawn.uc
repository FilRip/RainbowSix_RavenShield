//================================================================================
// R6TerroristPawn.
//================================================================================
class R6TerroristPawn extends R6Terrorist
	Abstract;

function PostBeginPlay ()
{
	Super.PostBeginPlay();
//	LinkSkelAnim(MeshAnimation'TerroristAnims');
}

defaultproperties
{
    m_FOVClass=Class'R6FieldOfView'
}
/*
    KParams=KarmaParamsSkel'KarmaParamsSkel248'
*/

