/*
 * Copyright (c) 2018 Confetti Interactive Inc.
 * 
 * This file is part of The-Forge
 * (see https://github.com/ConfettiFX/The-Forge).
 * 
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 * 
 *   http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
*/

#define _USE_MATH_DEFINES

// Unit Test for testing Compute Shaders and Tessellation
// using Responsive Real-Time Grass Rendering for General 3D Scenes

//tiny stl
#include "../../../../Common_3/ThirdParty/OpenSource/TinySTL/vector.h"
#include "../../../../Common_3/ThirdParty/OpenSource/TinySTL/string.h"

//Interfaces
#include "../../../../Common_3/OS/Interfaces/ICameraController.h"
#include "../../../../Common_3/OS/Interfaces/ILogManager.h"
#include "../../../../Common_3/OS/Interfaces/IFileSystem.h"
#include "../../../../Common_3/OS/Interfaces/ITimeManager.h"
#include "../../../../Common_3/OS/Interfaces/IApp.h"
#include "../../../../Common_3/Renderer/IRenderer.h"
#include "../../../../Common_3/Renderer/GpuProfiler.h"
#include "../../../../Common_3/Renderer/ResourceLoader.h"

//Math
#include "../../../../Common_3/OS/Math/MathTypes.h"

//ui
#include "../../../../Middleware_3/UI/AppUI.h"
#include "../../../../Common_3/OS/Core/DebugRenderer.h"

#include "../../../../Common_3/OS/Interfaces/IMemoryManager.h"

/// Camera Controller
#define GUI_CAMERACONTROLLER 1
#define FPS_CAMERACONTROLLER 2

#define USE_CAMERACONTROLLER FPS_CAMERACONTROLLER

ICameraController* pCameraController = NULL;

// Grass Parameters
static const unsigned int NUM_BLADES = 1 << 16;
#define MIN_HEIGHT 1.3f
#define MAX_HEIGHT 3.5f
#define MIN_WIDTH 0.1f
#define MAX_WIDTH 0.14f
#define MIN_BEND 7.0f
#define MAX_BEND 13.0f
#define PLANE_SIZE 100.0f

enum
{
	WIND_MODE_STRAIGHT = 0,
	WIND_MODE_RADIAL = 1,
};

static int gFillMode = FILL_MODE_SOLID;
static int gWindMode = WIND_MODE_STRAIGHT;
static int gMaxTessellationLevel = 5;

static float gWindSpeed = 25.0f;
static float gWindWidth = 6.0f;
static float gWindStrength = 15.0f;

struct GrassUniformBlock
{
	mat4 mWorld;
	mat4 mView;
	mat4 mInvView;
	mat4 mProj;
	mat4 mViewProj;

	float mDeltaTime;
	float mTotalTime;
	
	int mWindMode;
	int mMaxTessellationLevel;

 	float mWindSpeed;
 	float mWindWidth;
 	float mWindStrength;
};

struct Blade
{
	// Position and direction
	vec4 mV0;
	// Bezier point and height
	vec4 mV1;
	// Physical model guide and width
	vec4 mV2;
	// Up vector and stiffness coefficient
	vec4 mUp;
};

struct BladeDrawIndirect
{
	uint32_t mVertexCount;
	uint32_t mInstanceCount;
	uint32_t mFirstVertex;
	uint32_t mFirstInstance;
};

#ifdef METAL
struct PatchTess
{
    half edges[4];
    half inside[2];
};

struct HullOut
{
    float4 position;
    float4 tese_v1;
    float4 tese_v2;
    float4 tese_up;
    float4 tese_widthDir;
};
#endif

tinystl::vector<Blade> gBlades;

FileSystem gFileSystem;
ThreadPool gThreadSystem;
LogManager gLogManager;
Timer gAccumTimer;
HiresTimer gTimer;

UIApp gAppUI = {};
GuiComponent* pGui;

#if defined(DIRECT3D12)
#define RESOURCE_DIR "PCDX12"
#elif defined(VULKAN)
	#if defined(_WIN32)
	#define RESOURCE_DIR "PCVulkan"
	#elif defined(LINUX)
	#define RESOURCE_DIR "LINUXVulkan"
	#endif
#elif defined(METAL)
#define RESOURCE_DIR "OSXMetal"
#else
#error PLATFORM NOT SUPPORTED
#endif

#ifdef _DURANGO
// Durango load assets from 'Layout\Image\Loose'
const char* pszRoots[] =
{
	"Shaders/Binary/",	// FSR_BinShaders
	"Shaders/",		// FSR_SrcShaders
	"Shaders/Binary/",			// FSR_BinShaders_Common
	"Shaders/",					// FSR_SrcShaders_Common
	"Textures/",						// FSR_Textures
	"Meshes/",						// FSR_Meshes
	"Fonts/",						// FSR_Builtin_Fonts
	"",															// FSR_OtherFiles
};
#else
//Example for using roots or will cause linker error with the extern root in FileSystem.cpp
const char* pszRoots[] =
{
	"../../../src/07_Tessellation/" RESOURCE_DIR "/Binary/",	// FSR_BinShaders
	"../../../src/07_Tessellation/" RESOURCE_DIR "/",			// FSR_SrcShaders
	"",															// FSR_BinShaders_Common
	"",															// FSR_SrcShaders_Common
	"../../../UnitTestResources/Textures/",						// FSR_Textures
	"../../../UnitTestResources/Meshes/",						// FSR_Meshes
	"../../../UnitTestResources/Fonts/",						// FSR_Builtin_Fonts
	"",															// FSR_OtherFiles
};
#endif

const uint32_t	 gImageCount = 3;

Renderer*    pRenderer = NULL;

Queue*           pGraphicsQueue = NULL;
CmdPool*         pCmdPool = NULL;
Cmd**            ppCmds = NULL;

CmdPool*         pUICmdPool = NULL;
Cmd**            ppUICmds = NULL;

SwapChain*       pSwapChain = NULL;
RenderTarget*    pDepthBuffer = NULL;
Fence*           pRenderCompleteFences[gImageCount] = { NULL };
Semaphore*       pImageAcquiredSemaphore = NULL;
Semaphore*       pRenderCompleteSemaphores[gImageCount] = { NULL };

