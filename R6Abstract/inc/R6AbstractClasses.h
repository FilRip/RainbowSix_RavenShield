/*===========================================================================
    C++ class definitions exported from UnrealScript.
    This is automatically generated by the tools.
    DO NOT modify this manually! Edit the corresponding .uc files instead!
===========================================================================*/
#if SUPPORTS_PRAGMA_PACK
#pragma pack (push,4)
#endif

#ifndef R6ABSTRACT_API
#define R6ABSTRACT_API DLL_IMPORT
#endif

#ifndef NAMES_ONLY
#define AUTOGENERATE_NAME(name) extern R6ABSTRACT_API FName R6ABSTRACT_##name;
#define AUTOGENERATE_FUNCTION(cls,idx,name)
#endif

AUTOGENERATE_NAME(R6MakeNoise)
AUTOGENERATE_NAME(GetSkill)
AUTOGENERATE_NAME(SpawnSelectedGadget)

#ifndef NAMES_ONLY


class R6ABSTRACT_API AR6AbstractGameInfo : public AGameInfo
{
public:
    INT m_iNbOfRainbowAIToSpawn;
    INT m_iNbOfTerroristToSpawn;
    INT m_iDiffLevel;
    INT m_fTimerStartTime;
    BITFIELD m_bFriendlyFire:1 GCC_PACK(4);
    BITFIELD m_bEndGameIgnoreGamePlayCheck:1;
    BITFIELD m_bGameOverButAllowDeath:1;
    BITFIELD m_bTimerStarted:1;
    BITFIELD m_bInternetSvr:1;
    FLOAT m_fEndingTime GCC_PACK(4);
    FLOAT m_fTimeBetRounds;
    FLOAT m_fEndKickVoteTime;
    class APlayerController* m_Player;
    class UR6AbstractNoiseMgr* m_noiseMgr;
    class AR6MissionObjectiveMgr* m_missionMgr;
    class APlayerController* m_PlayerKick;
    class APlayerController* m_pCurPlayerCtrlMdfSrvInfo;
    class AUdpBeacon* m_UdpBeacon;
    FStringNoInit m_KickersName;
    FStringNoInit m_szDefaultActionPlan;
    DECLARE_CLASS(AR6AbstractGameInfo,AGameInfo,0|CLASS_Config,R6Abstract)
    NO_DEFAULT_CONSTRUCTOR(AR6AbstractGameInfo)
};

enum ESkills
{
    SKILL_Assault           =0,
    SKILL_Demolitions       =1,
    SKILL_Electronics       =2,
    SKILL_Sniper            =3,
    SKILL_Stealth           =4,
    SKILL_SelfControl       =5,
    SKILL_Leadership        =6,
    SKILL_Observation       =7,
    SKILL_MAX               =8,
};

struct AR6AbstractPawn_eventGetSkill_Parms
{
    BYTE eSkillName;
    FLOAT ReturnValue;
};
class R6ABSTRACT_API AR6AbstractPawn : public APawn
{
public:
    BITFIELD bShowLog:1 GCC_PACK(4);
    FLOAT eventGetSkill(BYTE eSkillName)
    {
        AR6AbstractPawn_eventGetSkill_Parms Parms;
        Parms.ReturnValue=0;
        Parms.eSkillName=eSkillName;
        ProcessEvent(FindFunctionChecked(R6ABSTRACT_GetSkill),&Parms);
        return Parms.ReturnValue;
    }
    DECLARE_CLASS(AR6AbstractPawn,APawn,0,R6Abstract)
    NO_DEFAULT_CONSTRUCTOR(AR6AbstractPawn)
};


class R6ABSTRACT_API AR6AbstractInsertionZone : public APlayerStart
{
public:
    INT m_iInsertionNumber;
    DECLARE_CLASS(AR6AbstractInsertionZone,APlayerStart,0,R6Abstract)
    NO_DEFAULT_CONSTRUCTOR(AR6AbstractInsertionZone)
};


