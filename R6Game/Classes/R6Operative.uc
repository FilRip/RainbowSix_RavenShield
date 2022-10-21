//================================================================================
// R6Operative.
//================================================================================
class R6Operative extends Object
	Native;
//	Export;

var int m_iUniqueID;
var int m_iRookieID;
var int m_RMenuFaceX;
var int m_RMenuFaceY;
var int m_RMenuFaceW;
var int m_RMenuFaceH;
var int m_RMenuFaceSmallX;
var int m_RMenuFaceSmallY;
var int m_RMenuFaceSmallW;
var int m_RMenuFaceSmallH;
var int m_iHealth;
var int m_iNbMissionPlayed;
var int m_iTerrokilled;
var int m_iRoundsfired;
var int m_iRoundsOntarget;
var float m_fAssault;
var float m_fDemolitions;
var float m_fElectronics;
var float m_fSniper;
var float m_fStealth;
var float m_fSelfControl;
var float m_fLeadership;
var float m_fObservation;
var Texture m_TMenuFace;
var Texture m_TMenuFaceSmall;
var name m_CanUseArmorType;
var array<Texture> m_OperativeFaces;
var string m_szOperativeClass;
var string m_szCountryID;
var string m_szCityID;
var string m_szStateID;
var string m_szSpecialityID;
var string m_szHairColorID;
var string m_szEyesColorID;
var string m_szGenderID;
var string m_szGender;
var string m_szPrimaryWeapon;
var string m_szPrimaryWeaponGadget;
var string m_szPrimaryWeaponBullet;
var string m_szPrimaryGadget;
var string m_szSecondaryWeapon;
var string m_szSecondaryWeaponGadget;
var string m_szSecondaryWeaponBullet;
var string m_szSecondaryGadget;
var string m_szArmor;

function string GetName ()
{
	if ( m_iRookieID != -1 )
	{
		return Localize(m_szOperativeClass,"ID_NAME","R6Operatives",True,True) $ string(m_iRookieID);
	}
	else
	{
		return Localize(m_szOperativeClass,"ID_NAME","R6Operatives",True,True);
	}
}

function string GetShortName ()
{
	if ( m_iRookieID != -1 )
	{
		return Localize(m_szOperativeClass,"ID_SHORTNAME","R6Operatives",True,True) $ string(m_iRookieID);
	}
	else
	{
		return Localize(m_szOperativeClass,"ID_SHORTNAME","R6Operatives",True,True);
	}
}

function string GetSpeciality ()
{
	return Localize("Speciality",m_szSpecialityID,"R6Operatives");
}

function string GetHistory ()
{
	return Localize(m_szOperativeClass,"ID_HISTORY","R6Operatives",False,True);
}

function string GetGender ()
{
	return Localize("Gender",m_szGenderID,"R6Common");
}

function string GetCountry ()
{
	return Localize("Country",m_szCountryID,"R6Common");
}

function string GetCity ()
{
	return Localize("City",m_szCityID,"R6Common");
}

function string GetState ()
{
	return Localize("State",m_szStateID,"R6Common");
}

function string GetHairColor ()
{
	return Localize("Color",m_szHairColorID,"R6Common");
}

function string GetEyesColor ()
{
	return Localize("Color",m_szEyesColorID,"R6Common");
}

function string GetIDNumber ()
{
	return Localize(m_szOperativeClass,"ID_IDNUMBER","R6Operatives");
}

function string GetBirthDate ()
{
	return Localize(GetRealOperativeClass(),"ID_BIRTHDATE","R6Operatives");
}

function string GetHeight ()
{
	return Localize(GetRealOperativeClass(),"ID_HEIGHT","R6Operatives");
}

function string GetWeight ()
{
	return Localize(GetRealOperativeClass(),"ID_WEIGHT","R6Operatives");
}

function string GetNbMissionPlayed ()
{
	return string(m_iNbMissionPlayed);
}

function string GetNbTerrokilled ()
{
	return string(m_iTerrokilled);
}

function string GetNbRoundsfired ()
{
	return string(m_iRoundsfired);
}

function string GetNbRoundsOnTarget ()
{
	return string(m_iRoundsOntarget);
}

function string GetShootPercent ()
{
	if ( m_iRoundsfired > 0 )
	{
		return string(m_iRoundsOntarget / m_iRoundsfired * 100);
	}
	else
	{
		return "0";
	}
}

