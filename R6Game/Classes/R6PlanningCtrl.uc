//================================================================================
// R6PlanningCtrl.
//================================================================================
class R6PlanningCtrl extends PlayerController
	Native
//	NoNativeReplication
	Config(User);

const R6InputKey_PathFlagPopup= 1026;
const R6InputKey_ActionPopup= 1024;
var int m_iCurrentTeam;
var int m_3DWindowPositionX;
var int m_3DWindowPositionY;
var int m_3DWindowPositionW;
var int m_3DWindowPositionH;
var int m_iLevelDisplay;
var bool m_bRender3DView;
var bool m_bMove3DView;
var bool m_bActionPointSelected;
var bool m_bCanMoveFirstPoint;
var bool m_bClickToFindLocation;
var bool m_bClickedOnRange;
var bool m_bSetSnipeDirection;
var bool m_bPlayMode;
var bool m_bLockCamera;
var(Debug) bool bShowLog;
var bool m_bFirstTick;
var float m_fLastMouseX;
var float m_fLastMouseY;
var float m_fZoom;
var float m_fZoomDelta;
var float m_fZoomRate;
var float m_fZoomMin;
var float m_fZoomMax;
var float m_fZoomFactor;
var float m_fCameraAngle;
var float m_fAngleRate;
var float m_fAngleMax;
var float m_fRotateDelta;
var float m_fRotateRate;
var float m_fCamRate;
var(R6Planning) const float m_fCastingHeight;
var float m_fDebugRangeScale;
var R6PlanningInfo m_pTeamInfo[3];
var R6FileManagerPlanning m_pFileManager;
var R6CameraDirection m_pCameraDirIcon;
var Actor m_pOldHitActor;
var Texture m_pIconTex[12];
var Actor m_CamSpot;
var Sound m_PlanningBadClickSnd;
var Sound m_PlanningGoodClickSnd;
var Sound m_PlanningRemoveSnd;
var Vector m_vCurrentCameraPos;
var Vector m_vCamPos;
var Vector m_vCamPosNoRot;
var Vector m_vCamDesiredPos;
var Rotator m_rCamRot;
var Vector m_vCamDelta;
var Vector m_vMinLocation;
var Vector m_vMaxLocation;

native(2013) final function bool GetClickResult (float X, float Y, out Vector HitLocation, out Actor HitActor, out int iChangeLevelTo);

native(2016) final function Vector GetXYPoint (float X, float Y, float Height);

native(2017) final function bool PlanningTrace (Vector vTraceEnd, Vector vTraceStart);

function PostBeginPlay ()
{
	local ZoneInfo PZone;
	local int iCurrentPlanning;
	local int iCurrentInsertionNumber;
	local R6InsertionZone anInsertionZone;
	local R6IORotatingDoor aDoor;
	local R6IOSlidingWindow aWindow;
	local R6ReferenceIcons pSpawnedIcon;
	local R6ReferenceIcons RefIco;
	local R6AbstractInsertionZone NavPoint;
	local R6AbstractExtractionZone ExtZone;

	SetFOVAngle(m_fZoom * 90);
	if ( m_pCameraDirIcon == None )
	{
		m_pCameraDirIcon=Spawn(Class'R6CameraDirection',self);
	}
	if ( m_pFileManager == None )
	{
		m_pFileManager=new Class'R6FileManagerPlanning';
	}
	iCurrentInsertionNumber=2147483647;
	foreach AllActors(Class'R6InsertionZone',anInsertionZone)
	{
		if ( anInsertionZone.IsAvailableInGameType(R6AbstractGameInfo(Level.Game).m_eGameTypeFlag) )
		{
			if ( anInsertionZone.m_iInsertionNumber < iCurrentInsertionNumber )
			{
				iCurrentInsertionNumber=anInsertionZone.m_iInsertionNumber;
				SetFloorToDraw(anInsertionZone.m_iPlanningFloor_0);
				m_iLevelDisplay=anInsertionZone.m_iPlanningFloor_0;
				m_vCamPosNoRot=anInsertionZone.Location;
				m_vCamDesiredPos=anInsertionZone.Location;
			}
		}
		else
		{
		}
	}
	foreach AllActors(Class'R6IORotatingDoor',aDoor)
	{
//		aDoor.m_eDisplayFlag=1;
		if ( aDoor.m_bTreatDoorAsWindow == False )
		{
			if ( aDoor.m_bIsDoorLocked == True )
			{
				pSpawnedIcon=Spawn(Class'R6DoorLockedIcon',,,aDoor.m_vCenterOfDoor);
			}
			else
			{
				pSpawnedIcon=Spawn(Class'R6DoorIcon',,,aDoor.m_vCenterOfDoor);
			}
			pSpawnedIcon.m_u8SpritePlanningAngle=aDoor.Rotation.Yaw / 255;
			pSpawnedIcon.m_iPlanningFloor_0=aDoor.m_iPlanningFloor_0;
			pSpawnedIcon.m_iPlanningFloor_1=aDoor.m_iPlanningFloor_1;
			if ( aDoor.m_bIsOpeningClockWise == False )
			{
				pSpawnedIcon.SetDrawScale3D(vect(1.00,-1.00,1.00));
			}
		}
	}
	foreach AllActors(Class'R6ReferenceIcons',RefIco)
	{
		RefIco.bHidden=False;
	}
	foreach AllActors(Class'R6AbstractInsertionZone',NavPoint)
	{
		if ( NavPoint.IsAvailableInGameType(R6AbstractGameInfo(Level.Game).m_eGameTypeFlag) )
		{
			NavPoint.bHidden=False;
		}
	}
	foreach AllActors(Class'R6AbstractExtractionZone',ExtZone)
	{
		if ( ExtZone.IsAvailableInGameType(R6AbstractGameInfo(Level.Game).m_eGameTypeFlag) )
		{
			ExtZone.bHidden=False;
		}
	}
	m_CamSpot=Level.GetCamSpot(Level.Game.m_eGameTypeFlag);
	Level.m_bAllow3DRendering=False;
}

function Set3DViewPosition (int NewX, int NewY, int NewH, int NewW)
{
	m_3DWindowPositionX=NewX;
	m_3DWindowPositionY=NewY;
	m_3DWindowPositionW=NewW;
	m_3DWindowPositionH=NewH;
}

