//================================================================================
// R6MissionObjectiveMgr.
//================================================================================
class R6MissionObjectiveMgr extends Actor;
//	NoNativeReplication;

enum EMissionObjectiveStatus {
	eMissionObjStatus_none,
	eMissionObjStatus_success,
	eMissionObjStatus_failed
};

var EMissionObjectiveStatus m_eMissionObjectiveStatus;
var bool m_bShowLog;
var bool m_bDontUpdateMgr;
var bool m_bOnSuccessAllObjectivesAreCompleted;
var bool m_bEnableCheckForErrors;
var R6AbstractGameInfo m_GameInfo;
var array<R6MissionObjectiveBase> m_aMissionObjectives;

function SetMissionObjStatus (EMissionObjectiveStatus eStatus)
{
	m_eMissionObjectiveStatus=eStatus;
	m_GameInfo.UpdateRepMissionObjectivesStatus();
}

function Init (R6AbstractGameInfo GameInfo)
{
	local int i;
	local int Index;
	local int iTimer;

	if ( m_bShowLog )
	{
		Log("*** Mission Objectives ***");
	}
	m_GameInfo=GameInfo;
	SetMissionObjStatus(eMissionObjStatus_none);
	i=0;
JL0041:
	if ( i < m_aMissionObjectives.Length )
	{
		m_aMissionObjectives[i].m_mgr=self;
		if ( m_bShowLog )
		{
			Log("  " $ string(i) $ ": " $ m_aMissionObjectives[i].getDescription());
		}
		m_aMissionObjectives[i].Init();
		++i;
		goto JL0041;
	}
}

function RemoveObjectives ()
{
	if ( m_bShowLog )
	{
		Log("Mission objective: removed");
	}
	if ( m_aMissionObjectives.Length > 0 )
	{
		m_aMissionObjectives.Remove (0,m_aMissionObjectives.Length);
	}
	m_GameInfo.ResetRepMissionObjectives();
}

function TimerCallback (float fTime);

function PawnKilled (Pawn killedPawn)
{
	local int i;

	if ( (m_eMissionObjectiveStatus != 0) || (killedPawn == None) )
	{
		return;
	}
	if ( m_bShowLog )
	{
		if ( (PlayerController(killedPawn.Controller) != None) && (PlayerController(killedPawn.Controller).PlayerReplicationInfo != None) )
		{
			Log("MissionObjective: PawnKilled " $ PlayerController(killedPawn.Controller).PlayerReplicationInfo.PlayerName);
		}
		else
		{
			Log("MissionObjective: PawnKilled " $ string(killedPawn.Name));
		}
	}
	i=0;
JL00EA:
	if ( i < m_aMissionObjectives.Length )
	{
		if ( m_aMissionObjectives[i].m_bFailed || m_aMissionObjectives[i].m_bCompleted )
		{
			goto JL0149;
		}
		m_aMissionObjectives[i].PawnKilled(killedPawn);
JL0149:
		++i;
		goto JL00EA;
	}
}

function IObjectInteract (Pawn aPawn, Actor anInteractiveObject)
{
	local int i;

	if ( m_eMissionObjectiveStatus != 0 )
	{
		return;
	}
	i=0;
JL0019:
	if ( i < m_aMissionObjectives.Length )
	{
		if ( m_aMissionObjectives[i].m_bFailed || m_aMissionObjectives[i].m_bCompleted )
		{
			goto JL007D;
		}
		m_aMissionObjectives[i].IObjectInteract(aPawn,anInteractiveObject);
JL007D:
		++i;
		goto JL0019;
	}
}

function IObjectDestroyed (Pawn aPawn, Actor anInteractiveObject)
{
	local int i;

	if ( m_eMissionObjectiveStatus != 0 )
	{
		return;
	}
	i=0;
JL0019:
	if ( i < m_aMissionObjectives.Length )
	{
		if ( m_aMissionObjectives[i].m_bFailed || m_aMissionObjectives[i].m_bCompleted )
		{
			goto JL007D;
		}
		m_aMissionObjectives[i].IObjectDestroyed(aPawn,anInteractiveObject);
JL007D:
		++i;
		goto JL0019;
	}
}

function PawnSeen (Pawn seen, Pawn witness)
{
	local int i;

	if ( m_eMissionObjectiveStatus != 0 )
	{
		return;
	}
	i=0;
JL0019:
	if ( i < m_aMissionObjectives.Length )
	{
		if ( m_aMissionObjectives[i].m_bFailed || m_aMissionObjectives[i].m_bCompleted )
		{
			goto JL007D;
		}
		m_aMissionObjectives[i].PawnSeen(seen,witness);
JL007D:
		++i;
		goto JL0019;
	}
}

