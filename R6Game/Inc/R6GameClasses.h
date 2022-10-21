/*===========================================================================
    C++ class definitions exported from UnrealScript.
    This is automatically generated by the tools.
    DO NOT modify this manually! Edit the corresponding .uc files instead!
===========================================================================*/
#if SUPPORTS_PRAGMA_PACK
#pragma pack (push,4)
#endif

#ifndef R6GAME_API
#define R6GAME_API DLL_IMPORT
#endif

#ifndef NAMES_ONLY
#define AUTOGENERATE_NAME(name) extern R6GAME_API FName R6GAME_##name;
#define AUTOGENERATE_FUNCTION(cls,idx,name)
#endif


#ifndef NAMES_ONLY

enum eGameWidgetID
{
    WidgetID_None           =0,
    InGameID_EscMenu        =1,
    InGameID_Debriefing     =2,
    InGameID_TrainingInstruction=3,
    TrainingWidgetID        =4,
    SinglePlayerWidgetID    =5,
    CampaignPlanningID      =6,
    MainMenuWidgetID        =7,
    IntelWidgetID           =8,
    PlanningWidgetID        =9,
    RetryCampaignPlanningID =10,
    RetryCustomMissionPlanningID=11,
    GearRoomWidgetID        =12,
    ExecuteWidgetID         =13,
    CustomMissionWidgetID   =14,
    MultiPlayerWidgetID     =15,
    OptionsWidgetID         =16,
    PreviousWidgetID        =17,
    CreditsWidgetID         =18,
    MPCreateGameWidgetID    =19,
    UbiComWidgetID          =20,
    NonUbiWidgetID          =21,
    InGameMPWID_Writable    =22,
    InGameMPWID_TeamJoin    =23,
    InGameMPWID_Intermission=24,
    InGameMPWID_InterEndRound=25,
    InGameMPWID_EscMenu     =26,
    InGameMpWID_RecMessages =27,
    InGameMpWID_MsgOffensive=28,
    InGameMpWID_MsgDefensive=29,
    InGameMpWID_MsgReply    =30,
    InGameMpWID_MsgStatus   =31,
    InGameMPWID_Vote        =32,
    InGameMPWID_CountDown   =33,
    InGameID_OperativeSelector=34,
    MultiPlayerError        =35,
    MultiPlayerErrorUbiCom  =36,
    MenuQuitID              =37,
    WidgetID_MAX            =38,
};
#define UCONST_CMaxRainbowAI 6
#define UCONST_CMaxPlayers 16

