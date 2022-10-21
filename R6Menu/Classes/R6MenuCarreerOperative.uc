//================================================================================
// R6MenuCarreerOperative.
//================================================================================
class R6MenuCarreerOperative extends UWindowWindow;

var float m_fXPos;
var float m_fXFacePos;
var float m_fYFacePos;
var float m_fTileHeight;
var R6WindowBitMap m_OperativeFace;
var Region RTopRight;
var Region RMidRight;
var Region RTopLeft;
var Region RMidLeft;

function Created ()
{
	m_fXPos=(WinWidth - RTopLeft.W - RTopRight.W) / 2;
	m_OperativeFace=R6WindowBitMap(CreateWindow(Class'R6WindowBitMap',m_fXPos + m_fXFacePos,m_fYFacePos,WinWidth - m_fXPos - m_fXFacePos,WinHeight - 2 * m_fYFacePos,self));
	m_OperativeFace.m_iDrawStyle=5;
	m_BorderColor=Root.Colors.Yellow;
	m_fTileHeight=WinHeight - RTopLeft.H - RTopLeft.H;
}

function AfterPaint (Canvas C, float X, float Y)
{
	local int i;
	local int j;

	C.Style=5;
	C.SetDrawColor(m_BorderColor.R,m_BorderColor.G,m_BorderColor.B,m_BorderColor.A);
	DrawStretchedTextureSegment(C,m_fXPos,0.00,RTopLeft.W,RTopLeft.H,RTopLeft.X,RTopLeft.Y,RTopLeft.W,RTopLeft.H,m_BorderTexture);
	DrawStretchedTextureSegment(C,m_fXPos + RTopLeft.W,0.00,RTopRight.W,RTopRight.H,RTopRight.X,RTopRight.Y,RTopRight.W,RTopRight.H,m_BorderTexture);
	i=0;
JL011E:
	if ( i + RMidLeft.H < m_fTileHeight )
	{
		DrawStretchedTextureSegment(C,m_fXPos,RTopLeft.H + i,RMidLeft.W,RMidLeft.H,RMidLeft.X,RMidLeft.Y,RMidLeft.W,RMidLeft.H,m_BorderTexture);
		DrawStretchedTextureSegment(C,m_fXPos + RMidLeft.W,RTopLeft.H + i,RMidRight.W,RMidRight.H,RMidRight.X,RMidRight.Y,RMidRight.W,RMidRight.H,m_BorderTexture);
		i += RMidLeft.H;
		goto JL011E;
	}
	j=m_fTileHeight - i;
	if ( j > 0 )
	{
		DrawStretchedTextureSegment(C,m_fXPos,RTopLeft.H + i,RMidLeft.W,j,RMidLeft.X,RMidLeft.Y,RMidLeft.W,j,m_BorderTexture);
		DrawStretchedTextureSegment(C,m_fXPos + RMidLeft.W,RTopLeft.H + i,RMidRight.W,j,RMidRight.X,RMidRight.Y,RMidRight.W,j,m_BorderTexture);
	}
	DrawStretchedTextureSegment(C,m_fXPos,WinHeight - RTopLeft.H,RTopLeft.W,RTopLeft.H,RTopLeft.X,RTopLeft.Y + RTopLeft.H,RTopLeft.W, -RTopLeft.H,m_BorderTexture);
	DrawStretchedTextureSegment(C,m_fXPos + RTopLeft.W,WinHeight - RTopRight.H,RTopRight.W,RTopRight.H,RTopRight.X,RTopRight.Y + RTopRight.H,RTopRight.W, -RTopRight.H,m_BorderTexture);
}

function setFace (Texture _OperativeFace, Region _FaceRegion)
{
	m_OperativeFace.t=_OperativeFace;
	m_OperativeFace.R=_FaceRegion;
}

function SetTeam (int _Team)
{
	m_BorderColor=Root.Colors.TeamColor[_Team];
}

defaultproperties
{
    m_fXFacePos=2.00
    m_fYFacePos=2.00
    RTopRight=(X=5841413,Y=570687488,W=170,H=205315)
    RMidRight=(X=6038021,Y=570687488,W=170,H=139779)
    RTopLeft=(X=6234629,Y=570687488,W=123,H=205315)
    RMidLeft=(X=6431237,Y=570687488,W=123,H=139779)
}
/*
    m_BorderTexture=Texture'R6MenuTextures.Gui_BoxScroll'
*/

