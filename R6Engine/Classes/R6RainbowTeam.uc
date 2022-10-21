//================================================================================
// R6RainbowTeam.
//================================================================================
class R6RainbowTeam extends Actor
	Native;
//	NoNativeReplication;

enum eFormation {
	FORM_SingleFile,
	FORM_SingleFileWallBothSides,
	FORM_SingleFileWallRight,
	FORM_SingleFileWallLeft,
	FORM_SingleFileNoWalls,
	FORM_OrientedSingleFile,
	FORM_Diamond
};

enum eTeamState {
	TS_None,
	TS_Waiting,
	TS_Holding,
	TS_Moving,
	TS_Following,
	TS_Regrouping,
	TS_Engaging,
	TS_Sniping,
	TS_LockPicking,
	TS_OpeningDoor,
	TS_ClosingDoor,
	TS_Opening,
	TS_Closing,
	TS_ClearingRoom,
	TS_Grenading,
	TS_DisarmingBomb,
	TS_InteractWithDevice,
	TS_SecuringTerrorist,
	TS_ClimbingLadder,
	TS_WaitingForOrders,
	TS_SettingBreach,
	TS_Retired
};

enum eWeaponGrenadeType {
	GT_GrenadeNone,
	GT_GrenadeFrag,
	GT_GrenadeGas,
	GT_GrenadeFlash,
	GT_GrenadeSmoke
};

enum EWeaponSound {
	WSOUND_None,
	WSOUND_Initialize,
	WSOUND_PlayTrigger,
	WSOUND_PlayFireSingleShot,
	WSOUND_PlayFireEndSingleShot,
	WSOUND_PlayFireThreeBurst,
	WSOUND_PlayFireFullAuto,
	WSOUND_PlayEmptyMag,
	WSOUND_PlayReloadEmpty,
	WSOUND_PlayReload,
	WSOUND_StopFireFullAuto
};

enum ePlayerRoomEntry {
	PRE_Center,
	PRE_Left,
	PRE_Right
};

var byte m_bHasGrenade;
var eFormation m_eFormation;
var eFormation m_eRequestedFormation;
var ePlayerRoomEntry m_ePlayerRoomEntry;
var eWeaponGrenadeType m_eEntryGrenadeType;
var EMovementMode m_eMovementMode;
var EMovementSpeed m_eMovementSpeed;
var EPlanAction m_ePlanAction;
var EPlanAction m_eNextAPAction;
var EPlanAction m_ePlayerAPAction;
var eTeamState m_eTeamState;
var eTeamState m_eBackupTeamState;
var EGoCode m_eGoCode;
var EGoCode m_eBackupGoCode;
var int m_iMemberCount;
var int m_iIDVoicesMgr;
var int m_iFormationDistance;
var int m_iDiagonalDistance;
var int m_iTeamHealth[4];
var int m_iMembersLost;
var int m_iGrenadeThrower;
var int m_iIntermLeader;
var int m_iSpawnDistance;
var int m_iSpawnDiagDist;
var int m_iSpawnDiagOther;
var int m_iSubAction;
var int m_iRainbowTeamName;
var int m_iTeamAction;
var bool m_bLeaderIsAPlayer;
var bool m_bPlayerHasFocus;
var bool m_bPlayerInGhostMode;
var bool m_bTeamIsClimbingLadder;
var bool m_bTeamIsSeparatedFromLeader;
var bool m_bGrenadeInProximity;
var bool m_bGasGrenadeInProximity;
var bool m_bEntryInProgress;
var bool m_bDoorOpensTowardTeam;
var bool m_bDoorOpensClockWise;
var bool m_bRainbowIsInFrontOfDoor;
var bool m_bWoundedHostage;
var bool m_bCAWaitingForZuluGoCode;
var bool m_bPreventUsingTeam;
var bool m_bSniperReady;
var bool m_bSkipAction;
var bool m_bWasSeparatedFromLeader;
var bool m_bAllTeamsHold;
var bool m_bTeamIsHoldingPosition;
var bool m_bSniperHold;
var bool m_bTeamIsRegrouping;
var bool m_bPlayerRequestedTeamReform;
var bool m_bPendingSnipeUntilGoCode;
var bool m_bTeamIsEngagingEnemy;
var bool bShowLog;
var bool bPlanningLog;
var bool m_bFirstTimeInGas;
var float m_fEngagingTimer;
var R6Rainbow m_Team[4];
var R6GameColors Colors;
var R6RainbowPlayerVoices m_PlayerVoicesMgr;
var R6RainbowMemberVoices m_MemberVoicesMgr;
var R6RainbowOtherTeamVoices m_OtherTeamVoicesMgr;
var R6MultiCommonVoices m_MultiCommonVoicesMgr;
var R6MultiCoopVoices m_MultiCoopPlayerVoicesMgr;
var R6MultiCoopVoices m_MultiCoopMemberVoicesMgr;
var R6PreRecordedMsgVoices m_PreRecMsgVoicesMgr;
var R6Rainbow m_TeamLeader;
var R6AbstractPlanningInfo m_TeamPlanning;
var R6Pawn m_PawnControllingDoor;
var R6Ladder m_TeamLadder;
var R6Door m_Door;
var R6CircumstantialActionQuery m_actionRequested;
var Actor m_PlanActionPoint;
var R6IORotatingDoor m_BreachingDoor;
var Actor m_LastActionPoint;
var R6Pawn m_SurrenderedTerrorist;
var R6Pawn m_HostageToRescue;
var Actor m_PlayerLastActionPoint;
var array<R6InteractiveObject> m_InteractiveObjectList;
var Color m_TeamColour;
var Rotator m_rTeamDirection;
var Vector m_vActionLocation;
var Vector m_vPlanActionLocation;
var Rotator m_rSnipingDir;
var Vector m_vPreviousPosition;
var Vector m_vNoiseSource;
const c_iMaxTeam= 4;

replication
{
	reliable if ( Role == Role_Authority )
		ClientUpdateFirstPersonWpnAndPeeking;
	reliable if ( Role < Role_Authority )
		TeamActionRequestWaitForZuluGoCode,TeamActionRequestFromRoseDesVents,TeamActionRequest;
	reliable if ( Role == Role_Authority )
		m_bHasGrenade,m_eTeamState,m_eGoCode,m_iMemberCount,m_iMembersLost,m_Team,m_TeamColour;
	reliable if ( Role == Role_Authority )
		m_bTeamIsClimbingLadder;
}

function SetTeamState (eTeamState eNewState)
{
	if ( m_bLeaderIsAPlayer && (m_iMemberCount == 1) ||  !m_bLeaderIsAPlayer && (m_iMemberCount == 0) )
	{
//		m_eTeamState=21;
	}
	else
	{
		if ( m_eTeamState != 6 )
		{
//			m_eTeamState=eNewState;
		}
		else
		{
//			m_eBackupTeamState=eNewState;
		}
	}
}

function TeamIsSeparatedFromLead (bool bSeparated)
{
	if ( m_iMemberCount <= 1 )
	{
		return;
	}
	m_bTeamIsSeparatedFromLeader=bSeparated;
}

function TeamIsRegroupingOnLead (bool bIsRegrouping)
{
	local bool bPreviousTeamIsRegrouping;

	bPreviousTeamIsRegrouping=m_bTeamIsRegrouping;
	if ( m_bLeaderIsAPlayer && m_bPlayerRequestedTeamReform && m_bTeamIsRegrouping &&  !bIsRegrouping )
	{
		m_bPlayerRequestedTeamReform=False;
//		m_MemberVoicesMgr.PlayRainbowMemberVoices(m_Team[1],5);
	}
	m_bTeamIsRegrouping=bIsRegrouping;
	TeamIsSeparatedFromLead(bIsRegrouping);
	if ( bIsRegrouping )
	{
//		SetTeamState(5);
	}
	if (  !bIsRegrouping && bPreviousTeamIsRegrouping )
	{
		Escort_ManageList();
	}
}

simulated event Destroyed ()
{
	if ( m_actionRequested != None )
	{
		m_actionRequested.Destroy();
		m_actionRequested=None;
	}
	Super.Destroyed();
}

event PostBeginPlay ()
{
	local R6InteractiveObject IntObject;

	Super.PostBeginPlay();
	foreach AllActors(Class'R6InteractiveObject',IntObject)
	{
		if ( IntObject.m_bRainbowCanInteract )
		{
			m_InteractiveObjectList[m_InteractiveObjectList.Length]=IntObject;
		}
	}
	m_actionRequested=Spawn(Class'R6CircumstantialActionQuery');
}

simulated event PostNetBeginPlay ()
{
	Colors=new Class'R6GameColors';
}

function CreateMPPlayerTeam (PlayerController MyPlayer, R6RainbowStartInfo Info, int iMemberCount, PlayerStart Start)
{
	local int i;
	local int iMembersToSpawn;

	if ( m_iMemberCount > 0 )
	{
		return;
	}
	m_bLeaderIsAPlayer=True;
	m_Team[0]=R6Rainbow(MyPlayer.Pawn);
	m_TeamLeader=m_Team[0];
	m_iTeamHealth[0]=0;
	m_iMemberCount=1;
	m_Team[0].m_FaceTexture=Info.m_FaceTexture;
	m_Team[0].m_FaceCoords=Info.m_FaceCoords;
	i=1;
JL0092:
	if ( i < iMemberCount )
	{
		CreateTeamMember(Info,Start,False);
		m_iTeamHealth[i]=0;
		i++;
		goto JL0092;
	}
	UpdateTeamGrenadeStatus();
	Info.Destroy();
}

function SetMultiVoicesMgr (R6AbstractGameInfo aGameInfo, int iTeamNumber, int iMemberCount)
{
	local bool bCoopGameType;

	m_MultiCommonVoicesMgr=None;
	m_MultiCoopPlayerVoicesMgr=None;
	m_MultiCoopMemberVoicesMgr=None;
	m_PreRecMsgVoicesMgr=None;
	bCoopGameType=Level.IsGameTypeCooperative(Level.Game.m_eGameTypeFlag);
	if ( bCoopGameType || Level.IsGameTypeTeamAdversarial(Level.Game.m_eGameTypeFlag) )
	{
		m_MultiCommonVoicesMgr=R6MultiCommonVoices(aGameInfo.GetMultiCommonVoicesMgr());
		m_PreRecMsgVoicesMgr=R6PreRecordedMsgVoices(aGameInfo.GetPreRecordedMsgVoicesMgr());
	}
	if ( bCoopGameType || Level.IsGameTypePlayWithNonRainbowNPCs(Level.Game.m_eGameTypeFlag) )
	{
		SetVoicesMgr(aGameInfo,True,True);
	}
	if ( bCoopGameType )
	{
		m_MultiCoopPlayerVoicesMgr=R6MultiCoopVoices(aGameInfo.GetMultiCoopPlayerVoicesMgr(Level.Game.CurrentID - Level.Game.Default.CurrentID));
		if ( iMemberCount > 1 )
		{
			m_MultiCoopMemberVoicesMgr=R6MultiCoopVoices(aGameInfo.GetMultiCoopMemberVoicesMgr());
		}
	}
}

function SetVoicesMgr (R6AbstractGameInfo aGameInfo, bool bPlayerTeamStart, bool bPlayerInTeam, optional int iIDVoicesMgr, optional bool bInGhostMode)
{
	m_PlayerVoicesMgr=None;
	m_MemberVoicesMgr=None;
	m_OtherTeamVoicesMgr=None;
	m_bPlayerInGhostMode=bInGhostMode;
	if (  !bPlayerTeamStart && bPlayerInTeam )
	{
		m_bPlayerHasFocus=True;
	}
	else
	{
		m_bPlayerHasFocus=False;
	}
	m_PlayerVoicesMgr=R6RainbowPlayerVoices(aGameInfo.GetRainbowPlayerVoicesMgr());
	if ( bPlayerTeamStart )
	{
		if ( m_iMemberCount > 1 )
		{
			m_MemberVoicesMgr=R6RainbowMemberVoices(aGameInfo.GetRainbowMemberVoicesMgr());
		}
	}
	else
	{
		if ( m_bPlayerHasFocus &&  !m_bPlayerInGhostMode )
		{
			m_MemberVoicesMgr=R6RainbowMemberVoices(aGameInfo.GetRainbowMemberVoicesMgr());
			m_MultiCoopMemberVoicesMgr=R6MultiCoopVoices(aGameInfo.GetMultiCoopMemberVoicesMgr());
		}
		else
		{
			if ( m_iMemberCount > 1 )
			{
				aGameInfo.GetRainbowMemberVoicesMgr();
				aGameInfo.GetCommonRainbowMemberVoicesMgr();
			}
			m_iIDVoicesMgr=iIDVoicesMgr;
			m_OtherTeamVoicesMgr=R6RainbowOtherTeamVoices(aGameInfo.GetRainbowOtherTeamVoicesMgr(iIDVoicesMgr));
		}
	}
}

function CreatePlayerTeam (R6TeamStartInfo TeamInfo, NavigationPoint StartingPoint, PlayerController aRainbowPC)
{
	local int i;

	if ( m_iMemberCount > 0 )
	{
		return;
	}
	m_bLeaderIsAPlayer=True;
	m_iMemberCount=0;
	i=0;
JL0023:
	if ( i < TeamInfo.m_iNumberOfMembers )
	{
		CreateTeamMember(TeamInfo.m_CharacterInTeam[i],StartingPoint,m_iMemberCount == 0,R6PlayerController(aRainbowPC));
		m_iTeamHealth[i]=TeamInfo.m_CharacterInTeam[i].m_iHealth;
		i++;
		goto JL0023;
	}
	UpdateTeamGrenadeStatus();
}

function CreateAITeam (R6TeamStartInfo TeamInfo, NavigationPoint StartingPoint)
{
	local int i;

	if ( m_iMemberCount > 0 )
	{
		return;
	}
	m_bLeaderIsAPlayer=False;
	m_TeamLeader=None;
	m_iMemberCount=0;
	i=0;
JL002A:
	if ( i < TeamInfo.m_iNumberOfMembers )
	{
		CreateTeamMember(TeamInfo.m_CharacterInTeam[i],StartingPoint,False);
		m_iTeamHealth[i]=TeamInfo.m_CharacterInTeam[i].m_iHealth;
		i++;
		goto JL002A;
	}
	UpdateTeamGrenadeStatus();
}

