//================================================================================
// R6OperativeSelectorItem.
//================================================================================
class R6OperativeSelectorItem extends UWindowDialogControl;

var byte m_eHealth;
var int m_iOperativeIndex;
var int m_iTeam;
var const int NameX;
var const int NameY;
var const int SpecX;
var const int SpecY;
var const int WeaponX;
var const int WeaponY;
var const int WeaponHeight;
var const int LifeX;
var const int LifeY;
var bool m_bMouseOver;
var bool m_bIsDead;
var bool m_bIsSinglePlayer;
var R6Rainbow m_Operative;
var R6TeamMemberReplicationInfo m_MemberRepInfo;
var Sound m_OperativeSelectSnd;
var Material HealthIconTexture;
var Material DefaultFaceTexture;
var Color m_DarkColor;
var Color m_NormalColor;
var Plane DefaultFaceCoords;
var string m_szSpeciality;
var string m_WeaponsName[4];
var string m_szName;

function LMouseDown (float X, float Y)
{
	local R6PlayerController PlayerOwner;
	local R6RainbowTeam TeamManager;

	if ( m_bIsDead )
	{
		return;
	}
	PlayerOwner=R6PlayerController(GetPlayerOwner());
//	PlayerOwner.PlaySound(m_OperativeSelectSnd,9);
	if (  !m_bIsSinglePlayer )
	{
		PlayerOwner.ChangeOperative(0,m_MemberRepInfo.m_iTeamPosition);
	}
	else
	{
		if (  !m_Operative.m_bIsPlayer )
		{
			TeamManager=R6RainbowAI(m_Operative.Controller).m_TeamManager;
		}
		else
		{
			TeamManager=R6PlayerController(m_Operative.Controller).m_TeamManager;
		}
		PlayerOwner.ChangeOperative(TeamManager.m_iRainbowTeamName,m_Operative.m_iID);
	}
//	Root.ChangeCurrentWidget(0);
}

function SetCharacterInfo (R6Rainbow Character)
{
	local int iWeapon;

	m_Operative=Character;
	m_MemberRepInfo=None;
	m_bIsSinglePlayer=True;
	iWeapon=0;
JL0021:
	if ( iWeapon < 4 )
	{
		if ( m_Operative.m_WeaponsCarried[iWeapon] != None )
		{
			m_WeaponsName[iWeapon]=m_Operative.m_WeaponsCarried[iWeapon].m_WeaponShortName;
		}
		else
		{
			if ( (iWeapon == 2) && (m_Operative.m_szPrimaryItem != "") )
			{
				m_WeaponsName[iWeapon]=Localize(m_Operative.m_szPrimaryItem,"ID_NAME","R6Gadgets");
			}
			else
			{
				if ( (iWeapon == 3) && (m_Operative.m_szSecondaryItem != "") )
				{
					m_WeaponsName[iWeapon]=Localize(m_Operative.m_szSecondaryItem,"ID_NAME","R6Gadgets");
				}
			}
		}
		iWeapon++;
		goto JL0021;
	}
}

function SetCharacterInfoMP (R6TeamMemberReplicationInfo repInfo)
{
	m_MemberRepInfo=repInfo;
	m_Operative=None;
	m_bIsSinglePlayer=False;
	if ( m_MemberRepInfo.m_PrimaryWeapon != "" )
	{
		m_WeaponsName[0]=Localize(m_MemberRepInfo.m_PrimaryWeapon,"ID_NAME","R6Weapons");
	}
	else
	{
		m_WeaponsName[0]=Localize("MISC","ID_EMPTY","R6Common");
	}
	if ( m_MemberRepInfo.m_SecondaryWeapon != "" )
	{
		m_WeaponsName[1]=Localize(m_MemberRepInfo.m_SecondaryWeapon,"ID_NAME","R6Weapons");
	}
	else
	{
		m_WeaponsName[1]=Localize("MISC","ID_EMPTY","R6Common");
	}
	if ( m_MemberRepInfo.m_PrimaryGadget != "" )
	{
		m_WeaponsName[2]=Localize(m_MemberRepInfo.m_PrimaryGadget,"ID_NAME","R6Gadgets");
	}
	if ( m_MemberRepInfo.m_SecondaryGadget != "" )
	{
		m_WeaponsName[3]=Localize(m_MemberRepInfo.m_SecondaryGadget,"ID_NAME","R6Gadgets");
	}
}

function MouseEnter ()
{
	Super.MouseEnter();
	m_bMouseOver=True;
}

function MouseLeave ()
{
	Super.MouseLeave();
	m_bMouseOver=False;
}

