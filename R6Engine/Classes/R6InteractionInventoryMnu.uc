//================================================================================
// R6InteractionInventoryMnu.
//================================================================================
class R6InteractionInventoryMnu extends R6InteractionRoseDesVents;

function ActionKeyPressed ()
{
	if ( m_Player.bOnlySpectator )
	{
		return;
	}
	DisplayMenu(True);
}

function bool IsValidMenuChoice (int iChoice)
{
	if ( (iChoice < 0) || (iChoice > 3) || (m_Player.m_pawn.m_WeaponsCarried[iChoice] == None) ||  !m_Player.m_pawn.m_WeaponsCarried[iChoice].HasAmmo() )
	{
		return False;
	}
	return True;
}

function SetMenuChoice (int iChoice)
{
	if ( (iChoice < 0) || (iChoice > 3) )
	{
		m_iCurrentMnuChoice=-1;
	}
	else
	{
		if ( (m_Player.m_pawn.m_WeaponsCarried[iChoice] != None) && m_Player.m_pawn.m_WeaponsCarried[iChoice].HasAmmo() )
		{
			m_iCurrentMnuChoice=iChoice;
		}
		else
		{
			SetMenuChoice(iChoice - 1);
		}
	}
}

function ItemClicked (int iItem)
{
	if ( bShowLog )
	{
		Log("**** LeftMouse -> Change weapon ! ****");
	}
	if ( iItem != -1 )
	{
		m_Player.SwitchWeapon(iItem + 1);
	}
}

function PostRender (Canvas C)
{
	C.UseVirtualSize(True);
	DrawInventoryMenu(C);
	C.UseVirtualSize(False);
}

