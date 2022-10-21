//================================================================================
// R6Grenade.
//================================================================================
class R6Grenade extends R6Bullet
	Native
	Abstract;

enum EGrenadeType {
	GTYPE_None,
	GTYPE_Smoke,
	GTYPE_TearGas,
	GTYPE_FlashBang,
	GTYPE_BreachingCharge
};

struct sDamagePercentage
{
	var() float fHead;
	var() float fBody;
	var() float fArms;
	var() float fLegs;
};

enum eGrenadeBoneTarget {
	GBT_Head,
	GBT_Body,
	GBT_LeftArm,
	GBT_RightArm,
	GBT_LeftLeg,
	GBT_RightLeg
};

enum eGrenadePawnPose {
	GPP_Stand,
	GPP_Crouch,
	GPP_ProneFacing
};

var EPhysics m_eOldPhysic;
var ESoundType m_eExplosionSoundType;
var EGrenadeType m_eGrenadeType;
var() int m_iNumberOfFragments;
var bool m_bFirstImpact;
var bool m_bDestroyedByImpact;
var float m_fDuration;
var float m_fShakeRadius;
var float m_fEffectiveOutsideKillRadius;
var(R6GrenadeSound) Sound m_sndExplosionSound;
var(R6GrenadeSound) Sound m_sndExplosionSoundStop;
var(R6GrenadeSound) Sound m_sndExplodeMetal;
var(R6GrenadeSound) Sound m_sndExplodeWater;
var(R6GrenadeSound) Sound m_sndExplodeAir;
var(R6GrenadeSound) Sound m_sndExplodeDirt;
var(R6GrenadeSound) Sound m_ImpactSound;
var(R6GrenadeSound) Sound m_ImpactGroundSound;
var(R6GrenadeSound) Sound m_ImpactWaterSound;
var(R6GrenadeSound) Sound m_sndEarthQuake;
var R6DemolitionsGadget m_Weapon;
var() Emitter m_pEmmiter;
var() Class<Emitter> m_pExplosionParticles;
var() Class<Emitter> m_pExplosionParticlesLOW;
var() Class<Light> m_pExplosionLight;
var Class<R6GrenadeDecal> m_GrenadeDecalClass;
var() sDamagePercentage m_DmgPercentStand;
var() sDamagePercentage m_DmgPercentCrouch;
var() sDamagePercentage m_DmgPercentProne;

simulated function Class<Emitter> GetGrenadeEmitter ()
{
	local R6GameOptions pGameOptions;

	pGameOptions=Class'Actor'.static.GetGameOptions();
	if ( (pGameOptions.LowDetailSmoke == True) && (m_pExplosionParticlesLOW != None) )
	{
		return m_pExplosionParticlesLOW;
	}
	else
	{
		return m_pExplosionParticles;
	}
}

function SelfDestroy ()
{
	if ( Level.NetMode != 3 )
	{
		Destroy();
	}
}

function PostBeginPlay ()
{
//	LinkSkelAnim(MeshAnimation'R61stHandsGripGrenadeA');
	Super.PostBeginPlay();
	Activate();
	m_fEffectiveOutsideKillRadius=m_fExplosionRadius - m_fKillBlastRadius;
}

function Activate ()
{
	if ( m_fExplosionDelay != 0 )
	{
		SetTimer(m_fExplosionDelay,False);
	}
}

event Timer ()
{
	Explode();
	SelfDestroy();
}

simulated event Destroyed ()
{
	local Light pEffectLight;
	local Class<Emitter> pExplosionParticles;

	Super.Destroyed();
	pExplosionParticles=GetGrenadeEmitter();
	if ( m_bDestroyedByImpact == False )
	{
		if ( Default.m_fDuration == 0 )
		{
			if ( pExplosionParticles != None )
			{
				m_pEmmiter=Spawn(pExplosionParticles);
				m_pEmmiter.RemoteRole=ROLE_None;
				m_pEmmiter.Role=Role_Authority;
			}
			if ( m_pExplosionLight != None )
			{
				pEffectLight=Spawn(m_pExplosionLight);
			}
		}
		else
		{
			if ( m_pEmmiter != None )
			{
				m_pEmmiter.Destroy();
			}
		}
	}
}

simulated function FirstPassReset ()
{
	SelfDestroy();
}

