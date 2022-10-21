//================================================================================
// R6WindowPopUpBox.
//================================================================================
class R6WindowPopUpBox extends UWindowWindow;

struct stBorderForm
{
	var Color vColor;
	var float fXPos;
	var float fYPos;
	var float fWidth;
	var float fHeight;
	var bool bActive;
};

enum eCornerType {
	No_Corners,
	Top_Corners,
	Bottom_Corners,
	All_Corners
};

enum eBorderType {
	Border_Top,
	Border_Bottom,
	Border_Left,
	Border_Right
};

const K_BORDER_VER_OFF= 1;
const K_BORDER_HOR_OFF= 1;
const K_FBUTTON_HEIGHT_REGION= 25;
const C_fTITLE_TIME_OFFSET= 10;
var eCornerType m_eCornerType;
var EPopUpID m_ePopUpID;
var MessageBoxResult Result;
var MessageBoxResult DefaultResult;
var int m_DrawStyle;
var int m_iPopUpButtonsType;
var bool m_bNoBorderToDraw;
var bool m_bBGFullScreen;
var bool m_bBGClientArea;
var bool m_bDetectKey;
var bool m_bForceButtonLine;
var bool m_bDisablePopUpActive;
var bool m_bPopUpLock;
var bool m_bTextWindowOnly;
var bool m_bResizePopUpOnTextLabel;
var bool m_bHideAllChild;
var float m_fHBorderHeight;
var float m_fVBorderWidth;
var float m_fHBorderPadding;
var float m_fVBorderPadding;
var float m_fHBorderOffset;
var float m_fVBorderOffset;
var Texture m_BGTexture;
var Texture m_HBorderTexture;
var Texture m_VBorderTexture;
var Texture m_topLeftCornerT;
var UWindowWindow m_ClientArea;
var UWindowWindow m_ButClientArea;
var R6WindowTextLabelExt m_pTextLabel;
var Class<UWindowWindow> m_ClientClass;
var Region m_BGTextureRegion;
var Region m_HBorderTextureRegion;
var Region m_VBorderTextureRegion;
var Region m_topLeftCornerR;
var Region m_RWindowBorder;
var Region SimpleBorderRegion;
var stBorderForm m_sBorderForm[4];
var Color m_eCornerColor[4];
var Color m_vFullBGColor;
var Color m_vClientAreaColor;

function Created ()
{
	local int i;

	i=0;
JL0007:
	if ( i < 4 )
	{
		m_sBorderForm[i].vColor=Root.Colors.BlueLight;
		m_sBorderForm[i].fXPos=0.00;
		m_sBorderForm[i].fYPos=0.00;
		m_sBorderForm[i].fWidth=1.00;
		m_sBorderForm[i].bActive=False;
		i++;
		goto JL0007;
	}
	m_eCornerColor[3]=Root.Colors.White;
	m_eCornerColor[1]=Root.Colors.White;
	m_eCornerColor[2]=Root.Colors.White;
	m_vFullBGColor=Root.Colors.m_cBGPopUpContour;
	m_vClientAreaColor=Root.Colors.m_cBGPopUpWindow;
	m_ClientArea=None;
}

function CreateClientWindow (Class<UWindowWindow> ClientClass, optional bool _bButtonBar, optional bool _bDrawClientOnBorder)
{
	m_ClientClass=ClientClass;
	if ( _bButtonBar )
	{
		m_ButClientArea=CreateWindow(m_ClientClass,m_RWindowBorder.X,m_RWindowBorder.Y + m_RWindowBorder.H - 25,m_RWindowBorder.W,25.00,OwnerWindow);
	}
	else
	{
		if ( _bDrawClientOnBorder )
		{
			m_ClientArea=CreateWindow(m_ClientClass,m_RWindowBorder.X + 1,m_RWindowBorder.Y - 1,m_RWindowBorder.W - 2 * 1,m_RWindowBorder.H + 2 * 1 - 25,OwnerWindow);
		}
		else
		{
			m_ClientArea=CreateWindow(m_ClientClass,m_RWindowBorder.X + 1 + 1,m_RWindowBorder.Y,m_RWindowBorder.W - 2 * 1 - 1,m_RWindowBorder.H - 25,OwnerWindow);
		}
	}
}

