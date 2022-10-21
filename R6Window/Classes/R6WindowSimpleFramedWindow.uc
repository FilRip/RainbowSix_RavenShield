//================================================================================
// R6WindowSimpleFramedWindow.
//================================================================================
class R6WindowSimpleFramedWindow extends UWindowWindow;

enum eCornerType {
	No_Corners,
	Top_Corners,
	Bottom_Corners,
	All_Corners
};

var eCornerType m_eCornerType;
var int m_DrawStyle;
var bool bShowLog;
var float m_fHBorderHeight;
var float m_fVBorderWidth;
var float m_fHBorderPadding;
var float m_fVBorderPadding;
var float m_fHBorderOffset;
var float m_fVBorderOffset;
var Texture m_HBorderTexture;
var Texture m_VBorderTexture;
var Texture m_topLeftCornerT;
var UWindowWindow m_ClientArea;
var Class<UWindowWindow> m_ClientClass;
var Region m_HBorderTextureRegion;
var Region m_VBorderTextureRegion;
var Region m_topLeftCornerR;

function CreateClientWindow (Class<UWindowWindow> ClientClass)
{
	m_ClientClass=ClientClass;
	m_ClientArea=CreateWindow(m_ClientClass,m_fVBorderWidth + m_fVBorderOffset,m_fHBorderHeight + m_fHBorderOffset,WinWidth - 2 * m_fVBorderWidth - 2 * m_fVBorderOffset,WinHeight - 2 * m_fHBorderHeight - 2 * m_fHBorderOffset,OwnerWindow);
	if ( bShowLog )
	{
		Log("Creating Client window");
		Log("m_ClientClass" @ string(m_ClientClass));
		Log("x:" @ string(m_fVBorderWidth + m_fVBorderOffset));
		Log("y:" @ string(m_fHBorderHeight + m_fHBorderOffset));
		Log("w:" @ string(WinWidth - 2 * m_fVBorderWidth - 2 * m_fVBorderOffset));
		Log("h:" @ string(WinHeight - 2 * m_fHBorderHeight - 2 * m_fHBorderOffset));
		Log("Done Creating Client window");
	}
}

function SetCornerType (eCornerType _eCornerType)
{
	m_eCornerType=_eCornerType;
}

