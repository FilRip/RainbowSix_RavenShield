//================================================================================
// R6IORotatingDoor.
//================================================================================
class R6IORotatingDoor extends R6IActionObject
	Native;

enum eDoorCircumstantialAction {
	CA_None,
	CA_Open,
	CA_OpenAndClear,
	CA_OpenAndGrenade,
	CA_OpenGrenadeAndClear,
	CA_Close,
	CA_Clear,
	CA_Grenade,
	CA_GrenadeAndClear,
	CA_GrenadeFrag,
	CA_GrenadeGas,
	CA_GrenadeFlash,
	CA_GrenadeSmoke,
	CA_Unlock,
	CA_Lock,
	CA_LockPickStop
};

var(R6Damage) int m_iLockHP;
var int m_iCurrentLockHP;
var(R6DoorProperties) int m_iMaxOpeningDeg;
var(R6DoorProperties) int m_iInitialOpeningDeg;
var int m_iYawInit;
var int m_iYawMax;
var int m_iMaxOpening;
var int m_iInitialOpening;
var int m_iCurrentOpening;
var() bool m_bTreatDoorAsWindow;
var(Debug) bool bShowLog;
var bool m_bInProcessOfClosing;
var bool m_bInProcessOfOpening;
var bool m_bUseWheel;
var() bool m_bForceNoFormation;
var(R6DoorProperties) bool m_bIsOpeningClockWise;
var(R6DoorProperties) bool m_bIsDoorLocked;
var bool sm_bIsDoorLocked;
var bool m_bIsDoorClosed;
var() float m_fWindowWidth;
var(R6DoorProperties) float m_fUnlockBaseTime;
var() R6Door m_DoorActorA;
var() R6Door m_DoorActorB;
var(R6DoorSounds) Sound m_OpeningSound;
var(R6DoorSounds) Sound m_OpeningWheelSound;
var(R6DoorSounds) Sound m_ClosingSound;
var(R6DoorSounds) Sound m_ClosingWheelSound;
var(R6DoorSounds) Sound m_LockSound;
var(R6DoorSounds) Sound m_UnlockSound;
var(R6DoorSounds) Sound m_MoveAmbientSound;
var(R6DoorSounds) Sound m_MoveAmbientSoundStop;
var(R6DoorSounds) Sound m_LockPickSound;
var(R6DoorSounds) Sound m_LockPickSoundStop;
var(R6DoorSounds) Sound m_ExplosionSound;
var array<R6AbstractBullet> m_BreachAttached;
var Vector m_vNormal;
var Vector m_vCenterOfDoor;
var Vector m_vDoorADir2D;

replication
{
	reliable if ( bNetInitial && (Role == Role_Authority) )
		m_iMaxOpeningDeg,m_iInitialOpeningDeg,m_bIsOpeningClockWise,m_bIsDoorLocked,m_DoorActorA,m_DoorActorB;
	reliable if ( Role == Role_Authority )
		m_iYawInit,m_iYawMax,m_iMaxOpening,m_iInitialOpening,m_bInProcessOfClosing,m_bInProcessOfOpening,m_bIsDoorClosed;
}

native(1511) final function bool WillOpenOnTouch (R6Pawn R6Pawn);

native(2018) final function AddBreach (R6AbstractBullet BreachAttached);

native(2019) final function RemoveBreach (R6AbstractBullet BreachAttached);

simulated function SaveOriginalData ()
{
	if ( m_bResetSystemLog )
	{
		LogResetSystem(True);
	}
	Super.SaveOriginalData();
	sm_bIsDoorLocked=m_bIsDoorLocked;
	sm_Rotation=Rotation;
}

