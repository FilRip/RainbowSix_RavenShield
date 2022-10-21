//================================================================================
// R6AbstractGameService.
//================================================================================
class R6AbstractGameService extends Object
	Native;
//	Export;

var bool m_bServerWaitMatchStartReply;
var bool m_bClientWaitMatchStartReply;
var bool m_bClientWillSubmitResult;
var bool m_bWaitSubmitMatchReply;
var bool m_bMSClientLobbyDisconnect;
var bool m_bMSClientRouterDisconnect;
var PlayerController m_LocalPlayerController;
var config string m_szUserID;

native(1297) final function NativeSubmitMatchResult ();

function CallNativeSetMatchResult (string szUbiUserID, int iField, int iValue);

function bool CallNativeProcessIcmpPing (string _ServerIpAddress, out int piPingTime);

function string MyID ();
