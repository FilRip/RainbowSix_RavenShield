//================================================================================
// LevelInfo.
//================================================================================
class LevelInfo extends ZoneInfo
	Native;
/*	NativeReplication
	Localized
	HideCategories(R6Weather);*/

enum EPhysicsDetailLevel {
	PDL_Low,
	PDL_Medium,
	PDL_High
};

enum ENetMode {
	NM_Standalone,
	NM_DedicatedServer,
	NM_ListenServer,
	NM_Client
};

enum ELevelAction {
	LEVACT_None,
	LEVACT_Loading,
	LEVACT_Saving,
	LEVACT_Connecting,
	LEVACT_Precaching
};

enum ER6SoundState {
	BANK_UnloadGun,
	BANK_UnloadAll
};

const RDC_CamTeamOnly=0x20;
const RDC_CamFadeToBk=0x10;
const RDC_CamGhost=0x08;
const RDC_CamFreeThirdP=0x04;
const RDC_CamThirdPerson=0x02;
const RDC_CamFirstPerson=0x01;
struct GameTypeInfo
{
	var string m_szGameType;
	var string m_szDisplayAsGameType;
	var EGameModeInfo m_eGameModeInfo;
	var bool m_bTeamAdversarial;
	var bool m_bUsePreRecMessages;
	var bool m_bCanSetNbOfTerroristToSpawn;
	var bool m_bPlayWithNonRainbowNPCs;
	var bool m_bUseRainbowComm;
	var bool m_bDisplayBombTimer;
	var string m_szNameLocalization;
	var string m_szClassName;
	var string m_szGreenTeamObjective;
	var string m_szRedTeamObjective;
	var string m_szGreenShortDescription;
	var string m_szRedShortDescription;
	var string m_szToString;
	var string m_szSaveDirectoryName;
	var string m_szEnglishDirName;
	var string m_szLocalizationFile;
};

struct WritableMapIcon
{
	var float TimeStamp;
	var int iIconIndex;
	var Color Color;
	var int iPosX;
	var int iPosY;
};

struct WritableMapStroke
{
	var float TimeStamp;
	var int numPoints;
};

struct WritableMapVertex
{
	var Vector Position;
	var Color Color;
};

struct SoundZoneAudibleZones
{
	var() bool bZone00;
	var() bool bZone01;
	var() bool bZone02;
	var() bool bZone03;
	var() bool bZone04;
	var() bool bZone05;
	var() bool bZone06;
	var() bool bZone07;
	var() bool bZone08;
	var() bool bZone09;
	var() bool bZone10;
	var() bool bZone11;
	var() bool bZone12;
	var() bool bZone13;
	var() bool bZone14;
	var() bool bZone15;
	var() bool bZone16;
	var() bool bZone17;
	var() bool bZone18;
	var() bool bZone19;
	var() bool bZone20;
	var() bool bZone21;
	var() bool bZone22;
	var() bool bZone23;
	var() bool bZone24;
	var() bool bZone25;
	var() bool bZone26;
	var() bool bZone27;
	var() bool bZone28;
	var() bool bZone29;
	var() bool bZone30;
	var() bool bZone31;
	var() bool bZone32;
	var() bool bZone33;
	var() bool bZone34;
	var() bool bZone35;
	var() bool bZone36;
	var() bool bZone37;
	var() bool bZone38;
	var() bool bZone39;
	var() bool bZone40;
	var() bool bZone41;
	var() bool bZone42;
	var() bool bZone43;
	var() bool bZone44;
	var() bool bZone45;
	var() bool bZone46;
	var() bool bZone47;
	var() bool bZone48;
	var() bool bZone49;
	var() bool bZone50;
	var() bool bZone51;
	var() bool bZone52;
	var() bool bZone53;
	var() bool bZone54;
	var() bool bZone55;
	var() bool bZone56;
	var() bool bZone57;
	var() bool bZone58;
	var() bool bZone59;
	var() bool bZone60;
	var() bool bZone61;
	var() bool bZone62;
	var() bool bZone63;
};