simulated function ResetOriginalData ()
{
	local Rotator rNewRotation;
	local Rotator rTempRotation;
	local bool bCA;
	local bool bBA;
	local bool bBP;

	if ( m_bResetSystemLog )
	{
		LogResetSystem(False);
	}
	Super.ResetOriginalData();
	m_bBulletGoThrough=False;
	m_bHidePortal=True;
	m_bUseWheel=False;
	m_bIsDoorLocked=sm_bIsDoorLocked;
	m_fPlayerCAStartTime=0.00;
	SetDoorProcessStates(False,False);
	m_iCurrentLockHP=m_iLockHP;
	m_iInitialOpening=m_iInitialOpeningDeg * 65536 / 360;
	m_iMaxOpening=m_iMaxOpeningDeg * 65536 / 360;
	m_iMaxOpening=Clamp(m_iMaxOpening,0,65535);
	m_iInitialOpening=Clamp(m_iInitialOpening,0,m_iMaxOpening);
	rTempRotation=sm_Rotation;
	rTempRotation.Yaw=sm_Rotation.Yaw & 65535;
	bCA=bCollideActors;
	bBA=bBlockActors;
	bBP=bBlockPlayers;
	SetCollision(False,False,False);
	SetRotation(rTempRotation);
	SetCollision(bCA,bBA,bBP);
	DesiredRotation=rTempRotation;
	bRotateToDesired=False;
	m_iYawInit=Rotation.Yaw;
	rNewRotation.Yaw=m_iYawInit;
	m_vCenterOfDoor=Location - 64 * vector(rNewRotation);
	m_vNormal=vector(rNewRotation) Cross vect(0.00,0.00,1.00);
	if ( m_DoorActorA != None )
	{
		m_vDoorADir2D=m_DoorActorA.Location - m_vCenterOfDoor;
	}
	m_vDoorADir2D.Z=0.00;
	m_vDoorADir2D=Normal(m_vDoorADir2D);
	rNewRotation=Rotation;
	if ( m_bIsOpeningClockWise )
	{
		m_iYawMax=m_iYawInit + m_iMaxOpening;
		rNewRotation.Yaw=Rotation.Yaw + Clamp(m_iInitialOpening,0,m_iMaxOpening);
	}
	else
	{
		m_iYawMax=m_iYawInit - m_iMaxOpening;
		rNewRotation.Yaw=Rotation.Yaw - Clamp(m_iInitialOpening,0,m_iMaxOpening);
	}
	m_iYawMax=m_iYawMax & 65535;
	DesiredRotation=rNewRotation;
	if ( rNewRotation.Yaw != m_iYawInit )
	{
		m_bUseWheel=True;
		SetDoorState(False);
		m_bHidePortal=m_bIsDoorClosed;
		if ( Level.NetMode == NM_Client )
		{
			SetRotation(rNewRotation);
		}
		ClientSetDoor(rNewRotation,True);
	}
	else
	{
		SetDoorState(True);
	}
	m_BreachAttached.Remove (0,m_BreachAttached.Length);
}

function PostBeginPlay ()
{
	Super.PostBeginPlay();
	m_bBulletGoThrough=False;
}

function bool startAction (float fDeltaMouse, Actor actionInstigator)
{
	return True;
}

function SetDoorProcessStates (bool bOpening, bool bClosing)
{
	m_bInProcessOfOpening=bOpening;
	m_bInProcessOfClosing=bClosing;
	if ( bOpening || bClosing )
	{
		Enable('Tick');
	}
}

function bool updateAction (float fDeltaMouse, Actor actionInstigator)
{
	local Rotator rNewRotation;
	local Rotator rRotation;
	local float fDoorMouvement;
	local int iMaxDoorMove;
	local float fTempSide;
	local int iNewOpening;

	SetDoorProcessStates(False,False);
	if ( fDeltaMouse == 0.00 )
	{
		return False;
	}
	RotationRate.Yaw=Default.RotationRate.Yaw;
	if (  !m_bIsOpeningClockWise )
	{
		fDeltaMouse *= -1;
	}
	fDoorMouvement=fDeltaMouse;
	fDoorMouvement=fDoorMouvement * m_iMaxOpening / m_fMaxMouseMove;
	if ( (Default.Mass != 0) && (Mass != 0) )
	{
		fDoorMouvement=fDoorMouvement * Default.Mass / Mass;
	}
	rNewRotation=Rotation;
	rRotation=Rotation;
	if ( m_bIsOpeningClockWise )
	{
		iNewOpening=m_iCurrentOpening + fDoorMouvement;
		iNewOpening=Clamp(iNewOpening,0,m_iMaxOpening);
		rNewRotation.Yaw=m_iYawInit + iNewOpening;
	}
	else
	{
		iNewOpening=m_iCurrentOpening - fDoorMouvement;
		iNewOpening=Clamp(iNewOpening,0,m_iMaxOpening);
		rNewRotation.Yaw=m_iYawInit - iNewOpening;
	}
	if (  !m_bUseWheel && (rRotation.Yaw == m_iYawInit) && (rNewRotation.Yaw != m_iYawInit) )
	{
		if ( m_OpeningWheelSound != None )
		{
//			PlaySound(m_OpeningWheelSound,3);
		}
		AmbientSound=m_MoveAmbientSound;
		AmbientSoundStop=m_MoveAmbientSoundStop;
		m_bUseWheel=True;
	}
	ClientSetDoor(rNewRotation);
	return True;
}

simulated function R6CircumstantialActionCancel ()
{
	performDoorAction(15);
}

function performDoorAction (int iActionID)
{
	if ( iActionID == 5 )
	{
		CloseDoor(None);
	}
	else
	{
		if ( iActionID == 1 )
		{
			OpenDoor(None);
		}
		else
		{
			if ( iActionID == 13 )
			{
				UnlockDoor();
//				PlaySound(m_UnlockSound,3);
			}
			else
			{
				if ( iActionID == 14 )
				{
//					PlaySound(m_LockSound,3);
				}
				else
				{
					if ( iActionID == 15 )
					{
//						PlaySound(m_LockPickSoundStop,3);
					}
				}
			}
		}
	}
}

