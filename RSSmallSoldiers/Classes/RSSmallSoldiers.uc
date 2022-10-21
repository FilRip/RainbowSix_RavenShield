Class RSSmallSoldiers extends Mutator;

function bool CheckReplacement (Actor Other,out byte bSuperRelevant)
{
	if (Other.IsA('R6Pawn'))
	{
		R6Pawn(Other).DrawScale=0.3;
		R6Pawn(Other).SetCollisionSize(Other.CollisionRadius,25);
	}
	if (Other.IsA('R6AbstractGadget'))
	{
		R6AbstractGadget(Other).DrawScale=0.3;
	}
	if (Other.IsA('R6AbstractHelmet'))
	{
		R6AbstractHelmet(Other).DrawScale=0.3;
	}
	return True;
}

defaultproperties
{
}
