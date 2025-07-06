// Upgrade NOTE: replaced 'UNITY_PASS_TEXCUBE(unity_SpecCube1)' with 'UNITY_PASS_TEXCUBE_SAMPLER(unity_SpecCube1,unity_SpecCube0)'


float Test_;

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL0;
				float2 uv : TEXCOORD0;
    float2 uv2 : TEXCOORD1;
    float2 uv3 : TEXCOORD2;
    float2 uv4 : TEXCOORD3;
    float2 uv5 : TEXCOORD4;
    float4 Color : COLOR;
    uint id : SV_VertexID;
    float4 tangent : TANGENT;

};



float FresnelDispersionPower;
float FresnelDispersionScale;

float CentreIntensity;
float4x4 MatrixWorldToObject;
float4x4 MatrixWorldToObject2;
float4 CentreModel;
float lightEstimation2;
float MipLevel;

samplerCUBE _Environment;
half4 _Environment_HDR;
float FixedlightEstimation;
float ColorIntensity;
			struct v2f 
			{
				float2 uv : TEXCOORD0; 
    float2 uv2 : TEXCOORD1;
    float2 uv3 : TEXCOORD2;
    float3 WorldBitangent : TEXCOORD3;
    float3 WorldNormal : TEXCOORD4;
				float4 vertex : SV_POSITION0; 
				float3 Pos : TEXCOORD5; 
    float3 Pos2 : TEXCOORD6;
				float3 Normal : NORMAL0;
    float4 Color : COLOR;
    uint id : TEXCOORD7;
    float3 worldPos : TEXCOORD8;
    float4 tangent : TEXCOORD9;
};
			
			// vertex shader
			v2f vert (appdata v)
			{
				v2f o;
    
    

    UNITY_INITIALIZE_OUTPUT(v2f, o);
    
    //float3 VertP = lerp(v.vertex, float3(v.uv2, v.uv3.x), Test);
   
    
    float3 _worldTangent = UnityObjectToWorldDir(v.tangent);
    o.tangent.xyz = _worldTangent;
    float3 _worldNormal = UnityObjectToWorldNormal(v.normal);
    o.WorldNormal.xyz = _worldNormal;
    float _vertexTangentSign = v.tangent.w * unity_WorldTransformParams.w;
    float3 _worldBitangent = cross(_worldNormal, _worldTangent) * _vertexTangentSign;
    o.WorldBitangent.xyz = _worldBitangent;
				
   
    
    
    float4 pos = v.vertex;

    pos.xyz = (pos.xyz - CentreModel.xyz);
    
    o.vertex = UnityObjectToClipPos(pos);
    
    float3 cameraLocalPos;
    
 //   cameraLocalPos = mul(MatrixWorldToObject, float4(_WorldSpaceCameraPos, 1));
    
    cameraLocalPos = mul(MatrixWorldToObject, float4(_WorldSpaceCameraPos, 1));
    
    
    
    
    o.Pos2 = cameraLocalPos;
    
    
    
    
   // pos = lerp(pos, mul(MatrixWorldToObject2, pos),CentreIntensity);
    
    
    o.vertex = UnityObjectToClipPos(v.vertex);
	o.uv = v.uv;
    o.uv2 = v.uv2;
    o.uv3 = v.uv3;
  //  o.uv4 = v.uv4;
    o.Pos = float4(pos.xyz, 1);
				o.Normal = v.normal;
    o.Color = v.Color;
    o.id = v.id;
    o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				return o;
			}


float Dispersion;

float DispersionLimitedAngle;

float DispersionR;
float DispersionG;
float DispersionB;
float Brightness;
float Power;



float DispersionIntensity;
			sampler2D _ShapeTex;
			float _Scale;
            float TotalInternalReflection;
			int _SizeX;
			int _SizeY;
			int _PlaneCount;
			int _MaxReflection;

samplerCUBE ReflectionCube;
		//	samplerCUBE _Environment;
