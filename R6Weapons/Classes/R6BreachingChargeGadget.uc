//================================================================================
// R6BreachingChargeGadget.
//================================================================================
class R6BreachingChargeGadget extends R6DemolitionsGadget;

var R6IORotatingDoor m_IORDoor;

replication
{
	reliable if ( Role < Role_Authority )
		ServerSetDoor;
}

function ServerDetonate ()
{
	m_IORDoor.RemoveBreach(BulletActor);
	Super.ServerDetonate();
}

simulated function PlaceChargeAnimation ()
{
	ServerPlaceChargeAnimation();
}

function ServerPlaceChargeAnimation ()
{
//	R6Pawn(Owner).SetNextPendingAction(PENDING_Coughing6);
}

function NPCPlaceCharge (Actor aDoor)
{
	if ( bShowLog )
	{
		Log(" NonPlayerPlaceCharge() aDoor=" $ string(aDoor));
	}
	m_IORDoor=R6IORotatingDoor(aDoor);
	ServerPlaceCharge(m_IORDoor.Location);
	m_bChargeInPosition=True;
	GotoState('ChargeArmed');
}

function NPCDetonateCharge ()
{
	if ( bShowLog )
	{
		Log(" NPCDetonateCharge() m_bChargeInPosition=" $ string(m_bChargeInPosition));
	}
	if ( m_bChargeInPosition )
	{
		m_IORDoor.RemoveBreach(BulletActor);
		Explode();
		m_bChargeInPosition=False;
	}
}

function bool CharacterOnOtherSide ()
{
	local int iDiffYaw;

	iDiffYaw=m_IORDoor.Rotation.Yaw - Owner.Rotation.Yaw & 65535;
	if ( iDiffYaw < 32768 )
	{
		return True;
	}
	return False;
}

simulated function ServerSetDoor (R6IORotatingDoor aDoor)
{
	m_IORDoor=aDoor;
}

simulated function ServerPlaceCharge (Vector vLocation)
{
	BulletActor=R6Grenade(Spawn(m_pBulletClass,self));
	if ( bShowLog )
	{
		Log("  ServerPlaceCharge was called for Breach... BulletActor=" $ string(BulletActor) $ " : " $ string(m_IORDoor));
	}
	if ( (BulletActor == None) || (m_IORDoor == None) || (m_iNbBulletsInWeapon == 0) )
	{
		return;
	}
	BulletActor.m_Weapon=self;
	BulletActor.Instigator=Pawn(Owner);
	BulletActor.SetSpeed(0.00);
	BulletActor.SetOwner(m_IORDoor);
	BulletActor.SetBase(m_IORDoor,m_IORDoor.Location);
	m_IORDoor.AddBreach(BulletActor);
	BulletActor.bUnlit=m_IORDoor.bUnlit;
	BulletActor.bSpecialLit=m_IORDoor.bSpecialLit;
	if ( m_IORDoor.m_bIsOpeningClockWise )
	{
		BulletActor.SetRelativeLocation(vect(-64.00,2.50,0.00));
	}
	else
	{
		BulletActor.SetRelativeLocation(vect(-64.00,-2.50,0.00));
	}
	if ( CharacterOnOtherSide() )
	{
		BulletActor.SetRelativeRotation(rot(0,32768,0));
	}
	else
	{
		BulletActor.SetRelativeRotation(rot(0,0,0));
	}
	m_AttachPoint=m_DetonatorAttachPoint;
	SetStaticMesh(Default.StaticMesh);
	Pawn(Owner).AttachToBone(self,m_AttachPoint);
	m_iNbBulletsInWeapon--;
	m_bDetonator=True;
}

function SetAmmoStaticMesh ()
{
//	m_FPWeapon.m_smGun.SetStaticMesh(StaticMesh'R61stBreachingCharge');
}

function Explode ()
{
	BulletActor.Explode();
	BulletActor.Destroy();
}

