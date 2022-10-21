//================================================================================
// R6ActionPoint.
//================================================================================
class R6ActionPoint extends R6ActionPointAbstract
	Native;

var EMovementMode m_eMovementMode;
var EMovementSpeed m_eMovementSpeed;
var EPlanAction m_eAction;
var EPlanActionType m_eActionType;
var int m_iRainbowTeamName;
var int m_iMileStoneNum;
var int m_iNodeID;
var int m_iInitialMousePosX;
var int m_iInitialMousePosY;
var bool m_bActionCompleted;
var bool m_bActionPointReached;
var bool m_bDoorInRange;
var bool bShowLog;
var Texture m_pCurrentTexture;
var Texture m_pSelected;
var R6IORotatingDoor pDoor;
var R6PlanningCtrl m_pPlanningCtrl;
var R6PathFlag m_pMyPathFlag;
var R6ReferenceIcons m_pActionIcon;
var Color m_CurrentColor;
var Vector m_vActionDirection;
var Rotator m_rActionRotation;

function InitMyPathFlag ()
{
	local R6PathFlag pPrevFlag;

	if ( m_pMyPathFlag == None )
	{
		m_pMyPathFlag=Spawn(Class'R6PathFlag',self,,Location);
		if ( bShowLog )
		{
			Log("-->PathFlag spawned at Location " $ string(m_pMyPathFlag.Location));
		}
		m_pMyPathFlag.m_iPlanningFloor_0=m_iPlanningFloor_0;
		m_pMyPathFlag.m_iPlanningFloor_1=m_iPlanningFloor_1;
	}
	m_pMyPathFlag.SetModeDisplay(m_eMovementMode);
	m_pMyPathFlag.SetDrawColor(m_CurrentColor);
	m_pMyPathFlag.RefreshLocation();
}

function DrawPath (bool bDisplayInfo)
{
	local int iCurrentPoint;
	local Material pLineMaterial;
	local float fDashSize;

	if ( bHidden == True )
	{
		return;
	}
	switch (m_eMovementSpeed)
	{
/*		case 0:
		fDashSize=0.00;
		break;
		case 1:
		fDashSize=100.00;
		break;
		case 2:
		fDashSize=50.00;
		break;
		default:*/
	}
	if ( prevActionPoint.m_PathToNextPoint.Length == 0 )
	{
		if ( CanIDrawLine(prevActionPoint,self,m_pPlanningCtrl.m_iLevelDisplay,bDisplayInfo) )
		{
			DrawDashedLine(prevActionPoint.Location,Location,m_CurrentColor,fDashSize);
		}
	}
	else
	{
		if ( CanIDrawLine(prevActionPoint,prevActionPoint.m_PathToNextPoint[0],m_pPlanningCtrl.m_iLevelDisplay,bDisplayInfo) )
		{
			DrawDashedLine(prevActionPoint.Location,prevActionPoint.m_PathToNextPoint[0].Location,m_CurrentColor,fDashSize);
		}
		for (iCurrentPoint=0;iCurrentPoint < prevActionPoint.m_PathToNextPoint.Length - 1;iCurrentPoint++)
		{
			if ( CanIDrawLine(prevActionPoint.m_PathToNextPoint[iCurrentPoint],prevActionPoint.m_PathToNextPoint[iCurrentPoint + 1],m_pPlanningCtrl.m_iLevelDisplay,bDisplayInfo) )
			{
				DrawDashedLine(prevActionPoint.m_PathToNextPoint[iCurrentPoint].Location,prevActionPoint.m_PathToNextPoint[iCurrentPoint + 1].Location,m_CurrentColor,fDashSize);
			}
		}
		if ( CanIDrawLine(prevActionPoint.m_PathToNextPoint[iCurrentPoint],self,m_pPlanningCtrl.m_iLevelDisplay,bDisplayInfo) )
		{
			DrawDashedLine(prevActionPoint.m_PathToNextPoint[iCurrentPoint].Location,Location,m_CurrentColor,fDashSize);
		}
	}
}