function ClientSetDoor (Rotator rNewRotation, optional bool bForce)
{
	if ( bForce || (DesiredRotation != rNewRotation) )
	{
		Enable('Tick');
		bRotateToDesired=True;
		DesiredRotation=rNewRotation;
	}
}

simulated event bool EncroachingOn (Actor Other)
{
	local R6Pawn P;
	local R6AIController AI;

	P=R6Pawn(Other);
	if ( (P != None) && P.IsAlive() )
	{
		if (  !P.m_bIsPlayer )
		{
			AI=R6AIController(P.Controller);
			AI.m_BumpedBy=self;
			AI.GotoBumpBackUpState(AI.GetStateName());
		}
		return True;
	}
	return False;
}

function OpenDoor (Pawn opener, optional int iRotationRate)
{
	local Rotator rNewRotation;

	if ( iRotationRate == 0 )
	{
		iRotationRate=Default.RotationRate.Yaw;
	}
	RotationRate.Yaw=iRotationRate;
	if ( opener != None )
	{
		Instigator=opener;
	}
	if ( Instigator != None )
	{
		Instigator.R6MakeNoise(SNDTYPE_Door);
	}
	rNewRotation=Rotation;
	if ( m_iYawInit < m_iYawMax )
	{
		if ( Rotation.Yaw > m_iYawMax )
		{
			rNewRotation.Yaw -= 65536;
		}
	}
	else
	{
		if ( Rotation.Yaw > m_iYawInit )
		{
			rNewRotation.Yaw -= 65536;
		}
	}
	if (  !m_bUseWheel && (rNewRotation.Yaw == m_iYawInit) )
	{
		if ( m_OpeningSound != None )
		{
//			PlaySound(m_OpeningSound,3);
		}
		AmbientSound=m_MoveAmbientSound;
		AmbientSoundStop=m_MoveAmbientSoundStop;
		m_bUseWheel=True;
	}
	rNewRotation.Yaw=m_iYawMax;
	bRotateToDesired=True;
	DesiredRotation=rNewRotation;
	SetDoorProcessStates(True,False);
	ClientSetDoor(rNewRotation);
}

simulated function CloseDoor (R6Pawn Pawn, optional int iRotationRate)
{
	local Rotator rNewRotation;

	if ( iRotationRate == 0 )
	{
		iRotationRate=Default.RotationRate.Yaw;
	}
	RotationRate.Yaw=iRotationRate;
	if ( Pawn != None )
	{
		Instigator=Pawn;
	}
	if ( Instigator != None )
	{
		Instigator.R6MakeNoise(SNDTYPE_Door);
	}
	rNewRotation=Rotation;
	rNewRotation.Yaw=m_iYawInit;
	bRotateToDesired=True;
	DesiredRotation=rNewRotation;
	SetDoorProcessStates(False,True);
	ClientSetDoor(rNewRotation);
}

function bool DoorOpenTowardsActor (Actor aActor)
{
	if ( vector(aActor.Rotation) Dot m_vNormal > 0 )
	{
		if ( m_bIsOpeningClockWise )
		{
			return False;
		}
		else
		{
			return True;
		}
	}
	else
	{
		if ( m_bIsOpeningClockWise )
		{
			return True;
		}
		else
		{
			return False;
		}
	}
}