var EPhysicsDetailLevel PhysicsDetailLevel;
var ENetMode NetMode;
var(R6Sound) ETerroristNationality m_eTerroristVoices;
var(R6Sound) EHostageNationality m_eHostageVoices;
var int MaxRagdolls;
var int HubStackLevel;
var(R6Planning) int R6PlanningMaxLevel;
var(R6Planning) int R6PlanningMinLevel;
var int m_iMotionBlurIntensity;
var int m_iLimitedSFXCount;
var int iPBEnabled;
var bool bKStaticFriction;
var() bool bKNoInit;
var() bool bLonePlayer;
var bool bBegunPlay;
var bool bPlayersOnly;
var bool bHighDetailMode;
var bool bDropDetail;
var bool bAggressiveLOD;
var bool bStartup;
var bool bPathsRebuilt;
var bool m_bInGamePlanningActive;
var bool m_bInGamePlanningZoomingIn;
var bool m_bInGamePlanningZoomingOut;
var bool m_bGameTypesInitialized;
var() bool bNeverPrecache;
var bool m_bLogBandWidth;
var bool bNextItems;
var(R6MissionObjectives) bool m_bUseDefaultMoralityRules;
var bool m_bShowDebugLine;
var bool m_bShowDebugLights;
var bool m_bShowDebugLODs;
var bool m_bShowOnlyTransparentSM;
var bool m_bNightVisionActive;
var bool m_bHeatVisionActive;
var bool m_bScopeVisionActive;
var bool m_bAllow3DRendering;
var bool m_bSkipMotionBlur;
var bool m_bPlaySound;
var bool m_bCanStartStartingSound;
var bool m_bSoundFadeFinish;
var bool m_bIsResettingLevel;
var bool m_bPBSvRunning;
var bool m_bHeartBeatOn;
var() float TimeDilation;
var float TimeSeconds;
var float PauseDelay;
var float KarmaTimeScale;
var float RagdollTimeScale;
var float KarmaGravScale;
var float m_fInGamePlanningZoomDistance;
var(Audio) float PlayerDoppler;
var() float Brightness;
var float m_fRainbowSkillMultiplier;
var float m_fTerroSkillMultiplier;
var float NextSwitchCountdown;
var(R6MissionObjectives) float m_fTimeLimit;
var(R6Sound) float m_fEndGamePauseTime;
var float m_fDbgNavPointDistance;
var float m_fDistanceHeartBeatVisible;
var PlayerReplicationInfo Pauser;
var LevelSummary Summary;
var() Texture Screenshot;
var Texture DefaultTexture;
var Texture WireframeTexture;
var Texture WhiteSquareTexture;
var Texture LargeVertex;
var GameInfo Game;
var const NavigationPoint NavigationPointList;
var const Controller ControllerList;
var PhysicsVolume PhysicsVolumeList;
var const R6ActionSpot m_ActionSpotList;
var Material GreenTeamSkin;
var Material GreenHeadSkin;
var Material GreenGogglesSkin;
var Material GreenHandSkin;
var Material GreenMenuSkin;
var Mesh GreenMesh;
var StaticMesh GreenHelmetMesh;
var Material GreenHelmetSkin;
var Material RedTeamSkin;
var Material RedHeadSkin;
var Material RedGogglesSkin;
var Material RedHandSkin;
var Material RedMenuSkin;
var Mesh RedMesh;
var StaticMesh RedHelmetMesh;
var Material RedHelmetSkin;
var(R6MissionObjectives) Sound m_sndMissionComplete;
var Emitter m_WeatherEmitter;
var Actor m_WeatherViewTarget;
var Sound m_sndPlayMissionIntro;
var Sound m_sndPlayMissionExtro;
var(R6Sound) Sound m_SurfaceSwitchSnd;
var(R6Sound) Sound m_SurfaceSwitchForOtherPawnSnd;
var(R6Sound) Sound m_BodyFallSwitchSnd;
var(R6Sound) Sound m_BodyFallSwitchForOtherPawnSnd;
var(R6Sound) Sound m_StartingMusic;
var R6DecalManager m_DecalManager;
var Texture m_pScopeMaskTexture;
var Texture m_pScopeAddTexture;
var R6AbstractHostageMgr m_hostageMgr;
var R6AbstractTerroristMgr m_terroristMgr;
var(R6SFX) Material m_pProneTrailMaterial;
var R6ServerInfo m_ServerSettings;
var R6LimitedSFX m_aLimitedSFX[6];
var(R6DrawingTool) Texture m_tWritableMapTexture;
var(R6LevelWeather) Class<R6WeatherEmitter> m_WeatherEmitterClass;
var Class<R6WeatherEmitter> m_RepWeatherEmitterClass;
var(R6Breathing) Class<Emitter> m_BreathingEmitterClass;
var(R6MissionObjectives) editinlineuse array<R6MissionObjectiveBase> m_aMissionObjectives;
var array<WritableMapVertex> m_aCurrentStrip;
var array<WritableMapVertex> m_aWritableMapStrip;
var array<WritableMapStroke> m_aWritableMapTimeStamp;
var array<WritableMapIcon> m_aWritableMapIcons;
var array<GameTypeInfo> m_aGameTypeInfo;
var() Vector CameraLocationDynamic;
var() Vector CameraLocationTop;
var() Vector CameraLocationFront;
var() Vector CameraLocationSide;
var() Rotator CameraRotationDynamic;
var(R6Planning) Vector R6PlanningMaxVector;
var(R6Planning) Vector R6PlanningMinVector;
//var Region GreenMenuRegion;
//var Region RedMenuRegion;
var(R6Sound) SoundZoneAudibleZones m_SoundZoneAudibleZones[64];
var Vector m_vPredVector;
var Vector m_vPredPredVector;
var() localized string Title;
var() string Author;
var() localized string LevelEnterText;
var() string LocalizedPkg;
var string VisibleGroups;
var(Audio) string Song;
var string m_szGameTypeShown;
var string ComputerName;
var string EngineVersion;
var string MinNetVersion;
var() string DefaultGameType;
var string NextURL;
var(R6MultiPlayerSkins) string GreenTeamPawnClass;
var(R6MultiPlayerSkins) string RedTeamPawnClass;
var(R6MissionObjectives) string m_szMissionObjLocalization;
var(R6Sound) string m_csVoicesOneLinersBankName;
var transient ELevelAction LevelAction;
var transient int Year;
var transient int Month;
var transient int Day;
var transient int DayOfWeek;
var transient int Hour;
var transient int Minute;
var transient int Second;
var transient int Millisecond;
var const transient bool bPhysicsVolumesInitialized;
var transient string SelectedGroups;

