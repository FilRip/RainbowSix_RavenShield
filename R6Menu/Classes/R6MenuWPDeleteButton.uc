//================================================================================
// R6MenuWPDeleteButton.
//================================================================================
class R6MenuWPDeleteButton extends R6WindowButton;

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
}

simulated function Click (float X, float Y)
{
	Super.Click(X,Y);
	R6PlanningCtrl(GetPlayerOwner()).DeleteOneNode();
	R6MenuRootWindow(Root).m_PlanningWidget.CloseAllPopup();
}

defaultproperties
{
    m_iDrawStyle=5
    bUseRegion=True
    m_bPlayButtonSnd=False
    UpRegion=(X=1843716,Y=570621952,W=23,H=0)
    DownRegion=(X=3023365,Y=570687488,W=28,H=1516035)
    DisabledRegion=(X=4530693,Y=570687488,W=28,H=1516035)
    OverRegion=(X=1516037,Y=570687488,W=28,H=1516035)
}
/*
    UpTexture=Texture'R6MenuTextures.Gui_03'
    DownTexture=Texture'R6MenuTextures.Gui_03'
    DisabledTexture=Texture'R6MenuTextures.Gui_03'
    OverTexture=Texture'R6MenuTextures.Gui_03'
*/

