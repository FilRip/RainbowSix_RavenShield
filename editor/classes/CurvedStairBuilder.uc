//================================================================================
// CurvedStairBuilder.
//================================================================================
class CurvedStairBuilder extends BrushBuilder;

var() int InnerRadius;
var() int StepHeight;
var() int StepWidth;
var() int AngleOfCurve;
var() int NumSteps;
var() int AddToFirstStep;
var() bool CounterClockwise;
var() name GroupName;

function BuildCurvedStair (int direction)
{
	local Rotator RotStep;
	local Vector vtx;
	local Vector NewVtx;
	local int X;
	local int Z;
	local int InnerStart;
	local int OuterStart;
	local int BottomInnerStart;
	local int BottomOuterStart;
	local int Adjustment;

	RotStep.Yaw=65536 * AngleOfCurve / 360.00 / NumSteps;
	if ( CounterClockwise )
	{
		RotStep.Yaw *= -1;
		direction *= -1;
	}
	InnerStart=GetVertexCount();
	vtx.X=InnerRadius;
	X=0;
	while ( X < NumSteps + 1 )
	{
		if ( X == 0 )
		{
			Adjustment=AddToFirstStep;
		}
		else
		{
			Adjustment=0;
		}
		NewVtx=vtx >> RotStep * X;
		Vertex3f(NewVtx.X,NewVtx.Y,vtx.Z - Adjustment);
		vtx.Z += StepHeight;
		Vertex3f(NewVtx.X,NewVtx.Y,vtx.Z);
		X++;
	}
	OuterStart=GetVertexCount();
	vtx.X=InnerRadius + StepWidth;
	vtx.Z=0.00;
	X=0;
	while ( X < NumSteps + 1 )
	{
		if ( X == 0 )
		{
			Adjustment=AddToFirstStep;
		}
		else
		{
			Adjustment=0;
		}
		NewVtx=vtx >> RotStep * X;
		Vertex3f(NewVtx.X,NewVtx.Y,vtx.Z - Adjustment);
		vtx.Z += StepHeight;
		Vertex3f(NewVtx.X,NewVtx.Y,vtx.Z);
		X++;
	}
	BottomInnerStart=GetVertexCount();
	vtx.X=InnerRadius;
	vtx.Z=0.00;
	X=0;
	while ( X < NumSteps + 1 )
	{
		NewVtx=vtx >> RotStep * X;
		Vertex3f(NewVtx.X,NewVtx.Y,vtx.Z - AddToFirstStep);
		X++;
	}
	BottomOuterStart=GetVertexCount();
	vtx.X=InnerRadius + StepWidth;
	X=0;
	while ( X < NumSteps + 1 )
	{
		NewVtx=vtx >> RotStep * X;
		Vertex3f(NewVtx.X,NewVtx.Y,vtx.Z - AddToFirstStep);
		X++;
	}
	X=0;
	while ( X < NumSteps )
	{
		Poly4i(direction,InnerStart + X * 2 + 2,InnerStart + X * 2 + 1,OuterStart + X * 2 + 1,OuterStart + X * 2 + 2,'steptop');
		Poly4i(direction,InnerStart + X * 2 + 1,InnerStart + X * 2,OuterStart + X * 2,OuterStart + X * 2 + 1,'stepfront');
		Poly4i(direction,BottomInnerStart + X,InnerStart + X * 2 + 1,InnerStart + X * 2 + 2,BottomInnerStart + X + 1,'innercurve');
		Poly4i(direction,OuterStart + X * 2 + 1,BottomOuterStart + X,BottomOuterStart + X + 1,OuterStart + X * 2 + 2,'outercurve');
		Poly4i(direction,BottomInnerStart + X,BottomInnerStart + X + 1,BottomOuterStart + X + 1,BottomOuterStart + X,'Bottom');
		X++;
	}
	Poly4i(direction,BottomInnerStart + NumSteps,InnerStart + NumSteps * 2,OuterStart + NumSteps * 2,BottomOuterStart + NumSteps,'back');
}

function bool Build ()
{
	local int i;
	local int j;
	local int k;

	if ( (AngleOfCurve < 1) || (AngleOfCurve > 360) )
	{
		return BadParameters("Angle is out of range.");
	}
	if ( (InnerRadius < 1) || (StepWidth < 1) || (NumSteps < 1) )
	{
		return BadParameters();
	}
	BeginBrush(False,GroupName);
	BuildCurvedStair(1);
	return EndBrush();
}

defaultproperties
{
    InnerRadius=240
    StepHeight=16
    StepWidth=256
    AngleOfCurve=90
    NumSteps=4
    GroupName=CStair
    BitmapFilename="BBCurvedStair"
    ToolTip="Curved Staircase"
}