//================================================================================
// R6GameInfo.
//================================================================================
class R6GameInfo extends R6AbstractGameInfo
	Native;

struct PlayerPrefInfo
{
	var string m_CharacterName;
	var string m_ArmorName;
	var string m_WeaponName1;
	var string m_WeaponName2;
	var string m_WeaponGadgetName1;
	var string m_WeaponGadgetName2;
	var string m_BulletType1;
	var string m_BulletType2;
	var string m_GadgetName1;
	var string m_GadgetName2;
};

enum eGameWidgetID {
	WidgetID_None,
	InGameID_EscMenu,
	InGameID_Debriefing,
	InGameID_TrainingInstruction,
	TrainingWidgetID,
	SinglePlayerWidgetID,
	CampaignPlanningID,
	MainMenuWidgetID,
	IntelWidgetID,
	PlanningWidgetID,
	RetryCampaignPlanningID,
	RetryCustomMissionPlanningID,
	GearRoomWidgetID,
	ExecuteWidgetID,
	CustomMissionWidgetID,
	MultiPlayerWidgetID,
	OptionsWidgetID,
	PreviousWidgetID,
	CreditsWidgetID,
	MPCreateGameWidgetID,
	UbiComWidgetID,
	NonUbiWidgetID,
	InGameMPWID_Writable,
	InGameMPWID_TeamJoin,
	InGameMPWID_Intermission,
	InGameMPWID_InterEndRound,
	InGameMPWID_EscMenu,
	InGameMpWID_RecMessages,
	InGameMpWID_MsgOffensive,
	InGameMpWID_MsgDefensive,
	InGameMpWID_MsgReply,
	InGameMpWID_MsgStatus,
	InGameMPWID_Vote,
	InGameMPWID_CountDown,
	InGameID_OperativeSelector,
	MultiPlayerError,
	MultiPlayerErrorUbiCom,
	MenuQuitID
};

const CMaxPlayers=  16;
const CMaxRainbowAI=  6;
var byte R6DefaultWeaponInput;
var eGameWidgetID m_eEndGameWidgetID;
var byte m_bCurrentFemaleId;
var byte m_bCurrentMaleId;
var byte m_bRainbowFaces[30];
var int m_iCurrentID;
var int m_iMaxOperatives;
var int m_iJumpMapIndex;
var int m_iRoundsPerMatch;
var int m_iDeathCameraMode;
var int m_iSubMachineGunsResMask;
var int m_iShotGunResMask;
var int m_iAssRifleResMask;
var int m_iMachGunResMask;
var int m_iSnipRifleResMask;
var int m_iPistolResMask;
var int m_iMachPistolResMask;
var int m_iGadgPrimaryResMask;
var int m_iGadgSecondaryResMask;
var int m_iGadgMiscResMask;
var int m_iNbOfRestart;
var int m_iIDVoicesMgr;
var(Debug) bool bShowLog;
var bool bNoRestart;
var bool m_bServerAllowRadarRep;
var bool m_bRepAllowRadarOption;
var bool m_bIsRadarAllowed;
var bool m_bIsWritableMapAllowed;
var bool m_bUsingPlayerCampaign;
var bool m_bUsingCampaignBriefing;
var bool m_bUnlockAllDoors;
var bool m_bJumpingMaps;
var bool m_bAutoBalance;
var bool m_bTKPenalty;
var bool m_bPWSubMachGunRes;
var bool m_bPWShotGunRes;
var bool m_bPWAssRifleRes;
var bool m_bPWMachGunRes;
var bool m_bPWSnipRifleRes;
var bool m_bSWPistolRes;
var bool m_bSWMachPistolRes;
var bool m_bGadgPrimaryRes;
var bool m_bGadgSecondayRes;
var bool m_bGadgMiscRes;
var bool m_bShowNames;
var bool m_bFFPWeapon;
var bool m_bAdminPasswordReq;
var bool m_bAIBkp;
var bool m_bRotateMap;
var bool m_bFadeStarted;
var bool m_bPunkBuster;
var bool m_bFeedbackHostageKilled;
var bool m_bFeedbackHostageExtracted;
var float m_fRoundStartTime;
var float m_fRoundEndTime;
var float m_fPausedAtTime;
var float m_fBombTime;
var R6CommonRainbowVoices m_CommonRainbowPlayerVoicesMgr;
var R6CommonRainbowVoices m_CommonRainbowMemberVoicesMgr;
var R6RainbowPlayerVoices m_RainbowPlayerVoicesMgr;
var R6RainbowMemberVoices m_RainbowMemberVoicesMgr;
var R6MultiCoopVoices m_MultiCoopMemberVoicesMgr;
var R6PreRecordedMsgVoices m_PreRecordedMsgVoicesMgr;
var R6MultiCommonVoices m_MultiCommonVoicesMgr;
var NavigationPoint LastStartSpot;
var R6GSServers m_GameService;
var R6GSServers m_PersistantGameService;
var Material DefaultFaceTexture;
var array<R6RainbowOtherTeamVoices> m_RainbowOtherTeamVoicesMgr;
var array<R6MultiCoopVoices> m_MultiCoopPlayerVoicesMgr;
var array<R6TerroristVoices> m_TerroristVoicesMgr;
var array<R6HostageVoices> m_HostageVoicesMaleMgr;
var array<R6HostageVoices> m_HostageVoicesFemaleMgr;
var array<R6Terrorist> m_listAllTerrorists;
var array<R6RainbowAI> m_RainbowAIBackup;
var array<string> m_mapList;
var array<string> m_gameModeList;
var Plane DefaultFaceCoords;
var string m_szMessageOfDay;
var string m_szSvrName;

native(2010) final function bool SetController (PlayerController PController, Player pPlayer);

native(1504) final function GetSystemUserName (out string szUserName);

function SetUdpBeacon (InternetInfo _udpBeacon)
{
	m_UdpBeacon=UdpBeacon(_udpBeacon);
}

function GetNbHumanPlayerInTeam (out int iAlphaNb, out int iBravoNb);

simulated function FirstPassReset ()
{
	local int i;

	if ( m_missionMgr != None )
	{
		i=0;
JL0012:
		if ( i < m_missionMgr.m_aMissionObjectives.Length )
		{
			m_missionMgr.m_aMissionObjectives[i].Reset();
			++i;
			goto JL0012;
		}
//		m_missionMgr.SetMissionObjStatus(0);
	}
	ResetRepMissionObjectives();
	m_listAllTerrorists.Remove (0,m_listAllTerrorists.Length);
	if ( m_RainbowAIBackup.Length > 0 )
	{
		m_RainbowAIBackup.Remove (0,m_RainbowAIBackup.Length);
	}
}

function R6AbstractInsertionZone GetAStartSpot ()
{
	local R6AbstractInsertionZone aZone;

	foreach AllActors(Class'R6AbstractInsertionZone',aZone)
	{
		if ( aZone.IsAvailableInGameType(m_eGameTypeFlag) )
		{
			return aZone;
		}
	}
	return None;
}

function Object GetRainbowTeam (int eTeamName)
{
	return R6GameReplicationInfo(GameReplicationInfo).m_RainbowTeam[eTeamName];
}

function SetRainbowTeam (int eTeamName, R6RainbowTeam newTeam)
{
	R6GameReplicationInfo(GameReplicationInfo).m_RainbowTeam[eTeamName]=newTeam;
}

simulated event AcceptInventory (Pawn PlayerPawn)
{
	local PlayerPrefInfo m_PlayerPrefs;
	local R6Pawn aPawn;
	local R6Rainbow aRainbow;
	local string szSecWeapon;
	local string caps_szSecGadget;

	aPawn=R6Pawn(PlayerPawn);
	if ( (aPawn != None) && (aPawn.EngineWeapon == None) )
	{
//		m_PlayerPrefs=PlayerController(aPawn.Controller).m_PlayerPrefs;
		if (  !IsPrimaryWeaponRestrictedToPawn(aPawn) && (m_PlayerPrefs.m_WeaponName1 != "") &&  !IsPrimaryWeaponRestricted(m_PlayerPrefs.m_WeaponName1) )
		{
			if ( bShowLog )
			{
				Log("NOW GIVING " $ m_PlayerPrefs.m_WeaponName1 $ " to " $ string(aPawn.Controller));
			}
			if ( (m_PlayerPrefs.m_WeaponGadgetName1 != "") && IsPrimaryGadgetRestricted(m_PlayerPrefs.m_WeaponGadgetName1) )
			{
				aPawn.ServerGivesWeaponToClient(m_PlayerPrefs.m_WeaponName1,1,m_PlayerPrefs.m_BulletType1);
			}
			else
			{
				aPawn.ServerGivesWeaponToClient(m_PlayerPrefs.m_WeaponName1,1,m_PlayerPrefs.m_BulletType1,m_PlayerPrefs.m_WeaponGadgetName1);
			}
			if ( bShowLog )
			{
				Log("AcceptInventory PrimaryWeapon =" @ m_PlayerPrefs.m_WeaponName1);
			}
		}
		if (  !IsSecondaryWeaponRestrictedToPawn(aPawn) && (m_PlayerPrefs.m_WeaponName2 != "") )
		{
			if ( IsSecondaryWeaponRestricted(m_PlayerPrefs.m_WeaponName2) )
			{
				szSecWeapon="R63rdWeapons.NormalPistol92FS";
			}
			else
			{
				szSecWeapon=m_PlayerPrefs.m_WeaponName2;
			}
			if ( bShowLog )
			{
				Log("NOW GIVING " $ szSecWeapon $ " to " $ string(aPawn.Controller));
			}
			if ( (m_PlayerPrefs.m_WeaponGadgetName2 != "") && IsSecondaryGadgetRestricted(m_PlayerPrefs.m_WeaponGadgetName2) )
			{
				aPawn.ServerGivesWeaponToClient(szSecWeapon,2,m_PlayerPrefs.m_BulletType2);
			}
			else
			{
				aPawn.ServerGivesWeaponToClient(szSecWeapon,2,m_PlayerPrefs.m_BulletType2,m_PlayerPrefs.m_WeaponGadgetName2);
			}
			if ( bShowLog )
			{
				Log("AcceptInventory SecondaryWeapon = " $ szSecWeapon);
			}
		}
		if (  !IsTertiaryWeaponRestrictedToPawn(aPawn) && (m_PlayerPrefs.m_GadgetName1 != "") &&  !IsTertiaryWeaponRestricted(m_PlayerPrefs.m_GadgetName1) &&  !IsTertiaryWeaponRestrictedForGamePlay(aPawn,m_PlayerPrefs.m_GadgetName1) )
		{
			if ( bShowLog )
			{
				Log(" AND " $ m_PlayerPrefs.m_GadgetName1 $ "  (gadget 1)");
			}
			aPawn.ServerGivesWeaponToClient(m_PlayerPrefs.m_GadgetName1,3);
			if ( bShowLog )
			{
				Log("AcceptInventory GadgetOne = " $ m_PlayerPrefs.m_GadgetName1);
			}
		}
		if (  !IsTertiaryWeaponRestrictedToPawn(aPawn) && (m_PlayerPrefs.m_GadgetName2 != "") &&  !IsTertiaryWeaponRestricted(m_PlayerPrefs.m_GadgetName2) &&  !IsTertiaryWeaponRestrictedForGamePlay(aPawn,m_PlayerPrefs.m_GadgetName2) )
		{
			if ( bShowLog )
			{
				Log(" AND " $ m_PlayerPrefs.m_GadgetName2 $ "  (gadget 2)");
			}
			caps_szSecGadget=Caps(m_PlayerPrefs.m_GadgetName2);
			if ( (caps_szSecGadget != "PRIMARYMAGS") && (caps_szSecGadget != "SECONDARYMAGS") && (caps_szSecGadget == Caps(m_PlayerPrefs.m_GadgetName1)) )
			{
				aPawn.ServerGivesWeaponToClient("DoubleGadget",4);
			}
			else
			{
				aPawn.ServerGivesWeaponToClient(m_PlayerPrefs.m_GadgetName2,4);
			}
			if ( bShowLog )
			{
				Log("AcceptInventory GadgetTwo = " $ m_PlayerPrefs.m_GadgetName2);
			}
		}
		aRainbow=R6Rainbow(PlayerPawn);
		if ( aRainbow != None )
		{
			aRainbow.m_szPrimaryWeapon=m_PlayerPrefs.m_WeaponName1;
			aRainbow.m_szSecondaryWeapon=szSecWeapon;
			aRainbow.m_szPrimaryItem=m_PlayerPrefs.m_GadgetName1;
			aRainbow.m_szSecondaryItem=m_PlayerPrefs.m_GadgetName2;
		}
		if ( Level.NetMode == NM_ListenServer )
		{
			aPawn.ReceivedWeapons();
		}
	}
}

function bool IsPrimaryWeaponRestrictedToPawn (Pawn aPawn)
{
	return False;
}

function bool IsSecondaryWeaponRestrictedToPawn (Pawn aPawn)
{
	return False;
}

function bool IsTertiaryWeaponRestrictedToPawn (Pawn aPawn)
{
	return False;
}

function bool IsTertiaryWeaponRestrictedForGamePlay (Pawn aPawn, string szWeaponName)
{
	return False;
}

function bool IsPrimaryWeaponRestricted (string szWeaponName)
{
	local Class<R6AbstractWeapon> WeaponClass;
	local R6GameReplicationInfo _GRI;
	local string WeaponClassNameId;

	_GRI=R6GameReplicationInfo(GameReplicationInfo);
	if ( szWeaponName == "R6Description.R6DescPrimaryWeaponNone" )
	{
		return True;
	}
	WeaponClass=Class<R6AbstractWeapon>(DynamicLoadObject(szWeaponName,Class'Class'));
	WeaponClassNameId=WeaponClass.Default.m_NameID;
	if ( IsInResArray(WeaponClassNameId,_GRI.m_szSubMachineGunsRes) || IsInResArray(WeaponClassNameId,_GRI.m_szShotGunRes) || IsInResArray(WeaponClassNameId,_GRI.m_szAssRifleRes) || IsInResArray(WeaponClassNameId,_GRI.m_szMachGunRes) || IsInResArray(WeaponClassNameId,_GRI.m_szSnipRifleRes) )
	{
		if ( bShowLog )
		{
			Log(szWeaponName $ " is restricted and will not be spawned");
		}
		return True;
	}
	return False;
}

function bool IsPrimaryGadgetRestricted (string szWeaponGadgetName)
{
	local int i;
	local R6GameReplicationInfo _GRI;
	local Class<R6AbstractGadget> WeaponGadgetClass;
	local string RequestedGadget;

	if ( szWeaponGadgetName == "" )
	{
		return True;
	}
	WeaponGadgetClass=Class<R6AbstractGadget>(DynamicLoadObject(szWeaponGadgetName,Class'Class'));
	RequestedGadget=WeaponGadgetClass.Default.m_NameID;
	_GRI=R6GameReplicationInfo(GameReplicationInfo);
	if ( IsInResArray(RequestedGadget,_GRI.m_szGadgPrimaryRes) )
	{
		return True;
	}
	return False;
}

function bool IsSecondaryGadgetRestricted (string szWeaponGadgetName)
{
	local int i;
	local R6GameReplicationInfo _GRI;
	local Class<R6AbstractGadget> WeaponGadgetClass;
	local string RequestedGadget;

	if ( szWeaponGadgetName == "" )
	{
		return True;
	}
	WeaponGadgetClass=Class<R6AbstractGadget>(DynamicLoadObject(szWeaponGadgetName,Class'Class'));
	RequestedGadget=WeaponGadgetClass.Default.m_NameID;
	_GRI=R6GameReplicationInfo(GameReplicationInfo);
	if ( IsInResArray(RequestedGadget,_GRI.m_szGadgSecondayRes) )
	{
		if ( bShowLog )
		{
			Log(szWeaponGadgetName $ " is restricted and will not be spawned");
		}
		return True;
	}
	return False;
}