function string GetTextDescription ()
{
	local string szDescription;
	local string szTemp;

	szDescription=Localize("IdentificationField","ID_IDNUMBER","R6Operatives") $ " " $ GetIDNumber() $ Chr(13);
	szDescription=szDescription $ Localize("IdentificationField","ID_BIRTHPLACE","R6Operatives") $ " " $ GetCountry();
	szTemp=GetCountry();
	if ( szTemp != "" )
	{
		szDescription=szDescription $ szTemp;
	}
	szTemp=GetCity();
	if ( szTemp != "" )
	{
		szDescription=szDescription $ ", " $ szTemp;
	}
	szTemp=GetState();
	if ( szTemp != "" )
	{
		szDescription=szDescription $ ", " $ szTemp;
	}
	szDescription=szDescription $ Chr(13);
	szDescription=szDescription $ Localize("IdentificationField","ID_SPECIALITY","R6Operatives") $ " " $ GetSpeciality() $ Chr(13);
	szDescription=szDescription $ Localize("IdentificationField","ID_BIRTHDATE","R6Operatives") $ " " $ GetBirthDate() $ Chr(13);
	szDescription=szDescription $ Localize("IdentificationField","ID_HEIGHT","R6Operatives") $ " " $ GetHeight() $ Chr(13);
	szDescription=szDescription $ Localize("IdentificationField","ID_WEIGHT","R6Operatives") $ " " $ GetWeight() $ Chr(13);
	szDescription=szDescription $ Localize("IdentificationField","ID_HAIR","R6Operatives") $ " " $ GetHairColor() $ Chr(13);
	szDescription=szDescription $ Localize("IdentificationField","ID_EYES","R6Operatives") $ " " $ GetEyesColor() $ Chr(13);
	szDescription=szDescription $ Localize("IdentificationField","ID_GENDER","R6Operatives") $ " " $ GetGender();
	return szDescription;
}

function string GetHealthStatus ()
{
	local string Result;

	switch (m_iHealth)
	{
		case 0:
		Result=Localize("Health","ID_READY","R6Common");
		break;
		case 1:
		Result=Localize("Health","ID_WOUNDED","R6Common");
		break;
		case 2:
		Result=Localize("Health","ID_INCAPACITATED","R6Common");
		break;
		case 3:
		Result=Localize("Health","ID_DEAD","R6Common");
		break;
		default:
		Result="UNKNOWN";
		break;
	}
	return Result;
}

function bool IsOperativeReady ()
{
	return m_iHealth == 0;
}

function string GetRealOperativeClass ()
{
	local int ITemp;

	if ( m_iRookieID == -1 )
	{
		return m_szOperativeClass;
	}
	if ( m_iRookieID < 30 )
	{
		ITemp=29 - m_iRookieID;
	}
	else
	{
		ITemp=m_iRookieID / 30 - 1;
		ITemp=m_iRookieID - 29 + ITemp * 30;
	}
	return "R6Operative" $ string(ITemp);
}

function UpdateSkills ()
{
	local int iD5;
	local int iD2;
	local float fDecision;
	local float fIncreaseSkill;

	fIncreaseSkill=0.50;
	iD5=Rand(5) + 1;
	iD2=Rand(2) + 1;
	fDecision=FRand();
	if ( m_iHealth == 1 )
	{
		m_iHealth=0;
	}
	else
	{
		if ( m_iHealth > 1 )
		{
			return;
		}
	}
	if ( m_szSpecialityID == "ID_ASSAULT" )
	{
		m_fAssault += fIncreaseSkill * (iD5 + 5) / 100.00 * (100 - m_fAssault);
	}
	else
	{
		m_fAssault += fIncreaseSkill * (iD2 + 2) / 100.00 * (100 - m_fAssault);
	}
	if ( m_szSpecialityID == "ID_DEMOLITIONS" )
	{
		m_fDemolitions += fIncreaseSkill * (iD5 + 5) / 100.00 * (100 - m_fDemolitions);
	}
	else
	{
		if ( fDecision <= 0.20 )
		{
			m_fDemolitions += fIncreaseSkill * 0.02 * (100 - m_fDemolitions);
		}
		fDecision=FRand();
	}
	if ( m_szSpecialityID == "ID_ELECTRONICS" )
	{
		m_fElectronics += fIncreaseSkill * (iD5 + 5) / 100.00 * (100 - m_fElectronics);
	}
	else
	{
		if ( fDecision <= 0.20 )
		{
			m_fElectronics += fIncreaseSkill * 0.02 * (100 - m_fElectronics);
		}
		fDecision=FRand();
	}
	if ( m_szSpecialityID == "ID_STEALTH" )
	{
		m_fStealth += fIncreaseSkill * (iD5 + 5) / 100.00 * (100 - m_fStealth);
	}
	else
	{
		if ( fDecision <= 0.20 )
		{
			m_fStealth += fIncreaseSkill * 0.02 * (100 - m_fStealth);
		}
		fDecision=FRand();
	}
	if ( m_szSpecialityID == "ID_SNIPER" )
	{
		m_fSniper += fIncreaseSkill * (iD5 + 5) / 100.00 * (100 - m_fSniper);
	}
	else
	{
		if ( fDecision <= 0.20 )
		{
			m_fSniper += fIncreaseSkill * 0.02 * (100 - m_fSniper);
		}
		fDecision=FRand();
	}
	if ( fDecision <= 0.20 )
	{
		m_fSelfControl += fIncreaseSkill * 0.02 * (100 - m_fSelfControl);
	}
	fDecision=FRand();
	if ( fDecision <= 0.20 )
	{
		m_fLeadership += fIncreaseSkill * 0.02 * (100 - m_fLeadership);
	}
	fDecision=FRand();
	if ( fDecision <= 0.20 )
	{
		m_fObservation += fIncreaseSkill * 0.02 * (100 - m_fObservation);
	}
	fDecision=FRand();
}

