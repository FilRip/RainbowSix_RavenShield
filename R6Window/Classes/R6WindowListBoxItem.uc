//================================================================================
// R6WindowListBoxItem.
//================================================================================
class R6WindowListBoxItem extends UWindowListBoxItem;

var int m_iSeparatorID;
var bool m_IsSeparator;
var bool m_addedToSubList;
var Texture m_Icon;
var R6WindowListBoxItem m_ParentListItem;
var Object m_Object;
var Region m_IconRegion;
var Region m_IconSelectedRegion;
var string m_szMisc;

function R6WindowListBoxItem AppendAfterSeparator (Class<R6WindowListBoxItem> C, int iSeparatorID)
{
	local UWindowList NewElement;
	local UWindowList TempItem;
	local R6WindowListBoxItem workItem;

	TempItem=Next;
JL000B:
	if ( (TempItem != None) && (NewElement == None) )
	{
		workItem=R6WindowListBoxItem(TempItem);
		if ( (workItem != None) && workItem.m_IsSeparator && (workItem.m_iSeparatorID == iSeparatorID) )
		{
			NewElement=workItem.InsertAfter(Class'R6WindowListBoxItem');
		}
		TempItem=TempItem.Next;
		goto JL000B;
	}
	return R6WindowListBoxItem(NewElement);
}

function R6WindowListBoxItem InsertLastAfterSeparator (Class<R6WindowListBoxItem> C, int iSeparatorID)
{
	local UWindowList NewElement;
	local UWindowList TempItem;
	local UWindowList LastItem;
	local R6WindowListBoxItem workItem;
	local R6WindowListBoxItem Separator;
	local bool bSeparatorFound;

	TempItem=Next;
JL000B:
	if ( (TempItem != None) && (bSeparatorFound == False) )
	{
		workItem=R6WindowListBoxItem(TempItem);
		if ( (workItem != None) && workItem.m_IsSeparator && (workItem.m_iSeparatorID == iSeparatorID) )
		{
			Separator=workItem;
			bSeparatorFound=True;
		}
		LastItem=TempItem;
		TempItem=TempItem.Next;
		goto JL000B;
	}
JL00A2:
	if ( (TempItem != None) && (R6WindowListBoxItem(TempItem).m_IsSeparator == False) )
	{
		LastItem=TempItem;
		TempItem=TempItem.Next;
		goto JL00A2;
	}
	NewElement=LastItem.InsertAfter(Class'R6WindowListBoxItem');
	return R6WindowListBoxItem(NewElement);
}

function int FindItemIndex (UWindowList Item)
{
	local UWindowList L;
	local int i;

	L=Next;
	i=0;
JL0012:
	if ( i < Count() )
	{
		if ( L == Item )
		{
			return i;
		}
		L=L.Next;
		i++;
		goto JL0012;
	}
	return -1;
}