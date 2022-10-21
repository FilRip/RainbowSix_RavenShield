//================================================================================
// LocalMessage.
//================================================================================
class LocalMessage extends Info;

var int Lifetime;
var bool bComplexString;
var bool bIsSpecial;
var bool bIsUnique;
var bool bIsConsoleMessage;
var bool bFadeMessage;
var bool bBeep;
var bool bOffsetYPos;
var bool bFromBottom;
var bool bCenter;
var float XPos;
var float YPos;
var Class<LocalMessage> ChildMessage;
var Color DrawColor;

static function RenderComplexMessage (Canvas Canvas, out float XL, out float YL, optional string MessageString, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject);

static function string GetString (optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	if ( Class<Actor>(OptionalObject) != None )
	{
		return Class<Actor>(OptionalObject).static.GetLocalString(Switch,RelatedPRI_1,RelatedPRI_2);
	}
	return "";
}

static function string AssembleString (HUD myHUD, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional string MessageString)
{
	return "";
}

static function ClientReceive (PlayerController P, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	P.myHUD.LocalizedMessage(Default.Class,Switch,RelatedPRI_1,RelatedPRI_2,OptionalObject);
	if ( Default.bIsConsoleMessage )
	{
		P.Player.InteractionMaster.Process_Message(GetString(Switch,RelatedPRI_1,RelatedPRI_2,OptionalObject),6.00,P.Player.LocalInteractions);
	}
}

static function Color GetColor (optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
	return Default.DrawColor;
}

static function float GetOffset (int Switch, float YL, float ClipY)
{
	return Default.YPos;
}

static function int GetFontSize (int Switch);

defaultproperties
{
    Lifetime=6
    DrawColor=(R=255,G=255,B=255,A=255)
}