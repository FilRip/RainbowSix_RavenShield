//================================================================================
// R6DemolitionsGadget.
//================================================================================
class R6DemolitionsGadget extends R6Gadget
	Native
	Abstract;

var bool m_bDetonated;
var bool m_bChargeInPosition;
var bool m_bCanPlaceCharge;
var bool m_bInstallingCharge;
var bool m_bCancelChargeInstallation;
var bool m_bRaiseWeapon;
var bool m_bHide;
var bool m_bDetonator;
var R6Reticule m_ReticuleConfirm;
var R6Reticule m_ReticuleBlock;
var R6Reticule m_ReticuleDetonator;
var StaticMesh m_DetonatorStaticMesh;
var Texture m_DetonatorTexture;
var StaticMesh m_ChargeStaticMesh;
var R6Grenade BulletActor;
var name m_ChargeAttachPoint;
var name m_DetonatorAttachPoint;
var Class<Emitter> m_pExplosionParticles;
var Class<R6Reticule> m_pReticuleBlockClass;
var Class<R6Reticule> m_pDetonatorReticuleClass;
var Vector m_vLocation;

replication
{
	unreliable if ( Role < Role_Authority )
		ServerCancelChargeInstallation,ServerGotoSetExplosive;
	unreliable if ( Role == Role_Authority )
		ClientMyUnitIsDestroyed;
	reliable if ( Role == Role_Authority )
		m_bHide,m_bDetonator,BulletActor;
}

event NbBulletChange ();

function MyUnitIsDestroyed ()
{
	if ( m_iNbBulletsInWeapon == 0 )
	{
		m_bHide=True;
	}
	else
	{
		m_bHide=False;
	}
	m_bDetonator=False;
	ClientMyUnitIsDestroyed();
}

simulated function ClientMyUnitIsDestroyed ()
{
	m_bDetonated=False;
	m_bRaiseWeapon=False;
	m_bChargeInPosition=False;
	BulletActor.m_bDestroyedByImpact=True;
	if ( IsInState('ChargeArmed') )
	{
		R6Pawn(Owner).m_bIsFiringState=False;
		if ( m_FPHands != None )
		{
			m_FPHands.GotoState('DiscardWeapon');
		}
		if ( m_iNbBulletsInWeapon <= 0 )
		{
			GotoState('NoChargesLeft');
		}
		else
		{
			GotoState('GetNextCharge');
		}
	}
	else
	{
		if ( m_iNbBulletsInWeapon > 0 )
		{
			if ( m_FPHands != None )
			{
				SetAmmoStaticMesh();
				SwitchToChargeHandAnimations();
			}
		}
	}
}

simulated function UpdateHands ()
{
	if ( m_bChargeInPosition == True )
	{
		m_FPWeapon.m_smGun.SetStaticMesh(m_DetonatorStaticMesh);
		SwitchToDetonatorHandAnimations();
	}
	else
	{
		SetAmmoStaticMesh();
		SwitchToChargeHandAnimations();
	}
}

event PostBeginPlay ()
{
	Super.PostBeginPlay();
	SetGadgetStaticMesh();
}

simulated function PostNetBeginPlay ()
{
	Super.PostNetBeginPlay();
	SetGadgetStaticMesh();
}

simulated function ServerPlaceCharge (Vector vLocation)
{
	local Rotator rDesiredRotation;

	if ( m_iNbBulletsInWeapon == 0 )
	{
		return;
	}
	m_iNbBulletsInWeapon--;
	m_bDetonator=True;
	rDesiredRotation=Pawn(Owner).GetViewRotation();
	rDesiredRotation.Pitch=0;
	rDesiredRotation.Yaw += 32768;
	BulletActor=R6Grenade(Spawn(m_pBulletClass,self));
	if ( bShowLog )
	{
		Log("R6DemolitionsGadget :: ServerPlaceCharge() " $ string(BulletActor) $ " rDesiredRotation=" $ string(rDesiredRotation) $ " vLocation=" $ string(vLocation));
	}
	BulletActor.SetLocation(vLocation + vect(0.00,0.00,10.00));
//	BulletActor.SetRotation(rDesiredRotation);
	BulletActor.m_Weapon=self;
	BulletActor.Instigator=Pawn(Owner);
	BulletActor.SetSpeed(0.00);
	m_AttachPoint=m_DetonatorAttachPoint;
	SetStaticMesh(Default.StaticMesh);
	Pawn(Owner).AttachToBone(self,m_AttachPoint);
}

