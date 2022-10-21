//================================================================================
// RawMaterialFactory.
//================================================================================
class RawMaterialFactory extends MaterialFactory;

var() Class<Material> MaterialClass;

function Material CreateMaterial (Object InOuter, string InPackage, string InGroup, string InName)
{
	if ( MaterialClass == None )
	{
		return None;
	}
//	return new (InOuter,InName,4 + 524288,MaterialClass);
	return New(InOuter, InName, RF_Public+RF_Standalone) MaterialClass;
}

defaultproperties
{
    MaterialClass=Class'Engine.Shader'
    Description="Raw Material"
}