//================================================================================
// UWindowTextAreaControl.
//================================================================================
class UWindowTextAreaControl extends UWindowDialogControl;

var int Font;
var int BufSize;
var int Head;
var int Tail;
var int Lines;
var int VisibleRows;
var bool bCursor;
var bool bScrollable;
var bool bShowCaret;
var bool bScrollOnResize;
var bool m_bWrapClipText;
var float m_fXOffSet;
var float m_fYOffSet;
var float LastDrawTime;
var Font TextFontArea[80];
var Font AbsoluteFont;
var UWindowVScrollbar VertSB;
var Color TextColorArea[80];
var string TextArea[80];
var string Prompt;
const szTextArraySize= 80;

function Created ()
{
	LastDrawTime=GetTime();
}

function SetScrollable (bool newScrollable)
{
	bScrollable=newScrollable;
	if ( newScrollable )
	{
		VertSB=UWindowVScrollbar(CreateWindow(Class'UWindowVScrollbar',WinWidth - LookAndFeel.Size_ScrollbarWidth,0.00,LookAndFeel.Size_ScrollbarWidth,WinHeight));
		VertSB.bAlwaysOnTop=True;
	}
	else
	{
		if ( VertSB != None )
		{
			VertSB.Close();
			VertSB=None;
		}
	}
}

function BeforePaint (Canvas C, float X, float Y)
{
	Super.BeforePaint(C,X,Y);
	if ( VertSB != None )
	{
		VertSB.WinTop=0.00;
		VertSB.WinHeight=WinHeight;
		VertSB.WinWidth=LookAndFeel.Size_ScrollbarWidth;
		VertSB.WinLeft=WinWidth - LookAndFeel.Size_ScrollbarWidth;
	}
}

function SetAbsoluteFont (Font f)
{
	AbsoluteFont=f;
}

function Paint (Canvas C, float X, float Y)
{
	local int i;
	local int j;
	local int Line;
	local int TempHead;
	local int TempTail;
	local float XL;
	local float YL;
	local float W;
	local float H;

	if ( AbsoluteFont != None )
	{
		C.Font=AbsoluteFont;
	}
	else
	{
		C.Font=Root.Fonts[Font];
	}
	C.SetDrawColor(255,255,255);
	TextSize(C,"TEST",XL,YL);
	VisibleRows=WinHeight / YL;
	TempHead=Head;
	TempTail=Tail;
	Line=TempHead;
	if ( Prompt == "" )
	{
		Line--;
		if ( Line < 0 )
		{
			Line += BufSize;
		}
	}
	if ( bScrollable )
	{
		if ( VertSB.MaxPos - VertSB.pos >= 0 )
		{
			Line -= VertSB.MaxPos - VertSB.pos;
			TempTail -= VertSB.MaxPos - VertSB.pos;
			if ( Line < 0 )
			{
				Line += BufSize;
			}
			if ( TempTail < 0 )
			{
				TempTail += BufSize;
			}
		}
	}
	if (  !bCursor )
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
	i=0;
JL01E4:
	if ( i < VisibleRows + 1 )
	{
		ClipText(C,2.00,WinHeight - YL * (i + 1),TextArea[Line]);
		if ( (Line == Head) && bShowCaret )
		{
			TextSize(C,TextArea[Line],W,H);
			ClipText(C,W,WinHeight - YL * (i + 1),"|");
		}
		if ( TempTail == Line )
		{
			goto JL02C9;
		}
		Line--;
		if ( Line < 0 )
		{
			Line += BufSize;
		}
		i++;
		goto JL01E4;
	}
JL02C9:
}

function AddText (string _szNewLine, Color _TextColor, Font _Font)
{
	TextColorArea[Lines]=_TextColor;
	TextFontArea[Lines]=_Font;
	TextArea[Lines]=_szNewLine;
	Lines += 1;
}

