﻿// VacuumShaders 2014
// https://www.facebook.com/VacuumShaders

Shader "VacuumShaders/Colored Shadows/Cutout/Bumped Specular" 
{
	Properties 
	{
		//Default Options
		[DefaultOptions]
		V_CSH_D_OPTIONS("", float) = 0

		_Color("Main Color", color) = (1, 1, 1, 1)
		_SpecColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 1)
		_Shininess ("Shininess", Range (0.01, 1)) = 0.078125		
		_MainTex ("Base (RGB) TransGloss (A)", 2D) = "white" {}
		_BumpMap ("NormalMap", 2D) = "bump"{}
		_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5

		
		//Shadow Options
		[ShadowOptions]
		V_CSH_SH_OPTIONS("", float) = 0

		_V_CSH_ShadowIntencity("Shadow Intencity", Range(0, 1)) = 1
		[HideInInspector]
		_V_CSH_ShadowColor("Shadow Color", color) = (0, 1, 0.5, 1)		
		[HideInInspector]
		_V_CSH_ShadowTex("Shadow Texture", 2D) = "black"{}
		[HideInInspector]
		_V_CSH_GradientTex("Gradient Texture", 2D) = "black"{}
		[HideInInspector]
		_V_CSH_ShadowEmissive("Shadow Emissive", Range(0, 1)) = 1	
	}

	SubShader 
	{
		Tags {"Queue"="AlphaTest" "IgnoreProjector"="True" "RenderType"="TransparentCutout"}
		LOD 200
		
		 Pass 
		 {
            Name "ForwardBase"
            Tags {"LightMode"="ForwardBase"}
            
            
            CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#define UNITY_PASS_FORWARDBASE
				#include "UnityCG.cginc"
				#include "AutoLight.cginc"
				#pragma multi_compile_fwdbase

				#pragma target 3.0

				#pragma shader_feature V_CSH_COLOR_LIGHTCOLOR V_CSH_COLOR_INVERTLIGHTCOLOR V_CSH_COLOR_CUSTOMCOLOR V_CSH_COLOR_GRADIENT
				#pragma shader_feature V_CSH_DISABLE_LIGHT_COLORES_OFF V_CSH_DISABLE_LIGHT_COLORES_ON
				#pragma shader_feature V_CSH_TEXTURE_NONE V_CSH_TEXTURE_RGB V_CSH_TEXTURE_RGBA
				#pragma shader_feature V_CSH_EMISSION_TYPE_NONE V_CSH_EMISSION_TYPE_MULTIPLY V_CSH_EMISSION_TYPE_EXPONENTAL


				#define V_NEED_TANGENT

				#define NEED_CALC_TANGET_ROTATION
				#define NEED_CALC_LIGHTDIR_TS
				#define NEED_CALC_VIEWDIR_TS

				#define NEED_P_LIGHTDIR_TS
				#define NEED_P_VIEWDIR_TS

				#define SPECULAR_ON
				#define CUTOUT_ON
				#define BUMP_ON

				struct v2f 
				{
					float4 pos : SV_POSITION;
					half4 uv : TEXCOORD0;
					half2 uv2 : TEXCOORD1; 

					half3 ligthDir : TEXCOORD2;
					half3 viewDir : TEXCOORD3;
					 
					LIGHTING_COORDS(4,5)
				};

				#include "ColoredShadowsCG.cginc"
			
			ENDCG
		 }

	     Pass 
		 {
            Name "ForwardAdd"
            Tags {"LightMode"="ForwardAdd"}
            Blend One One
            
            
            Fog { Color (0,0,0,0) }
            CGPROGRAM
				#pragma vertex vert 
				#pragma fragment frag
				#define UNITY_PASS_FORWARDADD
				#include "UnityCG.cginc" 


				#include "ColoredShadowsAutoLight.cginc"
				#pragma multi_compile_fwdadd_fullshadows

				#pragma target 3.0
            
				#pragma shader_feature V_CSH_COLOR_LIGHTCOLOR V_CSH_COLOR_INVERTLIGHTCOLOR V_CSH_COLOR_CUSTOMCOLOR V_CSH_COLOR_GRADIENT
				#pragma shader_feature V_CSH_DISABLE_LIGHT_COLORES_OFF V_CSH_DISABLE_LIGHT_COLORES_ON
				#pragma shader_feature V_CSH_TEXTURE_NONE V_CSH_TEXTURE_RGB V_CSH_TEXTURE_RGBA
				#pragma shader_feature V_CSH_EMISSION_TYPE_NONE V_CSH_EMISSION_TYPE_MULTIPLY V_CSH_EMISSION_TYPE_EXPONENTAL

			
			            
				#define V_NEED_TANGENT

				#define NEED_CALC_TANGET_ROTATION
				#define NEED_CALC_LIGHTDIR_TS
				#define NEED_CALC_VIEWDIR_TS

				#define NEED_P_LIGHTDIR_TS
				#define NEED_P_VIEWDIR_TS

				#define SPECULAR_ON
				#define CUTOUT_ON
				#define BUMP_ON

				struct v2f 
				{
						float4 pos : SV_POSITION;
					half4 uv : TEXCOORD0;
					half2 uv2 : TEXCOORD1; 

					half3 ligthDir : TEXCOORD2;
					half3 viewDir : TEXCOORD3;
					 
					LIGHTING_COORDS(4,5)
				};

				#include "ColoredShadowsCG.cginc"									
			
			ENDCG
		}
	} 

	Fallback "Transparent/Cutout/VertexLit"

	CustomEditor "ColoredShadowsMaterialEditor"
}
