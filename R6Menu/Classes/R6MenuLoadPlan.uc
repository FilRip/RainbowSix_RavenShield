//================================================================================
// R6MenuLoadPlan.
//================================================================================
class R6MenuLoadPlan extends UWindowDialogClientWindow;

var int m_IBXPos;
var int m_IBYPos;
var R6WindowTextListBox m_pListOfSavedPlan;
var R6WindowButton m_BDeletePlan;

function Created ()
{
	m_BDeletePlan=R6WindowButton(CreateControl(Class'R6WindowButton',m_IBXPos,WinHeight - R6MenuRSLookAndFeel(LookAndFeel).m_RSquareBgLeft.H - m_IBYPos,WinWidth - m_IBXPos,R6MenuRSLookAndFeel(LookAndFeel).m_RSquareBgLeft.H));
	m_BDeletePlan.m_buttonFont=Root.Fonts[6];
	m_BDeletePlan.m_fLMarge=4.00;
	m_BDeletePlan.m_fRMarge=4.00;
	m_BDeletePlan.Align=TA_Left;
	m_BDeletePlan.m_bDrawSpecialBorder=True;
	m_BDeletePlan.m_bDrawBorders=True;
	m_BDeletePlan.Text=Localize("POPUP","DELETEPLANBUTTON","R6Menu");
	m_BDeletePlan.ResizeToText();
	m_pListOfSavedPlan=R6WindowTextListBox(CreateWindow(Class'R6WindowTextListBox',0.00,0.00,WinWidth,m_BDeletePlan.WinTop));
	m_pListOfSavedPlan.ListClass=Class'R6WindowListBoxItem';
	m_pListOfSavedPlan.m_Font=Root.Fonts[6];
	m_pListOfSavedPlan.Register(self);
	m_pListOfSavedPlan.m_fXItemOffset=5.00;
	m_pListOfSavedPlan.m_DoubleClickClient=OwnerWindow;
	m_pListOfSavedPlan.m_bSkipDrawBorders=True;
	m_pListOfSavedPlan.m_fItemHeight=10.00;
}

function Resized ()
{
	m_BDeletePlan.WinTop=WinHeight - R6MenuRSLookAndFeel(LookAndFeel).m_RSquareBgLeft.H - m_IBYPos;
	m_pListOfSavedPlan.SetSize(WinWidth,m_BDeletePlan.WinTop);
}

function Notify (UWindowDialogControl C, byte E)
{
	local string DelPlanMsg;

	if ( (E == 2) && (C == m_BDeletePlan) )
	{
		if ( m_pListOfSavedPlan.m_SelectedItem != None )
		{
			DelPlanMsg=Localize("POPUP","DelPlanMsg","R6Menu") @ ":" @ m_pListOfSavedPlan.m_SelectedItem.HelpText @ "\n" @ Localize("POPUP","DelPlanQuestion","R6Menu");
//			R6MenuRootWindow(Root).SimplePopUp(Localize("POPUP","DelPlan","R6Menu"),DelPlanMsg,35);
		}
	}
}

defaultproperties
{
    m_IBXPos=6
    m_IBYPos=4
}
