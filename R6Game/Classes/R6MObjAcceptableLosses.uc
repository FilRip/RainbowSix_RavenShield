//================================================================================
// R6MObjAcceptableLosses.
//================================================================================
class R6MObjAcceptableLosses extends R6MissionObjectiveBase
	Abstract;

enum EPawnType {
	PAWN_NotDefined,
	PAWN_Rainbow,
	PAWN_Terrorist,
	PAWN_Hostage,
	PAWN_All
};

var EPawnType m_ePawnTypeKiller;
var EPawnType m_ePawnTypeDead;
var() int m_iAcceptableLost;
var int m_iKillerTeamID;
var() bool m_bConsiderSuicide;

function Reset ()
{
	Super.Reset();
	m_iKillerTeamID=Default.m_iKillerTeamID;
}

function PawnKilled (Pawn Killed)
{
	local int iLost;
	local R6Pawn aPawn;
	local float fTotal;

	if ( Killed.m_ePawnType != m_ePawnTypeDead )
	{
		return;
	}
	if ( m_iKillerTeamID != -1 )
	{
		aPawn=R6Pawn(Killed);
		if ( aPawn.m_KilledBy.m_iTeam != m_iKillerTeamID )
		{
			return;
		}
	}
	foreach m_mgr.DynamicActors(Class'R6Pawn',aPawn)
	{
		if ( aPawn.m_ePawnType != m_ePawnTypeDead )
		{
			continue;
		}
		else
		{
			if ( aPawn.m_ePawnType == 3 )
			{
				if ( R6Hostage(Killed).m_bCivilian != R6Hostage(aPawn).m_bCivilian )
				{
					continue;
				}
				else
				{
					fTotal += 1;
					if ( aPawn.IsAlive() )
					{
						continue;
					}
					else
					{
						if ( m_bConsiderSuicide && aPawn.m_bSuicided || (aPawn.m_bSuicided == False) && (m_ePawnTypeKiller == 4) || (aPawn.m_KilledBy.m_ePawnType == m_ePawnTypeKiller) )
						{
							if ( (m_iKillerTeamID == -1) || (aPawn.m_KilledBy.m_iTeam == m_iKillerTeamID) )
							{
								iLost += 1;
							}
						}
					}
				}
			}
		}
	}
	iLost=iLost / fTotal * 100.00;
	if ( (iLost >= 100) || (iLost > 0) && (iLost > m_iAcceptableLost) )
	{
		if ( m_bShowLog )
		{
			logX(" failed: iLost > m_iAcceptableLost=" $ string(iLost > m_iAcceptableLost));
		}
		R6MissionObjectiveMgr(m_mgr).SetMissionObjCompleted(self,False,True);
	}
	if ( m_bShowLog )
	{
		aPawn=R6Pawn(Killed);
		logX("PawnKilled failed=" $ string(m_bFailed) $ " " $ string(Killed.Name) $ " was killed by " $ string(aPawn.m_KilledBy.Name) $ " lost=" $ string(iLost) $ " acceptable=" $ string(m_iAcceptableLost));
	}
}

defaultproperties
{
    m_iKillerTeamID=-1
    m_bConsiderSuicide=True
    m_bIfFailedMissionIsAborted=True
    m_bMoralityObjective=True
}
