//================================================================================
// PlayerInput.
//================================================================================
class PlayerInput extends Object within PlayerController
	Native
//	Export
	Transient
	Config(User);

enum EDoubleClickDir {
	DCLICK_None,
	DCLICK_Left,
	DCLICK_Right,
	DCLICK_Forward,
	DCLICK_Back,
	DCLICK_Active,
	DCLICK_Done
};

var globalconfig byte MouseSmoothingMode;
var int MouseSamples[2];
var bool bInvertMouse;
var bool bWasForward;
var bool bWasBack;
var bool bWasLeft;
var bool bWasRight;
var bool bEdgeForward;
var bool bEdgeBack;
var bool bEdgeLeft;
var bool bEdgeRight;
var bool bAdjustSampling;
var globalconfig float MouseSensitivity;
var globalconfig float MouseSamplingTime;
var float SmoothedMouse[2];
var float ZeroTime[2];
var float SamplingTime[2];
var float MaybeTime[2];
var float OldSamples[4];
var float DoubleClickTimer;
var globalconfig float DoubleClickTime;

event PlayerInput (float DeltaTime)
{
	local float FOVScale;
	local float MouseScale;

	bEdgeForward=bWasForward ^^ (Outer.aBaseY > 0);
	bEdgeBack=bWasBack ^^ (Outer.aBaseY < 0);
	bEdgeLeft=bWasLeft ^^ (Outer.aStrafe > 0);
	bEdgeRight=bWasRight ^^ (Outer.aStrafe < 0);
	bWasForward=Outer.aBaseY > 0;
	bWasBack=Outer.aBaseY < 0;
	bWasLeft=Outer.aStrafe > 0;
	bWasRight=Outer.aStrafe < 0;
	FOVScale=Outer.DesiredFOV * 0.01;
	MouseScale=MouseSensitivity * FOVScale;
	Outer.aMouseX=SmoothMouse(Outer.aMouseX * MouseScale,DeltaTime,Outer.bXAxis,0);
	Outer.aMouseY=SmoothMouse(Outer.aMouseY * MouseScale,DeltaTime,Outer.bYAxis,1);
	Outer.aLookUp *= FOVScale;
	Outer.aTurn *= FOVScale;
	if ( Outer.bStrafe != 0 )
	{
		Outer.aStrafe += Outer.aBaseX + Outer.aMouseX;
	}
	else
	{
		Outer.aTurn += Outer.aBaseX * FOVScale + Outer.aMouseX;
	}
	Outer.aBaseX=0.00;
	if ( (Outer.bStrafe == 0) && (Outer.bAlwaysMouseLook || (Outer.bLook != 0)) )
	{
		if ( bInvertMouse )
		{
			Outer.aLookUp -= Outer.aMouseY;
		}
		else
		{
			Outer.aLookUp += Outer.aMouseY;
		}
	}
	else
	{
		Outer.aForward += Outer.aMouseY;
	}
	if ( Outer.bSnapLevel != 0 )
	{
		Outer.bCenterView=True;
		Outer.bKeyboardLook=False;
	}
	else
	{
		if ( Outer.aLookUp != 0 )
		{
			Outer.bCenterView=False;
			Outer.bKeyboardLook=True;
		}
		else
		{
			if ( Outer.bSnapToLevel &&  !Outer.bAlwaysMouseLook )
			{
				Outer.bCenterView=True;
				Outer.bKeyboardLook=False;
			}
		}
	}
	if ( Outer.bFreeLook != 0 )
	{
		Outer.bKeyboardLook=True;
		Outer.aLookUp += 0.50 * Outer.aBaseY * FOVScale;
	}
	else
	{
		Outer.aForward += Outer.aBaseY;
	}
	Outer.aBaseY=0.00;
	Outer.HandleWalking();
}

function UpdateMouseOptions ();

exec function SetSmoothingMode (byte B)
{
	MouseSmoothingMode=B;
	Log("Smoothing mode " $ string(MouseSmoothingMode));
}

exec function SetSmoothingStrength (float f)
{
}

