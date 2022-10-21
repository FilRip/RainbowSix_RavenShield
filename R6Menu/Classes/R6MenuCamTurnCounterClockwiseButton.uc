//================================================================================
// R6MenuCamTurnCounterClockwiseButton.
//================================================================================
class R6MenuCamTurnCounterClockwiseButton extends R6WindowButton;

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
		R6PlanningCtrl(GetPlayerOwner()).m_bRotateCW=1;
		R6MenuRootWindow(Root).m_PlanningWidget.CloseAllPopup();
	}
}

function LMouseUp (float X, float Y)
{
	Super.LMouseUp(X,Y);
	if ( bDisabled )
	{
		return;
	}
	if ( GetPlayerOwner().IsA('R6PlanningCtrl') )
	{
		R6PlanningCtrl(GetPlayerOwner()).m_bRotateCW=0;
	}
}

function MouseLeave ()
{
	Super.MouseLeave();
	if ( bDisabled )
	{
		return;
	}
	if ( GetPlayerOwner().IsA('R6PlanningCtrl') )
	{
		R6PlanningCtrl(GetPlayerOwner()).m_bRotateCW=0;
	}
}

defaultproperties
{
    m_iDrawStyle=5
    bUseRegion=True
    UpRegion=(X=5513734,Y=570687488,W=33,H=1516035)
    DownRegion=(X=5513734,Y=570753024,W=46,H=2171396)
    DisabledRegion=(X=5513734,Y=570753024,W=69,H=2171396)
    OverRegion=(X=5513734,Y=570753024,W=23,H=2171396)
}
/*
    UpTexture=Texture'R6MenuTextures.Gui_03'
    DownTexture=Texture'R6MenuTextures.Gui_03'
    DisabledTexture=Texture'R6MenuTextures.Gui_03'
    OverTexture=Texture'R6MenuTextures.Gui_03'
*/

