//================================================================================
// R6MenuSavePlan.
//================================================================================
class R6MenuSavePlan extends UWindowDialogClientWindow;

var int m_IBXPos;
var int m_IBYPos;
var R6WindowEditBox m_pEditSaveNameBox;
var R6WindowTextListBox m_pListOfSavedPlan;
var R6WindowButton m_BDeletePlan;
const C_iEDITBOX_HEIGHT= 24;

function Created ()
{
	m_pEditSaveNameBox=R6WindowEditBox(CreateWindow(Class'R6WindowEditBox',0.00,0.00,WinWidth,24.00));
	m_pEditSaveNameBox.TextColor=Root.Colors.White;
	m_pEditSaveNameBox.SetFont(6);
	m_pEditSaveNameBox.bCaps=False;
	m_pEditSaveNameBox.SetValue("");
	m_pEditSaveNameBox.MoveEnd();
	m_pEditSaveNameBox.MaxLength=20;
	m_pEditSaveNameBox.offset=5.00;
	m_BDeletePlan=R6WindowButton(CreateControl(Class'R6WindowButton',m_IBXPos,WinHeight - R6MenuRSLookAndFeel(LookAndFeel).m_RSquareBgLeft.H - m_IBYPos,WinWidth - m_IBXPos,R6MenuRSLookAndFeel(LookAndFeel).m_RSquareBgLeft.H));
	m_BDeletePlan.m_buttonFont=Root.Fonts[6];
	m_BDeletePlan.m_fLMarge=4.00;
	m_BDeletePlan.m_fRMarge=4.00;
	m_BDeletePlan.m_bDrawSpecialBorder=True;
	m_BDeletePlan.m_bDrawBorders=True;
	m_BDeletePlan.Align=TA_Left;
	m_BDeletePlan.Text=Localize("POPUP","DELETEPLANBUTTON","R6Menu");
	m_BDeletePlan.ResizeToText();
	m_pListOfSavedPlan=R6WindowTextListBox(CreateWindow(Class'R6WindowTextListBox',0.00,24.00,WinWidth,m_BDeletePlan.WinTop - 24));
	m_pListOfSavedPlan.ListClass=Class'R6WindowListBoxItem';
	m_pListOfSavedPlan.m_Font=Root.Fonts[6];
	m_pListOfSavedPlan.Register(self);
	m_pListOfSavedPlan.m_fXItemOffset=5.00;
	m_pListOfSavedPlan.m_DoubleClickClient=OwnerWindow;
	m_pListOfSavedPlan.m_bSkipDrawBorders=True;
	m_pListOfSavedPlan.m_fItemHeight=10.00;
}

function Paint (Canvas C, float X, float Y)
{
	C.Style=1;
	C.SetDrawColor(m_BorderColor.R,m_BorderColor.G,m_BorderColor.B);
//	DrawStretchedTexture(C,0.00,m_pListOfSavedPlan.WinTop,WinWidth,1.00,Texture'WhiteTexture');
}

function Notify (UWindowDialogControl C, byte E)
{
	local string DelPlanMsg;

	if ( E == 2 )
	{
		if ( C == m_pListOfSavedPlan )
		{
			if ( m_pListOfSavedPlan.m_SelectedItem != None )
			{
				m_pEditSaveNameBox.SetValue(m_pListOfSavedPlan.m_SelectedItem.HelpText);
			}
		}
		else
		{
			if ( C == m_BDeletePlan )
			{
				if ( m_pListOfSavedPlan.m_SelectedItem != None )
				{
					DelPlanMsg=Localize("POPUP","DelPlanMsg","R6Menu") @ ":" @ m_pListOfSavedPlan.m_SelectedItem.HelpText @ "\n" @ Localize("POPUP","DelPlanQuestion","R6Menu");
//					R6MenuRootWindow(Root).SimplePopUp(Localize("POPUP","DelPlan","R6Menu"),DelPlanMsg,36);
				}
			}
		}
	}
}

defaultproperties
{
    m_IBXPos=6
    m_IBYPos=4
}
