// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "CubeEnv"
{
	Properties
	{
		_Smooth("Smooth", Float) = 0
		_Stencil("Stencil", Range( 0 , 255)) = 0
		_environment("environment", CUBE) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "AlphaTest+20" }
		Cull Front
		Stencil
		{
			Ref [_Stencil]
			Comp Equal
		}
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#pragma target 5.0
		#pragma surface surf Standard keepalpha noshadow exclude_path:deferred 
		struct Input
		{
			float3 viewDir;
		};

		uniform float _Stencil;
		uniform samplerCUBE _environment;
		uniform float _Smooth;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 temp_output_21_0 = ( ( i.viewDir * -1.0 ) * float3(-1,-1,1) );
			float4 texCUBENode17 = texCUBE( _environment, temp_output_21_0 );
			o.Albedo = ( texCUBENode17 * 0.25 ).rgb;
			o.Smoothness = _Smooth;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18910
2659;357;1814;1050;117.5386;748.146;1;True;True
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;8;-306.781,-564.7689;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;20;-118.2916,-450.1515;Inherit;False;Constant;_Float2;Float 2;5;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;60.20846,-553.9514;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;22;50.7442,-434.7761;Inherit;False;Constant;_Vector0;Vector 0;5;0;Create;True;0;0;0;False;0;False;-1,-1,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;248.7085,-472.0518;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;17;460.0499,-616.3372;Inherit;True;Property;_environment;environment;4;0;Create;True;0;0;0;False;0;False;-1;None;135bd5006c02be848af719445c3bf0de;True;0;False;white;Auto;False;Object;-1;Auto;Cube;8;0;SAMPLERCUBE;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;24;959.7701,-557.093;Inherit;False;Constant;_Float1;Float 1;5;0;Create;True;0;0;0;False;0;False;0.25;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;11;246.8491,57.85823;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;437.0576,-50.84532;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;9;-139,-8.5;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;18;837.0581,-395.2969;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;16;431.9431,87.66321;Inherit;False;Constant;_Float0;Float 0;4;0;Create;True;0;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;10;110,57.5;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;208.7702,-330.093;Inherit;False;Constant;_Float3;Float 2;5;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;809.7144,97.76447;Inherit;False;Property;_Stencil;Stencil;3;0;Create;True;0;0;0;True;0;False;0;1;0;255;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;595.9431,-21.33679;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;817.9431,15.66321;Inherit;False;Property;_Smooth;Smooth;2;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;7;122.548,-211.2026;Inherit;False;Property;_Color0;Color 0;1;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.6886792,0.2176484,0.2176484,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;996.7178,-341.3936;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;25;359.7702,-377.093;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;1118.461,-657.146;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;5;1252.089,-424.9486;Float;False;True;-1;7;ASEMaterialInspector;0;0;Standard;CubeEnv;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Front;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;20;True;Opaque;;AlphaTest;ForwardOnly;16;all;True;True;True;True;0;False;-1;True;1;True;23;255;False;-1;255;False;-1;5;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;19;0;8;0
WireConnection;19;1;20;0
WireConnection;21;0;19;0
WireConnection;21;1;22;0
WireConnection;17;1;21;0
WireConnection;11;0;10;0
WireConnection;13;0;11;0
WireConnection;13;1;11;0
WireConnection;18;0;17;0
WireConnection;18;1;7;0
WireConnection;10;0;9;0
WireConnection;10;1;8;0
WireConnection;15;0;13;0
WireConnection;15;1;16;0
WireConnection;12;0;18;0
WireConnection;12;1;15;0
WireConnection;25;0;21;0
WireConnection;25;1;26;0
WireConnection;27;0;17;0
WireConnection;27;1;24;0
WireConnection;5;0;27;0
WireConnection;5;4;14;0
ASEEND*/
//CHKSM=BE2E7F5769B742E20D2DF7D66D15DA55430D74B9