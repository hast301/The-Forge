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

#ifdef __linux__

#include "../Interfaces/IFileSystem.h"
#include "../Interfaces/ILogManager.h"
#include "../Interfaces/IOperatingSystem.h"
#include "../Interfaces/IMemoryManager.h"

#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <pwd.h>
#include <linux/limits.h> //PATH_MAX declaration
#define MAX_PATH PATH_MAX

FileHandle _openFile(const char* filename, const char* flags)
{
	FILE* fp;
	fp = fopen(filename, flags);
	return fp;
}

void _closeFile(FileHandle handle)
{
	fclose((::FILE*)handle);
}

void _flushFile(FileHandle handle)
{
	fflush((::FILE*)handle);
}

size_t _readFile(void *buffer, size_t byteCount, FileHandle handle)
{
	return fread(buffer, 1, byteCount, (::FILE*)handle);
}

bool _seekFile(FileHandle handle, long offset, int origin)
{
	return fseek((::FILE*)handle, offset, origin) == 0;
}

long _tellFile(FileHandle handle)
{
	return ftell((::FILE*)handle);
}

size_t _writeFile(const void *buffer, size_t byteCount, FileHandle handle)
{
	return fwrite(buffer, byteCount, 1, (::FILE*)handle);
}

size_t _getFileLastModifiedTime(const char* _fileName)
{
	struct stat fileInfo;

	if (!stat(_fileName, &fileInfo))
	{
		return (size_t)fileInfo.st_mtime;
	}
	else
	{
		// return an impossible large mod time as the file doesn't exist
		return ~0;
	}
}

String _getCurrentDir()
{
	char curDir[MAX_PATH];
	getcwd(curDir, sizeof(curDir));
	return String (curDir);
}

String _getExePath()
{
	char exeName[MAX_PATH];
	exeName[0] = 0;
	ssize_t count = readlink( "/proc/self/exe", exeName, MAX_PATH );
	return String(exeName);
}

String _getAppPrefsDir(const char *org, const char *app)
{
	const char* homedir;

	if ((homedir = getenv("HOME")) == NULL) 
	{
		homedir = getpwuid(getuid())->pw_dir;
	}
	return String(homedir);
}

String _getUserDocumentsDir()
{
	const char* homedir;
	if ((homedir = getenv("HOME")) == NULL) 
	{
		homedir = getpwuid(getuid())->pw_dir;
	}
	String homeString = String(homedir);
	const char* doc = "Documents";
	homeString.append(doc, doc + strlen(doc));
	return homeString;
}

void _setCurrentDir(const char* path)
{
	// change working directory
	// http://man7.org/linux/man-pages/man2/chdir.2.html
	chdir(path);
}

#endif