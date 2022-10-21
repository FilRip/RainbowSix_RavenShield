//================================================================================
// ActionMoveCamera.
//================================================================================
class ActionMoveCamera extends MatAction
	native;

enum EPathStyle {
	PATHSTYLE_Linear,
	PATHSTYLE_Bezier
};

var(Path) config EPathStyle PathStyle;

defaultproperties
{
}
//    Palette=0