function bool CanPlaceCharge ()
{
	local Vector vFeetLocation;
	local Vector vLookLocation;
	local Vector vHitLocation;
	local Vector vHitNormal;
	local Actor HitActor;
	local R6Pawn pawnOwner;

	pawnOwner=R6Pawn(Owner);
/*	if ( pawnOwner.m_bIsProne ||  !pawnOwner.IsStationary() || (pawnOwner.m_fPeeking != pawnOwner.1000.00) )
	{
		return False;
	}*/
	m_IORDoor=R6IORotatingDoor(pawnOwner.m_potentialActionActor);
	if ( m_IORDoor == None )
	{
		return False;
	}
	if ( m_IORDoor.m_bInProcessOfClosing || m_IORDoor.m_bInProcessOfOpening )
	{
		return False;
	}
	if (  !pawnOwner.m_bIsPlayer )
	{
		m_vLocation=m_IORDoor.Location;
		return True;
	}
	HitActor=pawnOwner.Trace(vHitLocation,vHitNormal,Owner.Location + 100 * vector(Owner.Rotation),Owner.Location,True);
	if ( (HitActor == None) ||  !HitActor.IsA('R6IORotatingDoor') )
	{
		return False;
	}
	if ( R6IORotatingDoor(HitActor).m_bTreatDoorAsWindow || R6IORotatingDoor(HitActor).m_bBroken )
	{
		return False;
	}
	m_vLocation=m_IORDoor.Location;
	if (  !pawnOwner.IsLocallyControlled() )
	{
		return True;
	}
	if ( pawnOwner.m_potentialActionActor == R6PlayerController(pawnOwner.Controller).m_CurrentCircumstantialAction.aQueryTarget )
	{
		return True;
	}
	return False;
}

simulated function name GetFiringAnimName ()
{
	if ( Pawn(Owner).bIsCrouched )
	{
		return 'CrouchPlaceBreach';
	}
	else
	{
		return m_PawnFiringAnim;
	}
}

simulated function Tick (float fDeltaTime)
{
	if ( Owner == None )
	{
		return;
	}
	if ( m_bInstallingCharge && (m_IORDoor.m_bInProcessOfClosing || m_IORDoor.m_bInProcessOfOpening) )
	{
		if ( (Level.NetMode == NM_Client) || (Level.NetMode == NM_ListenServer) && R6Pawn(Owner).IsLocallyControlled() )
		{
			ServerCancelChargeInstallation();
		}
		CancelChargeInstallation();
	}
	Super.Tick(fDeltaTime);
}

state ChargeReady
{
	function Timer ()
	{
		if (  !R6Pawn(Owner).m_bIsPlayer || R6Pawn(Owner).m_bPostureTransition ||  !m_bInstallingCharge )
		{
			return;
		}
		if ( bShowLog )
		{
			Log(string(self) $ " state ChargeReady : Timer() has expired " $ string(R6PlayerController(Pawn(Owner).Controller).m_bPlacedExplosive));
		}
		if ( R6PlayerController(Pawn(Owner).Controller).m_bPlacedExplosive )
		{
			ServerSetDoor(m_IORDoor);
			ServerPlaceCharge(m_vLocation);
			m_bChargeInPosition=True;
			m_bInstallingCharge=False;
			m_bRaiseWeapon=False;
			m_FPWeapon.m_smGun.SetStaticMesh(m_DetonatorStaticMesh);
			GotoState('ChargeArmed');
		}
	}

}

defaultproperties
{
    m_ChargeAttachPoint=TagC4Hand
    m_iClipCapacity=3
    m_pBulletClass=Class'R6BreachingChargeUnit'
    m_pFPHandsClass=Class'R61stWeapons.R61stHandsGripBreach'
    m_pFPWeaponClass=Class'R61stWeapons.R61stBreachingCharge'
    m_PawnWaitAnimLow=StandGrenade_nt
    m_PawnWaitAnimHigh=StandGrenade_nt
    m_PawnWaitAnimProne=ProneGrenade_nt
    m_PawnFiringAnim=StandPlaceBreach
    m_AttachPoint=TagC4Hand
    m_HUDTexturePos=(X=0.00,Y=0.00,Z=-131072.56,W=0.00)
    m_NameID="BreachingChargeGadget"
}
/*
    StaticMesh=StaticMesh'R63rdWeapons_SM.Items.R63rdBreachingDetonator'
    m_DetonatorStaticMesh=StaticMesh'R61stWeapons_SM.Items.R61stBreachingDetonator'
    m_ChargeStaticMesh=StaticMesh'R63rdWeapons_SM.Items.R63rdBreachingCharge'
    m_SingleFireStereoSnd=Sound'Gadget_BreachingCharge.Play_BreachingChargePlacement'
    m_SingleFireEndStereoSnd=Sound'Gadget_BreachingCharge.Stop_BreachingCharge_Go'
    m_HUDTexture=Texture'R6HUD.HUDElements'
*/