// half4 _Environment_HDR;
			float _RefractiveIndex;

float _RefractiveIndex_;

			float _BaseReflection;




		
			#define MAX_REFLECTION (10)









float random(float2 st)
{
    float r = frac(sin(dot(st.xy,
					float2(12.9898, 78.233)))
					* 43758.5453123);
    return r * clamp(pow(distance(r, 0.6), 2.5) * 100, 0, 1);
}



float CalcReflectionRate(float3 normal, float3 ray, float baseReflection, float borderDot)
			{
				//float normalizedDot = clamp( (abs(dot(normal,ray)) - borderDot) / ( 1.0 - borderDot ), 0.0, 1.0);
    
    float normalizedDot = clamp((abs(dot(normal, ray)) - borderDot) / (1.0 - borderDot), 0.0, 1.0);
    
    
   // return baseReflection;
    
				return baseReflection + (1.0-baseReflection)*pow(1.0-normalizedDot, 5);
			}


half rgb2hsv(half3 c)
{
    half4 K = half4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    half4 p = lerp(half4(c.bg, K.wz), half4(c.gb, K.xy), step(c.b, c.g));
    half4 q = lerp(half4(p.xyw, c.r), half4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return abs(q.z + (q.w - q.y) / (6.0 * d + e));
}

float Remap(float value, float min1, float max1, float min2, float max2)
{
    return (min2 + (value - min1) * (max2 - min2) / (max1 - min1));
}

			float4 GetUnpackedPlaneByIndex(uint index)
			{
				int x_index = index % _SizeX;
				int y_index = index / _SizeX;

				float ustride = 1.0 / _SizeX;
				float vstride = 1.0 / _SizeY;

				float2 uv = float2((0.5+x_index)*ustride, (0.5+y_index)*vstride);

				float4 packedPlane = tex2D(_ShapeTex, uv);

#if !defined(UNITY_COLORSPACE_GAMMA)
				packedPlane.xyz = LinearToGammaSpace(packedPlane.xyz);
#endif

				float3 normal = packedPlane.xyz*2 - float3(1,1,1); // смена диапозона

				return float4(normal, packedPlane.w*_Scale);
			}

			
float CheckCollideRayWithPlane(float3 rayStart, float3 rayNormalized, float4 normalTriangle) // plane - normal.xyz и normal.w - distance
			{
    float dp = dot(rayNormalized, normalTriangle.xyz);

				if( dp < 0 )
				{
					return -1;
				}
				else
				{
        float distanceNormalized = normalTriangle.w - dot(rayStart.xyz, normalTriangle.xyz);

					if( distanceNormalized < 0 )
					{
						return -1;
					}

					return distanceNormalized / dp;
				}


				return -1;
			}


void CollideRayWithPlane(float3 Pos, float PassCount, float3 rayNormalized, float4 TriangleNormal, float startSideRelativeRefraction, out float reflectionRate, out float reflectionRate2, out float3 reflection, out float3 refraction, out float HorizontalElementSquared)
			{
    float3 rayVertical = dot(TriangleNormal.xyz, rayNormalized) * TriangleNormal.xyz;
				reflection = rayNormalized - rayVertical*2.0;
    
 
    
  //  reflection.r = pow(reflection.r, reflection.r * 2);

				float3 rayHorizontal = rayNormalized - rayVertical;

				float3 refractHorizontal = rayHorizontal * startSideRelativeRefraction ;

				float horizontalElementSquared = dot(refractHorizontal, refractHorizontal);
				
			/**/
    float borderDot = 0;

    
				if( startSideRelativeRefraction > 1.0 )
				{
					borderDot = sqrt(1.0-1.0f/(startSideRelativeRefraction*startSideRelativeRefraction));
				}
				else
				{
					borderDot = 0.0;
				} 
    
    
    
    HorizontalElementSquared = 0;
  //  HorizontalElementSquared = horizontalElementSquared;
    
    
    float3 _worldViewDir = UnityWorldSpaceViewDir(Pos);
    _worldViewDir = normalize(_worldViewDir);
    
    
    float fresnelNdotV5 = dot(rayNormalized.xyz, _worldViewDir);

    float fresnelNode5 = (FresnelDispersionScale * pow(1.0 - fresnelNdotV5, FresnelDispersionPower));
    
    
    HorizontalElementSquared = horizontalElementSquared /3;
    if (horizontalElementSquared >= TotalInternalReflection)  
				{
        HorizontalElementSquared = 0;
        
        
					reflectionRate = 1.0;
        reflectionRate2 = 1.0;
        refraction = TriangleNormal.xyz;

					return;
				}				
			
				float verticalSizeSquared = 1-horizontalElementSquared;

				float3 refractVertical = rayVertical * sqrt( verticalSizeSquared / dot(rayVertical, rayVertical));
 //   HorizontalElementSquared = verticalSizeSquared;
    
				refraction = refractHorizontal + refractVertical;

   //  refraction = lerp(TriangleNormal.xyz, refraction, Test_);
    
    reflectionRate = CalcReflectionRate(rayNormalized, TriangleNormal.xyz, _BaseReflection * PassCount, borderDot);

    reflectionRate2 = CalcReflectionRate(rayNormalized, TriangleNormal.xyz, _BaseReflection * PassCount, borderDot);
    
  //  reflectionRate = reflectionRate * CalcReflectionRate(rayNormalized, TriangleNormal.xyz, 1 * PassCount, borderDot);
    
    


    
 //   reflectionRate = CalcReflectionRate(rayNormalized, TriangleNormal.xyz, _BaseReflection, 0);
   // reflectionRate = _BaseReflection;
    
				return;
			}

float3 CalcColorCoefByDistance(float distance,float4 Color)
			{

    return pow(max(Color.xyz, 0.01), distance * Color.w);
}

			float4 SampleEnvironment(float3 rayLocal)
			{
				float3 rayWorld = mul(unity_ObjectToWorld, float4(rayLocal, 0));

				rayWorld = normalize(rayWorld);

    
#if _CUBEMAPMODE_CUBEMAP 
    float4 tex = texCUBElod(_Environment, float4(rayWorld,MipLevel));
				return float4(DecodeHDR(tex, _Environment_HDR), 1);
    
#endif

    
    
  //  UNITY_PASS_TEXCUBE_SAMPLER(unity_SpecCube1, unity_SpecCube0);
    
    
    
    
    
    
 //   float4 tex = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, float4(rayWorld, 0)) * (1 + (1 - lightEstimation2) * 5);
    
    
#if _CUBEMAPMODE_REFLECTIONPROBE
//    float4 tex = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, float4(rayWorld, 0)) / (lerp(1, lightEstimation2, FixedlightEstimation));
    
 // float4 tex =   UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0,rayWorld, MipLevel) / (lerp(1, lightEstimation2, FixedlightEstimation));
    
    
    float4 tex =   UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0,rayWorld, MipLevel);
    
    
  //  float4 tex = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, float4(rayWorld, 0)) * (1 + ((1 - lightEstimation2) * 5 * ((1 - lightEstimation2))));
    
 //   float4 tex = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, float4(rayWorld, 0)) * 1 + lightEstimation2;
    return float4(DecodeHDR(tex, unity_SpecCube0_HDR), 1);
#endif
    
    
    
    
    
    
    
    
    /*
    float4 tex = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, float4(rayWorld, 0));
    return float4(DecodeHDR(tex, unity_SpecCube0_HDR), 1);
    */
}

			void CheckCollideRayWithAllPlanes(float3 rayStart, float3 rayDirection, out float4 hitPlane, out float hitTime)
			{
				hitTime=1000000.0;
				hitPlane=float4(1,0,0,1);
		//		[unroll(20)]
    for(int i=0; i<_PlaneCount; ++i)
				{
					float4 plane = GetUnpackedPlaneByIndex(i);
					float tmpTime = CheckCollideRayWithPlane(rayStart, rayDirection, plane);

					if(tmpTime >= -0.001 && tmpTime<hitTime)
					{
						hitTime = tmpTime;
						hitPlane = plane;
					}
				}
			}

