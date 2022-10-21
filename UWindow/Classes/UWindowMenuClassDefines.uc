//================================================================================
// UWindowMenuClassDefines.
//================================================================================
class UWindowMenuClassDefines extends Object
	config(R6ClassDefines);

var config Class<UWindowWindow> ClassMPServerOption;
var config Class<UWindowWindow> ClassButtonsDefines;
var config Class<UWindowWindow> ClassMPCreateGameTabOpt;
var config Class<UWindowWindow> ClassMPCreateGameTabAdvOpt;
var config Class<UWindowWindow> ClassMPMenuTabGameModeFilters;
var config Class<UWindowWindow> ClassMultiPlayerWidget;
var config Class<UWindowWindow> ClassCustomMissionWidget;
var config Class<UWindowWindow> ClassMPCreateGameWidget;
var config Class<UWindowWindow> ClassUbiComWidget;
var config Class<UWindowWindow> ClassNonUbiComWidget;
var config Class ClassGSServer;
var config Class ClassLanServer;
var config Class<UWindowWindow> ClassUbiLogIn;
var config Class<UWindowWindow> ClassUbiCDKeyCheck;
var config Class<UWindowWindow> ClassQueryServerInfo;
var config Class<UWindowWindow> ClassUbiLoginClient;
var config Class<UWindowWindow> ClassMultiJoinIP;
var config string RegularRoot;
var config string InGameMultiRoot;
var config string InGameSingleRoot;

function Created ()
{
	local string szMenuDefFile;

	szMenuDefFile=Class'Actor'.static.GetModMgr().GetMenuDefFile();
	LoadConfig(szMenuDefFile);
	if ( ClassMPServerOption == None )
	{
		Log("WARNING Your ClassMPServerOption was not define in " $ szMenuDefFile $ ".ini");
	}
	if ( ClassMPCreateGameTabOpt == None )
	{
		Log("WARNING Your ClassMPCreateGameTabOpt was not define in " $ szMenuDefFile $ ".ini");
	}
	if ( ClassMPCreateGameTabAdvOpt == None )
	{
		Log("WARNING Your ClassMPCreateGameTabAdvOpt was not define in " $ szMenuDefFile $ ".ini");
	}
	if ( ClassMPMenuTabGameModeFilters == None )
	{
		Log("WARNING Your ClassMPMenuTabGameModeFilters was not define in " $ szMenuDefFile $ ".ini");
	}
	if ( ClassMultiPlayerWidget == None )
	{
		Log("WARNING Your ClassMultiPlayerWidget was not define in " $ szMenuDefFile $ ".ini");
	}
	if ( ClassCustomMissionWidget == None )
	{
		Log("WARNING Your ClassCustomMissionWidget was not define in " $ szMenuDefFile $ ".ini");
	}
	if ( ClassMPCreateGameWidget == None )
	{
		Log("WARNING Your ClassMPCreateGameWidget was not define in " $ szMenuDefFile $ ".ini");
	}
	if ( ClassUbiComWidget == None )
	{
		Log("WARNING Your ClassUbiComWidget was not define in " $ szMenuDefFile $ ".ini");
	}
	if ( ClassNonUbiComWidget == None )
	{
		Log("WARNING Your ClassNonUbiComWidget was not define in " $ szMenuDefFile $ ".ini");
	}
	if ( ClassUbiLogIn == None )
	{
		Log("WARNING Your ClassUbiLogIn was not define in " $ szMenuDefFile $ ".ini");
	}
	if ( ClassUbiCDKeyCheck == None )
	{
		Log("WARNING Your ClassUbiCDKeyCheck was not define in " $ szMenuDefFile $ ".ini");
	}
	if ( ClassQueryServerInfo == None )
	{
		Log("WARNING Your ClassQueryServerInfo was not define in " $ szMenuDefFile $ ".ini");
	}
	if ( ClassUbiLoginClient == None )
	{
		Log("WARNING Your ClassUbiLoginClient was not define in " $ szMenuDefFile $ ".ini");
	}
	if ( ClassMultiJoinIP == None )
	{
		Log("WARNING Your ClassMultiJoinIP was not define in " $ szMenuDefFile $ ".ini");
	}
}

defaultproperties
{
    ClassMPServerOption=Class'R6Menu.R6MenuMPServerOption'
    ClassButtonsDefines=Class'R6Menu.R6MenuButtonsDefines'
    ClassMPCreateGameTabOpt=Class'R6Menu.R6MenuMPCreateGameTabOptions'
    ClassMPCreateGameTabAdvOpt=Class'R6Menu.R6MenuMPCreateGameTabAdvOptions'
    ClassMPMenuTabGameModeFilters=Class'R6Menu.R6MenuMPMenuTab'
    ClassMultiPlayerWidget=Class'R6Menu.R6MenuMultiPlayerWidget'
    ClassCustomMissionWidget=Class'R6Menu.R6MenuCustomMissionWidget'
    ClassMPCreateGameWidget=Class'R6Menu.R6MenuMPCreateGameWidget'
    ClassUbiComWidget=Class'R6Menu.R6MenuUbiComWidget'
    ClassNonUbiComWidget=Class'R6Menu.R6MenuNonUbiWidget'
    ClassGSServer=Class'R6GameService.R6GSServers'
    ClassLanServer=Class'R6GameService.R6LanServers'
    ClassUbiLogIn=Class'R6Window.R6WindowUbiLogIn'
    ClassUbiCDKeyCheck=Class'R6Window.R6WindowUbiCDKeyCheck'
    ClassQueryServerInfo=Class'R6Window.R6WindowQueryServerInfo'
    ClassUbiLoginClient=Class'R6Window.R6WindowUbiLoginClient'
    ClassMultiJoinIP=Class'R6Window.R6WindowJoinIP'
    RegularRoot="R6Menu.R6MenuRootWindow"
    InGameMultiRoot="R6Menu.R6MenuInGameMultiPlayerRootWindow"
    InGameSingleRoot="R6Menu.R6MenuInGameRootWindow"
}
