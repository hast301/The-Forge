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

#define NK_INCLUDE_DEFAULT_ALLOCATOR
#define NK_IMPLEMENTATION

#include "NuklearGUIDriver.h"
#include "Fontstash.h"
#include "UIRenderer.h"

#include "../../Common_3/OS/Interfaces/IOperatingSystem.h"
#include "../../Common_3/OS/Interfaces/ILogManager.h"
#include "../../Common_3/ThirdParty/OpenSource/NuklearUI/nuklear.h"
#include "../../Common_3/Renderer/IRenderer.h"

#include "../../Common_3/OS/Interfaces/IMemoryManager.h" //NOTE: this should be the last include in a .cpp

void initGUIDriver(GUIDriver** ppDriver)
{
	NuklearGUIDriver* pDriver = conf_placement_new<NuklearGUIDriver>(conf_calloc(1, sizeof(NuklearGUIDriver)));
	pDriver->init();
	*ppDriver = pDriver;
}

void removeGUIDriver(GUIDriver* pDriver)
{
	pDriver->exit();
	(reinterpret_cast<NuklearGUIDriver*>(pDriver))->~NuklearGUIDriver();
	conf_free(pDriver);
}

struct InputInstruction
{
	enum Type
	{
		ITYPE_CHAR,
		ITYPE_KEY,
		ITYPE_JOYSTICK,
		ITYPE_MOUSEMOVE,
		ITYPE_MOUSECLICK,
		ITYPE_MOUSESCROLL,
	};
	Type type;
// Anonymous structures generates warnings in C++11. 
// See discussion here for more info: https://stackoverflow.com/questions/2253878/why-does-c-disallow-anonymous-structs
#pragma warning( push )
#pragma warning( disable : 4201) // warning C4201: nonstandard extension used: nameless struct/union
	union {
		struct { int mousex; int mousey; int mousebutton; bool mousedown; };
		struct { int scrollx; int scrolly; int scrollamount; };
		struct { int key; bool keydown; };
		struct { unsigned int charUnicode; };
		struct { int joystickbutton; bool joystickdown; };
	};
#pragma warning( pop )
};

static void changedProperty(UIProperty* pProp)
{
	if (pProp->callback)
		pProp->callback(pProp);
}

class _Impl_NuklearGUIDriver
{
public:
	struct nk_command_buffer queue;
	struct nk_cursor cursor;
	struct nk_context context;

	void* memory;

	UIRenderer* renderer;
	Fontstash* fontstash;
	int fontID;
	
	float width;
	float height;

	InputInstruction inputInstructions[2048];
	int inputInstructionCount;

	float fontCalibrationOffset;

	struct Font
	{
		_Impl_NuklearGUIDriver* driver;
		struct nk_user_font userFont;
		int fontID;
	};
	Font fontStack[128];
	UIProperty* pProps;
	uint32_t propCount;
	int32_t selectedID;
	int32_t minID;
	int32_t numberOfElements;
	int32_t scrollOffset;

	int currentFontStackPos;
	bool wantKeyboardInput;
	bool needKeyboardInputNextFrame;
	bool escWasPressed;

	void setSelectedIndex(int idx)
	{
		selectedID = idx;
		if (selectedID >= (int)propCount)
			selectedID = propCount - 1;
		if (selectedID < 0)
			selectedID = 0;

		int maxID = minID + numberOfElements;

		if (selectedID > maxID - scrollOffset)
			minID = selectedID + scrollOffset - numberOfElements;
		if (selectedID < minID + scrollOffset)
			minID = selectedID - scrollOffset + 1;

		maxID = minID + numberOfElements;

		if (minID < 0)
			minID = 0;
		if (maxID >= (int)propCount)
			minID = propCount - numberOfElements;
	}

	void goDirection(int down)
	{
		setSelectedIndex(selectedID + down);
	}

	void processJoystickDownState()
	{
#if !defined(TARGET_IOS) && !defined(LINUX)
		if (getJoystickButtonDown(BUTTON_LEFT))
		{
			pProps[selectedID].modify(-1);
			changedProperty(&pProps[selectedID]);
		}
		if (getJoystickButtonDown(BUTTON_RIGHT))
		{
			pProps[selectedID].modify(1);
			changedProperty(&pProps[selectedID]);
		}
#endif
	}
};

