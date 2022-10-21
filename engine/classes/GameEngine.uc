//================================================================================
// GameEngine.
//================================================================================
class GameEngine extends Engine
	Native;

struct URL
{
	var string Protocol;
	var string Host;
	var int Port;
	var string Map;
	var array<string> Op;
	var string Portal;
	var bool Valid;
};

var Level GLevel;
var Level GEntry;
var PendingLevel GPendingLevel;
var URL LastURL;
var config array<string> ServerActors;
var config array<string> ServerPackages;
var bool FramePresentPending;
var string m_MapName;

defaultproperties
{
    ServerActors(0)="IpDrv.UdpBeacon"
    ServerPackages(0)="GamePlay"
	ServerPackages(1)="R6Abstract"
	ServerPackages(2)="R6Engine"
	ServerPackages(3)="R6Characters"
	ServerPackages(4)="R6GameService"
	ServerPackages(5)="R6Game"
	ServerPackages(6)="R61stWeapons"
	ServerPackages(7)="R6Weapons"
	ServerPackages(8)="R6WeaponGadgets"
	ServerPackages(9)="R63rdWeapons"
    CacheSizeMegs=32
}