function CreateTeamMember (R6RainbowStartInfo RainbowToCreate, NavigationPoint StartingPoint, optional bool bPlayer, optional R6PlayerController RainbowPC)
{
	local R6RainbowAI rainbowAI;
	local Vector vOriginStart;
	local Vector vStart;
	local Class<R6Rainbow> rainbowPawnClass;
	local R6Rainbow Rainbow;
	local int iSpawnTry;
	local Rotator rPosOrientation;
	local Rotator rStartingPointRot;

	if ( Level.NetMode == NM_Client )
	{
		return;
	}
	if ( (Level.NetMode == NM_Standalone) && (m_TeamPlanning.m_NodeList.Length != 0) )
	{
		vOriginStart=m_TeamPlanning.m_NodeList[0].Location;
		rStartingPointRot=m_TeamPlanning.m_NodeList[0].Rotation;
	}
	else
	{
		vOriginStart=StartingPoint.Location;
		rStartingPointRot=StartingPoint.Rotation;
	}
	rStartingPointRot.Roll=0;
	iSpawnTry=0;
JL00C7:
	if ( iSpawnTry != -1 )
	{
		if ( iSpawnTry == 0 )
		{
			vStart=vOriginStart;
		}
		else
		{
			if ( iSpawnTry < 8 )
			{
				rPosOrientation=rStartingPointRot;
				rPosOrientation.Yaw += 32768 + 8192 * (iSpawnTry + 1);
				if ( (iSpawnTry == 1) || (iSpawnTry == 3) || (iSpawnTry == 5) || (iSpawnTry == 7) )
				{
//					vStart=vOriginStart - m_iSpawnDistance * rPosOrientation;
				}
				else
				{
//					vStart=vOriginStart - m_iSpawnDiagDist * rPosOrientation;
				}
			}
			else
			{
				if ( iSpawnTry < 24 )
				{
					rPosOrientation=rStartingPointRot;
					rPosOrientation.Yaw += 32768 + 16384 + 4096 * (iSpawnTry - 9);
					if ( (iSpawnTry == 9) || (iSpawnTry == 13) || (iSpawnTry == 17) || (iSpawnTry == 21) )
					{
//						vStart=vOriginStart - m_iSpawnDistance * 2 * rPosOrientation;
					}
					else
					{
						if ( (iSpawnTry == 11) || (iSpawnTry == 15) || (iSpawnTry == 19) || (iSpawnTry == 23) )
						{
//							vStart=vOriginStart - m_iSpawnDiagDist * 2 * rPosOrientation;
						}
						else
						{
//							vStart=vOriginStart - m_iSpawnDiagOther * rPosOrientation;
						}
					}
				}
				else
				{
					Log("    Rainbow6    <R6GameInfo::CreateTeamMember> attempt to create a rainbow member failed!!");
					return;
				}
			}
		}
		if ( iSpawnTry == 0 )
		{
			if ( RainbowToCreate == None )
			{
				return;
			}
			if ( RainbowToCreate.m_ArmorName == "" )
			{
				return;
			}
			rainbowPawnClass=Class<R6Rainbow>(DynamicLoadObject(RainbowToCreate.m_ArmorName,Class'Class'));
			rainbowPawnClass.Default.m_iOperativeID=RainbowToCreate.m_iOperativeID;
			rainbowPawnClass.Default.bIsFemale= !RainbowToCreate.m_bIsMale;
		}
		Rainbow=Spawn(rainbowPawnClass,,,vStart,rStartingPointRot,False);
		if ( Rainbow == None )
		{
			iSpawnTry++;
		}
		else
		{
			Rainbow.m_szPrimaryWeapon=RainbowToCreate.m_WeaponName[0];
			Rainbow.m_szPrimaryGadget=RainbowToCreate.m_WeaponGadgetName[0];
			Rainbow.m_szPrimaryBulletType=RainbowToCreate.m_BulletType[0];
			Rainbow.m_szSecondaryWeapon=RainbowToCreate.m_WeaponName[1];
			Rainbow.m_szSecondaryGadget=RainbowToCreate.m_WeaponGadgetName[1];
			Rainbow.m_szSecondaryBulletType=RainbowToCreate.m_BulletType[1];
			Rainbow.m_szPrimaryItem=RainbowToCreate.m_GadgetName[0];
			Rainbow.m_szSecondaryItem=RainbowToCreate.m_GadgetName[1];
			Rainbow.m_szSpecialityID=RainbowToCreate.m_szSpecialityID;
			Rainbow.m_FaceTexture=RainbowToCreate.m_FaceTexture;
			Rainbow.m_FaceCoords=RainbowToCreate.m_FaceCoords;
			if ( Level.NetMode == NM_Standalone )
			{
				Rainbow.m_fSkillAssault=RainbowToCreate.m_fSkillAssault;
				Rainbow.m_fSkillDemolitions=RainbowToCreate.m_fSkillDemolitions;
				Rainbow.m_fSkillElectronics=RainbowToCreate.m_fSkillElectronics;
				Rainbow.m_fSkillSniper=RainbowToCreate.m_fSkillSniper;
				Rainbow.m_fSkillStealth=RainbowToCreate.m_fSkillStealth;
				Rainbow.m_fSkillSelfControl=RainbowToCreate.m_fSkillSelfControl;
				Rainbow.m_fSkillLeadership=RainbowToCreate.m_fSkillLeadership;
				Rainbow.m_fSkillObservation=RainbowToCreate.m_fSkillObservation;
			}
			switch (RainbowToCreate.m_iHealth)
			{
/*				case 0:
				Rainbow.m_eHealth=HEALTH_Healthy;
				break;
				case 1:
				Rainbow.m_eHealth=HEALTH_Wounded;
				break;
				case 2:
				Rainbow.m_eHealth=HEALTH_Incapacitated;
				break;
				case 3:
				Rainbow.m_eHealth=HEALTH_Dead;
				break;
				default:
				Rainbow.m_eHealth=HEALTH_Healthy;   */
			}
			iSpawnTry=-1;
		}
		goto JL00C7;
	}
	Rainbow.m_vStartLocation=vStart;
	Rainbow.m_CharacterName=RainbowToCreate.m_CharacterName;
	if ( bPlayer )
	{
		if ( Level.NetMode == NM_Standalone )
		{
			RainbowPC.SetLocation(vStart);
			R6AbstractGameInfo(Level.Game).m_Player=RainbowPC;
			RainbowPC.m_CurrentVolumeSound=Rainbow.m_CurrentVolumeSound;
			RainbowPC.Possess(Rainbow);
			RainbowPC.GameReplicationInfo=Level.Game.GameReplicationInfo;
			Rainbow.Controller=RainbowPC;
			RainbowPC.Focus=None;
			RainbowPC.m_CurrentAmbianceObject=Rainbow.Region.Zone;
		}
	}
	else
	{
		if ( Level.NetMode == NM_Standalone )
		{
			rainbowAI=Spawn(Class'R6RainbowAI',,,vStart,StartingPoint.Rotation);
		}
		else
		{
			rainbowAI=R6RainbowAI(R6AbstractGameInfo(Level.Game).GetRainbowAIFromTable());
		}
		rainbowAI.Possess(Rainbow);
		Rainbow.Controller=rainbowAI;
		rainbowAI.Focus=None;
	}
	m_Team[m_iMemberCount]=Rainbow;
	if ( m_TeamLeader == None )
	{
		m_TeamLeader=Rainbow;
		if (  !bPlayer )
		{
			rainbowAI.m_TeamLeader=None;
			rainbowAI.NextState='Patrol';
			rainbowAI.GotoState('WaitForGameToStart');
		}
		GetFirstActionPoint();
	}
	else
	{
		rainbowAI.m_TeamLeader=m_TeamLeader;
		rainbowAI.NextState='FollowLeader';
		rainbowAI.GotoState('WaitForGameToStart');
	}
	if ( bPlayer )
	{
		if ( Level.NetMode == NM_Standalone )
		{
			RainbowPC.SetRotation(StartingPoint.Rotation);
			RainbowPC.m_TeamManager=self;
		}
	}
	else
	{
		rainbowAI.SetRotation(StartingPoint.Rotation);
		rainbowAI.m_TeamManager=self;
	}
	Rainbow.m_iID=m_iMemberCount;
	Rainbow.m_iPermanentID=Rainbow.m_iID;
	m_iMemberCount++;
	Rainbow.GiveDefaultWeapon();
}

function ResetRainbowTeam ()
{
	local int i;

	m_bTeamIsClimbingLadder=False;
	m_bEntryInProgress=False;
	m_bRainbowIsInFrontOfDoor=False;
	if ( m_iMemberCount <= 1 )
	{
		return;
	}
	i=1;
JL002C:
	if ( i < m_iMemberCount )
	{
		m_Team[i].Controller.GotoState('FollowLeader');
		i++;
		goto JL002C;
	}
}

function bool LastMemberIsStationary ()
{
	if ( m_Team[m_iMemberCount - 1].IsStationary() )
	{
		return True;
	}
	return False;
}

function ResetGrenadeAction ()
{
	m_iTeamAction=m_iTeamAction & -65;
}

function UpdateTeamGrenadeStatus ()
{
	m_bHasGrenade=0;
/*	if ( FindRainbowWithGrenadeType(1,False) != None )
	{
		m_bHasGrenade += 1;
	}
	if ( FindRainbowWithGrenadeType(2,False) != None )
	{
		m_bHasGrenade += 2;
	}
	if ( FindRainbowWithGrenadeType(3,False) != None )
	{
		m_bHasGrenade += 4;
	}
	if ( FindRainbowWithGrenadeType(4,False) != None )
	{
		m_bHasGrenade += 8;
	} */
}

simulated function bool HaveRainbowWithGrenadeType (eWeaponGrenadeType grenadeType)
{
	switch (grenadeType)
	{
/*		case 1:
		return (m_bHasGrenade & 1) != 0;
		case 2:
		return (m_bHasGrenade & 2) != 0;
		case 3:
		return (m_bHasGrenade & 4) != 0;
		case 4:
		return (m_bHasGrenade & 8) != 0;
		default:      */
	}
	return False;
}

function UpdateLocalActionRequest (R6CircumstantialActionQuery actionRequested)
{
	m_actionRequested.aQueryOwner=actionRequested.aQueryOwner;
	m_actionRequested.aQueryTarget=actionRequested.aQueryTarget;
	m_actionRequested.iMenuChoice=actionRequested.iMenuChoice;
	m_actionRequested.iSubMenuChoice=actionRequested.iSubMenuChoice;
}

function TeamActionRequest (R6CircumstantialActionQuery actionRequested)
{
	local int iHostage;
	local Vector vActorDir;

	if (  !m_bLeaderIsAPlayer || (m_iMemberCount <= 1) || m_bTeamIsClimbingLadder || Level.m_bInGamePlanningActive )
	{
		return;
	}
	RestoreTeamOrder();
	if ( m_bCAWaitingForZuluGoCode )
	{
		ResetZuluGoCode();
	}
	UpdateLocalActionRequest(actionRequested);
	m_bTeamIsHoldingPosition=False;
	if ( actionRequested.aQueryTarget.IsA('R6Terrorist') )
	{
		m_iTeamAction=1024;
		InstructTeamToArrestTerrorist(R6Terrorist(actionRequested.aQueryTarget));
	}
	else
	{
		if ( actionRequested.aQueryTarget.IsA('R6Hostage') )
		{
			m_iTeamAction=2048;
			MoveTeamTo(actionRequested.aQueryTarget.Location);
		}
		else
		{
			if ( actionRequested.aQueryTarget.IsA('R6LadderVolume') )
			{
				m_iTeamAction=512;
				InstructTeamToClimbLadder(R6LadderVolume(actionRequested.aQueryTarget));
			}
			else
			{
				if ( actionRequested.aQueryTarget.IsA('R6IORotatingDoor') )
				{
					if ( R6IORotatingDoor(actionRequested.aQueryTarget).m_bIsDoorClosed )
					{
						m_iTeamAction=16;
					}
					else
					{
						m_iTeamAction=32;
					}
					ChooseOpenSound(actionRequested);
					AssignAction(R6IORotatingDoor(actionRequested.aQueryTarget),-1);
				}
				else
				{
					if ( actionRequested.aQueryTarget.IsA('R6IOBomb') )
					{
						m_iTeamAction=4096;
						vActorDir=vector(R6IOBomb(actionRequested.aQueryTarget).Rotation * -80);
						vActorDir.Z=0.00;
						MoveTeamTo(actionRequested.aQueryTarget.Location + vActorDir);
					}
					else
					{
						if ( actionRequested.aQueryTarget.IsA('R6IODevice') )
						{
							m_iTeamAction=8192;
							vActorDir=vector(R6IODevice(actionRequested.aQueryTarget).Rotation * -80);
							vActorDir.Z=0.00;
							MoveTeamTo(actionRequested.aQueryTarget.Location + vActorDir);
						}
						else
						{
							if ( actionRequested.aQueryTarget.IsA('R6PlayerController') )
							{
//								m_PlayerVoicesMgr.PlayRainbowPlayerVoices(m_TeamLeader,1);
								m_iTeamAction=256;
								MoveTeamTo(R6PlayerController(m_TeamLeader.Controller).m_vRequestedLocation);
							}
							else
							{
							}
						}
					}
				}
			}
		}
	}
}

function TeamActionRequestFromRoseDesVents (R6CircumstantialActionQuery actionRequested, int iMenuChoice, int iSubMenuChoice, optional bool bOrderOnZulu)
{
	local R6IORotatingDoor Door;
	local Vector vActorDir;

	actionRequested.iMenuChoice=iMenuChoice;
	actionRequested.iSubMenuChoice=iSubMenuChoice;
	if ( (m_iMemberCount <= 1) || m_bTeamIsClimbingLadder || Level.m_bInGamePlanningActive )
	{
		return;
	}
	RestoreTeamOrder();
	if (  !bOrderOnZulu && m_bCAWaitingForZuluGoCode )
	{
		ResetZuluGoCode();
	}
	m_bTeamIsHoldingPosition=False;
	UpdateLocalActionRequest(actionRequested);
	if ( actionRequested.aQueryTarget.IsA('R6IORotatingDoor') )
	{
		Door=R6IORotatingDoor(actionRequested.aQueryTarget);
		switch (actionRequested.iMenuChoice)
		{
/*			case Door.5:
			m_iTeamAction=32;
			ChooseOpenSound(actionRequested);
			AssignAction(Door,actionRequested.iSubMenuChoice);
			break;
			case Door.1:
			m_iTeamAction=16;
			ChooseOpenSound(actionRequested);
			AssignAction(Door,actionRequested.iSubMenuChoice);
			break;
			case Door.2:
			m_iTeamAction=144;
			m_PlayerVoicesMgr.PlayRainbowPlayerVoices(m_TeamLeader,13);
			AssignAction(Door,actionRequested.iSubMenuChoice);
			break;
			case Door.3:
			m_iTeamAction=80;
			AssignAction(Door,actionRequested.iSubMenuChoice);
			break;
			case Door.4:
			m_iTeamAction=208;
			AssignAction(Door,actionRequested.iSubMenuChoice);
			break;
			case Door.6:
			m_iTeamAction=128;
			AssignAction(Door,actionRequested.iSubMenuChoice);
			break;
			case Door.7:
			m_iTeamAction=64;
			AssignAction(Door,actionRequested.iSubMenuChoice);
			break;
			case Door.8:
			m_iTeamAction=192;
			AssignAction(Door,actionRequested.iSubMenuChoice);
			break;
			default:    */
		}
	}
	else
	{
		if ( actionRequested.aQueryTarget.IsA('R6PlayerController') )
		{
/*			if ( actionRequested.iMenuChoice == R6PlayerController(actionRequested.aQueryTarget).3 )
			{
				m_iTeamAction=320;
				MoveTeamTo(R6PlayerController(m_TeamLeader.Controller).m_vRequestedLocation,actionRequested.iSubMenuChoice);
			}
			else
			{
				m_iTeamAction=256;
				MoveTeamTo(R6PlayerController(m_TeamLeader.Controller).m_vRequestedLocation);
			}*/
		}
		else
		{
			if ( actionRequested.aQueryTarget.IsA('R6LadderVolume') )
			{
				m_iTeamAction=512;
				InstructTeamToClimbLadder(R6LadderVolume(actionRequested.aQueryTarget));
			}
			else
			{
				if ( actionRequested.aQueryTarget.IsA('R6IOBomb') )
				{
					m_iTeamAction=4096;
					vActorDir=vector(R6IOBomb(actionRequested.aQueryTarget).Rotation * -80);
					vActorDir.Z=0.00;
					MoveTeamTo(R6IOBomb(actionRequested.aQueryTarget).Location + vActorDir);
				}
				else
				{
					if ( actionRequested.aQueryTarget.IsA('R6IODevice') )
					{
						m_iTeamAction=8192;
						vActorDir=vector(R6IODevice(actionRequested.aQueryTarget).Rotation * -80);
						vActorDir.Z=0.00;
						MoveTeamTo(actionRequested.aQueryTarget.Location + vActorDir);
					}
					else
					{
						if ( actionRequested.aQueryTarget.IsA('R6Terrorist') )
						{
							m_iTeamAction=1024;
							InstructTeamToArrestTerrorist(R6Terrorist(actionRequested.aQueryTarget));
						}
						else
						{
							if ( actionRequested.aQueryTarget.IsA('R6Hostage') )
							{
								m_iTeamAction=2048;
								MoveTeamTo(actionRequested.aQueryTarget.Location);
							}
							else
							{
							}
						}
					}
				}
			}
		}
	}
}

function ChooseOpenSound (R6CircumstantialActionQuery actionRequested)
{
	if ( R6IORotatingDoor(actionRequested.aQueryTarget).m_bIsDoorClosed )
	{
		if ( R6IORotatingDoor(actionRequested.aQueryTarget).m_bTreatDoorAsWindow )
		{
//			m_PlayerVoicesMgr.PlayRainbowPlayerVoices(m_TeamLeader,11);
		}
		else
		{
//			m_PlayerVoicesMgr.PlayRainbowPlayerVoices(m_TeamLeader,9);
		}
	}
	else
	{
		if ( R6IORotatingDoor(actionRequested.aQueryTarget).m_bTreatDoorAsWindow )
		{
//			m_PlayerVoicesMgr.PlayRainbowPlayerVoices(m_TeamLeader,12);
		}
		else
		{
//			m_PlayerVoicesMgr.PlayRainbowPlayerVoices(m_TeamLeader,10);
		}
	}
}

function TeamActionRequestWaitForZuluGoCode (R6CircumstantialActionQuery actionRequested, int iMenuChoice, int iSubMenuChoice)
{
	actionRequested.iMenuChoice=iMenuChoice;
	actionRequested.iSubMenuChoice=iSubMenuChoice;
	UpdateLocalActionRequest(actionRequested);
	if (  !m_bCAWaitingForZuluGoCode )
	{
		m_bCAWaitingForZuluGoCode=True;
//		m_eBackupGoCode=m_eGoCode;
//		m_eGoCode=3;
	}
	TeamActionRequestFromRoseDesVents(m_actionRequested,m_actionRequested.iMenuChoice,m_actionRequested.iSubMenuChoice,True);
}

function ReceivedZuluGoCode ()
{
	if ( m_bCAWaitingForZuluGoCode )
	{
		ResetZuluGoCode();
	}
}

function PlaySniperOrder ()
{
	if ( m_bSniperHold )
	{
//		m_PlayerVoicesMgr.PlayRainbowPlayerVoices(m_TeamLeader,44);
	}
	else
	{
//		m_PlayerVoicesMgr.PlayRainbowPlayerVoices(m_TeamLeader,43);
	}
}

