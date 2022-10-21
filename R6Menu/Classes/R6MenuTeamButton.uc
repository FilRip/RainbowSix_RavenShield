//================================================================================
// R6MenuTeamButton.
//================================================================================
class R6MenuTeamButton extends R6WindowButton;

var int m_iTeamColor;
var Texture m_DotTexture;
var Region m_DotRegion;

function Created ()
{
	bNoKeyboard=True;
}

function BeforePaint (Canvas C, float X, float Y)
{
}

function Tick (float fDelta)
{
}

function Paint (Canvas C, float X, float Y)
{
	Super.Paint(C,X,Y);
	if ( m_bSelected == True )
	{
		C.SetDrawColor(m_vButtonColor.R,m_vButtonColor.G,m_vButtonColor.B);
		DrawStretchedTextureSegment(C,0.00,0.00,WinWidth,WinHeight,m_DotRegion.X,m_DotRegion.Y,m_DotRegion.W,m_DotRegion.H,m_DotTexture);
	}
}

function LMouseDown (float X, float Y)
{
	local float fGlobalX;
	local float fGlobalY;

	Super.LMouseDown(X,Y);
	if (  !bDisabled && OwnerWindow.IsA('R6MenuTeamBar') )
	{
		R6MenuTeamBar(OwnerWindow).SetTeamActive(m_iTeamColor);
		R6MenuRootWindow(Root).m_PlanningWidget.CloseAllPopup();
	}
}

defaultproperties
{
    m_DotRegion=(X=13115910,Y=570753024,W=43,H=926212)
    m_iDrawStyle=5
    bUseRegion=True
    UpRegion=(X=14230022,Y=570753024,W=92,H=926212)
    DownRegion=(X=14230022,Y=570753024,W=138,H=926212)
    DisabledRegion=(X=14230022,Y=570753024,W=161,H=926212)
    OverRegion=(X=14230022,Y=570753024,W=115,H=926212)
}
/*
    m_DotTexture=Texture'R6MenuTextures.Gui_BoxScroll'
    UpTexture=Texture'R6MenuTextures.Gui_03'
    DownTexture=Texture'R6MenuTextures.Gui_03'
    DisabledTexture=Texture'R6MenuTextures.Gui_03'
    OverTexture=Texture'R6MenuTextures.Gui_03'
*/

