//================================================================================
// R6InteractiveObject.
//================================================================================
class R6InteractiveObject extends Actor
	Native
//	NoNativeReplication
	Placeable;

struct stSpawnedActor
{
	var() Class<Actor> ActorToSpawn;
	var() string HelperName;
};

struct stRandomSkin
{
	var() float fPercentage;
	var() array<Material> Skin;
};

struct stRandomMesh
{
	var() float fPercentage;
	var() StaticMesh Mesh;
};

enum EInteractiveAction {
	IA_PlayAnim,
	IA_LookAt
};

struct stDamageState
{
	var() float fDamagePercentage;
	var() array<stRandomMesh> RandomMeshes;
	var() array<stRandomSkin> RandomSkins;
	var() array<stSpawnedActor> ActorList;
	var() array<Sound> SoundList;
	var() Sound NewAmbientSound;
	var() Sound NewAmbientSoundStop;
};

const c_iIObjectSkinMax= 4;
var ENoiseType m_HearNoiseType;
var int m_iActionNumber;
var int m_iActionIndex;
var(R6Damage) int m_iHitPoints;
var int m_iCurrentHitPoints;
var int m_iCurrentState;
var bool m_bCollisionRemovedFromActor;
var bool m_bOriginalCollideActors;
var bool m_bOriginalBlockActors;
var bool m_bOriginalBlockPlayers;
var bool m_bPawnDied;
var(Debug) bool bShowLog;
var bool m_bBroken;
var(R6ActionObject) bool m_bRainbowCanInteract;
var bool m_bEndAction;
var(Display) bool m_bBlockCoronas;
var(R6Damage) bool m_bBreakableByFlashBang;
var(R6Action) float m_fRadius;
var(R6Action) float m_fProbability;
var(R6Action) float m_fActionInterval;
var float m_fTimeSinceAction;
var float m_fTimeForNextSound;
var float m_fTimerInterval;
var float m_fPlayerCAStartTime;
var float m_HearNoiseLoudness;
var float m_fNetDamagePercentage;
var(R6Damage) float m_fAIBreakNoiseRadius;
var R6AIController m_InteractionOwner;
var(R6Action) Actor m_RemoveCollisionFromActor;
var(R6Action) NavigationPoint m_Anchor;
var(R6Action) Actor m_vEndActionGoto;
var R6InteractiveObjectAction m_CurrentInteractiveObject;
var Pawn m_SeePlayerPawn;
var Actor m_HearNoiseNoiseMaker;
var Material m_aOldSkins[4];
var Material m_aRepSkins[4];
var StaticMesh sm_staticMesh;
var R6Pawn m_User;
var Sound sm_AmbientSound;
var Sound sm_AmbientSoundStop;
var(R6Action) name m_vEndActionAnimName;
var(R6Action) editinlineuse array<R6InteractiveObjectAction> m_ActionList;
var array<Material> sm_aSkins;
var(R6Damage) array<stDamageState> m_StateList;
var(R6Attachments) array<Actor> m_AttachedActors;

replication
{
	reliable if ( Role == Role_Authority )
		m_fNetDamagePercentage,m_aRepSkins;
}

simulated function FirstPassReset ()
{
	m_User=None;
	m_InteractionOwner=None;
	m_SeePlayerPawn=None;
	m_HearNoiseNoiseMaker=None;
	m_bEndAction=False;
}

simulated function SaveOriginalData ()
{
	local int iSkin;

	if ( m_bResetSystemLog )
	{
		LogResetSystem(True);
	}
	Super.SaveOriginalData();
	sm_staticMesh=StaticMesh;
	if ( 4 < Skins.Length )
	{
		Log("WARNING c_iIObjectSkinMax < Skins.Length");
	}
	iSkin=0;
JL0061:
	if ( iSkin < Skins.Length )
	{
		if ( iSkin > 4 )
		{
			goto JL00CF;
		}
		sm_aSkins[iSkin]=Skins[iSkin];
		m_aOldSkins[iSkin]=Skins[iSkin];
		m_aRepSkins[iSkin]=Skins[iSkin];
		iSkin++;
		goto JL0061;
	}
JL00CF:
	sm_AmbientSound=AmbientSound;
	sm_AmbientSoundStop=AmbientSoundStop;
	m_fNetDamagePercentage=100.00;
}