replication
{
	reliable if ( bNetDirty && (Role == 4) )
		TimeDilation,Pauser;
	reliable if ( Role == 4 )
		m_RepWeatherEmitterClass;
}

native(2801) final function AddWritableMapPoint (Vector point, Color C);

native(2802) final function AddEncodedWritableMapStrip (string S);

native(1608) final function AddWritableMapIcon (string Msg);

native(2711) final function SetBankSound (ER6SoundState eGameState);

native(1604) final function FinalizeLoading ();

native(1515) final function ResetLevelInNative ();

native(1516) final function CallLogThisActor (Actor anActor);

native(1518) final function GetCampaignNameFromParam (out string szCampaignName);

simulated event bool GameTypeUseNbOfTerroristToSpawn (string szGameType)
{
	local int i;

	i=0;
JL0007:
	if ( i < m_aGameTypeInfo.Length )
	{
		if ( m_aGameTypeInfo[i].m_szGameType == szGameType )
		{
			return m_aGameTypeInfo[i].m_bCanSetNbOfTerroristToSpawn;
		}
		i++;
		goto JL0007;
	}
	return False;
}

simulated function bool IsGameTypeMultiplayer (string szGameType, optional bool _bNotIncludeGMI_None)
{
	local int i;

	i=0;
JL0007:
	if ( i < m_aGameTypeInfo.Length )
	{
		if ( m_aGameTypeInfo[i].m_szGameType == szGameType )
		{
			if ( _bNotIncludeGMI_None )
			{
				if ( m_aGameTypeInfo[i].m_eGameModeInfo == 0 )
				{
					return False;
				}
			}
			return m_aGameTypeInfo[i].m_eGameModeInfo != 1;
		}
		i++;
		goto JL0007;
	}
	return False;
}

simulated function bool IsGameTypeAdversarial (string szGameType)
{
	local int i;

	i=0;
JL0007:
	if ( i < m_aGameTypeInfo.Length )
	{
		if ( m_aGameTypeInfo[i].m_szGameType == szGameType )
		{
			return m_aGameTypeInfo[i].m_eGameModeInfo == 3;
		}
		i++;
		goto JL0007;
	}
	return False;
}