class R6GAME_API AR6GameInfo : public AR6AbstractGameInfo
{
public:
    BYTE R6DefaultWeaponInput;
    BYTE m_eEndGameWidgetID;
    BYTE m_bCurrentFemaleId;
    BYTE m_bCurrentMaleId;
    BYTE m_bRainbowFaces[30];
    INT m_iCurrentID;
    INT m_iMaxOperatives;
    INT m_iJumpMapIndex;
    INT m_iRoundsPerMatch;
    INT m_iDeathCameraMode;
    INT m_iSubMachineGunsResMask;
    INT m_iShotGunResMask;
    INT m_iAssRifleResMask;
    INT m_iMachGunResMask;
    INT m_iSnipRifleResMask;
    INT m_iPistolResMask;
    INT m_iMachPistolResMask;
    INT m_iGadgPrimaryResMask;
    INT m_iGadgSecondaryResMask;
    INT m_iGadgMiscResMask;
    INT m_iNbOfRestart;
    INT m_iIDVoicesMgr;
    BITFIELD bShowLog:1 GCC_PACK(4);
    BITFIELD bNoRestart:1;
    BITFIELD m_bServerAllowRadarRep:1;
    BITFIELD m_bRepAllowRadarOption:1;
    BITFIELD m_bIsRadarAllowed:1;
    BITFIELD m_bIsWritableMapAllowed:1;
    BITFIELD m_bUsingPlayerCampaign:1;
    BITFIELD m_bUsingCampaignBriefing:1;
    BITFIELD m_bUnlockAllDoors:1;
    BITFIELD m_bJumpingMaps:1;
    BITFIELD m_bAutoBalance:1;
    BITFIELD m_bTKPenalty:1;
    BITFIELD m_bPWSubMachGunRes:1;
    BITFIELD m_bPWShotGunRes:1;
    BITFIELD m_bPWAssRifleRes:1;
    BITFIELD m_bPWMachGunRes:1;
    BITFIELD m_bPWSnipRifleRes:1;
    BITFIELD m_bSWPistolRes:1;
    BITFIELD m_bSWMachPistolRes:1;
    BITFIELD m_bGadgPrimaryRes:1;
    BITFIELD m_bGadgSecondayRes:1;
    BITFIELD m_bGadgMiscRes:1;
    BITFIELD m_bShowNames:1;
    BITFIELD m_bFFPWeapon:1;
    BITFIELD m_bAdminPasswordReq:1;
    BITFIELD m_bAIBkp:1;
    BITFIELD m_bRotateMap:1;
    BITFIELD m_bFadeStarted:1;
    BITFIELD m_bPunkBuster:1;
    BITFIELD m_bFeedbackHostageKilled:1;
    BITFIELD m_bFeedbackHostageExtracted:1;
    FLOAT m_fRoundStartTime GCC_PACK(4);
    FLOAT m_fRoundEndTime;
    FLOAT m_fPausedAtTime;
    FLOAT m_fBombTime;
    class UR6CommonRainbowVoices* m_CommonRainbowPlayerVoicesMgr;
    class UR6CommonRainbowVoices* m_CommonRainbowMemberVoicesMgr;
    class UR6RainbowPlayerVoices* m_RainbowPlayerVoicesMgr;
    class UR6RainbowMemberVoices* m_RainbowMemberVoicesMgr;
    class UR6MultiCoopVoices* m_MultiCoopMemberVoicesMgr;
    class UR6PreRecordedMsgVoices* m_PreRecordedMsgVoicesMgr;
    class UR6MultiCommonVoices* m_MultiCommonVoicesMgr;
    class ANavigationPoint* LastStartSpot;
    class UR6GSServers* m_GameService;
    class UR6GSServers* m_PersistantGameService;
    class UMaterial* DefaultFaceTexture;
    TArrayNoInit<class UR6RainbowOtherTeamVoices*> m_RainbowOtherTeamVoicesMgr;
    TArrayNoInit<class UR6MultiCoopVoices*> m_MultiCoopPlayerVoicesMgr;
    TArrayNoInit<class UR6TerroristVoices*> m_TerroristVoicesMgr;
    TArrayNoInit<class UR6HostageVoices*> m_HostageVoicesMaleMgr;
    TArrayNoInit<class UR6HostageVoices*> m_HostageVoicesFemaleMgr;
    TArrayNoInit<class AR6Terrorist*> m_listAllTerrorists;
    TArrayNoInit<class AR6RainbowAI*> m_RainbowAIBackup;
    TArrayNoInit<FString> m_mapList;
    TArrayNoInit<FString> m_gameModeList;
    FPlane DefaultFaceCoords;
    FStringNoInit m_szMessageOfDay;
    FStringNoInit m_szSvrName;
    DECLARE_FUNCTION(execGetSystemUserName);
    DECLARE_FUNCTION(execSetController);
    DECLARE_CLASS(AR6GameInfo,AR6AbstractGameInfo,0|CLASS_Config,R6Game)
    NO_DEFAULT_CONSTRUCTOR(AR6GameInfo)
};

#define UCONST_K_KickVoteTime 90
#define UCONST_K_UpdateUbiDotCom 30.0
#define UCONST_K_RefreshCheckPlayerReadyFreq 1
#define UCONST_K_InGamePauseTime 5

class R6GAME_API AR6MultiPlayerGameInfo : public AR6GameInfo
{
public:
    INT m_iUbiComGameMode;
    BITFIELD m_bMSCLientActive:1 GCC_PACK(4);
    BITFIELD m_bDoLadderInit:1;
    BITFIELD m_TeamSelectionLocked:1;
    FLOAT m_fNextCheckPlayerReadyTime GCC_PACK(4);
    FLOAT m_fLastUpdateTime;
    FLOAT m_fInGameStartTime;
    class UR6MObjTimer* m_missionObjTimer;
    class USound* m_sndSoundTimeFailure;
    DECLARE_CLASS(AR6MultiPlayerGameInfo,AR6GameInfo,0|CLASS_Config,R6Game)
    NO_DEFAULT_CONSTRUCTOR(AR6MultiPlayerGameInfo)
};


class R6GAME_API AR6SoundVolume : public AVolume
{
public:
    BYTE m_eSoundSlot;
    TArrayNoInit<class USound*> m_EntrySound;
    TArrayNoInit<class USound*> m_ExitSound;
    DECLARE_CLASS(AR6SoundVolume,AVolume,0,R6Game)
    NO_DEFAULT_CONSTRUCTOR(AR6SoundVolume)
};


