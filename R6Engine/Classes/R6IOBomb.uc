//================================================================================
// R6IOBomb.
//================================================================================
class R6IOBomb extends R6IOObject
	Native;

enum ESoundBeepBomb {
	SBB_Normal,
	SBB_Fast,
	SBB_Faster
};

var ESoundBeepBomb m_eBeepState;
const C_fBombTimerInterval= 0.1;
var(R6ActionObject) int m_iEnergy;
var(Debug) bool bShowLog;
var bool m_bExploded;
var float m_fTimeOfExplosion;
var float m_fTimeLeft;
var float m_fRepTimeLeft;
var float m_fLastLevelTime;
var(R6ActionObject) float m_fDisarmBombTimeMin;
var(R6ActionObject) float m_fDisarmBombTimeMax;
var(R6ActionObject) float m_fExplosionRadius;
var(R6ActionObject) float m_fKillBlastRadius;
var(R6ActionObject) Material m_ArmedTexture;
var Sound m_sndActivationBomb;
var Sound m_sndPlayBeepNormal;
var Sound m_sndStopBeepNormal;
var Sound m_sndPlayBeepFast;
var Sound m_sndStopBeepFast;
var Sound m_sndPlayBeepFaster;
var Sound m_sndStopBeepFaster;
var Sound m_sndExplosion;
var Sound m_sndEarthQuake;
var Emitter m_pEmmiter;
var Class<Light> m_pExplosionLight;
var Vector m_vOffset;
var(R6ActionObject) string m_szIdentityID;
var string m_szIdentity;
var(R6ActionObject) string m_szMsgArmedID;
var(R6ActionObject) string m_szMsgDisarmedID;
var(R6ActionObject) string m_szMissionObjLocalization;

replication
{
	reliable if ( Role < Role_Authority )
		DisarmBomb,ArmBomb;
	reliable if ( Role == Role_Authority )
		m_bExploded,m_fRepTimeLeft;
}

simulated function PostBeginPlay ()
{
	Super.PostBeginPlay();
	if ( Role == Role_Authority )
	{
		AddSoundBankName("Foley_Bomb");
	}
	StartBombSound();
	m_szIdentity=Localize("Game",m_szIdentityID,GetMissionObjLocFile());
}

simulated function string GetMissionObjLocFile ()
{
	if ( m_szMissionObjLocalization != "" )
	{
		return m_szMissionObjLocalization;
	}
	else
	{
		return Level.m_szMissionObjLocalization;
	}
}

simulated function ResetOriginalData ()
{
	if ( m_bResetSystemLog )
	{
		LogResetSystem(False);
	}
	Super.ResetOriginalData();
	if ( m_bExploded )
	{
		bHidden=False;
	}
	m_bExploded=False;
	m_fTimeLeft=0.00;
	m_fRepTimeLeft=0.00;
	m_fLastLevelTime=0.00;
	StopSoundBomb();
	if ( Level.NetMode != 3 )
	{
		if ( m_bIsActivated )
		{
			ArmBomb(None);
		}
		else
		{
			SetSkin(None,0);
		}
	}
	if ( Level.NetMode == NM_Client )
	{
		SetTimer(0.10,True);
	}
}

simulated function bool CanToggle ()
{
	if ( m_bExploded )
	{
		return False;
	}
	return Super.CanToggle();
}

simulated function float GetTimeLeft ()
{
	if ( Level.NetMode == NM_Client )
	{
		return m_fRepTimeLeft;
	}
	else
	{
		return m_fTimeLeft;
	}
}

simulated function Timer ()
{
	local int iRemaining;

	Super.Timer();
	if ( Level.NetMode == NM_Client )
	{
		if ( m_bIsActivated )
		{
			m_fRepTimeLeft -= 0.10;
			if ( m_fRepTimeLeft < 0 )
			{
				m_fRepTimeLeft=0.00;
			}
		}
	}
	else
	{
		if ( m_bIsActivated && (m_fTimeLeft > 0) )
		{
			m_fTimeLeft -= Level.TimeSeconds - m_fLastLevelTime;
			iRemaining=m_fTimeLeft;
			ChangeSoundBomb();
			if ( iRemaining % 5 == 0 )
			{
				m_fRepTimeLeft=m_fTimeLeft;
			}
			if ( m_fTimeLeft <= 0 )
			{
				DetonateBomb();
			}
			m_fLastLevelTime=Level.TimeSeconds;
		}
	}
}

