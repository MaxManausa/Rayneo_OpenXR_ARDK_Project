// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "FloorPoint"
{
	Properties
	{
		_points("points", 2D) = "white" {}
		_large_points("large_points", 2D) = "black" {}
		_wave("wave", 2D) = "black" {}
		_density("density", Float) = 1
		_wavesize("wavesize", Range( 0 , 50)) = 15.14681
		_brightness("brightness", Float) = 1
		_waveheight("waveheight", Range( 0 , 0.1)) = 0.1
		_distance("distance", Float) = 5
		_time("time", Range( 0 , 1)) = 0
		_Color0("Color 0", Color) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+20" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform float _waveheight;
		uniform float4 _Color0;
		uniform sampler2D _points;
		uniform float _density;
		uniform sampler2D _wave;
		uniform float _time;
		uniform float _wavesize;
		uniform sampler2D _large_points;
		uniform float _brightness;
		uniform float _distance;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 temp_output_6_0 = ( i.uv_texcoord * _density );
			float4 tex2DNode1 = tex2D( _points, temp_output_6_0 );
			float mulTime74 = _Time.y * _time;
			float4 tex2DNode2 = tex2D( _wave, ( ( mulTime74 + i.uv_texcoord ) * _wavesize ) );
			float4 lerpResult94 = lerp( _Color0 , tex2DNode1 , tex2DNode2.b);
			float4 tex2DNode66 = tex2D( _large_points, temp_output_6_0 );
			float temp_output_73_0 = pow( tex2DNode2.b , 2.0 );
			float3 ase_worldPos = i.worldPos;
			float temp_output_26_0 = length( ( ase_worldPos - _WorldSpaceCameraPos ) );
			float clampResult85 = clamp( ( 1.0 + ( temp_output_26_0 * -1.0 ) ) , 0.0 , 1.0 );
			float clampResult89 = clamp( ( temp_output_73_0 + clampResult85 ) , 0.0 , 1.0 );
			float4 lerpResult67 = lerp( lerpResult94 , tex2DNode66 , clampResult89);
			o.Emission = ( lerpResult67 * _brightness ).rgb;
			float clampResult87 = clamp( ( temp_output_73_0 + clampResult85 ) , 0.0 , 1.0 );
			float lerpResult72 = lerp( tex2DNode1.a , tex2DNode66.a , clampResult87);
			float clampResult44 = clamp( ( ( ( -1.0 / _distance ) * temp_output_26_0 ) + 1.0 ) , 0.0 , 1.0 );
			o.Alpha = ( lerpResult72 * clampResult44 );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit alpha:fade keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18910
3013;285;1814;1086;-1646.057;454.5895;1;True;True
Node;AmplifyShaderEditor.RangedFloatNode;77;-1110.552,733.2213;Inherit;False;Property;_time;time;8;0;Create;True;0;0;0;True;0;False;0;0.015;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;17;95.88171,477.0792;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;8;112.4539,279.8471;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleTimeNode;74;-819.2999,823.3085;Inherit;False;1;0;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;38;-842.0095,990.5499;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;18;620.3572,376.1569;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-848.6534,1182.979;Inherit;False;Property;_wavesize;wavesize;4;0;Create;True;0;0;0;True;0;False;15.14681;3;0;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;75;-547.97,952.7934;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LengthOpNode;26;851.2821,341.0496;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;82;877.1935,444.1835;Inherit;False;Constant;_Float0;Float 0;10;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;1100.731,365.6405;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-383.4836,984.1097;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;84;1245.731,319.6405;Inherit;False;2;2;0;FLOAT;1;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-188.9096,983.1432;Inherit;True;Property;_wave;wave;2;0;Create;True;0;0;0;True;0;False;-1;None;a90065c2ee6dd7b4eb968b8240638b04;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;40;613.7634,134.1517;Inherit;False;Property;_distance;distance;7;0;Create;True;0;0;0;True;0;False;5;4.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-1096.763,174.097;Inherit;False;Property;_density;density;3;0;Create;True;0;0;0;True;0;False;1;120;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-980.7126,-311.0809;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;73;256.857,672.571;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;85;1364.731,302.6405;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;43;864.09,174.7387;Inherit;False;2;0;FLOAT;-1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-664.3796,-175.0816;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;86;1703.223,56.37816;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;1099.138,257.6013;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;79;1524.787,-180.9845;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-395.6377,-386.7231;Inherit;True;Property;_points;points;0;0;Create;True;0;0;0;False;0;False;-1;None;2e33339c0aaa5d748905472f248dd203;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;90;-28.7753,-800.5474;Inherit;False;Property;_Color0;Color 0;9;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.3563545,0.4834042,0.9811321,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;87;1865.24,-6.501587;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;41;1291.337,184.9769;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;66;-384.259,-140.7624;Inherit;True;Property;_large_points;large_points;1;0;Create;True;0;0;0;True;0;False;-1;None;9235040b1a48b154db832bd8d73cd927;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;89;1671.025,-161.6514;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;94;457.1519,-556.7173;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;67;1847.046,-295.7787;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;72;2004.158,-4.746177;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;2201.302,-138.7346;Inherit;False;Property;_brightness;brightness;5;0;Create;True;0;0;0;True;0;False;1;1.36;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;44;1461.239,150.264;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;687.8298,1099.688;Inherit;False;Property;_waveheight;waveheight;6;0;Create;True;0;0;0;True;0;False;0.1;0.0034;0;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;527.6672,955.3739;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector3Node;29;283.9593,939.165;Inherit;False;Constant;_Vector0;Vector 0;4;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;1048.573,566.5486;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;2193.125,7.776451;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;80;1639.1,211.9002;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;63;1837.058,362.1443;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;-0.4,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;76;-973.517,346.2514;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;2480.616,-173.7614;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;25;2723.608,-173.5874;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;FloorPoint;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;1;False;-1;7;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;20;True;Transparent;;Transparent;All;16;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;3;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;74;0;77;0
WireConnection;18;0;8;0
WireConnection;18;1;17;0
WireConnection;75;0;74;0
WireConnection;75;1;38;0
WireConnection;26;0;18;0
WireConnection;83;0;26;0
WireConnection;83;1;82;0
WireConnection;37;0;75;0
WireConnection;37;1;36;0
WireConnection;84;1;83;0
WireConnection;2;1;37;0
WireConnection;73;0;2;3
WireConnection;85;0;84;0
WireConnection;43;1;40;0
WireConnection;6;0;5;0
WireConnection;6;1;7;0
WireConnection;86;0;73;0
WireConnection;86;1;85;0
WireConnection;39;0;43;0
WireConnection;39;1;26;0
WireConnection;79;0;73;0
WireConnection;79;1;85;0
WireConnection;1;1;6;0
WireConnection;87;0;86;0
WireConnection;41;0;39;0
WireConnection;66;1;6;0
WireConnection;89;0;79;0
WireConnection;94;0;90;0
WireConnection;94;1;1;0
WireConnection;94;2;2;3
WireConnection;67;0;94;0
WireConnection;67;1;66;0
WireConnection;67;2;89;0
WireConnection;72;0;1;4
WireConnection;72;1;66;4
WireConnection;72;2;87;0
WireConnection;44;0;41;0
WireConnection;31;0;29;0
WireConnection;31;1;2;0
WireConnection;34;0;31;0
WireConnection;34;1;35;0
WireConnection;42;0;72;0
WireConnection;42;1;44;0
WireConnection;80;0;44;0
WireConnection;63;1;34;0
WireConnection;76;1;7;0
WireConnection;10;0;67;0
WireConnection;10;1;9;0
WireConnection;25;2;10;0
WireConnection;25;9;42;0
ASEEND*/
//CHKSM=BF3FCEAF1ABCAAA95C19B06A3762CE76465008F1