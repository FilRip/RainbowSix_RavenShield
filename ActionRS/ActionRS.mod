[Engine.R6Mod]
version=1
m_szKeyword=ActionRS
m_bInstalled=true
m_fPriority=1
m_szGameServiceGameName=ActionRS
m_szCampaignIniFile=ActionRSCampaign
m_szCampaignDir=
m_szPlayerCustomMission=ActionRSsave.cus
m_szServerIni=arsserver
m_szName=ActionRS
m_szModInfo=ActionRS
m_PlayerCtrlToSpawn=ARSPlayerController

// Localization files

//Extra Packages
m_aDescriptionPackage=R6Description

// Games Modes
m_eGameTypes=RGM_TeamDeathmatchMode

// Background Root Directory
m_szBackgroundRootDir=ActionRS\Backgrounds

// Videos Root
m_szVideosRootDir=ActionRS\Videos

// Ini files dir
m_szIniFilesDir=System

// Credits
m_szCreditsFile=ARSCredits

//Menu class defines
m_szMenuDefinesFile=ARSClassDefines

[Engine.GameEngine]
CacheSizeMegs=32
UseSound=True
ServerActors=IpDrv.UdpBeacon
ServerPackages=GamePlay
ServerPackages=R6Abstract
ServerPackages=R6Engine
ServerPackages=R6Characters
ServerPackages=R6GameService
ServerPackages=R6Game
ServerPackages=R61stWeapons
ServerPackages=R6Weapons
ServerPackages=R6WeaponGadgets
ServerPackages=R63rdWeapons
ServerPackages=ActionRS