function PlayGoCode (EGoCode eGo)
{
	switch (eGo)
	{
/*		case 0:
		m_PlayerVoicesMgr.PlayRainbowPlayerVoices(m_TeamLeader,33);
		break;
		case 1:
		m_PlayerVoicesMgr.PlayRainbowPlayerVoices(m_TeamLeader,34);
		break;
		case 2:
		m_PlayerVoicesMgr.PlayRainbowPlayerVoices(m_TeamLeader,35);
		break;
		case 3:
		m_PlayerVoicesMgr.PlayRainbowPlayerVoices(m_TeamLeader,36);
		if ( m_bCAWaitingForZuluGoCode && (m_iMemberCount > 1) )
		{
			m_MemberVoicesMgr.PlayRainbowMemberVoices(m_Team[1],6);
		}
		break;
		default:    */
	}
}

function SetTeamIsClimbingLadder (bool bClimbing)
{
	m_bTeamIsClimbingLadder=bClimbing;
}

function TeamLeaderIsClimbingLadder ()
{
	local int i;

	if ( m_bTeamIsSeparatedFromLeader && m_bLeaderIsAPlayer || (m_iMemberCount == 1) )
	{
		return;
	}
	if ( m_bTeamIsClimbingLadder )
	{
		return;
	}
	SetTeamIsClimbingLadder(True);
//	UpdateTeamFormation(0);
	m_TeamLadder=m_TeamLeader.m_Ladder;
	if ( m_iMemberCount > 1 )
	{
		i=1;
JL0063:
		if ( i < m_iMemberCount )
		{
			m_Team[i].Controller.MoveTarget=m_TeamLeader.m_Ladder;
			m_Team[i].m_Ladder=m_TeamLeader.m_Ladder;
			R6RainbowAI(m_Team[i].Controller).ResetStateProgress();
			m_Team[i].Controller.GotoState('TeamClimbLadder');
			i++;
			goto JL0063;
		}
	}
}

function TeamFinishedClimbingLadder ()
{
	if ( (m_iTeamAction & 512) > 0 )
	{
		ActionCompleted(True);
	}
//	UpdateTeamFormation(1);
	SetTeamIsClimbingLadder(False);
}

function bool AllMembersAreOnTheSameSideOfTheLadder (R6LadderVolume Ladder)
{
	local bool bLeaderIsAtTopOfLadder;
	local int iLeader;
	local int i;

	if ( m_bTeamIsSeparatedFromLeader )
	{
		if ( m_iMemberCount == 2 )
		{
			return True;
		}
		iLeader=1;
		bLeaderIsAtTopOfLadder=m_Team[1].Location.Z > Ladder.Location.Z;
	}
	else
	{
		if ( m_iMemberCount == 1 )
		{
			return True;
		}
		iLeader=0;
		bLeaderIsAtTopOfLadder=m_TeamLeader.Location.Z > Ladder.Location.Z;
	}
	i=iLeader + 1;
JL00A3:
	if ( i < m_iMemberCount )
	{
		if ( bLeaderIsAtTopOfLadder != m_Team[i].Location.Z > Ladder.Location.Z )
		{
			return False;
		}
		i++;
		goto JL00A3;
	}
	return True;
}

function MemberFinishedClimbingLadder (R6Pawn member)
{
	local int i;
	local int iTotalMember;
	local int iLeader;

	if ( (R6Rainbow(member) == m_TeamLeader) && member.m_bIsPlayer && (m_bTeamIsSeparatedFromLeader || (m_iMemberCount == 1)) )
	{
		return;
	}
	if (  !member.IsAlive() )
	{
		return;
	}
	if ( AllMembersAreOnTheSameSideOfTheLadder(R6LadderVolume(m_TeamLadder.MyLadder)) )
	{
		TeamFinishedClimbingLadder();
		if ( m_bTeamIsSeparatedFromLeader )
		{
			iLeader=1;
		}
		else
		{
			iLeader=0;
		}
		i=iLeader + 1;
JL00A2:
		if ( i < m_iMemberCount )
		{
			m_Team[i].Controller.GotoState('FollowLeader');
			i++;
			goto JL00A2;
		}
	}
}

function bool TeamHasFinishedClimbingLadder ()
{
	if ( m_bTeamIsClimbingLadder )
	{
		return False;
	}
	else
	{
		return True;
	}
}

function bool MembersAreOnSameEndOfLadder (R6Pawn p1, R6Pawn p2)
{
	if ( Abs(p1.Location.Z - p2.Location.Z) < 30 )
	{
		return True;
	}
	return False;
}

function InstructTeamToClimbLadder (R6LadderVolume LadderVolume, optional bool bPathFinding, optional int iMemberId)
{
	local float fDistanceToTop;
	local float fDistanceToBottom;
	local int i;
	local int iMemberLeading;

	if ( m_iMemberCount < 2 )
	{
		return;
	}
	if ( bPathFinding )
	{
		iMemberLeading=iMemberId;
	}
	else
	{
//		m_PlayerVoicesMgr.PlayRainbowPlayerVoices(m_TeamLeader,26);
		PlayOrderTeamOnZulu();
//		m_MemberVoicesMgr.PlayRainbowMemberVoices(m_Team[1],6);
		iMemberLeading=1;
	}
	fDistanceToTop=Abs(m_Team[iMemberLeading].Location.Z - LadderVolume.m_TopLadder.Location.Z);
	fDistanceToBottom=Abs(m_Team[iMemberLeading].Location.Z - LadderVolume.m_BottomLadder.Location.Z);
	if ( fDistanceToTop < fDistanceToBottom )
	{
		m_TeamLadder=LadderVolume.m_TopLadder;
	}
	else
	{
		m_TeamLadder=LadderVolume.m_BottomLadder;
	}
	m_Team[iMemberLeading].Controller.MoveTarget=m_TeamLadder;
	if ( bPathFinding )
	{
//		SetTeamState(18);
		if ( (iMemberLeading == 0) &&  !m_bLeaderIsAPlayer )
		{
			m_Team[iMemberLeading].Controller.NextState='WaitForTeam';
		}
		else
		{
			if ( m_bLeaderIsAPlayer && (iMemberLeading == 1) )
			{
				m_Team[iMemberLeading].Controller.NextState='TeamClimbEndNoLeader';
			}
			else
			{
				m_Team[iMemberLeading].Controller.NextState=m_Team[iMemberLeading].Controller.GetStateName();
			}
		}
		m_Team[iMemberLeading].Controller.GotoState('ApproachLadder');
	}
	else
	{
		if ( m_Team[iMemberLeading].m_bIsClimbingLadder )
		{
//			SetTeamState(18);
			m_Team[iMemberLeading].Controller.NextState='TeamClimbEndNoLeader';
		}
		else
		{
			m_Team[iMemberLeading].Controller.GotoState('TeamClimbStartNoLeader');
		}
		TeamIsSeparatedFromLead(True);
	}
//	UpdateTeamFormation(0);
	if ( m_iMemberCount > iMemberLeading + 1 )
	{
		i=iMemberLeading + 1;
JL02B5:
		if ( i < m_iMemberCount )
		{
			if ( MembersAreOnSameEndOfLadder(m_Team[iMemberLeading],m_Team[i]) )
			{
				m_Team[i].m_Ladder=m_TeamLadder;
				R6RainbowAI(m_Team[i].Controller).ResetStateProgress();
				m_Team[i].Controller.GotoState('TeamClimbLadder');
			}
			i++;
			goto JL02B5;
		}
	}
}

function PlaySoundTeamStatusReport ()
{
	if ( m_TeamLeader.m_bIsPlayer || m_bPlayerHasFocus || m_bPlayerInGhostMode )
	{
//		m_PlayerVoicesMgr.PlayRainbowPlayerVoices(m_TeamLeader,30);
	}
	if (  !m_TeamLeader.m_bIsPlayer &&  !m_bPlayerHasFocus && (m_OtherTeamVoicesMgr != None) && (m_iMemberCount > 0) )
	{
		switch (m_eTeamState)
		{
/*			case 1:
			switch (m_eGoCode)
			{
				case 0:
				m_OtherTeamVoicesMgr.PlayRainbowOtherTeamVoices(m_TeamLeader,24);
				break;
				case 1:
				m_OtherTeamVoicesMgr.PlayRainbowOtherTeamVoices(m_TeamLeader,25);
				break;
				case 2:
				m_OtherTeamVoicesMgr.PlayRainbowOtherTeamVoices(m_TeamLeader,26);
				break;
				case 3:
				m_OtherTeamVoicesMgr.PlayRainbowOtherTeamVoices(m_TeamLeader,27);
				break;
				default:
			}
			break;
			case 14:
			case 15:
			case 19:
			case 2:
			m_OtherTeamVoicesMgr.PlayRainbowOtherTeamVoices(m_TeamLeader,23);
			break;
			case 6:
			m_OtherTeamVoicesMgr.PlayRainbowOtherTeamVoices(m_TeamLeader,21);
			break;
			case 7:
			switch (m_eGoCode)
			{
				case 0:
				m_OtherTeamVoicesMgr.PlayRainbowOtherTeamVoices(m_TeamLeader,28);
				break;
				case 1:
				m_OtherTeamVoicesMgr.PlayRainbowOtherTeamVoices(m_TeamLeader,29);
				break;
				case 2:
				m_OtherTeamVoicesMgr.PlayRainbowOtherTeamVoices(m_TeamLeader,30);
				break;
				default:
			}
			break;
			case 16:
			switch (m_TeamLeader.m_eDeviceAnim)
			{
				case 2:
				m_OtherTeamVoicesMgr.PlayRainbowTeamVoices(m_TeamLeader,8);
				case 3:
				m_OtherTeamVoicesMgr.PlayRainbowTeamVoices(m_TeamLeader,0);
				break;
				case 4:
				m_OtherTeamVoicesMgr.PlayRainbowTeamVoices(m_TeamLeader,2);
				default:
			}
			break;
			case 20:
			m_OtherTeamVoicesMgr.PlayRainbowTeamVoices(m_TeamLeader,6);
			break;
			case 21:
			case 17:
			case 18:
			case 13:
			case 4:
			case 3:
			case 8:
			case 9:
			case 10:
			case 5:
			m_OtherTeamVoicesMgr.PlayRainbowOtherTeamVoices(m_TeamLeader,22);
			break;
			default:   */
		}
	}
}

function InstructPlayerTeamToHoldPosition (optional bool bOtherTeam)
{
	local int i;
	local int iMember;

	if ( m_bTeamIsClimbingLadder )
	{
		m_iTeamAction=0;
		return;
	}
	TeamIsSeparatedFromLead(True);
	m_bTeamIsHoldingPosition=True;
	m_bPlayerRequestedTeamReform=False;
	if ( m_bCAWaitingForZuluGoCode )
	{
		ResetZuluGoCode();
	}
	if ( m_TeamLeader.m_bIsPlayer )
	{
		if ( bOtherTeam )
		{
//			m_PlayerVoicesMgr.PlayRainbowPlayerVoices(m_TeamLeader,3);
		}
		if ( m_iMemberCount > 1 )
		{
			if (  !bOtherTeam )
			{
//				m_PlayerVoicesMgr.PlayRainbowPlayerVoices(m_TeamLeader,2);
			}
//			m_MemberVoicesMgr.PlayRainbowMemberVoices(m_Team[1],18);
		}
	}
	if ( m_iMemberCount > 1 )
	{
		iMember=1;
JL00BF:
		if ( iMember < m_iMemberCount )
		{
			m_Team[iMember].Controller.NextState='None';
			m_Team[iMember].Controller.GotoState('HoldPosition');
			iMember++;
			goto JL00BF;
		}
	}
}

function InstructPlayerTeamToFollowLead (optional bool bOtherTeam)
{
	local int i;

	if ( m_bTeamIsClimbingLadder )
	{
		return;
	}
	m_iTeamAction=0;
	m_bTeamIsHoldingPosition=False;
	m_bEntryInProgress=False;
	m_bPlayerRequestedTeamReform=False;
	if ( m_bCAWaitingForZuluGoCode )
	{
		ResetZuluGoCode();
	}
	RestoreTeamOrder();
	if ( m_TeamLeader.m_bIsPlayer && bOtherTeam )
	{
//		m_PlayerVoicesMgr.PlayRainbowPlayerVoices(m_TeamLeader,4);
	}
	if ( m_iMemberCount > 1 )
	{
		if ( m_TeamLeader.m_bIsPlayer )
		{
			if (  !bOtherTeam )
			{
//				m_PlayerVoicesMgr.PlayRainbowPlayerVoices(m_TeamLeader,0);
			}
			if ( VSize(m_Team[1].Location - m_TeamLeader.Location) > 600 )
			{
				if ( m_MemberVoicesMgr != None )
				{
//					m_MemberVoicesMgr.PlayRainbowMemberVoices(m_Team[1],4);
				}
				m_bPlayerRequestedTeamReform=True;
			}
			else
			{
				if ( m_MemberVoicesMgr != None )
				{
//					m_MemberVoicesMgr.PlayRainbowMemberVoices(m_Team[1],5);
				}
			}
		}
		i=1;
JL0136:
		if ( i < m_iMemberCount )
		{
			m_Team[i].Controller.GotoState('FollowLeader');
			R6RainbowAI(m_Team[i].Controller).ResetStateProgress();
			i++;
			goto JL0136;
		}
		TeamIsRegroupingOnLead(True);
	}
}

function GrenadeInProximity (R6Rainbow spotter, Vector vGrenadeLocation, float fTimeLeft, float fGrenadeDangerRadius)
{
	local int i;

	if ( m_bGrenadeInProximity )
	{
		return;
	}
	m_bGrenadeInProximity=True;
	m_bWasSeparatedFromLeader=m_bTeamIsSeparatedFromLeader;
	if ( m_bLeaderIsAPlayer )
	{
		TeamIsSeparatedFromLead(True);
		m_vPreviousPosition=m_Team[1].Location;
	}
	else
	{
		m_vPreviousPosition=m_Team[0].Location;
	}
	if ( m_bPlayerHasFocus || Level.IsGameTypeCooperative(Level.Game.m_eGameTypeFlag) )
	{
//		m_MultiCoopMemberVoicesMgr.PlayRainbowTeamVoices(spotter,11);
	}
	else
	{
//		m_MemberVoicesMgr.PlayRainbowMemberVoices(spotter,15);
	}
	i=0;
JL00C9:
	if ( i < m_iMemberCount )
	{
		if (  !m_Team[i].m_bIsPlayer )
		{
			R6RainbowAI(m_Team[i].Controller).ReactToFragGrenade(vGrenadeLocation,fTimeLeft,fGrenadeDangerRadius);
		}
		i++;
		goto JL00C9;
	}
}

function GasGrenadeInProximity (R6Rainbow spotter)
{
	if ( m_bGasGrenadeInProximity )
	{
		return;
	}
	m_bGasGrenadeInProximity=True;
//	m_MemberVoicesMgr.PlayRainbowMemberVoices(spotter,16);
}

function GasGrenadeCleared (R6Pawn aPawn)
{
	local int i;

	i=0;
JL0007:
	if ( i < m_iMemberCount )
	{
		if (  !m_Team[i].m_bIsPlayer && (m_Team[i] != aPawn) && (m_Team[i].m_eEffectiveGrenade == 2) )
		{
			return;
		}
		i++;
		goto JL0007;
	}
	m_bGasGrenadeInProximity=False;
}

function GrenadeThreatIsOver ()
{
	local int i;
	local bool bTeamIsClimbingLadder;

	if (  !m_bGrenadeInProximity )
	{
		return;
	}
	m_bGrenadeInProximity=False;
	RestoreTeamOrder();
	TeamIsSeparatedFromLead(m_bWasSeparatedFromLeader);
	if (  !m_bLeaderIsAPlayer )
	{
		i=0;
JL0039:
		if ( i < m_iMemberCount )
		{
			if ( m_Team[i].m_bIsClimbingLadder || (m_Team[i].Physics == 11) )
			{
				bTeamIsClimbingLadder=True;
			}
			else
			{
				if ( i == 0 )
				{
					if ( m_bTeamIsHoldingPosition )
					{
						R6RainbowAI(m_Team[0].Controller).FindPathToTargetLocation(m_vPreviousPosition);
						R6RainbowAI(m_Team[0].Controller).m_PostFindPathToState='HoldPosition';
					}
					else
					{
						R6RainbowAI(m_Team[0].Controller).GotoState('Patrol');
					}
				}
				else
				{
					R6RainbowAI(m_Team[i].Controller).GotoState('FollowLeader');
				}
			}
			i++;
			goto JL0039;
		}
	}
	else
	{
		if ( m_iMemberCount == 1 )
		{
			return;
		}
		i=1;
JL0153:
		if ( i < m_iMemberCount )
		{
			if ( m_Team[i].m_bIsClimbingLadder || (m_Team[i].Physics == 11) )
			{
				bTeamIsClimbingLadder=True;
			}
			else
			{
				if ( m_bTeamIsSeparatedFromLeader )
				{
					if ( i == 1 )
					{
						m_iTeamAction=256;
						m_vActionLocation=m_vPreviousPosition;
						R6RainbowAI(m_Team[i].Controller).GotoState('TeamMoveTo');
					}
					else
					{
						R6RainbowAI(m_Team[i].Controller).GotoState('FollowLeader');
					}
				}
				else
				{
					R6RainbowAI(m_Team[i].Controller).GotoState('FollowLeader');
				}
			}
			i++;
			goto JL0153;
		}
	}
	m_bTeamIsClimbingLadder=bTeamIsClimbingLadder;
}

