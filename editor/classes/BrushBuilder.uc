//================================================================================
// BrushBuilder.
//================================================================================
class BrushBuilder extends Object
	Native
	Abstract;
//	Export;

struct BuilderPoly
{
	var array<int> VertexIndices;
	var int direction;
	var name Item;
	var int PolyFlags;
};

var private bool MergeCoplanars;
var private name Group;
var array<Vector> Vertices;
var array<BuilderPoly> Polys;
var() string BitmapFilename;
var() string ToolTip;

native function BeginBrush (bool MergeCoplanars, name Group);

native function bool EndBrush ();

native function int GetVertexCount ();

native function Vector GetVertex (int i);

native function int GetPolyCount ();

native function bool BadParameters (optional string Msg);

native function int Vertexv (Vector V);

native function int Vertex3f (float X, float Y, float Z);

native function Poly3i (int direction, int i, int j, int k, optional name ItemName, optional int PolyFlags);

native function Poly4i (int direction, int i, int j, int k, int L, optional name ItemName, optional int PolyFlags);

native function PolyBegin (int direction, optional name ItemName, optional int PolyFlags);

native function Polyi (int i);

native function PolyEnd ();

event bool Build ();

defaultproperties
{
    BitmapFilename="BBGeneric"
    ToolTip="Generic Builder"
}