function ServerPlaceChargeAnimation ();

function PlaceChargeAnimation ();

function Activate ();

function SetAmmoStaticMesh ();

function ServerDetonate ()
{
	if ( m_iNbBulletsInWeapon == 0 )
	{
		m_bHide=True;
	}
	m_bDetonator=False;
	if ( bShowLog )
	{
		Log(" Explode() BulletActor=" $ string(BulletActor));
	}
	BulletActor.Explode();
	BulletActor.Destroy();
}

function Fire (float fValue)
{
	if ( bShowLog )
	{
		Log("(R6DemolitionsGadget) WEAPON - R6Weapons.NoState::Fire(" $ string(fValue) $ ") for weapon " $ string(self));
	}
	if ( Pawn(Owner).Controller.m_bLockWeaponActions == True )
	{
		return;
	}
	m_FPHands.StopTimer();
	if ( m_bChargeInPosition )
	{
		m_bDetonated=False;
		GotoState('ChargeArmed');
	}
	else
	{
		GotoState('ChargeReady');
	}
}

function StopFire (optional bool bSoundOnly)
{
}

function AltFire (float fValue)
{
}

function StopAltFire ()
{
}

simulated function bool LoadFirstPersonWeapon (optional Pawn NetOwner, optional Controller LocalPlayerController)
{
	Super.LoadFirstPersonWeapon(NetOwner,LocalPlayerController);
	if ( m_bChargeInPosition == True )
	{
		SwitchToDetonatorHandAnimations();
		m_FPWeapon.m_smGun.SetStaticMesh(m_DetonatorStaticMesh);
	}
	return True;
}

function StartLoopingAnims ()
{
	if ( m_FPHands != None )
	{
		m_FPHands.SetDrawType(DT_Mesh);
		m_FPHands.GotoState('Waiting');
	}
}

function SwitchToDetonatorHandAnimations ()
{
	m_FPHands.UnLinkSkelAnim();
//	m_FPHands.LinkSkelAnim(MeshAnimation'R61stHandsGripDetonatorA');
}

function SwitchToChargeHandAnimations ()
{
	m_FPHands.UnLinkSkelAnim();
//	m_FPHands.LinkSkelAnim(MeshAnimation'R61stHandsGripBreachA');
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

	simulated function EndState ()
	{
		Pawn(Owner).Controller.m_bHideReticule=False;
		Pawn(Owner).Controller.m_bLockWeaponActions=False;
	}

	simulated function FirstPersonAnimOver ()
	{
		if ( bShowLog )
		{
			Log("FirstPersonAnimOver()  R6DemolitionsGadget");
		}
		R6PlayerController(Pawn(Owner).Controller).ServerWeaponUpAnimDone();
		if ( m_bChargeInPosition )
		{
			m_bDetonated=False;
			GotoState('ChargeArmed');
		}
		else
		{
			GotoState('ChargeReady');
		}
	}

	simulated function BeginState ()
	{
		if ( bShowLog )
		{
			Log("WEAPON - BeginState of RaiseWeapon for " $ string(self));
		}
		Pawn(Owner).Controller.m_bLockWeaponActions=True;
		if ( m_FPHands != None )
		{
			m_bRaiseWeapon=True;
			m_FPHands.GotoState('RaiseWeapon');
		}
	}

}

