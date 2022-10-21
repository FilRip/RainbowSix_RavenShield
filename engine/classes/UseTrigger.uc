//================================================================================
// UseTrigger.
//================================================================================
class UseTrigger extends Triggers;
//	Localized;

var() localized string Message;

function UsedBy (Pawn User)
{
	TriggerEvent(Event,self,User);
}

function Touch (Actor Other)
{
	if ( (Message != "") && (Other.Instigator != None) )
	{
		Other.Instigator.ClientMessage(Message);
	}
}
