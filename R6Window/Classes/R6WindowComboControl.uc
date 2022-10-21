//================================================================================
// R6WindowComboControl.
//================================================================================
class R6WindowComboControl extends UWindowComboControl;

var int m_iButtonID;
var R6WindowTextLabel m_pComboTextLabel;

function Created ()
{
	m_pComboTextLabel=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',0.00,0.00,WinWidth,LookAndFeel.Size_ComboHeight,self));
//	m_pComboTextLabel.SetProperties("",0,Root.Fonts[5],Root.Colors.White,False);
	EditBox=UWindowEditBox(CreateWindow(Class'UWindowEditBox',0.00,0.00,WinWidth - LookAndFeel.Size_ComboButtonWidth + 1,LookAndFeel.Size_ComboHeight,self));
	EditBox.NotifyOwner=self;
	EditBox.bTransient=True;
	EditBox.bCanEdit=False;
	EditBox.m_bDrawEditBorders=True;
	EditBox.m_BorderColor=Root.Colors.White;
	EditBox.Align=TA_Center;
	EditBox.m_bUseNewPaint=True;
	Button=UWindowComboButton(CreateWindow(Class'UWindowComboButton',WinWidth - LookAndFeel.Size_ComboButtonWidth,0.00,LookAndFeel.Size_ComboButtonWidth,LookAndFeel.Size_ComboHeight,self));
	Button.Owner=self;
	Button.bAlwaysOnTop=True;
	Button.m_bDrawButtonBorders=True;
	Button.m_BorderColor=Root.Colors.White;
	Button.RegionScale=1.00;
	List=UWindowComboList(Root.CreateWindow(ListClass,0.00,0.00,Button.WinLeft + Button.WinWidth - EditBox.WinLeft,100.00,self));
	List.LookAndFeel=LookAndFeel;
	List.Owner=self;
	List.Setup();
	List.HBorder=1;
	List.VBorder=1;
	List.HideWindow();
	bListVisible=False;
}

function BeforePaint (Canvas C, float X, float Y)
{
	List.bLeaveOnscreen=bListVisible && bLeaveOnscreen;
}

function Paint (Canvas C, float X, float Y)
{
	if (  !m_bDisabled )
	{
		if ( EditBox.m_bMouseOn )
		{
			m_pComboTextLabel.TextColor=Root.Colors.BlueLight;
			EditBox.m_BorderColor=Root.Colors.BlueLight;
			Button.m_BorderColor=Root.Colors.BlueLight;
			List.SetBorderColor(Root.Colors.BlueLight);
			ParentWindow.MouseEnter();
		}
		else
		{
			if (  !bListVisible )
			{
				if ( m_pComboTextLabel.TextColor!=Root.Colors.White )
				{
					m_pComboTextLabel.TextColor=Root.Colors.White;
					EditBox.m_BorderColor=Root.Colors.White;
					Button.m_BorderColor=Root.Colors.White;
					List.SetBorderColor(Root.Colors.White);
					ParentWindow.MouseLeave();
				}
			}
		}
	}
}

function AdjustEditBoxW (float _fY, float _fWidth, float _fHeight)
{
	Button.WinTop=_fY;
	EditBox.WinLeft=Button.WinLeft + 1 - _fWidth;
	EditBox.WinTop=Button.WinTop;
	EditBox.WinWidth=_fWidth;
	EditBox.WinHeight=_fHeight;
	EditBox.Font=5;
	EditBoxWidth=EditBox.WinWidth;
	List.WinWidth=Button.WinLeft + Button.WinWidth - EditBox.WinLeft;
}

function AdjustTextW (string _szTitle, float _fX, float _fY, float _fWidth, float _fHeight)
{
	m_pComboTextLabel.WinLeft=_fX;
	m_pComboTextLabel.WinTop=_fY;
	m_pComboTextLabel.WinWidth=_fWidth;
	m_pComboTextLabel.WinHeight=_fHeight;
	m_pComboTextLabel.SetNewText(_szTitle,True);
}

function SetEditBoxTip (string _szToolTip)
{
	EditBox.ToolTipString=_szToolTip;
}

function SetDisableButton (bool _bDisable)
{
	if ( _bDisable )
	{
		EditBox.m_BorderColor=Root.Colors.ButtonTextColor[1];
		Button.m_BorderColor=Root.Colors.ButtonTextColor[1];
		Button.bDisabled=True;
		m_pComboTextLabel.TextColor=Root.Colors.ButtonTextColor[1];
		m_bDisabled=True;
	}
}

defaultproperties
{
    ListClass=Class'R6WindowComboList'
}
