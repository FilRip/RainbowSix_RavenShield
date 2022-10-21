//================================================================================
// R6DZonePath.
//================================================================================
class R6DZonePath extends R6DeploymentZone
	Native
	Placeable;

enum EInformTeam {
	INFO_EnterPath,
	INFO_ReachNode,
	INFO_FinishWaiting,
	INFO_Engage,
	INFO_ExitPath,
	INFO_Dead
};

var(R6DZone) bool m_bCycle;
var(R6DZone) bool m_bSelectNodeInEditor;
var(R6DZone) bool m_bActAsGroup;
var(Debug) bool bShowLog;
var(R6DZone) editinlineuse array<R6DZonePathNode> m_aNode;

function int GetNodeIndex (R6DZonePathNode Node)
{
	local int i;

	i=0;
JL0007:
	if ( i < m_aNode.Length )
	{
		if ( m_aNode[i] == Node )
		{
			return i;
		}
		i++;
		goto JL0007;
	}
	return -1;
}

function R6DZonePathNode GetNextNode (R6DZonePathNode Node)
{
	local int Index;

	Index=GetNodeIndex(Node);
	if ( Index != -1 )
	{
		Index++;
		if ( Index >= m_aNode.Length )
		{
			Index=0;
		}
		return m_aNode[Index];
	}
	return None;
}

function R6DZonePathNode GetPreviousNode (R6DZonePathNode Node)
{
	local int Index;

	Index=GetNodeIndex(Node);
	if ( Index != -1 )
	{
		if ( Index == 0 )
		{
			Index=m_aNode.Length;
		}
		Index--;
		return m_aNode[Index];
	}
	return None;
}

function R6DZonePathNode FindNearestNode (Actor Pawn)
{
	local R6DZonePathNode Best;
	local R6DZonePathNode r6node;
	local float fBestDistSqr;
	local float fDistSqr;
	local Vector vDist;
	local int i;

	i=0;
JL0007:
	if ( i < m_aNode.Length )
	{
		r6node=m_aNode[i];
		vDist=Pawn.Location - r6node.Location;
		fDistSqr=vDist.X * vDist.X + vDist.Y * vDist.Y;
		if ( (fDistSqr < fBestDistSqr) || (i == 0) )
		{
			fBestDistSqr=fDistSqr;
			Best=r6node;
		}
		i++;
		goto JL0007;
	}
	return Best;
}

function bool IsLeader (R6Terrorist terro)
{
	if (  !m_bActAsGroup )
	{
		return True;
	}
	HaveTerrorist();
	if ( m_aTerrorist[0] == terro )
	{
		return True;
	}
	else
	{
		return False;
	}
}

function R6Terrorist GetLeader ()
{
	return m_aTerrorist[0];
}

function Vector GetRandomPointToNode (R6DZonePathNode Node)
{
	local Rotator R;
	local int iDistance;
	local Vector vDestination;

	R.Yaw=Rand(32767) * 2;
	iDistance=Rand(Node.m_fRadius);
//	vDestination=Node.Location + R * iDistance;
	return vDestination;
}

function SetNextNodeForTerro (R6TerroristAI terro)
{
	local int Index;
	local R6DZonePathNode nextNode;

	if ( terro.m_currentNode == None )
	{
		terro.m_currentNode=FindNearestNode(terro.m_pawn);
	}
	if (  !m_bCycle )
	{
		Index=GetNodeIndex(terro.m_currentNode);
		if ( Index == 0 )
		{
			terro.m_pawn.m_bPatrolForward=True;
		}
		if ( Index == m_aNode.Length - 1 )
		{
			terro.m_pawn.m_bPatrolForward=False;
		}
	}
	if ( terro.m_pawn.m_bPatrolForward )
	{
		nextNode=GetNextNode(terro.m_currentNode);
	}
	else
	{
		nextNode=GetPreviousNode(terro.m_currentNode);
	}
	terro.m_currentNode=nextNode;
}

function bool IsAllTerroWaiting ()
{
	local int i;

	i=0;
JL0007:
	if ( i < m_aTerrorist.Length )
	{
		if ( (m_aTerrorist[i].m_controller == None) ||  !m_aTerrorist[i].m_controller.m_bWaiting )
		{
			return False;
		}
		i++;
		goto JL0007;
	}
	return True;
}