Sampler*         pSampler = NULL;
DepthState*      pDepth = NULL;
RasterizerState* pRast = NULL;
RasterizerState* pWireframeRast = NULL;

RenderTarget*	 PGrassRenderTarget = NULL;

Buffer*          pGrassUniformBuffer = NULL;
Buffer*          pBladeStorageBuffer = NULL;
Buffer*          pCulledBladeStorageBuffer = NULL;

Buffer*          pBladeNumBuffer = NULL;

#ifdef METAL
Buffer*         pTessFactorsBuffer = NULL;
Buffer*         pHullOutputBuffer = NULL;
#endif

CommandSignature* pIndirectCommandSignature = NULL;

Shader*          pGrassShader = NULL;
Pipeline*        pGrassPipeline = NULL;
#ifdef METAL
Shader*          pGrassVertexHullShader = NULL;
Pipeline*        pGrassVertexHullPipeline = NULL;
#endif

Pipeline*        pGrassPipelineForWireframe = NULL;

RootSignature*   pGrassRootSignature = NULL;
#ifdef METAL
RootSignature*   pGrassVertexHullRootSignature = NULL;
#endif

#ifdef TARGET_IOS
Texture*         pVirtualJoystickTex = NULL;
#endif

Shader*          pComputeShader = NULL;
Pipeline*        pComputePipeline = NULL;
RootSignature*   pComputeRootSignature = NULL;

uint32_t         gFrameIndex = 0;

GrassUniformBlock gGrassUniformData;

GpuProfiler*	pGpuProfiler = NULL;

unsigned gStartTime = 0;

struct ObjectProperty
{
	float mRotX = 0, mRotY = 0;
} gObjSettings;

DebugTextDrawDesc gFrameTimeDraw = DebugTextDrawDesc(0, 0xff00ffff, 18);

