//================================================================================
// R6BipodGadget.
//================================================================================
class R6BipodGadget extends R6AbstractGadget;
//	NoNativeReplication;

var(R6Meshes) StaticMesh CloseSM;
var(R6Meshes) StaticMesh OpenSM;

simulated function Toggle3rdBipod (bool bBipodOpen)
{
	if ( bBipodOpen == False )
	{
		SetStaticMesh(CloseSM);
	}
	else
	{
		SetStaticMesh(OpenSM);
	}
}

simulated function UpdateAttachment (R6EngineWeapon weapOwner)
{
	local Vector vTagLocation;
	local Rotator rTagRotator;

	Super.UpdateAttachment(weapOwner);
	SetBase(None);
	SetBase(weapOwner,weapOwner.Location);
	weapOwner.GetTagInformations("TagBipod",vTagLocation,rTagRotator);
	SetRelativeLocation(vTagLocation);
	SetRelativeRotation(rTagRotator);
}

defaultproperties
{
    m_eGadgetType=3
    DrawType=8
    m_bDrawFromBase=True
}