function GoToNextNode (R6TerroristAI terroAI)
{
	local R6TerroristAI leaderAI;
	local int i;
	local Vector vGoal;

	if ( m_bActAsGroup &&  !IsAllTerroWaiting() )
	{
		if ( bShowLog )
		{
			Log("Not all terro waiting");
		}
		return;
	}
	SetNextNodeForTerro(terroAI);
	vGoal=GetRandomPointToNode(terroAI.m_currentNode);
	if ( m_bActAsGroup )
	{
		OrderTerroListFromDistanceTo(terroAI.m_currentNode.Location);
		i=0;
JL0089:
		if ( i < m_aTerrorist.Length )
		{
			m_aTerrorist[i].m_controller.m_currentNode=terroAI.m_currentNode;
			if ( i == 0 )
			{
				m_aTerrorist[i].m_controller.GotoNode(vGoal);
			}
			else
			{
				if ( i % 3 == 1 )
				{
					m_aTerrorist[i].m_controller.FollowLeader(m_aTerrorist[i - 1],vect(75.00,75.00,0.00));
				}
				else
				{
					if ( i % 3 == 2 )
					{
						m_aTerrorist[i].m_controller.FollowLeader(m_aTerrorist[i - 1],vect(-25.00,-150.00,0.00));
					}
					else
					{
						if ( i % 3 == 0 )
						{
							m_aTerrorist[i].m_controller.FollowLeader(m_aTerrorist[i - 1],vect(25.00,75.00,0.00));
						}
					}
				}
			}
			i++;
			goto JL0089;
		}
	}
	else
	{
		terroAI.GotoNode(vGoal);
	}
}

function StartWaiting (R6TerroristAI terroAI)
{
	local int iWaitingTime;
	local int iFacingTime;
	local Rotator rDirection;
	local Rotator rRefDir;
	local int i;
	local int iYawOffset;

	if ( m_bActAsGroup &&  !IsAllTerroWaiting() )
	{
		if ( bShowLog )
		{
			Log("Not all terro waiting");
		}
		return;
	}
	if ( terroAI.m_currentNode.m_bWait )
	{
		iWaitingTime=terroAI.GetWaitingTime();
		iFacingTime=terroAI.GetFacingTime();
	}
	else
	{
		iWaitingTime=0;
		iFacingTime=0;
	}
	if ( terroAI.m_currentNode.bDirectional )
	{
		rRefDir=terroAI.m_currentNode.Rotation;
	}
	else
	{
		rRefDir=m_aTerrorist[0].Rotation;
	}
	if ( m_bActAsGroup )
	{
		iYawOffset=8192;
		i=0;
JL0100:
		if ( i < m_aTerrorist.Length )
		{
			rDirection=rRefDir;
			if ( i != 0 )
			{
				if ( i % 2 != 0 )
				{
					rDirection.Yaw -= iYawOffset * (i + 1) / 2;
				}
				else
				{
					rDirection.Yaw += iYawOffset * (i + 1) / 2;
				}
			}
			m_aTerrorist[i].m_controller.WaitAtNode(iWaitingTime,iFacingTime,rDirection);
			i++;
			goto JL0100;
		}
	}
	else
	{
		terroAI.WaitAtNode(iWaitingTime,iFacingTime,rRefDir);
	}
}

function InformTerroTeam (EInformTeam eInfo, R6TerroristAI terroAI)
{
	local int i;

	if ( bShowLog )
	{
		Log("Received message " $ string(eInfo) $ " from " $ string(terroAI.Name));
	}
	switch (eInfo)
	{
/*		case 1:
		StartWaiting(terroAI);
		break;
		case 2:
		GoToNextNode(terroAI);
		break;
		case 4:
		break;
		case 5:
		HaveTerrorist();
		i=0;
JL0087:
		if ( i < m_aTerrorist.Length )
		{
			m_aTerrorist[i].m_controller.GotoPointAndSearch(terroAI.Pawn.Location,5,False,30.00);
			i++;
			goto JL0087;
		}
		break;
		default:
		break;   */
	}
}

defaultproperties
{
    m_bSelectNodeInEditor=True
}
