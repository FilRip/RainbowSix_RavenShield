//================================================================================
// R6UPackageMgr.
//================================================================================
class R6UPackageMgr extends Object;
//	Export;

var bool bShowLog;
var array<string> m_aPackageList;

function InitOperativeClassesMgr ()
{
	local R6FileManager pFileManager;
	local int iFiles;
	local int i;
	local string szPackageFilename;

	pFileManager=new Class'R6FileManager';
	iFiles=pFileManager.GetNbFile("..\\Mods\\NewOperative\\","u");
	for (i=0;i < iFiles;i++)
	{
		pFileManager.GetFileName(i,szPackageFilename);
		if ( bShowLog )
		{
			Log("Found Operative package : " $ szPackageFilename);
		}
		m_aPackageList[i]=Left(szPackageFilename,Len(szPackageFilename) - 2);
	}
}

function Class GetFirstClassFromPackage (int iPackageIndex, Class ClassType)
{
	return GetFirstPackageClass(m_aPackageList[iPackageIndex] $ ".u",ClassType);
}

function Class GetNextClassFromPackage ()
{
	return GetNextClass();
}

function int GetNbPackage ()
{
	return m_aPackageList.Length;
}

function string GetPackageName (int iPackageIndex)
{
	return m_aPackageList[iPackageIndex];
}

function string GetLocalizedString (int iPackageIndex, string SectionName, string KeyName, bool bMultipleToken)
{
	local string szLocalizedString;

	szLocalizedString=Localize(SectionName,KeyName,"..\\Mods\\NewOperative\\" $ m_aPackageList[iPackageIndex],bMultipleToken);
	if ( szLocalizedString == "" )
	{
		szLocalizedString=SectionName $ " " $ Right(SectionName,Len(SectionName) - 3);
	}
	return szLocalizedString;
}
