//================================================================================
// UWindowDynamicTextArea.
//================================================================================
class UWindowDynamicTextArea extends UWindowDialogControl;

var config int MaxLines;
var int Count;
var int VisibleRows;
var int Font;
var bool bTopCentric;
var bool bScrollOnResize;
var bool bVCenter;
var bool bHCenter;
var bool bAutoScrollbar;
var bool bVariableRowHeight;
var bool bDirty;
var float DefaultTextHeight;
var float WrapWidth;
var float OldW;
var float OldH;
var UWindowDynamicTextRow List;
var UWindowVScrollbar VertSB;
var Font AbsoluteFont;
var Class<UWindowDynamicTextRow> RowClass;
var Color TextColor;

function Created ()
{
	Super.Created();
	VertSB=UWindowVScrollbar(CreateWindow(Class'UWindowVScrollbar',WinWidth - LookAndFeel.Size_ScrollbarWidth,0.00,LookAndFeel.Size_ScrollbarWidth,WinHeight));
	VertSB.bAlwaysOnTop=True;
	Clear();
}

function Clear ()
{
	bDirty=True;
	if ( List != None )
	{
		if ( List.Next == None )
		{
			return;
		}
		List.DestroyList();
	}
	List=new RowClass;
	List.SetupSentinel();
}

function SetAbsoluteFont (Font f)
{
	AbsoluteFont=f;
}

function SetFont (int f)
{
	Font=f;
}

function SetTextColor (Color C)
{
	TextColor=C;
}

function TextAreaClipText (Canvas C, float DrawX, float DrawY, coerce string S, optional bool bCheckHotKey)
{
	ClipText(C,DrawX,DrawY,S,bCheckHotKey);
}

function TextAreaTextSize (Canvas C, string Text, out float W, out float H)
{
	TextSize(C,Text,W,H);
}

function BeforePaint (Canvas C, float X, float Y)
{
	Super.BeforePaint(C,X,Y);
	VertSB.WinTop=0.00;
	VertSB.WinHeight=WinHeight;
	VertSB.WinWidth=LookAndFeel.Size_ScrollbarWidth;
	VertSB.WinLeft=WinWidth - LookAndFeel.Size_ScrollbarWidth;
}

