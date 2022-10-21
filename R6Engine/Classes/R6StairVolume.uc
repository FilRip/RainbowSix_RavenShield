//================================================================================
// R6StairVolume.
//================================================================================
class R6StairVolume extends PhysicsVolume
	Native
//	NoNativeReplication
	Placeable;

var() bool m_bCreateIcon;
var() bool m_bRestrictedSpaceAtStairLimits;
var bool m_bShowLog;
var() R6StairOrientation m_pStairOrientation;
var Vector m_vOrientationNorm;

simulated function PostBeginPlay ()
{
	if ( m_pStairOrientation == None )
	{
		Log("WARNING: " $ string(self) $ " is missing m_pStairOrientation");
	}
	else
	{
		m_vOrientationNorm=vector(m_pStairOrientation.Rotation);
	}
}

simulated event PawnEnteredVolume (Pawn P)
{
	local R6Pawn thisPawn;

	thisPawn=R6Pawn(P);
	if ( thisPawn == None )
	{
		return;
	}
	Super.PawnEnteredVolume(P);
	if (  !thisPawn.m_bIsClimbingStairs )
	{
		if ( m_bShowLog )
		{
			Log("STAIR: enter");
		}
		thisPawn.m_bIsClimbingStairs=True;
		thisPawn.ClimbStairs(m_vOrientationNorm);
	}
}

simulated event PawnLeavingVolume (Pawn P)
{
	local R6Pawn thisPawn;
	local Vector vDirection;

	thisPawn=R6Pawn(P);
	if ( thisPawn == None )
	{
		return;
	}
	Super.PawnLeavingVolume(P);
	if ( m_bShowLog )
	{
		Log("STAIR: leave");
	}
	if ( thisPawn.m_bIsClimbingStairs )
	{
		thisPawn.m_bIsClimbingStairs=False;
		thisPawn.EndClimbStairs();
	}
}

defaultproperties
{
    m_bCreateIcon=True
}
