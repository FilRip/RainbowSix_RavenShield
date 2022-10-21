//================================================================================
// R6MObjAcceptableCivilianLossesByRainbow.
//================================================================================
class R6MObjAcceptableCivilianLossesByRainbow extends R6MObjAcceptableLosses;

#exec OBJ LOAD FILE=..\Sounds\Voices_Control_MissionFailed.uax PACKAGE=Voices_Control_MissionFailed

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
			m_szDescriptionFailure="PolicemanWasKilledByRainbow";
			m_sndSoundFailure=Sound'Voices_Control_MissionFailed.Play_MissionFailed';
		}
		Super.PawnKilled(Killed);
	}
}

defaultproperties
{
    m_ePawnTypeKiller=1
    m_ePawnTypeDead=3
    m_sndSoundFailure=Sound'Voices_Control_MissionFailed.Play_CivilianKilled'
    m_szDescription="Acceptable civilian losses by rainbow"
    m_szDescriptionInMenu="AvoidCivilianCasualities"
    m_szDescriptionFailure="CivilianWasKilledByRainbow"
}