class Player extends Object;

const IDC_WAIT=6;
const IDC_SIZEWE=5;
const IDC_SIZENWSE=4;
const IDC_SIZENS=3;
const IDC_SIZENESW=2;
const IDC_SIZEALL=1;
const IDC_ARROW=0;
var int vfOut;
var int vfExec;
var PlayerController Actor;
var Interaction Console;
var bool bWindowsMouseAvailable;
var bool bShowWindowsMouse;
var bool bSuspendPrecaching;
var float WindowsMouseX;
var float WindowsMouseY;
var int CurrentNetSpeed;
var globalconfig int ConfiguredInternetSpeed;
var globalconfig int ConfiguredLanSpeed;
var byte SelectedCursor;
var transient InteractionMaster InteractionMaster;
var transient array<Interaction> LocalInteractions;
var Guid m_ArmPatchGUID;
var byte u8WaitLaunchStatingSound;

defaultproperties
{
    ConfiguredInternetSpeed=20000
    ConfiguredLanSpeed=20000
}