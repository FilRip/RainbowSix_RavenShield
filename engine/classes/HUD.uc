//================================================================================
// HUD.
//================================================================================
class HUD extends Actor
	Native;
//	NoNativeReplication
//	Localized;

const c_iTextServerMessagesMax= 3;
const c_iTextKillMessagesMax= 4;
const c_iTextMessagesMax= 6;
struct HUDLocalizedMessage
{
	var Class<LocalMessage> Message;
	var int Switch;
	var PlayerReplicationInfo RelatedPRI;
	var Object OptionalObject;
	var float EndOfLife;
	var float Lifetime;
	var bool bDrawing;
	var int numLines;
	var string StringMessage;
	var Color DrawColor;
	var Font StringFont;
	var float XL;
	var float YL;
	var float YPos;
};

var bool bShowScores;
var bool bShowDebugInfo;
var bool bHideCenterMessages;
var bool bBadConnectionAlert;
var bool bHideHUD;
var float MessageLife[6];
var float MessageKillLife[4];
var float MessageServerLife[3];
var Font SmallFont;
var Font MedFont;
var Font BigFont;
var Font LargeFont;
var R6GameColors Colors;
var HUD nextHUD;
var PlayerController PlayerOwner;
var Font m_FontRainbow6_14pt;
var Font m_FontRainbow6_17pt;
var Font m_FontRainbow6_22pt;
var Font m_FontRainbow6_36pt;
var Material m_ConsoleBackground;
var Color m_ChatMessagesColor;
var Color m_KillMessagesColor;
var Color m_ServerMessagesColor;
var string HUDConfigWindowType;
var localized string LoadingMessage;
var localized string SavingMessage;
var localized string ConnectingMessage;
var localized string PausedMessage;
var localized string PrecachingMessage;
var string TextMessages[6];
var string TextKillMessages[4];
var string TextServerMessages[3];

native final function Draw3DLine (Vector Start, Vector End, Color LineColor);

simulated event PostBeginPlay ()
{
	Super.PostBeginPlay();
	PlayerOwner=PlayerController(Owner);
	Colors=new Class'R6GameColors';
	if ( Level.NetMode == NM_DedicatedServer )
	{
		return;
	}
	SmallFont=Font(DynamicLoadObject("R6Font.SmallFont",Class'Font'));
	MedFont=SmallFont;
	BigFont=SmallFont;
	LargeFont=SmallFont;
	m_FontRainbow6_14pt=Font(DynamicLoadObject("R6Font.Rainbow6_14pt",Class'Font'));
	m_FontRainbow6_17pt=Font(DynamicLoadObject("R6Font.Rainbow6_17pt",Class'Font'));
	m_FontRainbow6_22pt=Font(DynamicLoadObject("R6Font.Rainbow6_22pt",Class'Font'));
	m_FontRainbow6_36pt=Font(DynamicLoadObject("R6Font.Rainbow6_36pt",Class'Font'));
}

simulated event Destroyed ()
{
	PlayerOwner=None;
	Super.Destroyed();
}

event ShowUpgradeMenu ();

function PlayStartupMessage (byte Stage);

function ClearMessage (out HUDLocalizedMessage M)
{
	M.Message=None;
	M.Switch=0;
	M.RelatedPRI=None;
	M.OptionalObject=None;
	M.EndOfLife=0.00;
	M.StringMessage="";
	M.DrawColor=Class'Canvas'.static.MakeColor(255,255,255);
	M.XL=0.00;
	M.bDrawing=False;
}

function CopyMessage (out HUDLocalizedMessage M1, HUDLocalizedMessage M2)
{
	M1.Message=M2.Message;
	M1.Switch=M2.Switch;
	M1.RelatedPRI=M2.RelatedPRI;
	M1.OptionalObject=M2.OptionalObject;
	M1.EndOfLife=M2.EndOfLife;
	M1.StringMessage=M2.StringMessage;
	M1.DrawColor=M2.DrawColor;
	M1.XL=M2.XL;
	M1.YL=M2.YL;
	M1.YPos=M2.YPos;
	M1.bDrawing=M2.bDrawing;
	M1.Lifetime=M2.Lifetime;
	M1.numLines=M2.numLines;
}

simulated event WorldSpaceOverlays ()
{
	if ( bShowDebugInfo && (Pawn(PlayerOwner.ViewTarget) != None) )
	{
		DrawRoute();
	}
}

