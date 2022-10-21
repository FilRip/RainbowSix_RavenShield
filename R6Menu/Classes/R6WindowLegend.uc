//================================================================================
// R6WindowLegend.
//================================================================================
class R6WindowLegend extends R6MenuFramePopup;

var int m_iCurrentPage;
var int m_NavButtonSize;
var bool m_bDisplayWindow;
var bool m_bInitialized;
var R6MenuLegendPage m_LegendPages[5];
var UWindowButton m_PreviousPageButton;
var UWindowButton m_NextPageButton;
var R6WindowBitMap m_PrevBg;
var R6WindowBitMap m_NextBg;
var Region ButtonBg;

function Created ()
{
	local Texture ButtonTexture;

	Super.Created();
	ButtonTexture=R6WindowLookAndFeel(LookAndFeel).m_R6ScrollTexture;
	ToolTipString=Localize("PlanningLegend","MainTip","R6Menu");
	m_PreviousPageButton=R6LegendPreviousPageButton(CreateWindow(Class'R6LegendPreviousPageButton',m_iFrameWidth + 4,m_iFrameWidth + 4,m_NavButtonSize,m_NavButtonSize,self));
	m_NextPageButton=R6LegendNextPageButton(CreateWindow(Class'R6LegendNextPageButton',m_iFrameWidth + 4,m_iFrameWidth + 4,m_NavButtonSize,m_NavButtonSize,self));
	m_PrevBg=R6WindowBitMap(CreateWindow(Class'R6WindowBitMap',m_iFrameWidth + 2,m_iFrameWidth + 2,ButtonBg.W,ButtonBg.H,self));
	m_PrevBg.bAlwaysBehind=True;
	m_PrevBg.m_bUseColor=True;
	m_PrevBg.m_iDrawStyle=5;
	m_PrevBg.t=ButtonTexture;
	m_PrevBg.R=ButtonBg;
	m_PrevBg.SendToBack();
	m_NextBg=R6WindowBitMap(CreateWindow(Class'R6WindowBitMap',m_iFrameWidth + 2,m_iFrameWidth + 2,ButtonBg.W,ButtonBg.H,self));
	m_NextBg.bAlwaysBehind=True;
	m_NextBg.m_bUseColor=True;
	m_NextBg.m_iDrawStyle=5;
	m_NextBg.t=ButtonTexture;
	m_NextBg.R=ButtonBg;
	m_NextBg.SendToBack();
	m_LegendPages[0]=R6MenuLegendPageObject(CreateWindow(Class'R6MenuLegendPageObject',m_iFrameWidth,m_fTitleBarHeight,100.00,100.00,self));
	m_LegendPages[1]=R6MenuLegendPageInteractive(CreateWindow(Class'R6MenuLegendPageInteractive',m_iFrameWidth,m_fTitleBarHeight,100.00,100.00,self));
	m_LegendPages[1].HideWindow();
	m_LegendPages[2]=R6MenuLegendPageROE(CreateWindow(Class'R6MenuLegendPageROE',m_iFrameWidth,m_fTitleBarHeight,100.00,100.00,self));
	m_LegendPages[2].HideWindow();
	m_LegendPages[3]=R6MenuLegendPageWPDesc(CreateWindow(Class'R6MenuLegendPageWPDesc',m_iFrameWidth,m_fTitleBarHeight,100.00,100.00,self));
	m_LegendPages[3].HideWindow();
	m_LegendPages[4]=R6MenuLegendPageActions(CreateWindow(Class'R6MenuLegendPageActions',m_iFrameWidth,m_fTitleBarHeight,100.00,100.00,self));
	m_LegendPages[4].HideWindow();
	m_ButtonList=m_LegendPages[0];
	m_szWindowTitle=m_LegendPages[0].m_szPageTitle;
}