function ForceTimeLeft (float fTime)
{
	m_fTimeLeft=fTime;
	m_fRepTimeLeft=fTime;
	m_fLastLevelTime=Level.TimeSeconds;
}

function ChangeSoundBomb ()
{
	switch (m_eBeepState)
	{
/*		case 0:
		if ( m_fTimeLeft <= 20 )
		{
			AmbientSound=m_sndPlayBeepFast;
			AmbientSoundStop=m_sndStopBeepFast;
			PlaySound(m_sndPlayBeepFast,1);
			m_eBeepState=1;
		}
		break;
		case 1:
		if ( m_fTimeLeft <= 10 )
		{
			AmbientSound=m_sndPlayBeepFaster;
			AmbientSoundStop=m_sndStopBeepFaster;
			PlaySound(m_sndPlayBeepFaster,1);
			m_eBeepState=2;
		}
		break;
		default:     */
	}
}

simulated function DetonateBomb (optional R6Pawn P)
{
	local R6GrenadeDecal GrenadeDecal;
	local Rotator GrenadeDecalRotation;
	local Light pEffectLight;
	local Vector vDecalLoc;
	local float fKillBlastHalfRadius;
	local float fDistFromBomb;
	local Actor aActor;
	local R6Pawn pPawn;
	local R6PlayerController pPC;
	local R6ActorSound pBombSound;

	if (  !m_bIsActivated )
	{
		return;
	}
	if ( bShowLog )
	{
		Log(" DetonateBomb: " $ string(self));
	}
	StopSoundBomb();
	m_bExploded=True;
	bHidden=True;
	vDecalLoc=Location;
	vDecalLoc.Z -= CollisionHeight - 2;
	GrenadeDecal=Spawn(Class'R6GrenadeDecal',,,vDecalLoc,GrenadeDecalRotation);
	m_pEmmiter=Spawn(Class'R6BombFX');
	m_pEmmiter.RemoteRole=ROLE_AutonomousProxy;
	m_pEmmiter.Role=Role_Authority;
	pEffectLight=Spawn(m_pExplosionLight);
	R6AbstractGameInfo(Level.Game).IObjectDestroyed(P,self);
	R6AbstractGameInfo(Level.Game).m_bGameOverButAllowDeath=True;
	pBombSound=Spawn(Class'R6ActorSound',,,Location);
	if ( pBombSound != None )
	{
//		pBombSound.m_eTypeSound=8;
		pBombSound.m_ImpactSound=m_sndExplosion;
	}
	fKillBlastHalfRadius=m_fKillBlastRadius / 2.00;
	foreach CollidingActors(Class'Actor',aActor,m_fExplosionRadius,Location)
	{
		fDistFromBomb=VSize(aActor.Location - Location);
		if ( fDistFromBomb <= fKillBlastHalfRadius )
		{
			HurtActor(aActor);
		}
		else
		{
			if ( fDistFromBomb <= m_fKillBlastRadius )
			{
				if ( FastTrace(Location,aActor.Location) )
				{
					HurtActor(aActor);
				}
			}
		}
		if ( fDistFromBomb > 3000 )
		{
			fDistFromBomb=3000.00;
		}
		pPawn=R6Pawn(aActor);
		if ( (pPawn != None) && pPawn.IsAlive() )
		{
			pPC=R6PlayerController(pPawn.Controller);
			if ( pPC != None )
			{
				pPC.R6Shake(1.50,3000.00 - fDistFromBomb,0.10);
//				pPC.ClientPlaySound(m_sndEarthQuake,3);
			}
		}
	}
	R6AbstractGameInfo(Level.Game).m_bGameOverButAllowDeath=False;
}

function HurtActor (Actor aActor)
{
	local Vector vExplosionMomentum;
	local R6Pawn aPawn;

	if ( (R6InteractiveObject(aActor) != None) && (aActor != self) )
	{
		vExplosionMomentum=(aActor.Location - Location) * 0.25;
		R6InteractiveObject(aActor).R6TakeDamage(m_iEnergy,m_iEnergy,None,aActor.Location,vExplosionMomentum,0);
		return;
	}
	aPawn=R6Pawn(aActor);
	if ( aPawn == None )
	{
		return;
	}
	if ( aPawn.m_eHealth >= 2 )
	{
		return;
	}
	vExplosionMomentum=(aPawn.Location - Location) * 0.25;
	aPawn.ServerForceKillResult(4);
	aPawn.m_bSuicideType=9;
	aPawn.R6TakeDamage(m_iEnergy,m_iEnergy,aPawn,aPawn.Location,vExplosionMomentum,0);
	aPawn.ServerForceKillResult(0);
}

