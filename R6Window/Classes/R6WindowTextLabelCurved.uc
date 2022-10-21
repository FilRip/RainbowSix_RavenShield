//================================================================================
// R6WindowTextLabelCurved.
//================================================================================
class R6WindowTextLabelCurved extends R6WindowTextLabel;

var float m_RightCurveLineWidth;
var float m_fVBorderOffset;
var float m_fRightCurveLineX;
var float m_fLeftCurveLineX;
var Texture m_TLeftcurve;
var Texture m_TBetweenCurveBG;
var Texture m_TUnderLeftCurveBG;
var Texture m_topLeftCornerT;
var Region m_RLeftcurve;
var Region m_RBetweenCurveBG;
var Region m_RUnderLeftCurveBG;
var Region m_topLeftCornerR;

function Created ()
{
	m_fRightCurveLineX=WinWidth - m_fVBorderWidth - m_topLeftCornerR.W - m_RightCurveLineWidth;
	m_fLeftCurveLineX=m_fRightCurveLineX - 2 * m_RLeftcurve.W - m_RBetweenCurveBG.W;
}

function Paint (Canvas C, float X, float Y)
{
	if ( m_BGTexture != None )
	{
		C.Style=4;
		DrawStretchedTextureSegment(C,m_fVBorderWidth,m_fHBorderHeight,m_fLeftCurveLineX - m_fVBorderWidth,WinHeight - 2 * m_fHBorderHeight,m_BGTextureRegion.X,m_BGTextureRegion.Y,m_BGTextureRegion.W,m_BGTextureRegion.H,m_BGTexture);
		DrawStretchedTextureSegment(C,m_fRightCurveLineX,m_fHBorderHeight,WinWidth - m_fVBorderWidth - m_fRightCurveLineX,WinHeight - 2 * m_fHBorderHeight,m_BGTextureRegion.X,m_BGTextureRegion.Y,m_BGTextureRegion.W,m_BGTextureRegion.H,m_BGTexture);
		DrawStretchedTextureSegment(C,m_fRightCurveLineX - m_RLeftcurve.W - m_RBetweenCurveBG.W,m_RLeftcurve.H,m_RBetweenCurveBG.W,WinHeight - m_fHBorderHeight - m_RLeftcurve.H,m_RBetweenCurveBG.X,m_RBetweenCurveBG.Y,m_RBetweenCurveBG.W,m_RBetweenCurveBG.H,m_TBetweenCurveBG);
		DrawStretchedTextureSegment(C,m_fLeftCurveLineX,m_fHBorderHeight,m_RUnderLeftCurveBG.W,m_RUnderLeftCurveBG.H,m_RUnderLeftCurveBG.X,m_RUnderLeftCurveBG.Y,m_RUnderLeftCurveBG.W,m_RUnderLeftCurveBG.H,m_TUnderLeftCurveBG);
		DrawStretchedTextureSegment(C,m_fRightCurveLineX - m_RLeftcurve.W,m_fHBorderHeight,m_RUnderLeftCurveBG.W,m_RUnderLeftCurveBG.H,m_RUnderLeftCurveBG.X + m_RUnderLeftCurveBG.W,m_RUnderLeftCurveBG.Y, -m_RUnderLeftCurveBG.W,m_RUnderLeftCurveBG.H,m_TUnderLeftCurveBG);
	}
	C.SetDrawColor(m_BorderColor.R,m_BorderColor.G,m_BorderColor.B);
	if ( m_HBorderTexture != None )
	{
		C.Style=5;
		DrawStretchedTextureSegment(C,m_fHBorderPadding,0.00,m_fLeftCurveLineX - m_fHBorderPadding,m_fHBorderHeight,m_HBorderTextureRegion.X,m_HBorderTextureRegion.Y,m_HBorderTextureRegion.W,m_HBorderTextureRegion.H,m_HBorderTexture);
		DrawStretchedTextureSegment(C,m_fRightCurveLineX,0.00,m_RightCurveLineWidth,m_fHBorderHeight,m_HBorderTextureRegion.X,m_HBorderTextureRegion.Y,m_HBorderTextureRegion.W,m_HBorderTextureRegion.H,m_HBorderTexture);
		DrawStretchedTextureSegment(C,m_fRightCurveLineX - m_RLeftcurve.W - m_RBetweenCurveBG.W,m_RLeftcurve.H - m_HBorderTextureRegion.H,m_RBetweenCurveBG.W,m_fHBorderHeight,m_HBorderTextureRegion.X,m_HBorderTextureRegion.Y,m_HBorderTextureRegion.W,m_HBorderTextureRegion.H,m_HBorderTexture);
		DrawStretchedTextureSegment(C,m_fVBorderOffset,WinHeight - m_fHBorderHeight,WinWidth - 2 * m_fVBorderOffset,m_fHBorderHeight,m_HBorderTextureRegion.X,m_HBorderTextureRegion.Y,m_HBorderTextureRegion.W,m_HBorderTextureRegion.H,m_HBorderTexture);
	}
	if ( m_TLeftcurve != None )
	{
		C.Style=5;
		DrawStretchedTextureSegment(C,m_fRightCurveLineX - m_RLeftcurve.W,0.00,m_RLeftcurve.W,m_RLeftcurve.H,m_RLeftcurve.X + m_RLeftcurve.W,m_RLeftcurve.Y, -m_RLeftcurve.W,m_RLeftcurve.H,m_TLeftcurve);
		DrawStretchedTextureSegment(C,m_fRightCurveLineX - 2 * m_RLeftcurve.W - m_RBetweenCurveBG.W,0.00,m_RLeftcurve.W,m_RLeftcurve.H,m_RLeftcurve.X,m_RLeftcurve.Y,m_RLeftcurve.W,m_RLeftcurve.H,m_TLeftcurve);
	}
	if ( m_VBorderTexture != None )
	{
		C.Style=5;
		DrawStretchedTextureSegment(C,m_fVBorderOffset,m_fHBorderHeight + m_fVBorderPadding,m_fVBorderWidth,WinHeight - 2 * m_fHBorderHeight - m_fVBorderPadding,m_VBorderTextureRegion.X,m_VBorderTextureRegion.Y,m_VBorderTextureRegion.W,m_VBorderTextureRegion.H,m_VBorderTexture);
		DrawStretchedTextureSegment(C,WinWidth - m_fVBorderWidth - m_fVBorderOffset,m_fHBorderHeight + m_fVBorderPadding,m_fVBorderWidth,WinHeight - 2 * m_fHBorderHeight - m_fVBorderPadding,m_VBorderTextureRegion.X,m_VBorderTextureRegion.Y,m_VBorderTextureRegion.W,m_VBorderTextureRegion.H,m_VBorderTexture);
	}
	if ( m_topLeftCornerT != None )
	{
		C.Style=5;
		DrawStretchedTextureSegment(C,0.00,0.00,m_topLeftCornerR.W,m_topLeftCornerR.H,m_topLeftCornerR.X,m_topLeftCornerR.Y,m_topLeftCornerR.W,m_topLeftCornerR.H,m_topLeftCornerT);
		DrawStretchedTextureSegment(C,WinWidth - m_topLeftCornerR.W,0.00,m_topLeftCornerR.W,m_topLeftCornerR.H,m_topLeftCornerR.X + m_topLeftCornerR.W,m_topLeftCornerR.Y, -m_topLeftCornerR.W,m_topLeftCornerR.H,m_topLeftCornerT);
	}
	if ( Text != "" )
	{
		C.Style=1;
		C.Font=m_Font;
		C.SpaceX=m_fFontSpacing;
		C.SetDrawColor(TextColor.R,TextColor.G,TextColor.B);
		ClipText(C,TextX,TextY,Text,True);
	}
}

defaultproperties
{
    m_RightCurveLineWidth=11.00
    m_fVBorderOffset=1.00
    m_RLeftcurve=(X=1188363,Y=571277312,W=57,H=598537)
    m_RBetweenCurveBG=(X=6365707,Y=571015168,W=33,H=1516040)
    m_RUnderLeftCurveBG=(X=5513739,Y=571015168,W=9,H=1909256)
    m_topLeftCornerR=(X=795147,Y=571277312,W=56,H=401929)
    m_fHBorderPadding=7.00
    m_fVBorderPadding=6.00
    m_BGTextureRegion=(X=5054987,Y=571015168,W=4,H=1909256)
}
/*
    m_TLeftcurve=Texture'R6MenuTextures.Gui_BoxScroll'
    m_TBetweenCurveBG=Texture'R6MenuTextures.Gui_BoxScroll'
    m_TUnderLeftCurveBG=Texture'R6MenuTextures.Gui_BoxScroll'
    m_topLeftCornerT=Texture'R6MenuTextures.Gui_BoxScroll'
*/

