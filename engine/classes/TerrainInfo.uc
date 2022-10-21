//================================================================================
// TerrainInfo.
//================================================================================
class TerrainInfo extends Info
	Native
	NoExport
	Placeable
	ShowCategories(Movement,Collision,Lighting,LightColor,Karma,Force);

enum ESortOrder {
	SORT_NoSort,
	SORT_BackToFront,
	SORT_FrontToBack
};

enum ETexMapAxis {
	TEXMAPAXIS_XY,
	TEXMAPAXIS_XZ,
	TEXMAPAXIS_YZ
};

struct NormalPair
{
	var Vector Normal1;
	var Vector Normal2;
};

struct DecoInfo
{
	var Vector Location;
	var Rotator Rotation;
	var Vector Scale;
	var Vector TempScale;
	var Color Color;
	var int Distance;
};

struct DecoSectorInfo
{
	var array<DecoInfo> DecoInfo;
	var Vector Location;
	var float Radius;
};

struct DecorationLayerData
{
	var array<DecoSectorInfo> Sectors;
};

struct DecorationLayer
{
	var() int ShowOnTerrain;
	var() Texture ScaleMap;
	var() Texture DensityMap;
	var() Texture ColorMap;
	var() StaticMesh StaticMesh;
	var() RangeVector ScaleMultiplier;
	var() Range FadeoutRadius;
	var() Range DensityMultiplier;
	var() int MaxPerQuad;
	var() int Seed;
	var() int AlignToTerrain;
	var() ESortOrder DrawOrder;
	var() int ShowOnInvisibleTerrain;
	var() int LitDirectional;
	var() int DisregardTerrainLighting;
};

struct TerrainLayer
{
	var() Material Texture;
	var() Texture AlphaMap;
	var() float UScale;
	var() float VScale;
	var() float UPan;
	var() float VPan;
	var() ETexMapAxis TextureMapAxis;
	var() float TextureRotation;
	var() Rotator LayerRotation;
	var Matrix TerrainMatrix;
	var() float KFriction;
	var() float KRestitution;
	var Texture LayerWeightMap;
};

var() int TerrainSectorSize;
var() Texture TerrainMap;
var() Vector TerrainScale;
var() TerrainLayer Layers[32];
var() array<DecorationLayer> DecoLayers;
var() bool Inverted;
var() bool bKCollisionHalfRes;
var bool m_bNeedPlanningVBRebuild;
var transient int JustLoaded;
var const native array<DecorationLayerData> DecoLayerData;
var const native array<TerrainSector> Sectors;
var const native array<Vector> Vertices;
var const native int HeightmapX;
var const native int HeightmapY;
var const native int SectorsX;
var const native int SectorsY;
var const native TerrainPrimitive Primitive;
var const native array<NormalPair> FaceNormals;
var const native Vector ToWorld[4];
var const native Vector ToHeightmap[4];
var const native array<int> SelectedVertices;
var const native int ShowGrid;
var const array<int> QuadVisibilityBitmap;
var const array<int> EdgeTurnBitmap;
var const native array<int> RenderCombinations;
var const native array<int> VertexStreams;
var const native array<Color> VertexColors;
var const native array<Color> PaintedColor;
var const native Texture OldTerrainMap;
var const native array<byte> OldHeightmap;
var const native array<int> m_TerrainPlanningFloorsInfo;
var const native array<int> m_iTerrainPlanningLastFloor;

defaultproperties
{
    TerrainSectorSize=16
    TerrainScale=(X=64.00,Y=64.00,Z=64.00)
    m_bNeedPlanningVBRebuild=True
    bStatic=True
    bWorldGeometry=True
    bStaticLighting=True
    bBlockActors=True
}
/*
    Texture=Texture'S_TerrainInfo'
*/

