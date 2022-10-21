//================================================================================
// R6GenericHB.
//================================================================================
class R6GenericHB extends R6InteractiveObject
	Native
	Abstract;

var bool m_bFirstImpact;
var Sound m_ImpactSound;
var Sound m_ImpactGroundSound;
var Sound m_ImpactWaterSound;

simulated function SetSpeed (float fSpeed)
{
//	Velocity=fSpeed * Rotation;
//	Acceleration=Rotation * 50;
//	SetDrawType(DT_StaticMesh);
}

simulated event HitWall (Vector HitNormal, Actor Wall)
{
	local Vector vTraceEnd;
	local Rotator rotGrenade;
	local float fOldHeight;
	local Vector vHitLocation;
	local Vector vHitNormal;
	local Actor pHit;
	local Material HitMaterial;

	if ( Wall != None )
	{
		if ( (Instigator != None) && (Instigator.m_collisionBox == Wall) )
		{
			vTraceEnd=Location + 10 * Normal(Velocity);
			SetLocation(vTraceEnd,True);
			return;
		}
		if ( Wall.m_bBulletGoThrough && Wall.IsA('R6InteractiveObject') )
		{
			Wall.R6TakeDamage(10000,10000,Instigator,Wall.Location,Velocity,0);
			vTraceEnd=Location - 10 * HitNormal;
			SetLocation(vTraceEnd,True);
			Velocity *= 0.50;
			return;
		}
	}
	DesiredRotation=RotRand();
	Velocity=0.33 * MirrorVectorByNormal(Velocity,HitNormal);
	RotationRate.Yaw=1000 * VSize(Velocity) * FRand() - 500 * VSize(Velocity);
	RotationRate.Pitch=1000 * VSize(Velocity) * FRand() - 500 * VSize(Velocity);
	RotationRate.Roll=1000 * VSize(Velocity) * FRand() - 500 * VSize(Velocity);
	if ( Velocity.Z > 400 )
	{
		Velocity.Z=400.00;
	}
	else
	{
		if ( VSize(Velocity) < 50 )
		{
			SetPhysics(PHYS_None);
			bBounce=False;
		}
	}
	if ( m_bFirstImpact )
	{
		m_bFirstImpact=False;
		if ( Level.NetMode != 1 )
		{
			m_ImpactSound=m_ImpactGroundSound;
			pHit=Trace(vHitLocation,vHitNormal,Location - vect(0.00,0.00,40.00),Location,False,,HitMaterial);
			if ( (HitMaterial != None) && ((HitMaterial.m_eSurfIdForSnd == 12) || (HitMaterial.m_eSurfIdForSnd == 13)) )
			{
				m_ImpactSound=m_ImpactWaterSound;
			}
//			PlaySound(m_ImpactSound,3);
		}
	}
//	R6MakeNoise(SNDTYPE_GrenadeLike);
}

simulated function Landed (Vector HitNormal)
{
	HitWall(HitNormal,None);
}

singular simulated function Touch (Actor Other)
{
}

simulated function ProcessTouch (Actor Other, Vector vHitLocation)
{
	HitWall(vHitLocation,Other);
}

defaultproperties
{
    m_bFirstImpact=True
    m_ImpactGroundSound=Sound'Foley_CommonGrenade.Play_Grenades_GroundImpacts'
    m_iHitPoints=1
    m_bBlockCoronas=True
    Physics=2
    DrawType=8
    bNoDelete=False
    bSkipActorPropertyReplication=False
    bCollideWorld=True
    bProjTarget=True
    m_bPawnGoThrough=True
    bFixedRotationDir=True
}
