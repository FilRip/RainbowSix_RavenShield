//================================================================================
// SheetBuilder.
//================================================================================
class SheetBuilder extends BrushBuilder;

enum ESheetAxis {
	AX_Horizontal,
	AX_XAxis,
	AX_YAxis
};

var() ESheetAxis Axis;
var() int Height;
var() int Width;
var() int HorizBreaks;
var() int VertBreaks;
var() name GroupName;

event bool Build ()
{
	local int X;
	local int Y;
	local int XStep;
	local int YStep;
	local int idx;
	local int Count;

	if ( (Height <= 0) || (Width <= 0) || (HorizBreaks <= 0) || (VertBreaks <= 0) )
	{
		return BadParameters();
	}
	BeginBrush(False,GroupName);
	XStep=Width / HorizBreaks;
	YStep=Height / VertBreaks;
	Count=0;
	X=0;
	while ( X < HorizBreaks )
	{
		Y=0;
		while ( Y < VertBreaks )
		{
			if ( Axis == 0 )
			{
				Vertex3f(X * XStep - Width / 2,Y * YStep - Height / 2,0.00);
				Vertex3f(X * XStep - Width / 2,(Y + 1) * YStep - Height / 2,0.00);
				Vertex3f((X + 1) * XStep - Width / 2,(Y + 1) * YStep - Height / 2,0.00);
				Vertex3f((X + 1) * XStep - Width / 2,Y * YStep - Height / 2,0.00);
			}
			else
			{
				if ( Axis == 1 )
				{
					Vertex3f(0.00,X * XStep - Width / 2,Y * YStep - Height / 2);
					Vertex3f(0.00,X * XStep - Width / 2,(Y + 1) * YStep - Height / 2);
					Vertex3f(0.00,(X + 1) * XStep - Width / 2,(Y + 1) * YStep - Height / 2);
					Vertex3f(0.00,(X + 1) * XStep - Width / 2,Y * YStep - Height / 2);
				}
				else
				{
					Vertex3f(X * XStep - Width / 2,0.00,Y * YStep - Height / 2);
					Vertex3f(X * XStep - Width / 2,0.00,(Y + 1) * YStep - Height / 2);
					Vertex3f((X + 1) * XStep - Width / 2,0.00,(Y + 1) * YStep - Height / 2);
					Vertex3f((X + 1) * XStep - Width / 2,0.00,Y * YStep - Height / 2);
				}
			}
			Poly4i(1,Count,Count + 1,Count + 2,Count + 3,'Sheet',264);
			Count=GetVertexCount();
			Y++;
		}
		X++;
	}
	return EndBrush();
}

defaultproperties
{
    Height=256
    Width=256
    HorizBreaks=1
    VertBreaks=1
    GroupName=Sheet
    BitmapFilename="BBSheet"
    ToolTip="Sheet"
}