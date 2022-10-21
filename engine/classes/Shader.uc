//================================================================================
// Shader.
//================================================================================
class Shader extends RenderedMaterial
	Native
//	Export
	EditInLineNew;

enum EOutputBlending {
	OB_Normal,
	OB_Masked,
	OB_Modulate,
	OB_Translucent,
	OB_Invisible,
	OB_Brighten,
	OB_Darken
};

var() EOutputBlending OutputBlending;
var() bool TwoSided;
var() bool Wireframe;
var bool ModulateStaticLighting2X;
var() bool PerformLightingOnSpecularPass;
var() editinlineuse Material Diffuse;
var() editinlineuse Material Opacity;
var() editinlineuse Material Specular;
var() editinlineuse Material SpecularityMask;
var() editinlineuse Material SelfIllumination;
var() editinlineuse Material SelfIlluminationMask;
var() editinlineuse Material Detail;

function Trigger (Actor Other, Actor EventInstigator)
{
	if ( Diffuse != None )
	{
		Diffuse.Trigger(Other,EventInstigator);
	}
	if ( Opacity != None )
	{
		Opacity.Trigger(Other,EventInstigator);
	}
	if ( Specular != None )
	{
		Specular.Trigger(Other,EventInstigator);
	}
	if ( SpecularityMask != None )
	{
		SpecularityMask.Trigger(Other,EventInstigator);
	}
	if ( SelfIllumination != None )
	{
		SelfIllumination.Trigger(Other,EventInstigator);
	}
	if ( SelfIlluminationMask != None )
	{
		SelfIlluminationMask.Trigger(Other,EventInstigator);
	}
	if ( FallbackMaterial != None )
	{
		FallbackMaterial.Trigger(Other,EventInstigator);
	}
}
