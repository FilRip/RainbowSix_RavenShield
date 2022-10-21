//================================================================================
// R6WindowServerListBox.
//================================================================================
class R6WindowServerListBox extends R6WindowListBox;

var ERenderStyle m_BGRenderStyle;
var int m_iPingTimeOut;
var bool m_bDrawBorderAndBkg;
var Texture m_BGSelTexture;
var Font m_Font;
var Color m_BGSelColor;
var Region m_BGSelRegion;
var Color m_SelTextColor;

function Created ()
{
	Super.Created();
	m_VertSB.SetHideWhenDisable(True);
	TextColor=Root.Colors.m_LisBoxNormalTextColor;
	m_SelTextColor=Root.Colors.m_LisBoxSelectedTextColor;
	m_BGSelColor=Root.Colors.m_LisBoxSelectionColor;
//	m_BGRenderStyle=5;
}

function BeforePaint (Canvas C, float fMouseX, float fMouseY)
{
	m_VertSB.SetBorderColor(m_BorderColor);
	Super.BeforePaint(C,fMouseX,fMouseY);
}

function Paint (Canvas C, float fMouseX, float fMouseY)
{
	if ( m_bDrawBorderAndBkg )
	{
		R6WindowLookAndFeel(LookAndFeel).R6List_DrawBackground(self,C);
	}
	Super.Paint(C,fMouseX,fMouseY);
}

function DrawItem (Canvas C, UWindowList Item, float X, float Y, float W, float H)
{
/*	local R6WindowListServerItem pSItem;
	local float TextY;
	local float fYPos;
	local float fTemp;
	local float tW;
	local float tH;
	local string szTemp;

	pSItem=R6WindowListServerItem(Item);
	if ( pSItem.bSelected )
	{
		if ( m_BGSelTexture != None )
		{
			C.Style=m_BGRenderStyle;
			C.SetDrawColor(m_BGSelColor.R,m_BGSelColor.G,m_BGSelColor.B);
			DrawStretchedTextureSegment(C,X,Y,W,H,m_BGSelRegion.X,m_BGSelRegion.Y,m_BGSelRegion.W,m_BGSelRegion.H,m_BGSelTexture);
		}
		C.SetDrawColor(m_SelTextColor.R,m_SelTextColor.G,m_SelTextColor.B);
	}
	else
	{
		C.SetDrawColor(TextColor.R,TextColor.G,TextColor.B);
	}
	C.Font=m_Font;
	C.Style=5;
	if (  !pSItem.bSameVersion )
	{
		C.SetDrawColor(Root.Colors.GrayLight.R,Root.Colors.GrayLight.G,Root.Colors.GrayLight.B);
	}
	TextSize(C,"A",tW,tH);
	TextY=(H - tH) / 2;
	TextY=TextY + 0.50;
	fYPos=Y + TextY;
	if ( pSItem.bFavorite )
	{
		DrawIcon(C,pSItem.0,pSItem.m_stServerItemPos[pSItem.0].fXPos,fYPos,pSItem.m_stServerItemPos[pSItem.0].fWidth,tH);
	}
	if ( pSItem.bLocked )
	{
		DrawIcon(C,pSItem.1,pSItem.m_stServerItemPos[pSItem.1].fXPos,fYPos,pSItem.m_stServerItemPos[pSItem.1].fWidth,tH);
	}
	if ( pSItem.bDedicated )
	{
		DrawIcon(C,pSItem.2,pSItem.m_stServerItemPos[pSItem.2].fXPos,fYPos,pSItem.m_stServerItemPos[pSItem.2].fWidth,tH);
	}
	if ( pSItem.m_bNewItem )
	{
		pSItem.szName=TextSize(C,pSItem.szName,tW,tH,pSItem.m_stServerItemPos[pSItem.3].fWidth);
	}
	C.SetPos(pSItem.m_stServerItemPos[pSItem.3].fXPos + 2,fYPos);
	C.DrawText(pSItem.szName);
	if ( pSItem.iPing < m_iPingTimeOut )
	{
		szTemp=string(pSItem.iPing);
	}
	else
	{
		szTemp="-";
	}
	TextSize(C,szTemp,tW,tH);
	fTemp=pSItem.m_stServerItemPos[pSItem.4].fXPos + GetCenterXPos(pSItem.m_stServerItemPos[pSItem.4].fWidth,tW);
	C.SetPos(fTemp,fYPos);
	C.DrawText(szTemp);
	pSItem.szGameType=TextSize(C,pSItem.szGameType,tW,tH,pSItem.m_stServerItemPos[pSItem.5].fWidth);
	fTemp=pSItem.m_stServerItemPos[pSItem.5].fXPos + GetCenterXPos(pSItem.m_stServerItemPos[pSItem.5].fWidth,tW);
	C.SetPos(fTemp,fYPos);
	C.DrawText(pSItem.szGameType);
	pSItem.szGameMode=TextSize(C,pSItem.szGameMode,tW,tH,pSItem.m_stServerItemPos[pSItem.6].fWidth);
	fTemp=pSItem.m_stServerItemPos[pSItem.6].fXPos + GetCenterXPos(pSItem.m_stServerItemPos[pSItem.6].fWidth,tW);
	C.SetPos(fTemp,fYPos);
	C.DrawText(pSItem.szGameMode);
	pSItem.szMap=TextSize(C,pSItem.szMap,tW,tH,pSItem.m_stServerItemPos[pSItem.7].fWidth);
	fTemp=pSItem.m_stServerItemPos[pSItem.7].fXPos + GetCenterXPos(pSItem.m_stServerItemPos[pSItem.7].fWidth,tW);
	C.SetPos(fTemp,fYPos);
	C.DrawText(pSItem.szMap);
	if ( (pSItem.iMaxPlayers > 0) && (pSItem.iNumPlayers >= 0) )
	{
		szTemp=string(pSItem.iNumPlayers) $ "/" $ string(pSItem.iMaxPlayers);
		TextSize(C,szTemp,tW,tH);
		fTemp=pSItem.m_stServerItemPos[pSItem.8].fXPos + GetCenterXPos(pSItem.m_stServerItemPos[pSItem.8].fWidth,tW);
		C.SetPos(fTemp,fYPos);
		C.DrawText(szTemp);
	}
	pSItem.m_bNewItem=False;*/
}

