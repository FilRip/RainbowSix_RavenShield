[Engine.R6Mod]
version=1
MinorVersion=53
BuildVersion=383
m_szKeyword=Prohibition
m_bInstalled=true
m_fPriority=1
m_szCampaignIniFile=ProhibitionCampaign
m_szCampaignDir=
m_szPlayerCustomMission=Prohibitionsave.cus
m_szServerIni=Prohibitionserver
m_szName=Prohibition
m_szModInfo=Prohibition
m_szNetGameName=Prohibition
m_ConfigClass=Prohibition.ProhibitionModConfig

// Classe controlleur du joueur
m_PlayerCtrlToSpawn=Prohibition.ProhibitionPlayerController

// Localization files

//Extra Packages
m_aDescriptionPackage=R6Description

// Games Modes
m_szGameTypes="Pro_TeamDeathmatchMode"

// Background Root Directory
m_szBackgroundRootDir=Prohibition\Backgrounds

// Videos Root
m_szVideosRootDir=Prohibition\Videos

// Ini files dir
m_szIniFilesDir=System

// Credits
m_szCreditsFile=ProhibitionCredits

//Menu class defines
m_szMenuDefinesFile=ProhibitionClassDefines

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
ServerPackages=Prohibition
ServerPackages=ProhibitionSFX
