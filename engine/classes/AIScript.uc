//================================================================================
// AIScript.
//================================================================================
class AIScript extends Keypoint
	Native;

var bool bNavigate;
var bool bLoggingEnabled;
var AIMarker myMarker;
var() Class<AIController> ControllerClass;

function SpawnControllerFor (Pawn P)
{
	local AIController C;

	if ( ControllerClass == None )
	{
		if ( P.ControllerClass == None )
		{
			return;
		}
		C=Spawn(P.ControllerClass);
	}
	else
	{
		C=Spawn(ControllerClass);
	}
	C.MyScript=self;
	C.Possess(P);
}

function Actor GetMoveTarget ()
{
	if ( myMarker != None )
	{
		return myMarker;
	}
	return self;
}

function TakeOver (Pawn P);
