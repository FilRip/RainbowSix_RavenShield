//================================================================================
// R6WindowListBoxCreditsItem.
//================================================================================
class R6WindowListBoxCreditsItem extends UWindowList;

var int m_iFont;
var int m_iColor;
var int m_iXPosOffset;
var int m_iYPosOffset;
var bool m_bDrawALineUnderText;
var bool m_bConvertItemValue;
var float m_fHeight;
var Font m_Font;
var Color m_TextColor;
var string m_szName;

function Init (string _szCreditsLine)
{
	local string szTemp;
	local int iMarkerPos1;
	local int iMarkerPos2;

	szTemp=_szCreditsLine;
	iMarkerPos1=InStr(szTemp,"[");
	if ( iMarkerPos1 == -1 )
	{
		return;
	}
	iMarkerPos2=InStr(szTemp,"]");
	if ( iMarkerPos2 == -1 )
	{
		return;
	}
	iMarkerPos1 += 1;
	szTemp=Mid(szTemp,iMarkerPos1,iMarkerPos2 - iMarkerPos1);
	iMarkerPos2 += 1;
	switch (szTemp)
	{
		case "T0":
		m_szName=Mid(_szCreditsLine,iMarkerPos2);
		m_fHeight=40.00;
		m_iFont=4;
		m_iColor=0;
		m_bDrawALineUnderText=True;
		break;
		case "T1":
		m_szName=Mid(_szCreditsLine,iMarkerPos2);
		m_fHeight=20.00;
		m_iFont=16;
		m_iColor=0;
		break;
		case "T2":
		m_szName=Mid(_szCreditsLine,iMarkerPos2);
		m_fHeight=20.00;
		m_iFont=5;
		m_iColor=1;
		break;
		default:
		m_szName="";
		m_fHeight=float(szTemp);
		break;
	}
}