function BeforePaint (Canvas C, float X, float Y)
{
	local int iTeamColor;

	if ( m_bInitialized == False )
	{
		m_bInitialized=True;
		m_LegendPages[0].BeforePaint(C,X,Y);
		m_LegendPages[1].BeforePaint(C,X,Y);
		m_LegendPages[2].BeforePaint(C,X,Y);
		m_LegendPages[3].BeforePaint(C,X,Y);
		m_LegendPages[4].BeforePaint(C,X,Y);
		Resized();
		m_fTitleOffSet=(WinWidth - R6MenuLegendPage(m_ButtonList).m_fTitleWidth) * 0.50;
		m_NextBg.WinLeft=WinWidth - m_iFrameWidth - m_NavButtonSize - 2;
		m_NextPageButton.WinLeft=m_NextBg.WinLeft + 2;
	}
	iTeamColor=R6PlanningCtrl(GetPlayerOwner()).m_iCurrentTeam;
	m_PrevBg.m_TextureColor=Root.Colors.TeamColor[iTeamColor];
	m_NextBg.m_TextureColor=Root.Colors.TeamColor[iTeamColor];
}

function Resized ()
{
	local float fHeight;
	local float fWidth;
	local float fBiggestButtonList;

	fBiggestButtonList=m_LegendPages[0].WinWidth;
	if ( fBiggestButtonList < m_LegendPages[1].WinWidth )
	{
		fBiggestButtonList=m_LegendPages[1].WinWidth;
	}
	if ( fBiggestButtonList < m_LegendPages[2].WinWidth )
	{
		fBiggestButtonList=m_LegendPages[2].WinWidth;
	}
	if ( fBiggestButtonList < m_LegendPages[3].WinWidth )
	{
		fBiggestButtonList=m_LegendPages[3].WinWidth;
	}
	if ( fBiggestButtonList < m_LegendPages[4].WinWidth )
	{
		fBiggestButtonList=m_LegendPages[4].WinWidth;
	}
	fWidth=fBiggestButtonList + m_iFrameWidth * 2;
	fHeight=m_ButtonList.WinHeight + m_fTitleBarHeight + m_iFrameWidth * 2;
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
		if ( m_bDisplayUp == True )
		{
			WinTop += WinHeight - fHeight;
		}
		WinHeight=fHeight;
	}
}

function NextPage ()
{
	m_iCurrentPage++;
	if ( m_iCurrentPage == 5 )
	{
		m_iCurrentPage=0;
	}
	m_ButtonList.HideWindow();
	m_ButtonList=m_LegendPages[m_iCurrentPage];
	m_ButtonList.ShowWindow();
	m_szWindowTitle=m_LegendPages[m_iCurrentPage].m_szPageTitle;
	m_fTitleOffSet=(WinWidth - m_LegendPages[m_iCurrentPage].m_fTitleWidth) * 0.50;
}

function PreviousPage ()
{
	m_iCurrentPage--;
	if ( m_iCurrentPage < 0 )
	{
		m_iCurrentPage=4;
	}
	m_ButtonList.HideWindow();
	m_ButtonList=m_LegendPages[m_iCurrentPage];
	m_ButtonList.ShowWindow();
	m_szWindowTitle=m_LegendPages[m_iCurrentPage].m_szPageTitle;
	m_fTitleOffSet=(WinWidth - m_LegendPages[m_iCurrentPage].m_fTitleWidth) * 0.50;
}

function ToggleLegend ()
{
	m_bDisplayWindow= !m_bDisplayWindow;
	if ( m_bDisplayWindow == True )
	{
		ShowWindow();
	}
	else
	{
		HideWindow();
	}
}

function CloseLegendWindow ()
{
	m_bDisplayWindow=False;
	HideWindow();
}

defaultproperties
{
    m_NavButtonSize=16
    ButtonBg=(X=15737350,Y=570753024,W=36,H=1057284)
    m_iNbButton=6
    m_bDisplayLeft=True
    m_fTitleBarHeight=22.00
}