function bool FriendlyFlashBang (Actor aGrenade)
{
	local int i;

	i=0;
JL0007:
	if ( i < m_iMemberCount )
	{
		if ( aGrenade.Instigator == m_Team[i] )
		{
			return True;
		}
		i++;
		goto JL0007;
	}
	return False;
}

function InstructTeamToArrestTerrorist (R6Terrorist terrorist)
{
	local int i;

//	m_PlayerVoicesMgr.PlayRainbowPlayerVoices(m_TeamLeader,27);
	TeamIsSeparatedFromLead(True);
	if ( m_iMemberCount > 1 )
	{
		PlayOrderTeamOnZulu();
//		m_MemberVoicesMgr.PlayRainbowMemberVoices(m_Team[1],6);
		R6RainbowAI(m_Team[1].Controller).m_ActionTarget=terrorist;
		m_Team[1].Controller.GotoState('TeamSecureTerrorist');
	}
	if ( m_iMemberCount > 2 )
	{
		i=2;
JL0099:
		if ( i < m_iMemberCount )
		{
			m_Team[i].Controller.GotoState('FollowLeader');
			i++;
			goto JL0099;
		}
	}
}

function MoveTeamTo (Vector vLocation, optional int iSubAction)
{
	local int i;
	local R6Pawn actionMember;
	local R6RainbowAI rainbowAI;

	TeamIsSeparatedFromLead(True);
	m_iSubAction=iSubAction;
	if ( m_iMemberCount > 1 )
	{
		switch (m_iTeamAction)
		{
/*			case 320:
			actionMember=SelectMemberWithFrag(m_iSubAction,m_TeamLeader.Controller);
			if ( actionMember == None )
			{
				switch (m_eEntryGrenadeType)
				{
					case 1:
					m_MemberVoicesMgr.PlayRainbowMemberVoices(m_Team[1],8);
					break;
					case 2:
					m_MemberVoicesMgr.PlayRainbowMemberVoices(m_Team[1],10);
					break;
					case 3:
					m_MemberVoicesMgr.PlayRainbowMemberVoices(m_Team[1],11);
					break;
					case 4:
					m_MemberVoicesMgr.PlayRainbowMemberVoices(m_Team[1],9);
					default:
				}
				ActionCompleted(False);
				InstructPlayerTeamToHoldPosition(False);
				return;
			}
			PlayOrderTeamOnZulu();
			m_MemberVoicesMgr.PlayRainbowMemberVoices(m_Team[1],6);
			break;
			case 4096:
			m_PlayerVoicesMgr.PlayRainbowPlayerVoices(m_TeamLeader,32);
			PlayOrderTeamOnZulu();
			ReorganizeTeamToInteractWithDevice(4096,m_actionRequested.aQueryTarget);
			R6RainbowAI(m_Team[1].Controller).m_ActionTarget=m_actionRequested.aQueryTarget;
			m_MemberVoicesMgr.PlayRainbowMemberVoices(m_Team[1],6);
			break;
			case 8192:
			m_PlayerVoicesMgr.PlayRainbowPlayerVoices(m_TeamLeader,31);
			PlayOrderTeamOnZulu();
			ReorganizeTeamToInteractWithDevice(8192,m_actionRequested.aQueryTarget);
			R6RainbowAI(m_Team[1].Controller).m_ActionTarget=m_actionRequested.aQueryTarget;
			m_MemberVoicesMgr.PlayRainbowMemberVoices(m_Team[1],6);
			break;
			case 2048:
			if ( R6Hostage(m_actionRequested.aQueryTarget).m_escortedByRainbow != None )
			{
				m_PlayerVoicesMgr.PlayRainbowPlayerVoices(m_TeamLeader,29);
			}
			else
			{
				m_PlayerVoicesMgr.PlayRainbowPlayerVoices(m_TeamLeader,28);
			}
			PlayOrderTeamOnZulu();
			R6RainbowAI(m_Team[1].Controller).m_ActionTarget=m_actionRequested.aQueryTarget;
			m_MemberVoicesMgr.PlayRainbowMemberVoices(m_Team[1],6);
			break;
			case 256:
			m_PlayerVoicesMgr.PlayRainbowPlayerVoices(m_TeamLeader,1);
			PlayOrderTeamOnZulu();
			if ( (m_iMemberCount == 2) || m_bCAWaitingForZuluGoCode )
			{
				m_MemberVoicesMgr.PlayRainbowMemberVoices(m_Team[1],6);
			}
			else
			{
				m_MemberVoicesMgr.PlayRainbowMemberVoices(m_Team[1],19);
			}
			break;
			default:  */
		}
//		m_iGrenadeThrower=1;
		rainbowAI=R6RainbowAI(m_Team[m_iGrenadeThrower].Controller);
		if ( m_iTeamAction == 320 )
		{
			rainbowAI.m_iStateProgress=0;
			rainbowAI.m_vLocationOnTarget=vLocation;
			m_vActionLocation=rainbowAI.Pawn.Location;
		}
		else
		{
			if ( m_iTeamAction == 256 )
			{
				m_vActionLocation=vLocation + vect(0.00,0.00,80.00);
				m_Team[m_iGrenadeThrower].FindSpot(m_vActionLocation,vect(38.00,38.00,80.00));
			}
			else
			{
				m_vActionLocation=vLocation;
			}
		}
		if ( rainbowAI.IsInState('TeamMoveTo') )
		{
			rainbowAI.ResetTeamMoveTo();
		}
		rainbowAI.GotoState('TeamMoveTo');
	}
	if ( m_iMemberCount > 2 )
	{
		i=2;
JL044E:
		if ( i < m_iMemberCount )
		{
			m_Team[i].Controller.GotoState('FollowLeader');
			i++;
			goto JL044E;
		}
	}
}

function PlayOrderTeamOnZulu ()
{
	if ( m_bCAWaitingForZuluGoCode )
	{
//		m_PlayerVoicesMgr.PlayRainbowPlayerVoices(m_TeamLeader,37);
	}
}

function MoveTeamToCompleted (bool bStatus)
{
	if ( m_iMemberCount > 1 )
	{
		m_Team[1].Controller.NextState='None';
		m_Team[1].Controller.GotoState('HoldPosition');
	}
	ActionCompleted(bStatus);
}

function ReorganizeTeamToInteractWithDevice (int iTeamAction, Actor actionObject)
{
	local R6Rainbow actionMember;
	local int iMember;
	local float fMemberSkill;
	local float fBestSkill;

	iMember=0;
JL0007:
	if ( iMember < m_iMemberCount )
	{
		if ( m_Team[iMember].m_bIsPlayer )
		{
			goto JL0107;
		}
		if ( iTeamAction == 4096 )
		{
			fMemberSkill=m_Team[iMember].GetSkill(SKILL_Demolitions);
		}
		else
		{
			fMemberSkill=m_Team[iMember].GetSkill(SKILL_Electronics);
		}
		if ( (iTeamAction == 4096) && m_Team[iMember].m_bHasDiffuseKit || (iTeamAction == 8192) && m_Team[iMember].m_bHasElectronicsKit )
		{
			fMemberSkill += 20;
		}
		if ( fMemberSkill > fBestSkill )
		{
			actionMember=m_Team[iMember];
			fBestSkill=fMemberSkill;
		}
JL0107:
		iMember++;
		goto JL0007;
	}
	if ( m_bLeaderIsAPlayer )
	{
		if ( actionMember.m_iID != 1 )
		{
			ReOrganizeTeam(actionMember.m_iID);
		}
	}
	else
	{
		if ( actionMember.m_iID != 0 )
		{
			ReOrganizeTeam(actionMember.m_iID);
		}
		m_iTeamAction=iTeamAction;
		R6RainbowAI(m_Team[0].Controller).m_ActionTarget=actionObject;
		m_vActionLocation=actionObject.Location - 80 * vector(actionObject.Rotation);
		m_Team[0].Controller.GotoState('TeamMoveTo');
	}
}

function ReOrganizeTeamForGrenade (EPlanAction ePAction)
{
	local R6Rainbow actionMember;
	local int i;

	switch (ePAction)
	{
/*		case 1:
		m_eEntryGrenadeType=1;
		break;
		case 3:
		m_eEntryGrenadeType=2;
		break;
		case 2:
		m_eEntryGrenadeType=3;
		break;
		case 4:
		m_eEntryGrenadeType=4;
		break;
		default:
		m_eEntryGrenadeType=0;    */
	}
	actionMember=FindRainbowWithGrenadeType(m_eEntryGrenadeType,True);
	if ( actionMember == None )
	{
		m_bSkipAction=True;
		return;
	}
	if ( actionMember.m_iID != 0 )
	{
		ReOrganizeTeam(actionMember.m_iID);
	}
}

function R6Pawn SelectMemberWithFrag (int iSubAction, Actor Target)
{
	local R6Pawn actionMember;

	if ( Target.IsA('R6IORotatingDoor') )
	{
		switch (iSubAction)
		{
/*			case R6IORotatingDoor(Target).9:
			m_eEntryGrenadeType=1;
			break;
			case R6IORotatingDoor(Target).10:
			m_eEntryGrenadeType=2;
			break;
			case R6IORotatingDoor(Target).11:
			m_eEntryGrenadeType=3;
			break;
			case R6IORotatingDoor(Target).12:
			m_eEntryGrenadeType=4;
			break;
			default:
			m_eEntryGrenadeType=0;        */
		}
	}
	else
	{
		if ( R6PlayerController(Target) == None )
		{
			return None;
		}
		switch (iSubAction)
		{
/*			case R6PlayerController(Target).4:
			m_eEntryGrenadeType=1;
			break;
			case R6PlayerController(Target).5:
			m_eEntryGrenadeType=2;
			break;
			case R6PlayerController(Target).6:
			m_eEntryGrenadeType=3;
			break;
			case R6PlayerController(Target).7:
			m_eEntryGrenadeType=4;
			break;
			default:             */
		}
//		m_eEntryGrenadeType=0;
	}
	if ( m_eEntryGrenadeType != 0 )
	{
		if ( m_TeamLeader.m_bIsPlayer )
		{
			switch (m_eEntryGrenadeType)
			{
/*				case 1:
				switch (m_iTeamAction)
				{
					case 320:
					m_PlayerVoicesMgr.PlayRainbowPlayerVoices(m_TeamLeader,5);
					break;
					case 192:
					m_PlayerVoicesMgr.PlayRainbowPlayerVoices(m_TeamLeader,22);
					break;
					case 80:
					m_PlayerVoicesMgr.PlayRainbowPlayerVoices(m_TeamLeader,14);
					break;
					case 208:
					m_PlayerVoicesMgr.PlayRainbowPlayerVoices(m_TeamLeader,18);
					break;
					default:
				}
				break;
				case 2:
				switch (m_iTeamAction)
				{
					case 320:
					m_PlayerVoicesMgr.PlayRainbowPlayerVoices(m_TeamLeader,6);
					break;
					case 192:
					m_PlayerVoicesMgr.PlayRainbowPlayerVoices(m_TeamLeader,23);
					break;
					case 80:
					m_PlayerVoicesMgr.PlayRainbowPlayerVoices(m_TeamLeader,15);
					break;
					case 208:
					m_PlayerVoicesMgr.PlayRainbowPlayerVoices(m_TeamLeader,19);
					break;
					default:
				}
				break;
				case 3:
				switch (m_iTeamAction)
				{
					case 320:
					m_PlayerVoicesMgr.PlayRainbowPlayerVoices(m_TeamLeader,8);
					break;
					case 192:
					m_PlayerVoicesMgr.PlayRainbowPlayerVoices(m_TeamLeader,25);
					break;
					case 80:
					m_PlayerVoicesMgr.PlayRainbowPlayerVoices(m_TeamLeader,17);
					break;
					case 208:
					m_PlayerVoicesMgr.PlayRainbowPlayerVoices(m_TeamLeader,21);
					break;
					default:
				}
				break;
				case 4:
				switch (m_iTeamAction)
				{
					case 320:
					m_PlayerVoicesMgr.PlayRainbowPlayerVoices(m_TeamLeader,7);
					break;
					case 192:
					m_PlayerVoicesMgr.PlayRainbowPlayerVoices(m_TeamLeader,24);
					break;
					case 80:
					m_PlayerVoicesMgr.PlayRainbowPlayerVoices(m_TeamLeader,16);
					break;
					case 208:
					m_PlayerVoicesMgr.PlayRainbowPlayerVoices(m_TeamLeader,20);
					break;
					default:
				}
				break;
				default: */
			}
		}
		actionMember=FindRainbowWithGrenadeType(m_eEntryGrenadeType,True);
	}
	if ( actionMember != None )
	{
		ReOrganizeTeam(actionMember.m_iID);
	}
	return actionMember;
}

function AssignAction (Actor Target, int iSubAction)
{
	local R6Pawn actionMember;
	local R6Door closestDoor;
	local float fDistA;
	local float fDistB;
	local R6RainbowAI actionMemberController;
	local int i;

	if ( (m_iMemberCount == 1) ||  !Target.IsA('R6IORotatingDoor') )
	{
		return;
	}
	TeamIsSeparatedFromLead(True);
	m_iSubAction=iSubAction;
	if ( iSubAction != -1 )
	{
		actionMember=SelectMemberWithFrag(m_iSubAction,Target);
		if ( actionMember == None )
		{
			ActionCompleted(False);
			return;
		}
	}
	else
	{
		if ( (m_iTeamAction & 64) > 0 )
		{
			ActionCompleted(False);
			return;
		}
	}
	if ( actionMember == None )
	{
		actionMember=m_Team[1];
	}
	PlayOrderTeamOnZulu();
//	m_MemberVoicesMgr.PlayRainbowMemberVoices(m_Team[1],6);
	if ( R6IORotatingDoor(Target).m_DoorActorA != None )
	{
		fDistA=VSize(R6IORotatingDoor(Target).m_DoorActorA.Location - actionMember.Location);
	}
	else
	{
		fDistA=99999.00;
	}
	if ( R6IORotatingDoor(Target).m_DoorActorB != None )
	{
		fDistB=VSize(R6IORotatingDoor(Target).m_DoorActorB.Location - actionMember.Location);
	}
	else
	{
		fDistB=99999.00;
	}
	actionMemberController=R6RainbowAI(actionMember.Controller);
	if ( fDistA < fDistB )
	{
		actionMemberController.m_ActionTarget=R6IORotatingDoor(Target).m_DoorActorA;
	}
	else
	{
		actionMemberController.m_ActionTarget=R6IORotatingDoor(Target).m_DoorActorB;
	}
	actionMemberController.ResetStateProgress();
	actionMemberController.NextState='HoldPosition';
	actionMemberController.GotoState('PerformAction');
	if ( m_iMemberCount > 2 )
	{
		i=2;
JL022D:
		if ( i < m_iMemberCount )
		{
			m_Team[i].Controller.GotoState('FollowLeader');
			i++;
			goto JL022D;
		}
	}
}

simulated function R6Rainbow FindRainbowWithGrenadeType (eWeaponGrenadeType grenadeType, bool bSetGadgetGroup)
{
	local int iMember;
	local int iWeaponGroup;
	local R6EngineWeapon grenadeWeapon;
	local bool bHasGrenade;

	iMember=0;
JL0007:
	if ( iMember < m_iMemberCount )
	{
		if ( (m_Team[iMember] == None) || m_Team[iMember].m_bIsPlayer ||  !m_Team[iMember].IsAlive() )
		{
			goto JL0204;
		}
		iWeaponGroup=3;
JL0068:
		if ( iWeaponGroup <= 4 )
		{
			bHasGrenade=False;
			grenadeWeapon=m_Team[iMember].GetWeaponInGroup(iWeaponGroup);
			if ( (grenadeWeapon != None) && (grenadeWeapon.m_eWeaponType == 6) && grenadeWeapon.HasAmmo() )
			{
				switch (grenadeType)
				{
/*					case 1:
					if ( grenadeWeapon.HasBulletType('R6FragGrenade') )
					{
						bHasGrenade=True;
					}
					break;
					case 2:
					if ( grenadeWeapon.HasBulletType('R6TearGasGrenade') )
					{
						bHasGrenade=True;
					}
					break;
					case 3:
					if ( grenadeWeapon.HasBulletType('R6FlashBang') )
					{
						bHasGrenade=True;
					}
					break;
					case 4:
					if ( grenadeWeapon.HasBulletType('R6SmokeGrenade') )
					{
						bHasGrenade=True;
					}
					break;
					default: */
				}
			}
			if ( bHasGrenade &&  !m_Team[iMember].m_bIsPlayer )
			{
				if ( bSetGadgetGroup && (m_Team[iMember].Controller != None) )
				{
					R6RainbowAI(m_Team[iMember].Controller).m_iActionUseGadgetGroup=iWeaponGroup;
				}
				return m_Team[iMember];
			}
			iWeaponGroup++;
			goto JL0068;
		}
JL0204:
		iMember++;
		goto JL0007;
	}
	return None;
}

