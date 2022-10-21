//================================================================================
// R6PlanningInfo.
//================================================================================
class R6PlanningInfo extends R6AbstractPlanningInfo
	Native
	Transient;

native(1411) final function bool AddToTeam (R6ActionPoint pNewPoint);

native(1412) final function bool InsertToTeam (R6ActionPoint pNewPoint);

native(1413) final function bool DeletePoint ();

native(2007) final function bool FindPathToNextPoint (R6ActionPoint pStartPoint, R6ActionPoint pPointToReach);

function Tick (float fDelta)
{
	local R6GameInfo Game;
	local int iCurrentActionPoint;

	if ( (m_iNbNode > 1) && m_NodeList[0].InPlanningMode() )
	{
		iCurrentActionPoint=1;
JL0025:
		if ( iCurrentActionPoint < m_iNbNode )
		{
			R6ActionPoint(m_NodeList[iCurrentActionPoint]).DrawPath(bDisplayDbgInfo);
			iCurrentActionPoint++;
			goto JL0025;
		}
	}
	if ( bDisplayDbgInfo == True )
	{
		bDisplayDbgInfo=False;
	}
}

function InitPlanning (int iTeamId, R6PlanningCtrl pPlanningCtrl)
{
	local int iBackupLastNode;
	local int iCurrentActionPoint;
	local int iLoadedNumberOfNodes;
	local R6ActionPoint pCurrentPoint;
	local R6ActionPoint pNextPoint;

	if ( m_iNbNode == 0 )
	{
		return;
	}
	iBackupLastNode=m_iCurrentNode;
	iLoadedNumberOfNodes=m_iNbNode;
	iCurrentActionPoint=0;
JL002A:
	if ( iCurrentActionPoint < iLoadedNumberOfNodes )
	{
		pCurrentPoint=R6ActionPoint(m_NodeList[iCurrentActionPoint]);
		if ( iCurrentActionPoint == 0 )
		{
			pCurrentPoint.SetFirstPointTexture();
			pCurrentPoint.UnselectPoint();
		}
		pCurrentPoint.m_pPlanningCtrl=pPlanningCtrl;
		pCurrentPoint.m_iRainbowTeamName=iTeamId;
		if ( iCurrentActionPoint != iLoadedNumberOfNodes - 1 )
		{
			pNextPoint=R6ActionPoint(m_NodeList[iCurrentActionPoint + 1]);
			pNextPoint.prevActionPoint=pCurrentPoint;
			FindPathToNextPoint(pCurrentPoint,pNextPoint);
		}
		pCurrentPoint.SetDrawColor(m_TeamColor);
		if ( iCurrentActionPoint != 0 )
		{
			pCurrentPoint.prevActionPoint=R6ActionPoint(m_NodeList[iCurrentActionPoint - 1]);
			pCurrentPoint.InitMyPathFlag();
		}
		pCurrentPoint.ChangeActionType(pCurrentPoint.m_eActionType);
		pCurrentPoint.SetPointAction(pCurrentPoint.m_eAction,True);
		iCurrentActionPoint++;
		goto JL002A;
	}
	ResetPointsOrientation();
	if ( iBackupLastNode != -1 )
	{
		SetAsCurrentNode(R6ActionPoint(m_NodeList[iBackupLastNode]));
	}
}

function ResetPointsOrientation ()
{
	SetToStartNode();
JL0006:
	if ( GetNextPoint() != None )
	{
		SetPointRotation();
		SetToNextNode();
		goto JL0006;
	}
	SetPointRotation();
	SetToStartNode();
}

