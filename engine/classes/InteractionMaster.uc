//================================================================================
// InteractionMaster.
//================================================================================
class InteractionMaster extends Interactions
	Native
	Transient;

var R6StartGameInfo m_StartGameInfo;
var R6GameMenuCom m_MenuCommunication;
var transient Client Client;
var const transient Interaction BaseMenu;
var const transient Interaction Console;
var transient array<Interaction> GlobalInteractions;

native function Travel (string URL);

event Interaction AddInteraction (string InteractionName, optional Player AttachTo)
{
	local Interaction NewInteraction;
	local Class<Interaction> NewInteractionClass;

	NewInteractionClass=Class<Interaction>(DynamicLoadObject(InteractionName,Class'Class'));
	if ( NewInteractionClass != None )
	{
		NewInteraction=new NewInteractionClass;
		if ( NewInteraction != None )
		{
			if ( AttachTo != None )
			{
				AttachTo.LocalInteractions.Length=AttachTo.LocalInteractions.Length + 1;
				AttachTo.LocalInteractions[AttachTo.LocalInteractions.Length - 1]=NewInteraction;
				NewInteraction.ViewportOwner=AttachTo;
			}
			else
			{
				GlobalInteractions.Length=GlobalInteractions.Length + 1;
				GlobalInteractions[GlobalInteractions.Length - 1]=NewInteraction;
			}
			NewInteraction.Initialize();
			NewInteraction.Master=self;
			return NewInteraction;
		}
		else
		{
			Log("Could not create interaction [" $ InteractionName $ "]",'IMaster');
		}
	}
	else
	{
		Log("Could not load interaction [" $ InteractionName $ "]",'IMaster');
	}
	return None;
}

event RemoveInteraction (Interaction RemoveMe)
{
	local int Index;
	local array<Interaction> InteractionArray;

	if ( RemoveMe.ViewportOwner != None )
	{
		Index=0;
JL001B:
		if ( Index < RemoveMe.ViewportOwner.LocalInteractions.Length )
		{
			if ( RemoveMe.ViewportOwner.LocalInteractions[Index] == RemoveMe )
			{
				RemoveMe.ViewportOwner.LocalInteractions.Remove (Index,1);
				return;
			}
			Index++;
			goto JL001B;
		}
	}
	else
	{
		Index=0;
JL0098:
		if ( Index < GlobalInteractions.Length )
		{
			if ( GlobalInteractions[Index] == RemoveMe )
			{
				GlobalInteractions.Remove (Index,1);
				return;
			}
			Index++;
			goto JL0098;
		}
	}
	Log("Could not remove interaction [" $ string(RemoveMe) $ "] (Not Found)",'IMaster');
}

event SetFocusTo (Interaction Inter, optional Player ViewportOwner)
{
	local array<Interaction> InteractionArray;
	local Interaction temp;
	local int i;
	local int iIndex;

	if ( ViewportOwner != None )
	{
		InteractionArray=ViewportOwner.LocalInteractions;
	}
	else
	{
		InteractionArray=GlobalInteractions;
	}
	if ( InteractionArray.Length == 0 )
	{
		Log("Attempt to SetFocus on an empty Array.",'IMaster');
		return;
	}
	iIndex=-1;
	i=0;
JL007C:
	if ( i < InteractionArray.Length )
	{
		if ( InteractionArray[i] == Inter )
		{
			iIndex=i;
		}
		else
		{
			i++;
			goto JL007C;
		}
	}
	if ( iIndex < 0 )
	{
		Log("Interaction " $ string(Inter) $ " is not in " $ string(ViewportOwner) $ ".",'IMaster');
		return;
	}
	else
	{
		if ( iIndex == 0 )
		{
			return;
		}
	}
	temp=InteractionArray[iIndex];
	i=0;
JL0129:
	if ( i < iIndex )
	{
		InteractionArray[i + 1]=InteractionArray[i];
		i++;
		goto JL0129;
	}
	InteractionArray[0]=temp;
	InteractionArray[0].bActive=True;
	InteractionArray[0].bVisible=True;
}

event bool Process_KeyType (array<Interaction> InteractionArray, out EInputKey Key)
{
	local int Index;

	Index=0;
JL0007:
	if ( Index < InteractionArray.Length )
	{
		if ( InteractionArray[Index].bActive && InteractionArray[Index].KeyType(Key) )
		{
			return True;
		}
		Index++;
		goto JL0007;
	}
	return False;
}

event bool Process_KeyEvent (array<Interaction> InteractionArray, out EInputKey Key, out EInputAction Action, float Delta)
{
	local int Index;

	Index=0;
JL0007:
	if ( Index < InteractionArray.Length )
	{
		if ( InteractionArray[Index].bActive && InteractionArray[Index].KeyEvent(Key,Action,Delta) )
		{
			return True;
		}
		Index++;
		goto JL0007;
	}
	return False;
}

event Process_PreRender (array<Interaction> InteractionArray, Canvas Canvas)
{
	local int Index;

	Index=InteractionArray.Length;
JL000C:
	if ( Index > 0 )
	{
		if ( InteractionArray[Index - 1].bVisible )
		{
			InteractionArray[Index - 1].PreRender(Canvas);
		}
		Index--;
		goto JL000C;
	}
}

event Process_PostRender (array<Interaction> InteractionArray, Canvas Canvas)
{
	local int Index;

	Index=InteractionArray.Length;
JL000C:
	if ( Index > 0 )
	{
		InteractionArray[Index - 1].PostRender(Canvas);
		Index--;
		goto JL000C;
	}
}

event Process_Tick (array<Interaction> InteractionArray, float DeltaTime)
{
	local int Index;

	Index=0;
JL0007:
	if ( Index < InteractionArray.Length )
	{
		if ( InteractionArray[Index].bRequiresTick )
		{
			InteractionArray[Index].Tick(DeltaTime);
		}
		Index++;
		goto JL0007;
	}
}

event Process_Message (coerce string Msg, float MsgLife, array<Interaction> InteractionArray)
{
	local int Index;

	Index=0;
JL0007:
	if ( Index < InteractionArray.Length )
	{
		InteractionArray[Index].Message(Msg,MsgLife);
		Index++;
		goto JL0007;
	}
}
