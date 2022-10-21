//================================================================================
// VehiclePart.
//================================================================================
class VehiclePart extends Actor
	Native
	Abstract
//	NoNativeReplication
	Placeable;

var bool bUpdating;

function Update (float DeltaTime);

function Activate (bool bActive);
