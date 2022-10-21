//================================================================================
// R6MenuLegendButton.
//================================================================================
class R6MenuLegendButton extends R6WindowStayDownButton;

function Created ()
{
	bNoKeyboard=True;
	ToolTipString=Localize("PlanningMenu","Legend","R6Menu");
	ImageX=(WinWidth - UpRegion.W) / 2;
	ImageY=(WinHeight - UpRegion.H) / 2;
	m_BorderColor=Root.Colors.GrayLight;
}

function BeforePaint (Canvas C, float X, float Y)
{
}

function Tick (float fDeltaTime)
{
}

function LMouseDown (float X, float Y)
{
	Super.LMouseDown(X,Y);
	R6MenuRootWindow(Root).m_bPlayerWantLegend=m_bSelected;
	R6MenuRootWindow(Root).m_PlanningWidget.m_LegendWindow.ToggleLegend();
}

function Paint (Canvas C, float X, float Y)
{
	C.SetDrawColor(Root.Colors.GrayDark.R,Root.Colors.GrayDark.G,Root.Colors.GrayDark.B);
//	DrawStretchedTextureSegment(C,0.00,0.00,WinWidth,WinHeight,0.00,0.00,WinWidth,WinHeight,Texture'LaptopTileBG');
	C.SetDrawColor(Root.Colors.White.R,Root.Colors.White.G,Root.Colors.White.B);
	Super.Paint(C,X,Y);
	DrawSimpleBorder(C);
}

defaultproperties
{
    m_iDrawStyle=5
    bStretched=True
    bUseRegion=True
    UpRegion=(X=15147526,Y=570753024,W=92,H=1319428)
    DownRegion=(X=15147526,Y=570753024,W=120,H=1319428)
    DisabledRegion=(X=15147526,Y=570753024,W=134,H=1319428)
    OverRegion=(X=15147526,Y=570753024,W=106,H=1319428)
}
/*
    UpTexture=Texture'R6MenuTextures.Gui_03'
    DownTexture=Texture'R6MenuTextures.Gui_03'
    DisabledTexture=Texture'R6MenuTextures.Gui_03'
    OverTexture=Texture'R6MenuTextures.Gui_03'
*/