state ChargeReady
{
	function BeginState ()
	{
		Pawn(Owner).Controller.m_bLockWeaponActions=False;
		m_bRaiseWeapon=False;
		if ( bShowLog )
		{
			Log(string(self) $ " entered state ChargeReady...");
		}
		m_AttachPoint=m_ChargeAttachPoint;
		SetStaticMesh(m_ChargeStaticMesh);
		Pawn(Owner).AttachToBone(self,m_AttachPoint);
		m_bDetonated=False;
		if ( (Pawn(Owner).Controller.bFire == 1) && (CanPlaceCharge() == True) )
		{
			Fire(0.00);
		}
	}

	function EndState ()
	{
		if ( bShowLog )
		{
			Log(string(self) $ " exited state ChargeReady...");
		}
		SetTimer(0.00,False);
	}

	function Timer ()
	{
		local R6Pawn pawnOwner;
		local R6PlayerController PlayerCtrl;

		pawnOwner=R6Pawn(Owner);
		PlayerCtrl=R6PlayerController(pawnOwner.Controller);
		if (  !pawnOwner.m_bIsPlayer || pawnOwner.m_bPostureTransition ||  !m_bInstallingCharge )
		{
			return;
		}
		if ( bShowLog )
		{
			Log(string(self) $ " state ChargeReady : Timer() has expired " $ string(PlayerCtrl.m_bPlacedExplosive) $ " : " $ string(PlayerCtrl.GetStateName()));
		}
		if ( PlayerCtrl.m_bPlacedExplosive )
		{
			ServerPlaceCharge(m_vLocation);
			m_bChargeInPosition=True;
			m_bInstallingCharge=False;
			m_bRaiseWeapon=False;
			m_FPWeapon.m_smGun.SetStaticMesh(m_DetonatorStaticMesh);
			GotoState('ChargeArmed');
		}
	}

	function Fire (float fValue)
	{
		local R6PlayerController PlayerCtrl;

		PlayerCtrl=R6PlayerController(R6Pawn(Owner).Controller);
		if ( m_bChargeInPosition ||  !m_bCanPlaceCharge || (PlayerCtrl.m_bLockWeaponActions == True) )
		{
			return;
		}
		PlayerCtrl.DoZoom(True);
		PlayerCtrl.m_bLockWeaponActions=True;
		m_bInstallingCharge=True;
		HideReticule();
		if ( Level.NetMode == NM_Client )
		{
			ServerGotoSetExplosive();
		}
		PlayerCtrl.GotoState('PlayerSetExplosive');
		PlaceChargeAnimation();
		m_vLocation=PlayerCtrl.m_vDefaultLocation;
		if ( bShowLog )
		{
			Log(string(self) $ " state ChargeReady : Remote Charge has been placed at m_vLocation = " $ string(m_vLocation));
		}
		if ( m_FPHands != None )
		{
			m_FPHands.GotoState('DiscardWeapon');
		}
		SetTimer(0.10,True);
	}

	function FirstPersonAnimOver ()
	{
		if ( m_bCancelChargeInstallation == True )
		{
			m_bCancelChargeInstallation=False;
			Pawn(Owner).Controller.m_bLockWeaponActions=False;
			SetTimer(0.00,False);
		}
	}

}

state ChargeArmed
{
	function BeginState ()
	{
		if ( bShowLog )
		{
			Log(string(self) $ " state ChargeArmed : beginState() " $ string(m_bRaiseWeapon));
		}
		m_ReticuleInstance=m_ReticuleDetonator;
		Pawn(Owner).Controller.m_bHideReticule=False;
		if ( m_FPHands != None )
		{
			SwitchToDetonatorHandAnimations();
			if (  !m_bRaiseWeapon )
			{
				m_bRaiseWeapon=True;
				m_FPHands.GotoState('RaiseWeapon');
			}
			else
			{
				m_bRaiseWeapon=False;
			}
		}
		else
		{
			m_bRaiseWeapon=False;
		}
	}

	function EndState ()
	{
		if ( bShowLog )
		{
			Log(string(self) $ " state ChargeArmed : endState() " $ string(m_bDetonated) $ " : " $ string(m_bChargeInPosition));
		}
	}

	function FirstPersonAnimOver ()
	{
		if ( bShowLog )
		{
			Log("First person anim over " $ string(m_bRaiseWeapon));
		}
		if ( m_bRaiseWeapon )
		{
			Pawn(Owner).Controller.m_bLockWeaponActions=False;
			m_bRaiseWeapon=False;
			return;
		}
		else
		{
			if ( m_bDetonated )
			{
				if ( bShowLog )
				{
					Log(string(self) $ " state ChargeArmed : DETONATE CHARGE!!! # left :" $ string(m_iNbBulletsInWeapon));
				}
				ServerDetonate();
				m_bChargeInPosition=False;
				SetStaticMesh(None);
				R6Pawn(Owner).m_bIsFiringState=False;
				if ( m_iNbBulletsInWeapon <= 0 )
				{
					GotoState('NoChargesLeft');
				}
				else
				{
					GotoState('GetNextCharge');
				}
			}
		}
	}

	function Fire (float fValue)
	{
		if (  !m_bRaiseWeapon )
		{
			if (  !m_bDetonated )
			{
				Pawn(Owner).Controller.m_bLockWeaponActions=True;
				R6Pawn(Owner).m_bIsFiringState=True;
				m_bDetonated=True;
				if ( m_FPHands != None )
				{
					m_FPHands.GotoState('FiringWeapon');
					m_FPHands.FireSingleShot();
				}
				else
				{
					FirstPersonAnimOver();
				}
			}
			else
			{
				if ( bShowLog )
				{
					Log(string(self) $ " state ChargeArmed : DO NOTHING, charge has already exploded...");
				}
			}
		}
	}

}

