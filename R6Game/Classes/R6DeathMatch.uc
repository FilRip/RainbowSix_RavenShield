//================================================================================
// R6DeathMatch.
//================================================================================
class R6DeathMatch extends R6AdversarialTeamGame;

var int m_iNextPlayerTeamID;

function int GetRainbowTeamColourIndex (int eTeamName)
{
	return 1;
}

function BroadcastTeam (Actor Sender, coerce string Msg, optional name type)
{
}

function InitObjectives ()
{
	m_iNextPlayerTeamID=4 + 1;
	m_missionMgr.m_bOnSuccessAllObjectivesAreCompleted=False;
	Level.m_bUseDefaultMoralityRules=False;
	Super.InitObjectives();
}

function EndGame (PlayerReplicationInfo Winner, string Reason)
{
	local R6GameReplicationInfo gameRepInfo;

	if ( m_bGameOver )
	{
		return;
	}
	gameRepInfo=R6GameReplicationInfo(GameReplicationInfo);
	if ( m_objDeathmatch.m_bCompleted && (m_bCompilingStats == True) )
	{
		if ( bShowLog )
		{
			Log("** Game : someone won the deathmatch ");
		}
		m_objDeathmatch.m_winnerCtrl.PlayerReplicationInfo.m_iRoundsWon++;
		BroadcastGameMsg("",m_objDeathmatch.m_winnerCtrl.PlayerReplicationInfo.PlayerName,"HasWonTheRound",None,GetGameMsgLifeTime());
	}
	else
	{
		BroadcastGameMsg("","","RoundIsADraw",None,GetGameMsgLifeTime());
		if ( bShowLog )
		{
			Log("** Game : it's a draw");
		}
	}
	Super.EndGame(Winner,Reason);
}

function int GetSpawnPointNum (string Options)
{
	return 0;
}

function ResetPlayerTeam (Controller aPlayer)
{
	Super.ResetPlayerTeam(aPlayer);
	aPlayer.Pawn.PlayerReplicationInfo.TeamID=m_iNextPlayerTeamID;
	R6Pawn(aPlayer.Pawn).m_iTeam=m_iNextPlayerTeamID;
	m_iNextPlayerTeamID++;
}

function SetPawnTeamFriendlies (Pawn aPawn)
{
	aPawn.m_iFriendlyTeams=GetTeamNumBit(aPawn.m_iTeam);
	aPawn.m_iEnemyTeams= ~aPawn.m_iFriendlyTeams;
}

defaultproperties
{
    m_iUbiComGameMode=1
    m_bIsRadarAllowed=False
    m_bIsWritableMapAllowed=False
    m_eGameTypeFlag=RGM_DeathmatchMode
}