simulated function ResetOriginalData ()
{
	local int i;

	if ( m_bResetSystemLog )
	{
		LogResetSystem(False);
	}
	Super.ResetOriginalData();
	AmbientSound=sm_AmbientSound;
	AmbientSoundStop=sm_AmbientSoundStop;
	if ( (m_fProbability != 0.00) && (Level.NetMode == NM_Standalone) || (Role == Role_Authority) )
	{
		SetTimer(m_fTimerInterval,True);
		m_iCurrentHitPoints=m_iHitPoints;
	}
	m_fNetDamagePercentage=100.00;
	m_iCurrentState=-1;
	m_fTimeSinceAction=0.00;
	m_fTimeForNextSound=9999999.00;
	m_InteractionOwner=None;
	m_bBroken=False;
	if ( m_bCollisionRemovedFromActor )
	{
		m_RemoveCollisionFromActor.SetCollision(m_bOriginalCollideActors,m_bOriginalBlockActors,m_bOriginalBlockPlayers);
		m_bCollisionRemovedFromActor=False;
	}
	Skins.Remove (0,Skins.Length);
	i=0;
JL00FA:
	if ( i < sm_aSkins.Length )
	{
		Skins[i]=sm_aSkins[i];
		m_aOldSkins[i]=Skins[i];
		m_aRepSkins[i]=Skins[i];
		i++;
		goto JL00FA;
	}
	if ( StaticMesh != sm_staticMesh )
	{
		ChangeStaticMesh(sm_staticMesh);
	}
}

function PostBeginPlay ()
{
	local int i;

	Super.PostBeginPlay();
	m_OutlineStaticMesh=StaticMesh;
	i=0;
JL0018:
	if ( i < m_AttachedActors.Length )
	{
		if ( m_AttachedActors[i] != None )
		{
			m_AttachedActors[i].SetBase(self);
			m_AttachedActors[i].m_AttachedTo=self;
		}
		i++;
		goto JL0018;
	}
}

simulated function SetSkin (Material aSkin, int iIndex)
{
	if ( iIndex > 4 )
	{
		return;
	}
	Skins[iIndex]=aSkin;
	m_aRepSkins[iIndex]=aSkin;
}

simulated function ChangeStaticMesh (StaticMesh sm)
{
	if ( (sm == None) && (StaticMesh != None) )
	{
		SetCollision(False,False,False);
	}
	else
	{
		if ( (sm != None) && (StaticMesh == None) )
		{
			SetCollision(Default.bCollideActors,Default.bBlockActors,Default.bBlockPlayers);
		}
	}
	SetStaticMesh(sm);
}

function FinishAction ();

simulated function Timer ()
{
	local R6Pawn P;

	m_fTimeSinceAction += m_fTimerInterval;
	if ( (Level.NetMode != 0) && (Role != 4) )
	{
		return;
	}
	if ( m_InteractionOwner != None )
	{
		if ( m_CurrentInteractiveObject.IsA('R6InteractiveObjectActionLoopAnim') || m_CurrentInteractiveObject.IsA('R6InteractiveObjectActionLoopRandomAnim') )
		{
			if ( (m_CurrentInteractiveObject.m_eSoundToPlay != None) && (m_CurrentInteractiveObject.m_eSoundToPlayStop != None) )
			{
				if ( m_fTimeSinceAction > m_fTimeForNextSound )
				{
					R6Pawn(m_InteractionOwner.Pawn).PlayVoices(m_CurrentInteractiveObject.m_eSoundToPlay,SLOT_Talk,15);
					m_fTimeForNextSound += RandRange(m_CurrentInteractiveObject.m_SoundRange.Min,m_CurrentInteractiveObject.m_SoundRange.Max);
				}
			}
		}
		return;
	}
	if ( (FRand() < m_fProbability) && (m_fTimeSinceAction >= m_fActionInterval) )
	{
		foreach VisibleCollidingActors(Class'R6Pawn',P,m_fRadius,Location)
		{
			if ( (R6AIController(P.Controller) != None) && R6AIController(P.Controller).CanInteractWithObjects(self) )
			{
				m_fTimeSinceAction=0.00;
				PerformAction(P);
			}
			else
			{
			}
		}
	}
}

simulated function SetBroken ()
{
	m_bBroken=True;
	StopInteraction();
	SetTimer(0.00,False);
}

