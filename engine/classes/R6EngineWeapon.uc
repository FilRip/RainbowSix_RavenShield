//================================================================================
// R6EngineWeapon.
//================================================================================
class R6EngineWeapon extends Actor
	Native
	Abstract;
//	NoNativeReplication;

enum EWeaponSound {
	WSOUND_None,
	WSOUND_Initialize,
	WSOUND_PlayTrigger,
	WSOUND_PlayFireSingleShot,
	WSOUND_PlayFireEndSingleShot,
	WSOUND_PlayFireThreeBurst,
	WSOUND_PlayFireFullAuto,
	WSOUND_PlayEmptyMag,
	WSOUND_PlayReloadEmpty,
	WSOUND_PlayReload,
	WSOUND_StopFireFullAuto
};

enum eGadgetType {
	GAD_Other,
	GAD_SniperRifleScope,
	GAD_Magazine,
	GAD_Bipod,
	GAD_Muzzle,
	GAD_Silencer,
	GAD_Light
};

enum eRateOfFire {
	ROF_Single,
	ROF_ThreeRound,
	ROF_FullAuto
};

enum eWeaponGrenadeType {
	GT_GrenadeNone,
	GT_GrenadeFrag,
	GT_GrenadeGas,
	GT_GrenadeFlash,
	GT_GrenadeSmoke
};

enum eGripType {
	GRIP_None,
	GRIP_Aug,
	GRIP_BullPup,
	GRIP_LMG,
	GRIP_P90,
	GRIP_ShotGun,
	GRIP_Uzi,
	GRIP_SubGun,
	GRIP_HandGun
};

enum eWeaponType {
	WT_Pistol,
	WT_Sub,
	WT_Assault,
	WT_ShotGun,
	WT_Sniper,
	WT_LMG,
	WT_Grenade,
	WT_Gadget
};

var(R6GunProperties) eWeaponType m_eWeaponType;
var eGripType m_eGripType;
var byte m_iNbBulletsInWeapon;
var int m_iNbParticlesToCreate;
var int m_InventoryGroup;
var(R6GunProperties) bool m_bBipod;
var bool m_bDeployBipod;
var bool m_bBipodDeployed;
var bool bFiredABullet;
var bool m_bPawnIsWalking;
var bool m_bIsSilenced;
var bool m_bUnlimitedClip;
var bool m_bUseMicroAnim;
var float m_fTimeDisplayParticule;
var(R6GunProperties) float m_fMaxZoom;
var float m_fFireAnimRate;
var float m_fFPBlend;
var(R6GunProperties) float BobDamping;
var(R6GunProperties) float m_fReloadTime;
var(R6GunProperties) float m_fReloadEmptyTime;
var float m_fPauseWhenChanging;
var(R6Sounds) Sound m_ReloadSound;
var(R6GunProperties) Texture m_ScopeTexture;
var(R6GunProperties) Texture m_ScopeAdd;
var(R6GunProperties) StaticMesh m_WithScopeSM;
var(R6GunProperties) Texture m_FPMuzzleFlashTexture;
var(R6WeaponSound) Sound m_EquipSnd;
var(R6WeaponSound) Sound m_UnEquipSnd;
var(R6WeaponSound) Sound m_ReloadSnd;
var(R6WeaponSound) Sound m_ReloadEmptySnd;
var(R6WeaponSound) Sound m_ChangeROFSnd;
var(R6WeaponSound) Sound m_SingleFireStereoSnd;
var(R6WeaponSound) Sound m_SingleFireEndStereoSnd;
var(R6WeaponSound) Sound m_BurstFireStereoSnd;
var(R6WeaponSound) Sound m_FullAutoStereoSnd;
var(R6WeaponSound) Sound m_FullAutoEndMonoSnd;
var(R6WeaponSound) Sound m_FullAutoEndStereoSnd;
var(R6WeaponSound) Sound m_EmptyMagSnd;
var(R6WeaponSound) Sound m_TriggerSnd;
var(R6WeaponSound) Sound m_ShellSingleFireSnd;
var(R6WeaponSound) Sound m_ShellBurstFireSnd;
var(R6WeaponSound) Sound m_ShellFullAutoSnd;
var(R6WeaponSound) Sound m_ShellEndFullAutoSnd;
var(R6WeaponSound) Sound m_CommonWeaponZoomSnd;
var(R6WeaponSound) Sound m_SniperZoomFirstSnd;
var(R6WeaponSound) Sound m_SniperZoomSecondSnd;
var(R6WeaponSound) Sound m_BipodSnd;
var Material m_HUDTexture;
var(R6Animation) name m_PawnWaitAnimLow;
var(R6Animation) name m_PawnWaitAnimHigh;
var(R6Animation) name m_PawnWaitAnimProne;
var(R6Animation) name m_PawnFiringAnim;
var(R6Animation) name m_PawnFiringAnimProne;
var(R6Animation) name m_PawnReloadAnim;
var(R6Animation) name m_PawnReloadAnimTactical;
var(R6Animation) name m_PawnReloadAnimProne;
var(R6Animation) name m_PawnReloadAnimProneTactical;
var(R6Attachment) name m_AttachPoint;
var(R6Attachment) name m_HoldAttachPoint;
var(R6Attachment) name m_HoldAttachPoint2;
var(R6GunProperties) Vector m_vPositionOffset;
var Vector m_FPFlashLocation;
var Plane m_HUDTexturePos;
var string m_NameID;
var string m_WeaponDesc;
var string m_WeaponShortName;
var(R6Attachment) string m_szMagazineClass;
var(R6Attachment) string m_szMuzzleClass;
var(R6Attachment) string m_szSilencerClass;
var(R6Attachment) string m_szTacticalLightClass;

