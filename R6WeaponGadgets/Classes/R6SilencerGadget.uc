//================================================================================
// R6SilencerGadget.
//================================================================================
class R6SilencerGadget extends R6AbstractGadget;
//	NoNativeReplication;

var Actor m_FPSilencerModel;
var Class<Actor> m_pFPSilencerClass;

simulated event Destroyed ()
{
	Super.Destroyed();
	DestroyFPGadget();
}

simulated function Vector GetGadgetMuzzleOffset ()
{
	local Vector vTagLocation;
	local Rotator rTagRotator;

	GetTagInformations("TAGSilencer",vTagLocation,rTagRotator,1.00);
	return vTagLocation;
}

simulated function UpdateAttachment (R6EngineWeapon weapOwner)
{
	local Vector vTagLocation;
	local Rotator rTagRotator;

	Super.UpdateAttachment(weapOwner);
	m_GadgetShortName=Localize(m_NameID,"ID_SHORTNAME","R6WeaponGadgets");
	SetBase(None);
	SetBase(weapOwner,weapOwner.Location);
	weapOwner.GetTagInformations("TagMuzzle",vTagLocation,rTagRotator);
	SetRelativeLocation(vTagLocation);
	SetRelativeRotation(rTagRotator);
}

simulated function AttachFPGadget ()
{
	local Vector vTagLocation;
	local Rotator rTagRotator;

	if ( (m_WeaponOwner == None) || (R6AbstractWeapon(m_WeaponOwner).m_FPWeapon == None) )
	{
		return;
	}
	if ( m_FPSilencerModel == None )
	{
		m_FPSilencerModel=Spawn(m_pFPSilencerClass);
	}
	if ( m_FPSilencerModel != None )
	{
		R6AbstractWeapon(m_WeaponOwner).m_FPWeapon.AttachToBone(m_FPSilencerModel,'TagMuzzle');
		m_FPSilencerModel.GetTagInformations("TagMuzzle",vTagLocation,rTagRotator);
		m_WeaponOwner.m_FPFlashLocation=vTagLocation;
	}
}

simulated function DestroyFPGadget ()
{
	local Actor aFPGadget;

	aFPGadget=m_FPSilencerModel;
	m_FPSilencerModel=None;
	if ( aFPGadget != None )
	{
		aFPGadget.Destroy();
	}
}

defaultproperties
{
    m_eGadgetType=5
    m_NameID="Silencer"
    m_bDrawFromBase=True
}
