#version 450 core

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


layout (location = 0) in float textcoord;

layout (location = 0) out vec4 oColor;

layout (set=0, binding=11) uniform texture2D uTex0[5];
layout (set=0, binding=3) uniform sampler uSampler0;

layout (set=0, binding=0) uniform uniformBlock {
	uniform mat4 viewProject;
};

layout(push_constant) uniform pushConstantBlock
{
    uniform float paletteFactor;
    uniform uint data;
	uniform uint textureIndex;
} particleRootConstant;

void main( void )
{
  vec2 tc = vec2(textcoord, 0.0f);
  vec4 ca = texture(sampler2D(uTex0[particleRootConstant.textureIndex], uSampler0), tc);
  vec4 cb = texture(sampler2D(uTex0[(particleRootConstant.textureIndex + 1) % 5], uSampler0), tc);
  oColor =  0.05f * mix(ca, cb, particleRootConstant.paletteFactor);
}
