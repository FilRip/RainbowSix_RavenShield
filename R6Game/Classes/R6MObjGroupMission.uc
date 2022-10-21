//================================================================================
// R6MObjGroupMission.
//================================================================================
class R6MObjGroupMission extends R6MissionObjectiveBase;

var() int m_iMinSuccessRequired;
var() int m_iMaxFailedAccepted;
var() editinlineuse array<R6MissionObjectiveBase> m_aSubMissionObjectives;

function Init ()
{
	local R6MissionObjectiveMgr mgr;
	local int i;
	local int Index;
	local array<R6MissionObjectiveBase> aTempMObj;

	if ( R6MissionObjectiveMgr(m_mgr).m_bEnableCheckForErrors )
	{
		if ( m_aSubMissionObjectives.Length == 0 )
		{
			logMObj("m_aSubMissionObjectives.Length == 0");
		}
		if ( m_iMinSuccessRequired <= 0 )
		{
			logMObj("m_iMinSuccessRequired <= 0");
		}
		if ( m_iMinSuccessRequired > m_aSubMissionObjectives.Length )
		{
			logMObj("m_iMinSuccessRequired >  m_aSubMissionObjectives.Length ");
		}
		if ( m_iMaxFailedAccepted > m_aSubMissionObjectives.Length )
		{
			logMObj("m_iMaxFailedAccepted > m_aSubMissionObjectives.Length");
		}
	}
	m_iMaxFailedAccepted=Clamp(m_iMaxFailedAccepted,0,m_aSubMissionObjectives.Length);
	m_iMinSuccessRequired=Clamp(m_iMinSuccessRequired,1,m_aSubMissionObjectives.Length);
	i=0;
JL0147:
	if ( i < m_aSubMissionObjectives.Length )
	{
		if (  !m_aSubMissionObjectives[i].m_bEndOfListOfObjectives )
		{
			aTempMObj[Index]=m_aSubMissionObjectives[i];
			++Index;
		}
		++i;
		goto JL0147;
	}
	i=0;
JL01A0:
	if ( i < m_aSubMissionObjectives.Length )
	{
		if ( m_aSubMissionObjectives[i].m_bEndOfListOfObjectives )
		{
			aTempMObj[Index]=m_aSubMissionObjectives[i];
			++Index;
		}
		++i;
		goto JL01A0;
	}
	mgr=R6MissionObjectiveMgr(m_mgr);
	i=0;
JL0207:
	if ( i < m_aSubMissionObjectives.Length )
	{
		m_aSubMissionObjectives[i]=aTempMObj[i];
		m_aSubMissionObjectives[i].m_mgr=m_mgr;
		m_aSubMissionObjectives[i].Init();
		if ( mgr.m_bShowLog )
		{
			Log("    " $ string(i) $ ": " $ m_aSubMissionObjectives[i].getDescription());
		}
		++i;
		goto JL0207;
	}
}

function ToggleLog (bool bToggle)
{
	local int i;

	Super.ToggleLog(bToggle);
	i=0;
JL0013:
	if ( i < m_aSubMissionObjectives.Length )
	{
		m_aSubMissionObjectives[i].ToggleLog(bToggle);
		++i;
		goto JL0013;
	}
}

function PawnKilled (Pawn killedPawn)
{
	local int i;

	i=0;
JL0007:
	if ( i < m_aSubMissionObjectives.Length )
	{
		if ( m_aSubMissionObjectives[i].m_bFailed || m_aSubMissionObjectives[i].m_bCompleted )
		{
			goto JL0066;
		}
		m_aSubMissionObjectives[i].PawnKilled(killedPawn);
JL0066:
		++i;
		goto JL0007;
	}
}

function IObjectInteract (Pawn aPawn, Actor anInteractiveObject)
{
	local int i;

	i=0;
JL0007:
	if ( i < m_aSubMissionObjectives.Length )
	{
		if ( m_aSubMissionObjectives[i].m_bFailed || m_aSubMissionObjectives[i].m_bCompleted )
		{
			goto JL006B;
		}
		m_aSubMissionObjectives[i].IObjectInteract(aPawn,anInteractiveObject);
JL006B:
		++i;
		goto JL0007;
	}
}

function IObjectDestroyed (Pawn aPawn, Actor anInteractiveObject)
{
	local int i;

	i=0;
JL0007:
	if ( i < m_aSubMissionObjectives.Length )
	{
		if ( m_aSubMissionObjectives[i].m_bFailed || m_aSubMissionObjectives[i].m_bCompleted )
		{
			goto JL006B;
		}
		m_aSubMissionObjectives[i].IObjectDestroyed(aPawn,anInteractiveObject);
JL006B:
		++i;
		goto JL0007;
	}
}

function PawnSeen (Pawn seen, Pawn witness)
{
	local int i;

	i=0;
JL0007:
	if ( i < m_aSubMissionObjectives.Length )
	{
		if ( m_aSubMissionObjectives[i].m_bFailed || m_aSubMissionObjectives[i].m_bCompleted )
		{
			goto JL006B;
		}
		m_aSubMissionObjectives[i].PawnSeen(seen,witness);
JL006B:
		++i;
		goto JL0007;
	}
}

function PawnHeard (Pawn seen, Pawn witness)
{
	local int i;

	i=0;
JL0007:
	if ( i < m_aSubMissionObjectives.Length )
	{
		if ( m_aSubMissionObjectives[i].m_bFailed || m_aSubMissionObjectives[i].m_bCompleted )
		{
			goto JL006B;
		}
		m_aSubMissionObjectives[i].PawnHeard(seen,witness);
JL006B:
		++i;
		goto JL0007;
	}
}

