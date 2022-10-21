//================================================================================
// VolumetricBuilder.
//================================================================================
class VolumetricBuilder extends BrushBuilder;

var() int NumSheets;
var() float Height;
var() float Radius;
var() name GroupName;

function BuildVolumetric (int direction, int NumSheets, float Height, float Radius)
{
	local int N;
	local int X;
	local int Y;
	local Rotator RotStep;
	local Vector vtx;
	local Vector NewVtx;

	N=GetVertexCount();
	RotStep.Yaw=65536 / NumSheets * 2;
	vtx.X=Radius;
	vtx.Z=Height / 2;
	X=0;
	while ( X < NumSheets * 2 )
	{
		NewVtx=vtx >> RotStep * X;
		Vertex3f(NewVtx.X,NewVtx.Y,NewVtx.Z);
		Vertex3f(NewVtx.X,NewVtx.Y,NewVtx.Z - Height);
		X++;
	}
	X=0;
	while ( X < NumSheets )
	{
		Y=X * 2 + 1;
		if ( Y >= NumSheets * 2 )
		{
			Y -= NumSheets * 2;
		}
		Poly4i(direction,N + X * 2,N + Y,N + Y + NumSheets * 2,N + X * 2 + NumSheets * 2,'Sheets',264);
		X++;
	}
}

function bool Build ()
{
	if ( NumSheets < 2 )
	{
		return BadParameters();
	}
	if ( (Height <= 0) || (Radius <= 0) )
	{
		return BadParameters();
	}
	BeginBrush(True,GroupName);
	BuildVolumetric(1,NumSheets,Height,Radius);
	return EndBrush();
}

defaultproperties
{
    NumSheets=2
    Height=128.00
    Radius=64.00
    GroupName=Volumetric
    BitmapFilename="BBVolumetric"
    ToolTip="Volumetric (Torches, Chains, etc)"
}