//================================================================================
// R6MenuTimeLineLock.
//================================================================================
class R6MenuTimeLineLock extends R6WindowButton;

var bool m_bLocked;
var Region m_ButtonRegions[8];

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
	m_bLocked= !m_bLocked;
	R6PlanningCtrl(GetPlayerOwner()).m_bLockCamera=m_bLocked;
	if ( m_bLocked == True )
	{
		UpRegion=m_ButtonRegions[0];
		OverRegion=m_ButtonRegions[1];
		DownRegion=m_ButtonRegions[2];
		DisabledRegion=m_ButtonRegions[3];
	}
	else
	{
		UpRegion=m_ButtonRegions[4];
		OverRegion=m_ButtonRegions[5];
		DownRegion=m_ButtonRegions[6];
		DisabledRegion=m_ButtonRegions[7];
	}
	R6MenuRootWindow(Root).m_PlanningWidget.CloseAllPopup();
}

function ResetCameraLock ()
{
	m_bLocked=False;
	UpRegion=m_ButtonRegions[4];
	OverRegion=m_ButtonRegions[5];
	DownRegion=m_ButtonRegions[6];
	DisabledRegion=m_ButtonRegions[7];
}

defaultproperties
{
    m_ButtonRegions(0)=(X=10691078,Y=570753024,W=92,H=1712644)
    m_ButtonRegions(1)=(X=10691078,Y=570753024,W=115,H=1712644)
    m_ButtonRegions(2)=(X=10691078,Y=570753024,W=138,H=1712644)
    m_ButtonRegions(3)=(X=10691078,Y=570753024,W=161,H=1712644)
    m_ButtonRegions(4)=(X=7676422,Y=570753024,W=92,H=1712644)
    m_ButtonRegions(5)=(X=7676422,Y=570753024,W=115,H=1712644)
    m_ButtonRegions(6)=(X=7676422,Y=570753024,W=138,H=1712644)
    m_ButtonRegions(7)=(X=7676422,Y=570753024,W=161,H=1712644)
    m_iDrawStyle=5
    bUseRegion=True
    UpRegion=(X=7676422,Y=570753024,W=92,H=1712644)
    DownRegion=(X=7676422,Y=570753024,W=138,H=1712644)
    DisabledRegion=(X=7676422,Y=570753024,W=161,H=1712644)
    OverRegion=(X=7676422,Y=570753024,W=115,H=1712644)
}
/*
    UpTexture=Texture'R6MenuTextures.Gui_03'
    DownTexture=Texture'R6MenuTextures.Gui_03'
    DisabledTexture=Texture'R6MenuTextures.Gui_03'
    OverTexture=Texture'R6MenuTextures.Gui_03'
*/

