//================================================================================
// R6MatineeAttach.
//================================================================================
class R6MatineeAttach extends Object
	Native;
//	Export;

var bool m_bInitialized;
var Actor m_AttachActor;
var R6Pawn m_AttachPawn;
var name m_PawnTag;
var name m_BoneName;
var Vector m_InteractionPos;
var Rotator m_InteractionRot;
var Vector m_OffsetPos;
var Rotator m_OffsetRot;
var string m_StaticMeshTag;

native(2907) final function GetBoneInformation ();

native(2908) final function TestLocation ();

function InitAttach ()
{
	local Vector MeshPos;
	local Rotator MeshRot;

	if ( (m_PawnTag != 'None') && (m_AttachActor != None) )
	{
		GetBoneInformation();
		m_AttachActor.GetTagInformations(m_StaticMeshTag,MeshPos,MeshRot);
		m_InteractionPos=m_AttachActor.Location + MeshPos;
		m_InteractionRot=m_AttachActor.Rotation + MeshRot;
		m_bInitialized=True;
	}
	else
	{
		m_bInitialized=False;
	}
}

function MatineeAttach ()
{
	if ( m_bInitialized == True )
	{
		m_AttachPawn.AttachToBone(m_AttachActor,m_BoneName);
		m_AttachActor.SetRelativeLocation(m_OffsetPos);
		m_AttachActor.SetRelativeRotation(m_OffsetRot);
	}
}

function MatineeDetach ()
{
	local Vector Location;
	local Rotator Rotation;

	if ( m_bInitialized == True )
	{
		m_AttachPawn.DetachFromBone(m_AttachActor);
	}
}
