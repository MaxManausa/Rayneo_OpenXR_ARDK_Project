// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "CubeContent"
{
	Properties
	{
		_Stencil("Stencil", Range( 0 , 255)) = 1
		_Color0("Color 0", Color) = (0,0,0,0)
		_Color1("Color 1", Color) = (0,0,0,0)
		_Smooth("Smooth", Range( 0 , 1)) = 0
		_Fresner("Fresner", Range( 0 , 15)) = 1
		_Fresnerbias("Fresner bias", Range( 0 , 1)) = 0
		_Fresnerpowers("Fresner powers", Range( 0 , 15)) = 1
		_reflect("reflect", 2D) = "black" {}
		_refscale("ref scale", Range( 0 , 20)) = 1
		_refstrenght("ref strenght", Range( 0 , 20)) = 1
		_transparent("transparent", Range( 0 , 1)) = 1
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "AlphaTest+20" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Stencil
		{
			Ref [_Stencil]
			Comp Equal
		}
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#pragma target 5.0
		#pragma surface surf Standard keepalpha noshadow 
		struct Input
		{
			float3 worldRefl;
			INTERNAL_DATA
			float3 worldPos;
			float3 worldNormal;
		};

		uniform float _Stencil;
		uniform float4 _Color0;
		uniform float4 _Color1;
		uniform float _Fresnerbias;
		uniform float _Fresner;
		uniform float _Fresnerpowers;
		uniform sampler2D _reflect;
		uniform float _refscale;
		uniform float _refstrenght;
		uniform float _Smooth;
		uniform float _transparent;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldReflection = i.worldRefl;
			float4 lerpResult27 = lerp( _Color0 , _Color1 , (0.0 + (ase_worldReflection.y - -1.0) * (1.0 - 0.0) / (1.0 - -1.0)));
			o.Albedo = lerpResult27.rgb;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV4 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode4 = ( _Fresnerbias + _Fresner * pow( 1.0 - fresnelNdotV4, _Fresnerpowers ) );
			float3 normalizeResult20 = normalize( ase_worldReflection );
			o.Emission = ( ( _Color0 * fresnelNode4 ) + ( tex2D( _reflect, ( normalizeResult20 / _refscale ).xy ) * _refstrenght ) ).rgb;
			o.Smoothness = _Smooth;
			o.Alpha = _transparent;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18910
2811;274;1396;1308;1085.153;674.6163;1;True;True
Node;AmplifyShaderEditor.WorldReflectionVector;8;-1481.034,-346.0421;Inherit;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalizeNode;20;-1018.332,345.0006;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-1015.429,582.5002;Inherit;False;Property;_refscale;ref scale;9;0;Create;True;0;0;0;True;0;False;1;4.79;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-957.3318,192.0007;Inherit;False;Property;_Fresnerpowers;Fresner powers;7;0;Create;True;0;0;0;True;0;False;1;0.54;0;15;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-952.0082,102.4813;Inherit;False;Property;_Fresner;Fresner;5;0;Create;True;0;0;0;True;0;False;1;0.89;0;15;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-960.3318,9.000656;Inherit;False;Property;_Fresnerbias;Fresner bias;6;0;Create;True;0;0;0;True;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;16;-724.6115,429.1425;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;2;-805.9114,-741.7018;Inherit;False;Property;_Color0;Color 0;2;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.2509904,0.1411764,0.5843138,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;24;-549.9379,579.4819;Inherit;False;Property;_refstrenght;ref strenght;10;0;Create;True;0;0;0;True;0;False;1;0;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;4;-600.0082,14.48126;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;10;-554.2838,282.8603;Inherit;True;Property;_reflect;reflect;8;0;Create;True;0;0;0;True;0;False;-1;None;58df2ebb521175f40ab2fa180d3bb70b;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-279.908,1.48126;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-211.9383,279.1817;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;26;-792.7849,-534.0951;Inherit;False;Property;_Color1;Color 1;3;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.3114049,0.1843137,0.7921569,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;40;-1113.135,-191.0204;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;37;-1113.994,-354.7834;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-133.0399,394.1766;Inherit;False;Property;_Smooth;Smooth;4;0;Create;True;0;0;0;True;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;27;-165.2407,-526.0872;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1;-171.1716,490.6934;Inherit;False;Property;_Stencil;Stencil;1;0;Create;True;0;0;0;True;0;False;1;1;0;255;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-4.70282,265.2141;Inherit;False;Property;_transparent;transparent;11;0;Create;True;0;0;0;True;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;11;-19.51745,48.51591;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.NormalizeNode;41;-1290.135,-461.0204;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;381.3894,-159.5123;Float;False;True;-1;7;ASEMaterialInspector;0;0;Standard;CubeContent;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;20;True;Transparent;;AlphaTest;All;16;all;True;True;True;True;0;False;-1;True;0;True;1;255;False;-1;255;False;-1;5;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;20;0;8;0
WireConnection;16;0;20;0
WireConnection;16;1;17;0
WireConnection;4;1;21;0
WireConnection;4;2;7;0
WireConnection;4;3;22;0
WireConnection;10;1;16;0
WireConnection;5;0;2;0
WireConnection;5;1;4;0
WireConnection;25;0;10;0
WireConnection;25;1;24;0
WireConnection;40;0;8;2
WireConnection;37;0;8;2
WireConnection;27;0;2;0
WireConnection;27;1;26;0
WireConnection;27;2;40;0
WireConnection;11;0;5;0
WireConnection;11;1;25;0
WireConnection;41;0;8;0
WireConnection;0;0;27;0
WireConnection;0;2;11;0
WireConnection;0;4;3;0
WireConnection;0;9;12;0
ASEEND*/
//CHKSM=E4E3573EDD8B167578C3CF30168F7BC30419BA07