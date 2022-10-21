//================================================================================
// R6TeamDeathMatchGame.
//================================================================================
class R6TeamDeathMatchGame extends R6AdversarialTeamGame;

function InitObjectives ()
{
	Level.m_bUseDefaultMoralityRules=False;
	Super.InitObjectives();
}

function EndGame (PlayerReplicationInfo Winner, string Reason)
{
	local R6GameReplicationInfo gameRepInfo;

	if (m_bGameOver)
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
    m_iUbiComGameMode=2
    m_eGameTypeFlag=RGM_TeamDeathmatchMode
}
