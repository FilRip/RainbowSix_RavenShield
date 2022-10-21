//================================================================================
// R6CircumstantialActionQuery.
//================================================================================
class R6CircumstantialActionQuery extends R6AbstractCircumstantialActionQuery;
//	NoNativeReplication;

var bool bShowLog;
var bool m_bNeedsTick;

simulated event Tick (float fDelta)
{
	local R6PlayerController PlayerController;

	if ( m_bNeedsTick )
	{
		if ( Level.TimeSeconds - m_fPressedTime >= 0.40 )
		{
			PlayerController=R6PlayerController(aQueryOwner);
			if ( (iInRange == 1) && bCanBeInterrupted )
			{
				PlayerController.m_InteractionCA.PerformCircumstantialAction(CACTION_Player);
			}
			else
			{
				if ( (iInRange == 0) && (iTeamActionIDList[0] != 0) && PlayerController.CanIssueTeamOrder() )
				{
					if ( bShowLog )
					{
						Log("**** Displaying rose des vents ! ****");
					}
					PlayerController.m_InteractionCA.DisplayMenu(True);
				}
			}
			m_bNeedsTick=False;
		}
	}
}

simulated function ClientPerformCircumstantialAction ()
{
	if ( bShowLog )
	{
		Log("R6CAQ **** Executing player action ! ****");
	}
	R6PlayerController(aQueryOwner).m_InteractionCA.PerformCircumstantialAction(CACTION_Player);
}

simulated function ClientDisplayMenu (bool bDisplay)
{
	if ( bShowLog )
	{
		Log("setting DisplayMenu " $ string(bDisplay));
	}
	R6PlayerController(aQueryOwner).m_InteractionCA.DisplayMenu(bDisplay);
}
