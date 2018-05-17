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

// Unit Test to create Bottom and Top Level Acceleration Structures using Raytracing API.

//tiny stl
#include "../../../../Common_3/ThirdParty/OpenSource/TinySTL/vector.h"
#include "../../../../Common_3/ThirdParty/OpenSource/TinySTL/string.h"

//Interfaces
#include "../../../../Common_3/OS/Interfaces/ICameraController.h"
#include "../../../../Common_3/OS/Interfaces/IApp.h"
#include "../../../../Common_3/OS/Interfaces/ILogManager.h"
#include "../../../../Common_3/OS/Interfaces/IFileSystem.h"
#include "../../../../Common_3/OS/Interfaces/ITimeManager.h"
#include "../../../../Common_3/OS/Core/DebugRenderer.h"
#include "../../../../Common_3/Renderer/IRenderer.h"
#include "../../../../Common_3/Renderer/GpuProfiler.h"
#include "../../../../Common_3/Renderer/ResourceLoader.h"

// Raytracing
#include "../../../../CommonRaytracing_3/Interfaces/IRaytracing.h"

//Math
#include "../../../../Common_3/OS/Math/MathTypes.h"

// Shader
#include "PCDX12/Compiled/RayGen.h"
#include "PCDX12/Compiled/ClosestHit.h"
#include "PCDX12/Compiled/Miss.h"

#include "../../../../Common_3/OS/Interfaces/IMemoryManager.h"

//Example for using roots or will cause linker error with the extern root in FileSystem.cpp
const char* pszRoots[FSR_Count] =
{
	"",										// FSR_BinShaders
	"",										// FSR_SrcShaders
	"",										// FSR_BinShaders_Common
	"",										// FSR_SrcShaders_Common
	"",										// FSR_Textures
	"",										// FSR_Meshes
	"../../../UnitTestResources/Fonts/",	// FSR_Builtin_Fonts
	"",										// FSR_OtherFiles
};