function SetPathDisplay (bool bDisplay)
{
	local int iCurrentNode;
	local R6ActionPoint pCurrentPoint;

	m_bDisplayPath=bDisplay;
	if ( m_iCurrentNode != -1 )
	{
		iCurrentNode=0;
JL0023:
		if ( iCurrentNode < m_NodeList.Length )
		{
			pCurrentPoint=R6ActionPoint(m_NodeList[iCurrentNode]);
			pCurrentPoint.bHidden= !bDisplay;
			if ( pCurrentPoint.m_pMyPathFlag != None )
			{
				pCurrentPoint.m_pMyPathFlag.bHidden= !bDisplay;
			}
			if ( pCurrentPoint.m_pActionIcon != None )
			{
				pCurrentPoint.m_pActionIcon.bHidden= !bDisplay;
			}
			iCurrentNode++;
			goto JL0023;
		}
	}
}

function SelectTeam (bool bIsSelected)
{
	local R6ActionPoint pCurrentPoint;

	pCurrentPoint=GetPoint();
	if ( pCurrentPoint != None )
	{
		pCurrentPoint.m_PlanningColor=pCurrentPoint.m_CurrentColor;
		if ( bIsSelected == True )
		{
			pCurrentPoint.SetTimer(0.50,True);
		}
		else
		{
			pCurrentPoint.SetTimer(0.00,False);
		}
	}
	else
	{
		R6PlanningCtrl(m_pTeamManager).PositionCameraOnInsertionZone();
	}
}

function bool InsertPoint (R6ActionPoint pNewPoint)
{
	local R6ActionPoint BehindMe;
	local R6ActionPoint FrontMe;

	BehindMe=GetPoint();
	FrontMe=GetNextPoint();
	if ( (FindPathToNextPoint(BehindMe,pNewPoint) == True) && (FindPathToNextPoint(pNewPoint,FrontMe) == True) )
	{
		InsertToTeam(pNewPoint);
		ResetID();
		FrontMe.m_pMyPathFlag.RefreshLocation();
		pNewPoint.m_eMovementMode=BehindMe.m_eMovementMode;
		pNewPoint.m_eMovementSpeed=BehindMe.m_eMovementSpeed;
		pNewPoint.SetDrawColor(m_TeamColor);
		pNewPoint.InitMyPathFlag();
		BehindMe.UnselectPoint();
		pNewPoint.SelectPoint();
		SetPointRotation();
		SetToNextNode();
		SetPointRotation();
		SetToNextNode();
		SetPointRotation();
		SetToPrevNode();
	}
	else
	{
		pNewPoint.Destroy();
		pNewPoint=None;
		return False;
	}
	return True;
}

function bool AddPoint (R6ActionPoint pNewPoint)
{
	local R6ActionPoint BehindMe;

	if ( m_iCurrentNode != -1 )
	{
		BehindMe=GetPoint();
	}
	if ( BehindMe != None )
	{
		if ( FindPathToNextPoint(BehindMe,pNewPoint) == True )
		{
			AddToTeam(pNewPoint);
			ResetID();
			pNewPoint.m_eMovementMode=BehindMe.m_eMovementMode;
			pNewPoint.m_eMovementSpeed=BehindMe.m_eMovementSpeed;
			pNewPoint.SetDrawColor(m_TeamColor);
			pNewPoint.InitMyPathFlag();
			SetPointRotation();
			SetToNextNode();
			SetPointRotation();
		}
		else
		{
			pNewPoint.Destroy();
			pNewPoint=None;
			return False;
		}
	}
	else
	{
		AddToTeam(pNewPoint);
		ResetID();
		pNewPoint.SetDrawColor(m_TeamColor);
		pNewPoint.SelectPoint();
	}
	return True;
}

function bool MoveCurrentPoint ()
{
	local R6ActionPoint BehindMe;
	local R6ActionPoint FrontMe;
	local R6ActionPoint CurrentPoint;

	CurrentPoint=GetPoint();
	BehindMe=R6ActionPoint(CurrentPoint.prevActionPoint);
	FrontMe=GetNextPoint();
	if ( BehindMe != None )
	{
		if ( FindPathToNextPoint(BehindMe,CurrentPoint) == True )
		{
			CurrentPoint.InitMyPathFlag();
		}
		else
		{
			return False;
		}
	}
	if ( FrontMe != None )
	{
		if ( FindPathToNextPoint(CurrentPoint,FrontMe) == True )
		{
			FrontMe.InitMyPathFlag();
		}
		else
		{
			return False;
		}
	}
	return True;
}

