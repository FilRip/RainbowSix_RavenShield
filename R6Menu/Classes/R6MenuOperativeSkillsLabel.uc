//================================================================================
// R6MenuOperativeSkillsLabel.
//================================================================================
class R6MenuOperativeSkillsLabel extends R6WindowTextLabel;

var float m_fWidthOfFixArea;
var Color m_NumericValueColor;
var string m_szNumericValue;

function Created ()
{
	m_Font=Root.Fonts[6];
}

function Paint (Canvas C, float X, float Y)
{
	if ( Text != "" )
	{
		C.Font=m_Font;
		C.SpaceX=m_fFontSpacing;
		C.SetDrawColor(TextColor.R,TextColor.G,TextColor.B);
		C.Style=m_TextDrawstyle;
		ClipText(C,TextX,TextY,Text,True);
	}
	if ( m_szNumericValue != "" )
	{
		DrawNumericValue(C);
	}
}

function DrawNumericValue (Canvas C)
{
	local float fX;
	local float fW;
	local float fH;
	local float fSizeOfBG;

	C.Font=m_Font;
	C.SpaceX=m_fFontSpacing;
	C.Style=5;
	C.SetDrawColor(Root.Colors.White.R,Root.Colors.White.G,Root.Colors.White.B);
	TextSize(C,m_szNumericValue,fW,fH);
	if ( m_fWidthOfFixArea == 0 )
	{
		fSizeOfBG=fW + 6;
		DrawStretchedTextureSegment(C,WinWidth - fSizeOfBG,0.00,fSizeOfBG,WinHeight,m_BGTextureRegion.X,m_BGTextureRegion.Y,m_BGTextureRegion.W,m_BGTextureRegion.H,m_BGTexture);
		C.SetPos(WinWidth - fSizeOfBG + 3,m_fHBorderHeight);
	}
	else
	{
		DrawStretchedTextureSegment(C,WinWidth - m_fWidthOfFixArea,0.00,m_fWidthOfFixArea,WinHeight,m_BGTextureRegion.X,m_BGTextureRegion.Y,m_BGTextureRegion.W,m_BGTextureRegion.H,m_BGTexture);
		fX=WinWidth - m_fWidthOfFixArea + (m_fWidthOfFixArea - fW) / 2;
		C.SetPos(fX,m_fHBorderHeight);
	}
	C.SetDrawColor(m_NumericValueColor.R,m_NumericValueColor.G,m_NumericValueColor.B);
	C.DrawText(m_szNumericValue);
}

function SetNumericValue (int _iOriginalValue, int _iLastValue)
{
	local int ITemp;
	local int iOriginalValue;

	iOriginalValue=Min(_iOriginalValue,100);
	m_szNumericValue=string(Max(iOriginalValue,0));
	ITemp=Min(_iLastValue,100) - iOriginalValue;
	if ( ITemp != 0 )
	{
		if ( ITemp > 0 )
		{
			m_szNumericValue=m_szNumericValue $ "(+" $ string(Min(ITemp,100)) $ ")";
		}
		else
		{
			m_szNumericValue=m_szNumericValue $ "(-" $ string(Min(Abs(ITemp),100)) $ ")";
		}
	}
}

defaultproperties
{
    m_bDrawBorders=False
    m_BGTextureRegion=(X=7414278,Y=570753024,W=47,H=139780)
}