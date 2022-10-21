//================================================================================
// R6InteractionRoseDesVents.
//================================================================================
class R6InteractionRoseDesVents extends Interaction
	Abstract;

const C_RoseDesVentSize= 150;
var int m_iCurrentMnuChoice;
var int m_iCurrentSubMnuChoice;
var const int C_iMouseDelta;
var bool m_bActionKeyDown;
var bool m_bIgnoreNextActionKeyRelease;
var bool bShowLog;
var float m_iTextureWidth;
var float m_iTextureHeight;
var R6PlayerController m_Player;
var Texture m_TexMNU;
var Texture m_TexMNUItemNormalTop;
var Texture m_TexMNUItemNormalLeft;
var Texture m_TexMNUItemNormalSubTop;
var Texture m_TexMNUItemNormalSubLeft;
var Texture m_TexMNUItemSelectedSubTop;
var Texture m_TexMNUItemSelectedSubLeft;
var Texture m_TexMNUItemSelectedTop;
var Texture m_TexMNUItemSelectedLeft;
var Font m_Font;
var Sound m_RoseOpenSnd;
var Sound m_RoseSelectSnd;
var Color m_color;
var string m_ActionKey;

event Initialized ()
{
	Super.Initialized();
	m_Player=R6PlayerController(ViewportOwner.Actor);
}

function GotoSubMenu ();

function bool IsValidMenuChoice (int iChoice);

function SetMenuChoice (int iChoice);

function NoItemSelected ();

function ItemRightClicked (int iItem);

function ItemClicked (int iItem);

function ActionKeyPressed ();

function ActionKeyReleased ();

function bool ItemHasSubMenu (int iItem);

function bool MenuItemEnabled (int iItem)
{
	return True;
}

function bool CurrentItemHasSubMenu ()
{
	return False;
}

function int GetCurrentMenuChoice ()
{
	return m_iCurrentMnuChoice;
}

function int GetCurrentSubMenuChoice ()
{
	return m_iCurrentSubMnuChoice;
}

function DisplayMenu (bool bDisplay, optional bool bOpen)
{
	bVisible=bDisplay;
	m_iCurrentMnuChoice=-1;
	m_iCurrentSubMnuChoice=-1;
	m_Player.m_bAMenuIsDisplayed=bDisplay;
	if (  !bVisible )
	{
		GotoState('None');
	}
	else
	{
//		m_Player.PlaySound(m_RoseOpenSnd,9);
		GotoState('MenuDisplayed');
		SetMenuChoice(0);
	}
}

function bool KeyEvent (EInputKey eKey, EInputAction eAction, float fDelta)
{
	if ( eKey == m_Player.GetKey(m_ActionKey) )
	{
		if ( (eAction == 1) &&  !m_bActionKeyDown )
		{
			m_bActionKeyDown=True;
			ActionKeyPressed();
			return True;
		}
		if ( (eAction == 3) && m_bActionKeyDown )
		{
			if (  !m_bIgnoreNextActionKeyRelease )
			{
				ActionKeyReleased();
			}
			else
			{
				m_bIgnoreNextActionKeyRelease=False;
			}
			m_bActionKeyDown=False;
			return True;
		}
	}
	return Super.KeyEvent(eKey,eAction,fDelta);
}

