//================================================================================
// R6AdversarialTeamGame.
//================================================================================
class R6AdversarialTeamGame extends R6MultiPlayerGameInfo;

struct MultiPlayerTeamInfo
{
	var array<R6PlayerController> m_aPlayerController;
	var int m_iLivingPlayers;
};

enum ePlayerTeamSelection {
	PTS_UnSelected,
	PTS_AutoSelect,
	PTS_Alpha,
	PTS_Bravo,
	PTS_Spectator
};

var const int c_iAlphaTeam;
var const int c_iBravoTeam;
var const int c_iMaxTeam;
var bool m_bAddObjDeathmatch;
var R6MObjDeathmatch m_objDeathmatch;
var Sound m_sndGreenTeamWonRound;
var Sound m_sndRedTeamWonRound;
var Sound m_sndRoundIsADraw;
var Sound m_sndGreenTeamWonMatch;
var Sound m_sndRedTeamWonMatch;
var Sound m_sndMatchIsADraw;
var MultiPlayerTeamInfo m_aTeam[2];

event PostBeginPlay ()
{
	Super.PostBeginPlay();
	AddSoundBankName("Voices_Control_Multiplayer");
}

function InitObjectives ()
{
	local int iLength;

	if ( m_bAddObjDeathmatch )
	{
		m_objDeathmatch=new Class'R6MObjDeathmatch';
		m_objDeathmatch.m_bTeamDeathmatch=True;
		iLength=m_missionMgr.m_aMissionObjectives.Length;
		m_missionMgr.m_aMissionObjectives[iLength]=m_objDeathmatch;
		iLength++;
	}
	Super.InitObjectives();
}

function int GetTeamIDFromTeamSelection (ePlayerTeamSelection eTeam)
{
	if ( eTeam == 2 )
	{
		return c_iAlphaTeam;
	}
	else
	{
		return c_iBravoTeam;
	}
}

function SetControllerTeamID (R6PlayerController PController, ePlayerTeamSelection eTeam)
{
	if ( eTeam == 2 )
	{
		PController.m_pawn.m_iTeam=2;
	}
	else
	{
		if ( eTeam == 3 )
		{
			PController.m_pawn.m_iTeam=3;
		}
	}
}

function bool IsPlayerInTeam (R6PlayerController PController, int iTeamId)
{
	local int i;

	if ( iTeamId >= c_iMaxTeam )
	{
		return False;
	}
	for (i=0;i<m_aTeam[iTeamId].m_aPlayerController.Length;i++)
		if ( m_aTeam[iTeamId].m_aPlayerController[i] == PController )
			return True;
	return False;
}

function AddPlayerToTeam (R6PlayerController PController, ePlayerTeamSelection eTeam)
{
	local int iLength;
	local int iTeamId;

	iTeamId=GetTeamIDFromTeamSelection(eTeam);
	iLength=m_aTeam[iTeamId].m_aPlayerController.Length;
	m_aTeam[iTeamId].m_aPlayerController[iLength]=PController;
	if ( bShowLog )
	{
		Log("AddPlayerToTeam pController=" $ string(PController) $ " (alpha=0, bravo=1) index=" $ string(iTeamId));
	}
}

function bool RemovePlayerFromTeams (R6PlayerController PController)
{
	local int iTeam;
	local int i;
	local bool bRemoved;

	for (iTeam=0;iTeam<2;++iTeam)
	{
		for (i=0;i<m_aTeam[iTeam].m_aPlayerController.Length;++i)
		{
			if ( m_aTeam[iTeam].m_aPlayerController[i] == PController )
			{
				m_aTeam[iTeam].m_aPlayerController.Remove (i,1);
				--i;
				bRemoved=True;
				if ( bShowLog )
				{
					Log("RemovePlayerFromTeam pController=" $ string(PController) $ " in team=" $ string(iTeam));
				}
			}
		}
	}
	return bRemoved;
}

