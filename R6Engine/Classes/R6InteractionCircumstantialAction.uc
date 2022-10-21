//================================================================================
// R6InteractionCircumstantialAction.
//================================================================================
class R6InteractionCircumstantialAction extends R6InteractionRoseDesVents;

enum eCircumstantialActionPerformer {
	CACTION_Player,
	CACTION_Team,
	CACTION_TeamFromList,
	CACTION_TeamFromListZulu
};

var Texture m_TexProgressCircle;
var Texture m_TexProgressItem;
var Texture m_TexFakeReticule;
var Font m_SmallFont_14pt;

event Initialized ()
{
	Super.Initialized();
}

function ActionKeyPressed ()
{
	if ( m_Player.Level.NetMode != 0 )
	{
		m_Player.ServerActionKeyPressed();
	}
	m_Player.SetRequestedCircumstantialAction();
	if ( m_Player.m_RequestedCircumstantialAction.iHasAction == 1 )
	{
		m_Player.m_RequestedCircumstantialAction.m_bNeedsTick=True;
		m_Player.m_RequestedCircumstantialAction.m_fPressedTime=m_Player.Level.TimeSeconds;
	}
}

function ActionKeyReleased ()
{
	m_Player.ServerActionKeyReleased();
	m_Player.SetRequestedCircumstantialAction();
	m_Player.m_RequestedCircumstantialAction.m_bNeedsTick=False;
	m_Player.m_RequestedCircumstantialAction.m_fPressedTime=0.00;
	if ( m_Player.PlayerCanSwitchToAIBackup() )
	{
		if ( (m_Player.Pawn != None) &&  !m_Player.Pawn.IsAlive() )
		{
			m_Player.RegroupOnMe();
			return;
		}
	}
	else
	{
		if ( m_Player.m_bReadyToEnterSpectatorMode )
		{
			m_Player.EnterSpectatorMode();
			return;
		}
	}
	if ( m_Player.m_RequestedCircumstantialAction.iHasAction != 1 )
	{
		DisplayMenu(False);
		return;
	}
	if ( m_Player.m_RequestedCircumstantialAction.iInRange != 1 )
	{
//		m_Player.m_InteractionCA.PerformCircumstantialAction(1);
	}
	else
	{
		if ( m_Player.m_pawn.CanInteractWithObjects() && (m_Player.m_RequestedCircumstantialAction.iInRange == 1) &&  !m_Player.m_RequestedCircumstantialAction.bCanBeInterrupted )
		{
			if ( m_Player.m_RequestedCircumstantialAction.aQueryTarget == m_Player )
			{
				m_Player.RegroupOnMe();
			}
			else
			{
//				m_Player.m_InteractionCA.PerformCircumstantialAction(0);
			}
		}
		else
		{
			if ( m_Player.m_RequestedCircumstantialAction.aQueryTarget.IsA('R6IORotatingDoor') )
			{
				if ( R6IORotatingDoor(m_Player.m_RequestedCircumstantialAction.aQueryTarget).m_bIsDoorLocked )
				{
					R6Pawn(m_Player.Pawn).ServerPerformDoorAction(R6IORotatingDoor(m_Player.m_RequestedCircumstantialAction.aQueryTarget),14);
				}
			}
		}
	}
	DisplayMenu(False);
}

simulated function bool MenuItemEnabled (int iItem)
{
	local bool bActionCanBeExecuted;
	local int iSubMenuChoice;

	iSubMenuChoice=m_iCurrentSubMnuChoice * 4 + iItem;
	if ( (iItem < 0) || (iItem > 3) )
	{
		return False;
	}
	if ( m_iCurrentSubMnuChoice != -1 )
	{
		bActionCanBeExecuted=m_Player.m_CurrentCircumstantialAction.aQueryTarget.R6ActionCanBeExecuted(m_Player.m_CurrentCircumstantialAction.iTeamSubActionsIDList[iSubMenuChoice]);
	}
	else
	{
		if ( m_Player.m_CurrentCircumstantialAction.iTeamActionIDList[iItem] != 0 )
		{
			bActionCanBeExecuted=m_Player.m_CurrentCircumstantialAction.aQueryTarget.R6ActionCanBeExecuted(m_Player.m_CurrentCircumstantialAction.iTeamActionIDList[iItem]);
		}
		else
		{
			bActionCanBeExecuted=False;
		}
	}
	return bActionCanBeExecuted;
}

