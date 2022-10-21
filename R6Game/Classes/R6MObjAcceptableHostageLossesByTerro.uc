//================================================================================
// R6MObjAcceptableHostageLossesByTerro.
//================================================================================
class R6MObjAcceptableHostageLossesByTerro extends R6MObjAcceptableLosses;

function PawnKilled (Pawn Killed)
{
	local R6Hostage H;

	if ( Killed.m_ePawnType != m_ePawnTypeDead )
	{
		return;
	}
	H=R6Hostage(Killed);
	if (  !H.m_bCivilian )
	{
		Super.PawnKilled(Killed);
	}
}

defaultproperties
{
    m_ePawnTypeKiller=2
    m_ePawnTypeDead=3
    m_sndSoundFailure=Sound'Voices_Control_MissionFailed.Play_HostageKilled'
    m_szDescription="Acceptable hostage losses by terro"
    m_szDescriptionInMenu="AvoidHostageCasualities"
    m_szDescriptionFailure="HostageWasKilledByTerro"
}