simulated event R6QueryCircumstantialAction (float fDistance, out R6AbstractCircumstantialActionQuery Query, PlayerController PlayerController)
{
	local bool bDisplayBombIcon;
	local Vector vActorDir;
	local Vector vFacingDir;
	local R6Pawn aPawn;

	if ( (CanToggle() == False) ||  !m_bRainbowCanInteract )
	{
		return;
	}
	Query.iHasAction=0;
	aPawn=R6Pawn(PlayerController.Pawn);
	if ( m_bIsActivated )
	{
		if ( aPawn.m_bCanDisarmBomb )
		{
			Query.iHasAction=1;
//			Query.textureIcon=Texture'Disarm';
			Query.iPlayerActionID=1;
			Query.iTeamActionID=1;
			Query.iTeamActionIDList[0]=1;
		}
	}
	else
	{
		if ( aPawn.m_bCanArmBomb )
		{
			Query.iHasAction=1;
//			Query.textureIcon=Texture'ArmingBomb';
			Query.iPlayerActionID=2;
			Query.iTeamActionID=2;
			Query.iTeamActionIDList[0]=2;
		}
	}
	Query.iTeamActionIDList[1]=0;
	Query.iTeamActionIDList[2]=0;
	Query.iTeamActionIDList[3]=0;
	if ( fDistance < m_fCircumstantialActionRange )
	{
		vFacingDir=vector(Rotation);
		vFacingDir.Z=0.00;
		vActorDir=Normal(Location - PlayerController.Pawn.Location);
		vActorDir.Z=0.00;
		if ( vActorDir Dot vFacingDir > 0.40 )
		{
			Query.iInRange=1;
		}
		else
		{
			Query.iInRange=0;
		}
	}
	else
	{
		Query.iInRange=0;
	}
	Query.bCanBeInterrupted=True;
	Query.fPlayerActionTimeRequired=GetTimeRequired(R6PlayerController(PlayerController).m_pawn);
}

simulated function string R6GetCircumstantialActionString (int iAction)
{
	switch (iAction)
	{
/*		case 1:
		return Localize("RDVOrder","Order_DisarmBomb","R6Menu");
		case 2:
		return Localize("RDVOrder","Order_ArmBomb","R6Menu");
		default:     */
	}
	return "";
}

simulated function ToggleDevice (R6Pawn aPawn)
{
	if ( CanToggle() == False )
	{
		return;
	}
	Super.ToggleDevice(aPawn);
	if ( m_bIsActivated )
	{
		if ( aPawn.m_bCanDisarmBomb )
		{
//			m_eAnimToPlay=1;
			DisarmBomb(aPawn);
			if ( aPawn.m_bIsPlayer )
			{
//				R6PlayerController(aPawn.Controller).PlaySoundActionCompleted(m_eAnimToPlay);
			}
		}
	}
	else
	{
		if ( aPawn.m_bCanArmBomb )
		{
//			m_eAnimToPlay=0;
			ArmBomb(aPawn);
//			R6PlayerController(aPawn.Controller).PlaySoundActionCompleted(m_eAnimToPlay);
		}
	}
}

simulated function ArmBomb (R6Pawn aPawn)
{
	if ( m_bExploded )
	{
		return;
	}
	if ( m_bIsActivated && (aPawn != None) )
	{
		return;
	}
//	PlaySound(m_sndActivationBomb,3);
	if ( bShowLog )
	{
		Log("Arm BOMB " @ string(self));
	}
	m_bIsActivated=True;
	StartBombSound();
	m_fLastLevelTime=Level.TimeSeconds;
	SetTimer(0.10,True);
	m_fRepTimeLeft=m_fTimeOfExplosion;
	m_fTimeLeft=m_fTimeOfExplosion;
	SetSkin(m_ArmedTexture,0);
	R6AbstractGameInfo(Level.Game).IObjectInteract(aPawn,self);
}

