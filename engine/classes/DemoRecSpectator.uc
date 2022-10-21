//================================================================================
// DemoRecSpectator.
//================================================================================
class DemoRecSpectator extends MessagingSpectator
	Config(User);

var PlayerController PlaybackActor;
var GameReplicationInfo PlaybackGRI;

replication
{
	reliable if ( bDemoRecording )
		RepReceiveLocalizedMessage,RepClientVoiceMessage,RepClientMessage;
}

function ClientMessage (coerce string S, optional name type)
{
	RepClientMessage(S,type);
}

function ClientVoiceMessage (PlayerReplicationInfo Sender, PlayerReplicationInfo Recipient, name messagetype, byte MessageID)
{
	RepClientVoiceMessage(Sender,Recipient,messagetype,MessageID);
}

function ReceiveLocalizedMessage (Class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	RepReceiveLocalizedMessage(Message,Switch,RelatedPRI_1,RelatedPRI_2,OptionalObject);
}

simulated function RepClientMessage (coerce string S, optional name type)
{
}

simulated function RepClientVoiceMessage (PlayerReplicationInfo Sender, PlayerReplicationInfo Recipient, name messagetype, byte MessageID)
{
}

simulated function RepReceiveLocalizedMessage (Class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
}
