//================================================================================
// R6NoiseMgr.
//================================================================================
class R6NoiseMgr extends R6AbstractNoiseMgr
	Config(Sound);

enum EPawnType {
	PAWN_NotDefined,
	PAWN_Rainbow,
	PAWN_Terrorist,
	PAWN_Hostage,
	PAWN_All
};

enum ENoiseType {
	NOISE_None,
	NOISE_Investigate,
	NOISE_Threat,
	NOISE_Grenade,
	NOISE_Dead
};

struct STPawnMovement
{
	var float fStandSlow;
	var float fStandFast;
	var float fCrouchSlow;
	var float fCrouchFast;
	var float fProne;
	var ENoiseType eType;
};

struct STSound
{
	var float fSndDist;
	var ENoiseType eType;
};

var bool bShowLog;
var config STSound m_SndBulletImpact;
var config STSound m_SndBulletRicochet;
var config STSound m_SndGrenadeImpact;
var config STSound m_SndGrenadeLike;
var config STSound m_sndExplosion;
var config STSound m_SndChoking;
var config STSound m_SndTalking;
var config STSound m_SndScreaming;
var config STSound m_SndReload;
var config STSound m_SndEquipping;
var config STSound m_SndDead;
var config STSound m_SndDoor;
var config STPawnMovement m_Rainbow;
var config STPawnMovement m_Terro;
var config STPawnMovement m_Hostage;

function Init ()
{
	SaveConfig();
}

function MakeANoise (Actor Source, float fDist, ENoiseType ENoiseType, EPawnType EPawnType, ESoundType ESoundType)
{
	if ( fDist > 0.00 )
	{
//		Source.MakeNoise(fDist,ENoiseType,EPawnType);
	}
}

event R6MakeNoise (ESoundType ESoundType, Actor Source)
{
	local float fDist;
	local R6AbstractPawn aR6Pawn;
	local ENoiseType ENoiseType;
	local EPawnType EPawnType;
	local R6Weapons srcWeapon;

	aR6Pawn=R6AbstractPawn(Source.Instigator);
	if ( aR6Pawn != None )
	{
//		EPawnType=aR6Pawn.m_ePawnType;
		switch (ESoundType)
		{
/*			case 1:
			srcWeapon=R6Weapons(Source);
			if ( srcWeapon == None )
			{
				return;
			}
			if ( aR6Pawn.m_NextFireSound > aR6Pawn.Level.TimeSeconds )
			{
				return;
			}
			aR6Pawn.m_NextFireSound=aR6Pawn.Level.TimeSeconds + 0.33;
			fDist=srcWeapon.m_fFireSoundRadius * 1.50;
			ENoiseType=1;
			break;
			case 2:
			if ( aR6Pawn.m_NextBulletImpact > aR6Pawn.Level.TimeSeconds )
			{
				return;
			}
			aR6Pawn.m_NextBulletImpact=aR6Pawn.Level.TimeSeconds + 0.33;
			fDist=m_SndBulletImpact.fSndDist;
			ENoiseType=m_SndBulletImpact.eType;
			break;
			case 3:
			fDist=m_SndGrenadeImpact.fSndDist;
			ENoiseType=m_SndGrenadeImpact.eType;
			EPawnType=4;
			break;
			case 4:
			fDist=m_SndGrenadeLike.fSndDist;
			ENoiseType=m_SndGrenadeLike.eType;
			break;
			case 5:
			fDist=m_sndExplosion.fSndDist;
			ENoiseType=m_sndExplosion.eType;
			break;
			case 7:
			fDist=m_SndChoking.fSndDist;
			ENoiseType=m_SndChoking.eType;
			break;
			case 8:
			fDist=m_SndTalking.fSndDist;
			ENoiseType=m_SndTalking.eType;
			break;
			case 9:
			fDist=m_SndScreaming.fSndDist;
			ENoiseType=m_SndScreaming.eType;
			break;
			case 10:
			fDist=m_SndReload.fSndDist;
			ENoiseType=m_SndReload.eType;
			break;
			case 11:
			fDist=m_SndEquipping.fSndDist;
			ENoiseType=m_SndEquipping.eType;
			break;
			case 12:
			fDist=m_SndDead.fSndDist;
			ENoiseType=m_SndDead.eType;
			EPawnType=4;
			break;
			case 13:
			fDist=m_SndDoor.fSndDist;
			ENoiseType=m_SndDoor.eType;
			break;
			default:*/
		}
//		MakeANoise(Source,fDist,ENoiseType,EPawnType,ESoundType);
	}
}

event R6MakePawnMovementNoise (R6AbstractPawn Pawn)
{
	local float fDist;
	local EPawnType EPawnType;
	local R6Pawn aR6Pawn;
	local bool bIsRunning;
	local STPawnMovement pawnMove;
	local float fStealth;

	aR6Pawn=R6Pawn(Pawn);
//	EPawnType=aR6Pawn.m_ePawnType;
	if ( EPawnType == 2 )
	{
		pawnMove=m_Terro;
	}
	else
	{
		if ( EPawnType == 1 )
		{
			pawnMove=m_Rainbow;
		}
		else
		{
			pawnMove=m_Hostage;
		}
	}
	bIsRunning=aR6Pawn.IsRunning();
	if ( aR6Pawn.m_bIsProne )
	{
		fDist=pawnMove.fProne;
	}
	else
	{
		if ( aR6Pawn.bIsCrouched )
		{
			if ( bIsRunning )
			{
				fDist=pawnMove.fCrouchFast;
			}
			else
			{
				fDist=pawnMove.fCrouchSlow;
			}
		}
		else
		{
			if ( bIsRunning )
			{
				fDist=pawnMove.fStandFast;
			}
			else
			{
				fDist=pawnMove.fStandSlow;
			}
		}
	}
	fStealth=Pawn.GetSkill(SKILL_Stealth);
	fStealth=Clamp(fStealth,0,1.50);
	fDist *= 1.25 - fStealth * 0.50;
//	MakeANoise(Pawn,fDist,pawnMove.eType,EPawnType,6);
}

defaultproperties
{
    m_SndBulletImpact=(fSndDist=0.00,eType=NOISE_None)
    m_SndBulletRicochet=(fSndDist=0.00,eType=NOISE_None)
    m_SndGrenadeImpact=(fSndDist=0.00,eType=NOISE_None)
    m_SndGrenadeLike=(fSndDist=0.00,eType=NOISE_None)
    m_sndExplosion=(fSndDist=0.00,eType=64)
    m_SndChoking=(fSndDist=0.00,eType=NOISE_None)
    m_SndTalking=(fSndDist=0.00,eType=NOISE_None)
    m_SndScreaming=(fSndDist=0.00,eType=NOISE_None)
    m_SndReload=(fSndDist=0.00,eType=NOISE_None)
    m_SndEquipping=(fSndDist=0.00,eType=NOISE_None)
    m_SndDead=(fSndDist=0.00,eType=NOISE_None)
    m_SndDoor=(fSndDist=0.00,eType=NOISE_None)
    m_Rainbow=(fStandSlow=0.00,fStandFast=6.05309157881044828E28,fCrouchSlow=0.00,fCrouchFast=0.00,fProne=-131072.56,eType=67)
    m_Terro=(fStandSlow=0.00,fStandFast=6.08065508749766182E28,fCrouchSlow=0.00,fCrouchFast=0.00,fProne=0.00,eType=68)
    m_Hostage=(fStandSlow=0.00,fStandFast=6.08065508749766182E28,fCrouchSlow=0.00,fCrouchFast=0.00,fProne=0.00,eType=68)
}
