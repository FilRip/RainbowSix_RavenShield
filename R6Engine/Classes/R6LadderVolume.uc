//================================================================================
// R6LadderVolume.
//================================================================================
class R6LadderVolume extends LadderVolume
	Native;

enum eLadderCircumstantialAction {
	CAL_None,
	CAL_Climb
};

enum eLadderEndDirection {
	LDR_Forward,
	LDR_Right,
	LDR_Left
};

var() eLadderEndDirection m_eLadderEndDirection;
var(Debug) bool bShowLog;
var float m_fBottomLadderActionRange;
const C_iMaxClimbers= 6;
var R6Ladder m_TopLadder;
var R6Ladder m_BottomLadder;
var R6LadderCollision m_TopCollision;
var R6LadderCollision m_BottomCollision;
var R6Pawn m_Climber[6];
var(R6Sound) Sound m_SlideSound;
var(R6Sound) Sound m_SlideSoundStop;
var(R6Sound) Sound m_HandSound;
var(R6Sound) Sound m_FootSound;

simulated function PostBeginPlay ()
{
	Super.PostBeginPlay();
	PostNetBeginPlay();
}

simulated function PostNetBeginPlay ()
{
	local Ladder L;
	local Ladder M;
	local Vector vDir;

	if ( LadderList == None )
	{
		Log("WARNING - no Ladder actors in LadderVolume " $ string(self));
		return;
	}
	LookDir=vector(LadderList.Rotation);
	WallDir=rotator(LookDir);
	if (  !bAutoPath )
	{
		ClimbDir=vect(0.00,0.00,0.00);
		L=LadderList;
JL008D:
		if ( L != None )
		{
			M=LadderList;
JL00A3:
			if ( M != None )
			{
				if ( M != L )
				{
					vDir=Normal(M.Location - L.Location);
					if ( vDir Dot ClimbDir < 0 )
					{
						vDir *= -1;
					}
					ClimbDir += vDir;
					if ( M.Location.Z > L.Location.Z )
					{
						m_TopLadder=R6Ladder(M);
						m_BottomLadder=R6Ladder(L);
					}
					else
					{
						m_TopLadder=R6Ladder(L);
						m_BottomLadder=R6Ladder(M);
					}
				}
				M=M.LadderList;
				goto JL00A3;
			}
			L=L.LadderList;
			goto JL008D;
		}
		ClimbDir=Normal(ClimbDir);
		if ( ClimbDir Dot vect(0.00,0.00,1.00) < 0 )
		{
			ClimbDir *= -1;
		}
	}
	ClimbDir.X=0.00;
	ClimbDir.Y=0.00;
	if ( Level.NetMode != 3 )
	{
		if ( m_TopCollision == None )
		{
			m_TopCollision=Spawn(Class'R6LadderCollision',self,,m_TopLadder.Location - vect(0.00,0.00,239.00),rot(0,0,0));
			m_TopCollision.SetCollision(False,False,False);
		}
		if ( m_BottomCollision == None )
		{
			m_BottomCollision=Spawn(Class'R6LadderCollision',self,,m_BottomLadder.Location + vect(0.00,0.00,199.00),rot(0,0,0));
			m_BottomCollision.SetCollision(False,False,False);
		}
	}
}

function Destroyed ()
{
	if ( m_TopCollision != None )
	{
		m_TopCollision.Destroy();
		m_TopCollision=None;
	}
	if ( m_BottomCollision != None )
	{
		m_BottomCollision.Destroy();
		m_BottomCollision=None;
	}
}

simulated function ResetOriginalData ()
{
	local int i;

	if ( m_TopCollision != None )
	{
		m_TopCollision.SetCollision(False,False,False);
	}
	if ( m_BottomCollision != None )
	{
		m_BottomCollision.SetCollision(False,False,False);
	}
	i=0;
JL003B:
	if ( i < 6 )
	{
		m_Climber[i]=None;
		i++;
		goto JL003B;
	}
}

function EnableCollisions (R6Ladder Ladder)
{
	if ( Ladder == m_TopLadder )
	{
		m_TopCollision.SetCollision(True,True,True);
	}
	else
	{
		m_BottomCollision.SetCollision(True,True,True);
	}
}

function DisableCollisions (R6Ladder Ladder)
{
	if ( Ladder == m_TopLadder )
	{
		m_TopCollision.SetCollision(False,False,False);
	}
	else
	{
		m_BottomCollision.SetCollision(False,False,False);
	}
}

