//================================================================================
// R6WindowButtonGear.
//================================================================================
class R6WindowButtonGear extends R6WindowButton;

var bool m_HighLight;
var bool m_bForceMouseOver;
var float m_fAlpha;
var Texture m_HighLightTexture;

function RMouseDown (float X, float Y)
{
	bRMouseDown=True;
}

function MMouseDown (float X, float Y)
{
	bMMouseDown=True;
}

function LMouseDown (float X, float Y)
{
	bMouseDown=True;
}

function Paint (Canvas C, float X, float Y)
{
	C.Style=5;
	if ( bDisabled )
	{
		if ( DisabledTexture != None )
		{
			if (  !m_HighLight )
			{
				C.SetDrawColor(m_vButtonColor.R,m_vButtonColor.G,m_vButtonColor.B,m_fAlpha);
			}
			DrawStretchedTextureSegment(C,ImageX,ImageY,DisabledRegion.W * RegionScale,DisabledRegion.H * RegionScale,DisabledRegion.X,DisabledRegion.Y,DisabledRegion.W,DisabledRegion.H,DisabledTexture);
		}
	}
	else
	{
		if ( m_HighLight )
		{
			DrawStretchedTextureSegment(C,0.00,0.00,WinWidth,WinHeight,0.00,0.00,m_HighLightTexture.USize,m_HighLightTexture.VSize,m_HighLightTexture);
		}
		if ( bMouseDown )
		{
			if ( DownTexture != None )
			{
				C.SetDrawColor(m_vButtonColor.R,m_vButtonColor.G,m_vButtonColor.B);
				DrawStretchedTextureSegment(C,ImageX,ImageY,DownRegion.W * RegionScale,DownRegion.H * RegionScale,DownRegion.X,DownRegion.Y,DownRegion.W,DownRegion.H,DownTexture);
			}
		}
		else
		{
			if ( MouseIsOver() || m_bForceMouseOver )
			{
				if ( OverTexture != None )
				{
					C.SetDrawColor(m_vButtonColor.R,m_vButtonColor.G,m_vButtonColor.B);
					DrawStretchedTextureSegment(C,ImageX,ImageY,OverRegion.W * RegionScale,OverRegion.H * RegionScale,OverRegion.X,OverRegion.Y,OverRegion.W,OverRegion.H,OverTexture);
				}
			}
			else
			{
				if ( UpTexture != None )
				{
					if (  !m_HighLight )
					{
						C.SetDrawColor(m_vButtonColor.R,m_vButtonColor.G,m_vButtonColor.B,m_fAlpha);
					}
					DrawStretchedTextureSegment(C,ImageX,ImageY,UpRegion.W * RegionScale,UpRegion.H * RegionScale,UpRegion.X,UpRegion.Y,UpRegion.W,UpRegion.H,UpTexture);
				}
			}
		}
	}
	if ( m_bDrawSimpleBorder )
	{
		DrawSimpleBorder(C);
	}
}

function ForceMouseOver (bool _bForceMouseOver)
{
	m_bForceMouseOver=_bForceMouseOver;
}

defaultproperties
{
    m_fAlpha=128.00
    ImageX=1.00
    ImageY=1.00
}
/*
    m_HighLightTexture=Texture'R6TextureMenuEquipment.Highlight_gearroom'
*/

