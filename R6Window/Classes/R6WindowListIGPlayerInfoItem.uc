//================================================================================
// R6WindowListIGPlayerInfoItem.
//================================================================================
class R6WindowListIGPlayerInfoItem extends UWindowListBoxItem;

struct stSettings
{
	var float fXPos;
	var float fWidth;
	var bool bDisplay;
};

enum ePLInfo {
	ePL_Ready,
	ePL_HealthStatus,
	ePL_Name,
	ePL_RoundsWon,
	ePL_Kill,
	ePL_DeadCounter,
	ePL_Efficiency,
	ePL_RoundFired,
	ePL_RoundHit,
	ePL_KillerName,
	ePL_PingTime
};

enum ePlStatus {
	ePlayerStatus_Alive,
	ePlayerStatus_Wounded,
	ePlayerStatus_Incapacitated,
	ePlayerStatus_Dead,
	ePlayerStatus_Spectator,
	ePlayerStatus_TooLate
};

var ePlStatus eStatus;
var int iKills;
var int iMyDeadCounter;
var int iEfficiency;
var int iRoundsFired;
var int iRoundsHit;
var int iPingTime;
var int m_iRainbowTeam;
var int m_iOperativeID;
var bool bOwnPlayer;
var bool bReady;
var stSettings stTagCoord[11];
var string szPlName;
var string szKillBy;
var string szRoundsWon;
const C_NB_OF_PLAYER_INFO= 11;

function int GetHealth (ePlStatus _ePLStatus)
{
	switch (_ePLStatus)
	{
/*		case 0:
		return 0;
		case 1:
		return 1;
		case 2:
		return 2;
		case 3:
		return 3;
		case 4:
		return 4;
		default:*/
	}
	return 0;
}
