//================================================================================
// R6AbstractPlanningInfo.
//================================================================================
class R6AbstractPlanningInfo extends Object
	Native;
//	Export;

enum EGoCodeState {
	GOCODESTATE_None,
	GOCODESTATE_Waiting,
	GOCODESTATE_Snipe,
	GOCODESTATE_Breach,
	GOCODESTATE_Done
};

const R6InputKey_NewNode= 1025;
var EGoCodeState m_eGoCodeState[4];
var const EMovementMode m_eDefaultMode;
var const EMovementSpeed m_eDefaultSpeed;
var const EPlanAction m_eDefaultAction;
var const EPlanActionType m_eDefaultActionType;
var int m_iCurrentNode;
var int m_iCurrentPathIndex;
var int m_iStartingPointNumber;
var int m_iNbNode;
var int m_iNbMilestone;
var int DEB_iStartTime;
var bool m_bDisplayPath;
var bool m_bPlanningOver;
var bool m_bPlacedFirstPoint;
var(Debug) bool bShowLog;
var bool bDisplayDbgInfo;
var float m_fReachRange;
var float m_fZReachRange;
var Actor m_pTeamManager;
var array<Actor> m_NodeList;
var Color m_TeamColor;

function ResetPointsOrientation ()
{
}

function NotifyActionPoint (ENodeNotify eMsg, EGoCode eCode)
{
}

function byte GetAction ()
{
	return 0;
}

function byte GetMovementMode ()
{
	return 0;
}

function byte GetMovementSpeed ()
{
	return 1;
}

function SkipCurrentDestination ();

function Actor GetFirstActionPoint ()
{
	return m_NodeList[0];
}

function Actor GetNextActionPoint ()
{
	return None;
}

function Actor PreviewNextActionPoint ()
{
	return None;
}

function byte NextActionPointHasAction (Actor aPoint)
{
	return 0;
}

function Actor GetPreviousActor ()
{
	return None;
}

function int GetActionPointID ()
{
	return 0;
}

function int GetNbActionPoint ()
{
	return 0;
}

function Vector GetActionLocation ()
{
	return vect(0.00,0.00,0.00);
}

function PlayerStart GetStartingPoint ()
{
	return None;
}

function GetSnipingCoordinates (out Vector vLocation, out Rotator rRotation)
{
}

function Actor GetDoorToBreach ()
{
	return None;
}

function Actor GetNextDoorToBreach (Actor aPoint)
{
	return None;
}

function ResetID ()
{
}

function DeleteAllNode ();