function SetLastPointRotation ()
{
	local Vector vDirection;
	local R6InsertionZone anInsertionZone;
	local Rotator rFirstPointRotation;
	local R6ActionPoint pCurrentPoint;

	pCurrentPoint=GetPoint();
	if ( m_NodeList.Length > 1 )
	{
		if ( pCurrentPoint.prevActionPoint.m_PathToNextPoint.Length != 0 )
		{
			vDirection=pCurrentPoint.Location - pCurrentPoint.prevActionPoint.m_PathToNextPoint[pCurrentPoint.prevActionPoint.m_PathToNextPoint.Length - 1].Location;
		}
		else
		{
			vDirection=pCurrentPoint.Location - pCurrentPoint.prevActionPoint.Location;
		}
		vDirection.Z=0.00;
		vDirection=Normal(vDirection);
		pCurrentPoint.SetRotation(rotator(vDirection));
		pCurrentPoint.m_u8SpritePlanningAngle=pCurrentPoint.Rotation.Yaw / 255;
	}
	else
	{
		foreach m_pTeamManager.AllActors(Class'R6InsertionZone',anInsertionZone)
		{
			if ( anInsertionZone.IsAvailableInGameType(R6AbstractGameInfo(m_pTeamManager.Level.Game).m_eGameTypeFlag) && (anInsertionZone.m_iInsertionNumber == m_iStartingPointNumber) )
			{
				rFirstPointRotation=anInsertionZone.Rotation;
			}
		}
		pCurrentPoint.SetRotation(rFirstPointRotation);
		pCurrentPoint.m_u8SpritePlanningAngle=pCurrentPoint.Rotation.Yaw / 255;
	}
}

function SetPointRotation ()
{
	local Vector vDirection;
	local R6ActionPoint pCurrentPoint;

	pCurrentPoint=GetPoint();
	pCurrentPoint.m_bActionCompleted=False;
	pCurrentPoint.m_bActionPointReached=False;
	if ( GetNextPoint() != None )
	{
		if ( pCurrentPoint.m_PathToNextPoint.Length != 0 )
		{
			vDirection=pCurrentPoint.m_PathToNextPoint[0].Location - pCurrentPoint.Location;
		}
		else
		{
			vDirection=GetNextPoint().Location - pCurrentPoint.Location;
		}
		vDirection.Z=0.00;
		vDirection=Normal(vDirection);
		pCurrentPoint.SetRotation(rotator(vDirection));
		pCurrentPoint.m_u8SpritePlanningAngle=pCurrentPoint.Rotation.Yaw / 255;
	}
	else
	{
		SetLastPointRotation();
	}
}

function SetToPrevNode ()
{
	if ( m_iCurrentNode > 0 )
	{
		GetPoint().UnselectPoint();
		m_iCurrentNode--;
		GetPoint().SelectPoint();
	}
}

function SetToNextNode ()
{
	if ( m_iCurrentNode != m_NodeList.Length - 1 )
	{
		GetPoint().UnselectPoint();
		m_iCurrentNode++;
		GetPoint().SelectPoint();
	}
}

function SetToStartNode ()
{
	if ( m_iNbNode != 0 )
	{
		if ( m_iCurrentNode != -1 )
		{
			GetPoint().UnselectPoint();
		}
		m_iCurrentNode=0;
		GetPoint().SelectPoint();
		m_iCurrentPathIndex=-1;
	}
}

function SetToEndNode ()
{
	if ( m_iCurrentNode != -1 )
	{
		GetPoint().UnselectPoint();
		m_iCurrentNode=m_NodeList.Length - 1;
		GetPoint().SelectPoint();
	}
}

