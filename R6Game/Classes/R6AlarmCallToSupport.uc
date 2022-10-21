//================================================================================
// R6AlarmCallToSupport.
//================================================================================
class R6AlarmCallToSupport extends R6Alarm
	Placeable;

enum ETerroristTarget {
	TT_AlarmPosition,
	TT_GivenPosition
};

enum eMovementPace {
	PACE_None,
	PACE_Prone,
	PACE_CrouchWalk,
	PACE_CrouchRun,
	PACE_Walk,
	PACE_Run
};

var(R6AlarmSettings) ETerroristTarget m_eTerroristTarget;
var(R6AlarmSettings) eMovementPace m_ePace;
var(R6AlarmSettings) int m_iTerroristGroup;
var(R6AlarmSettings) float m_fActivationTime;
var float m_fTimeStart;
var(R6AlarmSettings) Sound m_sndAlarmSound;
var(R6AlarmSettings) Sound m_sndAlarmSoundStop;
var(R6AlarmSettings) array<R6IOSound> m_IOSoundList;

simulated function ResetOriginalData ()
{
	local int i;

	if ( m_bResetSystemLog )
	{
		LogResetSystem(False);
	}
	Super.ResetOriginalData();
	Disable('Tick');
	i=0;
JL0024:
	if ( i < m_IOSoundList.Length )
	{
		m_IOSoundList[i].AmbientSound=None;
		m_IOSoundList[i].AmbientSoundStop=None;
		i++;
		goto JL0024;
	}
	m_fTimeStart=0.00;
	Disable('Tick');
}

function SetAlarm (Vector vLocation)
{
	local R6TerroristAI C;
	local bool bStartAlarm;
	local int i;

	bStartAlarm=False;
	foreach AllActors(Class'R6TerroristAI',C)
	{
		if ( C.m_pawn.IsAlive() && (C.m_pawn.m_iGroupID == m_iTerroristGroup) )
		{
			bStartAlarm=True;
			if ( m_eTerroristTarget == 0 )
			{
//				C.GotoPointAndSearch(Location,m_ePace,True);
			}
			else
			{
				if ( m_eTerroristTarget == 1 )
				{
//					C.GotoPointAndSearch(vLocation,m_ePace,True);
				}
			}
		}
	}
	if ( bStartAlarm )
	{
		i=0;
JL00C7:
		if ( i < m_IOSoundList.Length )
		{
			m_IOSoundList[i].AmbientSound=m_sndAlarmSound;
			m_IOSoundList[i].AmbientSoundStop=m_sndAlarmSoundStop;
			i++;
			goto JL00C7;
		}
		m_fTimeStart=0.00;
		Enable('Tick');
	}
}

function Tick (float fDeltaTime)
{
	local int i;

	m_fTimeStart += fDeltaTime;
	if ( m_fTimeStart > m_fActivationTime )
	{
		i=0;
JL0022:
		if ( i < m_IOSoundList.Length )
		{
			m_IOSoundList[i].AmbientSound=None;
			i++;
			goto JL0022;
		}
		Disable('Tick');
	}
}

auto state Startup
{
Begin:
	Disable('Tick');
}

defaultproperties
{
    m_eTerroristTarget=1
    m_ePace=5
}