function bool IsSecondaryWeaponRestricted (string szWeaponName)
{
	local int i;
	local R6GameReplicationInfo _GRI;
	local Class<R6AbstractWeapon> WeaponClass;
	local string RequestedWeapon;
	local Class<R6SecondaryWeaponDescription> SecondaryWeaponClass;

	_GRI=R6GameReplicationInfo(GameReplicationInfo);
	WeaponClass=Class<R6AbstractWeapon>(DynamicLoadObject(szWeaponName,Class'Class'));
	RequestedWeapon=WeaponClass.Default.m_NameID;
	if ( IsInResArray(RequestedWeapon,_GRI.m_szPistolRes) || IsInResArray(RequestedWeapon,_GRI.m_szMachPistolRes) )
	{
		if ( bShowLog )
		{
			Log(szWeaponName $ " is restricted and will not be spawned");
		}
		return True;
	}
	return False;
}

function bool IsTertiaryWeaponRestricted (string szWeaponName)
{
	local int i;
	local R6GameReplicationInfo _GRI;
	local Class<R6AbstractWeapon> WeaponClass;
	local string RequestedWeapon;
	local Class<R6SecondaryWeaponDescription> SecondaryWeaponClass;
	local Class<R6GadgetDescription> _GadgetClass;

	_GRI=R6GameReplicationInfo(GameReplicationInfo);
	if ( szWeaponName == "" )
	{
		return True;
	}
	if ( Class<R6AbstractWeapon>(FindObject(szWeaponName,Class'Class')) != None )
	{
		WeaponClass=Class<R6AbstractWeapon>(DynamicLoadObject(szWeaponName,Class'Class'));
		if ( WeaponClass == None )
		{
			return False;
		}
		RequestedWeapon=WeaponClass.Default.m_NameID;
	}
	else
	{
		RequestedWeapon=szWeaponName;
	}
	if ( IsInResArray(RequestedWeapon,_GRI.m_szGadgMiscRes) )
	{
		if ( bShowLog )
		{
			Log(szWeaponName $ " is restricted and will not be spawned");
		}
		return True;
	}
	return False;
}

function bool IsInResArray (string szWeaponNameId, string RestrictionArray[32])
{
	local int i;

	i=0;
JL0007:
	if ( (i < 32) && (RestrictionArray[i] != "") )
	{
		if ( RestrictionArray[i] ~= szWeaponNameId )
		{
			if ( bShowLog )
			{
				Log(szWeaponNameId $ " is restricted and will not be spawned");
			}
			return True;
		}
		i++;
		goto JL0007;
	}
	return False;
}

function PostBeginPlay ()
{
	local R6DeploymentZone PZone;
	local int i;
	local bool bFound;
	local array<string> AGadgetNameID;
	local R6ServerInfo pServerOptions;

	Super.PostBeginPlay();
	pServerOptions=Class'Actor'.static.GetServerOptions();
	Level.m_ServerSettings=pServerOptions;
	CreateMissionObjectiveMgr();
	m_missionMgr.m_bEnableCheckForErrors=False;
	InitObjectives();
	if ( Level.NetMode != 0 )
	{
		R6GameReplicationInfo(GameReplicationInfo).m_iMapIndex=GetCurrentMapNum();
	}
	R6GameReplicationInfo(GameReplicationInfo).m_eGameTypeFlag=m_eGameTypeFlag;
	R6GameReplicationInfo(GameReplicationInfo).m_iDeathCameraMode=m_iDeathCameraMode;
	if ( (Level.NetMode == NM_DedicatedServer) || (Level.NetMode == NM_ListenServer) )
	{
		bPauseable=False;
		m_szSvrName=Left(pServerOptions.ServerName,m_GameService.GetMaxUbiServerNameSize());
		if ( m_szSvrName != "" )
		{
			GameReplicationInfo.ServerName=m_szSvrName;
		}
	}
	R6GameReplicationInfo(GameReplicationInfo).m_iRoundsPerMatch=m_iRoundsPerMatch;
	R6GameReplicationInfo(GameReplicationInfo).m_iDiffLevel=m_iDiffLevel;
	R6GameReplicationInfo(GameReplicationInfo).m_iNbOfTerro=m_iNbOfTerroristToSpawn;
	R6GameReplicationInfo(GameReplicationInfo).m_fTimeBetRounds=m_fTimeBetRounds;
	R6GameReplicationInfo(GameReplicationInfo).m_bPasswordReq=AccessControl.GamePasswordNeeded();
	R6GameReplicationInfo(GameReplicationInfo).m_bFriendlyFire=m_bFriendlyFire;
	R6GameReplicationInfo(GameReplicationInfo).m_bAutoBalance=m_bAutoBalance;
	R6GameReplicationInfo(GameReplicationInfo).m_bMenuTKPenaltySetting=m_bTKPenalty;
	m_bTKPenalty=m_bTKPenalty && Level.IsGameTypeTeamAdversarial(m_eGameTypeFlag);
	R6GameReplicationInfo(GameReplicationInfo).m_bTKPenalty=m_bTKPenalty;
	R6GameReplicationInfo(GameReplicationInfo).m_bShowNames=m_bShowNames;
	R6GameReplicationInfo(GameReplicationInfo).m_MaxPlayers=MaxPlayers;
	R6GameReplicationInfo(GameReplicationInfo).m_fBombTime=m_fBombTime;
	R6GameReplicationInfo(GameReplicationInfo).m_bInternetSvr=m_bInternetSvr;
	R6GameReplicationInfo(GameReplicationInfo).m_bFFPWeapon=m_bFFPWeapon;
	R6GameReplicationInfo(GameReplicationInfo).m_bAIBkp=m_bAIBkp;
	R6GameReplicationInfo(GameReplicationInfo).m_bRotateMap=m_bRotateMap;
	R6GameReplicationInfo(GameReplicationInfo).m_bAdminPasswordReq=m_bAdminPasswordReq;
	R6GameReplicationInfo(GameReplicationInfo).m_bDedicatedSvr=Level.NetMode == NM_DedicatedServer;
	R6GameReplicationInfo(GameReplicationInfo).m_bIsWritableMapAllowed=m_bIsWritableMapAllowed;
	R6GameReplicationInfo(GameReplicationInfo).m_bPunkBuster=m_bPunkBuster;
	if ( m_bIsWritableMapAllowed )
	{
		AddSoundBankName("Common_Multiplayer");
	}
	SetTimer(2.00,True);
	i=0;
JL03AE:
/*	if ( i < R6GameReplicationInfo(GameReplicationInfo).32 )
	{
		if ( i < m_mapList.Length )
		{
			R6GameReplicationInfo(GameReplicationInfo).m_mapArray[i]=m_mapList[i];
		}
		else
		{
			R6GameReplicationInfo(GameReplicationInfo).m_mapArray[i]="";
		}
		if ( i < m_gameModeList.Length )
		{
			R6GameReplicationInfo(GameReplicationInfo).m_gameModeArray[i]=m_gameModeList[i];
		}
		else
		{
			R6GameReplicationInfo(GameReplicationInfo).m_gameModeArray[i]="";
		}
		i++;
		goto JL03AE;
	}*/
	UpdateRepResArrays();
	if ( Level.NetMode == NM_DedicatedServer )
	{
		m_PersistantGameService=m_GameService;
	}
	else
	{
		if ( Level.NetMode == NM_ListenServer )
		{
			m_PersistantGameService=R6Console(Class'Actor'.static.GetCanvas().Viewport.Console).m_GameService;
		}
	}
}

function UpdateRepResArrays ()
{
	local Class<R6SubGunDescription> SubGunClass;
	local Class<R6ShotgunDescription> ShotGunClass;
	local Class<R6AssaultDescription> AssaultRifleClass;
	local Class<R6LMGDescription> MachGunClass;
	local Class<R6SniperDescription> SniperRifleClass;
	local Class<R6PistolsDescription> PistolClass;
	local Class<R6MachinePistolsDescription> MachPistolClass;
	local Class<R6WeaponGadgetDescription> PriGadgClass;
	local Class<R6WeaponGadgetDescription> SecGadgClass;
	local Class<R6GadgetDescription> MiscGadgClass;
	local R6ServerInfo pServerOptions;
	local int i;
	local R6GameReplicationInfo _GRI;

	pServerOptions=Level.m_ServerSettings;
	_GRI=R6GameReplicationInfo(GameReplicationInfo);
	if ( Level.NetMode != 0 )
	{
		i=0;
JL0044:
		if ( i < 32 )
		{
			_GRI.m_szSubMachineGunsRes[i]="";
			i++;
			goto JL0044;
		}
		i=0;
JL0078:
		if ( i < pServerOptions.RestrictedSubMachineGuns.Length )
		{
			SubGunClass=Class<R6SubGunDescription>(DynamicLoadObject("" $ string(pServerOptions.RestrictedSubMachineGuns[i]),Class'Class'));
			_GRI.m_szSubMachineGunsRes[i]=SubGunClass.Default.m_NameID;
			i++;
			goto JL0078;
		}
		i=0;
JL00F5:
		if ( i < 32 )
		{
			_GRI.m_szShotGunRes[i]="";
			i++;
			goto JL00F5;
		}
		i=0;
JL0129:
		if ( i < pServerOptions.RestrictedShotGuns.Length )
		{
			ShotGunClass=Class<R6ShotgunDescription>(DynamicLoadObject("" $ string(pServerOptions.RestrictedShotGuns[i]),Class'Class'));
			_GRI.m_szShotGunRes[i]=ShotGunClass.Default.m_NameID;
			i++;
			goto JL0129;
		}
		i=0;
JL01A6:
		if ( i < 32 )
		{
			_GRI.m_szAssRifleRes[i]="";
			i++;
			goto JL01A6;
		}
		i=0;
JL01DA:
		if ( i < pServerOptions.RestrictedAssultRifles.Length )
		{
			AssaultRifleClass=Class<R6AssaultDescription>(DynamicLoadObject("" $ string(pServerOptions.RestrictedAssultRifles[i]),Class'Class'));
			_GRI.m_szAssRifleRes[i]=AssaultRifleClass.Default.m_NameID;
			i++;
			goto JL01DA;
		}
		i=0;
JL0257:
		if ( i < 32 )
		{
			_GRI.m_szMachGunRes[i]="";
			i++;
			goto JL0257;
		}
		i=0;
JL028B:
		if ( i < pServerOptions.RestrictedMachineGuns.Length )
		{
			MachGunClass=Class<R6LMGDescription>(DynamicLoadObject("" $ string(pServerOptions.RestrictedMachineGuns[i]),Class'Class'));
			_GRI.m_szMachGunRes[i]=MachGunClass.Default.m_NameID;
			i++;
			goto JL028B;
		}
		i=0;
JL0308:
		if ( i < 32 )
		{
			_GRI.m_szSnipRifleRes[i]="";
			i++;
			goto JL0308;
		}
		i=0;
JL033C:
		if ( i < pServerOptions.RestrictedSniperRifles.Length )
		{
			SniperRifleClass=Class<R6SniperDescription>(DynamicLoadObject("" $ string(pServerOptions.RestrictedSniperRifles[i]),Class'Class'));
			_GRI.m_szSnipRifleRes[i]=SniperRifleClass.Default.m_NameID;
			i++;
			goto JL033C;
		}
		i=0;
JL03B9:
		if ( i < 32 )
		{
			_GRI.m_szPistolRes[i]="";
			i++;
			goto JL03B9;
		}
		i=0;
JL03ED:
		if ( i < pServerOptions.RestrictedPistols.Length )
		{
			PistolClass=Class<R6PistolsDescription>(DynamicLoadObject("" $ string(pServerOptions.RestrictedPistols[i]),Class'Class'));
			_GRI.m_szPistolRes[i]=PistolClass.Default.m_NameID;
			i++;
			goto JL03ED;
		}
		i=0;
JL046A:
		if ( i < 32 )
		{
			_GRI.m_szMachPistolRes[i]="";
			i++;
			goto JL046A;
		}
		i=0;
JL049E:
		if ( i < pServerOptions.RestrictedMachinePistols.Length )
		{
			MachPistolClass=Class<R6MachinePistolsDescription>(DynamicLoadObject("" $ string(pServerOptions.RestrictedMachinePistols[i]),Class'Class'));
			_GRI.m_szMachPistolRes[i]=MachPistolClass.Default.m_NameID;
			i++;
			goto JL049E;
		}
		i=0;
JL051B:
		if ( i < 32 )
		{
			_GRI.m_szGadgPrimaryRes[i]="";
			i++;
			goto JL051B;
		}
		i=0;
JL054F:
		if ( i < pServerOptions.RestrictedPrimary.Length )
		{
			_GRI.m_szGadgPrimaryRes[i]=pServerOptions.RestrictedPrimary[i];
			i++;
			goto JL054F;
		}
		i=0;
JL05A2:
		if ( i < 32 )
		{
			_GRI.m_szGadgSecondayRes[i]="";
			i++;
			goto JL05A2;
		}
		i=0;
JL05D6:
		if ( i < pServerOptions.RestrictedSecondary.Length )
		{
			_GRI.m_szGadgSecondayRes[i]=pServerOptions.RestrictedSecondary[i];
			i++;
			goto JL05D6;
		}
		i=0;
JL0629:
		if ( i < 32 )
		{
			_GRI.m_szGadgMiscRes[i]="";
			i++;
			goto JL0629;
		}
		i=0;
JL065D:
		if ( i < pServerOptions.RestrictedMiscGadgets.Length )
		{
			_GRI.m_szGadgMiscRes[i]=pServerOptions.RestrictedMiscGadgets[i];
			i++;
			goto JL065D;
		}
	}
}