simulated function Explode ()
{
	local Actor HitActor;
	local Vector vHitLocation;
	local Vector vHitNormal;
	local Material HitMaterial;
	local R6GrenadeDecal GrenadeDecal;
	local R6ActorSound pGrenadeSound;
	local Rotator GrenadeDecalRotation;

	if ( m_sndExplosionSound == None )
	{
		HitActor=Trace(vHitLocation,vHitNormal,Location - vect(0.00,0.00,40.00),Location,False,,HitMaterial);
		if ( (HitMaterial == None) && (m_sndExplodeAir != None) )
		{
			m_sndExplosionSound=m_sndExplodeAir;
		}
		if ( (m_sndExplosionSound == None) && (m_sndExplodeMetal != None) && ((HitMaterial.m_eSurfIdForSnd == 10) || (HitMaterial.m_eSurfIdForSnd == 11)) )
		{
			m_sndExplosionSound=m_sndExplodeMetal;
		}
		if ( (m_sndExplosionSound == None) && (m_sndExplodeWater != None) && ((HitMaterial.m_eSurfIdForSnd == 12) || (HitMaterial.m_eSurfIdForSnd == 13)) )
		{
			m_sndExplosionSound=m_sndExplodeWater;
		}
		if ( m_sndExplosionSound == None )
		{
			if ( m_sndExplodeDirt != None )
			{
				m_sndExplosionSound=m_sndExplodeDirt;
			}
			else
			{
				Log("Missing SOUND for the grenade!");
			}
		}
	}
	HurtPawns();
	R6MakeNoise(m_eExplosionSoundType);
	if ( m_GrenadeDecalClass != None )
	{
		GrenadeDecalRotation.Pitch=0;
		GrenadeDecalRotation.Yaw=0;
		GrenadeDecalRotation.Roll=0;
		GrenadeDecal=Spawn(m_GrenadeDecalClass,,,Location,GrenadeDecalRotation);
	}
	pGrenadeSound=Spawn(Class'R6ActorSound',,,Location);
	if ( pGrenadeSound != None )
	{
		if ( IsA('R6FlashBang') )
		{
//			pGrenadeSound.m_eTypeSound=4;
		}
		else
		{
//			pGrenadeSound.m_eTypeSound=2;
		}
		pGrenadeSound.m_ImpactSound=m_sndExplosionSound;
		pGrenadeSound.m_ImpactSoundStop=m_sndExplosionSoundStop;
		if ( m_eGrenadeType == 1 )
		{
//			pGrenadeSound.m_fExplosionDelay=m_fDuration - 35;
		}
		else
		{
//			pGrenadeSound.m_fExplosionDelay=m_fDuration;
		}
	}
}

