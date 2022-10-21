//================================================================================
// R6WindowSimpleCurvedFramedWindow.
//================================================================================
class R6WindowSimpleCurvedFramedWindow extends R6WindowSimpleFramedWindow;

var TextAlign m_TitleAlign;
var float m_fFontSpacing;
var float m_fLMarge;
var R6WindowTextLabelCurved m_topLabel;
var Font m_Font;
var Color m_TextColor;
var string m_Title;

function Created ()
{
	m_topLabel=R6WindowTextLabelCurved(CreateWindow(Class'R6WindowTextLabelCurved',0.00,0.00,WinWidth,31.00,self));
	m_fVBorderOffset=m_topLabel.m_fVBorderOffset;
	m_fHBorderPadding=m_topLabel.m_topLeftCornerR.W + 1;
	m_fVBorderPadding=m_topLabel.m_topLeftCornerR.H + 1;
}

function CreateClientWindow (Class<UWindowWindow> ClientClass)
{
	m_ClientClass=ClientClass;
	m_ClientArea=CreateWindow(m_ClientClass,m_fVBorderWidth + m_fVBorderOffset,m_fHBorderHeight + m_fHBorderOffset + m_topLabel.WinHeight,WinWidth - 2 * m_fVBorderWidth - 2 * m_fVBorderOffset,WinHeight - 2 * m_fHBorderHeight - 2 * m_fHBorderOffset - m_topLabel.WinHeight,OwnerWindow);
}

function BeforePaint (Canvas C, float X, float Y)
{
	m_topLabel.Text=m_Title;
	m_topLabel.Align=m_TitleAlign;
	m_topLabel.m_Font=m_Font;
	m_topLabel.TextColor=m_TextColor;
	m_topLabel.m_fFontSpacing=m_fFontSpacing;
	m_topLabel.m_fLMarge=m_fLMarge;
	m_topLabel.m_BorderColor=m_BorderColor;
}

function SetCornerType (eCornerType _eCornerType)
{
	switch (_eCornerType)
	{
/*		case 1:
		m_fHBorderOffset=0.00;
		m_fHBorderPadding=m_fVBorderOffset;
		m_fVBorderPadding=m_fHBorderHeight;
		break;
		case 2:
		case 3:
		m_fHBorderOffset=Default.m_fHBorderOffset;
		m_fHBorderPadding=Default.m_fHBorderPadding;
		m_fVBorderPadding=Default.m_fVBorderPadding;
		default:*/
	}
	m_eCornerType=_eCornerType;
}

function AfterPaint (Canvas C, float X, float Y)
{
	local float tempSpace;

	C.SetDrawColor(m_BorderColor.R,m_BorderColor.G,m_BorderColor.B);
	C.Style=m_DrawStyle;
	if ( m_HBorderTexture != None )
	{
		DrawStretchedTextureSegment(C,m_fHBorderPadding,WinHeight - m_fHBorderHeight - m_fHBorderOffset,WinWidth - 2 * m_fHBorderPadding,m_fHBorderHeight,m_HBorderTextureRegion.X,m_HBorderTextureRegion.Y,m_HBorderTextureRegion.W,m_HBorderTextureRegion.H,m_HBorderTexture);
	}
	if ( m_VBorderTexture != None )
	{
		DrawStretchedTextureSegment(C,m_fVBorderOffset,m_topLabel.WinHeight,m_fVBorderWidth,WinHeight - m_fVBorderPadding - m_topLabel.WinHeight,m_VBorderTextureRegion.X,m_VBorderTextureRegion.Y,m_VBorderTextureRegion.W,m_VBorderTextureRegion.H,m_VBorderTexture);
		DrawStretchedTextureSegment(C,WinWidth - m_fVBorderWidth - m_fVBorderOffset,m_topLabel.WinHeight,m_fVBorderWidth,WinHeight - m_fVBorderPadding - m_topLabel.WinHeight,m_VBorderTextureRegion.X,m_VBorderTextureRegion.Y,m_VBorderTextureRegion.W,m_VBorderTextureRegion.H,m_VBorderTexture);
	}
	switch (m_eCornerType)
	{
/*		case 1:
		break;
		case 2:
		case 3:
		DrawStretchedTextureSegment(C,0.00,WinHeight - m_topLeftCornerR.H,m_topLeftCornerR.W,m_topLeftCornerR.H,m_topLeftCornerR.X,m_topLeftCornerR.Y + m_topLeftCornerR.H,m_topLeftCornerR.W, -m_topLeftCornerR.H,m_topLeftCornerT);
		DrawStretchedTextureSegment(C,WinWidth - m_topLeftCornerR.W,WinHeight - m_topLeftCornerR.H,m_topLeftCornerR.W,m_topLeftCornerR.H,m_topLeftCornerR.X + m_topLeftCornerR.W,m_topLeftCornerR.Y + m_topLeftCornerR.H, -m_topLeftCornerR.W, -m_topLeftCornerR.H,m_topLeftCornerT);
		break;
		default:*/
	}
}

defaultproperties
{
    m_fLMarge=2.00
}
