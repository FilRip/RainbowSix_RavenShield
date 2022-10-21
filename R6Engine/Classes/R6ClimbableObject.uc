//================================================================================
// R6ClimbableObject.
//================================================================================
class R6ClimbableObject extends R6AbstractClimbableObj
	Native;

enum eClimbableObjectCircumstantialAction {
	COBJ_None,
	COBJ_Climb
};

enum EClimbHeight {
	EClimbNone,
	EClimb64,
	EClimb96
};

var(Collision) EClimbHeight m_eClimbHeight;
var R6ClimbablePoint m_climbablePoint;
var R6ClimbablePoint m_insideClimbablePoint;
var Vector m_vClimbDir;

replication
{
	reliable if ( bNetInitial && (Role == Role_Authority) )
		m_eClimbHeight,m_climbablePoint,m_vClimbDir;
}

function PostBeginPlay ()
{
	Super.PostBeginPlay();
	m_vClimbDir=vector(Rotation);
	m_vClimbDir=Normal(m_vClimbDir);
}

simulated function bool IsClimbableBy (R6Pawn P, bool bCheckCylinderTranslation, bool bCheckRotation)
{
	local Rotator rPawnRot;
	local float fFootZ;
	local float fDistance2d;
	local Vector vStart;
	local Vector vDest;
	local Vector vPawnLocation;

	if ( P.m_bIsProne || (P.m_climbObject != None) )
	{
		return False;
	}
	fFootZ=P.Location.Z - P.CollisionHeight;
	if (  !(fFootZ <= Location.Z) && (Location.Z - CollisionHeight <= fFootZ) )
	{
		return False;
	}
	rPawnRot=P.Rotation;
	rPawnRot.Pitch=0;
	if ( bCheckRotation /*&& (rPawnRot Dot m_vClimbDir) < 0*/)
	{
		return False;
	}
	else
	{
		vPawnLocation=P.Location;
		vPawnLocation.Z=Location.Z;
		fDistance2d=VSize(vPawnLocation - Location) - CollisionRadius - P.CollisionRadius;
		if ( fDistance2d > m_fCircumstantialActionRange )
		{
			return False;
		}
		else
		{
			if ( bCheckCylinderTranslation )
			{
				vDest=P.Location + vector(rPawnRot) * P.CollisionRadius * 1.90;
				vDest.Z += CollisionHeight * 2;
				vStart=P.Location;
				vStart.Z=vDest.Z;
/*				if (  !P.SetPawnScale(vStart,vDest,self) )
				{
					return False;
				}*/
			}
		}
	}
	return True;
}

event Bump (Actor Other)
{
	local R6Pawn P;

	P=R6Pawn(Other);
	if ( P == None )
	{
		return;
	}
	if ( P.m_bIsPlayer )
	{
		return;
	}
	if ( (P.Controller != None) && R6AIController(P.Controller).CanClimbObject() && IsClimbableBy(P,False,False) &&  !P.Controller.IsInState('ClimbObject') )
	{
		P.StartClimbObject(self);
	}
}

simulated event R6QueryCircumstantialAction (float fDistance, out R6AbstractCircumstantialActionQuery Query, PlayerController PlayerController)
{
	local R6Pawn P;

	P=R6Pawn(PlayerController.Pawn);
	Query.iHasAction=1;
	if ( IsClimbableBy(P,True,True) )
	{
		Query.iInRange=1;
		P.PotentialClimbableObject(self);
	}
	else
	{
		Query.iInRange=0;
		P.RemovePotentialClimbableObject(self);
	}
//	Query.textureIcon=Texture'ClimbObject';
	Query.iPlayerActionID=1;
	Query.iTeamActionID=0;
	Query.iTeamActionIDList[0]=0;
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

event Attach (Actor pActor)
{
	local R6Pawn pPawn;

	pPawn=R6Pawn(pActor);
	if ( pPawn != None )
	{
		pPawn.AttachToClimbableObject(self);
	}
}

event Detach (Actor pActor)
{
	local R6Pawn pPawn;

	pPawn=R6Pawn(pActor);
	if ( pPawn != None )
	{
		pPawn.DetachFromClimbableObject(self);
	}
}

defaultproperties
{
    bCollideActors=True
    bBlockActors=True
    bBlockPlayers=True
    bDirectional=True
    bObsolete=True
    CollisionRadius=40.00
    CollisionHeight=32.00
    m_fCircumstantialActionRange=30.00
}
