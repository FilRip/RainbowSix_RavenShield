//================================================================================
// UWindowBase.
//================================================================================
class UWindowBase extends Object;

#EXEC TEXTURE IMPORT NAME=WhiteTexture FILE=textures/WhiteTexture.bmp
#EXEC TEXTURE IMPORT NAME=BlackTexture FILE=textures/BlackTexture.bmp

struct HTMLStyle
{
	var int BulletLevel;
	var string LinkDestination;
	var Color TextColor;
	var Color BGColor;
	var bool bCenter;
	var bool bLink;
	var bool bUnderline;
	var bool bNoBR;
	var bool bHeading;
	var bool bBold;
	var bool bBlink;
};

enum ERenderStyle {
	STY_None,
	STY_Normal,
	STY_Masked,
	STY_Translucent,
	STY_Modulated,
	STY_Alpha,
	STY_Particle,
	STY_Highlight
};

enum ERestKitID {
	ERestKit_SubMachineGuns,
	ERestKit_Shotguns,
	ERestKit_AssaultRifle,
	ERestKit_MachineGuns,
	ERestKit_SniperRifle,
	ERestKit_Pistol,
	ERestKit_MachinePistol,
	ERestKit_PriWpnGadget,
	ERestKit_SecWpnGadget,
	ERestKit_MiscGadget,
	ERestKit_Max
};

enum EPopUpID {
	EPopUpID_None,
	EPopUpID_MsgOfTheDay,
	EPopUpID_FileWriteError,
	EPopUpID_FileWriteErrorBackupPln,
	EPopUpID_SaveFileExist,
	EPopUpID_PlanDeleteError,
	EPopUpID_InvalidLoad,
	EPopUpID_MPServerOpt,
	EPopUpID_MPKitRest,
	EPopUpID_MPGearRoom,
	EPopUpID_EnterIP,
	EPopUpID_JoinIPError,
	EPopUpID_JoinIPWait,
	EPopUpID_UbiAccount,
	EPopUpID_LoginError,
	EPopUpID_UbiComDisconnected,
	EPopUpID_CDKeyPleaseWait,
	EPopUpID_EnterCDKey,
	EPopUpID_Password,
	EPopUpID_JoinRoomError,
	EPopUpID_JoinRoomErrorCDKeyInUse,
	EPopUpID_JoinRoomErrorCDKeySrvNotResp,
	EPopUpID_JoinRoomErrorPassWd,
	EPopUpID_JoinRoomErrorSrvFull,
	EPopUpID_ErrorConnect,
	EPopUpID_InvalidPassword,
	EPopUpID_QueryServerWait,
	EPopUpID_QueryServerError,
	EPopUpID_TKPenalty,
	EPopUpID_LeaveInGameToMultiMenu,
	EPopUpID_RefreshServerList,
	EPopUpID_DownLoadingInProgress,
	EPopUpID_AdvFilters,
	EPopUpID_CoopFilters,
	EPopUpID_QuickPlay,
	EPopUpID_LoadDelPlan,
	EPopUpID_SaveDelPlan,
	EPopUpID_DeleteCampaign,
	EPopUpID_OverWriteCampaign,
	EPopUpID_DelAllWayPoints,
	EPopUpID_DelAllTeamsWayPoints,
	EPopUpID_LeavePlanningToMain,
	EPopUpID_SavePlanning,
	EPopUpID_LoadPlanning,
	EPopUpID_PlanningIncomplete,
	EPopUpID_LeaveInGameToMain,
	EPopUpID_LeaveInGameToQuit,
	EPopUpID_AbortMissionRetryAction,
	EPopUpID_AbortMissionRetryPlan,
	EPopUpID_QuitTraining,
	EPopUpID_OptionsResetDefault,
	EPopUpID_TextOnly,
	EPopUpID_Max
};

enum EButtonName {
	EBN_None,
	EBN_RoundPerMatch,
	EBN_RoundTime,
	EBN_NB_Players,
	EBN_BombTimer,
	EBN_Spectator,
	EBN_RoundPerMission,
	EBN_TimeBetRound,
	EBN_NB_of_Terro,
	EBN_InternetServer,
	EBN_DedicatedServer,
	EBN_FriendlyFire,
	EBN_AllowTeamNames,
	EBN_AutoBalTeam,
	EBN_TKPenalty,
	EBN_AllowRadar,
	EBN_RotateMap,
	EBN_AIBkp,
	EBN_ForceFPersonWp,
	EBN_Recruit,
	EBN_Veteran,
	EBN_Elite,
	EBN_DiffLevel,
	EBN_CamFirstPerson,
	EBN_CamThirdPerson,
	EBN_CamFreeThirdP,
	EBN_CamGhost,
	EBN_CamFadeToBk,
	EBN_CamTeamOnly,
	EBN_LogIn,
	EBN_LogOut,
	EBN_Join,
	EBN_JoinIP,
	EBN_Refresh,
	EBN_Create,
	EBN_Cancel,
	EBN_Launch,
	EBN_EditMsg,
	EBN_CancelUbiCom,
	EBN_Max
};

