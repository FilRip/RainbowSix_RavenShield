//================================================================================
// SavedMove.
//================================================================================
class SavedMove extends Info
	Native;

var EDoubleClickDir DoubleClickMove;
var bool bRun;
var bool bDuck;
var bool m_bCrawl;
var float TimeStamp;
var float Delta;
var SavedMove NextMove;

final function Clear ()
{
	TimeStamp=0.00;
	Delta=0.00;
	DoubleClickMove=DCLICK_None;
	Acceleration=vect(0.00,0.00,0.00);
	bRun=False;
	bDuck=False;
	m_bCrawl=False;
}

final function SetMoveFor (PlayerController P, float DeltaTime, Vector NewAccel, EDoubleClickDir InDoubleClick)
{
	if ( VSize(NewAccel) > 3072 )
	{
		NewAccel=3072 * Normal(NewAccel);
	}
	if ( Delta > 0 )
	{
		Acceleration=(DeltaTime * NewAccel + Delta * Acceleration) / (Delta + DeltaTime);
	}
	else
	{
		Acceleration=NewAccel;
	}
	Delta += DeltaTime;
	if ( DoubleClickMove == 0 )
	{
		DoubleClickMove=InDoubleClick;
	}
	bRun=P.bRun > 0;
	bDuck=P.bDuck > 0;
	TimeStamp=Level.TimeSeconds;
	m_bCrawl=P.m_bCrawl;
}
