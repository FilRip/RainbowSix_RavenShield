//================================================================================
// R6WindowPopUpBoxCW.
//================================================================================
class R6WindowPopUpBoxCW extends UWindowDialogClientWindow;

var MessageBoxButtons Buttons;
var MessageBoxResult EnterResult;
var R6WindowPopUpButton m_pOKButton;
var R6WindowPopUpButton m_pCancelButton;
var R6WindowButtonBox m_pDisablePopUpButton;
const C_fBUT_HEIGHT= 17;

function KeyDown (int Key, float X, float Y)
{
	local R6WindowPopUpBox P;

	P=R6WindowPopUpBox(ParentWindow);
/*	if ( (Key == GetPlayerOwner().Player.Console.13) && (EnterResult != 0) )
	{
		P.Result=EnterResult;
		P.Close();
	}
	else
	{
		if ( Key == GetPlayerOwner().Player.Console.27 )
		{
			P.Result=4;
			P.Close();
		}
	}*/
}

function Resized ()
{
}

function SetupPopUpBoxClient (MessageBoxButtons InButtons, MessageBoxResult InEnterResult)
{
	local float fXBut;
	local float fYBut;
	local float fWidthBut;
	local float fHeightBut;
	local bool bButtonsValid;

	fWidthBut=23.00;
	fHeightBut=17.00;
	Buttons=InButtons;
	EnterResult=InEnterResult;
	if ( m_pOKButton != None )
	{
		m_pOKButton.HideWindow();
	}
	if ( m_pCancelButton != None )
	{
		m_pCancelButton.HideWindow();
	}
	bButtonsValid=True;
	switch (Buttons)
	{
/*		case 1:
		fXBut=WinWidth - fWidthBut - 20;
		if ( m_pCancelButton != None )
		{
			m_pCancelButton.WinLeft=fXBut;
			m_pCancelButton.ShowWindow();
		}
		else
		{
			fYBut=(WinHeight - fHeightBut) * 0.50;
			fYBut=fYBut + 0.50;
			m_pCancelButton=R6WindowPopUpButton(CreateControl(Class'R6WindowPopUpButton',fXBut,fYBut,fWidthBut,fHeightBut));
			m_pCancelButton.ImageX=2.00;
			m_pCancelButton.ImageY=2.00;
			m_pCancelButton.m_bDrawRedBG=True;
			R6WindowLookAndFeel(LookAndFeel).Button_SetupEnumSignChoice(m_pCancelButton,1);
		}
		fXBut=fXBut - fWidthBut - 20;
		if ( m_pOKButton != None )
		{
			m_pOKButton.WinLeft=fXBut;
			m_pOKButton.ShowWindow();
		}
		else
		{
			m_pOKButton=R6WindowPopUpButton(CreateControl(Class'R6WindowPopUpButton',fXBut,fYBut,fWidthBut,fHeightBut));
			m_pOKButton.ImageX=2.00;
			m_pOKButton.ImageY=2.00;
			m_pOKButton.m_bDrawGreenBG=True;
			R6WindowLookAndFeel(LookAndFeel).Button_SetupEnumSignChoice(m_pOKButton,0);
		}
		break;
		case 2:
		fXBut=WinWidth - fWidthBut - 20;
		fYBut=(WinHeight - fHeightBut) * 0.50;
		fYBut=fYBut + 0.50;
		m_pOKButton=R6WindowPopUpButton(CreateControl(Class'R6WindowPopUpButton',fXBut,fYBut,fWidthBut,fHeightBut));
		m_pOKButton.ImageX=2.00;
		m_pOKButton.ImageY=2.00;
		m_pOKButton.m_bDrawGreenBG=True;
		R6WindowLookAndFeel(LookAndFeel).Button_SetupEnumSignChoice(m_pOKButton,0);
		break;
		case 4:
		fXBut=WinWidth - fWidthBut - 20;
		if ( m_pCancelButton != None )
		{
			m_pCancelButton.WinLeft=fXBut;
			m_pCancelButton.ShowWindow();
		}
		else
		{
			fYBut=(WinHeight - fHeightBut) * 0.50;
			fYBut=fYBut + 0.50;
			m_pCancelButton=R6WindowPopUpButton(CreateControl(Class'R6WindowPopUpButton',fXBut,fYBut,fWidthBut,fHeightBut));
			m_pCancelButton.ImageX=2.00;
			m_pCancelButton.ImageY=2.00;
			m_pCancelButton.m_bDrawRedBG=True;
			R6WindowLookAndFeel(LookAndFeel).Button_SetupEnumSignChoice(m_pCancelButton,1);
		}
		break;
		default:
		bButtonsValid=False;
		break;*/
	}
	if ( bButtonsValid )
	{
		SetAcceptsFocus();
	}
}

function AddDisablePopUpButton ()
{
	local float fXBut;
	local float fYBut;

	if ( m_pDisablePopUpButton == None )
	{
		fXBut=5.00;
		fYBut=0.00;
		fYBut=fYBut + 0.50;
		m_pDisablePopUpButton=R6WindowButtonBox(CreateControl(Class'R6WindowButtonBox',fXBut,fYBut,WinWidth,WinHeight,self));
		m_pDisablePopUpButton.SetButtonBox(False);
		m_pDisablePopUpButton.CreateTextAndBox(Localize("POPUP","DISABLEPOPUP","R6Menu"),"",0.00,R6WindowPopUpBox(ParentWindow).m_ePopUpID,True);
		m_pDisablePopUpButton.bAlwaysOnTop=True;
		m_pDisablePopUpButton.m_bResizeToText=True;
	}
	else
	{
		m_pDisablePopUpButton.ShowWindow();
	}
}

function RemoveDisablePopUpButton ()
{
	if ( m_pDisablePopUpButton != None )
	{
		m_pDisablePopUpButton.HideWindow();
	}
}

function Notify (UWindowDialogControl C, byte E)
{
	local R6WindowPopUpBox P;

	P=R6WindowPopUpBox(ParentWindow);
	switch (E)
	{
		case 2:
		if ( C.IsA('R6WindowButtonBox') )
		{
			R6WindowButtonBox(C).m_bSelected= !R6WindowButtonBox(C).m_bSelected;
		}
		else
		{
			switch (C)
			{
				case m_pOKButton:
//				P.Result=3;
				P.Close();
				break;
				case m_pCancelButton:
//				P.Result=4;
				P.Close();
				break;
				default:
			}
		}
		break;
		default:
		break;
	}
}
