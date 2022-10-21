//================================================================================
// R6LegendPreviousPageButton.
//================================================================================
class R6LegendPreviousPageButton extends UWindowButton;

function Created ()
{
	bNoKeyboard=True;
	ToolTipString=Localize("PlanningLegend","MainPrevious","R6Menu");
}

function BeforePaint (Canvas C, float X, float Y)
{
}

function LMouseDown (float X, float Y)
{
	Super.LMouseDown(X,Y);
	R6WindowLegend(ParentWindow).PreviousPage();
}

defaultproperties
{
    bStretched=True
    bUseRegion=True
    UpRegion=(X=15737350,Y=570687488,W=12,H=795139)
    DownRegion=(X=15737350,Y=570753024,W=24,H=795140)
    OverRegion=(X=15737350,Y=570753024,W=12,H=795140)
}
/*
    UpTexture=Texture'R6MenuTextures.Gui_BoxScroll'
    DownTexture=Texture'R6MenuTextures.Gui_BoxScroll'
    OverTexture=Texture'R6MenuTextures.Gui_BoxScroll'
*/

