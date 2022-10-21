//================================================================================
// R6FootStep.
//================================================================================
class R6FootStep extends Actor
	Native
	Abstract;
//	NoNativeReplication;

var(Rainbow) float m_fDuration;
var(Rainbow) float m_fDurationDirty;
var(Rainbow) float m_fDirtyTime;
var float m_fFootStepDuration;
var float m_fFootStepCurrentTime;
var(Rainbow) Texture m_DecalLeftFootTexture;
var(Rainbow) Texture m_DecalRightFootTexture;
var(Rainbow) Texture m_DecalLeftFootTextureDirty;
var(Rainbow) Texture m_DecalRightFootTextureDirty;
var Texture m_DecalFootTexture;

defaultproperties
{
    m_fDurationDirty=10.00
    RemoteRole=ROLE_None
    DrawType=0
    bHidden=True
    m_fSoundRadiusSaturation=150.00
    Texture=None
}