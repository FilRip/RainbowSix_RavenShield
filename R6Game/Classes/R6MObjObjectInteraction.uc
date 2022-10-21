//================================================================================
// R6MObjObjectInteraction.
//================================================================================
class R6MObjObjectInteraction extends R6MissionObjectiveBase;

var() bool m_bIfDeviceIsActivatedObjectiveIsCompleted;
var() bool m_bIfDeviceIsActivatedObjectiveIsFailed;
var() bool m_bIfDeviceIsDeactivatedObjectiveIsCompleted;
var() bool m_bIfDeviceIsDeactivatedObjectiveIsFailed;
var() bool m_bIfDestroyedObjectiveIsCompleted;
var() bool m_bIfDestroyedObjectiveIsFailed;
var() R6IOObject m_r6IOObject;

function Init ()
{
	if ( R6MissionObjectiveMgr(m_mgr).m_bEnableCheckForErrors )
	{
		if ( m_r6IOObject == None )
		{
			logMObj("m_r6IOObject not specified");
		}
		if ( m_bIfDestroyedObjectiveIsCompleted && m_bIfDestroyedObjectiveIsFailed )
		{
			logMObj("both are set to true m_bIfDestroyedObjectiveIsCompleted, m_bIfDestroyedObjectiveIsFailed");
		}
	}
}

function IObjectInteract (Pawn aPawn, Actor anInteractiveObject)
{
	if ( m_r6IOObject != anInteractiveObject )
	{
		return;
	}
	if ( m_r6IOObject.m_bIsActivated )
	{
		if ( m_bIfDeviceIsActivatedObjectiveIsCompleted )
		{
			R6MissionObjectiveMgr(m_mgr).SetMissionObjCompleted(self,True,True);
		}
		else
		{
			if ( m_bIfDeviceIsActivatedObjectiveIsFailed )
			{
				R6MissionObjectiveMgr(m_mgr).SetMissionObjCompleted(self,False,True);
			}
		}
	}
	else
	{
		if ( m_bIfDeviceIsDeactivatedObjectiveIsCompleted )
		{
			R6MissionObjectiveMgr(m_mgr).SetMissionObjCompleted(self,True,True);
		}
		else
		{
			if ( m_bIfDeviceIsDeactivatedObjectiveIsFailed )
			{
				R6MissionObjectiveMgr(m_mgr).SetMissionObjCompleted(self,False,True);
			}
		}
	}
}

function IObjectDestroyed (Pawn aPawn, Actor anInteractiveObject)
{
	if ( m_r6IOObject != anInteractiveObject )
	{
		return;
	}
	if ( m_bIfDestroyedObjectiveIsCompleted )
	{
		R6MissionObjectiveMgr(m_mgr).SetMissionObjCompleted(self,True,True);
	}
	else
	{
		if ( m_bIfDestroyedObjectiveIsFailed )
		{
			R6MissionObjectiveMgr(m_mgr).SetMissionObjCompleted(self,False,True);
		}
	}
}

defaultproperties
{
    m_sndSoundFailure=Sound'Voices_Control_MissionFailed.Play_MissionFailed'
    m_szDescription="Interact with object"
}