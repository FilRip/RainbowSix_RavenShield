//================================================================================
// R6MenuAssignAllButton.
//================================================================================
class R6MenuAssignAllButton extends R6WindowButton;

var bool m_bDrawLeftBorder;
var bool m_bDrawRightBorder;
var bool m_bDrawTopBorder;
var bool m_bDrawDownBorder;
var Color m_DisableColor;
var Color m_EnableColor;

function Created ()
{
	m_DisableColor=Root.Colors.GrayLight;
	m_EnableColor=Root.Colors.White;
	m_vButtonColor=m_DisableColor;
	m_BorderColor=m_DisableColor;
	m_bDrawBorders=True;
	m_bDrawSimpleBorder=True;
}

function RMouseDown (float X, float Y)
{
	bRMouseDown=True;
}

function MMouseDown (float X, float Y)
{
	bMMouseDown=True;
}

function LMouseDown (float X, float Y)
{
	bMouseDown=True;
}

function DrawSimpleBorder (Canvas C)
{
	C.Style=m_BorderStyle;
	C.SetDrawColor(m_BorderColor.R,m_BorderColor.G,m_BorderColor.B);
	if ( m_bDrawTopBorder )
	{
		DrawStretchedTextureSegment(C,0.00,0.00,WinWidth,m_BorderTextureRegion.H,m_BorderTextureRegion.X,m_BorderTextureRegion.Y,m_BorderTextureRegion.W,m_BorderTextureRegion.H,m_BorderTexture);
	}
	if ( m_bDrawDownBorder )
	{
		DrawStretchedTextureSegment(C,0.00,WinHeight - m_BorderTextureRegion.H,WinWidth,m_BorderTextureRegion.H,m_BorderTextureRegion.X,m_BorderTextureRegion.Y,m_BorderTextureRegion.W,m_BorderTextureRegion.H,m_BorderTexture);
	}
	if ( m_bDrawLeftBorder )
	{
		DrawStretchedTextureSegment(C,0.00,m_BorderTextureRegion.H,m_BorderTextureRegion.W,WinHeight - 2 * m_BorderTextureRegion.H,m_BorderTextureRegion.X,m_BorderTextureRegion.Y,m_BorderTextureRegion.W,m_BorderTextureRegion.H,m_BorderTexture);
	}
	if ( m_bDrawRightBorder )
	{
		DrawStretchedTextureSegment(C,WinWidth - m_BorderTextureRegion.W,m_BorderTextureRegion.H,m_BorderTextureRegion.W,WinHeight - 2 * m_BorderTextureRegion.H,m_BorderTextureRegion.X,m_BorderTextureRegion.Y,m_BorderTextureRegion.W,m_BorderTextureRegion.H,m_BorderTexture);
	}
}

function SetButtonStatus (bool _bDisable)
{
	bDisabled=_bDisable;
	if ( _bDisable )
	{
		m_vButtonColor=m_DisableColor;
	}
	else
	{
		m_vButtonColor=m_EnableColor;
	}
}

function SetBorderColor (Color _NewColor)
{
	m_BorderColor=_NewColor;
}

function SetCompleteAssignAllButton ()
{
	m_bDrawLeftBorder=True;
	m_bDrawRightBorder=True;
	m_bDrawTopBorder=True;
	m_bDrawDownBorder=True;
	UpRegion=NewRegion(172.00,0.00,30.00,13.00);
	OverRegion=NewRegion(172.00,13.00,30.00,13.00);
	DownRegion=NewRegion(172.00,26.00,30.00,13.00);
	DisabledRegion=NewRegion(172.00,0.00,30.00,13.00);
	ImageX=(WinWidth - UpRegion.W) / 2;
	ImageY=0.00;
}

defaultproperties
{
    m_bDrawLeftBorder=True
    m_iDrawStyle=5
    bUseRegion=True
    UpRegion=(X=11280902,Y=570687488,W=10,H=860675)
    DownRegion=(X=11280902,Y=570753024,W=26,H=664068)
    DisabledRegion=(X=11280902,Y=570687488,W=10,H=860675)
    OverRegion=(X=11280902,Y=570753024,W=13,H=664068)
}
/*
    UpTexture=Texture'R6MenuTextures.Gui_BoxScroll'
    DownTexture=Texture'R6MenuTextures.Gui_BoxScroll'
    DisabledTexture=Texture'R6MenuTextures.Gui_BoxScroll'
    OverTexture=Texture'R6MenuTextures.Gui_BoxScroll'
*/

