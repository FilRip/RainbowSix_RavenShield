//================================================================================
// R6FragGrenade.
//================================================================================
class R6FragGrenade extends R6Grenade;

var float m_fTimerCounter;

function Activate ()
{
	if ( m_fExplosionDelay != 0 )
	{
		m_fTimerCounter=0.00;
		SetTimer(0.20,True);
	}
}

simulated event Timer ()
{
	local R6RainbowAI rainbowAI;
	local Controller aController;
	local R6Pawn aGrenadeOwner;
	local float fDangerZone;

	m_fTimerCounter += 0.20;
	if ( m_fTimerCounter >= m_fExplosionDelay )
	{
		Explode();
		SelfDestroy();
	}
	else
	{
		aGrenadeOwner=R6Pawn(Owner.Owner);
		if ( (aGrenadeOwner != None) && (aGrenadeOwner.m_ePawnType == 1) )
		{
			fDangerZone=m_fKillBlastRadius;
		}
		else
		{
			fDangerZone=m_fExplosionRadius;
		}
		aController=Level.ControllerList;
JL0096:
		if ( aController != None )
		{
			rainbowAI=R6RainbowAI(aController);
			if ( (rainbowAI == None) || (rainbowAI.Pawn == None) )
			{
				goto JL0168;
			}
			if ( VSize(Location - rainbowAI.Pawn.Location) < fDangerZone )
			{
				if ( (Velocity == vect(0.00,0.00,0.00)) || (Location.Z < rainbowAI.Pawn.Location.Z) )
				{
					rainbowAI.FragGrenadeInProximity(Location,m_fExplosionDelay - m_fTimerCounter,fDangerZone);
				}
			}
JL0168:
			aController=aController.nextController;
			goto JL0096;
		}
	}
}

function Explode ()
{
	local R6SmokeCloud pCloud;

	pCloud=Spawn(Class'R6SmokeCloud',,,Location + vect(0.00,0.00,125.00),rot(0,0,0));
	pCloud.SetCloud(self,1.50,150.00,4.00);
	SetTimer(0.00,False);
	Super.Explode();
}

