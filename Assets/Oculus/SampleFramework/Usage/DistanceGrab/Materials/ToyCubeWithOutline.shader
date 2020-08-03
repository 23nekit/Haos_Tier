// Custom shader to draw our toy cubes and balls with an outline around them.
Shader "Custom/ToyCubeOutline" 
{
	Properties 
	{
		[PerRendererData] _OutlineColor ("Outline Color", Color) = (0,0,0,1)
		_OutlineWidth ("Outline width", Range (.002, 0.03)) = .005
		[HideInInspector] _Mode ("__mode", Float) = 0.0
		[HideInInspector] _SrcBlend ("__src", Float) = 1.0
		[HideInInspector] _DstBlend ("__dst", Float) = 0.0
		[HideInInspector] _ZWrite ("__zw", Float) = 1.0
		_BaseMap("Texture", 2D) = "white" { }
		_BaseColor("Color", Color) = (1.000000,1.000000,1.000000,1.000000)
		 _Cutoff("AlphaCutout", Range(0.000000,1.000000)) = 0.500000
		[HideInInspector]  _Surface("__surface", Float) = 0.000000
		[HideInInspector]  _Blend("__blend", Float) = 0.000000
		[HideInInspector]  _AlphaClip("__clip", Float) = 0.000000
		[HideInInspector]  _SrcBlend("Src", Float) = 1.000000
		[HideInInspector]  _DstBlend("Dst", Float) = 0.000000
		[HideInInspector]  _ZWrite("ZWrite", Float) = 1.000000
		[HideInInspector]  _Cull("__cull", Float) = 2.000000
		[HideInInspector]  _QueueOffset("Queue offset", Float) = 0.000000
		[HideInInspector]  _MainTex("BaseMap", 2D) = "white" { }
		[HideInInspector]  _Color("Base Color", Color) = (0.500000,0.500000,0.500000,1.000000)
		[HideInInspector]  _SampleGI("SampleGI", Float) = 0.000000
	}
		SubShader{
		 LOD 100
		 Tags { "IGNOREPROJECTOR" = "true" "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" }
		 Pass {}
		  Name "Unlit"
		  Tags { "IGNOREPROJECTOR" = "true" "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" }
		  ZWrite[_ZWrite]
		  Cull[_Cull]
		  Blend[_SrcBlend][_DstBlend]
			//////////////////////////////////
			//                              //
			//      Compiled programs       //
			//                              //
			//////////////////////////////////
		  //////////////////////////////////////////////////////
		  Global Keywords : <none>
		  Local Keywords : <none>
		  --Hardware tier variant : Tier 1
		  --Vertex shader for "gles3" :
		  Set 2D Texture "_BaseMap" to slot 0

		  Constant Buffer "UnityPerMaterial" (44 bytes) on slot 0 {
			Vector4 _BaseMap_ST at 0
			Vector4 _BaseColor at 16
			Float _Cutoff at 32
			Float _Glossiness at 36
			Float _Metallic at 40
		  }
	
	CGINCLUDE
	#include "UnityCG.cginc"
	
	struct appdata 
	{
		float4 vertex : POSITION;
		float3 normal : NORMAL;
	};

	struct v2f 
	{
		float4 pos : SV_POSITION;
		fixed4 color : COLOR;
	};
	
	uniform float _OutlineWidth;
	uniform float4 _OutlineColor;
	uniform float4x4 _ObjectToWorldFixed;
	
	// Pushes the verts out a little from the object center.
	// Lets us give an outline to objects that all have normals facing away from the center.
	// If we can't assume that, we need to tweak the math of this shader.
	v2f vert(appdata v) 
	{
		v2f o;

		// MTF TODO 
		// 1. Fix batching so that it actually occurs.
		// 2. See if batching causes problems,
		// if it does fix this line by adding that component that sets it.
		//float4 objectCenterWorld = mul(_ObjectToWorldFixed, float4(0.0, 0.0, 0.0, 1.0));
		float4 objectCenterWorld = mul(unity_ObjectToWorld, float4(0.0, 0.0, 0.0, 1.0));
		float4 vertWorld = mul(unity_ObjectToWorld, v.vertex);

		float3 offsetDir = vertWorld.xyz - objectCenterWorld.xyz;
		offsetDir = normalize(offsetDir) * _OutlineWidth;

		o.pos = UnityWorldToClipPos(vertWorld+offsetDir);

		o.color = _OutlineColor;
		return o;
	}
	ENDCG

	SubShader 
	{
		Tags { "Queue" = "Transparent" }
		Pass 
		{
			Name "OUTLINE"
			// To allow the cube to render entirely on top of the outline.
			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			fixed4 frag(v2f i) : SV_Target
			{
				// Just draw the _OutlineColor from the vert pass above.
				return i.color;
			}
			ENDCG
		}
		// Standard forward render.
		UsePass "Standard/FORWARD"
	}
		Constant Buffer "$Globals" (64 bytes) {
				Matrix4x4 unity_MatrixVP at 0
			}
			Constant Buffer "UnityPerDraw" (384 bytes) on slot 1195985987 {
				Matrix4x4 unity_ObjectToWorld at 0
					Matrix4x4 unity_WorldToObject at 64
					Vector4 unity_LODFade at 128
					Vector4 unity_WorldTransformParams at 144
					Vector4 unity_LightData at 160
					Vector4 unity_LightIndices[2] at 176
					Vector4 unity_ProbesOcclusion at 208
					Vector4 unity_SpecCube0_HDR at 224
					Vector4 unity_LightmapST at 240
					Vector4 unity_DynamicLightmapST at 256
					Vector4 unity_SHAr at 272
					Vector4 unity_SHAg at 288
					Vector4 unity_SHAb at 304
					Vector4 unity_SHBr at 320
					Vector4 unity_SHBg at 336
					Vector4 unity_SHBb at 352
					Vector4 unity_SHC at 368
			}

			Shader Disassembly :
#ifdef VERTEX
			#version 300 es

#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
#if HLSLCC_ENABLE_UNIFORM_BUFFERS
#define UNITY_UNIFORM
#else
#define UNITY_UNIFORM uniform
#endif
#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
#if UNITY_SUPPORTS_UNIFORM_LOCATION
#define UNITY_LOCATION(x) layout(location = x)
#define UNITY_BINDING(x) layout(binding = x, std140)
#else
#define UNITY_LOCATION(x)
#define UNITY_BINDING(x) layout(std140)
#endif
				uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
#if HLSLCC_ENABLE_UNIFORM_BUFFERS
			UNITY_BINDING(1) uniform UnityPerDraw{
			#endif
				UNITY_UNIFORM vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
				UNITY_UNIFORM vec4 hlslcc_mtx4x4unity_WorldToObject[4];
				UNITY_UNIFORM vec4 unity_LODFade;
				UNITY_UNIFORM mediump vec4 unity_WorldTransformParams;
				UNITY_UNIFORM mediump vec4 unity_LightData;
				UNITY_UNIFORM mediump vec4 unity_LightIndices[2];
				UNITY_UNIFORM vec4 unity_ProbesOcclusion;
				UNITY_UNIFORM mediump vec4 unity_SpecCube0_HDR;
				UNITY_UNIFORM vec4 unity_LightmapST;
				UNITY_UNIFORM vec4 unity_DynamicLightmapST;
				UNITY_UNIFORM mediump vec4 unity_SHAr;
				UNITY_UNIFORM mediump vec4 unity_SHAg;
				UNITY_UNIFORM mediump vec4 unity_SHAb;
				UNITY_UNIFORM mediump vec4 unity_SHBr;
				UNITY_UNIFORM mediump vec4 unity_SHBg;
				UNITY_UNIFORM mediump vec4 unity_SHBb;
				UNITY_UNIFORM mediump vec4 unity_SHC;
			#if HLSLCC_ENABLE_UNIFORM_BUFFERS
			};
#endif
#if HLSLCC_ENABLE_UNIFORM_BUFFERS
			UNITY_BINDING(0) uniform UnityPerMaterial{
			#endif
				UNITY_UNIFORM vec4 _BaseMap_ST;
				UNITY_UNIFORM mediump vec4 _BaseColor;
				UNITY_UNIFORM mediump float _Cutoff;
				UNITY_UNIFORM mediump float _Glossiness;
				UNITY_UNIFORM mediump float _Metallic;
			#if HLSLCC_ENABLE_UNIFORM_BUFFERS
			};
#endif
			in highp vec4 in_POSITION0;
			in highp vec2 in_TEXCOORD0;
			out highp vec2 vs_TEXCOORD0;
			out highp float vs_TEXCOORD1;
			vec4 u_xlat0;
			vec4 u_xlat1;
			void main()
			{
				vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _BaseMap_ST.xy + _BaseMap_ST.zw;
				vs_TEXCOORD1 = 0.0;
				u_xlat0.xyz = in_POSITION0.yyy * hlslcc_mtx4x4unity_ObjectToWorld[1].xyz;
				u_xlat0.xyz = hlslcc_mtx4x4unity_ObjectToWorld[0].xyz * in_POSITION0.xxx + u_xlat0.xyz;
				u_xlat0.xyz = hlslcc_mtx4x4unity_ObjectToWorld[2].xyz * in_POSITION0.zzz + u_xlat0.xyz;
				u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_ObjectToWorld[3].xyz;
				u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
				u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
				u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
				gl_Position = u_xlat0 + hlslcc_mtx4x4unity_MatrixVP[3];
				return;
			}

#endif
#ifdef FRAGMENT
			#version 300 es

				precision highp float;
			precision highp int;
#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
#if HLSLCC_ENABLE_UNIFORM_BUFFERS
#define UNITY_UNIFORM
#else
#define UNITY_UNIFORM uniform
#endif
#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
#if UNITY_SUPPORTS_UNIFORM_LOCATION
#define UNITY_LOCATION(x) layout(location = x)
#define UNITY_BINDING(x) layout(binding = x, std140)
#else
#define UNITY_LOCATION(x)
#define UNITY_BINDING(x) layout(std140)
#endif
#if HLSLCC_ENABLE_UNIFORM_BUFFERS
			UNITY_BINDING(0) uniform UnityPerMaterial{
			#endif
				UNITY_UNIFORM vec4 _BaseMap_ST;
				UNITY_UNIFORM mediump vec4 _BaseColor;
				UNITY_UNIFORM mediump float _Cutoff;
				UNITY_UNIFORM mediump float _Glossiness;
				UNITY_UNIFORM mediump float _Metallic;
			#if HLSLCC_ENABLE_UNIFORM_BUFFERS
			};
#endif
			UNITY_LOCATION(0) uniform mediump sampler2D _BaseMap;
			in highp vec2 vs_TEXCOORD0;
			layout(location = 0) out mediump vec4 SV_Target0;
			mediump vec4 u_xlat16_0;
			void main()
			{
				u_xlat16_0 = texture(_BaseMap, vs_TEXCOORD0.xy);
				SV_Target0 = u_xlat16_0 * _BaseColor;
				return;
			}

#endif


			--Hardware tier variant : Tier 1
				--Fragment shader for "gles3" :
				Shader Disassembly :
			// All GLSL source is contained within the vertex program

			//////////////////////////////////////////////////////
			Global Keywords : INSTANCING_ON
				Local Keywords : <none>
				--Hardware tier variant : Tier 1
				--Vertex shader for "gles3" :
				Set 2D Texture "_BaseMap" to slot 0

				Constant Buffer "UnityPerMaterial" (44 bytes) on slot 0 {
				Vector4 _BaseMap_ST at 0
					Vector4 _BaseColor at 16
					Float _Cutoff at 32
					Float _Glossiness at 36
					Float _Metallic at 40
			}
			Constant Buffer "$Globals" (68 bytes) {
				Matrix4x4 unity_MatrixVP at 0
					ScalarInt unity_BaseInstanceID at 64
			}
			Constant Buffer "UnityInstancing_PerDraw0" (256 bytes) on slot 1411412847 {
				Struct unity_Builtins0Array[128][2] at 0 {
					Matrix4x4 unity_ObjectToWorldArray at 0
						Matrix4x4 unity_WorldToObjectArray at 64
				}
			}

			Shader Disassembly :
#ifdef VERTEX
			#version 300 es
#ifndef UNITY_RUNTIME_INSTANCING_ARRAY_SIZE
#define UNITY_RUNTIME_INSTANCING_ARRAY_SIZE 2
#endif

#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
#if HLSLCC_ENABLE_UNIFORM_BUFFERS
#define UNITY_UNIFORM
#else
#define UNITY_UNIFORM uniform
#endif
#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
#if UNITY_SUPPORTS_UNIFORM_LOCATION
#define UNITY_LOCATION(x) layout(location = x)
#define UNITY_BINDING(x) layout(binding = x, std140)
#else
#define UNITY_LOCATION(x)
#define UNITY_BINDING(x) layout(std140)
#endif
				uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
			uniform 	int unity_BaseInstanceID;
			struct unity_Builtins0Array_Type {
				vec4 hlslcc_mtx4x4unity_ObjectToWorldArray[4];
				vec4 hlslcc_mtx4x4unity_WorldToObjectArray[4];
			};
#if HLSLCC_ENABLE_UNIFORM_BUFFERS
			UNITY_BINDING(1) uniform UnityInstancing_PerDraw0{
			#endif
				UNITY_UNIFORM unity_Builtins0Array_Type unity_Builtins0Array[UNITY_RUNTIME_INSTANCING_ARRAY_SIZE];
			#if HLSLCC_ENABLE_UNIFORM_BUFFERS
			};
#endif
#if HLSLCC_ENABLE_UNIFORM_BUFFERS
			UNITY_BINDING(0) uniform UnityPerMaterial{
			#endif
				UNITY_UNIFORM vec4 _BaseMap_ST;
				UNITY_UNIFORM mediump vec4 _BaseColor;
				UNITY_UNIFORM mediump float _Cutoff;
				UNITY_UNIFORM mediump float _Glossiness;
				UNITY_UNIFORM mediump float _Metallic;
			#if HLSLCC_ENABLE_UNIFORM_BUFFERS
			};
#endif
			in highp vec4 in_POSITION0;
			in highp vec2 in_TEXCOORD0;
			out highp vec2 vs_TEXCOORD0;
			out highp float vs_TEXCOORD1;
			flat out highp uint vs_SV_InstanceID0;
			vec4 u_xlat0;
			int u_xlati0;
			vec4 u_xlat1;
			vec3 u_xlat2;
			void main()
			{
				vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _BaseMap_ST.xy + _BaseMap_ST.zw;
				vs_TEXCOORD1 = 0.0;
				u_xlati0 = gl_InstanceID + unity_BaseInstanceID;
				u_xlati0 = int(u_xlati0 << 3);
				u_xlat2.xyz = in_POSITION0.yyy * unity_Builtins0Array[u_xlati0 / 8].hlslcc_mtx4x4unity_ObjectToWorldArray[1].xyz;
				u_xlat2.xyz = unity_Builtins0Array[u_xlati0 / 8].hlslcc_mtx4x4unity_ObjectToWorldArray[0].xyz * in_POSITION0.xxx + u_xlat2.xyz;
				u_xlat2.xyz = unity_Builtins0Array[u_xlati0 / 8].hlslcc_mtx4x4unity_ObjectToWorldArray[2].xyz * in_POSITION0.zzz + u_xlat2.xyz;
				u_xlat0.xyz = u_xlat2.xyz + unity_Builtins0Array[u_xlati0 / 8].hlslcc_mtx4x4unity_ObjectToWorldArray[3].xyz;
				u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
				u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
				u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
				gl_Position = u_xlat0 + hlslcc_mtx4x4unity_MatrixVP[3];
				vs_SV_InstanceID0 = uint(gl_InstanceID);
				return;
			}

#endif
#ifdef FRAGMENT
			#version 300 es

				precision highp float;
			precision highp int;
#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
#if HLSLCC_ENABLE_UNIFORM_BUFFERS
#define UNITY_UNIFORM
#else
#define UNITY_UNIFORM uniform
#endif
#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
#if UNITY_SUPPORTS_UNIFORM_LOCATION
#define UNITY_LOCATION(x) layout(location = x)
#define UNITY_BINDING(x) layout(binding = x, std140)
#else
#define UNITY_LOCATION(x)
#define UNITY_BINDING(x) layout(std140)
#endif
#if HLSLCC_ENABLE_UNIFORM_BUFFERS
			UNITY_BINDING(0) uniform UnityPerMaterial{
			#endif
				UNITY_UNIFORM vec4 _BaseMap_ST;
				UNITY_UNIFORM mediump vec4 _BaseColor;
				UNITY_UNIFORM mediump float _Cutoff;
				UNITY_UNIFORM mediump float _Glossiness;
				UNITY_UNIFORM mediump float _Metallic;
			#if HLSLCC_ENABLE_UNIFORM_BUFFERS
			};
#endif
			UNITY_LOCATION(0) uniform mediump sampler2D _BaseMap;
			in highp vec2 vs_TEXCOORD0;
			layout(location = 0) out mediump vec4 SV_Target0;
			mediump vec4 u_xlat16_0;
			void main()
			{
				u_xlat16_0 = texture(_BaseMap, vs_TEXCOORD0.xy);
				SV_Target0 = u_xlat16_0 * _BaseColor;
				return;
			}

#endif


			--Hardware tier variant : Tier 1
				--Fragment shader for "gles3" :
				Shader Disassembly :
			// All GLSL source is contained within the vertex program

		}
			Pass{
			 Tags { "LIGHTMODE" = "DepthOnly" "IGNOREPROJECTOR" = "true" "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" }
			 Cull[_Cull]
			 Blend[_SrcBlend][_DstBlend]
			 ColorMask 0
			//////////////////////////////////
			//                              //
			//      Compiled programs       //
			//                              //
			//////////////////////////////////
		  //////////////////////////////////////////////////////
		  Global Keywords : <none>
		  Local Keywords : <none>
		  --Hardware tier variant : Tier 1
		  --Vertex shader for "gles3" :
		  Constant Buffer "$Globals" (64 bytes) {
			Matrix4x4 unity_MatrixVP at 0
		  }
		  Constant Buffer "UnityPerDraw" (384 bytes) on slot 1 {
			Matrix4x4 unity_ObjectToWorld at 0
			Matrix4x4 unity_WorldToObject at 64
			Vector4 unity_LODFade at 128
			Vector4 unity_WorldTransformParams at 144
			Vector4 unity_LightData at 160
			Vector4 unity_LightIndices[2] at 176
			Vector4 unity_ProbesOcclusion at 208
			Vector4 unity_SpecCube0_HDR at 224
			Vector4 unity_LightmapST at 240
			Vector4 unity_DynamicLightmapST at 256
			Vector4 unity_SHAr at 272
			Vector4 unity_SHAg at 288
			Vector4 unity_SHAb at 304
			Vector4 unity_SHBr at 320
			Vector4 unity_SHBg at 336
			Vector4 unity_SHBb at 352
			Vector4 unity_SHC at 368
		  }
		  Constant Buffer "UnityPerMaterial" (44 bytes) on slot 1195985987 {
			Vector4 _BaseMap_ST at 0
			Vector4 _BaseColor at 16
			Float _Cutoff at 32
			Float _Glossiness at 36
			Float _Metallic at 40
		  }

		  Shader Disassembly :
		  #ifdef VERTEX
		  #version 300 es

		  #define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
		  #if HLSLCC_ENABLE_UNIFORM_BUFFERS
		  #define UNITY_UNIFORM
		  #else
		  #define UNITY_UNIFORM uniform
		  #endif
		  #define UNITY_SUPPORTS_UNIFORM_LOCATION 1
		  #if UNITY_SUPPORTS_UNIFORM_LOCATION
		  #define UNITY_LOCATION(x) layout(location = x)
		  #define UNITY_BINDING(x) layout(binding = x, std140)
		  #else
		  #define UNITY_LOCATION(x)
		  #define UNITY_BINDING(x) layout(std140)
		  #endif
		  uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
		  #if HLSLCC_ENABLE_UNIFORM_BUFFERS
		  UNITY_BINDING(0) uniform UnityPerDraw {
		  #endif
			  UNITY_UNIFORM vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
			  UNITY_UNIFORM vec4 hlslcc_mtx4x4unity_WorldToObject[4];
			  UNITY_UNIFORM vec4 unity_LODFade;
			  UNITY_UNIFORM mediump vec4 unity_WorldTransformParams;
			  UNITY_UNIFORM mediump vec4 unity_LightData;
			  UNITY_UNIFORM mediump vec4 unity_LightIndices[2];
			  UNITY_UNIFORM vec4 unity_ProbesOcclusion;
			  UNITY_UNIFORM mediump vec4 unity_SpecCube0_HDR;
			  UNITY_UNIFORM vec4 unity_LightmapST;
			  UNITY_UNIFORM vec4 unity_DynamicLightmapST;
			  UNITY_UNIFORM mediump vec4 unity_SHAr;
			  UNITY_UNIFORM mediump vec4 unity_SHAg;
			  UNITY_UNIFORM mediump vec4 unity_SHAb;
			  UNITY_UNIFORM mediump vec4 unity_SHBr;
			  UNITY_UNIFORM mediump vec4 unity_SHBg;
			  UNITY_UNIFORM mediump vec4 unity_SHBb;
			  UNITY_UNIFORM mediump vec4 unity_SHC;
		  #if HLSLCC_ENABLE_UNIFORM_BUFFERS
		  };
		  #endif
		  #if HLSLCC_ENABLE_UNIFORM_BUFFERS
		  UNITY_BINDING(1) uniform UnityPerMaterial {
		  #endif
			  UNITY_UNIFORM vec4 _BaseMap_ST;
			  UNITY_UNIFORM mediump vec4 _BaseColor;
			  UNITY_UNIFORM mediump float _Cutoff;
			  UNITY_UNIFORM mediump float _Glossiness;
			  UNITY_UNIFORM mediump float _Metallic;
		  #if HLSLCC_ENABLE_UNIFORM_BUFFERS
		  };
		  #endif
		  in highp vec4 in_POSITION0;
		  in highp vec2 in_TEXCOORD0;
		  out highp vec2 vs_TEXCOORD0;
		  vec4 u_xlat0;
		  vec4 u_xlat1;
		  void main()
		  {
			  vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _BaseMap_ST.xy + _BaseMap_ST.zw;
			  u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
			  u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
			  u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
			  u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
			  u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
			  u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
			  u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
			  gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
			  return;
		  }

		  #endif
		  #ifdef FRAGMENT
		  #version 300 es

		  precision highp float;
		  precision highp int;
		  layout(location = 0) out mediump vec4 SV_TARGET0;
		  void main()
		  {
			  SV_TARGET0 = vec4(0.0, 0.0, 0.0, 0.0);
			  return;
		  }

		  #endif


		  --Hardware tier variant : Tier 1
		  --Fragment shader for "gles3" :
		  Shader Disassembly :
		  // All GLSL source is contained within the vertex program

		  //////////////////////////////////////////////////////
		  Global Keywords : INSTANCING_ON
		  Local Keywords : <none>
		  --Hardware tier variant : Tier 1
		  --Vertex shader for "gles3" :
		  Constant Buffer "$Globals" (68 bytes) {
			Matrix4x4 unity_MatrixVP at 0
			ScalarInt unity_BaseInstanceID at 64
		  }
		  Constant Buffer "UnityInstancing_PerDraw0" (256 bytes) on slot 1 {
			Struct unity_Builtins0Array[128][2] at 0 {
			  Matrix4x4 unity_ObjectToWorldArray at 0
			  Matrix4x4 unity_WorldToObjectArray at 64
			}
		  }
		  Constant Buffer "UnityPerMaterial" (44 bytes) on slot 942878464 {
			Vector4 _BaseMap_ST at 0
			Vector4 _BaseColor at 16
			Float _Cutoff at 32
			Float _Glossiness at 36
			Float _Metallic at 40
		  }

		  Shader Disassembly :
		  #ifdef VERTEX
		  #version 300 es
		  #ifndef UNITY_RUNTIME_INSTANCING_ARRAY_SIZE
			  #define UNITY_RUNTIME_INSTANCING_ARRAY_SIZE 2
		  #endif

		  #define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
		  #if HLSLCC_ENABLE_UNIFORM_BUFFERS
		  #define UNITY_UNIFORM
		  #else
		  #define UNITY_UNIFORM uniform
		  #endif
		  #define UNITY_SUPPORTS_UNIFORM_LOCATION 1
		  #if UNITY_SUPPORTS_UNIFORM_LOCATION
		  #define UNITY_LOCATION(x) layout(location = x)
		  #define UNITY_BINDING(x) layout(binding = x, std140)
		  #else
		  #define UNITY_LOCATION(x)
		  #define UNITY_BINDING(x) layout(std140)
		  #endif
		  uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
		  uniform 	int unity_BaseInstanceID;
		  struct unity_Builtins0Array_Type {
			  vec4 hlslcc_mtx4x4unity_ObjectToWorldArray[4];
			  vec4 hlslcc_mtx4x4unity_WorldToObjectArray[4];
		  };
		  #if HLSLCC_ENABLE_UNIFORM_BUFFERS
		  UNITY_BINDING(0) uniform UnityInstancing_PerDraw0 {
		  #endif
			  UNITY_UNIFORM unity_Builtins0Array_Type unity_Builtins0Array[UNITY_RUNTIME_INSTANCING_ARRAY_SIZE];
		  #if HLSLCC_ENABLE_UNIFORM_BUFFERS
		  };
		  #endif
		  #if HLSLCC_ENABLE_UNIFORM_BUFFERS
		  UNITY_BINDING(1) uniform UnityPerMaterial {
		  #endif
			  UNITY_UNIFORM vec4 _BaseMap_ST;
			  UNITY_UNIFORM mediump vec4 _BaseColor;
			  UNITY_UNIFORM mediump float _Cutoff;
			  UNITY_UNIFORM mediump float _Glossiness;
			  UNITY_UNIFORM mediump float _Metallic;
		  #if HLSLCC_ENABLE_UNIFORM_BUFFERS
		  };
		  #endif
		  in highp vec4 in_POSITION0;
		  in highp vec2 in_TEXCOORD0;
		  out highp vec2 vs_TEXCOORD0;
		  flat out highp uint vs_SV_InstanceID0;
		  vec4 u_xlat0;
		  int u_xlati0;
		  vec4 u_xlat1;
		  void main()
		  {
			  vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _BaseMap_ST.xy + _BaseMap_ST.zw;
			  u_xlati0 = gl_InstanceID + unity_BaseInstanceID;
			  u_xlati0 = int(u_xlati0 << 3);
			  u_xlat1 = in_POSITION0.yyyy * unity_Builtins0Array[u_xlati0 / 8].hlslcc_mtx4x4unity_ObjectToWorldArray[1];
			  u_xlat1 = unity_Builtins0Array[u_xlati0 / 8].hlslcc_mtx4x4unity_ObjectToWorldArray[0] * in_POSITION0.xxxx + u_xlat1;
			  u_xlat1 = unity_Builtins0Array[u_xlati0 / 8].hlslcc_mtx4x4unity_ObjectToWorldArray[2] * in_POSITION0.zzzz + u_xlat1;
			  u_xlat0 = u_xlat1 + unity_Builtins0Array[u_xlati0 / 8].hlslcc_mtx4x4unity_ObjectToWorldArray[3];
			  u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
			  u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
			  u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
			  gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
			  vs_SV_InstanceID0 = uint(0u);
			  return;
		  }

		  #endif
		  #ifdef FRAGMENT
		  #version 300 es

		  precision highp float;
		  precision highp int;
		  layout(location = 0) out mediump vec4 SV_TARGET0;
		  void main()
		  {
			  SV_TARGET0 = vec4(0.0, 0.0, 0.0, 0.0);
			  return;
		  }

		  #endif


		  --Hardware tier variant : Tier 1
		  --Fragment shader for "gles3" :
		  Shader Disassembly :
		  // All GLSL source is contained within the vertex program

		}
		}
			CustomEditor "UnityEditor.Rendering.Universal.ShaderGUI.UnlitShader"
			Fallback "Hidden/Universal Render Pipeline/FallbackError"
}
	Fallback Off
}