function bool CanIDrawLine (Actor FromPoint, Actor ToPoint, int iDisplayingFloor, bool bDisplayInfo)
{
	local R6Stairs StairsFromPoint;
	local R6Stairs StairsToPoint;

	StairsFromPoint=R6Stairs(FromPoint);
	StairsToPoint=R6Stairs(ToPoint);
	if ( bDisplayInfo )
	{
		Log("Displaying line from " $ string(FromPoint) $ " To :" $ string(ToPoint) $ " : " $ string(FromPoint.m_iPlanningFloor_0) $ " : " $ string(FromPoint.m_iPlanningFloor_1) $ " : " $ string(ToPoint.m_iPlanningFloor_0) $ " : " $ string(ToPoint.m_iPlanningFloor_1));
	}
	if ( (StairsFromPoint != None) && (StairsToPoint != None) )
	{
		if ( StairsFromPoint.m_bIsTopOfStairs == StairsToPoint.m_bIsTopOfStairs )
		{
			if ( (StairsFromPoint.m_bIsTopOfStairs == True) && (FromPoint.m_iPlanningFloor_1 != iDisplayingFloor) || (StairsFromPoint.m_bIsTopOfStairs == False) && (FromPoint.m_iPlanningFloor_0 != iDisplayingFloor) )
			{
				return False;
			}
			return True;
		}
		else
		{
			if ( ((ToPoint.m_iPlanningFloor_0 == iDisplayingFloor) || (ToPoint.m_iPlanningFloor_1 == iDisplayingFloor)) && ((FromPoint.m_iPlanningFloor_0 == iDisplayingFloor) || (FromPoint.m_iPlanningFloor_1 == iDisplayingFloor)) )
			{
				return True;
			}
			return False;
		}
	}
	if ( (StairsFromPoint != None) || (StairsToPoint != None) )
	{
		if ( StairsFromPoint != None )
		{
			if ( (ToPoint.m_iPlanningFloor_0 == iDisplayingFloor) || (ToPoint.m_iPlanningFloor_1 == iDisplayingFloor) )
			{
				return True;
			}
		}
		else
		{
			if ( (FromPoint.m_iPlanningFloor_0 == iDisplayingFloor) || (FromPoint.m_iPlanningFloor_1 == iDisplayingFloor) )
			{
				return True;
			}
		}
		return False;
	}
	if ( (FromPoint.m_iPlanningFloor_0 == iDisplayingFloor) && (FromPoint.m_iPlanningFloor_1 == iDisplayingFloor) )
	{
		return True;
	}
	if ( (FromPoint.m_iPlanningFloor_0 <= iDisplayingFloor) && (FromPoint.m_iPlanningFloor_1 >= iDisplayingFloor) || (ToPoint.m_iPlanningFloor_0 <= iDisplayingFloor) && (ToPoint.m_iPlanningFloor_1 >= iDisplayingFloor) )
	{
		return True;
	}
	return False;
}

function ChangeActionType (EPlanActionType eNewType)
{
	local bool bDoIReset;

	if ( (m_eActionType == 1) || (eNewType == 1) )
	{
		bDoIReset=True;
	}
	m_eActionType=eNewType;
	if ( m_eActionType == 0 )
	{
		m_pCurrentTexture=Default.m_pCurrentTexture;
		m_pSelected=Default.m_pSelected;
		Texture=m_pSelected;
		m_bSpriteShowFlatInPlanning=True;
	}
	else
	{
		if ( m_eActionType == 1 )
		{
			if ( m_pPlanningCtrl != None )
			{
				m_pPlanningCtrl.ResetIDs();
			}
			bDoIReset=False;
			Texture=m_pSelected;
			m_bSpriteShowFlatInPlanning=False;
		}
		else
		{
			if ( m_pPlanningCtrl != None )
			{
				m_pCurrentTexture=m_pPlanningCtrl.GetActionTypeTexture(m_eActionType);
			}
			m_pSelected=m_pCurrentTexture;
			Texture=m_pSelected;
			m_bSpriteShowFlatInPlanning=False;
		}
	}
	if ( bDoIReset && (m_pPlanningCtrl != None) )
	{
		m_pPlanningCtrl.ResetIDs();
	}
}