function DisplayStats ()
{
	Log("------------------------");
	Log(GetName());
	Log("m_fAssault     =" @ string(m_fAssault));
	Log("m_fElectronics =" @ string(m_fElectronics));
	Log("m_fSniper      =" @ string(m_fSniper));
	Log("m_fStealth     =" @ string(m_fStealth));
	Log("m_fSelfControl =" @ string(m_fSelfControl));
	Log("m_fLeadership  =" @ string(m_fLeadership));
	Log("m_fObservation =" @ string(m_fObservation));
	Log("========================");
}

function CopyOperative (R6Operative aOperative)
{
	local int i;

	aOperative.m_szOperativeClass=m_szOperativeClass;
	aOperative.m_szCountryID=m_szCountryID;
	aOperative.m_szCityID=m_szCityID;
	aOperative.m_szStateID=m_szStateID;
	aOperative.m_szSpecialityID=m_szSpecialityID;
	aOperative.m_szHairColorID=m_szHairColorID;
	aOperative.m_szEyesColorID=m_szEyesColorID;
	aOperative.m_szGenderID=m_szGenderID;
	aOperative.m_TMenuFace=m_TMenuFace;
	for (i=0;i < m_OperativeFaces.Length;i++)
	{
		aOperative.m_OperativeFaces[aOperative.m_OperativeFaces.Length]=m_OperativeFaces[i];
	}
	aOperative.m_szGender=m_szGender;
	aOperative.m_fAssault=m_fAssault;
	aOperative.m_fDemolitions=m_fDemolitions;
	aOperative.m_fElectronics=m_fElectronics;
	aOperative.m_fSniper=m_fSniper;
	aOperative.m_fStealth=m_fStealth;
	aOperative.m_fSelfControl=m_fSelfControl;
	aOperative.m_fLeadership=m_fLeadership;
	aOperative.m_fObservation=m_fObservation;
	aOperative.m_iHealth=m_iHealth;
	aOperative.m_iNbMissionPlayed=m_iNbMissionPlayed;
	aOperative.m_iTerrokilled=m_iTerrokilled;
	aOperative.m_iRoundsfired=m_iRoundsfired;
	aOperative.m_iRoundsOntarget=m_iRoundsOntarget;
}

defaultproperties
{
    m_iUniqueID=-1
    m_iRookieID=-1
    m_RMenuFaceY=420
    m_RMenuFaceW=175
    m_RMenuFaceH=81
    m_RMenuFaceSmallX=456
    m_RMenuFaceSmallY=132
    m_RMenuFaceSmallW=38
    m_RMenuFaceSmallH=42
    m_CanUseArmorType=R6ArmorDescription
    m_szOperativeClass="R6Operative"
    m_szCountryID="ID_SPAIN"
    m_szCityID="ID_MALAGA"
    m_szSpecialityID="ID_ASSAULT"
    m_szHairColorID="ID_BROWN"
    m_szEyesColorID="ID_BLUE"
    m_szGenderID="ID_MALE"
    m_szGender="M"
}
/*
    m_TMenuFace=Texture'R6MenuOperative.RS6_Memeber_03'
    m_TMenuFaceSmall=Texture'R6MenuOperative.RS6_Memeber_01'
*/

