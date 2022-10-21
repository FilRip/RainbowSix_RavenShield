//================================================================================
// R6GameMenuCom.
//================================================================================
class R6GameMenuCom extends Object;
//	Export;

struct PlayerPrefInfo
{
	var string m_CharacterName;
	var string m_ArmorName;
	var string m_WeaponName[2];
	var string m_WeaponGadgetName[2];
	var string m_BulletType[2];
	var string m_GadgetName[2];
};

enum ER6GameType {
	RGM_AllMode,
	RGM_StoryMode,
	RGM_PracticeMode,
	RGM_MissionMode,
	RGM_TerroristHuntMode,
	RGM_TerroristHuntCoopMode,
	RGM_HostageRescueMode,
	RGM_HostageRescueCoopMode,
	RGM_HostageRescueAdvMode,
	RGM_DefendMode,
	RGM_DefendCoopMode,
	RGM_ReconMode,
	RGM_ReconCoopMode,
	RGM_DeathmatchMode,
	RGM_TeamDeathmatchMode,
	RGM_BombAdvMode,
	RGM_EscortAdvMode,
	RGM_LoneWolfMode,
	RGM_SquadDeathmatch,
	RGM_SquadTeamDeathmatch,
	RGM_TerroristHuntAdvMode,
	RGM_ScatteredHuntAdvMode,
	RGM_CaptureTheEnemyAdvMode,
	RGM_CountDownMode,
	RGM_KamikazeMode,
	RGM_NoRulesMode
};

enum eClientMenuState {
	CMS_Initial,
	CMS_SpecMenu,
	CMS_BetRoundmenu,
	CMS_DisplayStat,
	CMS_DisplayForceStat,
	CMS_PlayerDead,
	CMS_DisplayForceStatLocked,
	CMS_InPreGameState
};

enum ePlayerTeamSelection {
	PTS_UnSelected,
	PTS_AutoSelect,
	PTS_Alpha,
	PTS_Bravo,
	PTS_Spectator
};

var eClientMenuState m_eStatMenuState;
var ER6GameType m_ePreviousGameType;
var int m_iLastValidIndex;
var int m_iOldMapIndex;
var bool m_bImCurrentlyDisconnect;
var bool bShowLog;
var PlayerController m_PlayerController;
var GameReplicationInfo m_GameRepInfo;
var PlayerPrefInfo m_PlayerPrefInfo;
var string m_szPrimaryWeapon;
var string m_szPrimaryWeaponGadget;
var string m_szPrimaryWeaponBullet;
var string m_szPrimaryGadget;
var string m_szSecondaryWeapon;
var string m_szSecondaryWeaponGadget;
var string m_szSecondaryWeaponBullet;
var string m_szSecondaryGadget;
var string m_szArmor;
var string m_szServerName;

function PostBeginPlay ()
{
	InitialisePlayerSetupInfo();
}

function ClearLevelReferences ()
{
	m_PlayerController=None;
	m_GameRepInfo=None;
}

function bool IsInitialisationCompleted ()
{
	return (m_PlayerController != None) && (m_GameRepInfo != None);
}

simulated function ER6GameType GetGameType ();

simulated function InitialisePlayerSetupInfo ();

simulated function SavePlayerSetupInfo ();

simulated function SelectTeam ();

function SetupPlayerPrefs ();

function TKPopUpBox (string _KillerName);

function TKPopUpDone (bool _bApplyTeamKillerPenalty);

function ActiveVoteMenu (bool _bActiveMenu, optional string _szPlayerNameToKick);

function SetClientServerSettings (bool _bCanChangeOptions);

function CountDownPopUpBox ();

function CountDownPopUpBoxDone ();

