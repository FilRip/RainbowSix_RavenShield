//================================================================================
// R6IOSlidingWindow.
//================================================================================
class R6IOSlidingWindow extends R6IActionObject;

enum eWindowCircumstantialAction {
	CA_None,
	CA_Open,
	CA_Close,
	CA_Climb,
	CA_Grenade,
	CA_OpenAndGrenade,
	CA_GrenadeFrag,
	CA_GrenadeGas,
	CA_GrenadeFlash,
	CA_GrenadeSmoke
};

enum EOpeningSide {
	Top,
	Bottom,
	Left,
	Right
};

var(R6WindowProperties) EOpeningSide eOpening;
var(R6WindowProperties) int m_iInitialOpening;
var int sm_iInitialOpening;
var(R6WindowProperties) bool m_bIsWindowLocked;
var bool sm_bIsWindowLocked;
var bool m_bIsWindowClosed;
var float C_fWindowOpen;
var(R6WindowProperties) float m_iMaxOpening;
var float m_TotalMovement;
var Vector sm_Location;

simulated function SaveOriginalData ()
{
	if ( m_bResetSystemLog )
	{
		LogResetSystem(True);
	}
	Super.SaveOriginalData();
	sm_Location=Location;
	sm_iInitialOpening=m_iInitialOpening;
	sm_bIsWindowLocked=m_bIsWindowLocked;
}

simulated function ResetOriginalData ()
{
	local Vector vNewLocation;
	local Vector vX;
	local Vector vY;
	local Vector vZ;

	if ( m_bResetSystemLog )
	{
		LogResetSystem(False);
	}
	Super.ResetOriginalData();
	m_ActionInstigator=None;
	SetLocation(sm_Location);
	m_iInitialOpening=sm_iInitialOpening;
	m_bIsWindowLocked=sm_bIsWindowLocked;
	if ( m_iInitialOpening > 0 )
	{
		vNewLocation=Location;
		GetAxes(Rotation,vX,vY,vZ);
		switch (eOpening)
		{
/*			case 0:
			m_TotalMovement=m_iInitialOpening;
			vNewLocation.Z=Location.Z + m_iInitialOpening;
			break;
			case 1:
			m_TotalMovement=m_iMaxOpening - m_iInitialOpening;
			vNewLocation.Z=Location.Z - m_iInitialOpening;
			break;
			case 2:
			m_TotalMovement=m_iMaxOpening - m_iInitialOpening;
			vNewLocation=Location - m_iInitialOpening * vX;
			break;
			case 3:
			m_TotalMovement=m_iInitialOpening;
			vNewLocation=Location + m_iInitialOpening * vX;
			break;
			default:      */
		}
		SetLocation(vNewLocation);
	}
	m_bIsWindowClosed=m_iInitialOpening > 0;
}

function bool startAction (float fDeltaMouse, Actor actionInstigator)
{
	if ( m_ActionInstigator != None )
	{
		return False;
	}
	m_ActionInstigator=actionInstigator;
	return updateAction(fDeltaMouse,actionInstigator);
}

