// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Head"
{
	Properties
	{
		_strenght("strenght", Float) = 0
		_fresnerStrenght("fresner Strenght", Float) = 0
		_environment("environment", CUBE) = "white" {}
		_environment2("environment2", CUBE) = "white" {}
		_FresnerColor("FresnerColor", Color) = (1,1,1,0)
		_InteriorColor("InteriorColor", Color) = (1,1,1,0)
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_density("density", Range( 0 , 40)) = 1
		_speed("speed", Range( -3 , 3)) = 1
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_changematerials("change materials", Range( 0 , 1)) = 0
		_TextureSample2("Texture Sample 2", 2D) = "white" {}
		_ChangeMaterial2("Change Material 2", Range( 0 , 1)) = 0
		_ChangeMaterial3("Change Material 3", Range( 0 , 1)) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float3 worldNormal;
			float3 viewDir;
			float3 worldPos;
			float3 worldRefl;
			INTERNAL_DATA
		};

		uniform sampler2D _TextureSample2;
		uniform float _strenght;
		uniform samplerCUBE _environment2;
		uniform samplerCUBE _environment;
		uniform float4 _InteriorColor;
		uniform float _ChangeMaterial3;
		uniform float4 _FresnerColor;
		uniform float _fresnerStrenght;
		uniform sampler2D _TextureSample0;
		uniform float _density;
		uniform float _speed;
		uniform sampler2D _TextureSample1;
		uniform float _changematerials;
		uniform float _ChangeMaterial2;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldNormal = i.worldNormal;
			float dotResult32 = dot( ase_worldNormal , i.viewDir );
			float clampResult34 = clamp( ( 1.0 - dotResult32 ) , 0.0 , 1.0 );
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float temp_output_127_0 = ( ( ase_vertex3Pos.x + 1.0 ) * 0.5 );
			float clampResult99 = clamp( _SinTime.w , 0.0 , 0.05 );
			float mulTime85 = _Time.y * 0.1;
			float4 appendResult90 = (float4(temp_output_127_0 , ( ase_vertex3Pos.y + clampResult99 + mulTime85 ) , 0.0 , 0.0));
			float4 tex2DNode79 = tex2D( _TextureSample2, ( appendResult90 * float4( 2,2,0,0 ) ).xy );
			float3 ase_worldReflection = i.worldRefl;
			float4 lerpResult138 = lerp( texCUBE( _environment2, ase_worldReflection ) , ( texCUBE( _environment, ase_worldReflection ) * _InteriorColor ) , _ChangeMaterial3);
			float3 ase_worldPos = i.worldPos;
			float lerpResult67 = lerp( ase_worldPos.y , ase_worldPos.z , _SinTime.z);
			float mulTime56 = _Time.y * _speed;
			float4 appendResult151 = (float4(( _SinTime.z + ase_worldPos.y ) , ase_worldPos.z , 0.0 , 0.0));
			float4 appendResult104 = (float4(( ( lerpResult67 * _density ) + mulTime56 + ( 0.5 * tex2D( _TextureSample1, ( appendResult151 * float4( 0.5,0.5,0,0 ) ).xy ).r ) ) , ( ase_worldPos.y * ( ( ase_vertex3Pos.x * 20.0 ) + _density ) ) , 0.0 , 0.0));
			float3 lerpResult75 = lerp( float3( 0,0,0 ) , ( ( ase_vertex3Pos + float3( 0.3,0.1,1.5 ) ) * tex2D( _TextureSample0, appendResult104.xy ).r ) , _changematerials);
			float4 appendResult74 = (float4(( ( ( _strenght * lerpResult138 ) + ( pow( clampResult34 , 5.0 ) * _FresnerColor * _fresnerStrenght ) ) + float4( lerpResult75 , 0.0 ) )));
			float4 lerpResult76 = lerp( ( ( ( clampResult34 * clampResult34 ) * ( tex2DNode79 + tex2DNode79 ) ) + float4( 0,0,0,0 ) ) , appendResult74 , _ChangeMaterial2);
			o.Emission = lerpResult76.xyz;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

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
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float4 tSpace0 : TEXCOORD1;
				float4 tSpace1 : TEXCOORD2;
				float4 tSpace2 : TEXCOORD3;
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
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
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
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.viewDir = worldViewDir;
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.worldRefl = -worldViewDir;
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
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
3013;285;1814;1086;-4196.903;1026.646;1;True;True
Node;AmplifyShaderEditor.SinTimeNode;66;1199.179,-2.724365;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;44;1692.772,-283.7521;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;71;1700.426,186.1924;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;151;1907.385,185.0861;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;152;2009.385,359.0861;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0.5,0.5,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.PosVertexDataNode;110;2010.994,-911.1045;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;31;591.6025,-164.6725;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LerpOp;67;2114.35,-206.4258;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;62;1762.21,-16.18594;Inherit;False;Property;_density;density;7;0;Create;True;0;0;0;True;0;False;1;0.15;0;40;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;150;2014.748,-503.1786;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;20;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;70;2143.252,206.217;Inherit;True;Property;_TextureSample1;Texture Sample 1;9;0;Create;True;0;0;0;False;0;False;-1;None;a90065c2ee6dd7b4eb968b8240638b04;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;63;1933.251,86.72153;Inherit;False;Property;_speed;speed;8;0;Create;True;0;0;0;True;0;False;1;0.25;-3;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;29;560.6025,-364.6725;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SinTimeNode;102;2131.264,-1205.188;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;99;2314.096,-1180.413;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.05;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;56;2234.602,-18.41768;Inherit;False;1;0;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;126;2495.172,-914.6262;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;32;798.6025,-267.6725;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;85;2264.843,-1029.081;Inherit;False;1;0;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;2331.309,-181.886;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldReflectionVector;103;-421.5707,-807.7848;Inherit;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;149;2015.748,-299.1786;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;2429.681,86.35358;Inherit;False;2;2;0;FLOAT;0.5;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;127;2623.172,-955.6262;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;91;2564.934,-1155.033;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;57;2493.594,-188.8653;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;17;495.6501,-683.8367;Inherit;True;Property;_environment;environment;2;0;Create;True;0;0;0;False;0;False;-1;None;e37a3acb2fdb11d43a0aeb2385c90076;True;0;False;white;Auto;False;Object;-1;Auto;Cube;8;0;SAMPLERCUBE;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;105;2216.584,-359.7186;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;8;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;36;981.6073,-313.6646;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;42;838.9386,-590.7921;Inherit;False;Property;_InteriorColor;InteriorColor;5;0;Create;True;0;0;0;False;0;False;1,1,1,0;0.5271215,0,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;139;562.4192,-791.0012;Inherit;False;Property;_ChangeMaterial3;Change Material 3;13;0;Create;True;0;0;0;True;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;34;1157.607,-366.6646;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;90;2857.289,-1057.63;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;140;1072.577,-682.5864;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;104;2679.584,-248.7186;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;137;496.4025,-1050.048;Inherit;True;Property;_environment2;environment2;3;0;Create;True;0;0;0;True;0;False;-1;None;51155988379081b4fbddc28eae827be4;True;0;False;white;Auto;False;Object;-1;Auto;Cube;8;0;SAMPLERCUBE;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;87;3003.793,-1143.703;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;2,2,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;14;1020.943,-979.2368;Inherit;False;Property;_strenght;strenght;0;0;Create;True;0;0;0;True;0;False;0;0.32;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;971.959,-130.6509;Inherit;False;Property;_fresnerStrenght;fresner Strenght;1;0;Create;True;0;0;0;True;0;False;0;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;38;1343.607,-394.6646;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;138;964.4457,-832.7148;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;114;2889.794,-449.6876;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0.3,0.1,1.5;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;41;1255.081,-213.5211;Inherit;False;Property;_FresnerColor;FresnerColor;4;0;Create;True;0;0;0;False;0;False;1,1,1,0;0.4192716,0.3683248,0.8773585,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;55;2848.585,-287.8844;Inherit;True;Property;_TextureSample0;Texture Sample 0;6;0;Create;True;0;0;0;False;0;False;-1;None;bf74b3e089b82ab4baf64bea2b16b527;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;77;3310.093,-281.1735;Inherit;False;Property;_changematerials;change materials;10;0;Create;True;0;0;0;True;0;False;0;0.941;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;1299.344,-847.0325;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;1536.081,-410.5211;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;79;3172.709,-1194.951;Inherit;True;Property;_TextureSample2;Texture Sample 2;11;0;Create;True;0;0;0;False;0;False;-1;None;ad32e739c76e1af44b4332806c92e501;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;3184.99,-488.4171;Inherit;False;2;2;0;FLOAT3;10,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;75;3412.62,-518.975;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;118;3438.625,-874.2077;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;136;3522.278,-1177.861;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;37;1853.607,-627.6646;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;130;3652.561,-916.3752;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0.4,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;64;3556.829,-617.211;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;74;3707.573,-620.9518;Inherit;False;FLOAT4;4;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;89;3733.093,-492.9211;Inherit;False;Property;_ChangeMaterial2;Change Material 2;12;0;Create;True;0;0;0;True;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;129;3827,-1038.362;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;171;3973.899,-0.8167114;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;144;234.0422,-1018.656;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;162;5020.336,-476.0173;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;76;4031.559,-659.302;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.AbsOpNode;172;4437.7,87.15265;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;68;1497.308,-59.71286;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleRemainderNode;142;-138.9578,-961.6563;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;2,2,2;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;148;-158.9593,-678.7206;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;141;3.042175,-1217.656;Inherit;False;2;0;FLOAT3;1,1,1;False;1;FLOAT3;1,1,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldNormalVector;134;3442.81,-1414.049;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;147;86.90137,-882.4858;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;146;116.0422,-1144.656;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;1,1,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.AbsOpNode;143;-6.957825,-1038.656;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;145;320.0422,-1241.656;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;173;4258.903,-485.6456;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;155;3961.184,-225.4596;Inherit;False;Constant;_Float0;Float 0;14;0;Create;True;0;0;0;False;0;False;0.07;0;0;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;174;4779.903,-375.6456;Inherit;False;Constant;_Vector0;Vector 0;14;0;Create;True;0;0;0;False;0;False;1,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;154;4426.184,-411.4596;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalVertexDataNode;153;4008.184,-442.4596;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;169;4964.429,-138.5424;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;168;4816.429,-170.5424;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;158;4647.018,-78.08664;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;165;3598.095,157.9225;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleRemainderNode;166;3848.121,124.787;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;160;3756.336,-151.0174;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;167;4052.253,139.8145;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;161;4107.336,-95.0174;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;157;4279.718,-13.88664;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;128;2720.172,-867.6262;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;170;5078.429,-285.5424;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;88;5208.992,-895.7601;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Head;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;16;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;71;0;66;3
WireConnection;71;1;44;2
WireConnection;151;0;71;0
WireConnection;151;1;44;3
WireConnection;152;0;151;0
WireConnection;67;0;44;2
WireConnection;67;1;44;3
WireConnection;67;2;66;3
WireConnection;150;0;110;1
WireConnection;70;1;152;0
WireConnection;99;0;102;4
WireConnection;56;0;63;0
WireConnection;126;0;110;1
WireConnection;32;0;29;0
WireConnection;32;1;31;0
WireConnection;61;0;67;0
WireConnection;61;1;62;0
WireConnection;149;0;150;0
WireConnection;149;1;62;0
WireConnection;72;1;70;1
WireConnection;127;0;126;0
WireConnection;91;0;110;2
WireConnection;91;1;99;0
WireConnection;91;2;85;0
WireConnection;57;0;61;0
WireConnection;57;1;56;0
WireConnection;57;2;72;0
WireConnection;17;1;103;0
WireConnection;105;0;44;2
WireConnection;105;1;149;0
WireConnection;36;1;32;0
WireConnection;34;0;36;0
WireConnection;90;0;127;0
WireConnection;90;1;91;0
WireConnection;140;0;17;0
WireConnection;140;1;42;0
WireConnection;104;0;57;0
WireConnection;104;1;105;0
WireConnection;137;1;103;0
WireConnection;87;0;90;0
WireConnection;38;0;34;0
WireConnection;138;0;137;0
WireConnection;138;1;140;0
WireConnection;138;2;139;0
WireConnection;114;0;110;0
WireConnection;55;1;104;0
WireConnection;39;0;14;0
WireConnection;39;1;138;0
WireConnection;40;0;38;0
WireConnection;40;1;41;0
WireConnection;40;2;43;0
WireConnection;79;1;87;0
WireConnection;65;0;114;0
WireConnection;65;1;55;1
WireConnection;75;1;65;0
WireConnection;75;2;77;0
WireConnection;118;0;34;0
WireConnection;118;1;34;0
WireConnection;136;0;79;0
WireConnection;136;1;79;0
WireConnection;37;0;39;0
WireConnection;37;1;40;0
WireConnection;130;0;118;0
WireConnection;130;1;136;0
WireConnection;64;0;37;0
WireConnection;64;1;75;0
WireConnection;74;0;64;0
WireConnection;129;0;130;0
WireConnection;171;0;160;2
WireConnection;144;0;143;0
WireConnection;144;1;145;0
WireConnection;162;0;154;0
WireConnection;162;1;170;0
WireConnection;162;2;174;0
WireConnection;76;0;129;0
WireConnection;76;1;74;0
WireConnection;76;2;89;0
WireConnection;172;0;157;0
WireConnection;68;0;66;1
WireConnection;142;0;103;0
WireConnection;141;0;143;0
WireConnection;147;0;148;0
WireConnection;146;0;143;0
WireConnection;143;0;142;0
WireConnection;145;0;141;0
WireConnection;145;1;146;0
WireConnection;154;0;153;0
WireConnection;154;1;155;0
WireConnection;169;0;168;0
WireConnection;168;0;158;0
WireConnection;158;0;172;0
WireConnection;166;0;165;0
WireConnection;167;0;166;0
WireConnection;161;0;160;2
WireConnection;157;0;161;0
WireConnection;157;1;167;0
WireConnection;128;0;127;0
WireConnection;128;2;127;0
WireConnection;170;0;169;0
WireConnection;88;2;76;0
ASEEND*/
//CHKSM=3FAE7A710E995CB702AF5322452639B33526A25B