event InitGame (string Options, out string Error)
{
	local string InOpt;
	local MapList myList;
	local Class<MapList> ML;
	local string KeyName;
	local int iCounter;
	local ER6GameType eGameType;
	local UWindowMenuClassDefines pMenuDefGSServers;
	local R6ServerInfo pServerOptions;

	pServerOptions=Class'Actor'.static.GetServerOptions();
	if ( pServerOptions == None )
	{
		pServerOptions=new Class'R6ServerInfo';
	}
	pServerOptions.m_GameInfo=self;
	m_szGameOptions=Options;
	Super.InitGame(Options,Error);
	if ( pServerOptions.m_ServerMapList == None )
	{
		myList=Spawn(Class'R6MapList');
		pServerOptions.m_ServerMapList=R6MapList(myList);
	}
	else
	{
		myList=pServerOptions.m_ServerMapList;
	}
	if ( BroadcastHandler == None )
	{
		Log("failed to create BroadcastHandlerClass=" $ BroadcastHandlerClass $ "  BroadcastHandler=" $ string(BroadcastHandler));
	}
	if ( pServerOptions.UsePassword && (pServerOptions.GamePassword != "") )
	{
		AccessControl.SetGamePassword(pServerOptions.GamePassword);
	}
	MaxPlayers=Min(16,pServerOptions.MaxPlayers);
	m_szMessageOfDay=pServerOptions.MOTD;
	m_szSvrName=pServerOptions.ServerName;
	m_bInternetSvr=pServerOptions.InternetServer;
	Level.m_fTimeLimit=pServerOptions.RoundTime;
	m_iRoundsPerMatch=pServerOptions.RoundsPerMatch;
	m_fTimeBetRounds=pServerOptions.BetweenRoundTime;
	m_fBombTime=pServerOptions.BombTime;
	m_bFriendlyFire=pServerOptions.FriendlyFire;
	m_bAutoBalance=pServerOptions.Autobalance;
	m_bAdminPasswordReq=pServerOptions.UseAdminPassword;
	m_bFFPWeapon=pServerOptions.ForceFPersonWeapon;
	m_bTKPenalty=pServerOptions.TeamKillerPenalty;
	m_bShowNames=pServerOptions.ShowNames;
	m_bAIBkp=pServerOptions.AIBkp;
	if ( Level.NetMode == NM_Standalone )
	{
		if ( IsA('R6TrainingMgr') )
		{
			m_iDiffLevel=1;
		}
		else
		{
			m_iDiffLevel=Class'Actor'.static.GetCanvas().Viewport.Console.Master.m_StartGameInfo.m_DifficultyLevel;
		}
	}
	else
	{
		m_iDiffLevel=pServerOptions.DiffLevel;
	}
	m_bRepAllowRadarOption=pServerOptions.AllowRadar;
	if ( m_bIsRadarAllowed )
	{
		m_bServerAllowRadarRep=m_bRepAllowRadarOption;
	}
	else
	{
		m_bServerAllowRadarRep=False;
	}
	if ( bShowLog )
	{
		Log("RADAR: m_bIsRadarAllowed =" $ string(m_bIsRadarAllowed) $ " pServerOptions.AllowRadar=" $ string(pServerOptions.AllowRadar) $ " m_bServerAllowRadarRep=" $ string(m_bServerAllowRadarRep));
	}
	m_mapList.Remove (0,m_mapList.Length);
	m_gameModeList.Remove (0,m_gameModeList.Length);
	iCounter=0;
JL0400:
	if ( iCounter < 32 )
	{
		Level.PreBeginPlay();
		if ( iCounter == GetCurrentMapNum() )
		{
			m_iCurrGameType=Level.GetER6GameTypeFromClassName(R6MapList(myList).GameType[iCounter]);
		}
		m_mapList[iCounter]=myList.Maps[iCounter];
		m_gameModeList[iCounter]=R6MapList(myList).GameType[iCounter];
		iCounter++;
		goto JL0400;
	}
	eGameType=Level.ConvertGameTypeIntToEnum(m_iCurrGameType);
	m_iNbOfTerroristToSpawn=pServerOptions.NbTerro;
	m_iDeathCameraMode=0;
	if ( pServerOptions.CamFirstPerson )
	{
//		m_iDeathCameraMode=Level.1;
	}
	if ( pServerOptions.CamThirdPerson )
	{
//		m_iDeathCameraMode=m_iDeathCameraMode | Level.2;
	}
	if ( pServerOptions.CamFreeThirdP )
	{
//		m_iDeathCameraMode=m_iDeathCameraMode | Level.4;
	}
	if ( pServerOptions.CamGhost )
	{
//		m_iDeathCameraMode=m_iDeathCameraMode | Level.8;
	}
	if ( pServerOptions.CamTeamOnly )
	{
		if (  !(Level.IsGameTypeAdversarial(eGameType) || Level.IsGameTypeSquad(eGameType)) &&  !Level.IsGameTypeTeamAdversarial(eGameType) )
		{
//			m_iDeathCameraMode=m_iDeathCameraMode | Level.32;
		}
	}
	if ( pServerOptions.CamFadeToBlack )
	{
//		m_iDeathCameraMode=Level.16;
	}
	pMenuDefGSServers=new Class'UWindowMenuClassDefines';
	pMenuDefGSServers.Created();
	m_GameService=new Class<R6GSServers>(pMenuDefGSServers.ClassGSServer);
	m_GameService.Created();
	m_GameService.m_bDedicatedServer=Level.NetMode == NM_DedicatedServer;
	if ( Level.IsGameTypeCooperative(eGameType) )
	{
		m_bRotateMap=pServerOptions.RotateMap;
	}
	else
	{
		m_bRotateMap=False;
	}
}

function SetGamePassword (string szPasswd)
{
	local Controller P;
	local R6PlayerController _iterController;

	Super.SetGamePassword(szPasswd);
	m_GameService.m_bUpdateServer=True;
}

function CreateBackupRainbowAI ()
{
	local R6RainbowAI rainbowAI;
	local int i;

	if ( Level.NetMode == NM_Standalone )
	{
		return;
	}
	i=0;
JL0022:
	if ( i < 6 )
	{
		rainbowAI=Spawn(Class'R6RainbowAI');
		rainbowAI.bStasis=True;
		m_RainbowAIBackup[m_RainbowAIBackup.Length]=rainbowAI;
		i++;
		goto JL0022;
	}
}

function Actor GetRainbowAIFromTable ()
{
	local R6RainbowAI rainbowAI;
	local int i;

	if ( (Level.NetMode == NM_Standalone) || (Level.NetMode == NM_Client) )
	{
		return None;
	}
	if ( m_RainbowAIBackup.Length == 0 )
	{
		return None;
	}
	rainbowAI=m_RainbowAIBackup[0];
	rainbowAI.bStasis=False;
	m_RainbowAIBackup.Remove (0,1);
	return rainbowAI;
}

function DeployRainbowTeam (PlayerController NewPlayer)
{
	local R6RainbowTeam newTeam;
	local int iMembers;
	local int iActiveTotal;
	local int iActiveGreen;
	local R6RainbowStartInfo Info;

	if ( Level.NetMode != 0 )
	{
		if ( bShowLog )
		{
			Log("DeployRainbowTeam newPlayer=" $ string(NewPlayer) $ " iNbOfRainbowAIToSpawn=" $ string(GetNbOfRainbowAIToSpawn(NewPlayer)));
		}
		newTeam=Spawn(Class'R6RainbowTeam');
		newTeam.SetOwner(NewPlayer);
		if ( m_bAIBkp &&  !R6PlayerController(NewPlayer).m_bPenaltyBox && Level.IsGameTypeCooperative(m_eGameTypeFlag) )
		{
			GetNbHumanPlayerInTeam(iActiveTotal,iActiveGreen);
			iActiveTotal += iActiveGreen;
			switch (iActiveTotal)
			{
/*				case 1:
				case 2:
				iMembers=4;
				break;
				case 3:
				iMembers=2;
				break;
				case 4:
				iMembers=2;
				break;
				default:*/
			}
//			iMembers=1;
		}
		SetRainbowTeam(0,newTeam);
		Info=Spawn(Class'R6RainbowStartInfo');
		if ( NewPlayer.PlayerReplicationInfo != None )
		{
			Info.m_CharacterName=NewPlayer.PlayerReplicationInfo.PlayerName;
		}
		Info.m_ArmorName="" $ string(NewPlayer.PawnClass);
		if (  !IsPrimaryWeaponRestricted(NewPlayer.m_PlayerPrefs.m_WeaponName1) )
		{
			Info.m_WeaponName[0]=NewPlayer.m_PlayerPrefs.m_WeaponName1;
		}
		if (  !IsSecondaryWeaponRestricted(NewPlayer.m_PlayerPrefs.m_WeaponName2) )
		{
			Info.m_WeaponName[1]=NewPlayer.m_PlayerPrefs.m_WeaponName2;
		}
		else
		{
			Info.m_WeaponName[1]="R63rdWeapons.NormalPistol92FS";
		}
		Info.m_BulletType[0]=NewPlayer.m_PlayerPrefs.m_BulletType1;
		Info.m_BulletType[1]=NewPlayer.m_PlayerPrefs.m_BulletType2;
		if (  !IsPrimaryGadgetRestricted(NewPlayer.m_PlayerPrefs.m_WeaponGadgetName1) )
		{
			Info.m_WeaponGadgetName[0]=NewPlayer.m_PlayerPrefs.m_WeaponGadgetName1;
		}
		if (  !IsSecondaryGadgetRestricted(NewPlayer.m_PlayerPrefs.m_WeaponGadgetName2) )
		{
			Info.m_WeaponGadgetName[1]=NewPlayer.m_PlayerPrefs.m_WeaponGadgetName2;
		}
		if (  !IsTertiaryWeaponRestricted(NewPlayer.m_PlayerPrefs.m_GadgetName1) )
		{
			Info.m_GadgetName[0]=NewPlayer.m_PlayerPrefs.m_GadgetName1;
		}
		if (  !IsTertiaryWeaponRestricted(NewPlayer.m_PlayerPrefs.m_GadgetName2) )
		{
			Info.m_GadgetName[1]=NewPlayer.m_PlayerPrefs.m_GadgetName2;
		}
		Info.m_iOperativeID=R6Rainbow(NewPlayer.Pawn).m_iOperativeID;
		Info.m_bIsMale= !NewPlayer.Pawn.bIsFemale;
		Info.m_iHealth=0;
		Info.m_FaceTexture=DefaultFaceTexture;
		Info.m_FaceCoords=DefaultFaceCoords;
		newTeam.CreateMPPlayerTeam(NewPlayer,Info,iMembers,PlayerStart(NewPlayer.StartSpot));
		newTeam.SetMultiVoicesMgr(self,R6Pawn(NewPlayer.Pawn).m_iTeam,iMembers);
		ServerSendBankToLoad();
		R6PlayerController(NewPlayer).m_TeamManager=newTeam;
		newTeam.SetMemberTeamID(R6Pawn(NewPlayer.Pawn).m_iTeam);
	}
}

event PlayerController Login (string Portal, string Options, out string Error)
{
	local NavigationPoint StartSpot;
	local PlayerController NewPlayer;
	local Pawn TestPawn;
	local string InName;
	local string InPassword;
	local string InChecksum;
	local string InClass;
	local byte InTeam;
	local int i;
	local Actor A;
	local int iSpawnPointNum;
	local Rotator rStartSpotRot;

	StartSpot=R6FindPlayerStart(None,iSpawnPointNum,Portal);
	if ( StartSpot == None )
	{
		Error=Localize("MPMiscMessages","FailedPlaceMessage","R6GameInfo");
		return None;
	}
	if ( (PlayerControllerClass == None) && (Level.NetMode == NM_Standalone) )
	{
		PlayerControllerClass=Class<PlayerController>(DynamicLoadObject(PlayerControllerClassName,Class'Class'));
		Log(string(PlayerControllerClass) @ PlayerControllerClassName);
	}
	rStartSpotRot=StartSpot.Rotation;
	rStartSpotRot.Roll=0;
	NewPlayer=Spawn(PlayerControllerClass,,,StartSpot.Location,rStartSpotRot);
	NewPlayer.StartSpot=StartSpot;
	if ( NewPlayer == None )
	{
		Log("Couldn't spawn player controller of class " $ string(PlayerControllerClass));
		Error=Localize("MPMiscMessages","FailedSpawnMessage","R6GameInfo");
		return None;
	}
	if ( InName == "" )
	{
		InName=DefaultPlayerName;
	}
	if ( (Level.NetMode != 0) || (NewPlayer.PlayerReplicationInfo != None) && (NewPlayer.PlayerReplicationInfo.PlayerName == DefaultPlayerName) )
	{
		ChangeName(NewPlayer,InName,False);
	}
	NewPlayer.GameReplicationInfo=GameReplicationInfo;
	NewPlayer.GotoState('Spectating');
	if (  !ChangeTeam(NewPlayer,InTeam) )
	{
		Error=Localize("MPMiscMessages","FailedTeamMessage","R6GameInfo");
		return None;
	}
	if ( NewPlayer.PlayerReplicationInfo != None )
	{
		NewPlayer.PlayerReplicationInfo.PlayerID=CurrentID++ ;
	}
	if ( (Level.NetMode != 0) && (InClass == "") )
	{
		InClass=ParseOption(Options,"Class");
	}
	if ( InClass != "" )
	{
		NewPlayer.PawnClass=Class<Pawn>(DynamicLoadObject(InClass,Class'Class'));
	}
	if ( StatLog != None )
	{
		StatLog.LogPlayerConnect(NewPlayer);
	}
//	NewPlayer.ReceivedSecretChecksum= !InChecksum ~= "NoChecksum";
	NumPlayers++;
	bRestartLevel=False;
	StartMatch();
	NotifyMatchStart();
	bRestartLevel=Default.bRestartLevel;
	m_Player=NewPlayer;
	if ( bShowLog )
	{
		Log(" ********  Login() is called....playerCont = " $ string(NewPlayer) $ "  and pawn = " $ string(NewPlayer.Pawn));
	}
	return NewPlayer;
}

event PreLogOut (PlayerController ExitingPlayer)
{
	Logout(ExitingPlayer);
}

function RemoveAIBackup (R6PlayerController _playerController)
{
	local int iMember;
	local int iMemberCount;

	if ( _playerController.m_TeamManager == None )
	{
		return;
	}
	iMember=1;
JL001D:
	if ( iMember < 4 )
	{
		if ( _playerController.m_TeamManager.m_Team[iMember] != None )
		{
			_playerController.m_TeamManager.m_Team[iMember].Destroy();
			_playerController.m_TeamManager.m_Team[iMember]=None;
		}
		iMember++;
		goto JL001D;
	}
	_playerController.m_TeamManager.m_iMemberCount=0;
}

function Logout (Controller Exiting)
{
	local bool bMessage;
	local Controller P;
	local R6PlayerController _playerController;
	local R6PlayerController _iterController;
	local bool _bUpdatePlayerLadderStats;
	local float _fTimeElapsed;
	local string _szUBIUserID;
	local string _PlayerName;
	local int iAlphaNb;
	local int iBravoNb;

	_bUpdatePlayerLadderStats=(m_GameService.m_eMenuLoginRegServer == 2) && (m_bGameOver == False);
	m_GameService.m_bUpdateServer=True;
	bMessage=True;
	_playerController=R6PlayerController(Exiting);
	if ( _playerController == None )
	{
		return;
	}
	if ( _playerController.m_PreLogOut == True )
	{
		return;
	}
	_playerController.m_PreLogOut=True;
	if ( _playerController.bOnlySpectator )
	{
		bMessage=False;
	}
	else
	{
		if ( bShowLog )
		{
			Log(string(Exiting) $ "Player has quit the game " $ string(Exiting.Pawn) $ ": suicide");
		}
		if ( m_bAIBkp && Level.IsGameTypeCooperative(m_eGameTypeFlag) )
		{
			RemoveAIBackup(_playerController);
		}
		if ( (Exiting.Pawn != None) && R6Pawn(Exiting.Pawn).IsAlive() )
		{
			if (  !bChangeLevels )
			{
				R6Pawn(Exiting.Pawn).ServerSuicidePawn(1);
			}
		}
	}
	NumPlayers--;
	if ( (Level.NetMode == NM_DedicatedServer) || (Level.NetMode == NM_ListenServer) )
	{
		GetNbHumanPlayerInTeam(iAlphaNb,iBravoNb);
		if ( _playerController.m_TeamSelection == 2 )
		{
			iAlphaNb--;
		}
		if ( Level.IsGameTypeCooperative(m_eGameTypeFlag) )
		{
			SetCompilingStats(iAlphaNb > 0);
			SetRoundRestartedByJoinFlag(iAlphaNb == 0);
		}
		_PlayerName=Exiting.PlayerReplicationInfo.PlayerName;
		_fTimeElapsed=Level.TimeSeconds - m_fRoundStartTime;
		_szUBIUserID=Exiting.PlayerReplicationInfo.m_szUbiUserID;
		P=Level.ControllerList;
JL0288:
		if ( P != None )
		{
			_iterController=R6PlayerController(P);
			if ( (P != Exiting) && (_iterController != None) && (_iterController.m_TeamSelection != 4) )
			{
				if ( _bUpdatePlayerLadderStats && m_bLadderStats && (R6PlayerController(Exiting).m_TeamSelection != 4) )
				{
					if ( Exiting.PlayerReplicationInfo.Deaths > Exiting.PlayerReplicationInfo.m_iBackUpDeaths )
					{
						_iterController.ClientUpdateLadderStat(_szUBIUserID,Exiting.PlayerReplicationInfo.m_iRoundKillCount,1,_fTimeElapsed);
					}
					else
					{
						_iterController.ClientUpdateLadderStat(_szUBIUserID,Exiting.PlayerReplicationInfo.m_iRoundKillCount,0,_fTimeElapsed);
					}
				}
			}
			if ( Exiting == m_PlayerKick )
			{
				_iterController.ClientVoteSessionAbort(_PlayerName);
			}
			P=P.nextController;
			goto JL0288;
		}
		if ( Exiting == m_PlayerKick )
		{
			m_PlayerKick=None;
			m_KickersName="";
			m_fEndKickVoteTime=0.00;
		}
		if ( bMessage )
		{
			BroadcastLocalizedMessage(GameMessageClass,4,Exiting.PlayerReplicationInfo);
		}
	}
	if ( StatLog != None )
	{
		StatLog.LogPlayerDisconnect(Exiting);
	}
}

