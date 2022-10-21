//================================================================================
// UWindowComboListItem.
//================================================================================
class UWindowComboListItem extends UWindowList;

var int SortWeight;
var bool bDisabled;
var float ItemTop;
var string Value;
var string Value2;

function int Compare (UWindowList t, UWindowList B)
{
	local UWindowComboListItem TI;
	local UWindowComboListItem BI;
	local string TS;
	local string BS;

	TI=UWindowComboListItem(t);
	BI=UWindowComboListItem(B);
	if ( TI.SortWeight == BI.SortWeight )
	{
		TS=Caps(TI.Value);
		BS=Caps(BI.Value);
		if ( TS == BS )
		{
			return 0;
		}
		if ( TS < BS )
		{
			return -1;
		}
		return 1;
	}
	else
	{
		return TI.SortWeight - BI.SortWeight;
	}
}
