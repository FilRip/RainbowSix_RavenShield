//================================================================================
// MaterialSwitch.
//================================================================================
class MaterialSwitch extends Modifier
	Native
	HideCategories(Modifier);

var() int Current;
var() editinlineuse array<Material> Materials;

function Trigger (Actor Other, Actor EventInstigator)
{
	Current++;
	if ( Current >= Materials.Length )
	{
		Current=0;
	}
	Material=Materials[Current];
	if ( Material != None )
	{
		Material.Trigger(Other,EventInstigator);
	}
	if ( FallbackMaterial != None )
	{
		FallbackMaterial.Trigger(Other,EventInstigator);
	}
}