function UpdateTeamInfo ()
{
	local int iTeam;
	local int i;

	iTeam=0;
JL0007:
	if ( iTeam < 2 )
	{
		m_aTeam[iTeam].m_iLivingPlayers=0;
		i=0;
JL002C:
		if ( i < m_aTeam[iTeam].m_aPlayerController.Length )
		{
			if ( m_aTeam[iTeam].m_aPlayerController[i].m_pawn.IsAlive() )
			{
				m_aTeam[iTeam].m_iLivingPlayers++;
			}
			++i;
			goto JL002C;
		}
		++iTeam;
		goto JL0007;
	}
}

simulated function ResetOriginalData ()
{
	local int iTeam;

	if ( m_bResetSystemLog )
	{
		LogResetSystem(False);
	}
	Super.ResetOriginalData();
	iTeam=0;
JL001D:
	if ( iTeam < 2 )
	{
		m_aTeam[iTeam].m_aPlayerController.Remove (0,m_aTeam[iTeam].m_aPlayerController.Length);
		m_aTeam[iTeam].m_iLivingPlayers=0;
		++iTeam;
		goto JL001D;
	}
}

function R6PlayerController GetLastManStanding ()
{
	local int iTeam;
	local int i;
	local R6PlayerController aController;
	local R6PlayerController aPotentialWinnerController;
	local int iPotentialWinner;

	iTeam=0;
JL0007:
	if ( iTeam < 2 )
	{
		m_aTeam[iTeam].m_iLivingPlayers=0;
		i=0;
JL002C:
		if ( i < m_aTeam[iTeam].m_aPlayerController.Length )
		{
			if ( (m_aTeam[iTeam].m_aPlayerController[i].m_pawn != None) && m_aTeam[iTeam].m_aPlayerController[i].m_pawn.IsAlive() )
			{
				if ( aController != None )
				{
					return None;
				}
				aController=m_aTeam[iTeam].m_aPlayerController[i];
				m_aTeam[iTeam].m_iLivingPlayers++;
			}
			aPotentialWinnerController=m_aTeam[iTeam].m_aPlayerController[i];
			iPotentialWinner++;
			++i;
			goto JL002C;
		}
		++iTeam;
		goto JL0007;
	}
	if ( iPotentialWinner == 1 )
	{
		return aPotentialWinnerController;
	}
	return aController;
}

function int GetRainbowTeamColourIndex (int eTeamName)
{
	return eTeamName - 1;
}

function int GetSpawnPointNum (string Options)
{
	return GetIntOption(Options,"SpawnNum",255);
}

function RemoveController (Controller aPlayer)
{
	RemovePlayerFromTeams(R6PlayerController(aPlayer));
}

function ResetPlayerTeam (Controller aPlayer)
{
/*	if (  !IsPlayerInTeam(R6PlayerController(aPlayer),GetTeamIDFromTeamSelection(R6PlayerController(aPlayer).m_TeamSelection)) )
	{
		RemovePlayerFromTeams(R6PlayerController(aPlayer));
		if ( (R6PlayerController(aPlayer).m_TeamSelection == 2) || (R6PlayerController(aPlayer).m_TeamSelection == 3) )
		{
			goto JL016D;
		}
		if ( R6PlayerController(aPlayer).m_TeamSelection == 1 )
		{
			if ( m_aTeam[c_iAlphaTeam].m_aPlayerController.Length <= m_aTeam[c_iBravoTeam].m_aPlayerController.Length )
			{
				R6PlayerController(aPlayer).m_TeamSelection=2;
			}
			else
			{
				R6PlayerController(aPlayer).m_TeamSelection=3;
			}
		}
		else
		{
			if ( bShowLog )
			{
				Log("R6AdversarialTeamGame: not added player " $ string(aPlayer.Pawn) $ "to Team yet");
			}
			R6Pawn(aPlayer.Pawn).m_iTeam=4;
			return;
		}
JL016D:
		AddPlayerToTeam(R6PlayerController(aPlayer),R6PlayerController(aPlayer).m_TeamSelection);
	}
	Super.ResetPlayerTeam(aPlayer);
	if ( R6PlayerController(aPlayer).m_pawn != None )
	{
		SetControllerTeamID(R6PlayerController(aPlayer),R6PlayerController(aPlayer).m_TeamSelection);
	} */
}