replication
{
	unreliable if ( Role < Role_Authority )
		ServerShowInfo,ServerPlaceChargeAnimation,ServerDetonate,ServerPlaceCharge,ServerPutBulletInShotgun;
	unreliable if ( Role == Role_Authority )
		WeaponZoomSound;
	reliable if ( Role == Role_Authority )
		StopFire,ClientStopFire;
	reliable if ( Role < Role_Authority )
		ServerStopFire;
	reliable if ( Role == Role_Authority )
		m_iNbBulletsInWeapon,m_bDeployBipod,m_bUnlimitedClip;
	reliable if ( bNetOwner && (Role == Role_Authority) )
		m_fMaxZoom;
}

simulated function PostRender (Canvas Canvas);

simulated event DeployWeaponBipod (bool bBipodOpen);

simulated function bool ClientFire (float Value);

simulated function bool ClientAltFire (float Value);

function Fire (float Value);

function AltFire (float Value);

simulated function bool LoadFirstPersonWeapon (optional Pawn NetOwner, optional Controller LocalPlayerController)
{
	return False;
}

simulated function RemoveFirstPersonWeapon ();

simulated function AttachEmittersToFPWeapon ();

simulated function AttachEmittersTo3rdWeapon ();

simulated function DisableWeaponOrGadget ();

simulated function TurnOffEmitters (bool bTurnOff);

function GiveMoreAmmo ();

function AttachMagazine ();

simulated function int NumberOfBulletsLeftInClip ();

function float GetCurrentMaxAngle ();

function bool IsAtBestAccuracy ();

function float GetWeaponJump ();

exec function SetNextRateOfFire ();

function bool SetRateOfFire (eRateOfFire eNewRateOfFire);

function eRateOfFire GetRateOfFire ();

function SetHoldAttachPoint ();

function UseScopeStaticMesh ();

function SetTerroristNbOfClips (int iNewNumber);

function int GetNbOfClips ();

function bool HasAtLeastOneFullClip ();

function int GetClipCapacity ();