function DrawInventoryMenu (Canvas C)
{
	local string strWeapon[4];
	local Color TextColor[4];
	local int iWeapon;
	local R6Rainbow PlayerPawn;
	local Texture weaponIcon;
	local float fPosX;
	local float fPosY;
	local float fTextSizeX;
	local float fTextSizeY;
	local float fScaleX;
	local float fScaleY;
	local bool bPrimaryGadgetSet;
	local bool bSecondaryGadgetSet;
	local R6EngineWeapon pWeapon;

	if ( m_Player == None )
	{
		return;
	}
	if ( m_Player.bOnlySpectator || m_Player.bCheatFlying )
	{
		return;
	}
	PlayerPawn=m_Player.m_pawn;
	if ( (PlayerPawn == None) ||  !bVisible )
	{
		return;
	}
	DrawRoseDesVents(C,m_iCurrentMnuChoice);
	fScaleX=C.SizeX / 800.00;
	fScaleY=C.SizeY / 600.00;
	fPosX=C.SizeX / 2.00 + fScaleX;
	fPosY=C.SizeY / 2.00 + fScaleY;
	iWeapon=0;
JL00FC:
	if ( iWeapon < 2 )
	{
		if ( PlayerPawn.m_WeaponsCarried[iWeapon] != None )
		{
			strWeapon[iWeapon]=PlayerPawn.m_WeaponsCarried[iWeapon].m_WeaponShortName;
			if ( PlayerPawn.m_WeaponsCarried[iWeapon].HasAmmo() )
			{
				TextColor[iWeapon]=m_Player.m_TeamManager.Colors.HUDWhite;
			}
			else
			{
				TextColor[iWeapon]=m_Player.m_TeamManager.Colors.HUDGrey;
			}
		}
		else
		{
			strWeapon[iWeapon]=Localize("MISC","ID_EMPTY","R6Common");
			TextColor[iWeapon]=m_Player.m_TeamManager.Colors.HUDGrey;
		}
		iWeapon++;
		goto JL00FC;
	}
	pWeapon=PlayerPawn.m_WeaponsCarried[2];
	if ( (pWeapon != None) && pWeapon.HasAmmo() )
	{
		strWeapon[2]=Localize(pWeapon.m_NameID,"ID_NAME","R6Gadgets");
		bPrimaryGadgetSet=True;
		TextColor[2]=m_Player.m_TeamManager.Colors.HUDWhite;
	}
	pWeapon=PlayerPawn.m_WeaponsCarried[3];
	if ( (pWeapon != None) && pWeapon.HasAmmo() )
	{
		strWeapon[3]=Localize(pWeapon.m_NameID,"ID_NAME","R6Gadgets");
		bSecondaryGadgetSet=True;
		TextColor[3]=m_Player.m_TeamManager.Colors.HUDWhite;
	}
	if ( PlayerPawn.m_bHasLockPickKit )
	{
		if (  !bPrimaryGadgetSet )
		{
			strWeapon[2]=Localize("LOCKPICKKIT","ID_NAME","R6Gadgets");
			bPrimaryGadgetSet=True;
			TextColor[2]=m_Player.m_TeamManager.Colors.HUDGrey;
		}
		else
		{
			if (  !bSecondaryGadgetSet )
			{
				strWeapon[3]=Localize("LOCKPICKKIT","ID_NAME","R6Gadgets");
				bSecondaryGadgetSet=True;
				TextColor[3]=m_Player.m_TeamManager.Colors.HUDGrey;
			}
		}
	}
	if ( PlayerPawn.m_bHasDiffuseKit )
	{
		if (  !bPrimaryGadgetSet )
		{
			strWeapon[2]=Localize("DIFFUSEKIT","ID_NAME","R6Gadgets");
			bPrimaryGadgetSet=True;
			TextColor[2]=m_Player.m_TeamManager.Colors.HUDGrey;
		}
		else
		{
			if (  !bSecondaryGadgetSet )
			{
				strWeapon[3]=Localize("DIFFUSEKIT","ID_NAME","R6Gadgets");
				bSecondaryGadgetSet=True;
				TextColor[3]=m_Player.m_TeamManager.Colors.HUDGrey;
			}
		}
	}
	if ( PlayerPawn.m_bHasElectronicsKit )
	{
		if (  !bPrimaryGadgetSet )
		{
			strWeapon[2]=Localize("ELECTRONICKIT","ID_NAME","R6Gadgets");
			bPrimaryGadgetSet=True;
			TextColor[2]=m_Player.m_TeamManager.Colors.HUDGrey;
		}
		else
		{
			if (  !bSecondaryGadgetSet )
			{
				strWeapon[3]=Localize("ELECTRONICKIT","ID_NAME","R6Gadgets");
				bSecondaryGadgetSet=True;
				TextColor[3]=m_Player.m_TeamManager.Colors.HUDGrey;
			}
		}
	}
	if ( PlayerPawn.m_bHaveGasMask )
	{
		if (  !bPrimaryGadgetSet )
		{
			strWeapon[2]=Localize("GASMASK","ID_NAME","R6Gadgets");
			bPrimaryGadgetSet=True;
			TextColor[2]=m_Player.m_TeamManager.Colors.HUDGrey;
		}
		else
		{
			if (  !bSecondaryGadgetSet )
			{
				strWeapon[3]=Localize("GASMASK","ID_NAME","R6Gadgets");
				bSecondaryGadgetSet=True;
				TextColor[3]=m_Player.m_TeamManager.Colors.HUDGrey;
			}
		}
	}
	if (  !bPrimaryGadgetSet )
	{
		strWeapon[2]=Localize("MISC","ID_EMPTY","R6Common");
		bPrimaryGadgetSet=True;
		TextColor[2]=m_Player.m_TeamManager.Colors.HUDGrey;
	}
	if (  !bSecondaryGadgetSet )
	{
		strWeapon[3]=Localize("MISC","ID_EMPTY","R6Common");
		bSecondaryGadgetSet=True;
		TextColor[3]=m_Player.m_TeamManager.Colors.HUDGrey;
	}
	fTextSizeX=75.00;
	fTextSizeY=32.00;
	C.Style=3;
	C.UseVirtualSize(False);
	iWeapon=0;
JL080F:
	if ( iWeapon < 4 )
	{
		C.SetDrawColor(TextColor[iWeapon].R,TextColor[iWeapon].G,TextColor[iWeapon].B,TextColor[iWeapon].A);
		switch (iWeapon)
		{
			case 0:
			DrawTextCenteredInBox(C,strWeapon[iWeapon],fPosX - fTextSizeX * fScaleX / 2.00,fPosY - (50 + fTextSizeY) * fScaleY,fTextSizeX * fScaleX,fTextSizeY * fScaleY);
			break;
			case 1:
			DrawTextCenteredInBox(C,strWeapon[iWeapon],fPosX + 35 * fScaleX,fPosY - fTextSizeY / 2 * fScaleY,fTextSizeX * fScaleX,fTextSizeY * fScaleY);
			break;
			case 2:
			DrawTextCenteredInBox(C,strWeapon[iWeapon],fPosX - fTextSizeX * fScaleX / 2.00,fPosY + 50 * fScaleY,fTextSizeX * fScaleX,fTextSizeY * fScaleY);
			break;
			case 3:
			DrawTextCenteredInBox(C,strWeapon[iWeapon],fPosX - (35 + fTextSizeX) * fScaleX,fPosY - fTextSizeY / 2 * fScaleY,fTextSizeX * fScaleX,fTextSizeY * fScaleY);
			break;
			default:
		}
		iWeapon++;
		goto JL080F;
	}
	C.OrgX=0.00;
	C.OrgY=0.00;
}

defaultproperties
{
    m_ActionKey="InventoryMenu"
}