event RenderFirstPersonGun (Canvas Canvas)
{
	local Pawn P;

	if (  !PlayerOwner.bBehindView )
	{
		P=Pawn(PlayerOwner.ViewTarget);
		if ( (P != None) && (P.EngineWeapon != None) )
		{
			P.EngineWeapon.RenderOverlays(Canvas);
		}
	}
}

simulated event PostFadeRender (Canvas Canvas);

simulated event PostRender (Canvas Canvas)
{
	local HUD H;
	local float YL;
	local float YPos;
	local Pawn P;

	DisplayMessages(Canvas);
	if (  !bHideCenterMessages && (PlayerOwner.ProgressTimeOut > Level.TimeSeconds) )
	{
		DisplayProgressMessage(Canvas);
	}
	if ( bBadConnectionAlert )
	{
		DisplayBadConnectionAlert();
	}
	if ( bShowDebugInfo )
	{
		YPos=5.00;
		UseSmallFont(Canvas);
		PlayerOwner.ViewTarget.DisplayDebug(Canvas,YL,YPos);
	}
	else
	{
		for (H=self;H != None;H=H.nextHUD)
		{
			H.DrawHUD(Canvas);
		}
	}
}

simulated function DrawRoute ()
{
	local int i;
	local Controller C;
	local Vector Start;
	local Vector End;
	local Vector RealStart;
	local bool bPath;

	C=Pawn(PlayerOwner.ViewTarget).Controller;
	if ( C == None )
	{
		return;
	}
	if ( C.CurrentPath != None )
	{
		Start=C.CurrentPath.Start.Location;
	}
	else
	{
		Start=PlayerOwner.ViewTarget.Location;
	}
	RealStart=Start;
	if ( C.bAdjusting )
	{
		Draw3DLine(C.Pawn.Location,C.AdjustLoc,Class'Canvas'.static.MakeColor(255,0,255));
		Start=C.AdjustLoc;
	}
	if ( (C == PlayerOwner) || (C.MoveTarget == C.RouteCache[0]) && (C.MoveTarget != None) )
	{
		if ( (C == PlayerOwner) && (C.Destination != vect(0.00,0.00,0.00)) )
		{
			if ( C.pointReachable(C.Destination) )
			{
				Draw3DLine(C.Pawn.Location,C.Destination,Class'Canvas'.static.MakeColor(255,255,255));
				return;
			}
			C.FindPathTo(C.Destination);
		}
		for (i=0;i < 16;i++)
		{
			if ( C.RouteCache[i] == None )
			{
				break;
			}
			bPath=True;
			Draw3DLine(Start,C.RouteCache[i].Location,Class'Canvas'.static.MakeColor(0,255,0));
			Start=C.RouteCache[i].Location;
		}
		if ( bPath )
		{
			Draw3DLine(RealStart,C.Destination,Class'Canvas'.static.MakeColor(255,255,255));
		}
	}
	else
	{
		if ( PlayerOwner.ViewTarget.Velocity != vect(0.00,0.00,0.00) )
		{
			Draw3DLine(RealStart,C.Destination,Class'Canvas'.static.MakeColor(255,255,255));
		}
	}
	if ( C == PlayerOwner )
	{
		return;
	}
	if ( C.Focus != None )
	{
		End=C.Focus.Location;
	}
	else
	{
		End=C.FocalPoint;
	}
}

function DrawHUD (Canvas Canvas);

simulated function DisplayProgressMessage (Canvas Canvas)
{
	local int i;
	local float XL;
	local float YL;
	local float YOffset;
	local GameReplicationInfo GRI;

	PlayerOwner.ProgressTimeOut=FMin(PlayerOwner.ProgressTimeOut,Level.TimeSeconds + 8);
	Canvas.Style=5;
	Canvas.Font=m_FontRainbow6_22pt;
	if ( Canvas.Font == None )
	{
		UseLargeFont(Canvas);
	}
	YOffset=0.30 * Canvas.ClipY;
	for (i=0;i < 4;i++)
	{
		Canvas.DrawColor=PlayerOwner.ProgressColor[i];
		Canvas.StrLen(PlayerOwner.ProgressMessage[i],XL,YL);
		Canvas.SetPos(0.50 * (Canvas.ClipX - XL),YOffset);
		Canvas.DrawText(PlayerOwner.ProgressMessage[i],False);
		YOffset += YL + 1;
	}
	Canvas.SetDrawColor(255,255,255);
}

function DisplayBadConnectionAlert ();

simulated function Message (PlayerReplicationInfo PRI, coerce string Msg, name MsgType)
{
	if ( (MsgType == 'Say') || (MsgType == 'TeamSay') )
	{
		Msg=PRI.PlayerName $ ": " $ Msg;
	}
	AddTextMessage(Msg,Class'LocalMessage');
}