class R6GAME_API AR6WaterVolume : public AR6SoundVolume
{
public:
    DECLARE_CLASS(AR6WaterVolume,AR6SoundVolume,0,R6Game)
    NO_DEFAULT_CONSTRUCTOR(AR6WaterVolume)
};

#define UCONST_TimeBetweenStep 15

class R6GAME_API AR6InstructionSoundVolume : public AR6SoundVolume
{
public:
    INT m_iBoxNumber;
    INT m_iSoundIndex;
    INT m_iHudStep;
    INT m_IDHudStep;
    INT m_fTimerStep;
    BITFIELD m_bSoundIsPlaying:1 GCC_PACK(4);
    FLOAT m_fTime GCC_PACK(4);
    FLOAT m_fTimerSound;
    FLOAT m_fTimeHud;
    class USound* m_sndIntructionSoundStop;
    class AR6TrainingMgr* m_TrainingMgr;
    DECLARE_FUNCTION(execUseSound);
    DECLARE_CLASS(AR6InstructionSoundVolume,AR6SoundVolume,0,R6Game)
    NO_DEFAULT_CONSTRUCTOR(AR6InstructionSoundVolume)
};

#define UCONST_R6InputKey_ActionPopup 1024
#define UCONST_R6InputKey_PathFlagPopup 1026

class R6GAME_API AR6PlanningCtrl : public APlayerController
{
public:
    INT m_iCurrentTeam;
    INT m_3DWindowPositionX;
    INT m_3DWindowPositionY;
    INT m_3DWindowPositionW;
    INT m_3DWindowPositionH;
    INT m_iLevelDisplay;
    BITFIELD m_bRender3DView:1 GCC_PACK(4);
    BITFIELD m_bMove3DView:1;
    BITFIELD m_bActionPointSelected:1;
    BITFIELD m_bCanMoveFirstPoint:1;
    BITFIELD m_bClickToFindLocation:1;
    BITFIELD m_bClickedOnRange:1;
    BITFIELD m_bSetSnipeDirection:1;
    BITFIELD m_bPlayMode:1;
    BITFIELD m_bLockCamera:1;
    BITFIELD bShowLog:1;
    BITFIELD m_bFirstTick:1;
    FLOAT m_fLastMouseX GCC_PACK(4);
    FLOAT m_fLastMouseY;
    FLOAT m_fZoom;
    FLOAT m_fZoomDelta;
    FLOAT m_fZoomRate;
    FLOAT m_fZoomMin;
    FLOAT m_fZoomMax;
    FLOAT m_fZoomFactor;
    FLOAT m_fCameraAngle;
    FLOAT m_fAngleRate;
    FLOAT m_fAngleMax;
    FLOAT m_fRotateDelta;
    FLOAT m_fRotateRate;
    FLOAT m_fCamRate;
    FLOAT m_fCastingHeight;
    FLOAT m_fDebugRangeScale;
    class UR6PlanningInfo* m_pTeamInfo[3];
    class UR6FileManagerPlanning* m_pFileManager;
    class AR6CameraDirection* m_pCameraDirIcon;
    class AActor* m_pOldHitActor;
    class UTexture* m_pIconTex[12];
    class AActor* m_CamSpot;
    class USound* m_PlanningBadClickSnd;
    class USound* m_PlanningGoodClickSnd;
    class USound* m_PlanningRemoveSnd;
    FVector m_vCurrentCameraPos;
    FVector m_vCamPos;
    FVector m_vCamPosNoRot;
    FVector m_vCamDesiredPos;
    FRotator m_rCamRot;
    FVector m_vCamDelta;
    FVector m_vMinLocation;
    FVector m_vMaxLocation;
    DECLARE_FUNCTION(execPlanningTrace);
    DECLARE_FUNCTION(execGetXYPoint);
    DECLARE_FUNCTION(execGetClickResult);
    DECLARE_CLASS(AR6PlanningCtrl,APlayerController,0|CLASS_Config,R6Game)
    NO_DEFAULT_CONSTRUCTOR(AR6PlanningCtrl)
};