function int R6TakeDamage (int iKillValue, int iStunValue, Pawn instigatedBy, Vector vHitLocation, Vector vMomentum, int iPenetrationFactor, optional int iBulletGroup)
{
	local float fPercentage;
	local float fBulletDamMultiplier;
	local int i;

	if ( (Level.NetMode == NM_Standalone) || (Role == Role_Authority) )
	{
		if ( iBulletGroup == -1 )
		{
			if ( m_iHitPoints < 2500 )
			{
				fBulletDamMultiplier=0.05 * iPenetrationFactor;
			}
			else
			{
				fBulletDamMultiplier=0.00 * iPenetrationFactor;
			}
			if ( (m_iCurrentLockHP != 0) && HitLock(vHitLocation) )
			{
				m_iCurrentLockHP=Max(m_iCurrentLockHP - Max(iKillValue * fBulletDamMultiplier * 10,400),0);
				if ( (m_iYawInit != Rotation.Yaw) || (m_iCurrentLockHP == 0) )
				{
					UnlockDoor();
					OpenDoorWhenHit(vHitLocation,vMomentum,2048 * iPenetrationFactor,False);
				}
			}
			else
			{
				m_iCurrentHitPoints=Max(m_iCurrentHitPoints - iKillValue * fBulletDamMultiplier,0);
				if ( (m_iYawInit != Rotation.Yaw) || (m_iCurrentLockHP == 0) )
				{
					OpenDoorWhenHit(vHitLocation,vMomentum,2048 * iPenetrationFactor,False);
				}
			}
		}
		else
		{
			m_iCurrentHitPoints=Max(m_iCurrentHitPoints - iKillValue,0);
			m_iCurrentLockHP=Max(m_iCurrentLockHP - iKillValue,0);
			if ( m_iCurrentLockHP == 0 )
			{
				UnlockDoor();
				OpenDoorWhenHit(vHitLocation,vMomentum,0,True);
			}
		}
		fPercentage=m_iCurrentHitPoints * 100 / m_iHitPoints;
		SetNewDamageState(fPercentage);
		if ( m_bBroken )
		{
//			PlaySound(m_ExplosionSound,3);
			R6AbstractGameInfo(Level.Game).IObjectDestroyed(instigatedBy,self);
			Instigator=instigatedBy;
//			R6MakeNoise2(m_fAIBreakNoiseRadius,2,4);
JL0226:
			if ( m_BreachAttached.Length != 0 )
			{
				if ( m_BreachAttached[0] == None )
				{
					m_BreachAttached.Remove (0,1);
				}
				else
				{
					m_BreachAttached[0].DoorExploded();
				}
				goto JL0226;
			}
		}
	}
	return m_iCurrentHitPoints;
}

function bool HitLock (Vector vHitVector)
{
	local Vector vTemp2;
	local Vector vTemp3;

	vTemp2=vHitVector;
	vTemp3=Location;
	if ( (vTemp2.Z - vTemp3.Z > -8) || (vTemp2.Z - vTemp3.Z < -24) )
	{
		return False;
	}
	vTemp2.Z=0.00;
	vTemp3.Z=0.00;
	if ( VSize(vTemp2 - vTemp3) < 112 )
	{
		return False;
	}
	return True;
}

