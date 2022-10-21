//================================================================================
// UWindowPulldownMenuItem.
//================================================================================
class UWindowPulldownMenuItem extends UWindowList;

var byte HotKey;
var bool bChecked;
var bool bDisabled;
var float ItemTop;
var Texture Graphic;
var UWindowPulldownMenu SubMenu;
var UWindowPulldownMenu Owner;
var string Caption;

function UWindowPulldownMenu CreateSubMenu (Class<UWindowPulldownMenu> MenuClass, optional UWindowWindow InOwnerWindow)
{
	SubMenu=UWindowPulldownMenu(Owner.ParentWindow.CreateWindow(MenuClass,0.00,0.00,100.00,100.00,InOwnerWindow));
	SubMenu.HideWindow();
	SubMenu.Owner=self;
	return SubMenu;
}

function Select ()
{
	if ( SubMenu != None )
	{
		SubMenu.WinLeft=Owner.WinLeft + Owner.WinWidth - Owner.HBorder;
		SubMenu.WinTop=ItemTop - Owner.VBorder;
		SubMenu.ShowWindow();
	}
}

function SetCaption (string C)
{
	local string Junk;
	local string Junk2;

	Caption=C;
	HotKey=Owner.ParseAmpersand(C,Junk,Junk2,False);
}

function DeSelect ()
{
	if ( SubMenu != None )
	{
		SubMenu.DeSelect();
		SubMenu.HideWindow();
	}
}

function CloseUp ()
{
	Owner.CloseUp();
}

function UWindowMenuBar GetMenuBar ()
{
	return Owner.GetMenuBar();
}
