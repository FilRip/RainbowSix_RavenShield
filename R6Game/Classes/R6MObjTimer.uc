//================================================================================
// R6MObjTimer.
//================================================================================
class R6MObjTimer extends R6MissionObjectiveBase;

function TimerCallback (float fTime)
{
	if ( m_bShowLog )
	{
		logX("failed: timer countdown is zero");
	}
	R6MissionObjectiveMgr(m_mgr).SetMissionObjCompleted(self,False,True);
}

defaultproperties
{
    m_bIfFailedMissionIsAborted=True
    m_sndSoundFailure=Sound'Voices_Control_MissionFailed.Play_MissionFailed'
    m_szDescription="Timer countdown"
    m_szFeedbackOnFailure="TimeIsUp"
}