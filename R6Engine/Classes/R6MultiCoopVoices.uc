//================================================================================
// R6MultiCoopVoices.
//================================================================================
class R6MultiCoopVoices extends R6Voices;

enum ERainbowTeamVoices {
	RTV_PlacingBug,
	RTV_BugActivated,
	RTV_AccessingComputer,
	RTV_ComputerHacked,
	RTV_EscortingHostage,
	RTV_HostageSecured,
	RTV_PlacingExplosives,
	RTV_ExplosivesReady,
	RTV_DesactivatingSecurity,
	RTV_SecurityDeactivated,
	RTV_GasThreat,
	RTV_GrenadeThreat
};

var Sound m_sndPlacingBug;
var Sound m_sndBugActivated;
var Sound m_sndAccessingComputer;
var Sound m_sndComputerHacked;
var Sound m_sndEscortingHostage;
var Sound m_sndHostageSecured;
var Sound m_sndPlacingExplosives;
var Sound m_sndExplosivesReady;
var Sound m_sndDesactivatingSecurity;
var Sound m_sndSecurityDeactivated;

function PlayRainbowTeamVoices (R6Pawn aPawn, ERainbowTeamVoices eVoices)
{
	switch (eVoices)
	{
		case RTV_PlacingBug:
		aPawn.PlayVoices(m_sndPlacingBug,SLOT_HeadSet,10,SSTATUS_SendToPlayer,True);
		break;
		case RTV_BugActivated:
		aPawn.PlayVoices(m_sndBugActivated,SLOT_HeadSet,10,SSTATUS_SendToPlayer,True);
		break;
		case RTV_AccessingComputer:
		aPawn.PlayVoices(m_sndAccessingComputer,SLOT_HeadSet,10,SSTATUS_SendToPlayer,True);
		break;
		case RTV_ComputerHacked:
		aPawn.PlayVoices(m_sndComputerHacked,SLOT_HeadSet,10,SSTATUS_SendToPlayer,True);
		break;
		case RTV_EscortingHostage:
		aPawn.PlayVoices(m_sndEscortingHostage,SLOT_HeadSet,10,SSTATUS_SendToPlayer,True);
		break;
		case RTV_HostageSecured:
		aPawn.PlayVoices(m_sndHostageSecured,SLOT_HeadSet,10,SSTATUS_SendToAll,True);
		break;
		case RTV_PlacingExplosives:
		aPawn.PlayVoices(m_sndPlacingExplosives,SLOT_HeadSet,10,SSTATUS_SendToPlayer,True);
		break;
		case RTV_ExplosivesReady:
		aPawn.PlayVoices(m_sndExplosivesReady,SLOT_HeadSet,10,SSTATUS_SendToPlayer,True);
		break;
		case RTV_DesactivatingSecurity:
		aPawn.PlayVoices(m_sndDesactivatingSecurity,SLOT_HeadSet,10,SSTATUS_SendToPlayer,True);
		break;
		case RTV_SecurityDeactivated:
		aPawn.PlayVoices(m_sndSecurityDeactivated,SLOT_HeadSet,10,SSTATUS_SendToPlayer,True);
		break;
		default:
	}
}
