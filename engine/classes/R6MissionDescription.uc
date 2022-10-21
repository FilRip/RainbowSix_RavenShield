//================================================================================
// R6MissionDescription.
//================================================================================
class R6MissionDescription extends Object
	Native;
//	Export;

struct GameTypeSkin
{
	var string Package;
	var string type;
	var string greenPackage;
	var string Green;
	var string redPackage;
	var string Red;
};

struct GameTypeMaxPlayer
{
	var string Package;
	var string type;
	var int maxNb;
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

const C_iR6MissionDescriptionVersion= 3;
var config int version;
var bool m_bCampaignMission;
var bool m_bIsLocked;
var config Sound m_PlayEventControl;
var config Sound m_PlayEventClark;
var config Sound m_PlayEventSweeney;
var config Sound m_PlayMissionIntro;
var config Sound m_PlayMissionExtro;
var config Texture m_TMissionOverview;
var config Texture m_TWorldMap;
var config array<GameTypeMaxPlayer> GameTypes;
var array<ER6GameType> m_eGameTypes;
var config array<Class> m_MissionArmorTypes;
var config array<GameTypeSkin> SkinsPerGameTypes;
var config Region m_RMissionOverview;
var config Region m_RWorldMap;
var string m_missionIniFile;
var config string m_MapName;
var config string m_ShortName;
var config string mod;
var config string LocalizationFile;
var config string m_AudioBankName;
var config string m_InGameVoiceClarkBankName;

event Reset ()
{
	m_missionIniFile="";
	m_MapName="";
	version=0;
	GameTypes.Remove (0,GameTypes.Length);
	SkinsPerGameTypes.Remove (0,SkinsPerGameTypes.Length);
	m_eGameTypes.Remove (0,m_eGameTypes.Length);
	LocalizationFile="";
	m_AudioBankName="";
	m_bCampaignMission=False;
	m_bIsLocked=Default.m_bIsLocked;
}

event bool Init (LevelInfo aLevel, string szMissionFile)
{
	local int i;
	local string szIniFile;
	local string szClassName;

	m_missionIniFile=Caps(szMissionFile);
	LoadConfig(szMissionFile);
	if ( (version == 0) || (m_MapName == "") )
	{
		return False;
	}
	szIniFile=m_MapName $ ".ini";
	szIniFile=Caps(szIniFile);
	if ( InStr(m_missionIniFile,szIniFile) < 0 )
	{
		Log("WARNING: R6MissionDescription m_missionIniFile (" $ m_missionIniFile $ ") != m_MapName (" $ szIniFile $ ") - " $ string(InStr(m_missionIniFile,szIniFile)));
		m_MapName="";
		return False;
	}
	else
	{
		m_missionIniFile=szIniFile;
	}
	if ( aLevel == None )
	{
		return False;
	}
	i=0;
JL00FC:
	if ( i < GameTypes.Length )
	{
		szClassName=GameTypes[i].Package $ "." $ GameTypes[i].type;
//		m_eGameTypes[i]=aLevel.GetER6GameTypeFromClassName(szClassName);
		++i;
		goto JL00FC;
	}
	if ( (version <= 2) || (mod == "") )
	{
		mod="RavenShield";
	}
	return True;
}

event bool GetSkins (string szGameTypeClass, out string szGreen, out string szRed)
{
	local int i;
	local string szGameMode;
	local string szClassName;

	i=0;
JL0007:
	if ( i < SkinsPerGameTypes.Length )
	{
		szClassName=SkinsPerGameTypes[i].Package $ "." $ SkinsPerGameTypes[i].type;
		if ( szGameTypeClass ~= szClassName )
		{
			szGreen=SkinsPerGameTypes[i].greenPackage $ "." $ SkinsPerGameTypes[i].Green;
			szRed=SkinsPerGameTypes[i].redPackage $ "." $ SkinsPerGameTypes[i].Red;
			return True;
		}
		++i;
		goto JL0007;
	}
	return False;
}

function LogInfo ()
{
	local int i;
	local string szClassName;
	local string szGreen;
	local string szRed;
	local Class<Pawn> RedPawnClass;
	local Class<Pawn> GreenPawnClass;

	Log("MissionDescription " $ m_missionIniFile $ " mapName=" $ m_MapName $ " localizationFile=" $ LocalizationFile $ " version=" $ string(version));
	Log(" mod                    =" $ mod);
	Log(" m_TMissionOverview     =" $ string(m_TMissionOverview));
	Log(" m_RMissionOverview     =" $ string(m_RMissionOverview.X) $ "," $ string(m_RMissionOverview.Y) $ "," $ string(m_RMissionOverview.W) $ "," $ string(m_RMissionOverview.H));
	Log(" m_TWorldMap            =" $ string(m_TWorldMap));
	Log(" m_RWorldMap            =" $ string(m_RWorldMap.X) $ "," $ string(m_RWorldMap.Y) $ "," $ string(m_RWorldMap.W) $ "," $ string(m_RWorldMap.H));
	Log(" m_AudioBankName        =" $ m_AudioBankName);
	Log(" m_PlayEventControl     =" $ string(m_PlayEventControl));
	Log(" m_PlayEventClark       =" $ string(m_PlayEventClark));
	Log(" m_PlayEventSweeney     =" $ string(m_PlayEventSweeney));
	i=0;
JL023A:
	if ( i < m_MissionArmorTypes.Length )
	{
		Log(" m_MissionArmorTypes " $ string(i) $ "=" $ string(m_MissionArmorTypes[i]));
		++i;
		goto JL023A;
	}
	i=0;
JL0291:
	if ( i < GameTypes.Length )
	{
		Log(" GameTypes " $ string(i) $ "=" $ GameTypes[i].Package $ "." $ GameTypes[i].type $ " ID=" $ string(m_eGameTypes[i]) $ " max nb players=" $ string(GameTypes[i].maxNb));
		++i;
		goto JL0291;
	}
	i=0;
JL0337:
	if ( i < SkinsPerGameTypes.Length )
	{
		szClassName=SkinsPerGameTypes[i].Package $ "." $ SkinsPerGameTypes[i].type;
		szGreen=SkinsPerGameTypes[i].greenPackage $ "." $ SkinsPerGameTypes[i].Green;
		szRed=SkinsPerGameTypes[i].redPackage $ "." $ SkinsPerGameTypes[i].Red;
		Log(" SkinsPerGameTypes " $ string(i) $ "- " $ szClassName $ " green=" $ szGreen $ " red=" $ szRed);
		++i;
		goto JL0337;
	}
}

function bool IsAvailableInGameType (ER6GameType eGameType)
{
	local int i;

JL0000:
	if ( i < m_eGameTypes.Length )
	{
		if ( m_eGameTypes[i] == eGameType )
		{
			return True;
		}
		++i;
		goto JL0000;
	}
	return False;
}

function int GetMaxNbPlayers (ER6GameType eGameType)
{
	local int i;

JL0000:
	if ( i < m_eGameTypes.Length )
	{
		if ( m_eGameTypes[i] == eGameType )
		{
			return GameTypes[i].maxNb;
		}
		++i;
		goto JL0000;
	}
	return 0;
}

defaultproperties
{
    m_MissionArmorTypes=[0]=None
}