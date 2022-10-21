//================================================================================
// R6WindowIGPlayerInfoListBox.
//================================================================================
class R6WindowIGPlayerInfoListBox extends R6WindowListBox;

var ERenderStyle m_BGRenderStyle;
var int m_fYOffSet;
var Texture m_BGSelTexture;
var Font m_Font;
var Color m_BGSelColor;
var Region m_BGSelRegion;
var Color m_SelTextColor;
var Color m_SpectatorColor;

function Created ()
{
	Super.Created();
	m_Font=Root.Fonts[11];
	m_VertSB.LookAndFeel=LookAndFeel;
	m_VertSB.UpButton.LookAndFeel=LookAndFeel;
	m_VertSB.DownButton.LookAndFeel=LookAndFeel;
	m_VertSB.SetHideWhenDisable(True);
	TextColor=Root.Colors.m_LisBoxNormalTextColor;
	m_SelTextColor=Root.Colors.m_LisBoxSelectedTextColor;
	m_SpectatorColor=Root.Colors.m_LisBoxSpectatorTextColor;
	m_BGSelColor=Root.Colors.m_LisBoxSelectionColor;
//	m_BGRenderStyle=5;
}

function BeforePaint (Canvas C, float fMouseX, float fMouseY)
{
	m_VertSB.SetBorderColor(m_BorderColor);
	Super.BeforePaint(C,fMouseX,fMouseY);
}

function DrawItem (Canvas C, UWindowList Item, float X, float Y, float W, float H)
{
/*	local string szTemp;
	local float TextY;
	local float tW;
	local float tH;
	local float fTemp;
	local float fYPos;
	local R6WindowListIGPlayerInfoItem pItem;

	pItem=R6WindowListIGPlayerInfoItem(Item);
	if ( pItem.bOwnPlayer )
	{
		C.SetDrawColor(Root.Colors.BlueLight.R,Root.Colors.BlueLight.G,Root.Colors.BlueLight.B);
	}
	else
	{
		if ( pItem.eStatus == pItem.4 )
		{
			C.SetDrawColor(m_SpectatorColor.R,m_SpectatorColor.G,m_SpectatorColor.B);
		}
		else
		{
			C.SetDrawColor(TextColor.R,TextColor.G,TextColor.B);
		}
	}
	C.Style=5;
	C.Font=m_Font;
	szTemp=TextSize(C,pItem.szPlName,tW,tH,pItem.stTagCoord[pItem.2].fWidth - 2);
	TextY=(H - tH) / 2;
	TextY=TextY + 0.50;
	fYPos=Y + TextY + m_fYOffSet;
	if ( pItem.bReady )
	{
		DrawIcon(C,6,pItem.stTagCoord[pItem.0].fXPos,fYPos,pItem.stTagCoord[pItem.0].fWidth,H);
	}
	else
	{
		DrawIcon(C,5,pItem.stTagCoord[pItem.0].fXPos,fYPos,pItem.stTagCoord[pItem.0].fWidth,H);
	}
	if ( pItem.eStatus != pItem.5 )
	{
		DrawIcon(C,pItem.GetHealth(pItem.eStatus),pItem.stTagCoord[pItem.1].fXPos,fYPos,pItem.stTagCoord[pItem.1].fWidth,H);
	}
	C.SetPos(pItem.stTagCoord[pItem.2].fXPos + 2,fYPos);
	C.DrawText(szTemp);
	if ( pItem.stTagCoord[pItem.3].bDisplay )
	{
		szTemp=TextSize(C,pItem.szRoundsWon,tW,tH,pItem.stTagCoord[pItem.3].fWidth);
		fTemp=pItem.stTagCoord[pItem.3].fXPos + GetCenterXPos(pItem.stTagCoord[pItem.3].fWidth,tW);
		C.SetPos(fTemp,fYPos);
		C.DrawText(szTemp);
	}
	szTemp=TextSize(C,string(pItem.iKills),tW,tH,pItem.stTagCoord[pItem.4].fWidth);
	fTemp=pItem.stTagCoord[pItem.4].fXPos + GetCenterXPos(pItem.stTagCoord[pItem.4].fWidth,tW);
	C.SetPos(fTemp,fYPos);
	C.DrawText(szTemp);
	szTemp=TextSize(C,string(pItem.iMyDeadCounter),tW,tH,pItem.stTagCoord[pItem.5].fWidth);
	fTemp=pItem.stTagCoord[pItem.5].fXPos + GetCenterXPos(pItem.stTagCoord[pItem.5].fWidth,tW);
	C.SetPos(fTemp,fYPos);
	C.DrawText(szTemp);
	szTemp=TextSize(C,string(pItem.iEfficiency),tW,tH,pItem.stTagCoord[pItem.6].fWidth);
	fTemp=pItem.stTagCoord[pItem.6].fXPos + GetCenterXPos(pItem.stTagCoord[pItem.6].fWidth,tW);
	C.SetPos(fTemp,fYPos);
	C.DrawText(szTemp);
	szTemp=TextSize(C,string(pItem.iRoundsFired),tW,tH,pItem.stTagCoord[pItem.7].fWidth);
	fTemp=pItem.stTagCoord[pItem.7].fXPos + GetCenterXPos(pItem.stTagCoord[pItem.7].fWidth,tW);
	C.SetPos(fTemp,fYPos);
	C.DrawText(szTemp);
	szTemp=TextSize(C,string(pItem.iRoundsHit),tW,tH,pItem.stTagCoord[pItem.8].fWidth);
	fTemp=pItem.stTagCoord[pItem.8].fXPos + GetCenterXPos(pItem.stTagCoord[pItem.8].fWidth,tW);
	C.SetPos(fTemp,fYPos);
	C.DrawText(szTemp);
	szTemp=TextSize(C,pItem.szKillBy,tW,tH,pItem.stTagCoord[pItem.9].fWidth - 2);
	C.SetPos(pItem.stTagCoord[pItem.9].fXPos + 2,fYPos);
	C.DrawText(szTemp);
	szTemp=TextSize(C,string(pItem.iPingTime),tW,tH,pItem.stTagCoord[pItem.10].fWidth - 2);
	fTemp=pItem.stTagCoord[pItem.10].fXPos + GetCenterXPos(pItem.stTagCoord[pItem.10].fWidth,tW);
	C.SetPos(fTemp,fYPos);
	C.DrawText(szTemp); */
}

