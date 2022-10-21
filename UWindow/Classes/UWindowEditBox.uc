//================================================================================
// UWindowEditBox.
//================================================================================
class UWindowEditBox extends UWindowDialogControl;

var int CaretOffset;
var int MaxLength;
var bool bShowCaret;
var bool bNumericOnly;
var bool bNumericFloat;
var bool bCanEdit;
var bool bAllSelected;
var bool bDelayedNotify;
var bool bChangePending;
var bool bControlDown;
var bool bShiftDown;
var bool bHistory;
var bool bKeyDown;
var bool m_bMouseOn;
var bool m_bDrawEditBorders;
var bool m_bUseNewPaint;
var bool m_CurrentlyEditing;
var bool bSelectOnFocus;
var bool bPassword;
var bool m_bDrawEditBoxBG;
var bool bShowLog;
var float LastDrawTime;
var float offset;
var UWindowDialogControl NotifyOwner;
var UWindowEditBoxHistory HistoryList;
var UWindowEditBoxHistory CurrentHistory;
var string Value;
var string Value2;
var string OldValue;

function Created ()
{
	Super.Created();
	LastDrawTime=GetTime();
}

function SetHistory (bool bInHistory)
{
	bHistory=bInHistory;
	if ( bHistory && (HistoryList == None) )
	{
		HistoryList=new Class'UWindowEditBoxHistory';
		HistoryList.SetupSentinel();
		CurrentHistory=None;
	}
	else
	{
		if (  !bHistory && (HistoryList != None) )
		{
			HistoryList=None;
			CurrentHistory=None;
		}
	}
}

function SetEditable (bool bEditable)
{
	bCanEdit=bEditable;
}

function SetValue (string NewValue, optional string NewValue2, optional bool noUpdateHistory)
{
	Value=Left(NewValue,MaxLength);
	Value2=NewValue2;
	CaretOffset=Len(Value);
	offset=0.00;
	if (  !bHistory )
	{
		OldValue=Value;
	}
	else
	{
		if (  !noUpdateHistory )
		{
			if ( Value != "" )
			{
				CurrentHistory=UWindowEditBoxHistory(HistoryList.Insert(Class'UWindowEditBoxHistory'));
				CurrentHistory.HistoryText=Value;
				if ( bShowLog )
				{
					Log("Set value CurrentHistory.HistoryText" @ CurrentHistory.HistoryText);
				}
			}
			CurrentHistory=HistoryList;
		}
	}
	Notify(1);
}

function Clear ()
{
	CaretOffset=0;
	Value="";
	Value2="";
	bAllSelected=False;
	if ( bDelayedNotify )
	{
		bChangePending=True;
	}
	else
	{
		Notify(1);
	}
}

function SelectAll ()
{
	if ( bShowLog )
	{
		Log("SelectAll Begin: bcanedit" @ string(bCanEdit) @ "m_CurrentlyEditing" @ string(m_CurrentlyEditing) @ "value" @ Value @ "bAllSelected" @ string(bAllSelected));
	}
	if ( bCanEdit )
	{
		m_CurrentlyEditing=True;
		SetAcceptsFocus();
	}
	if ( Value != "" )
	{
		CaretOffset=Len(Value);
		bAllSelected= !bAllSelected;
	}
	if ( bShowLog )
	{
		Log("SelectAll End: bcanedit" @ string(bCanEdit) @ "m_CurrentlyEditing" @ string(m_CurrentlyEditing) @ "value" @ Value @ "bAllSelected" @ string(bAllSelected));
	}
}

function string GetValue ()
{
	return Value;
}

function string GetValue2 ()
{
	return Value2;
}

function Notify (byte E)
{
	if ( NotifyOwner != None )
	{
		NotifyOwner.Notify(E);
	}
	else
	{
		Super.Notify(E);
	}
}

function InsertText (string Text)
{
	local int i;

	i=0;
JL0007:
	if ( i < Len(Text) )
	{
		Insert(Asc(Mid(Text,i,1)));
		i++;
		goto JL0007;
	}
}

function bool Insert (byte C)
{
	local string NewValue;

	NewValue=Left(Value,CaretOffset) $ Chr(C) $ Mid(Value,CaretOffset);
	if ( Len(NewValue) > MaxLength )
	{
		return False;
	}
	CaretOffset++;
	Value=NewValue;
	if ( bDelayedNotify )
	{
		bChangePending=True;
	}
	else
	{
		Notify(1);
	}
	return True;
}

function bool Backspace ()
{
	local string NewValue;

	if ( CaretOffset == 0 )
	{
		return False;
	}
	NewValue=Left(Value,CaretOffset - 1) $ Mid(Value,CaretOffset);
	CaretOffset--;
	Value=NewValue;
	if ( bDelayedNotify )
	{
		bChangePending=True;
	}
	else
	{
		Notify(1);
	}
	return True;
}