function Paint (Canvas C, float X, float Y)
{
	if ( m_bResizePopUpOnTextLabel )
	{
		if ( m_pTextLabel != None )
		{
			m_pTextLabel.m_bPreCalculatePos=m_bHideAllChild;
		}
		if ( m_ClientArea != None )
		{
			m_ClientArea.m_bPreCalculatePos=m_bHideAllChild;
		}
		if ( m_ButClientArea != None )
		{
			m_ButClientArea.m_bPreCalculatePos=m_bHideAllChild;
		}
		if ( m_bHideAllChild )
		{
			m_bHideAllChild=False;
			return;
		}
	}
	R6WindowLookAndFeel(LookAndFeel).DrawPopUpFrameWindow(self,C);
	if ( m_bTextWindowOnly )
	{
		if ( m_ClientArea != None )
		{
			m_ClientArea.HideWindow();
		}
		if ( m_ButClientArea != None )
		{
			m_ButClientArea.HideWindow();
		}
		return;
	}
	if ( (m_ButClientArea != None) || m_bForceButtonLine )
	{
		C.SetDrawColor(255,255,255);
		DrawStretchedTextureSegment(C,m_RWindowBorder.X + 1,m_RWindowBorder.Y + m_RWindowBorder.H - 25,m_RWindowBorder.W - 2,1.00,SimpleBorderRegion.X,SimpleBorderRegion.Y,SimpleBorderRegion.W,SimpleBorderRegion.H,m_BGTexture);
	}
}

function CreateStdPopUpWindow (string _szPopUpTitle, float _fTextHeight, float _fXPos, float _fYPos, float _fWidth, float _fHeight, optional int _iButtonsType)
{
	CreateTextWindow(_szPopUpTitle,_fXPos,_fYPos,_fWidth,_fTextHeight);
	CreatePopUpFrame(_fXPos,_fYPos + _fTextHeight,_fWidth,_fHeight);
	CreateClientWindow(Class'R6WindowPopUpBoxCW',True);
	SetButtonsType(_iButtonsType);
}

function CreatePopUpFrameWindow (string _szPopUpTitle, float _fTextHeight, float _fXPos, float _fYPos, float _fWidth, float _fHeight)
{
	CreateTextWindow(_szPopUpTitle,_fXPos,_fYPos,_fWidth,_fTextHeight);
	CreatePopUpFrame(_fXPos,_fYPos + _fTextHeight,_fWidth,_fHeight);
}

function ModifyPopUpFrameWindow (string _szPopUpTitle, float _fTextHeight, float _fXPos, float _fYPos, float _fWidth, float _fHeight, optional int _iButtonsType)
{
	m_bTextWindowOnly=False;
	ModifyTextWindow(_szPopUpTitle,_fXPos,_fYPos,_fWidth,_fTextHeight);
	CreatePopUpFrame(_fXPos,_fYPos + _fTextHeight,_fWidth,_fHeight);
	if ( m_ButClientArea != None )
	{
		m_ButClientArea.WinLeft=m_RWindowBorder.X;
		m_ButClientArea.WinTop=m_RWindowBorder.Y + m_RWindowBorder.H - 25;
		m_ButClientArea.WinWidth=m_RWindowBorder.W;
		m_ButClientArea.WinHeight=25.00;
		SetButtonsType(_iButtonsType);
	}
	if ( m_ClientArea != None )
	{
		m_ClientArea.WinLeft=m_RWindowBorder.X + 1;
		m_ClientArea.WinTop=m_RWindowBorder.Y;
		m_ClientArea.SetSize(m_RWindowBorder.W - 2 * 1,m_RWindowBorder.H - 25);
	}
}

function CreateTextWindow (string _szTitleText, float _X, float _Y, float _fWidth, float _fHeight)
{
	m_pTextLabel=R6WindowTextLabelExt(CreateWindow(Class'R6WindowTextLabelExt',_X,_Y,_fWidth,_fHeight,self));
	m_pTextLabel.SetBorderParam(0,7.00,0.00,1.00,Root.Colors.White);
	m_pTextLabel.SetBorderParam(1,1.00,0.00,1.00,Root.Colors.White);
	m_pTextLabel.SetBorderParam(2,1.00,1.00,1.00,Root.Colors.White);
	m_pTextLabel.SetBorderParam(3,1.00,1.00,1.00,Root.Colors.White);
	m_pTextLabel.m_Font=Root.Fonts[8];
	m_pTextLabel.m_vTextColor=Root.Colors.White;
/*	m_pTextLabel.AddTextLabel(_szTitleText,0.00,0.00,_fWidth,2,False,0.00,m_bResizePopUpOnTextLabel);
	m_pTextLabel.AddTextLabel("",_fWidth - 10,0.00,0.00,1,False,0.00,True);*/
	m_pTextLabel.m_bTextCenterToWindow=True;
//	m_pTextLabel.m_eCornerType=1;
	SetCornerColor(1,Root.Colors.White);
}