function RemovePointsRefsToCtrl ()
{
	local R6ActionPoint pActionPoint;
	local int iCurrentNode;

	iCurrentNode=0;
JL0007:
	if ( iCurrentNode < m_NodeList.Length )
	{
		pActionPoint=R6ActionPoint(m_NodeList[iCurrentNode]);
		pActionPoint.m_pPlanningCtrl=None;
		iCurrentNode++;
		goto JL0007;
	}
}

function ResetID ()
{
	local R6ActionPoint pNode;

	m_iNbMilestone=0;
	m_iNbNode=0;
JL000E:
	if ( m_iNbNode < m_NodeList.Length )
	{
		pNode=R6ActionPoint(m_NodeList[m_iNbNode]);
		pNode.m_iNodeID=m_iNbNode;
		if ( pNode.m_eActionType == 1 )
		{
			m_iNbMilestone++;
			pNode.m_iMileStoneNum=m_iNbMilestone;
			pNode.SetMileStoneIcon(m_iNbMilestone);
		}
		m_iNbNode++;
		goto JL000E;
	}
}

function bool SetAsCurrentNode (R6ActionPoint pSelectedNode)
{
	if ( m_iCurrentNode != -1 )
	{
		GetPoint().UnselectPoint();
	}
	m_iCurrentNode=0;
JL0026:
	if ( m_iCurrentNode < m_NodeList.Length )
	{
		if ( GetPoint() == pSelectedNode )
		{
			GetPoint().SelectPoint();
			return True;
		}
		m_iCurrentNode++;
		goto JL0026;
	}
	m_iCurrentNode=0;
	Log("WARNING - Could not find current node in Planning Info!!");
	return False;
}

function bool DeleteNode ()
{
	local R6ActionPoint pCurrentPoint;
	local R6ReferenceIcons tempAI;
	local R6PathFlag tempPF;

	if ( m_iCurrentNode == -1 )
	{
		return False;
	}
	pCurrentPoint=GetPoint();
	if (  !(m_iCurrentNode == 0) && (m_NodeList.Length > 1) )
	{
		if ( pCurrentPoint.m_pActionIcon != None )
		{
			tempAI=pCurrentPoint.m_pActionIcon;
			pCurrentPoint.m_pActionIcon=None;
			tempAI.Destroy();
			pCurrentPoint.m_vActionDirection=vect(0.00,0.00,0.00);
		}
		if ( pCurrentPoint.m_pMyPathFlag != None )
		{
			tempPF=pCurrentPoint.m_pMyPathFlag;
			pCurrentPoint.m_pMyPathFlag=None;
			tempPF.Destroy();
		}
		if ( m_iCurrentNode == 0 )
		{
			m_bPlacedFirstPoint=False;
		}
		DeletePoint();
		ResetID();
		if ( m_iCurrentNode == m_NodeList.Length )
		{
			m_iCurrentNode--;
			if ( m_iCurrentNode == -1 )
			{
				return True;
			}
			pCurrentPoint=GetPoint();
			pCurrentPoint.SelectPoint();
			SetPointRotation();
		}
		else
		{
			m_iCurrentNode--;
			pCurrentPoint=GetPoint();
			GetNextPoint().prevActionPoint=pCurrentPoint;
			FindPathToNextPoint(pCurrentPoint,GetNextPoint());
			GetNextPoint().m_pMyPathFlag.RefreshLocation();
			pCurrentPoint.SelectPoint();
			SetPointRotation();
			SetToNextNode();
			SetPointRotation();
			SetToPrevNode();
		}
	}
	else
	{
		Log("Cannot delete start location, when there's other points in the list");
		return False;
	}
	return True;
}

