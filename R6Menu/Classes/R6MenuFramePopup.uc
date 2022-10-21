//================================================================================
// R6MenuFramePopup.
//================================================================================
class R6MenuFramePopup extends R6WindowFramedWindow;

var const int m_iNbButton;
var int m_iTeamColor;
var int m_iFrameWidth;
var int m_iTextureSize;
var bool m_bDisplayUp;
var bool m_bDisplayLeft;
var bool m_bInitialized;
var float m_fTitleBarHeight;
var float m_fTitleBarWidth;
var R6WindowListRadioButton m_ButtonList;
var Texture m_Texture;

function BeforePaint (Canvas C, float X, float Y)
{
	if ( m_bInitialized == False )
	{
		m_bInitialized=True;
		Super.BeforePaint(C,X,Y);
		C.Font=Root.Fonts[8];
		TextSize(C,m_szWindowTitle,m_fTitleBarWidth,m_fTitleBarHeight);
		m_fTitleBarHeight += 6.00;
		m_fTitleBarWidth += 12.00;
	}
}

function Paint (Canvas C, float X, float Y)
{
	local Region R;
	local Region temp;
	local Color iColor;

	m_iTeamColor=R6PlanningCtrl(GetPlayerOwner()).m_iCurrentTeam;
	if ( m_szWindowTitle != "" )
	{
		iColor=Root.Colors.TeamColor[m_iTeamColor];
		C.Style=5;
		C.SetDrawColor(iColor.R,iColor.G,iColor.B,Root.Colors.PopUpAlphaFactor);
		DrawStretchedTextureSegment(C,m_iTextureSize,m_iTextureSize,WinWidth - m_iTextureSize - m_iTextureSize,m_fTitleBarHeight - m_iTextureSize,0.00,0.00,m_iTextureSize,m_iTextureSize,m_Texture);
		C.Style=5;
		iColor=Root.Colors.TeamColorDark[m_iTeamColor];
		C.SetDrawColor(iColor.R,iColor.G,iColor.B,Root.Colors.PopUpAlphaFactor);
		DrawStretchedTextureSegment(C,m_iTextureSize,m_fTitleBarHeight,WinWidth - m_iTextureSize - m_iTextureSize,WinHeight - m_fTitleBarHeight - m_iTextureSize,0.00,0.00,m_iTextureSize,m_iTextureSize,m_Texture);
	}
	else
	{
		C.Style=5;
		iColor=Root.Colors.TeamColorDark[m_iTeamColor];
		C.SetDrawColor(iColor.R,iColor.G,iColor.B,Root.Colors.PopUpAlphaFactor);
		DrawStretchedTextureSegment(C,m_iTextureSize,m_iTextureSize,WinWidth - m_iTextureSize - m_iTextureSize,WinHeight - m_iTextureSize - m_iTextureSize,0.00,0.00,m_iTextureSize,m_iTextureSize,m_Texture);
	}
	iColor=Root.Colors.TeamColor[m_iTeamColor];
	C.SetDrawColor(iColor.R,iColor.G,iColor.B);
	DrawStretchedTextureSegment(C,0.00,0.00,WinWidth,m_iTextureSize,0.00,0.00,m_iTextureSize,m_iTextureSize,m_Texture);
	if ( m_szWindowTitle != "" )
	{
		DrawStretchedTextureSegment(C,0.00,m_fTitleBarHeight - 1,WinWidth,m_iTextureSize,0.00,0.00,m_iTextureSize,m_iTextureSize,m_Texture);
	}
	DrawStretchedTextureSegment(C,0.00,m_iTextureSize,m_iTextureSize,WinHeight - m_iTextureSize - m_iTextureSize,0.00,0.00,m_iTextureSize,m_iTextureSize,m_Texture);
	DrawStretchedTextureSegment(C,WinWidth - m_iTextureSize,m_iTextureSize,m_iTextureSize,WinHeight - m_iTextureSize - m_iTextureSize,0.00,0.00,m_iTextureSize,m_iTextureSize,m_Texture);
	DrawStretchedTextureSegment(C,0.00,WinHeight - m_iTextureSize,WinWidth,m_iTextureSize,0.00,0.00,m_iTextureSize,m_iTextureSize,m_Texture);
	C.Style=5;
	C.Font=Root.Fonts[8];
	iColor=Root.Colors.White;
	C.SetDrawColor(iColor.R,iColor.G,iColor.B);
	ClipTextWidth(C,m_fTitleOffSet,3.00,m_szWindowTitle,WinWidth);
}

function Resized ()
{
	local float fHeight;
	local float fWidth;

	if ( m_fTitleBarWidth > m_ButtonList.WinWidth )
	{
		fWidth=m_fTitleBarWidth + m_iFrameWidth * 2;
		m_ButtonList.WinWidth=m_fTitleBarWidth;
		m_ButtonList.ChangeItemsSize(m_fTitleBarWidth);
	}
	else
	{
		fWidth=m_ButtonList.WinWidth + m_iFrameWidth * 2;
	}
	fHeight=m_ButtonList.WinHeight + m_fTitleBarHeight + m_iFrameWidth;
	if ( (fWidth != WinWidth) || (fHeight != WinHeight) )
	{
		m_ButtonList.WinTop=m_fTitleBarHeight;
		m_ButtonList.WinLeft=m_iFrameWidth;
		Super.Resized();
		if ( m_bDisplayLeft == True )
		{
			WinLeft += WinWidth - fWidth;
		}
		WinWidth=fWidth;
		m_fTitleOffSet=(WinWidth - m_fTitleBarWidth) / 2 + 6;
		if ( m_bDisplayUp == True )
		{
			WinTop += WinHeight - fHeight;
		}
		WinHeight=fHeight;
	}
}

function ShowWindow ()
{
	Super.ShowWindow();
	m_ButtonList.ShowWindow();
}

function AjustPosition (bool bDisplayUp, bool bDisplayLeft)
{
	m_bDisplayUp=bDisplayUp;
	m_bDisplayLeft=bDisplayLeft;
	if ( m_bDisplayLeft == True )
	{
		WinLeft -= WinWidth;
	}
	if ( m_bDisplayUp == True )
	{
		WinTop -= WinHeight;
	}
}

defaultproperties
{
    m_iFrameWidth=1
    m_iTextureSize=1
    m_fTitleBarHeight=17.00
    m_TitleAlign=2
    m_bDisplayClose=False
}
/*
    m_Texture=Texture'Color.Color.White'
*/

