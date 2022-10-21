//================================================================================
// CubeBuilder.
//================================================================================
class CubeBuilder extends BrushBuilder;

var() bool Hollow;
var() bool Tessellated;
var() float Height;
var() float Width;
var() float Breadth;
var() float WallThickness;
var() name GroupName;

function BuildCube (int direction, float dx, float dy, float dz, bool _tessellated)
{
	local int N;
	local int i;
	local int j;
	local int k;

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
	if ( _tessellated )
	{
		Poly3i(direction,N + 0,N + 1,N + 3);
		Poly3i(direction,N + 0,N + 3,N + 2);
		Poly3i(direction,N + 2,N + 3,N + 7);
		Poly3i(direction,N + 2,N + 7,N + 6);
		Poly3i(direction,N + 6,N + 7,N + 5);
		Poly3i(direction,N + 6,N + 5,N + 4);
		Poly3i(direction,N + 4,N + 5,N + 1);
		Poly3i(direction,N + 4,N + 1,N + 0);
		Poly3i(direction,N + 3,N + 1,N + 5);
		Poly3i(direction,N + 3,N + 5,N + 7);
		Poly3i(direction,N + 0,N + 2,N + 6);
		Poly3i(direction,N + 0,N + 6,N + 4);
	}
	else
	{
		Poly4i(direction,N + 0,N + 1,N + 3,N + 2);
		Poly4i(direction,N + 2,N + 3,N + 7,N + 6);
		Poly4i(direction,N + 6,N + 7,N + 5,N + 4);
		Poly4i(direction,N + 4,N + 5,N + 1,N + 0);
		Poly4i(direction,N + 3,N + 1,N + 5,N + 7);
		Poly4i(direction,N + 0,N + 2,N + 6,N + 4);
	}
}

event bool Build ()
{
	if ( (Height <= 0) || (Width <= 0) || (Breadth <= 0) )
	{
		return BadParameters();
	}
	if ( Hollow && ((Height <= WallThickness) || (Width <= WallThickness) || (Breadth <= WallThickness)) )
	{
		return BadParameters();
	}
	if ( Hollow && Tessellated )
	{
		return BadParameters("The 'Tessellated' option can't be specified with the 'Hollow' option.");
	}
	BeginBrush(False,GroupName);
	BuildCube(1,Breadth,Width,Height,Tessellated);
	if ( Hollow )
	{
		BuildCube(-1,Breadth - WallThickness,Width - WallThickness,Height - WallThickness,Tessellated);
	}
	return EndBrush();
}

defaultproperties
{
    Height=256.00
    Width=256.00
    Breadth=256.00
    WallThickness=16.00
    GroupName=Cube
    BitmapFilename="BBCube"
    ToolTip="Cube"
}