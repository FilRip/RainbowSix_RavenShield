//================================================================================
// R6Weapons.
//================================================================================
class R6Weapons extends R6AbstractWeapon
	Native
	Abstract;

struct stAccuracyType
{
	var() float fBaseAccuracy;
	var() float fShuffleAccuracy;
	var() float fWalkingAccuracy;
	var() float fWalkingFastAccuracy;
	var() float fRunningAccuracy;
	var() float fReticuleTime;
	var() float fAccuracyChange;
	var() float fWeaponJump;
};

struct stWeaponCaps
{
	var() int bSingle;
	var() int bThreeRound;
	var() int bFullAuto;
	var() int bCMag;
	var() int bMuzzle;
	var() int bSilencer;
	var() int bLight;
	var() int bMiniScope;
	var() int bHeatVision;
};

const AccuracyLostWhenWounded= 1.2;
var(R6Clip) byte m_aiNbOfBullets[20];
var byte m_iNbOfRoundsInBurst;
var(R6Firing) eRateOfFire m_eRateOfFire;
var byte m_wNbOfBounce;
var const int C_iMaxNbOfClips;
var(R6Clip) int m_iClipCapacity;
var(R6Clip) int m_iNbOfClips;
var(R6Clip) int m_iNbOfExtraClips;
var int m_iCurrentClip;
var int m_iNbOfRoundsToShoot;
var int m_iCurrentNbOfClips;
var int m_iCurrentAverage;
var(Debug) int m_iDbgNextReticule;
var bool m_bPlayLoopingSound;
var(Debug) bool m_bSoundLog;
var(Debug) bool bShowLog;
var bool m_bFireOn;
var bool m_bEmptyAllClips;
var(R6GunProperties) float m_fMuzzleVelocity;
var(Muzzleflash) float m_MuzzleScale;
var float m_fAverageDegChanges;
var float m_fAverageDegTable[5];
var float m_fStablePercentage;
var float m_fWorstAccuracy;
var float m_fOldWorstAccuracy;
var float m_fEffectiveAccuracy;
var float m_fDesiredAccuracy;
var float m_fMaxAngleError;
var float m_fCurrentFireJump;
var float m_fFireSoundRadius;
var(R6Firing) float m_fRateOfFire;
var float m_fDisplayFOV;
var(R6GunProperties) Texture m_WeaponIcon;
var R6Reticule m_ReticuleInstance;
var R6SFX m_pEmptyShellsEmitter;
var R6SFX m_pMuzzleFlashEmitter;
var(R6GunProperties) Class<R6Reticule> m_pReticuleClass;
var(R6GunProperties) Class<R6Reticule> m_pWithWeaponReticuleClass;
var(R6Clip) Class<R6Bullet> m_pBulletClass;
var(R6Clip) Class<R6SFX> m_pEmptyShells;
var(R6Clip) Class<R6SFX> m_pMuzzleFlash;
var(R6GunProperties) stWeaponCaps m_stWeaponCaps;
var Rotator m_rLastRotation;
var Rotator m_rBuckFirstBullet;
var(R6Firing) stAccuracyType m_stAccuracyValues;
var Vector m_vPawnLocWhenKilled;

replication
{
	reliable if ( Role < Role_Authority )
		ServerChangeClip,ServerStartChangeClip,ServerFireBullet,ServerStartFiring,ServerAddClips,ServerSetNextRateOfFire,ServerWhoIsMyOwner;
	reliable if ( Role == Role_Authority )
		ClientStartChangeClip,ClientsFireBullet,ClientShowBulletFire,ClientStartFiring,ClientYourOwnerIs;
	reliable if ( Role == Role_Authority )
		m_eRateOfFire,m_iCurrentClip,m_iCurrentNbOfClips;
	reliable if ( bNetInitial && (Role == Role_Authority) )
		m_iClipCapacity,m_pBulletClass;
	reliable if ( Role < Role_Authority )
		m_bFireOn;
}

simulated event HideAttachment ();

function bool HasScope ()
{
	return m_fMaxZoom > 2.00;
}

simulated function UseScopeStaticMesh ()
{
	if ( m_WithScopeSM != None )
	{
		SetStaticMesh(m_WithScopeSM);
	}
}

simulated function SpawnSelectedGadget ()
{
	if ( m_WeaponGadgetClass.Default.m_eGadgetType == 5 )
	{
		if ( m_MuzzleGadget != None )
		{
			m_MuzzleGadget.Destroy();
			m_MuzzleGadget=None;
		}
		R6SetGadget(Class<R6AbstractGadget>(DynamicLoadObject(m_szSilencerClass,Class'Class')));
	}
	else
	{
		if ( m_WeaponGadgetClass.Default.m_eGadgetType == 6 )
		{
			if ( m_szTacticalLightClass != "" )
			{
				R6SetGadget(Class<R6AbstractGadget>(DynamicLoadObject(m_szTacticalLightClass,Class'Class')));
			}
		}
		else
		{
			R6SetGadget(m_WeaponGadgetClass);
		}
	}
}

simulated function SetGadgets ()
{
	if ( Level.NetMode != 3 )
	{
		if ( m_WeaponGadgetClass != None )
		{
			if ( m_WeaponGadgetClass.Default.m_eGadgetType == 5 )
			{
				if ( m_MuzzleGadget != None )
				{
					m_MuzzleGadget.Destroy();
					m_MuzzleGadget=None;
				}
				R6SetGadget(Class<R6AbstractGadget>(DynamicLoadObject(m_szSilencerClass,Class'Class')));
			}
			else
			{
				if ( m_WeaponGadgetClass.Default.m_eGadgetType == 6 )
				{
					if ( m_szTacticalLightClass != "" )
					{
						R6SetGadget(Class<R6AbstractGadget>(DynamicLoadObject(m_szTacticalLightClass,Class'Class')));
					}
				}
				else
				{
					R6SetGadget(m_WeaponGadgetClass);
				}
			}
		}
	}
	if ( m_InventoryGroup == 1 )
	{
		if ( m_szMagazineClass != "" )
		{
			R6SetGadget(Class<R6AbstractGadget>(DynamicLoadObject(m_szMagazineClass,Class'Class')));
		}
		else
		{
			m_MagazineGadget=None;
		}
		if ( GotBipod() )
		{
			if ( IsA('R6SniperRifle') )
			{
				if ( Owner.IsA('R6Rainbow') )
				{
					R6SetGadget(Class<R6AbstractGadget>(DynamicLoadObject("R6WeaponGadgets.R63rdRainbowScope",Class'Class')));
				}
				else
				{
					R6SetGadget(Class<R6AbstractGadget>(DynamicLoadObject("R6WeaponGadgets.R6ScopeGadget",Class'Class')));
				}
				R6SetGadget(Class<R6AbstractGadget>(DynamicLoadObject("R6WeaponGadgets.R63rdSnipeBipod",Class'Class')));
			}
			else
			{
				R6SetGadget(Class<R6AbstractGadget>(DynamicLoadObject("R6WeaponGadgets.R63rdLMGBipod",Class'Class')));
			}
		}
		if ( m_szMuzzleClass != "" )
		{
			R6SetGadget(Class<R6AbstractGadget>(DynamicLoadObject(m_szMuzzleClass,Class'Class')));
		}
	}
	else
	{
		if ( m_InventoryGroup == 2 )
		{
			R6SetGadget(Class<R6AbstractGadget>(DynamicLoadObject(m_szMagazineClass,Class'Class')));
			if ( m_szMuzzleClass != "" )
			{
				R6SetGadget(Class<R6AbstractGadget>(DynamicLoadObject(m_szMuzzleClass,Class'Class')));
			}
		}
	}
}

simulated event Destroyed ()
{
	if ( (R6Pawn(Owner) != None) && R6Pawn(Owner).m_bIsPlayer )
	{
		RemoveFirstPersonWeapon();
	}
	if ( m_pMuzzleFlashEmitter != None )
	{
		m_pMuzzleFlashEmitter.Destroy();
		m_pMuzzleFlashEmitter=None;
	}
	if ( m_pEmptyShellsEmitter != None )
	{
		m_pEmptyShellsEmitter.Destroy();
		m_pEmptyShellsEmitter=None;
	}
	if ( m_SelectedWeaponGadget != None )
	{
		m_SelectedWeaponGadget.Destroy();
		m_SelectedWeaponGadget=None;
	}
	if ( m_MuzzleGadget != None )
	{
		m_MuzzleGadget.Destroy();
		m_MuzzleGadget=None;
	}
	if ( m_ScopeGadget != None )
	{
		m_ScopeGadget.Destroy();
		m_ScopeGadget=None;
	}
	if ( m_BipodGadget != None )
	{
		m_BipodGadget.Destroy();
		m_BipodGadget=None;
	}
	if ( m_MagazineGadget != None )
	{
		m_MagazineGadget.Destroy();
		m_MagazineGadget=None;
	}
	if ( m_FPWeapon != None )
	{
		m_FPWeapon.Destroy();
		m_FPWeapon=None;
	}
	Super.Destroyed();
}