function bool SpawnNumberToNavPoint (int _iSpawnNumber, out NavigationPoint _StartNavPoint)
{
	local R6AbstractInsertionZone NavPoint;
	local Controller OtherPlayer;
	local float NextDist;

	foreach AllActors(Class'R6AbstractInsertionZone',NavPoint)
	{
		if ( (NavPoint.m_iInsertionNumber == _iSpawnNumber) && NavPoint.IsAvailableInGameType(m_eGameTypeFlag) )
		{
			OtherPlayer=Level.ControllerList;
JL0052:
			if ( OtherPlayer != None )
			{
				if ( OtherPlayer.bIsPlayer && (OtherPlayer.Pawn != None) && (OtherPlayer.Pawn.Region.Zone == NavPoint.Region.Zone) )
				{
					NextDist=VSize(OtherPlayer.Pawn.Location - NavPoint.Location);
					if ( NextDist < OtherPlayer.Pawn.CollisionRadius + OtherPlayer.Pawn.CollisionHeight )
					{
						Log("SPAWNNUMBERTONAVPOINT: Player" @ string(OtherPlayer.Pawn) @ "is in the way");
						return False;
					}
				}
				OtherPlayer=OtherPlayer.nextController;
				goto JL0052;
			}
			_StartNavPoint=NavPoint;
			return True;
		}
	}
	return False;
}

function NavigationPoint R6FindPlayerStart (Controller Player, optional int SpawnPointNumber, optional string incomingName)
{
	local NavigationPoint NavPoint;
	local PlayerStart _tempStart;
	local PlayerStart _checkStarts;

	if ( bShowLog )
	{
		Log(string(self) @ ": R6FindPlayerStart for" @ string(Player) @ "Name is" @ incomingName @ " spawn number is" @ string(SpawnPointNumber));
	}
	return FindPlayerStart(Player,SpawnPointNumber);
}

function NavigationPoint FindPlayerStart (Controller Player, optional byte InTeam, optional string incomingName)
{
	local R6AbstractInsertionZone NavPoint;
	local R6AbstractInsertionZone BestStart;
	local PlayerStart _tempStart;
	local float BestRating;
	local float NewRating;
	local PlayerStart _checkStarts;
	local ER6GameType eGameType;

	eGameType=R6AbstractGameInfo(Level.Game).m_eGameTypeFlag;
	if ( bShowLog )
	{
		Log(string(self) @ ": R6GameInfo FindPlayerStart for" @ string(Player) @ "Name is" @ incomingName @ "Spawn num" @ string(InTeam));
	}
	foreach AllActors(Class'PlayerStart',_checkStarts)
	{
		if ( bShowLog )
		{
			Log("Found PlayerStart" @ string(_checkStarts));
		}
		if (  !_checkStarts.IsA('R6AbstractInsertionZone') )
		{
			_tempStart=_checkStarts;
			Log("WARNING - Please make sure that the PlayerStart " $ string(_checkStarts) $ " is replaced with an R6InsertionZone type instead");
		}
	}
	foreach AllActors(Class'R6AbstractInsertionZone',NavPoint)
	{
		if (  !NavPoint.IsAvailableInGameType(m_eGameTypeFlag) )
		{
			continue;
		}
		else
		{
			NewRating=RatePlayerStart(NavPoint,InTeam,Player);
			if ( NewRating > BestRating )
			{
				BestRating=NewRating;
				BestStart=NavPoint;
			}
		}
	}
	if ( BestStart == None )
	{
		Log("WARNING - NO R6INSERTIONZONE FOUND - WARNING");
		Log("WARNING - Make sure you are using R6InsertionZone instead of PlayerStart");
		LastStartSpot=_checkStarts;
		return _tempStart;
	}
	if ( BestStart != None )
	{
		LastStartSpot=BestStart;
	}
	return BestStart;
}

function float RatePlayerStart (NavigationPoint NavPoint, byte Team, Controller Player)
{
	local R6AbstractInsertionZone _startPoint;
	local float Score;
	local float NextDist;
	local Controller OtherPlayer;

	_startPoint=R6AbstractInsertionZone(NavPoint);
	if ( _startPoint == None )
	{
		return 0.00;
	}
	Score=16000000.00;
	if (  !_startPoint.IsAvailableInGameType(m_eGameTypeFlag) )
	{
		Score -= 1000000;
	}
	Score += 10000 * FRand();
	if ( _startPoint.m_iInsertionNumber == Team )
	{
		Score += 40000;
	}
	else
	{
		Score -= 1000000;
	}
	OtherPlayer=Level.ControllerList;
JL00AF:
	if ( OtherPlayer != None )
	{
		if ( OtherPlayer.bIsPlayer && (OtherPlayer.Pawn != None) )
		{
			if ( OtherPlayer.Pawn.Region.Zone == _startPoint.Region.Zone )
			{
				Score -= 1500;
				NextDist=VSize(OtherPlayer.Pawn.Location - _startPoint.Location);
				if ( NextDist < OtherPlayer.Pawn.CollisionRadius + OtherPlayer.Pawn.CollisionHeight )
				{
					Score -= 1000000.00;
				}
				else
				{
					if ( (NextDist < 3000) && FastTrace(_startPoint.Location,OtherPlayer.Pawn.Location) )
					{
						Score -= 10000.00 - NextDist;
					}
					else
					{
						if ( Level.Game.NumPlayers + Level.Game.NumBots == 2 )
						{
							Score += 2 * VSize(OtherPlayer.Pawn.Location - _startPoint.Location);
							if ( FastTrace(_startPoint.Location,OtherPlayer.Pawn.Location) )
							{
								Score -= 10000;
							}
						}
					}
				}
			}
			if ( OtherPlayer.bIsPlayer && (OtherPlayer.StartSpot == _startPoint) )
			{
				Score -= 1000000.00;
			}
		}
		OtherPlayer=OtherPlayer.nextController;
		goto JL00AF;
	}
	return Score;
}

function bool Stats_getPlayerInfo (out string sz, R6Pawn pPawn, PlayerReplicationInfo pInfo)
{
	local string szHealth;
	local int iKills;

	if ( pInfo == None )
	{
		sz="";
		return False;
	}
	if ( pPawn != None )
	{
		if ( pPawn.m_eHealth == 0 )
		{
			szHealth="healthy";
		}
		else
		{
			if ( pPawn.m_eHealth == 1 )
			{
				szHealth="wounded";
			}
			else
			{
				szHealth="dead";
			}
		}
		iKills=pInfo.m_iKillCount;
	}
	else
	{
		szHealth="unknow";
	}
	sz="" $ pInfo.PlayerName $ " kills: " $ string(iKills) $ " (deaths: " $ string(pInfo.Deaths) $ ") status : " $ szHealth;
	return True;
}

function RestartPlayer (Controller aPlayer)
{
	local NavigationPoint StartSpot;
	local int iStartPos;
	local Class<Pawn> DefaultPlayerClass;
	local Rotator rStartingPointRot;

	if ( bRestartLevel && (Level.NetMode != 1) && (Level.NetMode != 2) )
	{
		return;
	}
	if ( (R6PlayerController(aPlayer) != None) && (R6PlayerController(aPlayer).m_TeamSelection == 3) )
	{
		iStartPos=1;
	}
	else
	{
		iStartPos=0;
	}
	StartSpot=FindPlayerStart(aPlayer,iStartPos);
	if ( StartSpot == None )
	{
		Log(" Player start not found!!!");
		return;
	}
	rStartingPointRot=StartSpot.Rotation;
	rStartingPointRot.Roll=0;
	R6SetPawnClassInMultiPlayer(aPlayer);
	if ( aPlayer.PawnClass != None )
	{
		aPlayer.Pawn=Spawn(aPlayer.PawnClass,,,StartSpot.Location,rStartingPointRot);
	}
	if ( aPlayer.Pawn == None )
	{
		aPlayer.PawnClass=GetDefaultPlayerClass();
		aPlayer.Pawn=Spawn(aPlayer.PawnClass,,,StartSpot.Location,rStartingPointRot,True);
	}
	if ( aPlayer.Pawn == None )
	{
		Log("Couldn't spawn player of type " $ string(aPlayer.PawnClass) $ " at " $ string(StartSpot));
		aPlayer.GotoState('Dead');
		return;
	}
	aPlayer.StartSpot=StartSpot;
	aPlayer.PreviousPawnClass=aPlayer.Pawn.Class;
	aPlayer.Possess(aPlayer.Pawn);
	aPlayer.PawnClass=aPlayer.Pawn.Class;
	aPlayer.PlayTeleportEffect(True,True);
	aPlayer.ClientSetRotation(aPlayer.Pawn.Rotation);
	AddDefaultInventory(aPlayer.Pawn);
	TriggerEvent(StartSpot.Event,StartSpot,aPlayer.Pawn);
	R6Pawn(aPlayer.Pawn).m_iUniqueID=m_iCurrentID;
	m_iCurrentID++;
}

function R6SetPawnClassInMultiPlayer (Controller _playerController)
{
	if (  !(Level.NetMode == NM_DedicatedServer) || (Level.NetMode == NM_ListenServer) )
	{
		return;
	}
	if ( R6PlayerController(_playerController).m_TeamSelection == 3 )
	{
		R6PlayerController(_playerController).PawnClass=Class<Pawn>(DynamicLoadObject(Level.RedTeamPawnClass,Class'Class'));
		if ( R6PlayerController(_playerController).PawnClass == None )
		{
			R6PlayerController(_playerController).PawnClass=Class<Pawn>(DynamicLoadObject(Level.Default.RedTeamPawnClass,Class'Class'));
		}
	}
	else
	{
		R6PlayerController(_playerController).PawnClass=Class<Pawn>(DynamicLoadObject(Level.GreenTeamPawnClass,Class'Class'));
		if ( R6PlayerController(_playerController).PawnClass == None )
		{
			R6PlayerController(_playerController).PawnClass=Class<Pawn>(DynamicLoadObject(Level.Default.GreenTeamPawnClass,Class'Class'));
		}
	}
}

function LoadPlanningInTraining ();

event PostLogin (PlayerController NewPlayer)
{
	local R6FileManagerPlanning pFileManager;

	Super.PostLogin(NewPlayer);
	if ( NewPlayer.IsA('R6PlanningCtrl') )
	{
		R6PlanningCtrl(NewPlayer).SetPlanningInfo();
	}
	if ( Level.NetMode == NM_Standalone )
	{
		if ( NewPlayer.Player.Console.Master.m_StartGameInfo.m_GameMode == "R6Game.R6TrainingMgr" )
		{
			LoadPlanningInTraining();
			R6Console(NewPlayer.Player.Console).StartR6Game();
			return;
		}
		if ( NewPlayer.Player.Console.Master.m_StartGameInfo.m_ReloadPlanning == True )
		{
			pFileManager=new Class'R6FileManagerPlanning';
			pFileManager.LoadPlanning("Backup","Backup","Backup","","Backup.pln",NewPlayer.Player.Console.Master.m_StartGameInfo);
			NewPlayer.Player.Console.Master.m_StartGameInfo.m_ReloadPlanning=False;
			if ( NewPlayer.Player.Console.Master.m_StartGameInfo.m_SkipPlanningPhase == False )
			{
				R6PlanningCtrl(NewPlayer).InitNewPlanning(pFileManager.m_iCurrentTeam);
			}
		}
		if ( NewPlayer.Player.Console.Master.m_StartGameInfo.m_SkipPlanningPhase == True )
		{
			R6Console(NewPlayer.Player.Console).StartR6Game();
			NewPlayer.Player.Console.Master.m_StartGameInfo.m_SkipPlanningPhase=False;
		}
		else
		{
			SetPlanningMode(True);
		}
	}
	if ( Level.NetMode != 0 )
	{
		NewPlayer.ClientSetHUD(Class'R6HUD',None);
	}
}

function DeployCharacters (PlayerController ControlledByPlayer)
{
	local R6StartGameInfo StartGameInfo;
	local int CurrentTeam;
	local Player CurrentPlayer;
	local Interaction CurrentConsole;
	local R6DeploymentZone PZone;
	local R6ActionPoint pActionPoint;
	local R6Terrorist pTerrorist;
	local int iSoundNb;

	assert (Level.NetMode == NM_Standalone);
	CurrentPlayer=ControlledByPlayer.Player;
	CurrentConsole=ControlledByPlayer.Player.Console;
	if ( ControlledByPlayer.Pawn != None )
	{
		ControlledByPlayer.Pawn.SetCollision(False,False,False);
		ControlledByPlayer.Pawn.SetPhysics(PHYS_None);
		ControlledByPlayer.Pawn.Destroy();
	}
	ControlledByPlayer.Destroy();
	ControlledByPlayer=None;
	StartGameInfo=CurrentConsole.Master.m_StartGameInfo;
	ControlledByPlayer=Spawn(Class'R6PlayerController',,,Location);
	CurrentTeam=0;
JL00EE:
	if ( CurrentTeam < 3 )
	{
		if ( StartGameInfo.m_TeamInfo[CurrentTeam].m_iNumberOfMembers > 0 )
		{
			StartGameInfo.m_TeamInfo[CurrentTeam].m_pPlanning.ResetID();
			CreateRainbowTeam(CurrentTeam,StartGameInfo.m_TeamInfo[CurrentTeam],StartGameInfo.m_bIsPlaying,StartGameInfo.m_iTeamStart,ControlledByPlayer);
		}
		CurrentTeam++;
		goto JL00EE;
	}
	if ( StartGameInfo.m_bIsPlaying )
	{
		ControlledByPlayer=PlayerController(R6RainbowTeam(GetRainbowTeam(StartGameInfo.m_iTeamStart)).m_TeamLeader.Controller);
		SetController(ControlledByPlayer,CurrentPlayer);
	}
	else
	{
		ControlledByPlayer.SetLocation(R6RainbowTeam(GetRainbowTeam(StartGameInfo.m_iTeamStart)).m_TeamLeader.Location);
		ControlledByPlayer.m_CurrentAmbianceObject=R6RainbowTeam(GetRainbowTeam(StartGameInfo.m_iTeamStart)).m_TeamLeader.Region.Zone;
		m_Player=ControlledByPlayer;
		m_Player.GameReplicationInfo=GameReplicationInfo;
		m_Player.bOnlySpectator=True;
		SetController(ControlledByPlayer,CurrentPlayer);
		m_Player.GotoState('CameraPlayer');
	}
	CurrentTeam=0;
JL02B1:
	if ( CurrentTeam < 3 )
	{
		if ( StartGameInfo.m_TeamInfo[CurrentTeam].m_iNumberOfMembers == 0 )
		{
			StartGameInfo.m_TeamInfo[CurrentTeam].m_pPlanning.m_pTeamManager=R6RainbowTeam(GetRainbowTeam(StartGameInfo.m_iTeamStart));
		}
		CurrentTeam++;
		goto JL02B1;
	}
	foreach AllActors(Class'R6ActionPoint',pActionPoint)
	{
		pActionPoint.SetDrawType(DT_None);
		pActionPoint.bHidden=True;
		if ( pActionPoint.m_pActionIcon != None )
		{
			pActionPoint.m_pActionIcon=None;
		}
	}
	if ( Level.NetMode == NM_Standalone )
	{
		SetPlanningMode(False);
	}
}