function AddTextWithCanvas (Canvas C, float _fXOffSet, float _fYOffset, string NewLine, Font _Font, Color FontColor)
{
	local string szTempTextArea[80];
	local string Out;
	local string temp;
	local string szTSResult;
	local float XWordPos;
	local float fWidthToReduce;
	local float fTotalWToReduce;
	local float WordWidth;
	local float WordHeight;
	local int WordPos;
	local int TotalPos;
	local int PrevPos;
	local int TotalLinePos;
	local int numLines;
	local int PrevNumLines;
	local int i;
	local int iRealSizeOfWord;
	local int iNbLineTemp;
	local int iNbLineTempTotal;
	local bool bSentry;

	m_fXOffSet=_fXOffSet;
	m_fYOffSet=_fYOffset;
	fWidthToReduce=_fXOffSet + 11;
	fTotalWToReduce=2.00 * _fXOffSet + 11;
	iNbLineTemp=0;
	temp=Caps(NewLine);
	szTempTextArea[iNbLineTemp]=NewLine;
	i=InStr(temp,"\N");
JL0075:
	if ( i != -1 )
	{
		temp=Mid(szTempTextArea[iNbLineTemp],i + 2);
		szTempTextArea[iNbLineTemp]=Left(szTempTextArea[iNbLineTemp],i);
		iNbLineTemp += 1;
		szTempTextArea[iNbLineTemp]=temp;
		temp=Caps(temp);
		i=InStr(temp,"\N");
		goto JL0075;
	}
	iNbLineTempTotal=iNbLineTemp;
	Out="";
	bSentry=True;
	iNbLineTemp=0;
	XWordPos=_fXOffSet;
JL0125:
	if ( bSentry )
	{
		if ( Out == "" )
		{
			i=0;
			PrevPos=0;
			TotalLinePos=0;
			TotalPos=0;
			numLines=1;
			PrevNumLines=1;
			i++;
			Out=szTempTextArea[iNbLineTemp];
		}
		WordPos=InStr(Out," ");
		if ( WordPos == -1 )
		{
			temp=Out;
			WordPos=Len(temp);
		}
		else
		{
			temp=Left(Out,WordPos) $ " ";
		}
		C.Font=_Font;
		szTSResult=TextSize(C,temp,WordWidth,WordHeight,WinWidth - fTotalWToReduce);
		if ( WordWidth + XWordPos + fTotalWToReduce > WinWidth - _fXOffSet )
		{
			if ( XWordPos == _fXOffSet )
			{
				temp=szTSResult;
				WordPos=Len(temp);
				Out=Mid(Out,WordPos);
				TotalPos += WordPos;
				TotalLinePos += WordPos;
			}
			XWordPos=_fXOffSet;
			numLines++;
		}
		else
		{
			XWordPos += WordWidth;
			TotalPos += WordPos + 1;
			TotalLinePos += WordPos + 1;
			Out=Mid(Out,Len(temp));
		}
		if ( (Out == "") && (i > 0) )
		{
			bSentry=False;
		}
		if ( (numLines != PrevNumLines) ||  !bSentry )
		{
			if ( Lines >= 80 )
			{
				Log("Small problem over here, string array overloaded in UWindowTextAreaControl.uc");
				goto JL0439;
			}
			else
			{
				PrevNumLines=numLines;
				temp=Mid(szTempTextArea[iNbLineTemp],PrevPos);
				TextArea[Lines]=Left(temp,TotalLinePos);
				TextColorArea[Lines]=FontColor;
				TextFontArea[Lines]=C.Font;
				PrevPos=TotalPos;
				TotalLinePos=0;
				Lines += 1;
				if ( (iNbLineTemp < iNbLineTempTotal) &&  !bSentry )
				{
					iNbLineTemp += 1;
					Out="";
					bSentry=True;
					XWordPos=_fXOffSet;
				}
			}
		}
		goto JL0125;
	}
JL0439:
}

function Resized ()
{
	if ( bScrollable )
	{
		VertSB.SetRange(0.00,Lines,VisibleRows);
		if ( bScrollOnResize )
		{
			VertSB.pos=VertSB.MaxPos;
		}
	}
}

function SetPrompt (string NewPrompt)
{
	Prompt=NewPrompt;
}

function Clear (optional bool _bClearArrayOnly, optional bool _bWrapText)
{
	local int i;

	if ( Lines != 0 )
	{
		i=0;
JL0012:
		if ( i < 80 )
		{
			TextArea[i]="";
			TextFontArea[i]=None;
			Lines -= 1;
			if ( Lines == 0 )
			{
				goto JL0059;
			}
			i++;
			goto JL0012;
		}
	}
JL0059:
	TextArea[0]="";
	TextFontArea[0]=None;
	if ( bScrollable )
	{
		VertSB.pos=0.00;
	}
	if ( _bWrapText )
	{
		m_bWrapClipText=True;
	}
	if (  !_bClearArrayOnly )
	{
		Head=0;
		Tail=0;
		m_fXOffSet=0.00;
		m_fYOffSet=0.00;
		m_bWrapClipText=True;
	}
}

defaultproperties
{
    BufSize=200
    bScrollOnResize=True
    m_bWrapClipText=True
}
