//================================================================================
// R6LegendNextPageButton.
//================================================================================
class R6LegendNextPageButton extends UWindowButton;

function Created ()
{
	bNoKeyboard=True;
	ToolTipString=Localize("PlanningLegend","MainNext","R6Menu");
}

function BeforePaint (Canvas C, float X, float Y)
{
}

function LMouseDown (float X, float Y)
{
	Super.LMouseDown(X,Y);
	R6WindowLegend(ParentWindow).NextPage();
}

defaultproperties
{
    bStretched=True
    bUseRegion=True
    UpRegion=(X=16523782,Y=570687488,W=-12,H=795139)
    DownRegion=(X=16523782,Y=570753024,W=24,H=-777724)
    OverRegion=(X=16523782,Y=570753024,W=12,H=-777724)
}
/*
    UpTexture=Texture'R6MenuTextures.Gui_BoxScroll'
    DownTexture=Texture'R6MenuTextures.Gui_BoxScroll'
    OverTexture=Texture'R6MenuTextures.Gui_BoxScroll'
*/