class Tessellation : public IApp
{
public:
	bool Init()
	{
		HiresTimer startTime;

		initNoise();

		initBlades();

		BladeDrawIndirect indirectDraw;
		indirectDraw.mVertexCount = NUM_BLADES;
		indirectDraw.mInstanceCount = 1;
		indirectDraw.mFirstVertex = 0;
		indirectDraw.mFirstInstance = 0;

		// renderer for swapchains
		RendererDesc settings = { 0 };
		initRenderer(GetName(), &settings, &pRenderer);

		QueueDesc queueDesc = {};
		queueDesc.mType = CMD_POOL_DIRECT;
		addQueue(pRenderer, &queueDesc, &pGraphicsQueue);
		addCmdPool(pRenderer, pGraphicsQueue, false, &pCmdPool);
		addCmd_n(pCmdPool, false, gImageCount, &ppCmds);

		addCmdPool(pRenderer, pGraphicsQueue, false, &pUICmdPool);
		addCmd_n(pUICmdPool, false, gImageCount, &ppUICmds);

		for (uint32_t i = 0; i < gImageCount; ++i)
		{
			addFence(pRenderer, &pRenderCompleteFences[i]);
			addSemaphore(pRenderer, &pRenderCompleteSemaphores[i]);
		}
		addSemaphore(pRenderer, &pImageAcquiredSemaphore);

		initResourceLoaderInterface(pRenderer, DEFAULT_MEMORY_BUDGET);
		initDebugRendererInterface(pRenderer, FileSystem::FixPath("TitilliumText/TitilliumText-Bold.ttf", FSR_Builtin_Fonts));

#ifndef METAL
		addGpuProfiler(pRenderer, pGraphicsQueue, &pGpuProfiler);
#endif

#ifdef TARGET_IOS
        // Add virtual joystick texture.
        TextureLoadDesc textureDesc = {};
        textureDesc.mRoot = FSRoot::FSR_Absolute;
        textureDesc.mUseMipmaps = false;
        textureDesc.pFilename = "circlepad.png";
        textureDesc.ppTexture = &pVirtualJoystickTex;
        addResource(&textureDesc, true);
#endif

#if defined(DIRECT3D12) || defined(VULKAN)
		ShaderLoadDesc grassShader = {};
		grassShader.mStages[0] = { "grass.vert", NULL, 0, FSR_SrcShaders };
		grassShader.mStages[1] = { "grass.frag", NULL, 0, FSR_SrcShaders };
		grassShader.mStages[2] = { "grass.tesc", NULL, 0, FSR_SrcShaders };
		grassShader.mStages[3] = { "grass.tese", NULL, 0, FSR_SrcShaders };
#else
        ShaderLoadDesc grassVertexHullShader = {};
        grassVertexHullShader.mStages[0] = { "grass_verthull.comp", NULL, 0, FSR_SrcShaders };
        
        ShaderLoadDesc grassShader = {};
        grassShader.mStages[0] = { "grass.domain.vert", NULL, 0, FSR_SrcShaders };
        grassShader.mStages[1] = { "grass.frag", NULL, 0, FSR_SrcShaders };
#endif
		ShaderLoadDesc computeShader = {};
		computeShader.mStages[0] = { "compute.comp", NULL, 0, FSR_SrcShaders };

		addShader(pRenderer, &grassShader, &pGrassShader);
		addShader(pRenderer, &computeShader, &pComputeShader);

		RootSignatureDesc grassRootDesc = { &pGrassShader, 1 };
		RootSignatureDesc computeRootDesc = { &pComputeShader, 1 };
		addRootSignature(pRenderer, &grassRootDesc, &pGrassRootSignature);
		addRootSignature(pRenderer, &computeRootDesc, &pComputeRootSignature);
#ifdef METAL
		addShader(pRenderer, &grassVertexHullShader, &pGrassVertexHullShader);

		RootSignatureDesc vertexHullRootDesc = { &pGrassVertexHullShader, 1 };
		addRootSignature(pRenderer, &vertexHullRootDesc, &pGrassVertexHullRootSignature);
#endif

		ComputePipelineDesc computePipelineDesc = { 0 };
		computePipelineDesc.pRootSignature = pComputeRootSignature;
		computePipelineDesc.pShaderProgram = pComputeShader;
		addComputePipeline(pRenderer, &computePipelineDesc, &pComputePipeline);

		DepthStateDesc depthStateDesc = {};
		depthStateDesc.mDepthTest = true;
		depthStateDesc.mDepthWrite = true;
		depthStateDesc.mDepthFunc = CMP_LEQUAL;
		addDepthState(pRenderer, &depthStateDesc, &pDepth);

		RasterizerStateDesc rasterizerStateDesc = {};
		rasterizerStateDesc.mCullMode = CULL_MODE_NONE;
		addRasterizerState(pRenderer, &rasterizerStateDesc, &pRast);

		SamplerDesc samplerDesc = {
			FILTER_NEAREST, FILTER_NEAREST, MIPMAP_MODE_NEAREST,
			ADDRESS_MODE_CLAMP_TO_EDGE, ADDRESS_MODE_CLAMP_TO_EDGE, ADDRESS_MODE_CLAMP_TO_EDGE
		};
		addSampler(pRenderer, &samplerDesc, &pSampler);

		RasterizerStateDesc rasterizerStateWireframeDesc = {};
		rasterizerStateWireframeDesc.mCullMode = CULL_MODE_NONE;
		rasterizerStateWireframeDesc.mFillMode = FILL_MODE_WIREFRAME;
		addRasterizerState(pRenderer, &rasterizerStateWireframeDesc, &pWireframeRast);

#ifdef METAL
		ComputePipelineDesc grassVertexHullPipelineDesc = { 0 };
		grassVertexHullPipelineDesc.pRootSignature = pGrassVertexHullRootSignature;
		grassVertexHullPipelineDesc.pShaderProgram = pGrassVertexHullShader;
		addComputePipeline(pRenderer, &grassVertexHullPipelineDesc, &pGrassVertexHullPipeline);
#endif

		BufferLoadDesc ubGrassDesc = {};
		ubGrassDesc.mDesc.mUsage = BUFFER_USAGE_UNIFORM;
		ubGrassDesc.mDesc.mMemoryUsage = RESOURCE_MEMORY_USAGE_CPU_TO_GPU;
		ubGrassDesc.mDesc.mSize = sizeof(GrassUniformBlock);
		ubGrassDesc.mDesc.mFlags = BUFFER_CREATION_FLAG_PERSISTENT_MAP_BIT;
		ubGrassDesc.pData = NULL;
		ubGrassDesc.ppBuffer = &pGrassUniformBuffer;
		addResource(&ubGrassDesc);


		BufferLoadDesc sbBladeDesc = {};
		sbBladeDesc.mDesc.mUsage = BUFFER_USAGE_STORAGE_UAV;
		sbBladeDesc.mDesc.mFirstElement = 0;
		sbBladeDesc.mDesc.mElementCount = NUM_BLADES;
		sbBladeDesc.mDesc.mVertexStride = sizeof(Blade);
		sbBladeDesc.mDesc.mStructStride = sizeof(Blade);
		sbBladeDesc.mDesc.mMemoryUsage = RESOURCE_MEMORY_USAGE_GPU_ONLY;
		sbBladeDesc.mDesc.mSize = NUM_BLADES * sizeof(Blade);

		sbBladeDesc.pData = gBlades.data();
		sbBladeDesc.ppBuffer = &pBladeStorageBuffer;
		addResource(&sbBladeDesc);


		BufferLoadDesc sbCulledBladeDesc = {};
		sbCulledBladeDesc.mDesc.mUsage = BUFFER_USAGE_STORAGE_UAV | BUFFER_USAGE_VERTEX;
		sbCulledBladeDesc.mDesc.mFirstElement = 0;
		sbCulledBladeDesc.mDesc.mElementCount = NUM_BLADES;
		sbCulledBladeDesc.mDesc.mVertexStride = sizeof(Blade);
		sbCulledBladeDesc.mDesc.mStructStride = sizeof(Blade);
		sbCulledBladeDesc.mDesc.mMemoryUsage = RESOURCE_MEMORY_USAGE_GPU_ONLY;
		sbCulledBladeDesc.mDesc.mSize = NUM_BLADES * sizeof(Blade);

		sbCulledBladeDesc.pData = gBlades.data();
		sbCulledBladeDesc.ppBuffer = &pCulledBladeStorageBuffer;
		addResource(&sbCulledBladeDesc);


		BufferLoadDesc sbBladeNumDesc = {};
		sbBladeNumDesc.mDesc.mUsage = BUFFER_USAGE_STORAGE_UAV | BUFFER_USAGE_INDIRECT;
		sbBladeNumDesc.mDesc.mFirstElement = 0;
		sbBladeNumDesc.mDesc.mElementCount = 1;
		sbBladeNumDesc.mDesc.mStructStride = sizeof(BladeDrawIndirect);
#ifndef TARGET_IOS
		sbBladeNumDesc.mDesc.mMemoryUsage = RESOURCE_MEMORY_USAGE_GPU_ONLY;
#else
		sbBladeNumDesc.mDesc.mMemoryUsage = RESOURCE_MEMORY_USAGE_CPU_TO_GPU; // On iOS, we need to map this buffer to CPU memory to support tessellated execute-indirect.
#endif
		sbBladeNumDesc.mDesc.mSize = sizeof(BladeDrawIndirect);

		sbBladeNumDesc.pData = &indirectDraw;
		sbBladeNumDesc.ppBuffer = &pBladeNumBuffer;
		addResource(&sbBladeNumDesc);

#ifdef METAL
		BufferLoadDesc tessFactorBufferDesc = {};
		tessFactorBufferDesc.mDesc.mUsage = BUFFER_USAGE_STORAGE_UAV;
		tessFactorBufferDesc.mDesc.mFirstElement = 0;
		tessFactorBufferDesc.mDesc.mElementCount = NUM_BLADES;
		tessFactorBufferDesc.mDesc.mStructStride = sizeof(PatchTess);
		tessFactorBufferDesc.mDesc.mMemoryUsage = RESOURCE_MEMORY_USAGE_GPU_ONLY;
		tessFactorBufferDesc.mDesc.mSize = NUM_BLADES * sizeof(PatchTess);
		tessFactorBufferDesc.pData = NULL;
		tessFactorBufferDesc.ppBuffer = &pTessFactorsBuffer;
		addResource(&tessFactorBufferDesc);

		BufferLoadDesc hullOutputBufferDesc = {};
		hullOutputBufferDesc.mDesc.mUsage = BUFFER_USAGE_STORAGE_UAV;
		hullOutputBufferDesc.mDesc.mFirstElement = 0;
		hullOutputBufferDesc.mDesc.mElementCount = NUM_BLADES;
		hullOutputBufferDesc.mDesc.mStructStride = sizeof(HullOut);
		hullOutputBufferDesc.mDesc.mMemoryUsage = RESOURCE_MEMORY_USAGE_GPU_ONLY;
		hullOutputBufferDesc.mDesc.mSize = NUM_BLADES * sizeof(HullOut);
		hullOutputBufferDesc.pData = NULL;
		hullOutputBufferDesc.ppBuffer = &pHullOutputBuffer;
		addResource(&hullOutputBufferDesc);
#endif

		tinystl::vector<IndirectArgumentDescriptor> indirectArgDescs(1);
		indirectArgDescs[0] = {};
		indirectArgDescs[0].mType = INDIRECT_DRAW; // Indirect Index Draw Arguments
		CommandSignatureDesc cmdDesc = {};
		cmdDesc.mIndirectArgCount = (uint32_t)indirectArgDescs.size();
		cmdDesc.pArgDescs = indirectArgDescs.data();
		cmdDesc.pCmdPool = pCmdPool;
		cmdDesc.pRootSignature = pGrassRootSignature;
		addIndirectCommandSignature(pRenderer, &cmdDesc, &pIndirectCommandSignature);

		gGrassUniformData.mTotalTime = 0.0f;
		gGrassUniformData.mMaxTessellationLevel = gMaxTessellationLevel;
		gGrassUniformData.mWindMode = gWindMode;

#if !USE_CAMERACONTROLLER
		// initial camera properties
		gCameraProp.mCameraPitch = -0.785398163f;
		gCameraProp.mCamearYaw = 1.5f*0.785398163f;
		gCameraProp.mCameraPosition = Point3(48.0f, 48.0f, 20.0f);
		gCameraProp.mCameraForward = vec3(0.0f, 0.0f, -1.0f);
		gCameraProp.mCameraUp = vec3(0.0f, 1.0f, 0.0f);

		vec3 camRot(gCameraProp.mCameraPitch, gCameraProp.mCamearYaw, 0.0f);
		mat3 trans = mat3::rotationZYX(camRot);
		gCameraProp.mCameraDirection = trans* gCameraProp.mCameraForward;
		gCameraProp.mCameraRight = cross(gCameraProp.mCameraDirection, gCameraProp.mCameraUp);
		normalize(gCameraProp.mCameraRight);
#endif

		GuiDesc guiDesc = {};
		guiDesc.mStartSize = vec2(300.0f, 250.0f);
		guiDesc.mStartPosition = vec2(0.0f, guiDesc.mStartSize.getY());

		if (!gAppUI.Init(pRenderer))
			return false;

		gAppUI.LoadFont(FileSystem::FixPath("TitilliumText/TitilliumText-Bold.ttf", FSR_Builtin_Fonts));
		pGui = gAppUI.AddGuiComponent("Tessellation Properties", &guiDesc);

		static const char* enumNames[] = {
			"SOLID",
			"WIREFRAME",
			NULL
		};
		static const int enumValues[] = {
			FILL_MODE_SOLID,
			FILL_MODE_WIREFRAME,
			0
		};

		static const char* enumWindNames[] = {
			"STRAIGHT",
			"RADIAL",
			NULL
		};
		static const int enumWindValues[] = {
			WIND_MODE_STRAIGHT,
			WIND_MODE_RADIAL,
			0
		};

		pGui->AddProperty(UIProperty("Fill Mode : ", gFillMode, enumNames, enumValues));
		pGui->AddProperty(UIProperty("Wind Mode : ", gWindMode, enumWindNames, enumWindValues));

		pGui->AddProperty(UIProperty("Wind Speed : ", gWindSpeed, 1.0f, 100.0f));
		pGui->AddProperty(UIProperty("Wave Width : ", gWindWidth, 1.0f, 20.0f));
		pGui->AddProperty(UIProperty("Wind Strength : ", gWindStrength, 1.0f, 100.0f));

		pGui->AddProperty(UIProperty("Max Tessellation Level : ", gMaxTessellationLevel, 1, 10));

#if USE_CAMERACONTROLLER
		CameraMotionParameters cmp{ 100.0f, 150.0f, 300.0f };
		vec3 camPos{ 48.0f, 48.0f, 20.0f };
		vec3 lookAt{ 0 };

#if USE_CAMERACONTROLLER == FPS_CAMERACONTROLLER
		pCameraController = createFpsCameraController(camPos, lookAt);
		requestMouseCapture(true);
#elif USE_CAMERACONTROLLER == GUI_CAMERACONTROLLER
		pCameraController = createGuiCameraController(camPos, lookAt);
#endif

		pCameraController->setMotionParameters(cmp);

#if !defined(_DURANGO)
		registerRawMouseMoveEvent(cameraMouseMove);
		registerMouseButtonEvent(cameraMouseButton);
		registerMouseWheelEvent(cameraMouseWheel);
#endif

#ifdef TARGET_IOS
        registerTouchEvent(cameraTouch);
        registerTouchMoveEvent(cameraTouchMove);
#endif
#endif

		LOGINFOF("Load time %f ms", startTime.GetUSec(true) / 1000.0f);
		return true;
	}

