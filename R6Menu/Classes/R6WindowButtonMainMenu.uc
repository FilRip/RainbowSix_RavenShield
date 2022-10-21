//================================================================================
// R6WindowButtonMainMenu.
//================================================================================
class R6WindowButtonMainMenu extends UWindowButton;

enum eButtonActionType {
	Button_SinglePlayer,
	Button_CustomMission,
	Button_Multiplayer,
	Button_Training,
	Button_Options,
	Button_Replays,
	Button_Credits,
	Button_Quit,
	Button_UbiComQuit,
	Button_UbiComReturn
};

var eButtonActionType m_eButton_Action;
var int m_iTextRightPadding;
var int m_iMinXPos;
var int m_iMaxXPos;
var int m_iTotalScroll;
var bool m_bResizeToText;
var float m_fProgressTime;
var float m_TextWidth;
var float m_fLMarge;
var float m_fFontSpacing;
var Texture m_OverAlphaTexture;
var Texture m_OverScrollingTexture;
var Font m_buttonFont;
var Region m_OverAlphaRegion;
var Region m_OverScrollingRegion;
var Color m_DownTextColor;

function Created ()
{
	Super.Created();
	m_OverTextColor=Root.Colors.White;
	TextColor=Root.Colors.White;
	m_DownTextColor=Root.Colors.BlueLight;
}

function BeforePaint (Canvas C, float X, float Y)
{
	local float W;
	local float H;
	local float ftextSize;

	if ( m_buttonFont != None )
	{
		C.Font=m_buttonFont;
	}
	else
	{
		C.Font=Root.Fonts[Font];
	}
	TextSize(C,Text,W,H);
	switch (Align)
	{
		case TA_Left:
		TextX=m_fLMarge;
		break;
		case TA_Right:
		TextX=WinWidth - W - Len(Text) * m_fFontSpacing;
		break;
		case TA_Center:
		TextX=(WinWidth - W - Len(Text) * m_fFontSpacing) / 2;
		break;
		default:
	}
	TextY=(WinHeight - H) / 2;
	TextY=TextY + 0.50;
	if ( m_bResizeToText )
	{
		ftextSize=W + Len(Text) * m_fFontSpacing;
		WinWidth=ftextSize + m_fLMarge + m_iTextRightPadding;
		if ( Align != 0 )
		{
			WinLeft += TextX - m_fLMarge;
		}
		TextX=m_fLMarge;
		Align=TA_Left;
		m_bResizeToText=False;
	}
}

function Paint (Canvas C, float X, float Y)
{
	local float tH;
	local int currentTextStyle;

	C.Font=Root.Fonts[Font];
	TextSize(C,Text,m_TextWidth,tH);
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
		DrawButtonText(C,m_DisabledTextColor,3);
	}
	else
	{
		if ( bMouseDown )
		{
			DrawButtonBackGround(C,Root.Colors.Blue,3);
			DrawButtonScrollEffect(C,Root.Colors.BlueLight,3);
			DrawButtonText(C,m_DownTextColor,1);
		}
		else
		{
			if ( MouseIsOver() )
			{
				DrawButtonBackGround(C,Root.Colors.Blue,3);
				DrawButtonScrollEffect(C,Root.Colors.BlueLight,3);
				DrawButtonText(C,m_OverTextColor,1);
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
				DrawButtonText(C,TextColor,1);
			}
		}
	}
}

function DrawButtonText (Canvas C, Color currentTextColor, int currentStyle)
{
	if ( Text != "" )
	{
		if ( m_buttonFont != None )
		{
			C.Font=m_buttonFont;
		}
		else
		{
			C.Font=Root.Fonts[Font];
		}
		C.SpaceX=0.00;
		C.SetDrawColor(currentTextColor.R,currentTextColor.G,currentTextColor.B);
		C.Style=currentStyle;
		ClipText(C,TextX,TextY,Text,True);
	}
}

function DrawButtonBackGround (Canvas C, Color currentDrawColor, int currentStyle)
{
	C.Style=currentStyle;
	C.SetDrawColor(currentDrawColor.R,currentDrawColor.G,currentDrawColor.B);
	if ( m_OverAlphaTexture != None )
	{
		DrawStretchedTextureSegment(C,0.00,ImageY,m_OverAlphaRegion.W,m_OverAlphaRegion.H,m_OverAlphaRegion.X,m_OverAlphaRegion.Y,m_OverAlphaRegion.W,m_OverAlphaRegion.H,m_OverAlphaTexture);
	}
	if ( OverTexture != None )
	{
		DrawStretchedTextureSegment(C,m_OverAlphaRegion.W,ImageY,WinWidth - 2 * m_OverAlphaRegion.W,OverRegion.H,OverRegion.X,OverRegion.Y,OverRegion.W,OverRegion.H,OverTexture);
	}
	if ( m_OverAlphaTexture != None )
	{
		DrawStretchedTextureSegment(C,WinWidth - m_OverAlphaRegion.W,ImageY,m_OverAlphaRegion.W,m_OverAlphaRegion.H,m_OverAlphaRegion.X + m_OverAlphaRegion.W,m_OverAlphaRegion.Y, -m_OverAlphaRegion.W,m_OverAlphaRegion.H,m_OverAlphaTexture);
	}
}