function float GetMuzzleVelocity ();

simulated function name GetWaitAnimName ()
{
	return m_PawnWaitAnimLow;
}

simulated function name GetHighWaitAnimName ()
{
	return m_PawnWaitAnimHigh;
}

simulated function name GetProneWaitAnimName ()
{
	return m_PawnWaitAnimProne;
}

simulated function name GetFiringAnimName ()
{
	return m_PawnFiringAnim;
}

simulated function name GetProneFiringAnimName ()
{
	return m_PawnFiringAnimProne;
}

simulated function name GetReloadAnimName ()
{
	return m_PawnReloadAnim;
}

simulated function name GetReloadAnimTacticalName ()
{
	return m_PawnReloadAnimTactical;
}

simulated function name GetProneReloadAnimName ()
{
	return m_PawnReloadAnimProne;
}

simulated function name GetProneReloadAnimTacticalName ()
{
	return m_PawnReloadAnimProneTactical;
}

simulated function PlayReloading ();

simulated event PawnIsMoving ();

simulated event PawnStoppedMoving ();

function bool HasAmmo ();

function ChangeClip ();

function FullCurrentClip ();

function FillClips ();

function AddExtraClip ();

simulated function AddClips (int iNbOfExtraClips);

function bool CanSwitchToWeapon ();

function ServerStopFire (optional bool bSoundOnly);

function ClientStopFire ();

function StopFire (optional bool bSoundOnly);

function StopAltFire ();

function FullAmmo ();

function PerfectAim ();

event SetIdentifyTarget (bool bIdentifyCharacter, bool bFriendly, string characterName);

simulated function R6SetReticule (optional Controller LocalPlayerController);

simulated function UpdateHands ();

simulated function WeaponInitialization (Pawn pawnOwner);

function StartLoopingAnims ();

simulated function FirstPersonAnimOver ()
{
}

function ServerPutBulletInShotgun ()
{
}

function ClientAddShell ()
{
}

function bool GunIsFull ()
{
	return False;
}

simulated function bool GotBipod ()
{
	return m_bBipod;
}

function Toggle3rdBipod (bool bBipodOpen);

function ThrowGrenade ();

function float GetSaveDistanceToThrow ()
{
	return 0.00;
}

function ServerPlaceCharge (Vector vLocation);

function ServerDetonate ();

function ServerPlaceChargeAnimation ();

function NPCPlaceCharge (Actor aDoor);

function NPCDetonateCharge ();

function GiveBulletToWeapon (string aBulletName);

function bool HasBulletType (name strBulletType);

simulated event bool IsGoggles ()
{
	return False;
}

function SetHeartBeatRange (float fRange);

function WeaponZoomSound (bool bFirstZoom);

function Texture Get2DIcon ();

simulated function StartFalling ();

simulated function SetGadgets ();

function bool AffectActor (int BulletGroup, Actor ActorAffected);

simulated function bool IsPumpShotGun ()
{
	return False;
}

function bool IsSniperRifle ()
{
	return m_eWeaponType == 4;
}

simulated function bool IsLMG ()
{
	return m_eWeaponType == 5;
}

function bool HasScope ();

function float GetExplosionDelay ();

function float GetWeaponRange ();

simulated event UpdateWeaponAttachment ();

function SetRelevant (bool bNewAlwaysRelevant);

function SetTearOff (bool bNewTearOff);

simulated event ShowWeaponParticules (EWeaponSound EWeaponSound);

function SetAccuracyOnHit ();

simulated function ServerShowInfo ()
{
}

defaultproperties
{
    m_eGripType=7
    m_InventoryGroup=1
    m_fMaxZoom=1.50
    m_fFireAnimRate=1.00
    BobDamping=0.96
    m_fReloadTime=2.50
    m_fReloadEmptyTime=3.00
    m_fPauseWhenChanging=0.50
    RemoteRole=ROLE_SimulatedProxy
}