state GetNextCharge
{
	ignores  Fire;

	function StopFire (optional bool bSoundOnly)
	{
	}

	function AltFire (float fValue)
	{
	}

	function StopAltFire ()
	{
	}

	function BeginState ()
	{
		if ( bShowLog )
		{
			Log(string(self) $ " state GetNextCharge : beginState() ");
		}
	}

	function FirstPersonAnimOver ()
	{
		m_AttachPoint=m_ChargeAttachPoint;
		SetAmmoStaticMesh();
		if ( m_FPHands != None )
		{
			SwitchToChargeHandAnimations();
			m_FPHands.GotoState('RaiseWeapon');
		}
		GotoState('ChargeReady');
	}

}

state NoChargesLeft
{
	ignores  Fire;

	function BeginState ()
	{
		if ( bShowLog )
		{
			Log(string(self) $ " state NoChargesLeft : BeginState()...");
		}
		Pawn(Owner).Controller.m_bHideReticule=True;
	}

	function StopFire (optional bool bSoundOnly)
	{
	}

	function AltFire (float fValue)
	{
	}

	function StopAltFire ()
	{
	}

	function FirstPersonAnimOver ()
	{
		Pawn(Owner).Controller.m_bLockWeaponActions=False;
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

	simulated function BeginState ()
	{
		m_bRaiseWeapon=False;
		if ( m_FPHands != None )
		{
			if ( bShowLog )
			{
				Log("***** DiscardWeapon for" @ string(self) @ string(m_bDetonator) @ string(m_iNbBulletsInWeapon) @ "******");
			}
			if ( Pawn(Owner).Controller != None )
			{
				Pawn(Owner).Controller.m_bHideReticule=True;
				Pawn(Owner).Controller.m_bLockWeaponActions=True;
			}
			if ( m_bDetonator || (m_iNbBulletsInWeapon > 0) )
			{
				m_FPHands.GotoState('DiscardWeapon');
			}
			else
			{
				FirstPersonAnimOver();
			}
		}
	}

}

state BringWeaponUp
{
	simulated function BeginState ()
	{
		if ( bShowLog )
		{
			Log("WEAPON - " $ string(self) $ " - BeginState of BringWeaponUp for " $ string(self));
		}
		if ( m_FPHands != None )
		{
			if ( (m_iNbBulletsInWeapon == 0) && m_bDetonated )
			{
				GotoState('NoChargesLeft');
			}
			else
			{
				m_FPHands.GotoState('BringWeaponUp');
			}
		}
		else
		{
			FirstPersonAnimOver();
		}
	}

	simulated function FirstPersonAnimOver ()
	{
		if ( bShowLog )
		{
			Log("FirstPersonAnimOver()  R6DemolitionsGadget");
		}
		R6PlayerController(Pawn(Owner).Controller).ServerWeaponUpAnimDone();
		if ( m_bChargeInPosition )
		{
			m_bDetonated=False;
			GotoState('ChargeArmed');
		}
		else
		{
			GotoState('ChargeReady');
		}
	}

	simulated function EndState ()
	{
		Pawn(Owner).Controller.m_bHideReticule=False;
		Pawn(Owner).Controller.m_bLockWeaponActions=False;
		m_bRaiseWeapon=True;
	}

}

simulated function RemoveFirstPersonWeapon ()
{
	if ( m_FPHands != None )
	{
		m_FPHands.Destroy();
	}
	m_FPHands=None;
	if ( m_FPWeapon != None )
	{
		m_FPWeapon.DestroySM();
		m_FPWeapon.Destroy();
	}
	m_FPWeapon=None;
	if ( m_MagazineGadget != None )
	{
		m_MagazineGadget.DestroyFPGadget();
		m_MagazineGadget=None;
	}
	DestroyReticules();
}

function HideReticule ()
{
	m_ReticuleInstance=None;
}

function DestroyReticules ()
{
	local R6Reticule aReticule;

	aReticule=m_ReticuleConfirm;
	m_ReticuleConfirm=None;
	if ( aReticule != None )
	{
		aReticule.Destroy();
	}
	aReticule=m_ReticuleBlock;
	m_ReticuleBlock=None;
	if ( aReticule != None )
	{
		aReticule.Destroy();
	}
	aReticule=m_ReticuleDetonator;
	m_ReticuleDetonator=None;
	if ( aReticule != None )
	{
		aReticule.Destroy();
	}
	m_ReticuleInstance=None;
}

simulated function R6SetReticule (optional Controller LocalPlayerController)
{
	local R6PlayerController PlayerCtrl;

	if ( Owner.IsA('R6Rainbow') )
	{
		if ( (m_pReticuleClass != None) && (m_ReticuleInstance == None) )
		{
			m_ReticuleConfirm=Spawn(m_pReticuleClass);
			m_ReticuleBlock=Spawn(m_pReticuleBlockClass);
			m_ReticuleDetonator=Spawn(m_pDetonatorReticuleClass);
			m_ReticuleInstance=m_ReticuleBlock;
			m_ReticuleConfirm.SetOwner(Owner);
			m_ReticuleBlock.SetOwner(Owner);
			m_ReticuleDetonator.SetOwner(Owner);
			if ( Level.NetMode == NM_Standalone )
			{
				m_ReticuleConfirm.m_bShowNames=GetGameOptions().HUDShowPlayersName;
				m_ReticuleBlock.m_bShowNames=GetGameOptions().HUDShowPlayersName;
				m_ReticuleDetonator.m_bShowNames=GetGameOptions().HUDShowPlayersName;
			}
			else
			{
				PlayerCtrl=R6PlayerController(LocalPlayerController);
				if ( PlayerCtrl == None )
				{
					PlayerCtrl=R6PlayerController(R6Pawn(Owner).Controller);
				}
				m_ReticuleConfirm.m_bShowNames=R6GameReplicationInfo(PlayerCtrl.GameReplicationInfo).m_bShowNames;
				m_ReticuleBlock.m_bShowNames=m_ReticuleConfirm.m_bShowNames;
				m_ReticuleDetonator.m_bShowNames=m_ReticuleConfirm.m_bShowNames;
			}
		}
	}
}

simulated function bool CanPlaceCharge ()
{
	local Vector vFeetLocation;
	local Vector vLookLocation;
	local R6Pawn pawnOwner;
	local R6PlayerController PlayerCtrl;

	pawnOwner=R6Pawn(Owner);
	PlayerCtrl=R6PlayerController(pawnOwner.Controller);
	if ( (Owner == None) || (pawnOwner.Controller == None) )
	{
		return False;
	}
	if ( pawnOwner.m_bPostureTransition )
	{
		return False;
	}
	if ( PlayerCtrl != None )
	{
		vLookLocation=PlayerCtrl.m_vDefaultLocation;
		if ( vLookLocation == vect(0.00,0.00,0.00) )
		{
			return False;
		}
	}
/*	if (  !pawnOwner.IsStationary() || (pawnOwner.m_fPeeking != pawnOwner.1000.00) )
	{
		return False;
	}*/
	vFeetLocation=Owner.Location;
	vFeetLocation.Z -= pawnOwner.CollisionHeight;
	if ( VSize(vLookLocation - vFeetLocation) < 75 )
	{
		return True;
	}
	return False;
}

function ServerGotoSetExplosive ()
{
//	R6Pawn(Owner).PlayWeaponSound(3);
	R6PlayerController(Pawn(Owner).Controller).GotoState('PlayerSetExplosive');
}

function ServerCancelChargeInstallation ()
{
	if ( bShowLog )
	{
		Log("Server Cancel Charge Installation : " $ string(R6PlayerController(Pawn(Owner).Controller).GetStateName()));
	}
//	R6Pawn(Owner).PlayWeaponSound(4);
	if ( R6Pawn(Owner).IsAlive() )
	{
		R6Pawn(Owner).m_bToggleServerCancelPlacingCharge= !R6Pawn(Owner).m_bToggleServerCancelPlacingCharge;
		if (  !Class'Actor'.static.GetModMgr().IsMissionPack() && Owner.IsA('R6Rainbow') && R6Rainbow(Owner).m_bIsSurrended )
		{
			R6PlayerController(Pawn(Owner).Controller).GotoState('PlayerWalking');
		}
	}
}

simulated function CancelChargeInstallation ()
{
	if ( bShowLog )
	{
		Log("Cancel Charge Installation");
	}
	SetTimer(0.00,False);
	m_bCancelChargeInstallation=True;
	m_bInstallingCharge=False;
	if ( R6Pawn(Owner).IsAlive() )
	{
		if (  !Class'Actor'.static.GetModMgr().IsMissionPack() && Owner.IsA('R6Rainbow') && R6Rainbow(Owner).m_bIsSurrended )
		{
			R6PlayerController(Pawn(Owner).Controller).GotoState('PlayerWalking');
		}
		m_FPHands.GotoState('RaiseWeapon');
	}
}

simulated function Tick (float fDeltaTime)
{
	if ( (Owner == None) || (self != R6Pawn(Owner).EngineWeapon) )
	{
		return;
	}
	Super.Tick(fDeltaTime);
	if ( m_bChargeInPosition || m_bDetonated )
	{
		return;
	}
	if ( m_bInstallingCharge && (Pawn(Owner).Controller.bFire == 0) )
	{
		if ( (Level.NetMode == NM_Client) || (Level.NetMode == NM_ListenServer) && R6Pawn(Owner).IsLocallyControlled() )
		{
			ServerCancelChargeInstallation();
		}
		CancelChargeInstallation();
	}
	if ( m_bInstallingCharge )
	{
		return;
	}
	m_bCanPlaceCharge=CanPlaceCharge();
	if ( m_bCanPlaceCharge )
	{
		m_ReticuleInstance=m_ReticuleConfirm;
	}
	else
	{
		m_ReticuleInstance=m_ReticuleBlock;
	}
}

simulated event HideAttachment ()
{
	if ( bShowLog )
	{
		Log("***** HideAttachment for" @ string(self) @ "****** : " $ string(m_bHide));
	}
	if ( m_bHide == True )
	{
		SetDrawType(DT_None);
	}
	else
	{
		SetDrawType(DT_StaticMesh);
		bHidden=False;
	}
}

simulated event SetGadgetStaticMesh ()
{
	if ( bShowLog )
	{
		Log("***** SetGadgetStaticMesh for" @ string(self) @ "****** : " $ string(m_bDetonator));
	}
	if ( m_bDetonator )
	{
		m_AttachPoint=m_DetonatorAttachPoint;
		SetStaticMesh(Default.StaticMesh);
		Pawn(Owner).AttachToBone(self,m_AttachPoint);
	}
	else
	{
		m_AttachPoint=m_ChargeAttachPoint;
		SetStaticMesh(m_ChargeStaticMesh);
		Pawn(Owner).AttachToBone(self,m_AttachPoint);
	}
}

function bool CanSwitchToWeapon ()
{
	if ( bShowLog )
	{
		Log("***** CanSwitchToWeapon for" @ string(self) @ string(m_bDetonator) @ string(m_iNbBulletsInWeapon) @ string(GetStateName()) @ "******");
	}
	if ( (m_bDetonator || (m_iNbBulletsInWeapon > 0)) &&  !IsInState('ChargeReady') )
	{
		return True;
	}
	else
	{
		return False;
	}
}

defaultproperties
{
    m_DetonatorAttachPoint=TagDetonatorHand
    m_pReticuleBlockClass=Class'R6CrossReticule'
    m_pDetonatorReticuleClass=Class'R6DotReticule'
    m_iClipCapacity=2
    m_pReticuleClass=Class'R6GrenadeReticule'
    m_bHiddenWhenNotInUse=True
    m_pFPHandsClass=Class'R61stWeapons.R61stHandsGripC4'
    m_NameID="DiffuseKit"
    bCollideWorld=True
}
/*
    m_EquipSnd=Sound'Foley_HBSJammer.Play_HBSJ_Equip'
    m_UnEquipSnd=Sound'Foley_HBSJammer.Play_HBSJ_Unequip'
*/

