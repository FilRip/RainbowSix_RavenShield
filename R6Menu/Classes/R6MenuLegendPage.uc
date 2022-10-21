//================================================================================
// R6MenuLegendPage.
//================================================================================
class R6MenuLegendPage extends R6MenuPopupListButton;
//	Localized;

var int m_iTextureSize;
var int m_iSpaceBetweenTextureNText;
var int m_iSpaceEnd;
var float m_fTitleWidth;
var localized string m_szPageTitle;

function Created ()
{
	Super.Created();
	m_fItemHeight=m_iTextureSize;
}

function BeforePaint (Canvas C, float MouseX, float MouseY)
{
	local int i;
	local int iCurrentNbButton;
	local float fTitleHeight;
	local float fWidth;
	local float fHeight;
	local float fMaxWidth;

	if ( bInitialized == False )
	{
		bInitialized=True;
		C.Font=Root.Fonts[12];
		i=0;
JL003B:
		if ( i < m_iNbButton )
		{
			if ( (m_ButtonItem[i] != None) && (m_ButtonItem[i].m_Button != None) )
			{
				TextSize(C,m_ButtonItem[i].m_Button.Text,fWidth,fHeight);
				fWidth += m_iSpaceEnd;
				if ( fWidth > fMaxWidth )
				{
					fMaxWidth=fWidth;
				}
			}
			i++;
			goto JL003B;
		}
		WinWidth=fMaxWidth + m_iTextureSize + m_iSpaceBetweenTextureNText;
		if ( m_szPageTitle != "" )
		{
			C.Font=Root.Fonts[8];
			TextSize(C,m_szPageTitle,m_fTitleWidth,fTitleHeight);
			fMaxWidth=m_fTitleWidth + 12.00 + R6WindowLegend(ParentWindow).m_NavButtonSize * 2;
		}
		if ( WinWidth < fMaxWidth )
		{
			WinWidth=fMaxWidth;
		}
		m_fItemHeight=m_iTextureSize;
		iCurrentNbButton=0;
		i=0;
JL01A2:
		if ( i < m_iNbButton )
		{
			if ( (m_ButtonItem[i] != None) && (m_ButtonItem[i].m_Button != None) )
			{
				m_ButtonItem[i].m_Button.TextColor=Root.Colors.White;
				m_ButtonItem[i].m_Button.WinWidth=WinWidth;
				m_ButtonItem[i].m_Button.WinHeight=m_fItemHeight;
				iCurrentNbButton++;
			}
			i++;
			goto JL01A2;
		}
		WinHeight=m_fItemHeight * iCurrentNbButton + iCurrentNbButton - 1;
		ParentWindow.Resized();
	}
}

function Paint (Canvas C, float MouseX, float MouseY)
{
	local float X;
	local float Y;
	local UWindowList CurItem;
	local Color lcolor;

	C.SetDrawColor(255,255,255);
	if ( m_fItemWidth == 0 )
	{
		m_fItemWidth=WinWidth;
	}
	X=(WinWidth - m_fItemWidth) / 2;
//	C.Style=GetPlayerOwner().5;
	CurItem=Items.Next;
JL0077:
	if ( CurItem != None )
	{
		R6WindowListButtonItem(CurItem).m_Button.ShowWindow();
		DrawItem(C,CurItem,X,Y,m_fItemWidth,m_fItemHeight);
		Y += m_fItemHeight;
		if ( Y < WinHeight )
		{
			lcolor=Root.Colors.TeamColorLight[R6PlanningCtrl(GetPlayerOwner()).m_iCurrentTeam];
			C.SetDrawColor(lcolor.R,lcolor.G,lcolor.B,Root.Colors.PopUpAlphaFactor);
			DrawStretchedTextureSegment(C,X,Y,m_SeperatorLineRegion.W + m_iTextureSize,m_SeperatorLineRegion.H,m_SeperatorLineRegion.X,m_SeperatorLineRegion.Y,m_SeperatorLineRegion.W,m_SeperatorLineRegion.H,m_SeperatorLineTexture);
			Y += m_SeperatorLineRegion.H;
			C.SetDrawColor(255,255,255);
		}
		CurItem=CurItem.Next;
		goto JL0077;
	}
}

function DrawItem (Canvas C, UWindowList Item, float X, float Y, float W, float H)
{
	local R6MenuLegendItem pR6MenuLegendItem;
	local R6WindowListButtonItem pListButtonItem;

	pR6MenuLegendItem=R6MenuLegendItem(Item);
	pListButtonItem=R6WindowListButtonItem(Item);
	if ( pR6MenuLegendItem.m_pObjectIcon != None )
	{
		if ( pR6MenuLegendItem.m_bOtherTextureHeight == True )
		{
			DrawStretchedTextureSegment(C,X,Y,m_iTextureSize,m_iTextureSize,0.00,0.00,128.00,148.00,R6MenuLegendItem(Item).m_pObjectIcon);
		}
		else
		{
			DrawStretchedTexture(C,X,Y,m_iTextureSize,m_iTextureSize,R6MenuLegendItem(Item).m_pObjectIcon);
		}
	}
	if ( pListButtonItem.m_Button != None )
	{
		pListButtonItem.m_Button.WinLeft=X + m_iTextureSize + m_iSpaceBetweenTextureNText;
		pListButtonItem.m_Button.WinTop=Y;
		pListButtonItem.m_Button.WinHeight=H;
	}
}

defaultproperties
{
    m_iTextureSize=32
    m_iSpaceBetweenTextureNText=2
    m_iSpaceEnd=12
    m_iNbButton=6
    ListClass=Class'R6MenuLegendItem'
}