function bool CurrentItemHasSubMenu ()
{
	local int i;

	if ( m_iCurrentSubMnuChoice != -1 )
	{
		return False;
	}
	i=m_iCurrentMnuChoice * 4;
JL0020:
	if ( i < (m_iCurrentMnuChoice + 1) * 4 )
	{
		if ( m_Player.m_CurrentCircumstantialAction.iTeamSubActionsIDList[i] != 0 )
		{
			return True;
		}
		i++;
		goto JL0020;
	}
	return False;
}

function bool ItemHasSubMenu (int iItem)
{
	local int i;

	if ( m_iCurrentSubMnuChoice != -1 )
	{
		return False;
	}
	i=iItem * 4;
JL0020:
	if ( i < (iItem + 1) * 4 )
	{
		if ( m_Player.m_CurrentCircumstantialAction.iTeamSubActionsIDList[i] != 0 )
		{
			return True;
		}
		i++;
		goto JL0020;
	}
	return False;
}

function GotoSubMenu ()
{
	m_Player.m_RequestedCircumstantialAction.iMenuChoice=m_Player.m_RequestedCircumstantialAction.iTeamActionIDList[m_iCurrentMnuChoice];
	m_iCurrentSubMnuChoice=m_iCurrentMnuChoice;
	m_iCurrentMnuChoice=0;
}

function bool IsValidMenuChoice (int iChoice)
{
	local int iSubMenuChoice;

	iSubMenuChoice=m_iCurrentSubMnuChoice * 4 + iChoice;
	if ( (iChoice < 0) || (iChoice > 3) )
	{
		return False;
	}
	if ( (m_iCurrentSubMnuChoice != -1) && (m_Player.m_CurrentCircumstantialAction.iTeamSubActionsIDList[iSubMenuChoice] != 0) && m_Player.m_CurrentCircumstantialAction.aQueryTarget.R6ActionCanBeExecuted(m_Player.m_CurrentCircumstantialAction.iTeamSubActionsIDList[iSubMenuChoice]) || (m_Player.m_CurrentCircumstantialAction.iTeamActionIDList[iChoice] != 0) )
	{
		return True;
	}
	return False;
}

function SetMenuChoice (int iChoice)
{
	if ( (iChoice < 0) || (iChoice > 3) )
	{
		m_iCurrentMnuChoice=-1;
	}
	else
	{
		if ( IsValidMenuChoice(iChoice) )
		{
			m_iCurrentMnuChoice=iChoice;
		}
		else
		{
			SetMenuChoice(iChoice - 1);
		}
	}
}

function NoItemSelected ()
{
	m_Player.SetRequestedCircumstantialAction();
}

function ItemClicked (int iItem)
{
//	PerformCircumstantialAction(2);
}

function ItemRightClicked (int iItem)
{
//	PerformCircumstantialAction(3);
}

