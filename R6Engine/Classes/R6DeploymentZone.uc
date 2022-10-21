//================================================================================
// R6DeploymentZone.
//================================================================================
class R6DeploymentZone extends Actor
	Native
	Abstract;
//	NoNativeReplication;

enum EDefCon {
	DEFCON_0,
	DEFCON_1,
	DEFCON_2,
	DEFCON_3,
	DEFCON_4,
	DEFCON_5
};

enum EEngageReaction {
	EREACT_Random,
	EREACT_AimedFire,
	EREACT_SprayFire,
	EREACT_RunAway,
	EREACT_Surrender
};

struct STTemplate
{
	var() string m_szName;
	var() int m_iChance;
};

var(R6DZoneTerrorist) EDefCon m_eDefCon;
var(R6DZoneTerrorist) EEngageReaction m_eEngageReaction;
var(R6DZoneTerrorist) int m_iGroupID;
var(R6DZoneTerrorist) int m_HostageShootChance;
var(R6DZoneTerrorist) int m_iMinTerrorist;
var(R6DZoneTerrorist) int m_iMaxTerrorist;
var(R6DZoneHostage) int m_iMinHostage;
var(R6DZoneHostage) int m_iMaxHostage;
var(Debug) bool m_bDontSeePlayer;
var(Debug) bool m_bDontHearPlayer;
var(Debug) bool m_bHearNothing;
var(R6DZoneTerrorist) bool m_bAllowLeave;
var(R6DZoneTerrorist) bool m_bPreventCrouching;
var(R6DZoneTerrorist) bool m_bKnowInPlanning;
var(R6DZoneTerrorist) bool m_bHuntDisallowed;
var(R6DZoneTerrorist) bool m_bHuntFromStart;
var bool m_bAlreadyInitialized;
var(R6DZoneTerrorist) R6InteractiveObject m_InteractiveObject;
var(R6DZoneTerrorist) editinlineuse array<int> m_iGroupIDsToCall;
var(R6DZoneTerrorist) array<R6DeploymentZone> m_HostageZoneToCheck;
var const array<R6Terrorist> m_aTerrorist;
var const array<R6Hostage> m_aHostage;
var(R6DZoneTerrorist) STTemplate m_Template[5];
var(R6DZoneHostage) STTemplate m_HostageTemplates[5];
const C_NB_Template= 5;

native(1830) final function FirstInit ();

native(1831) final function Vector FindRandomPointInArea ();

native(1832) final function bool IsPointInZone (Vector vPoint);

native(1833) final function Vector FindClosestPointTo (Vector vPoint);

native(1834) final function bool HaveTerrorist ();

native(1835) final function bool HaveHostage ();

native(1836) final function AddHostage (R6Hostage hostage);

native(1837) final function OrderTerroListFromDistanceTo (Vector vPoint);

native(1838) final function R6Hostage GetClosestHostage (Vector vPoint);

function InitZone ()
{
	FirstInit();
}

simulated function ResetOriginalData ()
{
	if ( m_bResetSystemLog )
	{
		LogResetSystem(False);
	}
	Super.ResetOriginalData();
	m_aTerrorist.Remove (0,m_aTerrorist.Length);
	m_aHostage.Remove (0,m_aHostage.Length);
}

defaultproperties
{
    m_eDefCon=3
    m_iMinTerrorist=1
    m_iMaxTerrorist=1
    m_bAllowLeave=True
    m_bKnowInPlanning=True
    bStatic=True
    bHidden=True
    bNoDelete=True
    m_bUseR6Availability=True
    DrawScale=3.00
    CollisionRadius=40.00
    CollisionHeight=85.00
}
/*
    Texture=Texture'R6Engine_T.Icons.DZoneTer'
*/

