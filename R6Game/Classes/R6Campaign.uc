//================================================================================
// R6Campaign.
//================================================================================
class R6Campaign extends Object;
//	Export;

var config array<string> missions;
var array<R6MissionDescription> m_missions;
var config array<string> m_OperativeClassName;
var config array<string> m_OperativeBackupClassName;
var string m_szCampaignFile;
var config string LocalizationFile;

function Init (LevelInfo aLevel, string szFileName, R6Console Console)
{
	local int i;
	local int j;
	local int iMission;
	local string szIniFile;
	local bool bFound;

	m_szCampaignFile=szFileName;
	if ( Class'Actor'.static.GetModMgr().IsRavenShield() )
	{
		LoadConfig("..\\maps\\" $ m_szCampaignFile);
	}
	else
	{
		LoadConfig("..\\Mods\\" $ Class'Actor'.static.GetModMgr().m_pCurrentMod.m_szCampaignDir $ "\\maps\\" $ m_szCampaignFile);
	}
	if ( Console.m_aMissionDescriptions.Length == 0 )
	{
		Console.GetAllMissionDescriptions();
	}
	i=0;
	iMission=0;
JL00AB:
	if ( i < missions.Length )
	{
		missions[i]=Caps(missions[i]);
		szIniFile=missions[i] $ ".INI";
		bFound=False;
		j=0;
JL00FC:
		if ( j < Console.m_aMissionDescriptions.Length )
		{
			if ( Console.m_aMissionDescriptions[j].m_missionIniFile == szIniFile )
			{
				m_missions[iMission]=Console.m_aMissionDescriptions[j];
				m_missions[iMission].m_bCampaignMission=True;
				if ( iMission == 0 )
				{
					m_missions[iMission].m_bIsLocked=False;
				}
				else
				{
					m_missions[iMission].m_bIsLocked=True;
				}
				iMission++;
				bFound=True;
			}
			else
			{
				j++;
				goto JL00FC;
			}
		}
		if (  !bFound )
		{
			Log("Warning: missing mission description " $ szIniFile $ " in campaign " $ szFileName);
		}
		i++;
		goto JL00AB;
	}
	Console.UnlockMissions();
}

function LogInfo ()
{
	local int i;

	Log("CAMPAIGN name=" $ m_szCampaignFile $ " localizationFile=" $ LocalizationFile);
	Log("===========================================================");
	Log(" List mission (.ini files)");
JL0093:
	if ( i < missions.Length )
	{
		Log("  Mission " $ string(i) $ " " $ missions[i]);
		i++;
		goto JL0093;
	}
	Log(" List operative");
	i=0;
	Log("  List backup operative");
	i=0;
JL0112:
	if ( i < m_OperativeBackupClassName.Length )
	{
		Log("  bk " $ string(i) $ " " $ m_OperativeBackupClassName[i]);
		i++;
		goto JL0112;
	}
}