function ActionCompleted (bool bSuccess)
{
	local int i;
	local int iMember;

	if (  !bSuccess )
	{
		ResetZuluGoCode();
	}
	if ( m_TeamLeader.m_bIsPlayer )
	{
		if ( m_iMemberCount > 1 )
		{
			m_bTeamIsHoldingPosition=True;
			if ( bSuccess )
			{
				if ( (m_iTeamAction & 128) > 0 )
				{
//					m_MemberVoicesMgr.PlayRainbowMemberVoices(m_Team[1],26);
				}
			}
			else
			{
//				m_MemberVoicesMgr.PlayRainbowMemberVoices(m_Team[1],7);
			}
		}
	}
	else
	{
		if ( m_iMemberCount > 1 )
		{
			iMember=1;
JL0096:
			if ( iMember < m_iMemberCount )
			{
				m_Team[iMember].Controller.GotoState('FollowLeader');
				iMember++;
				goto JL0096;
			}
		}
		TeamIsSeparatedFromLead(False);
	}
	m_iTeamAction=0;
}

function ReIssueTeamOrders ()
{
	if ( m_actionRequested.iMenuChoice == -1 )
	{
		TeamActionRequest(m_actionRequested);
	}
	else
	{
		if ( m_bCAWaitingForZuluGoCode )
		{
			TeamActionRequestWaitForZuluGoCode(m_actionRequested,m_actionRequested.iMenuChoice,m_actionRequested.iSubMenuChoice);
		}
		else
		{
			TeamActionRequestFromRoseDesVents(m_actionRequested,m_actionRequested.iMenuChoice,m_actionRequested.iSubMenuChoice);
		}
	}
}

function RainbowIsInFrontOfAClosedDoor (R6Pawn Rainbow, R6Door Door)
{
	local int i;
	local int iOpensClockwise;
	local int iStart;

	if ( Rainbow.m_bIsPlayer && (m_bTeamIsSeparatedFromLeader || m_bTeamIsClimbingLadder) )
	{
		return;
	}
	m_Door=Door;
	m_PawnControllingDoor=Rainbow;
	if ( m_Door.m_RotatingDoor.m_bTreatDoorAsWindow )
	{
		return;
	}
	m_bRainbowIsInFrontOfDoor=True;
	m_bEntryInProgress=True;
	m_bDoorOpensTowardTeam=Door.m_RotatingDoor.DoorOpenTowardsActor(Rainbow);
	m_bDoorOpensClockWise=Door.m_RotatingDoor.m_bIsOpeningClockWise;
	if ( Rainbow == m_TeamLeader )
	{
		iStart=1;
	}
	else
	{
		iStart=Rainbow.m_iID + 1;
	}
	if (  !Rainbow.m_bIsPlayer )
	{
		R6RainbowAI(Rainbow.Controller).m_bEnteredRoom=False;
	}
	i=iStart;
JL011E:
	if ( i < m_iMemberCount )
	{
		R6RainbowAI(m_Team[i].Controller).ResetStateProgress();
		if ( m_Team[i].m_bIsClimbingLadder )
		{
			m_Team[i].Controller.NextState='RoomEntry';
		}
		else
		{
			m_Team[i].Controller.GotoState('RoomEntry');
		}
		i++;
		goto JL011E;
	}
}

function EnteredRoom (R6Pawn member)
{
	local int i;

	if (  !m_bEntryInProgress )
	{
		return;
	}
	if (  !member.m_bIsPlayer )
	{
		R6RainbowAI(member.Controller).m_bEnteredRoom=True;
	}
	if ( (member.m_iID == m_iMemberCount - 1) || m_bTeamIsSeparatedFromLeader && m_PawnControllingDoor.m_bIsPlayer )
	{
		m_bEntryInProgress=False;
	}
}

function bool HasGoneThroughDoor ()
{
	if ( Normal(m_PawnControllingDoor.Location - m_Door.Location) Dot m_Door.m_vLookDir < 0 )
	{
		return False;
	}
	else
	{
		return True;
	}
}

function EndRoomEntry ()
{
	local int iStart;
	local int i;

	m_PawnControllingDoor=None;
	m_bEntryInProgress=False;
	if ( m_iMemberCount == 1 )
	{
		return;
	}
	if ( m_bTeamIsSeparatedFromLeader )
	{
		iStart=2;
	}
	else
	{
		iStart=1;
	}
	i=iStart;
JL0042:
	if ( i < m_iMemberCount )
	{
		m_Team[i].Controller.GotoState('FollowLeader');
		i++;
		goto JL0042;
	}
}

function RainbowHasLeftDoor (R6Pawn Rainbow)
{
	local int i;
	local int iStart;
	local Vector vDist;
	local float fDir;
	local Vector vDir;

	if ( (m_Door == None) || (m_Door.m_RotatingDoor == None) )
	{
		return;
	}
	if ( m_Door.m_RotatingDoor.m_bTreatDoorAsWindow )
	{
		m_Door=None;
		m_PawnControllingDoor=None;
		return;
	}
	if ( (m_iMemberCount <= 1) ||  !m_bEntryInProgress ||  !m_bRainbowIsInFrontOfDoor )
	{
		return;
	}
	if ( (Rainbow != None) && Rainbow.m_bIsPlayer && m_bTeamIsSeparatedFromLeader )
	{
		return;
	}
	m_bRainbowIsInFrontOfDoor=False;
	if ( ( !m_Door.m_RotatingDoor.m_bIsDoorClosed || m_Door.m_RotatingDoor.m_bInProcessOfOpening) && HasGoneThroughDoor() )
	{
		EnteredRoom(m_PawnControllingDoor);
		m_PawnControllingDoor=None;
	}
	else
	{
		m_Door=None;
		if ( m_PawnControllingDoor == m_TeamLeader )
		{
			iStart=1;
		}
		else
		{
			iStart=2;
		}
		i=iStart;
JL0136:
		if ( i < m_iMemberCount )
		{
			m_Team[i].Controller.GotoState('FollowLeader');
			i++;
			goto JL0136;
		}
		EndRoomEntry();
	}
}

function GetPlayerDirection ()
{
	local float fDirResult;
	local Vector vCrossDir;
	local Vector vPlayerMove;

	if (  !m_TeamLeader.m_bIsPlayer )
	{
		return;
	}
	vPlayerMove=Normal(m_TeamLeader.Location - m_Door.Location);
	fDirResult=vPlayerMove Dot m_Door.m_vLookDir;
	vCrossDir=vPlayerMove Cross m_Door.m_vLookDir;
	if ( m_Door.m_eRoomLayout == 1 )
	{
		if ( (fDirResult > 0.90) || (vCrossDir.Z > 0) )
		{
//			m_ePlayerRoomEntry=2;
		}
		else
		{
			if ( fDirResult > 0.40 )
			{
//				m_ePlayerRoomEntry=0;
			}
			else
			{
//				m_ePlayerRoomEntry=1;
			}
		}
	}
	else
	{
		if ( m_Door.m_eRoomLayout == 2 )
		{
			if ( (fDirResult > 0.90) || (vCrossDir.Z < 0) )
			{
//				m_ePlayerRoomEntry=1;
			}
			else
			{
				if ( fDirResult > 0.40 )
				{
//					m_ePlayerRoomEntry=0;
				}
				else
				{
//					m_ePlayerRoomEntry=2;
				}
			}
		}
		else
		{
			if ( fDirResult > 0.90 )
			{
//				m_ePlayerRoomEntry=0;
			}
			else
			{
				if ( vCrossDir.Z > 0 )
				{
//					m_ePlayerRoomEntry=1;
				}
				else
				{
//					m_ePlayerRoomEntry=2;
				}
			}
		}
	}
}

function UpdatePlayerWeapon (R6Rainbow Rainbow)
{
	Rainbow.AttachWeapon(Rainbow.EngineWeapon,Rainbow.EngineWeapon.m_AttachPoint);
	if ( (Rainbow.EngineWeapon != Rainbow.GetWeaponInGroup(1)) && (Rainbow.GetWeaponInGroup(1) != None) )
	{
		Rainbow.AttachWeapon(Rainbow.GetWeaponInGroup(1),Rainbow.GetWeaponInGroup(1).m_HoldAttachPoint);
	}
	if ( (Rainbow.EngineWeapon != Rainbow.GetWeaponInGroup(2)) && (Rainbow.GetWeaponInGroup(2) != None) )
	{
		Rainbow.AttachWeapon(Rainbow.GetWeaponInGroup(2),Rainbow.GetWeaponInGroup(2).m_HoldAttachPoint);
	}
	if ( (Rainbow.EngineWeapon != Rainbow.GetWeaponInGroup(3)) && (Rainbow.GetWeaponInGroup(3) != None) )
	{
		Rainbow.AttachWeapon(Rainbow.GetWeaponInGroup(3),Rainbow.GetWeaponInGroup(3).m_HoldAttachPoint);
	}
	if ( (Rainbow.EngineWeapon != Rainbow.GetWeaponInGroup(4)) && (Rainbow.GetWeaponInGroup(4) != None) )
	{
		Rainbow.AttachWeapon(Rainbow.GetWeaponInGroup(4),Rainbow.GetWeaponInGroup(4).m_HoldAttachPoint);
	}
	if ( Rainbow.m_bWeaponGadgetActivated == True )
	{
		R6AbstractWeapon(Rainbow.EngineWeapon).m_SelectedWeaponGadget.ActivateGadget(True,True);
	}
	if ( Rainbow.m_bActivateNightVision == True )
	{
		Rainbow.ToggleNightVision();
	}
}

function UpdateFirstPersonWeaponMemory (R6Rainbow npc, R6Rainbow teamLeader)
{
	local int i;
	local R6AbstractWeapon LeaderWeapon;
	local R6AbstractWeapon NPCWeapon;

	if ( Level.NetMode == NM_Standalone )
	{
		i=1;
JL0020:
		if ( i <= 4 )
		{
			if ( npc.GetWeaponInGroup(i) != None )
			{
				npc.GetWeaponInGroup(i).RemoveFirstPersonWeapon();
			}
			if ( teamLeader.GetWeaponInGroup(i) != None )
			{
				teamLeader.GetWeaponInGroup(i).LoadFirstPersonWeapon();
			}
			i++;
			goto JL0020;
		}
		if ( teamLeader.m_bChangingWeapon == True )
		{
//			R6AbstractWeapon(teamLeader.EngineWeapon).m_FPHands.SetDrawType(DT_None);
			teamLeader.EngineWeapon.GotoState('DiscardWeapon');
			teamLeader.PendingWeapon.m_bPawnIsWalking=teamLeader.EngineWeapon.m_bPawnIsWalking;
			teamLeader.EngineWeapon=teamLeader.PendingWeapon;
			if ( teamLeader.EngineWeapon.IsInState('RaiseWeapon') )
			{
				teamLeader.EngineWeapon.BeginState();
			}
			else
			{
				teamLeader.EngineWeapon.GotoState('RaiseWeapon');
			}
		}
		else
		{
			teamLeader.EngineWeapon.StartLoopingAnims();
		}
	}
	else
	{
		teamLeader.m_bReloadingWeapon=False;
		teamLeader.m_bPawnIsReloading=False;
		teamLeader.m_bWeaponTransition=False;
		npc.m_bReloadingWeapon=False;
		npc.m_bPawnIsReloading=False;
		npc.m_bWeaponTransition=False;
		if ( (Level.NetMode != 1) && teamLeader.IsLocallyControlled() )
		{
			teamLeader.RemoteRole=ROLE_SimulatedProxy;
		}
		else
		{
			teamLeader.RemoteRole=ROLE_AutonomousProxy;
		}
		npc.RemoteRole=ROLE_SimulatedProxy;
		i=1;
JL0289:
		if ( i <= 4 )
		{
			LeaderWeapon=R6AbstractWeapon(teamLeader.GetWeaponInGroup(i));
			NPCWeapon=R6AbstractWeapon(npc.GetWeaponInGroup(i));
			if ( LeaderWeapon != None )
			{
				if ( (Level.NetMode != 1) && teamLeader.IsLocallyControlled() )
				{
					LeaderWeapon.RemoteRole=ROLE_SimulatedProxy;
				}
				else
				{
					LeaderWeapon.RemoteRole=ROLE_AutonomousProxy;
				}
				NPCWeapon.RemoteRole=ROLE_SimulatedProxy;
			}
			i++;
			goto JL0289;
		}
		ClientUpdateFirstPersonWpnAndPeeking(npc,teamLeader);
	}
}

simulated function ClientUpdateFirstPersonWpnAndPeeking (R6Rainbow npc, R6Rainbow teamLeader)
{
	local int i;
	local bool bLoadWorked;
	local R6AbstractWeapon LeaderWeapon;
	local R6AbstractWeapon NPCWeapon;
	local Texture scopeTexture;
	local R6PlayerController LocalController;

	LocalController=R6PlayerController(npc.Controller);
	if ( LocalController == None )
	{
		LocalController=R6PlayerController(teamLeader.Controller);
	}
	if ( Level.NetMode == NM_Client )
	{
		teamLeader.Role=ROLE_AutonomousProxy;
		npc.Role=ROLE_SimulatedProxy;
	}
	teamLeader.bRotateToDesired=False;
	i=1;
JL0090:
	if ( i <= 4 )
	{
		LeaderWeapon=R6AbstractWeapon(teamLeader.GetWeaponInGroup(i));
		NPCWeapon=R6AbstractWeapon(npc.GetWeaponInGroup(i));
		if ( LeaderWeapon != None )
		{
			if ( Level.NetMode == NM_Client )
			{
				LeaderWeapon.Role=ROLE_AutonomousProxy;
				NPCWeapon.Role=ROLE_SimulatedProxy;
			}
			npc.GetWeaponInGroup(i).RemoveFirstPersonWeapon();
			bLoadWorked=teamLeader.GetWeaponInGroup(i).LoadFirstPersonWeapon(,LocalController);
		}
		i++;
		goto JL0090;
	}
	if ( bLoadWorked == True )
	{
		if ( teamLeader.m_bChangingWeapon == True )
		{
			if ( teamLeader.EngineWeapon != teamLeader.PendingWeapon )
			{
//				R6AbstractWeapon(teamLeader.EngineWeapon).m_FPHands.SetDrawType(DT_None);
				teamLeader.EngineWeapon.GotoState('None');
				teamLeader.PendingWeapon.m_bPawnIsWalking=teamLeader.EngineWeapon.m_bPawnIsWalking;
				teamLeader.EngineWeapon=teamLeader.PendingWeapon;
			}
			LocalController.m_bLockWeaponActions=True;
			if ( teamLeader.EngineWeapon.IsInState('RaiseWeapon') )
			{
				teamLeader.EngineWeapon.BeginState();
			}
			else
			{
				teamLeader.EngineWeapon.GotoState('RaiseWeapon');
			}
		}
		else
		{
			if ( teamLeader.EngineWeapon != None )
			{
				teamLeader.EngineWeapon.StartLoopingAnims();
			}
		}
	}
//	LocalController.SetPeekingInfo(PEEK_none,npc.1000.00);
}

function ResetWeaponReloading ()
{
	if ( m_Team[0].m_bPawnIsReloading == True )
	{
		m_Team[0].ServerSwitchReloadingWeapon(False);
		m_Team[0].m_bPawnIsReloading=False;
		m_Team[0].GotoState('None');
		m_Team[0].PlayWeaponAnimation();
	}
}

function SetPlayerControllerState (R6PlayerController aPlayerController)
{
	if ( m_Team[0].m_bIsClimbingLadder )
	{
		aPlayerController.ClientHideReticule(True);
		m_Team[0].EngineWeapon.GotoState('PutWeaponDown');
		if ( m_Team[0].Physics == 12 )
		{
			aPlayerController.m_bSkipBeginState=True;
			if ( m_Team[0].m_bGettingOnLadder )
			{
				aPlayerController.GotoState('PlayerBeginClimbingLadder');
			}
			else
			{
				aPlayerController.GotoState('PlayerEndClimbingLadder');
			}
		}
		else
		{
			aPlayerController.m_bSkipBeginState=False;
			aPlayerController.GotoState('PlayerClimbing');
		}
	}
	else
	{
		if ( (m_Team[0].Physics == 11) && (m_Team[0].OnLadder != None) )
		{
			R6LadderVolume(m_Team[0].OnLadder).RemoveClimber(m_Team[0]);
			MemberFinishedClimbingLadder(m_Team[0]);
			m_Team[0].RainbowEquipWeapon();
			m_Team[0].m_ePlayerIsUsingHands=HANDS_None;
			m_Team[0].m_bWeaponTransition=False;
		}
		aPlayerController.ClientHideReticule(False);
		aPlayerController.GotoState('PlayerWalking');
		m_Team[0].SetPhysics(PHYS_Walking);
	}
	if ( Level.NetMode != 0 )
	{
		aPlayerController.ClientGotoState(aPlayerController.GetStateName(),'None');
		aPlayerController.ClientDisableFirstPersonViewEffects(True);
	}
}

