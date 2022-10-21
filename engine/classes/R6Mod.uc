//================================================================================
// R6Mod.
//================================================================================
class R6Mod extends Object
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

var config int version;
var config bool m_bInstalled;
var config float m_fPriority;
var config array<string> m_ALocFile;
var config array<string> m_aExtraPaths;
var config array<string> m_aDescriptionPackage;
var config array<ER6GameType> m_eGameTypes;
var config string m_szKeyWord;
var string m_szName;
var string m_szModInfo;
var config string m_szGameServiceGameName;
var config string m_szCampaignDir;
var config string m_szPlayerCustomMission;
var config string m_szServerIni;
var config string m_szCampaignIniFile;
var config string m_szBackgroundRootDir;
var config string m_szVideosRootDir;
var config string m_szIniFilesDir;
var config string m_szCreditsFile;
var config string m_szMenuDefinesFile;
const C_iR6ModVersion= 1;

function Init (string szFile)
{
	local R6ModMgr pModManager;

	LoadConfig("..\\Mods\\" $ szFile);
	if ( (version != 1) || (version == 0) || (m_szKeyWord == "") )
	{
		Log("WARNING: problem initializing mod " $ szFile);
		return;
	}
	pModManager=Class'Actor'.static.GetModMgr();
	pModManager.m_pCurrentMod=self;
	pModManager.SetSystemMod();
	m_szName=Localize(m_szKeyWord,"ModName","R6Mod",True);
	m_szModInfo=Localize(m_szKeyWord,"ModInfo","R6Mod",True);
	if ( Len(m_szKeyWord) > 20 )
	{
		assert (False);
	}
}

function LogArray (string S, array<string> anArray)
{
	local int i;

	Log(S $ ":");
	for (i=0;i < anArray.Length;++i)
	{
		Log("   -" $ anArray[i]);
	}
}

function LogInfo ()
{
	Log("");
	Log(" R6Mod Information");
	Log(" =================");
	Log("	m_szKeyWord = " $ m_szKeyWord);
	Log("  version= " $ string(version));
	Log("  installed=" $ string(m_bInstalled));
	Log("  m_fPriority=" $ string(m_fPriority));
	Log("  m_szName= " $ m_szName);
	Log("  m_szModInfo=" $ m_szModInfo);
	Log("  m_szCampaignIniFile=" $ m_szCampaignIniFile);
	Log("  m_szCampaignDir=" $ m_szCampaignDir);
	Log("  m_szPlayerCustomMission=" $ m_szPlayerCustomMission);
	Log("  m_szBackgroundRootDir=" $ m_szBackgroundRootDir);
	Log("  m_szVideosRootDir=" $ m_szVideosRootDir);
	Log("  m_szCreditsFile= " $ m_szCreditsFile);
	Log("");
	Log("Localization Files:");
	Log("===================");
	Log("");
	Log(" Description Packages");
	Log(" ====================");
	LogArray("	 m_aDescriptionPackage",m_aDescriptionPackage);
}