function DeleteAllNode ()
{
	m_iCurrentNode=m_NodeList.Length - 1;
JL000F:
	if ( m_iCurrentNode != -1 )
	{
		DeleteNode();
		goto JL000F;
	}
	m_bPlacedFirstPoint=False;
}

function SetCurrentPointAction (EPlanAction eAction)
{
	if ( GetPoint() == None )
	{
		Log("WARNING: CurrentNode null");
		return;
	}
	GetPoint().SetPointAction(eAction);
}

function AjustSnipeDirection (Vector vHitLocation)
{
	if ( m_iCurrentNode != -1 )
	{
		GetPoint().m_rActionRotation=R6PlanningSnipe(GetPoint().m_pActionIcon).SetDirectionRotator(vHitLocation);
	}
}

function GetSnipingCoordinates (out Vector vLocation, out Rotator rRotation)
{
	vLocation=GetPoint().Location;
	rRotation=GetPoint().m_rActionRotation;
}

function Actor GetDoorToBreach ()
{
	return GetPoint().pDoor;
}

function Actor GetNextDoorToBreach (Actor aPoint)
{
	local R6ActionPoint nextActionPoint;

	if ( R6ActionPoint(aPoint) != None )
	{
		return R6ActionPoint(aPoint).pDoor;
	}
	nextActionPoint=GetNextPoint();
	if ( nextActionPoint != None )
	{
		return nextActionPoint.pDoor;
	}
}

function bool SetGrenadeLocation (Vector vHitLocation)
{
	if ( GetPoint() != None )
	{
		vHitLocation.Z += 100;
		return GetPoint().SetGrenade(vHitLocation);
	}
	return False;
}

function SetActionType (EPlanActionType eNewType)
{
	if ( m_iCurrentNode != -1 )
	{
		GetPoint().ChangeActionType(eNewType);
	}
}

function R6ActionPoint GetPoint ()
{
	if ( m_iCurrentNode != -1 )
	{
		return R6ActionPoint(m_NodeList[m_iCurrentNode]);
	}
	return None;
}

function R6ActionPoint GetNextPoint ()
{
	if ( (m_iCurrentNode != -1) && (m_iCurrentNode + 1 != m_NodeList.Length) )
	{
		return R6ActionPoint(m_NodeList[m_iCurrentNode + 1]);
	}
	return None;
}

function EPlanActionType GetActionType ()
{
	if ( m_iCurrentNode != -1 )
	{
		return GetPoint().m_eActionType;
	}
	return m_eDefaultActionType;
}

function SetAction (EPlanAction eNewAction)
{
	if ( m_iCurrentNode != -1 )
	{
		GetPoint().m_eAction=eNewAction;
	}
}

/*function EPlanAction GetAction ()
{
	if ( m_iCurrentNode != -1 )
	{
		return GetPoint().m_eAction;
	}
	return m_eDefaultAction;
}

function EPlanAction NextActionPointHasAction (Actor aPoint)
{
	local R6ActionPoint actionPoint;
	local R6ActionPoint nextActionPoint;

	actionPoint=R6ActionPoint(aPoint);
	if ( actionPoint == None )
	{
		nextActionPoint=GetNextPoint();
		if ( (nextActionPoint != None) && (VSize(nextActionPoint.Location - aPoint.Location) < 300) )
		{
			return nextActionPoint.m_eAction;
		}
		else
		{
			return 0;
		}
	}
	return actionPoint.m_eAction;
} */

function SetMovementMode (EMovementMode eNewMode)
{
	if ( m_iCurrentNode != -1 )
	{
		GetPoint().m_eMovementMode=eNewMode;
		GetPoint().m_pMyPathFlag.SetModeDisplay(eNewMode);
	}
}

/*function EMovementMode GetMovementMode ()
{
	if ( m_iCurrentNode != -1 )
	{
		if ( m_iCurrentPathIndex != -1 )
		{
			return GetNextPoint().m_eMovementMode;
		}
		else
		{
			return GetPoint().m_eMovementMode;
		}
	}
	return m_eDefaultMode;
}*/