function SetAILeadControllerState ()
{
	local R6Ladder topLadder;
	local R6Ladder bottomLadder;

	if ( m_TeamLeader.m_bIsPlayer )
	{
		return;
	}
	if ( m_TeamLeader.m_bIsClimbingLadder )
	{
		topLadder=R6LadderVolume(m_TeamLeader.OnLadder).m_TopLadder;
		bottomLadder=R6LadderVolume(m_TeamLeader.OnLadder).m_BottomLadder;
		m_TeamLeader.Controller.NextState='WaitForTeam';
		if ( m_TeamLeader.Physics == 12 )
		{
			R6RainbowAI(m_TeamLeader.Controller).m_bMoveTargetAlreadySet=True;
			if ( m_TeamLeader.m_bGettingOnLadder )
			{
				m_TeamLeader.Controller.GotoState('BeginClimbingLadder','WaitForStartClimbingAnimToEnd');
			}
			else
			{
				m_TeamLeader.Controller.GotoState('EndClimbingLadder','WaitForEndClimbingAnimToEnd');
			}
		}
		else
		{
			m_TeamLeader.Controller.GotoState('BeginClimbingLadder','MoveTowardEndOfLadder');
		}
		if ( (m_PlanActionPoint != None) && (Abs(m_PlanActionPoint.Location.Z - topLadder.Location.Z) < Abs(m_PlanActionPoint.Location.Z - bottomLadder.Location.Z)) )
		{
			m_TeamLeader.Controller.MoveTarget=topLadder;
		}
		else
		{
			m_TeamLeader.Controller.MoveTarget=bottomLadder;
		}
	}
	else
	{
		m_TeamLeader.Controller.GotoState('Patrol');
		m_TeamLeader.SetPhysics(PHYS_Walking);
		if ( m_TeamLeader.m_eEquipWeapon != 3 )
		{
			m_TeamLeader.RainbowEquipWeapon();
			m_TeamLeader.m_ePlayerIsUsingHands=HANDS_None;
			m_TeamLeader.m_bWeaponTransition=False;
		}
	}
}

function ResetRainbowControllerStates (R6PlayerController aPlayerController, int iMember)
{
	local int i;
	local bool bAtLeastOneMemberIsOnLadder;

	SetPlayerControllerState(aPlayerController);
	i=1;
JL0012:
	if ( i < m_iMemberCount )
	{
		R6RainbowAI(m_Team[i].Controller).m_TeamLeader=m_TeamLeader;
		if ( (i == iMember) && m_Team[i].m_bIsClimbingLadder )
		{
			m_Team[i].Controller.NextState='FollowLeader';
			R6LadderVolume(m_Team[i].OnLadder).DisableCollisions(m_Team[i].m_Ladder);
			if ( m_Team[i].Physics == 12 )
			{
				R6RainbowAI(m_Team[i].Controller).m_bMoveTargetAlreadySet=True;
				if ( m_Team[i].m_bGettingOnLadder )
				{
					m_Team[i].Controller.GotoState('BeginClimbingLadder','WaitForStartClimbingAnimToEnd');
				}
				else
				{
					m_Team[i].Controller.GotoState('EndClimbingLadder','WaitForEndClimbingAnimToEnd');
				}
			}
			else
			{
				m_Team[i].Controller.GotoState('BeginClimbingLadder','MoveTowardEndOfLadder');
			}
			if ( m_Team[0].Location.Z > m_Team[i].Location.Z + 100 )
			{
				m_Team[i].Controller.MoveTarget=R6LadderVolume(m_Team[i].OnLadder).m_TopLadder;
			}
			else
			{
				m_Team[i].Controller.MoveTarget=R6LadderVolume(m_Team[i].OnLadder).m_BottomLadder;
			}
			bAtLeastOneMemberIsOnLadder=True;
		}
		else
		{
			if (  !m_Team[i].m_bIsClimbingLadder )
			{
				m_Team[i].Controller.GotoState('FollowLeader');
				if ( m_Team[i].Physics != 2 )
				{
					m_Team[i].SetPhysics(PHYS_Walking);
				}
				if ( m_Team[i].m_eEquipWeapon != 3 )
				{
					m_Team[i].RainbowEquipWeapon();
					m_Team[i].m_ePlayerIsUsingHands=HANDS_None;
					m_Team[i].m_bWeaponTransition=False;
				}
			}
		}
		i++;
		goto JL0012;
	}
	SetTeamIsClimbingLadder(bAtLeastOneMemberIsOnLadder);
	if ( m_bCAWaitingForZuluGoCode )
	{
		ResetZuluGoCode();
	}
}

function SwitchPlayerControlToPreviousMember ()
{
	local R6Rainbow tempPawn;
	local R6RainbowAI tempRainbowAI;
	local R6PlayerController tempPlayerController;
	local int iLastMember;
	local int i;

	if ( (Level.Game != None) &&  !R6AbstractGameInfo(Level.Game).CanSwitchTeamMember() )
	{
		return;
	}
	if (  !m_Team[0].IsAlive() )
	{
		SwitchPlayerControlToNextMember();
		return;
	}
	TeamIsSeparatedFromLead(False);
	if ( m_iMemberCount <= 1 )
	{
		return;
	}
	iLastMember=m_iMemberCount - 1;
	tempPawn=m_Team[iLastMember];
	i=m_iMemberCount - 1;
JL0099:
	if ( i > 0 )
	{
		m_Team[i]=m_Team[i - 1];
		m_Team[i].m_iID=i;
		i--;
		goto JL0099;
	}
	m_Team[0]=tempPawn;
	m_TeamLeader=m_Team[0];
	m_TeamLeader.m_iID=0;
	m_Team[1].ClientQuickResetPeeking();
	m_Team[1].m_bIsPlayer=False;
	m_TeamLeader.m_bIsPlayer=True;
	tempPawn=m_Team[1];
	UpdatePlayerWeapon(tempPawn);
	ResetWeaponReloading();
	tempRainbowAI=R6RainbowAI(m_Team[0].Controller);
	tempPlayerController=R6PlayerController(m_Team[1].Controller);
	SwitchControllerRepInfo(tempRainbowAI,tempPlayerController);
	tempPlayerController.ToggleHelmetCameraZoom(True);
	tempPlayerController.CancelShake();
	tempPlayerController.ClientForceUnlockWeapon();
	m_Team[1].UnPossessed();
	tempRainbowAI.Possess(m_Team[1]);
	AssociatePlayerAndPawn(tempPlayerController,m_Team[0]);
	m_Team[1].PawnLook(rot(0,0,0),);
	m_Team[1].ResetBoneRotation();
	m_TeamLeader.ResetBoneRotation();
	m_TeamLeader.ClientQuickResetPeeking();
	UpdateFirstPersonWeaponMemory(tempPawn,m_TeamLeader);
	ResetRainbowControllerStates(tempPlayerController,1);
	m_iIntermLeader=0;
	tempPlayerController.UpdatePlayerPostureAfterSwitch();
	UpdateEscortList();
	UpdateTeamGrenadeStatus();
}

function SwitchPlayerControlToNextMember ()
{
	local R6Rainbow tempPawn;
	local R6RainbowAI tempRainbowAI;
	local R6PlayerController tempPlayerController;
	local int iLastMember;
	local int i;
	local bool bLeaderIsDead;
	local bool bBackupIsClimbing;

	if ( (Level.Game != None) &&  !R6AbstractGameInfo(Level.Game).CanSwitchTeamMember() )
	{
		return;
	}
	bLeaderIsDead= !m_Team[0].IsAlive();
	TeamIsSeparatedFromLead(False);
	if ( bLeaderIsDead )
	{
		if ( m_iMemberCount == 0 )
		{
			return;
		}
		else
		{
			R6PlayerController(m_Team[0].Controller).ClientFadeCommonSound(0.50,100);
		}
	}
	else
	{
		if ( m_iMemberCount == 1 )
		{
			return;
		}
	}
	iLastMember=m_iMemberCount - 1;
	tempPlayerController=R6PlayerController(m_Team[0].Controller);
	if ( bLeaderIsDead )
	{
		tempPawn=m_Team[0];
		i=0;
JL00F0:
		if ( i < m_iMemberCount )
		{
			m_Team[i]=m_Team[i + 1];
			m_Team[i].m_iID=i;
			i++;
			goto JL00F0;
		}
		m_TeamLeader=m_Team[0];
		m_Team[iLastMember + 1]=tempPawn;
		m_Team[iLastMember + 1].m_iID=iLastMember + 1;
		tempPawn.m_bIsPlayer=False;
		m_TeamLeader.m_bIsPlayer=True;
		tempRainbowAI=R6RainbowAI(m_TeamLeader.Controller);
		tempPlayerController.ToggleHelmetCameraZoom(True);
		tempPlayerController.CancelShake();
		tempPlayerController.ClientForceUnlockWeapon();
		SwitchControllerRepInfo(tempRainbowAI,tempPlayerController);
		bBackupIsClimbing=tempRainbowAI.m_pawn.m_bIsClimbingLadder;
		tempRainbowAI.GotoState('Dead');
		tempRainbowAI.m_pawn.m_bIsClimbingLadder=bBackupIsClimbing;
		m_Team[iLastMember + 1].UnPossessed();
		tempRainbowAI.Possess(m_Team[iLastMember + 1]);
		AssociatePlayerAndPawn(tempPlayerController,m_TeamLeader);
	}
	else
	{
		tempPawn=m_TeamLeader;
		i=0;
JL029F:
		if ( i < m_iMemberCount - 1 )
		{
			m_Team[i]=m_Team[i + 1];
			m_Team[i].m_iID=i;
			i++;
			goto JL029F;
		}
		m_TeamLeader=m_Team[0];
		m_Team[iLastMember]=tempPawn;
		m_Team[iLastMember].m_iID=iLastMember;
		tempPawn.ClientQuickResetPeeking();
		tempPawn.m_bIsPlayer=False;
		m_TeamLeader.m_bIsPlayer=True;
		UpdatePlayerWeapon(tempPawn);
		ResetWeaponReloading();
		tempRainbowAI=R6RainbowAI(m_TeamLeader.Controller);
		tempPlayerController=R6PlayerController(m_Team[iLastMember].Controller);
		tempPlayerController.ToggleHelmetCameraZoom(True);
		tempPlayerController.CancelShake();
		tempPlayerController.ClientForceUnlockWeapon();
		SwitchControllerRepInfo(tempRainbowAI,tempPlayerController);
		m_Team[iLastMember].UnPossessed();
		tempRainbowAI.Possess(m_Team[iLastMember]);
		AssociatePlayerAndPawn(tempPlayerController,m_TeamLeader);
		m_Team[iLastMember].PawnLook(rot(0,0,0),);
		m_Team[iLastMember].ResetBoneRotation();
	}
	m_TeamLeader.ResetBoneRotation();
	m_TeamLeader.ClientQuickResetPeeking();
	UpdateFirstPersonWeaponMemory(tempPawn,m_TeamLeader);
	ResetRainbowControllerStates(tempPlayerController,iLastMember);
	m_iIntermLeader=0;
	tempPlayerController.UpdatePlayerPostureAfterSwitch();
	UpdateEscortList();
	UpdateTeamGrenadeStatus();
}

function SwitchControllerRepInfo (R6RainbowAI tempRainbowAI, R6PlayerController tempPlayerController)
{
	local R6PawnReplicationInfo aPawnRepInfo;

	aPawnRepInfo=tempRainbowAI.m_PawnRepInfo;
	tempRainbowAI.m_PawnRepInfo=tempPlayerController.m_PawnRepInfo;
	tempRainbowAI.m_PawnRepInfo.m_ControllerOwner=tempRainbowAI;
	tempPlayerController.m_PawnRepInfo=aPawnRepInfo;
	tempPlayerController.m_PawnRepInfo.m_ControllerOwner=tempPlayerController;
	tempPlayerController.m_CurrentAmbianceObject=tempRainbowAI.Pawn.Region.Zone;
}

function AssociatePlayerAndPawn (R6PlayerController Player, R6Rainbow Pawn)
{
	Player.PossessInit(Pawn);
	Player.SetViewTarget(Pawn);
	Pawn.PlayerReplicationInfo=Player.PlayerReplicationInfo;
	Player.bBehindView=False;
	switch (Pawn.m_eHealth)
	{
/*		case 0:
		Player.PlayerReplicationInfo.m_iHealth=0;
		break;
		case 1:
		Player.PlayerReplicationInfo.m_iHealth=1;
		break;
		case 2:
		case 3:
		Player.PlayerReplicationInfo.m_iHealth=2;
		break;
		default:*/
	}
}

function SwapPlayerControlWithTeamMate (int iMember)
{
	local R6Rainbow tempPawn;
	local R6RainbowAI tempRainbowAI;
	local R6PlayerController tempPlayerController;
	local int i;

	if ( (Level.Game != None) &&  !R6AbstractGameInfo(Level.Game).CanSwitchTeamMember() )
	{
		return;
	}
	if ( (iMember == 0) ||  !m_Team[iMember].IsAlive() )
	{
		return;
	}
	TeamIsSeparatedFromLead(False);
	tempPawn=m_Team[0];
	m_Team[0]=m_Team[iMember];
	m_Team[0].m_iID=0;
	m_TeamLeader=m_Team[0];
	m_Team[iMember]=tempPawn;
	m_Team[iMember].m_iID=iMember;
	m_TeamLeader.m_bIsPlayer=True;
	m_Team[iMember].m_bIsPlayer=False;
	m_Team[iMember].ClientQuickResetPeeking();
	tempPawn=m_Team[iMember];
	UpdatePlayerWeapon(tempPawn);
	ResetWeaponReloading();
	tempRainbowAI=R6RainbowAI(m_Team[0].Controller);
	tempPlayerController=R6PlayerController(m_Team[iMember].Controller);
	tempPlayerController.ToggleHelmetCameraZoom(True);
	tempPlayerController.CancelShake();
	tempPlayerController.ClientForceUnlockWeapon();
	SwitchControllerRepInfo(tempRainbowAI,tempPlayerController);
	m_Team[iMember].UnPossessed();
	tempRainbowAI.Possess(m_Team[iMember]);
	AssociatePlayerAndPawn(tempPlayerController,m_Team[0]);
	m_Team[iMember].PawnLook(rot(0,0,0),);
	m_Team[iMember].ResetBoneRotation();
	m_TeamLeader.ResetBoneRotation();
	m_TeamLeader.ClientQuickResetPeeking();
	UpdateFirstPersonWeaponMemory(tempPawn,m_TeamLeader);
	ResetRainbowControllerStates(tempPlayerController,iMember);
	m_iIntermLeader=0;
	tempPlayerController.UpdatePlayerPostureAfterSwitch();
	UpdateEscortList();
	UpdateTeamGrenadeStatus();
}

function UpdateTeamStatus (R6Pawn member)
{
	local R6PlayerController _playerController;

/*	if ( (m_iTeamHealth[member.m_iPermanentID] == member.2) && (member.m_eHealth == 3) )
	{
		m_iTeamHealth[member.m_iPermanentID]=member.m_eHealth;
		return;
	}*/
	if (  !member.IsAlive() )
	{
		_playerController=R6PlayerController(m_TeamLeader.Controller);
		TeamMemberDead(member);
		if ( (m_iMemberCount == 0) && m_bLeaderIsAPlayer && (Level.NetMode != 0) )
		{
			_playerController.ClientTeamIsDead();
		}
		if ( m_bLeaderIsAPlayer && (m_iMemberCount == 1) ||  !m_bLeaderIsAPlayer && (m_iMemberCount == 0) )
		{
//			SetTeamState(21);
		}
	}
/*	if (  !member.m_bIsPlayer && (m_iTeamAction != 512) && (m_iTeamHealth[member.m_iPermanentID] == member.0) && (member.m_eHealth == 1) )
	{
		if ( (m_iMemberCount > member.m_iID + 1) && (m_Team[member.m_iID + 1].m_eHealth == 0) )
		{
			if ( SendMemberToEnd(member.m_iID,True) )
			{
				ResetTeamMemberStates();
				if ( m_bTeamIsHoldingPosition &&  !m_Team[0].m_bIsPlayer )
				{
					m_Team[0].Controller.GotoState('HoldPosition');
				}
			}
		}
	}      */
	m_iTeamHealth[member.m_iPermanentID]=member.m_eHealth;
}

function bool RainbowAIAreStillClimbingLadder ()
{
	local int i;

	i=1;
JL0007:
	if ( i < m_iMemberCount )
	{
		if ( m_Team[i].IsAlive() && m_Team[i].m_bIsClimbingLadder )
		{
			return True;
		}
		i++;
		goto JL0007;
	}
	return False;
}

