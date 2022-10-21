//================================================================================
// R6FileManager.
//================================================================================
class R6FileManager extends Object
	Native;
//	Export;

var array<string> m_pFileList;

native(1525) final function int GetNbFile (string szPath, string szExt);

native(1526) final function GetFileName (int iFileID, out string szFileName);

native(1527) final function bool DeleteFile (string szPathFile);

native(1528) final function bool FindFile (string szPathAndFilename);
