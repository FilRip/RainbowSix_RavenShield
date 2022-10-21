//================================================================================
// R6PathFlag.
//================================================================================
class R6PathFlag extends R6ReferenceIcons;

var Texture m_pIconTex[3];

function SetModeDisplay (EMovementMode eMode)
{
	Texture=m_pIconTex[eMode];
}

function SetDrawColor (Color NewColor)
{
	m_PlanningColor=NewColor;
}

function RefreshLocation ()
{
	local float fEvenCheck;
	local Vector vFirstVector;
	local Vector vSecondVector;
	local int iMiddleNodeIndex;
	local R6ActionPoint OwnerPoint;
	local Actor aMiddlePoint1;
	local Actor aMiddlePoint2;
	local Actor aMiddlePoint3;

	OwnerPoint=R6ActionPoint(Owner);
	if ( OwnerPoint.prevActionPoint.m_PathToNextPoint.Length == 0 )
	{
		SetLocation((OwnerPoint.Location + OwnerPoint.prevActionPoint.Location) * 0.50);
		m_iPlanningFloor_0=Owner.m_iPlanningFloor_0;
		m_iPlanningFloor_1=OwnerPoint.prevActionPoint.m_iPlanningFloor_0;
	}
	else
	{
		fEvenCheck=OwnerPoint.prevActionPoint.m_PathToNextPoint.Length % 2;
		if ( fEvenCheck == 0 )
		{
			aMiddlePoint1=OwnerPoint.prevActionPoint.m_PathToNextPoint[OwnerPoint.prevActionPoint.m_PathToNextPoint.Length / 2];
			if ( OwnerPoint.prevActionPoint.m_PathToNextPoint.Length > 1 )
			{
				aMiddlePoint2=OwnerPoint.prevActionPoint.m_PathToNextPoint[OwnerPoint.prevActionPoint.m_PathToNextPoint.Length / 2 - 1];
				if ( OwnerPoint.prevActionPoint.m_PathToNextPoint.Length > 3 )
				{
					aMiddlePoint3=OwnerPoint.prevActionPoint.m_PathToNextPoint[OwnerPoint.prevActionPoint.m_PathToNextPoint.Length / 2 - 2];
				}
			}
			if ( aMiddlePoint2.IsA('R6Ladder') && aMiddlePoint1.IsA('R6Ladder') || aMiddlePoint2.IsA('R6Door') && aMiddlePoint1.IsA('R6Door') )
			{
				if ( OwnerPoint.prevActionPoint.m_PathToNextPoint.Length == 2 )
				{
					vFirstVector=OwnerPoint.prevActionPoint.Location;
					vSecondVector=OwnerPoint.prevActionPoint.m_PathToNextPoint[0].Location;
				}
				else
				{
					vFirstVector=aMiddlePoint3.Location;
					vSecondVector=aMiddlePoint2.Location;
				}
			}
			else
			{
				vFirstVector=aMiddlePoint1.Location;
				vSecondVector=aMiddlePoint2.Location;
			}
			SetLocation((vFirstVector + vSecondVector) * 0.50);
			if ( aMiddlePoint2.IsA('R6Stairs') &&  !aMiddlePoint1.IsA('R6Stairs') )
			{
				if ( R6Stairs(aMiddlePoint2).m_bIsTopOfStairs == True )
				{
					m_iPlanningFloor_0=aMiddlePoint2.m_iPlanningFloor_1;
					m_iPlanningFloor_1=aMiddlePoint2.m_iPlanningFloor_1;
				}
				else
				{
					m_iPlanningFloor_0=aMiddlePoint2.m_iPlanningFloor_0;
					m_iPlanningFloor_1=aMiddlePoint2.m_iPlanningFloor_0;
				}
			}
			else
			{
				if ( aMiddlePoint2.IsA('R6Ladder') && aMiddlePoint1.IsA('R6Ladder') )
				{
					if ( R6Ladder(aMiddlePoint2).m_bIsTopOfLadder == True )
					{
						m_iPlanningFloor_0=aMiddlePoint2.m_iPlanningFloor_1;
						m_iPlanningFloor_1=aMiddlePoint2.m_iPlanningFloor_1;
					}
					else
					{
						m_iPlanningFloor_0=aMiddlePoint2.m_iPlanningFloor_0;
						m_iPlanningFloor_1=aMiddlePoint2.m_iPlanningFloor_0;
					}
				}
				else
				{
					m_iPlanningFloor_0=aMiddlePoint2.m_iPlanningFloor_0;
					m_iPlanningFloor_1=aMiddlePoint2.m_iPlanningFloor_1;
				}
			}
		}
		else
		{
			iMiddleNodeIndex=OwnerPoint.prevActionPoint.m_PathToNextPoint.Length / 2;
			aMiddlePoint1=OwnerPoint.prevActionPoint.m_PathToNextPoint[iMiddleNodeIndex];
			if ( OwnerPoint.prevActionPoint.m_PathToNextPoint.Length > 1 )
			{
				aMiddlePoint2=OwnerPoint.prevActionPoint.m_PathToNextPoint[iMiddleNodeIndex + 1];
				aMiddlePoint3=OwnerPoint.prevActionPoint.m_PathToNextPoint[iMiddleNodeIndex - 1];
			}
			if ( aMiddlePoint1.IsA('R6Ladder') )
			{
				if ( OwnerPoint.prevActionPoint.m_PathToNextPoint.Length == 1 )
				{
					vFirstVector=OwnerPoint.prevActionPoint.Location;
					vSecondVector=aMiddlePoint1.Location;
				}
				else
				{
					if ( aMiddlePoint3.IsA('R6Ladder') )
					{
						vFirstVector=aMiddlePoint1.Location;
						vSecondVector=aMiddlePoint2.Location;
					}
					else
					{
						vFirstVector=aMiddlePoint1.Location;
						vSecondVector=aMiddlePoint3.Location;
					}
				}
				SetLocation((vFirstVector + vSecondVector) * 0.50);
			}
			if ( aMiddlePoint1.IsA('R6Door') )
			{
				if ( OwnerPoint.prevActionPoint.m_PathToNextPoint.Length == 1 )
				{
					vFirstVector=OwnerPoint.prevActionPoint.Location;
					vSecondVector=aMiddlePoint1.Location;
				}
				else
				{
					if ( aMiddlePoint3.IsA('R6Door') )
					{
						vFirstVector=aMiddlePoint1.Location;
						vSecondVector=aMiddlePoint2.Location;
					}
					else
					{
						vFirstVector=aMiddlePoint1.Location;
						vSecondVector=aMiddlePoint3.Location;
					}
				}
				SetLocation((vFirstVector + vSecondVector) * 0.50);
			}
			else
			{
				SetLocation(aMiddlePoint1.Location);
			}
			m_iPlanningFloor_0=aMiddlePoint1.m_iPlanningFloor_0;
			m_iPlanningFloor_1=aMiddlePoint1.m_iPlanningFloor_1;
		}
	}
}

defaultproperties
{
    m_bSkipHitDetection=False
    m_bSpriteShowFlatInPlanning=False
    DrawScale=1.25
}
/*
    m_pIconTex(0)=Texture'R6Planning.Icons.PlanIcon_Assault'
    m_pIconTex(1)=Texture'R6Planning.Icons.PlanIcon_Infiltrate'
    m_pIconTex(2)=Texture'R6Planning.Icons.PlanIcon_Recon'
*/

