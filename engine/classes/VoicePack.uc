//================================================================================
// VoicePack.
//================================================================================
class VoicePack extends Info
	Abstract;

function ClientInitialize (PlayerReplicationInfo Sender, PlayerReplicationInfo Recipient, name messagetype, byte messageIndex);

function PlayerSpeech (name type, int Index, int Callsign);

static function byte GetMessageIndex (name PhraseName)
{
	return 0;
}

defaultproperties
{
    RemoteRole=Role_None
    LifeSpan=10.00
}