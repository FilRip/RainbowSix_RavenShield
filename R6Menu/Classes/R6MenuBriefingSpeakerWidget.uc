//================================================================================
// R6MenuBriefingSpeakerWidget.
//================================================================================
class R6MenuBriefingSpeakerWidget extends UWindowWindow;

var float m_fHBorderHeight;
var float m_fVBorderWidth;
var float m_fHBorderPadding;
var float m_fVBorderPadding;
var Texture m_Texture[4];
var Texture m_HBorderTexture;
var Texture m_VBorderTexture;
var Region m_TextureRegion[4];
var Region m_HBorderTextureRegion;
var Region m_VBorderTextureRegion;

function Created ()
{
	m_Texture[0]=Texture(DynamicLoadObject("R6BlackSnow.Mission.3dmodel",Class'Texture'));
	m_TextureRegion[0]=NewRegion(0.00,0.00,151.00,113.00);
}

function Paint (Canvas C, float X, float Y)
{
	C.SetDrawColor(m_BorderColor.R,m_BorderColor.G,m_BorderColor.B);
	C.Style=m_BorderStyle;
	if ( m_HBorderTexture != None )
	{
		DrawStretchedTextureSegment(C,m_fHBorderPadding,0.00,WinWidth - 2 * m_fHBorderPadding,m_fHBorderHeight,m_HBorderTextureRegion.X,m_HBorderTextureRegion.Y,m_HBorderTextureRegion.W,m_HBorderTextureRegion.H,m_HBorderTexture);
		DrawStretchedTextureSegment(C,m_fHBorderPadding,WinHeight - m_fHBorderHeight,WinWidth - 2 * m_fHBorderPadding,m_fHBorderHeight,m_HBorderTextureRegion.X,m_HBorderTextureRegion.Y,m_HBorderTextureRegion.W,m_HBorderTextureRegion.H,m_HBorderTexture);
		DrawStretchedTextureSegment(C,m_fHBorderPadding,m_fHBorderHeight + m_TextureRegion[0].H,WinWidth,m_fHBorderHeight,m_HBorderTextureRegion.X,m_HBorderTextureRegion.Y,m_HBorderTextureRegion.W,m_HBorderTextureRegion.H,m_HBorderTexture);
	}
	if ( m_VBorderTexture != None )
	{
		DrawStretchedTextureSegment(C,0.00,m_fHBorderHeight + m_fVBorderPadding,m_fVBorderWidth,WinHeight - 2 * m_fHBorderHeight - 2 * m_fVBorderPadding,m_VBorderTextureRegion.X,m_VBorderTextureRegion.Y,m_VBorderTextureRegion.W,m_VBorderTextureRegion.H,m_VBorderTexture);
		DrawStretchedTextureSegment(C,WinWidth - m_fVBorderWidth,m_fHBorderHeight + m_fVBorderPadding,m_fVBorderWidth,WinHeight - 2 * m_fHBorderHeight - 2 * m_fVBorderPadding,m_VBorderTextureRegion.X,m_VBorderTextureRegion.Y,m_VBorderTextureRegion.W,m_VBorderTextureRegion.H,m_VBorderTexture);
	}
	C.SetDrawColor(255,255,255);
	DrawStretchedTextureSegment(C,m_fVBorderWidth,m_fHBorderHeight,m_TextureRegion[0].W,m_TextureRegion[0].H,m_TextureRegion[0].X,m_TextureRegion[0].Y,m_TextureRegion[0].W,m_TextureRegion[0].H,m_Texture[0]);
}