enum eTeamState
{
    TS_None                 =0,
    TS_Waiting              =1,
    TS_Holding              =2,
    TS_Moving               =3,
    TS_Following            =4,
    TS_Regrouping           =5,
    TS_Engaging             =6,
    TS_Sniping              =7,
    TS_LockPicking          =8,
    TS_OpeningDoor          =9,
    TS_ClosingDoor          =10,
    TS_Opening              =11,
    TS_Closing              =12,
    TS_ClearingRoom         =13,
    TS_Grenading            =14,
    TS_DisarmingBomb        =15,
    TS_InteractWithDevice   =16,
    TS_SecuringTerrorist    =17,
    TS_ClimbingLadder       =18,
    TS_WaitingForOrders     =19,
    TS_SettingBreach        =20,
    TS_Retired              =21,
    TS_MAX                  =22,
};

class R6GAME_API AR6HUD : public AR6AbstractHUD
{
public:
    BYTE m_eLastMovementMode;
    BYTE m_eLastTeamState;
    BYTE m_eLastOtherTeamState[2];
    BYTE m_eLastPlayerAPAction;
    BYTE m_eLastGoCode;
    INT m_iBulletCount;
    INT m_iMaxBulletCount;
    INT m_iMagCount;
    INT m_iCurrentMag;
    BITFIELD m_bDrawHUDinScript:1 GCC_PACK(4);
    BITFIELD m_bGMIsSinglePlayer:1;
    BITFIELD m_bGMIsCoop:1;
    BITFIELD m_bGMIsTeamAdverserial:1;
    BITFIELD m_bShowCharacterInfo:1;
    BITFIELD m_bShowCurrentTeamInfo:1;
    BITFIELD m_bShowOtherTeamInfo:1;
    BITFIELD m_bShowWeaponInfo:1;
    BITFIELD m_bShowFPWeapon:1;
    BITFIELD m_bShowWaypointInfo:1;
    BITFIELD m_bShowActionIcon:1;
    BITFIELD m_bShowMPRadar:1;
    BITFIELD m_bShowTeamMatesNames:1;
    BITFIELD m_bUpdateHUDInTraining:1;
    BITFIELD m_bDisplayTimeBomb:1;
    BITFIELD m_bDisplayRemainingTime:1;
    BITFIELD m_bNoDeathCamera:1;
    BITFIELD m_bLastSniperHold:1;
    BITFIELD m_bShowPressGoCode:1;
    BITFIELD m_bPressGoCodeCanBlink:1;
    FLOAT m_fPosX GCC_PACK(4);
    FLOAT m_fPosY;
    FLOAT m_fScaleX;
    FLOAT m_fScaleY;
    FLOAT m_fScale;
    class AR6GameReplicationInfo* m_GameRepInfo;
    class AR6PlayerController* m_PlayerOwner;
    class UTexture* m_FlashbangFlash;
    class UTexture* m_TexNightVision;
    class UTexture* m_TexHeatVision;
    class UMaterial* m_TexHeatVisionActor;
    class UMaterial* m_TexHUDElements;
    class UMaterial* m_pCurrentMaterial;
    class UTexture* m_HeartBeatMaskMul;
    class UTexture* m_HeartBeatMaskAdd;
    class UTexture* m_Waypoint;
    class UTexture* m_WaypointArrow;
    class UTexture* m_InGamePlanningPawnIcon;
    class UTexture* m_LoadingScreen;
    class UTexture* m_TexNoise;
    class UMaterial* m_TexProneTrail;
    class UFinalBlend* m_pAlphaBlend;
    class AActor* m_pNextWayPoint;
    class UMaterial* m_TexRadarTextures[10];
    class AR6RainbowTeam* m_pLastRainbowTeam;
    TArrayNoInit<class AR6IOBomb*> m_aIOBombs;
    FColor m_iCurrentTeamColor;
    FColor m_CharacterInfoBoxColor;
    FColor m_CharacterInfoOutlineColor;
    FColor m_WeaponBoxColor;
    FColor m_WeaponOutlineColor;
    FColor m_TeamBoxColor;
    FColor m_TeamBoxOutlineColor;
    FColor m_OtherTeamBoxColor;
    FColor m_OtherTeamOutlineColor;
    FColor m_WPIconBox;
    FColor m_WPIconOutlineColor;
    FR6HUDState m_HUDElements[16];
    FStringNoInit m_szMovementMode;
    FStringNoInit m_szTeamState;
    FStringNoInit m_szOtherTeamState[2];
    FStringNoInit m_aszOtherTeamName[2];
    FStringNoInit m_szLastPlayerAPAction;
    FStringNoInit m_szPressGoCode;
    FStringNoInit m_szTeam;
    DECLARE_FUNCTION(execHudStep);
    DECLARE_FUNCTION(execDrawNativeHUD);
    DECLARE_CLASS(AR6HUD,AR6AbstractHUD,0,R6Game)
    NO_DEFAULT_CONSTRUCTOR(AR6HUD)
};