function CreateRainbowTeam (int NewTeamNumber, R6TeamStartInfo TeamInfo, bool bIsPlaying, int iTeamStart, PlayerController aRainbowPC)
{
	local NavigationPoint StartingPoint;
	local R6RainbowTeam newTeam;

	newTeam=Spawn(Class'R6RainbowTeam');
	TeamInfo.m_pPlanning.m_pTeamManager=newTeam;
	newTeam.m_TeamPlanning=TeamInfo.m_pPlanning;
	if ( newTeam.m_TeamPlanning.GetNbActionPoint() != 0 )
	{
		newTeam.m_TeamPlanning.ResetPointsOrientation();
	}
	if ( (TeamInfo.m_pPlanning.m_NodeList.Length > 0) || (TeamInfo.m_pPlanning.m_iStartingPointNumber != 0) )
	{
		StartingPoint=FindTeamInsertionZone(TeamInfo.m_pPlanning.m_iStartingPointNumber);
	}
	else
	{
		StartingPoint=FindTeamInsertionZone(-1);
	}
	if ( StartingPoint == None )
	{
		if ( bShowLog )
		{
			Warn("Couldn't find insertion zone #" $ string(TeamInfo.m_pPlanning.m_iStartingPointNumber) $ " Finding Insertion #0 or player start");
		}
		StartingPoint=FindTeamInsertionZone(0);
		if ( StartingPoint == None )
		{
			FindPlayerStart(m_Player);
		}
	}
	SetRainbowTeam(NewTeamNumber,newTeam);
	if ( (NewTeamNumber == iTeamStart) && bIsPlaying )
	{
		newTeam.CreatePlayerTeam(TeamInfo,StartingPoint,aRainbowPC);
		R6PlayerController(m_Player).m_TeamManager=newTeam;
		newTeam.SetVoicesMgr(self,True,True,m_iIDVoicesMgr);
	}
	else
	{
		newTeam.CreateAITeam(TeamInfo,StartingPoint);
		newTeam.SetVoicesMgr(self,False,NewTeamNumber == iTeamStart,m_iIDVoicesMgr);
		if ( (NewTeamNumber != iTeamStart) && (GetGameOptions().SndQuality == 1) )
		{
			m_iIDVoicesMgr++;
		}
	}
	newTeam.m_iRainbowTeamName=NewTeamNumber;
}

function R6InsertionZone FindTeamInsertionZone (int iSpawningPointNumber)
{
	local int iCurrentZoneNumber;
	local R6InsertionZone anInsertionZone;
	local R6InsertionZone pSelectedInsertionZone;

	iCurrentZoneNumber=2147483647;
	pSelectedInsertionZone=None;
	foreach AllActors(Class'R6InsertionZone',anInsertionZone)
	{
		if ( iSpawningPointNumber == -1 )
		{
			if ( anInsertionZone.IsAvailableInGameType(R6AbstractGameInfo(Level.Game).m_eGameTypeFlag) && (anInsertionZone.m_iInsertionNumber < iCurrentZoneNumber) )
			{
				iCurrentZoneNumber=anInsertionZone.m_iInsertionNumber;
				pSelectedInsertionZone=anInsertionZone;
			}
		}
		else
		{
			if ( (anInsertionZone.m_iInsertionNumber == iSpawningPointNumber) && anInsertionZone.IsAvailableInGameType(R6AbstractGameInfo(Level.Game).m_eGameTypeFlag) )
			{
				return anInsertionZone;
			}
		}
	}
	return pSelectedInsertionZone;
}

function bool RainbowOperativesStillAlive ()
{
	local R6GameReplicationInfo repInfo;

	repInfo=R6GameReplicationInfo(GameReplicationInfo);
	if ( (repInfo.m_RainbowTeam[0] != None) && (repInfo.m_RainbowTeam[0].m_iMemberCount > 0) )
	{
		return True;
	}
	if ( (repInfo.m_RainbowTeam[1] != None) && (repInfo.m_RainbowTeam[1].m_iMemberCount > 0) )
	{
		return True;
	}
	if ( (repInfo.m_RainbowTeam[2] != None) && (repInfo.m_RainbowTeam[2].m_iMemberCount > 0) )
	{
		return True;
	}
	return False;
}

function bool IsARainbowAlive ()
{
	local R6GameReplicationInfo gInfo;
	local int iTeam;
	local int iRainbow;

	gInfo=R6GameReplicationInfo(GameReplicationInfo);
	iTeam=0;
JL0017:
	if ( (iTeam < 3) && (gInfo.m_RainbowTeam[iTeam] != None) )
	{
		iRainbow=0;
JL0046:
		if ( iRainbow < gInfo.m_RainbowTeam[iTeam].m_iMemberCount )
		{
			if ( gInfo.m_RainbowTeam[iTeam].m_Team[iRainbow].IsAlive() )
			{
				return True;
			}
			++iRainbow;
			goto JL0046;
		}
		++iTeam;
		goto JL0017;
	}
	return False;
}

function Actor GetNewTeam (Actor aCurrentTeam, optional bool bNextTeam)
{
	local R6RainbowTeam aRainbowTeam[3];
	local R6RainbowTeam aNewTeam;
	local int i;
	local int iCurrentTeam;
	local int iNewTeam;

	if ( aCurrentTeam == None )
	{
		return None;
	}
	aRainbowTeam[0]=R6RainbowTeam(GetRainbowTeam(0));
	aRainbowTeam[1]=R6RainbowTeam(GetRainbowTeam(1));
	aRainbowTeam[2]=R6RainbowTeam(GetRainbowTeam(2));
	if ( (aRainbowTeam[1] != None) && aRainbowTeam[1].m_bPreventUsingTeam )
	{
		aRainbowTeam[1]=None;
	}
	if ( (aRainbowTeam[2] != None) && aRainbowTeam[2].m_bPreventUsingTeam )
	{
		aRainbowTeam[2]=None;
	}
	if ( (aRainbowTeam[1] == None) && (aRainbowTeam[2] == None) )
	{
		return None;
	}
	if ( aRainbowTeam[2] == None )
	{
		if ( aCurrentTeam == aRainbowTeam[0] )
		{
			aNewTeam=aRainbowTeam[1];
		}
		else
		{
			aNewTeam=aRainbowTeam[0];
		}
		if ( aNewTeam.m_iMemberCount == 0 )
		{
			return None;
		}
	}
	else
	{
		i=0;
JL0121:
		if ( i < 3 )
		{
			if ( aRainbowTeam[i] == aCurrentTeam )
			{
				iCurrentTeam=i;
			}
			else
			{
				i++;
				goto JL0121;
			}
		}
		iNewTeam=iCurrentTeam;
JL0165:
		if ( bNextTeam )
		{
			iNewTeam++;
		}
		else
		{
			iNewTeam--;
		}
		if ( iNewTeam == -1 )
		{
			iNewTeam=2;
		}
		if ( iNewTeam == 3 )
		{
			iNewTeam=0;
		}
		if (! (aRainbowTeam[iNewTeam] != None) && (aRainbowTeam[iNewTeam].m_iMemberCount != 0) || (aRainbowTeam[iNewTeam] == aCurrentTeam) ) goto JL0165;
		if ( aRainbowTeam[iNewTeam] == aCurrentTeam )
		{
			return None;
		}
		aNewTeam=aRainbowTeam[iNewTeam];
	}
	return aNewTeam;
}

function ChangeOperatives (PlayerController inPlayerController, int iTeamId, int iOperativeID)
{
	local R6RainbowTeam aNewTeam;
	local R6PlayerController aPlayerController;

	aPlayerController=R6PlayerController(inPlayerController);
	if ( Level.NetMode != 0 )
	{
		aNewTeam=aPlayerController.m_TeamManager;
	}
	else
	{
		aNewTeam=R6RainbowTeam(GetRainbowTeam(iTeamId));
	}
	if ( aPlayerController.bOnlySpectator )
	{
		if ( aPlayerController.m_eCameraMode == 3 )
		{
			return;
		}
JL0083:
		if ( aPlayerController.m_TeamManager != aNewTeam )
		{
			aPlayerController.ChangeTeams(True);
			goto JL0083;
		}
JL00AE:
		if ( R6Pawn(aPlayerController.ViewTarget).m_iID != iOperativeID )
		{
			aPlayerController.NextMember();
			goto JL00AE;
		}
		return;
	}
	if ( aPlayerController.m_TeamManager == aNewTeam )
	{
		aPlayerController.m_TeamManager.SwapPlayerControlWithTeamMate(iOperativeID);
	}
	else
	{
		aNewTeam.AssignNewTeamLeader(iOperativeID);
		ChangeTeams(inPlayerController,,aNewTeam);
	}
}

function ChangeTeams (PlayerController inPlayerController, optional bool bNextTeam, optional Actor newRainbowTeam)
{
	local R6PawnReplicationInfo aPawnRepInfo;
	local R6PlayerController aPC;
	local R6RainbowAI tempAIController;
	local R6RainbowTeam aCurrentTeam;
	local R6RainbowTeam aNewTeam;
	local bool bPlayerDied;

	aPC=R6PlayerController(inPlayerController);
	if ( Level.NetMode != 0 )
	{
		return;
	}
	if ( aPC.Pawn == None )
	{
		return;
	}
	bPlayerDied= !aPC.Pawn.IsAlive();
	aCurrentTeam=aPC.m_TeamManager;
	if ( newRainbowTeam == None )
	{
		aNewTeam=R6RainbowTeam(GetNewTeam(aCurrentTeam,bNextTeam));
	}
	else
	{
		aNewTeam=R6RainbowTeam(newRainbowTeam);
	}
	if ( (aCurrentTeam == None) || (aNewTeam == None) )
	{
		return;
	}
	if ( bPlayerDied )
	{
//		aPC.ClientFadeCommonSound(0.50,100);
	}
	aCurrentTeam.PlayerHasAbandonedTeam();
	aPC.ResetPlayerVisualEffects();
	aPC.m_bLockWeaponActions=False;
	tempAIController=R6RainbowAI(aNewTeam.m_TeamLeader.Controller);
	aPawnRepInfo=tempAIController.m_PawnRepInfo;
	tempAIController.m_PawnRepInfo=aPC.m_PawnRepInfo;
	tempAIController.m_PawnRepInfo.m_ControllerOwner=tempAIController;
	aPC.m_PawnRepInfo=aPawnRepInfo;
	aPC.m_PawnRepInfo.m_ControllerOwner=aPC;
	aPC.m_CurrentAmbianceObject=tempAIController.Pawn.Region.Zone;
	aPC.m_TeamManager=aNewTeam;
	if (  !bPlayerDied )
	{
		aCurrentTeam.m_TeamLeader.UnPossessed();
	}
	aNewTeam.AssociatePlayerAndPawn(aPC,aNewTeam.m_TeamLeader);
	aNewTeam.m_bLeaderIsAPlayer=True;
	aNewTeam.m_TeamLeader.m_bIsPlayer=True;
	aNewTeam.SetPlayerControllerState(aPC);
	aNewTeam.InstructPlayerTeamToFollowLead();
	aCurrentTeam.m_bLeaderIsAPlayer=False;
	if ( bPlayerDied )
	{
		tempAIController.Destroy();
	}
	else
	{
		aCurrentTeam.m_TeamLeader.m_bIsPlayer=False;
		aCurrentTeam.m_TeamLeader.Controller=tempAIController;
		aCurrentTeam.m_TeamLeader.Controller.Possess(aCurrentTeam.m_TeamLeader);
		tempAIController.m_TeamManager=aCurrentTeam;
		tempAIController.StopMoving();
		aCurrentTeam.SetAILeadControllerState();
		if ( aPC.m_bAllTeamsHold )
		{
			aCurrentTeam.AITeamHoldPosition();
		}
	}
	aCurrentTeam.m_TeamLeader.PawnLook(rot(0,0,0),);
	aCurrentTeam.UpdateFirstPersonWeaponMemory(aCurrentTeam.m_TeamLeader,aNewTeam.m_TeamLeader);
	aCurrentTeam.UpdatePlayerWeapon(aNewTeam.m_TeamLeader);
	if ( aNewTeam.m_TeamLeader.m_bPawnIsReloading == True )
	{
		aNewTeam.m_TeamLeader.ServerSwitchReloadingWeapon(False);
		aNewTeam.m_TeamLeader.m_bPawnIsReloading=False;
		aNewTeam.m_TeamLeader.GotoState('None');
		aNewTeam.m_TeamLeader.PlayWeaponAnimation();
	}
	aCurrentTeam.SetVoicesMgr(self,False,False,aNewTeam.m_iIDVoicesMgr);
	aNewTeam.SetVoicesMgr(self,True,True);
	aNewTeam.UpdateTeamGrenadeStatus();
	if ( (aNewTeam.m_iMemberCount == 1) && (aNewTeam.m_iMembersLost > 0) )
	{
//		aNewTeam.SetTeamState(21);
	}
	aPC.UpdatePlayerPostureAfterSwitch();
}

function InstructAllTeamsToHoldPosition ()
{
	local R6RainbowTeam aRainbowTeam[3];
	local int i;
	local int iNbTeam;

	i=0;
JL0007:
	if ( i < 3 )
	{
		aRainbowTeam[i]=R6RainbowTeam(GetRainbowTeam(i));
		if ( (aRainbowTeam[i] != None) && (aRainbowTeam[i].m_iMemberCount > 0) )
		{
			iNbTeam++;
		}
		i++;
		goto JL0007;
	}
	i=0;
JL0074:
	if ( i < 3 )
	{
		if ( aRainbowTeam[i] != None )
		{
			if ( aRainbowTeam[i].m_bLeaderIsAPlayer )
			{
				aRainbowTeam[i].InstructPlayerTeamToHoldPosition(iNbTeam > 1);
			}
			else
			{
				aRainbowTeam[i].AITeamHoldPosition();
			}
			aRainbowTeam[i].m_bAllTeamsHold=True;
		}
		i++;
		goto JL0074;
	}
}

function InstructAllTeamsToFollowPlanning ()
{
	local R6RainbowTeam aRainbowTeam[3];
	local int i;
	local int iNbTeam;

	i=0;
JL0007:
	if ( i < 3 )
	{
		aRainbowTeam[i]=R6RainbowTeam(GetRainbowTeam(i));
		if ( (aRainbowTeam[i] != None) && (aRainbowTeam[i].m_iMemberCount > 0) )
		{
			iNbTeam++;
		}
		i++;
		goto JL0007;
	}
	i=0;
JL0074:
	if ( i < 3 )
	{
		if ( aRainbowTeam[i] != None )
		{
			if ( aRainbowTeam[i].m_bLeaderIsAPlayer )
			{
				aRainbowTeam[i].InstructPlayerTeamToFollowLead(iNbTeam > 1);
			}
			else
			{
				aRainbowTeam[i].AITeamFollowPlanning();
			}
			aRainbowTeam[i].m_bAllTeamsHold=False;
		}
		i++;
		goto JL0074;
	}
}

