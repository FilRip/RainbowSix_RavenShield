//================================================================================
// UWindowButton.
//================================================================================
class UWindowButton extends UWindowDialogControl;

var int m_iButtonID;
var bool bDisabled;
var bool bStretched;
var bool bUseRegion;
var bool m_bSelected;
var bool m_bDrawButtonBorders;
var bool m_bUseRotAngle;
var bool m_bPlayButtonSnd;
var bool m_bWaitSoundFinish;
var bool m_bSoundStart;
var float RegionScale;
var float ImageX;
var float ImageY;
var float m_fRotAngle;
var float m_fRotAngleWidth;
var float m_fRotAngleHeight;
var Texture UpTexture;
var Texture DownTexture;
var Texture DisabledTexture;
var Texture OverTexture;
var Sound OverSound;
var Sound DownSound;
var Region UpRegion;
var Region DownRegion;
var Region DisabledRegion;
var Region OverRegion;
var Color m_SelectedTextColor;
var Color m_DisabledTextColor;
var Color m_OverTextColor;

function Created ()
{
	Super.Created();
	TextColor=Root.Colors.ButtonTextColor[0];
	m_DisabledTextColor=Root.Colors.ButtonTextColor[1];
	m_OverTextColor=Root.Colors.ButtonTextColor[2];
	m_SelectedTextColor=Root.Colors.ButtonTextColor[3];
	m_fRotAngleWidth=WinWidth;
	m_fRotAngleHeight=WinHeight;
}

function BeforePaint (Canvas C, float X, float Y)
{
	C.Font=Root.Fonts[Font];
}

function Paint (Canvas C, float X, float Y)
{
	C.Font=Root.Fonts[Font];
	C.Style=5;
	if ( bDisabled )
	{
		if ( DisabledTexture != None )
		{
			if ( bUseRegion )
			{
				if ( m_bUseRotAngle )
				{
					DrawStretchedTextureSegmentRot(C,ImageX,ImageY,m_fRotAngleWidth,m_fRotAngleHeight,DisabledRegion.X,DisabledRegion.Y,DisabledRegion.W,DisabledRegion.H,DisabledTexture,m_fRotAngle);
				}
				else
				{
					DrawStretchedTextureSegment(C,ImageX,ImageY,Abs(DisabledRegion.W * RegionScale),Abs(DisabledRegion.H * RegionScale),DisabledRegion.X,DisabledRegion.Y,DisabledRegion.W,DisabledRegion.H,DisabledTexture);
				}
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
		if ( bMouseDown )
		{
			if ( DownTexture != None )
			{
				if ( bUseRegion )
				{
					if ( m_bUseRotAngle )
					{
						DrawStretchedTextureSegmentRot(C,ImageX,ImageY,m_fRotAngleWidth,m_fRotAngleHeight,DownRegion.X,DownRegion.Y,DownRegion.W,DownRegion.H,DownTexture,m_fRotAngle);
					}
					else
					{
						DrawStretchedTextureSegment(C,ImageX,ImageY,Abs(DownRegion.W * RegionScale),Abs(DownRegion.H * RegionScale),DownRegion.X,DownRegion.Y,DownRegion.W,DownRegion.H,DownTexture);
					}
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
		else
		{
			if ( MouseIsOver() )
			{
				if ( OverTexture != None )
				{
					if ( bUseRegion )
					{
						if ( m_bUseRotAngle )
						{
							DrawStretchedTextureSegmentRot(C,ImageX,ImageY,m_fRotAngleWidth,m_fRotAngleHeight,OverRegion.X,OverRegion.Y,OverRegion.W,OverRegion.H,OverTexture,m_fRotAngle);
						}
						else
						{
							DrawStretchedTextureSegment(C,ImageX,ImageY,Abs(OverRegion.W * RegionScale),Abs(OverRegion.H * RegionScale),OverRegion.X,OverRegion.Y,OverRegion.W,OverRegion.H,OverTexture);
						}
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
						if ( m_bUseRotAngle )
						{
							DrawStretchedTextureSegmentRot(C,ImageX,ImageY,m_fRotAngleWidth,m_fRotAngleHeight,UpRegion.X,UpRegion.Y,UpRegion.W,UpRegion.H,UpTexture,m_fRotAngle);
						}
						else
						{
							DrawStretchedTextureSegment(C,ImageX,ImageY,Abs(UpRegion.W * RegionScale),Abs(UpRegion.H * RegionScale),UpRegion.X,UpRegion.Y,UpRegion.W,UpRegion.H,UpTexture);
						}
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
	if ( m_bDrawButtonBorders )
	{
		DrawSimpleBorder(C);
	}
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

function AfterPaint (Canvas C, float X, float Y)
{
	if ( m_bSoundStart &&  !GetPlayerOwner().IsPlayingSound(GetPlayerOwner(),DownSound) )
	{
		Notify(2);
		m_bSoundStart=False;
	}
}

simulated function Click (float X, float Y)
{
	if ( bDisabled )
	{
		return;
	}
	if ( m_bPlayButtonSnd && (DownSound != None) )
	{
		GetPlayerOwner().PlaySound(DownSound,SLOT_Menu);
		if ( m_bWaitSoundFinish )
		{
			m_bSoundStart=True;
			return;
		}
	}
	Notify(2);
}

function DoubleClick (float X, float Y)
{
	if (  !bDisabled )
	{
		Notify(11);
	}
}

function RClick (float X, float Y)
{
	if (  !bDisabled )
	{
		Notify(6);
	}
}

function MClick (float X, float Y)
{
	if (  !bDisabled )
	{
		Notify(5);
	}
}

defaultproperties
{
    m_bPlayButtonSnd=True
    RegionScale=1.00
    m_fRotAngle=1.57
    DownSound=Sound'SFX_Menus.Play_Button_Selection'
    bIgnoreLDoubleClick=True
    bIgnoreMDoubleClick=True
    bIgnoreRDoubleClick=True
}