function SetMovementSpeed (EMovementSpeed eNewSpeed)
{
	if ( m_iCurrentNode != -1 )
	{
		GetPoint().m_eMovementSpeed=eNewSpeed;
	}
}

/*function EMovementSpeed GetMovementSpeed ()
{
	if ( m_iCurrentNode != -1 )
	{
		if ( m_iCurrentPathIndex != -1 )
		{
			return GetNextPoint().m_eMovementSpeed;
		}
		else
		{
			return GetPoint().m_eMovementSpeed;
		}
	}
	return m_eDefaultSpeed;
}*/

function Actor GetFirstActionPoint ()
{
	return GetPoint();
}

function SkipCurrentDestination ()
{
	local R6ActionPoint pPrevPoint;
	local R6ActionPoint pCurrentPoint;
	local R6RainbowTeam pCurrentTeam;

	pCurrentPoint=GetPoint();
	pCurrentTeam=R6RainbowTeam(m_pTeamManager);
	if ( (m_iCurrentNode != -1) && (m_iCurrentNode != m_NodeList.Length - 1) )
	{
		if ( m_iCurrentPathIndex == pCurrentPoint.m_PathToNextPoint.Length - 1 )
		{
			pPrevPoint=pCurrentPoint;
			pCurrentPoint.m_bActionCompleted=True;
			m_iCurrentPathIndex=-1;
			m_iCurrentNode++;
		}
		else
		{
			m_iCurrentPathIndex++;
		}
		if ( m_iCurrentPathIndex == -1 )
		{
			if ( pPrevPoint.m_eMovementMode != pCurrentPoint.m_eMovementMode )
			{
//				pCurrentTeam.TeamNotifyActionPoint(1,4);
			}
			if ( pPrevPoint.m_eMovementSpeed != pCurrentPoint.m_eMovementSpeed )
			{
//				pCurrentTeam.TeamNotifyActionPoint(2,4);
			}
		}
		else
		{
			if ( m_iCurrentPathIndex == 0 )
			{
				if ( GetNextPoint().m_eMovementMode != pCurrentPoint.m_eMovementMode )
				{
//					pCurrentTeam.TeamNotifyActionPoint(1,4);
				}
				if ( GetNextPoint().m_eMovementSpeed != pCurrentPoint.m_eMovementSpeed )
				{
//					pCurrentTeam.TeamNotifyActionPoint(2,4);
				}
			}
		}
//		pCurrentTeam.TeamNotifyActionPoint(3,4);
	}
	else
	{
		m_iCurrentNode=-1;
	}
}

function Actor GetNextActionPoint ()
{
	local Actor pPointToReturn;
	local R6ActionPoint pCurrentPoint;

	pCurrentPoint=GetPoint();
	if ( (m_iCurrentNode != -1) && (m_iCurrentNode < m_NodeList.Length) )
	{
		if ( (m_iCurrentPathIndex != -1) && (m_iCurrentPathIndex < pCurrentPoint.m_PathToNextPoint.Length) )
		{
			pPointToReturn=pCurrentPoint.m_PathToNextPoint[m_iCurrentPathIndex];
		}
		else
		{
			pPointToReturn=pCurrentPoint;
		}
	}
	else
	{
		pPointToReturn=None;
	}
	return pPointToReturn;
}

function Actor PreviewNextActionPoint ()
{
	local Actor pPointToReturn;

	if ( m_iCurrentNode != -1 )
	{
		if ( m_iCurrentPathIndex + 1 < GetPoint().m_PathToNextPoint.Length )
		{
			pPointToReturn=GetPoint().m_PathToNextPoint[m_iCurrentPathIndex + 1];
		}
		else
		{
			pPointToReturn=GetNextPoint();
		}
	}
	return pPointToReturn;
}

