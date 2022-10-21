//================================================================================
// Console.
//================================================================================
class Console extends Interaction
	Native;

var globalconfig byte ConsoleKey;
var int HistoryTop;
var int HistoryBot;
var int HistoryCur;
var globalconfig int iBrowserMaxNbServerPerPage;
var bool bTyping;
var bool bIgnoreKeys;
var bool bShowLog;
var bool bShowConsoleLog;
var bool m_bStringIsTooLong;
var bool m_bStartedByGSClient;
var bool m_bNonUbiMatchMaking;
var bool m_bNonUbiMatchMakingHost;
var bool m_bInterruptConnectionProcess;
var string TypedStr;
var string History[16];
const MaxHistory=16;

event GameServiceTick ()
{
}

function GetAllMissionDescriptions ();

exec function type ()
{
	TypedStr="";
	bShowConsoleLog=True;
	GotoState('Typing');
}

exec function Talk ()
{
	TypedStr="Say ";
	bShowConsoleLog=False;
	GotoState('Typing');
}

exec function TeamTalk ()
{
/*	local GameReplicationInfo GameInfo;

	if ( ViewportOwner.Actor != None )
	{
		GameInfo=ViewportOwner.Actor.GameReplicationInfo;
		if (  !ViewportOwner.Actor.Level.IsGameTypeTeamAdversarial(GameInfo.m_eGameTypeFlag) )
		{
			return;
		}
	}
	TypedStr="TeamSay ";
	bShowConsoleLog=False;
	GotoState('Typing');*/
}

event Message (coerce string Msg, float MsgLife);

function bool KeyEvent (EInputKey Key, EInputAction Action, float Delta)
{
	if ( bShowLog )
	{
		Log("Console state " @ string(Action) @ "Key" @ string(Key));
	}
	if ( Action != 1 )
	{
		return False;
	}
	else
	{
		if ( Key == ConsoleKey )
		{
			GotoState('Typing');
			return True;
		}
		else
		{
			return False;
		}
	}
}

function bool KeyType (EInputKey Key)
{
	if ( bShowLog )
	{
		Log("Console state " @ string(Key) @ string(Key));
	}
	return False;
}

state Typing
{
	exec function type ()
	{
		TypedStr="";
		GotoState('None');
	}

	function bool KeyType (EInputKey Key)
	{
		local string OutStr;
		local float XL;
		local float YL;

		if ( bShowLog )
		{
			Log("Console state Typing KeyType Key" @ string(Key));
		}
		if ( bIgnoreKeys )
		{
			return True;
		}
		if ( m_bStringIsTooLong )
		{
			return True;
		}
		if ( (Key >= 32) && (Key < 256) && (Key != Asc("~")) && (Key != Asc("`")) )
		{
			TypedStr=TypedStr $ Chr(Key);
			Class'Actor'.static.GetCanvas().Font=Class'Actor'.static.GetCanvas().SmallFont;
			OutStr="(>" @ TypedStr $ "_";
			Class'Actor'.static.GetCanvas().StrLen(OutStr,XL,YL);
			if ( XL > Class'Actor'.static.GetCanvas().SizeX * 0.95 )
			{
				m_bStringIsTooLong=True;
			}
			return True;
		}
	}

	function bool KeyEvent (EInputKey Key, EInputAction Action, float Delta)
	{
		local string temp;
		local int i;

		if ( bShowLog )
		{
			Log("Console state Typing KeyEvent Action" @ string(Action) @ "Key" @ string(Key));
		}
		if ( Action == 1 )
		{
			bIgnoreKeys=False;
		}
		if ( Key == 27 )
		{
			if ( TypedStr != "" )
			{
				TypedStr="";
				HistoryCur=HistoryTop;
				return True;
			}
			else
			{
				GotoState('None');
			}
		}
		else
		{
			if ( Global.KeyEvent(Key,Action,Delta) )
			{
				return True;
			}
			else
			{
				if ( Action != 1 )
				{
					return False;
				}
				else
				{
					if ( Key == 13 )
					{
						if ( TypedStr != "" )
						{
							Message(TypedStr,6.00);
							History[HistoryTop]=TypedStr;
							HistoryTop=(HistoryTop + 1) % 16;
							if ( (HistoryBot == -1) || (HistoryBot == HistoryTop) )
							{
								HistoryBot=(HistoryBot + 1) % 16;
							}
							HistoryCur=HistoryTop;
							temp=TypedStr;
							TypedStr="";
							if (  !ConsoleCommand(temp) )
							{
								Message(Localize("Errors","Exec","R6Engine"),6.00);
							}
							Message("",6.00);
							GotoState('None');
						}
						else
						{
							GotoState('None');
						}
						return True;
					}
					else
					{
						if ( Key == 38 )
						{
							if ( HistoryBot >= 0 )
							{
								if ( HistoryCur == HistoryBot )
								{
									HistoryCur=HistoryTop;
								}
								else
								{
									HistoryCur--;
									if ( HistoryCur < 0 )
									{
										HistoryCur=16 - 1;
									}
								}
								TypedStr=History[HistoryCur];
							}
							return True;
						}
						else
						{
							if ( Key == 40 )
							{
								if ( HistoryBot >= 0 )
								{
									if ( HistoryCur == HistoryTop )
									{
										HistoryCur=HistoryBot;
									}
									else
									{
										HistoryCur=(HistoryCur + 1) % 16;
									}
									TypedStr=History[HistoryCur];
								}
							}
							else
							{
								if ( (Key == 8) || (Key == 37) )
								{
									if ( Len(TypedStr) > 0 )
									{
										TypedStr=Left(TypedStr,Len(TypedStr) - 1);
									}
									return True;
								}
							}
						}
					}
				}
			}
		}
		return True;
	}

	function PostRender (Canvas Canvas)
	{
		local float XL;
		local float YL;
		local string OutStr;
		local float OrgX;
		local float OrgY;

		OrgX=Canvas.OrgX;
		OrgY=Canvas.OrgY;
		Canvas.SetOrigin(0.00,0.00);
		Canvas.ClipX=Canvas.SizeX;
		Canvas.ClipY=Canvas.SizeY;
		Canvas.Style=1;
		Canvas.Font=Canvas.SmallFont;
		OutStr=">" @ TypedStr $ "_";
		Canvas.StrLen(OutStr,XL,YL);
		Canvas.SetPos(0.00,Canvas.SizeY - 6 - YL);
//		Canvas.DrawTile(Texture'ConsoleBK',Canvas.SizeX,YL + 6,0.00,0.00,32.00,32.00);
		Canvas.SetPos(0.00,Canvas.SizeY - 8 - YL);
		Canvas.SetDrawColor(128,128,128);
//		Canvas.DrawTile(Texture'ConsoleBdr',Canvas.SizeX,2.00,0.00,0.00,32.00,32.00);
		Canvas.SetDrawColor(255,255,255);
		Canvas.SetPos(0.00,Canvas.SizeY - 3 - YL);
		Canvas.bCenter=False;
		Canvas.DrawText(OutStr,False);
		Canvas.SetOrigin(OrgX,OrgY);
	}

	function BeginState ()
	{
		bTyping=True;
		bVisible=True;
		bIgnoreKeys=True;
		HistoryCur=HistoryTop;
		m_bStringIsTooLong=False;
	}

	function EndState ()
	{
		bTyping=False;
		bVisible=False;
	}

}

defaultproperties
{
    ConsoleKey=192
    HistoryBot=-1
    iBrowserMaxNbServerPerPage=400
    bRequiresTick=True
}
