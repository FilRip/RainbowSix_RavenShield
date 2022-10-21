//================================================================================
// R6AbstractWeapon.
//================================================================================
class R6AbstractWeapon extends R6EngineWeapon
	Native
	Abstract;

var bool m_bHiddenWhenNotInUse;
var R6AbstractGadget m_SelectedWeaponGadget;
var R6AbstractGadget m_ScopeGadget;
var R6AbstractGadget m_BipodGadget;
var R6AbstractGadget m_MuzzleGadget;
var R6AbstractGadget m_MagazineGadget;
var R6AbstractFirstPersonWeapon m_FPHands;
var R6AbstractFirstPersonWeapon m_FPWeapon;
var R6AbstractGadget m_FPGadget;
var Class<R6AbstractGadget> m_WeaponGadgetClass;
var(R6GunProperties) Class<R6AbstractFirstPersonWeapon> m_pFPHandsClass;
var(R6GunProperties) Class<R6AbstractFirstPersonWeapon> m_pFPWeaponClass;

replication
{
	reliable if ( Role == Role_Authority )
		m_WeaponGadgetClass;
}

function R6AbstractBulletManager GetBulletManager ();

simulated event SpawnSelectedGadget ();

simulated function R6SetGadget (Class<R6AbstractGadget> pWeaponGadgetClass);

simulated function CreateWeaponEmitters ();
