//================================================================================
// Mutator.
//================================================================================
class Mutator extends Info
	Native;

var Mutator NextMutator;
var Class<R6EngineWeapon> DefaultWeapon;
var string DefaultWeaponName;

event PreBeginPlay ()
{
}

function ModifyLogin (out string Portal, out string Options)
{
	if ( NextMutator != None )
	{
		NextMutator.ModifyLogin(Portal,Options);
	}
}

function ModifyPlayer (Pawn Other)
{
	if ( NextMutator != None )
	{
		NextMutator.ModifyPlayer(Other);
	}
}

function Class<R6EngineWeapon> GetDefaultWeapon ()
{
	local Class<R6EngineWeapon> W;

	if ( NextMutator != None )
	{
		W=NextMutator.GetDefaultWeapon();
		if ( W == None )
		{
			W=MyDefaultWeapon();
		}
	}
	else
	{
		W=MyDefaultWeapon();
	}
	return W;
}

function Class<R6EngineWeapon> MyDefaultWeapon ()
{
	if ( (DefaultWeapon == None) && (DefaultWeaponName != "") )
	{
		DefaultWeapon=Class<R6EngineWeapon>(DynamicLoadObject(DefaultWeaponName,Class'Class'));
	}
	return DefaultWeapon;
}

function AddMutator (Mutator M)
{
	if ( NextMutator == None )
	{
		NextMutator=M;
	}
	else
	{
		NextMutator.AddMutator(M);
	}
}

function bool ReplaceWith (Actor Other, string aClassName)
{
	local Actor A;
	local Class<Actor> aClass;

	if ( Other.IsA('Inventory') && (Other.Location == vect(0.00,0.00,0.00)) )
	{
		return False;
	}
	aClass=Class<Actor>(DynamicLoadObject(aClassName,Class'Class'));
	if ( aClass != None )
	{
		A=Spawn(aClass,Other.Owner,Other.Tag,Other.Location,Other.Rotation);
	}
	if ( A != None )
	{
		A.Event=Other.Event;
		A.Tag=Other.Tag;
		return True;
	}
	return False;
}

function bool AlwaysKeep (Actor Other)
{
	if ( NextMutator != None )
	{
		return NextMutator.AlwaysKeep(Other);
	}
	return False;
}

function bool IsRelevant (Actor Other, out byte bSuperRelevant)
{
	local bool bResult;

	bResult=CheckReplacement(Other,bSuperRelevant);
	if ( bResult && (NextMutator != None) )
	{
		bResult=NextMutator.IsRelevant(Other,bSuperRelevant);
	}
	return bResult;
}

function bool CheckRelevance (Actor Other)
{
	local bool bResult;
	local byte bSuperRelevant;

	if ( AlwaysKeep(Other) )
	{
		return True;
	}
	bResult=IsRelevant(Other,bSuperRelevant);
	return bResult;
}

function bool CheckReplacement (Actor Other, out byte bSuperRelevant)
{
	return True;
}

function PlayerChangedClass (Controller aPlayer)
{
	NextMutator.PlayerChangedClass(aPlayer);
}
