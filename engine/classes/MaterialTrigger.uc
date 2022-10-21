//================================================================================
// MaterialTrigger.
//================================================================================
class MaterialTrigger extends Triggers;

var() array<Material> MaterialsToTrigger;

function Trigger (Actor Other, Pawn EventInstigator)
{
	local int i;

	for (i=0;i < MaterialsToTrigger.Length;i++)
	{
		if ( MaterialsToTrigger[i] != None )
		{
			MaterialsToTrigger[i].Trigger(Other,EventInstigator);
		}
	}
}

defaultproperties
{
    bCollideActors=False
}
/*
    Texture=Texture'S_MaterialTrigger'
*/