function Object GetMultiCoopPlayerVoicesMgr (int iTeam)
{
	local int iIndex;

	switch (iTeam)
	{
/*		case 1:
		case 4:
		case 7:
		iIndex=0;
		break;
		case 2:
		case 5:
		case 8:
		iIndex=1;
		break;
		case 3:
		case 6:
		iIndex=2;
		break;
		default:
		iIndex=0;*/
	}
	if ( m_MultiCoopPlayerVoicesMgr.Length <= iIndex )
	{
		m_MultiCoopPlayerVoicesMgr[iIndex]=None;
	}
	if ( m_MultiCoopPlayerVoicesMgr[iIndex] == None )
	{
		switch (iIndex)
		{
/*			case 0:
			m_MultiCoopPlayerVoicesMgr[iIndex]=new Class'R6MultiCoopPlayerVoices1';
			break;
			case 1:
			m_MultiCoopPlayerVoicesMgr[iIndex]=new Class'R6MultiCoopPlayerVoices2';
			break;
			case 2:
			m_MultiCoopPlayerVoicesMgr[iIndex]=new Class'R6MultiCoopPlayerVoices3';
			break;
			default:*/
		}
		m_MultiCoopPlayerVoicesMgr[iIndex].Init(self);
	}
	return m_MultiCoopPlayerVoicesMgr[iIndex];
}

function Object GetMultiCoopMemberVoicesMgr ()
{
	if ( m_MultiCoopMemberVoicesMgr == None )
	{
		m_MultiCoopMemberVoicesMgr=new Class'R6MultiCoopMemberVoices';
		m_MultiCoopMemberVoicesMgr.Init(self);
	}
	return m_MultiCoopMemberVoicesMgr;
}

function Object GetPreRecordedMsgVoicesMgr ()
{
	if ( m_PreRecordedMsgVoicesMgr == None )
	{
		m_PreRecordedMsgVoicesMgr=new Class'R6PreRecordedMsgVoices';
		m_PreRecordedMsgVoicesMgr.Init(self);
	}
	return m_PreRecordedMsgVoicesMgr;
}

function Object GetMultiCommonVoicesMgr ()
{
	if ( m_MultiCommonVoicesMgr == None )
	{
		m_MultiCommonVoicesMgr=new Class'R6MultiCommonVoices';
		m_MultiCommonVoicesMgr.Init(self);
	}
	return m_MultiCommonVoicesMgr;
}

function Object GetCommonRainbowPlayerVoicesMgr ()
{
	if ( m_CommonRainbowPlayerVoicesMgr == None )
	{
		m_CommonRainbowPlayerVoicesMgr=new Class'R6CommonRainbowPlayerVoices';
		m_CommonRainbowPlayerVoicesMgr.Init(self);
	}
	return m_CommonRainbowPlayerVoicesMgr;
}

function Object GetCommonRainbowMemberVoicesMgr ()
{
	if ( m_CommonRainbowMemberVoicesMgr == None )
	{
		m_CommonRainbowMemberVoicesMgr=new Class'R6CommonRainbowMemberVoices';
		m_CommonRainbowMemberVoicesMgr.Init(self);
	}
	return m_CommonRainbowMemberVoicesMgr;
}

function Object GetRainbowPlayerVoicesMgr ()
{
	if ( m_RainbowPlayerVoicesMgr == None )
	{
		m_RainbowPlayerVoicesMgr=new Class'R6RainbowPlayerVoices';
		m_RainbowPlayerVoicesMgr.Init(self);
	}
	return m_RainbowPlayerVoicesMgr;
}

function Object GetRainbowMemberVoicesMgr ()
{
	if ( m_RainbowMemberVoicesMgr == None )
	{
		m_RainbowMemberVoicesMgr=new Class'R6RainbowMemberVoices';
		m_RainbowMemberVoicesMgr.Init(self);
	}
	return m_RainbowMemberVoicesMgr;
}

function Object GetRainbowOtherTeamVoicesMgr (int iIDVoicesMgr)
{
	if ( m_RainbowOtherTeamVoicesMgr.Length <= iIDVoicesMgr )
	{
		m_RainbowOtherTeamVoicesMgr[iIDVoicesMgr]=None;
	}
	if ( m_RainbowOtherTeamVoicesMgr[iIDVoicesMgr] == None )
	{
		if ( iIDVoicesMgr == 0 )
		{
			m_RainbowOtherTeamVoicesMgr[iIDVoicesMgr]=new Class'R6RainbowOtherTeamVoices1';
		}
		else
		{
			m_RainbowOtherTeamVoicesMgr[iIDVoicesMgr]=new Class'R6RainbowOtherTeamVoices2';
		}
		m_RainbowOtherTeamVoicesMgr[iIDVoicesMgr].Init(self);
	}
	return m_RainbowOtherTeamVoicesMgr[iIDVoicesMgr];
}

function Object GetTerroristVoicesMgr (ETerroristNationality eNationality)
{
	if ( m_TerroristVoicesMgr.Length <= eNationality )
	{
		m_TerroristVoicesMgr[eNationality]=None;
	}
	if ( m_TerroristVoicesMgr[eNationality] == None )
	{
		switch (eNationality)
		{
/*			case 0:
			m_TerroristVoicesMgr[eNationality]=new Class'R6TerroristVoicesSpanish1';
			break;
			case 1:
			m_TerroristVoicesMgr[eNationality]=new Class'R6TerroristVoicesSpanish2';
			break;
			case 2:
			m_TerroristVoicesMgr[eNationality]=new Class'R6TerroristVoicesGerman1';
			break;
			case 3:
			m_TerroristVoicesMgr[eNationality]=new Class'R6TerroristVoicesGerman2';
			break;
			case 4:
			m_TerroristVoicesMgr[eNationality]=new Class'R6TerroristVoicesPortuguese';
			break;
			default:*/
		}
		m_TerroristVoicesMgr[eNationality].Init(self);
	}
	return m_TerroristVoicesMgr[eNationality];
}

function Object GetHostageVoicesMgr (EHostageNationality eNationality, bool IsFemale)
{
	if ( IsFemale )
	{
		if ( m_HostageVoicesFemaleMgr.Length <= eNationality )
		{
			m_HostageVoicesFemaleMgr[eNationality]=None;
		}
		if ( m_HostageVoicesFemaleMgr[eNationality] == None )
		{
			switch (eNationality)
			{
/*				case 0:
				m_HostageVoicesFemaleMgr[eNationality]=new Class'R6HostageVoicesFemaleFrench';
				break;
				case 1:
				m_HostageVoicesFemaleMgr[eNationality]=new Class'R6HostageVoicesFemaleBritish';
				break;
				case 2:
				m_HostageVoicesFemaleMgr[eNationality]=new Class'R6HostageVoicesFemaleSpanish';
				break;
				case 4:
				m_HostageVoicesFemaleMgr[eNationality]=new Class'R6HostageVoicesFemaleNorwegian';
				break;
				case 3:
				m_HostageVoicesFemaleMgr[eNationality]=new Class'R6HostageVoicesFemalePortuguese';
				break;
				default:*/
			}
			m_HostageVoicesFemaleMgr[eNationality].Init(self);
		}
		return m_HostageVoicesFemaleMgr[eNationality];
	}
	else
	{
		if ( m_HostageVoicesMaleMgr.Length <= eNationality )
		{
			m_HostageVoicesMaleMgr[eNationality]=None;
		}
		if ( m_HostageVoicesMaleMgr[eNationality] == None )
		{
			switch (eNationality)
			{
/*				case 0:
				m_HostageVoicesMaleMgr[eNationality]=new Class'R6HostageVoicesMaleFrench';
				break;
				case 1:
				m_HostageVoicesMaleMgr[eNationality]=new Class'R6HostageVoicesMaleBritish';
				break;
				case 2:
				m_HostageVoicesMaleMgr[eNationality]=new Class'R6HostageVoicesMaleSpanish';
				break;
				case 4:
				m_HostageVoicesMaleMgr[eNationality]=new Class'R6HostageVoicesMaleNorwegian';
				break;
				case 3:
				m_HostageVoicesMaleMgr[eNationality]=new Class'R6HostageVoicesMalePortuguese';
				break;
				default:*/
			}
			m_HostageVoicesMaleMgr[eNationality].Init(self);
		}
		return m_HostageVoicesMaleMgr[eNationality];
	}
}

function R6TrainingMgr GetTrainingMgr (R6Pawn P)
{
	return None;
}

function R6AbstractNoiseMgr GetNoiseMgr ()
{
	if ( m_noiseMgr == None )
	{
		m_noiseMgr=new Class'R6NoiseMgr';
		m_noiseMgr.Init();
	}
	return m_noiseMgr;
}

function RestartGame ()
{
	local R6PlayerController P;

//	GameReplicationInfo.SetServerState(GameReplicationInfo.4);
	if ( bNoRestart == True )
	{
		return;
	}
	if ( bChangeLevels )
	{
		foreach DynamicActors(Class'R6PlayerController',P)
		{
			P.ClientChangeMap();
		}
	}
	Super.RestartGame();
	Level.ResetLevelInNative();
	DestroyBeacon();
}

function R6GameInfoMakeNoise (ESoundType eType, Actor soundsource)
{
//	GetNoiseMgr().R6MakeNoise(eType,soundsource);
}

function PlayTeleportEffect (bool bOut, bool bSound)
{
}

function InitGameReplicationInfo ()
{
	Super.InitGameReplicationInfo();
	GameReplicationInfo.m_bServerAllowRadar=m_bServerAllowRadarRep;
	GameReplicationInfo.m_bRepAllowRadarOption=m_bRepAllowRadarOption;
	GameReplicationInfo.TimeLimit=Level.m_fTimeLimit;
	GameReplicationInfo.MOTDLine1=m_szMessageOfDay;
	R6GameReplicationInfo(GameReplicationInfo).m_iCurrGameType=m_iCurrGameType;
}

function IncrementRoundsFired (Pawn Instigator, bool ForceIncrement)
{
	local R6RainbowPawn _pawnIterator;
	local PlayerController _playerController;

	if ( Level.NetMode == NM_Standalone )
	{
		R6Pawn(Instigator).IncrementBulletsFired();
	}
	else
	{
		if ( (m_bCompilingStats == True) || (ForceIncrement == True) )
		{
			if ( Instigator.PlayerReplicationInfo != None )
			{
				Instigator.PlayerReplicationInfo.m_iRoundFired++;
			}
			else
			{
				_playerController=R6Pawn(Instigator).GetHumanLeaderForAIPawn();
				if ( _playerController == None )
				{
					return;
				}
				_playerController.PlayerReplicationInfo.m_iRoundFired++;
			}
		}
	}
}

function SetPawnTeamFriendlies (Pawn aPawn)
{
	SetDefaultTeamFriendlies(aPawn);
}

function int GetTeamNumBit (int Num)
{
	return 1 << Num;
}

function SetDefaultTeamFriendlies (Pawn aPawn)
{
	switch (aPawn.m_iTeam)
	{
		case 1:
		if ( aPawn.m_ePawnType != 2 )
		{
			Log("WARNING SetDefaultTeamFriendlies m_ePawnType != PAWN_Terrorist for " $ string(aPawn.Name));
		}
		aPawn.m_iFriendlyTeams=GetTeamNumBit(1);
		aPawn.m_iEnemyTeams=GetTeamNumBit(2);
		aPawn.m_iEnemyTeams += GetTeamNumBit(3);
		break;
		case 0:
		if ( aPawn.m_ePawnType != 3 )
		{
			Log("WARNING SetDefaultTeamFriendlies m_ePawnType != PAWN_Hostage for " $ string(aPawn.Name));
		}
		aPawn.m_iFriendlyTeams=GetTeamNumBit(2);
		aPawn.m_iFriendlyTeams += GetTeamNumBit(3);
		aPawn.m_iEnemyTeams=GetTeamNumBit(1);
		break;
		case 2:
		case 3:
		if ( aPawn.m_ePawnType != 1 )
		{
			Log("WARNING SetDefaultTeamFriendlies m_ePawnType != PAWN_Rainbow for " $ string(aPawn.Name));
		}
		aPawn.m_iFriendlyTeams=GetTeamNumBit(2);
		aPawn.m_iFriendlyTeams += GetTeamNumBit(3);
		aPawn.m_iEnemyTeams=GetTeamNumBit(1);
		break;
		default:
		Log("warning: SetDefaultTeamFriendlies team not supported for " $ string(aPawn.Name) $ " team=" $ string(aPawn.m_iTeam));
		break;
	}
}

function CheckForExtractionZone (R6MissionObjectiveBase Mo)
{
	local int iTotal;
	local R6ExtractionZone aExtractZone;

	iTotal=0;
	foreach AllActors(Class'R6ExtractionZone',aExtractZone)
	{
		iTotal++;
		goto JL0022;
JL0022:
	}
	if ( iTotal == 0 )
	{
		Log("WARNING: there is no R6ExtractionZone to complete this objective: " $ Mo.getDescription());
	}
}

function CheckForTerrorist (R6MissionObjectiveBase Mo, int iMinNum)
{
	local int iTotal;
	local R6Terrorist aTerrorist;

	foreach DynamicActors(Class'R6Terrorist',aTerrorist)
	{
		iTotal++;
	}
	if ( iTotal < iMinNum )
	{
		Log("WARNING: there is no terrorist spawned to complete this objective: " $ Mo.getDescription());
	}
}

function CheckForHostage (R6MissionObjectiveBase Mo, int iMinNum)
{
	local int iTotal;
	local R6Hostage aHostage;

	foreach DynamicActors(Class'R6Hostage',aHostage)
	{
		iTotal++;
	}
	if ( iTotal < iMinNum )
	{
		Log("WARNING: there is not enough (" $ string(iMinNum) $ ") hostage spawned to complete this objective: " $ Mo.getDescription());
	}
}

function InitObjectives ()
{
	local int Index;
	local int iMaxRep;
	local int iRep;
	local int i;
	local GameReplicationInfo G;

	if ( Level.m_bUseDefaultMoralityRules )
	{
		Index=m_missionMgr.m_aMissionObjectives.Length;
		m_missionMgr.m_aMissionObjectives[Index]=new Class'R6MObjAcceptableCivilianLossesByRainbow';
		Index++;
		m_missionMgr.m_aMissionObjectives[Index]=new Class'R6MObjAcceptableCivilianLossesByTerro';
		Index++;
		m_missionMgr.m_aMissionObjectives[Index]=new Class'R6MObjAcceptableHostageLossesByRainbow';
		Index++;
		m_missionMgr.m_aMissionObjectives[Index]=new Class'R6MObjAcceptableHostageLossesByTerro';
		Index++;
		m_missionMgr.m_aMissionObjectives[Index]=new Class'R6MObjAcceptableRainbowLosses';
		Index++;
	}
	m_missionMgr.Init(self);
	G=GameReplicationInfo;
	iRep=0;
	iMaxRep=G.GetRepMObjInfoArraySize();
	i=0;
JL011E:
	if ( i < m_missionMgr.m_aMissionObjectives.Length )
	{
		if ( m_missionMgr.m_aMissionObjectives[i].m_bVisibleInMenu &&  !m_missionMgr.m_aMissionObjectives[i].m_bMoralityObjective )
		{
			if ( i < iMaxRep )
			{
				G.SetRepMObjString(iRep,m_missionMgr.m_aMissionObjectives[i].m_szDescriptionInMenu,Level.GetMissionObjLocFile(m_missionMgr.m_aMissionObjectives[i]));
				iRep++;
			}
			else
			{
				Log("Warning: array of m_aRepMObj is to small for this mission");
			}
		}
		++i;
		goto JL011E;
	}
}

function ResetRepMissionObjectives ()
{
	GameReplicationInfo.ResetRepMObjInfo();
}

