//================================================================================
// R6AbstractFirstPersonWeapon.
//================================================================================
class R6AbstractFirstPersonWeapon extends R6EngineFirstPersonWeapon
	Native
	Abstract;

var bool m_bWeaponBipodDeployed;
var bool m_bReloadEmpty;
var Actor m_smGun;
var Actor m_smGun2;
var(R6FPAnimations) name m_Empty;
var(R6FPAnimations) name m_Fire;
var(R6FPAnimations) name m_FireEmpty;
var(R6FPAnimations) name m_FireLast;
var(R6FPAnimations) name m_Neutral;
var(R6FPAnimations) name m_Reload;
var(R6FPAnimations) name m_ReloadEmpty;
var(R6FPAnimations) name m_BipodRaise;
var(R6FPAnimations) name m_BipodDeploy;
var(R6FPAnimations) name m_BipodDiscard;
var(R6FPAnimations) name m_BipodClose;
var(R6FPAnimations) name m_BipodNeutral;
var(R6FPAnimations) name m_BipodReload;
var(R6FPAnimations) name m_BipodReloadEmpty;
var name m_WeaponNeutralAnim;

function StopFiring ();

function InterruptFiring ();

function FireEmpty ();

function FireLastBullet ();

function FireSingleShot ();

function FireThreeShots ();

function LoopBurst ();

function StartBurst ();

function StopTimer ();

function StartTimer ();

function FireGrenadeThrow ();

function FireGrenadeRoll ();

function DestroyBullets ();

function StartWeaponBurst ();

function LoopWeaponBurst ();

function StopWeaponBurst ();

function PlayWalkingAnimation ();

function StopWalkingAnimation ();

function ResetNeutralAnim ();

simulated function SwitchFPMesh ();

simulated function SwitchFPAnim ();

simulated function SetAssociatedWeapon (R6AbstractFirstPersonWeapon AWeapon);

function HideBullet (int iWhichBullet);

function PlayFireAnim ()
{
	if ( m_bWeaponBipodDeployed == False )
	{
		PlayAnim(m_Fire);
	}
}

function PlayFireLastAnim ()
{
	if ( m_bWeaponBipodDeployed == False )
	{
		PlayAnim(m_FireLast);
	}
}

function DestroySM ()
{
	local Actor aActor;

	aActor=m_smGun;
	m_smGun=None;
	if ( aActor != None )
	{
		aActor.Destroy();
	}
	aActor=m_smGun2;
	m_smGun2=None;
	if ( aActor != None )
	{
		aActor.Destroy();
	}
	DestroyBullets();
}

simulated function PostBeginPlay ()
{
	if (  !HasAnim(m_Neutral) )
	{
		Log("Missing Neutral Anim for Weapon :" $ string(self));
	}
	if (  !HasAnim(m_Empty) )
	{
		m_Empty=m_Neutral;
	}
	if (  !HasAnim(m_Fire) )
	{
		m_Fire=m_Neutral;
	}
	if (  !HasAnim(m_FireLast) )
	{
		m_FireLast=m_Fire;
	}
	if (  !HasAnim(m_FireEmpty) )
	{
		m_FireEmpty=m_Neutral;
	}
	if (  !HasAnim(m_Reload) )
	{
		m_Reload=m_Neutral;
	}
	if (  !HasAnim(m_ReloadEmpty) )
	{
		m_ReloadEmpty=m_Reload;
	}
	if (  !HasAnim(m_BipodRaise) )
	{
		m_BipodRaise=m_Neutral;
	}
	if (  !HasAnim(m_BipodDeploy) )
	{
		m_BipodDeploy=m_Neutral;
	}
	if (  !HasAnim(m_BipodDiscard) )
	{
		m_BipodDiscard=m_Neutral;
	}
	if (  !HasAnim(m_BipodClose) )
	{
		m_BipodClose=m_Neutral;
	}
	if (  !HasAnim(m_BipodNeutral) )
	{
		m_BipodNeutral=m_Neutral;
	}
	if (  !HasAnim(m_BipodReload) )
	{
		m_BipodReload=m_BipodNeutral;
	}
	if (  !HasAnim(m_BipodReloadEmpty) )
	{
		m_BipodReloadEmpty=m_BipodReload;
	}
}

state Reloading
{
	function BeginState ()
	{
	}
	
}

simulated event Destroyed ()
{
	DestroySM();
	Super.Destroyed();
}

defaultproperties
{
    m_Empty=Empty_nt
    m_Fire=Fire
    m_FireEmpty=FireEmpty
    m_FireLast=FireLast
    m_Neutral=Neutral
    m_Reload=Reload
    m_ReloadEmpty=ReloadEmpty
    m_BipodRaise=BipodBegin
    m_BipodDeploy=Bipod_b
    m_BipodDiscard=BipodEnd
    m_BipodClose=Bipod_e
    m_BipodNeutral=Bipod_nt
    m_BipodReload=BipodReload
    m_BipodReloadEmpty=BipodReloadEmpty
    m_WeaponNeutralAnim=Neutral
    RemoteRole=ROLE_None
    DrawType=2
    m_bAllowLOD=False
}