function PerformCircumstantialAction (eCircumstantialActionPerformer ePerformer)
{
	if ( m_Player.m_RequestedCircumstantialAction == None )
	{
		return;
	}
	if ( m_iCurrentSubMnuChoice != -1 )
	{
		m_Player.m_RequestedCircumstantialAction.iMenuChoice=m_Player.m_RequestedCircumstantialAction.iTeamActionIDList[m_iCurrentSubMnuChoice];
		m_Player.m_RequestedCircumstantialAction.iSubMenuChoice=m_Player.m_RequestedCircumstantialAction.iTeamSubActionsIDList[m_iCurrentSubMnuChoice * 4 + m_iCurrentMnuChoice];
	}
	else
	{
		if ( m_iCurrentMnuChoice != -1 )
		{
			m_Player.m_RequestedCircumstantialAction.iMenuChoice=m_Player.m_RequestedCircumstantialAction.iTeamActionIDList[m_iCurrentMnuChoice];
			m_Player.m_RequestedCircumstantialAction.iSubMenuChoice=-1;
		}
	}
	switch (ePerformer)
	{
/*		case 0:
		if ( m_Player.m_RequestedCircumstantialAction.bCanBeInterrupted )
		{
			ActionProgressStart();
		}
		else
		{
			m_Player.m_pawn.ActionRequest(m_Player.m_RequestedCircumstantialAction);
		}
		break;
		case 1:
		m_Player.m_TeamManager.TeamActionRequest(m_Player.m_RequestedCircumstantialAction);
		break;
		case 2:
		m_Player.m_TeamManager.TeamActionRequestFromRoseDesVents(m_Player.m_RequestedCircumstantialAction,m_Player.m_RequestedCircumstantialAction.iMenuChoice,m_Player.m_RequestedCircumstantialAction.iSubMenuChoice);
		break;
		case 3:
		m_Player.m_TeamManager.TeamActionRequestWaitForZuluGoCode(m_Player.m_RequestedCircumstantialAction,m_Player.m_RequestedCircumstantialAction.iMenuChoice,m_Player.m_RequestedCircumstantialAction.iSubMenuChoice);
		break;
		default:   */
	}
}

function ActionProgressStart ()
{
	if (  !R6Pawn(m_Player.Pawn).CanInteractWithObjects() )
	{
		return;
	}
	m_Player.m_PlayerCurrentCA=m_Player.m_RequestedCircumstantialAction;
	GotoState('ActionProgress');
	m_Player.ServerPlayerActionProgress();
	if ( m_Player.m_PlayerCurrentCA.aQueryTarget.IsA('R6Terrorist') )
	{
		m_Player.GotoState('PlayerSecureTerrorist');
	}
	else
	{
		if ( Class'Actor'.static.GetModMgr().IsMissionPack() && m_Player.m_PlayerCurrentCA.aQueryTarget.IsA('R6Rainbow') )
		{
			m_Player.GotoState('PlayerSecureRainbow');
		}
		else
		{
			m_Player.GotoState('PlayerActionProgress');
		}
	}
}

function ActionProgressStop ()
{
	DisplayMenu(False);
	if ( Class'Actor'.static.GetModMgr().IsMissionPack() )
	{
		if ( m_Player.Pawn.IsAlive() &&  !m_Player.m_pawn.m_bIsSurrended )
		{
			m_Player.GotoState('PlayerWalking');
		}
	}
	else
	{
		if ( m_Player.Pawn.IsAlive() )
		{
			m_Player.GotoState('PlayerWalking');
		}
	}
	m_Player.m_PlayerCurrentCA=None;
}

function ActionProgressDone ()
{
	m_Player.m_pawn.ActionRequest(m_Player.m_PlayerCurrentCA);
	DisplayMenu(False);
	m_bIgnoreNextActionKeyRelease=True;
	m_Player.GotoState('PlayerWalking');
	m_Player.m_PlayerCurrentCA=None;
}

state ActionProgress
{
	function bool KeyEvent (EInputKey eKey, EInputAction eAction, float fDelta)
	{
		if ( eKey == m_Player.GetKey(m_ActionKey) )
		{
			if ( eAction == 3 )
			{
				m_Player.ServerActionProgressStop();
				if ( Class'Actor'.static.GetModMgr().IsMissionPack() )
				{
					if ( m_Player.Pawn.IsAlive() &&  !m_Player.m_pawn.m_bIsSurrended )
					{
						m_Player.GotoState('PlayerWalking');
					}
				}
				else
				{
					if ( m_Player.Pawn.IsAlive() )
					{
						m_Player.GotoState('PlayerWalking');
					}
				}
				DisplayMenu(False);
				m_bActionKeyDown=False;
				return True;
			}
		}
		return True;
	}

}

