//================================================================================
// BroadcastHandler.
//================================================================================
class BroadcastHandler extends Info;

var int SentText;
var config bool bMuteSpectators;

function UpdateSentText ()
{
	SentText=0;
}

function bool AllowsBroadcast (Actor broadcaster, int Len)
{
	if ( bMuteSpectators && (PlayerController(broadcaster) != None) && PlayerController(broadcaster).bOnlySpectator )
	{
		return False;
	}
	SentText += Len;
	return SentText < 260;
}

function BroadcastText (PlayerReplicationInfo SenderPRI, PlayerController Receiver, coerce string Msg, optional name type)
{
	Receiver.TeamMessage(SenderPRI,Msg,type);
}

function BroadcastLocalized (Actor Sender, PlayerController Receiver, Class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	Receiver.ReceiveLocalizedMessage(Message,Switch,RelatedPRI_1,RelatedPRI_2,OptionalObject);
}

function Broadcast (Actor Sender, coerce string Msg, optional name type)
{
	local PlayerController P;
	local PlayerReplicationInfo PRI;

	if (  !AllowsBroadcast(Sender,Len(Msg)) )
	{
		return;
	}
	if ( Pawn(Sender) != None )
	{
		PRI=Pawn(Sender).PlayerReplicationInfo;
	}
	else
	{
		if ( Controller(Sender) != None )
		{
			PRI=Controller(Sender).PlayerReplicationInfo;
		}
	}
	foreach DynamicActors(Class'PlayerController',P)
	{
		BroadcastText(PRI,P,Msg,type);
	}
}

function BroadcastTeam (Actor Sender, coerce string Msg, optional name type)
{
	local PlayerController P;
	local PlayerReplicationInfo PRI;

	if ( Pawn(Sender) != None )
	{
		PRI=Pawn(Sender).PlayerReplicationInfo;
	}
	else
	{
		if ( Controller(Sender) != None )
		{
			PRI=Controller(Sender).PlayerReplicationInfo;
		}
	}
	foreach DynamicActors(Class'PlayerController',P)
	{
		if ( P.PlayerReplicationInfo.TeamID == PRI.TeamID )
		{
			BroadcastText(PRI,P,Msg,type);
		}
	}
}

event AllowBroadcastLocalized (Actor Sender, Class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	local PlayerController P;

	foreach DynamicActors(Class'PlayerController',P)
	{
		BroadcastLocalized(Sender,P,Message,Switch,RelatedPRI_1,RelatedPRI_2,OptionalObject);
	}
}