simulated function PostBeginPlay ()
{
	Super.PostBeginPlay();
	FillClips();
	if ( (Level.NetMode != 0) && (m_eWeaponType == 0) )
	{
		m_bUnlimitedClip=True;
	}
	m_fEffectiveAccuracy=m_stAccuracyValues.fBaseAccuracy;
	m_fDesiredAccuracy=m_stAccuracyValues.fBaseAccuracy;
	m_fWorstAccuracy=m_stAccuracyValues.fBaseAccuracy;
}

simulated function FillClips ()
{
	local int i;

	m_iCurrentNbOfClips=m_iNbOfClips;
	if ( IsPumpShotGun() )
	{
		m_iNbBulletsInWeapon=m_iClipCapacity;
	}
	else
	{
		m_iNbBulletsInWeapon=m_iClipCapacity;
		i=0;
JL0038:
		if ( i < m_iNbOfClips )
		{
			m_aiNbOfBullets[i]=m_iClipCapacity;
			i++;
			goto JL0038;
		}
		if (  !IsLMG() &&  !IsA('R6Gadget') )
		{
			m_iNbBulletsInWeapon++;
		}
	}
}

function float GetWeaponRange ()
{
	return m_pBulletClass.Default.m_fRange;
}

function float GetWeaponJump ()
{
	return m_stAccuracyValues.fWeaponJump;
}

event SetIdentifyTarget (bool bIdentifyCharacter, bool bFriendly, string characterName)
{
	local R6GameOptions GameOptions;

	if ( m_ReticuleInstance != None )
	{
		GameOptions=GetGameOptions();
		m_ReticuleInstance.m_bIdentifyCharacter=bIdentifyCharacter && (GameOptions.HUDShowPlayersName || R6PlayerController(Pawn(Owner).Controller).m_bShowCompleteHUD);
		m_ReticuleInstance.m_CharacterName=characterName;
		m_ReticuleInstance.m_bAimingAtFriendly=bFriendly;
	}
}

simulated function R6SetReticule (optional Controller LocalPlayerController)
{
	if ( Owner.IsA('R6Rainbow') )
	{
		if ( (m_pReticuleClass != None) && (m_ReticuleInstance == None) )
		{
			if ( (m_pFPWeaponClass != None) && (m_eWeaponType != 6) && (m_eWeaponType != 7) )
			{
				m_ReticuleInstance=Spawn(m_pWithWeaponReticuleClass,Owner);
			}
			else
			{
				m_ReticuleInstance=Spawn(m_pReticuleClass,Owner);
			}
			if ( Level.NetMode == NM_Standalone )
			{
				m_ReticuleInstance.m_bShowNames=True;
			}
			else
			{
				if ( LocalPlayerController != None )
				{
					m_ReticuleInstance.m_bShowNames=R6GameReplicationInfo(R6PlayerController(LocalPlayerController).GameReplicationInfo).m_bShowNames;
				}
				else
				{
					m_ReticuleInstance.m_bShowNames=R6GameReplicationInfo(R6PlayerController(Pawn(Owner).Controller).GameReplicationInfo).m_bShowNames;
				}
			}
		}
	}
}

function ServerWhoIsMyOwner ()
{
	ClientYourOwnerIs(Owner);
}

function ClientYourOwnerIs (Actor OwnerFromServer)
{
	if ( OwnerFromServer == None )
	{
		ServerWhoIsMyOwner();
		return;
	}
	SetOwner(OwnerFromServer);
	LoadFirstPersonWeapon();
	if ( R6Pawn(Owner).m_bChangingWeapon == True )
	{
		if ( IsInState('RaiseWeapon') )
		{
			BeginState();
		}
		else
		{
			GotoState('RaiseWeapon');
		}
	}
	else
	{
		StartLoopingAnims();
	}
}

simulated function bool LoadFirstPersonWeapon (optional Pawn NetOwner, optional Controller LocalPlayerController)
{
	if ( (m_pFPWeaponClass != None) && (m_pFPHandsClass != None) && (m_FPHands == None) && (m_FPWeapon == None) )
	{
		if ( NetOwner != None )
		{
			SetOwner(NetOwner);
		}
		else
		{
			if ( Owner == None )
			{
				ServerWhoIsMyOwner();
				return False;
			}
		}
		m_FPHands=Spawn(m_pFPHandsClass,self);
		if ( Owner.IsA('R6RainbowPawn') )
		{
			m_FPHands.Skins[0]=R6RainbowPawn(Owner).m_FPHandsTexture;
		}
		m_FPWeapon=Spawn(m_pFPWeaponClass,self);
		R6AbstractFirstPersonHands(m_FPHands).SetAssociatedWeapon(m_FPWeapon);
		if ( (m_FPWeapon != None) && (m_FPHands != None) )
		{
			if ( NumberOfBulletsLeftInClip() == 0 )
			{
				m_FPWeapon.m_WeaponNeutralAnim=m_FPWeapon.m_Empty;
			}
			if ( m_SelectedWeaponGadget != None )
			{
				m_SelectedWeaponGadget.AttachFPGadget();
			}
			if ( m_MuzzleGadget != None )
			{
				m_MuzzleGadget.AttachFPGadget();
			}
			AttachEmittersToFPWeapon();
			m_FPWeapon.PlayAnim(m_FPWeapon.m_WeaponNeutralAnim);
			m_FPHands.AttachToBone(m_FPWeapon,'B_R_Wrist_A');
		}
		else
		{
		}
	}
	else
	{
	}
	R6SetReticule(LocalPlayerController);
	return True;
}

simulated function AttachEmittersToFPWeapon ()
{
	if ( m_pMuzzleFlashEmitter != None )
	{
		m_pMuzzleFlashEmitter.m_bDrawFromBase=False;
		m_pMuzzleFlashEmitter.SetBase(None);
		m_FPWeapon.AttachToBone(m_pMuzzleFlashEmitter,'TagMuzzle');
		m_pMuzzleFlashEmitter.SetRelativeLocation(vect(0.00,0.00,0.00));
		m_pMuzzleFlashEmitter.SetRelativeRotation(rot(0,0,0));
	}
	if ( m_pEmptyShellsEmitter != None )
	{
		m_pEmptyShellsEmitter.m_bDrawFromBase=False;
		m_pEmptyShellsEmitter.SetBase(None);
		m_FPWeapon.AttachToBone(m_pEmptyShellsEmitter,'TagCase');
		m_pEmptyShellsEmitter.SetRelativeLocation(vect(0.00,0.00,0.00));
		m_pEmptyShellsEmitter.SetRelativeRotation(rot(0,0,0));
		if ( m_pEmptyShellsEmitter.Emitters.Length > 0 )
		{
			m_pEmptyShellsEmitter.Emitters[0].LifetimeRange.Min=0.30;
			m_pEmptyShellsEmitter.Emitters[0].LifetimeRange.Max=0.30;
		}
	}
}

simulated function AttachEmittersTo3rdWeapon ()
{
	local Vector vTagLocation;
	local Rotator rTagRotator;

	if ( m_pMuzzleFlashEmitter != None )
	{
		GetTagInformations("TAGMuzzle",vTagLocation,rTagRotator);
		if ( m_SelectedWeaponGadget != None )
		{
			vTagLocation += m_SelectedWeaponGadget.GetGadgetMuzzleOffset();
		}
		if ( m_FPWeapon != None )
		{
			m_FPWeapon.DetachFromBone(m_pMuzzleFlashEmitter);
		}
		m_pMuzzleFlashEmitter.m_bDrawFromBase=True;
		m_pMuzzleFlashEmitter.SetBase(None);
		m_pMuzzleFlashEmitter.SetBase(self,Location);
		m_pMuzzleFlashEmitter.SetRelativeLocation(vTagLocation);
		m_pMuzzleFlashEmitter.SetRelativeRotation(rTagRotator);
	}
	if ( m_pEmptyShellsEmitter != None )
	{
		GetTagInformations("TagCase",vTagLocation,rTagRotator);
		if ( m_FPWeapon != None )
		{
			m_FPWeapon.DetachFromBone(m_pEmptyShellsEmitter);
		}
		m_pEmptyShellsEmitter.m_bDrawFromBase=True;
		m_pEmptyShellsEmitter.SetBase(None);
		m_pEmptyShellsEmitter.SetBase(self,Location);
		m_pEmptyShellsEmitter.SetRelativeLocation(vTagLocation);
		m_pEmptyShellsEmitter.SetRelativeRotation(rTagRotator);
		if ( m_pEmptyShellsEmitter.Emitters.Length > 0 )
		{
			m_pEmptyShellsEmitter.Emitters[0].LifetimeRange.Min=4.00;
			m_pEmptyShellsEmitter.Emitters[0].LifetimeRange.Max=4.00;
		}
	}
}