function DrawIcon (Canvas C, int _iPlayerStats, float _fX, float _fY, float _fWidth, float _fHeight)
{
	local Region RIconRegion;
	local Region RIconToDraw;

	switch (_iPlayerStats)
	{
		case 0:
		RIconToDraw.X=0;
		RIconToDraw.Y=42;
		RIconToDraw.W=13;
		RIconToDraw.H=11;
		break;
		case 1:
		RIconToDraw.X=13;
		RIconToDraw.Y=42;
		RIconToDraw.W=13;
		RIconToDraw.H=11;
		break;
		case 2:
		RIconToDraw.X=0;
		RIconToDraw.Y=53;
		RIconToDraw.W=13;
		RIconToDraw.H=11;
		break;
		default:
		Log("R6WindowServerListBox DrawIcon() --> This icon " @ string(_iPlayerStats) @ "don't exist");
		break;
	}
	RIconRegion=CenterIconInBox(_fX,_fY,_fWidth,_fHeight,RIconToDraw);
	DrawStretchedTextureSegment(C,RIconRegion.X,RIconRegion.Y,RIconToDraw.W,RIconToDraw.H,RIconToDraw.X,RIconToDraw.Y,RIconToDraw.W,RIconToDraw.H,m_TIcon);
}

function RMouseDown (float X, float Y)
{
	Super.RMouseDown(X,Y);
	if ( GetItemAt(X,Y) != None )
	{
		SetSelected(X,Y);
		Notify(6);
	}
}

function SetSelectedItem (UWindowListBoxItem NewSelected)
{
	if ( (NewSelected != None) && (m_SelectedItem != NewSelected) )
	{
		if ( m_SelectedItem != None )
		{
			m_SelectedItem.bSelected=False;
		}
		m_SelectedItem=NewSelected;
		if ( m_SelectedItem != None )
		{
			m_SelectedItem.bSelected=True;
		}
	}
}

defaultproperties
{
    m_iPingTimeOut=1000
    m_BGSelColor=(R=128,G=0,B=0,A=0)
    m_BGSelRegion=(X=16589323,Y=571015168,W=2,H=860680)
    m_SelTextColor=(R=255,G=255,B=255,A=0)
    m_fItemHeight=14.00
    ListClass=Class'R6WindowListServerItem'
}
/*
    m_BGSelTexture=Texture'R6MenuTextures.Gui_BoxScroll'
*/

