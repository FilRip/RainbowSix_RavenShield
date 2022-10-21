//================================================================================
// R6MObjAcceptableRainbowLosses.
//================================================================================
class R6MObjAcceptableRainbowLosses extends R6MObjAcceptableLosses;

defaultproperties
{
    m_ePawnTypeKiller=4
    m_ePawnTypeDead=1
    m_iAcceptableLost=100
    m_sndSoundFailure=Sound'Voices_Control_MissionFailed.Play_TeamWipedOut'
    m_szDescription="Acceptable rainbow losses"
    m_szDescriptionInMenu="RaibowTeamMustSurvive"
    m_szDescriptionFailure="YourTeamWasWipedOut"
}