simulated event PawnIsMoving ()
{
	m_bPawnIsWalking=True;
	m_FPHands.PlayWalkingAnimation();
}

simulated event PawnStoppedMoving ()
{
	m_bPawnIsWalking=False;
	m_FPHands.StopWalkingAnimation();
}

function StartLoopingAnims ()
{
	if ( m_FPHands != None )
	{
		m_FPHands.SetDrawType(DT_Mesh);
		m_FPHands.GotoState('Waiting');
		m_FPHands.PlayAnim(R6AbstractFirstPersonHands(m_FPHands).m_WaitAnim1);
	}
	GotoState('None');
	R6Pawn(Owner).m_bReloadingWeapon=False;
	R6Pawn(Owner).m_bPawnIsReloading=False;
	R6Pawn(Owner).m_bWeaponTransition=False;
	R6Pawn(Owner).m_fWeaponJump=m_stAccuracyValues.fWeaponJump;
	R6Pawn(Owner).m_fZoomJumpReturn=1.00;
}

simulated function RemoveFirstPersonWeapon ()
{
	local Actor temp;

	if ( m_FPHands != None )
	{
		temp=m_FPHands;
		m_FPHands=None;
		temp.Destroy();
	}
	UpdateAllAttachments();
	AttachEmittersTo3rdWeapon();
	if ( m_FPWeapon != None )
	{
		m_FPWeapon.DestroySM();
		temp=m_FPWeapon;
		m_FPWeapon=None;
		temp.Destroy();
	}
	if ( m_ReticuleInstance != None )
	{
		temp=m_ReticuleInstance;
		m_ReticuleInstance=None;
		temp.Destroy();
	}
	if ( m_SelectedWeaponGadget != None )
	{
		m_SelectedWeaponGadget.DestroyFPGadget();
	}
	if ( m_MuzzleGadget != None )
	{
		m_MuzzleGadget.DestroyFPGadget();
	}
}

simulated function UpdateAllAttachments ()
{
	if ( m_SelectedWeaponGadget != None )
	{
		m_SelectedWeaponGadget.UpdateAttachment(self);
	}
	if ( m_ScopeGadget != None )
	{
		m_ScopeGadget.UpdateAttachment(self);
	}
	if ( m_MagazineGadget != None )
	{
		m_MagazineGadget.UpdateAttachment(self);
	}
	if ( m_BipodGadget != None )
	{
		m_BipodGadget.UpdateAttachment(self);
	}
	if ( m_MuzzleGadget != None )
	{
		m_MuzzleGadget.UpdateAttachment(self);
	}
}

simulated function TurnOffEmitters (bool bTurnOff)
{
	if ( m_pEmptyShellsEmitter != None )
	{
		m_pEmptyShellsEmitter.bHidden=bTurnOff;
	}
	if ( m_pMuzzleFlashEmitter != None )
	{
		m_pMuzzleFlashEmitter.bHidden=bTurnOff;
	}
}

function ReloadShotGun ()
{
}

exec function SetNextRateOfFire ()
{
//	Owner.PlaySound(m_ChangeROFSnd,2);
	ServerSetNextRateOfFire();
}

exec function ServerSetNextRateOfFire ()
{
	switch (m_eRateOfFire)
	{
/*		case 2:
		if (  !SetRateOfFire(0) )
		{
			SetRateOfFire(1);
		}
		break;
		case 1:
		if (  !SetRateOfFire(2) )
		{
			SetRateOfFire(0);
		}
		break;
		case 0:
		if (  !SetRateOfFire(1) )
		{
			SetRateOfFire(2);
		}
		break;
		default:   */
	}
}

function bool SetRateOfFire (eRateOfFire eNewRateOfFire)
{
	if ( (m_stWeaponCaps.bFullAuto == 1) && (eNewRateOfFire == 2) )
	{
//		m_eRateOfFire=2;
	}
	else
	{
		if ( (m_stWeaponCaps.bThreeRound == 1) && (eNewRateOfFire == 1) )
		{
//			m_eRateOfFire=1;
		}
		else
		{
			if ( (m_stWeaponCaps.bSingle == 1) && (eNewRateOfFire == 0) )
			{
//				m_eRateOfFire=0;
			}
			else
			{
				return False;
			}
		}
	}
	return True;
}

function eRateOfFire GetRateOfFire ()
{
	return m_eRateOfFire;
}

function int GetNbOfRoundsForROF ()
{
	if ( m_iNbBulletsInWeapon <= 0 )
	{
		return 0;
	}
	else
	{
		switch (m_eRateOfFire)
		{
/*			case 2:
			return m_iNbBulletsInWeapon;
			case 1:
			return Min(3,m_iNbBulletsInWeapon);
			case 0:
			return 1;
			default:         */
		}
	}
}

simulated function AddExtraClip ()
{
	AddClips(m_iNbOfExtraClips);
}

simulated function ServerAddClips ()
{
	AddClips(m_iNbOfExtraClips);
}

simulated function AddClips (int iNbOfExtraClips)
{
	local int i;
	local int iNewClipCount;

	i=m_iNbOfClips;
JL000B:
	if ( i < m_iNbOfClips + iNbOfExtraClips )
	{
		if ( m_iNbOfClips + 1 < C_iMaxNbOfClips )
		{
			m_aiNbOfBullets[i]=m_iClipCapacity;
			iNewClipCount++;
		}
		i++;
		goto JL000B;
	}
	m_iNbOfClips += iNewClipCount;
	m_iCurrentNbOfClips += iNewClipCount;
	if ( Level.NetMode == NM_Client )
	{
		ServerAddClips();
	}
}

function SetTerroristNbOfClips (int iNewNumber)
{
	m_iCurrentNbOfClips=iNewNumber;
	m_bEmptyAllClips=True;
}

function int GetNbOfClips ()
{
	return m_iCurrentNbOfClips;
}

function bool HasAtLeastOneFullClip ()
{
	local int i;

	if ( IsPumpShotGun() == True )
	{
		if ( m_iNbBulletsInWeapon < m_iClipCapacity * 0.50 )
		{
			return True;
		}
	}
	else
	{
		i=0;
JL0032:
		if ( i < m_iNbOfClips )
		{
			if ( m_aiNbOfBullets[i] == m_iClipCapacity )
			{
				return True;
			}
			i++;
			goto JL0032;
		}
	}
	return False;
}

function float GetCurrentMaxAngle ()
{
	return m_fMaxAngleError;
}

function bool IsAtBestAccuracy ()
{
	return m_fMaxAngleError <= m_stAccuracyValues.fBaseAccuracy;
}

simulated function WeaponInitialization (Pawn pawnOwner)
{
	if ( Level.NetMode == NM_DedicatedServer )
	{
		return;
	}
	CreateWeaponEmitters();
	if ( Default.m_NameID != "" )
	{
		if ( IsA('R6Gadget') )
		{
			m_WeaponDesc=Localize(m_NameID,"ID_NAME","R6Gadgets");
			m_WeaponShortName=m_WeaponDesc;
		}
		else
		{
			m_WeaponDesc=Localize(m_NameID,"ID_NAME","R6Weapons");
			m_WeaponShortName=Localize(m_NameID,"ID_SHORTNAME","R6Weapons");
		}
	}
	else
	{
		m_WeaponDesc="No Name Set";
	}
}

simulated function CreateWeaponEmitters ()
{
	if ( (m_pMuzzleFlashEmitter == None) && (m_pMuzzleFlash != None) )
	{
		m_pMuzzleFlashEmitter=Spawn(m_pMuzzleFlash);
		if ( (m_pMuzzleFlashEmitter != None) && (m_pMuzzleFlashEmitter.Emitters.Length > 4) )
		{
			m_pMuzzleFlashEmitter.Emitters[4].StartSizeRange.X.Min *= m_MuzzleScale;
			m_pMuzzleFlashEmitter.Emitters[4].StartSizeRange.X.Max *= m_MuzzleScale;
			if ( m_FPMuzzleFlashTexture != None )
			{
				m_pMuzzleFlashEmitter.Emitters[4].Texture=m_FPMuzzleFlashTexture;
			}
		}
	}
	if ( (m_pEmptyShellsEmitter == None) && (m_pEmptyShells != None) )
	{
		m_pEmptyShellsEmitter=Spawn(m_pEmptyShells);
	}
	AttachEmittersTo3rdWeapon();
}

