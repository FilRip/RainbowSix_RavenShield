//================================================================================
// MatObject.
//================================================================================
class MatObject extends Object
	Native
	Abstract;
//	Export;

struct Orientation
{
	var() ECamOrientation CamOrientation;
	var() Actor LookAt;
	var() float EaseIntime;
	var() int bReversePitch;
	var() int bReverseYaw;
	var() int bReverseRoll;
	var int MA;
	var float PctInStart;
	var float PctInEnd;
	var float PctInDuration;
	var Rotator StartingRotation;
};