class R6ABSTRACT_API AR6AbstractExtractionZone : public ANavigationPoint
{
public:
    DECLARE_CLASS(AR6AbstractExtractionZone,ANavigationPoint,0,R6Abstract)
    NO_DEFAULT_CONSTRUCTOR(AR6AbstractExtractionZone)
};

enum EGoCode
{
    GOCODE_Alpha            =0,
    GOCODE_Bravo            =1,
    GOCODE_Charlie          =2,
    GOCODE_Zulu             =3,
    GOCODE_None             =4,
    GOCODE_MAX              =5,
};

class R6ABSTRACT_API AR6AbstractHUD : public AHUD
{
public:
    INT m_iCycleHUDLayer;
    BITFIELD m_bToggleHelmet:1 GCC_PACK(4);
    BITFIELD m_bGetRes:1;
    FLOAT m_fNewHUDResX GCC_PACK(4);
    FLOAT m_fNewHUDResY;
    FStringNoInit m_szStatusDetail;
    DECLARE_CLASS(AR6AbstractHUD,AHUD,0,R6Abstract)
    NO_DEFAULT_CONSTRUCTOR(AR6AbstractHUD)
};


class R6ABSTRACT_API AR6AbstractFirstPersonWeapon : public AR6EngineFirstPersonWeapon
{
public:
    BITFIELD m_bWeaponBipodDeployed:1 GCC_PACK(4);
    BITFIELD m_bReloadEmpty:1;
    class AActor* m_smGun GCC_PACK(4);
    class AActor* m_smGun2;
    FName m_Empty;
    FName m_Fire;
    FName m_FireEmpty;
    FName m_FireLast;
    FName m_Neutral;
    FName m_Reload;
    FName m_ReloadEmpty;
    FName m_BipodRaise;
    FName m_BipodDeploy;
    FName m_BipodDiscard;
    FName m_BipodClose;
    FName m_BipodNeutral;
    FName m_BipodReload;
    FName m_BipodReloadEmpty;
    FName m_WeaponNeutralAnim;
    DECLARE_CLASS(AR6AbstractFirstPersonWeapon,AR6EngineFirstPersonWeapon,0,R6Abstract)
    NO_DEFAULT_CONSTRUCTOR(AR6AbstractFirstPersonWeapon)
};


struct AR6AbstractWeapon_eventSpawnSelectedGadget_Parms
{
};
class R6ABSTRACT_API AR6AbstractWeapon : public AR6EngineWeapon
{
public:
    BITFIELD m_bHiddenWhenNotInUse:1 GCC_PACK(4);
    class AR6AbstractGadget* m_SelectedWeaponGadget GCC_PACK(4);
    class AR6AbstractGadget* m_ScopeGadget;
    class AR6AbstractGadget* m_BipodGadget;
    class AR6AbstractGadget* m_MuzzleGadget;
    class AR6AbstractGadget* m_MagazineGadget;
    class AR6AbstractFirstPersonWeapon* m_FPHands;
    class AR6AbstractFirstPersonWeapon* m_FPWeapon;
    class AR6AbstractGadget* m_FPGadget;
    class UClass* m_WeaponGadgetClass;
    class UClass* m_pFPHandsClass;
    class UClass* m_pFPWeaponClass;
    void eventSpawnSelectedGadget()
    {
        ProcessEvent(FindFunctionChecked(R6ABSTRACT_SpawnSelectedGadget),NULL);
    }
    DECLARE_CLASS(AR6AbstractWeapon,AR6EngineWeapon,0,R6Abstract)
    NO_DEFAULT_CONSTRUCTOR(AR6AbstractWeapon)
};

enum eGadgetType
{
    GAD_Other               =0,
    GAD_SniperRifleScope    =1,
    GAD_Magazine            =2,
    GAD_Bipod               =3,
    GAD_Muzzle              =4,
    GAD_Silencer            =5,
    GAD_Light               =6,
    GAD_MAX                 =7,
};