function GetFiringDirection (out Vector vOrigin, out Rotator rRotation, optional int iBulletNumber)
{
	local float fMaxAngleError;
	local float fRandValueOne;
	local float fRandValueTwo;
	local float fMaxError;
	local R6PlayerController PlayerOwner;
	local R6Pawn pawnOwner;

	pawnOwner=R6Pawn(Owner);
	PlayerOwner=R6PlayerController(pawnOwner.Controller);
	vOrigin=pawnOwner.GetFiringStartPoint();
	if ( (PlayerOwner != None) && (PlayerOwner.m_targetedPawn != None) )
	{
		rRotation=rotator(PlayerOwner.m_vAutoAimTarget - vOrigin);
	}
	else
	{
		rRotation=pawnOwner.GetFiringRotation();
	}
	if ( iBulletNumber == 0 )
	{
		fMaxError=m_fMaxAngleError * 91.02;
		fRandValueOne=FRand() * 2 * fMaxError - fMaxError;
		fRandValueTwo=FRand() * 2 * fMaxError - fMaxError;
		rRotation.Pitch += fRandValueOne;
		rRotation.Yaw += fRandValueTwo;
		if ( m_eWeaponType == 3 )
		{
			m_rBuckFirstBullet.Pitch=rRotation.Pitch;
			m_rBuckFirstBullet.Yaw=rRotation.Yaw;
		}
		if ( PlayerOwner != None )
		{
			PlayerOwner.m_rLastBulletDirection.Pitch=fRandValueOne;
			PlayerOwner.m_rLastBulletDirection.Yaw=fRandValueTwo;
			PlayerOwner.m_rLastBulletDirection.Roll=1;
		}
	}
	else
	{
		rRotation.Pitch=m_rBuckFirstBullet.Pitch + FRand() * 550 - 275;
		rRotation.Yaw=m_rBuckFirstBullet.Yaw + FRand() * 550 - 275;
	}
}

simulated event RenderOverlays (Canvas Canvas)
{
	local R6PlayerController thePlayerController;
	local Rotator rNewRotation;

	if ( Level.m_bInGamePlanningActive == True )
	{
		return;
	}
	if ( (Owner == None) || (Pawn(Owner).Controller == None) )
	{
		return;
	}
	thePlayerController=R6PlayerController(Pawn(Owner).Controller);
	if ( thePlayerController != None )
	{
		if ( (thePlayerController.bBehindView == False) && (thePlayerController.m_bUseFirstPersonWeapon == True) )
		{
			if ( m_FPHands != None )
			{
				m_FPHands.SetLocation(R6Pawn(Owner).R6CalcDrawLocation(self,rNewRotation,m_vPositionOffset));
				m_FPHands.SetRotation(Pawn(Owner).GetViewRotation() + rNewRotation + thePlayerController.m_rHitRotation);
				if ( thePlayerController.ShouldDrawWeapon() )
				{
					Canvas.DrawActor(m_FPHands,False,True);
				}
			}
		}
	}
}

simulated function PostRender (Canvas Canvas)
{
	local R6PlayerController aPC;

	if ( (Level.m_bInGamePlanningActive == True) || (Owner == None) )
	{
		return;
	}
	aPC=R6PlayerController(Pawn(Owner).Controller);
	if ( (aPC != None) && (m_ReticuleInstance != None) &&  !aPC.bBehindView )
	{
		m_ReticuleInstance.SetReticuleInfo(Canvas);
		if ( GetGameOptions().HUDShowPlayersName || aPC.m_bShowCompleteHUD )
		{
			m_ReticuleInstance.SetIdentificationReticule(Canvas);
		}
		if ( (GetGameOptions().HUDShowReticule || aPC.m_bShowCompleteHUD) &&  !aPC.m_bHideReticule )
		{
			m_ReticuleInstance.PostRender(Canvas);
		}
	}
}

function Fire (float fValue)
{
	GotoState('NormalFire');
}

function ClientStartFiring ()
{
	m_iNbOfRoundsToShoot=GetNbOfRoundsForROF();
	if ( (m_iNbOfRoundsToShoot == 0) && (m_iNbOfRoundsInBurst == 0) && R6Pawn(Owner).m_bIsPlayer )
	{
//		R6Pawn(Owner).PlayLocalWeaponSound(2);
	}
	if ( Level.NetMode == NM_Client )
	{
		m_iNbOfRoundsInBurst=0;
	}
}

function ServerStartFiring ()
{
	m_iNbOfRoundsToShoot=GetNbOfRoundsForROF();
	if ( (m_iNbOfRoundsToShoot == 0) && (m_iNbOfRoundsInBurst == 0) )
	{
//		R6Pawn(Owner).PlayWeaponSound(2);
	}
	m_iNbOfRoundsInBurst=0;
}

function ServerStopFire (optional bool bSoundOnly)
{
	if ( (m_iNbOfRoundsInBurst < 3) && (m_eRateOfFire != 0) || (m_iNbOfRoundsInBurst > 3) || (m_iNbOfRoundsInBurst == 3) && (m_eRateOfFire != 1) )
	{
//		R6Pawn(Owner).PlayWeaponSound(10);
	}
	if ( bSoundOnly == False )
	{
		ClientStopFire();
	}
}

function ClientStopFire ()
{
	if ( m_FPHands != None )
	{
		if ( m_iNbOfRoundsInBurst < 3 )
		{
			if ( Level.NetMode != 0 )
			{
				m_FPHands.StopFiring();
			}
			else
			{
				m_FPHands.InterruptFiring();
			}
		}
		else
		{
			if ( (m_iNbOfRoundsInBurst > 3) || (m_iNbOfRoundsInBurst == 3) && (m_eRateOfFire != 1) )
			{
				m_FPHands.StopFiring();
			}
		}
	}
	else
	{
		GotoState('None');
	}
	if ( R6Pawn(Owner).m_bIsPlayer && ((m_iNbOfRoundsInBurst < 3) && (m_eRateOfFire != 0) || (m_iNbOfRoundsInBurst > 3) || (m_iNbOfRoundsInBurst == 3) && (m_eRateOfFire != 1)) )
	{
//		R6Pawn(Owner).PlayLocalWeaponSound(10);
	}
	R6Pawn(Owner).PlayWeaponAnimation();
}

function StopFire (optional bool bSoundOnly)
{
	if ( bSoundOnly == False )
	{
		ClientStopFire();
	}
	ServerStopFire(True);
}

simulated function bool HasAmmo ()
{
	return (m_iNbBulletsInWeapon > 0) || (m_iCurrentNbOfClips > 1);
}

simulated function int NumberOfBulletsLeftInClip ()
{
	return m_iNbBulletsInWeapon;
}

function int GetClipCapacity ()
{
	return m_iClipCapacity;
}

simulated function bool GunIsFull ()
{
	return m_iNbBulletsInWeapon >= m_iClipCapacity;
}

function float GetMuzzleVelocity ()
{
	return m_fMuzzleVelocity;
}

simulated function bool ClientAltFire (float fValue)
{
	R6Pawn(Owner).ToggleGadget();
	return True;
}

function R6AbstractBulletManager GetBulletManager ()
{
	local R6Pawn pOwner;

	pOwner=R6Pawn(Owner);
	if ( pOwner != None )
	{
		return pOwner.m_pBulletManager;
	}
}

simulated function AltFire (float fValue)
{
	ClientAltFire(fValue);
}