function OpenDoorWhenHit (Vector vHitLocation, Vector vBulletDirection, int YawVariation, bool bExplosion)
{
	local Rotator rBulletAsRotator;
	local Vector vTemp2;
	local Vector vTemp3;
	local int iYawDifference;
	local bool bShootTurnCCW;

	vTemp2=vHitLocation;
	vTemp2.Z=0.00;
	vTemp3=Location;
	vTemp3.Z=0.00;
	if ( (VSize(vTemp2 - vTemp3) < 96) &&  !bExplosion )
	{
		return;
	}
	rBulletAsRotator=rotator(vBulletDirection);
	if ( rBulletAsRotator.Yaw < 0 )
	{
		rBulletAsRotator.Yaw += 65536;
	}
	iYawDifference=rBulletAsRotator.Yaw - Rotation.Yaw;
	if ( iYawDifference < 0 )
	{
		iYawDifference += 65536;
	}
	if ( iYawDifference < 32768 )
	{
		YawVariation= -YawVariation;
		bShootTurnCCW=True;
	}
	DesiredRotation.Yaw += YawVariation;
	RotationRate.Yaw=65000;
	if ( bExplosion == False )
	{
		if ( m_bIsOpeningClockWise )
		{
			if ( m_bInProcessOfClosing == True )
			{
				if ( bShootTurnCCW == False )
				{
					SetDoorProcessStates(m_bInProcessOfOpening,False);
					DesiredRotation.Yaw=Rotation.Yaw;
				}
			}
			else
			{
				if ( m_bInProcessOfOpening == True )
				{
					if ( bShootTurnCCW == True )
					{
						SetDoorProcessStates(False,False);
						DesiredRotation.Yaw=Rotation.Yaw;
					}
				}
			}
			if (  !(bShootTurnCCW == True) && (m_iYawInit == Rotation.Yaw) || (bShootTurnCCW == False) && (m_iYawMax == Rotation.Yaw) )
			{
				if ( m_iYawInit > m_iYawMax )
				{
					if ( (DesiredRotation.Yaw > m_iYawMax) && (DesiredRotation.Yaw < m_iYawInit) )
					{
						if ( YawVariation > 0 )
						{
							DesiredRotation.Yaw=m_iYawMax;
						}
						else
						{
							DesiredRotation.Yaw=m_iYawInit;
						}
					}
				}
				else
				{
					if ( DesiredRotation.Yaw > m_iYawMax )
					{
						DesiredRotation.Yaw=m_iYawMax;
					}
					else
					{
						if ( DesiredRotation.Yaw < m_iYawInit )
						{
							DesiredRotation.Yaw=m_iYawInit;
						}
					}
				}
			}
			else
			{
				if ( bShootTurnCCW == True )
				{
					DesiredRotation.Yaw=m_iYawInit;
				}
				else
				{
					DesiredRotation.Yaw=m_iYawMax;
				}
			}
		}
		else
		{
			if ( m_bInProcessOfClosing == True )
			{
				if ( bShootTurnCCW == True )
				{
					SetDoorProcessStates(m_bInProcessOfOpening,False);
					DesiredRotation.Yaw=Rotation.Yaw;
				}
			}
			else
			{
				if ( m_bInProcessOfOpening == True )
				{
					if ( bShootTurnCCW == False )
					{
						SetDoorProcessStates(False,False);
						DesiredRotation.Yaw=Rotation.Yaw;
					}
				}
			}
			if (  !(bShootTurnCCW == False) && (m_iYawInit == Rotation.Yaw) || (bShootTurnCCW == True) && (m_iYawMax == Rotation.Yaw) )
			{
				if ( m_iYawInit < m_iYawMax )
				{
					if ( DesiredRotation.Yaw > 65536 )
					{
						DesiredRotation.Yaw -= 65536;
					}
					if ( (DesiredRotation.Yaw < m_iYawMax) && (DesiredRotation.Yaw > m_iYawInit) )
					{
						if ( YawVariation < 0 )
						{
							DesiredRotation.Yaw=m_iYawMax;
						}
						else
						{
							DesiredRotation.Yaw=m_iYawInit;
						}
					}
				}
				else
				{
					if ( DesiredRotation.Yaw < m_iYawMax )
					{
						DesiredRotation.Yaw=m_iYawMax;
					}
					else
					{
						if ( DesiredRotation.Yaw > m_iYawInit )
						{
							DesiredRotation.Yaw=m_iYawInit;
						}
					}
				}
			}
			else
			{
				if ( bShootTurnCCW == False )
				{
					DesiredRotation.Yaw=m_iYawInit;
				}
				else
				{
					DesiredRotation.Yaw=m_iYawMax;
				}
			}
		}
	}
	else
	{
		SetDoorProcessStates(False,False);
		if ( Rotation.Yaw == m_iYawInit )
		{
			if ( m_bIsOpeningClockWise && (iYawDifference > 32768) ||  !m_bIsOpeningClockWise && (iYawDifference < 32768) )
			{
				OpenDoor(None,65000);
			}
			else
			{
				if ( m_bIsOpeningClockWise )
				{
					if ( m_iYawInit > m_iYawMax )
					{
						DesiredRotation.Yaw=(m_iYawMax + m_iYawInit) / 2 + 32768;
					}
					else
					{
						DesiredRotation.Yaw=(m_iYawMax + m_iYawInit) / 2;
					}
				}
				else
				{
					if ( m_iYawInit < m_iYawMax )
					{
						DesiredRotation.Yaw=(m_iYawMax + m_iYawInit) / 2 + 32768;
					}
					else
					{
						DesiredRotation.Yaw=(m_iYawMax + m_iYawInit) / 2;
					}
				}
			}
		}
		else
		{
			if ( Rotation.Yaw == m_iYawMax )
			{
				if ( m_bIsOpeningClockWise && (iYawDifference < 32768) ||  !m_bIsOpeningClockWise && (iYawDifference > 32768) )
				{
					CloseDoor(None,65000);
				}
				else
				{
					if (  !m_bIsOpeningClockWise )
					{
						if ( m_iYawInit < m_iYawMax )
						{
							DesiredRotation.Yaw=(m_iYawMax + m_iYawInit) / 2 + 32768;
						}
						else
						{
							DesiredRotation.Yaw=(m_iYawMax + m_iYawInit) / 2;
						}
					}
					else
					{
						if ( m_iYawInit > m_iYawMax )
						{
							DesiredRotation.Yaw=(m_iYawMax + m_iYawInit) / 2 + 32768;
						}
						else
						{
							DesiredRotation.Yaw=(m_iYawMax + m_iYawInit) / 2;
						}
					}
				}
			}
			else
			{
				if ( m_bIsOpeningClockWise && (iYawDifference < 32768) ||  !m_bIsOpeningClockWise && (iYawDifference > 32768) )
				{
					CloseDoor(None,65000);
				}
				else
				{
					OpenDoor(None,65000);
				}
			}
		}
	}
	bRotateToDesired=True;
	Enable('Tick');
	if ( DesiredRotation.Yaw > 65536 )
	{
		DesiredRotation.Yaw -= 65536;
	}
	else
	{
		if ( DesiredRotation.Yaw < 0 )
		{
			DesiredRotation.Yaw += 65536;
		}
	}
	if ( (Rotation.Yaw == m_iYawInit) && (DesiredRotation.Yaw != m_iYawInit) )
	{
		if ( m_OpeningWheelSound != None )
		{
//			PlaySound(m_OpeningWheelSound,3);
		}
		AmbientSound=m_MoveAmbientSound;
		AmbientSoundStop=m_MoveAmbientSoundStop;
		m_bUseWheel=True;
	}
}