state MenuDisplayed
{
	function bool KeyEvent (EInputKey eKey, EInputAction eAction, float fDelta)
	{
		local int iCurrentMnuChoice;

		if ( (eKey == m_Player.GetKey(m_ActionKey)) && (eAction == 3) )
		{
			NoItemSelected();
			DisplayMenu(False);
			m_bActionKeyDown=False;
			m_bIgnoreNextActionKeyRelease=False;
			return True;
		}
		if ( (eKey == 1) && (eAction == 1) )
		{
			if (  !MenuItemEnabled(m_iCurrentMnuChoice) )
			{
				return True;
			}
			else
			{
				if ( CurrentItemHasSubMenu() )
				{
//					m_Player.PlaySound(m_RoseSelectSnd,9);
					GotoSubMenu();
					if ( bShowLog )
					{
						Log("**** LeftMouse -> Move to sub menu ! ****");
					}
				}
				else
				{
//					m_Player.PlaySound(m_RoseSelectSnd,9);
					ItemClicked(m_iCurrentMnuChoice);
					DisplayMenu(False);
					m_bIgnoreNextActionKeyRelease=True;
				}
			}
			return True;
		}
		if ( (eKey == 2) && (eAction == 1) )
		{
			if (  !MenuItemEnabled(m_iCurrentMnuChoice) )
			{
				return True;
			}
			else
			{
				if ( CurrentItemHasSubMenu() )
				{
//					m_Player.PlaySound(m_RoseSelectSnd,9);
					GotoSubMenu();
				}
				else
				{
//					m_Player.PlaySound(m_RoseSelectSnd,9);
					ItemRightClicked(m_iCurrentMnuChoice);
					DisplayMenu(False);
					m_bIgnoreNextActionKeyRelease=True;
				}
			}
			return True;
		}
		if ( eAction == 4 )
		{
			switch (eKey)
			{
/*				case 228:
				if ( Abs(fDelta) > C_iMouseDelta )
				{
					if ( fDelta > 0 )
					{
						SetMenuChoice(1);
					}
					else
					{
						SetMenuChoice(3);
					}
				}
				return True;
				break;
				case 229:
				if ( Abs(fDelta) > C_iMouseDelta )
				{
					if ( fDelta > 0 )
					{
						SetMenuChoice(0);
					}
					else
					{
						SetMenuChoice(2);
					}
				}
				return True;
				break;
				default:     */
			}
		}
		if ( (eKey == 236) && (eAction == 1) )
		{
			SetMenuChoice(m_iCurrentMnuChoice + 1);
			if ( m_iCurrentMnuChoice == -1 )
			{
				SetMenuChoice(0);
			}
			return True;
		}
		if ( (eKey == 237) && (eAction == 1) )
		{
			SetMenuChoice(m_iCurrentMnuChoice - 1);
			if ( m_iCurrentMnuChoice == -1 )
			{
				SetMenuChoice(3);
			}
			return True;
		}
		return Super(Interaction).KeyEvent(eKey,eAction,fDelta);
	}

}

function DrawRoseDesVents (Canvas C, int iMnuChoice)
{
	local int iItem;
	local int iUStart;
	local int iUEnd;
	local float fPosX;
	local float fPosY;
	local float fCenterX;
	local float fCenterY;
	local Color TeamColor;
	local float fScaleX;
	local float fScaleY;
	local Texture CurrentTexture;
	local bool bFlip;
	local bool bHasSubMenu;
	local bool bIsCurrent;

	TeamColor=m_color;
	C.UseVirtualSize(False);
	fScaleX=C.SizeX / 800.00;
	fScaleY=C.SizeY / 600.00;
	fCenterX=C.SizeX / 2.00 + fScaleX;
	fCenterY=C.SizeY / 2.00 + fScaleY;
	C.Font=m_Font;
	C.SetDrawColor(TeamColor.R,TeamColor.G,TeamColor.B,255);
	C.Style=5;
	C.SetPos(fCenterX - (150 + 5) * fScaleX,fCenterY - (150 + 5) * fScaleY);
	C.DrawTile(m_TexMNU,(150.00 * 2 + 10) * fScaleX,(150.00 * 2 + 10) * fScaleY,0.00,0.00,512.00,512.00);
	iItem=0;
JL0181:
	if ( iItem < 4 )
	{
		if ( iItem == iMnuChoice )
		{
			bIsCurrent=True;
		}
		else
		{
			bIsCurrent=False;
		}
		bHasSubMenu=ItemHasSubMenu(iItem);
		switch (iItem)
		{
/*			case 0:
			fPosX=fCenterX - 150 / 2 * fScaleX;
			fPosY=fCenterY - 150 * fScaleY;
			if ( MenuItemEnabled(iItem) )
			{
				if (  !bHasSubMenu )
				{
					if ( bIsCurrent )
					{
						CurrentTexture=m_TexMNUItemSelectedTop;
					}
					else
					{
						CurrentTexture=m_TexMNUItemNormalTop;
					}
				}
				else
				{
					if ( bIsCurrent )
					{
						CurrentTexture=m_TexMNUItemSelectedSubTop;
					}
					else
					{
						CurrentTexture=m_TexMNUItemNormalSubTop;
					}
				}
			}
			else
			{
				CurrentTexture=m_TexMNUItemNormalTop;
			}
			break;
			case 1:
			fPosX=fCenterX;
			fPosY=fCenterY - 150 / 2 * fScaleY;
			if ( MenuItemEnabled(iItem) )
			{
				if (  !bHasSubMenu )
				{
					if ( bIsCurrent )
					{
						CurrentTexture=m_TexMNUItemSelectedLeft;
					}
					else
					{
						CurrentTexture=m_TexMNUItemNormalLeft;
					}
				}
				else
				{
					if ( bIsCurrent )
					{
						CurrentTexture=m_TexMNUItemSelectedSubLeft;
					}
					else
					{
						CurrentTexture=m_TexMNUItemNormalSubLeft;
					}
				}
			}
			else
			{
				CurrentTexture=m_TexMNUItemNormalLeft;
			}
			break;
			case 2:
			fPosX=fCenterX - 150 / 2 * fScaleX;
			fPosY=fCenterY;
			bFlip=True;
			if ( MenuItemEnabled(iItem) )
			{
				if (  !bHasSubMenu )
				{
					if ( bIsCurrent )
					{
						CurrentTexture=m_TexMNUItemSelectedTop;
					}
					else
					{
						CurrentTexture=m_TexMNUItemNormalTop;
					}
				}
				else
				{
					if ( bIsCurrent )
					{
						CurrentTexture=m_TexMNUItemSelectedSubTop;
					}
					else
					{
						CurrentTexture=m_TexMNUItemNormalSubTop;
					}
				}
			}
			else
			{
				CurrentTexture=m_TexMNUItemNormalTop;
			}
			break;
			case 3:
			fPosX=fCenterX - 150 * fScaleX;
			fPosY=fCenterY - 150 / 2 * fScaleY;
			bFlip=True;
			if ( MenuItemEnabled(iItem) )
			{
				if (  !bHasSubMenu )
				{
					if ( bIsCurrent )
					{
						CurrentTexture=m_TexMNUItemSelectedLeft;
					}
					else
					{
						CurrentTexture=m_TexMNUItemNormalLeft;
					}
				}
				else
				{
					if ( bIsCurrent )
					{
						CurrentTexture=m_TexMNUItemSelectedSubLeft;
					}
					else
					{
						CurrentTexture=m_TexMNUItemNormalSubLeft;
					}
				}
			}
			else
			{
				CurrentTexture=m_TexMNUItemNormalLeft;
			}
			break;
			default:   */
		}
		C.SetPos(fPosX,fPosY);
		if ( bFlip )
		{
			C.DrawTile(CurrentTexture,150.00 * fScaleX,150.00 * fScaleY,m_iTextureWidth,m_iTextureHeight, -m_iTextureWidth, -m_iTextureHeight);
		}
		else
		{
			C.DrawTile(CurrentTexture,150.00 * fScaleX,150.00 * fScaleY,0.00,0.00,m_iTextureWidth,m_iTextureHeight);
		}
		iItem++;
		goto JL0181;
	}
}

