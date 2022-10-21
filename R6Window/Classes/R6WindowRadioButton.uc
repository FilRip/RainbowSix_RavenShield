//================================================================================
// R6WindowRadioButton.
//================================================================================
class R6WindowRadioButton extends R6WindowButton;

var bool bCenter;

function Paint (Canvas C, float X, float Y)
{
	if ( m_buttonFont != None )
	{
		C.Font=m_buttonFont;
	}
	else
	{
		C.Font=Root.Fonts[Font];
	}
	if ( m_bDrawBorders )
	{
		R6WindowLookAndFeel(LookAndFeel).DrawButtonBorder(self,C,True);
	}
	C.Style=m_iDrawStyle;
	C.SetDrawColor(m_BorderColor.R,m_BorderColor.G,m_BorderColor.B);
	if ( bDisabled )
	{
		if ( DisabledTexture != None )
		{
			if ( bUseRegion )
			{
				DrawStretchedTextureSegment(C,ImageX,ImageY,DisabledRegion.W * RegionScale,DisabledRegion.H * RegionScale,DisabledRegion.X,DisabledRegion.Y,DisabledRegion.W,DisabledRegion.H,DisabledTexture);
			}
			else
			{
				if ( bStretched )
				{
					DrawStretchedTexture(C,ImageX,ImageY,WinWidth,WinHeight,DisabledTexture);
				}
				else
				{
					DrawClippedTexture(C,ImageX,ImageY,DisabledTexture);
				}
			}
		}
	}
	else
	{
		if ( m_bSelected )
		{
			if ( DownTexture != None )
			{
				if ( bUseRegion && bCenter )
				{
					DrawStretchedTextureSegment(C,(WinWidth - DownRegion.W) / 2,(WinHeight - DownRegion.H) / 2,DownRegion.W,DownRegion.H,DownRegion.X,DownRegion.Y,DownRegion.W,DownRegion.H,DownTexture);
				}
				else
				{
					if ( bUseRegion )
					{
						DrawStretchedTextureSegment(C,ImageX,ImageY,DownRegion.W * RegionScale,DownRegion.H * RegionScale,DownRegion.X,DownRegion.Y,DownRegion.W,DownRegion.H,DownTexture);
					}
					else
					{
						if ( bStretched )
						{
							DrawStretchedTexture(C,ImageX,ImageY,WinWidth,WinHeight,DownTexture);
						}
						else
						{
							DrawClippedTexture(C,ImageX,ImageY,DownTexture);
						}
					}
				}
			}
		}
		else
		{
			if ( MouseIsOver() )
			{
				if ( OverTexture != None )
				{
					if ( bUseRegion )
					{
						DrawStretchedTextureSegment(C,ImageX,ImageY,OverRegion.W * RegionScale,OverRegion.H * RegionScale,OverRegion.X,OverRegion.Y,OverRegion.W,OverRegion.H,OverTexture);
					}
					else
					{
						if ( bStretched )
						{
							DrawStretchedTexture(C,ImageX,ImageY,WinWidth,WinHeight,OverTexture);
						}
						else
						{
							DrawClippedTexture(C,ImageX,ImageY,OverTexture);
						}
					}
				}
			}
			else
			{
				if ( UpTexture != None )
				{
					if ( bUseRegion )
					{
						DrawStretchedTextureSegment(C,ImageX,ImageY,UpRegion.W * RegionScale,UpRegion.H * RegionScale,UpRegion.X,UpRegion.Y,UpRegion.W,UpRegion.H,UpTexture);
					}
					else
					{
						if ( bStretched )
						{
							DrawStretchedTexture(C,ImageX,ImageY,WinWidth,WinHeight,UpTexture);
						}
						else
						{
							DrawClippedTexture(C,ImageX,ImageY,UpTexture);
						}
					}
				}
			}
		}
	}
	C.Style=1;
	if ( Text != "" )
	{
		if ( bDisabled )
		{
			C.SetDrawColor(m_DisabledTextColor.R,m_DisabledTextColor.G,m_DisabledTextColor.B);
		}
		else
		{
			if ( m_bSelected )
			{
				C.SetDrawColor(m_SelectedTextColor.R,m_SelectedTextColor.G,m_SelectedTextColor.B);
			}
			else
			{
				if ( MouseIsOver() )
				{
					C.SetDrawColor(m_OverTextColor.R,m_OverTextColor.G,m_OverTextColor.B);
				}
				else
				{
					C.SetDrawColor(TextColor.R,TextColor.G,TextColor.B);
				}
			}
		}
		ClipText(C,TextX,TextY,Text,True);
	}
}

defaultproperties
{
    bCenter=True
    m_iDrawStyle=5
    m_bDrawBorders=True
    bUseRegion=True
    ImageX=2.00
    ImageY=2.00
    DownRegion=(X=3416589,Y=571015168,W=10,H=664072)
}
/*
    DownTexture=Texture'R6MenuTextures.Gui_BoxScroll'
*/