simulated event R6QueryCircumstantialAction (float fDistance, out R6AbstractCircumstantialActionQuery Query, PlayerController PlayerController)
{
	local bool bDisplayOpenIcon;
	local Vector vDistance;
	local bool bOpensTowardsPawn;

	Query.iHasAction=1;
	if ( m_bIsDoorClosed )
	{
		vDistance=m_vVisibleCenter - PlayerController.Pawn.Location;
		vDistance.Z=0.00;
		fDistance=VSize(vDistance);
	}
	if ( fDistance < m_fCircumstantialActionRange )
	{
		Query.iInRange=1;
	}
	else
	{
		Query.iInRange=0;
	}
	if ( m_bInProcessOfClosing )
	{
		bDisplayOpenIcon=True;
	}
	else
	{
		if ( m_bInProcessOfOpening )
		{
			bDisplayOpenIcon=False;
		}
		else
		{
			if ( m_bIsDoorClosed )
			{
				bDisplayOpenIcon=True;
			}
			else
			{
				bDisplayOpenIcon=False;
			}
		}
	}
	if (  !bDisplayOpenIcon )
	{
		if ( m_bTreatDoorAsWindow )
		{
//			Query.textureIcon=Texture'CloseWindow';
		}
		else
		{
//			Query.textureIcon=Texture'CloseDoor';
		}
		Query.iPlayerActionID=5;
	}
	else
	{
		Query.bCanBeInterrupted=m_bIsDoorLocked;
		if ( R6Rainbow(PlayerController.Pawn).m_bHasLockPickKit )
		{
			Query.fPlayerActionTimeRequired=m_fUnlockBaseTime / 2.00;
		}
		else
		{
			Query.fPlayerActionTimeRequired=m_fUnlockBaseTime;
		}
		if ( m_bIsDoorLocked )
		{
//			Query.textureIcon=Texture'UnlockDoor';
			Query.iPlayerActionID=13;
		}
		else
		{
			bOpensTowardsPawn=DoorOpenTowardsActor(PlayerController.Pawn);
			if ( bOpensTowardsPawn )
			{
				if ( m_bIsOpeningClockWise )
				{
					if ( m_bTreatDoorAsWindow )
					{
//						Query.textureIcon=Texture'OpenWin_T_CW';
					}
					else
					{
//						Query.textureIcon=Texture'OpenDoor_T_CW';
					}
				}
				else
				{
					if ( m_bTreatDoorAsWindow )
					{
//						Query.textureIcon=Texture'OpenWin_T_CCW';
					}
					else
					{
//						Query.textureIcon=Texture'OpenDoor_T_CCW';
					}
				}
			}
			else
			{
				if ( m_bIsOpeningClockWise )
				{
					if ( m_bTreatDoorAsWindow )
					{
//						Query.textureIcon=Texture'OpenWin_A_CW';
					}
					else
					{
//						Query.textureIcon=Texture'OpenDoor_A_CW';
					}
				}
				else
				{
					if ( m_bTreatDoorAsWindow )
					{
//						Query.textureIcon=Texture'OpenWin_A_CCW';
					}
					else
					{
//						Query.textureIcon=Texture'OpenDoor_A_CCW';
					}
				}
			}
			Query.iPlayerActionID=1;
		}
	}
	if ( m_bIsDoorClosed )
	{
		Query.iTeamActionID=1;
		Query.iTeamActionIDList[0]=1;
		if (  !m_bTreatDoorAsWindow )
		{
			Query.iTeamActionIDList[1]=2;
			Query.iTeamActionIDList[2]=3;
			Query.iTeamActionIDList[3]=4;
			R6FillSubAction(Query,0,0);
			R6FillSubAction(Query,1,0);
			R6FillGrenadeSubAction(Query,2);
			R6FillGrenadeSubAction(Query,3);
		}
		else
		{
			Query.iTeamActionIDList[1]=0;
			Query.iTeamActionIDList[2]=0;
			Query.iTeamActionIDList[3]=0;
		}
	}
	else
	{
		Query.iTeamActionID=5;
		Query.iTeamActionIDList[0]=5;
		if (  !m_bTreatDoorAsWindow )
		{
			Query.iTeamActionIDList[1]=6;
			Query.iTeamActionIDList[2]=7;
			Query.iTeamActionIDList[3]=8;
			R6FillSubAction(Query,0,0);
			R6FillSubAction(Query,1,0);
			R6FillGrenadeSubAction(Query,2);
			R6FillGrenadeSubAction(Query,3);
		}
		else
		{
			Query.iTeamActionIDList[1]=0;
			Query.iTeamActionIDList[2]=0;
			Query.iTeamActionIDList[3]=0;
		}
	}
}

