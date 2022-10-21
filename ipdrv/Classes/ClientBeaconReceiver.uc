//================================================================================
// ClientBeaconReceiver.
//================================================================================
class ClientBeaconReceiver extends UdpBeacon;

struct PreJoinResponseInfo
{
	var bool bResponseRcvd;
	var int iLobbyID;
	var int iGroupID;
	var bool bLocked;
	var string szGameVersion;
	var bool bInternetServer;
	var int iNumPlayers;
	var int iMaxPlayers;
};

struct BeaconInfo
{
	var IpAddr Addr;
	var float Time;
	var string Text;
	var int iNumPlayers;
	var int iMaxPlayers;
	var ER6GameType eCurrGameType;
	var string szMapName;
	var string szSvrName;
	var bool bDedicated;
	var bool bLocked;
	var string MapList[32];
	var ER6GameType eGameType[32];
	var string szPlayerName[32];
	var string szPlayerTime[32];
	var int iPlayerPingTime[32];
	var int iPlayerKillCount[32];
	var int iRoundsPerMap;
	var float fRndTime;
	var float fBetTime;
	var float fBombTime;
	var bool bShowNames;
	var bool bInternetServer;
	var bool bFriendlyFire;
	var bool bAutoBalTeam;
	var bool bTKPenalty;
	var bool bNewData;
	var bool bRadar;
	var int iPort;
	var string szGameVersion;
	var int iLobbyID;
	var int iGroupID;
	var int iBeaconPort;
	var int iNumTerro;
	var bool bAIBkp;
	var bool bRotateMap;
	var bool bForceFPWpn;
	var string szModName;
	var bool bPunkBuster;
};

var BeaconInfo Beacons[32];
var PreJoinResponseInfo PreJoinInfo;

function string GetBeaconAddress (int i)
{
	return IpAddrToString(Beacons[i].Addr);
}

function string GetBeaconText (int i)
{
	return Beacons[i].Text;
}

function BeginPlay ()
{
	local IpAddr Addr;

	InitBeaconProduct();
	if ( BindPort(BeaconPort,True,LocalIpAddress) > 0 )
	{
		SetTimer(1.00,True);
		Log("ClientBeaconReceiver initialized.");
	}
	else
	{
		Log("ClientBeaconReceiver failed: Beacon port in use.");
	}
	Addr.Addr=BroadcastAddr;
	Addr.Port=ServerBeaconPort;
	BroadcastBeacon(Addr);
}

function Destroyed ()
{
	Log("ClientBeaconReceiver finished.");
}

function Timer ()
{
	local int i;
	local int j;

	i=0;
JL0007:
	if ( i < 32 )
	{
		if ( (Beacons[i].Addr.Addr != 0) && (Level.TimeSeconds - Beacons[i].Time < BeaconTimeout) )
		{
			Beacons[j++ ]=Beacons[i];
		}
		i++;
		goto JL0007;
	}
	j=j;
JL0088:
	if ( j < 32 )
	{
		Beacons[j].Addr.Addr=0;
		j++;
		goto JL0088;
	}
}

function BroadcastBeacon (IpAddr Addr)
{
/*	local int i;
	local IpAddr lAddr;

	i=0;
JL0007:
	if ( i < GetMaxAvailPorts() )
	{
		lAddr.Addr=Addr.Addr;
		lAddr.Port=Addr.Port + i;
		SendText(lAddr,"REPORT");
		i++;
		goto JL0007;
	}*/
}

function bool PreJoinQuery (string szIP, int iBeaconPort)
{
	local IpAddr Addr;

	PreJoinInfo.bResponseRcvd=False;
	PreJoinInfo.iLobbyID=0;
	PreJoinInfo.iGroupID=0;
	PreJoinInfo.szGameVersion="";
	if ( InStr(szIP,":") != -1 )
	{
		szIP=Left(szIP,InStr(szIP,":"));
	}
	if (  !StringToIpAddr(szIP,Addr) )
	{
		return False;
	}
	if ( iBeaconPort != 0 )
	{
		Addr.Port=iBeaconPort;
	}
	else
	{
		Addr.Port=ServerBeaconPort;
	}
	SendText(Addr,"PREJOIN");
	return True;
}

