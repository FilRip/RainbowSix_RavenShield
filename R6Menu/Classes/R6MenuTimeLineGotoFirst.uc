//================================================================================
// R6MenuTimeLineGotoFirst.
//================================================================================
class R6MenuTimeLineGotoFirst extends R6WindowButton;

function Created ()
{
	bNoKeyboard=True;
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
	if ( bDisabled )
	{
		return;
	}
	R6PlanningCtrl(GetPlayerOwner()).GotoFirstNode();
	R6MenuRootWindow(Root).m_PlanningWidget.CloseAllPopup();
}

defaultproperties
{
    m_iDrawStyle=5
    bUseRegion=True
    UpRegion=(X=6038021,Y=570687488,W=22,H=1516035)
    DownRegion=(X=9052677,Y=570687488,W=22,H=1516035)
    DisabledRegion=(X=10560005,Y=570687488,W=22,H=1516035)
    OverRegion=(X=7545349,Y=570687488,W=22,H=1516035)
}
/*
    UpTexture=Texture'R6MenuTextures.Gui_03'
    DownTexture=Texture'R6MenuTextures.Gui_03'
    DisabledTexture=Texture'R6MenuTextures.Gui_03'
    OverTexture=Texture'R6MenuTextures.Gui_03'
*/