function PawnSecure (Pawn securedPawn)
{
	local int i;

	i=0;
JL0007:
	if ( i < m_aSubMissionObjectives.Length )
	{
		if ( m_aSubMissionObjectives[i].m_bFailed || m_aSubMissionObjectives[i].m_bCompleted )
		{
			goto JL0066;
		}
		m_aSubMissionObjectives[i].PawnSecure(securedPawn);
JL0066:
		++i;
		goto JL0007;
	}
}

function EnteredExtractionZone (Pawn Pawn)
{
	local int i;

	i=0;
JL0007:
	if ( i < m_aSubMissionObjectives.Length )
	{
		if ( m_aSubMissionObjectives[i].m_bFailed || m_aSubMissionObjectives[i].m_bCompleted )
		{
			goto JL0066;
		}
		m_aSubMissionObjectives[i].EnteredExtractionZone(Pawn);
JL0066:
		++i;
		goto JL0007;
	}
}

function ExitExtractionZone (Pawn Pawn)
{
	local int i;

	i=0;
JL0007:
	if ( i < m_aSubMissionObjectives.Length )
	{
		if ( m_aSubMissionObjectives[i].m_bFailed || m_aSubMissionObjectives[i].m_bCompleted )
		{
			goto JL0066;
		}
		m_aSubMissionObjectives[i].ExitExtractionZone(Pawn);
JL0066:
		++i;
		goto JL0007;
	}
}

function bool isCompleted ()
{
	local int i;
	local int iNum;

	if ( m_bCompleted || m_bFailed )
	{
		return m_bCompleted;
	}
	i=0;
JL0022:
	if ( i < m_aSubMissionObjectives.Length )
	{
		if ( m_aSubMissionObjectives[i].isCompleted() )
		{
			if ( m_aSubMissionObjectives[i].isMissionCompletedOnSuccess() )
			{
				if ( m_bShowLog )
				{
					logX(" mission is completed on success because of " $ m_aSubMissionObjectives[i].getDescription());
				}
				R6MissionObjectiveMgr(m_mgr).SetMissionObjCompleted(self,True,True);
			}
			iNum++;
		}
		++i;
		goto JL0022;
	}
	if ( m_bCompleted )
	{
		return m_bCompleted;
	}
	if ( iNum >= m_iMinSuccessRequired )
	{
		R6MissionObjectiveMgr(m_mgr).SetMissionObjCompleted(self,True,True);
	}
	if ( m_bCompleted && m_bShowLog )
	{
		logX("is completed. num completed=" $ string(iNum) $ " minSuccessRequired=" $ string(m_iMinSuccessRequired));
	}
	return m_bCompleted;
}

function bool isFailed ()
{
	local int i;
	local int iNum;

	if ( m_bFailed || m_bCompleted )
	{
		return m_bFailed;
	}
	i=0;
JL0022:
	if ( i < m_aSubMissionObjectives.Length )
	{
		if ( m_aSubMissionObjectives[i].isFailed() )
		{
			if ( m_aSubMissionObjectives[i].m_bIfFailedMissionIsAborted )
			{
				R6MissionObjectiveMgr(m_mgr).SetMissionObjCompleted(self,False,True);
				if ( m_bShowLog )
				{
					logX("is failed. Mission is aborted because of " $ m_aSubMissionObjectives[i].getDescription());
				}
			}
			iNum++;
		}
		++i;
		goto JL0022;
	}
	if ( m_bFailed )
	{
		return m_bFailed;
	}
	if ( iNum == 0 )
	{
		return False;
	}
	if ( iNum >= m_iMaxFailedAccepted )
	{
		R6MissionObjectiveMgr(m_mgr).SetMissionObjCompleted(self,False,True);
	}
	if ( m_bShowLog && m_bFailed )
	{
		logX("is failed. num failed=" $ string(iNum) $ " maxFailedAccepted=" $ string(m_iMaxFailedAccepted));
	}
	return m_bFailed;
}

function string GetDescriptionFailure ()
{
	local int i;
	local int iNum;

	if (  !m_bFailed )
	{
		return "";
	}
	i=0;
JL0015:
	if ( i < m_aSubMissionObjectives.Length )
	{
		if ( m_aSubMissionObjectives[i].isFailed() && (m_aSubMissionObjectives[i].GetDescriptionFailure() != "") )
		{
			return m_aSubMissionObjectives[i].GetDescriptionFailure();
		}
		++i;
		goto JL0015;
	}
}

function Sound GetSoundFailure ()
{
	local int i;

	if (  !m_bFailed )
	{
		return None;
	}
	i=0;
JL0014:
	if ( i < m_aSubMissionObjectives.Length )
	{
		if ( m_aSubMissionObjectives[i].isFailed() )
		{
			return m_aSubMissionObjectives[i].GetSoundFailure();
		}
		++i;
		goto JL0014;
	}
	return m_sndSoundFailure;
}

function int GetNumSubMission ()
{
	return m_aSubMissionObjectives.Length;
}

function R6MissionObjectiveBase GetSubMissionObjective (int Index)
{
	return m_aSubMissionObjectives[Index];
}

function SetMObjMgr (Actor aMObjMgr)
{
	local int i;

	Super.SetMObjMgr(aMObjMgr);
	i=0;
JL0012:
	if ( i < m_aSubMissionObjectives.Length )
	{
		m_aSubMissionObjectives[i].SetMObjMgr(aMObjMgr);
		++i;
		goto JL0012;
	}
}

function Reset ()
{
	local int i;

	Super.Reset();
	i=0;
JL000D:
	if ( i < m_aSubMissionObjectives.Length )
	{
		m_aSubMissionObjectives[i].Reset();
		++i;
		goto JL000D;
	}
}

defaultproperties
{
    m_iMinSuccessRequired=1
    m_szDescription="This a group mission"
}