event ReceivedText (IpAddr Addr, string Text)
{
	local int i;
	local int N;
	local int pos;
	local string szSecondWord;
	local string szThirdWord;
	local string szRemainingText;
	local string szOneKWMessage;
	local string szPreJoinString;
	local bool bBooleanValue;
	local string szStringValue;

	N=Len(BeaconProduct);
	if ( Left(Text,N + 1) ~= (BeaconProduct $ " ") )
	{
		szSecondWord=Mid(Text,N + 1);
		Addr.Port=int(szSecondWord);
		szThirdWord=Mid(szSecondWord,InStr(szSecondWord," ") + 1);
		N=Len(KeyWordMarker);
		if ( Left(szThirdWord,N + 1) ~= (KeyWordMarker $ " ") )
		{
			i=0;
JL009E:
			if ( i < 32 )
			{
				if ( (Beacons[i].Addr.Addr == Addr.Addr) && (Beacons[i].Addr.Port == Addr.Port) )
				{
					goto JL0101;
				}
				i++;
				goto JL009E;
			}
JL0101:
			if ( i == 32 )
			{
				i=0;
JL0114:
				if ( i < 32 )
				{
					if ( Beacons[i].Addr.Addr == 0 )
					{
						goto JL0148;
					}
					i++;
					goto JL0114;
				}
			}
JL0148:
			if ( i == 32 )
			{
				return;
			}
			Beacons[i].Addr=Addr;
			Beacons[i].Time=Level.TimeSeconds;
			Beacons[i].Text=Mid(Text,InStr(Text," ") + 1);
			Beacons[i].bNewData=True;
			DecodeKeyWordString(i,szThirdWord);
			return;
		}
		else
		{
			if ( Left(szThirdWord,Len(PreJoinQueryMarker) + 1) ~= (PreJoinQueryMarker $ " ") )
			{
				pos=InStr(Mid(szThirdWord,1),"�");
				if ( pos != -1 )
				{
					szPreJoinString=Mid(szThirdWord,pos);
				}
				PreJoinInfo.bResponseRcvd=True;
				PreJoinInfo.iLobbyID=0;
				PreJoinInfo.iGroupID=0;
JL0251:
				if ( pos > 0 )
				{
					pos=InStr(Mid(szPreJoinString,1),"�");
					if ( pos != -1 )
					{
						pos += 1;
						szOneKWMessage=Left(szPreJoinString,pos - 1);
						szPreJoinString=Mid(szPreJoinString,pos);
					}
					else
					{
						szOneKWMessage=szPreJoinString;
					}
					if ( Left(szOneKWMessage,Len(LobbyServerIDMarker)) ~= LobbyServerIDMarker )
					{
						PreJoinInfo.iLobbyID=int(Mid(szOneKWMessage,InStr(szOneKWMessage," ") + 1));
					}
					else
					{
						if ( Left(szOneKWMessage,Len(GroupIDMarker)) ~= GroupIDMarker )
						{
							PreJoinInfo.iGroupID=int(Mid(szOneKWMessage,InStr(szOneKWMessage," ") + 1));
						}
						else
						{
							if ( Left(szOneKWMessage,Len(LockedMarker)) ~= LockedMarker )
							{
//								bBooleanValue=int(Mid(szOneKWMessage,InStr(szOneKWMessage," ") + 1));
								PreJoinInfo.bLocked=bBooleanValue;
							}
							else
							{
								if ( Left(szOneKWMessage,Len(GameVersionMarker)) ~= GameVersionMarker )
								{
									szStringValue=Mid(szOneKWMessage,InStr(szOneKWMessage," ") + 1);
									PreJoinInfo.szGameVersion=szStringValue;
								}
								else
								{
									if ( Left(szOneKWMessage,Len(InternetServerMarker)) ~= InternetServerMarker )
									{
//										bBooleanValue=int(Mid(szOneKWMessage,InStr(szOneKWMessage," ") + 1));
										PreJoinInfo.bInternetServer=bBooleanValue;
									}
									else
									{
										if ( Left(szOneKWMessage,Len(NumPlayersMarker)) ~= NumPlayersMarker )
										{
											PreJoinInfo.iNumPlayers=int(Mid(szOneKWMessage,InStr(szOneKWMessage," ") + 1));
										}
										else
										{
											if ( Left(szOneKWMessage,Len(MaxPlayersMarker)) ~= MaxPlayersMarker )
											{
												PreJoinInfo.iMaxPlayers=int(Mid(szOneKWMessage,InStr(szOneKWMessage," ") + 1));
											}
										}
									}
								}
							}
						}
					}
					goto JL0251;
				}
			}
		}
	}
}