function Paint (Canvas C, float MouseX, float MouseY)
{
	local UWindowDynamicTextRow L;
	local int SkipCount;
	local int DrawCount;
	local int i;
	local float Y;
	local float Junk;
	local bool bWrapped;

	C.SetDrawColor(TextColor.R,TextColor.G,TextColor.B);
	if ( AbsoluteFont != None )
	{
		C.Font=AbsoluteFont;
	}
	else
	{
		C.Font=Root.Fonts[Font];
	}
	if ( (OldW != WinWidth) || (OldH != WinHeight) )
	{
		WordWrap(C,True);
		OldW=WinWidth;
		OldH=WinHeight;
		bWrapped=True;
	}
	else
	{
		if ( bDirty )
		{
			WordWrap(C,False);
			bWrapped=True;
		}
	}
	if ( bWrapped )
	{
		TextAreaTextSize(C,"A",Junk,DefaultTextHeight);
		VisibleRows=WinHeight / DefaultTextHeight;
		Count=List.Count();
		VertSB.SetRange(0.00,Count,VisibleRows);
		if ( bScrollOnResize )
		{
			if ( bTopCentric )
			{
				VertSB.pos=0.00;
			}
			else
			{
				VertSB.pos=VertSB.MaxPos;
			}
		}
		if ( bAutoScrollbar &&  !bVariableRowHeight )
		{
			if ( Count <= VisibleRows )
			{
				VertSB.HideWindow();
			}
			else
			{
				VertSB.ShowWindow();
			}
		}
	}
	if ( bTopCentric )
	{
		SkipCount=VertSB.pos;
		L=UWindowDynamicTextRow(List.Next);
		i=0;
JL0210:
		if ( (i < SkipCount) && (L != None) )
		{
			L=UWindowDynamicTextRow(L.Next);
			i++;
			goto JL0210;
		}
		if ( bVCenter && (Count <= VisibleRows) )
		{
			Y=(WinHeight - Count * DefaultTextHeight) / 2;
		}
		else
		{
			Y=1.00;
		}
		DrawCount=0;
JL02A3:
		if ( Y < WinHeight )
		{
			DrawCount++;
			if ( L != None )
			{
				Y += DrawTextLine(C,L,Y);
				L=UWindowDynamicTextRow(L.Next);
			}
			else
			{
				Y += DefaultTextHeight;
			}
			goto JL02A3;
		}
		if ( bVariableRowHeight )
		{
			VisibleRows=DrawCount - 1;
JL0322:
			if ( VertSB.pos + VisibleRows > Count )
			{
				VisibleRows--;
				goto JL0322;
			}
			VertSB.SetRange(0.00,Count,VisibleRows);
			if ( bAutoScrollbar )
			{
				if ( Count <= VisibleRows )
				{
					VertSB.HideWindow();
				}
				else
				{
					VertSB.ShowWindow();
				}
			}
		}
	}
	else
	{
		SkipCount=Max(0,Count - VisibleRows + VertSB.pos);
		L=UWindowDynamicTextRow(List.Last);
		i=0;
JL03F8:
		if ( (i < SkipCount) && (L != List) )
		{
			L=UWindowDynamicTextRow(L.Prev);
			i++;
			goto JL03F8;
		}
		Y=WinHeight - DefaultTextHeight;
JL044D:
		if ( (L != List) && (L != None) && (Y >  -DefaultTextHeight) )
		{
			DrawTextLine(C,L,Y);
			Y=Y - DefaultTextHeight;
			L=UWindowDynamicTextRow(L.Prev);
			goto JL044D;
		}
	}
}

function UWindowDynamicTextRow AddText (string NewLine)
{
	local UWindowDynamicTextRow L;
	local string temp;
	local int i;

	bDirty=True;
	i=InStr(NewLine,"\n");
	if ( i != -1 )
	{
		temp=Mid(NewLine,i + 2);
		NewLine=Left(NewLine,i);
	}
	else
	{
		temp="";
	}
	L=CheckMaxRows();
	if ( L != None )
	{
		List.AppendItem(L);
	}
	else
	{
		L=UWindowDynamicTextRow(List.Append(RowClass));
	}
	L.Text=NewLine;
	L.WrapParent=None;
	L.bRowDirty=True;
	if ( temp != "" )
	{
		AddText(temp);
	}
	return L;
}

function UWindowDynamicTextRow CheckMaxRows ()
{
	local UWindowDynamicTextRow L;

	L=None;
JL0007:
	if ( (MaxLines > 0) && (List.Count() > MaxLines - 1) && (List.Next != None) )
	{
		L=UWindowDynamicTextRow(List.Next);
		RemoveWrap(L);
		L.Remove();
		goto JL0007;
	}
	return L;
}

function WordWrap (Canvas C, bool bForce)
{
	local UWindowDynamicTextRow L;

	L=UWindowDynamicTextRow(List.Next);
JL0019:
	if ( L != None )
	{
		if ( (L.WrapParent == None) && (L.bRowDirty || bForce) )
		{
			WrapRow(C,L);
		}
		L=UWindowDynamicTextRow(L.Next);
		goto JL0019;
	}
	bDirty=False;
}

