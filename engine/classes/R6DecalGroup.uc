//================================================================================
// R6DecalGroup.
//================================================================================
class R6DecalGroup extends Actor
	Native;
//	NoNativeReplication;

enum eDecalType {
	DECAL_Footstep,
	DECAL_Bullet,
	DECAL_BloodSplats,
	DECAL_BloodBaths,
	DECAL_GrenadeDecals
};

var() eDecalType m_Type;
var() int m_MaxSize;
var int m_iDecalPos;
var() bool m_bActive;
var() array<R6Decal> m_Decals;

native(2902) final function AddDecal (Vector Position, Rotator Rotation, Texture decalTexture, int iFov, float fDuration, float fStartTime, float fMaxTraceDistance);

native(2903) final function KillDecal ();

native(2904) final function ActivateGroup ();

native(2905) final function DeActivateGroup ();

defaultproperties
{
    m_MaxSize=150
    bHidden=True
}