function ServerFireBullet (float fMaxAngleErrorFromClient)
{
	local Vector vStartTrace;
	local Rotator rBulletRot;
	local int iCurrentBullet;
	local R6Pawn pawnOwner;
	local R6AbstractBulletManager BulletManager;

	if ( m_iNbBulletsInWeapon == 0 )
	{
		return;
	}
	pawnOwner=R6Pawn(Owner);
	BulletManager=GetBulletManager();
	m_iNbOfRoundsInBurst++;
	m_iNbBulletsInWeapon--;
	if ( (m_iNbBulletsInWeapon == 0) &&  !IsPumpShotGun() )
	{
		if (  !(m_iCurrentNbOfClips == 1) && m_bUnlimitedClip )
		{
			m_iCurrentNbOfClips--;
		}
		else
		{
			m_bEmptyAllClips=True;
			if ( R6Rainbow(Owner) != None )
			{
				m_iClipCapacity=5;
			}
		}
	}
	bFiredABullet=True;
	if ( pawnOwner.m_bIsProne && GotBipod() )
	{
		pawnOwner.UpdateBipodPosture();
	}
	else
	{
		pawnOwner.PlayWeaponAnimation();
	}
	m_fMaxAngleError=fMaxAngleErrorFromClient;
	iCurrentBullet=0;
JL00ED:
	if ( iCurrentBullet < NbBulletToShot() )
	{
		GetFiringDirection(vStartTrace,rBulletRot,iCurrentBullet);
		BulletManager.SpawnBullet(vStartTrace,rBulletRot,m_fMuzzleVelocity,iCurrentBullet == 0);
		iCurrentBullet++;
		goto JL00ED;
	}
	if ( pawnOwner != None )
	{
		R6AbstractGameInfo(Level.Game).IncrementRoundsFired(pawnOwner,False);
	}
	m_fCurrentFireJump += m_stAccuracyValues.fWeaponJump;
	if ( m_iNbBulletsInWeapon == 0 )
	{
		switch (m_eRateOfFire)
		{
/*			case 0:
			pawnOwner.PlayWeaponSound(7);
			break;
			case 1:
			case 2:
			if ( m_iNbOfRoundsInBurst == 1 )
			{
				pawnOwner.PlayWeaponSound(3);
			}
			break;
			default:     */
		}
	}
	else
	{
		if ( m_iNbOfRoundsInBurst == 1 )
		{
			switch (m_eRateOfFire)
			{
/*				case 0:
				pawnOwner.PlayWeaponSound(3);
				break;
				case 1:
				if ( m_iNbOfRoundsToShoot >= 3 )
				{
					pawnOwner.PlayWeaponSound(5);
				}
				else
				{
					pawnOwner.PlayWeaponSound(6);
				}
				break;
				case 2:
				pawnOwner.PlayWeaponSound(6);
				break;
				default:    */
			}
		}
	}
	ClientsFireBullet(m_iNbBulletsInWeapon);
	R6MakeNoise(SNDTYPE_Gunshot);
}

function ClientShowBulletFire ()
{
	local Vector vStartTrace;
	local Rotator rBulletRot;
	local R6Pawn pawnOwner;
	local R6PlayerController PlayerOwner;

	if ( Level.NetMode == NM_Client )
	{
		m_iNbOfRoundsInBurst++;
	}
	pawnOwner=R6Pawn(Owner);
	PlayerOwner=R6PlayerController(pawnOwner.Controller);
	if ( pawnOwner.m_bIsPlayer )
	{
		if ( (m_FPHands != None) && (m_iNbBulletsInWeapon > 0) )
		{
			if ( m_eRateOfFire == 0 )
			{
				m_FPHands.FireSingleShot();
			}
			else
			{
				if ( (m_eRateOfFire == 1) && (m_iNbOfRoundsInBurst == 1) )
				{
					m_FPHands.FireThreeShots();
				}
				else
				{
					if ( m_iNbOfRoundsInBurst == 1 )
					{
						m_FPHands.StartBurst();
					}
				}
			}
			m_FPWeapon.PlayFireAnim();
		}
		if ( Viewport(PlayerOwner.Player) != None )
		{
			if ( m_iNbBulletsInWeapon == 0 )
			{
				switch (m_eRateOfFire)
				{
/*					case 0:
					pawnOwner.PlayLocalWeaponSound(7);
					break;
					case 1:
					case 2:
					if ( m_iNbOfRoundsInBurst == 1 )
					{
						pawnOwner.PlayLocalWeaponSound(3);
					}
					break;
					default:     */
				}
			}
			else
			{
				if ( m_iNbOfRoundsInBurst == 1 )
				{
					switch (m_eRateOfFire)
					{
/*						case 0:
						pawnOwner.PlayLocalWeaponSound(3);
						break;
						case 1:
						if ( m_iNbOfRoundsToShoot >= 3 )
						{
							pawnOwner.PlayLocalWeaponSound(5);
						}
						else
						{
							pawnOwner.PlayLocalWeaponSound(6);
						}
						break;
						case 2:
						pawnOwner.PlayLocalWeaponSound(6);
						break;
						default:    */
					}
				}
			}
		}
	}
	if ( Role != 4 )
	{
		GetFiringDirection(vStartTrace,rBulletRot);
	}
	if ( PlayerOwner != None )
	{
		PlayerOwner.R6WeaponShake();
	}
}

function ClientsFireBullet (byte iBulletNbFired)
{
	local R6Pawn pawnOwner;
	local R6PlayerController PlayerOwner;

	pawnOwner=R6Pawn(Owner);
	PlayerOwner=R6PlayerController(pawnOwner.Controller);
	m_iNbBulletsInWeapon=iBulletNbFired;
	if ( pawnOwner.m_bIsPlayer )
	{
		if ( m_FPHands != None )
		{
			if ( IsLMG() == True )
			{
				if ( m_iNbBulletsInWeapon < 8 )
				{
					m_FPWeapon.HideBullet(m_iNbBulletsInWeapon);
				}
			}
			if ( iBulletNbFired == 0 )
			{
				m_FPHands.FireLastBullet();
				m_FPWeapon.PlayFireLastAnim();
			}
		}
	}
}

state NormalFire
{
	ignores  SetNextRateOfFire;

	function Fire (float Value)
	{
		if ( m_bFireOn == False )
		{
			StartFiring();
		}
	}

	function AltFire (float Value)
	{
	}

	function StopAltFire ()
	{
	}

	function PlayReloading ()
	{
		R6Pawn(Owner).ServerSwitchReloadingWeapon(False);
	}

	function EndState ()
	{
		R6Pawn(Owner).m_bIsFiringState=False;
		if ( m_bFireOn == True )
		{
			m_bFireOn=False;
			SetTimer(0.00,False);
			ServerStopFire(True);
		}
		Pawn(Owner).Controller.m_bLockWeaponActions=False;
	}

	simulated function FirstPersonAnimOver ()
	{
		m_FPHands.StartTimer();
		if (  !R6GameReplicationInfo(R6PlayerController(Pawn(Owner).Controller).GameReplicationInfo).m_bGameOverRep && (Pawn(Owner).Controller.bFire == 1) && (m_eRateOfFire == 2) )
		{
			ServerStopFire(True);
			StartFiring();
			return;
		}
		else
		{
			GotoState('None');
		}
	}

	simulated function BeginState ()
	{
		Pawn(Owner).Controller.m_bLockWeaponActions=True;
		R6Pawn(Owner).m_bIsFiringState=True;
		StartFiring();
	}

	simulated function StartFiring ()
	{
		m_iNbOfRoundsToShoot=GetNbOfRoundsForROF();
		ServerStartFiring();
		ClientStartFiring();
		if ( R6PlayerController(Pawn(Owner).Controller) != None )
		{
			R6PlayerController(Pawn(Owner).Controller).ResetCameraShake();
		}
		if ( m_iNbOfRoundsToShoot != 0 )
		{
			if ( m_FPHands != None )
			{
				m_FPHands.GotoState('FiringWeapon');
			}
			DoSingleFire();
			if ( m_iNbOfRoundsToShoot != 0 )
			{
				SetTimer(m_fRateOfFire,True);
				m_bFireOn=True;
			}
			else
			{
				if ( m_FPHands == None )
				{
					GotoState('None');
				}
			}
		}
		else
		{
			if ( m_FPHands.HasAnim('FireEmpty') )
			{
				m_FPHands.PlayAnim('FireEmpty');
			}
			GotoState('None');
		}
	}

	simulated function Timer ()
	{
		m_iNbOfRoundsToShoot--;
		if ( (m_iNbOfRoundsToShoot > 0) && ((m_eRateOfFire == 1) || (Pawn(Owner).Controller.bFire == 1)) )
		{
			DoSingleFire();
		}
		else
		{
			m_bFireOn=False;
			SetTimer(0.00,False);
			StopFire(False);
		}
	}

	function DoSingleFire ()
	{
		ServerFireBullet(m_fMaxAngleError);
		ClientShowBulletFire();
	}

}

function FullCurrentClip ()
{
	m_iNbBulletsInWeapon=m_iClipCapacity;
}

function ClientStartChangeClip ()
{
	if ( R6Pawn(Owner).m_bIsPlayer )
	{
		if ( m_iNbBulletsInWeapon <= 0 )
		{
//			R6Pawn(Owner).PlayLocalWeaponSound(8);
		}
		else
		{
//			R6Pawn(Owner).PlayLocalWeaponSound(9);
		}
	}
}

