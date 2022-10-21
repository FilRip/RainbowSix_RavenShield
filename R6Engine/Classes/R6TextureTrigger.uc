//================================================================================
// R6TextureTrigger.
//================================================================================
class R6TextureTrigger extends Trigger;

var(R6Trigger) Actor ActorToChange;
var(R6Trigger) array<Material> Skins;

function Touch (Actor Other)
{
	local int iSkinCount;

	Super.Touch(Other);
	if ( ActorToChange != None )
	{
		for (iSkinCount=0;iSkinCount < Skins.Length;iSkinCount++)
		{
			ActorToChange.Skins[iSkinCount]=Skins[iSkinCount];
		}
	}
}