//================================================================================
// R6ScopeGadget.
//================================================================================
class R6ScopeGadget extends R6AbstractGadget;
//	NoNativeReplication;

simulated function UpdateAttachment (R6EngineWeapon weapOwner)
{
	local Vector vTagLocation;
	local Rotator rTagRotator;

	Super.UpdateAttachment(weapOwner);
	SetBase(None);
	SetBase(weapOwner,weapOwner.Location);
	weapOwner.GetTagInformations("TagScope",vTagLocation,rTagRotator);
	SetRelativeLocation(vTagLocation);
	SetRelativeRotation(rTagRotator);
}

defaultproperties
{
    m_eGadgetType=1
    DrawType=8
    m_bDrawFromBase=True
}
/*
    StaticMesh=StaticMesh'R63rdWeapons_SM.Gadgets.R63rdDefaultScope'
*/