simulated event PawnEnteredVolume (Pawn P)
{
	local R6Pawn Pawn;
	local Rotator rPawnRot;

	Pawn=R6Pawn(P);
	if ( (Pawn == None) ||  !Pawn.bCanClimbLadders || (Pawn.Controller == None) )
	{
		return;
	}
	if ( P.IsPlayerPawn() )
	{
		TriggerEvent(Event,P,P);
	}
	rPawnRot=Pawn.Rotation;
	rPawnRot.Pitch=0;
	if ( (vector(rPawnRot) Dot LookDir) > 0.90 )
	{
		if ( Pawn.m_bIsClimbingLadder )
		{
			return;
		}
		Pawn.PotentialClimbLadder(self);
	}
	else
	{
		SetPotentialClimber();
	}
}

simulated event PawnLeavingVolume (Pawn P)
{
	if ( P.IsPlayerPawn() )
	{
		UntriggerEvent(Event,P,P);
	}
	if ( P.Physics == 11 )
	{
		P.EndClimbLadder(self);
	}
	else
	{
		R6Pawn(P).RemovePotentialClimbLadder(self);
	}
}

simulated event SetPotentialClimber ()
{
	GotoState('PotentialClimb');
}

state PotentialClimb
{
	simulated function Tick (float fDeltaTime)
	{
		local Rotator rPawnRot;
		local R6Pawn Pawn;
		local bool bFound;

		foreach TouchingActors(Class'R6Pawn',Pawn)
		{
			if ( (Pawn.Controller != None) && (Pawn.Physics != 11) )
			{
				if ( Encompasses(Pawn) )
				{
					rPawnRot=Pawn.Rotation;
					rPawnRot.Pitch=0;
					if ( (vector(rPawnRot) Dot LookDir) > 0.90 )
					{
						if (  !Pawn.m_bIsClimbingLadder )
						{
							Pawn.PotentialClimbLadder(self);
						}
					}
					else
					{
						bFound=True;
					}
				}
			}
		}
		if (  !bFound )
		{
			GotoState('None');
		}
	}

}

simulated function AddClimber (R6Pawn P)
{
	local int i;

	if ( bShowLog )
	{
		Log(string(self) $ " AddClimber : " $ string(P));
	}
	i=0;
JL0030:
	if ( i < 6 )
	{
		if ( m_Climber[i] == P )
		{
			goto JL0083;
		}
		if ( m_Climber[i] == None )
		{
			m_Climber[i]=P;
		}
		else
		{
			i++;
			goto JL0030;
		}
	}
JL0083:
}

simulated function RemoveClimber (R6Pawn P)
{
	local int i;

	if ( bShowLog )
	{
		Log(string(self) $ " Remove Climber : " $ string(P));
	}
	i=0;
JL0034:
	if ( i < 6 )
	{
		if ( m_Climber[i] == P )
		{
			m_Climber[i]=None;
		}
		else
		{
			i++;
			goto JL0034;
		}
	}
}

function bool IsAvailable (Pawn P)
{
	local int i;

	i=0;
JL0007:
	if ( i < 6 )
	{
		if ( m_Climber[i] != None )
		{
			if (  !m_Climber[i].IsValidClimber() )
			{
				m_Climber[i]=None;
			}
			else
			{
				if ( m_Climber[i] != P )
				{
					return False;
				}
			}
		}
		i++;
		goto JL0007;
	}
	return True;
}

function bool TopOfLadderIsAccessible ()
{
	local float fTopZLimit;
	local int i;

	fTopZLimit=m_TopLadder.Location.Z - 240.00;
	i=0;
JL0027:
	if ( i < 6 )
	{
		if ( m_Climber[i] == None )
		{
			goto JL00AC;
		}
		if (  !m_Climber[i].IsValidClimber() )
		{
			m_Climber[i]=None;
		}
		else
		{
			if ( m_Climber[i].Location.Z + m_Climber[i].CollisionHeight > fTopZLimit )
			{
				return False;
			}
		}
JL00AC:
		i++;
		goto JL0027;
	}
	return True;
}

function bool BottomOfLadderIsAccessible ()
{
	local float fBottomZLimit;
	local int i;

	fBottomZLimit=m_BottomLadder.Location.Z + 200.00;
	i=0;
JL0027:
	if ( i < 6 )
	{
		if ( m_Climber[i] == None )
		{
			goto JL00AC;
		}
		if (  !m_Climber[i].IsValidClimber() )
		{
			m_Climber[i]=None;
		}
		else
		{
			if ( m_Climber[i].Location.Z - m_Climber[i].CollisionHeight < fBottomZLimit )
			{
				return False;
			}
		}
JL00AC:
		i++;
		goto JL0027;
	}
	return True;
}