	void Exit()
	{
		waitForFences(pGraphicsQueue, 1, &pRenderCompleteFences[gFrameIndex], true);

		destroyCameraController(pCameraController);
		removeDebugRendererInterface();

		gAppUI.Exit();

		removeResource(pBladeStorageBuffer);
		removeResource(pCulledBladeStorageBuffer);

		removeResource(pBladeNumBuffer);

#ifdef METAL
		removeResource(pTessFactorsBuffer);
		removeResource(pHullOutputBuffer);
#endif
        
#ifdef TARGET_IOS
        removeResource(pVirtualJoystickTex);
#endif

		removeIndirectCommandSignature(pRenderer, pIndirectCommandSignature);

		for (uint32_t i = 0; i < gImageCount; ++i)
		{
			removeFence(pRenderer, pRenderCompleteFences[i]);
			removeSemaphore(pRenderer, pRenderCompleteSemaphores[i]);
		}

		removeSemaphore(pRenderer, pImageAcquiredSemaphore);

		removeCmd_n(pCmdPool, gImageCount, ppCmds);
		removeCmdPool(pRenderer, pCmdPool);

		removeCmd_n(pUICmdPool, gImageCount, ppUICmds);
		removeCmdPool(pRenderer, pUICmdPool);

		removeSampler(pRenderer, pSampler);
		removeDepthState(pDepth);

		removeRasterizerState(pRast);
		removeRasterizerState(pWireframeRast);
		removeResource(pGrassUniformBuffer);

		removeShader(pRenderer, pGrassShader);
#ifdef METAL
		removeShader(pRenderer, pGrassVertexHullShader);
#endif
		removeShader(pRenderer, pComputeShader);

#ifdef METAL
		removePipeline(pRenderer, pGrassVertexHullPipeline);
#endif
		removePipeline(pRenderer, pComputePipeline);

		removeRootSignature(pRenderer, pGrassRootSignature);
#ifdef METAL
		removeRootSignature(pRenderer, pGrassVertexHullRootSignature);
#endif
		removeRootSignature(pRenderer, pComputeRootSignature);

#ifndef METAL
		removeGpuProfiler(pRenderer, pGpuProfiler);
#endif
		removeResourceLoaderInterface(pRenderer);
		removeQueue(pGraphicsQueue);
		removeRenderer(pRenderer);
	}

