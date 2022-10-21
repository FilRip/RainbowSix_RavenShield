//================================================================================
// UWindowHotkeyWindowList.
//================================================================================
class UWindowHotkeyWindowList extends UWindowList;

var UWindowWindow Window;

function UWindowHotkeyWindowList FindWindow (UWindowWindow W)
{
	local UWindowHotkeyWindowList L;

	for (L=UWindowHotkeyWindowList(Next);L != None;L=UWindowHotkeyWindowList(L.Next))
	{
		if ( L.Window == W )
		{
			return L;
		}
	}
	return None;
}