function AfterPaint (Canvas C, float X, float Y)
{
	local float tempSpace;

	C.SetDrawColor(m_BorderColor.R,m_BorderColor.G,m_BorderColor.B);
	C.Style=m_DrawStyle;
	switch (m_eCornerType)
	{
/*		case 1:
		if ( m_HBorderTexture != None )
		{
			DrawStretchedTextureSegment(C,m_fHBorderPadding,m_fHBorderOffset,WinWidth - 2 * m_fHBorderPadding,m_fHBorderHeight,m_HBorderTextureRegion.X,m_HBorderTextureRegion.Y,m_HBorderTextureRegion.W,m_HBorderTextureRegion.H,m_HBorderTexture);
			DrawStretchedTextureSegment(C,m_fVBorderOffset,WinHeight - m_fHBorderHeight,WinWidth - 2 * m_fVBorderOffset,m_fHBorderHeight,m_HBorderTextureRegion.X,m_HBorderTextureRegion.Y,m_HBorderTextureRegion.W,m_HBorderTextureRegion.H,m_HBorderTexture);
		}
		if ( m_VBorderTexture != None )
		{
			DrawStretchedTextureSegment(C,m_fVBorderOffset,m_fVBorderPadding,m_fVBorderWidth,WinHeight - m_fVBorderPadding - m_fHBorderHeight,m_VBorderTextureRegion.X,m_VBorderTextureRegion.Y,m_VBorderTextureRegion.W,m_VBorderTextureRegion.H,m_VBorderTexture);
			DrawStretchedTextureSegment(C,WinWidth - m_fVBorderWidth - m_fVBorderOffset,m_fVBorderPadding,m_fVBorderWidth,WinHeight - m_fVBorderPadding - m_fHBorderHeight,m_VBorderTextureRegion.X,m_VBorderTextureRegion.Y,m_VBorderTextureRegion.W,m_VBorderTextureRegion.H,m_VBorderTexture);
		}
		if ( m_topLeftCornerT != None )
		{
			DrawStretchedTextureSegment(C,0.00,0.00,m_topLeftCornerR.W,m_topLeftCornerR.H,m_topLeftCornerR.X,m_topLeftCornerR.Y,m_topLeftCornerR.W,m_topLeftCornerR.H,m_topLeftCornerT);
			DrawStretchedTextureSegment(C,WinWidth - m_topLeftCornerR.W,0.00,m_topLeftCornerR.W,m_topLeftCornerR.H,m_topLeftCornerR.X + m_topLeftCornerR.W,m_topLeftCornerR.Y, -m_topLeftCornerR.W,m_topLeftCornerR.H,m_topLeftCornerT);
		}
		break;
		case 2:
		if ( m_HBorderTexture != None )
		{
			DrawStretchedTextureSegment(C,m_fVBorderOffset,0.00,WinWidth - 2 * m_fVBorderOffset,m_fHBorderHeight,m_HBorderTextureRegion.X,m_HBorderTextureRegion.Y,m_HBorderTextureRegion.W,m_HBorderTextureRegion.H,m_HBorderTexture);
			DrawStretchedTextureSegment(C,m_fHBorderPadding,WinHeight - m_fHBorderHeight - m_fHBorderOffset,WinWidth - 2 * m_fHBorderPadding,m_fHBorderHeight,m_HBorderTextureRegion.X,m_HBorderTextureRegion.Y,m_HBorderTextureRegion.W,m_HBorderTextureRegion.H,m_HBorderTexture);
		}
		if ( m_VBorderTexture != None )
		{
			DrawStretchedTextureSegment(C,m_fVBorderOffset,m_fHBorderHeight,m_fVBorderWidth,WinHeight - m_fVBorderPadding - m_fHBorderHeight,m_VBorderTextureRegion.X,m_VBorderTextureRegion.Y,m_VBorderTextureRegion.W,m_VBorderTextureRegion.H,m_VBorderTexture);
			DrawStretchedTextureSegment(C,WinWidth - m_fVBorderWidth - m_fVBorderOffset,m_fHBorderHeight,m_fVBorderWidth,WinHeight - m_fVBorderPadding - m_fHBorderHeight,m_VBorderTextureRegion.X,m_VBorderTextureRegion.Y,m_VBorderTextureRegion.W,m_VBorderTextureRegion.H,m_VBorderTexture);
		}
		if ( m_topLeftCornerT != None )
		{
			DrawStretchedTextureSegment(C,0.00,WinHeight - m_topLeftCornerR.H,m_topLeftCornerR.W,m_topLeftCornerR.H,m_topLeftCornerR.X,m_topLeftCornerR.Y + m_topLeftCornerR.H,m_topLeftCornerR.W, -m_topLeftCornerR.H,m_topLeftCornerT);
			DrawStretchedTextureSegment(C,WinWidth - m_topLeftCornerR.W,WinHeight - m_topLeftCornerR.H,m_topLeftCornerR.W,m_topLeftCornerR.H,m_topLeftCornerR.X + m_topLeftCornerR.W,m_topLeftCornerR.Y + m_topLeftCornerR.H, -m_topLeftCornerR.W, -m_topLeftCornerR.H,m_topLeftCornerT);
		}
		break;
		case 3:
		if ( m_HBorderTexture != None )
		{
			DrawStretchedTextureSegment(C,m_fHBorderPadding,m_fHBorderOffset,WinWidth - 2 * m_fHBorderPadding,m_fHBorderHeight,m_HBorderTextureRegion.X,m_HBorderTextureRegion.Y,m_HBorderTextureRegion.W,m_HBorderTextureRegion.H,m_HBorderTexture);
			DrawStretchedTextureSegment(C,m_fHBorderPadding,WinHeight - m_fHBorderHeight - m_fHBorderOffset,WinWidth - 2 * m_fHBorderPadding,m_fHBorderHeight,m_HBorderTextureRegion.X,m_HBorderTextureRegion.Y,m_HBorderTextureRegion.W,m_HBorderTextureRegion.H,m_HBorderTexture);
		}
		if ( m_VBorderTexture != None )
		{
			DrawStretchedTextureSegment(C,m_fVBorderOffset,m_fVBorderPadding,m_fVBorderWidth,WinHeight - 2 * m_fVBorderPadding,m_VBorderTextureRegion.X,m_VBorderTextureRegion.Y,m_VBorderTextureRegion.W,m_VBorderTextureRegion.H,m_VBorderTexture);
			DrawStretchedTextureSegment(C,WinWidth - m_fVBorderWidth - m_fVBorderOffset,m_fVBorderPadding,m_fVBorderWidth,WinHeight - 2 * m_fVBorderPadding,m_VBorderTextureRegion.X,m_VBorderTextureRegion.Y,m_VBorderTextureRegion.W,m_VBorderTextureRegion.H,m_VBorderTexture);
		}
		if ( m_topLeftCornerT != None )
		{
			DrawStretchedTextureSegment(C,0.00,0.00,m_topLeftCornerR.W,m_topLeftCornerR.H,m_topLeftCornerR.X,m_topLeftCornerR.Y,m_topLeftCornerR.W,m_topLeftCornerR.H,m_topLeftCornerT);
			DrawStretchedTextureSegment(C,WinWidth - m_topLeftCornerR.W,0.00,m_topLeftCornerR.W,m_topLeftCornerR.H,m_topLeftCornerR.X + m_topLeftCornerR.W,m_topLeftCornerR.Y, -m_topLeftCornerR.W,m_topLeftCornerR.H,m_topLeftCornerT);
			DrawStretchedTextureSegment(C,0.00,WinHeight - m_topLeftCornerR.H,m_topLeftCornerR.W,m_topLeftCornerR.H,m_topLeftCornerR.X,m_topLeftCornerR.Y + m_topLeftCornerR.H,m_topLeftCornerR.W, -m_topLeftCornerR.H,m_topLeftCornerT);
			DrawStretchedTextureSegment(C,WinWidth - m_topLeftCornerR.W,WinHeight - m_topLeftCornerR.H,m_topLeftCornerR.W,m_topLeftCornerR.H,m_topLeftCornerR.X + m_topLeftCornerR.W,m_topLeftCornerR.Y + m_topLeftCornerR.H, -m_topLeftCornerR.W, -m_topLeftCornerR.H,m_topLeftCornerT);
		}
		break;
		default:*/
	}
//	C.Style=1;
}

defaultproperties
{
    m_eCornerType=3
    m_DrawStyle=5
    m_fHBorderHeight=1.00
    m_fVBorderWidth=1.00
    m_fHBorderPadding=7.00
    m_fVBorderPadding=8.00
    m_fVBorderOffset=1.00
    m_ClientClass=Class'UWindow.UWindowClientWindow'
    m_HBorderTextureRegion=(X=4203019,Y=571277312,W=56,H=74249)
    m_VBorderTextureRegion=(X=4203019,Y=571277312,W=56,H=74249)
    m_topLeftCornerR=(X=795147,Y=571277312,W=56,H=401929)
}
/*
    m_HBorderTexture=Texture'R6MenuTextures.Gui_BoxScroll'
    m_VBorderTexture=Texture'R6MenuTextures.Gui_BoxScroll'
    m_topLeftCornerT=Texture'R6MenuTextures.Gui_BoxScroll'
*/

