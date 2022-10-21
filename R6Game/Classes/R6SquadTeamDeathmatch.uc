//================================================================================
// R6SquadTeamDeathmatch.
//================================================================================
class R6SquadTeamDeathmatch extends R6AdversarialTeamGame;

var int m_iNextPlayerTeamID;

function InitObjectives ()
{
	Level.m_bUseDefaultMoralityRules=False;
	Super.InitObjectives();
}

function int GetNbOfRainbowAIToSpawnBaseOnTeamNb (int iTeamNb)
{
	switch (iTeamNb)
	{
		case 0:
		return 0;
		case 1:
		return 3;
		case 2:
		return 3;
		case 3:
		return 3;
		case 4:
		return 2;
		default:
	}
	return 1;
}

function int GetNbOfRainbowAIToSpawn (PlayerController aController)
{
	local int iAlphaNb;
	local int iBravoNb;
	local int iHumanNb;
	local int iAdjustedMax;
	local int iNbAssigned;
	local int iNbPawnAssignedForThisController;
	local int iAiMax;
	local ePlayerTeamSelection eTeamToAdjust;
	local Controller P;

	if ( (R6PlayerController(aController).m_TeamSelection != 2) && (R6PlayerController(aController).m_TeamSelection != 3) )
	{
		return 0;
	}
	GetNbHumanPlayerInTeam(iAlphaNb,iBravoNb);
	if ( R6PlayerController(aController).m_TeamSelection == 2 )
	{
		iAiMax=GetNbOfRainbowAIToSpawnBaseOnTeamNb(iAlphaNb);
	}
	else
	{
		iAiMax=GetNbOfRainbowAIToSpawnBaseOnTeamNb(iBravoNb);
	}
	if ( (iAlphaNb == iBravoNb) || (iAlphaNb == 0) || (iBravoNb == 0) )
	{
		return iAiMax;
	}
	if ( R6PlayerController(aController).m_TeamSelection == 2 )
	{
		if ( iAlphaNb < iBravoNb )
		{
			return iAiMax;
		}
	}
	else
	{
		if ( iAlphaNb > iBravoNb )
		{
			return iAiMax;
		}
	}
	if ( iAlphaNb > iBravoNb )
	{
		iAdjustedMax=GetNbOfRainbowAIToSpawnBaseOnTeamNb(iBravoNb) * iBravoNb;
//		eTeamToAdjust=2;
		iHumanNb=iAlphaNb;
	}
	else
	{
		iAdjustedMax=GetNbOfRainbowAIToSpawnBaseOnTeamNb(iAlphaNb) * iAlphaNb;
//		eTeamToAdjust=3;
		iHumanNb=iBravoNb;
	}
	iAdjustedMax -= iHumanNb;
JL0181:
	if ( iAdjustedMax > 0 )
	{
		P=Level.ControllerList;
JL01A0:
		if ( P != None )
		{
			if ( (R6PlayerController(P) != None) && (R6PlayerController(P).m_TeamSelection == eTeamToAdjust) )
			{
				if ( aController == P )
				{
					++iNbPawnAssignedForThisController;
				}
				iAdjustedMax--;
			}
			if ( iAdjustedMax == 0 )
			{
				goto JL0220;
			}
			P=P.nextController;
			goto JL01A0;
		}
JL0220:
		goto JL0181;
	}
	iNbPawnAssignedForThisController++;
	return iNbPawnAssignedForThisController;
}

function SetPawnTeamFriendlies (Pawn aPawn)
{
	aPawn.m_iFriendlyTeams=GetTeamNumBit(aPawn.m_iTeam);
	aPawn.m_iEnemyTeams= ~aPawn.m_iFriendlyTeams;
}

function EndGame (PlayerReplicationInfo Winner, string Reason)
{
	local R6GameReplicationInfo gameRepInfo;

	if ( m_bGameOver )
	{
		return;
	}
	gameRepInfo=R6GameReplicationInfo(GameReplicationInfo);
	if ( m_objDeathmatch.m_bCompleted )
	{
		if ( m_objDeathmatch.m_iWinningTeam == 2 )
		{
			BroadcastGameMsg("","","GreenTeamWonRound",m_sndGreenTeamWonRound,GetGameMsgLifeTime());
			BroadcastMissionObjMsg("","","GreenNeutralizedRed",None,GetGameMsgLifeTime());
			AddTeamWonRound(c_iAlphaTeam);
		}
		else
		{
			if ( m_objDeathmatch.m_iWinningTeam == 3 )
			{
				BroadcastGameMsg("","","RedTeamWonRound",m_sndRedTeamWonRound,GetGameMsgLifeTime());
				BroadcastMissionObjMsg("","","RedNeutralizedGreen",None,GetGameMsgLifeTime());
				AddTeamWonRound(c_iBravoTeam);
			}
		}
	}
	else
	{
		if ( bShowLog )
		{
			Log("** Game : it's a draw");
		}
		BroadcastGameMsg("","","RoundIsADraw",m_sndRoundIsADraw,GetGameMsgLifeTime());
	}
	Super.EndGame(Winner,Reason);
}

defaultproperties
{
    m_eGameTypeFlag=RGM_SquadTeamDeathmatch
}