function PostRender (Canvas C)
{
	local R6GameOptions GameOptions;

	GameOptions=Class'Actor'.static.GetGameOptions();
	if ( m_Player == None )
	{
		return;
	}
	if ( GameOptions.HUDShowActionIcon || m_Player.m_bShowCompleteHUD )
	{
		C.UseVirtualSize(True);
		if ( (m_Player.Pawn != None) &&  !m_Player.Pawn.IsAlive() )
		{
			if ( m_Player.PlayerCanSwitchToAIBackup() )
			{
				DrawDeadCircumstantialIcon(C);
				C.UseVirtualSize(False);
				return;
			}
			else
			{
				if ( (m_Player.Level.NetMode != 0) && m_Player.m_bReadyToEnterSpectatorMode &&  !m_Player.bOnlySpectator )
				{
					DrawGotoSpectatorModeIcon(C);
					C.UseVirtualSize(False);
					return;
				}
			}
		}
	}
	Super.PostRender(C);
	DrawCircumstantialActionInfo(C);
	C.UseVirtualSize(False);
}

function DrawGotoSpectatorModeIcon (Canvas C)
{
	C.Style=5;
	C.SetDrawColor(m_Player.m_SpectatorColor.R,m_Player.m_SpectatorColor.G,m_Player.m_SpectatorColor.B,m_Player.m_SpectatorColor.A);
	C.SetPos(C.HalfClipX - 16,C.ClipY - 74);
//	C.DrawTile(Texture'GoToSpectator',32.00,32.00,0.00,0.00,32.00,32.00);
}

function DrawDeadCircumstantialIcon (Canvas C)
{
	local string szNextTeamMate;
	local float W;
	local float H;

	if ( m_Player.m_TeamManager != None )
	{
		C.Style=5;
		C.SetDrawColor(m_Player.m_TeamManager.Colors.HUDWhite.R,m_Player.m_TeamManager.Colors.HUDWhite.G,m_Player.m_TeamManager.Colors.HUDWhite.B,m_Player.m_TeamManager.Colors.HUDWhite.A);
		C.SetPos(C.HalfClipX - 16,C.ClipY - 74);
//		C.DrawTile(Texture'NextTeamMate',32.00,32.00,0.00,0.00,32.00,32.00);
		if ( R6GameReplicationInfo(m_Player.GameReplicationInfo).m_iDiffLevel == 1 )
		{
			szNextTeamMate=Localize("Order","NextTeamMate","R6Menu");
			szNextTeamMate=m_Player.GetLocStringWithActionKey(szNextTeamMate,"Action");
			C.TextSize(szNextTeamMate,W,H);
			C.SetPos(C.HalfClipX - 16 - W / 2,C.ClipY - 20);
			C.DrawText(szNextTeamMate);
		}
	}
}

function DrawSpectatorReticule (Canvas C)
{
	local int X;
	local int Y;
	local float fScale;
	local float fStrSizeX;
	local float fStrSizeY;
	local R6Pawn OtherPawn;
	local string characterName;

	X=C.HalfClipX;
	Y=C.HalfClipY;
	C.SetDrawColor(255,0,0);
	C.Style=5;
	fScale=16.00 / m_TexFakeReticule.VSize;
	C.SetPos(X - m_TexFakeReticule.USize * fScale / 2 + 1,Y - m_TexFakeReticule.VSize * fScale / 2 + 1);
	C.DrawIcon(m_TexFakeReticule,fScale);
	if ( m_Player.bOnlySpectator && ( !m_Player.bBehindView || m_Player.bCheatFlying) )
	{
		m_Player.UpdateSpectatorReticule();
		characterName=m_Player.m_CharacterName;
	}
	else
	{
		m_Player.m_CharacterName="";
		characterName="";
	}
	C.Font=m_SmallFont_14pt;
	C.StrLen(characterName,fStrSizeX,fStrSizeY);
	C.SetPos(X - fStrSizeX / 2,Y + 20);
	C.DrawText(characterName);
}