	bool Load()
	{
		if (!addSwapChain())
			return false;

		if (!addDepthBuffer())
			return false;

		if (!gAppUI.Load(pSwapChain->ppSwapchainRenderTargets))
			return false;

		VertexLayout vertexLayout = {};
#ifndef METAL
		vertexLayout.mAttribCount = 4;
#else
		vertexLayout.mAttribCount = 5;
#endif

		//v0 -- position (Metal)
		vertexLayout.mAttribs[0].mSemantic = SEMANTIC_TEXCOORD0;
		vertexLayout.mAttribs[0].mFormat = ImageFormat::RGBA32F;
		vertexLayout.mAttribs[0].mBinding = 0;
		vertexLayout.mAttribs[0].mLocation = 0;
		vertexLayout.mAttribs[0].mOffset = 0;

		//v1
		vertexLayout.mAttribs[1].mSemantic = SEMANTIC_TEXCOORD1;
		vertexLayout.mAttribs[1].mFormat = ImageFormat::RGBA32F;
		vertexLayout.mAttribs[1].mBinding = 0;
		vertexLayout.mAttribs[1].mLocation = 1;
		vertexLayout.mAttribs[1].mOffset = 4 * sizeof(float);

		//v2
		vertexLayout.mAttribs[2].mSemantic = SEMANTIC_TEXCOORD2;
		vertexLayout.mAttribs[2].mFormat = ImageFormat::RGBA32F;
		vertexLayout.mAttribs[2].mBinding = 0;
		vertexLayout.mAttribs[2].mLocation = 2;
		vertexLayout.mAttribs[2].mOffset = 8 * sizeof(float);

		//up
		vertexLayout.mAttribs[3].mSemantic = SEMANTIC_TEXCOORD3;
		vertexLayout.mAttribs[3].mFormat = ImageFormat::RGBA32F;
		vertexLayout.mAttribs[3].mBinding = 0;
		vertexLayout.mAttribs[3].mLocation = 3;
		vertexLayout.mAttribs[3].mOffset = 12 * sizeof(float);

#ifdef METAL
		// widthDir
		vertexLayout.mAttribs[4].mSemantic = SEMANTIC_TEXCOORD3;
		vertexLayout.mAttribs[4].mFormat = ImageFormat::RGBA32F;
		vertexLayout.mAttribs[4].mBinding = 0;
		vertexLayout.mAttribs[4].mLocation = 4;
		vertexLayout.mAttribs[4].mOffset = 16 * sizeof(float);
#endif

		GraphicsPipelineDesc pipelineSettings = { 0 };
		pipelineSettings.mPrimitiveTopo = PRIMITIVE_TOPO_PATCH_LIST;
		pipelineSettings.pRasterizerState = pRast;
		pipelineSettings.pDepthState = pDepth;
		pipelineSettings.mRenderTargetCount = 1;
		pipelineSettings.pColorFormats = &pSwapChain->ppSwapchainRenderTargets[0]->mDesc.mFormat;
		pipelineSettings.pSrgbValues = &pSwapChain->ppSwapchainRenderTargets[0]->mDesc.mSrgb;
		pipelineSettings.mSampleCount = pSwapChain->ppSwapchainRenderTargets[0]->mDesc.mSampleCount;
		pipelineSettings.mSampleQuality = pSwapChain->ppSwapchainRenderTargets[0]->mDesc.mSampleQuality;
		pipelineSettings.mDepthStencilFormat = pDepthBuffer->mDesc.mFormat;
		pipelineSettings.pVertexLayout = &vertexLayout;
		pipelineSettings.pRootSignature = pGrassRootSignature;
		pipelineSettings.pShaderProgram = pGrassShader;
		addPipeline(pRenderer, &pipelineSettings, &pGrassPipeline);
		pipelineSettings.pRasterizerState = pWireframeRast;
		addPipeline(pRenderer, &pipelineSettings, &pGrassPipelineForWireframe);

#if defined(VULKAN)
		transitionRenderTargets();
#endif

		return true;
	}

	void Unload()
	{
		waitForFences(pGraphicsQueue, 1, &pRenderCompleteFences[gFrameIndex], true);

		gAppUI.Unload();

		removePipeline(pRenderer, pGrassPipeline);
		removePipeline(pRenderer, pGrassPipelineForWireframe);

		removeSwapChain(pRenderer, pSwapChain);
		removeRenderTarget(pRenderer, pDepthBuffer);
	}

