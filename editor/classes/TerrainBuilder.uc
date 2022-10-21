//================================================================================
// TerrainBuilder.
//================================================================================
class TerrainBuilder extends BrushBuilder;

var() int WidthSegments;
var() int DepthSegments;
var() float Height;
var() float Width;
var() float Breadth;
var() name GroupName;

function BuildTerrain (int direction, float dx, float dy, float dz, int WidthSeg, int DepthSeg)
{
	local int N;
	local int nbottom;
	local int ntop;
	local int i;
	local int j;
	local int k;
	local int X;
	local int Y;
	local int idx;
	local float WidthStep;
	local float DepthStep;

	N=GetVertexCount();
	i=-1;
	while ( i < 2 )
	{
		j=-1;
		while ( j < 2 )
		{
			k=-1;
			while ( k < 2 )
			{
				Vertex3f(i * dx / 2,j * dy / 2,k * dz / 2);
				k += 2;
			}
			j += 2;
		}
		i += 2;
	}
	Poly4i(direction,N + 3,N + 1,N + 5,N + 7,'sky');
	nbottom=GetVertexCount();
	WidthStep=dx / WidthSeg;
	DepthStep=dy / DepthSeg;
	X=0;
	while ( X < WidthSeg + 1 )
	{
		Y=0;
		while ( Y < DepthSeg + 1 )
		{
			Vertex3f(WidthStep * X - dx / 2,DepthStep * Y - dy / 2, -dz / 2);
			Y++;
		}
		X++;
	}
	ntop=GetVertexCount();
	X=0;
	while ( X < WidthSeg + 1 )
	{
		Y=0;
		while ( Y < DepthSeg + 1 )
		{
			Vertex3f(WidthStep * X - dx / 2,DepthStep * Y - dy / 2,dz / 2);
			Y++;
		}
		X++;
	}
	X=0;
	while ( X < WidthSeg )
	{
		Y=0;
		while ( Y < DepthSeg )
		{
			Poly3i( -direction,nbottom + Y + (DepthSeg + 1) * X,nbottom + Y + (DepthSeg + 1) * (X + 1),nbottom + 1 + Y + (DepthSeg + 1) * (X + 1),'ground');
			Poly3i( -direction,nbottom + Y + (DepthSeg + 1) * X,nbottom + 1 + Y + (DepthSeg + 1) * (X + 1),nbottom + 1 + Y + (DepthSeg + 1) * X,'ground');
			Y++;
		}
		X++;
	}
	X=0;
	while ( X < WidthSeg )
	{
		Poly4i( -direction,nbottom + DepthSeg + (DepthSeg + 1) * X,nbottom + DepthSeg + (DepthSeg + 1) * (X + 1),ntop + DepthSeg + (DepthSeg + 1) * (X + 1),ntop + DepthSeg + (DepthSeg + 1) * X,'sky');
		Poly4i( -direction,nbottom + (DepthSeg + 1) * (X + 1),nbottom + (DepthSeg + 1) * X,ntop + (DepthSeg + 1) * X,ntop + (DepthSeg + 1) * (X + 1),'sky');
		X++;
	}
	Y=0;
	while ( Y < DepthSeg )
	{
		Poly4i( -direction,nbottom + Y,nbottom + Y + 1,ntop + Y + 1,ntop + Y,'sky');
		Poly4i( -direction,nbottom + (DepthSeg + 1) * WidthSeg + Y + 1,nbottom + (DepthSeg + 1) * WidthSeg + Y,ntop + (DepthSeg + 1) * WidthSeg + Y,ntop + (DepthSeg + 1) * WidthSeg + Y + 1,'sky');
		Y++;
	}
}

event bool Build ()
{
	if ( (Height <= 0) || (Width <= 0) || (Breadth <= 0) || (WidthSegments <= 0) || (DepthSegments <= 0) )
	{
		return BadParameters();
	}
	BeginBrush(False,GroupName);
	BuildTerrain(1,Breadth,Width,Height,WidthSegments,DepthSegments);
	return EndBrush();
}

defaultproperties
{
    WidthSegments=4
    DepthSegments=2
    Height=256.00
    Width=256.00
    Breadth=512.00
    GroupName=Terrain
    BitmapFilename="BBTerrain"
    ToolTip="BSP Based Terrain"
}