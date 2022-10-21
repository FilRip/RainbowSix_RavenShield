//================================================================================
// UWindowList.
//================================================================================
class UWindowList extends UWindowBase;

var int InternalCount;
var int CompareCount;
var bool bItemOrderChanged;
var bool bSuspendableSort;
var bool bSortSuspended;
var bool bTreeSort;
var bool m_bShowThisItem;
var UWindowList Next;
var UWindowList Last;
var UWindowList Prev;
var UWindowList Sentinel;
var UWindowList CurrentSortItem;
var UWindowList BranchLeft;
var UWindowList BranchRight;
var UWindowList ParentNode;

function UWindowList CreateItem (Class<UWindowList> C)
{
	local UWindowList NewElement;

	NewElement=new C;
	return NewElement;
}

function GraftLeft (UWindowList NewLeft)
{
	assert (Sentinel.bTreeSort);
	BranchLeft=NewLeft;
	if ( NewLeft != None )
	{
		NewLeft.ParentNode=self;
	}
}

function GraftRight (UWindowList NewRight)
{
	assert (Sentinel.bTreeSort);
	BranchRight=NewRight;
	if ( NewRight != None )
	{
		NewRight.ParentNode=self;
	}
}

function UWindowList RightMost ()
{
	local UWindowList L;

	assert (Sentinel.bTreeSort);
	if ( BranchRight == None )
	{
		return None;
	}
	L=self;
JL0026:
	if ( L.BranchRight != None )
	{
		L=L.BranchRight;
		goto JL0026;
	}
	return L;
}

function UWindowList LeftMost ()
{
	local UWindowList L;

	assert (Sentinel.bTreeSort);
	if ( BranchLeft == None )
	{
		return None;
	}
	L=self;
JL0026:
	if ( L.BranchLeft != None )
	{
		L=L.BranchLeft;
		goto JL0026;
	}
	return L;
}

function Remove ()
{
	local UWindowList t;

	if ( Next != None )
	{
		Next.Prev=Prev;
	}
	if ( Prev != None )
	{
		Prev.Next=Next;
	}
	if ( Sentinel != None )
	{
		if ( Sentinel.bTreeSort && (ParentNode != None) )
		{
			if ( BranchLeft != None )
			{
				if ( ParentNode.BranchLeft == self )
				{
					ParentNode.GraftLeft(BranchLeft);
				}
				if ( ParentNode.BranchRight == self )
				{
					ParentNode.GraftRight(BranchLeft);
				}
				t=BranchLeft.RightMost();
				if ( t != None )
				{
					t.GraftRight(BranchRight);
				}
			}
			else
			{
				if ( ParentNode.BranchLeft == self )
				{
					ParentNode.GraftLeft(BranchRight);
				}
				if ( ParentNode.BranchRight == self )
				{
					ParentNode.GraftRight(BranchRight);
				}
			}
			ParentNode=None;
			BranchLeft=None;
			BranchRight=None;
		}
		Sentinel.InternalCount--;
		Sentinel.bItemOrderChanged=True;
		if ( Sentinel.Last == self )
		{
			Sentinel.Last=Prev;
		}
		Prev=None;
		Next=None;
		Sentinel=None;
	}
}

function int Compare (UWindowList t, UWindowList B)
{
	return 0;
}

function UWindowList InsertBefore (Class<UWindowList> C)
{
	local UWindowList NewElement;

	NewElement=CreateItem(C);
	InsertItemBefore(NewElement);
	return NewElement;
}

function UWindowList InsertAfter (Class<UWindowList> C)
{
	local UWindowList NewElement;

	NewElement=CreateItem(C);
	InsertItemAfter(NewElement);
	return NewElement;
}

function InsertItemBefore (UWindowList NewElement)
{
	assert (Sentinel != self);
	NewElement.BranchLeft=None;
	NewElement.BranchRight=None;
	NewElement.ParentNode=None;
	NewElement.Sentinel=Sentinel;
	NewElement.BranchLeft=None;
	NewElement.BranchRight=None;
	NewElement.ParentNode=None;
	NewElement.Prev=Prev;
	Prev.Next=NewElement;
	Prev=NewElement;
	NewElement.Next=self;
	if ( Sentinel.Next == self )
	{
		Sentinel.Next=NewElement;
	}
	Sentinel.InternalCount++;
	Sentinel.bItemOrderChanged=True;
}

function InsertItemAfter (UWindowList NewElement, optional bool bCheckShowItem)
{
	local UWindowList N;

	N=Next;
	if ( bCheckShowItem )
	{
JL0014:
		if ( (N != None) &&  !N.ShowThisItem() )
		{
			N=N.Next;
			goto JL0014;
		}
	}
	if ( N != None )
	{
		N.InsertItemBefore(NewElement);
	}
	else
	{
		Sentinel.DoAppendItem(NewElement);
	}
	Sentinel.bItemOrderChanged=True;
}