simulated function bool IsGameTypeTeamAdversarial (string szGameType)
{
	local int i;

	i=0;
JL0007:
	if ( i < m_aGameTypeInfo.Length )
	{
		if ( m_aGameTypeInfo[i].m_szGameType == szGameType )
		{
			return m_aGameTypeInfo[i].m_bTeamAdversarial;
		}
		i++;
		goto JL0007;
	}
	return False;
}

simulated function bool IsGameTypeCooperative (string szGameType)
{
	local int i;

	i=0;
JL0007:
	if ( i < m_aGameTypeInfo.Length )
	{
		if ( m_aGameTypeInfo[i].m_szGameType == szGameType )
		{
			return m_aGameTypeInfo[i].m_eGameModeInfo == 2;
		}
		i++;
		goto JL0007;
	}
	return False;
}

simulated function bool IsGameTypeSquad (string szGameType)
{
	local int i;

	i=0;
JL0007:
	if ( i < m_aGameTypeInfo.Length )
	{
		if ( m_aGameTypeInfo[i].m_szGameType == szGameType )
		{
			return m_aGameTypeInfo[i].m_eGameModeInfo == 4;
		}
		i++;
		goto JL0007;
	}
	return False;
}

simulated function bool IsGameTypeUsePreRecMessages (string szGameType)
{
	local int i;

	i=0;
JL0007:
	if ( i < m_aGameTypeInfo.Length )
	{
		if ( m_aGameTypeInfo[i].m_szGameType == szGameType )
		{
			return m_aGameTypeInfo[i].m_bUsePreRecMessages;
		}
		i++;
		goto JL0007;
	}
	return False;
}

simulated event bool IsGameTypePlayWithNonRainbowNPCs (string szGameType)
{
	local int i;

	i=0;
JL0007:
	if ( i < m_aGameTypeInfo.Length )
	{
		if ( m_aGameTypeInfo[i].m_szGameType == szGameType )
		{
			return m_aGameTypeInfo[i].m_bPlayWithNonRainbowNPCs;
		}
		i++;
		goto JL0007;
	}
	return False;
}

simulated function bool IsGameTypeUseRainbowComm (string szGameType)
{
	local int i;

	i=0;
JL0007:
	if ( i < m_aGameTypeInfo.Length )
	{
		if ( m_aGameTypeInfo[i].m_szGameType == szGameType )
		{
			return m_aGameTypeInfo[i].m_bUseRainbowComm;
		}
		i++;
		goto JL0007;
	}
	return False;
}

simulated function string GetGameNameLocalization (string szGameType)
{
	local int i;

	i=0;
JL0007:
	if ( i < m_aGameTypeInfo.Length )
	{
		if ( m_aGameTypeInfo[i].m_szGameType == szGameType )
		{
			return m_aGameTypeInfo[i].m_szNameLocalization;
		}
		i++;
		goto JL0007;
	}
	return "";
}

function string GameTypeToString (string szGameType)
{
	local int i;

	i=0;
JL0007:
	if ( i < m_aGameTypeInfo.Length )
	{
		if ( m_aGameTypeInfo[i].m_szGameType == szGameType )
		{
			return m_aGameTypeInfo[i].m_szToString;
		}
		i++;
		goto JL0007;
	}
	return "";
}

function string GameTypeLocalizationFile (string szGameType)
{
	local int i;

	i=0;
JL0007:
	if ( i < m_aGameTypeInfo.Length )
	{
		if ( m_aGameTypeInfo[i].m_szGameType == szGameType )
		{
			return m_aGameTypeInfo[i].m_szLocalizationFile;
		}
		i++;
		goto JL0007;
	}
	return "";
}

simulated function string GetGreenTeamObjective (string szGameType)
{
	local int i;

	i=0;
JL0007:
	if ( i < m_aGameTypeInfo.Length )
	{
		if ( m_aGameTypeInfo[i].m_szGameType == szGameType )
		{
			return m_aGameTypeInfo[i].m_szGreenTeamObjective;
		}
		i++;
		goto JL0007;
	}
	return "";
}

simulated function string GetRedTeamObjective (string szGameType)
{
	local int i;

	i=0;
JL0007:
	if ( i < m_aGameTypeInfo.Length )
	{
		if ( m_aGameTypeInfo[i].m_szGameType == szGameType )
		{
			return m_aGameTypeInfo[i].m_szRedTeamObjective;
		}
		i++;
		goto JL0007;
	}
	return "";
}