function float SmoothMouse (float aMouse, float DeltaTime, out byte SampleCount, int Index)
{
	local int i;
	local int sum;

	if ( MouseSmoothingMode == 0 )
	{
		return aMouse;
	}
	if ( aMouse == 0 )
	{
		ZeroTime[Index] += DeltaTime;
		if ( ZeroTime[Index] < MouseSamplingTime )
		{
			SamplingTime[Index] += DeltaTime;
			MaybeTime[Index] += DeltaTime;
			aMouse=SmoothedMouse[Index];
		}
		else
		{
			if ( bAdjustSampling && (MouseSamples[Index] > 9) )
			{
				SamplingTime[Index] -= MaybeTime[Index];
				MouseSamplingTime=0.90 * MouseSamplingTime + 0.10 * SamplingTime[Index] / MouseSamples[Index];
			}
			SamplingTime[Index]=0.00;
			SmoothedMouse[Index]=0.00;
			MouseSamples[Index]=0;
		}
	}
	else
	{
		MaybeTime[Index]=0.00;
		if ( SmoothedMouse[Index] != 0 )
		{
			MouseSamples[Index] += SampleCount;
			if ( DeltaTime > MouseSamplingTime * (SampleCount + 1) )
			{
				SamplingTime[Index] += MouseSamplingTime * SampleCount;
			}
			else
			{
				SamplingTime[Index] += DeltaTime;
				aMouse=aMouse * DeltaTime / MouseSamplingTime * SampleCount;
			}
		}
		else
		{
			SamplingTime[Index]=0.50 * MouseSamplingTime;
		}
		SmoothedMouse[Index]=aMouse / SampleCount;
		ZeroTime[Index]=0.00;
	}
	SampleCount=0;
	if ( MouseSmoothingMode > 1 )
	{
		if ( aMouse == 0 )
		{
			i=0;
JL0231:
			if ( i < 3 )
			{
				sum += (i + 1) * 0.10;
				aMouse += sum * OldSamples[i];
				OldSamples[i]=0.00;
				i++;
				goto JL0231;
			}
			OldSamples[3]=0.00;
		}
		else
		{
			aMouse=0.40 * aMouse;
			OldSamples[3]=aMouse;
			i=0;
JL02C5:
			if ( i < 3 )
			{
				aMouse += (i + 1) * 0.10 * OldSamples[i];
				OldSamples[i]=OldSamples[i + 1];
				i++;
				goto JL02C5;
			}
		}
	}
	return aMouse;
}

function UpdateSensitivity (float f)
{
	MouseSensitivity=FMax(0.00,f);
	SaveConfig();
}

function ChangeSnapView (bool B)
{
	Outer.bSnapToLevel=B;
}

function EDoubleClickDir CheckForDoubleClickMove (float DeltaTime)
{
	local EDoubleClickDir DoubleClickMove;
	local EDoubleClickDir OldDoubleClick;

	if ( Outer.DoubleClickDir == DCLICK_Active )
	{
		DoubleClickMove=DCLICK_Active;
	}
	else
	{
		DoubleClickMove=DCLICK_None;
	}
	if ( DoubleClickTime > 0.00 )
	{
		if ( Outer.DoubleClickDir < 5 )
		{
//			OldDoubleClick=Outer.DoubleClickDir;
			Outer.DoubleClickDir=DCLICK_None;
			if ( bEdgeForward && bWasForward )
			{
				Outer.DoubleClickDir=DCLICK_Forward;
			}
			else
			{
				if ( bEdgeBack && bWasBack )
				{
					Outer.DoubleClickDir=DCLICK_Back;
				}
				else
				{
					if ( bEdgeLeft && bWasLeft )
					{
						Outer.DoubleClickDir=DCLICK_Left;
					}
					else
					{
						if ( bEdgeRight && bWasRight )
						{
							Outer.DoubleClickDir=DCLICK_Right;
						}
					}
				}
			}
			if ( Outer.DoubleClickDir == 0 )
			{
//				Outer.DoubleClickDir=OldDoubleClick;
			}
			else
			{
				if ( Outer.DoubleClickDir != OldDoubleClick )
				{
					DoubleClickTimer=DoubleClickTime + 0.50 * DeltaTime;
				}
				else
				{
//					DoubleClickMove=Outer.DoubleClickDir;
				}
			}
		}
		if ( Outer.DoubleClickDir == 6 )
		{
			DoubleClickTimer -= DeltaTime;
			if ( DoubleClickTimer < -0.35 )
			{
				Outer.DoubleClickDir=DCLICK_None;
				DoubleClickTimer=DoubleClickTime;
			}
		}
		else
		{
			if ( (Outer.DoubleClickDir != 0) && (Outer.DoubleClickDir != 5) )
			{
				DoubleClickTimer -= DeltaTime;
				if ( DoubleClickTimer < 0 )
				{
					Outer.DoubleClickDir=DCLICK_None;
					DoubleClickTimer=DoubleClickTime;
				}
			}
		}
	}
	return DoubleClickMove;
}

defaultproperties
{
    MouseSmoothingMode=1
    bAdjustSampling=True
    MouseSensitivity=3.00
    MouseSamplingTime=0.01
    DoubleClickTime=0.25
}