function ServerStartChangeClip ()
{
	if ( m_iNbBulletsInWeapon <= 0 )
	{
//		R6Pawn(Owner).PlayWeaponSound(8);
	}
	else
	{
//		R6Pawn(Owner).PlayWeaponSound(9);
	}
}

function ServerChangeClip ()
{
	local int i;
	local int iClipNumber;
	local int iMostFullClip;
	local int iMaxNbOfRounds;
	local int iBulletLeftInWeapon;

	R6MakeNoise(SNDTYPE_Reload);
	if ( m_bUnlimitedClip && (GetNbOfClips() == 1) && (m_bEmptyAllClips == True) )
	{
		m_iNbBulletsInWeapon=m_iClipCapacity;
	}
	else
	{
		m_aiNbOfBullets[m_iCurrentClip]=m_iNbBulletsInWeapon;
		if ( m_aiNbOfBullets[m_iCurrentClip] == 0 )
		{
			iBulletLeftInWeapon=0;
		}
		else
		{
			if (  !IsPumpShotGun() )
			{
				if ( IsLMG() )
				{
					if ( (m_aiNbOfBullets[m_iCurrentClip] < 8) && (m_iCurrentNbOfClips != 1) )
					{
						m_aiNbOfBullets[m_iCurrentClip]=0;
						m_iCurrentNbOfClips--;
						iBulletLeftInWeapon=0;
					}
				}
				else
				{
					m_aiNbOfBullets[m_iCurrentClip] -= 1;
					if ( m_aiNbOfBullets[m_iCurrentClip] == 0 )
					{
						if ( m_iCurrentNbOfClips != 1 )
						{
							m_iCurrentNbOfClips--;
						}
					}
					iBulletLeftInWeapon=1;
				}
			}
		}
		iMostFullClip=m_iCurrentClip;
		i=0;
JL010D:
		if ( i < m_iNbOfClips )
		{
			iClipNumber=m_iCurrentClip + i;
			if ( iClipNumber >= m_iNbOfClips )
			{
				iClipNumber -= m_iNbOfClips;
			}
			if ( m_aiNbOfBullets[iClipNumber] > iMaxNbOfRounds )
			{
				iMaxNbOfRounds=m_aiNbOfBullets[iClipNumber];
				iMostFullClip=iClipNumber;
			}
			i++;
			goto JL010D;
		}
		m_iCurrentClip=iMostFullClip;
		m_aiNbOfBullets[m_iCurrentClip] += iBulletLeftInWeapon;
		m_iNbBulletsInWeapon=m_aiNbOfBullets[m_iCurrentClip];
	}
	R6Pawn(Owner).ServerSwitchReloadingWeapon(False);
}

simulated function PlayReloading ()
{
	GotoState('Reloading');
}

simulated function WeaponZoomSound (bool bFirstZoom)
{
	if ( bFirstZoom )
	{
		if ( m_SniperZoomFirstSnd != None )
		{
//			Owner.PlaySound(m_SniperZoomFirstSnd,2);
		}
		else
		{
			if ( m_CommonWeaponZoomSnd != None )
			{
//				Owner.PlaySound(m_CommonWeaponZoomSnd,2);
			}
		}
	}
	else
	{
		if ( m_SniperZoomSecondSnd != None )
		{
//			Owner.PlaySound(m_SniperZoomSecondSnd,2);
		}
	}
}

state Reloading
{
	ignores  SetNextRateOfFire;

	function Fire (float Value)
	{
	}

	function AltFire (float Value)
	{
	}

	function StopAltFire ()
	{
	}

	function PlayReloading ()
	{
	}

	function FirstPersonAnimOver ()
	{
		local Pawn pawnOwner;

		pawnOwner=Pawn(Owner);
		if ( pawnOwner.Controller != None )
		{
			R6Pawn(Owner).ServerSwitchReloadingWeapon(False);
		}
		ServerChangeClip();
		if ( (pawnOwner.Controller != None) && (pawnOwner.Controller.bFire == 1) )
		{
			GotoState('NormalFire');
		}
		else
		{
			GotoState('None');
		}
	}

	simulated function ChangeClip ()
	{
		R6Pawn(Owner).ServerSwitchReloadingWeapon(False);
		ServerChangeClip();
		if ( Pawn(Owner).Controller.bFire == 1 )
		{
			GotoState('NormalFire');
		}
		else
		{
			GotoState('None');
		}
	}

	function EndState ()
	{
		local R6PlayerController PlayerCtrl;

		PlayerCtrl=R6PlayerController(Pawn(Owner).Controller);
		if ( PlayerCtrl != None )
		{
			PlayerCtrl.m_iPlayerCAProgress=0;
			PlayerCtrl.m_bHideReticule=False;
			PlayerCtrl.m_bLockWeaponActions=False;
		}
		R6Pawn(Owner).ServerSwitchReloadingWeapon(False);
	}

	simulated function BeginState ()
	{
		local R6PlayerController PlayerCtrl;

		PlayerCtrl=R6PlayerController(Pawn(Owner).Controller);
		if ( (GetNbOfClips() > 0) || (Level.NetMode != 0) && (m_eWeaponType == 0) )
		{
			if ( PlayerCtrl != None )
			{
				PlayerCtrl.m_bLockWeaponActions=True;
			}
			ServerStartChangeClip();
			ClientStartChangeClip();
			if ( R6Pawn(Owner).m_bIsPlayer )
			{
				if ( PlayerCtrl.bBehindView == False )
				{
					if ( m_iNbBulletsInWeapon <= 0 )
					{
						m_FPHands.m_bReloadEmpty=True;
					}
					m_FPHands.GotoState('Reloading');
					PlayerCtrl.m_iPlayerCAProgress=0;
					PlayerCtrl.m_bHideReticule=True;
				}
			}
		}
		else
		{
			GotoState('None');
		}
	}

	function int GetReloadProgress ()
	{
		local name Anim;
		local float fFrame;
		local float fRate;

		m_FPHands.GetAnimParams(0,Anim,fFrame,fRate);
		return fFrame * 110;
	}

	event Tick (float fDeltaTime)
	{
		local R6PlayerController PlayerCtrl;

		PlayerCtrl=R6PlayerController(Pawn(Owner).Controller);
		if ( (PlayerCtrl != None) &&  !PlayerCtrl.ShouldDrawWeapon() )
		{
			PlayerCtrl.m_iPlayerCAProgress=GetReloadProgress();
		}
	}

}

state DiscardWeapon
{
	function Fire (float Value)
	{
	}

	function AltFire (float Value)
	{
	}

	function StopFire (optional bool bSoundOnly)
	{
	}

	function StopAltFire ()
	{
	}

	function PlayReloading ()
	{
	}

	function FirstPersonAnimOver ()
	{
		if ( Pawn(Owner).Controller != None )
		{
			R6PlayerController(Pawn(Owner).Controller).WeaponUpState();
		}
	}

	simulated function BeginState ()
	{
		local R6PlayerController PlayerCtrl;

		PlayerCtrl=R6PlayerController(Pawn(Owner).Controller);
		if ( m_FPHands != None )
		{
			if ( PlayerCtrl != None )
			{
				PlayerCtrl.m_bHideReticule=True;
			}
			m_FPHands.GotoState('DiscardWeapon');
		}
		if ( PlayerCtrl != None )
		{
			PlayerCtrl.m_bLockWeaponActions=True;
		}
	}

	simulated function EndState ()
	{
	}

}

state RaiseWeapon
{
	function Fire (float Value)
	{
	}

	function AltFire (float Value)
	{
	}

	function StopFire (optional bool bSoundOnly)
	{
	}

	function StopAltFire ()
	{
	}

	function PlayReloading ()
	{
	}

	function EndState ()
	{
		local R6PlayerController PlayerCtrl;
		local R6Rainbow RainbowPawn;

		RainbowPawn=R6Rainbow(Owner);
		PlayerCtrl=R6PlayerController(RainbowPawn.Controller);
		RainbowPawn.AttachWeapon(self,m_AttachPoint);
		if ( PlayerCtrl != None )
		{
			PlayerCtrl.m_bHideReticule=False;
			PlayerCtrl.m_bLockWeaponActions=False;
		}
		RainbowPawn.m_fWeaponJump=m_stAccuracyValues.fWeaponJump;
		RainbowPawn.m_fZoomJumpReturn=1.00;
	}

	function FirstPersonAnimOver ()
	{
		if ( Pawn(Owner).Controller != None )
		{
			R6PlayerController(Pawn(Owner).Controller).ServerWeaponUpAnimDone();
		}
		R6Pawn(Owner).m_bChangingWeapon=False;
		if ( (Pawn(Owner).Controller != None) && (Pawn(Owner).Controller.bFire == 1) )
		{
			GotoState('NormalFire');
		}
		else
		{
			GotoState('None');
		}
	}

	simulated function BeginState ()
	{
		TurnOffEmitters(False);
		if ( m_FPHands != None )
		{
			if ( m_bPawnIsWalking == True )
			{
				m_FPHands.PlayWalkingAnimation();
			}
			else
			{
				m_FPHands.StopWalkingAnimation();
			}
			if ( m_FPHands.IsInState('RaiseWeapon') )
			{
				m_FPHands.BeginState();
			}
			else
			{
				m_FPHands.GotoState('RaiseWeapon');
			}
		}
	}

}

