//================================================================================
// Actor.
//================================================================================
class Actor extends Object
	Native
	Abstract
	NativeReplication;

const TF_SkipPawn= 0x0020;
const TF_ShadowCast= 0x0010;
const TF_SkipVolume= 0x0008;
const TF_LineOfFire= 0x0004;
const TF_Visibility= 0x0002;
const TF_TraceActors= 0x0001;

enum EDrawType {
	DT_None,
	DT_Sprite,
	DT_Mesh,
	DT_Brush,
	DT_RopeSprite,
	DT_VerticalSprite,
	DT_Terraform,
	DT_SpriteAnimOnce,
	DT_StaticMesh,
	DT_DrawType,
	DT_Particle,
	DT_AntiPortal,
	DT_FluidSurface
};

enum ENetRole {
	ROLE_None,
	ROLE_DumbProxy,
	ROLE_SimulatedProxy,
	ROLE_AutonomousProxy,
	ROLE_Authority
};

enum EHUDElement {
	HE_HealthAndName,
	HE_Posture,
	HE_ActionIcon,
	HE_WeaponIconAndName,
	HE_WeaponAttachment,
	HE_Ammo,
	HE_Magazine,
	HE_ROF,
	HE_TeamHealth,
	HE_MovementMode,
	HE_ROE,
	HE_WPAction,
	HE_Reticule,
	HE_WPIcon,
	HE_OtherTeam,
	HE_PressGoCodeKey
};

enum EHUDDisplayType {
	HDT_Normal,
	HDT_Hidden,
	HDT_FadeIn,
	HDT_Blink
};

enum EModeFlagOption {
	MFO_Available,
	MFO_NotAvailable
};