function bool Delete ()
{
	local string NewValue;

	if ( CaretOffset == Len(Value) )
	{
		return False;
	}
	NewValue=Left(Value,CaretOffset) $ Mid(Value,CaretOffset + 1);
	Value=NewValue;
	Notify(1);
	return True;
}

function bool WordLeft ()
{
JL0000:
	if ( (CaretOffset > 0) && (Mid(Value,CaretOffset - 1,1) == " ") )
	{
		CaretOffset--;
		goto JL0000;
	}
JL002F:
	if ( (CaretOffset > 0) && (Mid(Value,CaretOffset - 1,1) != " ") )
	{
		CaretOffset--;
		goto JL002F;
	}
	LastDrawTime=GetTime();
	bShowCaret=True;
	return True;
}

function bool MoveLeft ()
{
	if ( CaretOffset == 0 )
	{
		return False;
	}
	CaretOffset--;
	LastDrawTime=GetTime();
	bShowCaret=True;
	return True;
}

function bool MoveRight ()
{
	if ( CaretOffset == Len(Value) )
	{
		return False;
	}
	CaretOffset++;
	LastDrawTime=GetTime();
	bShowCaret=True;
	return True;
}

function bool WordRight ()
{
JL0000:
	if ( (CaretOffset < Len(Value)) && (Mid(Value,CaretOffset,1) != " ") )
	{
		CaretOffset++;
		goto JL0000;
	}
JL0032:
	if ( (CaretOffset < Len(Value)) && (Mid(Value,CaretOffset,1) == " ") )
	{
		CaretOffset++;
		goto JL0032;
	}
	LastDrawTime=GetTime();
	bShowCaret=True;
	return True;
}

function bool MoveHome ()
{
	CaretOffset=0;
	LastDrawTime=GetTime();
	bShowCaret=True;
	return True;
}

function bool MoveEnd ()
{
	CaretOffset=Len(Value);
	LastDrawTime=GetTime();
	bShowCaret=True;
	return True;
}

function EditCopy ()
{
	if ( (bAllSelected ||  !bCanEdit) && m_CurrentlyEditing )
	{
		GetPlayerOwner().CopyToClipboard(Value);
	}
}

function EditPaste ()
{
	if ( bCanEdit && m_CurrentlyEditing )
	{
		if ( bAllSelected )
		{
			Clear();
		}
		InsertText(GetPlayerOwner().PasteFromClipboard());
	}
}

function EditCut ()
{
	if ( bCanEdit && m_CurrentlyEditing )
	{
		if ( bAllSelected )
		{
			GetPlayerOwner().CopyToClipboard(Value);
			bAllSelected=False;
			Clear();
		}
	}
	else
	{
		EditCopy();
	}
}

function KeyType (int Key, float MouseX, float MouseY)
{
	if ( bShowLog )
	{
		Log("UWindowEditBox::KeyType bCanEdit" @ string(bCanEdit) @ "bKeyDown" @ string(bKeyDown) @ "m_CurrentlyEditing" @ string(m_CurrentlyEditing));
	}
	if ( bCanEdit && bKeyDown && m_CurrentlyEditing )
	{
		if (  !bControlDown )
		{
			if ( bAllSelected )
			{
				Clear();
			}
			bAllSelected=False;
			if ( bNumericOnly )
			{
				if ( (Key >= 48) && (Key <= 57) )
				{
					Insert(Key);
				}
			}
			else
			{
				if ( (Key >= 32) && (Key < 256) )
				{
					Insert(Key);
				}
			}
		}
	}
}

function KeyUp (int Key, float X, float Y)
{
	bKeyDown=False;
	switch (Key)
	{
/*		case Root.Console.17:
		bControlDown=False;
		break;
		case Root.Console.16:
		bShiftDown=False;
		break;
		default:*/
	}
}

