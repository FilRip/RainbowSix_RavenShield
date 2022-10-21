//================================================================================
// R6WindowMPManager.
//================================================================================
class R6WindowMPManager extends UWindowWindow;

const k_CharsForSwitchToWrapped= 30;
var R6WindowPopUpBox m_pError;
var R6WindowPopUpBox m_pLongError;

function PopUpBoxCreate ()
{
	local float fX;
	local float fY;
	local float fWidth;
	local float fHeight;
	local float fTextHeight;
	local R6WindowTextLabel pR6TextLabelTemp;
	local R6WindowWrappedTextArea pR6WrapLabelTemp;

	fTextHeight=30.00;
	fX=205.00;
	fY=170.00;
	fWidth=230.00;
	fHeight=50.00;
	m_pError=R6WindowPopUpBox(CreateWindow(Class'R6WindowPopUpBox',0.00,0.00,640.00,480.00));
	m_pError.CreateStdPopUpWindow(Localize("MultiPlayer","PopUp_Error_Title","R6Menu"),fTextHeight,fX,fY,fWidth,fHeight,2);
	m_pError.CreateClientWindow(Class'R6WindowTextLabel');
//	m_pError.m_ePopUpID=0;
	m_pError.SetPopUpResizable(True);
	pR6TextLabelTemp=R6WindowTextLabel(m_pError.m_ClientArea);
	pR6TextLabelTemp.Text="- UNREGISTERED ERROR -";
	pR6TextLabelTemp.Align=TA_Center;
	pR6TextLabelTemp.m_Font=Root.Fonts[6];
	pR6TextLabelTemp.TextColor=Root.Colors.BlueLight;
	pR6TextLabelTemp.m_BGTexture=None;
	pR6TextLabelTemp.m_HBorderTexture=None;
	pR6TextLabelTemp.m_VBorderTexture=None;
	pR6TextLabelTemp.m_TextDrawstyle=5;
	m_pError.HideWindow();
	fTextHeight=30.00;
	fX=205.00;
	fY=170.00;
	fWidth=230.00;
	fHeight=77.00;
	m_pLongError=R6WindowPopUpBox(CreateWindow(Class'R6WindowPopUpBox',0.00,0.00,640.00,480.00));
	m_pLongError.CreateStdPopUpWindow(Localize("MultiPlayer","PopUp_Error_Title","R6Menu"),fTextHeight,fX,fY,fWidth,fHeight,2);
	m_pLongError.CreateClientWindow(Class'R6WindowWrappedTextArea',False,True);
//	m_pLongError.m_ePopUpID=0;
	pR6WrapLabelTemp=R6WindowWrappedTextArea(m_pLongError.m_ClientArea);
	pR6WrapLabelTemp.SetScrollable(True);
	pR6WrapLabelTemp.m_fXOffSet=5.00;
	pR6WrapLabelTemp.m_fYOffSet=5.00;
	pR6WrapLabelTemp.AddText("- UNREGISTERED ERROR -",Root.Colors.BlueLight,Root.Fonts[6]);
	pR6WrapLabelTemp.m_bDrawBorders=False;
	m_pLongError.HideWindow();
}

function DisplayErrorMsg (string _szErrorMsg, EPopUpID _ePopUpID)
{
	local R6WindowWrappedTextArea pR6WrapLabelTemp;

	if ( Len(_szErrorMsg) < 30 )
	{
		m_pError.m_ePopUpID=_ePopUpID;
		R6WindowTextLabel(m_pError.m_ClientArea).Text=_szErrorMsg;
		m_pError.ShowWindow();
	}
	else
	{
		m_pLongError.m_ePopUpID=_ePopUpID;
		pR6WrapLabelTemp=R6WindowWrappedTextArea(m_pLongError.m_ClientArea);
		pR6WrapLabelTemp.Clear(True,True);
		pR6WrapLabelTemp.AddText(_szErrorMsg,Root.Colors.BlueLight,Root.Fonts[6]);
		m_pLongError.ShowWindow();
	}
}
