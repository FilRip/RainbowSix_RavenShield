//================================================================================
// R6SnowEffect.
//================================================================================
class R6SnowEffect extends R6SFXWallHit;

defaultproperties
{
    m_ImpactSound=Sound'Bullet_Impacts.Play_Impact_Snow'
    m_RicochetSound=Sound'Bullet_Impacts.Play_Impact_Snow'
    m_pSparksIn=Class'R6SnowImpact'
}