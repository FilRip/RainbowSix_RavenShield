//================================================================================
// EditorEngine.
//================================================================================
class EditorEngine extends Engine
	Native;

var const Level Level;
var const Model TempModel;
var const Texture CurrentTexture;
var const StaticMesh CurrentStaticMesh;
var const Mesh CurrentMesh;
var const Class CurrentClass;
var const TransBuffer Trans;
var const TextBuffer Results;
var const int Pad[8];
var const Texture Bad;
var const Texture Bkgnd;
var const Texture BkgndHi;
var const Texture BadHighlight;
var const Texture MaterialArrow;
var const Texture MaterialBackdrop;
var StaticMesh TexPropCube;
var StaticMesh TexPropSphere;
var const bool bFastRebuild;
var const bool bBootstrapping;
var const config int AutoSaveIndex;
var const int AutoSaveCount;
var const int Mode;
var const int TerrainEditBrush;
var const int ClickFlags;
var const float MovementSpeed;
var const Package PackageContext;
var const Vector AddLocation;
var const Plane AddPlane;
var const array<Object> Tools;
var const Class BrowseClass;
var const int ConstraintsVtbl;
var(Grid) config bool GridEnabled;
var(Grid) config bool SnapVertices;
var(Grid) config float SnapDistance;
var(Grid) config Vector GridSize;
var(RotationGrid) config bool RotGridEnabled;
var(RotationGrid) config Rotator RotGridSize;
var(Advanced) config bool UseSizingBox;
var(Advanced) config bool UseAxisIndicator;
var(Advanced) config float FovAngleDegrees;
var(Advanced) config bool GodMode;
var(Advanced) config bool AutoSave;
var(Advanced) config byte AutosaveTimeMinutes;
var(Advanced) config string GameCommandLine;
var(Advanced) config array<string> EditPackages;
var(Advanced) config bool AlwaysShowTerrain;
var(Advanced) config bool UseActorRotationGizmo;
var(Advanced) config bool LoadEntirePackageWhenSaving;

defaultproperties
{
    GridEnabled=True
    SnapDistance=10.00
    GridSize=(X=16.00,Y=16.00,Z=16.00)
    RotGridEnabled=True
    RotGridSize=(Pitch=1024,Yaw=1024,Roll=1024)
    UseAxisIndicator=True
    FovAngleDegrees=90.00
    GodMode=True
    AutoSave=True
    AutosaveTimeMinutes=5
    GameCommandLine="-log"
    EditPackages(0)="Core"
	EditPackages(1)="Engine"
	EditPackages(2)="Fire"
	EditPackages(3)="Editor"
	EditPackages(4)="UWindow"
	EditPackages(5)="IpDrv"
	EditPackages(6)="Gameplay"
	EditPackages(7)="R6SFX"
	EditPackages(8)="R6Abstract"
	EditPackages(9)="R6Engine"
	EditPackages(10)="R6Characters"
	EditPackages(11)="R61stWeapons"
	EditPackages(12)="R6Weapons"
	EditPackages(13)="R6WeaponGadgets"
	EditPackages(14)="R63rdWeapons"
	EditPackages(15)="R6Description"
	EditPackages(16)="R6GameService"
	EditPackages(17)="R6Game"
	EditPackages(18)="R6Window"
	EditPackages(19)="R6Menu"
	EditPackages(20)="UnrealEd"
    AlwaysShowTerrain=True
    CacheSizeMegs=32
}
/*
    Bad=Texture'Bad'
    Bkgnd=Texture'Bkgnd'
    BkgndHi=Texture'BkgndHi'
    BadHighlight=Texture'BadHighlight'
    MaterialArrow=Texture'MaterialArrow'
    MaterialBackdrop=Texture'MaterialBackdrop'
    TexPropCube=StaticMesh'TexPropCube'
    TexPropSphere=StaticMesh'TexPropSphere'
*/
