//================================================================================
// R6MenuTeamDisplayButton.
//================================================================================
class R6MenuTeamDisplayButton extends R6WindowButton;

var int m_iTeamColor;
var Texture m_ActiveTexture;
var Region m_ActiveRegion;

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
		DrawStretchedTextureSegment(C,0.00,0.00,WinWidth,WinHeight,m_ActiveRegion.X,m_ActiveRegion.Y,m_ActiveRegion.W,m_ActiveRegion.H,m_ActiveTexture);
	}
}

function LMouseDown (float X, float Y)
{
	local float fGlobalX;
	local float fGlobalY;

	if (  !bDisabled && (m_iTeamColor != R6PlanningCtrl(GetPlayerOwner()).m_iCurrentTeam) )
	{
		Super.LMouseDown(X,Y);
		m_bSelected= !m_bSelected;
		R6PlanningCtrl(GetPlayerOwner()).m_pTeamInfo[m_iTeamColor].SetPathDisplay(m_bSelected);
		R6MenuRootWindow(Root).m_PlanningWidget.CloseAllPopup();
	}
}

defaultproperties
{
    m_ActiveRegion=(X=11280902,Y=570753024,W=43,H=1843716)
    m_iDrawStyle=5
    bUseRegion=True
    m_bSelected=True
    UpRegion=(X=12395014,Y=570753024,W=92,H=1843716)
    DownRegion=(X=12395014,Y=570753024,W=138,H=1843716)
    DisabledRegion=(X=12395014,Y=570753024,W=161,H=1843716)
    OverRegion=(X=12395014,Y=570753024,W=115,H=1843716)
}
/*
    m_ActiveTexture=Texture'R6MenuTextures.Gui_BoxScroll'
    UpTexture=Texture'R6MenuTextures.Gui_03'
    DownTexture=Texture'R6MenuTextures.Gui_03'
    DisabledTexture=Texture'R6MenuTextures.Gui_03'
    OverTexture=Texture'R6MenuTextures.Gui_03'
*/

