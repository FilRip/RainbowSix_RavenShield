//================================================================================
// R6PlayerInput.
//================================================================================
class R6PlayerInput extends PlayerInput within R6PlayerController
	Config(User);

var bool m_bIgnoreInput;
var bool m_bFluidMovement;
var bool m_bWasFluidMovement;

function UpdateMouseOptions ()
{
	local int iScaledSensitivity;

	bInvertMouse=Outer.m_GameOptions.InvertMouse;
	Outer.m_GameOptions.MouseSensitivity=Clamp(Outer.m_GameOptions.MouseSensitivity,0,100);
	iScaledSensitivity=Outer.m_GameOptions.MouseSensitivity / 7 + 1;
	Outer.SetSensitivity(iScaledSensitivity);
}

event PlayerInput (float DeltaTime)
{
	if ( m_bIgnoreInput )
	{
		return;
	}
	if ( (Outer.m_GameOptions != None) && Outer.m_GameOptions.AlwaysRun )
	{
		if ( Outer.m_bPlayerRun > 0 )
		{
			Outer.bRun=0;
		}
		else
		{
			Outer.bRun=1;
		}
	}
	else
	{
		Outer.bRun=Outer.m_bPlayerRun;
	}
	Super.PlayerInput(DeltaTime);
	if ( Abs(Outer.aStrafe) < 1.00 )
	{
		Outer.aStrafe=0.00;
	}
	m_bFluidMovement=m_bWasFluidMovement ^^ (Outer.m_bSpecialCrouch > 0);
	m_bWasFluidMovement=Outer.m_bSpecialCrouch > 0;
}

function EDoubleClickDir CheckForDoubleClickMove (float DeltaTime)
{
	local EDoubleClickDir DoubleClickMove;
	local EDoubleClickDir OldDoubleClick;

	if ( Outer.DoubleClickDir == 5 )
	{
//		DoubleClickMove=5;
	}
	else
	{
//		DoubleClickMove=0;
	}
	if ( DoubleClickTime > 0.00 )
	{
		if ( Outer.DoubleClickDir < 5 )
		{
//			OldDoubleClick=Outer.DoubleClickDir;
//			Outer.DoubleClickDir=0;
			if ( m_bFluidMovement && m_bWasFluidMovement )
			{
//				Outer.DoubleClickDir=3;
			}
			else
			{
				if ( bEdgeBack && bWasBack )
				{
//					Outer.DoubleClickDir=4;
				}
				else
				{
					if ( bEdgeLeft && bWasLeft )
					{
//						Outer.DoubleClickDir=1;
					}
					else
					{
						if ( bEdgeRight && bWasRight )
						{
//							Outer.DoubleClickDir=2;
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
//				Outer.DoubleClickDir=0;
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
//					Outer.DoubleClickDir=0;
					DoubleClickTimer=DoubleClickTime;
				}
			}
		}
	}
	return DoubleClickMove;
}