function SetToPreviousActionPoint ()
{
	if ( GetPoint().m_bActionPointReached || (VSize(R6RainbowTeam(m_pTeamManager).m_Team[0].Location - GetPoint().Location) < 200) )
	{
		return;
	}
	if ( (m_iCurrentNode != -1) &&  !(m_iCurrentNode == 0) && (m_iCurrentPathIndex == -1) )
	{
		if ( m_iCurrentPathIndex != -1 )
		{
			m_iCurrentPathIndex -= 1;
		}
		else
		{
			m_iCurrentNode--;
			m_iCurrentPathIndex=GetPoint().m_PathToNextPoint.Length - 1;
		}
	}
}

function int GetActionPointID ()
{
	if ( m_iCurrentNode != -1 )
	{
		return GetPoint().m_iNodeID;
	}
	return -1;
}

function int GetNbActionPoint ()
{
	return m_iNbNode;
}

function Vector GetActionLocation ()
{
	if ( m_iCurrentNode != -1 )
	{
		return GetPoint().m_vActionDirection;
	}
	return vect(0.00,0.00,0.00);
}

function NotifyActionPoint (ENodeNotify eMsg, EGoCode eCode)
{
	local R6ActionPoint pPrevPoint;
	local R6RainbowTeam pCurrentTeam;
	local R6ActionPoint pCurrentPoint;

	pCurrentTeam=R6RainbowTeam(m_pTeamManager);
	pCurrentPoint=GetPoint();
	if ( (pCurrentTeam != None) && (m_iCurrentNode != -1) )
	{
		switch (eMsg)
		{
/*			case 0:
			return;
			case 1:
			return;
			case 4:
			if ( pCurrentTeam.m_eGoCode == 3 )
			{
				return;
			}
			if ( m_eGoCodeState[eCode] == 1 )
			{
				m_eGoCodeState[eCode]=0;
				if ( pCurrentPoint.m_eAction != 0 )
				{
					pCurrentTeam.TeamNotifyActionPoint(0,4);
				}
				else
				{
					NotifyActionPoint(5,4);
				}
				pCurrentTeam.ResetTeamGoCode();
			}
			else
			{
				if ( m_eGoCodeState[eCode] == 2 )
				{
					m_eGoCodeState[eCode]=0;
					pCurrentTeam.TeamSnipingOver();
					pCurrentTeam.ResetTeamGoCode();
				}
				else
				{
					if ( m_eGoCodeState[eCode] == 3 )
					{
						m_eGoCodeState[eCode]=0;
						pCurrentTeam.BreachDoor();
						pCurrentTeam.ResetTeamGoCode();
					}
					else
					{
					}
				}
			}
			return;
			case 5:
			if ( m_iCurrentNode != m_iNbNode - 1 )
			{
				pCurrentPoint.m_bActionCompleted=True;
				pPrevPoint=pCurrentPoint;
				if ( m_iCurrentPathIndex == pCurrentPoint.m_PathToNextPoint.Length - 1 )
				{
					m_iCurrentPathIndex=-1;
					m_iCurrentNode++;
					pCurrentPoint=GetPoint();
				}
				else
				{
					m_iCurrentPathIndex++;
				}
				if ( m_iCurrentPathIndex == -1 )
				{
					if ( pPrevPoint.m_eMovementMode != pCurrentPoint.m_eMovementMode )
					{
						pCurrentTeam.TeamNotifyActionPoint(1,4);
					}
					if ( pPrevPoint.m_eMovementSpeed != pCurrentPoint.m_eMovementSpeed )
					{
						pCurrentTeam.TeamNotifyActionPoint(2,4);
					}
				}
				else
				{
					if ( m_iCurrentPathIndex == 0 )
					{
						if ( GetNextPoint().m_eMovementMode != pCurrentPoint.m_eMovementMode )
						{
							pCurrentTeam.TeamNotifyActionPoint(1,4);
						}
						if ( GetNextPoint().m_eMovementSpeed != pCurrentPoint.m_eMovementSpeed )
						{
							pCurrentTeam.TeamNotifyActionPoint(2,4);
						}
					}
				}
				pCurrentTeam.TeamNotifyActionPoint(3,4);
			}
			else
			{
				m_iCurrentNode=-1;
			}
			return;
			case 6:
			m_eGoCodeState[eCode]=1;
			pCurrentTeam.TeamNotifyActionPoint(6,eCode);
			return;
			case 9:
			m_eGoCodeState[eCode]=2;
			pCurrentTeam.TeamNotifyActionPoint(9,eCode);
			return;
			case 10:
			m_eGoCodeState[eCode]=3;
			pCurrentTeam.TeamNotifyActionPoint(10,eCode);
			return;
			case 7:
			pCurrentPoint.m_bActionPointReached=True;
			ReadNode();
			return;
			case 8:
			SetToPreviousActionPoint();
			pCurrentTeam.TeamNotifyActionPoint(3,4);
			return;
			default:  */
		}
	}
	else
	{
	}
}