function KeyDown (int Key, float X, float Y)
{
	bKeyDown=True;
	switch (Key)
	{
/*		case Root.Console.17:
		bControlDown=True;
		break;
		case Root.Console.16:
		bShiftDown=True;
		break;
		case Root.Console.27:
		if ( bCanEdit && m_CurrentlyEditing )
		{
			if ( bShowLog )
			{
				Log("Escape pressed");
			}
			if (  !bHistory )
			{
				SetValue(OldValue,"",True);
			}
			else
			{
				if ( (CurrentHistory != None) && (CurrentHistory.Next != None) )
				{
					if ( bShowLog )
					{
						Log("CurrentHistory.HistoryText" @ CurrentHistory.HistoryText);
					}
					if ( bShowLog )
					{
						Log("CurrentHistory.Next.HistoryText" @ UWindowEditBoxHistory(CurrentHistory.Next).HistoryText);
					}
					SetValue(UWindowEditBoxHistory(CurrentHistory.Next).HistoryText,"",True);
				}
			}
			MoveEnd();
			DropSelection();
		}
		break;
		case Root.Console.13:
		if ( bCanEdit && m_CurrentlyEditing )
		{
			if (  !bHistory )
			{
				OldValue=Value;
			}
			else
			{
				if ( Value != "" )
				{
					CurrentHistory=UWindowEditBoxHistory(HistoryList.Insert(Class'UWindowEditBoxHistory'));
					CurrentHistory.HistoryText=Value;
					if ( bShowLog )
					{
						Log("Set value CurrentHistory.HistoryText" @ CurrentHistory.HistoryText);
					}
				}
				CurrentHistory=HistoryList;
			}
			MoveEnd();
			DropSelection();
			Notify(7);
		}
		break;
		case Root.Console.236:
		if ( bCanEdit )
		{
			Notify(14);
		}
		break;
		case Root.Console.237:
		if ( bCanEdit )
		{
			Notify(15);
		}
		break;
		case Root.Console.39:
		if ( bCanEdit && m_CurrentlyEditing )
		{
			if ( bControlDown )
			{
				WordRight();
			}
			else
			{
				MoveRight();
			}
			bAllSelected=False;
		}
		break;
		case Root.Console.37:
		if ( bCanEdit && m_CurrentlyEditing )
		{
			if ( bControlDown )
			{
				WordLeft();
			}
			else
			{
				MoveLeft();
			}
			bAllSelected=False;
		}
		break;
		case Root.Console.38:
		if ( bCanEdit && bHistory && m_CurrentlyEditing )
		{
			bAllSelected=False;
			if ( (CurrentHistory != None) && (CurrentHistory.Next != None) )
			{
				CurrentHistory=UWindowEditBoxHistory(CurrentHistory.Next);
				SetValue(CurrentHistory.HistoryText,"",True);
				MoveEnd();
			}
		}
		break;
		case Root.Console.40:
		if ( bCanEdit && bHistory && m_CurrentlyEditing )
		{
			bAllSelected=False;
			if ( (CurrentHistory != None) && (CurrentHistory.Prev != None) )
			{
				CurrentHistory=UWindowEditBoxHistory(CurrentHistory.Prev);
				SetValue(CurrentHistory.HistoryText,"",True);
				MoveEnd();
			}
		}
		break;
		case Root.Console.36:
		if ( bCanEdit && m_CurrentlyEditing )
		{
			MoveHome();
			bAllSelected=False;
		}
		break;
		case Root.Console.35:
		if ( bCanEdit && m_CurrentlyEditing )
		{
			MoveEnd();
			bAllSelected=False;
		}
		break;
		case Root.Console.8:
		if ( bCanEdit && m_CurrentlyEditing )
		{
			if ( bAllSelected )
			{
				Clear();
			}
			else
			{
				Backspace();
			}
			bAllSelected=False;
		}
		break;
		case Root.Console.46:
		if ( bCanEdit && m_CurrentlyEditing )
		{
			if ( bAllSelected )
			{
				Clear();
			}
			else
			{
				Delete();
			}
			bAllSelected=False;
		}
		break;
		case Root.Console.190:
		case Root.Console.110:
		if ( bNumericFloat )
		{
			Insert(Asc("."));
		}
		break;
		default:
		if ( bControlDown )
		{
			if ( (Key == Asc("c")) || (Key == Asc("C")) )
			{
				EditCopy();
			}
			if ( (Key == Asc("v")) || (Key == Asc("V")) )
			{
				EditPaste();
			}
			if ( (Key == Asc("x")) || (Key == Asc("X")) )
			{
				EditCut();
			}
		}
		else
		{
			if ( NotifyOwner != None )
			{
				NotifyOwner.KeyDown(Key,X,Y);
			}
			else
			{
				Super.KeyDown(Key,X,Y);
			}
		}
		break;*/
	}
}

function Click (float X, float Y)
{
	Notify(2);
	if ( bShowLog )
	{
		Log("UWindowEditBox::Click");
	}
}

function LMouseDown (float X, float Y)
{
	if ( bShowLog )
	{
		Log("UWindowEditBox::LMouseDown");
	}
	Super.LMouseDown(X,Y);
	if ( bShowLog )
	{
		Log("UWindowEditBox::LMouseDown ->SelectAll()");
	}
	SelectAll();
	Notify(10);
}