	void Update(float deltaTime)
	{
		/************************************************************************/
		// Update camera
		/************************************************************************/
#if USE_CAMERACONTROLLER
#ifndef TARGET_IOS
#if !defined(_DURANGO)
		if (getKeyDown(KEY_F))
		{
			RecenterCameraView(170.0f);
		}
#endif
#endif

		pCameraController->update(deltaTime);
#endif
		/************************************************************************/
		// Update uniform buffer
		/************************************************************************/
#if USE_CAMERACONTROLLER	
		mat4 viewMat = pCameraController->getViewMatrix();
#else	
		mat4 viewMat = mat4::lookAt(gCameraProp.mCameraPosition, Point3(gCameraProp.mCameraPosition + gCameraProp.mCameraDirection), gCameraProp.mCameraUp);
#endif
		const float aspectInverse = (float)mSettings.mHeight / (float)mSettings.mWidth;
		const float horizontal_fov = PI / 2.0f;
		mat4 projMat = mat4::perspective(horizontal_fov, aspectInverse, 0.1f, 1000.0f);

		gGrassUniformData.mDeltaTime = deltaTime;
		gGrassUniformData.mProj = projMat;
		gGrassUniformData.mView = viewMat;
		gGrassUniformData.mViewProj = gGrassUniformData.mProj * gGrassUniformData.mView;
		gGrassUniformData.mInvView = inverse(viewMat);
		gGrassUniformData.mWorld = mat4::identity();

		gGrassUniformData.mTotalTime = (float)(getSystemTime() - gStartTime) / 1000.0f;;

		gGrassUniformData.mMaxTessellationLevel = gMaxTessellationLevel;
		gGrassUniformData.mWindMode = gWindMode;

		gGrassUniformData.mWindSpeed = gWindSpeed;
		gGrassUniformData.mWindWidth = gWindWidth;
		gGrassUniformData.mWindStrength = gWindStrength;

		BufferUpdateDesc cbvUpdate = { pGrassUniformBuffer, &gGrassUniformData };
		updateResource(&cbvUpdate);
		/************************************************************************/
		// Update GUI
		/************************************************************************/
		gAppUI.Update(deltaTime);
		/************************************************************************/
		/************************************************************************/
	}

