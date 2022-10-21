//================================================================================
// R6MObjRecon.
//================================================================================
class R6MObjRecon extends R6MissionObjectiveBase;

var() bool m_bCanKill;
var() bool m_bCanSecure;
var() bool m_bCanMakeNoise;
var() bool m_bCanSeeMe;

function Init ()
{
	m_bIfCompletedMissionIsSuccessfull=True;
}

function PawnKilled (Pawn Killed)
{
	local R6Pawn P;

	if ( m_bCanKill )
	{
		return;
	}
	P=R6Pawn(Killed);
	if ( P.m_KilledBy == None )
	{
		return;
	}
	if ( P.m_KilledBy.m_ePawnType != 1 )
	{
		return;
	}
	R6MissionObjectiveMgr(m_mgr).SetMissionObjCompleted(self,False,True);
	if ( m_bShowLog )
	{
		logX("PawnKilled. mission failed");
	}
}

function PawnSecure (Pawn securedPawn)
{
	if ( m_bCanSecure )
	{
		return;
	}
	R6MissionObjectiveMgr(m_mgr).SetMissionObjCompleted(self,False,True);
	if ( m_bShowLog )
	{
		logX("PawnSecure. mission failed");
	}
}

function PawnSeen (Pawn seen, Pawn witness)
{
	if ( m_bCanSeeMe )
	{
		return;
	}
	if ( seen.m_ePawnType != 1 )
	{
		return;
	}
	R6MissionObjectiveMgr(m_mgr).SetMissionObjCompleted(self,False,True);
	if ( m_bShowLog )
	{
		logX("PawnSeen. mission failed");
	}
}

function PawnHeard (Pawn seen, Pawn witness)
{
	if ( m_bCanMakeNoise )
	{
		return;
	}
	if ( seen.m_ePawnType != 1 )
	{
		return;
	}
	R6MissionObjectiveMgr(m_mgr).SetMissionObjCompleted(self,False,True);
	if ( m_bShowLog )
	{
		logX("PawnHeard. mission failed");
	}
}

defaultproperties
{
    m_bCanMakeNoise=True
    m_bIfCompletedMissionIsSuccessfull=True
    m_bIfFailedMissionIsAborted=True
    m_sndSoundFailure=Sound'Voices_Control_MissionFailed.Play_TeamSpotted'
    m_szDescription="Recon: don't kill anyone and don't get caugh"
    m_szDescriptionInMenu="AvoidDetection"
    m_szDescriptionFailure="YouWereDetected"
}