function PawnHeard (Pawn heard, Pawn witness)
{
	local int i;

	if ( m_eMissionObjectiveStatus != 0 )
	{
		return;
	}
	i=0;
JL0019:
	if ( i < m_aMissionObjectives.Length )
	{
		if ( m_aMissionObjectives[i].m_bFailed || m_aMissionObjectives[i].m_bCompleted )
		{
			goto JL007D;
		}
		m_aMissionObjectives[i].PawnHeard(heard,witness);
JL007D:
		++i;
		goto JL0019;
	}
}

function PawnSecure (Pawn securedPawn)
{
	local int i;

	if ( m_eMissionObjectiveStatus != 0 )
	{
		return;
	}
	i=0;
JL0019:
	if ( i < m_aMissionObjectives.Length )
	{
		if ( m_aMissionObjectives[i].m_bFailed || m_aMissionObjectives[i].m_bCompleted )
		{
			goto JL0078;
		}
		m_aMissionObjectives[i].PawnSecure(securedPawn);
JL0078:
		++i;
		goto JL0019;
	}
}

function EnteredExtractionZone (Pawn aPawn)
{
	local int i;

	if ( aPawn == None )
	{
		return;
	}
	if ( m_eMissionObjectiveStatus != 0 )
	{
		return;
	}
	i=0;
JL0026:
	if ( i < m_aMissionObjectives.Length )
	{
		if ( m_aMissionObjectives[i].m_bFailed || m_aMissionObjectives[i].m_bCompleted )
		{
			goto JL0085;
		}
		m_aMissionObjectives[i].EnteredExtractionZone(aPawn);
JL0085:
		++i;
		goto JL0026;
	}
}

function ExitExtractionZone (Pawn aPawn)
{
	local int i;

	if ( aPawn == None )
	{
		return;
	}
	if ( m_eMissionObjectiveStatus != 0 )
	{
		return;
	}
	i=0;
JL0026:
	if ( i < m_aMissionObjectives.Length )
	{
		if ( m_aMissionObjectives[i].m_bFailed || m_aMissionObjectives[i].m_bCompleted )
		{
			goto JL0085;
		}
		m_aMissionObjectives[i].ExitExtractionZone(aPawn);
JL0085:
		++i;
		goto JL0026;
	}
}

function EMissionObjectiveStatus Update ()
{
	local int i;
	local int iTotalMissionToComplete;
	local int iCompleted;
	local int iTotalMissionFailed;

	if ( m_bDontUpdateMgr || InPlanningMode() && !Level.m_bInGamePlanningActive )
	{
		return eMissionObjStatus_none;
	}
	if ( m_eMissionObjectiveStatus != 0 )
	{
		return m_eMissionObjectiveStatus;
	}
	i=0;
JL0047:
	if ( i < m_aMissionObjectives.Length )
	{
		if ( m_aMissionObjectives[i].isFailed() )
		{
			if (  !m_aMissionObjectives[i].m_bMoralityObjective )
			{
				++iTotalMissionFailed;
			}
			if ( m_aMissionObjectives[i].isMissionAbortedOnFailure() )
			{
				SetMissionObjStatus(eMissionObjStatus_failed);
			}
		}
		++i;
		goto JL0047;
	}
	if ( m_eMissionObjectiveStatus == 2 )
	{
		return m_eMissionObjectiveStatus;
	}
	i=0;
JL00D7:
	if ( i < m_aMissionObjectives.Length )
	{
		if ( m_aMissionObjectives[i].m_bMoralityObjective )
		{
			goto JL0164;
		}
		++iTotalMissionToComplete;
		if (  !m_aMissionObjectives[i].isFailed() && m_aMissionObjectives[i].isCompleted() )
		{
			++iCompleted;
			if ( m_aMissionObjectives[i].isMissionCompletedOnSuccess() )
			{
				SetMissionObjStatus(eMissionObjStatus_success);
			}
		}
JL0164:
		++i;
		goto JL00D7;
	}
	if ( m_eMissionObjectiveStatus == 1 )
	{
		CompleteMission();
		return m_eMissionObjectiveStatus;
	}
	if ( iTotalMissionToComplete > 0 )
	{
		if ( iTotalMissionFailed == iTotalMissionToComplete )
		{
			SetMissionObjStatus(eMissionObjStatus_failed);
			return m_eMissionObjectiveStatus;
		}
		else
		{
			if ( iCompleted == iTotalMissionToComplete )
			{
				CompleteMission();
				return m_eMissionObjectiveStatus;
			}
		}
	}
	return eMissionObjStatus_none;
}