// font size callback
static float font_get_width(nk_handle handle, float h, const char *text, int len)
{
	float width;
	float bounds[4];
	_Impl_NuklearGUIDriver::Font* font = (_Impl_NuklearGUIDriver::Font*)handle.ptr;
	width = font->driver->fontstash->measureText(bounds, text, (int)len, 0.0f, 0.0f, font->fontID, 0xFFFFFFFF, h, 0.0f);
	return width;
}

bool NuklearGUIDriver::init()
{
	impl = conf_placement_new<_Impl_NuklearGUIDriver>(conf_calloc(1, sizeof(_Impl_NuklearGUIDriver)));
	impl->inputInstructionCount = 0;
	impl->fontCalibrationOffset = 0.0f;
	impl->currentFontStackPos = 0;

	impl->selectedID = 0;
	impl->minID = 0;
	impl->numberOfElements = 8;
	impl->scrollOffset = 3;

	return true;
}

void NuklearGUIDriver::exit()
{
	impl->~_Impl_NuklearGUIDriver();
	conf_free(impl);
}

void NuklearGUIDriver::setFontCalibration(float offset, float fontsize)
{
	impl->fontCalibrationOffset = offset;
	impl->fontStack[impl->currentFontStackPos].userFont.height = fontsize;
}

bool NuklearGUIDriver::load(UIRenderer* renderer, int fontID, float fontSize, Texture* cursorTexture, float uiwidth, float uiheight)
{
	// init renderer/font
	impl->renderer = renderer;
	impl->fontstash = renderer->getFontstash(fontID);
	impl->fontID = impl->fontstash->getFontID("default");

	// init UI (input)
	memset(&impl->context.input, 0, sizeof impl->context.input);

	// init UI (font)	
	impl->fontStack[impl->currentFontStackPos].driver = impl;
	impl->fontStack[impl->currentFontStackPos].fontID = impl->fontID;
	impl->fontStack[impl->currentFontStackPos].userFont.userdata.ptr = impl->fontStack + impl->currentFontStackPos;
	impl->fontStack[impl->currentFontStackPos].userFont.height = fontSize;
	impl->fontStack[impl->currentFontStackPos].userFont.width = font_get_width;
	++(impl->currentFontStackPos);

	// init UI (command queue & config)
	// Use nk_window_get_canvas 
	// nk_buffer_init_fixed(&impl->queue, impl->memoryScratchBuffer, sizeof(impl->memoryScratchBuffer));
	nk_init_default(&impl->context, &impl->fontStack[0].userFont);
	nk_style_default(&impl->context);

	if (cursorTexture != NULL)
	{
		// init Cursor Texture
		impl->cursor.img.handle.ptr = cursorTexture;
		impl->cursor.img.h = 1;
		impl->cursor.img.w = 1;
		impl->cursor.img.region[0] = 0;
		impl->cursor.img.region[1] = 0;
		impl->cursor.img.region[2] = 1;
		impl->cursor.img.region[3] = 1;
		impl->cursor.offset.x = 0;
		impl->cursor.offset.y = 0;
		impl->cursor.size.x = 32;
		impl->cursor.size.y = 32;

		for (nk_flags i = 0; i != NK_CURSOR_COUNT; i++)
		{
			nk_style_load_cursor(&impl->context, nk_style_cursor(i), &impl->cursor);
		}

	}
	nk_style_set_font(&impl->context, &impl->fontStack[0].userFont);

	// Height width
	impl->width = uiwidth;
	impl->height = uiheight;

	return true;
}

void NuklearGUIDriver::unload()
{
}

void* NuklearGUIDriver::getContext()
{
	return &impl->context;
}

void NuklearGUIDriver::onChar(const KeyboardCharEventData* data)
{
	if (impl->inputInstructionCount >= sizeof(impl->inputInstructions) / sizeof(impl->inputInstructions[0])) return;

	InputInstruction& is = impl->inputInstructions[impl->inputInstructionCount++];
	is.type = InputInstruction::ITYPE_CHAR;
	is.charUnicode = data->unicode;

	return;
}

