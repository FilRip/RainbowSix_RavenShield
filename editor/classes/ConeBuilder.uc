//================================================================================
// ConeBuilder.
//================================================================================
class ConeBuilder extends BrushBuilder;

var() int Sides;
var() bool AlignToSide;
var() bool Hollow;
var() float Height;
var() float CapHeight;
var() float OuterRadius;
var() float InnerRadius;
var() name GroupName;

function BuildCone (int direction, bool AlignToSide, int Sides, float Height, float Radius, name Item)
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
		Vertex3f(Radius * Sin((2.00 * i + Ofs) * 3.14 / Sides),Radius * Cos((2.00 * i + Ofs) * 3.14 / Sides),0.00);
		i++;
	}
	Vertex3f(0.00,0.00,Height);
	i=0;
	while ( i < Sides )
	{
		Poly3i(direction,N + i,N + Sides,N + (i + 1) % Sides,Item);
		i++;
	}
}

function bool Build ()
{
	local int i;

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
	if ( Hollow && (CapHeight > Height) )
	{
		return BadParameters();
	}
	if ( Hollow && (CapHeight == Height) && (InnerRadius == OuterRadius) )
	{
		return BadParameters();
	}
	BeginBrush(False,GroupName);
	BuildCone(1,AlignToSide,Sides,Height,OuterRadius,'Top');
	if ( Hollow )
	{
		BuildCone(-1,AlignToSide,Sides,CapHeight,InnerRadius,'Cap');
		if ( OuterRadius != InnerRadius )
		{
			i=0;
			while ( i < Sides )
			{
				Poly4i(1,i,(i + 1) % Sides,Sides + 1 + (i + 1) % Sides,Sides + 1 + i,'Bottom');
				i++;
			}
		}
	}
	else
	{
		PolyBegin(1,'Bottom');
		i=0;
		while ( i < Sides )
		{
			Polyi(i);
			i++;
		}
		PolyEnd();
	}
	return EndBrush();
}

defaultproperties
{
    Sides=8
    AlignToSide=True
    Height=256.00
    CapHeight=256.00
    OuterRadius=512.00
    InnerRadius=384.00
    GroupName=Cone
    BitmapFilename="BBCone"
    ToolTip="Cone"
}