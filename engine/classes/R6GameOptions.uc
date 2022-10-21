//================================================================================
// R6GameOptions.
//================================================================================
class R6GameOptions extends Object
	Native
//	Export
	Config(User);

enum EGameOptionsEffectLevel {
	eEL_None,
	eEL_Low,
	eEL_Medium,
	eEL_High
};

enum EGameOptionsGraphicLevel {
	eGL_Low,
	eGL_Medium,
	eGL_High
};

enum EGameOptionsNetSpeed {
	eNS_T1,
	eNS_T3,
	eNS_Cable,
	eNS_ADSL,
	eNS_Modem
};

enum EGameOptionsAudioVirtual {
	eAV_High,
	eAV_Low,
	eAV_None
};

var config EGameOptionsAudioVirtual AudioVirtual;
var config EGameOptionsNetSpeed NetSpeed;
var config EGameOptionsGraphicLevel TextureDetail;
var config EGameOptionsGraphicLevel LightmapDetail;
var config EGameOptionsGraphicLevel RainbowsDetail;
var config EGameOptionsGraphicLevel HostagesDetail;
var config EGameOptionsGraphicLevel TerrosDetail;
var config EGameOptionsEffectLevel RainbowsShadowLevel;
var config EGameOptionsEffectLevel HostagesShadowLevel;
var config EGameOptionsEffectLevel TerrosShadowLevel;
var config EGameOptionsEffectLevel GoreLevel;
var config EGameOptionsEffectLevel DecalsDetail;
var config int AutoTargetSlider;
var config int AmbientVolume;
var config int VoicesVolume;
var config int MusicVolume;
var config int SndQuality;
var config int Gender;
var config int ChangeNameTime;
var config int R6ScreenSizeX;
var config int R6ScreenSizeY;
var config int R6ScreenRefreshRate;
var bool EAXCompatible;
var bool m_bChangeResolution;
var bool m_bPBInstalled;
var config bool SplashScreen;
var bool UnlimitedPractice;
var config bool AlwaysRun;
var config bool InvertMouse;
var config bool Hide3DView;
var config bool PopUpLoadPlan;
var config bool PopUpQuickPlay;
var config bool SndHardware;
var config bool EAX;
var config bool HUDShowCharacterInfo;
var config bool HUDShowCurrentTeamInfo;
var config bool HUDShowOtherTeamInfo;
var config bool HUDShowWeaponInfo;
var config bool HUDShowFPWeapon;
var config bool HUDShowReticule;
var config bool HUDShowWaypointInfo;
var config bool HUDShowActionIcon;
var config bool HUDShowPlayersName;
var config bool ShowRadar;
var config bool AnimatedGeometry;
var config bool HideDeadBodies;
var config bool ShowRefreshRates;
var config bool LowDetailSmoke;
var config bool AllowChangeResInGame;
var config float CountDownDelayTime;
var config float MouseSensitivity;
var config Color m_reticuleFriendColour;
var config Color HUDMPColor;
var config Color HUDMPDarkColor;
var config string MPAutoSelection;
var config string characterName;
var config string ArmPatchTexture;

function ResetGameToDefault ()
{
	ResetConfig("AlwaysRun");
	ResetConfig("InvertMouse");
	ResetConfig("Hide3DView");
	ResetConfig("MouseSensitivity");
	ResetConfig("AutoTargetSlider");
	ResetConfig("PopUpLoadPlan");
	ResetConfig("PopUpQuickPlay");
}

function ResetSoundToDefault (bool _bInGame)
{
	ResetConfig("AmbientVolume");
	ResetConfig("MovementVolume");
	ResetConfig("VoicesVolume");
	ResetConfig("MusicVolume");
	ResetConfig("SndHardware");
	ResetConfig("EAX");
	ResetConfig("AudioVirtual");
	if (  !_bInGame )
	{
		ResetConfig("SndQuality");
	}
}

function ResetGraphicsToDefault (bool _bInGame)
{
	ResetConfig("R6ScreenSizeX");
	ResetConfig("R6ScreenSizeY");
	ResetConfig("R6ScreenRefreshRate");
	ResetConfig("TextureDetail");
	ResetConfig("LightmapDetail");
	ResetConfig("RainbowsDetail");
	ResetConfig("TerrosDetail");
	ResetConfig("HostagesDetail");
	ResetConfig("AnimatedGeometry");
	ResetConfig("HideDeadBodies");
	ResetConfig("ShowRefreshRates");
	ResetConfig("LowDetailSmoke");
	if (  !_bInGame )
	{
		ResetConfig("RainbowsShadowLevel");
		ResetConfig("HostagesShadowLevel");
		ResetConfig("TerrosShadowLevel");
		ResetConfig("DecalsDetail");
		ResetConfig("GoreLevel");
	}
}

function ResetMultiToDefault ()
{
	ResetConfig("CharacterName");
	ResetConfig("NetSpeed");
	ResetConfig("Gender");
	ResetConfig("ArmPatchTexture");
}

function ResetHudToDefault ()
{
	ResetConfig("HUDShowCharacterInfo");
	ResetConfig("HUDShowCurrentTeamInfo");
	ResetConfig("HUDShowOtherTeamInfo");
	ResetConfig("HUDShowWeaponInfo");
	ResetConfig("HUDShowFPWeapon");
	ResetConfig("HUDShowReticule");
	ResetConfig("HUDShowWaypointInfo");
	ResetConfig("HUDShowActionIcon");
	ResetConfig("HUDShowPlayersName");
	ResetConfig("ShowRadar");
}

defaultproperties
{
    AudioVirtual=2
    NetSpeed=2
    TextureDetail=2
    LightmapDetail=2
    RainbowsDetail=2
    HostagesDetail=2
    TerrosDetail=2
    RainbowsShadowLevel=1
    GoreLevel=3
    DecalsDetail=2
    AutoTargetSlider=1
    AmbientVolume=100
    VoicesVolume=100
    MusicVolume=100
    SndQuality=1
    ChangeNameTime=60
    R6ScreenSizeX=1024
    R6ScreenSizeY=768
    R6ScreenRefreshRate=-1
    PopUpLoadPlan=True
    PopUpQuickPlay=True
    SndHardware=True
    HUDShowCharacterInfo=True
    HUDShowCurrentTeamInfo=True
    HUDShowOtherTeamInfo=True
    HUDShowWeaponInfo=True
    HUDShowFPWeapon=True
    HUDShowReticule=True
    HUDShowWaypointInfo=True
    HUDShowActionIcon=True
    HUDShowPlayersName=True
    ShowRadar=True
    MouseSensitivity=16.00
    m_reticuleFriendColour=(R=0,G=255,B=0,A=0)
    HUDMPColor=(R=239,G=209,B=129,A=75)
    characterName="JOHNDOE"
}