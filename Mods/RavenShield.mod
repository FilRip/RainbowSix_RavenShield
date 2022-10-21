[Engine.R6Mod]
Version=1
MinorVersion=53
BuildVersion=383
m_szKeyword=RavenShield
m_bInstalled=true
m_fPriority=1
m_szCampaignIniFile=RavenShieldCampaign
m_szCampaignDir=
m_szPlayerCustomMission=Customsave.cus
m_szServerIni=server
m_ConfigClass=Engine.R6ModConfig

// Localization files

//Extra Packages
m_aDescriptionPackage=R6Description

// Games Modes
m_szGameTypes="RGM_StoryMode"
m_szGameTypes="RGM_PracticeMode"
m_szGameTypes="RGM_MissionMode"
m_szGameTypes="RGM_TerroristHuntMode"
m_szGameTypes="RGM_TerroristHuntCoopMode"
m_szGameTypes="RGM_HostageRescueMode"
m_szGameTypes="RGM_HostageRescueCoopMode"
m_szGameTypes="RGM_HostageRescueAdvMode"
m_szGameTypes="RGM_DeathmatchMode"
m_szGameTypes="RGM_TeamDeathmatchMode"
m_szGameTypes="RGM_BombAdvMode"
m_szGameTypes="RGM_EscortAdvMode"
m_szGameTypes="RGM_LoneWolfMode"

// Background Root Directory
m_szBackgroundRootDir=Backgrounds

// Videos Root
m_szVideosRootDir=Videos

// Ini files dir
m_szIniFilesDir=System

// Credits
m_szCreditsFile=R6Credits

//Menu class defines
m_szMenuDefinesFile=R6ClassDefines

[Engine.GameEngine]
CacheSizeMegs=32
UseSound=True
ServerActors=MutatorForRS.AddMutators
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
ServerPackages=MutatorForRS
ServerPackages=RSLightStick
