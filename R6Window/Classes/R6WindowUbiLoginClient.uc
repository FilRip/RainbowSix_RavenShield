//================================================================================
// R6WindowUbiLoginClient.
//================================================================================
class R6WindowUbiLoginClient extends UWindowDialogClientWindow;

var R6WindowEditControl m_pUserName;
var R6WindowEditControl m_pPassword;
var R6WindowButtonBox m_pSavePassword;
var R6WindowButtonBox m_pAutoLogIn;
var R6WindowButton m_pCrAccountBut;
var R6WindowTextLabelExt m_pCrAccountText;
const K_RIGHT_HOR_OFF= 10;
const K_LEFT_HOR_OFF= 5;
const K_BOTTON_WIDTH= 95;
const K_VERTICAL_SPACER= 2;
const K_TEXT_WIDTH= 130;
const K_TEXT_HEIGHT= 15;
const K_EDIT_BOX_WIDTH= 140;
const K_EDIT_BOX_HEIGHT= 15;

function SetupClientWindow (float fWindowWidth)
{
	local float fX;
	local float fY;
	local float fWidth;
	local float fHeight;

	fX=5.00;
	fY=2.00;
	fHeight=15.00;
	fWidth=fWindowWidth - 5 + 10;
	m_pUserName=R6WindowEditControl(CreateControl(Class'R6WindowEditControl',fX,fY,fWidth,fHeight,self));
	m_pUserName.SetValue("");
	m_pUserName.CreateTextLabel(Localize("MultiPlayer","PopUp_LoginName","R6Menu"),0.00,0.00,fWidth * 0.50,fHeight);
	m_pUserName.SetEditBoxTip("");
	fWidth=165.00;
	m_pUserName.ModifyEditBoxW(fWindowWidth - fWidth - 10,0.00,fWidth,fHeight);
	m_pUserName.EditBox.MaxLength=15;
	fY += 15 + 2;
	fWidth=fWindowWidth - 5 + 10;
	m_pPassword=R6WindowEditControl(CreateControl(Class'R6WindowEditControl',fX,fY,fWidth,fHeight,self));
	m_pPassword.SetValue("");
	m_pPassword.CreateTextLabel(Localize("MultiPlayer","PopUp_UbiPassword","R6Menu"),0.00,0.00,fWidth * 0.50,fHeight);
	m_pPassword.SetEditBoxTip("");
	fWidth=165.00;
	m_pPassword.ModifyEditBoxW(fWindowWidth - fWidth - 10,0.00,fWidth,fHeight);
	m_pPassword.EditBox.MaxLength=20;
	m_pPassword.EditBox.bPassword=True;
	fY += 15 + 2;
	fWidth=fWindowWidth - 5 + 10;
	m_pSavePassword=R6WindowButtonBox(CreateControl(Class'R6WindowButtonBox',fX,fY,fWidth,fHeight,self,True));
	m_pSavePassword.m_TextFont=Root.Fonts[5];
	m_pSavePassword.m_vTextColor=Root.Colors.White;
	m_pSavePassword.m_vBorder=Root.Colors.White;
	m_pSavePassword.m_bSelected=False;
	m_pSavePassword.CreateTextAndBox(Localize("MultiPlayer","PopUp_RemPass","R6Menu"),"",0.00,0);
	m_pSavePassword.SetButtonBox(True);
	fY += 15 + 2;
	m_pAutoLogIn=R6WindowButtonBox(CreateControl(Class'R6WindowButtonBox',fX,fY,fWidth,fHeight,self,True));
	m_pAutoLogIn.m_TextFont=Root.Fonts[5];
	m_pAutoLogIn.m_vTextColor=Root.Colors.White;
	m_pAutoLogIn.m_vBorder=Root.Colors.White;
	m_pAutoLogIn.m_bSelected=False;
	m_pAutoLogIn.CreateTextAndBox(Localize("MultiPlayer","PopUp_AutoLogin","R6Menu"),"",0.00,0);
	m_pAutoLogIn.SetButtonBox(True);
	fY += 15 + 2;
	fWidth=130.00;
	m_pCrAccountText=R6WindowTextLabelExt(CreateWindow(Class'R6WindowTextLabelExt',fX,fY,fWidth,fHeight,self));
	m_pCrAccountText.m_Font=Root.Fonts[5];
	m_pCrAccountText.m_vTextColor=Root.Colors.White;
//	m_pCrAccountText.AddTextLabel(Localize("MultiPlayer","PopUp_www","R6Menu"),0.00,0.00,200.00,0,False);
	m_pCrAccountText.m_bTextCenterToWindow=True;
	fX=fWindowWidth - 95 - 10;
	fWidth=95.00;
	m_pCrAccountBut=R6WindowButton(CreateControl(Class'R6WindowButton',fX,fY,fWidth,fHeight,self,True));
	m_pCrAccountBut.m_vButtonColor=Root.Colors.White;
	m_pCrAccountBut.SetButtonBorderColor(Root.Colors.White);
	m_pCrAccountBut.m_bDrawBorders=True;
	m_pCrAccountBut.Align=TA_Center;
	m_pCrAccountBut.ImageX=2.00;
	m_pCrAccountBut.ImageY=2.00;
	m_pCrAccountBut.m_bDrawSimpleBorder=True;
	m_pCrAccountBut.bStretched=True;
	m_pCrAccountBut.SetText(Localize("MultiPlayer","PopUp_CrAcct","R6Menu"));
	m_pCrAccountBut.SetFont(0);
	m_pCrAccountBut.TextColor=Root.Colors.White;
}

function Notify (UWindowDialogControl C, byte E)
{
	switch (C)
	{
		case m_pCrAccountBut:
		if ( E == 2 )
		{
			R6Console(Root.Console).m_GameService.Initialize();
			Root.Console.ConsoleCommand("startminimized " @ R6Console(Root.Console).m_GameService.m_szUbiHomePage);
		}
		break;
		case m_pSavePassword:
		case m_pAutoLogIn:
		if ( E == 2 )
		{
			if ( R6WindowButtonBox(C).GetSelectStatus() )
			{
				R6WindowButtonBox(C).m_bSelected= !R6WindowButtonBox(C).m_bSelected;
			}
		}
		m_pAutoLogIn.bDisabled= !m_pSavePassword.m_bSelected;
		if ( m_pAutoLogIn.bDisabled )
		{
			m_pAutoLogIn.m_bSelected=False;
		}
		break;
		default:
	}
}
