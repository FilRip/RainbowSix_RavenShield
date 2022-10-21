//================================================================================
// R6MissionObjectiveBase.
//================================================================================
class R6MissionObjectiveBase extends Object
	Abstract
//	Export
	EditInLineNew
	HideCategories(Object);

var int m_iCountdown;
var bool m_bFailed;
var bool m_bCompleted;
var() bool m_bVisibleInMenu;
var() bool m_bIfCompletedMissionIsSuccessfull;
var() bool m_bIfFailedMissionIsAborted;
var() bool m_bMoralityObjective;
var bool m_bEndOfListOfObjectives;
var() bool m_bShowLog;
var bool m_bFeedbackOnCompletionSend;
var bool m_bFeedbackOnFailureSend;
var Actor m_mgr;
var() Sound m_sndSoundSuccess;
var() Sound m_sndSoundFailure;
var() string m_szDescription;
var() string m_szDescriptionInMenu;
var() string m_szDescriptionFailure;
var() string m_szMissionObjLocalization;
var() string m_szFeedbackOnCompletion;
var() string m_szFeedbackOnFailure;

function PawnKilled (Pawn killedPawn);

function IObjectInteract (Pawn aPawn, Actor anInteractiveObject);

function IObjectDestroyed (Pawn aPawn, Actor anInteractiveObject);

function PawnSeen (Pawn seen, Pawn witness);

function PawnHeard (Pawn seen, Pawn witness);

function PawnSecure (Pawn securedPawn);

function EnteredExtractionZone (Pawn Pawn);

function ExitExtractionZone (Pawn Pawn);

function TimerCallback (float fTime);

function ToggleLog (bool bToggle)
{
	m_bShowLog=bToggle;
}

function logMObj (string szText)
{
	Log("WARNING MissionObjective (" $ string(self.Name) $ ")" $ szText);
}

function logX (string szText)
{
	Log("" $ string(self.Name) $ ": " $ szText);
}

function Init ();

function bool isVisibleInMenu ()
{
	return m_bVisibleInMenu;
}

function bool isMissionCompletedOnSuccess ()
{
	return m_bIfCompletedMissionIsSuccessfull;
}

function bool isMissionAbortedOnFailure ()
{
	return m_bIfFailedMissionIsAborted;
}

function bool isCompleted ()
{
	return m_bCompleted;
}

function bool isFailed ()
{
	return m_bFailed;
}

function string getDescription ()
{
	return m_szDescription;
}

function int GetNumSubMission ()
{
	return 0;
}

function R6MissionObjectiveBase GetSubMissionObjective (int Index)
{
	return None;
}

function string GetDescriptionFailure ()
{
	return m_szDescriptionFailure;
}

function SetMObjMgr (Actor aMObjMgr)
{
	m_mgr=aMObjMgr;
}

function Sound GetSoundSuccess ()
{
	return m_sndSoundSuccess;
}

function Sound GetSoundFailure ()
{
	return m_sndSoundFailure;
}

function Reset ()
{
	m_bFailed=False;
	m_bCompleted=False;
	m_bFeedbackOnCompletionSend=False;
	m_bFeedbackOnFailureSend=False;
}

defaultproperties
{
    m_bVisibleInMenu=True
}