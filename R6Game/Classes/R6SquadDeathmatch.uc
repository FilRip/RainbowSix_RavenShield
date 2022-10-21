//================================================================================
// R6SquadDeathmatch.
//================================================================================
class R6SquadDeathmatch extends R6AdversarialTeamGame;

var int m_iNextPlayerTeamID;

function InitObjectives ()
{
	m_iNextPlayerTeamID=2;
	Level.m_bUseDefaultMoralityRules=False;
	Super.InitObjectives();
}

function int GetNbOfRainbowAIToSpawn (PlayerController aController)
{
	if ( R6PlayerController(aController).m_TeamSelection == 2 )
	{
		return m_iNbOfRainbowAIToSpawn;
	}
	else
	{
		return 0;
	}
}

auto state InBetweenRoundMenu
{
	function EndState ()
	{
		local int iNbOfPlayer;
		local Controller P;

		for (P=Level.ControllerList;P != None;P=P.nextController)
		{
			if ( P.IsA('PlayerController') && (P.PlayerReplicationInfo != None) && (R6PlayerController(P).m_TeamSelection == 2) )
			{
				++iNbOfPlayer;
			}
		}
		switch (iNbOfPlayer)
		{
			case 0:
			m_iNbOfRainbowAIToSpawn=0;
			break;
			case 1:
			m_iNbOfRainbowAIToSpawn=4;
			break;
			case 2:
			m_iNbOfRainbowAIToSpawn=3;
			break;
			case 3:
			m_iNbOfRainbowAIToSpawn=3;
			break;
			case 4:
			m_iNbOfRainbowAIToSpawn=3;
			break;
			case 5:
			m_iNbOfRainbowAIToSpawn=2;
			break;
			case 6:
			m_iNbOfRainbowAIToSpawn=2;
			break;
			case 7:
			m_iNbOfRainbowAIToSpawn=1;
			break;
			case 8:
			m_iNbOfRainbowAIToSpawn=1;
			break;
			case 9:
			m_iNbOfRainbowAIToSpawn=1;
			break;
			case 10:
			m_iNbOfRainbowAIToSpawn=1;
			break;
			default:
			m_iNbOfRainbowAIToSpawn=0;
		}
		if ( bShowLog )
		{
			Log("NotifyMatchStart nb of player: " $ string(iNbOfPlayer) $ " AI in a team: " $ string(m_iNbOfRainbowAIToSpawn));
		}
		Super.EndState();
	}

}

function ResetPlayerTeam (Controller aPlayer)
{
	local R6Pawn aPawn;

	Super.ResetPlayerTeam(aPlayer);
	aPawn=R6Pawn(aPlayer.Pawn);
	aPawn.PlayerReplicationInfo.TeamID=m_iNextPlayerTeamID;
	aPawn.m_iTeam=m_iNextPlayerTeamID;
	m_iNextPlayerTeamID++;
	R6PlayerController(aPlayer).m_TeamManager.SetMemberTeamID(aPawn.m_iTeam);
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
	BroadcastGameMsg("","","GameOver",None,GetGameMsgLifeTime());
	if ( m_objDeathmatch.m_bCompleted )
	{
		if ( bShowLog )
		{
			Log("** Game : the pilot was extracted");
		}
		BroadcastGameMsg("",m_objDeathmatch.m_winnerCtrl.PlayerReplicationInfo.PlayerName,"HasWonTheRound",None,GetGameMsgLifeTime());
	}
	else
	{
		if ( bShowLog )
		{
			Log("** Game : it's a draw");
		}
		BroadcastGameMsg("","","RoundIsADraw",None,GetGameMsgLifeTime());
	}
	Super.EndGame(Winner,Reason);
}

defaultproperties
{
    m_eGameTypeFlag=RGM_SquadDeathmatch
}
