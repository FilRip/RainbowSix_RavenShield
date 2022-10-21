//================================================================================
// R6Bullet.
//================================================================================
class R6Bullet extends R6AbstractBullet
	Native;

enum EHitType {
	HIT_Impact,
	HIT_Ricochet,
	HIT_Exit
};

enum eHitResult {
	HR_NoMaterial,
	HR_Explode,
	HR_Ricochet,
	HR_GoThrough
};

var(Rainbow) int m_iEnergy;
var(Rainbow) int m_iPenetrationFactor;
var(Rainbow) int m_iNoArmorModifier;
var int m_iBulletGroupID;
var bool m_bBulletIsGone;
var bool m_bIsGrenade;
var bool m_bBulletDeactivated;
var bool bShowLog;
var(Rainbow) float m_fKillStunTransfer;
var(Rainbow) float m_fRangeConversionConst;
var(Rainbow) float m_fRange;
var(R6Grenade) float m_fExplosionRadius;
var(R6Grenade) float m_fKillBlastRadius;
var(Rainbow) float m_fExplosionDelay;
var Actor m_AffectedActor;
var R6BulletManager m_BulletManager;
var Vector m_vSpawnedPosition;
var(Rainbow) string m_szAmmoName;
var(Rainbow) string m_szAmmoType;
var(Rainbow) string m_szBulletType;

native(2001) final function eHitResult BulletGoesThroughSurface (Actor TouchedSurface, Vector vHitLocation, out Vector vBulletVelocity, out Vector vRealHitLocation, out Vector vexitLocation, out Vector vexitNormal, out Class<R6WallHit> TouchedEffects, out Class<R6WallHit> ExitEffects);

function bool DestroyedByImpact ()
{
	return False;
}

simulated function PostBeginPlay ()
{
	Super.PostBeginPlay();
	m_vSpawnedPosition=Location;
	m_bBulletIsGone=True;
}

simulated function SetSpeed (float fBulletSpeed)
{
//	Velocity=fBulletSpeed * Rotation;
}

function DeactivateBullet ()
{
	SetPhysics(PHYS_None);
	bStasis=True;
	SetCollision(False,False,False);
	m_bBulletDeactivated=True;
}

singular simulated function Touch (Actor Other)
{
	local Actor HitActor;
	local Vector vHitLocation;
	local Vector vHitNormal;
	local Material pMaterial;

	if ( (Other == Instigator) || (m_bBulletIsGone == False) || (m_bBulletDeactivated == True) || (Instigator.m_collisionBox == Other) )
	{
		return;
	}
	if ( R6Bullet(Other) != None )
	{
		if ( R6Bullet(Other).DestroyedByImpact() )
		{
			DeactivateBullet();
		}
	}
	if ( Other.bProjTarget || Other.bBlockActors && Other.bBlockPlayers || Other.IsA('R6ColBox') )
	{
		HitActor=Instigator.R6Trace(vHitLocation,vHitNormal,Location + Other.CollisionRadius * Normal(Location - m_vSpawnedPosition),m_vSpawnedPosition,4 | 1);
		if ( HitActor == Other )
		{
			ProcessTouch(Other,vHitLocation);
			if ( pMaterial != None )
			{
//				SpawnSFX(pMaterial.m_pHitEffect,vHitLocation,rotator(vHitNormal),Other,0);
			}
		}
		else
		{
			ProcessTouch(Other,Other.Location + Other.CollisionRadius * Normal(Location - Other.Location));
		}
	}
}

simulated function ProcessTouch (Actor Other, Vector vHitLocation)
{
	local float fResultKillEnergy;
	local float fResultStunEnergy;
	local float fRange;
	local R6Pawn OtherPawn;
	local R6Pawn instigatorPawn;

	if ( Other != Instigator )
	{
		if ( Role == Role_Authority )
		{
			fRange=VSize(Location - m_vSpawnedPosition);
			fRange /= 100;
			fResultKillEnergy=m_iEnergy - RangeConversion(fRange);
			if ( fResultKillEnergy < 10.00 )
			{
				fResultKillEnergy=10.00;
			}
			fResultStunEnergy=m_iEnergy + fResultKillEnergy * m_fKillStunTransfer - StunLoss(fRange);
			if ( fResultKillEnergy < 15.00 )
			{
				fResultKillEnergy=15.00;
			}
			if ( bShowLog )
			{
				Log("Bullet" $ string(self) $ " Hit " $ string(Other) $ " By :" $ string(Instigator) $ " at location " $ string(vHitLocation) $ " with energy : " $ string(fResultKillEnergy) $ " : " $ string(fResultKillEnergy));
			}
			OtherPawn=R6Pawn(Other);
			if ( (OtherPawn == None) && Other.IsA('R6ColBox') )
			{
				if ( R6ColBox(Other).m_fFeetColBoxRadius != 0.00 )
				{
					OtherPawn=R6Pawn(Other.Base.Base);
				}
				else
				{
					OtherPawn=R6Pawn(Other.Base);
				}
			}
			instigatorPawn=R6Pawn(Instigator);
			if ( (OtherPawn != None) &&  !instigatorPawn.m_bCanFireFriends && instigatorPawn.IsFriend(OtherPawn) ||  !instigatorPawn.m_bCanFireNeutrals && instigatorPawn.IsNeutral(OtherPawn) )
			{
				m_iEnergy=0;
			}
			else
			{
				m_iEnergy=Other.R6TakeDamage(fResultKillEnergy,fResultStunEnergy,Instigator,vHitLocation,Velocity,m_iNoArmorModifier,m_iBulletGroupID);
			}
			if ( (m_iEnergy == 0) || (m_szBulletType == "JHP") )
			{
				DeactivateBullet();
			}
		}
		if ( bShowLog )
		{
			Log(string(self) @ "Hit :" $ string(Other.Name));
		}
	}
}