class UnitTest_Triangle : public IApp
{
public:
	bool Init()
	{
		/************************************************************************/
		// 01 Init Raytracing
		/************************************************************************/
		RendererDesc desc = {};
		initRenderer(GetName(), &desc, &pRenderer);
		initResourceLoaderInterface(pRenderer);
		initRaytracing(pRenderer, &pRaytracing);

		QueueDesc queueDesc = {};
		queueDesc.mType = CMD_POOL_DIRECT;
		addQueue(pRenderer, &queueDesc, &pQueue);
		addCmdPool(pRenderer, pQueue, false, &pCmdPool);
		addCmd_n(pCmdPool, false, gImageCount, &ppCmds);
		addSemaphore(pRenderer, &pImageAcquiredSemaphore);
		for (uint32_t i = 0; i < gImageCount; ++i)
		{
			addFence(pRenderer, &pRenderCompleteFences[i]);
			addSemaphore(pRenderer, &pRenderCompleteSemaphores[i]);
		}

		addGpuProfiler(pRenderer, pQueue, &pGpuProfiler);

		initDebugRendererInterface(pRenderer, FileSystem::FixPath("TitilliumText/TitilliumText-Bold.ttf", FSR_Builtin_Fonts));
		/************************************************************************/
		// 02 Creation Acceleration Structure
		/************************************************************************/
		// Create Vertex Buffer
		const float3 vertices[] =
		{
			float3(0,          1,  0),
			float3(0.866f,  -0.5f, 0),
			float3(-0.866f, -0.5f, 0),
		};
		BufferLoadDesc vbDesc = {};
		vbDesc.mDesc.mUsage = BUFFER_USAGE_VERTEX;
		vbDesc.mDesc.mMemoryUsage = RESOURCE_MEMORY_USAGE_GPU_ONLY;
		vbDesc.mDesc.mSize = sizeof(vertices);
		vbDesc.mDesc.mVertexStride = sizeof(float3);
		vbDesc.pData = vertices;
		vbDesc.ppBuffer = &pVertexBuffer;
		addResource(&vbDesc);

		// Specify Geometry Used in Raytracing Structure
		AccelerationStructureGeometryDesc geomDesc = {};
		geomDesc.mFlags = ACCELERATION_STRUCTURE_GEOMETRY_FLAG_OPAQUE;
		geomDesc.mType = ACCELERATION_STRUCTURE_GEOMETRY_TYPE_TRIANGLES;
		geomDesc.pVertexBuffer = pVertexBuffer;

		uint32_t bottomASScratchBufferSize = 0;
		AccelerationStructureDesc bottomASDesc = {};
		bottomASDesc.mDescCount = 1;
		bottomASDesc.mFlags = ACCELERATION_STRUCTURE_BUILD_FLAG_PREFER_FAST_TRACE;
		bottomASDesc.mType = ACCELERATION_STRUCTURE_TYPE_BOTTOM_LEVEL;
		bottomASDesc.pGeometryDescs = &geomDesc;
		addAccelerationStructure(pRaytracing, &bottomASDesc, &bottomASScratchBufferSize, &pBottomLevelAS);

		// Specify Instance Used in Raytracing Structure
		mat4 identity = mat4::identity();
		AccelerationStructureInstanceDesc instanceDesc = {};
		instanceDesc.mFlags = ACCELERATION_STRUCTURE_INSTANCE_FLAG_NONE;
		instanceDesc.mInstanceContributionToHitGroupIndex = 0;
		instanceDesc.mInstanceID = 0;
		instanceDesc.mInstanceMask = 1;
		memcpy(instanceDesc.mTransform, &identity, sizeof(float[12]));
		instanceDesc.pAccelerationStructure = pBottomLevelAS;

		uint32_t topASScratchBufferSize = 0;
		AccelerationStructureDesc topASDesc = {};
		topASDesc.mDescCount = 1;
		topASDesc.mFlags = ACCELERATION_STRUCTURE_BUILD_FLAG_PREFER_FAST_TRACE;
		topASDesc.mType = ACCELERATION_STRUCTURE_TYPE_TOP_LEVEL;
		topASDesc.pInstanceDescs = &instanceDesc;
		addAccelerationStructure(pRaytracing, &topASDesc, &topASScratchBufferSize, &pTopLevelAS);

		Buffer* pScratchBuffer = NULL;
		BufferLoadDesc scratchBufferDesc = {};
		scratchBufferDesc.mDesc.mUsage = BUFFER_USAGE_STORAGE_UAV;
		scratchBufferDesc.mDesc.mMemoryUsage = RESOURCE_MEMORY_USAGE_GPU_ONLY;
		scratchBufferDesc.mDesc.mFlags = BUFFER_CREATION_FLAG_NO_DESCRIPTOR_VIEW_CREATION;
		scratchBufferDesc.mDesc.mSize = max(bottomASScratchBufferSize, topASScratchBufferSize);
		scratchBufferDesc.ppBuffer = &pScratchBuffer;
		addResource(&scratchBufferDesc);

		// Build Acceleration Structure
		beginCmd(ppCmds[0]);
		cmdBuildAccelerationStructure(ppCmds[0], pRaytracing, pScratchBuffer, pBottomLevelAS);
		cmdBuildAccelerationStructure(ppCmds[0], pRaytracing, pScratchBuffer, pTopLevelAS);
		endCmd(ppCmds[0]);
		queueSubmit(pQueue, 1, &ppCmds[0], pRenderCompleteFences[0], 0, NULL, 0, NULL);
		waitForFences(pQueue, 1, &pRenderCompleteFences[0], false);

		// Safe to remove scratch buffer since the GPU is done using it
		removeResource(pScratchBuffer);
		/************************************************************************/
		// Currently, dxc does not support reflecting raytracing shaders
		// So we hard-code the root signature
		// Once reflection is supported, we will go back to passing shaders for rootsignature creation
		// addRaytracingRootSignature(pRaytracing, ppShaders, 2, &pRootSignature);
		/************************************************************************/
		ShaderResource shaderResources[1] = {};
		shaderResources[0].name = "gOutput";
		shaderResources[0].name_size = (uint32_t)strlen(shaderResources[0].name);
		shaderResources[0].reg = 0;
		shaderResources[0].set = 0;
		shaderResources[0].size = 1;
		shaderResources[0].type = DESCRIPTOR_TYPE_RW_TEXTURE;
		addRaytracingRootSignature(pRaytracing, shaderResources, 1, false, &pRootSignature);
		/************************************************************************/
		// 03 - Create Raytracing Pipeline
		/************************************************************************/
		const char* pNames[] = { "rayGen", "miss", "chs" };
		addRaytracingShader(pRaytracing, gShader_RayGen, sizeof(gShader_RayGen), pNames[0], &pShaderRayGen);
		addRaytracingShader(pRaytracing, gShader_ClosestHit, sizeof(gShader_ClosestHit), pNames[2], &pShaderHit);
		addRaytracingShader(pRaytracing, gShader_Miss, sizeof(gShader_Miss), pNames[1], &pShaderMiss);

		RaytracingHitGroup hitGroup = {};
		hitGroup.pClosestHitShader = pShaderHit;
		hitGroup.pHitGroupName = "hitGroup";

		RaytracingShader* pShaders[] = { pShaderRayGen, pShaderHit, pShaderMiss };
		RaytracingPipelineDesc pipelineDesc = {};
		pipelineDesc.mAttributeSize = sizeof(float2);
		pipelineDesc.mMaxTraceRecursionDepth = 1;
		pipelineDesc.mPayloadSize = sizeof(float3);
		pipelineDesc.pGlobalRootSignature = pRootSignature;
		pipelineDesc.pRayGenShader = pShaderRayGen;
		pipelineDesc.ppMissShaders = &pShaderMiss;
		pipelineDesc.mMissShaderCount = 1;
		pipelineDesc.pHitGroups = &hitGroup;
		pipelineDesc.mHitGroupCount = 1;
		addRaytracingPipeline(pRaytracing, &pipelineDesc, &pPipeline);
		/************************************************************************/
		// 04 - Create Shader Binding Table to connect Pipeline with Acceleration Structure
		/************************************************************************/
		RaytracingShaderTableRecordDesc rayGenRecord = { "rayGen" };
		RaytracingShaderTableRecordDesc missRecord = { "miss" };
		RaytracingShaderTableRecordDesc hitRecord = { "hitGroup" };

		RaytracingShaderTableDesc shaderTableDesc = {};
		shaderTableDesc.pPipeline = pPipeline;
		shaderTableDesc.pRayGenShader = &rayGenRecord;
		shaderTableDesc.mMissShaderCount = 1;
		shaderTableDesc.pMissShaders = &missRecord;
		shaderTableDesc.mHitGroupCount = 1;
		shaderTableDesc.pHitGroups = &hitRecord;
		addRaytracingShaderTable(pRaytracing, &shaderTableDesc, &pShaderTable);
		/************************************************************************/
		/************************************************************************/
		return true;
	}

