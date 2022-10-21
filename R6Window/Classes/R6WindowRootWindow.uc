//================================================================================
// R6WindowRootWindow.
//================================================================================
class R6WindowRootWindow extends UWindowRootWindow;

struct StWidget
{
	var UWindowWindow m_pWidget;
	var R6WindowPopUpBox m_pPopUpFrame;
	var eGameWidgetID m_eGameWidgetID;
	var name m_WidgetConsoleState;
	var int iWidgetKA;
};

struct stKeyAvailability
{
	var int iKey;
	var int iWidgetKA;
};

var int m_iWidgetKA;
var int m_iLastKeyDown;
var R6WindowPopUpBox m_pSimplePopUp;
var Texture m_BGTexture[2];
var array<StWidget> m_pListOfActiveWidget;
var array<stKeyAvailability> m_pListOfKeyAvailability;
var array<R6WindowPopUpBox> m_pListOfFramePopUp;
var Region m_RSimplePopUp;
var Region m_RAddDlgSimplePopUp;
var string m_szCurrentBackgroundSubDirectory;

function SimplePopUp (string _szTitle, string _szText, EPopUpID _ePopUpID, optional int _iButtonsType, optional bool bAddDisableDlg, optional UWindowWindow OwnerWindow)
{
	local R6WindowWrappedTextArea pTextZone;

	if ( m_pSimplePopUp == None )
	{
		m_pSimplePopUp=R6WindowPopUpBox(CreateWindow(Class'R6WindowPopUpBox',0.00,0.00,640.00,480.00,OwnerWindow));
		m_pSimplePopUp.SetPopUpResizable(_ePopUpID != 51);
		m_pSimplePopUp.bAlwaysOnTop=True;
		m_pSimplePopUp.CreateStdPopUpWindow(_szTitle,25.00,m_RSimplePopUp.X,m_RSimplePopUp.Y,m_RSimplePopUp.W,m_RSimplePopUp.H,_iButtonsType);
		m_pSimplePopUp.CreateClientWindow(Class'R6WindowWrappedTextArea');
		m_pSimplePopUp.m_ePopUpID=_ePopUpID;
		pTextZone=R6WindowWrappedTextArea(m_pSimplePopUp.m_ClientArea);
		pTextZone.SetScrollable(True);
		pTextZone.m_fXOffSet=5.00;
		pTextZone.m_fYOffSet=5.00;
		pTextZone.AddText(_szText,Root.Colors.White,Root.Fonts[12]);
		pTextZone.m_bDrawBorders=False;
	}
	else
	{
		pTextZone=R6WindowWrappedTextArea(m_pSimplePopUp.m_ClientArea);
		pTextZone.Clear(True,True);
		pTextZone.AddText(_szText,Root.Colors.White,Root.Fonts[12]);
		m_pSimplePopUp.OwnerWindow=OwnerWindow;
		m_pSimplePopUp.SetPopUpResizable(_ePopUpID != 51);
		m_pSimplePopUp.ModifyPopUpFrameWindow(_szTitle,25.00,m_RSimplePopUp.X,m_RSimplePopUp.Y,m_RSimplePopUp.W,m_RSimplePopUp.H,_iButtonsType);
		m_pSimplePopUp.m_ePopUpID=_ePopUpID;
		m_pSimplePopUp.ShowWindow();
	}
	if ( _ePopUpID == 51 )
	{
		m_pSimplePopUp.m_ePopUpID=_ePopUpID;
		m_pSimplePopUp.TextWindowOnly(_szTitle,m_RSimplePopUp.X,m_RSimplePopUp.Y,m_RSimplePopUp.W,m_RSimplePopUp.H);
	}
	else
	{
		if ( bAddDisableDlg )
		{
			m_pSimplePopUp.AddDisableDLG();
			m_pSimplePopUp.ModifyPopUpFrameWindow(_szTitle,25.00,m_RAddDlgSimplePopUp.X,m_RAddDlgSimplePopUp.Y,m_RAddDlgSimplePopUp.W,m_RAddDlgSimplePopUp.H,_iButtonsType);
		}
		else
		{
			m_pSimplePopUp.RemoveDisableDLG();
		}
	}
	if ( Console.IsInState('Game') )
	{
		Console.LaunchUWindow();
	}
}

function SimpleTextPopUp (string _szText)
{
//	SimplePopUp(_szText,"",51,5);
}

function PopUpBoxDone (MessageBoxResult Result, EPopUpID _ePopUpID)
{
	m_RSimplePopUp=self.Default.m_RSimplePopUp;
	switch (_ePopUpID)
	{
/*		case 31:
		if ( Result == 4 )
		{
			Console.m_bInterruptConnectionProcess=True;
		}
		break;
		default:
		break;*/
	}
}

function EPopUpID GetSimplePopUpID ()
{
	if ( (m_pSimplePopUp != None) && m_pSimplePopUp.bWindowVisible )
	{
		return m_pSimplePopUp.m_ePopUpID;
	}
//	return 0;
}

function ModifyPopUpInsideText (array<string> _ANewText)
{
	local R6WindowWrappedTextArea pTextZone;
	local int i;

	if ( (m_pSimplePopUp != None) && m_pSimplePopUp.bWindowVisible )
	{
		if ( m_pSimplePopUp.m_ePopUpID == 31 )
		{
			pTextZone=R6WindowWrappedTextArea(m_pSimplePopUp.m_ClientArea);
			pTextZone.Clear(True,True);
			i=0;
JL0069:
			if ( i < _ANewText.Length )
			{
				pTextZone.AddText(_ANewText[i],Root.Colors.White,Root.Fonts[12]);
				i++;
				goto JL0069;
			}
		}
	}
}