function ModifyTextWindow (string _szTitleText, float _X, float _Y, float _fWidth, float _fHeight)
{
	if ( m_pTextLabel != None )
	{
		m_pTextLabel.WinLeft=_X;
		m_pTextLabel.WinTop=_Y;
		m_pTextLabel.WinWidth=_fWidth;
		m_pTextLabel.WinHeight=_fHeight;
		m_pTextLabel.SetBorderParam(0,7.00,0.00,1.00,Root.Colors.White);
		m_pTextLabel.SetBorderParam(1,1.00,0.00,1.00,Root.Colors.White);
		m_pTextLabel.SetBorderParam(2,1.00,1.00,1.00,Root.Colors.White);
		m_pTextLabel.SetBorderParam(3,1.00,1.00,1.00,Root.Colors.White);
		m_pTextLabel.Clear();
		m_pTextLabel.m_vTextColor=Root.Colors.White;
/*		m_pTextLabel.AddTextLabel(_szTitleText,0.00,0.00,_fWidth,2,False,0.00,m_bResizePopUpOnTextLabel);
		m_pTextLabel.AddTextLabel("",_fWidth - 10,0.00,0.00,1,False,0.00,True);*/
		m_pTextLabel.m_bTextCenterToWindow=True;
	}
}

function TextWindowOnly (string _szTitleText, float _X, float _Y, float _fWidth, float _fHeight)
{
	if ( m_pTextLabel != None )
	{
		m_bTextWindowOnly=True;
		SetNoBorder();
//		m_eCornerType=0;
		m_RWindowBorder.H=0;
		m_pTextLabel.WinLeft=_X;
		m_pTextLabel.WinTop=_Y;
		m_pTextLabel.WinWidth=_fWidth;
		m_pTextLabel.WinHeight=_fHeight;
		m_pTextLabel.SetBorderParam(0,7.00,0.00,1.00,Root.Colors.White);
		m_pTextLabel.SetBorderParam(1,7.00,0.00,1.00,Root.Colors.White);
		m_pTextLabel.SetBorderParam(2,1.00,1.00,1.00,Root.Colors.White);
		m_pTextLabel.SetBorderParam(3,1.00,1.00,1.00,Root.Colors.White);
//		m_pTextLabel.m_eCornerType=3;
		m_pTextLabel.Clear();
		m_pTextLabel.m_vTextColor=Root.Colors.White;
//		m_pTextLabel.AddTextLabel(_szTitleText,0.00,0.00,_fWidth,2,False);
		m_pTextLabel.m_bTextCenterToWindow=True;
	}
}

function UpdateTimeInTextLabel (int _iNewTime, optional string _StringInstead)
{
	local Color vTimeColor;
	local string szTemp;

	if ( m_pTextLabel != None )
	{
		vTimeColor=Root.Colors.White;
		if ( _iNewTime < 10 )
		{
			vTimeColor=Root.Colors.Red;
		}
		if ( _StringInstead != "" )
		{
			szTemp=_StringInstead;
		}
		else
		{
			if ( _iNewTime == -1 )
			{
				szTemp="";
			}
			else
			{
				szTemp=Class'Actor'.static.ConvertIntTimeToString(_iNewTime);
			}
		}
		m_pTextLabel.ChangeColorLabel(vTimeColor,1);
		m_pTextLabel.ChangeTextLabel(szTemp,1);
	}
}

