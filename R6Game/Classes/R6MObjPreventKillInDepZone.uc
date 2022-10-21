//================================================================================
// R6MObjPreventKillInDepZone.
//================================================================================
class R6MObjPreventKillInDepZone extends R6MissionObjectiveBase;

var() R6DeploymentZone m_depZone;

function Init ()
{
	local int iTotal;
	local R6Terrorist aTerrorist;

	if ( R6MissionObjectiveMgr(m_mgr).m_bEnableCheckForErrors )
	{
		if ( m_depZone != None )
		{
			if ( m_depZone.m_aTerrorist.Length == 0 )
			{
				logMObj("there is no terrorist in " $ string(m_depZone.Name));
			}
		}
	}
}

function PawnKilled (Pawn Killed)
{
	local float fNeutralized;
	local int iTotal;
	local R6Terrorist aTerrorist;
	local int i;
	local int iResult;

	if ( Killed.m_ePawnType != 2 )
	{
		return;
	}
	if ( m_depZone != None )
	{
		aTerrorist=R6Terrorist(Killed);
		if ( m_depZone != aTerrorist.m_DZone )
		{
			return;
		}
		if (  !aTerrorist.IsAlive() )
		{
			if ( m_bShowLog )
			{
				logX("PawnKilled failed=" $ string(m_bFailed));
			}
			R6MissionObjectiveMgr(m_mgr).SetMissionObjCompleted(self,False,True);
		}
	}
}

defaultproperties
{
    m_bVisibleInMenu=False
    m_bIfFailedMissionIsAborted=True
    m_szDescription="Dont kill pawn in this depzone"
}