function DrawButtonScrollEffect (Canvas C, Color currentDrawColor, int currentStyle)
{
	local int targetPos;
	local int lastDisplayedPos;
	local int iDisplayXPos;
	local int iWidthModifier;
	local R6MenuRSLookAndFeel currentLookAndFeel;

	m_iMinXPos=TextX - m_OverScrollingRegion.W / 2;
	m_iMaxXPos=WinWidth - m_iTextRightPadding - m_OverScrollingRegion.W / 2;
	m_iTotalScroll=m_iMaxXPos - m_iMinXPos;
	currentLookAndFeel=R6MenuRSLookAndFeel(LookAndFeel);
	if ( currentLookAndFeel != None )
	{
		m_fProgressTime=FClamp(m_fProgressTime,0.00,m_iTotalScroll / currentLookAndFeel.m_fScrollRate);
		if ( (m_fProgressTime == 0.00) || (m_fProgressTime == m_iTotalScroll / currentLookAndFeel.m_fScrollRate) )
		{
			currentLookAndFeel.m_iMultiplyer *= -1;
		}
		targetPos=m_fProgressTime * currentLookAndFeel.m_fScrollRate;
		iDisplayXPos=Clamp(m_iMinXPos + targetPos,TextX - m_iTextRightPadding,m_iMaxXPos);
		iWidthModifier=0;
		if ( m_iMinXPos + targetPos < TextX - m_iTextRightPadding )
		{
			iWidthModifier=TextX - m_iTextRightPadding - m_iMinXPos - targetPos;
		}
		currentLookAndFeel.m_fCurrentPct=targetPos / m_iTotalScroll;
		C.Style=currentStyle;
		C.SetDrawColor(currentDrawColor.R,currentDrawColor.G,currentDrawColor.B);
		DrawStretchedTextureSegment(C,iDisplayXPos,ImageY,m_OverScrollingRegion.W - iWidthModifier,m_OverScrollingRegion.H * RegionScale,m_OverScrollingRegion.X + iWidthModifier,m_OverScrollingRegion.Y,m_OverScrollingRegion.W - iWidthModifier,m_OverScrollingRegion.H,m_OverScrollingTexture);
	}
}

function ResizeToText ()
{
	m_bResizeToText=True;
}

function Tick (float DeltaTime)
{
	Super.Tick(DeltaTime);
	if ( MouseIsOver() || bMouseDown )
	{
		m_fProgressTime += DeltaTime * R6MenuRSLookAndFeel(LookAndFeel).m_iMultiplyer;
	}
	else
	{
		m_fProgressTime=R6MenuRSLookAndFeel(LookAndFeel).m_fCurrentPct * m_iTotalScroll / R6MenuRSLookAndFeel(LookAndFeel).m_fScrollRate;
	}
}

simulated function Click (float X, float Y)
{
	local R6MenuRootWindow r6Root;

	if ( bDisabled )
	{
		return;
	}
	Super.Click(X,Y);
	r6Root=R6MenuRootWindow(Root);
	switch (m_eButton_Action)
	{
/*		case 0:
//		r6Root.ChangeCurrentWidget(5);
		break;
		case 1:
//		r6Root.ChangeCurrentWidget(14);
		break;
		case 2:
//		r6Root.ChangeCurrentWidget(15);
		break;
		case 3:
//		r6Root.ChangeCurrentWidget(4);
		break;
		case 4:
//		r6Root.ChangeCurrentWidget(16);
		break;
		case 6:
//		r6Root.ChangeCurrentWidget(18);
		break;
		case 7:
//		Root.ChangeCurrentWidget(37);
		break;
		default:
		break;*/
	}
}

defaultproperties
{
    m_iTextRightPadding=4
    m_fLMarge=4.00
    m_OverAlphaRegion=(X=6169094,Y=570687488,W=31,H=1647107)
    m_OverScrollingRegion=(X=5710340,Y=570621952,W=25,H=0)
    bUseRegion=True
    ImageY=5.00
    OverRegion=(X=5841414,Y=570687488,W=2,H=1647107)
    Align=1
    Font=14
}
/*
    OverTexture=Texture'R6MenuTextures.MainMenuMouseOver'
    m_OverAlphaTexture=Texture'R6MenuTextures.MainMenuMouseOver'
    m_OverScrollingTexture=Texture'R6MenuTextures.MainMenuMouseOver'
*/

