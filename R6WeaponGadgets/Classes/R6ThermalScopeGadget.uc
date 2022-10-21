//================================================================================
// R6ThermalScopeGadget.
//================================================================================
class R6ThermalScopeGadget extends R6AbstractGadget;
//	NoNativeReplication;

var Actor m_FPThermalScopeModel;

simulated event Destroyed ()
{
	Super.Destroyed();
	DestroyFPGadget();
}

function ActivateGadget (bool bActivate, optional bool bControllerInBehindView)
{
	R6Pawn(m_OwnerCharacter).ToggleHeatVision();
}

simulated function UpdateAttachment (R6EngineWeapon weapOwner)
{
	local Vector vTagLocation;
	local Rotator rTagRotator;

	Super.UpdateAttachment(weapOwner);
	m_GadgetShortName=Localize(m_NameID,"ID_SHORTNAME","R6WeaponGadgets");
	SetBase(weapOwner,weapOwner.Location);
	weapOwner.GetTagInformations("TagScope",vTagLocation,rTagRotator);
	SetRelativeLocation(vTagLocation);
	SetRelativeRotation(rTagRotator);
}

simulated function AttachFPGadget ()
{
	if ( (m_WeaponOwner == None) || (R6AbstractWeapon(m_WeaponOwner).m_FPWeapon == None) )
	{
		return;
	}
	if ( m_FPThermalScopeModel == None )
	{
		m_FPThermalScopeModel=Spawn(Class'R61stThermalScope');
	}
	if ( m_FPThermalScopeModel != None )
	{
		R6AbstractWeapon(m_WeaponOwner).m_FPWeapon.AttachToBone(m_FPThermalScopeModel,'TagThermal');
	}
}

simulated function DestroyFPGadget ()
{
	local Actor aFPGadget;

	aFPGadget=m_FPThermalScopeModel;
	m_FPThermalScopeModel=None;
	if ( aFPGadget != None )
	{
		aFPGadget.Destroy();
	}
}

defaultproperties
{
    m_NameID="ThermalScope"
    DrawType=8
    m_bDrawFromBase=True
}
/*
    StaticMesh=StaticMesh'R63rdWeapons_SM.Gadgets.R63rdThermalScope'
*/