function SetPlanningInfo ()
{
	m_pTeamInfo[0]=R6PlanningInfo(Player.Console.Master.m_StartGameInfo.m_TeamInfo[0].m_pPlanning);
	m_pTeamInfo[1]=R6PlanningInfo(Player.Console.Master.m_StartGameInfo.m_TeamInfo[1].m_pPlanning);
	m_pTeamInfo[2]=R6PlanningInfo(Player.Console.Master.m_StartGameInfo.m_TeamInfo[2].m_pPlanning);
	m_pTeamInfo[0].m_pTeamManager=self;
	m_pTeamInfo[1].m_pTeamManager=self;
	m_pTeamInfo[2].m_pTeamManager=self;
	m_pTeamInfo[0].m_iStartingPointNumber=Player.Console.Master.m_StartGameInfo.m_TeamInfo[0].m_iSpawningPointNumber;
	m_pTeamInfo[1].m_iStartingPointNumber=Player.Console.Master.m_StartGameInfo.m_TeamInfo[1].m_iSpawningPointNumber;
	m_pTeamInfo[2].m_iStartingPointNumber=Player.Console.Master.m_StartGameInfo.m_TeamInfo[2].m_iSpawningPointNumber;
	m_pTeamInfo[0].m_TeamColor=WindowConsole(Player.Console).Root.Colors.TeamColorLight[0];
	m_pTeamInfo[1].m_TeamColor=WindowConsole(Player.Console).Root.Colors.TeamColorLight[1];
	m_pTeamInfo[2].m_TeamColor=WindowConsole(Player.Console).Root.Colors.TeamColorLight[2];
}

function InitNewPlanning (int iSelectedTeam)
{
	m_iCurrentTeam=iSelectedTeam;
	m_pTeamInfo[0].InitPlanning(0,self);
	m_pTeamInfo[1].InitPlanning(1,self);
	m_pTeamInfo[2].InitPlanning(2,self);
	if ( m_iCurrentTeam == 0 )
	{
		SwitchToRedTeam(True);
	}
	else
	{
		if ( m_iCurrentTeam == 1 )
		{
			SwitchToGreenTeam(True);
		}
		else
		{
			if ( m_iCurrentTeam == 2 )
			{
				SwitchToGoldTeam(True);
			}
		}
	}
}

event Destroyed ()
{
	m_pTeamInfo[0].RemovePointsRefsToCtrl();
	m_pTeamInfo[0].m_pTeamManager=None;
	m_pTeamInfo[1].RemovePointsRefsToCtrl();
	m_pTeamInfo[1].m_pTeamManager=None;
	m_pTeamInfo[2].RemovePointsRefsToCtrl();
	m_pTeamInfo[2].m_pTeamManager=None;
	Super.Destroyed();
}

event PlayerTick (float fDeltaTime)
{
	local Vector vAxisX;
	local Vector vAxisY;
	local Vector vAxisZ;
	local Vector vHitLocation;
	local float fMovementX;
	local float fMovementY;
	local float fAngle;
	local int iCurrentPlanning;
	local R6ActionPoint pCurrentPoint;

	Super.PlayerTick(fDeltaTime);
	if ( WindowConsole(Player.Console).Root.PlanningShouldDrawPath() )
	{
		m_pTeamInfo[0].Tick(fDeltaTime);
		m_pTeamInfo[1].Tick(fDeltaTime);
		m_pTeamInfo[2].Tick(fDeltaTime);
	}
	if ( m_fZoomDelta != 0.00 )
	{
		m_fZoom += m_fZoomDelta * fDeltaTime;
		m_fZoom=FClamp(m_fZoom,m_fZoomMin,m_fZoomMax);
		m_fZoomFactor=m_fZoom * 12;
		FovAngle=m_fZoom * 90;
	}
	if ( m_fCameraAngle != 0 )
	{
		m_vCamPos.X=FClamp(m_vCamPos.X + m_fCameraAngle * m_fZoomFactor * fDeltaTime,m_fAngleMax + 5000,1.00);
		fAngle=Sin(Acos(m_vCamPos.X / m_fAngleMax));
		m_vCamPos.Z=15000.00 * fAngle;
		fAngle=Atan(m_vCamPos.Z / m_vCamPos.X);
		fAngle /= 3.14 * 0.50;
		m_rCamRot.Pitch=65536 - Abs(fAngle) * 16384;
	}
	if ( m_fRotateDelta != 0.00 )
	{
		m_rCamRot.Yaw += m_fRotateDelta * fDeltaTime;
	}
	GetAxes(m_rCamRot,vAxisX,vAxisY,vAxisZ);
	vAxisY.Z=0.00;
	vAxisY=Normal(vAxisY);
	vAxisZ.Z=0.00;
	vAxisZ=Normal(vAxisZ);
	if ( (m_bPlayMode == True) && (m_bLockCamera == True) )
	{
		m_vCamPosNoRot=R6PlanningPawn(Pawn).m_ArrowInPlanningView.Location;
		m_vCamDesiredPos=m_vCamPosNoRot;
	}
	else
	{
		fMovementX=m_vCamDelta.Y * fDeltaTime * m_fZoomFactor;
		fMovementY=m_vCamDelta.X * fDeltaTime * m_fZoomFactor;
		if ( (m_vCamDesiredPos == m_vCamPosNoRot) || (fMovementX != 0) || (fMovementY != 0) )
		{
			m_vCamPosNoRot.X=FClamp(m_vCamPosNoRot.X + fMovementX * vAxisY.Y + fMovementY * vAxisY.X,Level.R6PlanningMinVector.X,Level.R6PlanningMaxVector.X);
			m_vCamPosNoRot.Y=FClamp(m_vCamPosNoRot.Y + fMovementX * vAxisZ.Y + fMovementY * vAxisZ.X,Level.R6PlanningMinVector.Y,Level.R6PlanningMaxVector.Y);
			m_vCamDesiredPos=m_vCamPosNoRot;
		}
		else
		{
			m_vCamPosNoRot.X=FClamp(m_vCamPosNoRot.X + (m_vCamDesiredPos.X - m_vCamPosNoRot.X) * fDeltaTime,Level.R6PlanningMinVector.X,Level.R6PlanningMaxVector.X);
			m_vCamPosNoRot.Y=FClamp(m_vCamPosNoRot.Y + (m_vCamDesiredPos.Y - m_vCamPosNoRot.Y) * fDeltaTime,Level.R6PlanningMinVector.Y,Level.R6PlanningMaxVector.Y);
			if ( VSize(m_vCamDesiredPos - m_vCamPosNoRot) < 20 )
			{
				m_vCamDesiredPos=m_vCamPosNoRot;
			}
		}
	}
	if ( m_bSetSnipeDirection == True )
	{
		vHitLocation=GetXYPoint(m_fLastMouseX,m_fLastMouseY,GetCurrentPoint().Location.Z);
		m_pTeamInfo[m_iCurrentTeam].AjustSnipeDirection(vHitLocation);
	}
	m_vCurrentCameraPos.X=m_vCamPosNoRot.X + m_vCamPos.X * vAxisY.Y;
	m_vCurrentCameraPos.Y=m_vCamPosNoRot.Y + m_vCamPos.X * vAxisZ.Y;
	m_vCurrentCameraPos.Z=m_vCamPos.Z;
	if ( m_bRender3DView == True )
	{
		if ( m_bPlayMode == True )
		{
			m_pCameraDirIcon.bHidden=True;
			R6PlanningPawn(Pawn).m_ArrowInPlanningView.RenderLevelFromMe(m_3DWindowPositionX,m_3DWindowPositionY,m_3DWindowPositionW,m_3DWindowPositionH);
		}
		else
		{
			pCurrentPoint=GetCurrentPoint();
			if ( pCurrentPoint != None )
			{
				pCurrentPoint.RenderLevelFromMe(m_3DWindowPositionX,m_3DWindowPositionY,m_3DWindowPositionW,m_3DWindowPositionH);
				m_pCameraDirIcon.bHidden=False;
				m_pCameraDirIcon.SetLocation(pCurrentPoint.Location);
				m_pCameraDirIcon.SetPlanningRotation(pCurrentPoint.Rotation);
				m_pCameraDirIcon.m_iPlanningFloor_0=pCurrentPoint.m_iPlanningFloor_0;
				m_pCameraDirIcon.m_iPlanningFloor_1=pCurrentPoint.m_iPlanningFloor_1;
			}
			else
			{
				m_pCameraDirIcon.bHidden=True;
				if ( m_CamSpot != None )
				{
					m_CamSpot.RenderLevelFromMe(m_3DWindowPositionX,m_3DWindowPositionY,m_3DWindowPositionW,m_3DWindowPositionH);
					return;
				}
				RenderLevelFromMe(m_3DWindowPositionX,m_3DWindowPositionY,m_3DWindowPositionW,m_3DWindowPositionH);
			}
		}
	}
}