function R6FillGrenadeSubAction (out R6AbstractCircumstantialActionQuery Query, int iSubMenu)
{
	local int i;
	local int j;

	if ( R6ActionCanBeExecuted(9) )
	{
		Query.iTeamSubActionsIDList[iSubMenu * 4 + i]=9;
		i++;
	}
	if ( R6ActionCanBeExecuted(10) )
	{
		Query.iTeamSubActionsIDList[iSubMenu * 4 + i]=10;
		i++;
	}
	if ( R6ActionCanBeExecuted(11) )
	{
		Query.iTeamSubActionsIDList[iSubMenu * 4 + i]=11;
		i++;
	}
	if ( R6ActionCanBeExecuted(12) )
	{
		Query.iTeamSubActionsIDList[iSubMenu * 4 + i]=12;
		i++;
	}
	j=i;
JL00E3:
	if ( j < 4 )
	{
		Query.iTeamSubActionsIDList[iSubMenu * 4 + j]=0;
		j++;
		goto JL00E3;
	}
}

function SetBroken ()
{
	Super.SetBroken();
	SetDoorState(False);
	m_bHidePortal=False;
}

function bool ShouldBeBreached ()
{
	if ( m_bBroken )
	{
		return False;
	}
	if ( m_bTreatDoorAsWindow )
	{
		return False;
	}
	if (  !m_bIsDoorClosed || (m_iCurrentOpening != 0) )
	{
		return False;
	}
	return True;
}

event EndedRotation ()
{
	bRotateToDesired=False;
}

event Tick (float fDelta)
{
	local int rDesYaw;

	if ( m_bBroken )
	{
		Disable('Tick');
		return;
	}
	if (  !m_bInProcessOfOpening &&  !m_bInProcessOfClosing &&  !bRotateToDesired )
	{
		Disable('Tick');
	}
	rDesYaw=DesiredRotation.Yaw;
	if ( rDesYaw < 0 )
	{
		rDesYaw += 65536;
	}
	else
	{
		if ( rDesYaw > 65536 )
		{
			rDesYaw -= 65536;
		}
	}
	if ( Rotation.Yaw == rDesYaw )
	{
		if ( m_bInProcessOfClosing || m_bInProcessOfOpening )
		{
			if ( m_bInProcessOfClosing )
			{
				if ( m_ClosingSound != None )
				{
//					PlaySound(m_ClosingSound,3);
				}
				AmbientSound=None;
				m_bUseWheel=False;
			}
			SetDoorProcessStates(False,False);
		}
		if ( m_bUseWheel && (DesiredRotation.Yaw == m_iYawInit) )
		{
			if ( m_ClosingWheelSound != None )
			{
//				PlaySound(m_ClosingWheelSound,3);
			}
			AmbientSound=None;
			m_bUseWheel=False;
		}
	}
	if ( m_bIsOpeningClockWise )
	{
		m_iCurrentOpening=Rotation.Yaw - m_iYawInit & 65535;
	}
	else
	{
		m_iCurrentOpening=m_iYawInit - Rotation.Yaw & 65535;
	}
	SetDoorState(m_iCurrentOpening < 16384);
	if (  !m_bTreatDoorAsWindow )
	{
		m_vVisibleCenter=Location - 64 * vector(Rotation);
	}
	else
	{
		m_vVisibleCenter=Location - m_fWindowWidth * 0.50 * vector(Rotation);
	}
	m_bHidePortal=m_iCurrentOpening == 0;
}

simulated function UnlockDoor ()
{
	if (  !m_bIsDoorLocked )
	{
		return;
	}
	m_bIsDoorLocked=False;
	m_DoorActorA.ExtraCost=m_DoorActorA.Default.ExtraCost;
	m_DoorActorB.ExtraCost=m_DoorActorB.Default.ExtraCost;
}

simulated function SetDoorState (bool bIsClosed)
{
	m_bIsDoorClosed=bIsClosed;
	if ( m_bTreatDoorAsWindow )
	{
		return;
	}
	if ( m_bIsDoorClosed )
	{
		if ( m_bIsDoorLocked )
		{
			m_DoorActorA.ExtraCost=1000;
			m_DoorActorB.ExtraCost=1000;
		}
		else
		{
			m_DoorActorA.ExtraCost=m_DoorActorA.Default.ExtraCost;
			m_DoorActorB.ExtraCost=m_DoorActorB.Default.ExtraCost;
		}
	}
	else
	{
		m_DoorActorA.ExtraCost=0;
		m_DoorActorB.ExtraCost=0;
	}
}