simulated function string GetGreenShortDescription (string szGameType)
{
	local int i;

	i=0;
JL0007:
	if ( i < m_aGameTypeInfo.Length )
	{
		if ( m_aGameTypeInfo[i].m_szGameType == szGameType )
		{
			return m_aGameTypeInfo[i].m_szGreenShortDescription;
		}
		i++;
		goto JL0007;
	}
	return "";
}

simulated function string GetRedShortDescription (string szGameType)
{
	local int i;

	i=0;
JL0007:
	if ( i < m_aGameTypeInfo.Length )
	{
		if ( m_aGameTypeInfo[i].m_szGameType == szGameType )
		{
			return m_aGameTypeInfo[i].m_szRedShortDescription;
		}
		i++;
		goto JL0007;
	}
	return "";
}

simulated function string GetGameTypeFromClassName (string szGameClassName)
{
	local int i;

	i=0;
JL0007:
	if ( i < m_aGameTypeInfo.Length )
	{
		if ( m_aGameTypeInfo[i].m_szClassName == szGameClassName )
		{
			return m_aGameTypeInfo[i].m_szGameType;
		}
		i++;
		goto JL0007;
	}
	return "";
}

simulated function string GetGameTypeClassName (string szGameType)
{
	local int i;

	i=0;
JL0007:
	if ( i < m_aGameTypeInfo.Length )
	{
		if ( m_aGameTypeInfo[i].m_szGameType == szGameType )
		{
			return m_aGameTypeInfo[i].m_szClassName;
		}
		i++;
		goto JL0007;
	}
	return "";
}

simulated function GetGameTypeSaveDirectories (out string SaveDirectory, out string EnglishSaveDir)
{
	local int i;

	i=0;
JL0007:
	if ( i < m_aGameTypeInfo.Length )
	{
		if ( m_aGameTypeInfo[i].m_szGameType == Game.m_szGameTypeFlag )
		{
			SaveDirectory=m_aGameTypeInfo[i].m_szSaveDirectoryName;
			EnglishSaveDir=m_aGameTypeInfo[i].m_szEnglishDirName;
		}
		i++;
		goto JL0007;
	}
}

simulated function bool FindSaveDirectoryNameFromEnglish (out string SaveDirectory, string EnglishSaveDir)
{
	local int i;

	i=0;
JL0007:
	if ( i < m_aGameTypeInfo.Length )
	{
		if ( EnglishSaveDir == m_aGameTypeInfo[i].m_szEnglishDirName )
		{
			SaveDirectory=m_aGameTypeInfo[i].m_szSaveDirectoryName;
			return True;
		}
		i++;
		goto JL0007;
	}
	return False;
}

simulated function string GetGameTypeFromLocName (string szGameTypeLoc, optional bool _bOnlyMulti)
{
	local int i;
	local bool bFind;

	bFind=True;
	i=0;
JL000F:
	if ( i < m_aGameTypeInfo.Length )
	{
		if ( m_aGameTypeInfo[i].m_szNameLocalization ~= szGameTypeLoc )
		{
			if ( _bOnlyMulti )
			{
				bFind=m_aGameTypeInfo[i].m_eGameModeInfo != 1;
			}
			if ( bFind )
			{
				return m_aGameTypeInfo[i].m_szGameType;
			}
		}
		i++;
		goto JL000F;
	}
	return "RGM_NoRulesMode";
}

simulated function Actor GetHostageMgr ()
{
	local Class<R6AbstractHostageMgr> DesiredHostageMgrClass;

	if ( m_hostageMgr == None )
	{
		DesiredHostageMgrClass=Class<R6AbstractHostageMgr>(DynamicLoadObject("R6Engine.R6HostageMgr",Class'Class'));
		m_hostageMgr=Spawn(DesiredHostageMgrClass);
	}
	return m_hostageMgr;
}

function Object GetTerroristMgr ()
{
	local Class<R6AbstractTerroristMgr> mgrClass;

	if ( m_terroristMgr == None )
	{
		mgrClass=Class<R6AbstractTerroristMgr>(DynamicLoadObject("R6Engine.R6TerroristMgr",Class'Class'));
		m_terroristMgr=new mgrClass;
		m_terroristMgr.Initialization(self);
	}
	return m_terroristMgr;
}