function StopInteraction ()
{
	if ( Level.m_bIsResettingLevel )
	{
		return;
	}
	if ( m_InteractionOwner != None )
	{
		m_InteractionOwner.PerformAction_StopInteraction();
		m_InteractionOwner.m_bCantInterruptIO=False;
		m_InteractionOwner.m_InteractionObject=None;
		m_InteractionOwner=None;
		m_bEndAction=False;
		if ( m_bCollisionRemovedFromActor )
		{
			m_RemoveCollisionFromActor.SetCollision(m_bOriginalCollideActors,m_bOriginalBlockActors,m_bOriginalBlockPlayers);
			m_bCollisionRemovedFromActor=False;
		}
	}
}

function StopInteractionWithEndingActions ()
{
	if ( Level.m_bIsResettingLevel )
	{
		return;
	}
	if (  !m_bEndAction )
	{
		m_bEndAction=True;
		m_iActionIndex=m_iActionNumber;
		FinishAction();
	}
}

function PerformAction (R6Pawn P)
{
	m_InteractionOwner=R6AIController(P.Controller);
	m_InteractionOwner.m_InteractionObject=self;
	m_iActionIndex=-1;
	m_iActionNumber=m_ActionList.Length;
	if ( m_RemoveCollisionFromActor != None )
	{
		m_bOriginalCollideActors=m_RemoveCollisionFromActor.bCollideActors;
		m_bOriginalBlockActors=m_RemoveCollisionFromActor.bBlockActors;
		m_bOriginalBlockPlayers=m_RemoveCollisionFromActor.bBlockPlayers;
		m_RemoveCollisionFromActor.SetCollision(False,False,False);
		m_bCollisionRemovedFromActor=True;
	}
	GotoState('PA_ExecuteStartInteraction');
}

function SwitchToNextAction ()
{
	m_iActionIndex++;
	if ( m_iActionIndex >= m_iActionNumber )
	{
		GotoState('PA_ExecutePlayEnding');
		return;
	}
	m_CurrentInteractiveObject=m_ActionList[m_iActionIndex];
	if ( (m_CurrentInteractiveObject.m_eSoundToPlay != None) && (m_CurrentInteractiveObject.m_eSoundToPlayStop != None) )
	{
		R6Pawn(m_InteractionOwner.Pawn).PlayVoices(m_CurrentInteractiveObject.m_eSoundToPlay,SLOT_Talk,15);
		if ( m_iActionIndex == 0 )
		{
			m_fTimeForNextSound=RandRange(m_CurrentInteractiveObject.m_SoundRange.Min,m_CurrentInteractiveObject.m_SoundRange.Max);
		}
	}
	switch (m_CurrentInteractiveObject.m_eType)
	{
/*		case 2:
		GotoState('PA_ExecuteLookAt');
		break;
		case 0:
		GotoState('PA_ExecuteGoto');
		break;
		case 1:
		GotoState('PA_ExecutePlayAnim');
		break;
		case 3:
		GotoState('PA_ExecuteLoopAnim');
		break;
		case 4:
		GotoState('PA_ExecuteLoopRandomAnim');
		break;
		case 5:
		GotoState('PA_ExecuteToggleDevice');
		break;
		default: */
	}
}

state PA_Execute
{
	function FinishAction ()
	{
		SwitchToNextAction();
	}

}

state PA_ExecuteStartInteraction extends PA_Execute
{
Begin:
	m_InteractionOwner.PerformAction_StartInteraction();
}

state PA_ExecuteLookAt extends PA_Execute
{
Begin:
	m_InteractionOwner.PerformAction_LookAt(R6InteractiveObjectActionLookAt(m_CurrentInteractiveObject).m_Target);
}

state PA_ExecuteGoto extends PA_Execute
{
Begin:
	m_InteractionOwner.PerformAction_Goto(R6InteractiveObjectActionGoto(m_CurrentInteractiveObject).m_Target);
}

state PA_ExecuteToggleDevice extends PA_Execute
{
	function ActionDetonateAllBombs ()
	{
		local int i;
		local R6InteractiveObjectActionToggleDevice ioAction;

		ioAction=R6InteractiveObjectActionToggleDevice(m_CurrentInteractiveObject);
	JL0010:
		if ( i < ioAction.m_aIOBombs.Length )
		{
			ioAction.m_aIOBombs[i].DetonateBomb(R6Pawn(m_InteractionOwner.Pawn));
			++i;
			goto JL0010;
		}
	}

	function ActionToggleDevice ()
	{
		local R6InteractiveObjectActionToggleDevice ioAction;

		ioAction=R6InteractiveObjectActionToggleDevice(m_CurrentInteractiveObject);
		if ( ioAction.m_iodevice != None )
		{
			ioAction.m_iodevice.ToggleDevice(R6Pawn(m_InteractionOwner.Pawn));
		}
	}

Begin:
	ActionToggleDevice();
	ActionDetonateAllBombs();
	FinishAction();
}