state PutWeaponDown
{
	function Fire (float Value)
	{
	}

	function AltFire (float Value)
	{
	}

	function StopFire (optional bool bSoundOnly)
	{
	}

	function StopAltFire ()
	{
	}

	function PlayReloading ()
	{
	}

	function FirstPersonAnimOver ()
	{
	}

	simulated function BeginState ()
	{
		if ( m_FPHands != None )
		{
			if ( m_FPHands.IsInState('FiringWeapon') )
			{
				GotoState('None');
				return;
			}
			m_FPHands.GotoState('PutWeaponDown');
		}
		if ( Pawn(Owner).Controller != None )
		{
			Pawn(Owner).Controller.m_bLockWeaponActions=True;
		}
	}

}

state BringWeaponUp
{
	function Fire (float Value)
	{
	}

	function AltFire (float Value)
	{
	}

	function StopFire (optional bool bSoundOnly)
	{
	}

	function StopAltFire ()
	{
	}

	function PlayReloading ()
	{
	}

	function FirstPersonAnimOver ()
	{
		if ( (Pawn(Owner).Controller != None) && (Pawn(Owner).Controller.bFire == 1) )
		{
			GotoState('NormalFire');
		}
		else
		{
			GotoState('None');
		}
	}

	simulated function BeginState ()
	{
		if ( m_FPHands != None )
		{
			m_FPHands.GotoState('BringWeaponUp');
		}
		else
		{
			FirstPersonAnimOver();
		}
	}

	simulated function EndState ()
	{
		if ( Pawn(Owner).Controller != None )
		{
			Pawn(Owner).Controller.m_bHideReticule=False;
			Pawn(Owner).Controller.m_bLockWeaponActions=False;
		}
	}

}

state DeployBipod
{
	function Fire (float Value)
	{
	}

	function AltFire (float Value)
	{
	}

	function StopAltFire ()
	{
	}

	function PlayReloading ()
	{
	}

	function FirstPersonAnimOver ()
	{
		if ( (Pawn(Owner).Controller != None) && (Pawn(Owner).Controller.bFire == 1) )
		{
			GotoState('NormalFire');
		}
		else
		{
			GotoState('None');
		}
	}

	simulated function BeginState ()
	{
		if ( m_FPHands != None )
		{
			m_FPHands.GotoState('DeployBipod');
		}
	}

	function EndState ()
	{
	}

}

state CloseBipod
{
	function Fire (float Value)
	{
	}

	function AltFire (float Value)
	{
	}

	function StopAltFire ()
	{
	}

	function PlayReloading ()
	{
	}

	function FirstPersonAnimOver ()
	{
		if ( (Pawn(Owner).Controller != None) && (Pawn(Owner).Controller.bFire == 1) )
		{
			GotoState('NormalFire');
		}
		else
		{
			GotoState('None');
		}
	}

	simulated function BeginState ()
	{
		if ( m_FPHands != None )
		{
			m_FPHands.GotoState('CloseBipod');
		}
	}

}

simulated event DeployWeaponBipod (bool bBipodOpen)
{
	if ( m_BipodGadget != None )
	{
		m_BipodGadget.Toggle3rdBipod(bBipodOpen);
	}
}

state ZoomIn
{
	function Fire (float Value)
	{
	}

	function AltFire (float Value)
	{
	}

	function StopAltFire ()
	{
	}

	function PlayReloading ()
	{
	}

	function FirstPersonAnimOver ()
	{
		local Pawn pawnOwner;

		pawnOwner=Pawn(Owner);
		if ( pawnOwner.Controller != None )
		{
			R6PlayerController(pawnOwner.Controller).DoZoom();
		}
		if ( (pawnOwner.Controller != None) && (pawnOwner.Controller.bFire == 1) )
		{
			GotoState('NormalFire');
		}
		else
		{
			GotoState('None');
		}
	}

	simulated function BeginState ()
	{
		Pawn(Owner).Controller.m_bLockWeaponActions=True;
		WeaponZoomSound(True);
		if ( m_FPHands != None )
		{
			m_FPHands.GotoState('ZoomIn');
		}
	}

	simulated function EndState ()
	{
		Pawn(Owner).Controller.m_bLockWeaponActions=False;
	}

}

state ZoomOut
{
	function FirstPersonAnimOver ()
	{
		if ( (Pawn(Owner).Controller != None) && (Pawn(Owner).Controller.bFire == 1) )
		{
			GotoState('NormalFire');
		}
		else
		{
			GotoState('None');
		}
	}

	simulated function BeginState ()
	{
		if ( m_FPHands != None )
		{
			m_FPHands.GotoState('ZoomOut');
		}
	}

}

function FullAmmo ()
{
	local int iClip;

	if ( Level.NetMode != 0 )
	{
		return;
	}
	m_iNbBulletsInWeapon=250;
	iClip=0;
JL002A:
	if ( iClip < C_iMaxNbOfClips )
	{
		m_aiNbOfBullets[iClip]=250;
		iClip++;
		goto JL002A;
	}
	m_iCurrentClip=0;
	m_iCurrentNbOfClips=C_iMaxNbOfClips;
}

function PerfectAim ()
{
	m_stAccuracyValues.fAccuracyChange=0.00;
	m_stAccuracyValues.fReticuleTime=0.10;
	m_stAccuracyValues.fRunningAccuracy=0.00;
	m_stAccuracyValues.fShuffleAccuracy=0.00;
	m_stAccuracyValues.fWalkingAccuracy=0.00;
	m_stAccuracyValues.fWalkingFastAccuracy=0.00;
}

function GiveBulletToWeapon (string aBulletName)
{
	local Class<R6Bullet> aBulletClass;

	aBulletClass=Class<R6Bullet>(DynamicLoadObject(aBulletName,Class'Class'));
	if ( aBulletClass != None )
	{
		m_pBulletClass=aBulletClass;
	}
}

function bool HasBulletType (name strBulletName)
{
	if ( m_pBulletClass == None )
	{
		return False;
	}
	return strBulletName == m_pBulletClass.Name;
}

function Texture Get2DIcon ()
{
	return m_WeaponIcon;
}

function bool AffectActor (int BulletGroup, Actor ActorAffected)
{
	return GetBulletManager().AffectActor(BulletGroup,ActorAffected);
}

simulated function R6SetGadget (Class<R6AbstractGadget> pWeaponGadgetClass)
{
	local R6AbstractGadget SelectedWeaponGadget;

	if ( pWeaponGadgetClass == None )
	{
		m_SelectedWeaponGadget=None;
	}
	else
	{
		switch (pWeaponGadgetClass.Default.m_eGadgetType)
		{
/*			case 1:
			if ( m_ScopeGadget != None )
			{
				return;
			}
			break;
			case 2:
			if ( m_MagazineGadget != None )
			{
				return;
			}
			break;
			case 3:
			if ( m_BipodGadget != None )
			{
				return;
			}
			break;
			case 4:
			if ( m_MuzzleGadget != None )
			{
				return;
			}
			break;
			default:
			if ( m_SelectedWeaponGadget != None )
			{
				return;
			}
			break;   */
		}
		SelectedWeaponGadget=Spawn(pWeaponGadgetClass);
		if ( SelectedWeaponGadget != None )
		{
			SelectedWeaponGadget.InitGadget(self,Pawn(Owner));
			switch (SelectedWeaponGadget.m_eGadgetType)
			{
/*				case 1:
				m_ScopeGadget=SelectedWeaponGadget;
				break;
				case 2:
				m_MagazineGadget=SelectedWeaponGadget;
				break;
				case 3:
				m_BipodGadget=SelectedWeaponGadget;
				break;
				case 4:
				m_MuzzleGadget=SelectedWeaponGadget;
				break;
				default:      */
			}
			m_SelectedWeaponGadget=SelectedWeaponGadget;
		}
		else
		{
		}
	}
}

function float GetExplosionDelay ()
{
	return 0.00;
}