function int GetBeaconListSize ()
{
	return 32;
}

function int GetBeaconIntAddress (int i)
{
	return Beacons[i].Addr.Addr;
}

function int GetMaxPlayers (int i)
{
	return Beacons[i].iMaxPlayers;
}

function int GetPortNumber (int i)
{
	return Beacons[i].iPort;
}

function int GetNumPlayers (int i)
{
	return Beacons[i].iNumPlayers;
}

function string GetFirstMapName (int i)
{
	return Beacons[i].szMapName;
}

function string GetSvrName (int i)
{
	return Beacons[i].szSvrName;
}

function string GetModName (int i)
{
	return Beacons[i].szModName;
}

function bool GetLocked (int i)
{
	return Beacons[i].bLocked;
}

function bool GetDedicated (int i)
{
	return Beacons[i].bDedicated;
}

function float GetRoundsPerMap (int i)
{
	return Beacons[i].iRoundsPerMap;
}

function float GetRoundTime (int i)
{
	return Beacons[i].fRndTime;
}

function float GetBetTime (int i)
{
	return Beacons[i].fBetTime;
}

function float GetBombTime (int i)
{
	return Beacons[i].fBombTime;
}

function int GetMapListSize (int i)
{
	local int j;

	j=0;
JL0007:
	if ( j < 32 )
	{
		if ( Beacons[i].MapList[j] == "" )
		{
			goto JL003D;
		}
		j++;
		goto JL0007;
	}
JL003D:
	return j;
}

function string GetOneMapName (int iBeacon, int i)
{
	return Beacons[iBeacon].MapList[i];
}

function int GetPlayerListSize (int i)
{
	local int j;

	j=0;
JL0007:
	if ( j < 32 )
	{
		if ( Beacons[i].szPlayerName[j] == "" )
		{
			goto JL003D;
		}
		j++;
		goto JL0007;
	}
JL003D:
	return j;
}

function string GetPlayerName (int iBeacon, int i)
{
	return Beacons[iBeacon].szPlayerName[i];
}

function string GetPlayerTime (int iBeacon, int i)
{
	return Beacons[iBeacon].szPlayerTime[i];
}

function int GetPlayerPingTime (int iBeacon, int i)
{
	return Beacons[iBeacon].iPlayerPingTime[i];
}

function int GetPlayerKillCount (int iBeacon, int i)
{
	return Beacons[iBeacon].iPlayerKillCount[i];
}

function ER6GameType GetGameType (int iBeacon, int i)
{
	return Beacons[iBeacon].eGameType[i];
}

function bool GetShowEnemyNames (int i)
{
	return Beacons[i].bShowNames;
}

function bool GetInternetServer (int i)
{
	return Beacons[i].bInternetServer;
}

function bool GetFriendlyFire (int i)
{
	return Beacons[i].bFriendlyFire;
}

function bool GetAutoBalanceTeam (int i)
{
	return Beacons[i].bAutoBalTeam;
}

function bool GetTKPenalty (int i)
{
	return Beacons[i].bTKPenalty;
}

