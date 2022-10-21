//================================================================================
// R6MenuTimeLineNext.
//================================================================================
class R6MenuTimeLineNext extends R6WindowButton;

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
	R6PlanningCtrl(GetPlayerOwner()).GoToNextNode();
	R6MenuRootWindow(Root).m_PlanningWidget.CloseAllPopup();
}

defaultproperties
{
    m_iDrawStyle=5
    bUseRegion=True
    UpRegion=(X=4596230,Y=570753024,W=92,H=1647108)
    DownRegion=(X=4596230,Y=570753024,W=138,H=1647108)
    DisabledRegion=(X=4596230,Y=570753024,W=161,H=1647108)
    OverRegion=(X=4596230,Y=570753024,W=115,H=1647108)
}
/*
    UpTexture=Texture'R6MenuTextures.Gui_03'
    DownTexture=Texture'R6MenuTextures.Gui_03'
    DisabledTexture=Texture'R6MenuTextures.Gui_03'
    OverTexture=Texture'R6MenuTextures.Gui_03'
*/

