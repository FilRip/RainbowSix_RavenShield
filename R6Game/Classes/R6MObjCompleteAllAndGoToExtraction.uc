//================================================================================
// R6MObjCompleteAllAndGoToExtraction.
//================================================================================
class R6MObjCompleteAllAndGoToExtraction extends R6MissionObjectiveBase;

function Init ()
{
	if ( R6MissionObjectiveMgr(m_mgr).m_bEnableCheckForErrors )
	{
		R6GameInfo(m_mgr.Level.Game).CheckForExtractionZone(self);
	}
}

function EnteredExtractionZone (Pawn aPawn)
{
	local R6MissionObjectiveMgr mgr;
	local int i;
	local int iTotal;
	local int iTotalCompleted;

	if ( m_bCompleted || isFailed() || (aPawn == None) || (aPawn.Controller == None) )
	{
		return;
	}
	if (  !aPawn.IsAlive() )
	{
		return;
	}
	mgr=R6MissionObjectiveMgr(m_mgr);
	i=0;
JL0066:
	if ( i < mgr.m_aMissionObjectives.Length )
	{
		if ( mgr.m_aMissionObjectives[i] == self )
		{
			goto JL014D;
		}
		if ( mgr.m_aMissionObjectives[i].m_bMoralityObjective )
		{
			goto JL014D;
		}
		if ( mgr.m_aMissionObjectives[i].isMissionCompletedOnSuccess() )
		{
			goto JL014D;
		}
		++iTotal;
		if ( mgr.m_aMissionObjectives[i].isFailed() )
		{
			R6MissionObjectiveMgr(m_mgr).SetMissionObjCompleted(self,False,True);
			return;
		}
		if ( mgr.m_aMissionObjectives[i].isCompleted() )
		{
			++iTotalCompleted;
		}
JL014D:
		++i;
		goto JL0066;
	}
	if ( (iTotal == iTotalCompleted) && (iTotal > 0) )
	{
		mgr.SetMissionObjCompleted(self,True,True);
	}
	if ( m_bShowLog )
	{
		Log("EnteredExtractionZone: completed=" $ string(m_bCompleted) $ " iTotal=" $ string(iTotal) $ " iTotalCompleted=" $ string(iTotalCompleted));
	}
}

function bool isCompleted ()
{
	local R6ExtractionZone anExtractionZone;
	local R6Rainbow aRainbow;
	local Controller aController;
	local R6PlayerController pR6PlayerController;
	local R6AIController pAIController;

	if ( isFailed() )
	{
		return False;
	}
	aController=m_mgr.Level.ControllerList;
JL0028:
	if ( aController != None )
	{
		pR6PlayerController=R6PlayerController(aController);
		if ( pR6PlayerController != None )
		{
			aRainbow=pR6PlayerController.m_pawn;
		}
		else
		{
			pAIController=R6AIController(aController);
			if ( pAIController != None )
			{
				aRainbow=R6Rainbow(pAIController.m_r6pawn);
			}
		}
		if ( aRainbow != None )
		{
			foreach aRainbow.TouchingActors(Class'R6ExtractionZone',anExtractionZone)
			{
				EnteredExtractionZone(aRainbow);
				goto JL00CC;
JL00CC:
			}
			if ( m_bCompleted || m_bFailed )
			{
				goto JL00FB;
			}
		}
		aController=aController.nextController;
		goto JL0028;
	}
JL00FB:
	return m_bCompleted;
}

defaultproperties
{
    m_bIfCompletedMissionIsSuccessfull=True
    m_bIfFailedMissionIsAborted=True
    m_bEndOfListOfObjectives=True
    m_szDescription="Completed all mission objetives"
}