function PlayerSelection (ePlayerTeamSelection newTeam)
{
	local int _TeamACount;
	local int _TeamBCount;

	if ( newTeam == 0 )
	{
		Log("ERROR: Menu engine returned PTS_UnSelected as player team");
		return;
	}
	RefreshReadyButtonStatus();
	if ( newTeam == m_PlayerController.m_TeamSelection )
	{
		SetStatMenuState(CMS_BetRoundmenu);
		return;
	}
	if ( m_GameRepInfo.IsInAGameState() )
	{
		if ( (newTeam == 4) ||  !m_GameRepInfo.m_bRestartableByJoin )
		{
			if ( m_PlayerController.Pawn == None )
			{
				m_PlayerController.m_bReadyToEnterSpectatorMode=True;
				m_PlayerController.Fire(0.00);
			}
			LoadSoundBankInSpectator();
			SetStatMenuState(CMS_SpecMenu);
		}
		else
		{
			SetStatMenuState(CMS_BetRoundmenu);
		}
	}
	else
	{
		SetStatMenuState(CMS_BetRoundmenu);
		if ( newTeam == 4 )
		{
			LoadSoundBankInSpectator();
		}
	}
//	m_PlayerController.ServerTeamRequested(newTeam);
	SavePlayerSetupInfo();
	m_ePreviousGameType=GetGameType();
}

function LoadSoundBankInSpectator ()
{
	if (  !m_PlayerController.m_bLoadSoundGun )
	{
		m_PlayerController.m_bLoadSoundGun=True;
		m_PlayerController.ServerReadyToLoadWeaponSound();
	}
}

function ePlayerTeamSelection IntToPTS (int InInt)
{
	switch (InInt)
	{
		case 0:
		return PTS_UnSelected;
		case 1:
		return PTS_AutoSelect;
		case 2:
		return PTS_Alpha;
		case 3:
		return PTS_Bravo;
		case 4:
		return PTS_Spectator;
		default:
	}
}

function int PTSToInt (ePlayerTeamSelection inEnum)
{
	local byte bCast;

	bCast=inEnum;
	return bCast;
}

function RefreshMPlayerInfo ()
{
	if ( m_GameRepInfo != None )
	{
		m_GameRepInfo.RefreshMPlayerInfo();
	}
}

function int GeTTeamSelection (int _iIndex);

function NewServerState ()
{
/*	if ( m_GameRepInfo == None )
	{
		return;
	}
	RefreshReadyButtonStatus();
	if ( (m_GameRepInfo.m_eCurrectServerState == m_GameRepInfo.1) || (m_GameRepInfo.m_eCurrectServerState == m_GameRepInfo.0) )
	{
		SetPlayerReadyStatus(False);
	}
	else
	{
		if ( m_GameRepInfo.m_eCurrectServerState == m_GameRepInfo.2 )
		{
			SetStatMenuState(CMS_InPreGameState);
		}
		else
		{
			if ( m_GameRepInfo.m_eCurrectServerState == m_GameRepInfo.3 )
			{
				if ( (m_PlayerController.m_TeamSelection == 2) || (m_PlayerController.m_TeamSelection == 3) )
				{
					SetPlayerReadyStatus(True);
					if (  !m_PlayerController.bOnlySpectator )
					{
						SetStatMenuState(CMS_DisplayStat);
					}
				}
				else
				{
					SetStatMenuState(CMS_SpecMenu);
				}
			}
			else
			{
				if ( m_GameRepInfo.m_eCurrectServerState == m_GameRepInfo.4 )
				{
					SetPlayerReadyStatus(False);
					if ( (m_PlayerController.Pawn != None) && (m_PlayerController.Pawn.EngineWeapon != None) )
					{
						m_PlayerController.Pawn.EngineWeapon.GotoState('None');
					}
					if ( bShowLog )
					{
						Log("NewServerState() m_GameRepInfo.RSS_EndOfMatch");
					}
					SetStatMenuState(CMS_DisplayForceStat);
				}
			}
		}
	}*/
}

function SetStatMenuState (eClientMenuState _eNewClientMenuState);

function SetPlayerReadyStatus (bool _bPlayerReady)
{
	if ( _bPlayerReady == m_PlayerController.PlayerReplicationInfo.m_bPlayerReady )
	{
		return;
	}
	m_PlayerController.PlayerReplicationInfo.m_bPlayerReady=_bPlayerReady;
	m_PlayerController.ServerSetPlayerReadyStatus(_bPlayerReady);
}

function RefreshReadyButtonStatus ();

function SetReadyButton (bool _bDisable)
{
}

function bool GetPlayerReadyStatus ()
{
	return m_PlayerController.PlayerReplicationInfo.m_bPlayerReady;
}

function bool GetPlayerDidASelection ();

function DisconnectClient (LevelInfo _Level);

simulated function bool IsInGame ()
{
	return False;
}