simulated function string R6GetCircumstantialActionString (int iAction)
{
	switch (iAction)
	{
/*		case 5:
		return Localize("RDVOrder","Order_Close","R6Menu");
		case 6:
		return Localize("RDVOrder","Order_Clear","R6Menu");
		case 7:
		return Localize("RDVOrder","Order_Grenade","R6Menu");
		case 8:
		return Localize("RDVOrder","Order_GrenadeClear","R6Menu");
		case 1:
		return Localize("RDVOrder","Order_Open","R6Menu");
		case 2:
		return Localize("RDVOrder","Order_OpenClear","R6Menu");
		case 3:
		return Localize("RDVOrder","Order_OpenGrenade","R6Menu");
		case 4:
		return Localize("RDVOrder","Order_OpenGrenadeClear","R6Menu");
		case 9:
		return Localize("RDVOrder","Order_FragGrenade","R6Menu");
		case 10:
		return Localize("RDVOrder","Order_GasGrenade","R6Menu");
		case 11:
		return Localize("RDVOrder","Order_FlashGrenade","R6Menu");
		case 12:
		return Localize("RDVOrder","Order_SmokeGrenade","R6Menu");
		default:    */
	}
	return "";
}

function R6CircumstantialActionProgressStart (R6AbstractCircumstantialActionQuery Query)
{
	m_fPlayerCAStartTime=Level.TimeSeconds;
	PlayLockPickSound();
}

function PlayLockPickSound ()
{
//	PlaySound(m_LockPickSound,3);
}

function int R6GetCircumstantialActionProgress (R6AbstractCircumstantialActionQuery Query, Pawn actingPawn)
{
	local float fPercentage;

	if ( m_bIsDoorLocked )
	{
		fPercentage=(Level.TimeSeconds - m_fPlayerCAStartTime) / Query.fPlayerActionTimeRequired * (2.00 - R6Pawn(actingPawn).ArmorSkillEffect());
	}
	else
	{
		fPercentage=1.00;
	}
	return fPercentage * 100;
}

simulated function bool R6ActionCanBeExecuted (int iAction)
{
	local R6PlayerController PlayerController;

	if ( iAction == 0 )
	{
		return False;
	}
	foreach DynamicActors(Class'R6PlayerController',PlayerController)
	{
		goto JL0024;
JL0024:
	}
	if ( (PlayerController == None) || (PlayerController.m_TeamManager == None) )
	{
		return False;
	}
	switch (iAction)
	{
/*		case 9:
		return PlayerController.m_TeamManager.HaveRainbowWithGrenadeType(1);
		break;
		case 10:
		return PlayerController.m_TeamManager.HaveRainbowWithGrenadeType(2);
		break;
		case 11:
		return PlayerController.m_TeamManager.HaveRainbowWithGrenadeType(3);
		break;
		case 12:
		return PlayerController.m_TeamManager.HaveRainbowWithGrenadeType(4);
		break;
		default:  */
	}
	return True;
}

event Bump (Actor Other)
{
	local R6Pawn Pawn;
	local Vector vDoorDir;
	local Rotator rPawnRot;
	local Vector vPawnDir;

	Pawn=R6Pawn(Other);
	if ( Pawn == None )
	{
		return;
	}
	if ( WillOpenOnTouch(Pawn) )
	{
		OpenDoor(Pawn);
		return;
	}
}

function bool ActorIsOnSideA (Actor aActor)
{
	local Vector vActorDir2D;

	vActorDir2D=aActor.Location - m_vCenterOfDoor;
	vActorDir2D.Z=0.00;
	vActorDir2D=Normal(vActorDir2D);
	return vActorDir2D Dot m_vDoorADir2D > 0;
}

function Vector GetTarget (Actor aActor, float fDistanceFromDoor, optional bool bBackup)
{
	local Vector vTarget;

	if ( bBackup )
	{
		fDistanceFromDoor *= -1;
	}
	vTarget=m_vCenterOfDoor;
	if ( ActorIsOnSideA(aActor) )
	{
		vTarget -= fDistanceFromDoor * m_vDoorADir2D;
	}
	else
	{
		vTarget += fDistanceFromDoor * m_vDoorADir2D;
	}
	vTarget.Z=aActor.Location.Z;
	return vTarget;
}

defaultproperties
{
    m_iLockHP=1000
    m_iMaxOpeningDeg=90
    m_fUnlockBaseTime=5.00
    m_iHitPoints=2000
    Physics=8
    m_eDisplayFlag=1
    m_bUseR6Availability=False
    m_bSkipHitDetection=True
    m_bUseDifferentVisibleCollide=True
    m_bUseOriginalRotationInPlanning=True
    m_bSpriteShowFlatInPlanning=True
    m_bOutlinedInPlanning=False
    m_fCircumstantialActionRange=132.00
    NetPriority=2.70
    RotationRate=(Pitch=0,Yaw=20000,Roll=0)
}
