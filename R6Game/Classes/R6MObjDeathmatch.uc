//================================================================================
// R6MObjDeathmatch.
//================================================================================
class R6MObjDeathmatch extends R6MissionObjectiveBase;

var int m_iWinningTeam;
var int m_aLivingPlayerInTeam[48];
var bool m_bTeamDeathmatch;
var PlayerController m_winnerCtrl;

function Reset ()
{
	Super.Reset();
	m_iWinningTeam=Default.m_iWinningTeam;
	m_winnerCtrl=None;
	ResetLivingPlayerInTeam();
}

function ResetLivingPlayerInTeam ()
{
	local int i;

	for (i=0;i < 48;++i)
	{
		m_aLivingPlayerInTeam[i]=0;
	}
}

function int GetWinningTeam ()
{
	local int i;
	local int iPotentialWinner;
	local int iNbTeamAlive;

	if ( R6GameInfo(m_mgr.Level.Game).m_bCompilingStats == False )
	{
		return -1;
	}
	for (i=0;i < 48;++i)
	{
		if ( m_aLivingPlayerInTeam[i] != 0 )
		{
			iPotentialWinner=i;
			iNbTeamAlive++;
		}
	}
	if ( iNbTeamAlive == 1 )
	{
		return iPotentialWinner;
	}
	return -1;
}

function PawnKilled (Pawn killedPawn)
{
	local R6Rainbow pPawn;
	local int aPlayerAliveInTeam[2];
	local int iNbAlive;

	ResetLivingPlayerInTeam();
	foreach m_mgr.DynamicActors(Class'R6Rainbow',pPawn)
	{
		if ( pPawn.IsAlive() )
		{
			++iNbAlive;
			if ( m_bTeamDeathmatch )
			{
				if ( pPawn.m_iTeam < 48 )
				{
					++m_aLivingPlayerInTeam[pPawn.m_iTeam];
				}
			}
			if ( m_bShowLog )
			{
				if ( PlayerController(pPawn.Controller).PlayerReplicationInfo != None )
				{
					logX(PlayerController(pPawn.Controller).PlayerReplicationInfo.PlayerName $ " is alive in teamID" $ string(pPawn.m_iTeam));
				}
				else
				{
					logX(string(PlayerController(pPawn.Controller)) $ " is alive in teamID" $ string(pPawn.m_iTeam));
				}
			}
			m_winnerCtrl=PlayerController(pPawn.Controller);
		}
		else
		{
			if ( m_bShowLog )
			{
				if ( PlayerController(pPawn.Controller).PlayerReplicationInfo != None )
				{
					logX(PlayerController(pPawn.Controller).PlayerReplicationInfo.PlayerName $ " is dead");
				}
				else
				{
					logX(string(PlayerController(pPawn.Controller)) $ " is dead");
				}
			}
		}
		if (  !m_bTeamDeathmatch )
		{
			if ( iNbAlive > 1 )
			{
				if ( m_bShowLog )
				{
					logX("more than 1 player alive ");
				}
			}
			else
			{
			}
		}
	}
	if ( iNbAlive == 0 )
	{
		if ( m_bShowLog )
		{
			logX("failed: zero man standing");
		}
		R6MissionObjectiveMgr(m_mgr).SetMissionObjCompleted(self,False,True);
		return;
	}
	if ( m_bTeamDeathmatch )
	{
		m_iWinningTeam=GetWinningTeam();
		if ( m_iWinningTeam != -1 )
		{
			if ( m_bShowLog )
			{
				logX("completed, last team standing teamID=" $ string(m_iWinningTeam));
			}
			R6MissionObjectiveMgr(m_mgr).SetMissionObjCompleted(self,True,True);
		}
		else
		{
			if ( m_bShowLog )
			{
				logX("no winner yet");
			}
		}
	}
	else
	{
		if ( iNbAlive == 1 )
		{
			if ( m_bShowLog )
			{
				logX("completed, one man standing");
			}
			R6MissionObjectiveMgr(m_mgr).SetMissionObjCompleted(self,True,True);
		}
		else
		{
			if ( m_bShowLog )
			{
				logX("no winner yet");
			}
			m_winnerCtrl=None;
		}
	}
}

defaultproperties
{
    m_iWinningTeam=-1
    m_bIfCompletedMissionIsSuccessfull=True
    m_bIfFailedMissionIsAborted=True
    m_szDescription="Deathmatch: eleminate enemies"
}