simulated function LocalizedMessage (Class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject, optional string CriticalString);

simulated function PlayReceivedMessage (string S, string PName, ZoneInfo PZone)
{
	PlayerOwner.ClientMessage(S);
}

function bool ProcessKeyEvent (int Key, int Action, float Delta)
{
	if ( nextHUD != None )
	{
		return nextHUD.ProcessKeyEvent(Key,Action,Delta);
	}
	return False;
}

function DisplayMessages (Canvas Canvas)
{
}

function AddTextMessage (string M, Class<LocalMessage> MessageClass)
{
	local int i;
	local int iLifeTime;

	if (  !PlayerOwner.ShouldDisplayIncomingMessages() )
	{
		return;
	}
	iLifeTime=MessageClass.Default.Lifetime + 2;
	Class'Actor'.static.AddMessageToConsole(M,m_ChatMessagesColor);
	for (i=0;i < 6;i++)
	{
		if ( TextMessages[i] == "" )
		{
			TextMessages[i]=M;
			MessageLife[i]=iLifeTime;
			return;
		}
	}
	for (i=0;i < 6 - 1;i++)
	{
		TextMessages[i]=TextMessages[i + 1];
		MessageLife[i]=MessageLife[i + 1];
	}
	TextMessages[6 - 1]=M;
	MessageLife[6 - 1]=iLifeTime;
}

function AddDeathTextMessage (string M, Class<LocalMessage> MessageClass)
{
	local int i;

	if ( (Level.NetMode != 0) &&  !PlayerOwner.ShouldDisplayIncomingMessages() )
	{
		return;
	}
	Class'Actor'.static.AddMessageToConsole(M,m_KillMessagesColor);
	for (i=0;i < 4;i++)
	{
		if ( TextKillMessages[i] == "" )
		{
			TextKillMessages[i]=M;
			MessageKillLife[i]=MessageClass.Default.Lifetime;
			return;
		}
	}
	for (i=0;i < 4 - 1;i++)
	{
		TextKillMessages[i]=TextKillMessages[i + 1];
		MessageKillLife[i]=MessageKillLife[i + 1];
	}
	TextKillMessages[4 - 1]=M;
	MessageKillLife[4 - 1]=MessageClass.Default.Lifetime;
}

function AddTextServerMessage (string M, Class<LocalMessage> MessageClass, optional int iLifeTime)
{
	local int i;

	Class'Actor'.static.AddMessageToConsole(M,m_ServerMessagesColor);
	for (i=0;i < 3;i++)
	{
		if ( TextServerMessages[i] == "" )
		{
			TextServerMessages[i]=M;
			if ( iLifeTime <= 0 )
			{
				MessageServerLife[i]=MessageClass.Default.Lifetime;
			}
			else
			{
				MessageServerLife[i]=iLifeTime;
			}
			return;
		}
	}
	for (i=0;i < 3 - 1;i++)
	{
		TextServerMessages[i]=TextServerMessages[i + 1];
		MessageServerLife[i]=MessageServerLife[i + 1];
	}
	TextServerMessages[3 - 1]=M;
	MessageServerLife[3 - 1]=MessageClass.Default.Lifetime;
}

function UseSmallFont (Canvas Canvas)
{
	if ( Canvas.ClipX <= 640 )
	{
		Canvas.Font=SmallFont;
	}
	else
	{
		Canvas.Font=MedFont;
	}
}

function UseMediumFont (Canvas Canvas)
{
	if ( Canvas.ClipX <= 640 )
	{
		Canvas.Font=MedFont;
	}
	else
	{
		Canvas.Font=BigFont;
	}
}

function UseLargeFont (Canvas Canvas)
{
	if ( Canvas.ClipX <= 640 )
	{
		Canvas.Font=BigFont;
	}
	else
	{
		Canvas.Font=LargeFont;
	}
}

function UseHugeFont (Canvas Canvas)
{
	Canvas.Font=LargeFont;
}

defaultproperties
{
    m_ChatMessagesColor=(R=255,G=255,B=255,A=255)
    m_KillMessagesColor=(R=128,G=128,B=255,A=255)
    m_ServerMessagesColor=(R=128,G=255,B=128,A=255)
    LoadingMessage="LOADING"
    SavingMessage="SAVING"
    ConnectingMessage="CONNECTING"
    PausedMessage="PAUSED"
    RemoteRole=ROLE_None
    bHidden=True
}
