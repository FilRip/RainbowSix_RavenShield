//================================================================================
// R6PlanningPawn.
//================================================================================
class R6PlanningPawn extends R6Pawn;

var float m_fSpeed;
var R6ArrowIcon m_ArrowInPlanningView;
var R6PlanningInfo m_PlanToFollow;
var Actor m_pActorToReach;
var Rotator m_rDirRot;

function ArrowReachedNavPoint ()
{
}

function ArrowRotationIsOK ()
{
}

event PostBeginPlay ()
{
	m_ArrowInPlanningView=Spawn(Class'R6ArrowIcon',self);
}

simulated event ChangeAnimation ()
{
}

function ClientReStart ()
{
}

function FollowPlanning (R6PlanningInfo m_pTeamInfo)
{
	m_PlanToFollow=m_pTeamInfo;
	m_PlanToFollow.m_iCurrentPathIndex=-1;
	GotoState('FollowPlan');
}

function StopFollowingPlanning ()
{
	GotoState('None');
}

event Falling ();

event Landed (Vector HitNormal)
{
	m_bIsLanding=True;
	Acceleration=vect(0.00,0.00,0.00);
	Velocity=vect(0.00,0.00,0.00);
}

simulated function PlayDuck ();

state FollowPlan
{
	function bool ChangeArrowParameters (optional bool bFirstInit)
	{
		local Vector vDir;
		local R6PlanningCtrl OwnerPlanningCtrl;

		OwnerPlanningCtrl=R6PlanningCtrl(Owner);
		m_pActorToReach=m_PlanToFollow.GetNextActionPoint();
		if ( (m_pActorToReach != None) && (m_PlanToFollow.PreviewNextActionPoint() != None) )
		{
			if ( m_pActorToReach.IsA('R6Ladder') && (R6Ladder(m_pActorToReach).m_bIsTopOfLadder == False) )
			{
				m_ArrowInPlanningView.SetLocation(m_pActorToReach.Location + vect(0.00,0.00,100.00));
			}
			else
			{
				m_ArrowInPlanningView.SetLocation(m_pActorToReach.Location);
			}
			m_ArrowInPlanningView.m_iPlanningFloor_0=m_pActorToReach.m_iPlanningFloor_0;
			m_ArrowInPlanningView.m_iPlanningFloor_1=m_pActorToReach.m_iPlanningFloor_1;
			if ( m_pActorToReach.IsA('R6Stairs') && (R6Stairs(m_pActorToReach).m_bIsTopOfStairs == True) )
			{
//				OwnerPlanningCtrl.SetFloorToDraw(m_ArrowInPlanningView.m_iPlanningFloor_1);
				OwnerPlanningCtrl.m_iLevelDisplay=m_ArrowInPlanningView.m_iPlanningFloor_1;
			}
			else
			{
//				OwnerPlanningCtrl.SetFloorToDraw(m_ArrowInPlanningView.m_iPlanningFloor_0);
				OwnerPlanningCtrl.m_iLevelDisplay=m_ArrowInPlanningView.m_iPlanningFloor_0;
			}
			m_ArrowInPlanningView.m_vPointToReach=m_PlanToFollow.PreviewNextActionPoint().Location;
			if ( m_PlanToFollow.PreviewNextActionPoint().IsA('R6Ladder') && (R6Ladder(m_PlanToFollow.PreviewNextActionPoint()).m_bIsTopOfLadder == False) )
			{
				m_ArrowInPlanningView.m_vPointToReach.Z += 100;
				vDir=m_PlanToFollow.PreviewNextActionPoint().Location + vect(0.00,0.00,100.00) - m_pActorToReach.Location;
			}
			else
			{
				vDir=m_PlanToFollow.PreviewNextActionPoint().Location - m_pActorToReach.Location;
			}
			m_ArrowInPlanningView.m_vStartLocation=m_pActorToReach.Location;
			m_rDirRot=rotator(vDir);
			if ( bFirstInit == True )
			{
				m_ArrowInPlanningView.SetRotation(m_rDirRot);
				m_ArrowInPlanningView.SetPhysics(PHYS_Projectile);
				m_ArrowInPlanningView.m_u8SpritePlanningAngle=m_rDirRot.Yaw / 255 + 64;
				m_ArrowInPlanningView.DesiredRotation=m_rDirRot;
				if ( m_PlanToFollow.GetNextPoint() != None )
				{
					if ( m_PlanToFollow.GetNextPoint().m_eMovementSpeed == 0 )
					{
						m_ArrowInPlanningView.RotationRate.Pitch=15000;
						m_ArrowInPlanningView.RotationRate.Yaw=15000;
						m_fSpeed=600.00;
					}
					else
					{
						if ( m_PlanToFollow.GetNextPoint().m_eMovementSpeed == 2 )
						{
							m_ArrowInPlanningView.RotationRate.Pitch=7500;
							m_ArrowInPlanningView.RotationRate.Yaw=7500;
							m_fSpeed=250.00;
						}
						else
						{
							m_ArrowInPlanningView.RotationRate.Pitch=11000;
							m_ArrowInPlanningView.RotationRate.Yaw=11000;
							m_fSpeed=350.00;
						}
					}
				}
			}
			else
			{
				m_ArrowInPlanningView.SetPhysics(PHYS_Rotating);
				m_ArrowInPlanningView.DesiredRotation=m_rDirRot;
				m_ArrowInPlanningView.DesiredRotation.Pitch=m_rDirRot.Pitch & 65535;
				m_ArrowInPlanningView.DesiredRotation.Yaw=m_rDirRot.Yaw & 65535;
				m_ArrowInPlanningView.DesiredRotation.Roll=m_rDirRot.Roll;
			}
			m_ArrowInPlanningView.Velocity=m_fSpeed * vector(m_rDirRot);
		}
		else
		{
			WindowConsole(PlayerController(Controller).Player.Console).Root.StopPlayMode();
			OwnerPlanningCtrl.m_bPlayMode=False;
			OwnerPlanningCtrl.StopPlayingPlanning();
			return False;
		}
		return True;
	}

	function ArrowRotationIsOK ()
	{
		m_ArrowInPlanningView.SetRotation(m_rDirRot);
		m_ArrowInPlanningView.SetPhysics(PHYS_Projectile);
	}

	function ArrowReachedNavPoint ()
	{
		if ( m_PlanToFollow.m_iCurrentPathIndex == m_PlanToFollow.GetPoint().m_PathToNextPoint.Length - 1 )
		{
			m_PlanToFollow.m_iCurrentPathIndex=-1;
			m_PlanToFollow.SetToNextNode();
			if ( m_PlanToFollow.GetNextPoint() != None )
			{
				if ( m_PlanToFollow.GetNextPoint().m_eMovementSpeed == 0 )
				{
					m_ArrowInPlanningView.RotationRate.Pitch=15000;
					m_ArrowInPlanningView.RotationRate.Yaw=15000;
					m_fSpeed=600.00;
				}
				else
				{
					if ( m_PlanToFollow.GetNextPoint().m_eMovementSpeed == 2 )
					{
						m_ArrowInPlanningView.RotationRate.Pitch=7500;
						m_ArrowInPlanningView.RotationRate.Yaw=7500;
						m_fSpeed=250.00;
					}
					else
					{
						m_ArrowInPlanningView.RotationRate.Pitch=11000;
						m_ArrowInPlanningView.RotationRate.Yaw=11000;
						m_fSpeed=350.00;
					}
				}
			}
		}
		else
		{
			m_PlanToFollow.m_iCurrentPathIndex++;
		}
		if ( ChangeArrowParameters() == False )
		{
			GotoState('None');
		}
	}

	function EndState ()
	{
		m_ArrowInPlanningView.GotoState('None');
	}

	function BeginState ()
	{
		m_ArrowInPlanningView.GotoState('FollowPath');
		ChangeArrowParameters(True);
	}

}

defaultproperties
{
    m_fSpeed=300.00
    m_bCanProne=False
    bCanStrafe=True
    MenuName="Planning Assistant"
    CollisionHeight=80.00
    KParams=KarmaParamsSkel'KarmaParamsSkel283'
}