float4 GetColorByRay(float3 rayStart, float3 rayDirection, float refractiveIndex, int MaxReflection, float4 Color, float lighttransmission)
			{
				float3 tmpRayStart = rayStart;
				float3 tmpRayDirection = rayDirection;

				float reflectionRates[MAX_REFLECTION];
    float reflectionRates2[MAX_REFLECTION];
				float4 refractionColors[MAX_REFLECTION];
    float4 refractionColors2[MAX_REFLECTION];
    float4 refractionColors3[MAX_REFLECTION];
				float4 depthColors[MAX_REFLECTION];

    

    
    
    int loopCount = min(MAX_REFLECTION, _MaxReflection);
 //   if (UV.x == 3)
  //  {
   //     loopCount = 1;

   // }
				int badRay = 0;

  //  [unroll(10)]
    for( int i = 0; i<loopCount; ++i )
				{
					float hitTime=1000000.0;
					float4 hitPlane=float4(1,0,0,1);
					CheckCollideRayWithAllPlanes(tmpRayStart, tmpRayDirection, hitPlane, hitTime);

					if (hitTime < 0.0)
					{
						badRay = 1;
					}
										
					float3 rayEnd = tmpRayStart + tmpRayDirection*hitTime;
								
					float reflectionRate;
        float reflectionRate2;
					float3 reflectionRay;
					float3 refractionRay;
        float PlaneNull;

        float i_Pass = i;
        
        if (i_Pass >= 2)
        {
            i_Pass = 0;

        }
        
        if (i_Pass < 2)
        {
            i_Pass = 1;

        }
        
        
        CollideRayWithPlane(rayStart, i_Pass, tmpRayDirection, hitPlane, refractiveIndex, reflectionRate,reflectionRate2, reflectionRay, refractionRay, PlaneNull);
		
        reflectionRates[i] = reflectionRate;
        
        reflectionRates2[i] = reflectionRate2;
        
        float Disp = pow(Dispersion , 2);
        
        float dispPow =  Dispersion * 0.4;
       
        
       
        
        

        
        float depth2 = Remap(i, 0, loopCount, 0, 1);
        
        
        depth2 = clamp(depth2, 0.0001, 1);
        
        depth2 = 1;
        
      //  PlaneNull = Remap(PlaneNull, 0, 2, 0, 1);
        
    //    PlaneNull = lerp(PlaneNull,1,0);
        
        
        float3 _worldViewDir = UnityWorldSpaceViewDir(rayStart.xyz);
        _worldViewDir = normalize(_worldViewDir);

        float fresnelNdotV5 = dot(tmpRayStart, _worldViewDir);
        float fresnelNode5 = (FresnelDispersionScale * pow(1.0 - fresnelNdotV5, FresnelDispersionPower));
        
        fresnelNode5 = 1;
        
        DispersionR = DispersionR * Dispersion * fresnelNode5;
        DispersionG = DispersionG * Dispersion * fresnelNode5;
        DispersionB = DispersionB * Dispersion * fresnelNode5;
        
        
        float3 DispersionRay_r = lerp(refractionRay, lerp(rayEnd, refractionRay,2), DispersionR * PlaneNull);
        
    //    PlaneNull = lerp(PlaneNull, 1, 0.2);
        
        float3 DispersionRay_g = lerp(refractionRay, lerp(rayEnd, refractionRay, 2), DispersionG * PlaneNull);
        
     //   PlaneNull = lerp(PlaneNull, 1, 0.2);
        float3 DispersionRay_b = lerp(refractionRay, lerp(rayEnd, refractionRay, 2), DispersionB * PlaneNull);
        
        
        
        
        
        
        float Depth_ = depthColors[i];
        
        Depth_ = Remap(Depth_, 0.997, 0.999, 1, 0);
        
        
        refractionColors3[i] = SampleEnvironment(refractionRay);
        
        refractionColors2[i] = 1;
        
        refractionColors2[i].r = SampleEnvironment(DispersionRay_r).r;
        refractionColors2[i].g = SampleEnvironment(DispersionRay_g).g;
        refractionColors2[i].b = SampleEnvironment(DispersionRay_b).b;
        
    //    depthColors[i] = float4(CalcColorCoefByDistance(hitTime, Color), 1);
        
        
        Color.rgb = lerp(1, Color, ColorIntensity).rgb;
        
        depthColors[i] = float4(CalcColorCoefByDistance(hitTime, lerp(Color, 1, lerp(0, (refractionColors3[i].r + refractionColors3[i].g + refractionColors3[i].b) / 2, lighttransmission))), 1);
        
        
   //     refractionColors2[i].r = SampleEnvironment(refractionRay + DispersionR).r;
  //      refractionColors2[i].g = SampleEnvironment(refractionRay + DispersionG).g;
  //      refractionColors2[i].b = SampleEnvironment(refractionRay + DispersionB).b;
        
   //     refractionColors[i].b = SampleEnvironment(normalize(refractionRay) - DispersionR).b;
   //     refractionColors[i].r = SampleEnvironment(normalize(refractionRay) - DispersionG).r;
  //      refractionColors[i].g = SampleEnvironment(normalize(refractionRay) - DispersionB).g;
        
        
       
    ////    refractionColors2[i] = DispersionR * PlaneNull;
        
        refractionColors2[i] = clamp(lerp(refractionColors3[i], refractionColors2[i], DispersionIntensity),0,1); 
        
        
     //   refractionColors2[i] = PlaneNull;
        
     //   refractionColors2[i] = refractionColors2[i] * (PlaneNull);
        float CLR = refractionRay.x;
        
        if (CLR < 0)
        {
            CLR = CLR * -1;

        }
        
    //    refractionColors2[i] = PlaneNull;
        
     //   refractionColors2[i] = float4(CLR, 1, 1, 1);
        
     //   refractionColors2[i] = float4(refractionRay + 1, 1);
        
        
    //    refractionColors2[i] = refractionColors2[i] *  depth2;
        
        
  //      refractionColors2[i] = (refractionColors2[i] + refractionColors[i]) / 2;
        
        
        refractionColors[i] = SampleEnvironment(refractionRay);
        
        
   /*     DispersionR = DispersionR / (tmpRayDirection - Depth_) ;
        DispersionG = DispersionG / (tmpRayDirection - Depth_);
        DispersionB = DispersionB / (tmpRayDirection - Depth_) ; */
        
        
        float DispRandom = pow(random(hitPlane.xy),0.1);
        
     //   DispRandom = 1;
        
        float3 DirDisp = clamp(tmpRayStart.rgb,-1,1);
  
        
    //   refractionColors2[i] = 0;

        
        
  //      refractionColors2[i] = (refractionColors2[i] + refractionColors[i]) / 2;
        
        
   //     refractionColors[i] = SampleEnvironment(refractionRay);
        
        
        
    /*    refractionColors2[i].r = SampleEnvironment(refractionRay + (reflectionRay * Dispersion * 1.5));
        refractionColors2[i].g = SampleEnvironment(refractionRay + (reflectionRay * Dispersion * 1.7));
        refractionColors2[i].b = SampleEnvironment(refractionRay + (reflectionRay * Dispersion * 1.9));
 */
					
					

        if (i == loopCount - 1)
        {
            reflectionRates[i] = 0.0;
            reflectionRates2[i] = 0.0;
        }

        tmpRayStart = tmpRayStart + tmpRayDirection * hitTime;
        tmpRayDirection = reflectionRay;
    }
				
    float4 tmpReflectionColor = float4(0, 0, 0, 0);
				
				// reverse calc
    for (int j = loopCount - 1; j >= 0; --j)
    {
        
     
   //     tmpReflectionColor = (0.2 + tmpReflectionColor) / 1.2;
        float4 refractionColors_;
        
       
        /*
       
        if (j > 1)
        {
            refractionColors_ = lerp(refractionColors2[j], tmpReflectionColor, reflectionRates[j]) * depthColors[j];
        }
        else
        {
            
            refractionColors_ = lerp(refractionColors2[j], tmpReflectionColor, reflectionRates[j]) * depthColors[j];
            

        }
        */
      

   //     refractionColors_ = lerp(refractionColors2[j], tmpReflectionColor, reflectionRates[j]) * depthColors[j];

       
     
            tmpReflectionColor = lerp(refractionColors2[j], tmpReflectionColor, reflectionRates[j]) * depthColors[j];
        
				
     //   tmpReflectionColor = max(tmpReflectionColor, lerp(refractionColors2[j], tmpReflectionColor, reflectionRates2[j]) * depthColors[j]);
        
        
     //   refractionColors_ = tmpReflectionColor;
        
        
        
    //     float4 refractionColors_ = lerp(refractionColors[j], tmpReflectionColor, lerp(reflectionRates[j],0.5,0)) * depthColors[j];
        
        
        
        
    //    refractionColors_ = (refractionColors_ + tmpReflectionColor)/2; ======================================

     //   refractionColors_ = (reflectionRates[j] * 6);
        
        
      //  refractionColors_ = refractionColors[j];
        
       // tmpReflectionColor.r = lerp(tmpReflectionColor.r, pow(tmpReflectionColor.r, tmpReflectionColor.r * 2), tmpReflectionColor.r );
        
        
        
      
        
       // refractionColors_ = lerp(refractionColors2[j], tmpReflectionColor, reflectionRates[j]) * depthColors[j];
        
        
      //  DispersionIntensity =  DispersionIntensity;
        
      //  DispersionIntensity = pow(refractionColors_,DispersionIntensity);
        
        
     //   refractionColors_ = lerp(refractionColors_, (lerp(refractionColors2[j], tmpReflectionColor, reflectionRates[j]) * depthColors[j] + tmpReflectionColor) / 2, DispersionIntensity);
        
        
        
        
        
        /*
        if (j > 1)
        {
            refractionColors_ = lerp(refractionColors_, (lerp(refractionColors2[j], tmpReflectionColor, reflectionRates[j]) * depthColors[j] + tmpReflectionColor) / 2, DispersionIntensity);
        }
        else
        {
            refractionColors_ = lerp(refractionColors_, (lerp(refractionColors3[j], tmpReflectionColor, reflectionRates[j]) * depthColors[j] + tmpReflectionColor) / 2, DispersionIntensity);
        }
        */
        
        
        tmpReflectionColor = pow(tmpReflectionColor * Brightness, Power);
     
     //    refractionColors_ = lerp(refractionColors2[j], tmpReflectionColor, reflectionRates[j] * depthColors[j]);
        
        
        
      //  refractionColors_ = tmpReflectionColor;
        
     //   refractionColors_ = float4(tmpRayStart, 1);
        /*
        if (Prism_ == 0)
        {
            
            refractionColors_ = lerp(refractionColors_,lerp(refractionColors2[j], tmpReflectionColor, reflectionRates[j]) * depthColors[j],DispersionIntensity);
            
        }
        */
    //    tmpReflectionColor = refractionColors_;
        /*
        if (Prism_ == 0 && tmpReflectionColor.r > 0.8 && tmpReflectionColor.g < 0.99)
        {
            float3 oldColor = tmpReflectionColor.rgb;
            float3 tmpReflectionColor2;
            
            tmpReflectionColor.r = pow(tmpReflectionColor.r, tmpRayStart.r * tmpReflectionColor.r);
            tmpReflectionColor.g = pow(tmpReflectionColor.g, tmpRayStart.g * tmpReflectionColor.g);
            tmpReflectionColor.b = pow(tmpReflectionColor.b, tmpRayStart.b * tmpReflectionColor.b);
            
            
            tmpReflectionColor2.r = pow(tmpReflectionColor.r, tmpRayStart.r * oldColor.b);
            tmpReflectionColor2.g = pow(tmpReflectionColor.g, tmpRayStart.g * oldColor.r);
            tmpReflectionColor2.b = pow(tmpReflectionColor.b, tmpRayStart.b * oldColor.g);
            
            tmpReflectionColor.rgb = pow(lerp(tmpReflectionColor.rgb, tmpReflectionColor2, oldColor.r), 10);
            
           tmpReflectionColor.rgb = lerp(oldColor, tmpReflectionColor.rgb, 5);
            
            
            /*
            tmpReflectionColor.r = pow(tmpReflectionColor.r, tmpReflectionColor.r * 2) ;
            tmpReflectionColor.g = pow(tmpReflectionColor.g, tmpReflectionColor.g * 3) ;
            tmpReflectionColor.b = pow(tmpReflectionColor.b, tmpReflectionColor.b * 4) ;
            
    }
        */
        
        
      /*  if (Prism_ < 0.97)
        {
        
        tmpReflectionColor.r = pow(tmpReflectionColor.r, tmpReflectionColor.r * 2);
            tmpReflectionColor.g = pow(tmpReflectionColor.g, tmpReflectionColor.g * 2.72);
            tmpReflectionColor.b = pow(tmpReflectionColor.b, tmpReflectionColor.b * 4.4);
        }
        */
        
        
       /* if (reflectionRates[j].r < 0.1)
        {
            tmpReflectionColor = float4(1, 0, 0, 1);

        }*/

        
        
    //    Prism_ = depthColors[j].b;
        
    }
				
				if (badRay > 0)
				{
					return float4(1, 0, 0, 1);
				}
   // return float4(Prism_.xxx, 1);
				return tmpReflectionColor;
			}


