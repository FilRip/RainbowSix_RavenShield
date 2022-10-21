//================================================================================
// SpiralStairBuilder.
//================================================================================
class SpiralStairBuilder extends BrushBuilder;

var() int InnerRadius;
var() int StepWidth;
var() int StepHeight;
var() int StepThickness;
var() int NumStepsPer360;
var() int NumSteps;
var() bool SlopedCeiling;
var() bool SlopedFloor;
var() bool CounterClockwise;
var() name GroupName;

function BuildCurvedStair (int direction)
{
	local Rotator RotStep;
	local Rotator newRot;
	local Vector vtx;
	local Vector NewVtx;
	local Vector Template[8];
	local int X;
	local int Y;
	local int idx;
	local int VertexStart;

	RotStep.Yaw=65536 * 360.00 / NumStepsPer360 / 360.00;
	if ( CounterClockwise )
	{
		RotStep.Yaw *= -1;
		direction *= -1;
	}
	idx=0;
	VertexStart=GetVertexCount();
	vtx.X=InnerRadius;
	X=0;
	while ( X < 2 )
	{
		NewVtx=vtx >> RotStep * X;
		vtx.Z=0.00;
		if ( SlopedCeiling && (X == 1) )
		{
			vtx.Z=StepHeight;
		}
		Vertex3f(NewVtx.X,NewVtx.Y,vtx.Z);
		Template[idx].X=NewVtx.X;
		Template[idx].Y=NewVtx.Y;
		Template[idx].Z=vtx.Z;
		idx++;
		vtx.Z=StepThickness;
		if ( SlopedFloor && (X == 0) )
		{
			vtx.Z -= StepHeight;
		}
		Vertex3f(NewVtx.X,NewVtx.Y,vtx.Z);
		Template[idx].X=NewVtx.X;
		Template[idx].Y=NewVtx.Y;
		Template[idx].Z=vtx.Z;
		idx++;
		X++;
	}
	vtx.X=InnerRadius + StepWidth;
	X=0;
	while ( X < 2 )
	{
		NewVtx=vtx >> RotStep * X;
		vtx.Z=0.00;
		if ( SlopedCeiling && (X == 1) )
		{
			vtx.Z=StepHeight;
		}
		Vertex3f(NewVtx.X,NewVtx.Y,vtx.Z);
		Template[idx].X=NewVtx.X;
		Template[idx].Y=NewVtx.Y;
		Template[idx].Z=vtx.Z;
		idx++;
		vtx.Z=StepThickness;
		if ( SlopedFloor && (X == 0) )
		{
			vtx.Z -= StepHeight;
		}
		Vertex3f(NewVtx.X,NewVtx.Y,vtx.Z);
		Template[idx].X=NewVtx.X;
		Template[idx].Y=NewVtx.Y;
		Template[idx].Z=vtx.Z;
		idx++;
		X++;
	}
	X=0;
	while ( X < NumSteps - 1 )
	{
		if ( SlopedFloor )
		{
			Poly3i(direction,VertexStart + 3,VertexStart + 1,VertexStart + 5,'steptop');
			Poly3i(direction,VertexStart + 3,VertexStart + 5,VertexStart + 7,'steptop');
		}
		else
		{
			Poly4i(direction,VertexStart + 3,VertexStart + 1,VertexStart + 5,VertexStart + 7,'steptop');
		}
		Poly4i(direction,VertexStart + 0,VertexStart + 1,VertexStart + 3,VertexStart + 2,'inner');
		Poly4i(direction,VertexStart + 5,VertexStart + 4,VertexStart + 6,VertexStart + 7,'Outer');
		Poly4i(direction,VertexStart + 1,VertexStart + 0,VertexStart + 4,VertexStart + 5,'stepfront');
		Poly4i(direction,VertexStart + 2,VertexStart + 3,VertexStart + 7,VertexStart + 6,'stepback');
		if ( SlopedCeiling )
		{
			Poly3i(direction,VertexStart + 0,VertexStart + 2,VertexStart + 6,'stepbottom');
			Poly3i(direction,VertexStart + 0,VertexStart + 6,VertexStart + 4,'stepbottom');
		}
		else
		{
			Poly4i(direction,VertexStart + 0,VertexStart + 2,VertexStart + 6,VertexStart + 4,'stepbottom');
		}
		VertexStart=GetVertexCount();
		Y=0;
		while ( Y < 8 )
		{
			NewVtx=Template[Y] >> RotStep * (X + 1);
			Vertex3f(NewVtx.X,NewVtx.Y,NewVtx.Z + StepHeight * (X + 1));
			Y++;
		}
		X++;
	}
}

function bool Build ()
{
	if ( (InnerRadius < 1) || (StepWidth < 1) || (NumSteps < 1) || (NumStepsPer360 < 3) )
	{
		return BadParameters();
	}
	BeginBrush(False,GroupName);
	BuildCurvedStair(1);
	return EndBrush();
}

defaultproperties
{
    InnerRadius=64
    StepWidth=256
    StepHeight=16
    StepThickness=32
    NumStepsPer360=8
    NumSteps=8
    SlopedCeiling=True
    GroupName=Spiral
    BitmapFilename="BBSpiralStair"
    ToolTip="Spiral Staircase"
}