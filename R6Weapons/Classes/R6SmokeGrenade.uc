//================================================================================
// R6SmokeGrenade.
//================================================================================
class R6SmokeGrenade extends R6TearGasGrenade;

defaultproperties
{
    m_fExpansionTime=10.00
    m_eGrenadeType=1
    m_pExplosionParticles=Class'R6SFX.R6SmokeGrenadeEffect'
    m_pExplosionParticlesLOW=Class'R6SFX.R6SmokeGrenadeEffectLOW'
    m_fExplosionRadius=600.00
    m_fKillBlastRadius=0.00
    m_fExplosionDelay=1.00
    m_szAmmoName="Smoke Grenade"
    LifeSpan=60.00
}
/*
    StaticMesh=StaticMesh'R63rdWeapons_SM.Grenades.R63rdGrenadeSmoke'
    m_sndExplosionSound=Sound'Grenade_Smoke.Play_SmokeGrenade_Expl'
    m_sndExplosionSoundStop=Sound'Grenade_Smoke.Stop_Go_SmokeSilence'
*/

