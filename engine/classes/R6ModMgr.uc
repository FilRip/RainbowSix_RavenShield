//================================================================================
// R6ModMgr.
//================================================================================
class R6ModMgr extends Object
	Native;
//	Export;

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

var bool bShowLog;
var R6UPackageMgr m_pUPackageMgr;
var R6Mod m_pCurrentMod;
var R6Mod m_pMP1;
var R6Mod m_pMP2;
var R6Mod m_pRVS;
var array<R6Mod> m_aMods;
var array<Object> m_aObjects;
var string m_szPendingModName;

native(2020) final function AddNewModExtraPath ();

native(2021) final function SetSystemMod ();

native(3003) final function CallSndEngineInit (Level pLevel);

event int GetNbMods ()
{
	return m_aMods.Length;
}

event bool IsMissionPack ()
{
	return (m_pMP1 == m_pCurrentMod) || (m_pMP2 == m_pCurrentMod);
}

event bool IsRavenShield ()
{
	return m_pRVS == m_pCurrentMod;
}

event InitModMgr ()
{
	local R6FileManager pFileManager;
	local int i;
	local int j;
	local int jMove;
	local int iFiles;
	local string szIniFilename;
	local R6Mod aMod;

	pFileManager=new Class'R6FileManager';
	m_pUPackageMgr=new Class'R6UPackageMgr';
	m_pUPackageMgr.InitOperativeClassesMgr();
	iFiles=pFileManager.GetNbFile("..\\Mods\\","mod");
	i=0;
JL0055:
	if ( i < iFiles )
	{
		pFileManager.GetFileName(i,szIniFilename);
		if ( szIniFilename == "" )
		{
			goto JL0147;
		}
		aMod=new Class'R6Mod';
		aMod.Init(szIniFilename);
		j=0;
JL00B3:
		if ( j < m_aMods.Length )
		{
			if ( aMod.m_fPriority < m_aMods[j].m_fPriority )
			{
				goto JL00F7;
			}
			j++;
			goto JL00B3;
		}
JL00F7:
		jMove=m_aMods.Length;
JL0103:
		if ( jMove != j )
		{
			m_aMods[jMove]=m_aMods[jMove - 1];
			jMove--;
			goto JL0103;
		}
		m_aMods[j]=aMod;
JL0147:
		i++;
		goto JL0055;
	}
	SetCurrentMod("AthenaSword");
	m_pMP1=m_pCurrentMod;
	SetCurrentMod("MP2");
	m_pMP2=m_pCurrentMod;
	SetCurrentMod("RavenShield");
	m_pRVS=m_pCurrentMod;
}

function R6UPackageMgr GetPackageMgr ()
{
	return m_pUPackageMgr;
}

event SetCurrentMod (string szKeyWord, optional bool bInitSystem, optional Console pConsole, optional Level pLevel)
{
	local int i;
	local R6Mod pPreviousMod;

	pPreviousMod=m_pCurrentMod;
	i=0;
JL0012:
	if ( i < m_aMods.Length )
	{
		if ( (m_aMods[i].m_szKeyWord ~= szKeyWord) && m_aMods[i].m_bInstalled )
		{
			if ( bShowLog )
			{
				Log("CurrentMod: " $ szKeyWord);
			}
			m_pCurrentMod=m_aMods[i];
		}
		++i;
		goto JL0012;
	}
	if ( pPreviousMod != m_pCurrentMod )
	{
		CallSndEngineInit(pLevel);
		AddNewModExtraPath();
		SetSystemMod();
		if ( pConsole != None )
		{
			pConsole.GetAllMissionDescriptions();
		}
	}
}

event InitAllModObjects ()
{
	local int i;

	i=0;
JL0007:
	if ( i < m_aObjects.Length )
	{
		if ( m_aObjects[i] != None )
		{
			m_aObjects[i].InitMod();
		}
		i++;
		goto JL0007;
	}
}

event SetPendingMODFromGSName (string GSGameName)
{
	local int i;

	i=0;
JL0007:
	if ( i < m_aMods.Length )
	{
		if ( m_aMods[i].m_szGameServiceGameName ~= GSGameName )
		{
			m_szPendingModName=m_aMods[i].m_szKeyWord;
		}
		++i;
		goto JL0007;
	}
}