state PlayerWalking
{
	function ProcessMove (float DeltaTime, Vector NewAccel, EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
	{
		if ( (Pawn == None) || (WindowConsole(Player.Console).Root.PlanningShouldProcessKey() == False) )
		{
			return;
		}
		if ( m_bRotateCW == m_bRotateCCW )
		{
			m_fRotateDelta=0.00;
		}
		else
		{
			if ( m_bRotateCW == 1 )
			{
				m_fRotateDelta=m_fRotateRate;
			}
			else
			{
				if ( m_bRotateCCW == 1 )
				{
					m_fRotateDelta= -m_fRotateRate;
				}
			}
		}
		if ( m_bMoveLeft == m_bMoveRight )
		{
			m_vCamDelta.X=0.00;
		}
		else
		{
			if ( m_bMoveRight == 1 )
			{
				m_vCamDelta.X=m_fCamRate;
			}
			else
			{
				if ( m_bMoveLeft == 1 )
				{
					m_vCamDelta.X= -m_fCamRate;
				}
			}
		}
		if ( m_bMoveUp == m_bMoveDown )
		{
			m_vCamDelta.Y=0.00;
		}
		else
		{
			if ( m_bMoveUp == 1 )
			{
				m_vCamDelta.Y=m_fCamRate;
			}
			else
			{
				if ( m_bMoveDown == 1 )
				{
					m_vCamDelta.Y= -m_fCamRate;
				}
			}
		}
		if ( m_bAngleUp == m_bAngleDown )
		{
			m_fCameraAngle=0.00;
		}
		else
		{
			if ( m_bAngleUp == 1 )
			{
				m_fCameraAngle=m_fAngleRate;
			}
			else
			{
				if ( m_bAngleDown == 1 )
				{
					m_fCameraAngle= -m_fAngleRate;
				}
			}
		}
		if ( m_bZoomIn == m_bZoomOut )
		{
			m_fZoomDelta=0.00;
		}
		else
		{
			if ( m_bZoomIn == 1 )
			{
				m_fZoomDelta= -m_fZoomRate;
			}
			else
			{
				if ( m_bZoomOut == 1 )
				{
					m_fZoomDelta=m_fZoomRate;
				}
			}
		}
		if ( m_bLevelUp == 1 )
		{
			if ( m_bGoLevelUp == 1 )
			{
				m_bGoLevelUp=0;
				if (  !(m_bPlayMode == True) && (m_bLockCamera == True) )
				{
					ChangeLevelDisplay(1);
					m_vCamDesiredPos=m_vCamPosNoRot;
				}
			}
		}
		if ( m_bLevelDown == 1 )
		{
			if ( m_bGoLevelDown == 1 )
			{
				m_bGoLevelDown=0;
				if (  !(m_bPlayMode == True) && (m_bLockCamera == True) )
				{
					ChangeLevelDisplay(-1);
					m_vCamDesiredPos=m_vCamPosNoRot;
				}
			}
		}
	}

}

exec function DeleteWaypoint ()
{
	if ( (m_bPlayMode == False) && WindowConsole(Player.Console).Root.PlanningShouldProcessKey() )
	{
		DeleteOneNode();
	}
}

exec function PrevWaypoint ()
{
	if ( (m_bPlayMode == False) && WindowConsole(Player.Console).Root.PlanningShouldProcessKey() )
	{
		GotoPrevNode();
	}
}

exec function NextWaypoint ()
{
	if ( (m_bPlayMode == False) && WindowConsole(Player.Console).Root.PlanningShouldProcessKey() )
	{
		GoToNextNode();
	}
}

exec function FirstWaypoint ()
{
	if ( (m_bPlayMode == False) && WindowConsole(Player.Console).Root.PlanningShouldProcessKey() )
	{
		GotoFirstNode();
	}
}

exec function LastWaypoint ()
{
	if ( (m_bPlayMode == False) && WindowConsole(Player.Console).Root.PlanningShouldProcessKey() )
	{
		GotoLastNode();
	}
}

exec function SwitchToRedTeam (optional bool bForceFunction)
{
	if ( (bForceFunction == True) || (m_bPlayMode == False) && WindowConsole(Player.Console).Root.PlanningShouldProcessKey() && (m_bSetSnipeDirection == False) && (m_bClickToFindLocation == False) )
	{
		m_iCurrentTeam=0;
		m_pTeamInfo[0].SelectTeam(True);
		m_pTeamInfo[1].SelectTeam(False);
		m_pTeamInfo[2].SelectTeam(False);
		m_pTeamInfo[0].SetPathDisplay(True);
		MoveCamOver();
		WindowConsole(Player.Console).Root.UpdateMenus(0);
	}
}

exec function SwitchToGreenTeam (optional bool bForceFunction)
{
	if ( (bForceFunction == True) || (m_bPlayMode == False) && WindowConsole(Player.Console).Root.PlanningShouldProcessKey() && (m_bSetSnipeDirection == False) && (m_bClickToFindLocation == False) )
	{
		m_iCurrentTeam=1;
		m_pTeamInfo[0].SelectTeam(False);
		m_pTeamInfo[1].SelectTeam(True);
		m_pTeamInfo[2].SelectTeam(False);
		m_pTeamInfo[1].SetPathDisplay(True);
		MoveCamOver();
		WindowConsole(Player.Console).Root.UpdateMenus(1);
	}
}

exec function SwitchToGoldTeam (optional bool bForceFunction)
{
	if ( (bForceFunction == True) || (m_bPlayMode == False) && WindowConsole(Player.Console).Root.PlanningShouldProcessKey() && (m_bSetSnipeDirection == False) && (m_bClickToFindLocation == False) )
	{
		m_iCurrentTeam=2;
		m_pTeamInfo[0].SelectTeam(False);
		m_pTeamInfo[1].SelectTeam(False);
		m_pTeamInfo[2].SelectTeam(True);
		m_pTeamInfo[2].SetPathDisplay(True);
		MoveCamOver();
		WindowConsole(Player.Console).Root.UpdateMenus(2);
	}
}

exec function ViewRedTeam ()
{
	if ( WindowConsole(Player.Console).Root.PlanningShouldProcessKey() && (m_iCurrentTeam != 0) )
	{
		m_pTeamInfo[0].SetPathDisplay( !m_pTeamInfo[0].m_bDisplayPath);
		WindowConsole(Player.Console).Root.UpdateMenus(3);
	}
}

exec function ViewGreenTeam ()
{
	if ( WindowConsole(Player.Console).Root.PlanningShouldProcessKey() && (m_iCurrentTeam != 1) )
	{
		m_pTeamInfo[1].SetPathDisplay( !m_pTeamInfo[1].m_bDisplayPath);
		WindowConsole(Player.Console).Root.UpdateMenus(4);
	}
}

exec function ViewGoldTeam ()
{
	if ( WindowConsole(Player.Console).Root.PlanningShouldProcessKey() && (m_iCurrentTeam != 2) )
	{
		m_pTeamInfo[2].SetPathDisplay( !m_pTeamInfo[2].m_bDisplayPath);
		WindowConsole(Player.Console).Root.UpdateMenus(5);
	}
}

event PlayerCalcView (out Actor aViewActor, out Vector vCameraLocation, out Rotator rCameraRotation)
{
	rCameraRotation=m_rCamRot;
	vCameraLocation=m_vCurrentCameraPos;
}

function FixFOV ()
{
}

function AdjustView (float DeltaTime)
{
}

function Toggle3DView ()
{
	m_pCameraDirIcon.bHidden=m_bRender3DView;
	m_bRender3DView= !m_bRender3DView;
}

function TurnOff3DView ()
{
	m_bRender3DView=False;
	m_pCameraDirIcon.bHidden=True;
}

function TurnOn3DMove (float X, float Y)
{
	m_bMove3DView= !m_bMove3DView;
	if ( m_bMove3DView && (GetCurrentPoint() != None) )
	{
		GetCurrentPoint().Init3DView(X,Y);
	}
}

function TurnOff3DMove ()
{
	m_bMove3DView=False;
}

function Ajust3DRotation (float X, float Y)
{
	if ( GetCurrentPoint() != None )
	{
		GetCurrentPoint().RotateView(X,Y);
	}
}

function ChangeLevelDisplay (int iStep)
{
	if ( iStep > 0 )
	{
		if ( m_iLevelDisplay < Level.R6PlanningMaxLevel )
		{
			m_iLevelDisplay += iStep;
//			SetFloorToDraw(m_iLevelDisplay);
		}
	}
	else
	{
		if ( m_iLevelDisplay > Level.R6PlanningMinLevel )
		{
			m_iLevelDisplay += iStep;
//			SetFloorToDraw(m_iLevelDisplay);
		}
	}
}

function LMouseDown (float X, float Y)
{
	local Actor pHitActor;
	local Vector vHitLocation;
	local Vector vHitNormal;
	local Vector vSpawnOffset;
	local R6ActionPoint FirstActionPoint;
	local int iChangeLevelTo;
	local R6Ladder aHitActorLadder;
	local R6ActionPoint pCurrentPoint;

	if ( m_bPlayMode == True )
	{
		return;
	}
	if ( m_bSetSnipeDirection == True )
	{
		m_bSetSnipeDirection=False;
		WindowConsole(Player.Console).Root.m_bUseAimIcon=False;
		return;
	}
	pCurrentPoint=GetCurrentPoint();
	if ( GetClickResult(X,Y,vHitLocation,pHitActor,iChangeLevelTo) == True )
	{
		if ( m_bClickToFindLocation == True )
		{
			if ( m_bClickedOnRange == False )
			{
				if ( (pHitActor != None) && pHitActor.IsA('R6PlanningRangeGrenade') )
				{
					m_bClickedOnRange=True;
					pHitActor.bHidden=True;
					LMouseDown(X,Y);
					pHitActor.bHidden=False;
				}
				else
				{
					if ( (pHitActor != None) && pHitActor.IsA('R6CameraDirection') )
					{
						pHitActor.bHidden=True;
						LMouseDown(X,Y);
						pHitActor.bHidden=False;
					}
					else
					{
						PlaySound(m_PlanningBadClickSnd,SLOT_Menu);
					}
				}
			}
			else
			{
				if ( (pHitActor != None) &&  !pHitActor.IsA('StaticMeshActor') && (pHitActor.m_bIsWalkable == True) &&  !pHitActor.IsA('TerrainInfo') )
				{
					pHitActor.bHidden=True;
					LMouseDown(X,Y);
					pHitActor.bHidden=False;
				}
				else
				{
					if ( m_pTeamInfo[m_iCurrentTeam].SetGrenadeLocation(vHitLocation) )
					{
						pCurrentPoint.bHidden=False;
						m_bClickToFindLocation=False;
						WindowConsole(Player.Console).Root.m_bUseAimIcon=False;
						PlaySound(m_PlanningGoodClickSnd,SLOT_Menu);
					}
					else
					{
						PlaySound(m_PlanningBadClickSnd,SLOT_Menu);
					}
				}
			}
			return;
		}
		if ( pHitActor != None )
		{
			if ( pHitActor.IsA('R6ActionPoint') )
			{
				if ( R6ActionPoint(pHitActor).m_iRainbowTeamName == m_iCurrentTeam )
				{
					m_pTeamInfo[m_iCurrentTeam].SetAsCurrentNode(R6ActionPoint(pHitActor));
					m_bCanMoveFirstPoint=False;
					m_bActionPointSelected=True;
				}
			}
			else
			{
				if ( pHitActor.IsA('R6PathFlag') )
				{
					return;
				}
				else
				{
					if ( pHitActor.IsA('R6PlanningBreach') || pHitActor.IsA('R6PlanningGrenade') )
					{
						m_pTeamInfo[m_iCurrentTeam].SetAsCurrentNode(R6ActionPoint(pHitActor.Owner));
						return;
					}
					else
					{
						if ( pHitActor.IsA('StaticMeshActor') )
						{
							if ( pHitActor.m_bIsWalkable == True )
							{
								CastActionPointAt(vHitLocation,m_iLevelDisplay,iChangeLevelTo,X,Y);
							}
							else
							{
								PlaySound(m_PlanningBadClickSnd,SLOT_Menu);
							}
						}
						else
						{
							if ( pHitActor.IsA('R6Ladder') )
							{
								aHitActorLadder=R6Ladder(pHitActor);
								if ( aHitActorLadder.m_iPlanningFloor_0 == aHitActorLadder.m_pOtherFloor.m_iPlanningFloor_0 )
								{
									pHitActor.bHidden=True;
									LMouseDown(X,Y);
									pHitActor.bHidden=False;
								}
								else
								{
									if (  !(m_bPlayMode == True) && (m_bLockCamera == True) )
									{
										ChangeLevelDisplay(aHitActorLadder.m_pOtherFloor.m_iPlanningFloor_0 - aHitActorLadder.m_iPlanningFloor_0);
										m_vCamDesiredPos=m_vCamPosNoRot;
									}
									if ( aHitActorLadder.m_bIsTopOfLadder == True )
									{
										vSpawnOffset=vector(aHitActorLadder.m_pOtherFloor.Rotation) * -100.00;
										vHitLocation=aHitActorLadder.m_pOtherFloor.Location + vSpawnOffset;
									}
									else
									{
										vSpawnOffset=vector(aHitActorLadder.m_pOtherFloor.Rotation) * 100.00;
										Trace(vHitLocation,vHitNormal,aHitActorLadder.m_pOtherFloor.Location + vSpawnOffset + vect(0.00,0.00,-100.00),aHitActorLadder.m_pOtherFloor.Location + vSpawnOffset,True,vect(0.00,0.00,0.00));
									}
									CastActionPointAt(vHitLocation,aHitActorLadder.m_pOtherFloor.m_iPlanningFloor_0,aHitActorLadder.m_pOtherFloor.m_iPlanningFloor_0,X,Y);
								}
							}
							else
							{
								if ( pHitActor.IsA('R6InsertionZone') )
								{
									if ( m_pTeamInfo[m_iCurrentTeam].m_iCurrentNode == -1 )
									{
										m_pTeamInfo[m_iCurrentTeam].m_bPlacedFirstPoint=True;
									}
									pHitActor.bHidden=True;
									LMouseDown(X,Y);
									pHitActor.bHidden=False;
									if ( m_pTeamInfo[m_iCurrentTeam].m_iCurrentNode == -1 )
									{
										pCurrentPoint=R6ActionPoint(m_pTeamInfo[m_iCurrentTeam].m_NodeList[0]);
										m_pTeamInfo[m_iCurrentTeam].m_iStartingPointNumber=R6InsertionZone(pHitActor).m_iInsertionNumber;
										m_pTeamInfo[m_iCurrentTeam].SetAsCurrentNode(pCurrentPoint);
										pCurrentPoint.SetRotation(pHitActor.Rotation);
										pCurrentPoint.m_u8SpritePlanningAngle=pCurrentPoint.Rotation.Yaw / 255;
									}
								}
								else
								{
									if ( pHitActor.IsA('TerrainInfo') )
									{
										CastActionPointAt(vHitLocation,iChangeLevelTo,iChangeLevelTo,X,Y);
									}
								}
							}
						}
					}
				}
			}
		}
		else
		{
			CastActionPointAt(vHitLocation,m_iLevelDisplay,iChangeLevelTo,X,Y);
		}
	}
	else
	{
		PlaySound(m_PlanningBadClickSnd,SLOT_Menu);
	}
}

function RMouseUp (float X, float Y)
{
}

function LMouseUp (float X, float Y)
{
	local Actor pHitActor;
	local Vector vHitLocation;
	local int iChangeLevelTo;

	if ( (m_bActionPointSelected == True) && (WindowConsole(Player.Console).Root.m_bUseDragIcon == True) )
	{
		m_pTeamInfo[m_iCurrentTeam].GetPoint().bHidden=True;
		if ( GetClickResult(X,Y,vHitLocation,pHitActor,iChangeLevelTo) == True )
		{
			if ( pHitActor != None )
			{
				if (  !pHitActor.IsA('R6ActionPoint') || pHitActor.IsA('R6PathFlag') || pHitActor.IsA('R6PlanningBreach') || pHitActor.IsA('R6PlanningGrenade') || pHitActor.IsA('R6Ladder') )
				{
					if ( pHitActor.IsA('StaticMeshActor') )
					{
						if ( pHitActor.m_bIsWalkable == True )
						{
							MoveActionPointTo(vHitLocation,m_iLevelDisplay,iChangeLevelTo);
						}
					}
					else
					{
						if ( pHitActor.IsA('TerrainInfo') )
						{
							if ( pHitActor.m_bIsWalkable == True )
							{
								MoveActionPointTo(vHitLocation,iChangeLevelTo,iChangeLevelTo);
							}
						}
						else
						{
							if ( pHitActor.IsA('R6InsertionZone') )
							{
								m_bCanMoveFirstPoint=True;
							}
							pHitActor.bHidden=True;
							LMouseUp(X,Y);
							pHitActor.bHidden=False;
						}
					}
				}
			}
			else
			{
				MoveActionPointTo(vHitLocation,m_iLevelDisplay,iChangeLevelTo);
			}
		}
		else
		{
			PlaySound(m_PlanningBadClickSnd,SLOT_Menu);
		}
		m_pTeamInfo[m_iCurrentTeam].GetPoint().bHidden=False;
	}
	WindowConsole(Player.Console).Root.m_bUseDragIcon=False;
	m_bActionPointSelected=False;
}

function RMouseDown (float X, float Y)
{
	local Actor pHitActor;
	local Actor pHitActorBackup;
	local Vector vHitLocation;
	local Vector vHitNormal;
	local Vector vSpawnOffset;
	local R6ActionPoint FirstActionPoint;
	local int iChangeLevelTo;
	local R6Ladder aHitActorLadder;
	local R6ActionPoint pCurrentPoint;

	if ( m_bPlayMode == True )
	{
		return;
	}
	if ( (m_bSetSnipeDirection == True) || (m_bClickToFindLocation == True) )
	{
		CancelActionPointAction();
		return;
	}
	pCurrentPoint=GetCurrentPoint();
	if ( GetClickResult(X,Y,vHitLocation,pHitActor,iChangeLevelTo) == True )
	{
		if ( pHitActor != None )
		{
			if ( pHitActor.IsA('R6ActionPoint') )
			{
				if ( R6ActionPoint(pHitActor).m_iRainbowTeamName == m_iCurrentTeam )
				{
					m_pTeamInfo[m_iCurrentTeam].SetAsCurrentNode(R6ActionPoint(pHitActor));
					WindowConsole(Player.Console).Root.KeyType(1024,X,Y);
				}
			}
			else
			{
				if ( pHitActor.IsA('R6PathFlag') )
				{
					if ( R6ActionPoint(pHitActor.Owner).m_iRainbowTeamName == m_iCurrentTeam )
					{
						m_pTeamInfo[m_iCurrentTeam].SetAsCurrentNode(R6ActionPoint(pHitActor.Owner));
						WindowConsole(Player.Console).Root.KeyType(1026,X,Y);
					}
				}
				else
				{
					if ( pHitActor.IsA('R6PlanningBreach') || pHitActor.IsA('R6PlanningGrenade') )
					{
						m_pTeamInfo[m_iCurrentTeam].SetAsCurrentNode(R6ActionPoint(pHitActor.Owner));
						return;
					}
					else
					{
						if ( pHitActor.IsA('StaticMeshActor') )
						{
							if ( pHitActor.m_bIsWalkable == True )
							{
								if ( CastActionPointAt(vHitLocation,m_iLevelDisplay,iChangeLevelTo,X,Y) )
								{
									WindowConsole(Player.Console).Root.KeyType(1024,X,Y);
								}
							}
							else
							{
								PlaySound(m_PlanningBadClickSnd,SLOT_Menu);
							}
						}
						else
						{
							if ( pHitActor.IsA('R6Ladder') )
							{
								aHitActorLadder=R6Ladder(pHitActor);
								if ( aHitActorLadder.m_iPlanningFloor_0 == aHitActorLadder.m_pOtherFloor.m_iPlanningFloor_1 )
								{
									pHitActor.bHidden=True;
									RMouseDown(X,Y);
									pHitActor.bHidden=False;
								}
								else
								{
									if (  !(m_bPlayMode == True) && (m_bLockCamera == True) )
									{
										ChangeLevelDisplay(aHitActorLadder.m_pOtherFloor.m_iPlanningFloor_0 - aHitActorLadder.m_iPlanningFloor_0);
										m_vCamDesiredPos=m_vCamPosNoRot;
									}
									if ( aHitActorLadder.m_bIsTopOfLadder == True )
									{
										vSpawnOffset=vector(aHitActorLadder.m_pOtherFloor.Rotation) * -100.00;
										vHitLocation=aHitActorLadder.m_pOtherFloor.Location + vSpawnOffset;
									}
									else
									{
										vSpawnOffset=vector(aHitActorLadder.m_pOtherFloor.Rotation) * 100.00;
										Trace(vHitLocation,vHitNormal,aHitActorLadder.m_pOtherFloor.Location + vSpawnOffset + vect(0.00,0.00,-100.00),aHitActorLadder.m_pOtherFloor.Location + vSpawnOffset,True,vect(0.00,0.00,0.00));
									}
									if ( CastActionPointAt(vHitLocation,aHitActorLadder.m_pOtherFloor.m_iPlanningFloor_0,aHitActorLadder.m_pOtherFloor.m_iPlanningFloor_0,X,Y) )
									{
										WindowConsole(Player.Console).Root.KeyType(1024,X,Y);
									}
								}
							}
							else
							{
								if ( pHitActor.IsA('R6InsertionZone') )
								{
									if ( m_pTeamInfo[m_iCurrentTeam].m_iCurrentNode == -1 )
									{
										m_pTeamInfo[m_iCurrentTeam].m_bPlacedFirstPoint=True;
									}
									pHitActor.bHidden=True;
									LMouseDown(X,Y);
									pHitActor.bHidden=False;
									if ( m_pTeamInfo[m_iCurrentTeam].m_iCurrentNode == -1 )
									{
										pCurrentPoint=R6ActionPoint(m_pTeamInfo[m_iCurrentTeam].m_NodeList[0]);
										m_pTeamInfo[m_iCurrentTeam].m_iStartingPointNumber=R6InsertionZone(pHitActor).m_iInsertionNumber;
										m_pTeamInfo[m_iCurrentTeam].SetAsCurrentNode(R6ActionPoint(m_pTeamInfo[m_iCurrentTeam].m_NodeList[0]));
										pCurrentPoint.SetRotation(pHitActor.Rotation);
										pCurrentPoint.m_u8SpritePlanningAngle=pCurrentPoint.Rotation.Yaw / 255;
									}
									WindowConsole(Player.Console).Root.KeyType(1024,X,Y);
								}
								else
								{
									if ( pHitActor.IsA('TerrainInfo') )
									{
										if ( CastActionPointAt(vHitLocation,iChangeLevelTo,iChangeLevelTo,X,Y) )
										{
											WindowConsole(Player.Console).Root.KeyType(1024,X,Y);
										}
									}
								}
							}
						}
					}
				}
			}
		}
		else
		{
			if ( CastActionPointAt(vHitLocation,m_iLevelDisplay,iChangeLevelTo,X,Y) )
			{
				WindowConsole(Player.Console).Root.KeyType(1024,X,Y);
			}
		}
	}
	else
	{
		PlaySound(m_PlanningBadClickSnd,SLOT_Menu);
	}
}

function MouseMove (float X, float Y)
{
	local Vector vHitLocation;

	if ( m_bSetSnipeDirection == True )
	{
		m_fLastMouseX=X;
		m_fLastMouseY=Y;
		vHitLocation=GetXYPoint(X,Y,GetCurrentPoint().Location.Z);
		m_pTeamInfo[m_iCurrentTeam].AjustSnipeDirection(vHitLocation);
	}
	if ( m_bActionPointSelected == True )
	{
		WindowConsole(Player.Console).Root.m_bUseDragIcon=True;
	}
	else
	{
		WindowConsole(Player.Console).Root.m_bUseDragIcon=False;
	}
}

function CancelActionPointAction ()
{
	local R6ActionPoint pCurrentPoint;

	if ( (m_bSetSnipeDirection == True) || (m_bClickToFindLocation == True) )
	{
		pCurrentPoint=GetCurrentPoint();
//		pCurrentPoint.m_eAction=0;
		pCurrentPoint.m_pActionIcon.Destroy();
		pCurrentPoint.m_pActionIcon=None;
		pCurrentPoint.bHidden=False;
		m_bClickToFindLocation=False;
		m_bSetSnipeDirection=False;
		WindowConsole(Player.Console).Root.m_bUseAimIcon=False;
		return;
	}
}

function ResetAllID ()
{
	m_pTeamInfo[0].ResetID();
	m_pTeamInfo[1].ResetID();
	m_pTeamInfo[2].ResetID();
}

function ResetIDs ()
{
	m_pTeamInfo[m_iCurrentTeam].ResetID();
}

function Texture GetActionTypeTexture (EPlanActionType EActionType, optional int iMilestone)
{
	switch (EActionType)
	{
/*		case 2:
		return m_pIconTex[0];
		break;
		case 3:
		return m_pIconTex[1];
		break;
		case 4:
		return m_pIconTex[2];
		break;
		case 1:
		return m_pIconTex[2 + iMilestone];
		break;
		default:*/
	}
	return None;
}

function MoveActionPointTo (Vector vHitLocation, int iFirstFloor, int iSecondFloor)
{
	local R6ActionPoint pCurrentActionPoint;
	local Vector vBackupLocation;

	if ( (m_pTeamInfo[m_iCurrentTeam].m_iCurrentNode == 0) && (m_bCanMoveFirstPoint == False) )
	{
//		PlaySound(m_PlanningBadClickSnd,9);
		return;
	}
	vHitLocation.Z += m_fCastingHeight;
	pCurrentActionPoint=GetCurrentPoint();
	vBackupLocation=pCurrentActionPoint.Location;
	pCurrentActionPoint.SetLocation(vHitLocation);
	if ( m_pTeamInfo[m_iCurrentTeam].MoveCurrentPoint() == True )
	{
//		pCurrentActionPoint.m_eAction=0;
		if ( pCurrentActionPoint.m_pActionIcon != None )
		{
			pCurrentActionPoint.m_pActionIcon.Destroy();
			pCurrentActionPoint.m_pActionIcon=None;
		}
		m_pTeamInfo[m_iCurrentTeam].SetPointRotation();
		if ( iFirstFloor < iSecondFloor )
		{
			pCurrentActionPoint.m_iPlanningFloor_0=iFirstFloor;
			pCurrentActionPoint.m_iPlanningFloor_1=iSecondFloor;
		}
		else
		{
			pCurrentActionPoint.m_iPlanningFloor_0=iSecondFloor;
			pCurrentActionPoint.m_iPlanningFloor_1=iFirstFloor;
		}
		pCurrentActionPoint.FindDoor();
//		PlaySound(m_PlanningGoodClickSnd,9);
	}
	else
	{
//		PlaySound(m_PlanningBadClickSnd,9);
		pCurrentActionPoint.SetLocation(vBackupLocation);
		m_pTeamInfo[m_iCurrentTeam].MoveCurrentPoint();
	}
}

function bool CastActionPointAt (Vector vLocation, int iFirstFloor, int iSecondFloor, int X, int Y)
{
	local bool bResult;
	local bool bReturnValue;
	local R6ActionPoint pNewActionPoint;
	local R6PlanningInfo pTeamInfo;
	local R6InsertionZone pInsertionZone;

	bReturnValue=True;
	pTeamInfo=m_pTeamInfo[m_iCurrentTeam];
	if ( pTeamInfo.m_bPlacedFirstPoint == False )
	{
		Log("-->First ActionPoint must be on an InsertionZone!");
		bReturnValue=False;
	}
	if ( pTeamInfo.m_NodeList.Length > 500 )
	{
		Log("-->too Many points in planning!");
		bReturnValue=False;
	}
	if ( bReturnValue )
	{
		vLocation.Z += m_fCastingHeight;
		bResult=FindSpot(vLocation,vect(42.00,42.00,62.00));
		if ( bResult == True )
		{
			pNewActionPoint=Spawn(Class'R6ActionPoint',,,vLocation);
			if ( pNewActionPoint != None )
			{
				pNewActionPoint.m_pPlanningCtrl=self;
				if ( iFirstFloor <= iSecondFloor )
				{
					pNewActionPoint.m_iPlanningFloor_0=iFirstFloor;
					pNewActionPoint.m_iPlanningFloor_1=iSecondFloor;
				}
				else
				{
					pNewActionPoint.m_iPlanningFloor_0=iSecondFloor;
					pNewActionPoint.m_iPlanningFloor_1=iFirstFloor;
				}
				if ( pTeamInfo.m_iCurrentNode == -1 )
				{
					pNewActionPoint.SetFirstPointTexture();
				}
				pNewActionPoint.FindDoor();
				if ( (pTeamInfo.m_iCurrentNode != -1) && (pTeamInfo.m_iCurrentNode != pTeamInfo.m_NodeList.Length - 1) )
				{
					if ( m_pTeamInfo[m_iCurrentTeam].InsertPoint(pNewActionPoint) == True )
					{
						pNewActionPoint.m_iRainbowTeamName=m_iCurrentTeam;
						if ( (X < 100) || (X > 544) || (Y < 54) || (Y > 326) )
						{
							MoveCamOver();
						}
					}
					else
					{
						Log("Could not Insert point at location");
						bReturnValue=False;
					}
				}
				else
				{
					if ( m_pTeamInfo[m_iCurrentTeam].AddPoint(pNewActionPoint) == True )
					{
						pNewActionPoint.m_iRainbowTeamName=m_iCurrentTeam;
						if ( (X < 100) || (X > 544) || (Y < 54) || (Y > 326) )
						{
							MoveCamOver();
						}
					}
					else
					{
						Log("Could not add point at location");
						bReturnValue=False;
					}
				}
			}
			else
			{
				bReturnValue=False;
				Log("Could not spawn action point");
			}
		}
		else
		{
			bReturnValue=False;
			Log("Could not find place to spawn action point");
		}
	}
	if ( bReturnValue )
	{
//		PlaySound(m_PlanningGoodClickSnd,9);
	}
	else
	{
//		PlaySound(m_PlanningBadClickSnd,9);
	}
	return bReturnValue;
}

function DeleteOneNode ()
{
	CancelActionPointAction();
	if ( m_pTeamInfo[m_iCurrentTeam].DeleteNode() )
	{
//		PlaySound(m_PlanningRemoveSnd,9);
	}
	else
	{
//		PlaySound(m_PlanningBadClickSnd,9);
	}
	if ( GetCurrentPoint() != None )
	{
		m_iLevelDisplay=GetCurrentPoint().m_iPlanningFloor_0;
//		SetFloorToDraw(m_iLevelDisplay);
	}
}

function DeleteAllNode ()
{
	CancelActionPointAction();
	m_pTeamInfo[m_iCurrentTeam].DeleteAllNode();
	PositionCameraOnInsertionZone();
}

function PositionCameraOnInsertionZone ()
{
	local R6InsertionZone anInsertionZone;

	foreach AllActors(Class'R6InsertionZone',anInsertionZone)
	{
		if ( (anInsertionZone.m_iInsertionNumber == 0) && anInsertionZone.IsAvailableInGameType(R6AbstractGameInfo(Level.Game).m_eGameTypeFlag) )
		{
			SetFloorToDraw(anInsertionZone.m_iPlanningFloor_0);
			m_iLevelDisplay=anInsertionZone.m_iPlanningFloor_0;
			m_vCamDesiredPos=anInsertionZone.Location;
			m_vCamDesiredPos.Z=0.00;
		}
		else
		{
		}
	}
}

function DeleteEverySingleNode ()
{
	CancelActionPointAction();
	m_pTeamInfo[0].DeleteAllNode();
	m_pTeamInfo[1].DeleteAllNode();
	m_pTeamInfo[2].DeleteAllNode();
	PositionCameraOnInsertionZone();
}

function GotoFirstNode ()
{
	CancelActionPointAction();
	m_pTeamInfo[m_iCurrentTeam].SetToStartNode();
	MoveCamOver();
}

function GotoLastNode ()
{
	CancelActionPointAction();
	m_pTeamInfo[m_iCurrentTeam].SetToEndNode();
	MoveCamOver();
}

function GoToNextNode ()
{
	CancelActionPointAction();
	m_pTeamInfo[m_iCurrentTeam].SetToNextNode();
	MoveCamOver();
}

function GotoPrevNode ()
{
	CancelActionPointAction();
	m_pTeamInfo[m_iCurrentTeam].SetToPrevNode();
	MoveCamOver();
}

function GotoNode ()
{
	CancelActionPointAction();
	MoveCamOver();
}

function R6ActionPoint GetCurrentPoint ()
{
	return m_pTeamInfo[m_iCurrentTeam].GetPoint();
}

function EPlanActionType GetCurrentActionType ()
{
	return m_pTeamInfo[m_iCurrentTeam].GetActionType();
}

function EMovementMode GetMovementMode ()
{
//	return m_pTeamInfo[m_iCurrentTeam].GetMovementMode();
    return MOVE_Assault;
}

function MoveCamOver ()
{
	if ( GetCurrentPoint() != None )
	{
		m_vCamDesiredPos.X=GetCurrentPoint().Location.X;
		m_vCamDesiredPos.Y=GetCurrentPoint().Location.Y;
		m_iLevelDisplay=GetCurrentPoint().m_iPlanningFloor_0;
//		SetFloorToDraw(m_iLevelDisplay);
	}
}

function StartPlayingPlanning ()
{
	m_bPlayMode=True;
	R6PlanningPawn(Pawn).FollowPlanning(m_pTeamInfo[m_iCurrentTeam]);
}

function StopPlayingPlanning ()
{
	m_bPlayMode=False;
	R6PlanningPawn(Pawn).StopFollowingPlanning();
}

auto state PlayerWaiting
{
	function EndState ()
	{
	}

	function BeginState ()
	{
	}

}

defaultproperties
{
    m_bFirstTick=True
    m_fZoom=0.25
    m_fZoomRate=0.20
    m_fZoomMin=0.05
    m_fZoomMax=0.40
    m_fZoomFactor=2.00
    m_fAngleRate=4000.00
    m_fAngleMax=-25000.00
    m_fRotateRate=6000.00
    m_fCamRate=1000.00
    m_fCastingHeight=100.00
    m_fDebugRangeScale=1.00
    m_vCurrentCameraPos=(X=1.00,Y=0.00,Z=15000.00)
    m_vCamPos=(X=1.00,Y=0.00,Z=15000.00)
    m_rCamRot=(Pitch=49153,Yaw=0,Roll=0)
    bBehindView=True
    InputClass=Class'R6PlanningPlayerInput'
    RemoteRole=ROLE_None
}
/*
    m_pIconTex(0)=Texture'R6Planning.Icons.PlanIcon_Alpha'
    m_pIconTex(1)=Texture'R6Planning.Icons.PlanIcon_Bravo'
    m_pIconTex(2)=Texture'R6Planning.Icons.PlanIcon_Charlie'
    m_pIconTex(3)=Texture'R6Planning.Icons.PlanIcon_Milestone1'
    m_pIconTex(4)=Texture'R6Planning.Icons.PlanIcon_Milestone2'
    m_pIconTex(5)=Texture'R6Planning.Icons.PlanIcon_Milestone3'
    m_pIconTex(6)=Texture'R6Planning.Icons.PlanIcon_Milestone4'
    m_pIconTex(7)=Texture'R6Planning.Icons.PlanIcon_Milestone5'
    m_pIconTex(8)=Texture'R6Planning.Icons.PlanIcon_Milestone6'
    m_pIconTex(9)=Texture'R6Planning.Icons.PlanIcon_Milestone7'
    m_pIconTex(10)=Texture'R6Planning.Icons.PlanIcon_Milestone8'
    m_pIconTex(11)=Texture'R6Planning.Icons.PlanIcon_Milestone9'
    m_PlanningBadClickSnd=Sound'SFX_Menus.Play_Planning_BadClick'
    m_PlanningGoodClickSnd=Sound'SFX_Menus.Play_Planning_GoodClick'
*/