function SetPointAction (EPlanAction eAction, optional bool bLoading)
{
	m_eAction=eAction;
	if ( m_pActionIcon != None )
	{
		m_pActionIcon.Destroy();
		m_pActionIcon=None;
	}
	if ( bLoading )
	{
		FindDoor();
	}
	if ( eAction == 1 )
	{
		if ( bLoading == False )
		{
			m_pActionIcon=Spawn(Class'R6PlanningRangeFragGrenade',self,,Location);
			m_pActionIcon.m_iPlanningFloor_0=m_iPlanningFloor_0;
			m_pActionIcon.m_iPlanningFloor_1=m_iPlanningFloor_1;
			bHidden=True;
		}
		else
		{
			SetGrenade(m_vActionDirection);
		}
	}
	else
	{
		if ( (eAction == 2) || (eAction == 3) || (eAction == 4) )
		{
			if ( bLoading == False )
			{
				m_pActionIcon=Spawn(Class'R6PlanningRangeGrenade',self,,Location);
				m_pActionIcon.m_iPlanningFloor_0=m_iPlanningFloor_0;
				m_pActionIcon.m_iPlanningFloor_1=m_iPlanningFloor_1;
				bHidden=True;
			}
			else
			{
				SetGrenade(m_vActionDirection);
			}
		}
		else
		{
			if ( eAction == 5 )
			{
				m_pActionIcon=Spawn(Class'R6PlanningSnipe',self,,Location);
				m_pActionIcon.m_iPlanningFloor_0=m_iPlanningFloor_0;
				m_pActionIcon.m_iPlanningFloor_1=m_iPlanningFloor_1;
				if ( bLoading )
				{
					m_pActionIcon.m_u8SpritePlanningAngle=m_rActionRotation.Yaw / 255;
				}
			}
			else
			{
				if ( eAction == 6 )
				{
					if ( pDoor != None )
					{
						m_pActionIcon=Spawn(Class'R6PlanningBreach',self,,pDoor.m_vCenterOfDoor);
						m_pActionIcon.m_iPlanningFloor_0=m_iPlanningFloor_0;
						m_pActionIcon.m_iPlanningFloor_1=m_iPlanningFloor_1;
						R6PlanningBreach(m_pActionIcon).SetSpriteAngle(pDoor.m_iYawInit,Location);
					}
					else
					{
//						m_eAction=0;
					}
				}
			}
		}
	}
}

function FindDoor ()
{
	local Vector vDistanceVect;
	local int iPreviousDistance;
	local R6IORotatingDoor pRotatingDoor;
	local R6Door pDoorTest;

	iPreviousDistance=25000;
	m_bDoorInRange=False;
	foreach VisibleCollidingActors(Class'R6Door',pDoorTest,150.00,Location)
	{
		if ( bShowLog )
		{
			Log("Found door " $ string(pDoorTest.m_RotatingDoor) $ " for " $ string(self));
		}
		if (  !pDoorTest.m_RotatingDoor.m_bTreatDoorAsWindow )
		{
			pRotatingDoor=pDoorTest.m_RotatingDoor;
			vDistanceVect=pDoorTest.Location - Location;
			vDistanceVect.Z=0.00;
			vDistanceVect *= vDistanceVect;
			if ( vDistanceVect.X + vDistanceVect.Y < iPreviousDistance )
			{
				m_bDoorInRange=True;
				pDoor=pRotatingDoor;
				iPreviousDistance=vDistanceVect.X + vDistanceVect.Y;
			}
		}
	}
	if ( bShowLog )
	{
		Log("Kept door : " $ string(pDoor));
	}
}

function SetMileStoneIcon (int iMilestone)
{
	if ( m_pPlanningCtrl != None )
	{
		if ( m_eActionType != 0 )
		{
//			m_pCurrentTexture=m_pPlanningCtrl.GetActionTypeTexture(1,iMilestone);
			m_pSelected=m_pCurrentTexture;
			Texture=m_pSelected;
		}
		else
		{
			m_pCurrentTexture=Default.m_pCurrentTexture;
			m_pSelected=Default.m_pSelected;
			Texture=m_pSelected;
		}
	}
}

