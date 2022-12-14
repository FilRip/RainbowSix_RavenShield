//================================================================================
// R6RainbowOtherTeamVoices2.
//================================================================================
class R6RainbowOtherTeamVoices2 extends R6RainbowOtherTeamVoices;

function Init (Actor aActor)
{
	Super.Init(aActor);
	aActor.AddSoundBankName("Voices_OtherTeam2");
}

defaultproperties
{
    m_sndSniperHasTarget=Sound'Voices_OtherTeam2.Play_Other2_Sniper_Hot'
    m_sndSniperLooseTarget=Sound'Voices_OtherTeam2.Play_Other2_Sniper_Cold'
    m_sndSniperTangoDown=Sound'Voices_OtherTeam2.Play_Other2_Sniper_TangoDown'
    m_sndMemberDown=Sound'Voices_OtherTeam2.Play_Other2_ManDown'
    m_sndRainbowHitRainbow=Sound'Voices_OtherTeam2.Play_Other2_FriendlyFire'
    m_sndObjective1=Sound'Voices_OtherTeam2.Play_Other2_Objective1'
    m_sndObjective2=Sound'Voices_OtherTeam2.Play_Other2_Objective2'
    m_sndObjective3=Sound'Voices_OtherTeam2.Play_Other2_Objective3'
    m_sndObjective4=Sound'Voices_OtherTeam2.Play_Other2_Objective4'
    m_sndObjective5=Sound'Voices_OtherTeam2.Play_Other2_Objective5'
    m_sndObjective6=Sound'Voices_OtherTeam2.Play_Other2_Objective6'
    m_sndObjective7=Sound'Voices_OtherTeam2.Play_Other2_Objective7'
    m_sndObjective8=Sound'Voices_OtherTeam2.Play_Other2_Objective8'
    m_sndObjective9=Sound'Voices_OtherTeam2.Play_Other2_Objective9'
    m_sndWaitAlpha=Sound'Voices_OtherTeam2.Play_Other2_WaitingAlpha'
    m_sndWaitBravo=Sound'Voices_OtherTeam2.Play_Other2_WaitingBravo'
    m_sndWaitCharlie=Sound'Voices_OtherTeam2.Play_Other2_WaitingCharlie'
    m_sndWaitZulu=Sound'Voices_OtherTeam2.Play_Other2_WaitingZulu'
    m_sndEntersGas=Sound'Voices_OtherTeam2.Play_Other2_Gagging'
    m_sndPlacingBug=Sound'Voices_OtherTeam2.Play_Other2_PlacingBug'
    m_sndBugActivated=Sound'Voices_OtherTeam2.Play_Other2_BugActivated'
    m_sndComputerHacked=Sound'Voices_OtherTeam2.Play_Other2_FilesDownload'
    m_sndEscortingHostage=Sound'Voices_OtherTeam2.Play_Other2_EscortHost'
    m_sndHostageSecured=Sound'Voices_OtherTeam2.Play_Other2_HostSecured'
    m_sndPlacingExplosives=Sound'Voices_OtherTeam2.Play_Other2_PlacingExplosives'
    m_sndExplosivesReady=Sound'Voices_OtherTeam2.Play_Other2_ExplosivesReady'
    m_sndDesactivatingSecurity=Sound'Voices_OtherTeam2.Play_Other2_DeactSecurity'
    m_sndSecurityDeactivated=Sound'Voices_OtherTeam2.Play_Other2_SecurityDeactivated'
    m_sndStatusEngaging=Sound'Voices_OtherTeam2.Play_Other2_Engaging'
    m_sndStatusMoving=Sound'Voices_OtherTeam2.Play_Other2_Moving'
    m_sndStatusWaiting=Sound'Voices_OtherTeam2.Play_Other2_Waiting'
    m_sndStatusWaitAlpha=Sound'Voices_OtherTeam2.Play_Other2_WaitingAlpha'
    m_sndStatusWaitBravo=Sound'Voices_OtherTeam2.Play_Other2_WaitingBravo'
    m_sndStatusWaitCharlie=Sound'Voices_OtherTeam2.Play_Other2_WaitingCharlie'
    m_sndStatusWaitZulu=Sound'Voices_OtherTeam2.Play_Other2_WaitingZulu'
    m_sndStatusSniperWaitAlpha=Sound'Voices_OtherTeam2.Play_Other2_SnipingAlpha'
    m_sndStatusSniperWaitBravo=Sound'Voices_OtherTeam2.Play_Other2_SnipingBravo'
    m_sndStatusSniperWaitCharlie=Sound'Voices_OtherTeam2.Play_Other2_SnipingCharlie'
    m_sndStatusSniperUntilAlpha=Sound'Voices_OtherTeam2.Play_Other2_SnipingUntilAlpha'
    m_sndStatusSniperUntilBravo=Sound'Voices_OtherTeam2.Play_Other2_SnipingUntilBravo'
    m_sndStatusSniperUntilCharlie=Sound'Voices_OtherTeam2.Play_Other2_SnipingUntilCharlie'
}