simulated function SpawnSFX (Class<R6WallHit> fxClass, Vector vLocation, Rotator vRotation, Actor pSource, EHitType eType)
{
	local R6WallHit WallHitEffect;

	if ( fxClass != None )
	{
		WallHitEffect=Spawn(fxClass,,,vLocation,vRotation);
		if ( WallHitEffect != None )
		{
			if ( m_BulletManager.AffectActor(m_iBulletGroupID,pSource) == False )
			{
				WallHitEffect.m_bPlayEffectSound=False;
			}
		}
//		WallHitEffect.m_eHitType=eType;
	}
}

simulated event HitWall (Vector vHitNormal, Actor Wall)
{
	local eHitResult eHitResult;
	local Class<R6WallHit> CurrentHitEffect;
	local Class<R6WallHit> ExitHitEffect;
	local Vector vRealHitLocation;
	local Vector vexitLocation;
	local Vector vexitNormal;
	local int iInitialEnergy;
	local Vector vRangeVector;
	local float fDistance;

	iInitialEnergy=m_iEnergy;
	eHitResult=BulletGoesThroughSurface(Wall,Location,Velocity,vRealHitLocation,vexitLocation,vexitNormal,CurrentHitEffect,ExitHitEffect);
	if ( Wall.IsA('R6InteractiveObject') )
	{
		vRangeVector=vRealHitLocation - m_vSpawnedPosition;
		fDistance=VSize(vRangeVector) * 0.01;
		Wall.R6TakeDamage(iInitialEnergy - RangeConversion(fDistance),0,Instigator,vRealHitLocation,Velocity,m_iPenetrationFactor,-1);
	}
	switch (eHitResult)
	{
/*		case 3:
		SpawnSFX(CurrentHitEffect,vRealHitLocation,rotator(vHitNormal),Wall,0);
		SpawnSFX(ExitHitEffect,vexitLocation,rotator(vexitNormal),Wall,2);
		if (  !SetLocation(vexitLocation + vexitNormal * 2) )
		{
			DeactivateBullet();
		}
		break;
		case 1:
		SpawnSFX(CurrentHitEffect,vRealHitLocation,rotator(vHitNormal),Wall,0);
		DeactivateBullet();
		break;
		case 2:
		SpawnSFX(CurrentHitEffect,vRealHitLocation,rotator(vHitNormal),Wall,1);
		DeactivateBullet();
		break;
		case 0:
		DeactivateBullet();
		break;
		default:
		Log("!!! We have a serious problem HERE !!!");   */
	}
}

function float RangeConversion (float fRange)
{
	return fRange * fRange * m_fRangeConversionConst + m_fRangeConversionConst;
}

function float StunLoss (float fRange)
{
	return fRange * fRange * m_fRangeConversionConst;
}

defaultproperties
{
    m_iEnergy=100
    m_iPenetrationFactor=1
    m_fKillStunTransfer=0.01
    m_fRangeConversionConst=0.10
    m_fRange=100.00
    m_szAmmoName="R6Bullet"
    m_szAmmoType="Normal"
    m_szBulletType="JHP"
    RemoteRole=ROLE_None
    DrawType=0
    AmbientGlow=167
    SoundPitch=100
    bHidden=True
    bStasis=True
    bNetTemporary=True
    bReplicateInstigator=True
    m_bDeleteOnReset=True
    bGameRelevant=True
    bCollideActors=True
    bCollideWorld=True
    m_bDoPerBoneTrace=True
    bBounce=True
    SoundRadius=4.00
    NetPriority=2.50
}
