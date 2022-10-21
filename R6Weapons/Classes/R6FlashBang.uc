//================================================================================
// R6FlashBang.
//================================================================================
class R6FlashBang extends R6Grenade;

var float m_fBlindEffectRadius;

function HurtPawns ()
{
	local R6Pawn aPawn;
	local R6InteractiveObject anObject;
	local float fDistFromFlashbang;
	local float fEffectiveStunValue;
	local Vector vDamageLocation;
	local Vector vExplosionMomentum;
	local Vector vHitLocation;
	local Vector vHitNormal;
	local Actor HitActor;

	foreach CollidingActors(Class'R6Pawn',aPawn,m_fBlindEffectRadius,Location)
	{
		if ( aPawn.m_eHealth != 3 )
		{
			HitActor=aPawn.R6Trace(vHitLocation,vHitNormal,Location,aPawn.Location + aPawn.EyePosition(),1 | 2 | 4 | 32);
			if ( HitActor == None )
			{
				fDistFromFlashbang=VSize(aPawn.Location - Location);
				fEffectiveStunValue=m_iEnergy * (1 - fDistFromFlashbang / m_fBlindEffectRadius);
				vExplosionMomentum=(vDamageLocation - Location) * 0.25;
				vDamageLocation=aPawn.GetBoneCoords('R6 Head').Origin;
				aPawn.ServerForceStunResult(4);
				aPawn.R6TakeDamage(0,fEffectiveStunValue,Instigator,vDamageLocation,vExplosionMomentum,0);
				aPawn.ServerForceStunResult(0);
				aPawn.AffectedByGrenade(self,GTYPE_FlashBang);
			}
		}
	}
	foreach VisibleCollidingActors(Class'R6InteractiveObject',anObject,m_fExplosionRadius,Location)
	{
		if ( (anObject.m_bBreakableByFlashBang == True) && (anObject.m_iHitPoints > 0) )
		{
			anObject.R6TakeDamage(1000,fEffectiveStunValue,Instigator,anObject.Location,vect(0.00,0.00,0.00),0);
		}
	}
}

defaultproperties
{
    m_fBlindEffectRadius=5000.00
    m_eGrenadeType=3
    m_iNumberOfFragments=0
    m_pExplosionParticles=Class'R6SFX.R6FlashBangEffect'
    m_pExplosionLight=Class'R6SFX.R6GrenadeLight'
    m_iEnergy=4000
    m_fKillStunTransfer=0.35
    m_fExplosionRadius=500.00
    m_fExplosionDelay=2.00
    m_szAmmoName="FlashBang Grenade"
    m_szBulletType="GRENADE"
    LifeSpan=2.00
    DrawScale=1.50
}
/*
    m_sndExplosionSound=Sound'Grenade_FlashBang.Play_FlashBang_Expl'
    StaticMesh=StaticMesh'R63rdWeapons_SM.Grenades.R63rdGrenadeFlashbang'
*/