function Paint (Canvas C, float X, float Y)
{
	local float W;
	local float H;
	local float TextY;

	C.Font=Root.Fonts[Font];
	TextColor=Root.Colors.BlueLight;
	if ( m_bUseNewPaint )
	{
		TextSize(C,Value,W,H);
		TextY=(WinHeight - H) / 2;
		switch (Align)
		{
			case TA_Center:
			offset=(WinWidth - W - 14) / 2;
			break;
			default:
			offset=offset + 1;
			break;
		}
		C.SetDrawColor(TextColor.R,TextColor.G,TextColor.B);
		if ( m_CurrentlyEditing && bAllSelected )
		{
//			DrawStretchedTexture(C,offset,TextY,W,H,Texture'WhiteTexture');
			C.SetDrawColor(255 ^ C.DrawColor.R,255 ^ C.DrawColor.G,255 ^ C.DrawColor.B);
		}
		ClipText(C,offset,TextY,Value);
	}
	else
	{
		TextSize(C,"A",W,H);
		TextY=(WinHeight - H) / 2;
		TextSize(C,Left(Value,CaretOffset),W,H);
		if ( W + offset < 0 )
		{
			offset= -W;
		}
		if ( W + offset > WinWidth - 2 )
		{
			offset=WinWidth - 2 - W;
			if ( offset > 0 )
			{
				offset=0.00;
			}
		}
		C.SetDrawColor(TextColor.R,TextColor.G,TextColor.B);
		if ( m_CurrentlyEditing && bAllSelected )
		{
//			DrawStretchedTexture(C,offset + 1,TextY,W,H,Texture'WhiteTexture');
			C.SetDrawColor(255 ^ C.DrawColor.R,255 ^ C.DrawColor.G,255 ^ C.DrawColor.B);
		}
		ClipText(C,offset + 1,TextY,Value);
	}
	if (  !m_CurrentlyEditing ||  !bHasKeyboardFocus ||  !bCanEdit )
	{
		bShowCaret=False;
	}
	else
	{
		if ( (GetTime() > LastDrawTime + 0.30) || (GetTime() < LastDrawTime) )
		{
			LastDrawTime=GetTime();
			bShowCaret= !bShowCaret;
		}
	}
	if ( bShowCaret )
	{
		ClipText(C,offset + W - 1,TextY,"|");
	}
	if ( m_bDrawEditBorders )
	{
		DrawSimpleBorder(C);
	}
}

function Close (optional bool bByParent)
{
	DropSelection();
	Super.Close(bByParent);
}

function FocusWindow ()
{
	Super.FocusWindow();
	if ( bShowLog )
	{
		Log("FocusWindow ->SelectAll()");
	}
	if (  !m_CurrentlyEditing )
	{
		SelectAll();
	}
}

function FocusOtherWindow (UWindowWindow W)
{
	if ( bShowLog )
	{
		Log("FocusOtherWindow");
	}
	DropSelection();
	if ( NotifyOwner != None )
	{
		NotifyOwner.FocusOtherWindow(W);
	}
	else
	{
		Super.FocusOtherWindow(W);
	}
}

function DoubleClick (float X, float Y)
{
	Super.DoubleClick(X,Y);
	if ( bShowLog )
	{
		Log("DoubleClick ->SelectAll()");
	}
	SelectAll();
}

function KeyFocusEnter ()
{
	if ( bShowLog )
	{
		Log("UWindowEditBox::KeyFocusEnter");
	}
	if ( bSelectOnFocus &&  !bHasKeyboardFocus )
	{
		if ( bShowLog )
		{
			Log("KeyFocusEnter ->SelectAll()");
		}
		SelectAll();
	}
	Super.KeyFocusEnter();
}

function KeyFocusExit ()
{
	if ( bShowLog )
	{
		Log("KeyFocusExit");
	}
	if ( bCanEdit && m_CurrentlyEditing )
	{
		if (  !bHistory )
		{
			OldValue=Value;
		}
		else
		{
			if ( Value != "" )
			{
				CurrentHistory=UWindowEditBoxHistory(HistoryList.Insert(Class'UWindowEditBoxHistory'));
				CurrentHistory.HistoryText=Value;
				if ( bShowLog )
				{
					Log("Set value CurrentHistory.HistoryText" @ CurrentHistory.HistoryText);
				}
			}
			CurrentHistory=HistoryList;
		}
	}
	DropSelection();
	Super.KeyFocusExit();
}

function DropSelection ()
{
	if ( m_CurrentlyEditing )
	{
		if ( bChangePending )
		{
			bChangePending=False;
			Notify(1);
		}
	}
	bAllSelected=False;
	m_CurrentlyEditing=False;
	bKeyDown=False;
	MoveHome();
	CancelAcceptsFocus();
}

function MouseEnter ()
{
	Super.MouseEnter();
	m_bMouseOn=True;
}

function MouseLeave ()
{
	Super.MouseLeave();
	m_bMouseOn=False;
}

defaultproperties
{
    MaxLength=255
    bCanEdit=True
}
