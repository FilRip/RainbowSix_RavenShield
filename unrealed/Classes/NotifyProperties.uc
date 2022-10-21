//================================================================================
// NotifyProperties.
//================================================================================
class NotifyProperties extends Object
	Native
//	Export
	CollapseCategories
	HideCategories(Object);

struct NotifyInfo
{
	var() float NotifyFrame;
	var() editinlineuse AnimNotify Notify;
	var int OldRevisionNum;
};

var int OldArrayCount;
var const int WBrowserAnimationPtr;
var() array<NotifyInfo> Notifys;