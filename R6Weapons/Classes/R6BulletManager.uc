//================================================================================
// R6BulletManager.
//================================================================================
class R6BulletManager extends R6AbstractBulletManager;

const m_iNbBullets= 20;
var int m_iCurrentBullet;
var int m_iBulletSpeed;
var int m_iBulletEnergy;
var int m_iNextBulletGroupID;
var R6Bullet m_BulletArray[20];

function InitBulletMgr (Pawn TheInstigator)
{
	m_iCurrentBullet=0;
JL0007:
	if ( m_iCurrentBullet < 20 )
	{
		m_BulletArray[m_iCurrentBullet]=Spawn(Class'R6Bullet',,,,,True);
		m_BulletArray[m_iCurrentBullet].SetCollision(False,False,False);
		m_BulletArray[m_iCurrentBullet].Instigator=TheInstigator;
		m_BulletArray[m_iCurrentBullet].m_BulletManager=self;
		m_iCurrentBullet++;
		goto JL0007;
	}
	m_iCurrentBullet=0;
}

function SetBulletParameter (R6EngineWeapon AWeapon)
{
	local R6Weapons aR6Weapon;

	aR6Weapon=R6Weapons(AWeapon);
	if ( (aR6Weapon == None) || (aR6Weapon.m_pBulletClass == None) )
	{
		return;
	}
	m_iBulletEnergy=aR6Weapon.m_pBulletClass.Default.m_iEnergy;
	m_iCurrentBullet=0;
JL0057:
	if ( m_iCurrentBullet < 20 )
	{
		m_BulletArray[m_iCurrentBullet].m_szBulletType=aR6Weapon.m_pBulletClass.Default.m_szBulletType;
		m_BulletArray[m_iCurrentBullet].m_iEnergy=aR6Weapon.m_pBulletClass.Default.m_iEnergy;
		m_BulletArray[m_iCurrentBullet].m_fKillStunTransfer=aR6Weapon.m_pBulletClass.Default.m_fKillStunTransfer;
		m_BulletArray[m_iCurrentBullet].m_fRangeConversionConst=aR6Weapon.m_pBulletClass.Default.m_fRangeConversionConst;
		m_BulletArray[m_iCurrentBullet].m_fRange=aR6Weapon.m_pBulletClass.Default.m_fRange;
		m_BulletArray[m_iCurrentBullet].m_iPenetrationFactor=aR6Weapon.m_pBulletClass.Default.m_iPenetrationFactor;
		m_iCurrentBullet++;
		goto JL0057;
	}
	m_iCurrentBullet=0;
}

function SpawnBullet (Vector VPosition, Rotator rRotation, float fBulletSpeed, bool bFirstInShell)
{
	if ( bFirstInShell == True )
	{
		m_iNextBulletGroupID++;
	}
	m_BulletArray[m_iCurrentBullet].SetLocation(VPosition,True);
	m_BulletArray[m_iCurrentBullet].SetRotation(rRotation);
	m_BulletArray[m_iCurrentBullet].m_vSpawnedPosition=VPosition;
	m_BulletArray[m_iCurrentBullet].m_bBulletIsGone=True;
	m_BulletArray[m_iCurrentBullet].SetSpeed(fBulletSpeed);
	m_BulletArray[m_iCurrentBullet].SetCollision(True,True,False);
	m_BulletArray[m_iCurrentBullet].SetPhysics(PHYS_Projectile);
	m_BulletArray[m_iCurrentBullet].bStasis=False;
	m_BulletArray[m_iCurrentBullet].m_bBulletDeactivated=False;
	m_BulletArray[m_iCurrentBullet].m_iBulletGroupID=m_iNextBulletGroupID;
	m_BulletArray[m_iCurrentBullet].m_AffectedActor=None;
	m_BulletArray[m_iCurrentBullet].m_iEnergy=m_iBulletEnergy;
	m_iCurrentBullet++;
	if ( m_iCurrentBullet == 20 )
	{
		m_iCurrentBullet=0;
	}
}

function bool AffectActor (int BulletGroup, Actor ActorAffected)
{
	local int iBulletIndex;
	local int iSaveBulletIndex;

	iBulletIndex=0;
JL0007:
	if ( iBulletIndex < 20 )
	{
		if ( m_BulletArray[iBulletIndex].m_iBulletGroupID == BulletGroup )
		{
			if ( m_BulletArray[iBulletIndex].m_AffectedActor == ActorAffected )
			{
				return False;
			}
			else
			{
				if ( m_BulletArray[iBulletIndex].m_AffectedActor == None )
				{
					iSaveBulletIndex=iBulletIndex;
				}
			}
		}
		iBulletIndex++;
		goto JL0007;
	}
	m_BulletArray[iSaveBulletIndex].m_AffectedActor=ActorAffected;
	return True;
}

simulated event Destroyed ()
{
	local int i;
	local int iSaveBulletIndex;

	i=0;
JL0007:
	if ( i < 20 )
	{
		m_BulletArray[i].m_BulletManager=None;
		m_BulletArray[i].Destroy();
		i++;
		goto JL0007;
	}
}

defaultproperties
{
    RemoteRole=ROLE_None
    bHidden=True
}