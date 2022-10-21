//================================================================================
// R6MenuTimeLineGotoLast.
//================================================================================
class R6MenuTimeLineGotoLast extends R6WindowButton;

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
	R6PlanningCtrl(GetPlayerOwner()).GotoLastNode();
	R6MenuRootWindow(Root).m_PlanningWidget.CloseAllPopup();
}

defaultproperties
{
    m_iDrawStyle=5
    bUseRegion=True
    UpRegion=(X=6234630,Y=570753024,W=92,H=1450500)
    DownRegion=(X=6234630,Y=570753024,W=138,H=1450500)
    DisabledRegion=(X=6234630,Y=570753024,W=161,H=1647108)
    OverRegion=(X=6234630,Y=570753024,W=115,H=1450500)
}
/*
    UpTexture=Texture'R6MenuTextures.Gui_03'
    DownTexture=Texture'R6MenuTextures.Gui_03'
    DisabledTexture=Texture'R6MenuTextures.Gui_03'
    OverTexture=Texture'R6MenuTextures.Gui_03'
*/