function bool GetRadar (int i)
{
	return Beacons[i].bRadar;
}

function ER6GameType GetCurrGameType (int i)
{
	return Beacons[i].eCurrGameType;
}

function bool GetNewDataFlag (int i)
{
	return Beacons[i].bNewData;
}

function string GetServerGameVersion (int i)
{
	return Beacons[i].szGameVersion;
}

function SetNewDataFlag (int i, bool bNewData)
{
	Beacons[i].bNewData=bNewData;
}

function int GetLobbyID (int i)
{
	return Beacons[i].iLobbyID;
}

function int GetGroupID (int i)
{
	return Beacons[i].iGroupID;
}

function int GetBeaconPort (int i)
{
	return Beacons[i].iBeaconPort;
}

function int GetNumTerrorists (int i)
{
	return Beacons[i].iNumTerro;
}

function bool GetAIBackup (int i)
{
	return Beacons[i].bAIBkp;
}

function bool GetRotateMap (int i)
{
	return Beacons[i].bRotateMap;
}

function bool GetForceFirstPersonWeapon (int i)
{
	return Beacons[i].bForceFPWpn;
}

function bool GetPunkBusterEnabled (int i)
{
	return Beacons[i].bPunkBuster;
}

function ClearBeacon (int i)
{
	local int j;

	Beacons[i].Addr.Addr=0;
	Beacons[i].iNumPlayers=0;
	Beacons[i].iMaxPlayers=0;
	Beacons[i].szMapName="";
//	Beacons[i].eCurrGameType=0;
	Beacons[i].szSvrName="";
	Beacons[i].bDedicated=False;
	Beacons[i].bLocked=False;
	j=0;
JL00A1:
	if ( j < 32 )
	{
		Beacons[i].MapList[j]="";
		j++;
		goto JL00A1;
	}
	j=0;
JL00D7:
	if ( j < 32 )
	{
		Beacons[i].szPlayerName[j]="";
		j++;
		goto JL00D7;
	}
	j=0;
JL010D:
	if ( j < 32 )
	{
		Beacons[i].szPlayerTime[j]="";
		j++;
		goto JL010D;
	}
	Beacons[i].iRoundsPerMap=0;
	Beacons[i].fRndTime=0.00;
	Beacons[i].fBetTime=0.00;
	Beacons[i].fBombTime=0.00;
	Beacons[i].bShowNames=False;
	Beacons[i].bInternetServer=False;
	Beacons[i].bFriendlyFire=False;
	Beacons[i].bAutoBalTeam=False;
	Beacons[i].bTKPenalty=False;
	Beacons[i].bRadar=False;
	Beacons[i].iPort=0;
	Beacons[i].szGameVersion="";
	Beacons[i].iLobbyID=0;
	Beacons[i].iGroupID=0;
	Beacons[i].bPunkBuster=False;
}

function RefreshServers ()
{
	local IpAddr Addr;
	local int i;

	i=0;
JL0007:
	if ( i < 32 )
	{
		Beacons[i].Addr.Addr=0;
		i++;
		goto JL0007;
	}
	Addr.Addr=BroadcastAddr;
	Addr.Port=ServerBeaconPort;
	BroadcastBeacon(Addr);
}

function bool GrabOption (out string Options, out string Result)
{
	if ( Left(Options,1) == "�" )
	{
		Result=Mid(Options,1);
		if ( InStr(Result,"�") >= 0 )
		{
			Result=Left(Result,InStr(Result,"�"));
		}
		Options=Mid(Options,1);
		if ( InStr(Options,"�") >= 0 )
		{
			Options=Mid(Options,InStr(Options,"�"));
		}
		else
		{
			Options="";
		}
		return True;
	}
	else
	{
		return False;
	}
}

function GetKeyValue (string Pair, out string Key, out string Value)
{
	if ( InStr(Pair,"=") >= 0 )
	{
		Key=Left(Pair,InStr(Pair,"="));
		Value=Mid(Pair,InStr(Pair,"=") + 1);
	}
	else
	{
		Key=Pair;
		Value="";
	}
}

