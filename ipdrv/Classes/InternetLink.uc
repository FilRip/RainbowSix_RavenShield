//================================================================================
// InternetLink.
//================================================================================
class InternetLink extends InternetInfo
	Native;

enum EReceiveMode {
	RMODE_Manual,
	RMODE_Event
};

enum ELinkMode {
	MODE_Text,
	MODE_Line,
	MODE_Binary
};

struct IpAddr
{
	var int Addr;
	var int Port;
};

var ELinkMode LinkMode;
var EReceiveMode ReceiveMode;
var const int Socket;
var const int Port;
var const int RemoteSocket;
var const native private int PrivateResolveInfo;
var const int DataPending;

native function bool IsDataPending ();

native function bool ParseURL (coerce string URL, out string Addr, out int Port, out string LevelName, out string EntryName);

native function Resolve (coerce string Domain);

native function int GetLastError ();

native function string IpAddrToString (IpAddr Arg);

native function bool StringToIpAddr (string Str, out IpAddr Addr);

native function string Validate (string ValidationString, string GameName);

native function GetLocalIP (out IpAddr Arg);

event Resolved (IpAddr Addr);

event ResolveFailed ();
