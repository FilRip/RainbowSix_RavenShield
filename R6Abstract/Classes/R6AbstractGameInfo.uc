//================================================================================
// R6AbstractGameInfo.
//================================================================================
class R6AbstractGameInfo extends GameInfo
	Native
	Abstract;

var int m_iNbOfRainbowAIToSpawn;
var int m_iNbOfTerroristToSpawn;
var int m_iDiffLevel;
var int m_fTimerStartTime;
var bool m_bFriendlyFire;
var bool m_bEndGameIgnoreGamePlayCheck;
var bool m_bGameOverButAllowDeath;
var bool m_bTimerStarted;
var bool m_bInternetSvr;
var float m_fEndingTime;
var float m_fTimeBetRounds;
var float m_fEndKickVoteTime;
var PlayerController m_Player;
var R6AbstractNoiseMgr m_noiseMgr;
var R6MissionObjectiveMgr m_missionMgr;
var PlayerController m_PlayerKick;
var PlayerController m_pCurPlayerCtrlMdfSrvInfo;
var UdpBeacon m_UdpBeacon;
var string m_KickersName;
var string m_szDefaultActionPlan;

function Object GetRainbowTeam (int eTeamName);

function Actor GetNewTeam (Actor aCurrentTeam, optional bool bNextTeam);

function ChangeTeams (PlayerController inPlayerController, optional bool bPrevTeam, optional Actor newRainbowTeam);

function ChangeOperatives (PlayerController inPlayerController, int iTeamId, int iOperativeID);

function InstructAllTeamsToHoldPosition ();

function InstructAllTeamsToFollowPlanning ();

function BroadcastGameMsg (string szLocFile, string szPreMsg, string szMsgID, optional Sound sndGameStatus, optional int iLifeTime);

function R6AbstractNoiseMgr GetNoiseMgr ();

function Object GetMultiCoopPlayerVoicesMgr (int iTeam);

function Object GetMultiCoopMemberVoicesMgr ();

function Object GetPreRecordedMsgVoicesMgr ();

function Object GetMultiCommonVoicesMgr ();

function Object GetRainbowPlayerVoicesMgr ();

function Object GetRainbowMemberVoicesMgr ();

function Object GetCommonRainbowPlayerVoicesMgr ();

function Object GetCommonRainbowMemberVoicesMgr ();

function Object GetRainbowOtherTeamVoicesMgr (int iIDVoicesMgr);

function Object GetTerroristVoicesMgr (ETerroristNationality eNationality);

function Object GetHostageVoicesMgr (EHostageNationality eNationality, bool bIsFemale);

function bool ProcessKickVote (PlayerController _KickPlayer, string KickersName);

function ResetRound ();

function AdminResetRound ();

function ResetPenalty ();

function SetJumpingMaps (bool _flagSetting, int iNextMapIndex);

function UpdateRepResArrays ();

function PauseCountDown ();

function UnPauseCountDown ();

function StartTimer ();

function bool IsTeamSelectionLocked ();

function bool CanSwitchTeamMember ()
{
	return True;
}

function Actor GetRainbowAIFromTable ()
{
	return None;
}

function bool RainbowOperativesStillAlive ()
{
	return False;
}

function int GetNbOfRainbowAIToSpawn (PlayerController aController)
{
	return m_iNbOfRainbowAIToSpawn;
}

function CreateMissionObjectiveMgr ()
{
	if ( m_missionMgr == None )
	{
		m_missionMgr=Spawn(Class'R6MissionObjectiveMgr');
	}
}

function BroadcastMissionObjMsg (string szLocMsg, string szPreMsg, string szMsgID, optional Sound sndGameStatus, optional int iLifeTime);

function UpdateRepMissionObjectivesStatus ();

function UpdateRepMissionObjectives ();

function ResetRepMissionObjectives ();

function SpawnAIandInitGoInGame ();

function InitObjectives ();

function RemoveObjectives ()
{
	m_missionMgr.RemoveObjectives();
}

function PawnKilled (Pawn Killed)
{
	if ( m_bGameOver )
	{
		return;
	}
	m_missionMgr.PawnKilled(Killed);
	if ( CheckEndGame(None,"") )
	{
		EndGame(None,"");
	}
}

function RemoveTerroFromList (Pawn toRemove);

function PawnSeen (Pawn seen, Pawn witness)
{
	if ( m_bGameOver )
	{
		return;
	}
	m_missionMgr.PawnSeen(seen,witness);
	if ( CheckEndGame(None,"") )
	{
		EndGame(None,"");
	}
}

function PawnHeard (Pawn heard, Pawn witness)
{
	if ( m_bGameOver )
	{
		return;
	}
	m_missionMgr.PawnHeard(heard,witness);
	if ( CheckEndGame(None,"") )
	{
		EndGame(None,"");
	}
}

