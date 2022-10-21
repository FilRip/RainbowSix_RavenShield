//================================================================================
// R6AbstractCircumstantialActionQuery.
//================================================================================
class R6AbstractCircumstantialActionQuery extends Actor
	Native;

var byte iHasAction;
var byte iInRange;
var byte iPlayerActionID;
var byte iTeamActionID;
var byte iTeamActionIDList[4];
var byte iTeamSubActionsIDList[16];
var int iMenuChoice;
var int iSubMenuChoice;
var bool bCanBeInterrupted;
var float fPlayerActionTimeRequired;
var float m_fPressedTime;
var Actor aQueryOwner;
var Actor aQueryTarget;
var Texture textureIcon;

replication
{
	reliable if ( Role == Role_Authority )
		iHasAction,iInRange,iPlayerActionID,iTeamActionIDList,iTeamSubActionsIDList,bCanBeInterrupted,fPlayerActionTimeRequired,aQueryOwner,aQueryTarget,textureIcon;
}

simulated function ResetOriginalData ()
{
	if ( m_bResetSystemLog )
	{
		LogResetSystem(False);
	}
	Super.ResetOriginalData();
	aQueryTarget=None;
	iHasAction=0;
	bCanBeInterrupted=False;
	fPlayerActionTimeRequired=0.00;
	iMenuChoice=-1;
	iSubMenuChoice=-1;
}

function PostBeginPlay ()
{
	Super.PostBeginPlay();
}

defaultproperties
{
    RemoteRole=ROLE_SimulatedProxy
    DrawType=0
    bHidden=True
}