class R6ABSTRACT_API AR6AbstractGadget : public AActor
{
public:
    BYTE m_eGadgetType;
    class AR6EngineWeapon* m_WeaponOwner;
    class APawn* m_OwnerCharacter;
    FName m_AttachmentName;
    FStringNoInit m_NameID;
    FStringNoInit m_GadgetName;
    FStringNoInit m_GadgetShortName;
    DECLARE_CLASS(AR6AbstractGadget,AActor,0,R6Abstract)
    NO_DEFAULT_CONSTRUCTOR(AR6AbstractGadget)
};


class R6ABSTRACT_API AR6AbstractCorpse : public AActor
{
public:
    DECLARE_FUNCTION(execAddImpulseToBone);
    DECLARE_FUNCTION(execFirstInit);
    DECLARE_FUNCTION(execRenderBones);
    DECLARE_CLASS(AR6AbstractCorpse,AActor,0,R6Abstract)
    NO_DEFAULT_CONSTRUCTOR(AR6AbstractCorpse)
};


class R6ABSTRACT_API AR6AbstractBullet : public AActor
{
public:
    DECLARE_CLASS(AR6AbstractBullet,AActor,0,R6Abstract)
    NO_DEFAULT_CONSTRUCTOR(AR6AbstractBullet)
};


class R6ABSTRACT_API UR6AbstractGameService : public UObject
{
public:
    BITFIELD m_bServerWaitMatchStartReply:1 GCC_PACK(4);
    BITFIELD m_bClientWaitMatchStartReply:1;
    BITFIELD m_bClientWillSubmitResult:1;
    BITFIELD m_bWaitSubmitMatchReply:1;
    BITFIELD m_bMSClientLobbyDisconnect:1;
    BITFIELD m_bMSClientRouterDisconnect:1;
    class APlayerController* m_LocalPlayerController GCC_PACK(4);
    FStringNoInit m_szUserID;
    DECLARE_FUNCTION(execNativeSubmitMatchResult);
    DECLARE_CLASS(UR6AbstractGameService,UObject,0|CLASS_Config,R6Abstract)
    NO_DEFAULT_CONSTRUCTOR(UR6AbstractGameService)
};

enum ESoundType
{
    SNDTYPE_None            =0,
    SNDTYPE_Gunshot         =1,
    SNDTYPE_BulletImpact    =2,
    SNDTYPE_GrenadeImpact   =3,
    SNDTYPE_GrenadeLike     =4,
    SNDTYPE_Explosion       =5,
    SNDTYPE_PawnMovement    =6,
    SNDTYPE_Choking         =7,
    SNDTYPE_Talking         =8,
    SNDTYPE_Screaming       =9,
    SNDTYPE_Reload          =10,
    SNDTYPE_Equipping       =11,
    SNDTYPE_Dead            =12,
    SNDTYPE_Door            =13,
    SNDTYPE_MAX             =14,
};

struct UR6AbstractNoiseMgr_eventR6MakeNoise_Parms
{
    BYTE eType;
    class AActor* Source;
};
class R6ABSTRACT_API UR6AbstractNoiseMgr : public UObject
{
public:
    void eventR6MakeNoise(BYTE eType, class AActor* Source)
    {
        UR6AbstractNoiseMgr_eventR6MakeNoise_Parms Parms;
        Parms.eType=eType;
        Parms.Source=Source;
        ProcessEvent(FindFunctionChecked(R6ABSTRACT_R6MakeNoise),&Parms);
    }
    DECLARE_CLASS(UR6AbstractNoiseMgr,UObject,0,R6Abstract)
    NO_DEFAULT_CONSTRUCTOR(UR6AbstractNoiseMgr)
};

#endif

AUTOGENERATE_FUNCTION(UR6AbstractGameService,1297,execNativeSubmitMatchResult);
AUTOGENERATE_FUNCTION(AR6AbstractCorpse,1804,execAddImpulseToBone);
AUTOGENERATE_FUNCTION(AR6AbstractCorpse,1803,execFirstInit);
AUTOGENERATE_FUNCTION(AR6AbstractCorpse,1802,execRenderBones);

#ifndef NAMES_ONLY
#undef AUTOGENERATE_NAME
#undef AUTOGENERATE_FUNCTION
#endif

#if SUPPORTS_PRAGMA_PACK
#pragma pack (pop)
#endif
