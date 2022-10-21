//================================================================================
// R6FileManagerPlanning.
//================================================================================
class R6FileManagerPlanning extends R6FileManager
	Native;

var int m_iCurrentTeam;

native(1416) final function bool LoadPlanning (string szMapName, string szLocalizedMapName, string szEnglishGT, string szGameType, string szFileName, R6StartGameInfo sgi, optional out string LoadErrorMsgMapName, optional out string LoadErrorMsgGameType);

native(1417) final function bool SavePlanning (string szMapName, string szLocalizedMapName, string szEnglishGT, string szGameType, string szFileName, R6StartGameInfo sgi);

native(1418) final function int GetNumberOfFiles (string MapName, string szGameType);