//================================================================================
// R6WindowSimpleIGPlayerListBox.
//================================================================================
class R6WindowSimpleIGPlayerListBox extends R6WindowIGPlayerInfoListBox;

function DrawItem (Canvas C, UWindowList Item, float X, float Y, float W, float H)
{
/*	local float TextY;
	local float tW;
	local float tH;
	local float fTemp;
	local float fYPos;
	local Color co;
	local R6WindowListIGPlayerInfoItem pListIGPlayerInfoItem;
	local R6WindowLookAndFeel pLookAndFeel;

	pListIGPlayerInfoItem=R6WindowListIGPlayerInfoItem(Item);
	pLookAndFeel=R6WindowLookAndFeel(LookAndFeel);
	if ( pListIGPlayerInfoItem.bSelected )
	{
		if ( m_BGSelTexture != None )
		{
			C.Style=m_BGRenderStyle;
			C.SetDrawColor(m_BGSelColor.R,m_BGSelColor.G,m_BGSelColor.B,m_BGSelColor.A);
			fYPos=Y + (H - m_BGSelRegion.H) / 2;
			DrawStretchedTextureSegment(C,X,fYPos,W,m_BGSelRegion.H,m_BGSelRegion.X,m_BGSelRegion.Y,m_BGSelRegion.W,m_BGSelRegion.H,m_BGSelTexture);
		}
	}
	C.Style=5;
	C.Font=m_Font;
	TextSize(C,pListIGPlayerInfoItem.szPlName,tW,tH);
	TextY=(H - tH) / 2;
	TextY=TextY + 0.50;
	fYPos=Y + TextY;
	if ( pListIGPlayerInfoItem.bSelected )
	{
		co=Root.Colors.TeamColorLight[pListIGPlayerInfoItem.m_iRainbowTeam];
	}
	else
	{
		co=Root.Colors.TeamColor[pListIGPlayerInfoItem.m_iRainbowTeam];
	}
	C.SetDrawColor(co.R,co.G,co.B,co.A);
	pLookAndFeel.DrawInGamePlayerStats(self,C,4,pListIGPlayerInfoItem.stTagCoord[0].fXPos,Y,H,pListIGPlayerInfoItem.stTagCoord[0].fWidth);
	switch (pListIGPlayerInfoItem.eStatus)
	{
		case 0:
		pLookAndFeel.DrawInGamePlayerStats(self,C,1,pListIGPlayerInfoItem.stTagCoord[2].fXPos,Y,H,pListIGPlayerInfoItem.stTagCoord[2].fWidth);
		break;
		case 1:
		pLookAndFeel.DrawInGamePlayerStats(self,C,2,pListIGPlayerInfoItem.stTagCoord[2].fXPos,Y,H,pListIGPlayerInfoItem.stTagCoord[2].fWidth);
		break;
		case 2:
		case 3:
		pLookAndFeel.DrawInGamePlayerStats(self,C,3,pListIGPlayerInfoItem.stTagCoord[2].fXPos,Y,H,pListIGPlayerInfoItem.stTagCoord[2].fWidth);
		break;
		default:
	}
	if ( pListIGPlayerInfoItem.bSelected )
	{
		C.SetDrawColor(m_SelTextColor.R,m_SelTextColor.G,m_SelTextColor.B);
	}
	else
	{
		C.SetDrawColor(TextColor.R,TextColor.G,TextColor.B);
	}
	C.SetPos(pListIGPlayerInfoItem.stTagCoord[1].fXPos,fYPos);
	C.DrawText(pListIGPlayerInfoItem.szPlName);
	TextSize(C,string(pListIGPlayerInfoItem.iKills),tW,tH);
	fTemp=pListIGPlayerInfoItem.stTagCoord[3].fXPos + GetCenterXPos(pListIGPlayerInfoItem.stTagCoord[3].fWidth,tW);
	C.SetPos(fTemp,fYPos);
	C.DrawText(string(pListIGPlayerInfoItem.iKills));
	TextSize(C,string(pListIGPlayerInfoItem.iEfficiency),tW,tH);
	fTemp=pListIGPlayerInfoItem.stTagCoord[4].fXPos + GetCenterXPos(pListIGPlayerInfoItem.stTagCoord[4].fWidth,tW);
	C.SetPos(fTemp,fYPos);
	C.DrawText(string(pListIGPlayerInfoItem.iEfficiency));
	TextSize(C,string(pListIGPlayerInfoItem.iRoundsFired),tW,tH);
	fTemp=pListIGPlayerInfoItem.stTagCoord[5].fXPos + GetCenterXPos(pListIGPlayerInfoItem.stTagCoord[5].fWidth,tW);
	C.SetPos(fTemp,fYPos);
	C.DrawText(string(pListIGPlayerInfoItem.iRoundsFired));
	TextSize(C,string(pListIGPlayerInfoItem.iRoundsHit),tW,tH);
	fTemp=pListIGPlayerInfoItem.stTagCoord[6].fXPos + GetCenterXPos(pListIGPlayerInfoItem.stTagCoord[6].fWidth,tW);
	C.SetPos(fTemp,fYPos);
	C.DrawText(string(pListIGPlayerInfoItem.iRoundsHit));*/
}

defaultproperties
{
    m_fItemHeight=14.00
}
