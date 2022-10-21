//================================================================================
// R6MObjRescueHostage.
//================================================================================
class R6MObjRescueHostage extends R6MissionObjectiveBase;

var() int m_iRescuePercentage;
var() bool m_bRescueAllRemainingHostage;
var() bool m_bCheckPawnKilled;
var() R6DeploymentZone m_depZone;

function Init ()
{
	local int iTotal;
	local R6Hostage aHostage;
	local R6ExtractionZone aExtractZone;

	if ( R6MissionObjectiveMgr(m_mgr).m_bEnableCheckForErrors )
	{
		if ( m_depZone != None )
		{
			if ( m_depZone.m_aHostage.Length == 0 )
			{
				logMObj("there is no hostage in " $ string(m_depZone.Name));
			}
		}
		else
		{
			R6GameInfo(m_mgr.Level.Game).CheckForHostage(self,1);
		}
		R6GameInfo(m_mgr.Level.Game).CheckForExtractionZone(self);
	}
}

function PawnKilled (Pawn killedPawn)
{
	local R6Hostage H;
	local R6Hostage aHostage;
	local float fTotalDeath;
	local int iTotal;
	local int i;

	if (  !m_bCheckPawnKilled )
	{
		return;
	}
	if ( killedPawn.m_ePawnType != 3 )
	{
		return;
	}
	H=R6Hostage(killedPawn);
	if ( H.m_bCivilian )
	{
		return;
	}
	if ( m_depZone != None )
	{
		if ( m_depZone != H.m_DZone )
		{
			return;
		}
		for (i=0;i < m_depZone.m_aHostage.Length;++i)
		{
			if (  !m_depZone.m_aHostage[i].IsAlive() )
			{
				fTotalDeath += 1;
			}
			++iTotal;
		}
	}
	else
	{
		foreach m_mgr.DynamicActors(Class'R6Hostage',aHostage)
		{
			if (  !aHostage.m_bCivilian )
			{
				if (  !aHostage.IsAlive() )
				{
					fTotalDeath += 1;
				}
				++iTotal;
			}
		}
	}
	if ( m_bRescueAllRemainingHostage )
	{
		if ( fTotalDeath == iTotal )
		{
			R6MissionObjectiveMgr(m_mgr).SetMissionObjCompleted(self,False,True);
		}
	}
	else
	{
		if ( (fTotalDeath > 0) && (100 - fTotalDeath / iTotal * 100.00 <= m_iRescuePercentage) )
		{
			R6MissionObjectiveMgr(m_mgr).SetMissionObjCompleted(self,False,True);
		}
	}
	if ( m_bShowLog )
	{
		logX("PawnKilled. failed=" $ string(m_bFailed) $ " " $ string(fTotalDeath / iTotal * 100.00) $ "/" $ string(m_iRescuePercentage) $ "%");
	}
}

function EnteredExtractionZone (Pawn aPawn)
{
	local R6Hostage H;
	local R6Hostage aHostage;
	local float fRescuedNum;
	local int iTotal;
	local int i;
	local int iTotalAlive;

	if ( aPawn.m_ePawnType != 3 )
	{
		return;
	}
	H=R6Hostage(aPawn);
	if ( H.m_bCivilian )
	{
		return;
	}
	if ( m_depZone != None )
	{
		if ( m_depZone != H.m_DZone )
		{
			return;
		}
		for (i=0;i < m_depZone.m_aHostage.Length;++i)
		{
			aHostage=m_depZone.m_aHostage[i];
			if (  !aHostage.m_bCivilian )
			{
				if ( aHostage.IsAlive() )
				{
					iTotalAlive++;
					if ( aHostage.m_bExtracted )
					{
						fRescuedNum += 1;
					}
				}
				++iTotal;
			}
		}
	}
	else
	{
		foreach m_mgr.DynamicActors(Class'R6Hostage',aHostage)
		{
			if (  !aHostage.m_bCivilian )
			{
				if ( aHostage.IsAlive() )
				{
					iTotalAlive++;
					if ( aHostage.m_bExtracted )
					{
						fRescuedNum += 1;
					}
				}
				++iTotal;
			}
		}
	}
	if ( m_bRescueAllRemainingHostage )
	{
		if ( fRescuedNum == iTotalAlive )
		{
			R6MissionObjectiveMgr(m_mgr).SetMissionObjCompleted(self,True,True);
		}
	}
	else
	{
		if ( fRescuedNum / iTotal * 100.00 >= m_iRescuePercentage )
		{
			R6MissionObjectiveMgr(m_mgr).SetMissionObjCompleted(self,True,True);
		}
	}
	if ( m_bShowLog )
	{
		logX("EnteredExtZone. completed=" $ string(m_bCompleted) $ " " $ string(fRescuedNum / iTotal * 100.00) $ "/" $ string(m_iRescuePercentage) $ "%");
	}
}

function string GetDescriptionBasedOnNbOfHostages (LevelInfo Level)
{
	local R6Hostage aHostage;
	local int iTotal;

	foreach Level.DynamicActors(Class'R6Hostage',aHostage)
	{
		if ( aHostage.IsAlive() &&  !aHostage.m_bCivilian )
		{
			++iTotal;
		}
	}
	switch (iTotal)
	{
		case 1:
		return "RescueTheHostageToExtractionZone";
		case 2:
		return "RescueBothHostagesToExtractionZone";
		case 3:
		return "RescueThreeHostagesToExtractionZone";
		default:
	}
	return "RescueAllHostagesToExtractionZone";
}

defaultproperties
{
    m_iRescuePercentage=100
    m_bCheckPawnKilled=True
    m_bIfFailedMissionIsAborted=True
    m_sndSoundFailure=Sound'Voices_Control_MissionFailed.Play_HostageKilled'
    m_szDescription="Rescue hostage"
    m_szDescriptionInMenu="RescueAllHostagesToExtractionZone"
}