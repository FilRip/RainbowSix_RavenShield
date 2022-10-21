//================================================================================
// DecorationList.
//================================================================================
class DecorationList extends Keypoint
	Native;

struct DecorationType
{
	var() StaticMesh StaticMesh;
	var() Range Count;
	var() Range DrawScale;
	var() int bAlign;
	var() int bRandomPitch;
	var() int bRandomYaw;
	var() int bRandomRoll;
};

var(List) array<DecorationType> Decorations;


defaultproperties
{
}
/*
    Texture=Texture'S_DecorationList'
*/

