//================================================================================
// UWindowWrappedTextArea.
//================================================================================
class UWindowWrappedTextArea extends UWindowTextAreaControl;

function BeforePaint (Canvas C, float X, float Y)
{
	if ( m_bWrapClipText )
	{
		m_bWrapClipText=False;
		NewAddText(C);
	}
}

function Paint (Canvas C, float X, float Y)
{
	local float XL;
	local float YL;
	local int i;
	local int j;
	local int AddLine;
	local bool bUseAreaFont;

	if ( Lines == 0 )
	{
		return;
	}
	bUseAreaFont=False;
	if ( AbsoluteFont != None )
	{
		C.Font=AbsoluteFont;
	}
	else
	{
		if ( TextFontArea[0] != None )
		{
			bUseAreaFont=True;
			C.Font=TextFontArea[0];
		}
		else
		{
			C.Font=AbsoluteFont;
		}
	}
	TextSize(C,"TEST",XL,YL);
	AddLine=m_fYOffSet / YL;
	AddLine += 1;
	AddLine += Lines;
	VisibleRows=WinHeight / YL;
	i=0;
	if ( bScrollable )
	{
		VertSB.SetRange(0.00,AddLine,VisibleRows,0.00);
		i=VertSB.pos;
	}
	j=0;
JL0125:
	if ( (j < VisibleRows) && (i + j < Lines) )
	{
		C.SetDrawColor(TextColorArea[i + j].R,TextColorArea[i + j].G,TextColorArea[i + j].B);
		if ( bUseAreaFont )
		{
			C.Font=TextFontArea[i + j];
		}
		ClipText(C,m_fXOffSet,m_fYOffSet + YL * j,TextArea[i + j]);
		j++;
		goto JL0125;
	}
	if ( i + j > Lines )
	{
		j=0;
JL0225:
		if ( j < AddLine )
		{
			ClipText(C,m_fXOffSet,m_fYOffSet + YL * j,"");
			j++;
			goto JL0225;
		}
	}
}

function NewAddText (Canvas C)
{
	local int i;
	local int iTempLines;
	local Font TempTextFontArea[80];
	local Color TempTextColorArea[80];
	local string TempTextArea[80];

	if ( Lines == 0 )
	{
		return;
	}
	i=0;
JL0014:
	if ( i < Lines )
	{
		TempTextFontArea[i]=TextFontArea[i];
		TempTextColorArea[i]=TextColorArea[i];
		TempTextArea[i]=TextArea[i];
		i++;
		goto JL0014;
	}
	iTempLines=Lines;
	Clear(True);
	i=0;
JL008B:
	if ( i < iTempLines )
	{
		AddTextWithCanvas(C,m_fXOffSet,m_fYOffSet,TempTextArea[i],TempTextFontArea[i],TempTextColorArea[i]);
		i++;
		goto JL008B;
	}
}
