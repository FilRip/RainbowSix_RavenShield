//================================================================================
// R6Menu3DViewOnOffButton.
//================================================================================
class R6Menu3DViewOnOffButton extends R6WindowStayDownButton;

function Created ()
{
	bNoKeyboard=True;
	ToolTipString=Localize("PlanningMenu","3DView","R6Menu");
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
	local R6MenuRootWindow r6Root;

	Super.LMouseDown(X,Y);
	r6Root=R6MenuRootWindow(Root);
	r6Root.Set3dView( !m_bSelected);
	r6Root.m_PlanningWidget.m_3DWindow.Toggle3DWindow();
	r6Root.m_PlanningWidget.CloseAllPopup();
	R6PlanningCtrl(GetPlayerOwner()).Toggle3DView();
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
    UpRegion=(X=12067333,Y=570687488,W=33,H=926211)
    DownRegion=(X=13902341,Y=570687488,W=33,H=926211)
    DisabledRegion=(X=14819845,Y=570687488,W=33,H=926211)
    OverRegion=(X=12984837,Y=570687488,W=33,H=926211)
}
/*
    UpTexture=Texture'R6MenuTextures.Gui_03'
    DownTexture=Texture'R6MenuTextures.Gui_03'
    DisabledTexture=Texture'R6MenuTextures.Gui_03'
    OverTexture=Texture'R6MenuTextures.Gui_03'
*/

