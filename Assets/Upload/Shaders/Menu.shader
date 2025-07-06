// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Menu"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Float0("Float 0", Range( 0 , 6)) = 0
		_Float2("Float 2", Range( 0 , 6)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha noshadow 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _TextureSample0;
		uniform float _Float0;
		uniform float _Float2;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float mulTime27 = _Time.y * 0.2;
			float smoothstepResult38 = smoothstep( 0.0 , 0.07 , ( mulTime27 % 1.0 ));
			float4 appendResult29 = (float4(i.uv_texcoord.x , ( i.uv_texcoord.y - ( ( smoothstepResult38 + floor( mulTime27 ) ) * 0.2 ) ) , 0.0 , 0.0));
			float4 tex2DNode1 = tex2D( _TextureSample0, appendResult29.xy );
			o.Emission = tex2DNode1.rgb;
			float clampResult22 = clamp( ( pow( ( _Float0 * ( 0.5 - abs( ( 0.5 - i.uv_texcoord.y ) ) ) ) , 2.0 ) - _Float2 ) , 0.0 , 1.0 );
			o.Alpha = ( tex2DNode1.a * clampResult22 );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18910
2731;214;1814;1092;2291.562;638.4556;1.922672;True;True
Node;AmplifyShaderEditor.SimpleTimeNode;27;-1501.631,25.9814;Inherit;False;1;0;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;20;-1727.687,216.0009;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleRemainderNode;37;-1388.981,-148.1587;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;21;-528.9492,279.6591;Inherit;False;2;0;FLOAT;0.5;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;38;-1207.981,-206.1587;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.07;False;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode;33;-1201.478,94.76398;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;24;-356.4626,276.9315;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;39;-971.9807,-62.15869;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;25;-196.86,237.5521;Inherit;False;2;0;FLOAT;0.5;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-308.6392,74.60678;Inherit;False;Property;_Float0;Float 0;2;0;Create;True;0;0;0;True;0;False;0;0;0;6;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-22.3567,210.928;Inherit;False;2;2;0;FLOAT;2;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-917.4778,124.764;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;36;141.9248,254.0442;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;44;50.36078,418.6068;Inherit;False;Property;_Float2;Float 2;3;0;Create;True;0;0;0;True;0;False;0;0;0;6;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;30;-771.4596,-12.72173;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;42;343.3608,329.6068;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;29;-499.4022,-239.7141;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;1;-252,-234.5;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;22;513.3681,140.4851;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;678.7251,9.569824;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;19;978.0852,-299.726;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Menu;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;False;TransparentCutout;;Transparent;All;16;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;37;0;27;0
WireConnection;21;1;20;2
WireConnection;38;0;37;0
WireConnection;33;0;27;0
WireConnection;24;0;21;0
WireConnection;39;0;38;0
WireConnection;39;1;33;0
WireConnection;25;1;24;0
WireConnection;35;0;43;0
WireConnection;35;1;25;0
WireConnection;34;0;39;0
WireConnection;36;0;35;0
WireConnection;30;0;20;2
WireConnection;30;1;34;0
WireConnection;42;0;36;0
WireConnection;42;1;44;0
WireConnection;29;0;20;1
WireConnection;29;1;30;0
WireConnection;1;1;29;0
WireConnection;22;0;42;0
WireConnection;23;0;1;4
WireConnection;23;1;22;0
WireConnection;19;2;1;0
WireConnection;19;9;23;0
ASEEND*/
//CHKSM=5B6E34AF43355AB2E7444F17CC94A8A1680F9C8C