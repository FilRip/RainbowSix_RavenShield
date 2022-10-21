//================================================================================
// R6MObjAcceptableCivilianLossesByTerro.
//================================================================================
class R6MObjAcceptableCivilianLossesByTerro extends R6MObjAcceptableLosses;

function PawnKilled (Pawn Killed)
{
	local R6Hostage H;

	if ( Killed.m_ePawnType != m_ePawnTypeDead )
	{
		return;
	}
	H=R6Hostage(Killed);
	if ( H.m_bCivilian )
	{
		if ( H.m_bPoliceManMp1 )
		{
			m_szDescriptionFailure="PolicemanWasKilledByTerro";
		}
		Super.PawnKilled(Killed);
	}
}

defaultproperties
{
    m_ePawnTypeKiller=2
    m_ePawnTypeDead=3
    m_sndSoundFailure=Sound'Voices_Control_MissionFailed.Play_MissionFailed'
    m_szDescription="Acceptable civilian losses by terro"
    m_szDescriptionFailure="CivilianWasKilledByTerro"
}