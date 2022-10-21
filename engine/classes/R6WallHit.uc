//================================================================================
// R6WallHit.
//================================================================================
class R6WallHit extends R6DecalsBase
	Native
	Abstract;

enum EHitType {
	HIT_Impact,
	HIT_Ricochet,
	HIT_Exit
};

var(Rainbow) ESoundType m_eSoundType;
var EHitType m_eHitType;
var(Rainbow) bool m_bGoreLevelHigh;
var bool m_bPlayEffectSound;
var(Rainbow) Sound m_ImpactSound;
var(Rainbow) Sound m_ExitSound;
var(Rainbow) Sound m_RicochetSound;
var(Rainbow) Class<R6SFX> m_pSparksIn;
var(Rainbow) array<Texture> m_DecalTexture;

replication
{
	reliable if ( Role == Role_Authority )
		m_bPlayEffectSound;
}

simulated function FirstPassReset ()
{
	Destroy();
}

defaultproperties
{
    m_eSoundType=2
    m_bPlayEffectSound=True
    bHidden=True
    bNetOptional=True
    m_bDeleteOnReset=True
    LifeSpan=5.00
    Texture=None
}