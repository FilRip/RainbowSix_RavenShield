//================================================================================
// LinearStairBuilder.
//================================================================================
class LinearStairBuilder extends BrushBuilder;

var() int StepLength;
var() int StepHeight;
var() int StepWidth;
var() int NumSteps;
var() int AddToFirstStep;
var() name GroupName;

event bool Build ()
{
	local int i;
	local int LastIdx;
	local int CurrentX;
	local int CurrentY;
	local int CurrentZ;
	local int Adjustment;

	if ( (StepLength <= 0) || (StepHeight <= 0) || (StepWidth <= 0) )
	{
		return BadParameters();
	}
	if ( (NumSteps <= 1) || (NumSteps > 45) )
	{
		return BadParameters("NumSteps must be greater than 1 and less than 45.");
	}
	BeginBrush(False,GroupName);
	CurrentX=0;
	CurrentY=0;
	CurrentZ=0;
	LastIdx=GetVertexCount();
	Vertex3f(0.00,0.00, -StepHeight);
	Vertex3f(0.00,StepWidth, -StepHeight);
	Vertex3f(StepLength * NumSteps,StepWidth, -StepHeight);
	Vertex3f(StepLength * NumSteps,0.00, -StepHeight);
	Poly4i(1,0,1,2,3,'Base');
	LastIdx += 4;
	Vertex3f(StepLength * NumSteps,StepWidth, -StepHeight);
	Vertex3f(StepLength * NumSteps,StepWidth,StepHeight * (NumSteps - 1) + AddToFirstStep);
	Vertex3f(StepLength * NumSteps,0.00,StepHeight * (NumSteps - 1) + AddToFirstStep);
	Vertex3f(StepLength * NumSteps,0.00, -StepHeight);
	Poly4i(1,4,5,6,7,'back');
	LastIdx += 4;
	i=0;
	while ( i < NumSteps )
	{
		CurrentX=i * StepLength;
		CurrentZ=i * StepHeight + AddToFirstStep;
		Vertex3f(CurrentX,CurrentY,CurrentZ);
		Vertex3f(CurrentX,CurrentY + StepWidth,CurrentZ);
		Vertex3f(CurrentX + StepLength,CurrentY + StepWidth,CurrentZ);
		Vertex3f(CurrentX + StepLength,CurrentY,CurrentZ);
		Poly4i(1,LastIdx + i * 4 + 3,LastIdx + i * 4 + 2,LastIdx + i * 4 + 1,LastIdx + i * 4,'Step');
		i++;
	}
	LastIdx += NumSteps * 4;
	i=0;
	while ( i < NumSteps )
	{
		CurrentX=i * StepLength;
		CurrentZ=i * StepHeight + AddToFirstStep;
		if ( i == 0 )
		{
			Adjustment=AddToFirstStep;
		}
		else
		{
			Adjustment=0;
		}
		Vertex3f(CurrentX,CurrentY,CurrentZ);
		Vertex3f(CurrentX,CurrentY,CurrentZ - StepHeight - Adjustment);
		Vertex3f(CurrentX,CurrentY + StepWidth,CurrentZ - StepHeight - Adjustment);
		Vertex3f(CurrentX,CurrentY + StepWidth,CurrentZ);
		Poly4i(1,LastIdx + i * 12 + 3,LastIdx + i * 12 + 2,LastIdx + i * 12 + 1,LastIdx + i * 12,'Rise');
		Vertex3f(CurrentX,CurrentY,CurrentZ);
		Vertex3f(CurrentX,CurrentY,CurrentZ - StepHeight - Adjustment);
		Vertex3f(CurrentX + StepLength * (NumSteps - i),CurrentY,CurrentZ - StepHeight - Adjustment);
		Vertex3f(CurrentX + StepLength * (NumSteps - i),CurrentY,CurrentZ);
		Poly4i(1,LastIdx + i * 12 + 4,LastIdx + i * 12 + 5,LastIdx + i * 12 + 6,LastIdx + i * 12 + 7,'Side');
		Vertex3f(CurrentX,CurrentY + StepWidth,CurrentZ);
		Vertex3f(CurrentX,CurrentY + StepWidth,CurrentZ - StepHeight - Adjustment);
		Vertex3f(CurrentX + StepLength * (NumSteps - i),CurrentY + StepWidth,CurrentZ - StepHeight - Adjustment);
		Vertex3f(CurrentX + StepLength * (NumSteps - i),CurrentY + StepWidth,CurrentZ);
		Poly4i(1,LastIdx + i * 12 + 11,LastIdx + i * 12 + 10,LastIdx + i * 12 + 9,LastIdx + i * 12 + 8,'Side');
		i++;
	}
	return EndBrush();
}

defaultproperties
{
    StepLength=32
    StepHeight=16
    StepWidth=256
    NumSteps=8
    GroupName=LinearStair
    BitmapFilename="BBLinearStair"
    ToolTip="Linear Staircase"
}