function WrapRow (Canvas C, UWindowDynamicTextRow L)
{
	local UWindowDynamicTextRow CurrentRow;
	local UWindowDynamicTextRow N;
	local float MaxWidth;
	local int WrapPos;

	if ( WrapWidth == 0 )
	{
		if ( VertSB.bWindowVisible || bAutoScrollbar )
		{
			MaxWidth=WinWidth - VertSB.WinWidth;
		}
		else
		{
			MaxWidth=WinWidth;
		}
	}
	else
	{
		MaxWidth=WrapWidth;
	}
	L.bRowDirty=False;
	N=UWindowDynamicTextRow(L.Next);
	if ( (N == None) || (N.WrapParent != L) )
	{
		if ( GetWrapPos(C,L,MaxWidth) == -1 )
		{
			return;
		}
	}
	RemoveWrap(L);
	CurrentRow=L;
JL00E7:
	if ( True )
	{
		WrapPos=GetWrapPos(C,CurrentRow,MaxWidth);
		if ( WrapPos == -1 )
		{
			goto JL0131;
		}
		CurrentRow=SplitRowAt(CurrentRow,WrapPos);
		goto JL00E7;
	}
JL0131:
}

function float DrawTextLine (Canvas C, UWindowDynamicTextRow L, float Y)
{
	local float X;
	local float W;
	local float H;

	if ( bHCenter )
	{
		TextAreaTextSize(C,L.Text,W,H);
		if ( VertSB.bWindowVisible )
		{
			X=(WinWidth - VertSB.WinWidth - W) / 2;
		}
		else
		{
			X=(WinWidth - W) / 2;
		}
	}
	else
	{
		X=2.00;
	}
	TextAreaClipText(C,X,Y,L.Text);
	return DefaultTextHeight;
}

function int GetWrapPos (Canvas C, UWindowDynamicTextRow L, float MaxWidth)
{
	local float W;
	local float H;
	local float LineWidth;
	local float NextWordWidth;
	local string Input;
	local string NextWord;
	local int WordsThisRow;
	local int WrapPos;

	TextAreaTextSize(C,L.Text,W,H);
	if ( W <= MaxWidth )
	{
		return -1;
	}
	Input=L.Text;
	WordsThisRow=0;
	LineWidth=0.00;
	WrapPos=0;
	NextWord="";
JL006D:
	if ( (Input != "") || (NextWord != "") )
	{
		if ( NextWord == "" )
		{
			RemoveNextWord(Input,NextWord);
			TextAreaTextSize(C,NextWord,NextWordWidth,H);
		}
		if ( (WordsThisRow > 0) && (LineWidth + NextWordWidth > MaxWidth) )
		{
			return WrapPos;
		}
		else
		{
			WrapPos += Len(NextWord);
			LineWidth += NextWordWidth;
			NextWord="";
			WordsThisRow++;
		}
		goto JL006D;
	}
	return -1;
}

function UWindowDynamicTextRow SplitRowAt (UWindowDynamicTextRow L, int SplitPos)
{
	local UWindowDynamicTextRow N;

	N=UWindowDynamicTextRow(L.InsertAfter(RowClass));
	if ( L.WrapParent == None )
	{
		N.WrapParent=L;
	}
	else
	{
		N.WrapParent=L.WrapParent;
	}
	N.Text=Mid(L.Text,SplitPos);
	L.Text=Left(L.Text,SplitPos);
	return N;
}

function RemoveNextWord (out string Text, out string NextWord)
{
	local int i;

	i=InStr(Text," ");
	if ( i == -1 )
	{
		NextWord=Text;
		Text="";
	}
	else
	{
JL0035:
		if ( Mid(Text,i,1) == " " )
		{
			i++;
			goto JL0035;
		}
		NextWord=Left(Text,i);
		Text=Mid(Text,i);
	}
}

function RemoveWrap (UWindowDynamicTextRow L)
{
	local UWindowDynamicTextRow N;

	N=UWindowDynamicTextRow(L.Next);
JL0019:
	if ( (N != None) && (N.WrapParent == L) )
	{
		L.Text=L.Text $ N.Text;
		N.Remove();
		N=UWindowDynamicTextRow(L.Next);
		goto JL0019;
	}
}

defaultproperties
{
    bScrollOnResize=True
    RowClass=Class'UWindowDynamicTextRow'
    TextColor=(R=255,G=255,B=255,A=0)
}