function DrawCircumstantialActionInfo (Canvas C)
{
	local R6CircumstantialActionQuery Query;
	local int iMnuChoice;
	local int iSubMenu;
	local bool bHasAction;
	local Color TeamColor;
	local R6GameOptions GameOptions;

	if ( m_Player == None )
	{
		return;
	}
	if ( m_Player.m_CurrentCircumstantialAction == None )
	{
		return;
	}
	GameOptions=Class'Actor'.static.GetGameOptions();
	bHasAction=m_Player.m_CurrentCircumstantialAction.iHasAction == 1;
	Query=m_Player.m_CurrentCircumstantialAction;
	C.Style=5;
	if ( m_Player.m_bDisplayMessage && GameOptions.HUDShowActionIcon )
	{
		C.SetDrawColor(m_Player.m_TeamManager.Colors.HUDWhite.R,m_Player.m_TeamManager.Colors.HUDWhite.G,m_Player.m_TeamManager.Colors.HUDWhite.B,m_Player.m_TeamManager.Colors.HUDWhite.A);
		C.SetPos(C.HalfClipX - 24,C.ClipY - 82);
//		C.DrawTile(Texture'SkipText',48.00,48.00,0.00,0.00,32.00,32.00);
		if ( (m_Player.m_iPlayerCAProgress > 0) || m_Player.m_bDisplayActionProgress )
		{
			SetPosAndDrawActionProgress(C);
		}
		return;
	}
	if ( m_Player.bOnlySpectator &&  !m_Player.bBehindView &&  !m_Player.Level.m_bInGamePlanningActive && (GameOptions.HUDShowReticule || m_Player.m_bShowCompleteHUD) )
	{
		DrawSpectatorReticule(C);
	}
	if ( m_Player.bOnlySpectator && (GameOptions.HUDShowActionIcon || m_Player.m_bShowCompleteHUD) )
	{
		if ( m_Player.m_TeamManager != None )
		{
			TeamColor=m_Player.m_TeamManager.Colors.HUDWhite;
		}
		else
		{
			TeamColor=m_Player.m_SpectatorColor;
		}
		C.SetDrawColor(TeamColor.R,TeamColor.G,TeamColor.B,TeamColor.A);
		C.SetPos(C.HalfClipX - 16,C.ClipY - 74);
//		C.DrawTile(Texture'Spectator',32.00,32.00,0.00,0.00,32.00,32.00);
		return;
	}
	if ( m_Player.m_TeamManager == None )
	{
		return;
	}
	if ( (m_Player.m_iPlayerCAProgress > 0) || m_Player.m_bDisplayActionProgress )
	{
		SetPosAndDrawActionProgress(C);
	}
	else
	{
		if ( bHasAction &&  !m_Player.m_bAMenuIsDisplayed )
		{
			if ( Query.iInRange == 0 )
			{
				if (  !m_Player.CanIssueTeamOrder() )
				{
					return;
				}
				TeamColor=m_Player.m_TeamManager.GetTeamColor();
				C.SetDrawColor(m_Player.m_TeamManager.Colors.HUDGrey.R,m_Player.m_TeamManager.Colors.HUDGrey.G,m_Player.m_TeamManager.Colors.HUDGrey.B,m_Player.m_TeamManager.Colors.HUDGrey.A);
			}
			else
			{
				if ( m_Player.Pawn != None )
				{
					if (  !R6Pawn(m_Player.Pawn).CanInteractWithObjects() )
					{
						return;
					}
					C.SetDrawColor(m_Player.m_TeamManager.Colors.HUDWhite.R,m_Player.m_TeamManager.Colors.HUDWhite.G,m_Player.m_TeamManager.Colors.HUDWhite.B,m_Player.m_TeamManager.Colors.HUDWhite.A);
					if ( Query.aQueryTarget == m_Player )
					{
						if (  !m_Player.CanIssueTeamOrder() )
						{
							return;
						}
					}
				}
			}
			if ( GameOptions.HUDShowActionIcon || m_Player.m_bShowCompleteHUD )
			{
				C.SetPos(C.HalfClipX - 16,C.ClipY - 74);
				C.DrawTile(Query.textureIcon,32.00,32.00,0.00,0.00,32.00,32.00);
			}
		}
		else
		{
			if ( bHasAction && bVisible && (Query.iInRange == 0) )
			{
				if (  !m_Player.CanIssueTeamOrder() )
				{
					return;
				}
				DrawTeamActionMnu(C,Query);
			}
		}
	}
}

