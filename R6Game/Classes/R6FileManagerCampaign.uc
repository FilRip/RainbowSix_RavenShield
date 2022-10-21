//================================================================================
// R6FileManagerCampaign.
//================================================================================
class R6FileManagerCampaign extends R6FileManager
	Native;

native(1003) final function bool LoadCampaign (R6PlayerCampaign MyCampaign);

native(1004) final function bool SaveCampaign (R6PlayerCampaign MyCampaign);

native(2701) final function bool LoadCustomMissionAvailable (R6PlayerCustomMission myCustomMission);

native(2702) final function bool SaveCustomMissionAvailable (R6PlayerCustomMission myCustomMission);