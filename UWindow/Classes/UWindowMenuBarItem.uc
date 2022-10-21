//================================================================================
// UWindowMenuBarItem.
//================================================================================
class UWindowMenuBarItem extends UWindowList;

var byte HotKey;
var bool bHelp;
var float ItemLeft;
var float ItemWidth;
var UWindowMenuBar Owner;
var UWindowPulldownMenu Menu;
var string Caption;

function SetHelp (bool B)
{
	bHelp=B;
}

function SetCaption (string C)
{
	local string Junk;
	local string Junk2;

	Caption=C;
	HotKey=Owner.ParseAmpersand(C,Junk,Junk2,False);
}

function UWindowPulldownMenu CreateMenu (Class<UWindowPulldownMenu> MenuClass)
{
	Menu=UWindowPulldownMenu(Owner.ParentWindow.CreateWindow(MenuClass,0.00,0.00,100.00,100.00));
	Menu.HideWindow();
	Menu.Owner=self;
	return Menu;
}

function DeSelect ()
{
//	Owner.LookAndFeel.PlayMenuSound(Owner,SLOT_Ambient);
	Menu.DeSelect();
	Menu.HideWindow();
}

function Select ()
{
//	Owner.LookAndFeel.PlayMenuSound(Owner,SLOT_None);
	Menu.ShowWindow();
	Menu.WinLeft=ItemLeft + Owner.WinLeft;
	Menu.WinTop=14.00;
	Menu.WinWidth=100.00;
	Menu.WinHeight=100.00;
}

function CloseUp ()
{
	Owner.CloseUp();
}

function UWindowMenuBar GetMenuBar ()
{
	return Owner.GetMenuBar();
}
