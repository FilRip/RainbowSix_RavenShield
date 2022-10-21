//================================================================================
// R6HostageRescueAdvGame.
//================================================================================
class R6HostageRescueAdvGame extends R6AdversarialTeamGame;

var int m_iIfDeadHostageMinNbToRescue;
var R6MObjRescueHostage m_objRescueHostage;
var R6MObjAcceptableHostageLossesByRainbow m_objHostageLossesByAlpha;
var R6MObjAcceptableHostageLossesByRainbow m_objHostageLossesByBravo;

function InitObjectives ()
{
	local R6Hostage hostage;
	local int iLength;
	local int iTotalHostage;

	foreach DynamicActors(Class'R6Hostage',hostage)
	{
		hostage.m_controller.m_bForceToStayHere=True;
//		hostage.m_ePersonality=0;
		iTotalHostage++;
	}
	if ( (iTotalHostage == 0) && m_missionMgr.m_bEnableCheckForErrors )
	{
		Log("WARNING: there is no hostage in the game type: " $ string(self));
	}
	m_iIfDeadHostageMinNbToRescue=Clamp(iTotalHostage,0,2);
	m_objRescueHostage=new Class'R6MObjRescueHostage';
	m_objRescueHostage.m_szDescriptionInMenu=m_objRescueHostage.GetDescriptionBasedOnNbOfHostages(Level);
	iLength=m_missionMgr.m_aMissionObjectives.Length;
	m_missionMgr.m_aMissionObjectives[iLength]=m_objRescueHostage;
	iLength++;
	m_objHostageLossesByAlpha=new Class'R6MObjAcceptableHostageLossesByRainbow';
	m_missionMgr.m_aMissionObjectives[iLength]=m_objHostageLossesByAlpha;
	iLength++;
	m_objHostageLossesByBravo=new Class'R6MObjAcceptableHostageLossesByRainbow';
	m_missionMgr.m_aMissionObjectives[iLength]=m_objHostageLossesByBravo;
	iLength++;
	m_objRescueHostage.m_iRescuePercentage=0;
	m_objRescueHostage.m_bRescueAllRemainingHostage=True;
	m_objRescueHostage.m_bIfFailedMissionIsAborted=True;
	m_objRescueHostage.m_bIfCompletedMissionIsSuccessfull=True;
	m_objRescueHostage.m_bCheckPawnKilled=True;
	InitObjHostageLossesByTeamID(m_objHostageLossesByAlpha,2,100);
	InitObjHostageLossesByTeamID(m_objHostageLossesByBravo,3,100);
	m_missionMgr.m_bOnSuccessAllObjectivesAreCompleted=False;
	Level.m_bUseDefaultMoralityRules=False;
	Super.InitObjectives();
}

function InitObjHostageLossesByTeamID (R6MObjAcceptableHostageLossesByRainbow obj, int iTeamId, int iAcceptableLost)
{
	local string szTeamName;

	obj.m_iKillerTeamID=iTeamId;
	obj.m_bMoralityObjective=False;
	obj.m_bIfFailedMissionIsAborted=True;
	obj.m_iAcceptableLost=iAcceptableLost;
	obj.m_bVisibleInMenu=False;
	if ( iTeamId == 2 )
	{
		szTeamName="Alpha";
	}
	else
	{
		if ( iTeamId == 3 )
		{
			szTeamName="Bravo";
		}
		else
		{
			szTeamName="Unknow";
		}
	}
	obj.m_szDescription="HostageLossesByTeamID by " $ szTeamName;
	obj.m_szDescriptionInMenu="AvoidHostageCasualities";
}

function PawnKilled (Pawn killedPawn)
{
	if ( m_bGameOver )
	{
		return;
	}
	Super.PawnKilled(killedPawn);
	EnteredExtractionZone(killedPawn);
}

function EnteredExtractionZone (Actor anActor)
{
	local int i;
	local int iTotalRescued;
	local int iTotalAlive;
	local int iTotalHostage;
	local bool bSendMsg;
	local R6Pawn aPawn;
	local R6Hostage hostage;

	if ( m_bGameOver )
	{
		return;
	}
	aPawn=R6Pawn(anActor);
	if ( (aPawn == None) && (aPawn.m_ePawnType != 3) )
	{
		return;
	}
	foreach DynamicActors(Class'R6Hostage',hostage)
	{
		if ( hostage.m_bExtracted && hostage.IsAlive() &&  !hostage.m_bFeedbackExtracted )
		{
			hostage.m_bFeedbackExtracted=True;
			bSendMsg=True;
		}
		if ( hostage.IsAlive() )
		{
			++iTotalAlive;
			if ( hostage.m_bExtracted )
			{
				++iTotalRescued;
			}
		}
		iTotalHostage++;
	}
	if ( bSendMsg )
	{
		if ( (iTotalHostage == iTotalRescued) || (iTotalAlive != iTotalHostage) && (iTotalRescued >= m_iIfDeadHostageMinNbToRescue) )
		{
			if ( bShowLog )
			{
				Log(" ** Game: All hostage has been rescued");
			}
			BroadcastMissionObjMsg("","","AllHostagesHaveBeenRescued");
		}
		else
		{
			if ( bShowLog )
			{
				Log(" ** Game: A hostage has been rescued");
			}
			BroadcastMissionObjMsg("","","HostageHasBeenRescued");
		}
	}
	Super.EnteredExtractionZone(aPawn);
}