function TeamMemberDead (R6Pawn DeadPawn)
{
	local int i;
	local int iMemberId;
	local bool bReIssueTeamOrder;
	local bool bReassignNextMemberToLeadRoomEntry;
	local int iIdxDeadPawn;

	UpdateEscortList();
	UpdateTeamGrenadeStatus();
	iMemberId=DeadPawn.m_iID;
	DeadPawn.Controller.Enemy=None;
	if ( iMemberId == 0 )
	{
		m_TeamLeader=m_Team[1];
		if ( m_bLeaderIsAPlayer )
		{
			m_iMemberCount--;
			m_iMembersLost++;
			return;
		}
	}
	if ( m_iTeamAction != 0 )
	{
		if ( iMemberId == 1 )
		{
			bReIssueTeamOrder=True;
			if ( m_PawnControllingDoor == DeadPawn )
			{
				bReassignNextMemberToLeadRoomEntry=True;
			}
		}
		if ( m_iTeamAction == 512 )
		{
			if ( iMemberId == m_iMemberCount - 1 )
			{
				TeamFinishedClimbingLadder();
			}
		}
	}
	if (  !RainbowAIAreStillClimbingLadder() )
	{
		m_bTeamIsClimbingLadder=False;
	}
	i=iMemberId + 1;
JL00E7:
	if ( i < m_iMemberCount + m_iMembersLost )
	{
		if ( m_Team[i].IsAlive() )
		{
			m_Team[i - 1]=m_Team[i];
			if ( m_Team[i].Controller != None )
			{
				R6RainbowAI(m_Team[i].Controller).Promote();
			}
		}
		i++;
		goto JL00E7;
	}
	if ( m_bLeaderIsAPlayer && m_Team[0].m_bIsPlayer &&  !m_Team[0].IsAlive() )
	{
		iIdxDeadPawn=m_iMemberCount;
	}
	else
	{
		iIdxDeadPawn=m_iMemberCount - 1;
	}
	m_Team[iIdxDeadPawn]=R6Rainbow(DeadPawn);
	DeadPawn.m_iID=iIdxDeadPawn;
	if (  !m_bLeaderIsAPlayer && (m_TeamLeader != None) && (m_TeamLeader.Controller != None) )
	{
		R6RainbowAI(m_TeamLeader.Controller).m_bTeamMateHasBeenKilled=True;
	}
	m_iMemberCount--;
	m_iMembersLost++;
	if ( bReIssueTeamOrder && (m_iMemberCount > 1) )
	{
		if ( m_bTeamIsClimbingLadder )
		{
			m_Team[1].Controller.NextState='TeamClimbEndNoLeader';
		}
		else
		{
			ReIssueTeamOrders();
		}
		if ( bReassignNextMemberToLeadRoomEntry )
		{
			m_PawnControllingDoor=m_Team[1];
		}
	}
}

function bool AtLeastOneMemberIsWounded ()
{
	local int i;

	if ( m_bWoundedHostage )
	{
		return True;
	}
	i=0;
JL0012:
	if ( i < m_iMemberCount )
	{
		if ( m_Team[i].m_eHealth == 1 )
		{
			return True;
		}
		i++;
		goto JL0012;
	}
	return False;
}

function SetFormation (R6RainbowAI memberAI)
{
//	memberAI.m_eFormation=m_eFormation;
}

event UpdateTeamFormation (eFormation eFormation)
{
	local int i;
	local int iStart;

	m_eFormation=eFormation;
	if ( m_bLeaderIsAPlayer )
	{
		iStart=1;
	}
	i=iStart;
JL0026:
	if ( i < m_iMemberCount )
	{
		SetFormation(R6RainbowAI(m_Team[i].Controller));
		i++;
		goto JL0026;
	}
}

event RequestFormationChange (eFormation eFormation)
{
	if ( m_eRequestedFormation == eFormation )
	{
//		UpdateTeamFormation(eFormation);
	}
	else
	{
		m_eRequestedFormation=eFormation;
	}
}

function Tick (float fDelta)
{
	local int i;

	if (  !m_bTeamIsEngagingEnemy && (m_eTeamState == 6) )
	{
		if ( Level.TimeSeconds - m_fEngagingTimer > 1.00 )
		{
			m_eTeamState=m_eBackupTeamState;
		}
	}
	if ( m_TeamLeader != None )
	{
		if ( VSize(m_TeamLeader.Velocity) > 5 )
		{
			m_rTeamDirection=rotator(m_TeamLeader.Velocity);
		}
		if ( m_bLeaderIsAPlayer )
		{
			if ( Level.NetMode == NM_Standalone )
			{
				if ( m_PlanActionPoint != None )
				{
					if ( VSize(m_TeamLeader.Location - m_PlanActionPoint.Location) < 250 )
					{
						m_PlayerLastActionPoint=m_PlanActionPoint;
						ActionPointReached();
						m_ePlayerAPAction=m_ePlanAction;
						if ( m_eGoCode == 4 )
						{
							if ( m_ePlanAction != 0 )
							{
								ActionNodeCompleted();
							}
						}
						else
						{
//							m_ePlayerAPAction=m_TeamPlanning.GetAction();
						}
					}
					if ( (m_ePlayerAPAction != 0) && (VSize(m_TeamLeader.Location - m_PlayerLastActionPoint.Location) > 250) )
					{
//						m_ePlayerAPAction=0;
					}
				}
				else
				{
					if ( m_eGoCode == 4 )
					{
						GetNextActionPoint();
						if ( m_PlanActionPoint != None )
						{
							m_ePlayerAPAction=m_ePlanAction;
							ActionNodeCompleted();
						}
					}
				}
			}
			if ( m_TeamLeader.m_bIsProne )
			{
//				m_TeamLeader.m_eMovementPace=1;
			}
			else
			{
				if ( m_TeamLeader.bIsCrouched )
				{
					if ( m_TeamLeader.bIsWalking )
					{
//						m_TeamLeader.m_eMovementPace=2;
					}
					else
					{
//						m_TeamLeader.m_eMovementPace=3;
					}
				}
				else
				{
					if ( m_TeamLeader.bIsWalking )
					{
//						m_TeamLeader.m_eMovementPace=4;
					}
					else
					{
//						m_TeamLeader.m_eMovementPace=5;
					}
				}
			}
		}
		else
		{
			m_ePlayerAPAction=m_ePlanAction;
		}
	}
}

function int PickMemberClosestTo (Actor aNoiseSource)
{
	local int i;
	local int iMemberClosest;
	local int fDist;
	local int fClosestDist;

	iMemberClosest=-1;
	fClosestDist=10000;
	if ( m_iMemberCount == 1 )
	{
		if ( m_bLeaderIsAPlayer )
		{
			return iMemberClosest;
		}
		else
		{
			return 0;
		}
	}
	i=1;
JL003C:
	if ( i < m_iMemberCount )
	{
		if ( m_Team[i].m_bIsPlayer )
		{
			goto JL00B9;
		}
		fDist=VSize(m_Team[i].Location - aNoiseSource.Location);
		if ( fDist < fClosestDist )
		{
			iMemberClosest=i;
			fClosestDist=fDist;
		}
JL00B9:
		i++;
		goto JL003C;
	}
	return iMemberClosest;
}

function TeamHearNoise (Actor aNoiseMaker)
{
	local int iMember;

	m_vNoiseSource=aNoiseMaker.Location;
	if ( m_bLeaderIsAPlayer )
	{
		if ( m_iMemberCount == 1 )
		{
			return;
		}
	}
	else
	{
		if ( m_iMemberCount == 1 )
		{
			if ( m_Team[0].Controller.IsInState('SnipeUntilGoCode') )
			{
				R6RainbowAI(m_Team[0].Controller).SetNoiseFocus(m_vNoiseSource);
				return;
			}
		}
	}
	iMember=PickMemberClosestTo(aNoiseMaker);
	if ( iMember < 0 )
	{
		return;
	}
	R6RainbowAI(m_Team[iMember].Controller).SetNoiseFocus(m_vNoiseSource);
}

function TeamSpottedSurrenderedTerrorist (R6Pawn terrorist)
{
	if ( m_TeamLeader.m_bIsPlayer )
	{
		return;
	}
	if (  !R6Terrorist(terrorist).m_bIsUnderArrest )
	{
		m_SurrenderedTerrorist=terrorist;
	}
}

function bool RainbowIsEngaging ()
{
	local int i;

	i=1;
JL0007:
	if ( i < m_iMemberCount )
	{
		if ( m_Team[i].Controller.Enemy != None )
		{
			return True;
		}
		i++;
		goto JL0007;
	}
	return False;
}

function bool EngageEnemyIfNotAlreadyEngaged (R6Pawn Rainbow, R6Pawn Enemy)
{
	local bool bFound;
	local int i;

	if ( (Enemy == None) || (m_iMemberCount == 0) )
	{
		return False;
	}
	i=0;
JL0021:
	if ( i < m_iMemberCount )
	{
		if ( m_Team[i].m_bIsPlayer || (m_Team[i] == Rainbow) )
		{
			goto JL0090;
		}
		if ( R6RainbowAI(m_Team[i].Controller).Enemy == Enemy )
		{
			return False;
		}
JL0090:
		i++;
		goto JL0021;
	}
	if ( (m_TeamLeader.m_bIsPlayer || m_bPlayerHasFocus) &&  !R6Terrorist(Enemy).m_bEnteringView )
	{
		R6Terrorist(Enemy).m_bEnteringView=True;
		if ( (m_Team[m_iMemberCount - 1] == Rainbow) && R6RainbowAI(Rainbow.Controller).m_bIsMovingBackwards )
		{
//			m_MemberVoicesMgr.PlayRainbowMemberVoices(Rainbow,3);
		}
		else
		{
//			m_MemberVoicesMgr.PlayRainbowMemberVoices(Rainbow,2);
		}
	}
	return True;
}

function DisEngageEnemy (Pawn Rainbow, Pawn Enemy)
{
	CheckTeamEngagingStatus(Rainbow);
}

function RainbowIsEngagingEnemy ()
{
	m_bTeamIsEngagingEnemy=True;
	if ( m_eTeamState != 6 )
	{
		m_eBackupTeamState=m_eTeamState;
//		SetTeamState(6);
	}
}

function CheckTeamEngagingStatus (optional Pawn rainbowToIgnore)
{
	local bool bRainbowAreStillEngaging;
	local int i;

	i=0;
JL0007:
	if ( i < m_iMemberCount )
	{
		if ( m_Team[i].m_bIsPlayer || (m_Team[i] == rainbowToIgnore) )
		{
			goto JL009C;
		}
		if ( (m_Team[i].Controller.Enemy != None) &&  !m_Team[i].m_bIsSniping && m_bSniperHold )
		{
			m_bTeamIsEngagingEnemy=True;
			return;
		}
JL009C:
		i++;
		goto JL0007;
	}
	if ( m_bTeamIsEngagingEnemy )
	{
		m_bTeamIsEngagingEnemy=False;
		m_fEngagingTimer=Level.TimeSeconds;
	}
}

function AITeamHoldPosition ()
{
	local int iMember;

	if ( m_bPlayerHasFocus || m_bPlayerInGhostMode )
	{
//		m_PlayerVoicesMgr.PlayRainbowPlayerVoices(m_TeamLeader,3);
	}
	if ( m_bLeaderIsAPlayer || (m_iMemberCount == 0) || m_bTeamIsClimbingLadder )
	{
		return;
	}
	if ( m_bCAWaitingForZuluGoCode )
	{
		ResetZuluGoCode();
	}
	m_bTeamIsHoldingPosition=True;
	if ( m_TeamLeader.m_bIsSniping || m_TeamLeader.Controller.IsInState('PlaceBreachingCharge') || m_TeamLeader.Controller.IsInState('DetonateBreachingCharge') )
	{
		return;
	}
	iMember=0;
JL00BD:
	if ( iMember < m_iMemberCount )
	{
		m_Team[iMember].Controller.NextState='None';
		m_Team[iMember].Controller.GotoState('HoldPosition');
		iMember++;
		goto JL00BD;
	}
}

function AITeamFollowPlanning ()
{
	local int iMember;

	if ( m_bPlayerHasFocus || m_bPlayerInGhostMode )
	{
//		m_PlayerVoicesMgr.PlayRainbowPlayerVoices(m_TeamLeader,4);
	}
	if ( m_bLeaderIsAPlayer || (m_iMemberCount == 0) || m_bTeamIsClimbingLadder )
	{
		return;
	}
	m_bTeamIsHoldingPosition=False;
	if ( m_TeamLeader.m_bIsSniping || m_TeamLeader.Controller.IsInState('PlaceBreachingCharge') || m_TeamLeader.Controller.IsInState('DetonateBreachingCharge') )
	{
		return;
	}
	m_TeamLeader.Controller.GotoState('Patrol');
	iMember=1;
JL00C7:
	if ( iMember < m_iMemberCount )
	{
		m_Team[iMember].Controller.GotoState('FollowLeader');
		R6RainbowAI(m_Team[iMember].Controller).ResetStateProgress();
		iMember++;
		goto JL00C7;
	}
}

function bool SendMemberToEnd (int iMember, optional bool bReorganizeWounded)
{
	local int i;
	local R6Rainbow Rainbow;
	local R6RainbowAI rainbowAI;

	Rainbow=m_Team[iMember];
	rainbowAI=R6RainbowAI(Rainbow.Controller);
	if ( bReorganizeWounded )
	{
		if ( ((m_iTeamAction != 0) || m_bTeamIsClimbingLadder || Rainbow.m_bIsSniping || Rainbow.m_bInteractingWithDevice || m_bEntryInProgress || (m_eTeamState == 6)) && (Rainbow.m_eHealth == 1) )
		{
			rainbowAI.m_bReorganizationPending=True;
			return False;
		}
		else
		{
			rainbowAI.m_bReorganizationPending=False;
		}
	}
	i=iMember;
JL00DB:
	if ( i < m_iMemberCount - 1 )
	{
		m_Team[i]=m_Team[i + 1];
		m_Team[i].m_iID=i;
		i++;
		goto JL00DB;
	}
	m_Team[i]=Rainbow;
	m_Team[i].m_iID=i;
	return True;
}

function AssignNewTeamLeader (int iNewLeader)
{
	ReOrganizeTeam(iNewLeader);
	m_iIntermLeader=0;
}

function ReOrganizeTeam (int iNewLeader)
{
	local int i;

	if ( m_iMemberCount == 1 )
	{
		return;
	}
	if ( m_bLeaderIsAPlayer )
	{
		if ( m_iMemberCount == 2 )
		{
			return;
		}
		i=1;
JL002B:
		if ( i < iNewLeader )
		{
			SendMemberToEnd(1);
			i++;
			goto JL002B;
		}
	}
	else
	{
		if ( m_iMemberCount == 1 )
		{
			return;
		}
		i=0;
JL0062:
		if ( i < iNewLeader )
		{
			SendMemberToEnd(0);
			i++;
			goto JL0062;
		}
		ResetTeamMemberStates();
	}
	m_iIntermLeader=iNewLeader;
	Escort_ManageList();
}

function ResetTeamMemberStates ()
{
	local int i;

	if ( m_bLeaderIsAPlayer )
	{
		return;
	}
	m_TeamLeader=m_Team[0];
	if ( m_TeamLeader == None )
	{
		return;
	}
	i=0;
JL002C:
	if ( i < m_iMemberCount )
	{
		if ( i == 0 )
		{
			R6RainbowAI(m_Team[0].Controller).m_TeamLeader=None;
			m_Team[i].Controller.GotoState('Patrol');
		}
		else
		{
			R6RainbowAI(m_Team[i].Controller).m_TeamLeader=m_TeamLeader;
			m_Team[i].Controller.GotoState('FollowLeader');
		}
		i++;
		goto JL002C;
	}
}

function RestoreTeamOrder ()
{
	local int i;

	if ( m_bCAWaitingForZuluGoCode )
	{
		return;
	}
	if ( m_iIntermLeader == 0 )
	{
		return;
	}
	if ( m_bLeaderIsAPlayer )
	{
		if ( (m_iMemberCount == 2) || (m_iIntermLeader == 1) )
		{
			return;
		}
		i=1;
JL0043:
		if ( i <= m_iMemberCount - m_iIntermLeader )
		{
			SendMemberToEnd(1);
			i++;
			goto JL0043;
		}
	}
	else
	{
		if ( m_iMemberCount == 1 )
		{
			return;
		}
		i=0;
JL0081:
		if ( i < m_iMemberCount - m_iIntermLeader )
		{
			SendMemberToEnd(0);
			i++;
			goto JL0081;
		}
		ReOrganizeWoundedMembers();
		ResetTeamMemberStates();
	}
	m_iIntermLeader=0;
	Escort_ManageList();
}

function ReOrganizeWoundedMembers ()
{
	local int i;
	local bool bReOrganized;

	i=0;
JL0007:
	if ( i < m_iMemberCount )
	{
		if ( m_Team[i].m_bIsPlayer )
		{
			goto JL00C7;
		}
		if ( (i < m_iMemberCount - 1) && (m_Team[i].m_eHealth == 1) && (m_Team[i + 1].m_eHealth == 0) )
		{
			if ( SendMemberToEnd(i,True) )
			{
				bReOrganized=True;
			}
		}
		else
		{
			R6RainbowAI(m_Team[i].Controller).m_bReorganizationPending=False;
		}
JL00C7:
		i++;
		goto JL0007;
	}
	if ( bReOrganized )
	{
		ResetTeamMemberStates();
	}
}