function AbortMission ()
{
	local int i;

	i=0;
JL0007:
	if ( i < m_aMissionObjectives.Length )
	{
		if ( m_aMissionObjectives[i].m_bMoralityObjective )
		{
			goto JL0045;
		}
		SetMissionObjCompleted(m_aMissionObjectives[i],False,False);
JL0045:
		++i;
		goto JL0007;
	}
	SetMissionObjStatus(eMissionObjStatus_failed);
	m_GameInfo.UpdateRepMissionObjectives();
}

function CompleteMission ()
{
	local int i;

	if ( m_bOnSuccessAllObjectivesAreCompleted )
	{
		i=0;
JL0010:
		if ( i < m_aMissionObjectives.Length )
		{
			if (  !m_aMissionObjectives[i].m_bFailed )
			{
				SetMissionObjCompleted(m_aMissionObjectives[i],True,False);
			}
			++i;
			goto JL0010;
		}
	}
	SetMissionObjStatus(eMissionObjStatus_success);
	m_GameInfo.UpdateRepMissionObjectives();
}

function ToggleLog (bool bToggle)
{
	local int i;

	m_bShowLog=bToggle;
	i=0;
JL0014:
	if ( i < m_aMissionObjectives.Length )
	{
		m_aMissionObjectives[i].ToggleLog(bToggle);
		++i;
		goto JL0014;
	}
}

function R6MissionObjectiveBase GetMObjFailed ()
{
	local int i;
	local string szFailure;

	i=0;
JL0007:
	if ( i < m_aMissionObjectives.Length )
	{
		if (  !m_aMissionObjectives[i].isFailed() )
		{
			goto JL0077;
		}
		if ( m_aMissionObjectives[i].m_bMoralityObjective )
		{
			goto JL0077;
		}
		if ( m_aMissionObjectives[i].GetDescriptionFailure() != "" )
		{
			return m_aMissionObjectives[i];
		}
JL0077:
		++i;
		goto JL0007;
	}
	i=0;
JL0088:
	if ( i < m_aMissionObjectives.Length )
	{
		if (  !m_aMissionObjectives[i].isFailed() )
		{
			goto JL00FA;
		}
		if (  !m_aMissionObjectives[i].m_bMoralityObjective )
		{
			goto JL00FA;
		}
		if ( m_aMissionObjectives[i].GetDescriptionFailure() != "" )
		{
			return m_aMissionObjectives[i];
		}
JL00FA:
		++i;
		goto JL0088;
	}
}

simulated event Destroyed ()
{
	local int i;

	Super.Destroyed();
	i=0;
JL000D:
	if ( i < m_aMissionObjectives.Length )
	{
		m_aMissionObjectives[i].SetMObjMgr(None);
		++i;
		goto JL000D;
	}
	m_GameInfo=None;
}

function SetMissionObjCompleted (R6MissionObjectiveBase mobj, bool bCompleted, bool bFeedback)
{
	if ( InPlanningMode() && !Level.m_bInGamePlanningActive )
	{
		return;
	}
	if ( bCompleted )
	{
		mobj.m_bCompleted=True;
	}
	else
	{
		mobj.m_bFailed=True;
	}
	if (  !bFeedback || mobj.m_bFeedbackOnCompletionSend || mobj.m_bFeedbackOnFailureSend )
	{
		return;
	}
	if ( mobj.m_bCompleted )
	{
		if ( mobj.m_szFeedbackOnCompletion != "" )
		{
			m_GameInfo.BroadcastMissionObjMsg(Level.GetMissionObjLocFile(mobj),"",mobj.m_szFeedbackOnCompletion);
			mobj.m_bFeedbackOnCompletionSend=True;
		}
	}
	else
	{
		if ( mobj.m_szFeedbackOnFailure != "" )
		{
			m_GameInfo.BroadcastMissionObjMsg(Level.GetMissionObjLocFile(mobj),"",mobj.m_szFeedbackOnFailure);
			mobj.m_bFeedbackOnFailureSend=True;
		}
	}
}

defaultproperties
{
    m_bOnSuccessAllObjectivesAreCompleted=True
    bHidden=True
}
