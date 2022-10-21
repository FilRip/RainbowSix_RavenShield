//================================================================================
// R6MenuCamZoomOutButton.
//================================================================================
class R6MenuCamZoomOutButton extends R6WindowButton;

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

function LMouseDown (float X, float Y)
{
	Super.LMouseDown(X,Y);
	if ( bDisabled )
	{
		return;
	}
	if ( GetPlayerOwner().IsA('R6PlanningCtrl') )
	{
		R6PlanningCtrl(GetPlayerOwner()).m_bZoomOut=1;
		R6MenuRootWindow(Root).m_PlanningWidget.CloseAllPopup();
	}
}

function LMouseUp (float X, float Y)
{
	local R6PlanningCtrl PlanningCtrl;

	Super.LMouseUp(X,Y);
	if ( bDisabled )
	{
		return;
	}
	if ( GetPlayerOwner().IsA('R6PlanningCtrl') )
	{
		R6PlanningCtrl(GetPlayerOwner()).m_bZoomOut=0;
	}
}

function MouseLeave ()
{
	Super.MouseLeave();
	if ( GetPlayerOwner().IsA('R6PlanningCtrl') )
	{
		R6PlanningCtrl(GetPlayerOwner()).m_bZoomOut=0;
	}
}

defaultproperties
{
    m_iDrawStyle=5
    bUseRegion=True
    ImageX=2.00
    UpRegion=(X=9839110,Y=570687488,W=28,H=1516035)
    DownRegion=(X=9839110,Y=570753024,W=46,H=1843716)
    DisabledRegion=(X=9839110,Y=570753024,W=69,H=1843716)
    OverRegion=(X=9839110,Y=570753024,W=23,H=1843716)
}
/*
    UpTexture=Texture'R6MenuTextures.Gui_03'
    DownTexture=Texture'R6MenuTextures.Gui_03'
    DisabledTexture=Texture'R6MenuTextures.Gui_03'
    OverTexture=Texture'R6MenuTextures.Gui_03'
*/

