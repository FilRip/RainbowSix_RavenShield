//================================================================================
// R6RainbowOtherTeamVoices1.
//================================================================================
class R6RainbowOtherTeamVoices1 extends R6RainbowOtherTeamVoices;

function Init (Actor aActor)
{
	Super.Init(aActor);
	aActor.AddSoundBankName("Voices_OtherTeam1");
}

defaultproperties
{
    m_sndSniperHasTarget=Sound'Voices_OtherTeam1.Play_Other1_Sniper_Hot'
    m_sndSniperLooseTarget=Sound'Voices_OtherTeam1.Play_Other1_Sniper_Cold'
    m_sndSniperTangoDown=Sound'Voices_OtherTeam1.Play_Other1_Sniper_TangoDown'
    m_sndMemberDown=Sound'Voices_OtherTeam1.Play_Other1_ManDown'
    m_sndRainbowHitRainbow=Sound'Voices_OtherTeam1.Play_Other1_FriendlyFire'
    m_sndObjective1=Sound'Voices_OtherTeam1.Play_Other1_Objective1'
    m_sndObjective2=Sound'Voices_OtherTeam1.Play_Other1_Objective2'
    m_sndObjective3=Sound'Voices_OtherTeam1.Play_Other1_Objective3'
    m_sndObjective4=Sound'Voices_OtherTeam1.Play_Other1_Objective4'
    m_sndObjective5=Sound'Voices_OtherTeam1.Play_Other1_Objective5'
    m_sndObjective6=Sound'Voices_OtherTeam1.Play_Other1_Objective6'
    m_sndObjective7=Sound'Voices_OtherTeam1.Play_Other1_Objective7'
    m_sndObjective8=Sound'Voices_OtherTeam1.Play_Other1_Objective8'
    m_sndObjective9=Sound'Voices_OtherTeam1.Play_Other1_Objective9'
    m_sndWaitAlpha=Sound'Voices_OtherTeam1.Play_Other1_WaitingAlpha'
    m_sndWaitBravo=Sound'Voices_OtherTeam1.Play_Other1_WaitingBravo'
    m_sndWaitCharlie=Sound'Voices_OtherTeam1.Play_Other1_WaitingCharlie'
    m_sndWaitZulu=Sound'Voices_OtherTeam1.Play_Other1_WaitingZulu'
    m_sndEntersGas=Sound'Voices_OtherTeam1.Play_Other1_Gagging'
    m_sndPlacingBug=Sound'Voices_OtherTeam1.Play_Other1_PlacingBug'
    m_sndBugActivated=Sound'Voices_OtherTeam1.Play_Other1_BugActivated'
    m_sndComputerHacked=Sound'Voices_OtherTeam1.Play_Other1_FilesDownload'
    m_sndEscortingHostage=Sound'Voices_OtherTeam1.Play_Other1_EscortHost'
    m_sndHostageSecured=Sound'Voices_OtherTeam1.Play_Other1_HostSecured'
    m_sndPlacingExplosives=Sound'Voices_OtherTeam1.Play_Other1_PlacingExplosives'
    m_sndExplosivesReady=Sound'Voices_OtherTeam1.Play_Other1_ExplosivesReady'
    m_sndDesactivatingSecurity=Sound'Voices_OtherTeam1.Play_Other1_DeactSecurity'
    m_sndSecurityDeactivated=Sound'Voices_OtherTeam1.Play_Other1_SecurityDeactivated'
    m_sndStatusEngaging=Sound'Voices_OtherTeam1.Play_Other1_Engaging'
    m_sndStatusMoving=Sound'Voices_OtherTeam1.Play_Other1_Moving'
    m_sndStatusWaiting=Sound'Voices_OtherTeam1.Play_Other1_Waiting'
    m_sndStatusWaitAlpha=Sound'Voices_OtherTeam1.Play_Other1_WaitingAlpha'
    m_sndStatusWaitBravo=Sound'Voices_OtherTeam1.Play_Other1_WaitingBravo'
    m_sndStatusWaitCharlie=Sound'Voices_OtherTeam1.Play_Other1_WaitingCharlie'
    m_sndStatusWaitZulu=Sound'Voices_OtherTeam1.Play_Other1_WaitingZulu'
    m_sndStatusSniperWaitAlpha=Sound'Voices_OtherTeam1.Play_Other1_SnipingAlpha'
    m_sndStatusSniperWaitBravo=Sound'Voices_OtherTeam1.Play_Other1_SnipingBravo'
    m_sndStatusSniperWaitCharlie=Sound'Voices_OtherTeam1.Play_Other1_SnipingCharlie'
    m_sndStatusSniperUntilAlpha=Sound'Voices_OtherTeam1.Play_Other1_SnipingUntilAlpha'
    m_sndStatusSniperUntilBravo=Sound'Voices_OtherTeam1.Play_Other1_SnipingUntilBravo'
    m_sndStatusSniperUntilCharlie=Sound'Voices_OtherTeam1.Play_Other1_SnipingUntilCharlie'
}