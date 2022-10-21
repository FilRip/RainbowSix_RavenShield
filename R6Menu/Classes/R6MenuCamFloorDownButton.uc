//================================================================================
// R6MenuCamFloorDownButton.
//================================================================================
class R6MenuCamFloorDownButton extends R6WindowButton;

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
		R6PlanningCtrl(GetPlayerOwner()).m_bLevelDown=1;
		R6PlanningCtrl(GetPlayerOwner()).m_bGoLevelDown=1;
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
		R6PlanningCtrl(GetPlayerOwner()).m_bLevelDown=0;
		R6PlanningCtrl(GetPlayerOwner()).m_bGoLevelDown=1;
	}
}

defaultproperties
{
    m_iDrawStyle=5
    bUseRegion=True
    ImageX=3.00
    UpRegion=(X=15016454,Y=570687488,W=27,H=1516035)
    DownRegion=(X=15016454,Y=570753024,W=46,H=1778180)
    DisabledRegion=(X=15016454,Y=570753024,W=69,H=1778180)
    OverRegion=(X=15016454,Y=570753024,W=23,H=1778180)
}
/*
    UpTexture=Texture'R6MenuTextures.Gui_03'
    DownTexture=Texture'R6MenuTextures.Gui_03'
    DisabledTexture=Texture'R6MenuTextures.Gui_03'
    OverTexture=Texture'R6MenuTextures.Gui_03'
*/