function int NbBulletToShot ()
{
	return 1;
}

simulated event UpdateWeaponAttachment ()
{
	local Vector vTagLocation;
	local Rotator rTagRotator;

	SetGadgets();
}

function SetRelevant (bool bNewAlwaysRelevant)
{
	bAlwaysRelevant=bNewAlwaysRelevant;
	if ( m_MagazineGadget != None )
	{
		m_MagazineGadget.bAlwaysRelevant=bAlwaysRelevant;
	}
	if ( m_SelectedWeaponGadget != None )
	{
		m_SelectedWeaponGadget.bAlwaysRelevant=bAlwaysRelevant;
	}
	if ( m_ScopeGadget != None )
	{
		m_ScopeGadget.bAlwaysRelevant=bAlwaysRelevant;
	}
	if ( m_BipodGadget != None )
	{
		m_BipodGadget.bAlwaysRelevant=bAlwaysRelevant;
	}
	if ( m_MuzzleGadget != None )
	{
		m_MuzzleGadget.bAlwaysRelevant=bAlwaysRelevant;
	}
}

function SetTearOff (bool bNewTearOff)
{
	bTearOff=bNewTearOff;
	if ( m_MagazineGadget != None )
	{
		m_MagazineGadget.bTearOff=bTearOff;
	}
	if ( m_SelectedWeaponGadget != None )
	{
		m_SelectedWeaponGadget.bTearOff=bTearOff;
	}
	if ( m_ScopeGadget != None )
	{
		m_ScopeGadget.bTearOff=bTearOff;
	}
	if ( m_BipodGadget != None )
	{
		m_BipodGadget.bTearOff=bTearOff;
	}
	if ( m_MuzzleGadget != None )
	{
		m_MuzzleGadget.bTearOff=bTearOff;
	}
}

simulated function HitWall (Vector HitNormal, Actor Wall)
{
	m_wNbOfBounce++;
	RotationRate.Pitch=0;
	RotationRate.Yaw=RandRange(-65535.00,65535.00);
	RotationRate.Roll=RandRange(-65535.00,65535.00);
	if ( HitNormal.Z < 0.10 )
	{
		Velocity=0.75 * VSize(Velocity) * HitNormal;
	}
	else
	{
		Velocity=0.15 * MirrorVectorByNormal(Velocity,HitNormal);
		Velocity.Z *= 2;
		if ( VSize(Velocity) < 10 )
		{
			if ( CheckForPlaceToFall() )
			{
				return;
			}
			else
			{
				StopFallingAndSetCorrectRotation();
			}
		}
	}
	if ( m_wNbOfBounce > 20 )
	{
		PutAtOwnerFeet();
	}
}

simulated function bool CheckForPlaceToFall ()
{
	local Vector vNewLocation;
	local Vector vHitLocation;
	local Vector vNormal;
	local Actor aTraced;

	vNewLocation=Location - vect(0.00,0.00,10.00);
	aTraced=R6Trace(vHitLocation,vNormal,vNewLocation,Location,0);
	if ( aTraced == None )
	{
		if ( FindSpot(vNewLocation) )
		{
			if ( vNewLocation != Location )
			{
				SetLocation(vNewLocation);
				return True;
			}
		}
		else
		{
			vNewLocation=m_vPawnLocWhenKilled;
			vNewLocation.Z=Location.Z - 10;
			if ( FindSpot(vNewLocation) )
			{
				if ( vNewLocation != Location )
				{
					SetLocation(vNewLocation);
					return True;
				}
			}
		}
	}
	return False;
}

simulated function StopFallingAndSetCorrectRotation ()
{
	SetPhysics(PHYS_Rotating);
	bBounce=False;
	bRotateToDesired=True;
	DesiredRotation.Yaw=Rotation.Yaw;
	if ( Abs(Rotation.Roll - 13384) > Abs(Rotation.Roll - 49151) )
	{
		DesiredRotation.Roll=49151;
	}
	else
	{
		DesiredRotation.Roll=13384;
	}
	if ( DesiredRotation.Roll < Rotation.Roll )
	{
		RotationRate=rot(0,0,-100000);
	}
	else
	{
		RotationRate=rot(0,0,100000);
	}
}

simulated function PutAtOwnerFeet ()
{
	SetLocation(m_vPawnLocWhenKilled,True);
	StopFallingAndSetCorrectRotation();
}

simulated function StartFalling ()
{
	local Vector vLocation;
	local Vector vDir;
	local Rotator rRot;

	if ( Owner != None )
	{
		m_vPawnLocWhenKilled=Owner.Location;
		m_vPawnLocWhenKilled.Z -= Owner.CollisionHeight;
		Owner.DetachFromBone(self);
	}
	else
	{
		m_vPawnLocWhenKilled=Location;
	}
	m_iNbParticlesToCreate=0;
	GotoState('None');
	SetCollisionSize(35.00,5.00);
	vLocation=Location;
	m_bLightingVisibility=True;
	if ( FindSpot(vLocation) )
	{
		SetLocation(vLocation);
		SetCollision(True,False,False);
		bCollideWorld=True;
		bBounce=True;
		Enable('HitWall');
		SetPhysics(PHYS_Falling);
		vDir=vector(Rotation);
		vDir.X += RandRange(-0.40,0.40);
		vDir.Y += RandRange(-0.40,0.40);
		vDir *= RandRange(100.00,400.00);
		vDir.Z=-600.00;
		Acceleration=vDir;
		bFixedRotationDir=True;
		RotationRate.Pitch=0;
		RotationRate.Yaw=RandRange(-65535.00,65535.00);
		RotationRate.Roll=RandRange(-65535.00,65535.00);
		rRot=Rotation;
		rRot.Pitch=0;
		SetRotation(rRot);
	}
	else
	{
		PutAtOwnerFeet();
	}
}

function bool CanSwitchToWeapon ()
{
	return True;
}

simulated event ShowWeaponParticules (EWeaponSound EWeaponSound)
{
	m_fTimeDisplayParticule=Level.TimeSeconds;
	switch (EWeaponSound)
	{
/*		case 7:
		case 3:
		m_iNbParticlesToCreate=1;
		break;
		case 5:
		m_iNbParticlesToCreate=Min(3,m_iNbBulletsInWeapon);
		break;
		case 6:
		m_iNbParticlesToCreate=m_iNbBulletsInWeapon;
		break;
		default:
		m_iNbParticlesToCreate=0;
		break;     */
	}
}

function SetAccuracyOnHit ()
{
	m_fEffectiveAccuracy=m_stAccuracyValues.fRunningAccuracy;
}

defaultproperties
{
    C_iMaxNbOfClips=20
    m_iClipCapacity=9999
    m_iNbOfClips=1
    m_bPlayLoopingSound=True
    m_fMuzzleVelocity=10000.00
    m_fStablePercentage=0.50
    m_fFireSoundRadius=700.00
    m_fRateOfFire=0.10
    m_fDisplayFOV=80.00
    m_pWithWeaponReticuleClass=Class'R6WithWeaponReticule'
    m_stAccuracyValues=(fBaseAccuracy=0.00,fShuffleAccuracy=11.98,fWalkingAccuracy=0.00,fWalkingFastAccuracy=0.00,fRunningAccuracy=0.00,fReticuleTime=0.00,fAccuracyChange=6.70,fWeaponJump=0.00)
    m_PawnWaitAnimLow=StandSubGunLow_nt
    m_PawnWaitAnimHigh=StandSubGunHigh_nt
    m_PawnWaitAnimProne=ProneSubGun_nt
    m_PawnFiringAnim=StandFireSubGun
    m_PawnFiringAnimProne=ProneFireSubGun
    m_PawnReloadAnim=StandReloadSubGun
    m_PawnReloadAnimTactical=StandTacReloadSubGun
    m_PawnReloadAnimProne=ProneReloadSubGun
    m_PawnReloadAnimProneTactical=ProneTacReloadSubGun
    DrawType=8
    bReplicateInstigator=True
    bSkipActorPropertyReplication=True
    m_bForceBaseReplication=True
    m_bDeleteOnReset=True
    m_fSoundRadiusActivation=5600.00
    DrawScale3D=(X=-1.00,Y=-1.00,Z=1.00)
}
/*
    StaticMesh=StaticMesh'RedWeaponStaticMesh'
    m_ScopeAdd=Texture'Inventory_t.Scope.ScopeBlurTexAdd'
    m_CommonWeaponZoomSnd=Sound'CommonWeapons.Play_WeaponZoom'
    m_WeaponIcon=Texture'R6WeaponsIcons.Icons.IconTest'
*/

