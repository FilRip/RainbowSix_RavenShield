//================================================================================
// R6DecalManager.
//================================================================================
class R6DecalManager extends Actor
	Native;
//	NoNativeReplication;

enum eDecalType {
	DECAL_Footstep,
	DECAL_Bullet,
	DECAL_BloodSplats,
	DECAL_BloodBaths,
	DECAL_GrenadeDecals
};

var() bool m_bActive;
var() R6DecalGroup m_FootSteps;
var() R6DecalGroup m_WallHit;
var() R6DecalGroup m_BloodSplats;
var() R6DecalGroup m_BloodBaths;
var() R6DecalGroup m_GrenadeDecals;

native(2900) final function AddDecal (Vector Position, Rotator Rotation, Texture decalTexture, eDecalType type, int iFov, float fDuration, float fStartTime, float fMaxTraceDistance);

native(2901) final function KillDecal ();

simulated event Destroyed ()
{
	if ( m_FootSteps != None )
	{
		m_FootSteps.Destroy();
		m_FootSteps=None;
	}
	if ( m_WallHit != None )
	{
		m_WallHit.Destroy();
		m_WallHit=None;
	}
	if ( m_BloodSplats != None )
	{
		m_BloodSplats.Destroy();
		m_BloodSplats=None;
	}
	if ( m_BloodBaths != None )
	{
		m_BloodBaths.Destroy();
		m_BloodBaths=None;
	}
	if ( m_GrenadeDecals != None )
	{
		m_GrenadeDecals.Destroy();
		m_GrenadeDecals=None;
	}
	Super.Destroyed();
}

defaultproperties
{
    m_bActive=True
    bHidden=True
}