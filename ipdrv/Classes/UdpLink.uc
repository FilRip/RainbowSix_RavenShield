//================================================================================
// UdpLink.
//================================================================================
class UdpLink extends InternetLink
	Native;

var() const int BroadcastAddr;

native function float GetPlayingTime (string szIPAddr);

native function SetPlayingTime (string szIPAddr, float fLoginTime, float fCurrentTime);

native function CheckForPlayerTimeouts ();

native(1221) static final function int GetMaxAvailPorts ();

native function int BindPort (optional int Port, optional bool bUseNextAvailable, optional out string szLocalBoundIpAddress);

native function bool SendText (IpAddr Addr, coerce string Str);

native function bool SendBinary (IpAddr Addr, int Count, byte B[255]);

native function int ReadText (out IpAddr Addr, out string Str);

native function int ReadBinary (out IpAddr Addr, int Count, out byte B[255]);

event ReceivedText (IpAddr Addr, string Text);

event ReceivedLine (IpAddr Addr, string Line);

event ReceivedBinary (IpAddr Addr, int Count, byte B[255]);

defaultproperties
{
    BroadcastAddr=-1
    bAlwaysTick=True
}