function SetPawnTeamFriendlies (Pawn aPawn)
{
	switch (aPawn.m_iTeam)
	{
/*		case 0:
		aPawn.m_iFriendlyTeams=GetTeamNumBit(2);
		aPawn.m_iFriendlyTeams += GetTeamNumBit(3);
		aPawn.m_iEnemyTeams=GetTeamNumBit(1);
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
		break;
		default:
		Log("warning: SetPawnTeamFriendlies team not supported for " $ string(aPawn.Name) $ " team=" $ string(aPawn.m_iTeam));
		break;  */
	}
}

function PlayerReadySelected (PlayerController _Controller)
{
	local Controller _aController;
	local int iHumanCountA;
	local int iHumanCountB;
	local ePlayerTeamSelection _TeamSelection;

	if ( (R6PlayerController(_Controller) == None) || IsInState('InBetweenRoundMenu') )
	{
		return;
	}
	GetNbHumanPlayerInTeam(iHumanCountA,iHumanCountB);
//	_TeamSelection=R6PlayerController(_Controller).m_TeamSelection;
	if (  !(_TeamSelection == 2) || (_TeamSelection == 3) )
	{
		return;
	}
	if ( Level.IsGameTypeTeamAdversarial(m_eGameTypeFlag) )
	{
		if ( (_TeamSelection == 2) && (iHumanCountA == 1) && (iHumanCountB > 0) || (_TeamSelection == 3) && (iHumanCountB == 1) && (iHumanCountA > 0) || (iHumanCountA + iHumanCountB == 1) )
		{
			ResetRound();
		}
	}
	else
	{
		if ( iHumanCountA <= 2 )
		{
			ResetRound();
		}
	}
}

function int GetTotalTeamFrag (int iTeamId)
{
	local int i;
	local int iFragCount;
	local R6PlayerController PController;

	i=0;
JL0007:
	if ( i < m_aTeam[iTeamId].m_aPlayerController.Length )
	{
		PController=m_aTeam[iTeamId].m_aPlayerController[i];
		if ( (PController.m_pawn != None) &&  !PController.m_pawn.m_bSuicided )
		{
			iFragCount += PController.PlayerReplicationInfo.m_iRoundKillCount;
		}
		++i;
		goto JL0007;
	}
	return iFragCount;
}

function AddTeamWonRound (int iTeamId)
{
	if ( m_bCompilingStats == False )
	{
		return;
	}
	if ( iTeamId < 2 )
	{
		R6GameReplicationInfo(GameReplicationInfo).m_aTeamScore[iTeamId]++;
	}
	else
	{
		Log("Warning: AddTeamWonRound teamID=" $ string(iTeamId) $ " and m_aTeamScore size is= " $ string(2));
	}
}

function int GetNbRoundWinner ()
{
	local int iTeam;
	local int iCurWinner;
	local int iCurWinnerScore;
	local bool bDraw;
	local R6GameReplicationInfo repGameInfo;

	repGameInfo=R6GameReplicationInfo(GameReplicationInfo);
	iCurWinner=-1;
	iCurWinnerScore=-1;
	iTeam=0;
JL002D:
	if ( iTeam < 2 )
	{
		if ( repGameInfo.m_aTeamScore[iTeam] == iCurWinnerScore )
		{
			bDraw=True;
		}
		else
		{
			if ( repGameInfo.m_aTeamScore[iTeam] > iCurWinnerScore )
			{
				iCurWinner=iTeam;
				iCurWinnerScore=repGameInfo.m_aTeamScore[iTeam];
				bDraw=False;
			}
		}
		++iTeam;
		goto JL002D;
	}
	if ( bDraw )
	{
		return -1;
	}
	else
	{
		return iCurWinner;
	}
}

