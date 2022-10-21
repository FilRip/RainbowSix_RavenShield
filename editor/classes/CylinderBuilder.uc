//================================================================================
// CylinderBuilder.
//================================================================================
class CylinderBuilder extends BrushBuilder;

var() int Sides;
var() bool AlignToSide;
var() bool Hollow;
var() float Height;
var() float OuterRadius;
var() float InnerRadius;
var() name GroupName;

function BuildCylinder (int direction, bool AlignToSide, int Sides, float Height, float Radius)
{
	local int N;
	local int i;
	local int j;
	local int q;
	local int Ofs;

	N=GetVertexCount();
	if ( AlignToSide )
	{
		Radius /= Cos(3.14 / Sides);
		Ofs=1;
	}
	i=0;
	while ( i < Sides )
	{
		j=-1;
		while ( j < 2 )
		{
			Vertex3f(Radius * Sin((2.00 * i + Ofs) * 3.14 / Sides),Radius * Cos((2.00 * i + Ofs) * 3.14 / Sides),j * Height / 2);
			j += 2;
		}
		i++;
	}
	i=0;
	while ( i < Sides )
	{
		Poly4i(direction,N + i * 2,N + i * 2 + 1,N + (i * 2 + 3) % 2 * Sides,N + (i * 2 + 2) % 2 * Sides,'Wall');
		i++;
	}
}

function bool Build ()
{
	local int i;
	local int j;
	local int k;

	if ( Sides < 3 )
	{
		return BadParameters();
	}
	if ( (Height <= 0) || (OuterRadius <= 0) )
	{
		return BadParameters();
	}
	if ( Hollow && ((InnerRadius <= 0) || (InnerRadius >= OuterRadius)) )
	{
		return BadParameters();
	}
	BeginBrush(False,GroupName);
	BuildCylinder(1,AlignToSide,Sides,Height,OuterRadius);
	if ( Hollow )
	{
		BuildCylinder(-1,AlignToSide,Sides,Height,InnerRadius);
		j=-1;
		while ( j < 2 )
		{
			i=0;
			while ( i < Sides )
			{
				Poly4i(j,i * 2 + (1 - j) / 2,((i + 1) % Sides) * 2 + (1 - j) / 2,((i + 1) % Sides) * 2 + (1 - j) / 2 + Sides * 2,i * 2 + (1 - j) / 2 + Sides * 2,'Cap');
				i++;
			}
			j += 2;
		}
	}
	else
	{
		j=-1;
		while ( j < 2 )
		{
			PolyBegin(j,'Cap');
			i=0;
			while ( i < Sides )
			{
				Polyi(i * 2 + (1 - j) / 2);
				i++;
			}
			PolyEnd();
			j += 2;
		}
	}
	return EndBrush();
}

defaultproperties
{
    Sides=8
    AlignToSide=True
    Height=256.00
    OuterRadius=512.00
    InnerRadius=384.00
    GroupName=Cylinder
    BitmapFilename="BBCylinder"
    ToolTip="Cylinder"
}