function UpdateRepMissionObjectivesStatus ()
{
	GameReplicationInfo.SetRepMObjInProgress(m_missionMgr.m_eMissionObjectiveStatus == 0);
	GameReplicationInfo.SetRepMObjSuccess(m_missionMgr.m_eMissionObjectiveStatus == 1);
}

function UpdateRepMissionObjectives ()
{
	local int i;
	local int iRep;
	local int iMaxRep;

	iRep=0;
	i=0;
JL000E:
	if ( i < m_missionMgr.m_aMissionObjectives.Length )
	{
		if ( m_missionMgr.m_aMissionObjectives[i].m_bVisibleInMenu &&  !m_missionMgr.m_aMissionObjectives[i].m_bMoralityObjective )
		{
			GameReplicationInfo.SetRepMObjInfo(iRep,m_missionMgr.m_aMissionObjectives[i].m_bFailed,m_missionMgr.m_aMissionObjectives[i].m_bCompleted);
			iRep++;
		}
		++i;
		goto JL000E;
	}
}

function bool CheckEndGame (PlayerReplicationInfo Winner, string Reason)
{
	local R6GameOptions pGameOptions;

	m_missionMgr.Update();
	UpdateRepMissionObjectives();
	pGameOptions=Class'Actor'.static.GetGameOptions();
	if ( pGameOptions.UnlimitedPractice )
	{
		if ( IsARainbowAlive() )
		{
			return False;
		}
	}
	return m_missionMgr.m_eMissionObjectiveStatus != 0;
}

function BaseEndGame ()
{
	m_bGameOver=True;
	m_bPlayOutroVideo=Default.m_bPlayOutroVideo;
	SetCompilingStats(False);
	SetRoundRestartedByJoinFlag(True);
	if ( bShowLog )
	{
		Log("***STATE: " $ string(GetStateName()));
	}
	if ( m_missionMgr.m_eMissionObjectiveStatus == 0 )
	{
//		m_missionMgr.SetMissionObjStatus(2);
	}
	GameReplicationInfo.SetRepLastRoundSuccess(m_missionMgr.m_eMissionObjectiveStatus);
	m_fRoundEndTime=Level.TimeSeconds;
}

function EndGame (PlayerReplicationInfo Winner, string Reason)
{
	local R6PlayerController PlayerController;

	if ( m_bGameOver )
	{
		return;
	}
	BaseEndGame();
	Super.EndGame(Winner,Reason);
	if ( bShowLog )
	{
		Log(" ** EndGame");
	}
}

function InitObjectivesOfStoryMode ()
{
	local int i;
	local int Index;

	i=0;
JL0007:
	if ( i < Level.m_aMissionObjectives.Length )
	{
		Level.m_aMissionObjectives[i].Reset();
		if (  !Level.m_aMissionObjectives[i].m_bEndOfListOfObjectives )
		{
			m_missionMgr.m_aMissionObjectives[Index]=Level.m_aMissionObjectives[i];
			++Index;
		}
		++i;
		goto JL0007;
	}
	i=0;
JL00A2:
	if ( i < Level.m_aMissionObjectives.Length )
	{
		if ( Level.m_aMissionObjectives[i].m_bEndOfListOfObjectives )
		{
			m_missionMgr.m_aMissionObjectives[Index]=Level.m_aMissionObjectives[i];
			++Index;
		}
		++i;
		goto JL00A2;
	}
}

function PlayerReadySelected (PlayerController _Controller)
{
	local Controller _aController;
	local int iHumanCount;

	if ( (R6PlayerController(_Controller) == None) || IsInState('InBetweenRoundMenu') )
	{
		return;
	}
	_aController=Level.ControllerList;
JL0033:
	if ( _aController != None )
	{
		if ( (R6PlayerController(_aController) != None) && (R6PlayerController(_aController).m_TeamSelection == 2) )
		{
			iHumanCount++;
		}
		_aController=_aController.nextController;
		goto JL0033;
	}
	if (  !R6PlayerController(_Controller).IsPlayerPassiveSpectator() && (iHumanCount <= 2) )
	{
		ResetRound();
	}
}

function SetJumpingMaps (bool _flagSetting, int iNextMapIndex)
{
	m_bJumpingMaps=True;
	m_iJumpMapIndex=iNextMapIndex;
}

function bool IsLastRoundOfTheMatch ()
{
	if ( m_bJumpingMaps == True )
	{
		return True;
	}
	else
	{
		if ( m_bRotateMap )
		{
			return False;
		}
	}
	return R6GameReplicationInfo(GameReplicationInfo).m_iCurrentRound + 1 >= R6GameReplicationInfo(GameReplicationInfo).m_iRoundsPerMatch;
}

function ProcessChangeLevelSystem ()
{
	if ( Level.NetMode == NM_Standalone )
	{
		bChangeLevels=True;
	}
	else
	{
		if ( m_bRotateMap && (m_bJumpingMaps == False) )
		{
			bChangeLevels=m_missionMgr.m_eMissionObjectiveStatus == 1;
		}
		else
		{
			bChangeLevels=IsLastRoundOfTheMatch();
		}
	}
	R6GameReplicationInfo(GameReplicationInfo).m_iCurrentRound++;
	if ( bChangeLevels )
	{
		R6GameReplicationInfo(GameReplicationInfo).m_iCurrentRound=0;
	}
	if ( bShowLog )
	{
		Log("ProcessChangeLevelSystem bChangeLevels=" $ string(bChangeLevels));
	}
}

function ApplyTeamKillerPenalty (Pawn aPawn)
{
	local R6PlayerController PController;

	PController=R6PlayerController(aPawn.Controller);
	PController.m_bPenaltyBox=False;
	PController.m_bHasAPenalty=False;
	R6Pawn(aPawn).ServerSuicidePawn(2);
}

function Tick (float DeltaTime)
{
	local Controller _playerController;
	local R6PlayerController _R6PlayerController;
	local Controller P;
	local R6PlayerController _iterController;
	local bool m_bLoggedIntoGS;
	local float _fTimeElapsed;
	local R6Console aConsole;

	Super.Tick(DeltaTime);
	if ( m_bGameOver &&  !bChangeLevels )
	{
		if ( Level.NetMode != 0 )
		{
			m_PersistantGameService.HandleAnyLobbyConnectionFail();
		}
		if (  !m_bTimerStarted )
		{
			GameReplicationInfo.m_bGameOverRep=True;
			m_bLoggedIntoGS=(m_GameService.m_eMenuLoginRegServer == 2)/* || NativeStartedByGSClient()*/;
			if ( bShowLog )
			{
				Log("We should be sending ClientNotifySendMatchResults() m_bLoggedIntoGS = " $ string(m_bLoggedIntoGS));
			}
			_fTimeElapsed=Level.TimeSeconds - m_fRoundStartTime;
			_playerController=Level.ControllerList;
JL0113:
			if ( _playerController != None )
			{
				_R6PlayerController=R6PlayerController(_playerController);
				if ( _R6PlayerController != None )
				{
					if (  !m_bEndGameIgnoreGamePlayCheck && m_bLoggedIntoGS && (_R6PlayerController.PlayerReplicationInfo.m_bClientWillSubmitResult == True) &&  !_R6PlayerController.IsPlayerPassiveSpectator() )
					{
						P=Level.ControllerList;
JL0199:
						if ( P != None )
						{
							_iterController=R6PlayerController(P);
							if ( (_iterController != None) && (_iterController.m_TeamSelection != 4) && (_iterController.PlayerReplicationInfo.m_bClientWillSubmitResult == True) )
							{
								if ( _iterController.PlayerReplicationInfo.Deaths > _iterController.PlayerReplicationInfo.m_iBackUpDeaths )
								{
									_R6PlayerController.ClientUpdateLadderStat(_iterController.PlayerReplicationInfo.m_szUbiUserID,_iterController.PlayerReplicationInfo.m_iRoundKillCount,1,_fTimeElapsed);
								}
								else
								{
									_R6PlayerController.ClientUpdateLadderStat(_iterController.PlayerReplicationInfo.m_szUbiUserID,_iterController.PlayerReplicationInfo.m_iRoundKillCount,0,_fTimeElapsed);
								}
							}
							P=P.nextController;
							goto JL0199;
						}
						_R6PlayerController.ClientNotifySendMatchResults();
					}
					if ( (_R6PlayerController.Pawn != None) && (_R6PlayerController.Pawn.EngineWeapon != None) )
					{
						if ( _R6PlayerController.Pawn.m_bIsFiringWeapon != 0 )
						{
							_R6PlayerController.Pawn.EngineWeapon.ServerStopFire();
						}
					}
				}
				_playerController=_playerController.nextController;
				goto JL0113;
			}
			m_bTimerStarted=True;
			m_fTimerStartTime=Level.TimeSeconds;
		}
		if (  !m_bFadeStarted && (Level.TimeSeconds - m_fTimerStartTime > GetEndGamePauseTime() - 2.00) )
		{
			m_bFadeStarted=True;
			if ( Level.NetMode == NM_Standalone )
			{
				_R6PlayerController=R6PlayerController(m_Player);
				R6AbstractHUD(m_Player.myHUD).StartFadeToBlack(2,100);
//				_R6PlayerController.ClientFadeCommonSound(2.00,0);
//				_R6PlayerController.ClientFadeSound(2.00,0,5);
//				_R6PlayerController.ClientFadeSound(2.00,0,7);
			}
			else
			{
				_playerController=Level.ControllerList;
JL0466:
				if ( _playerController != None )
				{
					_R6PlayerController=R6PlayerController(_playerController);
					if ( _R6PlayerController != None )
					{
//						_R6PlayerController.ClientFadeCommonSound(2.00,0);
//						_R6PlayerController.ClientFadeSound(2.00,0,5);
//						_R6PlayerController.ClientFadeSound(2.00,0,7);
					}
					_playerController=_playerController.nextController;
					goto JL0466;
				}
			}
		}
		if ( Level.TimeSeconds - m_fTimerStartTime > GetEndGamePauseTime() )
		{
			if ( Level.NetMode != 0 )
			{
				_playerController=Level.ControllerList;
JL0535:
				if ( _playerController != None )
				{
					_R6PlayerController=R6PlayerController(_playerController);
					if ( _R6PlayerController != None )
					{
						if (  !m_bEndGameIgnoreGamePlayCheck && m_bLoggedIntoGS &&  !_R6PlayerController.m_bEndOfRoundDataReceived )
						{
							return;
						}
					}
					_playerController=_playerController.nextController;
					goto JL0535;
				}
				if ( bShowLog )
				{
					if (  !m_bEndGameIgnoreGamePlayCheck && m_bLoggedIntoGS )
					{
						Log("Received ServerEndOfRoundDataSent from all clients");
					}
				}
			}
			m_fTimerStartTime=2147483647;
			if ( Level.NetMode == NM_Standalone )
			{
				StopAllSounds();
				ResetBroadcastGameMsg();
				if ( IsA('R6TrainingMgr') )
				{
					aConsole=R6Console(Class'Actor'.static.GetCanvas().Viewport.Console);
//					aConsole.LeaveR6Game(aConsole.2);
				}
				else
				{
//					WindowConsole(m_Player.Player.Console).Root.ChangeCurrentWidget(m_eEndGameWidgetID);
				}
			}
			else
			{
				if ( m_bInternetSvr && (NativeStartedByGSClient() || m_GameService.NativeGetServerRegistered()) && m_bLadderStats )
				{
					m_bLadderStats=False;
//					m_PersistantGameService.5();
				}
				RestartGameMgr();
			}
		}
	}
}

function int SearchOperativesArray (bool bIsFemale, int iStartIndex)
{
	local int i;

	if ( iStartIndex < 0 )
	{
		iStartIndex=0;
	}
	i=iStartIndex;
JL001D:
	if ( i < 30 )
	{
		if ( bIsFemale )
		{
			if ( m_bRainbowFaces[i] > 0 )
			{
				return i;
			}
		}
		else
		{
			if ( m_bRainbowFaces[i] == 0 )
			{
				return i;
			}
		}
		i++;
		goto JL001D;
	}
	return -1;
}

function int MPSelectOperativeFace (bool bIsFemale)
{
	local int iOperativeID;

	iOperativeID=-1;
	if ( bIsFemale )
	{
		iOperativeID=SearchOperativesArray(bIsFemale,m_bCurrentFemaleId);
		if ( iOperativeID == -1 )
		{
			m_bCurrentFemaleId=0;
			iOperativeID=SearchOperativesArray(bIsFemale,m_bCurrentFemaleId);
		}
		m_bCurrentFemaleId=iOperativeID + 1;
		if ( m_bCurrentFemaleId >= 30 )
		{
			m_bCurrentFemaleId=0;
		}
	}
	else
	{
		iOperativeID=SearchOperativesArray(bIsFemale,m_bCurrentMaleId);
		if ( iOperativeID == -1 )
		{
			m_bCurrentMaleId=0;
			iOperativeID=SearchOperativesArray(bIsFemale,m_bCurrentMaleId);
		}
		m_bCurrentMaleId=iOperativeID + 1;
		if ( m_bCurrentMaleId >= 30 )
		{
			m_bCurrentMaleId=0;
		}
	}
	return iOperativeID;
}

function ResetMatchStat ()
{
	local PlayerReplicationInfo PRI;

	foreach DynamicActors(Class'PlayerReplicationInfo',PRI)
	{
		PRI.m_iKillCount=0;
		PRI.m_iRoundFired=0;
		PRI.m_iRoundsHit=0;
		PRI.m_iRoundsPlayed=0;
		PRI.m_iRoundsWon=0;
		PRI.Deaths=0.00;
		PRI.m_szKillersName="";
		PRI.m_bJoinedTeamLate=False;
	}
}

function AdminResetRound ()
{
	local PlayerReplicationInfo _PRI;

	foreach AllActors(Class'PlayerReplicationInfo',_PRI)
	{
		_PRI.AdminResetRound();
	}
}

simulated function ResetOriginalData ()
{
	if ( m_bResetSystemLog )
	{
		LogResetSystem(False);
	}
	Super.ResetOriginalData();
	m_bGameStarted=False;
	bGameEnded=False;
	bOverTime=False;
	bWaitingToStartMatch=True;
	m_bGameOver=False;
	m_bTimerStarted=False;
	m_fEndingTime=0.00;
	m_bFadeStarted=False;
	m_bEndGameIgnoreGamePlayCheck=False;
	m_pCurPlayerCtrlMdfSrvInfo=None;
	SetUnlimitedPractice(False,False);
}

function SetPlayerInPenaltyBox ()
{
	local R6PlayerController PlayerController;

	foreach DynamicActors(Class'R6PlayerController',PlayerController)
	{
		PlayerController.m_bPenaltyBox=False;
		if ( PlayerController.m_bHasAPenalty )
		{
			PlayerController.m_bPenaltyBox=True;
			if ( (PlayerController.m_pawn != None) && PlayerController.m_pawn.InGodMode() )
			{
				PlayerController.m_bPenaltyBox=False;
			}
			PlayerController.m_bHasAPenalty=False;
		}
	}
}

function ResetPlayerBlur ()
{
	local R6PlayerController PlayerController;

	foreach DynamicActors(Class'R6PlayerController',PlayerController)
	{
		PlayerController.ResetBlur();
	}
}

function ResetPenalty ()
{
	local R6PlayerController PlayerController;

	foreach DynamicActors(Class'R6PlayerController',PlayerController)
	{
		PlayerController.m_bPenaltyBox=False;
		PlayerController.m_bHasAPenalty=False;
	}
}

