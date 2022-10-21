//================================================================================
// R6WindowPopUpButton.
//================================================================================
class R6WindowPopUpButton extends UWindowButton;

var bool m_bDrawRedBG;
var bool m_bDrawGreenBG;
var Texture m_TButBorderTex;
var Region m_RButBorder;

function Paint (Canvas C, float X, float Y)
{
	C.Style=5;
	if ( m_bDrawRedBG )
	{
		C.SetDrawColor(Root.Colors.TeamColorLight[0].R,Root.Colors.TeamColorLight[0].G,Root.Colors.TeamColorLight[0].B);
	}
	else
	{
		if ( m_bDrawGreenBG )
		{
			C.SetDrawColor(Root.Colors.TeamColorLight[1].R,Root.Colors.TeamColorLight[1].G,Root.Colors.TeamColorLight[1].B);
		}
		else
		{
			C.SetDrawColor(Root.Colors.White.R,Root.Colors.White.G,Root.Colors.White.B);
		}
	}
	Super.Paint(C,X,Y);
	if ( Text == "" )
	{
		DrawStretchedTextureSegment(C,0.00,0.00,WinWidth,WinHeight,m_RButBorder.X,m_RButBorder.Y,m_RButBorder.W,m_RButBorder.H,m_TButBorderTex);
	}
}

defaultproperties
{
    m_RButBorder=(X=1712651,Y=571277312,W=40,H=1516041)
    m_bWaitSoundFinish=True
}
/*
    m_TButBorderTex=Texture'R6MenuTextures.Gui_BoxScroll'
*/