function ContinueSort ()
{
	local UWindowList N;

	CompareCount=0;
	bSortSuspended=False;
JL000F:
	if ( CurrentSortItem != None )
	{
		N=CurrentSortItem.Next;
		AppendItem(CurrentSortItem);
		CurrentSortItem=N;
		if ( (CompareCount >= 10000) && bSuspendableSort )
		{
			bSortSuspended=True;
			return;
		}
		goto JL000F;
	}
}

function Tick (float Delta)
{
	if ( bSortSuspended )
	{
		ContinueSort();
	}
}

function UWindowList Sort ()
{
	local UWindowList S;
	local UWindowList CurrentItem;
	local UWindowList Previous;
	local UWindowList Best;
	local UWindowList BestPrev;

	if ( bTreeSort )
	{
		if ( bSortSuspended )
		{
			ContinueSort();
			return self;
		}
		CurrentSortItem=Next;
		DisconnectList();
		ContinueSort();
		return self;
	}
	CurrentItem=self;
JL003A:
	if ( CurrentItem != None )
	{
		S=CurrentItem.Next;
		Best=CurrentItem.Next;
		Previous=CurrentItem;
		BestPrev=CurrentItem;
JL0083:
		if ( S != None )
		{
			if ( CurrentItem.Compare(S,Best) <= 0 )
			{
				Best=S;
				BestPrev=Previous;
			}
			Previous=S;
			S=S.Next;
			goto JL0083;
		}
		if ( Best != CurrentItem.Next )
		{
			BestPrev.Next=Best.Next;
			if ( BestPrev.Next != None )
			{
				BestPrev.Next.Prev=BestPrev;
			}
			Best.Prev=CurrentItem;
			Best.Next=CurrentItem.Next;
			CurrentItem.Next.Prev=Best;
			CurrentItem.Next=Best;
			if ( Sentinel.Last == Best )
			{
				Sentinel.Last=BestPrev;
				if ( Sentinel.Last == None )
				{
					Sentinel.Last=Sentinel;
				}
			}
		}
		CurrentItem=CurrentItem.Next;
		goto JL003A;
	}
	return self;
}

function DisconnectList ()
{
	Next=None;
	Last=self;
	Prev=None;
	BranchLeft=None;
	BranchRight=None;
	ParentNode=None;
	InternalCount=0;
	Sentinel.bItemOrderChanged=True;
}

function DestroyList ()
{
	local UWindowList L;
	local UWindowList temp;

	L=Next;
	InternalCount=0;
	if ( Sentinel != None )
	{
		Sentinel.bItemOrderChanged=True;
	}
JL002E:
	if ( L != None )
	{
		temp=L.Next;
		L.DestroyListItem();
		L=temp;
		goto JL002E;
	}
	DestroyListItem();
}

function DestroyListItem ()
{
	Next=None;
	Last=self;
	Sentinel=None;
	Prev=None;
	BranchLeft=None;
	BranchRight=None;
	ParentNode=None;
}

function int CountShown ()
{
	local int C;
	local UWindowList i;

	i=Next;
JL000B:
	if ( i != None )
	{
		if ( i.ShowThisItem() )
		{
			C++;
		}
		i=i.Next;
		goto JL000B;
	}
	return C;
}

function UWindowList CopyExistingListItem (Class<UWindowList> ItemClass, UWindowList SourceItem)
{
	local UWindowList i;

	i=Append(ItemClass);
	Sentinel.bItemOrderChanged=True;
	return i;
}

function bool ShowThisItem ()
{
	return m_bShowThisItem;
}

function int Count ()
{
	return InternalCount;
}

function MoveItemSorted (UWindowList Item)
{
	local UWindowList L;

	if ( bTreeSort )
	{
		Item.Remove();
		AppendItem(Item);
	}
	else
	{
		L=Next;
JL0031:
		if ( L != None )
		{
			if ( Compare(Item,L) <= 0 )
			{
				goto JL006C;
			}
			L=L.Next;
			goto JL0031;
		}
JL006C:
		if ( L != Item )
		{
			Item.Remove();
			if ( L == None )
			{
				AppendItem(Item);
			}
			else
			{
				L.InsertItemBefore(Item);
			}
		}
	}
}

function SetupSentinel (optional bool bInTreeSort)
{
	Last=self;
	Next=None;
	Prev=None;
	BranchLeft=None;
	BranchRight=None;
	ParentNode=None;
	Sentinel=self;
	InternalCount=0;
	bItemOrderChanged=True;
	bTreeSort=bInTreeSort;
}