simulated function GameTypeInfoAdd (string szGameType, string szDisplayAsGameType, EGameModeInfo eGameModeInfoType, bool bTeamAdversarial, bool bUsePreRecMessage, bool bSetNbTerro, bool bPlayWithNonRainbowNPCs, bool bUseRainbowComm, string szLocalizationFile, string szClassName, string szNameLocalization, string szGreenTeamObjective, string szRedTeamObjective, string szGreenShortDescription, string szRedShortDescription, string szToString)
{
	local int Index;
	local GameTypeInfo GameTypeToAdd;

	Index=0;
JL0007:
	if ( Index < m_aGameTypeInfo.Length )
	{
		if ( m_aGameTypeInfo[Index].m_szGameType == szGameType )
		{
			return;
		}
		Index++;
		goto JL0007;
	}
	GameTypeToAdd.m_eGameModeInfo=eGameModeInfoType;
	GameTypeToAdd.m_bTeamAdversarial=bTeamAdversarial;
	GameTypeToAdd.m_bUsePreRecMessages=bUsePreRecMessage;
	GameTypeToAdd.m_bCanSetNbOfTerroristToSpawn=bSetNbTerro;
	GameTypeToAdd.m_bPlayWithNonRainbowNPCs=bPlayWithNonRainbowNPCs;
	GameTypeToAdd.m_bUseRainbowComm=bUseRainbowComm;
	GameTypeToAdd.m_szGameType=szGameType;
	GameTypeToAdd.m_szDisplayAsGameType=szDisplayAsGameType;
	GameTypeToAdd.m_szLocalizationFile=szLocalizationFile;
	GameTypeToAdd.m_szClassName=szClassName;
	GameTypeToAdd.m_szNameLocalization=szNameLocalization;
	GameTypeToAdd.m_szGreenTeamObjective=szGreenTeamObjective;
	GameTypeToAdd.m_szRedTeamObjective=szRedTeamObjective;
	GameTypeToAdd.m_szGreenShortDescription=szGreenShortDescription;
	GameTypeToAdd.m_szRedShortDescription=szRedShortDescription;
	GameTypeToAdd.m_szToString=szToString;
	m_aGameTypeInfo[Index]=GameTypeToAdd;
}

simulated function GameTypeSaveGameInfo (int iIndex, string szSaveDirectoryName, string szEnglishDirName)
{
	assert (iIndex < m_aGameTypeInfo.Length);
	m_aGameTypeInfo[iIndex].m_szSaveDirectoryName=szSaveDirectoryName;
	m_aGameTypeInfo[iIndex].m_szEnglishDirName=szEnglishDirName;
}

simulated function SetGameTypeStrings ()
{
	local int i;

	i=0;
JL0007:
	if ( i < m_aGameTypeInfo.Length )
	{
		if ( m_aGameTypeInfo[i].m_szGreenTeamObjective != "" )
		{
			m_aGameTypeInfo[i].m_szGreenTeamObjective=Localize(m_aGameTypeInfo[i].m_szToString,"GreenTeamObj",m_aGameTypeInfo[i].m_szGreenTeamObjective);
		}
		if ( m_aGameTypeInfo[i].m_szRedTeamObjective != "" )
		{
			m_aGameTypeInfo[i].m_szRedTeamObjective=Localize(m_aGameTypeInfo[i].m_szToString,"RedTeamObj",m_aGameTypeInfo[i].m_szRedTeamObjective);
		}
		if ( m_aGameTypeInfo[i].m_szGreenShortDescription != "" )
		{
			m_aGameTypeInfo[i].m_szGreenShortDescription=Localize(m_aGameTypeInfo[i].m_szToString,"GreenShortDesc",m_aGameTypeInfo[i].m_szGreenShortDescription);
		}
		if ( m_aGameTypeInfo[i].m_szRedShortDescription != "" )
		{
			m_aGameTypeInfo[i].m_szRedShortDescription=Localize(m_aGameTypeInfo[i].m_szToString,"RedShortDesc",m_aGameTypeInfo[i].m_szRedShortDescription);
		}
		++i;
		goto JL0007;
	}
}