class R6GAME_API AR6ActionPoint : public AR6ActionPointAbstract
{
public:
    BYTE m_eMovementMode;
    BYTE m_eMovementSpeed;
    BYTE m_eAction;
    BYTE m_eActionType;
    INT m_iRainbowTeamName;
    INT m_iMileStoneNum;
    INT m_iNodeID;
    INT m_iInitialMousePosX;
    INT m_iInitialMousePosY;
    BITFIELD m_bActionCompleted:1 GCC_PACK(4);
    BITFIELD m_bActionPointReached:1;
    BITFIELD m_bDoorInRange:1;
    BITFIELD bShowLog:1;
    class UTexture* m_pCurrentTexture GCC_PACK(4);
    class UTexture* m_pSelected;
    class AR6IORotatingDoor* pDoor;
    class AR6PlanningCtrl* m_pPlanningCtrl;
    class AR6PathFlag* m_pMyPathFlag;
    class AR6ReferenceIcons* m_pActionIcon;
    FColor m_CurrentColor;
    FVector m_vActionDirection;
    FRotator m_rActionRotation;
    DECLARE_CLASS(AR6ActionPoint,AR6ActionPointAbstract,0,R6Game)
    NO_DEFAULT_CONSTRUCTOR(AR6ActionPoint)
};


class R6GAME_API UR6PlanningInfo : public UR6AbstractPlanningInfo
{
public:
    DECLARE_FUNCTION(execFindPathToNextPoint);
    DECLARE_FUNCTION(execDeletePoint);
    DECLARE_FUNCTION(execInsertToTeam);
    DECLARE_FUNCTION(execAddToTeam);
    DECLARE_CLASS(UR6PlanningInfo,UR6AbstractPlanningInfo,0|CLASS_Transient,R6Game)
    NO_DEFAULT_CONSTRUCTOR(UR6PlanningInfo)
};


class R6GAME_API UR6FileManagerCampaign : public UR6FileManager
{
public:
    DECLARE_FUNCTION(execSaveCustomMissionAvailable);
    DECLARE_FUNCTION(execLoadCustomMissionAvailable);
    DECLARE_FUNCTION(execSaveCampaign);
    DECLARE_FUNCTION(execLoadCampaign);
    DECLARE_CLASS(UR6FileManagerCampaign,UR6FileManager,0,R6Game)
    NO_DEFAULT_CONSTRUCTOR(UR6FileManagerCampaign)
};


class R6GAME_API UR6FileManagerPlanning : public UR6FileManager
{
public:
    INT m_iCurrentTeam;
    DECLARE_FUNCTION(execGetNumberOfFiles);
    DECLARE_FUNCTION(execSavePlanning);
    DECLARE_FUNCTION(execLoadPlanning);
    DECLARE_CLASS(UR6FileManagerPlanning,UR6FileManager,0,R6Game)
    NO_DEFAULT_CONSTRUCTOR(UR6FileManagerPlanning)
};


class R6GAME_API UR6Operative : public UObject
{
public:
    INT m_iUniqueID;
    INT m_iRookieID;
    INT m_RMenuFaceX;
    INT m_RMenuFaceY;
    INT m_RMenuFaceW;
    INT m_RMenuFaceH;
    INT m_RMenuFaceSmallX;
    INT m_RMenuFaceSmallY;
    INT m_RMenuFaceSmallW;
    INT m_RMenuFaceSmallH;
    INT m_iHealth;
    INT m_iNbMissionPlayed;
    INT m_iTerrokilled;
    INT m_iRoundsfired;
    INT m_iRoundsOntarget;
    FLOAT m_fAssault;
    FLOAT m_fDemolitions;
    FLOAT m_fElectronics;
    FLOAT m_fSniper;
    FLOAT m_fStealth;
    FLOAT m_fSelfControl;
    FLOAT m_fLeadership;
    FLOAT m_fObservation;
    class UTexture* m_TMenuFace;
    class UTexture* m_TMenuFaceSmall;
    FName m_CanUseArmorType;
    TArrayNoInit<class UTexture*> m_OperativeFaces;
    FStringNoInit m_szOperativeClass;
    FStringNoInit m_szCountryID;
    FStringNoInit m_szCityID;
    FStringNoInit m_szStateID;
    FStringNoInit m_szSpecialityID;
    FStringNoInit m_szHairColorID;
    FStringNoInit m_szEyesColorID;
    FStringNoInit m_szGenderID;
    FStringNoInit m_szGender;
    FStringNoInit m_szPrimaryWeapon;
    FStringNoInit m_szPrimaryWeaponGadget;
    FStringNoInit m_szPrimaryWeaponBullet;
    FStringNoInit m_szPrimaryGadget;
    FStringNoInit m_szSecondaryWeapon;
    FStringNoInit m_szSecondaryWeaponGadget;
    FStringNoInit m_szSecondaryWeaponBullet;
    FStringNoInit m_szSecondaryGadget;
    FStringNoInit m_szArmor;
    DECLARE_CLASS(UR6Operative,UObject,0,R6Game)
    NO_DEFAULT_CONSTRUCTOR(UR6Operative)
};


