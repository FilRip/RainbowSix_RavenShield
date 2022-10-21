//================================================================================
// R6AbstractGadget.
//================================================================================
class R6AbstractGadget extends Actor
	Native
	Abstract;

enum eGadgetType {
	GAD_Other,
	GAD_SniperRifleScope,
	GAD_Magazine,
	GAD_Bipod,
	GAD_Muzzle,
	GAD_Silencer,
	GAD_Light
};

var eGadgetType m_eGadgetType;
var R6EngineWeapon m_WeaponOwner;
var Pawn m_OwnerCharacter;
var name m_AttachmentName;
var string m_NameID;
var string m_GadgetName;
var string m_GadgetShortName;

simulated event Destroyed ()
{
	Super.Destroyed();
	m_WeaponOwner=None;
	m_OwnerCharacter=None;
}

simulated function InitGadget (R6EngineWeapon OwnerWeapon, Pawn OwnerCharacter)
{
	UpdateAttachment(OwnerWeapon);
	m_OwnerCharacter=OwnerCharacter;
	AttachFPGadget();
}

simulated function UpdateAttachment (R6EngineWeapon weapOwner)
{
	m_WeaponOwner=weapOwner;
}

simulated function AttachFPGadget ();

simulated function DestroyFPGadget ();

function ActivateGadget (bool bActivate, optional bool bControllerInBehindView);

function Vector GetGadgetMuzzleOffset ()
{
	return vect(0.00,0.00,0.00);
}

function Toggle3rdBipod (bool bBipodOpen);

defaultproperties
{
    RemoteRole=ROLE_None
    DrawType=0
    bSkipActorPropertyReplication=True
    m_bForceBaseReplication=True
    DrawScale3D=(X=-1.00,Y=-1.00,Z=1.00)
}
