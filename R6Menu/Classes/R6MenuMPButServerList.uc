//================================================================================
// R6MenuMPButServerList.
//================================================================================
class R6MenuMPButServerList extends UWindowDialogClientWindow;

var R6WindowButtonSort m_pButFavorites;
var R6WindowButtonSort m_pButLocked;
var R6WindowButtonSort m_pButDedicated;
var R6WindowButtonSort m_pButPingTime;
var R6WindowButtonSort m_pButName;
var R6WindowButtonSort m_pButGameType;
var R6WindowButtonSort m_pButGameMode;
var R6WindowButtonSort m_pButMap;
var R6WindowButtonSort m_pButNumPlayers;
var R6WindowButtonSort m_pLastButtonClick;
const C_fW_PLAYERS= 63;
const C_fW_MAP= 105;
const C_fW_GAMETYPE= 105;
const C_fW_GAMEMODE= 105;
const C_fW_PING= 40;
const C_fW_NAME= 155;
const C_fW_DEDICATED= 15;
const C_fW_LOCKED= 15;
const C_fW_FAVORITES= 15;
const C_fX_FAVORITES= 0;

function Created ()
{
	local R6ServerList pSLDummy;
	local float fXOffset;

	pSLDummy=R6MenuMultiPlayerWidget(OwnerWindow).m_GameService;
	fXOffset=0.00;
//	CreateServerListButton(pSLDummy.0,"InfoBar_F","InfoBar_F",fXOffset,15.00,m_pButFavorites);
	fXOffset += 15;
//	CreateServerListButton(pSLDummy.1,"InfoBar_L","InfoBar_L",fXOffset,15.00,m_pButLocked);
	fXOffset += 15;
//	CreateServerListButton(pSLDummy.2,"InfoBar_D","InfoBar_D",fXOffset,15.00,m_pButDedicated);
	fXOffset += 15;
//	CreateServerListButton(pSLDummy.5,"InfoBar_Server","InfoBar_Server",fXOffset,155.00,m_pButName);
	fXOffset += 155;
//	CreateServerListButton(pSLDummy.4,"InfoBar_Ping","InfoBar_Ping",fXOffset,40.00,m_pButPingTime);
	fXOffset += 40;
//	CreateServerListButton(pSLDummy.6,"InfoBar_Type","InfoBar_Type",fXOffset,105.00,m_pButGameType);
	fXOffset += 105;
//	CreateServerListButton(pSLDummy.7,"InfoBar_GameMode","InfoBar_GameMode",fXOffset,105.00,m_pButGameMode);
	fXOffset += 105;
//	CreateServerListButton(pSLDummy.8,"InfoBar_Map","InfoBar_Map",fXOffset,105.00,m_pButMap);
	fXOffset += 105;
//	CreateServerListButton(pSLDummy.9,"InfoBar_Players","InfoBar_Players",fXOffset,63.00,m_pButNumPlayers);
	m_pButPingTime.m_bDrawSortIcon=True;
	m_pButPingTime.m_bAscending=True;
	m_pLastButtonClick=m_pButPingTime;
}

function CreateServerListButton (int _iButtonID, string _szName, string _szTip, float _fX, float _fWidth, out R6WindowButtonSort _R6Button)
{
	_R6Button=R6WindowButtonSort(CreateControl(Class'R6WindowButtonSort',_fX,0.00,_fWidth,WinHeight,self));
	_R6Button.ToolTipString=Localize("Tip",_szTip,"R6Menu");
	_R6Button.Text=Localize("MultiPlayer",_szName,"R6Menu");
	_R6Button.Align=TA_Center;
	_R6Button.m_buttonFont=Root.Fonts[6];
	_R6Button.m_iButtonID=_iButtonID;
}

function Notify (UWindowDialogControl C, byte E)
{
	local bool bTypeOfSort;

	if ( E == 2 )
	{
		bTypeOfSort=R6MenuMultiPlayerWidget(OwnerWindow).m_bLastTypeOfSort;
		if ( m_pLastButtonClick == None )
		{
			m_pLastButtonClick=R6WindowButtonSort(C);
		}
		m_pLastButtonClick.m_bDrawSortIcon=False;
		if ( m_pLastButtonClick == R6WindowButtonSort(C) )
		{
			bTypeOfSort= !bTypeOfSort;
		}
		else
		{
			m_pLastButtonClick=R6WindowButtonSort(C);
		}
		R6WindowButtonSort(C).m_bDrawSortIcon=True;
		R6WindowButtonSort(C).m_bAscending=bTypeOfSort;
		R6MenuMultiPlayerWidget(OwnerWindow).ResortServerList(R6WindowButtonSort(C).m_iButtonID,bTypeOfSort);
	}
}