function ResetMatchStat ()
{
	local int iTeam;
	local R6GameReplicationInfo repGameInfo;

	repGameInfo=R6GameReplicationInfo(GameReplicationInfo);
	iTeam=0;
JL0017:
	if ( iTeam < 2 )
	{
		repGameInfo.m_aTeamScore[iTeam]=0;
		++iTeam;
		goto JL0017;
	}
	Super.ResetMatchStat();
}

function string GetDeathMatchWinner ()
{
	local PlayerMenuInfo playerMenuInfo1;
	local PlayerMenuInfo playerMenuInfo2;

	R6GameReplicationInfo(GameReplicationInfo).RefreshMPInfoPlayerStats();
	GetFPlayerMenuInfo(0,playerMenuInfo1);
	GetFPlayerMenuInfo(1,playerMenuInfo2);
	if ( playerMenuInfo1.iRoundsWon > playerMenuInfo2.iRoundsWon )
	{
		return playerMenuInfo1.szPlayerName;
	}
	return "";
}

function EndGame (PlayerReplicationInfo Winner, string Reason)
{
	local R6GameReplicationInfo gameRepInfo;
	local int iWinnerID;
	local PlayerController PlayerCtrl;
	local string szWinner;

	if ( m_bGameOver )
	{
		return;
	}
	if ( IsLastRoundOfTheMatch() )
	{
		gameRepInfo=R6GameReplicationInfo(GameReplicationInfo);
		if ( Level.IsGameTypeTeamAdversarial(m_eGameTypeFlag) )
		{
			iWinnerID=GetNbRoundWinner();
			if ( iWinnerID == -1 )
			{
				BroadcastGameMsg("","","MatchIsADraw",m_sndMatchIsADraw,GetGameMsgLifeTime());
			}
			else
			{
				if ( iWinnerID == c_iAlphaTeam )
				{
					BroadcastGameMsg("","","GreenTeamWonMatch",m_sndGreenTeamWonMatch,GetGameMsgLifeTime());
				}
				else
				{
					if ( iWinnerID == c_iBravoTeam )
					{
						BroadcastGameMsg("","","RedTeamWonMatch",m_sndRedTeamWonMatch,GetGameMsgLifeTime());
					}
					else
					{
						Log("Warning: GetNbRoundWinner unknow id= " $ string(iWinnerID) $ " in " $ string(Class.Name));
					}
				}
			}
		}
		else
		{
			if ( Level.IsGameTypeAdversarial(m_eGameTypeFlag) )
			{
				szWinner=GetDeathMatchWinner();
				if ( szWinner == "" )
				{
					BroadcastGameMsg("","","MatchIsADraw",None,GetGameMsgLifeTime());
				}
				else
				{
					BroadcastGameMsg("",szWinner,"HasWonTheMatch",None,GetGameMsgLifeTime());
				}
			}
		}
	}
	Super.EndGame(Winner,Reason);
}

defaultproperties
{
    c_iBravoTeam=1
    c_iMaxTeam=2
    m_bAddObjDeathmatch=True
    m_bUnlockAllDoors=True
    m_sndGreenTeamWonRound=Sound'Voices_Control_Multiplayer.Play_Green_Team'
    m_sndRedTeamWonRound=Sound'Voices_Control_Multiplayer.Play_Red_Team'
    m_sndRoundIsADraw=Sound'Voices_Control_Multiplayer.Play_Round_Draw'
    m_sndGreenTeamWonMatch=Sound'Voices_Control_Multiplayer.Play_Green_Team_Match'
    m_sndRedTeamWonMatch=Sound'Voices_Control_Multiplayer.Play_Red_Team_Match'
    m_sndMatchIsADraw=Sound'Voices_Control_Multiplayer.Play_Match_Draw'
}