function UpdateGadgets ()
{
	local bool bIsPrimaryGadgetEmpty;
	local bool bIsPrimaryGadgetSet;
	local bool bIsSecondaryGadgetEmpty;
	local bool bIsSecondaryGadgetSet;

	if ( m_Operative.m_WeaponsCarried[2] != None )
	{
		if ( m_Operative.m_WeaponsCarried[2].HasAmmo() )
		{
			m_WeaponsName[2]=Localize(m_Operative.m_WeaponsCarried[2].m_NameID,"ID_NAME","R6Gadgets");
		}
		else
		{
			m_WeaponsName[2]=Localize("MISC","ID_EMPTY","R6Common");
		}
		bIsPrimaryGadgetSet=True;
	}
	if ( m_Operative.m_WeaponsCarried[3] != None )
	{
		if ( m_Operative.m_WeaponsCarried[3].HasAmmo() )
		{
			m_WeaponsName[3]=Localize(m_Operative.m_WeaponsCarried[3].m_NameID,"ID_NAME","R6Gadgets");
		}
		else
		{
			m_WeaponsName[3]=Localize("MISC","ID_EMPTY","R6Common");
		}
		bIsSecondaryGadgetSet=True;
	}
	if ( m_Operative.m_bHasLockPickKit )
	{
		if (  !bIsPrimaryGadgetSet )
		{
			m_WeaponsName[2]=Localize("LOCKPICKKIT","ID_NAME","R6Gadgets");
			bIsPrimaryGadgetSet=True;
		}
		else
		{
			if (  !bIsSecondaryGadgetSet )
			{
				m_WeaponsName[3]=Localize("LOCKPICKKIT","ID_NAME","R6Gadgets");
				bIsSecondaryGadgetSet=True;
			}
		}
	}
	if ( m_Operative.m_bHasDiffuseKit )
	{
		if (  !bIsPrimaryGadgetSet )
		{
			m_WeaponsName[2]=Localize("DIFFUSEKIT","ID_NAME","R6Gadgets");
			bIsPrimaryGadgetSet=True;
		}
		else
		{
			if (  !bIsSecondaryGadgetSet )
			{
				m_WeaponsName[3]=Localize("DIFFUSEKIT","ID_NAME","R6Gadgets");
				bIsSecondaryGadgetSet=True;
			}
		}
	}
	if ( m_Operative.m_bHasElectronicsKit )
	{
		if (  !bIsPrimaryGadgetSet )
		{
			m_WeaponsName[2]=Localize("ELECTRONICKIT","ID_NAME","R6Gadgets");
			bIsPrimaryGadgetSet=True;
		}
		else
		{
			if (  !bIsSecondaryGadgetSet )
			{
				m_WeaponsName[3]=Localize("ELECTRONICKIT","ID_NAME","R6Gadgets");
				bIsSecondaryGadgetSet=True;
			}
		}
	}
	if ( m_Operative.m_bHaveGasMask )
	{
		if (  !bIsPrimaryGadgetSet )
		{
			m_WeaponsName[2]=Localize("GASMASK","ID_NAME","R6Gadgets");
			bIsPrimaryGadgetSet=True;
		}
		else
		{
			if (  !bIsSecondaryGadgetSet )
			{
				m_WeaponsName[3]=Localize("GASMASK","ID_NAME","R6Gadgets");
				bIsSecondaryGadgetSet=True;
			}
		}
	}
	if (  !bIsPrimaryGadgetSet )
	{
		m_WeaponsName[2]=Localize("MISC","ID_EMPTY","R6Common");
	}
	if (  !bIsSecondaryGadgetSet )
	{
		m_WeaponsName[3]=Localize("MISC","ID_EMPTY","R6Common");
	}
}

function UpdatePosition ()
{
	WinTop=Class'R6MenuInGameOperativeSelectorWidget'.Default.c_OutsideMarginY + Class'R6MenuInGameOperativeSelectorWidget'.Default.c_InsideMarginY + m_Operative.m_iID * (Class'R6MenuInGameOperativeSelectorWidget'.Default.c_InsideMarginY + Class'R6MenuInGameOperativeSelectorWidget'.Default.c_RowHeight);
}

function UpdatePositionMP ()
{
	if ( m_MemberRepInfo != None )
	{
		WinTop=Class'R6MenuInGameOperativeSelectorWidget'.Default.c_OutsideMarginY + Class'R6MenuInGameOperativeSelectorWidget'.Default.c_InsideMarginY + m_MemberRepInfo.m_iTeamPosition * (Class'R6MenuInGameOperativeSelectorWidget'.Default.c_InsideMarginY + Class'R6MenuInGameOperativeSelectorWidget'.Default.c_RowHeight);
	}
}

