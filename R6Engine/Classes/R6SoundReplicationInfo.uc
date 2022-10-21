//================================================================================
// R6SoundReplicationInfo.
//================================================================================
class R6SoundReplicationInfo extends Actor
	Native;
//	NoNativeReplication;

enum EWeaponSound {
	WSOUND_None,
	WSOUND_Initialize,
	WSOUND_PlayTrigger,
	WSOUND_PlayFireSingleShot,
	WSOUND_PlayFireEndSingleShot,
	WSOUND_PlayFireThreeBurst,
	WSOUND_PlayFireFullAuto,
	WSOUND_PlayEmptyMag,
	WSOUND_PlayReloadEmpty,
	WSOUND_PlayReload,
	WSOUND_StopFireFullAuto
};

var byte m_CurrentWeapon;
var byte m_NewWeaponSound;
var byte m_NewPawnState;
var byte m_Material;
var byte m_pawnState;
var byte m_TeamColor;
var byte m_GunSoundType;
var byte m_StatusOtherTeam;
var byte m_LastPlayedWeaponSound;
var bool m_bInitialize;
var bool m_bLastSoundFullAuto;
var float m_fClientUpdateFrequency;
var float m_fClientLastUpdate;
var R6Pawn m_pawnOwner;
var R6PawnReplicationInfo m_PawnRepInfo;
var Vector m_Location;

replication
{
	reliable if ( Role == Role_Authority )
		m_CurrentWeapon,m_NewWeaponSound,m_pawnOwner,m_PawnRepInfo;
	reliable if ( Role == Role_Authority )
		m_NewPawnState,m_Material,m_Location;
}

native(2727) final function PlayWeaponSound (EWeaponSound EWeaponSound);

native(2728) final function StopWeaponSound ();

native(3000) final function PlayLocalWeaponSound (EWeaponSound EWeaponSound);

defaultproperties
{
    m_fClientUpdateFrequency=1.00
    RemoteRole=ROLE_AutonomousProxy
    DrawType=0
    bHidden=True
    bSkipActorPropertyReplication=True
    m_fSoundRadiusActivation=5600.00
    NetUpdateFrequency=10.00
}
