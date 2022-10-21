Class BeAKrall extends Mutator;

#exec OBJ LOAD FILE=..\Animations\TESTKrall.ukx
#exec OBJ LOAD FILE=..\Textures\TESTKrallT.utx

function bool CheckReplacement (Actor Other,out byte bSuperRelevant)
{
	if (Other.IsA('R6Pawn'))
	{
		R6Pawn(Other).Mesh=SkeletalMesh'TESTKrall.Krall';
		R6Pawn(Other).Skins[0]=Texture'TESTKrallT.jkrall';
	}
	if (Other.IsA('R6PlayerController'))
	{
		R6PlayerController(Other).ClientReplicateSkins(Texture'TESTKrallT.jkrall');
	}
	return true;
}

defaultproperties
{
}
