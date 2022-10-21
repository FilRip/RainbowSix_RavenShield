//================================================================================
// R6DescriptionManager.
//================================================================================
class R6DescriptionManager extends Object;
//	Export;

static final function Class<R6Description> findPrimaryDefaultAmmo (Class<R6PrimaryWeaponDescription> WeaponDescriptionClass)
{
	local int i;
	local bool Found;

	Found=False;
	i=0;
JL000F:
	if ( (i < WeaponDescriptionClass.Default.m_Bullets.Length) && (Found == False) )
	{
		if ( Class<R6BulletDescription>(WeaponDescriptionClass.Default.m_Bullets[i]).Default.m_NameTag == "FMJ" )
		{
			Found=True;
		}
		else
		{
			i++;
		}
		goto JL000F;
	}
	if ( Found )
	{
		return Class<R6Description>(WeaponDescriptionClass.Default.m_Bullets[i]);
	}
	i=0;
JL00A1:
	if ( (i < WeaponDescriptionClass.Default.m_Bullets.Length) && (Found == False) )
	{
		if ( Class<R6BulletDescription>(WeaponDescriptionClass.Default.m_Bullets[i]).Default.m_NameTag == "BUCK" )
		{
			Found=True;
		}
		else
		{
			i++;
		}
		goto JL00A1;
	}
	if ( Found )
	{
		return Class<R6Description>(WeaponDescriptionClass.Default.m_Bullets[i]);
	}
	return Class<R6Description>(WeaponDescriptionClass.Default.m_Bullets[0]);
}

static final function Class<R6Description> findSecondaryDefaultAmmo (Class<R6SecondaryWeaponDescription> WeaponDescriptionClass)
{
	local int i;
	local bool Found;

	Found=False;
	i=0;
JL000F:
	if ( (i < WeaponDescriptionClass.Default.m_Bullets.Length) && (Found == False) )
	{
		if ( Class<R6BulletDescription>(WeaponDescriptionClass.Default.m_Bullets[i]).Default.m_NameTag == "FMJ" )
		{
			Found=True;
		}
		else
		{
			i++;
		}
		goto JL000F;
	}
	if ( Found )
	{
		return Class<R6Description>(WeaponDescriptionClass.Default.m_Bullets[i]);
	}
	return Class<R6Description>(WeaponDescriptionClass.Default.m_Bullets[0]);
}

static final function Class<R6BulletDescription> GetPrimaryBulletDesc (Class<R6PrimaryWeaponDescription> WeaponDescription, string token)
{
	local int i;
	local bool Found;
	local string caps_Token;

	caps_Token=Caps(token);
JL000D:
	if ( (i < WeaponDescription.Default.m_Bullets.Length) && (Found == False) )
	{
		if ( Class<R6BulletDescription>(WeaponDescription.Default.m_Bullets[i]).Default.m_NameTag == caps_Token )
		{
			Found=True;
		}
		else
		{
			i++;
		}
		goto JL000D;
	}
	if ( Found )
	{
		return Class<R6BulletDescription>(WeaponDescription.Default.m_Bullets[i]);
	}
	else
	{
		return Class'R6DescBulletNone';
	}
}

static final function Class<R6WeaponGadgetDescription> GetPrimaryWeaponGadgetDesc (Class<R6PrimaryWeaponDescription> WeaponDescription, string token)
{
	local int i;
	local bool Found;
	local string caps_Token;

	caps_Token=Caps(token);
	if ( caps_Token == "NONE" )
	{
		return Class'R6DescWeaponGadgetNone';
	}
JL0023:
	if ( (i < WeaponDescription.Default.m_MyGadgets.Length) && (Found == False) )
	{
		if ( (WeaponDescription.Default.m_MyGadgets[i] != None) && (Class<R6WeaponGadgetDescription>(WeaponDescription.Default.m_MyGadgets[i]).Default.m_NameID == caps_Token) )
		{
			Found=True;
		}
		else
		{
			i++;
		}
		goto JL0023;
	}
	if ( Found )
	{
		return Class<R6WeaponGadgetDescription>(WeaponDescription.Default.m_MyGadgets[i]);
	}
	else
	{
		return Class'R6DescWeaponGadgetNone';
	}
}

static final function Class<R6BulletDescription> GetSecondaryBulletDesc (Class<R6SecondaryWeaponDescription> WeaponDescription, string token)
{
	local int i;
	local bool Found;
	local string caps_Token;

	caps_Token=Caps(token);
JL000D:
	if ( (i < WeaponDescription.Default.m_Bullets.Length) && (Found == False) )
	{
		if ( Class<R6BulletDescription>(WeaponDescription.Default.m_Bullets[i]).Default.m_NameTag == caps_Token )
		{
			Found=True;
		}
		else
		{
			i++;
		}
		goto JL000D;
	}
	if ( Found )
	{
		return Class<R6BulletDescription>(WeaponDescription.Default.m_Bullets[i]);
	}
	else
	{
		return Class'R6DescBulletNone';
	}
}

static final function Class<R6WeaponGadgetDescription> GetSecondaryWeaponGadgetDesc (Class<R6SecondaryWeaponDescription> WeaponDescription, string token)
{
	local int i;
	local bool Found;
	local string caps_Token;

	caps_Token=Caps(token);
	if ( caps_Token == "NONE" )
	{
		return Class'R6DescWeaponGadgetNone';
	}
JL0023:
	if ( (i < WeaponDescription.Default.m_MyGadgets.Length) && (Found == False) )
	{
		if ( Class<R6WeaponGadgetDescription>(WeaponDescription.Default.m_MyGadgets[i]).Default.m_NameID == caps_Token )
		{
			Found=True;
		}
		else
		{
			i++;
		}
		goto JL0023;
	}
	if ( Found )
	{
		return Class<R6WeaponGadgetDescription>(WeaponDescription.Default.m_MyGadgets[i]);
	}
	else
	{
		return Class'R6DescWeaponGadgetNone';
	}
}