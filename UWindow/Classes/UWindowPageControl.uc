//================================================================================
// UWindowPageControl.
//================================================================================
class UWindowPageControl extends UWindowTabControl;

function ResolutionChanged (float W, float H)
{
	local UWindowPageControlPage i;

	i=UWindowPageControlPage(Items.Next);
JL0019:
	if ( i != None )
	{
		if ( (i.Page != None) && (i != SelectedTab) )
		{
			i.Page.ResolutionChanged(W,H);
		}
		i=UWindowPageControlPage(i.Next);
		goto JL0019;
	}
	if ( SelectedTab != None )
	{
		UWindowPageControlPage(SelectedTab).Page.ResolutionChanged(W,H);
	}
}

function NotifyQuitUnreal ()
{
	local UWindowPageControlPage i;

	i=UWindowPageControlPage(Items.Next);
JL0019:
	if ( i != None )
	{
		if ( i.Page != None )
		{
			i.Page.NotifyQuitUnreal();
		}
		i=UWindowPageControlPage(i.Next);
		goto JL0019;
	}
}

function NotifyBeforeLevelChange ()
{
	local UWindowPageControlPage i;

	i=UWindowPageControlPage(Items.Next);
JL0019:
	if ( i != None )
	{
		if ( i.Page != None )
		{
			i.Page.NotifyBeforeLevelChange();
		}
		i=UWindowPageControlPage(i.Next);
		goto JL0019;
	}
}

function NotifyAfterLevelChange ()
{
	local UWindowPageControlPage i;

	i=UWindowPageControlPage(Items.Next);
JL0019:
	if ( i != None )
	{
		if ( i.Page != None )
		{
			i.Page.NotifyAfterLevelChange();
		}
		i=UWindowPageControlPage(i.Next);
		goto JL0019;
	}
}

function GetDesiredDimensions (out float W, out float H)
{
	local float MaxW;
	local float MaxH;
	local float tW;
	local float tH;
	local UWindowPageControlPage i;

	MaxW=0.00;
	MaxH=0.00;
	i=UWindowPageControlPage(Items.Next);
JL002F:
	if ( i != None )
	{
		if ( i.Page != None )
		{
			i.Page.GetDesiredDimensions(tW,tH);
		}
		if ( tW > MaxW )
		{
			MaxW=tW;
		}
		if ( tH > MaxH )
		{
			MaxH=tH;
		}
		i=UWindowPageControlPage(i.Next);
		goto JL002F;
	}
	W=MaxW;
	H=MaxH + TabArea.WinHeight;
}

function BeforePaint (Canvas C, float X, float Y)
{
	local float OldWinHeight;
	local UWindowPageControlPage i;

	OldWinHeight=WinHeight;
	Super.BeforePaint(C,X,Y);
	WinHeight=OldWinHeight;
	i=UWindowPageControlPage(Items.Next);
JL0044:
	if ( i != None )
	{
		LookAndFeel.Tab_SetTabPageSize(self,i.Page);
		i=UWindowPageControlPage(i.Next);
		goto JL0044;
	}
}

function Paint (Canvas C, float X, float Y)
{
	Super.Paint(C,X,Y);
	LookAndFeel.Tab_DrawTabPageArea(self,C,UWindowPageControlPage(SelectedTab).Page);
}

function UWindowPageControlPage AddPage (string Caption, Class<UWindowPageWindow> PageClass, optional name ObjectName)
{
	local UWindowPageControlPage P;

	P=UWindowPageControlPage(AddTab(Caption));
	P.Page=UWindowPageWindow(CreateWindow(PageClass,0.00,TabArea.WinHeight - LookAndFeel.TabSelectedM.H - LookAndFeel.TabUnselectedM.H,WinWidth,WinHeight - TabArea.WinHeight - LookAndFeel.TabSelectedM.H - LookAndFeel.TabUnselectedM.H,,,ObjectName));
	P.Page.OwnerTab=P;
	if ( P != SelectedTab )
	{
		P.Page.HideWindow();
	}
	else
	{
		if ( (UWindowPageControlPage(SelectedTab) != None) && WindowIsVisible() )
		{
			UWindowPageControlPage(SelectedTab).Page.ShowWindow();
			UWindowPageControlPage(SelectedTab).Page.BringToFront();
		}
	}
	return P;
}

function UWindowPageControlPage InsertPage (UWindowPageControlPage BeforePage, string Caption, Class<UWindowPageWindow> PageClass, optional name ObjectName)
{
	local UWindowPageControlPage P;

	if ( BeforePage == None )
	{
		return AddPage(Caption,PageClass);
	}
	P=UWindowPageControlPage(InsertTab(BeforePage,Caption));
	P.Page=UWindowPageWindow(CreateWindow(PageClass,0.00,TabArea.WinHeight - LookAndFeel.TabSelectedM.H - LookAndFeel.TabUnselectedM.H,WinWidth,WinHeight - TabArea.WinHeight - LookAndFeel.TabSelectedM.H - LookAndFeel.TabUnselectedM.H,,,ObjectName));
	P.Page.OwnerTab=P;
	if ( P != SelectedTab )
	{
		P.Page.HideWindow();
	}
	else
	{
		if ( (UWindowPageControlPage(SelectedTab) != None) && WindowIsVisible() )
		{
			UWindowPageControlPage(SelectedTab).Page.ShowWindow();
			UWindowPageControlPage(SelectedTab).Page.BringToFront();
		}
	}
	return P;
}

function UWindowPageControlPage GetPage (string Caption)
{
	return UWindowPageControlPage(GetTab(Caption));
}

function DeletePage (UWindowPageControlPage P)
{
	P.Page.Close(True);
	P.Page.HideWindow();
	DeleteTab(P);
}

function Close (optional bool bByParent)
{
	local UWindowPageControlPage i;

	i=UWindowPageControlPage(Items.Next);
JL0019:
	if ( i != None )
	{
		if ( i.Page != None )
		{
			i.Page.Close(True);
		}
		i=UWindowPageControlPage(i.Next);
		goto JL0019;
	}
	Super.Close(bByParent);
}

function GotoTab (UWindowTabControlItem NewSelected, optional bool bByUser)
{
	local UWindowPageControlPage i;

	Super.GotoTab(NewSelected,bByUser);
	i=UWindowPageControlPage(Items.Next);
JL002A:
	if ( i != None )
	{
		if ( i != NewSelected )
		{
			i.Page.HideWindow();
		}
		i=UWindowPageControlPage(i.Next);
		goto JL002A;
	}
	if ( UWindowPageControlPage(NewSelected) != None )
	{
		UWindowPageControlPage(NewSelected).Page.ShowWindow();
	}
}

function UWindowPageControlPage FirstPage ()
{
	return UWindowPageControlPage(Items.Next);
}

defaultproperties
{
    ListClass=Class'UWindowPageControlPage'
}
