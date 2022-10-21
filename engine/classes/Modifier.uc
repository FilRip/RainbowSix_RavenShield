//================================================================================
// Modifier.
//================================================================================
class Modifier extends Material
	Native
	Abstract
//	Export
	EditInLineNew
	HideCategories(Material);

var() editinlineuse Material Material;

function Trigger (Actor Other, Actor EventInstigator)
{
	if ( Material != None )
	{
		Material.Trigger(Other,EventInstigator);
	}
	if ( FallbackMaterial != None )
	{
		FallbackMaterial.Trigger(Other,EventInstigator);
	}
}
