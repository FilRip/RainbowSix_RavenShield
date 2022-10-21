//================================================================================
// MessagingSpectator.
//================================================================================
class MessagingSpectator extends PlayerController
	Abstract
//	NoNativeReplication
	Config(User);

function PostBeginPlay ()
{
	Super.PostBeginPlay();
	bIsPlayer=False;
}