simulated function SetGameTypeDisplayBombTimer (string szGameType)
{
	local int i;

	i=0;
JL0007:
	if ( i < m_aGameTypeInfo.Length )
	{
		if ( m_aGameTypeInfo[i].m_szGameType == szGameType )
		{
			m_aGameTypeInfo[i].m_bDisplayBombTimer=True;
		} else {
			++i;
			goto JL0007;
		}
	}
}

simulated function bool IsGameTypeDisplayBombTimer (string szGameType)
{
	local int i;

	i=0;
JL0007:
	if ( i < m_aGameTypeInfo.Length )
	{
		if ( m_aGameTypeInfo[i].m_szGameType == szGameType )
		{
			return m_aGameTypeInfo[i].m_bDisplayBombTimer;
		}
		++i;
		goto JL0007;
	}
	return False;
}

simulated event PreBeginPlay ()
{
	local R6ModMgr pModMgr;
	local R6Mod pCurrentMod;

	if ( m_bGameTypesInitialized )
	{
		return;
	}
	m_bGameTypesInitialized=True;
	pModMgr=Class'Actor'.static.GetModMgr();
	pModMgr.AddGameTypes(self);
}

simulated function ResetOriginalData ()
{
	local R6DecalManager aMgr;

	if ( m_bResetSystemLog )
	{
		LogResetSystem(False);
	}
	Super.ResetOriginalData();
	aMgr=m_DecalManager;
	m_DecalManager=None;
	if ( aMgr != None )
	{
		aMgr.Destroy();
	}
	m_bCanStartStartingSound=False;
	if (  !Level.bKNoInit )
	{
		m_DecalManager=Spawn(Class'R6DecalManager');
	}
	if ( m_terroristMgr != None )
	{
		m_terroristMgr.ResetOriginalData();
	}
	m_bInGamePlanningActive=False;
}

native simulated function string GetLocalURL ();

native(1319) final simulated function PBNotifyServerTravel ();

native simulated function string GetAddressURL ();

event ServerTravel (string URL, bool bItems)
{
	if ( NextURL == "" )
	{
		bNextItems=bItems;
		NextURL=URL;
		if ( Game != None )
		{
			Game.ProcessServerTravel(URL,bItems);
		} else {
			NextSwitchCountdown=0.00;
		}
	}
}

function ThisIsNeverExecuted ()
{
	local DefaultPhysicsVolume P;

	P=None;
}

function Reset ()
{
	GarbageCollect();
	Super.Reset();
}

simulated function AddPhysicsVolume (PhysicsVolume NewPhysicsVolume)
{
	local PhysicsVolume V;

	V=PhysicsVolumeList;
JL000B:
	if ( V != None )
	{
		if ( V == NewPhysicsVolume )
		{
			return;
		}
		V=V.NextPhysicsVolume;
		goto JL000B;
	}
	NewPhysicsVolume.NextPhysicsVolume=PhysicsVolumeList;
	PhysicsVolumeList=NewPhysicsVolume;
}

simulated function RemovePhysicsVolume (PhysicsVolume DeletedPhysicsVolume)
{
	local PhysicsVolume V;
	local PhysicsVolume Prev;

	V=PhysicsVolumeList;
JL000B:
	if ( V != None )
	{
		if ( V == DeletedPhysicsVolume )
		{
			if ( Prev == None )
			{
				PhysicsVolumeList=V.NextPhysicsVolume;
			} else {
				Prev.NextPhysicsVolume=V.NextPhysicsVolume;
			}
			return;
		}
		Prev=V;
		V=V.NextPhysicsVolume;
		goto JL000B;
	}
}

native(2612) final function NotifyMatchStart ();

function Actor GetCamSpot (string szGameType)
{
/*	local Actor StartSpot;

	foreach AllActors(Class'Actor',StartSpot)
	{
		if ( StartSpot.IsA('R6CameraSpot') && StartSpot.IsAvailableInGameType(szGameType) )
		{
			return StartSpot;
		}
	}*/
	return None;
}