function bool SetGrenade (Vector vHitLocation)
{
	local R6PlanningGrenade pGrenadeIcon;

	pGrenadeIcon=Spawn(Class'R6PlanningGrenade',self,,vHitLocation);
	pGrenadeIcon.SetGrenadeType(m_eAction);
	pGrenadeIcon.m_iPlanningFloor_0=m_iPlanningFloor_0;
	pGrenadeIcon.m_iPlanningFloor_1=m_iPlanningFloor_1;
	m_pPlanningCtrl.Pawn.SetLocation(Location);
	if ( m_pPlanningCtrl.PlanningTrace(Location,pGrenadeIcon.Location) == False )
	{
		if ( CanIThrowGrenadeThroughDoor(vHitLocation) == False )
		{
			pGrenadeIcon.Destroy();
			return False;
		}
	}
	if ( m_pActionIcon != None )
	{
		m_pActionIcon.Destroy();
	}
	m_vActionDirection=vHitLocation;
	m_pActionIcon=pGrenadeIcon;
	return True;
}

function bool CanIThrowGrenadeThroughDoor (Vector vHitLocation)
{
	local R6IORotatingDoor pRotatingDoor;
	local R6Door pDoorNav;

	foreach VisibleCollidingActors(Class'R6IORotatingDoor',pRotatingDoor,300.00,Location)
	{
		if ( m_pPlanningCtrl.PlanningTrace(Location,pRotatingDoor.m_DoorActorA.Location) == True )
		{
			pDoorNav=pRotatingDoor.m_DoorActorB;
		}
		else
		{
			if ( m_pPlanningCtrl.PlanningTrace(Location,pRotatingDoor.m_DoorActorB.Location) == True )
			{
				pDoorNav=pRotatingDoor.m_DoorActorA;
			}
		}
		if ( pDoorNav != None )
		{
			if ( m_pPlanningCtrl.PlanningTrace(vHitLocation,pDoorNav.Location) == True )
			{
				pDoor=pRotatingDoor;
				return True;
			}
		}
	}
	return False;
}

function SetFirstPointTexture ()
{
//	m_pCurrentTexture=Texture'PlanIcon_StartPoint';
}

function UnselectPoint ()
{
	m_PlanningColor=m_CurrentColor;
	Texture=m_pCurrentTexture;
	SetTimer(0.00,False);
}

function SelectPoint ()
{
	if ( m_pCurrentTexture != m_pSelected )
	{
		Texture=m_pSelected;
	}
	SetTimer(0.50,True);
}

function Timer ()
{
	if ( m_PlanningColor!=m_CurrentColor )
	{
		m_PlanningColor=m_CurrentColor;
	}
	else
	{
		m_PlanningColor.R=255;
		m_PlanningColor.G=255;
		m_PlanningColor.B=255;
	}
}

function SetDrawColor (Color NewColor)
{
	m_CurrentColor=NewColor;
	m_PlanningColor=NewColor;
}

function Init3DView (float X, float Y)
{
	m_iInitialMousePosX=X;
	m_iInitialMousePosY=Y;
}

function RotateView (float X, float Y)
{
	local float fDeltaX;
	local float fDeltaY;
	local Rotator NodeRotation;

	if ( bShowLog )
	{
		Log("-->RotateView");
	}
	fDeltaX=(m_iInitialMousePosX - X) / 640.00;
	fDeltaY=(m_iInitialMousePosY - Y) / 480.00;
	NodeRotation.Pitch=Rotation.Pitch + fDeltaY * 32768.00;
	NodeRotation.Yaw=Rotation.Yaw - fDeltaX * 65536.00;
	SetRotation(NodeRotation);
}

defaultproperties
{
    m_eMovementSpeed=1
    m_eDisplayFlag=0
    bProjTarget=True
    m_bSpriteShowFlatInPlanning=True
    DrawScale=1.25
    CollisionRadius=20.00
    CollisionHeight=20.00
}
/*
    m_pCurrentTexture=Texture'R6Planning.Icons.PlanIcon_ActionPoint'
    m_pSelected=Texture'R6Planning.Icons.PlanIcon_SelectedPoint'
*/