function R6Rainbow FindRainbowWithBreachingCharge ()
{
	local int iMember;
	local int iWeaponGroup;
	local R6AbstractWeapon demolitionsWeapon;

	iMember=0;
JL0007:
	if ( iMember < m_iMemberCount )
	{
		if ( m_Team[iMember].m_bIsPlayer )
		{
			goto JL0051;
		}
		if ( HasBreachingCharge(m_Team[iMember]) )
		{
			return m_Team[iMember];
		}
JL0051:
		iMember++;
		goto JL0007;
	}
	return None;
}

function bool HasBreachingCharge (R6Rainbow Rainbow)
{
	local int iWeaponGroup;
	local R6EngineWeapon demolitionsWeapon;

	iWeaponGroup=3;
JL0008:
	if ( iWeaponGroup <= 4 )
	{
		demolitionsWeapon=Rainbow.GetWeaponInGroup(iWeaponGroup);
		if ( (demolitionsWeapon != None) && demolitionsWeapon.IsA('R6BreachingChargeGadget') && demolitionsWeapon.HasAmmo() )
		{
			R6RainbowAI(Rainbow.Controller).m_iActionUseGadgetGroup=iWeaponGroup;
			return True;
		}
		iWeaponGroup++;
		goto JL0008;
	}
	return False;
}

function ReOrganizeTeamForBreachDoor ()
{
	local R6Rainbow actionMember;
	local int i;

	m_BreachingDoor=R6IORotatingDoor(m_TeamPlanning.GetNextDoorToBreach(m_PlanActionPoint));
	if ( HasBreachingCharge(m_Team[0]) ||  !m_BreachingDoor.ShouldBeBreached() )
	{
		return;
	}
	actionMember=FindRainbowWithBreachingCharge();
	if ( actionMember == None )
	{
		return;
	}
	ReOrganizeTeam(actionMember.m_iID);
}

function PlaceBreachCharge ()
{
	if ( m_bLeaderIsAPlayer )
	{
		return;
	}
	if ( m_BreachingDoor == None )
	{
		ActionNodeCompleted();
		return;
	}
	if ( m_BreachingDoor.ShouldBeBreached() &&  !HasBreachingCharge(m_Team[0]) )
	{
		ReOrganizeTeamForBreachDoor();
	}
	if (  !HasBreachingCharge(m_Team[0]) ||  !m_BreachingDoor.ShouldBeBreached() )
	{
		if ( m_eGoCode == 4 )
		{
			ActionNodeCompleted();
		}
		else
		{
			m_bSkipAction=True;
		}
		m_BreachingDoor=None;
	}
	else
	{
		R6RainbowAI(m_Team[0].Controller).ResetStateProgress();
		m_Team[0].Controller.GotoState('PlaceBreachingCharge');
	}
}

function BreachDoor ()
{
	if ( m_bLeaderIsAPlayer )
	{
		ResetTeamGoCode();
	}
	else
	{
		if ( m_bSkipAction )
		{
			ActionNodeCompleted();
		}
		else
		{
			R6RainbowAI(m_Team[0].Controller).DetonateBreach();
		}
	}
}

function SetTeamGoCode (EGoCode eCode)
{
	if ( m_bCAWaitingForZuluGoCode )
	{
//		m_eBackupGoCode=eCode;
	}
	else
	{
//		m_eBackupGoCode=4;
//		m_eGoCode=eCode;
	}
}

function ResetTeamGoCode ()
{
	if ( m_bCAWaitingForZuluGoCode )
	{
		return;
	}
//	m_eGoCode=4;
//	m_eBackupGoCode=4;
}

function ResetZuluGoCode ()
{
	if (  !m_bCAWaitingForZuluGoCode )
	{
		return;
	}
	m_bCAWaitingForZuluGoCode=False;
//	m_eGoCode=m_eBackupGoCode;
//	m_eBackupGoCode=4;
}

function ReOrganizeTeamForSniping ()
{
	local R6Rainbow actionMember;
	local int i;
	local int iBestSniper;
	local float fBestRange;
	local float fCurrentRange;

	if ( m_bSniperReady )
	{
		return;
	}
	iBestSniper=-1;
	i=0;
JL001D:
	if ( i < m_iMemberCount )
	{
		if ( m_Team[i].m_WeaponsCarried[0].m_eWeaponType == 4 )
		{
			if ( iBestSniper == -1 )
			{
				iBestSniper=i;
			}
			else
			{
				if ( m_Team[i].GetSkill(SKILL_Sniper) > m_Team[iBestSniper].GetSkill(SKILL_Sniper) )
				{
					iBestSniper=i;
				}
			}
		}
		i++;
		goto JL001D;
	}
	if ( iBestSniper == -1 )
	{
		iBestSniper=0;
		fBestRange=m_Team[0].m_WeaponsCarried[0].GetWeaponRange();
		i=0;
JL00FA:
		if ( i < m_iMemberCount )
		{
			fCurrentRange=m_Team[i].m_WeaponsCarried[0].GetWeaponRange();
			if ( fCurrentRange > fBestRange )
			{
				iBestSniper=i;
				fBestRange=fCurrentRange;
			}
			i++;
			goto JL00FA;
		}
	}
	if ( iBestSniper != 0 )
	{
		ReOrganizeTeam(iBestSniper);
	}
	m_bSniperReady=True;
}

function SnipeUntilGoCode ()
{
	local int i;
	local Vector vLocation;
	local Rotator rRotation;

	if ( m_bLeaderIsAPlayer )
	{
		return;
	}
	if ( m_bTeamIsClimbingLadder )
	{
		m_bPendingSnipeUntilGoCode=True;
		return;
	}
	m_bPendingSnipeUntilGoCode=False;
	m_TeamPlanning.GetSnipingCoordinates(vLocation,rRotation);
//	SetTeamState(7);
	R6RainbowAI(m_Team[0].Controller).m_ActionTarget=m_LastActionPoint;
	m_rSnipingDir=rRotation;
	m_Team[0].Controller.GotoState('SnipeUntilGoCode');
	if ( m_bCAWaitingForZuluGoCode )
	{
//		SetTeamState(1);
	}
	else
	{
		i=1;
JL00AC:
		if ( i < m_iMemberCount )
		{
			m_Team[i].Controller.GotoState('FollowLeader');
			i++;
			goto JL00AC;
		}
	}
}

function TeamSnipingOver ()
{
	local int i;

	if ( m_bLeaderIsAPlayer )
	{
		ResetTeamGoCode();
		return;
	}
	RestoreTeamOrder();
	if ( m_bTeamIsHoldingPosition )
	{
		m_Team[0].Controller.GotoState('HoldPosition');
	}
	else
	{
		m_Team[0].Controller.GotoState('Patrol');
	}
	i=1;
JL0060:
	if ( i < m_iMemberCount )
	{
		m_Team[i].Controller.GotoState('FollowLeader');
		i++;
		goto JL0060;
	}
	ActionNodeCompleted();
}

function TeamNotifyActionPoint (ENodeNotify eMsg, EGoCode eCode)
{
	switch (eMsg)
	{
/*		case 0:
		m_ePlanAction=m_TeamPlanning.GetAction();
		m_vPlanActionLocation=m_TeamPlanning.GetActionLocation();
		ResetTeamGoCode();
		if ( m_ePlanAction == 6 )
		{
			m_BreachingDoor=R6IORotatingDoor(m_TeamPlanning.GetDoorToBreach());
			PlaceBreachCharge();
		}
		return;
		case 1:
		m_eMovementMode=m_TeamPlanning.GetMovementMode();
		return;
		case 2:
		m_eMovementSpeed=m_TeamPlanning.GetMovementSpeed();
		return;
		case 3:
		ResetTeamGoCode();
		GetNextActionPoint();
		return;
		case 6:
		SetTeamGoCode(eCode);
		PlayWaitingGoCode(m_eGoCode);
		return;
		case 9:
		SetTeamGoCode(eCode);
		m_ePlanAction=5;
		SnipeUntilGoCode();
		return;
		case 10:
		SetTeamGoCode(eCode);
		m_ePlanAction=6;
		m_BreachingDoor=R6IORotatingDoor(m_TeamPlanning.GetDoorToBreach());
		PlaceBreachCharge();
		return;
		case 4:
		GetNextActionPoint();
		return;
		case 5:
		return;
		default:  */
	}
}

function PlayWaitingGoCode (EGoCode eCode, optional bool bSnipeUntilGoCode)
{
	if ( m_OtherTeamVoicesMgr == None )
	{
		return;
	}
	if (  !m_bLeaderIsAPlayer )
	{
		switch (eCode)
		{
/*			case 0:
			if ( bSnipeUntilGoCode )
			{
				m_OtherTeamVoicesMgr.PlayRainbowOtherTeamVoices(m_TeamLeader,31);
			}
			else
			{
				m_OtherTeamVoicesMgr.PlayRainbowOtherTeamVoices(m_TeamLeader,15);
			}
			break;
			case 1:
			if ( bSnipeUntilGoCode )
			{
				m_OtherTeamVoicesMgr.PlayRainbowOtherTeamVoices(m_TeamLeader,32);
			}
			else
			{
				m_OtherTeamVoicesMgr.PlayRainbowOtherTeamVoices(m_TeamLeader,16);
			}
			break;
			case 2:
			if ( bSnipeUntilGoCode )
			{
				m_OtherTeamVoicesMgr.PlayRainbowOtherTeamVoices(m_TeamLeader,33);
			}
			else
			{
				m_OtherTeamVoicesMgr.PlayRainbowOtherTeamVoices(m_TeamLeader,17);
			}
			break;
			case 3:
			m_OtherTeamVoicesMgr.PlayRainbowOtherTeamVoices(m_TeamLeader,18);
			break;
			default:*/
		}
	}
}

function GetFirstActionPoint ()
{
	m_PlanActionPoint=m_TeamPlanning.GetFirstActionPoint();
	m_LastActionPoint=m_PlanActionPoint;
//	TeamNotifyActionPoint(2,4);
//	TeamNotifyActionPoint(1,4);
}

function GetNextActionPoint ()
{
	m_PlanActionPoint=m_TeamPlanning.GetNextActionPoint();
	if ( m_PlanActionPoint != None )
	{
//		m_eNextAPAction=m_TeamPlanning.NextActionPointHasAction(m_PlanActionPoint);
		if ( m_BreachingDoor == None )
		{
			m_BreachingDoor=R6IORotatingDoor(m_TeamPlanning.GetNextDoorToBreach(m_PlanActionPoint));
		}
	}
	m_LastActionPoint=m_PlanActionPoint;
}

function Actor PreviewNextActionPoint ()
{
	return m_TeamPlanning.PreviewNextActionPoint();
}

function ActionPointReached ()
{
	m_PlanActionPoint=None;
//	m_TeamPlanning.NotifyActionPoint(7,4);
}

function ActionNodeCompleted ()
{
//	m_ePlanAction=0;
	m_bSkipAction=False;
//	m_TeamPlanning.NotifyActionPoint(5,4);
	m_bSniperReady=False;
}

function PlayerHasAbandonedTeam ()
{
	local R6Rainbow tempPawn;
	local int iLastMember;
	local int i;

//	m_TeamPlanning.NotifyActionPoint(8,4);
	if ( m_Team[0].m_bIsPlayer &&  !m_Team[0].IsAlive() )
	{
		m_Team[0].UnPossessed();
		iLastMember=m_iMemberCount - 1;
		tempPawn=m_Team[0];
		i=0;
JL0072:
		if ( i < m_iMemberCount )
		{
			m_Team[i]=m_Team[i + 1];
			m_Team[i].m_iID=i;
			m_Team[i].m_bIsPlayer=False;
			i++;
			goto JL0072;
		}
		m_TeamLeader=m_Team[0];
		m_Team[iLastMember + 1]=tempPawn;
		tempPawn.m_bIsPlayer=False;
		m_Team[iLastMember + 1].m_iID=iLastMember + 1;
		m_TeamLeader.Controller.GotoState('Patrol');
	}
	if ( m_iTeamAction == 0 )
	{
		i=1;
JL0153:
		if ( i < m_iMemberCount )
		{
			m_Team[i].Controller.GotoState('FollowLeader');
			i++;
			goto JL0153;
		}
		TeamIsSeparatedFromLead(False);
	}
}

function R6Rainbow Escort_GetLastRainbow ()
{
	local int i;

	if ( m_iMemberCount > 0 )
	{
		i=m_iMemberCount - 1;
JL0019:
		if ( (i >= 0) && (m_Team[i] != None) )
		{
			if ( m_Team[i].IsAlive() )
			{
				return m_Team[i];
			}
			--i;
			goto JL0019;
		}
	}
	return None;
}

function Escort_UpdateTeamSpeed ()
{
	local int i;
	local int iRainbow;
	local R6Rainbow R;

	m_bWoundedHostage=False;
	iRainbow=0;
JL000F:
	if ( iRainbow < m_iMemberCount )
	{
		R=m_Team[iRainbow];
JL002F:
		if ( (R != None) && (i < 4) && (R.m_aEscortedHostage[i] != None) )
		{
			if ( R.m_aEscortedHostage[i].m_eHealth == 1 )
			{
				m_bWoundedHostage=True;
			}
			else
			{
				++i;
				goto JL002F;
			}
		}
		iRainbow++;
		goto JL000F;
	}
}

function UpdateEscortList ()
{
	local int i;

	if ( m_Team[0] == None )
	{
		return;
	}
	i=0;
JL0016:
	if ( i < m_iMemberCount )
	{
		m_Team[i].Escort_UpdateList();
		i++;
		goto JL0016;
	}
}

function SetTeamColor (int iTeamNum)
{
	if ( (iTeamNum < 0) || (iTeamNum > 2) )
	{
		iTeamNum=0;
	}
	m_TeamColour=Colors.TeamHUDColor[iTeamNum];
}

simulated function Color GetTeamColor ()
{
	if ( Level.NetMode == NM_Standalone )
	{
		SetTeamColor(m_iRainbowTeamName);
	}
	return m_TeamColour;
}

function SetMemberTeamID (int iTeamId)
{
	local int i;

	i=0;
JL0007:
	if ( i < m_iMemberCount )
	{
		m_Team[i].m_iTeam=iTeamId;
		if ( m_Team[i].PlayerReplicationInfo != None )
		{
			m_Team[i].PlayerReplicationInfo.TeamID=iTeamId;
		}
		R6AbstractGameInfo(Level.Game).SetPawnTeamFriendlies(m_Team[i]);
		i++;
		goto JL0007;
	}
}

simulated function ResetTeam ()
{
	local int i;

	i=0;
JL0007:
	if ( i < 4 )
	{
		m_Team[i]=None;
		i++;
		goto JL0007;
	}
	m_TeamLeader=None;
}

simulated function FirstPassReset ()
{
	ResetTeam();
}

function Escort_ManageList ()
{
	local int i;
	local int iHostage;
	local R6Rainbow lastRainbow;
	local R6Hostage hostage;

	if ( m_bTeamIsSeparatedFromLeader )
	{
		return;
	}
	lastRainbow=Escort_GetLastRainbow();
	if ( lastRainbow == None )
	{
		return;
	}
	i=0;
JL002B:
	if ( i < m_iMemberCount )
	{
		if ( lastRainbow == m_Team[i] )
		{
			goto JL0114;
		}
		if ( m_Team[i].m_aEscortedHostage[0] != None )
		{
			iHostage=0;
JL0075:
			if ( (iHostage < 4) && (m_Team[i].m_aEscortedHostage[iHostage] != None) )
			{
				hostage=m_Team[i].m_aEscortedHostage[iHostage];
				if ( hostage.m_escortedByRainbow != None )
				{
					hostage.m_escortedByRainbow.Escort_RemoveHostage(hostage,True);
				}
				lastRainbow.Escort_AddHostage(hostage,True);
				iHostage++;
				goto JL0075;
			}
		}
JL0114:
		i++;
		goto JL002B;
	}
}

function R6Rainbow Escort_GetPawnToFollow (R6Rainbow Rainbow, bool bRunningTowardMe)
{
	local R6Rainbow lastRainbow;

	if (  !m_bTeamIsSeparatedFromLeader ||  !Rainbow.IsAlive() )
	{
		lastRainbow=Escort_GetLastRainbow();
		if ( (lastRainbow != None) && lastRainbow.IsAlive() )
		{
			Rainbow=lastRainbow;
		}
	}
	return Rainbow;
}

event Timer ()
{
	m_bFirstTimeInGas=False;
}

defaultproperties
{
    m_eFormation=1
    m_eMovementSpeed=1
    m_eGoCode=4
    m_eBackupGoCode=4
    m_iFormationDistance=100
    m_iDiagonalDistance=80
    m_iSpawnDistance=81
    m_iSpawnDiagDist=115
    m_iSpawnDiagOther=180
    m_bSniperHold=True
    m_bFirstTimeInGas=True
    RemoteRole=ROLE_SimulatedProxy
    bHidden=True
    m_bDeleteOnReset=True
    NetUpdateFrequency=4.00
}
