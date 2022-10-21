//================================================================================
// Vehicle.
//================================================================================
class Vehicle extends Pawn
	Native
	Abstract;
//	NoNativeReplication;

var int NumParts;
var bool bActivated;
var bool bUpdating;
var VehiclePart VehicleParts[16];
var Class<VehiclePart> PartClass[16];
var Vector PartOffset[16];

function PostBeginPlay ()
{
	local int i;
	local Vector RotX;
	local Vector RotY;
	local Vector RotZ;

	Super.PostBeginPlay();
	GetAxes(Rotation,RotX,RotY,RotZ);
	i=0;
JL0023:
	if ( i < 16 )
	{
		if ( PartClass[i] != None )
		{
			VehicleParts[i]=Spawn(PartClass[i],self,,Location + PartOffset[i].X * RotX + PartOffset[i].Y * RotY + PartOffset[i].Z * RotZ);
			if ( VehicleParts[i] == None )
			{
				Log("WARNING - " $ string(PartClass[i]) $ " failed to spawn for " $ string(self));
			}
			VehicleParts[i].SetRotation(Rotation);
			VehicleParts[i].SetBase(self);
			NumParts++;
		}
		else
		{
			goto JL0139;
		}
		i++;
		goto JL0023;
	}
JL0139:
}

simulated function bool PointOfView ()
{
	return True;
}

function Tick (float DeltaTime)
{
	local int i;

	bUpdating=False;
	i=0;
JL000F:
	if ( i < NumParts )
	{
		if ( (VehicleParts[i] != None) && VehicleParts[i].bUpdating )
		{
			VehicleParts[i].Update(DeltaTime);
			bUpdating=True;
		}
		i++;
		goto JL000F;
	}
	if ( bUpdating )
	{
		if ( Physics == PHYS_None )
		{
			SetPhysics(PHYS_Rotating);
		}
	}
}

auto state Startup
{
	function Tick (float DeltaTime)
	{
		local int i;
	
		bUpdating=False;
		i=0;
	JL000F:
		if ( i < NumParts )
		{
			if ( (VehicleParts[i] != None) && VehicleParts[i].bUpdating )
			{
				VehicleParts[i].Update(DeltaTime);
				bUpdating=True;
			}
			i++;
			goto JL000F;
		}
	}
	
Begin:
	GotoState('None');
}

defaultproperties
{
    ControllerClass=None
    Physics=4
    bOwnerNoSee=False
}