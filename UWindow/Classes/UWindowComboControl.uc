//================================================================================
// UWindowComboControl.
//================================================================================
class UWindowComboControl extends UWindowDialogControl;

var bool bListVisible;
var bool bCanEdit;
var bool bButtons;
var bool m_bDisabled;
var bool m_bSelectedByUser;
var float EditBoxWidth;
var float EditAreaDrawX;
var float EditAreaDrawY;
var UWindowEditBox EditBox;
var UWindowComboButton Button;
var UWindowComboLeftButton LeftButton;
var UWindowComboRightButton RightButton;
var UWindowComboList List;
var Class<UWindowComboList> ListClass;

function Created ()
{
	Super.Created();
	EditBox=UWindowEditBox(CreateWindow(Class'UWindowEditBox',0.00,0.00,WinWidth,LookAndFeel.Size_ComboHeight));
	EditBox.NotifyOwner=self;
	EditBoxWidth=WinWidth / 2;
	EditBox.bTransient=True;
	Button=UWindowComboButton(CreateWindow(Class'UWindowComboButton',WinWidth - LookAndFeel.Size_ComboButtonWidth,0.00,LookAndFeel.Size_ComboButtonWidth,LookAndFeel.Size_ComboHeight));
	Button.Owner=self;
	List=UWindowComboList(Root.CreateWindow(ListClass,0.00,0.00,100.00,100.00));
	List.LookAndFeel=LookAndFeel;
	List.Owner=self;
	List.Setup();
	List.HideWindow();
	bListVisible=False;
	SetEditTextColor(LookAndFeel.EditBoxTextColor);
}

function SetButtons (bool bInButtons)
{
	bButtons=bInButtons;
	if ( bInButtons )
	{
		LeftButton=UWindowComboLeftButton(CreateWindow(Class'UWindowComboLeftButton',WinWidth - 12,0.00,12.00,LookAndFeel.Size_ComboHeight));
		RightButton=UWindowComboRightButton(CreateWindow(Class'UWindowComboRightButton',WinWidth - 12,0.00,12.00,LookAndFeel.Size_ComboHeight));
	}
	else
	{
		LeftButton=None;
		RightButton=None;
	}
}

function Notify (byte E)
{
	Super.Notify(E);
	if ( E == 10 )
	{
		if (  !bListVisible &&  !m_bDisabled )
		{
			if (  !bCanEdit )
			{
				DropDown();
				Root.CaptureMouse(List);
			}
		}
		else
		{
			CloseUp();
		}
	}
}

function int FindItemIndex (string V, optional bool bIgnoreCase)
{
	return List.FindItemIndex(V,bIgnoreCase);
}

function RemoveItem (int Index)
{
	List.RemoveItem(Index);
}

function int FindItemIndex2 (string v2, optional bool bIgnoreCase)
{
	return List.FindItemIndex2(v2,bIgnoreCase);
}

function Close (optional bool bByParent)
{
	if ( bByParent && bListVisible )
	{
		CloseUp();
	}
	Super.Close(bByParent);
}

function SetNumericOnly (bool bNumericOnly)
{
	EditBox.bNumericOnly=bNumericOnly;
}

function SetNumericFloat (bool bNumericFloat)
{
	EditBox.bNumericFloat=bNumericFloat;
}

function SetFont (int NewFont)
{
	Super.SetFont(NewFont);
	EditBox.SetFont(NewFont);
}

function SetEditTextColor (Color NewColor)
{
	EditBox.SetTextColor(NewColor);
}

function SetEditable (bool bNewCanEdit)
{
	bCanEdit=bNewCanEdit;
	EditBox.SetEditable(bCanEdit);
}

function int GetSelectedIndex ()
{
	return List.FindItemIndex(GetValue());
}

function SetSelectedIndex (int Index)
{
	SetValue(List.GetItemValue(Index),List.GetItemValue2(Index));
}

function string GetValue ()
{
	return EditBox.GetValue();
}

function string GetValue2 ()
{
	return EditBox.GetValue2();
}

function SetValue (string NewValue, optional string NewValue2)
{
	EditBox.SetValue(NewValue,NewValue2);
}

function SetMaxLength (int MaxLength)
{
	EditBox.MaxLength=MaxLength;
}

function Paint (Canvas C, float X, float Y)
{
	LookAndFeel.Combo_Draw(self,C);
}

function AddItem (string S, optional string S2, optional int SortWeight)
{
	List.AddItem(S,S2,SortWeight);
}

function InsertItem (string S, optional string S2, optional int SortWeight)
{
	List.InsertItem(S,S2,SortWeight);
}

function UWindowComboListItem GetItem (string S)
{
	return List.GetItem(S);
}

function DisableAllItems ()
{
	List.DisableAllItems();
}

function BeforePaint (Canvas C, float X, float Y)
{
	Super.BeforePaint(C,X,Y);
	LookAndFeel.Combo_SetupSizes(self,C);
	List.bLeaveOnscreen=bListVisible && bLeaveOnscreen;
}

function CloseUp ()
{
	bListVisible=False;
	EditBox.SetEditable(bCanEdit);
	EditBox.SelectAll();
	List.HideWindow();
	List.CancelAcceptsFocus();
}

function DropDown ()
{
	bListVisible=True;
	EditBox.SetEditable(False);
	if ( List.Selected != None )
	{
		if ( List.Selected.bDisabled )
		{
			List.Selected=None;
		}
	}
	List.ShowWindow();
	List.SetAcceptsFocus();
}

function Sort ()
{
	List.Sort();
}

function ClearValue ()
{
	EditBox.Clear();
}

function Clear ()
{
	List.Clear();
	EditBox.Clear();
}

function FocusOtherWindow (UWindowWindow W)
{
	Super.FocusOtherWindow(W);
	if ( bListVisible && (W.ParentWindow != self) && (W != List) && (W.ParentWindow != List) )
	{
		CloseUp();
	}
}

defaultproperties
{
    ListClass=Class'UWindowComboList'
}