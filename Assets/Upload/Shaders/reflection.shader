// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "reflection"
{
	Properties
	{
		_reflect("reflect", CUBE) = "black" {}
		_refstrenght("ref strenght", Range( 0 , 20)) = 1
		_transparent("transparent", Range( 0 , 1)) = 1
		_Color0("Color 0", Color) = (0,0,0,0)
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "AlphaTest+20" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 5.0
		#pragma surface surf Standard keepalpha noshadow 
		struct Input
		{
			float3 viewDir;
			float3 worldNormal;
		};

		uniform float4 _Color0;
		uniform samplerCUBE _reflect;
		uniform float _refstrenght;
		uniform float _transparent;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldNormal = i.worldNormal;
			float3 normalizeResult48 = normalize( reflect( ( i.viewDir * -1.0 ) , ase_worldNormal ) );
			o.Emission = ( ( _Color0 + texCUBE( _reflect, normalizeResult48 ) ) * _refstrenght ).rgb;
			o.Alpha = _transparent;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18910
2360;1126;1396;1394;1076.838;120.1032;1;True;True
Node;AmplifyShaderEditor.RangedFloatNode;45;-1151.681,677.3902;Inherit;False;Constant;_Float0;Float 0;11;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;43;-1383.681,484.3902;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-1097.681,488.3902;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldNormalVector;47;-1009.681,604.3902;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ReflectOpNode;42;-831.6814,467.3902;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;48;-788.6814,354.3902;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;10;-550.2838,291.8603;Inherit;True;Property;_reflect;reflect;1;0;Create;True;0;0;0;True;0;False;-1;None;e37a3acb2fdb11d43a0aeb2385c90076;True;0;False;black;LockedToCube;False;Object;-1;Auto;Cube;8;0;SAMPLERCUBE;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;49;-473.8383,18.89676;Inherit;False;Property;_Color0;Color 0;4;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.2188858,0,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;24;-305.5381,507.9818;Inherit;False;Property;_refstrenght;ref strenght;2;0;Create;True;0;0;0;True;0;False;1;0.75;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;50;-205.8383,118.8968;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;12;44.29718,572.2141;Inherit;False;Property;_transparent;transparent;3;0;Create;True;0;0;0;True;0;False;1;0.425;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-64.70792,295.7812;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;381.3894,-159.5123;Float;False;True;-1;7;ASEMaterialInspector;0;0;Standard;reflection;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;20;True;Opaque;;AlphaTest;All;16;all;True;True;True;True;0;False;-1;False;0;True;1;255;False;-1;255;False;-1;5;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;44;0;43;0
WireConnection;44;1;45;0
WireConnection;42;0;44;0
WireConnection;42;1;47;0
WireConnection;48;0;42;0
WireConnection;10;1;48;0
WireConnection;50;0;49;0
WireConnection;50;1;10;0
WireConnection;5;0;50;0
WireConnection;5;1;24;0
WireConnection;0;2;5;0
WireConnection;0;9;12;0
ASEEND*/
//CHKSM=26D404FA59059B099B3FCD547088E9DCF022E55D