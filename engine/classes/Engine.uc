//================================================================================
// Engine.
//================================================================================
class Engine extends Subsystem
	Native
	NoExport
	Transient;

const C_ConsoleMaxStrings= 32;
var(Drivers) config Class<AudioSubsystem> AudioDevice;
var(Drivers) config Class<Interaction> Console;
var(Drivers) config Class<NetDriver> NetworkDevice;
var(Drivers) config Class<Language> Language;
var Primitive Cylinder;
var const Client Client;
var const AudioSubsystem Audio;
var const RenderDevice GRenDev;
var int bShowFrameRate;
var int bShowRenderStats;
var int bShowHardwareStats;
var int bShowGameStats;
var int bShowAnimStats;
var int bShowNetStats;
var int bShowHistograph;
var int bShowXboxMemStats;
var int bShowMatineeStats;
var int bShowAudioStats;
var int TickCycles;
var int GameCycles;
var int ClientCycles;
var(Settings) config int CacheSizeMegs;
var(Settings) config bool UseSound;
var(Settings) float CurrentTickRate;
var int m_iCurrentDelta;
var float m_fDeltaTime;
var float m_fTotalTime;
var string m_szCampaignNameFromParam;
var(Colors) config Color C_WorldBox;
var(Colors) config Color C_GroundPlane;
var(Colors) config Color C_GroundHighlight;
var(Colors) config Color C_BrushWire;
var(Colors) config Color C_Pivot;
var(Colors) config Color C_Select;
var(Colors) config Color C_Current;
var(Colors) config Color C_AddWire;
var(Colors) config Color C_SubtractWire;
var(Colors) config Color C_GreyWire;
var(Colors) config Color C_BrushVertex;
var(Colors) config Color C_BrushSnap;
var(Colors) config Color C_Invalid;
var(Colors) config Color C_ActorWire;
var(Colors) config Color C_ActorHiWire;
var(Colors) config Color C_Black;
var(Colors) config Color C_White;
var(Colors) config Color C_Mask;
var(Colors) config Color C_SemiSolidWire;
var(Colors) config Color C_NonSolidWire;
var(Colors) config Color C_WireBackground;
var(Colors) config Color C_WireGridAxis;
var(Colors) config Color C_ActorArrow;
var(Colors) config Color C_ScaleBox;
var(Colors) config Color C_ScaleBoxHi;
var(Colors) config Color C_ZoneWire;
var(Colors) config Color C_Mover;
var(Colors) config Color C_OrthoBackground;
var(Colors) config Color C_StaticMesh;
var(Colors) config Color C_VolumeBrush;
var(Colors) config Color C_ConstraintLine;
var(Colors) config Color C_AnimMesh;
var(Colors) config Color C_TerrainWire;
var bool m_bProfStatsFps;
var bool m_bProfStatsTimers;
var bool m_bKarmaMemoryStats;
var bool m_bShowActorRenderStats;
var bool m_bShowActorTickStats;
var bool m_bShowActorTraceStats;
var bool m_bShowActorTracedStats;
var bool m_bFreezeActorStats;
var bool m_bShowStaticMeshSectionsDebugInfo;
var bool m_bUseStaticMeshBatcher;
var bool m_bShowNetChannelStats;
var bool m_bShowLightValue;
var bool m_bRunningFromEditor;
var bool m_bDisplayVersionInfo;
var bool m_bMultiScreenShot;
var bool m_bEnableLoadingScreen;
var bool m_bIsRecording;
var byte m_szMovieFileName[256];
var float m_fFakeDeltaTime;
var int m_lMovieFrame;
var int m_iCurrentMapNum;
var Class m_TickedClassStats;
var string m_ConsoleStrings[32];
var Color m_ConsoleStringsColors[32];
var int m_iConsoleNbStrings;

defaultproperties
{
    Console=Class'Console'
    CacheSizeMegs=2
    UseSound=True
    C_WorldBox=(R=107,G=0,B=0,A=255)
    C_GroundPlane=(R=63,G=0,B=0,A=255)
    C_GroundHighlight=(R=127,G=0,B=0,A=255)
    C_BrushWire=(R=63,G=63,B=255,A=255)
    C_Pivot=(R=0,G=255,B=0,A=255)
    C_Select=(R=127,G=0,B=0,A=255)
    C_Current=(R=0,G=0,B=0,A=255)
    C_AddWire=(R=255,G=127,B=127,A=255)
    C_SubtractWire=(R=63,G=192,B=255,A=255)
    C_GreyWire=(R=163,G=163,B=163,A=255)
    C_BrushVertex=(R=0,G=0,B=0,A=255)
    C_BrushSnap=(R=0,G=0,B=0,A=255)
    C_Invalid=(R=163,G=163,B=163,A=255)
    C_ActorWire=(R=0,G=63,B=127,A=255)
    C_ActorHiWire=(R=0,G=127,B=255,A=255)
    C_Black=(R=0,G=0,B=0,A=255)
    C_White=(R=255,G=255,B=255,A=255)
    C_Mask=(R=0,G=0,B=0,A=255)
    C_SemiSolidWire=(R=0,G=255,B=127,A=255)
    C_NonSolidWire=(R=32,G=192,B=63,A=255)
    C_WireBackground=(R=0,G=0,B=0,A=255)
    C_WireGridAxis=(R=119,G=119,B=119,A=255)
    C_ActorArrow=(R=0,G=0,B=163,A=255)
    C_ScaleBox=(R=11,G=67,B=151,A=255)
    C_ScaleBoxHi=(R=157,G=149,B=223,A=255)
    C_ZoneWire=(R=0,G=0,B=0,A=255)
    C_Mover=(R=255,G=0,B=255,A=255)
    C_OrthoBackground=(R=163,G=163,B=163,A=255)
    C_StaticMesh=(R=255,G=255,B=0,A=255)
    C_VolumeBrush=(R=225,G=196,B=255,A=255)
    C_ConstraintLine=(R=0,G=255,B=0,A=255)
    C_AnimMesh=(R=28,G=221,B=221,A=255)
    C_TerrainWire=(R=255,G=255,B=255,A=255)
    m_bUseStaticMeshBatcher=True
    m_bEnableLoadingScreen=True
}