	void Draw()
	{
		acquireNextImage(pRenderer, pSwapChain, pImageAcquiredSemaphore, NULL, &gFrameIndex);
		RenderTarget* pRenderTarget = pSwapChain->ppSwapchainRenderTargets[gFrameIndex];

		Semaphore* pRenderCompleteSemaphore = pRenderCompleteSemaphores[gFrameIndex];
		Fence* pRenderCompleteFence = pRenderCompleteFences[gFrameIndex];

		// simply record the screen cleaning command
		LoadActionsDesc loadActions = {};
		loadActions.mLoadActionsColor[0] = LOAD_ACTION_CLEAR;
		loadActions.mClearColorValues[0] = { 0.0f, 0.0f, 0.0f, 0.0f };
		loadActions.mLoadActionDepth = LOAD_ACTION_CLEAR;
		loadActions.mClearDepth = { 1.0f, 0.0f }; // Clear depth to the far plane and stencil to 0

		tinystl::vector<Cmd*> allCmds;

		Cmd* cmd = ppCmds[gFrameIndex];
		beginCmd(cmd);

#ifndef METAL
		cmdBeginGpuFrameProfile(cmd, pGpuProfiler);
#endif

		const uint32_t* pThreadGroupSize = pComputeShader->mReflection.mStageReflections[0].mNumThreadsPerGroup;

#ifndef METAL
		cmdBeginGpuTimestampQuery(cmd, pGpuProfiler, "Compute Pass");
#endif

		DescriptorData computeParams[4] = {};
		cmdBindPipeline(cmd, pComputePipeline);


		computeParams[0].pName = "GrassUniformBlock";
		computeParams[0].ppBuffers = &pGrassUniformBuffer;

		computeParams[1].pName = "Blades";
		computeParams[1].ppBuffers = &pBladeStorageBuffer;

		computeParams[2].pName = "CulledBlades";
		computeParams[2].ppBuffers = &pCulledBladeStorageBuffer;

		computeParams[3].pName = "NumBlades";
		computeParams[3].ppBuffers = &pBladeNumBuffer;

		cmdBindDescriptors(cmd, pComputeRootSignature, 4, computeParams);
		cmdDispatch(cmd, (int)ceil(NUM_BLADES / pThreadGroupSize[0]), pThreadGroupSize[1], pThreadGroupSize[2]);

#ifndef METAL
		cmdEndGpuTimestampQuery(cmd, pGpuProfiler);
#endif

		TextureBarrier barriers[] = {
			{ pRenderTarget->pTexture, RESOURCE_STATE_RENDER_TARGET },
		};
		BufferBarrier srvBarriers[] = {
			{ pBladeNumBuffer, RESOURCE_STATE_INDIRECT_ARGUMENT },
			{ pCulledBladeStorageBuffer, RESOURCE_STATE_VERTEX_AND_CONSTANT_BUFFER },
		};
		cmdResourceBarrier(cmd, 2, srvBarriers, 1, barriers, false);

#ifdef METAL
		// On Metal, we have to run the grass_vertexHull compute shader before running the post-tesselation shaders.
		DescriptorData vertexHullParams[5] = {};
		cmdBindPipeline(cmd, pGrassVertexHullPipeline);
		vertexHullParams[0].pName = "GrassUniformBlock";
		vertexHullParams[0].ppBuffers = &pGrassUniformBuffer;
		vertexHullParams[1].pName = "vertexInput";
		vertexHullParams[1].ppBuffers = &pCulledBladeStorageBuffer;
		vertexHullParams[2].pName = "drawInfo";
		vertexHullParams[2].ppBuffers = &pBladeNumBuffer;
		vertexHullParams[3].pName = "tessellationFactorBuffer";
		vertexHullParams[3].ppBuffers = &pTessFactorsBuffer;
		vertexHullParams[4].pName = "hullOutputBuffer";
		vertexHullParams[4].ppBuffers = &pHullOutputBuffer;
		cmdBindDescriptors(cmd, pGrassVertexHullRootSignature, 5, vertexHullParams);
		cmdDispatch(cmd, (int)ceil(NUM_BLADES / pThreadGroupSize[0]), pThreadGroupSize[1], pThreadGroupSize[2]);
#endif

		cmdBindRenderTargets(cmd, 1, &pRenderTarget, pDepthBuffer, &loadActions);
		cmdSetViewport(cmd, 0.0f, 0.0f, (float)pRenderTarget->mDesc.mWidth, (float)pRenderTarget->mDesc.mHeight, 0.0f, 1.0f);
		cmdSetScissor(cmd, 0, 0, pRenderTarget->mDesc.mWidth, pRenderTarget->mDesc.mHeight);

#ifndef METAL
		cmdBeginGpuTimestampQuery(cmd, pGpuProfiler, "Draw Pass");
#endif

		// Draw computed results
		if (gFillMode == FILL_MODE_SOLID)
			cmdBindPipeline(cmd, pGrassPipeline);
		else if (gFillMode == FILL_MODE_WIREFRAME)
			cmdBindPipeline(cmd, pGrassPipelineForWireframe);

		DescriptorData grassParams[1] = {};
		grassParams[0].pName = "GrassUniformBlock";
		grassParams[0].ppBuffers = &pGrassUniformBuffer;
		cmdBindDescriptors(cmd, pGrassRootSignature, 1, grassParams);

#ifndef METAL
		cmdBindVertexBuffer(cmd, 1, &pCulledBladeStorageBuffer);
#else
		// When using tessellation on Metal, you should always bind the tessellationFactors buffer and the controlPointBuffer together as vertex buffer (following this order).
		Buffer* tessBuffers[] = { pTessFactorsBuffer, pHullOutputBuffer };
		cmdBindVertexBuffer(cmd, 2, tessBuffers);
#endif
		cmdExecuteIndirect(cmd, pIndirectCommandSignature, 1, pBladeNumBuffer, 0, NULL, 0);

		cmdBindRenderTargets(cmd, 0, NULL, NULL, NULL);

		BufferBarrier uavBarriers[] = {
			{ pBladeNumBuffer, RESOURCE_STATE_UNORDERED_ACCESS },
			{ pCulledBladeStorageBuffer, RESOURCE_STATE_UNORDERED_ACCESS },
		};
		cmdResourceBarrier(cmd, 2, uavBarriers, 0, NULL, true);

#ifndef METAL
		cmdEndGpuTimestampQuery(cmd, pGpuProfiler);
#endif

#ifndef METAL
		cmdEndGpuFrameProfile(cmd, pGpuProfiler);
#endif

		endCmd(cmd);

		allCmds.push_back(cmd);

		// Draw UI
		cmd = ppUICmds[gFrameIndex];
		beginCmd(cmd);

		cmdBindRenderTargets(cmd, 1, &pRenderTarget, NULL, NULL);
		cmdSetViewport(cmd, 0.0f, 0.0f, (float)pRenderTarget->mDesc.mWidth, (float)pRenderTarget->mDesc.mHeight, 0.0f, 1.0f);
		cmdSetScissor(cmd, 0, 0, pRenderTarget->mDesc.mWidth, pRenderTarget->mDesc.mHeight);

		static HiresTimer timer;
		timer.GetUSec(true);

		drawDebugText(cmd, 8, 15, String::format("CPU %f ms", timer.GetUSecAverage() / 1000.0f), &gFrameTimeDraw);
        
#ifdef TARGET_IOS
        // Draw the camera controller's virtual joysticks.
        float extSide = min(mSettings.mHeight, mSettings.mWidth) * pCameraController->getVirtualJoystickExternalRadius();
        float intSide = min(mSettings.mHeight, mSettings.mWidth) * pCameraController->getVirtualJoystickInternalRadius();
        
        float2 joystickSize = float2(extSide);
        vec2 leftJoystickCenter = pCameraController->getVirtualLeftJoystickCenter();
        float2 leftJoystickPos = float2(leftJoystickCenter.getX() * mSettings.mWidth, leftJoystickCenter.getY() * mSettings.mHeight) - 0.5f * joystickSize;
		drawDebugTexture(cmd, leftJoystickPos.x, leftJoystickPos.y, joystickSize.x, joystickSize.y, pVirtualJoystickTex, 1.0f, 1.0f, 1.0f);
        vec2 rightJoystickCenter = pCameraController->getVirtualRightJoystickCenter();
        float2 rightJoystickPos = float2(rightJoystickCenter.getX() * mSettings.mWidth, rightJoystickCenter.getY() * mSettings.mHeight) - 0.5f * joystickSize;
		drawDebugTexture(cmd, rightJoystickPos.x, rightJoystickPos.y, joystickSize.x, joystickSize.y, pVirtualJoystickTex, 1.0f, 1.0f, 1.0f);
        
        joystickSize = float2(intSide);
        leftJoystickCenter = pCameraController->getVirtualLeftJoystickPos();
        leftJoystickPos = float2(leftJoystickCenter.getX() * mSettings.mWidth, leftJoystickCenter.getY() * mSettings.mHeight) - 0.5f * joystickSize;
		drawDebugTexture(cmd, leftJoystickPos.x, leftJoystickPos.y, joystickSize.x, joystickSize.y, pVirtualJoystickTex, 1.0f, 1.0f, 1.0f);
        rightJoystickCenter = pCameraController->getVirtualRightJoystickPos();
        rightJoystickPos = float2(rightJoystickCenter.getX() * mSettings.mWidth, rightJoystickCenter.getY() * mSettings.mHeight) - 0.5f * joystickSize;
		drawDebugTexture(cmd, rightJoystickPos.x, rightJoystickPos.y, joystickSize.x, joystickSize.y, pVirtualJoystickTex, 1.0f, 1.0f, 1.0f);
#endif

#ifndef METAL // Metal doesn't support GPU profilers
		drawDebugText(cmd, 8, 40, String::format("GPU %f ms", (float)pGpuProfiler->mCumulativeTime * 1000.0f), &gFrameTimeDraw);
		drawDebugGpuProfile(cmd, 8, 65, pGpuProfiler, NULL);
#endif

#ifndef TARGET_IOS
		gAppUI.Gui(pGui);
#endif

		gAppUI.Draw(cmd);

		barriers[0] = { pRenderTarget->pTexture, RESOURCE_STATE_PRESENT };
		cmdResourceBarrier(cmd, 0, NULL, 1, barriers, true);

		endCmd(cmd);
		allCmds.push_back(cmd);

		queueSubmit(pGraphicsQueue, (uint32_t)allCmds.size(), allCmds.data(), pRenderCompleteFence, 1, &pImageAcquiredSemaphore, 1, &pRenderCompleteSemaphore);
		queuePresent(pGraphicsQueue, pSwapChain, gFrameIndex, 1, &pRenderCompleteSemaphore);

		// Stall if CPU is running "Swap Chain Buffer Count" frames ahead of GPU
		Fence* pNextFence = pRenderCompleteFences[(gFrameIndex + 1) % gImageCount];
		FenceStatus fenceStatus;
		getFenceStatus(pRenderer, pNextFence, &fenceStatus);
		if (fenceStatus == FENCE_STATUS_INCOMPLETE)
			waitForFences(pGraphicsQueue, 1, &pNextFence, false);
	}