float4 CalculateContrast(float contrastValue, float4 colorTarget)
{
    float t = 0.5 * (1.0 - contrastValue);
    return mul(float4x4(contrastValue, 0, 0, t, 0, contrastValue, 0, t, 0, 0, contrastValue, t, 0, 0, 0, 1), colorTarget);
}

float4 ToneMap(float4 MainColor, float brightness, float Disaturate, float _max, float _min, float contrast, float Satur)
{

				

				

				
    fixed4 output = MainColor;
			//	output = output * brightness;
    output = output * brightness;
    output = CalculateContrast(contrast, output);

    float4 disatur = dot(output, float3(0.299, 0.587, 0.114)); // Desaturate
    output = lerp(output, disatur, clamp(pow(((output.x + output.y + output.z) / 3) * Disaturate, 1.3), 0, 1));
    output.x = clamp(Remap(output.x, 0, 1, _min, lerp(_max, 1, 0.5)), 0, 1.5);
    output.y = clamp(Remap(output.y, 0, 1, _min, lerp(_max, 1, 0.5)), 0, 1.5);
    output.z = clamp(Remap(output.z, 0, 1, _min, lerp(_max, 1, 0.5)), 0, 1.5);
				
			//	output = CalculateContrast(clamp(1 - pow((output.x + output.y + output.z) / 3, 1),0,1) * 2, output);

				



					


    output = pow(output, contrast);
				
				//output = lerp(output * (1 - pow(disatur,2)), output, 1 * lerp(max,1,0.3) );

					

				//output = lerp(output, output - 0.5,  _Middle *  clamp( distance(0.8, disatur), 0, 1));

    output = lerp(clamp(output, 0, _max), output, pow(_max, 4));



    output = lerp(smoothstep(output, -0.1, 0.25), output, (1 - distance(1, _max) * 2));

				
    output = lerp(dot(output, float3(0.299, 0.587, 0.114)), output, Satur);

    output = output * lerp(brightness, 1, 0.75);




    return output;


}