event AssertOnlyRS (string szDebug)
{
	if (  !IsMissionPack() )
	{
		return;
	}
	Log("AssertOnlyRS ERROR " $ szDebug);
	assert (False);
}

event AssertOnlyMP (string szDebug)
{
	if ( IsMissionPack() )
	{
		return;
	}
	Log("AssertOnlyMP ERROR " $ szDebug);
	assert (False);
}

function bool IsCampaignRS (string szCampaign)
{
	if ( m_pRVS == None )
	{
		return False;
	}
	return m_pRVS.m_szCampaignIniFile ~= szCampaign;
}

function bool IsCampaignMP1 (string szCampaign)
{
	if ( m_pMP1 == None )
	{
		return False;
	}
	return m_pMP1.m_szCampaignIniFile ~= szCampaign;
}

function bool IsCampaignMP2 (string szCampaign)
{
	if ( m_pMP2 == None )
	{
		return False;
	}
	return m_pMP2.m_szCampaignIniFile ~= szCampaign;
}

function bool IsGameTypeAvailable (ER6GameType eGameType)
{
	local int i;

	i=0;
JL0007:
	if ( i < m_pCurrentMod.m_eGameTypes.Length )
	{
		if ( eGameType == m_pCurrentMod.m_eGameTypes[i] )
		{
			return True;
		}
		i++;
		goto JL0007;
	}
	return False;
}

event string GetBackgroundsRoot ()
{
	return m_pCurrentMod.m_szBackgroundRootDir;
}

event string GetVideosRoot ()
{
	return m_pCurrentMod.m_szVideosRootDir;
}

event string GetCampaignDir ()
{
	return m_pCurrentMod.m_szCampaignDir;
}

event string GetIniFilesDir ()
{
	return m_pCurrentMod.m_szIniFilesDir;
}

event string GetPlayerCustomMission ()
{
	return m_pCurrentMod.m_szPlayerCustomMission;
}

function bool isRegistered (Object obj)
{
	local int i;

	i=0;
JL0007:
	if ( i < m_aObjects.Length )
	{
		if ( obj == m_aObjects[i] )
		{
			return True;
		}
		i++;
		goto JL0007;
	}
	return False;
}

function RegisterObject (Object obj)
{
	if ( isRegistered(obj) )
	{
		return;
	}
	m_aObjects[m_aObjects.Length]=obj;
}

function UnRegisterAllObject ()
{
	m_aObjects.Remove (0,m_aObjects.Length);
}

function UnRegisterObject (Object obj)
{
	local int i;

	i=0;
JL0007:
	if ( i < m_aObjects.Length )
	{
		if ( obj == m_aObjects[i] )
		{
			m_aObjects.Remove (i,1);
		}
		else
		{
			i++;
			goto JL0007;
		}
	}
}

function DebugRegisterObject (string sz)
{
	local int i;

	Log(sz);
	i=0;
JL000E:
	if ( i < m_aObjects.Length )
	{
		Log(string(m_aObjects[i]));
		i++;
		goto JL000E;
	}
}

function string GetCreditsFile ()
{
	return "..\\" $ GetIniFilesDir() $ "\\" $ m_pCurrentMod.m_szCreditsFile;
}

function string GetMenuDefFile ()
{
	return "..\\" $ GetIniFilesDir() $ "\\" $ m_pCurrentMod.m_szMenuDefinesFile;
}

event string GetUbiComClientVersion ()
{
	return "RSPC1.2";
}

event string GetGameServiceGameName ()
{
	return m_pCurrentMod.m_szGameServiceGameName;
}

event string GetServerIni ()
{
	return "..\\" $ GetIniFilesDir() $ "\\" $ m_pCurrentMod.m_szServerIni;
}

event string GetModKeyword ()
{
	return m_pCurrentMod.m_szKeyWord;
}

event string GetModName ()
{
	return m_pCurrentMod.m_szName;
}

function AddGameTypes (LevelInfo pLevelInfo)
{
}