function Validate ()
{
	local UWindowList i;
	local UWindowList Previous;
	local int Count;

	if ( Sentinel != self )
	{
		Log("Calling Sentinel.Validate() from " $ string(self));
		Sentinel.Validate();
		return;
	}
	Log("BEGIN Validate(): " $ string(Class));
	Count=0;
	Previous=self;
	i=Next;
JL007E:
	if ( i != None )
	{
		Log("Checking item: " $ string(Count));
		if ( i.Sentinel != self )
		{
			Log("   I.Sentinel reference is broken");
		}
		if ( i.Prev != Previous )
		{
			Log("   I.Prev reference is broken");
		}
		if ( (Last == i) && (i.Next != None) )
		{
			Log("   Item is Sentinel.Last but Item has valid Next");
		}
		if ( (i.Next == None) && (Last != i) )
		{
			Log("   Item is Item.Next is none, but Item is not Sentinel.Last");
		}
		Previous=i;
		Count++;
		i=i.Next;
		goto JL007E;
	}
	Log("END Validate(): " $ string(Class));
}

function UWindowList Append (Class<UWindowList> C)
{
	local UWindowList NewElement;

	NewElement=CreateItem(C);
	AppendItem(NewElement);
	return NewElement;
}

function AppendItem (UWindowList NewElement)
{
	local UWindowList Node;
	local UWindowList OldNode;
	local UWindowList temp;
	local int test;

	if ( bTreeSort )
	{
		if ( (Next != None) && (Last != self) )
		{
			if ( Compare(NewElement,Last) >= 0 )
			{
				Node=Last;
				Node.InsertItemAfter(NewElement,False);
				Node.GraftRight(NewElement);
				return;
			}
			if ( Compare(NewElement,Next) <= 0 )
			{
				Node=Next;
				Node.InsertItemBefore(NewElement);
				Node.GraftLeft(NewElement);
				return;
			}
		}
		Node=self;
JL00BF:
		if ( True )
		{
			if ( Node == self )
			{
				test=1;
			}
			else
			{
				test=Compare(NewElement,Node);
			}
			if ( test == 0 )
			{
				Node.InsertItemAfter(NewElement,False);
				return;
			}
			else
			{
				if ( test > 0 )
				{
					OldNode=Node;
					Node=Node.BranchRight;
					if ( Node == None )
					{
						temp=OldNode;
JL0153:
						if ( (temp.Next != None) && (temp.Next.ParentNode == None) )
						{
							temp=temp.Next;
							goto JL0153;
						}
						temp.InsertItemAfter(NewElement,False);
						OldNode.GraftRight(NewElement);
						return;
					}
				}
				else
				{
					OldNode=Node;
					Node=Node.BranchLeft;
					if ( Node == None )
					{
						OldNode.InsertItemBefore(NewElement);
						OldNode.GraftLeft(NewElement);
						return;
					}
				}
			}
			goto JL00BF;
		}
	}
	else
	{
		DoAppendItem(NewElement);
	}
}

function DoAppendItem (UWindowList NewElement)
{
	NewElement.Next=None;
	Last.Next=NewElement;
	NewElement.Prev=Last;
	NewElement.Sentinel=self;
	NewElement.BranchLeft=None;
	NewElement.BranchRight=None;
	NewElement.ParentNode=None;
	Last=NewElement;
	Sentinel.InternalCount++;
	Sentinel.bItemOrderChanged=True;
}

function UWindowList Insert (Class<UWindowList> C)
{
	local UWindowList NewElement;

	NewElement=CreateItem(C);
	InsertItem(NewElement);
	return NewElement;
}

function InsertItem (UWindowList NewElement)
{
	NewElement.Next=Next;
	if ( Next != None )
	{
		Next.Prev=NewElement;
	}
	Next=NewElement;
	if ( Last == self )
	{
		Last=Next;
	}
	NewElement.Prev=self;
	NewElement.Sentinel=self;
	NewElement.BranchLeft=None;
	NewElement.BranchRight=None;
	NewElement.ParentNode=None;
	Sentinel.InternalCount++;
	Sentinel.bItemOrderChanged=True;
}

function UWindowList FindEntry (int Index)
{
	local UWindowList L;
	local int i;

	L=Next;
	i=0;
JL0012:
	if ( i < Index )
	{
		L=L.Next;
		if ( L == None )
		{
			return None;
		}
		i++;
		goto JL0012;
	}
	return L;
}

function AppendListCopy (UWindowList L)
{
	if ( L == None )
	{
		return;
	}
	L=L.Next;
JL0021:
	if ( L != None )
	{
		CopyExistingListItem(L.Class,L);
		L=L.Next;
		goto JL0021;
	}
}

function Clear ()
{
	InternalCount=0;
	ParentNode=None;
	BranchLeft=None;
	BranchRight=None;
	bItemOrderChanged=True;
	Next=None;
	Last=self;
}

function ClearItem ()
{
}

defaultproperties
{
    m_bShowThisItem=True
}