function DrawTextCenteredInBox (Canvas C, string strText, float fPosX, float fPosY, float fWidth, float fHeight)
{
	local float fTextWidth;
	local float fTextHeight;
	local bool bBackCenter;
	local float fBackOrgX;
	local float fBackOrgY;
	local float fBackClipX;
	local float fBackClipY;

	bBackCenter=C.bCenter;
	fBackOrgX=C.OrgX;
	fBackOrgY=C.OrgY;
	fBackClipX=C.ClipX;
	fBackClipY=C.ClipY;
	C.bCenter=True;
	C.OrgX=fPosX;
	C.OrgY=fPosY;
	C.ClipX=fWidth;
	C.ClipY=fHeight;
	C.StrLen(strText,fTextWidth,fTextHeight);
	C.SetPos(0.00,(fHeight - fTextHeight) / 2.00);
	C.DrawText(strText);
	C.bCenter=bBackCenter;
	C.OrgX=fBackOrgX;
	C.OrgY=fBackOrgY;
	C.ClipX=fBackClipX;
	C.ClipY=fBackClipY;
}

defaultproperties
{
    m_iCurrentMnuChoice=-1
    m_iCurrentSubMnuChoice=-1
    C_iMouseDelta=5
    m_iTextureWidth=256.00
    m_iTextureHeight=256.00
}
/*
    m_TexMNU=Texture'R6HUD.QuadDisplay_back'
    m_TexMNUItemNormalTop=Texture'R6HUD.QuadDisplay_01_Ver'
    m_TexMNUItemNormalLeft=Texture'R6HUD.QuadDisplay_01_Hori'
    m_TexMNUItemNormalSubTop=Texture'R6HUD.QuadDisplay_02_Ver'
    m_TexMNUItemNormalSubLeft=Texture'R6HUD.QuadDisplay_02_Hori'
    m_TexMNUItemSelectedSubTop=Texture'R6HUD.QuadDisplay_03_Ver'
    m_TexMNUItemSelectedSubLeft=Texture'R6HUD.QuadDisplay_03_Hori'
    m_TexMNUItemSelectedTop=Texture'R6HUD.QuadDisplay_04_Ver'
    m_TexMNUItemSelectedLeft=Texture'R6HUD.QuadDisplay_04_Hori'
    m_Font=Font'R6Font.Rainbow6_14pt'
    m_RoseOpenSnd=Sound'SFX_Menus.Play_Rose_Open'
    m_RoseSelectSnd=Sound'SFX_Menus.Play_Rose_Select'
*/