void NuklearGUIDriver::onKey(const KeyboardButtonEventData* data)
{
	if (impl->inputInstructionCount >= sizeof(impl->inputInstructions) / sizeof(impl->inputInstructions[0])) return;

	InputInstruction& is = impl->inputInstructions[impl->inputInstructionCount++];
	is.type = InputInstruction::ITYPE_KEY;
	is.key = data->key;
	is.keydown = data->pressed;

#if !defined(_DURANGO) && !defined(TARGET_IOS)
	if (data->key == KEY_ESCAPE)
		impl->escWasPressed = data->pressed;
#endif
	return;
}

bool NuklearGUIDriver::onJoystick(int button, bool down)
{
	if (impl->inputInstructionCount >= sizeof(impl->inputInstructions) / sizeof(impl->inputInstructions[0])) return false;

	InputInstruction& is = impl->inputInstructions[impl->inputInstructionCount++];
	is.type = InputInstruction::ITYPE_JOYSTICK;
	is.joystickbutton = button;
	is.joystickdown = down;

	if (button == BUTTON_UP)
	{
		if (down)
			impl->goDirection(-1);

		return true;
	}

	if (button == BUTTON_DOWN)
	{
		if (down)
			impl->goDirection(1);

		return true;
	}

	return false;
}

void NuklearGUIDriver::onMouseMove(const MouseMoveEventData* data)
{
	if (impl->inputInstructionCount >= sizeof(impl->inputInstructions) / sizeof(impl->inputInstructions[0])) return;

	InputInstruction& is = impl->inputInstructions[impl->inputInstructionCount++];
	is.type = InputInstruction::ITYPE_MOUSEMOVE;
	is.mousex = data->x;
	is.mousey = data->y;

	return;
}

void NuklearGUIDriver::onMouseClick(const MouseButtonEventData* data)
{
	if (impl->inputInstructionCount >= sizeof(impl->inputInstructions) / sizeof(impl->inputInstructions[0])) return;

	InputInstruction& is = impl->inputInstructions[impl->inputInstructionCount++];
	is.type = InputInstruction::ITYPE_MOUSECLICK;
	is.mousex = data->x;
	is.mousey = data->y;
	is.mousebutton = data->button;
	is.mousedown = data->pressed;
	return;
}


void NuklearGUIDriver::onMouseScroll(const MouseWheelEventData* data)
{
	if (impl->inputInstructionCount >= sizeof(impl->inputInstructions) / sizeof(impl->inputInstructions[0])) return;

	InputInstruction& is = impl->inputInstructions[impl->inputInstructionCount++];
	is.type = InputInstruction::ITYPE_MOUSESCROLL;
	is.scrollx = data->x;
	is.scrolly = data->y;
	is.scrollamount = data->scroll;
	return;
}

void NuklearGUIDriver::processInput()
{
#if !defined(TARGET_IOS)
#if !defined(_DURANGO)
	const static int KeyIndex[] =
	{
		0,
		KEY_SHIFT,
		KEY_CTRL,
		KEY_DELETE,
		KEY_ENTER,
		KEY_TAB,
		KEY_BACKSPACE,
		0,//NK_KEY_COPY,
		0,//NK_KEY_CUT,
		0,//NK_KEY_PASTE,
		KEY_UP,
		KEY_DOWN,
		KEY_LEFT,
		KEY_RIGHT,
	};
#endif
	nk_input_begin(&impl->context);

	for (int i = 0; i < impl->inputInstructionCount; i++)
	{
		InputInstruction& is = impl->inputInstructions[i];
		switch (is.type)
		{
		case InputInstruction::ITYPE_MOUSEMOVE:
			nk_input_motion(&impl->context, is.mousex, is.mousey);
			break;
		case InputInstruction::ITYPE_MOUSECLICK:
			if (is.mousebutton != MOUSE_LEFT)
				break;
			nk_input_button(&impl->context, NK_BUTTON_LEFT, is.mousex, is.mousey, is.mousedown ? nk_true : nk_false);
			break;
		case InputInstruction::ITYPE_MOUSESCROLL:
			nk_input_scroll(&impl->context, nk_vec2(0.0f, float(is.scrollamount)));
			break;
		case InputInstruction::ITYPE_CHAR:
		{
			if(is.charUnicode >= 32)
				nk_input_unicode(&impl->context, is.charUnicode);
		}
		break;
#if !defined(_DURANGO)
		case InputInstruction::ITYPE_KEY:
		{
			for (uint i = 0; i < 14; ++i)
			{
				if (KeyIndex[i] == is.key && KeyIndex[i] != 0)
				{
					nk_input_key(&impl->context, nk_keys(i), is.keydown);
					break;
				}
			}
		}
		break;
#endif
		case InputInstruction::ITYPE_JOYSTICK:
			impl->processJoystickDownState();
			break;
		default:
			break;
		}
	}

	nk_input_end(&impl->context);

	// reset instruction counter
	impl->inputInstructionCount = 0;
#else
//	ASSERT(false && "Unsupported on target iOS");
#endif
}