class R6GAME_API UR6MissionRoster : public UObject
{
public:
    TArrayNoInit<class UR6Operative*> m_MissionOperatives;
    DECLARE_CLASS(UR6MissionRoster,UObject,0,R6Game)
    NO_DEFAULT_CONSTRUCTOR(UR6MissionRoster)
};


class R6GAME_API UR6PlayerCampaign : public UObject
{
public:
    BYTE m_bCampaignCompleted;
    INT m_iDifficultyLevel;
    INT m_iNoMission;
    class UR6MissionRoster* m_OperativesMissionDetails;
    FStringNoInit m_FileName;
    FStringNoInit m_CampaignFileName;
    DECLARE_CLASS(UR6PlayerCampaign,UObject,0,R6Game)
    NO_DEFAULT_CONSTRUCTOR(UR6PlayerCampaign)
};


class R6GAME_API UR6PlayerCustomMission : public UObject
{
public:
    TArrayNoInit<FString> m_aCampaignFileName;
    TArrayNoInit<INT> m_iNbMapUnlock;
    DECLARE_CLASS(UR6PlayerCustomMission,UObject,0,R6Game)
    NO_DEFAULT_CONSTRUCTOR(UR6PlayerCustomMission)
};

#endif

AUTOGENERATE_FUNCTION(AR6HUD,1609,execHudStep);
AUTOGENERATE_FUNCTION(AR6HUD,1605,execDrawNativeHUD);
AUTOGENERATE_FUNCTION(AR6GameInfo,1504,execGetSystemUserName);
AUTOGENERATE_FUNCTION(AR6GameInfo,2010,execSetController);
AUTOGENERATE_FUNCTION(AR6InstructionSoundVolume,2732,execUseSound);
AUTOGENERATE_FUNCTION(UR6FileManagerCampaign,2702,execSaveCustomMissionAvailable);
AUTOGENERATE_FUNCTION(UR6FileManagerCampaign,2701,execLoadCustomMissionAvailable);
AUTOGENERATE_FUNCTION(UR6FileManagerCampaign,1004,execSaveCampaign);
AUTOGENERATE_FUNCTION(UR6FileManagerCampaign,1003,execLoadCampaign);
AUTOGENERATE_FUNCTION(UR6FileManagerPlanning,1418,execGetNumberOfFiles);
AUTOGENERATE_FUNCTION(UR6FileManagerPlanning,1417,execSavePlanning);
AUTOGENERATE_FUNCTION(UR6FileManagerPlanning,1416,execLoadPlanning);
AUTOGENERATE_FUNCTION(UR6PlanningInfo,2007,execFindPathToNextPoint);
AUTOGENERATE_FUNCTION(UR6PlanningInfo,1413,execDeletePoint);
AUTOGENERATE_FUNCTION(UR6PlanningInfo,1412,execInsertToTeam);
AUTOGENERATE_FUNCTION(UR6PlanningInfo,1411,execAddToTeam);
AUTOGENERATE_FUNCTION(AR6PlanningCtrl,2017,execPlanningTrace);
AUTOGENERATE_FUNCTION(AR6PlanningCtrl,2016,execGetXYPoint);
AUTOGENERATE_FUNCTION(AR6PlanningCtrl,2013,execGetClickResult);

#ifndef NAMES_ONLY
#undef AUTOGENERATE_NAME
#undef AUTOGENERATE_FUNCTION
#endif

#if SUPPORTS_PRAGMA_PACK
#pragma pack (pop)
#endif