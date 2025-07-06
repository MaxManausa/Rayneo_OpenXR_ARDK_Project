Shader "Unlit/SitToon"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _OutlineWith("OutlineWith", Range(0,0.0001))= 0.0001
        _OutlineColor("OutlineColor",Color) = (1,1,1,1)
        _ColorChange("ColorChange",Color) = (0.0,0.0,0.0,0)
        _LightColor("LightColor",Color) = (0.0,0.0,0.0,0)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
        
        Pass //OutLINE
        {
            Cull Front
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag


            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 pos : SV_POSITION;
            };


            float _OutlineWith; 
            half4 _OutlineColor;
            half4 _ColorChange; 

            v2f vert (appdata v)
            {
                v2f o;
                float4 outlinePos = v.vertex + float4(v.normal * _OutlineWith, 0.0);
                o.pos = UnityObjectToClipPos(outlinePos);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = _OutlineColor;

                return col;
            }
            ENDCG
        }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag


            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float3 uv : TEXCOORD0;
                float4 pos : SV_POSITION;
            };

            sampler2D _MainTex;
            half4 _MainTex_ST;
            half4 _ColorChange;
            half4 _LightColor;

            v2f vert (appdata v)
            {
                v2f o;
                float3 normal_world = normalize(mul(v.normal, unity_WorldToObject).xyz);
                float3 lightDir = normalize(float3(-1,1,1));
                //lambert light
                o.uv.z = clamp(dot(normal_world, lightDir), 0, 1);
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv.xy);
                col = (col + _ColorChange) * 0.5 + i.uv.z * _LightColor;
                col[3] = 1.0; 

                return col;
            }
            ENDCG
        }
    }
}
