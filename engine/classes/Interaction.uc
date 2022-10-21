//================================================================================
// Interaction.
//================================================================================
class Interaction extends Interactions
	Native;

var bool bActive;
var bool bVisible;
var bool bRequiresTick;
var Player ViewportOwner;
var InteractionMaster Master;

native function Initialize ();

native function bool ConsoleCommand (coerce string S);

native function Vector WorldToScreen (Vector Location, optional Vector CameraLocation, optional Rotator CameraRotation);

native function Vector ScreenToWorld (Vector Location, optional Vector CameraLocation, optional Rotator CameraRotation);

event Initialized ();

event ServerDisconnected ();

event UserDisconnected ();

event ConnectionFailed ();

event R6ConnectionFailed (string szError);

event R6ConnectionSuccess ();

event R6ConnectionInterrupted ();

event R6ConnectionInProgress ();

event R6ProgressMsg (string _Str1, string _Str2, float Seconds);

function Object SetGameServiceLinks (PlayerController _localPlayer);

event NotifyLevelChange ();

event NotifyAfterLevelChange ();

event MenuLoadProfile (bool _bServerProfile);

event LaunchR6MainMenu ();

function SendGoCode (EGoCode eGo);

function Message (coerce string Msg, float MsgLife)
{
}

function bool KeyType (out EInputKey Key)
{
	return False;
}

function bool KeyEvent (out EInputKey Key, out EInputAction Action, float Delta)
{
	return False;
}

function PreRender (Canvas Canvas);

function PostRender (Canvas Canvas);

function SetFocus ()
{
	Master.SetFocusTo(self,ViewportOwner);
}

function Tick (float DeltaTime);

event string ConvertKeyToLocalisation (byte _Key, string _szEnumKeyName)
{
	local string szResult;

	if ( (_Key > 48 - 1) && (_Key < 57 + 1) )
	{
		szResult=string(_Key - 48);
	}
	else
	{
		if ( (_Key > 65 - 1) && (_Key < 90 + 1) )
		{
			szResult=Chr(_Key);
		}
		else
		{
			if ( (_Key > 112 - 1) && (_Key < 135 + 1) )
			{
				szResult="F" $ string(_Key - 112 + 1);
			}
			else
			{
				szResult=Localize("Interactions","IK_" $ _szEnumKeyName,"R6Menu");
				if ( szResult == Localize("Interactions","IK_None","R6Menu") )
				{
					szResult="";
				}
			}
		}
	}
	return szResult;
}

defaultproperties
{
    bActive=True
}