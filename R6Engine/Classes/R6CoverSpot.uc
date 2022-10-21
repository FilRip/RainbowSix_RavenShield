//================================================================================
// R6CoverSpot.
//================================================================================
class R6CoverSpot extends NavigationPoint
	Native;

enum ECoverShotDir {
	COVERDIR_Over,
	COVERDIR_Left,
	COVERDIR_Right
};

var() ECoverShotDir m_eShotDir;
const C_iPawnPeekingRadius= 60;
const C_iPawnRadius= 40;

defaultproperties
{
    bDirectional=True
    bObsolete=True
}
/*
    Texture=Texture'R6Engine_T.Icons.CoverSpot'
*/