enum PropertyCondition {
	PC_None,
	PC_LessThan,
	PC_Equal,
	PC_GreaterThan,
	PC_NotEqual,
	PC_Contains,
	PC_NotContains
};

enum MessageBoxResult {
	MR_None,
	MR_Yes,
	MR_No,
	MR_OK,
	MR_Cancel
};

enum MessageBoxButtons {
	MB_YesNo,
	MB_OKCancel,
	MB_OK,
	MB_YesNoCancel,
	MB_Cancel,
	MB_None
};

enum MenuSound {
	MS_MenuPullDown,
	MS_MenuCloseUp,
	MS_MenuItem,
	MS_WindowOpen,
	MS_WindowClose,
	MS_ChangeTab
};

enum FrameHitTest {
	HT_NW,
	HT_N,
	HT_NE,
	HT_W,
	HT_E,
	HT_SW,
	HT_S,
	HT_SE,
	HT_TitleBar,
	HT_DragHandle,
	HT_None
};

enum TextAlign {
	TA_Left,
	TA_Right,
	TA_Center
};

struct RegionButton
{
	var Region Up;
	var Region Down;
	var Region Over;
	var Region Disabled;
};

struct TexRegion
{
	var() int X;
	var() int Y;
	var() int W;
	var() int H;
	var() Texture t;
};

const F_CheckBoxButton= 17;
const F_PrincipalButton= 16;
const F_MainButton= 15;
const F_FirstMenuButton= 14;
const F_HelpWindow= 12;
const F_ListItemBig= 11;
const F_ListItemSmall= 10;
const F_IntelTitle= 9;
const F_PopUpTitle= 8;
const F_TabMainTitle= 7;
const F_VerySmallTitle= 6;
const F_SmallTitle= 5;
const F_MenuMainTitle= 4;
const F_ocraext17= 0;
const F_LargeBold= 3;
const F_Large= 2;
const F_Bold= 1;
const F_Normal= 0;

var(Display) ERenderStyle Style;

function Region NewRegion (float X, float Y, float W, float H)
{
	local Region R;

	R.X=X;
	R.Y=Y;
	R.W=W;
	R.H=H;
	return R;
}

function TexRegion NewTexRegion (float X, float Y, float W, float H, Texture t)
{
	local TexRegion R;

	R.X=X;
	R.Y=Y;
	R.W=W;
	R.H=H;
	R.t=t;
	return R;
}

function Region GetRegion (TexRegion t)
{
	local Region R;

	R.X=t.X;
	R.Y=t.Y;
	R.W=t.W;
	R.H=t.H;
	return R;
}

static function int InStrAfter (string Text, string Match, int pos)
{
	local int i;

	i=InStr(Mid(Text,pos),Match);
	if ( i != -1 )
	{
		return i + pos;
	}
	return -1;
}

static function Object BuildObjectWithProperties (string Text)
{
	local int i;
	local string ObjectClass;
	local string PropertyName;
	local string PropertyValue;
	local string temp;
	local Class C;
	local Object o;

	i=InStr(Text,",");
	if ( i == -1 )
	{
		ObjectClass=Text;
		Text="";
	}
	else
	{
		ObjectClass=Left(Text,i);
		Text=Mid(Text,i + 1);
	}
	C=Class<Object>(DynamicLoadObject(ObjectClass,Class'Class'));
	o=new C;
	while ( Text != "" )
	{
		i=InStr(Text,"=");
		if ( i == -1 )
		{
			Log("Missing value for property " $ ObjectClass $ "." $ Text);
			PropertyName=Text;
			PropertyValue="";
		}
		else
		{
			PropertyName=Left(Text,i);
			Text=Mid(Text,i + 1);
		}
		if ( Left(Text,1) == Chr(34) )
		{
			i=InStrAfter(Text,Chr(34),1);
			if ( i == -1 )
			{
				Log("Missing quote for " $ ObjectClass $ "." $ PropertyName);
				return o;
			}
			PropertyValue=Mid(Text,1,i - 1);
			temp=Mid(Text,i + 1,1);
			if ( (temp != "") && (temp != ",") )
			{
				Log("Missing comma after close quote for " $ ObjectClass $ "." $ PropertyName);
			}
			Text=Mid(Text,i + 2);
		}
		else
		{
			i=InStr(Text,",");
			if ( i == -1 )
			{
				PropertyValue=Text;
				Text="";
			}
			else
			{
				PropertyValue=Left(Text,i);
				Text=Mid(Text,i + 1);
			}
		}
		o.SetPropertyText(PropertyName,PropertyValue);
	}
	return o;
}