function SetPosAndDrawActionProgress (Canvas C)
{
	local Color TeamColor;
	local R6GameOptions GameOptions;

	GameOptions=Class'Actor'.static.GetGameOptions();
	if (  !m_Player.Level.m_bInGamePlanningActive )
	{
		TeamColor=m_Player.m_TeamManager.GetTeamColor();
		C.SetDrawColor(m_Player.m_TeamManager.Colors.HUDWhite.R,m_Player.m_TeamManager.Colors.HUDWhite.G,m_Player.m_TeamManager.Colors.HUDWhite.B,m_Player.m_TeamManager.Colors.HUDWhite.A);
		if ( GameOptions.HUDShowReticule || m_Player.m_bShowCompleteHUD )
		{
			DrawActionProgress(C,m_Player.m_iPlayerCAProgress);
		}
		if ( (GameOptions.HUDShowActionIcon || m_Player.m_bShowCompleteHUD) && (m_Player.m_PlayerCurrentCA != None) )
		{
			C.SetPos(C.HalfClipX - 16,C.ClipY - 74);
			C.DrawTile(m_Player.m_PlayerCurrentCA.textureIcon,32.00,32.00,0.00,0.00,32.00,32.00);
			C.SetPos(C.HalfClipX - 24,C.ClipY - 82);
//			C.DrawTile(Texture'CancelAction',48.00,48.00,0.00,0.00,32.00,32.00);
		}
	}
}