function RestartGameMgr ()
{
	local R6MapList myList;
	local bool bChangeLevelAllowed;
	local PlayerController _playerController;
	local R6ServerInfo pServerOptions;

	pServerOptions=Class'Actor'.static.GetServerOptions();
	ResetBroadcastGameMsg();
	ProcessChangeLevelSystem();
	SetPlayerInPenaltyBox();
	ResetPlayerBlur();
	if ( bChangeLevels )
	{
		bChangeLevelAllowed=True;
		GameReplicationInfo.SetRepLastRoundSuccess(0);
		ResetPenalty();
		if ( Level.NetMode == NM_Standalone )
		{
			bChangeLevelAllowed=False;
		}
		if ( bChangeLevelAllowed )
		{
			myList=pServerOptions.m_ServerMapList;
			if ( (m_bJumpingMaps == True) || (m_bChangedServerConfig == True) )
			{
				if ( (m_bChangedServerConfig == False) && (myList.CheckNextMapIndex(m_iJumpMapIndex) == myList.CheckCurrentMap()) && (myList.CheckNextGameTypeIndex(m_iJumpMapIndex) == myList.CheckCurrentGameType()) )
				{
					if ( bShowLog )
					{
						Log("RESET: it's the same map and the same game type ");
					}
					bChangeLevelAllowed=False;
				}
				if ( m_bChangedServerConfig == True )
				{
					BroadcastGameMsg("","","ServerOption");
					myList.GetNextMap(1);
				}
				else
				{
					myList.GetNextMap(m_iJumpMapIndex);
				}
				m_bJumpingMaps=False;
				m_iJumpMapIndex=0;
			}
			else
			{
				if ( (myList.CheckNextMap() == myList.CheckCurrentMap()) && (myList.CheckNextGameType() == myList.CheckCurrentGameType()) )
				{
					if ( bShowLog )
					{
						Log("RESET: it's the same map and the same game type ");
					}
					bChangeLevelAllowed=False;
//					myList.GetNextMap(myList.-2);
				}
			}
		}
		else
		{
			if ( bShowLog )
			{
				Log("RESET: game type does not allow changing level");
			}
			bChangeLevelAllowed=False;
		}
		if ( bChangeLevelAllowed )
		{
			if ( bShowLog )
			{
				Log("RESET: changing level!");
			}
			RestartGame();
			ResetMatchStat();
			m_bChangedServerConfig=False;
			return;
		}
		else
		{
			foreach DynamicActors(Class'PlayerController',_playerController)
			{
				_playerController.PlayerReplicationInfo.m_iRoundsPlayed=0;
				_playerController.PlayerReplicationInfo.m_iRoundsWon=0;
				_playerController.PlayerReplicationInfo.Deaths=0.00;
			}
			bChangeLevels=False;
		}
		ResetMatchStat();
	}
	ResetRound();
}

function ResetRound ()
{
	ResetOriginalData();
	m_iNbOfRestart++;
	Level.ResetLevel(m_iNbOfRestart);
	if ( Level.NetMode == NM_Standalone )
	{
		GotoState('None');
	}
	else
	{
		GotoState('InBetweenRoundMenu');
	}
}

function SpawnAI ()
{
	local R6DeploymentZone PZone;
	local R6Terrorist pTerrorist;

	if ( bShowLog )
	{
		Log("SpawnAI: load terrorsit/hostage/civilian");
	}
	foreach AllActors(Class'R6DeploymentZone',PZone)
	{
		PZone.InitZone();
	}
	foreach DynamicActors(Class'R6Terrorist',pTerrorist)
	{
		m_listAllTerrorists[m_listAllTerrorists.Length]=pTerrorist;
	}
}

function SetGameTypeInLocal ()
{
	local R6PlayerController PController;
	local Controller P;
	local Actor anActor;

	if ( Level.NetMode == NM_DedicatedServer )
	{
		return;
	}
	P=Level.ControllerList;
JL002F:
	if ( P != None )
	{
		PController=R6PlayerController(P);
		if ( PController != None )
		{
			if ( Level.NetMode == NM_Standalone )
			{
				goto JL00AB;
			}
			if ( Viewport(PController.Player) != None )
			{
				goto JL00AB;
			}
		}
		PController=None;
		P=P.nextController;
		goto JL002F;
	}
JL00AB:
	if ( PController != None )
	{
		PController.GameReplicationInfo.m_eGameTypeFlag=m_eGameTypeFlag;
		PController.GameReplicationInfo.m_bReceivedGameType=1;
	}
}

function SpawnAIandInitGoInGame ()
{
	local R6MissionObjectiveMgr aMgr;
	local R6IORotatingDoor Door;

	if ( bShowLog )
	{
		Log("SpawnAIandInitGoInGame");
	}
	SpawnAI();
	aMgr=m_missionMgr;
	m_missionMgr=None;
	if ( aMgr != None )
	{
		aMgr.Destroy();
	}
	if ( GameReplicationInfo != None )
	{
		GameReplicationInfo.ResetRepMObjInfo();
	}
	CreateMissionObjectiveMgr();
	m_missionMgr.m_bEnableCheckForErrors=True;
	InitObjectives();
	if ( m_bUnlockAllDoors )
	{
		foreach AllActors(Class'R6IORotatingDoor',Door)
		{
			Door.UnlockDoor();
		}
	}
	if ( Level.NetMode == NM_Standalone )
	{
		m_fRoundStartTime=Level.TimeSeconds;
		SetGameTypeInLocal();
	}
}

function SetTeamKillerPenalty (Pawn DeadPawn, Pawn KillerPawn)
{
	local R6PlayerController pControllerDead;
	local R6PlayerController pControllerKiller;

	if ( Level.IsGameTypeCooperative(m_eGameTypeFlag) )
	{
		return;
	}
	pControllerKiller=R6PlayerController(R6Pawn(KillerPawn).Controller);
	if ( (pControllerKiller == None) ||  !Level.IsGameTypeMultiplayer(m_eGameTypeFlag) )
	{
		return;
	}
	pControllerDead=R6PlayerController(R6Pawn(DeadPawn).Controller);
	if ( (DeadPawn.m_ePawnType == 3) && (KillerPawn != DeadPawn) )
	{
		pControllerKiller.m_ePenaltyForKillingAPawn=DeadPawn.m_ePawnType;
		pControllerKiller.m_bHasAPenalty=True;
	}
	else
	{
		if ( m_bTKPenalty && KillerPawn.IsFriend(DeadPawn) && (KillerPawn != DeadPawn) &&  !pControllerDead.m_bAlreadyPoppedTKPopUpBox )
		{
			pControllerDead.m_TeamKiller=pControllerKiller;
			pControllerDead.TKPopUpBox(pControllerKiller.PlayerReplicationInfo.PlayerName);
			pControllerDead.m_bAlreadyPoppedTKPopUpBox=True;
			pControllerKiller.m_ePenaltyForKillingAPawn=DeadPawn.m_ePawnType;
		}
	}
}

function bool ProcessPlayerReadyStatus ()
{
	local R6PlayerController _playerController;
	local Controller P;
	local int _iCount;

	P=Level.ControllerList;
JL0014:
	if ( P != None )
	{
		_playerController=R6PlayerController(P);
		if ( (_playerController != None) &&  !_playerController.IsPlayerPassiveSpectator() )
		{
			_iCount++;
			if ( _playerController.PlayerReplicationInfo.m_bPlayerReady == False )
			{
				return False;
			}
		}
		P=P.nextController;
		goto JL0014;
	}
	return _iCount > 0;
}

function BroadcastGameTypeDescription ()
{
	local Controller P;
	local R6PlayerController PlayerController;

	P=Level.ControllerList;
JL0014:
	if ( P != None )
	{
		if ( P.IsA('PlayerController') )
		{
			PlayerController=R6PlayerController(P);
			if (  !PlayerController.bOnlySpectator &&  !PlayerController.IsPlayerPassiveSpectator() )
			{
				PlayerController.ClientGameTypeDescription(m_eGameTypeFlag);
			}
		}
		P=P.nextController;
		goto JL0014;
	}
}

function BroadcastGameMsg (string szLocFile, string szPreMsg, string szMsgID, optional Sound sndGameStatus, optional int iLifeTime)
{
	local Controller P;
	local R6PlayerController PlayerController;

	P=Level.ControllerList;
JL0014:
	if ( P != None )
	{
		if ( P.IsA('PlayerController') )
		{
			PlayerController=R6PlayerController(P);
			PlayerController.ClientGameMsg(szLocFile,szPreMsg,szMsgID,sndGameStatus,iLifeTime);
		}
		P=P.nextController;
		goto JL0014;
	}
}

function BroadcastMissionObjMsg (string szLocFile, string szPreMsg, string szMsgID, optional Sound sndGameStatus, optional int iLifeTime)
{
	local Controller P;
	local R6PlayerController PlayerController;

	P=Level.ControllerList;
JL0014:
	if ( P != None )
	{
		if ( P.IsA('PlayerController') )
		{
			PlayerController=R6PlayerController(P);
			PlayerController.ClientMissionObjMsg(szLocFile,szPreMsg,szMsgID,sndGameStatus,iLifeTime);
		}
		P=P.nextController;
		goto JL0014;
	}
}

function ResetBroadcastGameMsg ()
{
	local Controller P;
	local R6PlayerController PlayerController;

	P=Level.ControllerList;
JL0014:
	if ( P != None )
	{
		if ( P.IsA('PlayerController') )
		{
			PlayerController=R6PlayerController(P);
			PlayerController.ClientResetGameMsg();
		}
		P=P.nextController;
		goto JL0014;
	}
}

function PawnKilled (Pawn Killed)
{
	local R6Hostage hostage;

	RemoveTerroFromList(Killed);
	if ( m_bFeedbackHostageKilled )
	{
		hostage=R6Hostage(Killed);
		if ( hostage != None )
		{
			if ( hostage.m_bPoliceManMp1 )
			{
				BroadcastMissionObjMsg("","","PolicemanHasDied");
			}
			else
			{
				if ( hostage.m_bCivilian )
				{
					BroadcastMissionObjMsg("","","CivilianHasDied");
				}
				else
				{
					BroadcastMissionObjMsg("","","HostageHasDied");
				}
			}
		}
	}
	Super.PawnKilled(Killed);
}

function RemoveTerroFromList (Pawn toRemove)
{
	local int i;
	local R6Terrorist aTerrorist;

	aTerrorist=R6Terrorist(toRemove);
	if ( aTerrorist != None )
	{
		i=0;
JL0022:
		if ( i < m_listAllTerrorists.Length )
		{
			if ( m_listAllTerrorists[i] == aTerrorist )
			{
				m_listAllTerrorists.Remove (i,1);
			}
			else
			{
				i++;
				goto JL0022;
			}
		}
		if ( m_listAllTerrorists.Length == 1 )
		{
			m_listAllTerrorists[0].StartHunting();
		}
	}
}

function bool IsUnlimitedPractice ()
{
	local R6GameOptions pGameOptions;

	pGameOptions=Class'Actor'.static.GetGameOptions();
	return pGameOptions.UnlimitedPractice;
}

exec function SetUnlimitedPractice (bool bUnlimitedPractice, bool bInGameProcess)
{
	local R6GameOptions pGameOptions;

	if ( Level.NetMode != 0 )
	{
		return;
	}
	pGameOptions=Class'Actor'.static.GetGameOptions();
	pGameOptions.UnlimitedPractice=bUnlimitedPractice;
	if ( bInGameProcess )
	{
		if (  !pGameOptions.UnlimitedPractice )
		{
			if ( CheckEndGame(None,"") )
			{
				EndGame(None,"");
			}
		}
		if ( pGameOptions.UnlimitedPractice )
		{
			BroadcastGameMsg("","","UnlimitedPracticeTRUE");
		}
		else
		{
			BroadcastGameMsg("","","UnlimitedPracticeFALSE");
		}
	}
}

function DestroyBeacon ()
{
	local UdpBeacon aBeacon;

	foreach AllActors(Class'UdpBeacon',aBeacon)
	{
		aBeacon.Destroy();
	}
}

function AbortScoreSubmission ()
{
	if ( m_bLadderStats )
	{
		m_bLadderStats=False;
//		m_PersistantGameService.5();
	}
}

function EnteredExtractionZone (Actor Other)
{
	local R6Hostage hostage;

	if ( m_bGameOver )
	{
		return;
	}
	if ( m_bFeedbackHostageExtracted )
	{
		hostage=R6Hostage(Other);
		if ( (hostage != None) && hostage.IsAlive() && hostage.m_bExtracted &&  !hostage.m_bFeedbackExtracted &&  !hostage.m_bPoliceManMp1 &&  !hostage.m_bCivilian )
		{
			BroadcastMissionObjMsg("","","HostageHasBeenRescued");
			hostage.m_bFeedbackExtracted=True;
		}
	}
	Super.EnteredExtractionZone(Other);
}

event bool CanPlayIntroVideo ()
{
	if ( m_bPlayIntroVideo )
	{
		m_bPlayIntroVideo=False;
		return True;
	}
	return False;
}

event bool CanPlayOutroVideo ()
{
	if (  !m_bPlayOutroVideo || (m_missionMgr == None) )
	{
		return False;
	}
	if ( m_missionMgr.m_eMissionObjectiveStatus == 1 )
	{
		m_bPlayOutroVideo=False;
		return True;
	}
	return False;
}

function int GetNbTerroNeutralized ()
{
	local R6Terrorist aTerrorist;
	local int iTerroNeutralized;

	foreach DynamicActors(Class'R6Terrorist',aTerrorist)
	{
		if (  !aTerrorist.IsAlive() || aTerrorist.m_bIsKneeling || aTerrorist.m_bIsUnderArrest )
		{
			iTerroNeutralized += 1;
		}
	}
	return iTerroNeutralized;
}

function ChangeName (Controller Other, coerce string S, bool bNameChange, optional bool bDontBroadcastNameChange)
{
	local R6Rainbow aRainbow;
	local R6Pawn pOther;
	local string szPreviousName;
	local R6PlayerController P;

	szPreviousName=Other.PlayerReplicationInfo.PlayerName;
	Super.ChangeName(Other,S,bNameChange,bDontBroadcastNameChange);
	if ( Other.PlayerReplicationInfo.PlayerName == szPreviousName )
	{
		return;
	}
	if ( bDontBroadcastNameChange == False )
	{
		foreach DynamicActors(Class'R6PlayerController',P)
		{
			P.ClientMPMiscMessage("IsNowKnownAs",szPreviousName,Other.PlayerReplicationInfo.PlayerName);
		}
	}
}

defaultproperties
{
    m_eEndGameWidgetID=2
    m_bRainbowFaces(7)=1
    m_bRainbowFaces(11)=1
    m_bRainbowFaces(23)=1
    m_bRainbowFaces(24)=1
    m_bRainbowFaces(27)=1
    m_bRainbowFaces(28)=1
    m_iCurrentID=1
    m_iMaxOperatives=8
    m_bIsRadarAllowed=True
    m_bIsWritableMapAllowed=True
    m_bFeedbackHostageKilled=True
    m_bFeedbackHostageExtracted=True
    DefaultFaceCoords=(X=0.00,Y=6.30073054337439142E34,Z=0.00,W=0.00)
    m_fTimeBetRounds=5.00
    m_eGameTypeFlag=RGM_NoRulesMode
    CurrentID=100
    GameReplicationInfoClass=Class'R6Engine.R6GameReplicationInfo'
    DefaultPlayerClassName="R6Game.R6PlanningPawn"
    HUDType="R6Game.R6PlanningHud"
    GameName="Rainbow6"
    PlayerControllerClassName="R6Game.R6PlanningCtrl"
}
/*
    DefaultFaceTexture=Texture'R6MenuOperative.RS6_Memeber_01'
*/

