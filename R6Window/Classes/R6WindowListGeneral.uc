//================================================================================
// R6WindowListGeneral.
//================================================================================
class R6WindowListGeneral extends UWindowListControl;

var float m_fItemWidth;
var float m_fItemHeight;
var float m_fStepBetweenItem;

function Paint (Canvas C, float X, float Y)
{
	local float fX;
	local float fY;
	local UWindowList CurItem;

	if ( m_fItemWidth == 0 )
	{
		m_fItemWidth=WinWidth;
	}
	fX=(WinWidth - m_fItemWidth) / 2;
	CurItem=Items.Next;
JL0044:
	if ( CurItem != None )
	{
		DrawItem(C,CurItem,fX,fY,m_fItemWidth,m_fItemHeight);
		fY += m_fItemHeight + m_fStepBetweenItem;
		if ( fY >= WinHeight )
		{
			fY=0.00;
			fX += WinWidth;
		}
		CurItem=CurItem.Next;
		goto JL0044;
	}
}

function DrawItem (Canvas C, UWindowList Item, float X, float Y, float W, float H)
{
	local R6WindowListGeneralItem pListGenItem;

	pListGenItem=R6WindowListGeneralItem(Item);
	if ( pListGenItem.m_pR6WindowCounter != None )
	{
		pListGenItem.m_pR6WindowCounter.WinLeft=WinLeft + X;
		pListGenItem.m_pR6WindowCounter.WinTop=WinTop + Y;
		pListGenItem.m_pR6WindowCounter.WinHeight=H;
	}
	else
	{
		if ( pListGenItem.m_pR6WindowButtonBox != None )
		{
			pListGenItem.m_pR6WindowButtonBox.WinLeft=WinLeft + X;
			pListGenItem.m_pR6WindowButtonBox.WinTop=WinTop + Y;
			pListGenItem.m_pR6WindowButtonBox.WinHeight=H;
		}
		else
		{
			if ( pListGenItem.m_pR6WindowComboControl != None )
			{
				pListGenItem.m_pR6WindowComboControl.WinLeft=WinLeft + X;
				pListGenItem.m_pR6WindowComboControl.WinTop=WinTop + Y;
				pListGenItem.m_pR6WindowComboControl.WinHeight=H;
			}
		}
	}
}

function RemoveAllItems ()
{
	local R6WindowListGeneralItem ItemIndex;

	ItemIndex=R6WindowListGeneralItem(Items.Next);
JL0019:
	if ( ItemIndex != None )
	{
		if ( ItemIndex.m_pR6WindowCounter != None )
		{
			ItemIndex.m_pR6WindowCounter.HideWindow();
		}
		else
		{
			if ( ItemIndex.m_pR6WindowButtonBox != None )
			{
				ItemIndex.m_pR6WindowButtonBox.HideWindow();
			}
			else
			{
				if ( ItemIndex.m_pR6WindowComboControl != None )
				{
					ItemIndex.m_pR6WindowComboControl.HideWindow();
				}
			}
		}
		ItemIndex.Remove();
		ItemIndex=R6WindowListGeneralItem(Items.Next);
		goto JL0019;
	}
}

function ChangeVisualItems (bool _bVisible)
{
	local UWindowList i;

	if ( Items.Next != None )
	{
		i=Items.Next;
JL0028:
		if ( i != None )
		{
			if ( R6WindowListGeneralItem(i).m_pR6WindowCounter != None )
			{
				if ( _bVisible )
				{
					R6WindowListGeneralItem(i).m_pR6WindowCounter.ShowWindow();
				}
				else
				{
					R6WindowListGeneralItem(i).m_pR6WindowCounter.HideWindow();
				}
			}
			else
			{
				if ( R6WindowListGeneralItem(i).m_pR6WindowButtonBox != None )
				{
					if ( _bVisible )
					{
						R6WindowListGeneralItem(i).m_pR6WindowButtonBox.ShowWindow();
					}
					else
					{
						R6WindowListGeneralItem(i).m_pR6WindowButtonBox.HideWindow();
					}
				}
				else
				{
					if ( R6WindowListGeneralItem(i).m_pR6WindowComboControl != None )
					{
						if ( _bVisible )
						{
							R6WindowListGeneralItem(i).m_pR6WindowComboControl.ShowWindow();
						}
						else
						{
							R6WindowListGeneralItem(i).m_pR6WindowComboControl.HideWindow();
						}
					}
				}
			}
			i=i.Next;
			goto JL0028;
		}
	}
}

defaultproperties
{
    m_fItemHeight=15.00
    m_fStepBetweenItem=1.00
    ListClass=Class'R6WindowListGeneralItem'
}