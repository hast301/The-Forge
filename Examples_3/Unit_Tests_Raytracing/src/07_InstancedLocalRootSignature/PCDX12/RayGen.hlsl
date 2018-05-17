RaytracingAccelerationStructure gRtScene : register(t0);
RWTexture2D<float4> gOutput : register(u0);

cbuffer gOffsetRootConstant : register(b0)
{
	float3 offset;
};

struct RayPayload
{
	float3 color;
};

[shader("raygeneration")]
void rayGen()
{
	uint2 launchIndex = DispatchRaysIndex();
	uint2 launchDim = DispatchRaysDimensions();

	float2 crd = float2(launchIndex);
	float2 dims = float2(launchDim);

	float2 d = ((crd / dims) * 2.f - 1.f);
	float aspectRatio = dims.x / dims.y;

	RayDesc ray;
	ray.Origin = float3(0, 0, -2) + offset;
	ray.Direction = normalize(float3(d.x * aspectRatio, -d.y, 1));

	ray.TMin = 0.001;
	ray.TMax = 10000;

	RayPayload payload;
	TraceRay(gRtScene, 0 /*rayFlags*/, 0xFF, 0 /* ray index*/, 0, 0, ray, payload);
	float3 col = payload.color;
	gOutput[launchIndex.xy] = float4(col, 1);
}