	void Exit()
	{
		waitForFences(pQueue, 1, &pRenderCompleteFences[mFrameIdx], true);

		removeDebugRendererInterface();

		removeGpuProfiler(pRenderer, pGpuProfiler);

		removeRaytracingShaderTable(pRaytracing, pShaderTable);
		removeRaytracingPipeline(pRaytracing, pPipeline);
		removeRootSignature(pRenderer, pRootSignature);
		removeRaytracingShader(pRaytracing, pShaderRayGen);
		removeRaytracingShader(pRaytracing, pShaderHit);
		removeRaytracingShader(pRaytracing, pShaderMiss);
		removeResource(pVertexBuffer);
		removeAccelerationStructure(pRaytracing, pTopLevelAS);
		removeAccelerationStructure(pRaytracing, pBottomLevelAS);
		for (uint32_t i = 0; i < gImageCount; ++i)
		{
			removeFence(pRenderer, pRenderCompleteFences[i]);
			removeSemaphore(pRenderer, pRenderCompleteSemaphores[i]);
		}
		removeSemaphore(pRenderer, pImageAcquiredSemaphore);
		removeCmd_n(pCmdPool, gImageCount, ppCmds);
		removeCmdPool(pRenderer, pCmdPool);
		removeQueue(pQueue);
		removeRaytracing(pRenderer, pRaytracing);
		removeResourceLoaderInterface(pRenderer);
		removeRenderer(pRenderer);
	}

