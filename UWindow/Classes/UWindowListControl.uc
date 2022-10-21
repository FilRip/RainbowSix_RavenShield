//================================================================================
// UWindowListControl.
//================================================================================
class UWindowListControl extends UWindowDialogControl;

var UWindowList Items;
var Class<UWindowList> ListClass;

function DrawItem (Canvas C, UWindowList Item, float X, float Y, float W, float H)
{
}

function Created ()
{
	Super.Created();
	Items=new ListClass;
	Items.Last=Items;
	Items.Next=None;
	Items.Prev=None;
	Items.Sentinel=Items;
}

function UWindowList GetItemAtIndex (int _iIndex)
{
	local UWindowList CurItem;
	local int i;

	if ( Items.Next == None )
	{
		if ( _iIndex == 0 )
		{
			return Items.Append(ListClass);
		}
		else
		{
			return None;
		}
	}
	CurItem=Items.Next;
	i=0;
JL0054:
	if ( CurItem != None )
	{
		if ( i == _iIndex )
		{
			CurItem.m_bShowThisItem=True;
		}
		else
		{
			CurItem=CurItem.Next;
			i++;
			goto JL0054;
		}
	}
	if ( CurItem == None )
	{
		return Items.Append(ListClass);
	}
	else
	{
		return CurItem;
	}
}

function ClearListOfItems ()
{
	local UWindowList CurItem;
	local int i;
	local int iListLength;

	if ( Items.Next == None )
	{
		return;
	}
	CurItem=Items.Next;
	iListLength=Items.Count();
	i=0;
JL0046:
	if ( i < iListLength )
	{
		if ( CurItem != None )
		{
			CurItem.ClearItem();
			CurItem=CurItem.Next;
		}
		else
		{
			goto JL0093;
		}
		i++;
		goto JL0046;
	}
JL0093:
}