function bool MemberReached (R6ActionPoint PTarget)
{
	local int i;
	local Vector vDiff;
	local float fZDiff;

	if ( PTarget != None )
	{
		if ( m_pTeamManager != None )
		{
			if ( R6RainbowTeam(m_pTeamManager).m_bLeaderIsAPlayer )
			{
				vDiff=R6RainbowTeam(m_pTeamManager).m_TeamLeader.Location - PTarget.Location;
				fZDiff=vDiff.Z;
				vDiff.Z=0.00;
				if ( (VSize(vDiff) < m_fReachRange) && (fZDiff < m_fZReachRange) )
				{
					return True;
				}
			}
		}
	}
	return False;
}

function ReadNode ()
{
	local R6PlayerController pMyPlayer;
	local Actor NextPoint;
	local R6RainbowTeam pCurrentTeam;
	local R6ActionPoint pCurrentPoint;

	pCurrentPoint=GetPoint();
	pCurrentTeam=R6RainbowTeam(m_pTeamManager);
	if ( pCurrentPoint.m_bActionCompleted != True )
	{
		switch (pCurrentPoint.m_eActionType)
		{
/*			case 1:
			foreach m_pTeamManager.Level.AllActors(Class'R6PlayerController',pMyPlayer)
			{
				pMyPlayer.DisplayMilestoneMessage(pCurrentTeam.m_iRainbowTeamName,pCurrentPoint.m_iMileStoneNum);
			}
			case 0:
			if ( pCurrentPoint.m_eAction != 0 )
			{
				pCurrentTeam.TeamNotifyActionPoint(0,4);
			}
			else
			{
				NotifyActionPoint(5,4);
			}
			break;
			case 2:
			if ( pCurrentPoint.m_eAction == 5 )
			{
				NotifyActionPoint(9,0);
			}
			else
			{
				if ( pCurrentPoint.m_eAction == 6 )
				{
					NotifyActionPoint(10,0);
				}
				else
				{
					NotifyActionPoint(6,0);
				}
			}
			break;
			case 3:
			if ( pCurrentPoint.m_eAction == 5 )
			{
				NotifyActionPoint(9,1);
			}
			else
			{
				if ( pCurrentPoint.m_eAction == 6 )
				{
					NotifyActionPoint(10,1);
				}
				else
				{
					NotifyActionPoint(6,1);
				}
			}
			break;
			case 4:
			if ( pCurrentPoint.m_eAction == 5 )
			{
				NotifyActionPoint(9,2);
			}
			else
			{
				if ( pCurrentPoint.m_eAction == 6 )
				{
					NotifyActionPoint(10,2);
				}
				else
				{
					NotifyActionPoint(6,2);
				}
			}
			break;
			default:   */
		}
	}
	else
	{
//		NotifyActionPoint(5,4);
	}
}