void NuklearGUIDriver::clear()
{
	nk_clear(&impl->context);
}



inline void AddProperty(_Impl_NuklearGUIDriver* impl, UIProperty& pProp, uint32_t propCount, float w)
{

	UIProperty& prop = pProp;

	if (!(prop.flags & UIProperty::FLAG_VISIBLE))
		return;

	if (!prop.source)
		return;

	//width of window divided by max columns, taking into account padding
	float colWidth = w / 3 - 12;
	int cols = 2;
	switch (prop.type)
	{
	case UI_PROPERTY_FLOAT:
	case UI_PROPERTY_INT:
	case UI_PROPERTY_UINT:
		cols = 3;
		break;
	default:
		break;
	}

	nk_layout_row_begin(&impl->context, NK_STATIC, 30.f, cols);
	nk_layout_row_push(&impl->context, colWidth);

	// Translate colours back by bitshifting
	nk_color col;
	col.r = (prop.color & 0xFF000000) >> 24;
	col.g = (prop.color & 0x00FF0000) >> 16;
	col.b = (prop.color & 0x0000FF00) >> 8;
	col.a = (prop.color & 0x000000FF);

	nk_label_colored_wrap(&impl->context, prop.description, nk_color(col));
	nk_layout_row_push(&impl->context, cols == 2 ? 2 * colWidth : colWidth);
	switch (prop.type)
	{
	case UI_PROPERTY_TEXT:
	{
		break;
	}

	case UI_PROPERTY_FLOAT:
	{
		float& currentValue = *(float*)prop.source;
		float oldValue = currentValue;
		nk_slider_float(&impl->context, prop.settings.fMin, (float*)prop.source, prop.settings.fMax, prop.settings.fIncrement);
		if (impl->wantKeyboardInput)
			currentValue = oldValue;

		// * edit box
		char buffer[200];
		sprintf(buffer, "%.3f", currentValue);
		//nk_property_float(&impl->context, prop.description, prop.settings.fMin, (float*)prop.source, prop.settings.fMax, prop.settings.fIncrement, prop.settings.fIncrement / 10);
		nk_flags result_flags = nk_edit_string_zero_terminated(&impl->context, NK_EDIT_FIELD | NK_EDIT_AUTO_SELECT | NK_EDIT_SIG_ENTER, buffer, 200, nk_filter_float);
		if (result_flags == NK_EDIT_ACTIVE)
			impl->needKeyboardInputNextFrame = true;

		if (result_flags != NK_EDIT_INACTIVE)
		{
			impl->needKeyboardInputNextFrame = false;
			currentValue = (float)atof(buffer);
		}


		if (result_flags & NK_EDIT_COMMITED || impl->escWasPressed)
			nk_edit_unfocus(&impl->context);

		// actualize changes
		if (currentValue != oldValue)
		{
			changedProperty(&prop);
		}

		break;
	}
	case UI_PROPERTY_INT:
	{
		int& currentValue = *(int*)prop.source;

		int oldValue = currentValue;
		nk_slider_int(&impl->context, prop.settings.iMin, (int*)prop.source, prop.settings.iMax, prop.settings.iIncrement);
		if (impl->wantKeyboardInput)
			currentValue = oldValue;
		// * edit box
		char buffer[200];
		sprintf(buffer, "%i", currentValue);
		nk_flags result_flags = nk_edit_string_zero_terminated(&impl->context, NK_EDIT_FIELD | NK_EDIT_AUTO_SELECT | NK_EDIT_SIG_ENTER, buffer, 200, nk_filter_decimal);
		if (result_flags == NK_EDIT_ACTIVE)
			impl->needKeyboardInputNextFrame = true;

		if (result_flags != NK_EDIT_INACTIVE)
		{
			impl->needKeyboardInputNextFrame = false;
			currentValue = (int)atoi(buffer);
		}

		if (result_flags & NK_EDIT_COMMITED || impl->escWasPressed)
			nk_edit_unfocus(&impl->context);

		// actualize changes
		if (currentValue != oldValue)
		{
			changedProperty(&prop);
		}
		break;
	}

	case UI_PROPERTY_UINT:
	{
		int& currentValue = *(int*)prop.source;
		int oldValue = currentValue;
		nk_slider_int(&impl->context, prop.settings.uiMin > 0 ? prop.settings.uiMin : 0, (int*)prop.source, prop.settings.uiMax, prop.settings.iIncrement);
		if (impl->wantKeyboardInput)
			currentValue = oldValue;
		// * edit box
		char buffer[200];
		sprintf(buffer, "%u", currentValue);
		nk_flags result_flags = nk_edit_string_zero_terminated(&impl->context, NK_EDIT_FIELD | NK_EDIT_AUTO_SELECT | NK_EDIT_SIG_ENTER, buffer, 200, nk_filter_decimal);
		if (result_flags == NK_EDIT_ACTIVE)
			impl->needKeyboardInputNextFrame = true;

		if (result_flags != NK_EDIT_INACTIVE)
		{
			impl->needKeyboardInputNextFrame = false;
			currentValue = (int)atoi(buffer);
		}


		if (result_flags & NK_EDIT_COMMITED || impl->escWasPressed)
			nk_edit_unfocus(&impl->context);

		// actualize changes
		if (currentValue != oldValue)
		{
			changedProperty(&prop);
		}

		break;
	}
	case UI_PROPERTY_BOOL:
	{
		bool& currentValue = *(bool*)prop.source;
		int value = (currentValue) ? 0 : 1;
		nk_checkbox_label(&impl->context, currentValue ? "True" : "False", &value);
		if (currentValue != (value == 0))
		{
			currentValue = (value == 0);
			changedProperty(&prop);
		}
		break;
	}
	case UI_PROPERTY_ENUM:
	{
		ASSERT(prop.settings.eByteSize == 4);

		int current = prop.enumComputeIndex();
		int previous = current;
		int cnt = 0;
		for (int vi = 0; prop.settings.eNames[vi] != 0; vi++)
			cnt = (int)vi;

		nk_combobox(&impl->context, prop.settings.eNames, cnt + 1, &current, 16, nk_vec2(colWidth * 2, 16 * 5));

		if (previous != current)
		{
			*(int*)prop.source = ((int*)prop.settings.eValues)[current];
			changedProperty(&prop);
		}
		break;
	}
	case UI_PROPERTY_BUTTON:
	{
		if (nk_button_label(&impl->context, prop.description))
		{
			if (prop.source)
				((UIButtonFn)prop.source)(prop.settings.pUserData);
			changedProperty(&prop);
		}
		break;
	}
	case UI_PROPERTY_TEXTINPUT:
	{
		nk_flags result_flags = nk_edit_string_zero_terminated(&impl->context, NK_EDIT_FIELD | NK_EDIT_AUTO_SELECT, (char*)prop.source, prop.settings.sLen, nk_filter_ascii);
		if (result_flags == NK_EDIT_ACTIVE)
		{
			impl->needKeyboardInputNextFrame = true;
		}

		if (result_flags & NK_EDIT_COMMITED || impl->escWasPressed)
		{
			nk_edit_unfocus(&impl->context);
			changedProperty(&prop);
		}
	}
	}
		
}