state PA_ExecutePlayAnim extends PA_Execute
{
Begin:
	m_InteractionOwner.PerformAction_PlayAnim(R6InteractiveObjectActionPlayAnim(m_CurrentInteractiveObject).m_vAnimName);
}

state PA_ExecuteLoopAnim extends PA_Execute
{
Begin:
	m_InteractionOwner.PerformAction_LoopAnim(R6InteractiveObjectActionLoopAnim(m_CurrentInteractiveObject).m_vAnimName,RandRange(R6InteractiveObjectActionLoopAnim(m_CurrentInteractiveObject).m_LoopTime.Min,R6InteractiveObjectActionLoopAnim(m_CurrentInteractiveObject).m_LoopTime.Max));
}

state PA_ExecuteLoopRandomAnim extends PA_Execute
{
	function FinishAction ()
	{
		if ( m_iActionIndex >= m_iActionNumber )
		{
			SwitchToNextAction();
		}
		else
		{
			GotoState('PA_ExecuteLoopRandomAnim');
		}
	}

Begin:
	m_InteractionOwner.PerformAction_PlayAnim(R6InteractiveObjectActionLoopRandomAnim(m_CurrentInteractiveObject).GetNextAnim());
}

state PA_ExecutePlayEnding extends PA_Execute
{
	function FinishAction ()
	{
		GotoState('PA_ExecuteGotoEnding');
	}

Begin:
	if ( m_vEndActionAnimName != 'None' )
	{
		m_InteractionOwner.PerformAction_PlayAnim(m_vEndActionAnimName);
	}
	else
	{
		FinishAction();
	}
}

state PA_ExecuteGotoEnding extends PA_Execute
{
	function FinishAction ()
	{
		StopInteraction();
	}

Begin:
	if ( m_vEndActionGoto != None )
	{
//		m_InteractionOwner.R6SetMovement(5);
		m_InteractionOwner.PerformAction_Goto(m_vEndActionGoto);
	}
	else
	{
		FinishAction();
	}
}

function int R6TakeDamage (int iKillValue, int iStunValue, Pawn instigatedBy, Vector vHitLocation, Vector vMomentum, int iBulletToArmorModifier, optional int iBulletGroup)
{
	local float fPercentage;

	if ( m_bBroken )
	{
		return 0;
	}
	if ( (Level.NetMode == NM_Standalone) || (Role == Role_Authority) )
	{
		if ( bShowLog )
		{
			Log("m_iCurrentHitPoints = " $ string(m_iCurrentHitPoints) $ " Damage: " $ string(iKillValue));
		}
		m_iCurrentHitPoints=Max(m_iCurrentHitPoints - iKillValue,0);
		fPercentage=m_iCurrentHitPoints * 100 / m_iHitPoints;
		if ( bShowLog )
		{
			Log("New Hit Point = " $ string(m_iCurrentHitPoints) $ " Percentage: " $ string(fPercentage));
		}
		SetNewDamageState(fPercentage);
		if ( m_bBroken )
		{
			R6AbstractGameInfo(Level.Game).IObjectDestroyed(instigatedBy,self);
			Instigator=instigatedBy;
//			R6MakeNoise2(m_fAIBreakNoiseRadius,2,4);
		}
	}
	if ( m_bBulletGoThrough == True )
	{
		return iKillValue;
	}
	else
	{
		return 0;
	}
}