	bool Load()
	{
		/************************************************************************/
		// 04 - Create Output Resources
		/************************************************************************/
		TextureDesc uavDesc = {};
		uavDesc.mArraySize = 1;
		uavDesc.mDepth = 1;
		uavDesc.mFormat = getRecommendedSwapchainFormat(true);
		uavDesc.mHeight = mSettings.mHeight;
		uavDesc.mMipLevels = 1;
		uavDesc.mSampleCount = SAMPLE_COUNT_1;
		uavDesc.mSrgb = false;
		uavDesc.mStartState = RESOURCE_STATE_UNORDERED_ACCESS;
		uavDesc.mType = TEXTURE_TYPE_2D;
		uavDesc.mUsage = TEXTURE_USAGE_UNORDERED_ACCESS;
		uavDesc.mWidth = mSettings.mWidth;
		TextureLoadDesc loadDesc = {};
		loadDesc.pDesc = &uavDesc;
		loadDesc.ppTexture = &pComputeOutput;
		addResource(&loadDesc);

		SwapChainDesc swapChainDesc = {};
		swapChainDesc.mColorClearValue = { 1, 1, 1, 1 };
		swapChainDesc.mColorFormat = getRecommendedSwapchainFormat(true);
		swapChainDesc.mEnableVsync = false;
		swapChainDesc.mHeight = mSettings.mHeight;
		swapChainDesc.mImageCount = gImageCount;
		swapChainDesc.mSampleCount = SAMPLE_COUNT_1;
		swapChainDesc.mSrgb = false;
		swapChainDesc.mWidth = mSettings.mWidth;
		swapChainDesc.ppPresentQueues = &pQueue;
		swapChainDesc.mPresentQueueCount = 1;
		swapChainDesc.pWindow = pWindow;
		addSwapChain(pRenderer, &swapChainDesc, &pSwapChain);
		/************************************************************************/
		/************************************************************************/

		return true;
	}

	void Unload()
	{
		waitForFences(pQueue, 1, &pRenderCompleteFences[mFrameIdx], true);

		removeSwapChain(pRenderer, pSwapChain);
		removeResource(pComputeOutput);
	}

	void Update(float deltaTime)
	{
	}