function DrawTeamActionMnu (Canvas C, R6CircumstantialActionQuery Query)
{
	local string strAction;
	local int iAction;
	local float fPosX;
	local float fPosY;
	local Color TeamColor;
	local float fTextSizeX;
	local float fTextSizeY;
	local float fScaleX;
	local float fScaleY;

	DrawRoseDesVents(C,m_iCurrentMnuChoice);
	C.OrgX=0.00;
	C.OrgY=0.00;
	C.UseVirtualSize(False);
	fScaleX=C.SizeX / 800.00;
	fScaleY=C.SizeY / 600.00;
	TeamColor=m_Player.m_TeamManager.GetTeamColor();
	fPosX=C.SizeX / 2.00 + fScaleX;
	fPosY=C.SizeY / 2.00 + fScaleY;
	fTextSizeX=75.00;
	fTextSizeY=32.00;
	iAction=0;
JL0102:
	if ( iAction < 4 )
	{
		if ( MenuItemEnabled(iAction) )
		{
			if ( m_iCurrentMnuChoice != iAction )
			{
				C.SetDrawColor(m_Player.m_TeamManager.Colors.HUDGrey.R,m_Player.m_TeamManager.Colors.HUDGrey.G,m_Player.m_TeamManager.Colors.HUDGrey.B,m_Player.m_TeamManager.Colors.HUDGrey.A);
			}
			else
			{
				C.SetDrawColor(m_Player.m_TeamManager.Colors.HUDWhite.R,m_Player.m_TeamManager.Colors.HUDWhite.G,m_Player.m_TeamManager.Colors.HUDWhite.B,m_Player.m_TeamManager.Colors.HUDWhite.A);
			}
		}
		else
		{
			C.SetDrawColor(m_Player.m_TeamManager.Colors.HUDGrey.R,m_Player.m_TeamManager.Colors.HUDGrey.G,m_Player.m_TeamManager.Colors.HUDGrey.B,m_Player.m_TeamManager.Colors.HUDGrey.A);
		}
		if ( m_iCurrentSubMnuChoice == -1 )
		{
			strAction=Query.aQueryTarget.R6GetCircumstantialActionString(Query.iTeamActionIDList[iAction]);
		}
		else
		{
			strAction=Query.aQueryTarget.R6GetCircumstantialActionString(Query.iTeamSubActionsIDList[m_iCurrentSubMnuChoice * 4 + iAction]);
		}
		C.Style=3;
		switch (iAction)
		{
			case 0:
			DrawTextCenteredInBox(C,strAction,fPosX - fTextSizeX * fScaleX / 2.00,fPosY - (50 + fTextSizeY) * fScaleY,fTextSizeX * fScaleX,fTextSizeY * fScaleY);
			break;
			case 1:
			DrawTextCenteredInBox(C,strAction,fPosX + 35 * fScaleX,fPosY - fTextSizeY / 2 * fScaleY,fTextSizeX * fScaleX,fTextSizeY * fScaleY);
			break;
			case 2:
			DrawTextCenteredInBox(C,strAction,fPosX - fTextSizeX * fScaleX / 2.00,fPosY + 50 * fScaleY,fTextSizeX * fScaleX,fTextSizeY * fScaleY);
			break;
			case 3:
			DrawTextCenteredInBox(C,strAction,fPosX - (35 + fTextSizeX) * fScaleX,fPosY - fTextSizeY / 2 * fScaleY,fTextSizeX * fScaleX,fTextSizeY * fScaleY);
			break;
			default:
		}
		iAction++;
		goto JL0102;
	}
	C.OrgX=0.00;
	C.OrgY=0.00;
	C.SetDrawColor(TeamColor.R,TeamColor.R,TeamColor.R,TeamColor.A);
}

function DrawActionProgress (Canvas C, float fProgress)
{
	local int iItem;
	local int fDegreeProgress;

	iItem=0;
JL0007:
	if ( iItem * 30 < 360.00 )
	{
		C.SetPos((C.ClipX - m_TexProgressCircle.USize) * 0.50,(C.ClipY - m_TexProgressCircle.VSize) * 0.50);
		C.DrawTile(m_TexProgressCircle,m_TexProgressCircle.USize,m_TexProgressCircle.VSize,0.00,0.00,m_TexProgressCircle.USize,m_TexProgressCircle.VSize,iItem * 30 * 3.14 / 180);
		iItem++;
		goto JL0007;
	}
	fDegreeProgress=fProgress * 3.60;
	iItem=1;
JL010E:
	if ( iItem * 30 < fDegreeProgress )
	{
		C.SetPos((C.ClipX - m_TexProgressItem.USize) * 0.50,(C.ClipY - m_TexProgressItem.VSize) * 0.50);
		C.DrawTile(m_TexProgressItem,m_TexProgressItem.USize,m_TexProgressItem.VSize,0.00,0.00,m_TexProgressItem.USize,m_TexProgressItem.VSize,(iItem - 1) * 30 * 3.14 / 180);
		iItem++;
		goto JL010E;
	}
}

defaultproperties
{
    m_ActionKey="Action"
}
/*    m_TexProgressCircle=Texture'R6HUD.ProgressCircle'
    m_TexProgressItem=Texture'R6HUD.ProgressItem'
    m_TexFakeReticule=Texture'R6TexturesReticule.Dot'*/
//    m_SmallFont_14pt=Font'R6Font.Rainbow6_14pt'