simulated event SetNewDamageState (float fPercentage)
{
	local int iState;
	local int iRandomMesh;
	local int iRandomSkin;
	local int iStateToUse;
	local float fRandValue;
	local int iActor;
	local int iSkin;
	local stDamageState stState;
	local Vector vTagLocation;
	local Rotator rTagRotator;
	local Actor SpawnedActor;

	if ( (Level.NetMode == NM_ListenServer) || (Level.NetMode == NM_DedicatedServer) )
	{
		m_fNetDamagePercentage=fPercentage;
	}
	iStateToUse=-1;
	iState=0;
JL0051:
	if ( iState < m_StateList.Length )
	{
		stState=m_StateList[iState];
		if ( (fPercentage <= stState.fDamagePercentage) && (stState.fDamagePercentage <= m_StateList[iState].fDamagePercentage) )
		{
			iStateToUse=iState;
		}
		iState++;
		goto JL0051;
	}
	if ( bShowLog )
	{
		Log("New State = " $ string(iState));
	}
	if ( iStateToUse == m_iCurrentState )
	{
		return;
	}
	if ( iStateToUse == m_StateList.Length - 1 )
	{
		SetBroken();
	}
	if ( iStateToUse != -1 )
	{
		stState=m_StateList[iStateToUse];
		m_iCurrentState=iStateToUse;
	}
	fRandValue=FRand() * 100.00;
	if ( stState.RandomMeshes.Length != 0 )
	{
		iRandomMesh=0;
JL015A:
		if ( iRandomMesh < stState.RandomMeshes.Length )
		{
			fRandValue -= stState.RandomMeshes[iRandomMesh].fPercentage;
			if ( fRandValue < 0 )
			{
				ChangeStaticMesh(stState.RandomMeshes[iRandomMesh].Mesh);
			}
			else
			{
				iRandomMesh++;
				goto JL015A;
			}
		}
		if ( fRandValue > 0 )
		{
			ChangeStaticMesh(stState.RandomMeshes[stState.RandomMeshes.Length - 1].Mesh);
		}
	}
	if ( stState.RandomSkins.Length != 0 )
	{
		iRandomSkin=0;
JL0209:
		if ( iRandomSkin < stState.RandomSkins.Length )
		{
			fRandValue -= stState.RandomSkins[iRandomSkin].fPercentage;
			if ( fRandValue < 0 )
			{
				iSkin=0;
JL024E:
				if ( iSkin < stState.RandomSkins[iRandomSkin].Skin.Length )
				{
					SetSkin(stState.RandomSkins[iRandomSkin].Skin[iSkin],iSkin);
					iSkin++;
					goto JL024E;
				}
			}
			else
			{
				iRandomSkin++;
				goto JL0209;
			}
		}
		if ( fRandValue > 0 )
		{
			iSkin=0;
JL02BF:
			if ( iSkin < stState.RandomSkins[stState.RandomSkins.Length - 1].Skin.Length )
			{
				SetSkin(stState.RandomSkins[stState.RandomSkins.Length - 1].Skin[iSkin],iSkin);
				iSkin++;
				goto JL02BF;
			}
		}
	}
	if ( Level.NetMode != 1 )
	{
		iActor=0;
JL0341:
		if ( iActor < stState.ActorList.Length )
		{
			if ( stState.ActorList[iActor].ActorToSpawn == None )
			{
				goto JL0407;
			}
			if ( stState.ActorList[iActor].HelperName != "" )
			{
				GetTagInformations(stState.ActorList[iActor].HelperName,vTagLocation,rTagRotator);
			}
			SpawnedActor=Spawn(stState.ActorList[iActor].ActorToSpawn,,,Location + vTagLocation,Rotation + rTagRotator);
			if ( SpawnedActor != None )
			{
				SpawnedActor.RemoteRole=ROLE_None;
			}
JL0407:
			iActor++;
			goto JL0341;
		}
	}
	if ( Role == Role_Authority )
	{
		PlayInteractiveObjectSound(stState);
	}
}

function PlayInteractiveObjectSound (stDamageState stState)
{
	local int iSound;

	iSound=0;
JL0007:
	if ( iSound < stState.SoundList.Length )
	{
//		PlaySound(stState.SoundList[iSound],3);
		iSound++;
		goto JL0007;
	}
}

defaultproperties
{
    m_fRadius=128.00
    m_fActionInterval=10.00
    m_fTimerInterval=1.00
    m_fAIBreakNoiseRadius=500.00
    bNoDelete=True
    m_bUseR6Availability=True
    bAcceptsProjectors=True
    bAlwaysRelevant=True
    bSkipActorPropertyReplication=True
    bShadowCast=True
    bStaticLighting=True
    bCollideActors=True
    bBlockActors=True
    bBlockPlayers=True
    bPathColliding=True
    m_bForceStaticLighting=True
}
