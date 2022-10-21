//================================================================================
// R6BreachingChargeUnit.
//================================================================================
class R6BreachingChargeUnit extends R6DemolitionsUnit;

function bool DestroyedByImpact ()
{
	R6IORotatingDoor(Owner).RemoveBreach(self);
	return Super.DestroyedByImpact();
}

function HurtPawns ()
{
	local R6InteractiveObject anObject;
	local R6Pawn aPawn;
	local R6Pawn aPawnInstigator;
	local R6DemolitionsUnit aDemoUnit;
	local float fDistFromCharge;
	local Vector vExplosionMomentum;
	local Vector vDoorCenter;
	local Vector vActorDir;
	local Vector vFacingDir;
	local Rotator rDoorInit;
	local int _iHealth;
	local int _PawnsHurtCount;
	local bool _bCompilingStats;
	local Controller aC;
	local R6PlayerController aPC;
	local float fDistFromGrenade;
	local Actor HitActor;
	local Vector vHitLocation;
	local Vector vHitNormal;

	aPawnInstigator=R6Pawn(Instigator);
	vDoorCenter=R6IORotatingDoor(Owner).m_vVisibleCenter;
	_PawnsHurtCount=0;
	_bCompilingStats=R6AbstractGameInfo(Level.Game).m_bCompilingStats;
	if ( DrawScale3D.Y > 0 )
	{
		vFacingDir=vector(Rotation) Cross vect(0.00,0.00,-1.00);
	}
	else
	{
		vFacingDir=vector(Rotation) Cross vect(0.00,0.00,1.00);
	}
	foreach VisibleCollidingActors(Class'R6DemolitionsUnit',aDemoUnit,m_fKillBlastRadius,Location)
	{
		if ( aDemoUnit != self )
		{
			aDemoUnit.DestroyedByImpact();
		}
	}
	R6IORotatingDoor(Owner).R6TakeDamage(m_iEnergy,0,Instigator,vect(0.00,0.00,0.00),vFacingDir,0);
	foreach CollidingActors(Class'R6Pawn',aPawn,m_fExplosionRadius + 800.00,vDoorCenter)
	{
		if ( (Level.NetMode != 0) && ( !aPawnInstigator.m_bCanFireFriends && aPawnInstigator.IsFriend(aPawn) ||  !aPawnInstigator.m_bCanFireNeutrals && aPawnInstigator.IsNeutral(aPawn)) )
		{
			continue;
		}
		else
		{
			if ( aPawn.m_eHealth != 3 )
			{
				HitActor=aPawn.R6Trace(vHitLocation,vHitNormal,vDoorCenter,aPawn.Location,2 | 4 | 32);
				if ( HitActor != None )
				{
					HitActor=aPawn.R6Trace(vHitLocation,vHitNormal,vDoorCenter,aPawn.Location + aPawn.EyePosition(),2 | 4 | 32);
				}
				if ( HitActor != None )
				{
					continue;
				}
				else
				{
					fDistFromCharge=VSize(aPawn.Location - vDoorCenter);
					vActorDir=Normal(aPawn.Location - vDoorCenter);
					vExplosionMomentum=(aPawn.Location - vDoorCenter) * 0.25;
					if ( vActorDir Dot vFacingDir < 0 )
					{
						if ( fDistFromCharge < m_fExplosionRadius * 0.50 )
						{
							if ( (aPawnInstigator != None) &&  !aPawnInstigator.IsFriend(aPawn) )
							{
								_PawnsHurtCount++;
								R6AbstractGameInfo(Level.Game).IncrementRoundsFired(aPawnInstigator,_bCompilingStats);
							}
							aPawn.R6TakeDamage(0,m_iEnergy,Instigator,aPawn.Location,vExplosionMomentum,0);
						}
						continue;
					}
					else
					{
						if ( fDistFromCharge < m_fKillBlastRadius )
						{
							aPawn.ServerForceKillResult(4);
							aPawn.R6TakeDamage(m_iEnergy,m_iEnergy,Instigator,aPawn.Location,vExplosionMomentum,0);
							aPawn.ServerForceKillResult(0);
							if ( (aPawnInstigator != None) &&  !aPawnInstigator.IsFriend(aPawn) )
							{
								_PawnsHurtCount++;
								R6AbstractGameInfo(Level.Game).IncrementRoundsFired(aPawnInstigator,_bCompilingStats);
							}
						}
						else
						{
							if ( fDistFromCharge <= m_fExplosionRadius )
							{
								_iHealth=aPawn.m_eHealth;
								DistributeDamage(aPawn,Location);
								if ( (_iHealth != aPawn.m_eHealth) && (aPawnInstigator != None) &&  !aPawnInstigator.IsFriend(aPawn) )
								{
									R6AbstractGameInfo(Level.Game).IncrementRoundsFired(aPawnInstigator,_bCompilingStats);
								}
							}
							aPawn.AffectedByGrenade(self,GTYPE_BreachingCharge);
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
    m_iNumberOfFragments=1
    m_pExplosionParticles=Class'R6SFX.R6BreachingChargeEffect'
    m_pExplosionLight=Class'R6SFX.R6GrenadeLight'
    m_iEnergy=8000
    m_fExplosionRadius=200.00
    m_fKillBlastRadius=100.00
    m_szAmmoName="Breaching Charge"
    Physics=0
    m_bDrawFromBase=True
    bCollideWorld=False
}
/*
    m_sndExplosionSound=Sound'Gadget_BreachingCharge.Play_random_Breaching_Expl'
    StaticMesh=StaticMesh'R63rdWeapons_SM.Items.R63rdBreachingCharge'
*/

