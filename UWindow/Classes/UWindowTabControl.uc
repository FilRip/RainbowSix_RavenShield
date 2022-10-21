//================================================================================
// UWindowTabControl.
//================================================================================
class UWindowTabControl extends UWindowListControl;

var bool bMultiLine;
var bool bSelectNearestTabOnRemove;
var bool m_bTabButton;
var UWindowTabControlLeftButton LeftButton;
var UWindowTabControlRightButton RightButton;
var UWindowTabControlTabArea TabArea;
var UWindowTabControlItem SelectedTab;

function Created ()
{
	Super.Created();
	SelectedTab=None;
	TabArea=UWindowTabControlTabArea(CreateWindow(Class'UWindowTabControlTabArea',0.00,0.00,WinWidth,LookAndFeel.Size_TabAreaHeight + LookAndFeel.Size_TabAreaOverhangHeight));
	TabArea.bAlwaysOnTop=True;
	if ( m_bTabButton )
	{
		LeftButton=UWindowTabControlLeftButton(CreateWindow(Class'UWindowTabControlLeftButton',WinWidth - 20,0.00,10.00,12.00));
		RightButton=UWindowTabControlRightButton(CreateWindow(Class'UWindowTabControlRightButton',WinWidth - 10,0.00,10.00,12.00));
	}
}

function BeforePaint (Canvas C, float X, float Y)
{
	TabArea.WinTop=0.00;
	TabArea.WinLeft=0.00;
	if ( bMultiLine )
	{
		TabArea.WinWidth=WinWidth;
	}
	TabArea.LayoutTabs(C);
	WinHeight=LookAndFeel.Size_TabAreaHeight * TabArea.TabRows + LookAndFeel.Size_TabAreaOverhangHeight;
	TabArea.WinHeight=WinHeight;
	Super.BeforePaint(C,X,Y);
}

function SetMultiLine (bool InMultiLine)
{
	bMultiLine=InMultiLine;
	if ( bMultiLine )
	{
		LeftButton.HideWindow();
		RightButton.HideWindow();
	}
	else
	{
		LeftButton.ShowWindow();
		RightButton.ShowWindow();
	}
}

function Paint (Canvas C, float X, float Y)
{
	local Region R;
	local Texture t;

	if (  !m_bNotDisplayBkg )
	{
		t=GetLookAndFeelTexture();
		R=LookAndFeel.TabBackground;
		DrawStretchedTextureSegment(C,0.00,0.00,WinWidth,LookAndFeel.Size_TabAreaHeight * TabArea.TabRows,R.X,R.Y,R.W,R.H,t);
	}
}

function UWindowTabControlItem AddTab (string Caption, optional int _iItemID)
{
	local UWindowTabControlItem i;

	i=UWindowTabControlItem(Items.Append(ListClass));
	i.Owner=self;
	i.SetCaption(Caption);
	i.m_iItemID=_iItemID;
	if ( SelectedTab == None )
	{
		SelectedTab=i;
	}
	return i;
}

function UWindowTabControlItem InsertTab (UWindowTabControlItem BeforeTab, string Caption, optional int _iItemID)
{
	local UWindowTabControlItem i;

	i=UWindowTabControlItem(BeforeTab.InsertBefore(ListClass));
	i.Owner=self;
	i.SetCaption(Caption);
	i.m_iItemID=_iItemID;
	if ( SelectedTab == None )
	{
		SelectedTab=i;
	}
	return i;
}

function GotoTab (UWindowTabControlItem NewSelected, optional bool bByUser)
{
	if ( (SelectedTab != NewSelected) && bByUser )
	{
//		LookAndFeel.PlayMenuSound(self,SLOT_Music);
	}
	SelectedTab=NewSelected;
	TabArea.bShowSelected=True;
}

function UWindowTabControlItem GetTab (string Caption)
{
	local UWindowTabControlItem i;

	i=UWindowTabControlItem(Items.Next);
JL0019:
	if ( i != None )
	{
		if ( i.Caption == Caption )
		{
			return i;
		}
		i=UWindowTabControlItem(i.Next);
		goto JL0019;
	}
	return None;
}

function DeleteTab (UWindowTabControlItem Tab)
{
	local UWindowTabControlItem NextTab;
	local UWindowTabControlItem PrevTab;

	NextTab=UWindowTabControlItem(Tab.Next);
	PrevTab=UWindowTabControlItem(Tab.Prev);
	Tab.Remove();
	if ( SelectedTab == Tab )
	{
		if ( bSelectNearestTabOnRemove )
		{
			Tab=NextTab;
			if ( Tab == None )
			{
				Tab=PrevTab;
			}
			GotoTab(Tab);
		}
		else
		{
			GotoTab(UWindowTabControlItem(Items.Next));
		}
	}
}

defaultproperties
{
    ListClass=Class'UWindowTabControlItem'
}