function PawnSecure (Pawn secured)
{
	if ( m_bGameOver )
	{
		return;
	}
	m_missionMgr.PawnSecure(secured);
	if ( CheckEndGame(None,"") )
	{
		EndGame(None,"");
	}
}

function bool IsLastRoundOfTheMatch ();

function float GetEndGamePauseTime ()
{
	if ( Level.NetMode == NM_Standalone )
	{
		return Level.m_fEndGamePauseTime;
	}
	else
	{
		if ( Level.IsGameTypeCooperative(Level.Game.m_eGameTypeFlag) )
		{
			return 6.00;
		}
		else
		{
			if ( IsLastRoundOfTheMatch() )
			{
				return 6.00;
			}
			else
			{
				return 4.00;
			}
		}
	}
}

function float GetGameMsgLifeTime ()
{
	if ( IsLastRoundOfTheMatch() && (Level.NetMode != 0) )
	{
		return 10.00;
	}
	else
	{
		return 5.00;
	}
}

function BaseEndGame ();

function EndGameAndJumpToMapID (int iGotoMapId)
{
	local R6ServerInfo pServerOptions;

	pServerOptions=Class'Actor'.static.GetServerOptions();
	if ( (pServerOptions != None) && (pServerOptions.m_ServerMapList != None) )
	{
		pServerOptions.m_ServerMapList.GetNextMap(iGotoMapId);
	}
	AbortScoreSubmission();
	SetJumpingMaps(True,iGotoMapId);
	if ( IsInState('InBetweenRoundMenu') || IsInState('PostBetweenRoundTime') )
	{
		RestartGameMgr();
	}
	else
	{
		BaseEndGame();
		m_bEndGameIgnoreGamePlayCheck=True;
	}
}

function AbortMission ()
{
	m_missionMgr.AbortMission();
	CheckEndGame(None,"");
	EndGame(None,"");
	m_bTimerStarted=True;
	m_fTimerStartTime=Level.TimeSeconds - GetEndGamePauseTime() - 1;
	m_fTimerStartTime=Clamp(m_fTimerStartTime,0,Level.TimeSeconds);
}

function CompleteMission ()
{
	m_missionMgr.CompleteMission();
	CheckEndGame(None,"");
	EndGame(None,"");
}

function EnteredExtractionZone (Actor Other)
{
	if ( m_bGameOver )
	{
		return;
	}
	m_missionMgr.EnteredExtractionZone(Pawn(Other));
	if ( CheckEndGame(None,"") )
	{
		EndGame(None,"");
	}
}

function LeftExtractionZone (Actor Other)
{
	if ( m_bGameOver )
	{
		return;
	}
	m_missionMgr.ExitExtractionZone(Pawn(Other));
	if ( CheckEndGame(None,"") )
	{
		EndGame(None,"");
	}
}

function IObjectInteract (Pawn aPawn, Actor anInteractiveObject)
{
	if ( m_bGameOver )
	{
		return;
	}
	if ( m_missionMgr == None )
	{
		return;
	}
	m_missionMgr.IObjectInteract(aPawn,anInteractiveObject);
	if ( CheckEndGame(None,"") )
	{
		EndGame(None,"");
	}
}

function IObjectDestroyed (Pawn aPawn, Actor anInteractiveObject)
{
	if ( m_bGameOver )
	{
		return;
	}
	m_missionMgr.IObjectDestroyed(aPawn,anInteractiveObject);
	if ( CheckEndGame(None,"") )
	{
		EndGame(None,"");
	}
}

function TimerCountdown ()
{
	if ( m_bGameOver )
	{
		return;
	}
	if ( CheckEndGame(None,"") )
	{
		EndGame(None,"");
	}
}

function ResetPlayerTeam (Controller aPlayer);

function RemoveController (Controller aPlayer);

function SetPawnTeamFriendlies (Pawn aPawn)
{
	SetDefaultTeamFriendlies(aPawn);
}

function SetDefaultTeamFriendlies (Pawn aPawn)
{
}

function SetTeamKillerPenalty (Pawn DeadPawn, Pawn KillerPawn);

function ApplyTeamKillerPenalty (Pawn aPawn);

function bool CheckEndGame (PlayerReplicationInfo Winner, string Reason)
{
	return False;
}

function PostBeginPlay ()
{
	SetTimer(0.00,False);
}

function PlayerReadySelected (PlayerController _Controller);

function IncrementRoundsFired (Pawn Instigator, bool ForceIncrement);

function NotifyMatchStart ();

function bool ProcessPlayerReadyStatus ();

function bool IsUnlimitedPractice ();

exec function SetUnlimitedPractice (bool bUnlimitedPractice, optional bool bSendMsg);

function LogVoteInfo ();

function string GetIntelVideoName (R6MissionDescription Desc)
{
	return "generic_intel";
}

defaultproperties
{
    m_iNbOfTerroristToSpawn=1
}
