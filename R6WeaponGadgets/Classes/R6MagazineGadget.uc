//================================================================================
// R6MagazineGadget.
//================================================================================
class R6MagazineGadget extends R6AbstractGadget;
//	NoNativeReplication;

simulated function UpdateAttachment (R6EngineWeapon weapOwner)
{
	local Vector vTagLocation;
	local Rotator rTagRotator;

	Super.UpdateAttachment(weapOwner);
	SetBase(None);
	SetBase(weapOwner,weapOwner.Location);
	weapOwner.GetTagInformations("TagMagazine",vTagLocation,rTagRotator);
	SetRelativeLocation(vTagLocation);
	SetRelativeRotation(rTagRotator);
}

defaultproperties
{
    m_eGadgetType=2
    m_NameID="CMag"
    m_bDrawFromBase=True
}
