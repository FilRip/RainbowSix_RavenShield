//================================================================================
// R6ClaymoreUnit.
//================================================================================
class R6ClaymoreUnit extends R6DemolitionsUnit;

function HurtPawns ()
{
	local R6InteractiveObject anObject;
	local R6Pawn aPawn;
	local R6Pawn aPawnInstigator;
	local R6DemolitionsUnit aDemoUnit;
	local float fDistFromGrenade;
	local Vector vExplosionMomentum;
	local Vector vActorDir;
	local Vector vFacingDir;
	local int _iHealth;
	local int _PawnsHurtCount;
	local bool _bCompilingStats;
	local Controller aC;
	local R6PlayerController aPC;

	aPawnInstigator=R6Pawn(Instigator);
	_bCompilingStats=R6AbstractGameInfo(Level.Game).m_bCompilingStats;
	foreach VisibleCollidingActors(Class'R6DemolitionsUnit',aDemoUnit,m_fKillBlastRadius,Location)
	{
		if ( aDemoUnit != self )
		{
			aDemoUnit.DestroyedByImpact();
		}
	}
//	vFacingDir=Rotation + rot(0,32768,0);
	foreach VisibleCollidingActors(Class'R6InteractiveObject',anObject,m_fExplosionRadius,Location)
	{
		vActorDir=anObject.Location - Location;
		vActorDir.Z=0.00;
		vActorDir=Normal(vActorDir);
		fDistFromGrenade=VSize(anObject.Location - Location);
		if ( (fDistFromGrenade > m_fKillBlastRadius * 0.50) && (vActorDir Dot vFacingDir < 0.74) )
		{
			continue;
		}
		else
		{
			if ( fDistFromGrenade <= m_fExplosionRadius )
			{
				DistributeDamage(anObject,Location);
			}
		}
	}
	foreach CollidingActors(Class'R6Pawn',aPawn,m_fExplosionRadius,Location)
	{
		if ( (Level.NetMode != 0) && ( !aPawnInstigator.m_bCanFireFriends && aPawnInstigator.IsFriend(aPawn) ||  !aPawnInstigator.m_bCanFireNeutrals && aPawnInstigator.IsNeutral(aPawn)) )
		{
			continue;
		}
		else
		{
			if ( aPawn.m_eHealth != 3 )
			{
				if ( aPawn.PawnCanBeHurtFrom(Location) )
				{
					fDistFromGrenade=VSize(aPawn.Location - Location);
					vActorDir=aPawn.Location - Location;
					vActorDir.Z=0.00;
					vActorDir=Normal(vActorDir);
					if ( (fDistFromGrenade <= m_fKillBlastRadius * 0.50) || (vActorDir Dot vFacingDir > 0.74) && (fDistFromGrenade <= m_fKillBlastRadius) )
					{
						vExplosionMomentum=(aPawn.Location - Location) * 0.25;
						aPawn.ServerForceKillResult(4);
						aPawn.R6TakeDamage(m_iEnergy,m_iEnergy,aPawnInstigator,aPawn.Location,vExplosionMomentum,0);
						aPawn.ServerForceKillResult(0);
						if ( (aPawnInstigator != None) &&  !aPawnInstigator.IsFriend(aPawn) )
						{
							_PawnsHurtCount++;
							R6AbstractGameInfo(Level.Game).IncrementRoundsFired(aPawnInstigator,_bCompilingStats);
						}
					}
					else
					{
						if ( vActorDir Dot vFacingDir > 0.74 )
						{
							_iHealth=aPawn.m_eHealth;
							DistributeDamage(aPawn,Location);
							if ( (_iHealth != aPawn.m_eHealth) && (aPawnInstigator != None) &&  !aPawnInstigator.IsFriend(aPawn) )
							{
								_PawnsHurtCount++;
								R6AbstractGameInfo(Level.Game).IncrementRoundsFired(aPawnInstigator,_bCompilingStats);
							}
						}
					}
				}
			}
		}
	}
	if ( _PawnsHurtCount == 0 )
	{
		R6AbstractGameInfo(Level.Game).IncrementRoundsFired(aPawnInstigator,_bCompilingStats);
	}
	for (aC=Level.ControllerList;aC != None;aC=aC.nextController)
	{
		if ( (aC.Pawn != None) && (aC.Pawn.m_ePawnType == 1) && aC.Pawn.IsAlive() )
		{
			aPC=R6PlayerController(aC);
			if ( aPC != None )
			{
				fDistFromGrenade=VSize(Location - aPC.Pawn.Location);
				if ( fDistFromGrenade < m_fShakeRadius )
				{
					aPC.R6Shake(1.00,m_fShakeRadius - fDistFromGrenade,0.05);
//					aPC.ClientPlaySound(m_sndEarthQuake,3);
				}
			}
		}
	}
}

defaultproperties
{
    m_pExplosionParticles=Class'R6SFX.R6ClaymoreMineEffect'
    m_pExplosionLight=Class'R6SFX.R6GrenadeLight'
    m_iEnergy=2000
    m_fExplosionRadius=700.00
    m_fKillBlastRadius=400.00
    m_szAmmoName="Claymore Mine"
}
/*
    m_sndExplodeMetal=Sound'Gadget_Claymore.Play_Claymore_Expl_Metal'
    m_sndExplodeDirt=Sound'Gadget_Claymore.Play_Claymore_Expl_Dirt'
    StaticMesh=StaticMesh'R63rdWeapons_SM.Items.R63rdClaymore'
*/