void NuklearGUIDriver::window(const char* pTitle,
	float x, float y, float w, float h,
	float& oX, float& oY, float& oW, float& oH,
	UIProperty* pProps, unsigned int propCount)
{
	impl->pProps = pProps;
	impl->propCount = (uint32_t)propCount;

	int result = nk_begin(&impl->context, pTitle, nk_rect(x, y, w, h),
		NK_WINDOW_BORDER | NK_WINDOW_MOVABLE | NK_WINDOW_SCALABLE | NK_WINDOW_MINIMIZABLE | NK_WINDOW_TITLE);
	
	// Trees are indexed based on name with a list of the properties part of the tree
	tinystl::unordered_map<const char*, tinystl::vector<UIProperty>> map;

	struct nk_rect r = nk_window_get_bounds(&impl->context);
	if (!result)
	{
		r.h = nk_window_get_panel(&impl->context)->header_height;
	}
	oX = r.x;
	oY = r.y;
	oW = r.w;
	oH = r.h;
	if (result)
	{
		for (uint32_t i = 0; i < propCount; ++i)
		{
			// If no tree, just add property
			if (pProps[i].tree == "none")
			{
				AddProperty(impl, pProps[i], propCount, w);
			}

			// if there is a tree, map the properties to their respective tree index
			else
			{
				map[pProps[i].tree].push_back(pProps[i]);
			}
		
		}
	
		// This ID is to make sure that trees do not share same ID's
		int id = 0;
		// Go through all the trees and add the properties for every tree 
		for (tinystl::unordered_hash_iterator<tinystl::unordered_hash_node<char const*, tinystl::vector<UIProperty>>> local_it = map.begin(); local_it != map.end(); ++local_it)
		{
			// Every tree has their own unique ID
			++id;
			
			// begin 
			if (nk_tree_push_id(&impl->context, NK_TREE_TAB, local_it.node->first, NK_MINIMIZED, id)) {
				
				for (int i = 0; i < local_it.node->second.size(); ++i)
				{
					AddProperty(impl, local_it.node->second[i], propCount, w);
				}

				// all code between push and pop will be seen as part of the UI tree
				nk_tree_pop(&impl->context);

			}
		}
	}

	nk_end(&impl->context);

	impl->wantKeyboardInput = impl->needKeyboardInputNextFrame;
}

