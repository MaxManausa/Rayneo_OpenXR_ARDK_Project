// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE_Stencil_FakeLight"
{
	Properties
	{
		_Albedo("Albedo", 2D) = "white" {}
		_Stencil("Stencil", Range( 0 , 255)) = 0
		_ScaleTiling_U("ScaleTiling_U", Float) = 1
		[HDR]_Color("Color", Color) = (0,0.9388051,1,0)
		_ScaleTiling_V("ScaleTiling_V", Float) = 1
		_ScaleOffset("ScaleOffset", Float) = 1
		_Opacity("Opacity", Range( 0 , 1)) = 0
		_FallOff("FallOff", Float) = 0.5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+1" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Stencil
		{
			Ref [_Stencil]
			Comp Equal
			Pass Keep
			Fail Keep
		}
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma exclude_renderers xboxseries playstation 
		#pragma surface surf Unlit alpha:fade keepalpha noshadow 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _Stencil;
		uniform float4 _Color;
		uniform sampler2D _Albedo;
		uniform float _ScaleTiling_U;
		uniform float _ScaleTiling_V;
		uniform float _ScaleOffset;
		uniform float _Opacity;
		uniform float _FallOff;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 appendResult39 = (float2(_ScaleTiling_U , _ScaleTiling_V));
			float2 appendResult31 = (float2(( _ScaleOffset * _Time.y ) , 0.0));
			float2 uv_TexCoord32 = i.uv_texcoord * appendResult39 + appendResult31;
			float4 tex2DNode33 = tex2D( _Albedo, uv_TexCoord32 );
			o.Emission = ( _Color * tex2DNode33 ).rgb;
			o.Alpha = ( ( tex2DNode33 * _Opacity ) * ( i.uv_texcoord.y - _FallOff ) ).r;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18910
2798;443;1396;859;1205.404;640.371;1.384053;True;True
Node;AmplifyShaderEditor.RangedFloatNode;29;-1661.184,-103.2523;Inherit;False;Property;_ScaleOffset;ScaleOffset;6;0;Create;True;0;0;0;False;0;False;1;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;36;-1664.673,23.31853;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-1534.904,-299.8879;Inherit;False;Property;_ScaleTiling_U;ScaleTiling_U;3;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-1533.762,-206.4774;Inherit;False;Property;_ScaleTiling_V;ScaleTiling_V;5;0;Create;True;0;0;0;False;0;False;1;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-1462.725,-46.15835;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;39;-1324.762,-272.4774;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;31;-1272.193,-103.8523;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;32;-1115.737,-202.2953;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;44;-781.7949,61.45776;Inherit;False;Property;_FallOff;FallOff;9;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;33;-782.2207,-278.1069;Inherit;True;Property;_Albedo;Albedo;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;42;-833.7949,148.4578;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;10;-546.1269,-60.04022;Inherit;False;Property;_Opacity;Opacity;7;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;43;-581.7949,73.45776;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;34;-685.2055,-458.4098;Inherit;False;Property;_Color;Color;4;1;[HDR];Create;True;0;0;0;False;0;False;0,0.9388051,1,0;0,1.254902,5.992157,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-224.7622,-139.4774;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-41.01853,192.6338;Inherit;False;Property;_Specular;Specular;2;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;181.4669,530.4579;Inherit;False;Property;_Stencil;Stencil;1;0;Create;True;0;0;0;True;0;False;0;3;0;255;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;28;238.3805,288.2465;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-347.3364,-345.5742;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-51.59485,-56.54224;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-59.69774,288.8154;Inherit;False;Property;_Roughness;Roughness;8;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;527.8942,-378.7819;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;ASE_Stencil_FakeLight;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;1.2;False;-1;2.1;False;-1;False;0;Transparent;0.5;True;False;1;False;Transparent;;Transparent;All;14;d3d9;d3d11_9x;d3d11;glcore;gles;gles3;metal;vulkan;xbox360;xboxone;ps4;psp2;n3ds;wiiu;True;True;True;True;0;False;-1;True;1;True;5;255;False;-1;255;False;-1;5;False;-1;1;False;-1;1;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;0;4;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;5;False;-1;10;False;-1;0;False;-1;1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;37;0;29;0
WireConnection;37;1;36;0
WireConnection;39;0;30;0
WireConnection;39;1;40;0
WireConnection;31;0;37;0
WireConnection;32;0;39;0
WireConnection;32;1;31;0
WireConnection;33;1;32;0
WireConnection;43;0;42;2
WireConnection;43;1;44;0
WireConnection;38;0;33;0
WireConnection;38;1;10;0
WireConnection;28;0;27;0
WireConnection;35;0;34;0
WireConnection;35;1;33;0
WireConnection;41;0;38;0
WireConnection;41;1;43;0
WireConnection;0;2;35;0
WireConnection;0;9;41;0
ASEEND*/
//CHKSM=E5BF67351FA6A81705E3203704196AEF482AF28E