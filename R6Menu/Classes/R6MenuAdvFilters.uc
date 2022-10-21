//================================================================================
// R6MenuAdvFilters.
//================================================================================
class R6MenuAdvFilters extends UWindowDialogClientWindow;

var R6WindowListRestKit m_pListGen;

function Created ()
{
	m_pListGen=R6WindowListRestKit(CreateWindow(Class'R6WindowListRestKit',0.00,0.00,WinWidth,WinHeight,self));
	m_pListGen.m_fXItemOffset=5.00;
	m_pListGen.bAlwaysBehind=True;
}

function AddButtonInList (bool _bSelected, string _szLoc, string _szTip, int _iButtonID)
{
	local R6WindowListGeneralItem NewItem;
	local float fXOffset;
	local float fYOffset;
	local float fYStep;
	local float fWidth;
	local float fHeight;
	local Font ButtonFont;
	local int i;

	fXOffset=5.00;
	fYOffset=7.00;
	fWidth=WinWidth - 2 * fXOffset;
	fHeight=15.00;
	ButtonFont=Root.Fonts[5];
	NewItem=R6WindowListGeneralItem(m_pListGen.GetItemAtIndex(m_pListGen.Items.CountShown()));
	NewItem.m_pR6WindowButtonBox=R6WindowButtonBox(CreateControl(Class'R6WindowButtonBox',fXOffset,0.00,fWidth,fHeight,self));
	NewItem.m_pR6WindowButtonBox.m_TextFont=ButtonFont;
	NewItem.m_pR6WindowButtonBox.m_vTextColor=Root.Colors.White;
	NewItem.m_pR6WindowButtonBox.m_vBorder=Root.Colors.White;
	NewItem.m_pR6WindowButtonBox.m_bSelected=_bSelected;
	NewItem.m_pR6WindowButtonBox.m_szMiscText="";
	NewItem.m_pR6WindowButtonBox.m_AdviceWindow=self;
	NewItem.m_pR6WindowButtonBox.CreateTextAndBox(_szLoc,_szTip,0.00,_iButtonID);
}

function Notify (UWindowDialogControl C, byte E)
{
	if ( C.IsA('R6WindowButtonBox') )
	{
		if ( E == 2 )
		{
			if ( OwnerWindow != None )
			{
				R6MenuMPMenuTab(OwnerWindow).Notify(C,E);
			}
		}
	}
}

function MouseWheelDown (float X, float Y)
{
	if ( m_pListGen != None )
	{
		m_pListGen.MouseWheelDown(X,Y);
	}
}

function MouseWheelUp (float X, float Y)
{
	if ( m_pListGen != None )
	{
		m_pListGen.MouseWheelUp(X,Y);
	}
}