enum EGameModeInfo {
	GMI_None,
	GMI_SinglePlayer,
	GMI_Cooperative,
	GMI_Adversarial,
	GMI_Squad
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

enum ESoundType {
	SNDTYPE_None,
	SNDTYPE_Gunshot,
	SNDTYPE_BulletImpact,
	SNDTYPE_GrenadeImpact,
	SNDTYPE_GrenadeLike,
	SNDTYPE_Explosion,
	SNDTYPE_PawnMovement,
	SNDTYPE_Choking,
	SNDTYPE_Talking,
	SNDTYPE_Screaming,
	SNDTYPE_Reload,
	SNDTYPE_Equipping,
	SNDTYPE_Dead,
	SNDTYPE_Door
};

enum EPawnType {
	PAWN_NotDefined,
	PAWN_Rainbow,
	PAWN_Terrorist,
	PAWN_Hostage,
	PAWN_All
};

enum ENoiseType {
	NOISE_None,
	NOISE_Investigate,
	NOISE_Threat,
	NOISE_Grenade,
	NOISE_Dead
};

enum EDisplayFlag {
	DF_ShowOnlyInPlanning,
	DF_ShowOnlyIn3DView,
	DF_ShowInBoth
};

enum EDoubleClickDir {
	DCLICK_None,
	DCLICK_Left,
	DCLICK_Right,
	DCLICK_Forward,
	DCLICK_Back,
	DCLICK_Active,
	DCLICK_Done
};

enum ETravelType {
	TRAVEL_Absolute,
	TRAVEL_Partial,
	TRAVEL_Relative
};

enum EPhysics {
	PHYS_None,
	PHYS_Walking,
	PHYS_Falling,
	PHYS_Swimming,
	PHYS_Flying,
	PHYS_Rotating,
	PHYS_Projectile,
	PHYS_Interpolating,
	PHYS_MovingBrush,
	PHYS_Spider,
	PHYS_Trailer,
	PHYS_Ladder,
	PHYS_RootMotion,
	PHYS_Karma,
	PHYS_KarmaRagDoll
};

struct RandomTweenNum
{
	var() float m_fMin;
	var() float m_fMax;
	var float m_fResult;
};

enum EStance {
	STAN_None,
	STAN_Standing,
	STAN_Crouching,
	STAN_Prone
};

enum eStunResult {
	SR_None,
	SR_Stunned,
	SR_Dazed,
	SR_KnockedOut
};

enum eKillResult {
	KR_None,
	KR_Wound,
	KR_Incapacitate,
	KR_Killed
};

enum EVoicesPriority {
	VP_Low,
	VP_Medium,
	VP_High
};

enum EHostageNationality {
	HN_French,
	HN_British,
	HN_Spanish,
	HN_Portuguese,
	HN_Norwegian
};

enum ETerroristNationality {
	TN_Spanish1,
	TN_Spanish2,
	TN_German1,
	TN_German2,
	TN_Portuguese
};

struct PlayerMenuInfo
{
	var string szPlayerName;
	var string szKilledBy;
	var int iKills;
	var int iEfficiency;
	var int iRoundsFired;
	var int iRoundsHit;
	var int iPingTime;
	var int iHealth;
	var int iTeamSelection;
	var int iRoundsPlayed;
	var int iRoundsWon;
	var int iDeathCount;
	var bool bOwnPlayer;
	var bool bSpectator;
	var bool bPlayerReady;
	var bool bJoinedTeamLate;
};

struct StaticMeshBatchRenderInfo
{
	var int m_iBatchIndex;
	var int m_iFirstIndex;
	var int m_iMinVertexIndex;
	var int m_iMaxVertexIndex;
};

struct ResolutionInfo
{
	var int iWidth;
	var int iHeigh;
	var int iRefreshRate;
};

struct IndexBufferPtr
{
	var int Ptr;
};

struct R6HUDState
{
	var float fTimeStamp;
	var EHUDDisplayType eDisplay;
	var Color Color;
};

const DEATHMSG_KILLED_BY_BOMB=9;
const DEATHMSG_RAINBOW_KILLEDBYTERRO=8;
const DEATHMSG_HOSTAGE_KILLEDBYTERRO=7;
const DEATHMSG_HOSTAGE_KILLEDBY=6;
const DEATHMSG_HOSTAGE_DIED=5;
const DEATHMSG_SWITCHTEAM=4;
const DEATHMSG_KAMAKAZE=3;
const DEATHMSG_PENALTY=2;
const DEATHMSG_CONNECTIONLOST=1;
const c_iTeamNumUnknow= 4;
const c_iTeamNumBravo= 3;
const c_iTeamNumAlpha= 2;
const c_iTeamNumTerrorist= 1;
const c_iTeamNumHostage= 0;
const TEAM_MoveAndGrenade= 0x00140;
const TEAM_GrenadeAndClear= 0x000c0;
const TEAM_OpenGrenadeAndClear= 0x000d0;
const TEAM_OpenAndGrenade= 0x00050;
const TEAM_OpenAndClear= 0x00090;
const TEAM_InteractDevice= 0x02000;
const TEAM_DisarmBomb= 0x01000;
const TEAM_EscortHostage= 0x00800;
const TEAM_SecureTerrorist= 0x00400;
const TEAM_ClimbLadder= 0x00200;
const TEAM_Move= 0x00100;
const TEAM_ClearRoom= 0x00080;
const TEAM_Grenade= 0x00040;
const TEAM_CloseDoor= 0x00020;
const TEAM_OpenDoor= 0x00010;
const TEAM_Orders= 0x00001;
const TEAM_None= 0x00000;
enum EForceType {
	FT_None,
	FT_DragAlong
};

struct AnimStruct
{
	var() name AnimSequence;
	var() name BoneName;
	var() float AnimRate;
	var() byte Alpha;
	var() byte LeadIn;
	var() byte LeadOut;
	var() bool bLoopAnim;
};

struct AnimRep
{
	var name AnimSequence;
	var bool bAnimLoop;
	var byte AnimRate;
	var byte AnimFrame;
	var byte TweenRate;
};

struct KRBVec
{
	var float X;
	var float Y;
	var float Z;
};

struct DbgVectorInfo
{
	var bool m_bDisplay;
	var Vector m_vLocation;
	var Vector m_vCylinder;
	var Color m_color;
	var string m_szDef;
};

const MINFLOORZ= 0.7;
const MAXSTEPHEIGHT= 33.0;

enum ELightEffect {
	LE_None,
	LE_TorchWaver,
	LE_FireWaver,
	LE_WateryShimmer,
	LE_Searchlight,
	LE_SlowWave,
	LE_FastWave,
	LE_CloudCast,
	LE_StaticSpot,
	LE_Shock,
	LE_Disco,
	LE_Warp,
	LE_Spotlight,
	LE_NonIncidence,
	LE_Shell,
	LE_OmniBumpMap,
	LE_Interference,
	LE_Cylinder,
	LE_Rotor,
	LE_Unused,
	LE_Sunlight
};

enum ELightType {
	LT_None,
	LT_Steady,
	LT_Pulse,
	LT_Blink,
	LT_Flicker,
	LT_Strobe,
	LT_BackdropLight,
	LT_SubtlePulse,
	LT_TexturePaletteOnce,
	LT_TexturePaletteLoop
};

enum EMusicTransition {
	MTRAN_None,
	MTRAN_Instant,
	MTRAN_Segue,
	MTRAN_Fade,
	MTRAN_FastFade,
	MTRAN_SlowFade
};

enum ELoadBankSound {
	LBS_Fix,
	LBS_UC,
	LBS_Map,
	LBS_Gun
};

enum ESendSoundStatus {
	SSTATUS_SendToPlayer,
	SSTATUS_SendToMPTeam,
	SSTATUS_SendToAll
};

enum ESoundVolume {
	VOLUME_Music,
	VOLUME_Voices,
	VOLUME_FX,
	VOLUME_Grenade
};

enum ESoundSlot {
	SLOT_None,
	SLOT_Ambient,
	SLOT_Guns,
	SLOT_SFX,
	SLOT_GrenadeEffect,
	SLOT_Music,
	SLOT_Talk,
	SLOT_Speak,
	SLOT_HeadSet,
	SLOT_Menu,
	SLOT_Instruction,
	SLOT_StartingSound
};

enum ESoundOcclusion {
	OCCLUSION_Default,
	OCCLUSION_None,
	OCCLUSION_BSP,
	OCCLUSION_StaticMeshes
};

enum ERenderStyle {
	STY_None,
	STY_Normal,
	STY_Masked,
	STY_Translucent,
	STY_Modulated,
	STY_Alpha,
	STY_Particle,
	STY_Highlight
};

struct ProjectorRenderInfoPtr
{
	var int Ptr;
};

struct ProjectorRelativeRenderInfo
{
	var ProjectorRenderInfoPtr m_RenderInfoPtr;
	var Vector m_RelativeLocation;
	var Rotator m_RelativeRotation;
};

struct PointRegion
{
	var ZoneInfo Zone;
	var int iLeaf;
	var byte ZoneNumber;
};

var(Movement) EPhysics Physics;
var ENetRole Role;
var ENetRole RemoteRole;
var(Display) EDrawType DrawType;
var(Display) byte AmbientGlow;
var(Display) byte MaxLights;
var(Display) ERenderStyle Style;
var(Sound) byte SoundPitch;
var(Sound) ESoundOcclusion SoundOcclusion;
var byte m_iTracedBone;
var(Lighting) ELightType LightType;
var(Lighting) ELightEffect LightEffect;
var(LightColor) byte LightHue;
var(LightColor) byte LightSaturation;
var(Lighting) byte LightPeriod;
var(Lighting) byte LightPhase;
var(Lighting) byte LightCone;
var(Force) EForceType ForceType;
var(R6Planning) EDisplayFlag m_eDisplayFlag;
var(R6Planning) byte m_u8SpritePlanningAngle;
var(R6Availability) EModeFlagOption m_eStoryMode;
var(R6Availability) EModeFlagOption m_eMissionMode;
var(R6Availability) EModeFlagOption m_eTerroristHunt;
var(R6Availability) EModeFlagOption m_eTerroristHuntCoop;
var(R6Availability) EModeFlagOption m_eHostageRescue;
var(R6Availability) EModeFlagOption m_eHostageRescueCoop;
var(R6Availability) EModeFlagOption m_eHostageRescueAdv;
var(R6Availability) EModeFlagOption m_eDefend;
var(R6Availability) EModeFlagOption m_eDefendCoop;
var(R6Availability) EModeFlagOption m_eRecon;
var(R6Availability) EModeFlagOption m_eReconCoop;
var(R6Availability) EModeFlagOption m_eDeathmatch;
var(R6Availability) EModeFlagOption m_eTeamDeathmatch;
var(R6Availability) EModeFlagOption m_eBomb;
var(R6Availability) EModeFlagOption m_eEscort;
var(R6Availability) EModeFlagOption m_eLoneWolf;
var(R6Availability) EModeFlagOption m_eSquadDeathmatch;
var(R6Availability) EModeFlagOption m_eSquadTeamDeathmatch;
var(R6Availability) EModeFlagOption m_eTerroristHuntAdv;
var(R6Availability) EModeFlagOption m_eScatteredHuntAdv;
var(R6Availability) EModeFlagOption m_eCaptureTheEnemyAdv;
var(R6Availability) EModeFlagOption m_eCountDown;
var(R6Availability) EModeFlagOption m_eKamikaze;
var byte m_u8RenderDataLastUpdate;
var(Display) byte m_HeatIntensity;
var byte m_wTickFrequency;
var byte m_wNbTickSkipped;
var native int CollisionTag;
var native int LightingTag;
var native int ActorTag;
var native int KStepTag;
var(R6Planning) int m_iPlanningFloor_0;
var(R6Planning) int m_iPlanningFloor_1;
var int m_bInWeatherVolume;
var int m_iLastRenderCycles;
var int m_iLastRenderTick;
var int m_iTotalRenderCycles;
var int m_iNbRenders;
var int m_iTickCycles;
var int m_iTraceCycles;
var int m_iTraceLastTick;
var int m_iTracedCycles;
var int m_iTracedLastTick;
var bool bStatic;
var(Advanced) bool bHidden;
var(Advanced) const bool bNoDelete;
var bool m_bR6Deletable;
var(R6Availability) bool m_bUseR6Availability;
var bool m_bSkipHitDetection;
var bool bAnimByOwner;
var bool bDeleteMe;
var(Lighting) bool bDynamicLight;
var bool m_bDynamicLightOnlyAffectPawns;
var bool bTimerLoop;
var(Advanced) bool bCanTeleport;
var bool bOwnerNoSee;
var bool bOnlyOwnerSee;
var bool bAlwaysTick;
var(Advanced) bool bHighDetail;
var(Advanced) bool bStasis;
var bool bTrailerSameRotation;
var bool bTrailerPrePivot;
var bool bClientAnim;
var bool bWorldGeometry;
var(Display) bool bAcceptsProjectors;
var bool m_bHandleRelativeProjectors;
var bool bOrientOnSlope;
var bool bDisturbFluidSurface;
var bool bOnlyAffectPawns;
var bool bShowOctreeNodes;
var bool bWasSNFiltered;
var bool bNetTemporary;
var bool bNetOptional;
var bool bNetDirty;
var bool bAlwaysRelevant;
var bool bReplicateInstigator;
var bool bReplicateMovement;
var bool bSkipActorPropertyReplication;
var bool bUpdateSimulatedPosition;
var bool bTearOff;
var bool m_bUseRagdoll;
var bool m_bForceBaseReplication;
var bool bOnlyDirtyReplication;
var bool bReplicateAnimations;
var bool bNetInitialRotation;
var bool bCompressedPosition;
var bool m_bReticuleInfo;
var bool m_bShowInHeatVision;
var bool m_bFirstTimeInZone;
var(Lighting) bool m_bBypassAmbiant;
var bool m_bRenderOutOfWorld;
var bool m_bSpawnedInGame;
var bool m_bResetSystemLog;
var bool m_bDeleteOnReset;
var bool m_bInAmbientRange;
var(R6Sound) bool m_bPlayIfSameZone;
var(R6Sound) bool m_bPlayOnlyOnce;
var(R6Sound) bool m_bListOfZoneHearable;
var(R6Sound) bool m_bIfDirectLineOfSight;
var bool m_bUseExitSounds;
var bool m_bSoundWasPlayed;
var bool m_bDrawFromBase;
var(Movement) bool bHardAttach;
var bool m_bAllowLOD;
var(Display) bool bUnlit;
var(Display) bool bShadowCast;
var(Display) bool bStaticLighting;
var(Display) bool bUseLightingFromBase;
var bool bHurtEntry;
var(Advanced) bool bGameRelevant;
var(Advanced) bool bCollideWhenPlacing;
var bool bTravel;
var(Advanced) bool bMovable;
var bool bDestroyInPainVolume;
var(Advanced) bool bShouldBaseAtStartup;
var bool bPendingDelete;
var(Advanced) bool m_bUseDifferentVisibleCollide;
var bool m_b3DSound;
var(Collision) bool bCollideActors;
var(Collision) bool bCollideWorld;
var(Collision) bool bBlockActors;
var(Collision) bool bBlockPlayers;
var(Collision) bool bProjTarget;
var(Collision) bool m_bSeeThrough;
var(Collision) bool m_bPawnGoThrough;
var(Collision) bool m_bBulletGoThrough;
var bool m_bDoPerBoneTrace;
var(Collision) bool bAutoAlignToTerrain;
var(Collision) bool bUseCylinderCollision;
var(Collision) bool bBlockKarma;
var(Debug) bool m_bLogNetTraffic;
var(Lighting) bool bSpecialLit;
var(Lighting) bool bActorShadows;
var(Lighting) bool bCorona;
var bool bLightChanged;
var bool m_bLightingVisibility;
var bool bIgnoreOutOfWorld;
var(Movement) bool bBounce;
var(Movement) bool bFixedRotationDir;
var(Movement) bool bRotateToDesired;
var bool bInterpolating;
var bool bJustTeleported;
var bool m_bUseOriginalRotationInPlanning;
var bool bNetInitial;
var bool bNetOwner;
var bool bNetRelevant;
var bool bDemoRecording;
var bool bClientDemoRecording;
var bool bClientDemoNetFunc;
var(Advanced) bool bHiddenEd;
var(Advanced) bool bHiddenEdGroup;
var(Advanced) bool bDirectional;
var bool bSelected;
var(Advanced) bool bEdShouldSnap;
var bool bObsolete;
var bool bPathColliding;
var bool bScriptInitialized;
var(Advanced) bool bLockLocation;
var(Advanced) bool bEdLocked;
var(R6Planning) bool m_bPlanningAlwaysDisplay;
var(R6Planning) bool m_bIsWalkable;
var(R6Planning) bool m_bSpriteShowFlatInPlanning;
var(R6Planning) bool m_bSpriteShownIn3DInPlanning;
var bool m_bSpriteShowOver;
var(R6Availability) bool m_bHideInLowGoreLevel;
var(Lighting) bool m_bIsRealtime;
var(Advanced) bool m_bShouldHidePortal;
var bool m_bHidePortal;
var(Display) bool m_bOutlinedInPlanning;
var bool m_bNeedOutlineUpdate;
var bool m_bBatchesStaticLightingUpdated;
var(Lighting) bool m_bForceStaticLighting;
var bool m_bSkipTick;
var bool m_bTickOnlyWhenVisible;
var float LastRenderTime;
var float TimerRate;
var float TimerCounter;
var(Advanced) float LifeSpan;
var(Display) float LODBias;
var(R6Sound) float m_fAmbientSoundRadius;
var(R6Sound) float m_fSoundRadiusSaturation;
var(R6Sound) float m_fSoundRadiusActivation;
var(R6Sound) float m_fSoundRadiusLinearFadeDist;
var(R6Sound) float m_fSoundRadiusLinearFadeEnd;
var float LatentFloat;
var(Display) float DrawScale;
var(Display) float m_fLightingScaleFactor;
var(Sound) float SoundRadius;
var(Sound) float TransientSoundVolume;
var(Sound) float TransientSoundRadius;
var(Collision) float CollisionRadius;
var(Collision) float CollisionHeight;
var float m_fCircumstantialActionRange;
var(LightColor) float LightBrightness;
var(Lighting) float LightRadius;
var(Movement) float Mass;
var(Movement) float Buoyancy;
var float fLightValue;
var float m_fBoneRotationTransition;
var(Force) float ForceRadius;
var(Force) float ForceScale;
var float NetPriority;
var float NetUpdateFrequency;
var(Lighting) float bCoronaMUL2XFactor;
var(Lighting) float m_fCoronaMinSize;
var(Lighting) float m_fCoronaMaxSize;
var float m_fAttachFactor;
var float m_fCummulativeTick;
var Actor Owner;
var LevelInfo Level;
var Pawn Instigator;
var(R6Sound) Sound AmbientSound;
var(R6Sound) Sound AmbientSoundStop;
var Actor m_CurrentAmbianceObject;
var Actor m_CurrentVolumeSound;
var Actor Base;
var Actor Deleted;
var PhysicsVolume PhysicsVolume;
var(Display) Material Texture;
var(Display) Mesh Mesh;
var(Display) StaticMesh StaticMesh;
var StaticMeshInstance StaticMeshInstance;
var export Model Brush;
var(Display) ConvexVolume AntiPortal;
var R6ColBox m_collisionBox;
var R6ColBox m_collisionBox2;
var Actor PendingTouch;
var(Karma) export editinlineuse KarmaParamsCollision KParams;
var Actor m_AttachedTo;
var Projector Shadow;
var StaticMesh m_OutlineStaticMesh;
var(Events) name Tag;
var(Object) name InitialState;
var(Object) name Group;
var(Events) name Event;
var(Movement) name AttachTag;
var name AttachmentBone;
var(R6Sound) name m_szSoundBoneName;
var Class<LocalMessage> MessageClass;
var(R6Sound) array<ZoneInfo> m_ListOfZoneInfo;
var array<Actor> Touching;
var array<Actor> Attached;
var(Display) array<Material> Skins;
var(Display) array<Material> NightVisionSkins;
var array<DbgVectorInfo> m_dbgVectorInfo;
var array<int> m_OutlineIndices;
var array<StaticMeshBatchRenderInfo> m_Batches;
var PointRegion Region;
var(Movement) Vector Location;
var(Movement) Rotator Rotation;
var(Movement) Vector Velocity;
var Vector Acceleration;
var Vector RelativeLocation;
var Rotator RelativeRotation;
var Matrix HardRelMatrix;
var(Display) Vector DrawScale3D;
var Vector PrePivot;
var(Display) Color m_fLightingAdditiveAmbiant;
var(Advanced) Vector m_vVisibleCenter;
var Rotator sm_Rotation;
var(Movement) Rotator RotationRate;
var(Movement) Rotator DesiredRotation;
var Vector ColLocation;
var(R6Planning) Color m_PlanningColor;
var transient int NetTag;
var transient int JoinedTag;
var transient bool bTicked;
var transient bool bEdSnap;
var transient bool bTempEditor;
var transient bool bPathTemp;
var transient MeshInstance MeshInstance;
var transient Level XLevel;
var transient array<int> Leaves;
var transient array<int> OctreeNodes;
var transient array<ProjectorRelativeRenderInfo> Projectors;
var transient Box OctreeBox;
var transient Vector OctreeBoxCenter;
var transient Vector OctreeBoxRadii;
var transient AnimRep SimAnim;
var transient IndexBufferPtr m_OutlineIndexBuffer;

replication
{
	reliable if ( Role == Role_Authority  )
		ClientAddSoundBank;
	reliable if ( Role < Role_Authority  )
		ServerSendBankToLoad;
	unreliable if ( bDemoRecording )
		DemoPlaySound;
	reliable if ( (Role == Role_Authority ) &&  !bNetOwner )
		Physics;
	reliable if ( ( !m_bUseRagdoll &&  !bSkipActorPropertyReplication || bNetInitial) && (Role == Role_Authority ) )
		Role,RemoteRole,LightType,bTearOff,bNetOwner;
	reliable if ( ( !m_bUseRagdoll &&  !bSkipActorPropertyReplication || bNetInitial) && (Role == Role_Authority ) && bNetDirty )
		DrawType,Style,bOnlyOwnerSee,bCollideActors,bCollideWorld,DrawScale,m_fLightingScaleFactor,Owner,Texture,DrawScale3D,m_fLightingAdditiveAmbiant;
	reliable if ( ( !m_bUseRagdoll &&  !bSkipActorPropertyReplication || bNetInitial) && (Role == Role_Authority ) && bNetDirty && (DrawType == 2) )
		AmbientGlow,bUnlit,Mesh,PrePivot;
	reliable if ( ( !m_bUseRagdoll &&  !bSkipActorPropertyReplication || bNetInitial) && (Role == Role_Authority ) && ( !bNetOwner ||  !bClientAnim) && (AmbientSound != None) )
		SoundPitch,SoundRadius,m_szSoundBoneName;
	reliable if ( ( !m_bUseRagdoll &&  !bSkipActorPropertyReplication || bNetInitial) && (Role == Role_Authority ) && bNetDirty && (LightType != 0) )
		LightEffect,LightHue,LightSaturation,LightPeriod,LightPhase,bSpecialLit,LightBrightness,LightRadius;
	reliable if ( ( !m_bUseRagdoll &&  !bSkipActorPropertyReplication || bNetInitial) && (Role == Role_Authority ) )
		bHidden;
	reliable if ( Role == Role_Authority )
		m_bUseRagdoll,m_fAttachFactor;
	reliable if ( ( !m_bUseRagdoll &&  !bSkipActorPropertyReplication || bNetInitial) && (Role == Role_Authority ) && bNetDirty && (bCollideActors || bCollideWorld) )
		bBlockActors,bBlockPlayers,bProjTarget,CollisionRadius,CollisionHeight;
	reliable if ( (Role == Role_Authority ) && bNetInitial )
		bActorShadows;
	reliable if ( ( !m_bUseRagdoll &&  !bSkipActorPropertyReplication || bNetInitial) && bReplicateMovement && (RemoteRole <= ROLE_SimulatedProxy) && (Physics == 5) )
		bFixedRotationDir,bRotateToDesired,RotationRate,DesiredRotation;
	reliable if ( ( !m_bUseRagdoll &&  !bSkipActorPropertyReplication || bNetInitial) && (Role == Role_Authority ) && bNetDirty && bReplicateInstigator )
		Instigator;
	reliable if ( ( !m_bUseRagdoll &&  !bSkipActorPropertyReplication || bNetInitial) && (Role == Role_Authority ) && ( !bNetOwner ||  !bClientAnim) )
		AmbientSound;
	reliable if ( ( !m_bUseRagdoll &&  !bSkipActorPropertyReplication || bNetInitial) && bReplicateMovement && (RemoteRole <= 2) || m_bForceBaseReplication &&  !bNetOwner && (Role == Role_Authority) )
		Base;
	reliable if ( ( !m_bUseRagdoll &&  !bSkipActorPropertyReplication || bNetInitial) && (Role == Role_Authority) && bNetDirty && (DrawType == 8) )
		StaticMesh;
	reliable if ( Role == Role_Authority )
		m_collisionBox,m_collisionBox2;
	reliable if ( ( !m_bUseRagdoll &&  !bSkipActorPropertyReplication || bNetInitial) && bReplicateMovement && (RemoteRole <= ROLE_SimulatedProxy) && (Base != None) &&  !Base.bWorldGeometry || m_bForceBaseReplication &&  !bNetOwner && (Role == Role_Authority) )
		AttachmentBone,RelativeLocation,RelativeRotation;
	reliable if ( ( !m_bUseRagdoll &&  !bSkipActorPropertyReplication || bNetInitial) && bReplicateMovement && ((RemoteRole == Role_AutonomousProxy) && bNetInitial || (RemoteRole == ROLE_SimulatedProxy) && (bNetInitial || bUpdateSimulatedPosition) && ((Base == None) || Base.bWorldGeometry) || (RemoteRole == ROLE_DumbProxy) && ((Base == None) || Base.bWorldGeometry)) )
		Location;
	reliable if ( ( !m_bUseRagdoll &&  !bSkipActorPropertyReplication || bNetInitial) && bReplicateMovement && ((DrawType == 2) || (DrawType == 8)) && ((RemoteRole == 3) && bNetInitial || (RemoteRole == ROLE_SimulatedProxy) && (bNetInitial || bUpdateSimulatedPosition) && ((Base == None) || Base.bWorldGeometry) || (RemoteRole == 1) && ((Base == None) || Base.bWorldGeometry)) )
		Rotation;
	reliable if ( ( !m_bUseRagdoll &&  !bSkipActorPropertyReplication || bNetInitial) && bReplicateMovement && ((RemoteRole == ROLE_SimulatedProxy) && (bNetInitial || bUpdateSimulatedPosition) || (RemoteRole == 1) && (Physics == 2)) )
		Velocity;
	reliable if ( ( !m_bUseRagdoll &&  !bSkipActorPropertyReplication || bNetInitial) && (Role == Role_Authority) && (DrawType == 2) && bReplicateAnimations )
		SimAnim;
}

native function string ConsoleCommand (string Command);

native(2008) final function GetTagInformations (string TagName, out Vector outVector, out Rotator OutRotator, optional float vOwnerScale);

native(1505) final function DbgVectorReset (int vectorIndex);

native(1506) final function DbgVectorAdd (Vector vPoint, Vector vCylinder, int vectorIndex, optional string szDef);

native(1801) final function DbgAddLine (Vector vStart, Vector vEnd, Color cColor);

native(1513) final function bool IsAvailableInGameType (ER6GameType eGameType);

native(1230) final function GetFPlayerMenuInfo (int Index, out PlayerMenuInfo _iPlayerMenuInfo);

native(1231) final function SetFPlayerMenuInfo (int Index, PlayerMenuInfo _iPlayerMenuInfo);

native(1232) final function GetPlayerSetupInfo (out string m_CharacterName, out string m_ArmorName, out string m_WeaponNameOne, out string m_WeaponGadgetNameOne, out string m_BulletTypeOne, out string m_WeaponNameTwo, out string m_WeaponGadgetNameTwo, out string m_BulletTypeTwo, out string m_GadgetNameOne, out string m_GadgetNameTwo);

native(1233) final function SetPlayerSetupInfo (string m_CharacterName, string m_ArmorName, string m_WeaponNameOne, string m_WeaponGadgetNameOne, string m_BulletTypeOne, string m_WeaponNameTwo, string m_WeaponGadgetNameTwo, string m_BulletTypeTwo, string m_GadgetNameOne, string m_GadgetNameTwo);

native(1279) final function SortFPlayerMenuInfo (int LastIndex, int iGameType);

native(1524) static final function R6ModMgr GetModMgr ();

native(1009) static final function R6GameOptions GetGameOptions ();

native(1012) static final function float GetTime ();

native(2614) static final function int GetNbAvailableResolutions ();

native(2615) static final function GetAvailableResolution (int Index, out int Width, out int Height, out int RefreshRate);

native(1200) static final function bool NativeStartedByGSClient ();

native(1316) static final function bool NativeNonUbiMatchMakingHost ();

native(1303) static final function bool NativeNonUbiMatchMaking ();

native(1304) static final function NativeNonUbiMatchMakingAddress (out string RemoteIpAddress);

native(1305) static final function NativeNonUbiMatchMakingPassword (out string NonUbiPassword);

native(1273) static final function R6ServerInfo GetServerOptions ();

native(1283) static final function R6ServerInfo SaveServerOptions (optional string FileName);

native(1302) static final function R6MissionDescription GetMissionDescription ();

native(1311) static final function SetServerBeacon (InternetInfo ServerBeacon);

native(1312) static final function InternetInfo GetServerBeacon ();

native(1400) static final function bool IsPBClientEnabled ();

native(1401) static final function SetPBStatus (bool _bDisable, bool _bServerStatus);

native(2613) static final function LoadLoadingScreen (string MapName, Texture pTex0, Texture pTex1);

native(2616) static final function bool ReplaceTexture (string FileName, Texture pTex);

native(1256) final function ER6GameType ConvertGameTypeIntToEnum (int iGameType);

native(1419) static final function string GetGameVersion (optional bool _bShortVersion);

native(2617) static final function bool IsVideoHardwareAtLeast64M ();

native(2618) static final function Canvas GetCanvas ();

native(2619) static final function EnableLoadingScreen (bool _enable);

native(2620) static final function AddMessageToConsole (string Msg, Color MsgColor);

native(2621) static final function UpdateGraphicOptions ();

native(2622) static final function GarbageCollect ();

native(1519) static final function string GetMapNameExt ();

native(1520) static final function string ConvertIntTimeToString (int iTimeToConvert, optional bool bAlignMinOnTwoDigits);

native(1522) static final function string GlobalIDToString (byte aBytes[16]);

native(1523) static final function GlobalIDToBytes (string szIn, out byte aBytes[255]);

native(2607) static final function Object LoadRandomBackgroundImage (optional string _szBackGroundSubFolder);

simulated event bool GetReticuleInfo (Pawn ownerReticule, out string szName)
{
	return False;
}

simulated event bool ProcessHeart (float DeltaSeconds, out float fMul1, out float fMul2);

native(233) final function Error (coerce string S);

native(256) final latent function Sleep (float Seconds);

native(262) final function SetCollision (optional bool NewColActors, optional bool NewBlockActors, optional bool NewBlockPlayers);

native(283) final function bool SetCollisionSize (float NewRadius, float NewHeight);

native final function SetDrawScale (float NewScale);

native final function SetDrawScale3D (Vector NewScale3D);

native final function SetStaticMesh (StaticMesh NewStaticMesh);

native final function SetDrawType (EDrawType NewDrawType);

native(266) final function bool Move (Vector Delta);

native(267) final function bool SetLocation (Vector NewLocation, optional bool bNoCheck);

native(299) final function bool SetRotation (Rotator NewRotation);

native final function bool SetRelativeRotation (Rotator NewRotation);

native final function bool SetRelativeLocation (Vector NewLocation);

native(3969) final function bool MoveSmooth (Vector Delta);

native(3971) final function AutonomousPhysics (float DeltaSeconds);

native(298) final function SetBase (Actor NewBase, optional Vector NewFloor);

native(272) final function SetOwner (Actor NewOwner);

native(259) final function PlayAnim (name Sequence, optional float Rate, optional float TweenTime, optional int Channel, optional bool bBackward, optional bool bForceAnimRate);

native(260) final function LoopAnim (name Sequence, optional float Rate, optional float TweenTime, optional int Channel, optional bool bBackward, optional bool bForceAnimRate);

native(294) final function TweenAnim (name Sequence, float Time, optional int Channel);

native(282) final function bool IsAnimating (optional int Channel);

native(261) final latent function FinishAnim (optional int Channel);

native(263) final function bool HasAnim (name Sequence);

native final function StopAnimating (optional bool ClearAllButBase);

native final function FreezeAnimAt (float Time, optional int Channel);

native final function bool IsTweening (int Channel);

native(1805) final function ClearChannel (int iChannel);

native(1500) final function name GetAnimGroup (name Sequence);

event AnimEnd (int Channel);

native final function EnableChannelNotify (int Channel, int Switch);

native final function int GetNotifyChannel ();

native final simulated function LinkSkelAnim (MeshAnimation Anim, optional Mesh NewMesh);

native final simulated function LinkMesh (Mesh NewMesh, optional bool bKeepAnim);

native(2210) final function UnLinkSkelAnim ();

native final simulated function AnimBlendParams (int Stage, optional float BlendAlpha, optional float InTime, optional float OutTime, optional name BoneName);

native final function AnimBlendToAlpha (int Stage, float TargetAlpha, float TimeInterval);

native(2208) final function float GetAnimBlendAlpha (int Stage);

native(1501) final function bool WasSkeletonUpdated ();

native final simulated function Coords GetBoneCoords (name BoneName, optional bool bDontCallGetFrame);

native final function Rotator GetBoneRotation (name BoneName, optional int Space);

native final function Vector GetRootLocation ();

native final function Rotator GetRootRotation ();

native final function Vector GetRootLocationDelta ();

native final function Rotator GetRootRotationDelta ();

native final function bool AttachToBone (Actor Attachment, name BoneName);

native final function bool DetachFromBone (Actor Attachment);

native final function LockRootMotion (int Lock, optional bool bUseRootRotation);

native final function SetBoneScale (int Slot, optional float BoneScale, optional name BoneName);

native final function SetBoneDirection (name BoneName, Rotator BoneTurn, optional Vector BoneTrans, optional float Alpha);

native final function SetBoneLocation (name BoneName, optional Vector BoneTrans, optional float Alpha);

native final function GetAnimParams (int Channel, out name OutSeqName, out float OutAnimFrame, out float OutAnimRate);

native final function bool AnimIsInGroup (int Channel, name GroupName);

native final function SetBoneRotation (name BoneName, optional Rotator BoneTurn, optional int Space, optional float Alpha, optional float InTime);

native final function Plane GetRenderBoundingSphere ();

native(301) final latent function FinishInterpolation ();

native(3970) final function SetPhysics (EPhysics newPhysics);

native final function OnlyAffectPawns (bool B);

native final function KSetMass (float Mass);

native final function float KGetMass ();

native final function KSetInertiaTensor (Vector it1, Vector it2);

native final function KGetInertiaTensor (out Vector it1, out Vector it2);

native final function KSetDampingProps (float lindamp, float angdamp);

native final function KGetDampingProps (out float lindamp, out float angdamp);

native final function KSetFriction (float friction);

native final function float KGetFriction ();

native final function KSetRestitution (float rest);

native final function float KGetRestitution ();

native final function KSetCOMOffset (Vector offset);

native final function KGetCOMOffset (out Vector offset);

native final function KGetCOMPosition (out Vector pos);

native final function KSetImpactThreshold (float thresh);

native final function float KGetImpactThreshold ();

native final function KWake ();

native final function bool KIsAwake ();

native final function KAddImpulse (Vector Impulse, Vector Position, optional name BoneName);

native final function KSetStayUpright (bool stayUpright, bool allowRotate);

native final function KSetBlockKarma (bool newBlock);

native final function KSetActorGravScale (float ActorGravScale);

native final function float KGetActorGravScale ();

native final function KDisableCollision (Actor Other);

native final function KEnableCollision (Actor Other);

native final function KSetSkelVel (Vector Velocity, optional Vector AngVelocity, optional bool AddToCurrent);

native final function float KGetSkelMass ();

native final function KFreezeRagdoll ();

native final function KAddBoneLifter (name BoneName, InterpCurve LiftVel, float LateralFriction, InterpCurve Softness);

native final function KRemoveLifterFromBone (name BoneName);

native final function KRemoveAllBoneLifters ();

native final function KMakeRagdollAvailable ();

native final function bool KIsRagdollAvailable ();

event KImpact (Actor Other, Vector pos, Vector impactVel, Vector impactNorm);

event KVelDropBelow ();

event KSkelConvulse ();

event KApplyForce (out Vector Force, out Vector Torque);

native final function bool PlayMusic (Sound Music, optional bool bForcePlayMusic);

native final function bool StopMusic (Sound StopMusic);

native final function StopAllMusic ();

event Destroyed ()
{
	if ( Shadow != None )
	{
		Shadow.Destroy();
	}
}

event GainedChild (Actor Other);

event LostChild (Actor Other);

event Tick (float DeltaTime);

event Trigger (Actor Other, Pawn EventInstigator);

event UnTrigger (Actor Other, Pawn EventInstigator);

event BeginEvent ();

event EndEvent ();

event Timer ();

event HitWall (Vector HitNormal, Actor HitWall);

event Falling ();

event Landed (Vector HitNormal);

event ZoneChange (ZoneInfo NewZone);

event PhysicsVolumeChange (PhysicsVolume NewVolume);

event Touch (Actor Other);

event PostTouch (Actor Other);

event UnTouch (Actor Other);

event Bump (Actor Other);

event BaseChange ();

event Attach (Actor Other);

event Detach (Actor Other);

event Actor SpecialHandling (Pawn Other);

event bool EncroachingOn (Actor Other);

event EncroachedBy (Actor Other);

event FinishedInterpolation ()
{
	bInterpolating=False;
}

event EndedRotation ();

event UsedBy (Pawn User);

function SetAttachVar (Actor AttachActor, string StaticMeshTag, name PawnTag);

function MatineeAttach ();

function MatineeDetach ();

event FellOutOfWorld ()
{
	SetPhysics(PHYS_None);
	Destroy();
}

event KilledBy (Pawn EventInstigator);

event TakeDamage (int Damage, Pawn EventInstigator, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType);

native(277) final function Actor Trace (out Vector HitLocation, out Vector HitNormal, Vector TraceEnd, optional Vector TraceStart, optional bool bTraceActors, optional Vector Extent, optional out Material Material);

native(1806) final function Actor R6Trace (out Vector HitLocation, out Vector HitNormal, Vector TraceEnd, optional Vector TraceStart, optional int iTraceFlags, optional Vector Extent, optional out Material Material);

native(1800) final function bool FindSpot (out Vector vLocation, optional Vector vExtent);

native(548) final function bool FastTrace (Vector TraceEnd, optional Vector TraceStart);

native(278) final function Actor Spawn (Class<Actor> SpawnClass, optional Actor SpawnOwner, optional name SpawnTag, optional Vector SpawnLocation, optional Rotator SpawnRotation, optional bool bNoCollisionFail);

native(279) final function bool Destroy ();

event TornOff ();

native(280) final function SetTimer (float NewTimerRate, bool bLoop);

native(264) final function PlaySound (Sound Sound, optional ESoundSlot Slot);

native(2725) final function StopSound (Sound Sound);

native(2703) final function bool IsPlayingSound (Actor aActor, Sound Sound);

native(2704) final function bool ResetVolume_AllTypeSound ();

native(2720) final function bool ResetVolume_TypeSound (ESoundSlot eSlot);

native(2705) final function ChangeVolumeType (ESoundSlot eSlot, float fVolume);

native(2712) final function StopAllSounds ();

native(2716) final function AddSoundBank (string szBank, ELoadBankSound eLBS);

native(2717) final function AddAndFindBankInSound (Sound Sound, ELoadBankSound eLBS);

native(2719) final function StopAllSoundsActor (Actor aActor);

native(2721) final function FadeSound (float fTime, int iFade, ESoundSlot eSlot);

native(2722) final function SaveCurrentFadeValue ();

native(2723) final function ReturnSavedFadeValue (float fTime);

native final simulated function PlayOwnedSound (Sound Sound, optional ESoundSlot Slot, optional float Volume, optional bool bNoOverride, optional float Radius, optional float Pitch, optional bool Attenuate);

native simulated event DemoPlaySound (Sound Sound, optional ESoundSlot Slot, optional float Volume, optional bool bNoOverride, optional float Radius, optional float Pitch, optional bool Attenuate);

native final function float GetSoundDuration (Sound Sound);

native(512) final function MakeNoise (float Loudness, optional ENoiseType eNoise, optional EPawnType ePawn);

event R6MakeNoise (ESoundType eType)
{
	if ( eType == 0 )
	{
		return;
	}
	if ( Level.Game != None )
	{
		Level.Game.R6GameInfoMakeNoise(eType,self);
	}
	else
	{
		Log("Warning: Call to R6MakeNoise when game is not the server");
		Log("         From " $ string(Name) $ " in the state " $ string(GetStateName()));
	}
}

function R6MakeNoise2 (float fLoudness, ENoiseType eNoise, EPawnType ePawn)
{
	MakeNoise(fLoudness,eNoise,ePawn);
}

native(532) final function bool PlayerCanSeeMe ();

event bool PreTeleport (Teleporter InTeleporter);

event PostTeleport (Teleporter OutTeleporter);

event BeginPlay ();

native(539) final function string GetMapName (string NameEnding, string MapName, int Dir);

native(545) final function GetNextSkin (string Prefix, string CurrentSkin, int Dir, out string SkinName, out string SkinDesc);

native(547) final function string GetURLMap ();

native final function string GetNextInt (string ClassName, int Num);

native final function GetNextIntDesc (string ClassName, int Num, out string Entry, out string Description);

native final function bool GetCacheEntry (int Num, out string Guid, out string FileName);

native final function bool MoveCacheEntry (string Guid, optional string NewFilename);

native(304) final iterator function AllActors (Class<Actor> BaseClass, out Actor Actor, optional name MatchTag);

native(313) final iterator function DynamicActors (Class<Actor> BaseClass, out Actor Actor, optional name MatchTag);

native(305) final iterator function ChildActors (Class<Actor> BaseClass, out Actor Actor);

native(306) final iterator function BasedActors (Class<Actor> BaseClass, out Actor Actor);

native(307) final iterator function TouchingActors (Class<Actor> BaseClass, out Actor Actor);

native(309) final iterator function TraceActors (Class<Actor> BaseClass, out Actor Actor, out Vector HitLoc, out Vector HitNorm, Vector End, optional Vector Start, optional Vector Extent);

native(310) final iterator function RadiusActors (Class<Actor> BaseClass, out Actor Actor, float Radius, optional Vector Loc);

native(311) final iterator function VisibleActors (Class<Actor> BaseClass, out Actor Actor, optional float Radius, optional Vector Loc);

native(312) final iterator function VisibleCollidingActors (Class<Actor> BaseClass, out Actor Actor, float Radius, optional Vector Loc, optional bool bIgnoreHidden);

native(321) final iterator function CollidingActors (Class<Actor> BaseClass, out Actor Actor, float Radius, optional Vector Loc);

native(549) static final operator(20) Color - (Color A, Color B);

native(550) static final operator(16) Color * (float A, Color B);

native(551) static final operator(20) Color + (Color A, Color B);

native(552) static final operator(16) Color * (Color A, float B);

native(2011) final function SetPlanningMode (bool bDraw);

native(2014) final function bool InPlanningMode ();

native(2012) final function SetFloorToDraw (int iFloor);

native(2610) final function RenderLevelFromMe (int iXMin, int iYMin, int iXSize, int iYSize);

native(2608) final function DrawDashedLine (Vector vStart, Vector vEnd, Color Col, float fDashSize);

native(2609) final function DrawText3D (Vector vPos, coerce string pString);

function RenderOverlays (Canvas Canvas);

event PreBeginPlay ()
{
	if ( (Level.Game != None) && Level.Game.m_bGameStarted )
	{
		m_bSpawnedInGame=True;
	}
	if (  !bGameRelevant && (Level.NetMode != 3) &&  !Level.Game.BaseMutator.CheckRelevance(self) )
	{
		Destroy();
	}
}

event BroadcastLocalizedMessage (Class<LocalMessage> MessageClass, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	Level.Game.BroadcastLocalized(self,MessageClass,Switch,RelatedPRI_1,RelatedPRI_2,OptionalObject);
}

event PostBeginPlay ();

simulated event SetInitialState ()
{
	bScriptInitialized=True;
	if ( InitialState != 'None' )
	{
		GotoState(InitialState);
	}
	else
	{
		GotoState('Auto');
	}
}

simulated function FirstPassReset ();

event PostNetBeginPlay ();

simulated event SaveAndResetData ()
{
	SaveOriginalData();
	ResetOriginalData();
}

final simulated function HurtRadius (float DamageAmount, float DamageRadius, Class<DamageType> DamageType, float Momentum, Vector HitLocation)
{
	local Actor Victims;
	local float damageScale;
	local float dist;
	local Vector Dir;

	if ( bHurtEntry )
	{
		return;
	}
	bHurtEntry=True;
	foreach VisibleCollidingActors(Class'Actor',Victims,DamageRadius,HitLocation)
	{
		if ( (Victims != self) && (Victims.Role == Role_Authority) )
		{
			Dir=Victims.Location - HitLocation;
			dist=FMax(1.00,VSize(Dir));
			Dir=Dir / dist;
			damageScale=1.00 - FMax(0.00,(dist - Victims.CollisionRadius) / DamageRadius);
			Victims.TakeDamage(damageScale * DamageAmount,Instigator,Victims.Location - 0.50 * (Victims.CollisionHeight + Victims.CollisionRadius) * Dir,damageScale * Momentum * Dir,DamageType);
		}
	}
	bHurtEntry=False;
}

event TravelPreAccept ();

event TravelPostAccept ();

function BecomeViewTarget ();

function string GetItemName (string FullName)
{
	local int pos;

	pos=InStr(FullName,".");
	While ( pos != -1 )
	{
		FullName=Right(FullName,Len(FullName) - pos - 1);
		pos=InStr(FullName,".");
	}
	return FullName;
}

function string GetHumanReadableName ()
{
	return GetItemName(string(Class));
}

final function ReplaceText (out string Text, string Replace, string With)
{
	local int i;
	local string Input;

	Input=Text;
	Text="";
	i=InStr(Input,Replace);
	while (i!=-1)
	{
		Text=Text $ Left(Input,i) $ With;
		Input=Mid(Input,i + Len(Replace));
		i=InStr(Input,Replace);
	}
	Text=Text $ Input;
}

function SetDisplayProperties (ERenderStyle NewStyle, Material NewTexture, bool bLighting)
{
	Style=NewStyle;
	Texture=NewTexture;
	bUnlit=bLighting;
}

function SetDefaultDisplayProperties ()
{
	Style=Default.Style;
	Texture=Default.Texture;
	bUnlit=Default.bUnlit;
}

static function string GetLocalString (optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
	return "";
}

function MatchStarting ();

function string GetDebugName ()
{
	return GetItemName(string(self));
}

simulated function DisplayDebug (Canvas Canvas, out float YL, out float YPos)
{
	local string t;
	local float XL;
	local int i;
	local Actor A;
	local name Anim;
	local float frame;
	local float Rate;

	Canvas.Style=1;
	Canvas.StrLen("TEST",XL,YL);
	YPos=YPos + YL;
	Canvas.SetPos(4.00,YPos);
	Canvas.SetDrawColor(255,0,0);
	t=GetDebugName();
	if ( bDeleteMe )
	{
		t=t $ " DELETED (bDeleteMe == true)";
	}
	Canvas.DrawText(t,False);
	YPos += YL;
	Canvas.SetPos(4.00,YPos);
	Canvas.SetDrawColor(255,255,255);
	if ( Level.NetMode != 0 )
	{
		t="ROLE ";
		switch (Role)
		{
			case Role_None:
			t=t $ "None";
			break;
			case Role_DumbProxy:
			t=t $ "DumbProxy";
			break;
			case Role_SimulatedProxy:
			t=t $ "SimulatedProxy";
			break;
			case Role_AutonomousProxy:
			t=t $ "AutonomousProxy";
			break;
			case Role_Authority:
			t=t $ "Authority";
			break;
			default:
		}
		t=t $ " REMOTE ROLE ";
		switch (RemoteRole)
		{
			case Role_None:
			t=t $ "None";
			break;
			case Role_DumbProxy:
			t=t $ "DumbProxy";
			break;
			case Role_SimulatedProxy:
			t=t $ "SimulatedProxy";
			break;
			case Role_AutonomousProxy:
			t=t $ "AutonomousProxy";
			break;
			case Role_Authority:
			t=t $ "Authority";
			break;
			default:
		}
		if ( bTearOff )
		{
			t=t $ " Tear Off";
		}
		Canvas.DrawText(t,False);
		YPos += YL;
		Canvas.SetPos(4.00,YPos);
	}
	t="Physics ";
	switch (Physics)
	{
		case PHYS_None:
		t=t $ "None";
		break;
		case PHYS_Walking:
		t=t $ "Walking";
		break;
		case PHYS_Falling:
		t=t $ "Falling";
		break;
		case PHYS_Swimming:
		t=t $ "Swimming";
		break;
		case PHYS_Flying:
		t=t $ "Flying";
		break;
		case PHYS_Rotating:
		t=t $ "Rotating";
		break;
		case PHYS_Projectile:
		t=t $ "Projectile";
		break;
		case PHYS_Interpolating:
		t=t $ "Interpolating";
		break;
		case PHYS_MovingBrush:
		t=t $ "MovingBrush";
		break;
		case PHYS_Spider:
		t=t $ "Spider";
		break;
		case PHYS_Trailer:
		t=t $ "Trailer";
		break;
		case PHYS_Ladder:
		t=t $ "Ladder";
		break;
		default:
	}
	t=t $ " in physicsvolume " $ GetItemName(string(PhysicsVolume)) $ " on base " $ GetItemName(string(Base));
	if ( bBounce )
	{
		t=t $ " - will bounce";
	}
	Canvas.DrawText(t,False);
	YPos += YL;
	Canvas.SetPos(4.00,YPos);
	Canvas.DrawText("Location: " $ string(Location) $ " Rotation " $ string(Rotation),False);
	YPos += YL;
	Canvas.SetPos(4.00,YPos);
	Canvas.DrawText("Velocity: " $ string(Velocity) $ " Speed " $ string(VSize(Velocity)),False);
	YPos += YL;
	Canvas.SetPos(4.00,YPos);
	Canvas.DrawText("Acceleration: " $ string(Acceleration),False);
	YPos += YL;
	Canvas.SetPos(4.00,YPos);
	Canvas.DrawColor.B=0;
	Canvas.DrawText("Collision Radius " $ string(CollisionRadius) $ " Height " $ string(CollisionHeight));
	YPos += YL;
	Canvas.SetPos(4.00,YPos);
	Canvas.DrawText("Collides with Actors " $ string(bCollideActors) $ ", world " $ string(bCollideWorld) $ ", proj. target " $ string(bProjTarget));
	YPos += YL;
	Canvas.SetPos(4.00,YPos);
	Canvas.DrawText("Blocks Actors " $ string(bBlockActors) $ ", players " $ string(bBlockPlayers));
	YPos += YL;
	Canvas.SetPos(4.00,YPos);
	t="Touching ";
	foreach TouchingActors(Class'Actor',A)
	{
		t=t $ GetItemName(string(A)) $ " ";
	}
	if ( t == "Touching " )
	{
		t="Touching nothing";
	}
	Canvas.DrawText(t,False);
	YPos += YL;
	Canvas.SetPos(4.00,YPos);
	Canvas.DrawColor.R=0;
	t="Rendered: ";
	switch (Style)
	{
		case STY_None:
		t=t;
		break;
		case STY_Normal:
		t=t $ "Normal";
		break;
		case STY_Masked:
		t=t $ "Masked";
		break;
		case STY_Translucent:
		t=t $ "Translucent";
		break;
		case STY_Modulated:
		t=t $ "Modulated";
		break;
		case STY_Alpha:
		t=t $ "Alpha";
		break;
		default:
	}
	switch (DrawType)
	{
		case DT_None:
		t=t $ " None";
		break;
		case DT_Sprite:
		t=t $ " Sprite ";
		break;
		case DT_Mesh:
		t=t $ " Mesh ";
		break;
		case DT_Brush:
		t=t $ " Brush ";
		break;
		case DT_RopeSprite:
		t=t $ " RopeSprite ";
		break;
		case DT_VerticalSprite:
		t=t $ " VerticalSprite ";
		break;
		case DT_Terraform:
		t=t $ " Terraform ";
		break;
		case DT_SpriteAnimOnce:
		t=t $ " SpriteAnimOnce ";
		break;
		case DT_StaticMesh:
		t=t $ " StaticMesh ";
		break;
		default:
	}
	if ( DrawType == DT_Mesh )
	{
		t=t $ string(Mesh);
		if ( Skins.Length > 0 )
		{
			t=t $ " skins: ";
			for (i=0;i<Skins.Length;i++)
			{
				if ( Skins[i] == None )
				{
					break;
				}
				else
				{
					t=t $ string(Skins[i]) $ ", ";
				}
			}
		}
		Canvas.DrawText(t,False);
		YPos += YL;
		Canvas.SetPos(4.00,YPos);
		GetAnimParams(0,Anim,frame,Rate);
		t="AnimSequence " $ string(Anim) $ " Frame " $ string(frame) $ " Rate " $ string(Rate);
		if ( bAnimByOwner )
		{
			t=t $ " Anim by Owner";
		}
	}
	else
	{
		if ( (DrawType == DT_Sprite) || (DrawType == DT_SpriteAnimOnce) )
		{
			t=t $ string(Texture);
		}
		else
		{
			if ( DrawType == DT_Brush )
			{
				t=t $ string(Brush);
			}
		}
	}
	Canvas.DrawText(t,False);
	YPos += YL;
	Canvas.SetPos(4.00,YPos);
	Canvas.DrawColor.B=255;
	Canvas.DrawText("Tag: " $ string(Tag) $ " Event: " $ string(Event) $ " STATE: " $ string(GetStateName()),False);
	YPos += YL;
	Canvas.SetPos(4.00,YPos);
	Canvas.DrawText("Instigator " $ GetItemName(string(Instigator)) $ " Owner " $ GetItemName(string(Owner)));
	YPos += YL;
	Canvas.SetPos(4.00,YPos);
	Canvas.DrawText("Timer: " $ string(TimerCounter) $ " LifeSpan " $ string(LifeSpan) $ " AmbientSound " $ string(AmbientSound));
	YPos += YL;
	Canvas.SetPos(4.00,YPos);
}

final simulated function bool NearSpot (Vector Spot)
{
	local Vector Dir;

	Dir=Location - Spot;
	if ( Abs(Dir.Z) > CollisionHeight )
	{
		return False;
	}
	Dir.Z=0.00;
	return VSize(Dir) <= CollisionRadius;
}

final simulated function bool TouchingActor (Actor A)
{
	local Vector Dir;

	Dir=Location - A.Location;
	if ( Abs(Dir.Z) > CollisionHeight + A.CollisionHeight )
	{
		return False;
	}
	Dir.Z=0.00;
	return VSize(Dir) <= CollisionRadius + A.CollisionRadius;
}

simulated function StartInterpolation ()
{
	GotoState('None');
	SetCollision(True,False,False);
	bCollideWorld=False;
	bInterpolating=True;
	SetPhysics(PHYS_None);
}

function Reset ();

event TriggerEvent (name EventName, Actor Other, Pawn EventInstigator)
{
	local Actor A;

	if ( (EventName == 'None') || (EventName == 'None') )
	{
		return;
	}
	foreach DynamicActors(Class'Actor',A,EventName)
	{
		A.Trigger(Other,EventInstigator);
	}
}

function UntriggerEvent (name EventName, Actor Other, Pawn EventInstigator)
{
	local Actor A;

	if ( (EventName == 'None') || (EventName == 'None') )
	{
		return;
	}
	foreach DynamicActors(Class'Actor',A,EventName)
	{
		A.UnTrigger(Other,EventInstigator);
	}
}

function bool IsInVolume (Volume aVolume)
{
	local Volume V;

	foreach TouchingActors(Class'Volume',V)
	{
		if ( V == aVolume )
		{
			return True;
		}
	}
	return False;
}

function bool IsInPain ()
{
	local PhysicsVolume V;

	foreach TouchingActors(Class'PhysicsVolume',V)
	{
		if ( V.bPainCausing && (V.DamagePerSec > 0) )
		{
			return True;
		}
	}
	return False;
}

function PlayTeleportEffect (bool bOut, bool bSound);

function bool CanSplash ()
{
	return False;
}

function Vector GetCollisionExtent ()
{
	local Vector Extent;

	Extent=CollisionRadius * vect(1.00,1.00,0.00);
	Extent.Z=CollisionHeight;
	return Extent;
}

event R6QueryCircumstantialAction (float fDistance, out R6AbstractCircumstantialActionQuery Query, PlayerController PlayerController)
{
	Query.iHasAction=0;
}

simulated function string R6GetCircumstantialActionString (int iAction)
{
	return "";
}

function R6CircumstantialActionProgressStart (R6AbstractCircumstantialActionQuery Query);

function int R6GetCircumstantialActionProgress (R6AbstractCircumstantialActionQuery Query, Pawn actingPawn)
{
	return 0;
}

function R6CircumstantialActionCancel ();

simulated function bool R6ActionCanBeExecuted (int iAction)
{
	return True;
}

function R6FillSubAction (out R6AbstractCircumstantialActionQuery Query, int iSubMenu, int iAction)
{
	Query.iTeamSubActionsIDList[iSubMenu * 4 + 0]=iAction;
	Query.iTeamSubActionsIDList[iSubMenu * 4 + 1]=iAction;
	Query.iTeamSubActionsIDList[iSubMenu * 4 + 2]=iAction;
	Query.iTeamSubActionsIDList[iSubMenu * 4 + 3]=iAction;
}

function int R6TakeDamage (int iKillValue, int iStunValue, Pawn instigatedBy, Vector vHitLocation, Vector vMomentum, int iBulletToArmorModifier, optional int iBulletGoup)
{
	if ( m_bBulletGoThrough == True )
	{
		return iKillValue;
	}
	else
	{
		return 0;
	}
}

static function float GetRandomTweenNum (out RandomTweenNum R)
{
	R.m_fResult=FRand() * (R.m_fMax - R.m_fMin);
	R.m_fResult += R.m_fMin;
	return R.m_fResult;
}

function Actor R6GetRootActor ()
{
	if ( m_AttachedTo != None )
	{
		return m_AttachedTo.R6GetRootActor();
	}
	return self;
}

function AddSoundBankName (string szBank)
{
	local bool bFind;
	local int i;

	for (i=0;i < Level.Game.m_BankListToLoad.Length;i++)
	{
		if ( Level.Game.m_BankListToLoad[i] == szBank )
		{
			bFind=True;
			break;
		}
	}
	if ( !bFind )
	{
		Level.Game.m_BankListToLoad[Level.Game.m_BankListToLoad.Length]=szBank;
	}
}

function ServerSendBankToLoad ()
{
	local Controller lpController;
	local int i;

	for (i=0;i < Level.Game.m_BankListToLoad.Length;i++)
	{
		for (lpController=Level.ControllerList;lpController != None;lpController=lpController.nextController)
		{
			if ( lpController.IsA('PlayerController') )
			{
				lpController.ClientAddSoundBank(Level.Game.m_BankListToLoad[i]);
			}
		}
	}
}

function ClientAddSoundBank (string szBank)
{
	AddSoundBank(szBank,LBS_UC);
}

simulated function SaveOriginalData ();

simulated function ResetOriginalData ();

function LogResetSystem (bool bSaving)
{
	if ( bSaving )
	{
		Log("SAVING: " $ string(Name) $ " in " $ string(Class.Name));
	}
	else
	{
		Log("RESETTING: " $ string(Name) $ " in " $ string(Class.Name));
	}
}

simulated function dbgLogActor (bool bVerbose)
{
	Log("Name= " $ string(Name));
}

defaultproperties
{
    Role=Role_Authority
    RemoteRole=ROLE_DumbProxy
    DrawType=1
    MaxLights=4
    Style=1
    SoundPitch=64
    m_eDisplayFlag=2
    m_HeatIntensity=64
    m_wNbTickSkipped=255
    m_iPlanningFloor_0=-1
    m_iPlanningFloor_1=-1
    bReplicateMovement=True
    m_bAllowLOD=True
    bMovable=True
    m_b3DSound=True
    bJustTeleported=True
    m_bIsRealtime=True
    m_bOutlinedInPlanning=True
    LODBias=1.00
    m_fSoundRadiusSaturation=300.00
    m_fSoundRadiusActivation=2000.00
    m_fSoundRadiusLinearFadeDist=1000.00
    m_fSoundRadiusLinearFadeEnd=2900.00
    DrawScale=1.00
    m_fLightingScaleFactor=1.00
    SoundRadius=64.00
    TransientSoundVolume=1.00
    m_fCircumstantialActionRange=175.00
    Mass=100.00
    NetPriority=1.00
    NetUpdateFrequency=100.00
    bCoronaMUL2XFactor=0.50
    m_fCoronaMaxSize=100000.00
    m_fAttachFactor=1.00
    MessageClass=Class'LocalMessage'
    DrawScale3D=(X=1.00,Y=1.00,Z=1.00)
    m_PlanningColor=(R=255,G=250,B=244,A=255)
}
/*
    Texture=Texture'S_Actor'
*/
