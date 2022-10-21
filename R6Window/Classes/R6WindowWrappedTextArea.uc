//================================================================================
// R6WindowWrappedTextArea.
//================================================================================
class R6WindowWrappedTextArea extends UWindowWrappedTextArea;

var int m_BGDrawStyle;
var bool m_bDrawBorders;
var bool m_bUseBGColor;
var bool m_bUseBGTexture;
var float m_fHBorderHeight;
var float m_fVBorderWidth;
var float m_fHBorderPadding;
var float m_fVBorderPadding;
var Texture m_HBorderTexture;
var Texture m_VBorderTexture;
var Texture m_BGTexture;
var Class<UWindowVScrollbar> m_SBClass;
var Region m_HBorderTextureRegion;
var Region m_VBorderTextureRegion;
var Region m_BGRegion;
var Color m_BGColor;

function SetBorderColor (Color _NewColor)
{
	m_BorderColor=_NewColor;
	if ( VertSB != None )
	{
		VertSB.SetBorderColor(_NewColor);
	}
}

function SetScrollable (bool newScrollable)
{
	bScrollable=newScrollable;
	if ( newScrollable )
	{
		VertSB=R6WindowVScrollbar(CreateWindow(m_SBClass,WinWidth - LookAndFeel.Size_ScrollbarWidth,0.00,LookAndFeel.Size_ScrollbarWidth,WinHeight));
		VertSB.bAlwaysOnTop=True;
		VertSB.SetHideWhenDisable(True);
		VertSB.m_BorderColor=m_BorderColor;
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

function Resize ()
{
	if ( VertSB != None )
	{
		VertSB.WinLeft=WinWidth - LookAndFeel.Size_ScrollbarWidth;
		VertSB.WinTop=0.00;
		VertSB.WinWidth=LookAndFeel.Size_ScrollbarWidth;
		VertSB.WinHeight=WinHeight;
	}
}

function Paint (Canvas C, float X, float Y)
{
	if ( m_bUseBGTexture )
	{
		if ( m_bUseBGColor )
		{
			C.SetDrawColor(m_BGColor.R,m_BGColor.G,m_BGColor.B,m_BGColor.A);
		}
		C.Style=m_BGDrawStyle;
		DrawStretchedTextureSegment(C,0.00,0.00,WinWidth,WinHeight,m_BGRegion.X,m_BGRegion.Y,m_BGRegion.W,m_BGRegion.H,m_BGTexture);
	}
	Super.Paint(C,X,Y);
	C.SetDrawColor(m_BorderColor.R,m_BorderColor.G,m_BorderColor.B);
	C.Style=m_BorderStyle;
	if ( m_bDrawBorders )
	{
		if ( m_HBorderTexture != None )
		{
			DrawStretchedTextureSegment(C,m_fHBorderPadding,0.00,WinWidth - 2 * m_fHBorderPadding,m_fHBorderHeight,m_HBorderTextureRegion.X,m_HBorderTextureRegion.Y,m_HBorderTextureRegion.W,m_HBorderTextureRegion.H,m_HBorderTexture);
			DrawStretchedTextureSegment(C,m_fHBorderPadding,WinHeight - m_fHBorderHeight,WinWidth - 2 * m_fHBorderPadding,m_fHBorderHeight,m_HBorderTextureRegion.X,m_HBorderTextureRegion.Y,m_HBorderTextureRegion.W,m_HBorderTextureRegion.H,m_HBorderTexture);
		}
		if ( m_VBorderTexture != None )
		{
			DrawStretchedTextureSegment(C,0.00,m_fHBorderHeight + m_fVBorderPadding,m_fVBorderWidth,WinHeight - 2 * m_fHBorderHeight - 2 * m_fVBorderPadding,m_VBorderTextureRegion.X,m_VBorderTextureRegion.Y,m_VBorderTextureRegion.W,m_VBorderTextureRegion.H,m_VBorderTexture);
			DrawStretchedTextureSegment(C,WinWidth - m_fVBorderWidth,m_fHBorderHeight + m_fVBorderPadding,m_fVBorderWidth,WinHeight - 2 * m_fHBorderHeight - 2 * m_fVBorderPadding,m_VBorderTextureRegion.X,m_VBorderTextureRegion.Y,m_VBorderTextureRegion.W,m_VBorderTextureRegion.H,m_VBorderTexture);
		}
	}
}

function MouseWheelDown (float X, float Y)
{
	if ( VertSB != None )
	{
		VertSB.MouseWheelDown(X,Y);
	}
}

function MouseWheelUp (float X, float Y)
{
	if ( VertSB != None )
	{
		VertSB.MouseWheelUp(X,Y);
	}
}

defaultproperties
{
    m_BGDrawStyle=5
    m_bDrawBorders=True
    m_fHBorderHeight=1.00
    m_fVBorderWidth=1.00
    m_SBClass=Class'R6WindowVScrollbar'
    m_HBorderTextureRegion=(X=1974795,Y=571277312,W=28,H=139785)
    m_VBorderTextureRegion=(X=1974795,Y=571277312,W=28,H=139785)
    m_BGRegion=(X=6365707,Y=571015168,W=33,H=1516040)
}
/*
    m_HBorderTexture=Texture'R6MenuTextures.Gui_BoxScroll'
    m_VBorderTexture=Texture'R6MenuTextures.Gui_BoxScroll'
    m_BGTexture=Texture'R6MenuTextures.Gui_BoxScroll'
*/