simulated function HitWall (Vector HitNormal, Actor Wall)
{
	local Vector vHitLocation;
	local Vector vHitNormal;
	local Vector vTraceEnd;
	local Vector vTraceStart;
	local Actor pHit;
	local Material HitMaterial;

	if ( m_fExplosionDelay == 0 )
	{
		Explode();
	}
	else
	{
		if ( (Wall != None) && (Instigator != None) && (Instigator.m_collisionBox == Wall) )
		{
			vTraceEnd=Location + 10 * Normal(Velocity);
			SetLocation(vTraceEnd,True);
			return;
		}
		if ( Wall == Level )
		{
			vTraceStart=Location + 10 * HitNormal;
			vTraceEnd=Location - 10 * HitNormal;
			pHit=R6Trace(vHitLocation,vHitNormal,vTraceEnd,vTraceStart,2 | 16);
			if ( pHit == None )
			{
				SetLocation(vTraceEnd,True);
				return;
			}
		}
		if ( (Wall != None) && Wall.m_bBulletGoThrough && Wall.IsA('R6InteractiveObject') )
		{
			Wall.R6TakeDamage(10000,10000,Instigator,vHitLocation,Velocity,0);
			vTraceEnd=Location - 10 * HitNormal;
			SetLocation(vTraceEnd,True);
			Velocity *= 0.50;
			return;
		}
		DesiredRotation=RotRand();
		Velocity=0.20 * MirrorVectorByNormal(Velocity,HitNormal);
		RotationRate.Yaw=1000 * VSize(Velocity) * FRand() - 500 * VSize(Velocity);
		RotationRate.Pitch=1000 * VSize(Velocity) * FRand() - 500 * VSize(Velocity);
		RotationRate.Roll=1000 * VSize(Velocity) * FRand() - 500 * VSize(Velocity);
		if ( Velocity.Z > 400 )
		{
			Velocity.Z=400.00;
		}
		else
		{
			if ( VSize(Velocity) < 10 )
			{
				SetPhysics(PHYS_None);
				bBounce=False;
				RotationRate=rot(0,0,0);
			}
		}
		if ( m_bFirstImpact )
		{
			m_bFirstImpact=False;
			m_ImpactSound=m_ImpactGroundSound;
			pHit=Trace(vHitLocation,vHitNormal,Location - vect(0.00,0.00,40.00),Location,False,,HitMaterial);
			if ( (HitMaterial != None) && ((HitMaterial.m_eSurfIdForSnd == 12) || (HitMaterial.m_eSurfIdForSnd == 13)) )
			{
				m_ImpactSound=m_ImpactWaterSound;
			}
//			PlaySound(m_ImpactSound,3);
		}
		R6MakeNoise(SNDTYPE_GrenadeImpact);
	}
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

function float GetLocalizedDamagePercentage (eGrenadePawnPose ePawnPose, eGrenadeBoneTarget eBoneTarget)
{
	switch (ePawnPose)
	{
/*		case 0:
		switch (eBoneTarget)
		{
			case 0:
			return m_DmgPercentStand.fHead;
			case 1:
			return m_DmgPercentStand.fBody;
			case 2:
			case 3:
			return m_DmgPercentStand.fArms;
			case 4:
			case 5:
			return m_DmgPercentStand.fLegs;
			default:
		}
		case 1:
		switch (eBoneTarget)
		{
			case 0:
			return m_DmgPercentCrouch.fHead;
			case 1:
			return m_DmgPercentCrouch.fBody;
			case 2:
			case 3:
			return m_DmgPercentCrouch.fArms;
			case 4:
			case 5:
			return m_DmgPercentCrouch.fLegs;
			default:
		}
		case 2:
		switch (eBoneTarget)
		{
			case 0:
			return m_DmgPercentProne.fHead;
			case 1:
			return m_DmgPercentProne.fBody;
			case 2:
			case 3:
			return m_DmgPercentProne.fArms;
			case 4:
			case 5:
			return m_DmgPercentProne.fLegs;
			default:
		}
		default:  */
	}
	return 0.00;
}

function eGrenadeBoneTarget HitRandomBodyPart (eGrenadePawnPose ePawnPose)
{
	local float fRandVal;
	local float fLeftArmVal;
	local float fRightArmVal;
	local float fLeftLegVal;
	local float fRighLegVal;
	local float fBodyVal;
	local float fHeadVal;

	fRandVal=FRand();
/*	fLeftArmVal=GetLocalizedDamagePercentage(ePawnPose,2);
	fRightArmVal=GetLocalizedDamagePercentage(ePawnPose,3) + fLeftArmVal;
	fLeftLegVal=GetLocalizedDamagePercentage(ePawnPose,4) + fRightArmVal;
	fRighLegVal=GetLocalizedDamagePercentage(ePawnPose,5) + fLeftLegVal;
	fBodyVal=GetLocalizedDamagePercentage(ePawnPose,1) + fRighLegVal;
	fHeadVal=GetLocalizedDamagePercentage(ePawnPose,0) + fBodyVal;    */
	if ( fRandVal < fLeftArmVal )
	{
		return GBT_LeftArm;
	}
	else
	{
		if ( fRandVal < fRightArmVal )
		{
			return GBT_RightArm;
		}
		else
		{
			if ( fRandVal < fLeftLegVal )
			{
				return GBT_LeftLeg;
			}
			else
			{
				if ( fRandVal < fRighLegVal )
				{
					return GBT_RightLeg;
				}
				else
				{
					if ( fRandVal < fBodyVal )
					{
						return GBT_Body;
					}
				}
			}
		}
	}
	return GBT_Head;
}

function eGrenadePawnPose GetPawnPose (R6Pawn aPawn)
{
	local float fDistFeet;
	local float fDistHead;
	local Vector vFeet;
	local Vector vHead;

	if ( aPawn.m_bIsProne )
	{
		vFeet=aPawn.GetBoneCoords('R6 L Foot').Origin;
		vHead=aPawn.GetBoneCoords('R6 Head').Origin;
		fDistHead=VSize(vHead - Location);
		fDistFeet=VSize(vFeet - Location);
		if ( fDistFeet - fDistHead > VSize(vFeet - vHead) * 0.75 )
		{
			return GPP_ProneFacing;
		}
		else
		{
			return GPP_Stand;
		}
	}
	if ( aPawn.bIsCrouched )
	{
		return GPP_Crouch;
	}
	return GPP_Stand;
}

function HurtPawns ()
{
}

defaultproperties
{
    m_eOldPhysic=2
    m_eExplosionSoundType=5
    m_iNumberOfFragments=4
    m_bFirstImpact=True
    m_fShakeRadius=1000.00
    m_bIsGrenade=True
    m_fExplosionDelay=3.00
    Physics=2
    RemoteRole=ROLE_SimulatedProxy
    DrawType=8
    bHidden=False
    bStasis=False
    bNetTemporary=False
    bAlwaysRelevant=True
    m_bBypassAmbiant=True
    m_bRenderOutOfWorld=True
    m_bDoPerBoneTrace=False
    bIgnoreOutOfWorld=True
    bFixedRotationDir=True
}
/*
    m_ImpactGroundSound=Sound'Foley_CommonGrenade.Play_Grenades_GroundImpacts'
    m_sndEarthQuake=Sound'CommonWeapons.Play_GrenadeQuake'
*/