simulated function DisarmBomb (R6Pawn aPawn)
{
	if ( (m_bIsActivated == False) || m_bExploded )
	{
		return;
	}
	if ( bShowLog )
	{
		Log("Disarm BOMB" @ string(self) @ "by pawn" @ string(aPawn) @ "and his controller" @ string(aPawn.Controller));
	}
	StopSoundBomb();
	m_bIsActivated=False;
	SetSkin(None,0);
	SetTimer(0.00,False);
	m_fRepTimeLeft=0.00;
	R6AbstractGameInfo(Level.Game).IObjectInteract(aPawn,self);
}

function StartBombSound ()
{
	if ( m_bIsActivated )
	{
		switch (m_eBeepState)
		{
/*			case 0:
			AmbientSound=m_sndPlayBeepNormal;
			AmbientSoundStop=m_sndStopBeepNormal;
			PlaySound(m_sndPlayBeepNormal,1);
			break;
			case 1:
			AmbientSound=m_sndPlayBeepFast;
			AmbientSoundStop=m_sndStopBeepFast;
			PlaySound(m_sndPlayBeepFast,1);
			break;
			case 2:
			AmbientSound=m_sndPlayBeepFaster;
			AmbientSoundStop=m_sndStopBeepFaster;
			PlaySound(m_sndPlayBeepFaster,1);
			break;
			default:       */
		}
	}
	else
	{
		AmbientSound=None;
	}
}

function StopSoundBomb ()
{
	if ( m_bIsActivated )
	{
		switch (m_eBeepState)
		{
/*			case 0:
			PlaySound(m_sndStopBeepNormal,1);
			break;
			case 1:
			PlaySound(m_sndStopBeepFast,1);
			break;
			case 2:
			PlaySound(m_sndStopBeepFaster,1);
			break;
			default:    */
		}
	}
//	m_eBeepState=0;
	AmbientSound=None;
	AmbientSoundStop=None;
}

simulated function bool HasKit (R6Pawn aPawn)
{
	return R6Rainbow(aPawn).m_bHasDiffuseKit;
}

simulated function float GetMaxTimeRequired ()
{
	return m_fDisarmBombTimeMax;
}

simulated function float GetTimeRequired (R6Pawn aPawn)
{
	local float fDisarmingBombTime;

	fDisarmingBombTime=m_fDisarmBombTimeMin + (1 - aPawn.GetSkill(SKILL_Electronics)) * (m_fDisarmBombTimeMax - m_fDisarmBombTimeMin);
	if ( HasKit(aPawn) && (fDisarmingBombTime - m_fGainTimeWithElectronicsKit > 0) )
	{
		fDisarmingBombTime -= m_fGainTimeWithElectronicsKit;
	}
	return fDisarmingBombTime;
}

defaultproperties
{
    m_iEnergy=3000
    m_fDisarmBombTimeMin=4.00
    m_fDisarmBombTimeMax=12.00
    m_fExplosionRadius=10000.00
    m_fKillBlastRadius=2000.00
    m_sndActivationBomb=Sound'Foley_Bomb.Play_BombActivationBeep'
    m_sndPlayBeepNormal=Sound'Foley_Bomb.Play_Seq_BombBeep'
    m_sndStopBeepNormal=Sound'Foley_Bomb.Stop_Seq_BombBeep'
    m_sndPlayBeepFast=Sound'Foley_Bomb.Stop_Seq_BombBeep_Go'
    m_sndStopBeepFast=Sound'Foley_Bomb.Stop_Seq_BombBeepFast'
    m_sndPlayBeepFaster=Sound'Foley_Bomb.Stop_Seq_BombBeepFast_Go'
    m_sndStopBeepFaster=Sound'Foley_Bomb.Stop_SeqBombBeepFinal'
    m_sndExplosion=Sound'Foley_Bomb.Bomb_Explosion'
    m_sndEarthQuake=Sound'Foley_Bomb.Play_EarthQuake'
    m_pExplosionLight=Class'R6SFX.R6GrenadeLight'
    m_vOffset=(X=0.00,Y=-70.00,Z=0.00)
    m_szIdentityID="BombA"
    m_szMsgArmedID="BombAArmed"
    m_szMsgDisarmedID="BombADisarmed"
    m_eAnimToPlay=1
    m_StartSnd=Sound'Foley_Bomb.Play_Bomb_Defusing'
    m_InterruptedSnd=Sound'Foley_Bomb.Stop_Go_Bomb_Defusing'
    m_CompletedSnd=Sound'Foley_Bomb.Stop_Go_Bomb_Defused'
    m_bRainbowCanInteract=True
    m_fSoundRadiusActivation=5600.00
    m_fCircumstantialActionRange=110.00
}
