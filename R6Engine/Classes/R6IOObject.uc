//================================================================================
// R6IOObject.
//================================================================================
class R6IOObject extends R6IActionObject
	Native;

enum eDeviceAnimToPlay {
	BA_ArmBomb,
	BA_DisarmBomb,
	BA_Keypad,
	BA_PlantDevice,
	BA_Keyboard
};

enum EDefCon {
	DEFCON_0,
	DEFCON_1,
	DEFCON_2,
	DEFCON_3,
	DEFCON_4,
	DEFCON_5
};

enum eStateIOObejct {
	SIO_Start,
	SIO_Interrupt,
	SIO_Complete
};

enum eDeviceCircumstantialAction {
	DCA_None,
	DCA_DisarmBomb,
	DCA_ArmBomb,
	DCA_Device
};

var(R6ActionObject) eDeviceAnimToPlay m_eAnimToPlay;
var eStateIOObejct m_ObjectState;
var(R6ActionObject) bool m_bToggleType;
var bool sm_bToggleType;
var(R6ActionObject) bool m_bIsActivated;
var bool sm_bIsActivated;
var(R6ActionObject) float m_fGainTimeWithElectronicsKit;
var float m_fLockObjectTime;
var Sound m_StartSnd;
var Sound m_InterruptedSnd;
var Sound m_CompletedSnd;

replication
{
	reliable if ( Role == Role_Authority )
		m_bIsActivated,sm_bIsActivated;
}

simulated function SaveOriginalData ()
{
	if ( m_bResetSystemLog )
	{
		LogResetSystem(True);
	}
	Super.SaveOriginalData();
	sm_bIsActivated=m_bIsActivated;
	sm_bToggleType=m_bToggleType;
}

simulated function ResetOriginalData ()
{
	if ( m_bResetSystemLog )
	{
		LogResetSystem(False);
	}
	Super.ResetOriginalData();
	m_bIsActivated=sm_bIsActivated;
	m_bToggleType=sm_bToggleType;
	m_fLockObjectTime=0.00;
}

simulated function LockObjectUse (bool bIsInUse)
{
	if ( bIsInUse )
	{
		m_fLockObjectTime=Level.TimeSeconds;
	}
	else
	{
		m_fLockObjectTime=0.00;
	}
}

simulated function R6CircumstantialActionProgressStart (R6AbstractCircumstantialActionQuery Query)
{
	m_fPlayerCAStartTime=Level.TimeSeconds;
//	PerformSoundAction(0);
	LockObjectUse(True);
}

simulated function int R6GetCircumstantialActionProgress (R6AbstractCircumstantialActionQuery Query, Pawn actingPawn)
{
	local float fPercentage;

	fPercentage=(Level.TimeSeconds - m_fPlayerCAStartTime) / Query.fPlayerActionTimeRequired * (2.00 - R6Pawn(actingPawn).ArmorSkillEffect());
	fPercentage *= 100;
	if ( fPercentage >= 100 )
	{
		LockObjectUse(False);
	}
	if ( (fPercentage >= 100) && (m_ObjectState != 2) )
	{
//		PerformSoundAction(2);
	}
	return fPercentage;
}

simulated function R6CircumstantialActionCancel ()
{
	LockObjectUse(False);
//	PerformSoundAction(1);
}

simulated function bool HasKit (R6Pawn aPawn)
{
	return False;
}

simulated function float GetMaxTimeRequired ()
{
	return 0.00;
}

simulated function float GetTimeRequired (R6Pawn aPawn)
{
	return 0.00;
}

simulated function ToggleDevice (R6Pawn aPawn)
{
	local float fBackup;

	fBackup=m_fLockObjectTime;
	if (  !aPawn.m_bIsPlayer )
	{
		m_fLockObjectTime=0.00;
	}
	if ( CanToggle() )
	{
		LockObjectUse(False);
	}
	else
	{
		fBackup=m_fLockObjectTime;
	}
}

simulated function bool CanToggle ()
{
	local bool bCanToggle;

	bCanToggle=(sm_bIsActivated == m_bIsActivated) || (m_bToggleType == True);
	if ( bCanToggle && (m_fLockObjectTime != 0) )
	{
		if ( GetMaxTimeRequired() < Level.TimeSeconds - m_fLockObjectTime )
		{
			LockObjectUse(False);
		}
		else
		{
			return False;
		}
	}
	return bCanToggle;
}

function PerformSoundAction (eStateIOObejct eState)
{
	m_ObjectState=eState;
	switch (eState)
	{
/*		case 0:
		if ( bShowLog )
		{
			Log("****** PerformSoundAction SIO_Start");
		}
		PlaySound(m_StartSnd,3);
		break;
		case 1:
		if ( bShowLog )
		{
			Log("****** PerformSoundAction SIO_Interrupt");
		}
		PlaySound(m_InterruptedSnd,3);
		break;
		case 2:
		if ( bShowLog )
		{
			Log("****** PerformSoundAction SIO_Complete");
		}
		PlaySound(m_CompletedSnd,3);
		break;
		default: */
	}
}

defaultproperties
{
    m_eAnimToPlay=2
    m_bToggleType=True
    m_fGainTimeWithElectronicsKit=2.00
    RemoteRole=ROLE_SimulatedProxy
    DrawType=8
    bUseCylinderCollision=True
    bDirectional=True
    CollisionRadius=32.00
    CollisionHeight=55.00
    m_fCircumstantialActionRange=105.00
    NetPriority=2.70
}
/*
    StaticMesh=StaticMesh'R6ActionObjects.MpBomb.MpBomb'
*/

