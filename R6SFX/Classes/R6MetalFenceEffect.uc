//================================================================================
// R6MetalFenceEffect.
//================================================================================
class R6MetalFenceEffect extends R6SFXWallHit;

defaultproperties
{
    m_ImpactSound=Sound'Bullet_Impacts.Play_Impact_MetalFence'
    m_RicochetSound=Sound'Bullet_Riccochets.Play_Ricco_MetalFence'
    m_pSparksIn=Class'R6MetalImpact'
}