function EndGame (PlayerReplicationInfo Winner, string Reason)
{
	if ( m_bGameOver )
	{
		return;
	}
	if ( m_objDeathmatch.m_bFailed )
	{
		if ( bShowLog )
		{
			Log("** Game : it's a draw");
		}
		BroadcastGameMsg("","","RoundIsADraw",m_sndRoundIsADraw,GetGameMsgLifeTime());
	}
	else
	{
		if ( m_objHostageLossesByAlpha.m_bFailed )
		{
			if ( bShowLog )
			{
				Log("** Game : bravo win, because alpha eleminated too much hostage");
			}
			BroadcastGameMsg("","","RedTeamWonRound",m_sndRedTeamWonRound,GetGameMsgLifeTime());
			BroadcastMissionObjMsg("","","GreenEleminatedTooManyHostages",None,GetGameMsgLifeTime());
			AddTeamWonRound(c_iBravoTeam);
		}
		else
		{
			if ( m_objHostageLossesByBravo.m_bFailed )
			{
				if ( bShowLog )
				{
					Log("** Game : alpha win, because bravo eleminated too much hostage");
				}
				BroadcastGameMsg("","","GreenTeamWonRound",m_sndGreenTeamWonRound,GetGameMsgLifeTime());
				BroadcastMissionObjMsg("","","RedEleminatedTooManyHostages",None,GetGameMsgLifeTime());
				AddTeamWonRound(c_iAlphaTeam);
			}
			else
			{
				if ( m_objRescueHostage.m_bFailed )
				{
					if ( bShowLog )
					{
						Log("** Game : it's a draw");
					}
					BroadcastGameMsg("","","RoundIsADraw",m_sndRoundIsADraw,GetGameMsgLifeTime());
				}
				else
				{
					if ( m_objDeathmatch.m_bCompleted )
					{
						if ( m_objDeathmatch.m_iWinningTeam == 2 )
						{
							if ( bShowLog )
							{
								Log("** Game : alpha eleminated bravo");
							}
							BroadcastGameMsg("","","GreenTeamWonRound",m_sndGreenTeamWonRound,GetGameMsgLifeTime());
							BroadcastMissionObjMsg("","","GreenNeutralizedRed",None,GetGameMsgLifeTime());
							AddTeamWonRound(c_iAlphaTeam);
						}
						else
						{
							if ( m_objDeathmatch.m_iWinningTeam == 3 )
							{
								if ( bShowLog )
								{
									Log("** Game : bravo eleminated alpha");
								}
								BroadcastGameMsg("","","RedTeamWonRound",m_sndRedTeamWonRound,GetGameMsgLifeTime());
								BroadcastMissionObjMsg("","","RedNeutralizedGreen",None,GetGameMsgLifeTime());
								AddTeamWonRound(c_iBravoTeam);
							}
						}
					}
					else
					{
						if ( m_objRescueHostage.m_bCompleted )
						{
							if ( bShowLog )
							{
								Log("** Game : alpha rescued enough hostage");
							}
							BroadcastGameMsg("","","GreenTeamWonRound",m_sndGreenTeamWonRound,GetGameMsgLifeTime());
							BroadcastMissionObjMsg("","","HostagesHaveBeenRescued",None,GetGameMsgLifeTime());
							AddTeamWonRound(c_iAlphaTeam);
						}
						else
						{
							if ( bShowLog )
							{
								Log("** Game : bravo kept the hostage from Alpha");
							}
							BroadcastGameMsg("","","RedTeamWonRound",m_sndRedTeamWonRound,GetGameMsgLifeTime());
							BroadcastMissionObjMsg("","","HostagesWhereNotRescued",None,GetGameMsgLifeTime());
							AddTeamWonRound(c_iBravoTeam);
						}
					}
				}
			}
		}
	}
	Super.EndGame(Winner,Reason);
}

function SetPawnTeamFriendlies (Pawn aPawn)
{
	switch (aPawn.m_iTeam)
	{
		case 0:
		aPawn.m_iFriendlyTeams=0;
		aPawn.m_iEnemyTeams=GetTeamNumBit(1);
		aPawn.m_iEnemyTeams += GetTeamNumBit(3);
		break;
		case 1:
		aPawn.m_iFriendlyTeams=GetTeamNumBit(1);
		aPawn.m_iEnemyTeams=GetTeamNumBit(2);
		aPawn.m_iEnemyTeams += GetTeamNumBit(3);
		break;
		case 2:
		aPawn.m_iFriendlyTeams=GetTeamNumBit(2);
		aPawn.m_iEnemyTeams=GetTeamNumBit(3);
		aPawn.m_iEnemyTeams += GetTeamNumBit(1);
		break;
		case 3:
		aPawn.m_iFriendlyTeams=GetTeamNumBit(3);
		aPawn.m_iEnemyTeams=GetTeamNumBit(2);
		aPawn.m_iEnemyTeams += GetTeamNumBit(1);
		aPawn.m_iEnemyTeams += GetTeamNumBit(0);
		break;
		default:
		Log("warning: SetPawnTeamFriendlies team not supported for " $ string(aPawn.Name) $ " team=" $ string(aPawn.m_iTeam));
		break;
	}
}

defaultproperties
{
    m_iUbiComGameMode=4
    m_bFeedbackHostageExtracted=False
    m_eGameTypeFlag=RGM_HostageRescueAdvMode
}