function CreatePopUpFrame (float _X, float _Y, float _fWidth, float _fHeight)
{
	local float fBorderSize;
	local float fBorderWidth;

	fBorderSize=1.00;
	fBorderWidth=1.00;
	m_RWindowBorder.X=_X;
	m_RWindowBorder.Y=_Y;
	m_RWindowBorder.W=_fWidth;
	m_RWindowBorder.H=_fHeight;
	ActiveBorder(0,False);
	SetBorderParam(1,7.00,_fHeight - fBorderSize,_fWidth - 14,fBorderWidth,Root.Colors.White);
	SetBorderParam(2,fBorderSize,0.00,fBorderWidth,_fHeight - 2 * fBorderSize,Root.Colors.White);
	SetBorderParam(3,_fWidth - 2,0.00,fBorderWidth,_fHeight - 2 * fBorderSize,Root.Colors.White);
//	m_eCornerType=2;
	SetCornerColor(2,Root.Colors.White);
}

function SetBorderParam (int _iBorderType, float _X, float _Y, float _fWidth, float _fHeight, Color _vColor)
{
	m_sBorderForm[_iBorderType].fXPos=_X + m_RWindowBorder.X;
	m_sBorderForm[_iBorderType].fYPos=_Y + m_RWindowBorder.Y;
	m_sBorderForm[_iBorderType].fWidth=_fWidth;
	m_sBorderForm[_iBorderType].fHeight=_fHeight;
	m_sBorderForm[_iBorderType].vColor=_vColor;
	m_sBorderForm[_iBorderType].bActive=True;
	m_bNoBorderToDraw=False;
}

function ActiveBorder (int _iBorderType, bool _Active)
{
	local int i;
	local bool bNoBorderToDraw;

	m_sBorderForm[_iBorderType].bActive=_Active;
	bNoBorderToDraw=True;
	i=0;
JL0027:
	if ( i < 4 )
	{
		if ( m_sBorderForm[_iBorderType].bActive )
		{
			bNoBorderToDraw=False;
		}
		else
		{
			i++;
			goto JL0027;
		}
	}
	m_bNoBorderToDraw=bNoBorderToDraw;
}

function SetNoBorder ()
{
	m_bNoBorderToDraw=True;
}

function SetCornerColor (int _iCornerType, Color _Color)
{
	if ( _iCornerType == 3 )
	{
		m_eCornerColor[1]=_Color;
		m_eCornerColor[2]=_Color;
	}
	m_eCornerColor[_iCornerType]=_Color;
}

function ResizePopUp (float _fNewWidth)
{
	local float fTemp;
	local int ITemp;

	fTemp=(640.00 - _fNewWidth) * 0.50;
	fTemp += 0.50;
	ITemp=fTemp;
	m_bHideAllChild=True;
	ModifyPopUpFrameWindow(m_pTextLabel.GetTextLabel(0),m_pTextLabel.WinHeight,ITemp,m_pTextLabel.WinTop,_fNewWidth,m_RWindowBorder.H,m_iPopUpButtonsType);
}

function SetPopUpResizable (bool _bResizable)
{
	m_bResizePopUpOnTextLabel=_bResizable;
	m_bHideAllChild=_bResizable;
}

function SetButtonsType (int _iButtonsType)
{
	m_iPopUpButtonsType=_iButtonsType;
	switch (_iButtonsType)
	{
		case 2:
//		SetupPopUpBox(2,3,3);
		break;
		case 4:
//		SetupPopUpBox(4,3);
		break;
		case 5:
//		SetupPopUpBox(5,0);
		break;
		default:
//		SetupPopUpBox(1,4,3);
		break;
	}
}

function SetupPopUpBox (MessageBoxButtons Buttons, MessageBoxResult InESCResult, optional MessageBoxResult InEnterResult)
{
	if ( m_ButClientArea != None )
	{
		R6WindowPopUpBoxCW(m_ButClientArea).SetupPopUpBoxClient(Buttons,InEnterResult);
	}
	Result=InESCResult;
	DefaultResult=InESCResult;
}

