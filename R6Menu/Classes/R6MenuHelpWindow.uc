//================================================================================
// R6MenuHelpWindow.
//================================================================================
class R6MenuHelpWindow extends R6WindowSimpleFramedWindowExt;

var bool m_bForceRefreshOnSameTip;

function Created ()
{
	local UWindowWrappedTextArea pHelpZone;
	local float fWidth;

	fWidth=1.00;
	m_ClientArea=CreateWindow(Class'UWindowWrappedTextArea',0.00,0.00,WinWidth,WinHeight,OwnerWindow);
	SetBorderParam(0,7.00,0.00,fWidth,Root.Colors.White);
	SetBorderParam(1,7.00,0.00,fWidth,Root.Colors.White);
	ActiveBorder(2,False);
	ActiveBorder(3,False);
	ActiveBackGround(True,Root.Colors.Black);
//	m_eCornerType=3;
	SetCornerColor(3,Root.Colors.White);
	pHelpZone=UWindowWrappedTextArea(m_ClientArea);
	pHelpZone.SetScrollable(False);
}

function ToolTip (string strTip)
{
	if ( (strTip != ToolTipString) || m_bForceRefreshOnSameTip )
	{
		ToolTipString=strTip;
		UWindowWrappedTextArea(m_ClientArea).Clear();
		if ( ToolTipString != "" )
		{
			UWindowWrappedTextArea(m_ClientArea).m_fXOffSet=5.00;
			UWindowWrappedTextArea(m_ClientArea).m_fYOffSet=5.00;
			UWindowWrappedTextArea(m_ClientArea).AddText(ToolTipString,Root.Colors.ToolTipColor,Root.Fonts[12]);
		}
	}
}

function AddTipText (string _szNewText)
{
	UWindowWrappedTextArea(m_ClientArea).AddText(_szNewText,Root.Colors.ToolTipColor,Root.Fonts[12]);
}
