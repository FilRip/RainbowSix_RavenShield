//================================================================================
// R6DemolitionsUnit.
//================================================================================
class R6DemolitionsUnit extends R6Grenade;

var bool m_bExploding;

function Activate ();

simulated function HitWall (Vector HitNormal, Actor Wall);

simulated function Landed (Vector HitNormal);

singular simulated function Touch (Actor Other);

simulated function ProcessTouch (Actor Other, Vector vHitLocation);

function Explode ()
{
	m_bExploding=True;
	Super.Explode();
	SelfDestroy();
}

function bool DestroyedByImpact ()
{
	Spawn(Class'R6BreakablePhone',None,,Location);
	m_Weapon.MyUnitIsDestroyed();
	m_bDestroyedByImpact=True;
	SelfDestroy();
	return True;
}

function DoorExploded ()
{
	if (  !m_bExploding )
	{
		DestroyedByImpact();
	}
}

function DistributeDamage (Actor anActor, Vector vLocationOfExplosion)
{
	local int iCurrentFragment;
	local float fCurrentNumberOfFragments;
	local Vector vHit;
	local Vector vHitNormal;
	local Vector vExplosionMomentum;
	local Vector vDamageLocation;
	local float fDistFromGrenade;
	local eGrenadeBoneTarget eBoneTarget;
	local float fDamagePercent;
	local float fEffectiveKillValue;
	local float fEffectiveStunValue;
	local R6IORotatingDoor pImADoor;

	fDistFromGrenade=VSize(anActor.Location - Location);
	fDamagePercent=1.00 - (fDistFromGrenade - m_fKillBlastRadius) / m_fEffectiveOutsideKillRadius;
	if ( bShowLog )
	{
		Log("Actor " $ string(anActor) $ " was hit by a grenade.  Distance : " $ string(fDistFromGrenade * 0.01));
	}
	if ( anActor.IsA('R6Pawn') )
	{
		fCurrentNumberOfFragments=m_iNumberOfFragments * fDamagePercent;
		iCurrentFragment=0;
		while ( iCurrentFragment < fCurrentNumberOfFragments )
		{
			eBoneTarget=HitRandomBodyPart(GetPawnPose(R6Pawn(anActor)));
			switch (eBoneTarget)
			{
/*				case 0:
				vDamageLocation=anActor.GetBoneCoords('R6 Head').Origin;
				break;
				case 1:
				vDamageLocation=anActor.GetBoneCoords('R6 Spine').Origin;
				break;
				case 2:
				vDamageLocation=anActor.GetBoneCoords('R6 L ForeArm').Origin;
				break;
				case 3:
				vDamageLocation=anActor.GetBoneCoords('R6 R ForeArm').Origin;
				break;
				case 4:
				vDamageLocation=anActor.GetBoneCoords('R6 L Thigh').Origin;
				break;
				case 5:
				vDamageLocation=anActor.GetBoneCoords('R6 R Thigh').Origin;
				break;
				default:   */
			}
			fDistFromGrenade=VSize(vDamageLocation - vLocationOfExplosion);
			fEffectiveKillValue=Max(m_iEnergy * fDamagePercent,0);
			if ( fEffectiveKillValue != 0 )
			{
				fEffectiveStunValue=fEffectiveKillValue + fEffectiveKillValue * m_fKillStunTransfer;
				vExplosionMomentum=vDamageLocation - vLocationOfExplosion;
				anActor.R6TakeDamage(fEffectiveKillValue,fEffectiveStunValue,Instigator,vDamageLocation,vExplosionMomentum,0);
			}
			iCurrentFragment++;
		}
	}
	else
	{
		pImADoor=R6IORotatingDoor(anActor);
		if ( pImADoor != None )
		{
			vDamageLocation=pImADoor.m_vVisibleCenter;
		}
		else
		{
			vDamageLocation=anActor.Location;
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
			vExplosionMomentum=vDamageLocation - vLocationOfExplosion;
			anActor.R6TakeDamage(fEffectiveKillValue,0,Instigator,vDamageLocation,vExplosionMomentum,0);
		}
	}
}

defaultproperties
{
    m_DmgPercentStand=(fHead=-151888246865920.00,fBody=0.00,fArms=0.50,fLegs=-107553240.00)
    m_DmgPercentCrouch=(fHead=-71.57,fBody=0.00,fArms=0.25,fLegs=-151888213311488.00)
    m_DmgPercentProne=(fHead=0.00,fBody=0.00,fArms=0.02,fLegs=-107553240.00)
    m_fKillStunTransfer=0.35
    m_fExplosionDelay=0.00
    m_szBulletType="DEMOLITIONS"
}
