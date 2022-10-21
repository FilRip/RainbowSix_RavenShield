//================================================================================
// R6Ladder.
//================================================================================
class R6Ladder extends Ladder
	Native
	NotPlaceable;

var() bool m_bIsTopOfLadder;
var() bool m_bSingleFileFormationOnly;
var bool bShowLog;
var R6Ladder m_pOtherFloor;

replication
{
	reliable if ( Role == Role_Authority )
		m_bIsTopOfLadder;
}

simulated function Touch (Actor Other)
{
	local R6Pawn Pawn;

	Pawn=R6Pawn(Other);
	if ( (Pawn == None) ||  !Pawn.bCanClimbLadders || (Pawn.Controller == None) )
	{
		return;
	}
	if ( bShowLog )
	{
		Log(string(Pawn) $ " has touched ladder actor : " $ string(self));
	}
	Pawn.m_Ladder=self;
	if ( Pawn.Physics == 11 )
	{
		if (  !Pawn.bIsWalking &&  !m_bIsTopOfLadder )
		{
			return;
		}
		if ( Pawn.m_bIsPlayer )
		{
			if ( Pawn.m_bIsClimbingLadder )
			{
				if ( (Normal(Pawn.Acceleration) Dot Normal(MyLadder.ClimbDir) < -0.90) &&  !m_bIsTopOfLadder || (Normal(Pawn.Acceleration) Dot Normal(MyLadder.ClimbDir) > 0.90) && m_bIsTopOfLadder )
				{
					Pawn.EndClimbLadder(MyLadder);
				}
			}
		}
		else
		{
			if ( bShowLog )
			{
				Log(" pawn.m_bIsClimbingLadder =" $ string(Pawn.m_bIsClimbingLadder));
			}
			if ( Pawn.m_bIsClimbingLadder &&  !Pawn.Controller.IsInState('EndClimbingLadder') )
			{
				if ( (Pawn.Acceleration.Z > 30.00) && m_bIsTopOfLadder )
				{
					Pawn.EndClimbLadder(MyLadder);
				}
				else
				{
					if ( (Pawn.Acceleration.Z < 30.00) &&  !m_bIsTopOfLadder )
					{
						Pawn.EndClimbLadder(MyLadder);
					}
				}
			}
		}
		return;
	}
	else
	{
		if ( bShowLog )
		{
			Log(string(Pawn) $ " is not in PHYSICS_Ladder yet... for " $ string(self));
		}
		if ( Pawn.m_bIsClimbingLadder )
		{
			return;
		}
		if ( m_bIsTopOfLadder )
		{
			Pawn.PotentialClimbLadder(MyLadder);
		}
		if ( Pawn.Controller.IsInState('ApproachLadder') )
		{
			return;
		}
		if ( (Pawn.m_ePawnType != 1) && R6AIController(Pawn.Controller).CanClimbLadders(self) )
		{
			if ( m_bIsTopOfLadder && ((vector(Pawn.Rotation) Dot MyLadder.LookDir) < 0) ||  !m_bIsTopOfLadder && ((vector(Pawn.Rotation) Dot MyLadder.LookDir) > 0) )
			{
				if ( bShowLog )
				{
					Log(string(Pawn) $ " was detected by R6Ladder, climb ladder automatically...");
				}
				Pawn.Controller.NextState=Pawn.Controller.GetStateName();
				Pawn.Controller.MoveTarget=self;
				R6AIController(Pawn.Controller).GotoState('ApproachLadder');
			}
		}
	}
}

event bool SuggestMovePreparation (Pawn Other)
{
	return False;
}

defaultproperties
{
    m_eDisplayFlag=0
    bHidden=False
    bCollideActors=True
    m_bBulletGoThrough=True
    m_bSpriteShowFlatInPlanning=True
    DrawScale=2.00
    CollisionRadius=35.00
    CollisionHeight=14.00
}
/*
    Texture=Texture'R6Planning.Icons.PlanIcon_Ladder'
*/