function bool updateAction (float fDeltaMouse, Actor actionInstigator)
{
	local Vector vNewLocation;
	local Vector vX;
	local Vector vY;
	local Vector vZ;
	local float fWindowMovement;

	if ( actionInstigator != m_ActionInstigator )
	{
		return False;
	}
	fWindowMovement=FClamp(Abs(fDeltaMouse),m_fMinMouseMove,m_fMaxMouseMove);
	fWindowMovement=fWindowMovement * m_iMaxOpening / m_fMaxMouseMove;
	if ( (Default.Mass != 0) && (Mass != 0) )
	{
		fWindowMovement=fWindowMovement * Default.Mass / Mass;
	}
	if ( fDeltaMouse < 0 )
	{
		fWindowMovement=fWindowMovement * -1.00;
	}
	m_TotalMovement=m_TotalMovement + fWindowMovement;
	if ( m_TotalMovement < 0 )
	{
		fWindowMovement=fWindowMovement - m_TotalMovement;
		m_TotalMovement=0.00;
	}
	else
	{
		if ( m_TotalMovement > m_iMaxOpening )
		{
			fWindowMovement=fWindowMovement - m_TotalMovement - m_iMaxOpening;
			m_TotalMovement=m_iMaxOpening;
		}
	}
	GetAxes(Rotation,vX,vY,vZ);
	vNewLocation=Location;
	switch (eOpening)
	{
/*		case 0:
		vNewLocation.Z=Location.Z + fWindowMovement;
		break;
		case 1:
		vNewLocation.Z=Location.Z + fWindowMovement;
		break;
		case 2:
		case 3:
		vNewLocation=Location + fWindowMovement * vX;
		break;
		default: */
	}
	SetLocation(vNewLocation);
	return True;
}

function endAction ()
{
	m_ActionInstigator=None;
}

event R6QueryCircumstantialAction (float fDistance, out R6AbstractCircumstantialActionQuery Query, PlayerController PlayerController)
{
	local bool bIsOpen;

	if ( m_TotalMovement > m_iMaxOpening * C_fWindowOpen )
	{
		Query.iHasAction=1;
		bIsOpen=True;
	}
	else
	{
		Query.iHasAction=0;
		bIsOpen=False;
	}
	if ( fDistance < m_fCircumstantialActionRange )
	{
		Query.iInRange=1;
	}
	else
	{
		Query.iInRange=0;
	}
//	Query.textureIcon=Texture'Climb';
	if ( bIsOpen )
	{
		Query.iPlayerActionID=2;
		Query.iTeamActionID=2;
		Query.iTeamActionIDList[0]=2;
		Query.iTeamActionIDList[1]=4;
		Query.iTeamActionIDList[2]=0;
		Query.iTeamActionIDList[3]=0;
		R6FillSubAction(Query,0,0);
		R6FillGrenadeSubAction(Query,1);
		R6FillSubAction(Query,2,0);
		R6FillSubAction(Query,3,0);
	}
	else
	{
		Query.iPlayerActionID=1;
		Query.iTeamActionID=1;
		Query.iTeamActionIDList[0]=1;
		Query.iTeamActionIDList[1]=5;
		Query.iTeamActionIDList[2]=0;
		Query.iTeamActionIDList[3]=0;
		R6FillSubAction(Query,0,0);
		R6FillGrenadeSubAction(Query,1);
		R6FillSubAction(Query,2,0);
		R6FillSubAction(Query,3,0);
	}
}

function R6FillGrenadeSubAction (out R6AbstractCircumstantialActionQuery Query, int iSubMenu)
{
	local int i;
	local int j;

	if ( R6ActionCanBeExecuted(6) )
	{
		Query.iTeamSubActionsIDList[iSubMenu * 4 + i]=6;
		i++;
	}
	if ( R6ActionCanBeExecuted(7) )
	{
		Query.iTeamSubActionsIDList[iSubMenu * 4 + i]=7;
		i++;
	}
	if ( R6ActionCanBeExecuted(8) )
	{
		Query.iTeamSubActionsIDList[iSubMenu * 4 + i]=8;
		i++;
	}
	if ( R6ActionCanBeExecuted(9) )
	{
		Query.iTeamSubActionsIDList[iSubMenu * 4 + i]=9;
		i++;
	}
	for (j=i;j < 4;j++)
	{
		Query.iTeamSubActionsIDList[iSubMenu * 4 + j]=0;
	}
}

defaultproperties
{
    m_bIsWindowClosed=True
    C_fWindowOpen=0.90
    m_iMaxOpening=50.00
    RemoteRole=ROLE_SimulatedProxy
    DrawType=8
    m_eDisplayFlag=1
    bObsolete=True
    CollisionRadius=10.00
    CollisionHeight=10.00
}
