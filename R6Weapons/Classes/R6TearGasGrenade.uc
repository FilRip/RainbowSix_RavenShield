//================================================================================
// R6TearGasGrenade.
//================================================================================
class R6TearGasGrenade extends R6Grenade;

var bool m_bGrenadeExploded;
var float m_fExpansionTime;
var float m_fStartTime;

function Timer ()
{
	local R6SmokeCloud pCloud;

	if (  !m_bGrenadeExploded )
	{
		SetTimer(0.50,True);
		m_fStartTime=Level.TimeSeconds;
		if ( m_eGrenadeType == 1 )
		{
			pCloud=Spawn(Class'R6SmokeCloud',,,Location + vect(0.00,0.00,130.00),rot(0,0,0));
			pCloud.SetCloud(self,20.00,500.00,35.00);
		}
		m_bGrenadeExploded=True;
		Explode();
		return;
	}
	HurtPawns();
}

simulated function Explode ()
{
	local Light pEffectLight;
	local Class<Emitter> pExplosionParticles;

	pExplosionParticles=GetGrenadeEmitter();
	if ( pExplosionParticles != None )
	{
		m_pEmmiter=Spawn(pExplosionParticles);
		m_pExplosionParticles=None;
		m_pExplosionParticlesLOW=None;
	}
	if ( m_pExplosionLight != None )
	{
		pEffectLight=Spawn(m_pExplosionLight);
		m_pExplosionLight=None;
	}
	if ( m_eGrenadeType == 2 )
	{
		bHidden=True;
	}
	Super.Explode();
}

simulated event Destroyed ()
{
	Super.Destroyed();
}

function HurtPawns ()
{
	local R6Pawn aPawn;
	local float fElapsedTime;
	local float fVisibilityRadius;
	local float fMessageRadius;

	fElapsedTime=Level.TimeSeconds - m_fStartTime;
	if ( fElapsedTime > m_fDuration )
	{
		SetTimer(0.00,False);
		SelfDestroy();
		return;
	}
	if ( (m_eGrenadeType == 1) && (Physics != 0) )
	{
		if ( m_pEmmiter != None )
		{
			m_pEmmiter.SetLocation(Location);
		}
	}
	if ( fElapsedTime < m_fExpansionTime )
	{
		fElapsedTime=fElapsedTime / m_fExpansionTime;
		fMessageRadius=m_fKillBlastRadius + fElapsedTime * (m_fExplosionRadius - m_fKillBlastRadius);
	}
	else
	{
		fMessageRadius=m_fExplosionRadius;
	}
	foreach VisibleCollidingActors(Class'R6Pawn',aPawn,fMessageRadius,Location + vect(0.00,0.00,125.00))
	{
		if ( aPawn.IsAlive() &&  !aPawn.m_bHaveGasMask )
		{
//			aPawn.AffectedByGrenade(self,m_eGrenadeType);
			if ( m_eGrenadeType == GTYPE_TearGas )
			{
				if ( aPawn.m_fRepDecrementalBlurValue == 300 )
				{
					aPawn.m_fRepDecrementalBlurValue=301.00;
				}
				else
				{
					aPawn.m_fRepDecrementalBlurValue=300.00;
				}
				aPawn.m_fDecrementalBlurValue=aPawn.m_fRepDecrementalBlurValue;
			}
		}
	}
}

defaultproperties
{
    m_fExpansionTime=2.00
    m_eExplosionSoundType=3
    m_eGrenadeType=2
    m_iNumberOfFragments=0
    m_fDuration=60.00
    m_pExplosionParticles=Class'R6SFX.R6TearsGazGrenadeEffect'
    m_DmgPercentStand=(fHead=-151888246865920.00,fBody=0.00,fArms=0.50,fLegs=-107553240.00)
    m_DmgPercentCrouch=(fHead=-71.57,fBody=0.00,fArms=0.25,fLegs=-151888213311488.00)
    m_DmgPercentProne=(fHead=0.00,fBody=0.00,fArms=0.02,fLegs=-107553240.00)
    m_iEnergy=0
    m_fKillStunTransfer=0.35
    m_fExplosionRadius=400.00
    m_fKillBlastRadius=100.00
    m_fExplosionDelay=2.00
    m_szAmmoName="Tear Gas Grenade"
    m_szBulletType="GRENADE"
    DrawScale=1.50
}
/*
    StaticMesh=StaticMesh'R63rdWeapons_SM.Grenades.R63rdGrenadeTearGas'
    m_sndExplosionSound=Sound'Grenade_Gas.Play_GasGrenade_Expl'
    m_sndExplosionSoundStop=Sound'Grenade_Gas.Stop_Go_Gas_Silence'
*/

