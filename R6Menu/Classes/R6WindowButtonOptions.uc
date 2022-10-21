//================================================================================
// R6WindowButtonOptions.
//================================================================================
class R6WindowButtonOptions extends R6WindowButton;

enum eButtonActionType {
	Button_Game,
	Button_Sound,
	Button_Graphic,
	Button_Hud,
	Button_Multiplayer,
	Button_Controls,
	Button_MODS,
	Button_Return
};

var eButtonActionType m_eButton_Action;
var Texture m_TOverButton;
var Region m_ROverButtonFade;
var Region m_ROverButton;

simulated function Click (float X, float Y)
{
	local R6MenuRootWindow r6Root;

	if ( bDisabled )
	{
		return;
	}
	Super.Click(X,Y);
	r6Root=R6MenuRootWindow(Root);
	switch (m_eButton_Action)
	{
/*		case 0:
		R6MenuOptionsWidget(OwnerWindow).ManageOptionsSelection(R6MenuOptionsWidget(OwnerWindow).0);
		break;
		case 1:
		R6MenuOptionsWidget(OwnerWindow).ManageOptionsSelection(R6MenuOptionsWidget(OwnerWindow).1);
		break;
		case 2:
		R6MenuOptionsWidget(OwnerWindow).ManageOptionsSelection(R6MenuOptionsWidget(OwnerWindow).2);
		break;
		case 3:
		R6MenuOptionsWidget(OwnerWindow).ManageOptionsSelection(R6MenuOptionsWidget(OwnerWindow).3);
		break;
		case 4:
		R6MenuOptionsWidget(OwnerWindow).ManageOptionsSelection(R6MenuOptionsWidget(OwnerWindow).4);
		break;
		case 5:
		R6MenuOptionsWidget(OwnerWindow).ManageOptionsSelection(R6MenuOptionsWidget(OwnerWindow).5);
		break;
		case 6:
		R6MenuOptionsWidget(OwnerWindow).ManageOptionsSelection(R6MenuOptionsWidget(OwnerWindow).6);
		break;
		case 7:
		R6MenuOptionsWidget(OwnerWindow).UpdateOptions();
//		Root.ChangeCurrentWidget(17);
		break;
		default:
		Log("Button not supported");
		break;*/
	}
}

defaultproperties
{
    m_ROverButtonFade=(X=16261638,Y=570687488,W=6,H=860675)
    m_ROverButton=(X=16589318,Y=570687488,W=2,H=860675)
    m_fFontSpacing=1.00
    bStretched=True
}
/*
    m_TOverButton=Texture'R6MenuTextures.Gui_BoxScroll'
*/