	void Draw()
	{
		acquireNextImage(pRenderer, pSwapChain, pImageAcquiredSemaphore, NULL, &mFrameIdx);

		FenceStatus fenceStatus = {};
		getFenceStatus(pRenderer, pRenderCompleteFences[mFrameIdx], &fenceStatus);
		if (fenceStatus == FENCE_STATUS_INCOMPLETE)
			waitForFences(pQueue, 1, &pRenderCompleteFences[mFrameIdx], false);

		Cmd* pCmd = ppCmds[mFrameIdx];
		RenderTarget* pRenderTarget = pSwapChain->ppSwapchainRenderTargets[mFrameIdx];
		beginCmd(pCmd);
		cmdBeginGpuFrameProfile(pCmd, pGpuProfiler, true);
		/************************************************************************/
		// Transition UAV texture so raytracing shader can write to it
		/************************************************************************/
		cmdBeginGpuTimestampQuery(pCmd, pGpuProfiler, "Raytrace Triangle", true);
		TextureBarrier uavBarrier = { pComputeOutput, RESOURCE_STATE_UNORDERED_ACCESS };
		cmdResourceBarrier(pCmd, 0, NULL, 1, &uavBarrier, false);
		/************************************************************************/
		// Perform raytracing
		/************************************************************************/
		DescriptorData params[1] = {};
		params[0].pName = "gOutput";
		params[0].ppTextures = &pComputeOutput;
		cmdBindDescriptors(pCmd, pRootSignature, 1, params);

		RaytracingDispatchDesc dispatchDesc = {};
		dispatchDesc.mHeight = mSettings.mHeight;
		dispatchDesc.mWidth = mSettings.mWidth;
		dispatchDesc.pShaderTable = pShaderTable;
		dispatchDesc.pTopLevelAccelerationStructure = pTopLevelAS;
		cmdDispatchRays(pCmd, pRaytracing, &dispatchDesc);
		/************************************************************************/
		// Transition UAV to be used as source and swapchain as destination in copy operation
		/************************************************************************/
		TextureBarrier copyBarriers[] = {
			{ pComputeOutput, RESOURCE_STATE_COPY_SOURCE },
			{ pRenderTarget->pTexture, RESOURCE_STATE_COPY_DEST },
		};
		cmdResourceBarrier(pCmd, 0, NULL, 2, copyBarriers, false);
		cmdEndGpuTimestampQuery(pCmd, pGpuProfiler);
		/************************************************************************/
		// Perform copy
		/************************************************************************/
		cmdBeginGpuTimestampQuery(pCmd, pGpuProfiler, "Copy UAV", true);
		cmdCopyTexture(pCmd, pRenderTarget->pTexture, pComputeOutput);
		cmdEndGpuTimestampQuery(pCmd, pGpuProfiler);
		/************************************************************************/
		// Present to screen
		/************************************************************************/
		TextureBarrier rtBarrier = { pRenderTarget->pTexture, RESOURCE_STATE_RENDER_TARGET };
		cmdResourceBarrier(pCmd, 0, NULL, 1, &rtBarrier, false);

		cmdBindRenderTargets(pCmd, 1, &pRenderTarget, NULL, NULL);
		cmdSetViewport(pCmd, 0.0f, 0.0f, (float)mSettings.mWidth, (float)mSettings.mHeight, 0.0f, 1.0f);
		cmdSetScissor(pCmd, 0, 0, mSettings.mWidth, mSettings.mHeight);
		drawDebugGpuProfile(pCmd, 15.0f, 40.0f, pGpuProfiler, NULL);

		TextureBarrier presentBarrier = { pRenderTarget->pTexture, RESOURCE_STATE_PRESENT };
		cmdResourceBarrier(pCmd, 0, NULL, 1, &presentBarrier, true);

		cmdEndGpuFrameProfile(pCmd, pGpuProfiler);
		endCmd(pCmd);
		queueSubmit(pQueue, 1, &pCmd, pRenderCompleteFences[mFrameIdx], 1, &pImageAcquiredSemaphore, 1, &pRenderCompleteSemaphores[mFrameIdx]);
		queuePresent(pQueue, pSwapChain, mFrameIdx, 1, &pRenderCompleteSemaphores[mFrameIdx]);
		/************************************************************************/
		/************************************************************************/
	}

	String GetName()
	{
		return "Raytrace Triangle";
	}
	/************************************************************************/
	// Data
	/************************************************************************/
private:
	static const uint32_t	gImageCount = 3;

	Renderer*				pRenderer;
	Raytracing*				pRaytracing;
	Queue*					pQueue;
	CmdPool*				pCmdPool;
	Cmd**					ppCmds;
	Fence*					pRenderCompleteFences[gImageCount];
	Buffer*					pVertexBuffer;
	AccelerationStructure*	pBottomLevelAS;
	AccelerationStructure*	pTopLevelAS;
	RaytracingShader*		pShaderRayGen;
	RaytracingShader*		pShaderHit;
	RaytracingShader*		pShaderMiss;
	RootSignature*			pRootSignature;
	RaytracingPipeline*		pPipeline;
	RaytracingShaderTable*	pShaderTable;
	SwapChain*				pSwapChain;
	Texture*				pComputeOutput;
	Semaphore*				pRenderCompleteSemaphores[gImageCount];
	Semaphore*				pImageAcquiredSemaphore;
	GpuProfiler*			pGpuProfiler;
	uint32_t				mFrameIdx;
};

DEFINE_APPLICATION_MAIN(UnitTest_Triangle)