simulated function ResetLevel (int iNbOfRestart)
{
	local Actor aActor;
	local Pawn aPawn;
	local Controller C;
	local Controller pNextController;
	local PlayerController PC;

	Log("Resetting Level (total=" $ string(iNbOfRestart) $ ")");
	m_bIsResettingLevel=True;
	foreach AllActors(Class'Actor',aActor)
	{
		aActor.FirstPassReset();
	}
	if ( NetMode != 3 )
	{
		C=Level.ControllerList;
JL0076:
		if ( C != None )
		{
			PC=PlayerController(C);
			if ( PC != None )
			{
				PC.ResettingLevel(iNbOfRestart);
			}
			if ( C.Pawn != None )
			{
				aPawn=C.Pawn;
				if ( PC != None )
				{
					PC.UnPossess();
				}
				aPawn.Destroy();
				C.Pawn=None;
			}
			pNextController=C.nextController;
			if ( PC != None )
			{
				C.GotoState('BaseSpectating');
			} else {
				if ( AIController(C) != None )
				{
					C.Destroy();
				}
			}
			C=pNextController;
			goto JL0076;
		}
	}
	if ( m_bResetSystemLog )
	{
		Log("RESET: ResetOriginalData of all actors...");
	}
/*	foreach AllActors(Class'Actor',aActor)
	{
		if ( aActor.bTearOff || aActor.m_bDeleteOnReset )
		{
			if (!  !aActor.Destroy() ) goto JL01E7;
JL01E7:
		} else {
			aActor.ResetOriginalData();
		}
	}*/
	ResetLevelInNative();
	GarbageCollect();
	foreach AllActors(Class'Actor',aActor)
	{
		if ( (PlayerController(aActor) == None) && (GameInfo(aActor) == None) )
		{
			aActor.SetInitialState();
		}
	}
	StopAllSounds();
	if ( Level.NetMode != 0 )
	{
		StopAllMusic();
	}
	ResetVolume_AllTypeSound();
	m_bIsResettingLevel=False;
}

function string GetMissionObjLocFile (R6MissionObjectiveBase obj)
{
	if ( (obj != None) && (obj.m_szMissionObjLocalization != "") )
	{
		return obj.m_szMissionObjLocalization;
	}
	return m_szMissionObjLocalization;
}

simulated event PostBeginPlay ()
{
	if ( NetMode != 3 )
	{
		m_RepWeatherEmitterClass=m_WeatherEmitterClass;
	}
	if ( ((NetMode == 0) || (NetMode == 2)) && (m_WeatherEmitterClass != None) )
	{
		m_WeatherEmitter=Spawn(m_WeatherEmitterClass);
	}
	GetTerroristMgr();
}

simulated function SetWeatherActive (bool bWeatherActive)
{
	if ( bWeatherActive && (m_WeatherEmitter.Emitters[0].m_iPaused == 1) )
	{
		m_WeatherEmitter.Emitters[0].m_iPaused=0;
		m_WeatherEmitter.Emitters[0].AllParticlesDead=False;
	} else {
		if (  !bWeatherActive && (m_WeatherEmitter.Emitters[0].m_iPaused == 0) )
		{
			m_WeatherEmitter.Emitters[0].m_iPaused=1;
			m_WeatherEmitter.Emitters[0].AllParticlesDead=False;
		}
	}
}

defaultproperties
{
    PhysicsDetailLevel=1
    MaxRagdolls=32
    R6PlanningMinLevel=65535
    bKStaticFriction=True
    bHighDetailMode=True
    m_bUseDefaultMoralityRules=True
    m_bAllow3DRendering=True
    m_bPlaySound=True
    TimeDilation=1.00
    KarmaTimeScale=0.90
    RagdollTimeScale=1.00
    KarmaGravScale=1.00
    m_fInGamePlanningZoomDistance=5000.00
    Brightness=1.00
    m_fRainbowSkillMultiplier=1.00
    m_fTerroSkillMultiplier=1.00
    m_fEndGamePauseTime=8.00
    m_fDbgNavPointDistance=2000.00
    DefaultTexture=Texture'DefaultTexture'
    WireframeTexture=Texture'WireframeTexture'
    WhiteSquareTexture=Texture'WhiteSquareTexture'
    LargeVertex=Texture'LargeVertex'
    Title="Untitled"
    VisibleGroups="None"
    GreenTeamPawnClass="R6Characters.R6RainbowMediumBlue"
    RedTeamPawnClass="R6Characters.R6RainbowMediumEuro"
    m_szMissionObjLocalization="R6MissionObjectives"
    bWorldGeometry=True
    bAlwaysRelevant=True
    bHiddenEd=True
}