function Close (optional bool bByParent)
{
	local R6GameOptions pGameOptions;
	local bool bGOSaveConfig;

	if ( m_bPopUpLock )
	{
		return;
	}
	Super.Close(bByParent);
	if ( m_bDisablePopUpActive )
	{
		if ( m_ButClientArea != None )
		{
			pGameOptions=Class'Actor'.static.GetGameOptions();
			bGOSaveConfig=True;
			switch (m_ePopUpID)
			{
/*				case 34:
				pGameOptions.PopUpQuickPlay= !R6WindowPopUpBoxCW(m_ButClientArea).m_pDisablePopUpButton.m_bSelected;
				break;
				case 43:
				pGameOptions.PopUpLoadPlan= !R6WindowPopUpBoxCW(m_ButClientArea).m_pDisablePopUpButton.m_bSelected;
				break;
				default:
				Log("Need to add your disable/enable pop-up ID in game options to have this feature ON");
				bGOSaveConfig=False;
				break;*/
			}
			if ( bGOSaveConfig )
			{
				pGameOptions.SaveConfig();
			}
		}
	}
	if ( m_ButClientArea != None )
	{
		R6WindowPopUpBoxCW(m_ButClientArea).CancelAcceptsFocus();
	}
	OwnerWindow.PopUpBoxDone(Result,m_ePopUpID);
	if ( m_ClientArea != None )
	{
		m_ClientArea.PopUpBoxDone(Result,m_ePopUpID);
	}
	Result=DefaultResult;
}

function ShowWindow ()
{
	Super.ShowWindow();
	if ( m_bResizePopUpOnTextLabel )
	{
		m_bHideAllChild=True;
	}
	if ( m_bDetectKey )
	{
		if ( m_ButClientArea != None )
		{
			R6WindowPopUpBoxCW(m_ButClientArea).SetAcceptsFocus();
		}
	}
	if ( m_ClientArea != None )
	{
		m_ClientArea.ShowWindow();
	}
}

function ShowLockPopUp ()
{
	m_bPopUpLock=True;
	ShowWindow();
}

function HideWindow ()
{
	m_bPopUpLock=False;
	Super.HideWindow();
}

function WindowEvent (WinMessage Msg, Canvas C, float X, float Y, int Key)
{
	Super.WindowEvent(Msg,C,X,Y,Key);
	if ( m_bDetectKey )
	{
		if ( Msg == 9 )
		{
			if ( m_ButClientArea != None )
			{
				if ( m_ButClientArea.IsA('R6WindowPopUpBoxCW') )
				{
					R6WindowPopUpBoxCW(m_ButClientArea).KeyDown(Key,X,Y);
				}
			}
		}
	}
}

function AddDisableDLG ()
{
	local R6GameOptions pGameOptions;

	if ( m_ButClientArea != None )
	{
		R6WindowPopUpBoxCW(m_ButClientArea).AddDisablePopUpButton();
		pGameOptions=Class'Actor'.static.GetGameOptions();
		switch (m_ePopUpID)
		{
/*			case 34:
			R6WindowPopUpBoxCW(m_ButClientArea).m_pDisablePopUpButton.m_bSelected= !pGameOptions.PopUpQuickPlay;
			break;
			case 43:
			R6WindowPopUpBoxCW(m_ButClientArea).m_pDisablePopUpButton.m_bSelected= !pGameOptions.PopUpLoadPlan;
			break;
			default:*/
		}
	}
	else
	{
	}
	m_bDisablePopUpActive=True;
}

function RemoveDisableDLG ()
{
	if ( m_ButClientArea != None )
	{
		R6WindowPopUpBoxCW(m_ButClientArea).RemoveDisablePopUpButton();
	}
	m_bDisablePopUpActive=False;
}

defaultproperties
{
    m_DrawStyle=5
    m_bBGFullScreen=True
    m_bBGClientArea=True
    m_bDetectKey=True
    m_fHBorderHeight=2.00
    m_fVBorderWidth=2.00
    m_fHBorderPadding=7.00
    m_fVBorderPadding=2.00
    m_fVBorderOffset=1.00
    m_ClientClass=Class'UWindow.UWindowClientWindow'
    m_BGTextureRegion=(X=4596235,Y=571277312,W=45,H=598537)
    m_HBorderTextureRegion=(X=4203019,Y=571277312,W=56,H=74249)
    m_VBorderTextureRegion=(X=4203019,Y=571277312,W=56,H=74249)
    m_topLeftCornerR=(X=795147,Y=571277312,W=56,H=401929)
    SimpleBorderRegion=(X=4203019,Y=571277312,W=56,H=74249)
}
/*
    m_BGTexture=Texture'R6MenuTextures.Gui_BoxScroll'
    m_HBorderTexture=Texture'R6MenuTextures.Gui_BoxScroll'
    m_VBorderTexture=Texture'R6MenuTextures.Gui_BoxScroll'
    m_topLeftCornerT=Texture'R6MenuTextures.Gui_BoxScroll'
*/