function Paint (Canvas C, float X, float Y)
{
	local int iLifeU;
	local int iWeapon;
	local bool bIsDead;
	local bool bCurrentSelection;
	local byte NameAlpha;
	local Color NameColor;
	local Color NameBackgroundColor;
	local byte NameBackgroundAlpha;
	local byte SpecAlpha;
	local Color SpecColor;
	local Color SpecAndWeaponBackgroundColor;
	local byte SpecAndWeaponBackgroundAlpha;
	local Color WeaponColor;
	local byte WeaponAlpha;
	local byte FaceAlpha;
	local Color LineColor;
	local byte LineAlpha;
	local string Name;
	local bool bIsPrimaryGadgetEmpty;
	local bool bIsSecondaryGadgetEmpty;
	local float fPosX;
	local float fPosY;
	local PlayerController PlayerOwner;

	PlayerOwner=GetPlayerOwner();
	if ( m_bIsSinglePlayer )
	{
		if ( PlayerOwner.ViewTarget == m_Operative )
		{
			bCurrentSelection=True;
		}
		else
		{
			bCurrentSelection=False;
		}
		m_eHealth=m_Operative.m_eHealth;
//		m_bIsDead=m_eHealth >= m_Operative.2;
		UpdateGadgets();
		bIsPrimaryGadgetEmpty=False;
		bIsSecondaryGadgetEmpty=False;
	}
	else
	{
		if ( m_MemberRepInfo == R6Pawn(PlayerOwner.Pawn).m_TeamMemberRepInfo )
		{
			bCurrentSelection=True;
		}
		else
		{
			bCurrentSelection=False;
		}
		m_eHealth=m_MemberRepInfo.m_eHealth;
//		m_bIsDead=m_eHealth >= PlayerOwner.Pawn.2;
		bIsPrimaryGadgetEmpty=m_MemberRepInfo.m_bIsPrimaryGadgetEmpty;
		bIsSecondaryGadgetEmpty=m_MemberRepInfo.m_bIsSecondaryGadgetEmpty;
	}
	iLifeU=Min(m_eHealth,2);
//	C.Style=5;
	LineColor=m_NormalColor;
	if ( m_bIsDead == True )
	{
		NameColor=m_NormalColor;
		NameAlpha=128;
		NameBackgroundColor=m_DarkColor;
		NameBackgroundAlpha=255;
		SpecColor=m_NormalColor;
		SpecAlpha=128;
		WeaponColor=m_NormalColor;
		WeaponAlpha=128;
		SpecAndWeaponBackgroundColor=m_DarkColor;
		SpecAndWeaponBackgroundAlpha=128;
		FaceAlpha=128;
		LineAlpha=128;
	}
	else
	{
		if ( m_bMouseOver )
		{
			NameColor=m_DarkColor;
			NameAlpha=255;
			NameBackgroundColor=m_NormalColor;
			NameBackgroundAlpha=255;
			SpecColor=Root.Colors.White;
			SpecAlpha=255;
			WeaponColor=Root.Colors.White;
			WeaponAlpha=255;
			SpecAndWeaponBackgroundColor=m_DarkColor;
			SpecAndWeaponBackgroundAlpha=255;
			FaceAlpha=255;
			LineAlpha=255;
		}
		else
		{
			if ( bCurrentSelection )
			{
				NameColor=Root.Colors.White;
				NameAlpha=255;
				NameBackgroundColor=m_NormalColor;
				NameBackgroundAlpha=128;
				SpecColor=Root.Colors.White;
				SpecAlpha=255;
				WeaponColor=Root.Colors.White;
				WeaponAlpha=255;
				SpecAndWeaponBackgroundColor=m_NormalColor;
				SpecAndWeaponBackgroundAlpha=128;
				FaceAlpha=255;
				LineAlpha=255;
			}
			else
			{
				NameColor=m_NormalColor;
				NameAlpha=255;
				NameBackgroundColor=m_DarkColor;
				NameBackgroundAlpha=255;
				SpecColor=m_NormalColor;
				SpecAlpha=255;
				WeaponColor=m_NormalColor;
				WeaponAlpha=255;
				SpecAndWeaponBackgroundColor=m_DarkColor;
				SpecAndWeaponBackgroundAlpha=128;
				FaceAlpha=255;
				LineAlpha=255;
			}
		}
	}
	C.DrawColor=NameBackgroundColor;
	C.DrawColor.A=NameBackgroundAlpha;
//	DrawStretchedTextureSegment(C,40.00,1.00,WinWidth - 41,21.00,0.00,0.00,1.00,1.00,Texture'White');
	Name=GetCharacterName();
	C.TextSize(Name,fPosX,fPosY);
	C.SetPos(NameX - fPosX / 2.00,NameY);
	C.Font=Root.Fonts[8];
	C.DrawColor=NameColor;
	C.DrawColor.A=NameAlpha;
	C.DrawText(Name);
	C.SetPos(LifeX,LifeY);
	C.DrawTile(HealthIconTexture,10.00,10.00,31.00 + 11 * iLifeU,29.00,10.00,10.00);
	C.DrawColor=SpecAndWeaponBackgroundColor;
	C.DrawColor.A=SpecAndWeaponBackgroundAlpha;
//	DrawStretchedTextureSegment(C,40.00,23.00,WinWidth - 40,20.00,0.00,0.00,1.00,1.00,Texture'White');
//	DrawStretchedTextureSegment(C,1.00,44.00,WinWidth - 2,44.00,0.00,0.00,1.00,1.00,Texture'White');
	C.DrawColor=LineColor;
	C.DrawColor.A=LineAlpha;
/*	DrawStretchedTextureSegment(C,1.00,0.00,WinWidth - 2,1.00,0.00,0.00,1.00,1.00,Texture'White');
	DrawStretchedTextureSegment(C,1.00,43.00,WinWidth - 2,1.00,0.00,0.00,1.00,1.00,Texture'White');
	DrawStretchedTextureSegment(C,1.00,WinHeight - 1,WinWidth - 2,1.00,0.00,0.00,1.00,1.00,Texture'White');
	DrawStretchedTextureSegment(C,40.00,22.00,WinWidth - 38,1.00,0.00,0.00,1.00,1.00,Texture'White');
	DrawStretchedTextureSegment(C,0.00,0.00,1.00,WinHeight,0.00,0.00,1.00,1.00,Texture'White');
	DrawStretchedTextureSegment(C,WinWidth - 1,0.00,1.00,WinHeight,0.00,0.00,1.00,1.00,Texture'White');
	DrawStretchedTextureSegment(C,39.00,0.00,1.00,43.00,0.00,0.00,1.00,1.00,Texture'White');*/
	C.SetPos(1.00,1.00);
	C.DrawColor=Root.Colors.White;
	C.DrawColor.A=FaceAlpha;
	if ( m_bIsSinglePlayer )
	{
		C.DrawTile(m_Operative.m_FaceTexture,38.00,42.00,m_Operative.m_FaceCoords.X,m_Operative.m_FaceCoords.Y,m_Operative.m_FaceCoords.Z,m_Operative.m_FaceCoords.W);
		C.DrawColor=SpecColor;
		C.DrawColor.A=SpecAlpha;
		C.TextSize(m_szSpeciality,fPosX,fPosY);
		C.SetPos(SpecX - fPosX / 2.00,SpecY);
		C.DrawText(m_szSpeciality);
	}
	else
	{
		C.DrawTile(DefaultFaceTexture,38.00,42.00,DefaultFaceCoords.X,DefaultFaceCoords.Y,DefaultFaceCoords.Z,DefaultFaceCoords.W);
	}
	C.DrawColor=WeaponColor;
	C.DrawColor.A=WeaponAlpha;
	C.Font=Root.Fonts[6];
	iWeapon=0;
JL0992:
	if ( iWeapon < 2 )
	{
		C.SetPos(WeaponX,WeaponY + WeaponHeight * iWeapon);
		C.DrawText(m_WeaponsName[iWeapon]);
		iWeapon++;
		goto JL0992;
	}
	C.SetPos(WeaponX,WeaponY + WeaponHeight * 2);
	if ( bIsPrimaryGadgetEmpty )
	{
		C.DrawText(Localize("MISC","ID_EMPTY","R6Common"));
	}
	else
	{
		C.DrawText(m_WeaponsName[iWeapon]);
	}
	C.SetPos(WeaponX,WeaponY + WeaponHeight * 3);
	if ( bIsSecondaryGadgetEmpty )
	{
		C.DrawText(Localize("MISC","ID_EMPTY","R6Common"));
	}
	else
	{
		C.DrawText(m_WeaponsName[3]);
	}
}

function string GetCharacterName ()
{
	if ( m_bIsSinglePlayer )
	{
		if ( m_Operative != None )
		{
			return m_Operative.m_CharacterName;
		}
	}
	else
	{
		return m_MemberRepInfo.m_CharacterName;
	}
}

defaultproperties
{
    NameX=119
    NameY=6
    SpecX=119
    SpecY=26
    WeaponX=5
    WeaponY=44
    WeaponHeight=10
    LifeX=44
    LifeY=6
    DefaultFaceCoords=(X=0.00,Y=0.00,Z=472.00,W=0.00)
}
/*
    m_OperativeSelectSnd=Sound'SFX_Menus.Play_Rose_Select'
    HealthIconTexture=Texture'R6MenuTextures.TeamBarIcon'
    DefaultFaceTexture=Texture'R6MenuOperative.RS6_Memeber_01'
*/