void NuklearGUIDriver::draw(Cmd* pCmd)
{
	static const int CircleEdgeCount = 10;

#ifdef _DURANGO
	{
		// Search for the currently selected property and change it's color to indicate selection status
		const struct nk_command* cmd;
		for ((cmd) = nk__begin(&impl->context); (cmd) != 0; (cmd) = nk__next(&impl->context, cmd))
		{
			if (cmd->type == NK_COMMAND_TEXT)
			{
				struct nk_command_text *textCommand = (struct nk_command_text*)cmd;
				if (strcmp((const char*)textCommand->string, impl->pProps[impl->selectedID].description) == 0)
				{
					// change color to indicate selection status
					textCommand->foreground.r = 1;
					textCommand->foreground.g = 1;
					textCommand->foreground.b = 1;
				}
			}
		}
}
#endif
	
	const struct nk_command *cmd;
	/* iterate over and execute each draw command except the text */
	nk_foreach(cmd, &impl->context)
	{
		switch (cmd->type)
		{
		case NK_COMMAND_NOP:
			break;
		case NK_COMMAND_SCISSOR:
		{
			const struct nk_command_scissor *s = (const struct nk_command_scissor*)cmd;
			RectDesc scissorRect;
			scissorRect.left = s->x;
			scissorRect.right = s->x + s->w;
			scissorRect.top = s->y;
			scissorRect.bottom = s->y + s->h;
			impl->renderer->setScissor(pCmd, &scissorRect);
			break;
		}
		case NK_COMMAND_LINE:
		{
			const struct nk_command_line *l = (const struct nk_command_line*)cmd;
			const float lineOffset = float(l->line_thickness) / 2;
			// thick line support
			const vec2 begin = vec2(l->begin.x, l->begin.y);
			const vec2 end = vec2(l->end.x, l->end.y);
			const vec2 normal = normalize(end - begin);
			const vec2 binormal = vec2(normal.getY(), -normal.getX()) * lineOffset;
			float2 vertices[] = 
			{
				v2ToF2(begin + binormal), v2ToF2(end + binormal),
				v2ToF2(begin - binormal), v2ToF2(end - binormal)
			};
			float4 color = float4((float)l->color.r / 255.0f, (float)l->color.g / 255.0f, (float)l->color.b / 255.0f, (float)l->color.a / 255.0f);
			impl->renderer->drawPlain(pCmd, PRIMITIVE_TOPO_TRI_STRIP, vertices, 4, &color);
			break;
		}
		case NK_COMMAND_RECT:
		{
			const struct nk_command_rect *r = (const struct nk_command_rect*)cmd;
			float lineOffset = float(r->line_thickness);
			// thick line support
			float2 vertices[] = 
			{ 
				// top-left
				float2(r->x - lineOffset, r->y - lineOffset), float2(r->x + lineOffset, r->y + lineOffset),
				
				// top-right
				float2(r->x + r->w + lineOffset, r->y - lineOffset), float2(r->x + r->w - lineOffset, r->y + lineOffset),

				// bottom-right
				float2(r->x + r->w + lineOffset, r->y + r->h + lineOffset), float2(r->x + r->w - lineOffset, r->y + r->h - lineOffset),

				// bottom-left
				float2(r->x - lineOffset, r->y + r->h + lineOffset), float2(r->x + lineOffset, r->y + r->h - lineOffset),

				// top-left
				float2(r->x - lineOffset, r->y - lineOffset), float2(r->x + lineOffset, r->y + lineOffset),
			};
			float4 color = float4((float)r->color.r / 255.0f, (float)r->color.g / 255.0f, (float)r->color.b / 255.0f, (float)r->color.a / 255.0f);
			impl->renderer->drawPlain(pCmd, PRIMITIVE_TOPO_TRI_STRIP, vertices, 10, &color);
			break;
		}
		case NK_COMMAND_RECT_FILLED:
		{
			const struct nk_command_rect_filled *r = (const struct nk_command_rect_filled*)cmd;
			float2 vertices[] = { MAKEQUAD(r->x, r->y, r->x + r->w, r->y + r->h, 0.0f) };
			float4 color = float4((float)r->color.r / 255.0f, (float)r->color.g / 255.0f, (float)r->color.b / 255.0f, (float)r->color.a / 255.0f);
			impl->renderer->drawPlain(pCmd, PRIMITIVE_TOPO_TRI_STRIP, vertices, 4, &color);
			break;
		}
		case NK_COMMAND_CIRCLE:
		{
			const struct nk_command_circle *r = (const struct nk_command_circle*)cmd;
			// thick line support
			const float lineOffset = float(r->line_thickness) / 2;
			const float hw = (float)r->w / 2.0f;
			const float hh = (float)r->h / 2.0f;
			const float2 center = float2(r->x + hw, r->y + hh);

			float2 vertices[(CircleEdgeCount + 1) * 2];
			float t = 0;
			for (uint i = 0; i < CircleEdgeCount + 1; ++i)
			{
				const float dt = (2 * PI) / CircleEdgeCount;
				vertices[i * 2 + 0] = center + float2(cosf(t) * (hw + lineOffset), sinf(t) * (hh + lineOffset));
				vertices[i * 2 + 1] = center + float2(cosf(t) * (hw - lineOffset), sinf(t) * (hh - lineOffset));
				t += dt;
			}

			float4 color = float4((float)r->color.r / 255.0f, (float)r->color.g / 255.0f, (float)r->color.b / 255.0f, (float)r->color.a / 255.0f);
			impl->renderer->drawPlain(pCmd, PRIMITIVE_TOPO_TRI_STRIP, vertices, (CircleEdgeCount + 1) * 2, &color);
			break;
		}
		case NK_COMMAND_CIRCLE_FILLED:
		{
			const struct nk_command_circle_filled *r = (const struct nk_command_circle_filled*)cmd;
			const float hw = (float)r->w / 2.0f;
			const float hh = (float)r->h / 2.0f;
			const float2 center = float2(r->x + hw, r->y + hh);
			
			float2 vertices[(CircleEdgeCount) * 2 + 1];
			float t = 0;
			for (uint i = 0; i < CircleEdgeCount; ++i)
			{
				const float dt = (2 * PI) / CircleEdgeCount;
				vertices[i * 2 + 0] = center + float2(cosf(t) * hw, sinf(t) * hh);
				vertices[i * 2 + 1] = center;
				t += dt;
			}
			// set last point on circle
			vertices[CircleEdgeCount * 2] = vertices[0];

			float4 color = float4((float)r->color.r / 255.0f, (float)r->color.g / 255.0f, (float)r->color.b / 255.0f, (float)r->color.a / 255.0f);
			impl->renderer->drawPlain(pCmd, PRIMITIVE_TOPO_TRI_STRIP, vertices, CircleEdgeCount * 2 + 1, &color);
			break;
		}
		case NK_COMMAND_TRIANGLE:
		{
			//const struct nk_command_triangle *r = (const struct nk_command_triangle*)cmd;
			//vec2 vertices[] = { vec2(r->a.x, r->a.y), vec2(r->b.x, r->b.y), vec2(r->c.x, r->c.y) };
			//vec4 color[] = { vec4((float)r->color.r / 255.0f, (float)r->color.g / 255.0f, (float)r->color.b / 255.0f, (float)r->color.a / 255.0f) };
			//impl->renderer->drawPlain(PRIM_LINE_LOOP, vertices, 3, impl->bstAlphaBlend, impl->dstNone, color, impl->rstScissorNoCull);
			break;
		}
		case NK_COMMAND_TRIANGLE_FILLED:
		{
			const struct nk_command_triangle_filled *r = (const struct nk_command_triangle_filled*)cmd;
			float2 vertices[] = { float2(r->a.x, r->a.y), float2(r->b.x, r->b.y), float2(r->c.x, r->c.y) };
			float4 color = float4((float)r->color.r / 255.0f, (float)r->color.g / 255.0f, (float)r->color.b / 255.0f, (float)r->color.a / 255.0f);
			impl->renderer->drawPlain(pCmd, PRIMITIVE_TOPO_TRI_LIST, vertices, 3, &color);
			break;
		}
		case NK_COMMAND_IMAGE:
		{
			const struct nk_command_image *r = (const struct nk_command_image*)cmd;

			float2 RegionTopLeft(float2((float)r->x, (float)r->y));
			float2 RegionBottonLeft(RegionTopLeft + float2(0, r->h));
			float2 RegionTopRight(RegionTopLeft + float2(r->w, 0));
			float2 RegionBottonRight(RegionTopLeft + float2(r->w, r->h));

			float2 texCoord[4] = {
				float2(float(r->img.region[0] + r->img.region[3]) / r->img.w, float(r->img.region[1] + r->img.region[2]) / r->img.h),
				float2(float(r->img.region[0] + r->img.region[3]) / r->img.w, float(r->img.region[1]) / r->img.h),
				float2(float(r->img.region[0]) / r->img.w, float(r->img.region[1] + r->img.region[2]) / r->img.h),
				float2(float(r->img.region[0]) / r->img.w, float(r->img.region[1]) / r->img.h)
			};

			TexVertex vertices[4] = { TexVertex(RegionBottonRight, texCoord[0]),
																TexVertex(RegionTopRight, texCoord[1]),
																TexVertex(RegionBottonLeft, texCoord[2]),
																TexVertex(RegionTopLeft, texCoord[3]) };

			float4 color = float4((float)r->col.r / 255.0f, (float)r->col.g / 255.0f, (float)r->col.b / 255.0f, (float)r->col.a / 255.0f);
			impl->renderer->drawTextured(pCmd, PRIMITIVE_TOPO_TRI_STRIP, vertices, 4, (Texture*)r->img.handle.ptr, &color);

			break;
		}
		case NK_COMMAND_TEXT:
		{
			const struct nk_command_text *r = (const struct nk_command_text*)cmd;
			float2 vertices[] = { MAKEQUAD(r->x, r->y + impl->fontCalibrationOffset, r->x + r->w, r->y + r->h + impl->fontCalibrationOffset, 0.0f) };
			float4 color = float4((float)r->background.r / 255.0f, (float)r->background.g / 255.0f, (float)r->background.b / 255.0f, (float)r->background.a / 255.0f);

			impl->renderer->drawPlain(pCmd, PRIMITIVE_TOPO_TRI_STRIP, vertices, 4, &color);
			_Impl_NuklearGUIDriver::Font* font = (_Impl_NuklearGUIDriver::Font*)r->font->userdata.ptr;
			impl->fontstash->drawText(pCmd, r->string, r->x, r->y + impl->fontCalibrationOffset, font->fontID, *(unsigned int*)&r->foreground, r->font->height, 0.0f, 0.0f);
			
			break;
		}
		default:
			break;
		}
	}
}