function string ParseOption (string Options, string InKey)
{
	local string Pair;
	local string Key;
	local string Value;

JL0000:
	if ( GrabOption(Options,Pair) )
	{
		GetKeyValue(Pair,Key,Value);
		if ( Key ~= InKey )
		{
			return Value;
		}
		goto JL0000;
	}
	return "";
}

function DecodeKeyWordString (int iBeaconIdx, string szKewWordString)
{
	local int pos;
	local int counter;
	local int i;
	local string szOneKWMessage;

	pos=InStr(szKewWordString,"�");
	if ( pos != -1 )
	{
		szKewWordString=Mid(szKewWordString,pos);
	}
	counter=0;
JL0038:
	if ( (pos > 0) && (counter < 255) )
	{
		counter++;
		pos=InStr(Mid(szKewWordString,1),"�");
		if ( pos != -1 )
		{
			pos += 1;
			szOneKWMessage=Left(szKewWordString,pos - 1);
			szKewWordString=Mid(szKewWordString,pos);
		}
		else
		{
			szOneKWMessage=szKewWordString;
		}
		DecodeKeyWordPair(szOneKWMessage,iBeaconIdx);
		Beacons[iBeaconIdx].bNewData=True;
		goto JL0038;
	}
}

function DecodeKeyWordPair (string szKeyWord, int iIndex)
{
/*	local int iIntegerValue;
	local bool bBooleanValue;
	local string szStringValue;
	local string szOptionName;
	local int j;
	local int N;
	local int pos;
	local string InOpt;
	local string LeftOpt;

	if ( Left(szKeyWord,Len(GamePortMarker)) ~= GamePortMarker )
	{
		iIntegerValue=int(Mid(szKeyWord,InStr(szKeyWord," ") + 1));
		Beacons[iIndex].iPort=iIntegerValue;
	}
	if ( Left(szKeyWord,Len(NumPlayersMarker)) ~= NumPlayersMarker )
	{
		iIntegerValue=int(Mid(szKeyWord,InStr(szKeyWord," ") + 1));
		Beacons[iIndex].iNumPlayers=iIntegerValue;
	}
	else
	{
		if ( Left(szKeyWord,Len(MaxPlayersMarker)) ~= MaxPlayersMarker )
		{
			iIntegerValue=int(Mid(szKeyWord,InStr(szKeyWord," ") + 1));
			Beacons[iIndex].iMaxPlayers=iIntegerValue;
		}
		else
		{
			if ( Left(szKeyWord,Len(MapNameMarker)) ~= MapNameMarker )
			{
				szStringValue=Mid(szKeyWord,InStr(szKeyWord," ") + 1);
				Beacons[iIndex].szMapName=szStringValue;
			}
			else
			{
				if ( Left(szKeyWord,Len(SvrNameMarker)) ~= SvrNameMarker )
				{
					szStringValue=Mid(szKeyWord,InStr(szKeyWord," ") + 1);
					Beacons[iIndex].szSvrName=szStringValue;
				}
				else
				{
					if ( Left(szKeyWord,Len(GameTypeMarker)) ~= GameTypeMarker )
					{
						iIntegerValue=int(Mid(szKeyWord,InStr(szKeyWord," ") + 1));
						Beacons[iIndex].eCurrGameType=Level.ConvertGameTypeIntToEnum(iIntegerValue);
					}
					else
					{
						if ( Left(szKeyWord,Len(DecicatedMarker)) ~= DecicatedMarker )
						{
							bBooleanValue=int(Mid(szKeyWord,InStr(szKeyWord," ") + 1));
							Beacons[iIndex].bDedicated=bBooleanValue;
						}
						else
						{
							if ( Left(szKeyWord,Len(LockedMarker)) ~= LockedMarker )
							{
								bBooleanValue=int(Mid(szKeyWord,InStr(szKeyWord," ") + 1));
								Beacons[iIndex].bLocked=bBooleanValue;
							}
							else
							{
								if ( Left(szKeyWord,Len(MapListMarker)) ~= MapListMarker )
								{
									szStringValue=Mid(szKeyWord,InStr(szKeyWord," ") + 1);
									j=0;
JL02B0:
									if ( j < 32 )
									{
										Beacons[iIndex].MapList[j]="";
										j++;
										goto JL02B0;
									}
									j=0;
JL02E6:
									if ( InStr(szStringValue,"/") != -1 )
									{
										szStringValue=Mid(szStringValue,InStr(szStringValue,"/") + 1);
										pos=InStr(szStringValue,"/");
										if ( pos != -1 )
										{
											Beacons[iIndex].MapList[j]=Left(szStringValue,pos);
										}
										else
										{
											Beacons[iIndex].MapList[j]=szStringValue;
										}
										j++;
										goto JL02E6;
									}
								}
								else
								{
									if ( Left(szKeyWord,Len(MenuGmNameMarker)) ~= MenuGmNameMarker )
									{
										szStringValue=Mid(szKeyWord,InStr(szKeyWord," ") + 1);
										j=0;
JL03BB:
										if ( j < 32 )
										{
											Beacons[iIndex].eGameType[j]=0;
											j++;
											goto JL03BB;
										}
										j=0;
JL03F1:
										if ( InStr(szStringValue,"/") != -1 )
										{
											szStringValue=Mid(szStringValue,InStr(szStringValue,"/") + 1);
											pos=InStr(szStringValue,"/");
											if ( pos != -1 )
											{
												Beacons[iIndex].eGameType[j]=Level.ConvertGameTypeIntToEnum(int(Left(szStringValue,pos)));
											}
											else
											{
												Beacons[iIndex].eGameType[j]=Level.ConvertGameTypeIntToEnum(int(szStringValue));
											}
											j++;
											goto JL03F1;
										}
									}
									else
									{
										if ( Left(szKeyWord,Len(PlayerListMarker)) ~= PlayerListMarker )
										{
											szStringValue=Mid(szKeyWord,InStr(szKeyWord," ") + 1);
											j=0;
JL04E2:
											if ( j < 32 )
											{
												Beacons[iIndex].szPlayerName[j]="";
												j++;
												goto JL04E2;
											}
											j=0;
JL0518:
											if ( InStr(szStringValue,"/") != -1 )
											{
												szStringValue=Mid(szStringValue,InStr(szStringValue,"/") + 1);
												pos=InStr(szStringValue,"/");
												if ( pos != -1 )
												{
													Beacons[iIndex].szPlayerName[j]=Left(szStringValue,pos);
												}
												else
												{
													Beacons[iIndex].szPlayerName[j]=szStringValue;
												}
												j++;
												goto JL0518;
											}
										}
										else
										{
											if ( Left(szKeyWord,Len(PlayerTimeMarker)) ~= PlayerTimeMarker )
											{
												szStringValue=Mid(szKeyWord,InStr(szKeyWord," ") + 1);
												j=0;
JL05ED:
												if ( j < 32 )
												{
													Beacons[iIndex].szPlayerTime[j]="";
													j++;
													goto JL05ED;
												}
												j=0;
JL0623:
												if ( InStr(szStringValue,"/") != -1 )
												{
													szStringValue=Mid(szStringValue,InStr(szStringValue,"/") + 1);
													pos=InStr(szStringValue,"/");
													if ( pos != -1 )
													{
														Beacons[iIndex].szPlayerTime[j]=Left(szStringValue,pos);
													}
													else
													{
														Beacons[iIndex].szPlayerTime[j]=szStringValue;
													}
													j++;
													goto JL0623;
												}
											}
											else
											{
												if ( Left(szKeyWord,Len(PlayerPingMarker)) ~= PlayerPingMarker )
												{
													szStringValue=Mid(szKeyWord,InStr(szKeyWord," ") + 1);
													j=0;
JL06F8:
													if ( j < 32 )
													{
														Beacons[iIndex].iPlayerPingTime[j]=0;
														j++;
														goto JL06F8;
													}
													j=0;
JL072D:
													if ( InStr(szStringValue,"/") != -1 )
													{
														szStringValue=Mid(szStringValue,InStr(szStringValue,"/") + 1);
														pos=InStr(szStringValue,"/");
														if ( pos != -1 )
														{
															Beacons[iIndex].iPlayerPingTime[j]=int(Left(szStringValue,pos));
														}
														else
														{
															Beacons[iIndex].iPlayerPingTime[j]=int(szStringValue);
														}
														j++;
														goto JL072D;
													}
												}
												else
												{
													if ( Left(szKeyWord,Len(PlayerKillMarker)) ~= PlayerKillMarker )
													{
														szStringValue=Mid(szKeyWord,InStr(szKeyWord," ") + 1);
														j=0;
JL0806:
														if ( j < 32 )
														{
															Beacons[iIndex].iPlayerKillCount[j]=0;
															j++;
															goto JL0806;
														}
														j=0;
JL083B:
														if ( InStr(szStringValue,"/") != -1 )
														{
															szStringValue=Mid(szStringValue,InStr(szStringValue,"/") + 1);
															pos=InStr(szStringValue,"/");
															if ( pos != -1 )
															{
																Beacons[iIndex].iPlayerKillCount[j]=int(Left(szStringValue,pos));
															}
															else
															{
																Beacons[iIndex].iPlayerKillCount[j]=int(szStringValue);
															}
															j++;
															goto JL083B;
														}
													}
													else
													{
														if ( Left(szKeyWord,Len(RoundsPerMatchMarker)) ~= RoundsPerMatchMarker )
														{
															iIntegerValue=float(Mid(szKeyWord,InStr(szKeyWord," ") + 1));
															Beacons[iIndex].iRoundsPerMap=iIntegerValue;
														}
														else
														{
															if ( Left(szKeyWord,Len(RoundTimeMarker)) ~= RoundTimeMarker )
															{
																iIntegerValue=float(Mid(szKeyWord,InStr(szKeyWord," ") + 1));
																Beacons[iIndex].fRndTime=iIntegerValue;
															}
															else
															{
																if ( Left(szKeyWord,Len(BetTimeMarker)) ~= BetTimeMarker )
																{
																	iIntegerValue=float(Mid(szKeyWord,InStr(szKeyWord," ") + 1));
																	Beacons[iIndex].fBetTime=iIntegerValue;
																}
																else
																{
																	if ( Left(szKeyWord,Len(BombTimeMarker)) ~= BombTimeMarker )
																	{
																		iIntegerValue=float(Mid(szKeyWord,InStr(szKeyWord," ") + 1));
																		Beacons[iIndex].fBombTime=iIntegerValue;
																	}
																	else
																	{
																		if ( Left(szKeyWord,Len(ShowNamesMarker)) ~= ShowNamesMarker )
																		{
																			bBooleanValue=int(Mid(szKeyWord,InStr(szKeyWord," ") + 1));
																			Beacons[iIndex].bShowNames=bBooleanValue;
																		}
																		else
																		{
																			if ( Left(szKeyWord,Len(InternetServerMarker)) ~= InternetServerMarker )
																			{
																				bBooleanValue=int(Mid(szKeyWord,InStr(szKeyWord," ") + 1));
																				Beacons[iIndex].bInternetServer=bBooleanValue;
																			}
																			else
																			{
																				if ( Left(szKeyWord,Len(FriendlyFireMarker)) ~= FriendlyFireMarker )
																				{
																					bBooleanValue=int(Mid(szKeyWord,InStr(szKeyWord," ") + 1));
																					Beacons[iIndex].bFriendlyFire=bBooleanValue;
																				}
																				else
																				{
																					if ( Left(szKeyWord,Len(AutoBalTeamMarker)) ~= AutoBalTeamMarker )
																					{
																						bBooleanValue=int(Mid(szKeyWord,InStr(szKeyWord," ") + 1));
																						Beacons[iIndex].bAutoBalTeam=bBooleanValue;
																					}
																					else
																					{
																						if ( Left(szKeyWord,Len(TKPenaltyMarker)) ~= TKPenaltyMarker )
																						{
																							bBooleanValue=int(Mid(szKeyWord,InStr(szKeyWord," ") + 1));
																							Beacons[iIndex].bTKPenalty=bBooleanValue;
																						}
																						else
																						{
																							if ( Left(szKeyWord,Len(AllowRadarMarker)) ~= AllowRadarMarker )
																							{
																								bBooleanValue=int(Mid(szKeyWord,InStr(szKeyWord," ") + 1));
																								Beacons[iIndex].bRadar=bBooleanValue;
																							}
																							else
																							{
																								if ( Left(szKeyWord,Len(GameVersionMarker)) ~= GameVersionMarker )
																								{
																									szStringValue=Mid(szKeyWord,InStr(szKeyWord," ") + 1);
																									Beacons[iIndex].szGameVersion=szStringValue;
																								}
																								else
																								{
																									if ( Left(szKeyWord,Len(LobbyServerIDMarker)) ~= LobbyServerIDMarker )
																									{
																										Beacons[iIndex].iLobbyID=int(Mid(szKeyWord,InStr(szKeyWord," ") + 1));
																									}
																									else
																									{
																										if ( Left(szKeyWord,Len(GroupIDMarker)) ~= GroupIDMarker )
																										{
																											Beacons[iIndex].iGroupID=int(Mid(szKeyWord,InStr(szKeyWord," ") + 1));
																										}
																										else
																										{
																											if ( Left(szKeyWord,Len(BeaconPortMarker)) ~= BeaconPortMarker )
																											{
																												Beacons[iIndex].iBeaconPort=int(Mid(szKeyWord,InStr(szKeyWord," ") + 1));
																											}
																											else
																											{
																												if ( Left(szKeyWord,Len(NumTerroMarker)) ~= NumTerroMarker )
																												{
																													Beacons[iIndex].iNumTerro=int(Mid(szKeyWord,InStr(szKeyWord," ") + 1));
																												}
																												else
																												{
																													if ( Left(szKeyWord,Len(AIBkpMarker)) ~= AIBkpMarker )
																													{
																														Beacons[iIndex].bAIBkp=int(Mid(szKeyWord,InStr(szKeyWord," ") + 1));
																													}
																													else
																													{
																														if ( Left(szKeyWord,Len(RotateMapMarker)) ~= RotateMapMarker )
																														{
																															Beacons[iIndex].bRotateMap=int(Mid(szKeyWord,InStr(szKeyWord," ") + 1));
																														}
																														else
																														{
																															if ( Left(szKeyWord,Len(ForceFPWpnMarker)) ~= ForceFPWpnMarker )
																															{
																																Beacons[iIndex].bForceFPWpn=int(Mid(szKeyWord,InStr(szKeyWord," ") + 1));
																															}
																															else
																															{
																																if ( Left(szKeyWord,Len(ModNameMarker)) ~= ModNameMarker )
																																{
																																	szStringValue=Mid(szKeyWord,InStr(szKeyWord," ") + 1);
																																	Beacons[iIndex].szModName=szStringValue;
																																}
																																else
																																{
																																	if ( Left(szKeyWord,Len(PunkBusterMarker)) ~= PunkBusterMarker )
																																	{
																																		Beacons[iIndex].bPunkBuster=int(Mid(szKeyWord,InStr(szKeyWord," ") + 1));
																																	}
																																}
																															}
																														}
																													}
																												}
																											}
																										}
																									}
																								}
																							}
																						}
																					}
																				}
																			}
																		}
																	}
																}
															}
														}
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}*/
}
