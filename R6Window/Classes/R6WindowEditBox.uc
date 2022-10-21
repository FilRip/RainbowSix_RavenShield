//================================================================================
// R6WindowEditBox.
//================================================================================
class R6WindowEditBox extends UWindowEditBox;

var bool bCaps;
var float m_fYTextPos;
var float m_fTextHeight;
var float m_fYBGPos;
var Texture m_TBGEditTexture;
var Region m_RBGEditTexture;
var string m_szCurValue;
var string m_szValueToDisplay;

function BeforePaint (Canvas C, float X, float Y)
{
	local float W;
	local float H;
	local int i;

	C.Font=Root.Fonts[Font];
	if ( m_szCurValue != Value )
	{
		m_szCurValue=Value;
		Super.BeforePaint(C,X,Y);
		if ( bPassword )
		{
			m_szValueToDisplay="";
			for (i=0;i < Len(Value);i++)
			{
				m_szValueToDisplay=m_szValueToDisplay $ "*";
			}
		}
		else
		{
			if ( bCaps )
			{
				m_szValueToDisplay=Caps(Value);
			}
			else
			{
				m_szValueToDisplay=Value;
			}
		}
		TextSize(C,"W",W,H);
		m_fTextHeight=H;
		m_fYTextPos=(WinHeight - H) / 2;
		m_fYTextPos=m_fYTextPos + 0.50;
	}
}

function Paint (Canvas C, float X, float Y)
{
	local float fStringLeftOfCaretW;
	local float H;

	TextSize(C,Left(m_szValueToDisplay,CaretOffset),fStringLeftOfCaretW,H);
	if ( m_bDrawEditBoxBG )
	{
		PaintEditBoxBG(C);
	}
	if ( fStringLeftOfCaretW + offset < 0 )
	{
		offset= -fStringLeftOfCaretW;
	}
	if ( fStringLeftOfCaretW + offset > WinWidth - 2 )
	{
		offset=WinWidth - 2 - fStringLeftOfCaretW;
		if ( offset > 0 )
		{
			offset=0.00;
		}
	}
	if ( bShowLog )
	{
		Log("Offset After" @ string(offset));
		bShowLog=False;
	}
	C.SetDrawColor(TextColor.R,TextColor.G,TextColor.B);
	if ( m_CurrentlyEditing && bAllSelected )
	{
		C.Style=5;
		C.SetDrawColor(Root.Colors.m_LisBoxSelectionColor.R,Root.Colors.m_LisBoxSelectionColor.G,Root.Colors.m_LisBoxSelectionColor.B,Root.Colors.EditBoxSelectAllAlpha);
		DrawStretchedTexture(C,offset + 1,m_fYBGPos,fStringLeftOfCaretW,m_RBGEditTexture.H,Texture'WhiteTexture');
		C.Style=5;
		C.SetDrawColor(Root.Colors.m_LisBoxSelectedTextColor.R,Root.Colors.m_LisBoxSelectedTextColor.G,Root.Colors.m_LisBoxSelectedTextColor.B);
	}
	ClipText(C,offset + 1,m_fYTextPos,m_szValueToDisplay);
	if (  !m_CurrentlyEditing ||  !bHasKeyboardFocus ||  !bCanEdit )
	{
		bShowCaret=False;
	}
	else
	{
		if ( (GetTime() > LastDrawTime + 0.30) || (GetTime() < LastDrawTime) )
		{
			LastDrawTime=GetLevel().GetTime();
			bShowCaret= !bShowCaret;
		}
	}
	if ( bShowCaret )
	{
		ClipText(C,offset + fStringLeftOfCaretW - 1,m_fYTextPos,"|");
	}
}

function PaintEditBoxBG (Canvas C)
{
	C.Style=5;
	if ( m_fTextHeight > m_RBGEditTexture.H )
	{
		m_fYBGPos=m_fYTextPos;
	}
	else
	{
		m_fYBGPos=(m_RBGEditTexture.H - m_fTextHeight) * 0.50;
		m_fYBGPos=m_fYBGPos + 0.50;
		m_fYBGPos=m_fYTextPos - m_fYBGPos;
	}
	DrawStretchedTextureSegment(C,0.00,m_fYBGPos,WinWidth,m_RBGEditTexture.H,m_RBGEditTexture.X,m_RBGEditTexture.Y,m_RBGEditTexture.W,m_RBGEditTexture.H,m_TBGEditTexture);
}

defaultproperties
{
    m_RBGEditTexture=(X=7479819,Y=571277312,W=47,H=139785)
    m_szCurValue="//N"
    bSelectOnFocus=True
    m_bDrawEditBoxBG=True
}
/*
    m_TBGEditTexture=Texture'R6MenuTextures.Gui_BoxScroll'
*/

