//================================================================================
// R6WindowListServerItem.
//================================================================================
class R6WindowListServerItem extends UWindowListBoxItem;

enum eServerItem {
	eSI_Favorites,
	eSI_Locked,
	eSI_Dedicated,
	eSI_ServerName,
	eSI_Ping,
	eSI_GameType,
	eSI_GameMode,
	eSI_Map,
	eSI_Players
};

var int iPing;
var int iMaxPlayers;
var int iNumPlayers;
var int iMainSvrListIdx;
var bool bFavorite;
var bool bLocked;
var bool bDedicated;
var bool bSameVersion;
var bool m_bNewItem;
var stCoordItem m_stServerItemPos[10];
var string szIPAddr;
var string szName;
var string szGameMode;
var string szMap;
var string szGameType;

function Created ()
{
	m_bNewItem=True;
	m_stServerItemPos[0].fXPos=0.00;
	m_stServerItemPos[0].fWidth=15.00;
	m_stServerItemPos[1].fXPos=m_stServerItemPos[0].fXPos + m_stServerItemPos[0].fWidth;
	m_stServerItemPos[1].fWidth=15.00;
	m_stServerItemPos[2].fXPos=m_stServerItemPos[1].fXPos + m_stServerItemPos[1].fWidth;
	m_stServerItemPos[2].fWidth=15.00;
	m_stServerItemPos[3].fXPos=m_stServerItemPos[2].fXPos + m_stServerItemPos[2].fWidth;
	m_stServerItemPos[3].fWidth=155.00;
	m_stServerItemPos[4].fXPos=m_stServerItemPos[3].fXPos + m_stServerItemPos[3].fWidth;
	m_stServerItemPos[4].fWidth=40.00;
	m_stServerItemPos[5].fXPos=m_stServerItemPos[4].fXPos + m_stServerItemPos[4].fWidth;
	m_stServerItemPos[5].fWidth=105.00;
	m_stServerItemPos[6].fXPos=m_stServerItemPos[5].fXPos + m_stServerItemPos[5].fWidth;
	m_stServerItemPos[6].fWidth=105.00;
	m_stServerItemPos[7].fXPos=m_stServerItemPos[6].fXPos + m_stServerItemPos[6].fWidth;
	m_stServerItemPos[7].fWidth=105.00;
	m_stServerItemPos[8].fXPos=m_stServerItemPos[7].fXPos + m_stServerItemPos[7].fWidth;
	m_stServerItemPos[8].fWidth=63.00;
}