function FillListOfKeyAvailability ()
{
}

function AddKeyInList (int _iKey, int _iWKA)
{
	local stKeyAvailability stKeyATemp;

	stKeyATemp.iKey=_iKey;
	stKeyATemp.iWidgetKA=_iWKA;
	m_pListOfKeyAvailability[m_pListOfKeyAvailability.Length]=stKeyATemp;
}

function R6WindowPopUpBox GetPopUpFrame (int _iIndex)
{
	local R6WindowPopUpBox pPopUpFrame;

	if ( m_pListOfFramePopUp.Length > _iIndex )
	{
		pPopUpFrame=m_pListOfFramePopUp[_iIndex];
	}
	else
	{
		pPopUpFrame=R6WindowPopUpBox(CreateWindow(Class'R6WindowPopUpBox',0.00,0.00,640.00,480.00));
		pPopUpFrame.CreatePopUpFrameWindow("",0.00,0.00,0.00,0.00,0.00);
		pPopUpFrame.m_bBGFullScreen=True;
		pPopUpFrame.HideWindow();
		m_pListOfFramePopUp[m_pListOfFramePopUp.Length]=pPopUpFrame;
	}
	return pPopUpFrame;
}

function ManagePrevWInHistory (bool _bClearPrevWInHistory, out int _iNbOfWidgetInList)
{
	if ( _bClearPrevWInHistory )
	{
		if ( _iNbOfWidgetInList != 0 )
		{
			if ( m_pListOfActiveWidget[_iNbOfWidgetInList - 1].m_pPopUpFrame != None )
			{
				m_pListOfActiveWidget[_iNbOfWidgetInList - 1].m_pPopUpFrame.HideWindow();
			}
			m_pListOfActiveWidget[_iNbOfWidgetInList - 1].m_pWidget.HideWindow();
			m_pListOfActiveWidget.Remove (_iNbOfWidgetInList - 1,1);;
			_iNbOfWidgetInList -= 1;
		}
	}
}

function bool IsWidgetIsInHistory (eGameWidgetID _eWidgetToFind)
{
	local int i;

	i=0;
JL0007:
	if ( i < m_pListOfActiveWidget.Length )
	{
		if ( m_pListOfActiveWidget[i].m_eGameWidgetID == _eWidgetToFind )
		{
			return True;
		}
		i++;
		goto JL0007;
	}
	return False;
}

function CloseAllWindow ()
{
	local int i;
	local int iNbOfWindow;

	iNbOfWindow=m_pListOfActiveWidget.Length;
	i=0;
JL0013:
	if ( i < iNbOfWindow )
	{
		if ( m_pListOfActiveWidget[i].m_pPopUpFrame != None )
		{
			m_pListOfActiveWidget[i].m_pPopUpFrame.HideWindow();
		}
		m_pListOfActiveWidget[i].m_pWidget.HideWindow();
		i++;
		goto JL0013;
	}
	m_pListOfActiveWidget.Remove (0,iNbOfWindow);
}

function SetLoadRandomBackgroundImage (string _szFolder)
{
	m_szCurrentBackgroundSubDirectory=_szFolder;
	Class'Actor'.static.LoadRandomBackgroundImage(_szFolder);
}

function PaintBackground (Canvas C, UWindowWindow _WidgetWindow)
{
	if ( (m_BGTexture[0] != None) && (m_BGTexture[1] != None) )
	{
		_WidgetWindow.DrawStretchedTextureSegment(C,0.00,0.00,512.00,512.00,0.00,0.00,512.00,512.00,m_BGTexture[0]);
		_WidgetWindow.DrawStretchedTextureSegment(C,512.00,0.00,512.00,512.00,0.00,0.00,512.00,512.00,m_BGTexture[1]);
	}
}

function CheckConsoleTypingState (name _RequestConsoleState)
{
	if ( Console.IsInState('Typing') )
	{
		Console.ConsoleState=_RequestConsoleState;
	}
	else
	{
		Console.GotoState(_RequestConsoleState);
	}
}

function bool GetMapNameLocalisation (string _szMapName, out string _szMapNameLoc, optional bool _bReturnInitName)
{
	local int i;
	local int j;
	local R6Console R6Console;
	local R6MissionDescription mission;
	local LevelInfo pLevel;

	pLevel=GetLevel();
	R6Console=R6Console(Root.Console);
	_szMapNameLoc="";
	i=0;
JL0034:
	if ( i < R6Console.m_aMissionDescriptions.Length )
	{
		mission=R6Console.m_aMissionDescriptions[i];
		if ( mission.m_MapName == _szMapName )
		{
			_szMapNameLoc=Localize(mission.m_MapName,"ID_MENUNAME",mission.LocalizationFile,True);
		}
		else
		{
			++i;
			goto JL0034;
		}
	}
	if ( _bReturnInitName && (_szMapNameLoc == "") )
	{
		_szMapNameLoc=_szMapName;
	}
	return _szMapNameLoc != "";
}

defaultproperties
{
    m_iLastKeyDown=-1
    m_RSimplePopUp=(X=11149835,Y=571277312,W=100,H=19669513)
    m_RAddDlgSimplePopUp=(X=10822155,Y=571277312,W=100,H=20324873)
}
/*
    m_BGTexture(0)=Texture'R6MenuBG.Backgrounds.GenericMainMenu0'
    m_BGTexture(1)=Texture'R6MenuBG.Backgrounds.GenericMainMenu1'
*/