function bool SpaceIsAvailableAtBottomOfLadder (optional bool bAvoidPlayerOnly)
{
	local R6Pawn Pawn;
	local Vector vDist;

	foreach TouchingActors(Class'R6Pawn',Pawn)
	{
		if (  !Pawn.IsAlive() )
		{
			continue;
		}
		else
		{
			if ( bAvoidPlayerOnly &&  !Pawn.m_bIsPlayer )
			{
				continue;
			}
			else
			{
				if ( Abs(Pawn.Location.Z - m_BottomLadder.Location.Z) > 100 )
				{
					continue;
				}
				else
				{
					vDist=Pawn.Location - m_BottomLadder.Location;
					vDist.Z=0.00;
					if ( VSize(vDist) < 90 )
					{
						return False;
					}
				}
			}
		}
	}
	return True;
}

function bool IsAShortLadder ()
{
	if ( m_TopLadder.Location.Z - m_BottomLadder.Location.Z < 340 )
	{
		return True;
	}
	return False;
}

simulated event PhysicsChangedFor (Actor Other)
{
}

simulated event R6QueryCircumstantialAction (float fDistance, out R6AbstractCircumstantialActionQuery Query, PlayerController PlayerController)
{
	local float fXYDistance;
	local Vector vLocation;
	local Vector vPawnLocation;
	local float fResult;
	local float fPawnFootZ;

	if ( R6Pawn(PlayerController.Pawn).m_bIsClimbingLadder || IsAShortLadder() &&  !IsAvailable(PlayerController.Pawn) )
	{
		Query.iHasAction=0;
		return;
	}
	vLocation=Location;
	vLocation.Z=0.00;
	vPawnLocation=PlayerController.Pawn.Location;
	vPawnLocation.Z=0.00;
	fXYDistance=VSize(vLocation - vPawnLocation);
	Query.iHasAction=1;
	fPawnFootZ=PlayerController.Pawn.Location.Z - PlayerController.Pawn.CollisionHeight;
	if ( PlayerController.Pawn.Location.Z < Location.Z )
	{
		if ( fPawnFootZ > m_BottomLadder.Location.Z )
		{
			Query.iInRange=0;
		}
		else
		{
			fResult=(vector(PlayerController.Pawn.Rotation) Dot vector(m_BottomLadder.Rotation));
			if ( fResult < 0.80 )
			{
				Query.iInRange=0;
			}
			else
			{
				if ( fXYDistance < m_fBottomLadderActionRange )
				{
					Query.iInRange=1;
					if (  !BottomOfLadderIsAccessible() )
					{
						Query.iHasAction=0;
						return;
					}
				}
				else
				{
					Query.iInRange=0;
				}
			}
		}
	}
	else
	{
		if ( fPawnFootZ > m_TopLadder.Location.Z )
		{
			Query.iInRange=0;
		}
		else
		{
			fResult=(vector(PlayerController.Pawn.Rotation) Dot  -vector(m_TopLadder.Rotation));
			if ( fResult < 0.90 )
			{
				Query.iInRange=0;
			}
			else
			{
				if ( fXYDistance < m_fCircumstantialActionRange )
				{
					Query.iInRange=1;
					if (  !TopOfLadderIsAccessible() )
					{
						Query.iHasAction=0;
						return;
					}
					if ( IsAShortLadder() )
					{
						if (  !SpaceIsAvailableAtBottomOfLadder() )
						{
							Query.iHasAction=0;
							return;
						}
					}
				}
				else
				{
					Query.iInRange=0;
				}
			}
		}
	}
//	Query.textureIcon=Texture'Climb';
	Query.iPlayerActionID=1;
	Query.iTeamActionID=1;
	Query.iTeamActionIDList[0]=1;
	Query.iTeamActionIDList[1]=0;
	Query.iTeamActionIDList[2]=0;
	Query.iTeamActionIDList[3]=0;
}

simulated function string R6GetCircumstantialActionString (int iAction)
{
	switch (iAction)
	{
		case 1:
		return Localize("RDVOrder","Order_Climb","R6Menu");
		default:
	}
	return "";
}

defaultproperties
{
    m_fBottomLadderActionRange=30.00
    bStatic=False
    m_fCircumstantialActionRange=110.00
    NetPriority=2.70
}
