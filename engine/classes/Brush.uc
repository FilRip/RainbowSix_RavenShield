//================================================================================
// Brush.
//================================================================================
class Brush extends Actor
	Native;
//	NoNativeReplication;

enum ECsgOper {
	CSG_Active,
	CSG_Add,
	CSG_Subtract,
	CSG_Intersect,
	CSG_Deintersect
};

var() ECsgOper CsgOper;
var() int PolyFlags;
var() bool bColored;
var const Object UnusedLightMesh;
var Vector PostPivot;
var Scale MainScale;
var Scale PostScale;
var Scale TempScale;
var() Color BrushColor;

defaultproperties
{
    MainScale=(Scale=(X=0.00,Y=1.00,Z=1.00),SheerRate=1.00,SheerAxis=SHEER_None)
    PostScale=(Scale=(X=0.00,Y=1.00,Z=1.00),SheerRate=1.00,SheerAxis=SHEER_None)
    TempScale=(Scale=(X=0.00,Y=1.00,Z=1.00),SheerRate=1.00,SheerAxis=SHEER_None)
    DrawType=3
    bStatic=True
    bHidden=True
    bNoDelete=True
    bFixedRotationDir=True
    bEdShouldSnap=True
}