function HurtPawns ()
{
	local R6InteractiveObject anObject;
	local R6DemolitionsUnit aDemoUnit;
	local R6Pawn aPawn;
	local R6Pawn aPawnInstigator;
	local eGrenadeBoneTarget eBoneTarget;
	local R6IORotatingDoor pImADoor;
	local float fDistFromGrenade;
	local float fDamagePercent;
	local float fEffectiveKillValue;
	local float fEffectiveStunValue;
	local Vector vDamageLocation;
	local Vector vExplosionMomentum;
	local int iCurrentFragment;
	local float fCurrentNumberOfFragments;
	local int _iHealth;
	local int _PawnsHurtCount;
	local bool _bCompilingStats;
	local Controller aC;
	local R6PlayerController aPC;

	aPawnInstigator=R6Pawn(Instigator);
	_bCompilingStats=R6AbstractGameInfo(Level.Game).m_bCompilingStats;
	foreach VisibleCollidingActors(Class'R6DemolitionsUnit',aDemoUnit,m_fKillBlastRadius,Location)
	{
		aDemoUnit.DestroyedByImpact();
	}
	foreach VisibleCollidingActors(Class'R6InteractiveObject',anObject,m_fExplosionRadius,Location)
	{
		fDistFromGrenade=VSize(anObject.Location - Location);
		if ( fDistFromGrenade <= m_fExplosionRadius )
		{
			pImADoor=R6IORotatingDoor(anObject);
			if ( pImADoor != None )
			{
				vDamageLocation=pImADoor.m_vVisibleCenter;
			}
			else
			{
				vDamageLocation=anObject.Location;
			}
			if ( fDistFromGrenade < m_fKillBlastRadius )
			{
				fEffectiveKillValue=Max(m_iEnergy,0);
			}
			else
			{
				fEffectiveKillValue=Max(m_iEnergy * fDamagePercent,0);
			}
			if ( fEffectiveKillValue != 0 )
			{
				vExplosionMomentum=vDamageLocation - Location;
				anObject.R6TakeDamage(fEffectiveKillValue,0,Instigator,vDamageLocation,vExplosionMomentum,0);
			}
		}
	}
	foreach CollidingActors(Class'R6Pawn',aPawn,m_fExplosionRadius,Location)
	{
		if ( (Level.NetMode != 0) && (aPawnInstigator.m_ePawnType == 1) && ( !aPawnInstigator.m_bCanFireFriends && aPawnInstigator.IsFriend(aPawn) ||  !aPawnInstigator.m_bCanFireNeutrals && aPawnInstigator.IsNeutral(aPawn)) )
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
					if ( fDistFromGrenade <= m_fKillBlastRadius )
					{
						vExplosionMomentum=(aPawn.Location - Location) * 0.25;
						aPawn.ServerForceKillResult(4);
						aPawn.R6TakeDamage(m_iEnergy,m_iEnergy,Instigator,aPawn.Location,vExplosionMomentum,0);
						aPawn.ServerForceKillResult(0);
						if ( (aPawnInstigator != None) &&  !aPawnInstigator.IsFriend(aPawn) )
						{
							_PawnsHurtCount++;
							R6AbstractGameInfo(Level.Game).IncrementRoundsFired(aPawnInstigator,_bCompilingStats);
						}
						if ( bShowLog )
						{
							Log("Pawn " $ string(aPawn) $ " was killed by a grenade !");
						}
					}
					else
					{
						fDamagePercent=1.00 - (fDistFromGrenade - m_fKillBlastRadius) / m_fEffectiveOutsideKillRadius;
						if ( bShowLog )
						{
							Log("Actor " $ string(aPawn) $ " was hit by a grenade.  Distance : " $ string(fDistFromGrenade * 0.01) $ " % : " $ string(fDamagePercent));
						}
						fCurrentNumberOfFragments=m_iNumberOfFragments * fDamagePercent;
						iCurrentFragment=0;
JL041F:
						if ( iCurrentFragment < fCurrentNumberOfFragments )
						{
							eBoneTarget=HitRandomBodyPart(GetPawnPose(aPawn));
							switch (eBoneTarget)
							{
								case GBT_Head:
								vDamageLocation=aPawn.GetBoneCoords('R6 Head').Origin;
								break;
								case GBT_Body:
								vDamageLocation=aPawn.GetBoneCoords('R6 Spine').Origin;
								break;
								case GBT_LeftArm:
								vDamageLocation=aPawn.GetBoneCoords('R6 L ForeArm').Origin;
								break;
								case GBT_RightArm:
								vDamageLocation=aPawn.GetBoneCoords('R6 R ForeArm').Origin;
								break;
								case GBT_LeftLeg:
								vDamageLocation=aPawn.GetBoneCoords('R6 L Thigh').Origin;
								break;
								case GBT_RightLeg:
								vDamageLocation=aPawn.GetBoneCoords('R6 R Thigh').Origin;
								break;
								default:
							}
							fDistFromGrenade=VSize(vDamageLocation - Location);
							fEffectiveKillValue=Max(m_iEnergy * fDamagePercent,0);
							if ( fEffectiveKillValue != 0 )
							{
								fEffectiveStunValue=fEffectiveKillValue + fEffectiveKillValue * m_fKillStunTransfer;
								vExplosionMomentum=vDamageLocation - Location;
								_iHealth=aPawn.m_eHealth;
								aPawn.R6TakeDamage(fEffectiveKillValue,fEffectiveStunValue,Instigator,vDamageLocation,vExplosionMomentum,0);
								if ( (_iHealth != aPawn.m_eHealth) && (aPawnInstigator != None) &&  !aPawnInstigator.IsFriend(aPawn) )
								{
									_PawnsHurtCount++;
									R6AbstractGameInfo(Level.Game).IncrementRoundsFired(aPawnInstigator,_bCompilingStats);
								}
							}
							iCurrentFragment++;
							goto JL041F;
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
	aC=Level.ControllerList;
JL06A9:
	if ( aC != None )
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
		aC=aC.nextController;
		goto JL06A9;
	}
}

defaultproperties
{
    m_pExplosionParticles=Class'R6SFX.R6FragGrenadeEffect'
    m_pExplosionLight=Class'R6SFX.R6GrenadeLight'
    m_GrenadeDecalClass=Class'R6Engine.R6GrenadeDecal'
    m_DmgPercentStand=(fHead=-151888246865920.00,fBody=0.00,fArms=0.50,fLegs=-107553240.00)
    m_DmgPercentCrouch=(fHead=-71.57,fBody=0.00,fArms=0.25,fLegs=-151888213311488.00)
    m_DmgPercentProne=(fHead=0.00,fBody=0.00,fArms=0.02,fLegs=-107553240.00)
    m_iEnergy=3000
    m_fKillStunTransfer=0.35
    m_fExplosionRadius=500.00
    m_fKillBlastRadius=300.00
    m_fExplosionDelay=2.50
    m_szAmmoName="Fragmentation Grenade"
    m_szBulletType="GRENADE"
    LifeSpan=2.70
    DrawScale=1.50
}
/*
    m_sndExplodeMetal=Sound'Grenade_Frag.Play_random_Frag_Expl_Metal'
    m_sndExplodeWater=Sound'Grenade_Frag.Play_Frag_Expl_Water'
    m_sndExplodeAir=Sound'Grenade_Frag.Play_Frag_Expl_Air'
    m_sndExplodeDirt=Sound'Grenade_Frag.Play_random_Frag_Expl_Dirt'
    StaticMesh=StaticMesh'R63rdWeapons_SM.Grenades.R63rdGrenadeHE'
*/

