//================================================================================
// CheatManager.
//================================================================================
class CheatManager extends Object within PlayerController
	Native;
//	Export;

var bool m_bUnlockAllCheat;
var Rotator LockedRotation;

function bool CanExec ()
{
	if ( m_bUnlockAllCheat )
	{
		return True;
	}
	if ( Outer.Level.NetMode == NM_Client )
	{
		Outer.ClientErrorMessageLocalized("Exec");
		return False;
	}
	if ( Outer.Level.NetMode == NM_Standalone )
	{
		return True;
	}
	Outer.ClientErrorMessageLocalized("Exec");
	return False;
}

exec function SloMo (float t)
{
	if (  !CanExec() )
	{
		return;
	}
	Outer.Level.Game.SetGameSpeed(t);
	Outer.Level.Game.SaveConfig();
	Outer.Level.Game.GameReplicationInfo.SaveConfig();
}

exec function KillAll (Class<Actor> aClass)
{
	local Actor A;

	if (  !CanExec() )
	{
		return;
	}
	if ( ClassIsChildOf(aClass,Class'Pawn') )
	{
		KillAllPawns(Class<Pawn>(aClass));
		return;
	}
	foreach Outer.DynamicActors(Class'Actor',A)
	{
		if ( ClassIsChildOf(A.Class,aClass) )
		{
			A.Destroy();
		}
	}
}

function KillAllPawns (Class<Pawn> aClass)
{
	local Pawn P;

	foreach Outer.DynamicActors(Class'Pawn',P)
	{
		if ( ClassIsChildOf(P.Class,aClass) &&  !P.IsHumanControlled() )
		{
			if ( P.Controller != None )
			{
				P.Controller.Destroy();
			}
			P.Destroy();
		}
	}
}

exec function ViewSelf (optional bool bQuiet)
{
	Outer.bBehindView=False;
	if ( Outer.Pawn != None )
	{
		Outer.SetViewTarget(Outer.Pawn);
	}
	else
	{
		Outer.SetViewTarget(Outer);
	}
	if (  !bQuiet )
	{
		Outer.ClientMessage(Outer.OwnCamera,'Event');
	}
	Outer.FixFOV();
}

exec function ViewActor (name ActorName)
{
	local Actor A;

	if (  !CanExec() )
	{
		return;
	}
	foreach Outer.AllActors(Class'Actor',A)
	{
		if ( A.Name == ActorName )
		{
			Outer.SetViewTarget(A);
			Outer.bBehindView=True;
			return;
		}
	}
}

exec function ViewClass (Class<Actor> aClass, optional bool bQuiet, optional bool bCheat)
{
	local Actor Other;
	local Actor first;
	local bool bFound;

	if (  !CanExec() )
	{
		return;
	}
	if (  !bCheat && (Outer.Level.Game != None) &&  !Outer.Level.Game.bCanViewOthers )
	{
		return;
	}
	first=None;
	foreach Outer.AllActors(aClass,Other)
	{
		if ( bFound || (first == None) )
		{
			if ( (Pawn(Other) == None) || Pawn(Other).IsAlive() )
			{
				first=Other;
				if ( bFound )
				{
					break;
				}
			}
		}
		if ( Other == Outer.ViewTarget )
		{
			bFound=True;
		}
	}
	if ( first != None )
	{
		if (  !bQuiet )
		{
			if ( Pawn(first) != None )
			{
				Outer.ClientMessage(Outer.ViewingFrom @ first.GetHumanReadableName(),'Event');
			}
			else
			{
				Outer.ClientMessage(Outer.ViewingFrom @ string(first),'Event');
			}
		}
		Outer.SetViewTarget(first);
		Outer.bBehindView=Outer.ViewTarget != Outer;
		if ( Outer.bBehindView )
		{
			Outer.ViewTarget.BecomeViewTarget();
		}
		Outer.FixFOV();
	}
	else
	{
		ViewSelf(bQuiet);
	}
}

exec event LogThis (optional bool bDontTraceActor, optional Actor anActor)
{
}