	String GetName()
	{
		return "UnitTest_07_Tessellation";
	}

	bool addSwapChain()
	{
		SwapChainDesc swapChainDesc = {};
		swapChainDesc.pWindow = pWindow;
		swapChainDesc.mPresentQueueCount = 1;
		swapChainDesc.ppPresentQueues = &pGraphicsQueue;
		swapChainDesc.mWidth = mSettings.mWidth;
		swapChainDesc.mHeight = mSettings.mHeight;
		swapChainDesc.mImageCount = gImageCount;
		swapChainDesc.mSampleCount = SAMPLE_COUNT_1;
		swapChainDesc.mColorFormat = getRecommendedSwapchainFormat(true);
		swapChainDesc.mEnableVsync = false;
		::addSwapChain(pRenderer, &swapChainDesc, &pSwapChain);

		return pSwapChain != NULL;
	}

	bool addDepthBuffer()
	{
		// Add depth buffer
		RenderTargetDesc depthRT = {};
		depthRT.mArraySize = 1;
		depthRT.mClearValue = { 1.0f, 0 };
		depthRT.mDepth = 1;
		depthRT.mFormat = ImageFormat::D32F;
		depthRT.mHeight = mSettings.mHeight;
		depthRT.mSampleCount = SAMPLE_COUNT_1;
		depthRT.mSampleQuality = 0;
		depthRT.mType = RENDER_TARGET_TYPE_2D;
		depthRT.mUsage = RENDER_TARGET_USAGE_DEPTH_STENCIL;
		depthRT.mWidth = mSettings.mWidth;
		addRenderTarget(pRenderer, &depthRT, &pDepthBuffer);

		return pDepthBuffer != NULL;
	}

	float generateRandomFloat()
	{
		return rand() / (float)RAND_MAX;
	}

	void initBlades()
	{
		gBlades.reserve(NUM_BLADES);

		for (unsigned int i = 0; i < NUM_BLADES; i++) {
			Blade currentBlade;// = Blade();

			vec3 bladeUp(0.0f, 1.0f, 0.0f);

			// Generate positions and direction (v0)
			float x = (generateRandomFloat() - 0.5f) * PLANE_SIZE;
			float y = 0.0f;
			float z = (generateRandomFloat() - 0.5f) * PLANE_SIZE;
			float direction = generateRandomFloat() * 2.f * 3.14159265f;
			vec3 bladePosition(x, y, z);
			currentBlade.mV0 = vec4(bladePosition, direction);

			// Bezier point and height (v1)
			float height = MIN_HEIGHT + (generateRandomFloat() * (MAX_HEIGHT - MIN_HEIGHT));
			currentBlade.mV1 = vec4(bladePosition + bladeUp * height, height);

			// Physical model guide and width (v2)
			float width = MIN_WIDTH + (generateRandomFloat() * (MAX_WIDTH - MIN_WIDTH));
			currentBlade.mV2 = vec4(bladePosition + bladeUp * height, width);

			// Up vector and stiffness coefficient (up)
			float stiffness = MIN_BEND + (generateRandomFloat() * (MAX_BEND - MIN_BEND));
			currentBlade.mUp = vec4(bladeUp, stiffness);

			gBlades.push_back(currentBlade);
		}
	}
#if defined(VULKAN)
	void transitionRenderTargets()
	{
		TextureBarrier barrier = { pDepthBuffer->pTexture, RESOURCE_STATE_DEPTH_WRITE };
		beginCmd(ppCmds[0]);
		cmdResourceBarrier(ppCmds[0], 0, NULL, 1, &barrier, false);
		endCmd(ppCmds[0]);
		queueSubmit(pGraphicsQueue, 1, ppCmds, pRenderCompleteFences[0], 0, NULL, 0, NULL);
		waitForFences(pGraphicsQueue, 1, &pRenderCompleteFences[0], false);
	}
#endif

	void RecenterCameraView(float maxDistance, vec3 lookAt = vec3(0))
	{
		vec3 p = pCameraController->getViewPosition();
		vec3 d = p - lookAt;

		float lenSqr = lengthSqr(d);
		if (lenSqr > (maxDistance * maxDistance))
		{
			d *= (maxDistance / sqrtf(lenSqr));
		}

		p = d + lookAt;
		pCameraController->moveTo(p);
		pCameraController->lookAt(lookAt);
	}

	/// Camera controller functionality
#if USE_CAMERACONTROLLER
#if !defined(_DURANGO)
	static bool cameraMouseMove(const RawMouseMoveEventData* data)
	{
		pCameraController->onMouseMove(data);
		return true;
	}

	static bool cameraMouseButton(const MouseButtonEventData* data)
	{
		pCameraController->onMouseButton(data);
		return true;
	}

	static bool cameraMouseWheel(const MouseWheelEventData* data)
	{
		pCameraController->onMouseWheel(data);
		return true;
	}
#endif

#ifdef TARGET_IOS
    static bool cameraTouch(const TouchEventData* data)
    {
        pCameraController->onTouch(data);
        return true;
    }
    
    static bool cameraTouchMove(const TouchEventData* data)
    {
        pCameraController->onTouchMove(data);
        return true;
    }
#endif
#endif
};

DEFINE_APPLICATION_MAIN(Tessellation)
