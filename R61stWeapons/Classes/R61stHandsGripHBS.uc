//================================================================================
// R61stHandsGripHBS.
//================================================================================
class R61stHandsGripHBS extends R6AbstractFirstPersonHands;

function PostBeginPlay ()
{
//	LinkSkelAnim(MeshAnimation'R61stHandsGripHBSA');
	Super.PostBeginPlay();
}

auto state Waiting
{
}

state RaiseWeapon
{
	simulated event AnimEnd (int Channel)
	{
		SetDrawType(DT_None);
		Super.AnimEnd(Channel);
	}

}

state BringWeaponUp
{
	simulated event AnimEnd (int Channel)
	{
		SetDrawType(DT_None);
		Super.AnimEnd(Channel);
	}

}

state DiscardWeapon
{
	simulated function BeginState ()
	{
		SetDrawType(DT_Mesh);
		Super.BeginState();
	}

}

state PutWeaponDown
{
	simulated function BeginState ()
	{
		SetDrawType(DT_Mesh);
		Super.BeginState();
	}

}

defaultproperties
{
    DrawType=0
}
/*
    Mesh=SkeletalMesh'R61stHands_UKX.R61stHands'
*/