function DrawIcon (Canvas C, int _iPlayerStats, float _fX, float _fY, float _fWidth, float _fHeight)
{
	local Region RIconRegion;
	local Region RIconToDraw;

	switch (_iPlayerStats)
	{
		case 0:
		RIconToDraw.X=31;
		RIconToDraw.Y=29;
		RIconToDraw.W=10;
		RIconToDraw.H=10;
		break;
		case 1:
		RIconToDraw.X=42;
		RIconToDraw.Y=29;
		RIconToDraw.W=10;
		RIconToDraw.H=10;
		break;
		case 2:
		case 3:
		RIconToDraw.X=53;
		RIconToDraw.Y=29;
		RIconToDraw.W=10;
		RIconToDraw.H=10;
		break;
		case 4:
		RIconToDraw.X=13;
		RIconToDraw.Y=53;
		RIconToDraw.W=13;
		RIconToDraw.H=11;
		break;
		case 5:
		RIconToDraw.X=42;
		RIconToDraw.Y=40;
		RIconToDraw.W=10;
		RIconToDraw.H=10;
		break;
		case 6:
		RIconToDraw.X=53;
		RIconToDraw.Y=40;
		RIconToDraw.W=10;
		RIconToDraw.H=10;
		break;
		default:
	}
	RIconRegion=CenterIconInBox(_fX,_fY,_fWidth,_fHeight,RIconToDraw);
	DrawStretchedTextureSegment(C,RIconRegion.X,RIconRegion.Y,RIconToDraw.W,RIconToDraw.H,RIconToDraw.X,RIconToDraw.Y,RIconToDraw.W,RIconToDraw.H,m_TIcon);
}

defaultproperties
{
    m_fYOffSet=1
    m_BGSelRegion=(X=16589323,Y=571015168,W=2,H=860680)
    m_SelTextColor=(R=255,G=255,B=255,A=0)
    m_SpectatorColor=(R=255,G=255,B=255,A=0)
    m_fItemHeight=11.00
    m_fSpaceBetItem=0.00
    ListClass=Class'R6WindowListIGPlayerInfoItem'
}
/*
    m_BGSelTexture=Texture'R6MenuTextures.Gui_BoxScroll'
*/

