##
## Auto Generated makefile by CodeLite IDE
## any manual changes will be erased      
##
## Debug
ProjectName            :=OS
ConfigurationName      :=Debug
WorkspacePath          :="./"
ProjectPath            :="OSBase/"
IntermediateDirectory  :=./Debug
OutDir                 := $(IntermediateDirectory)
CurrentFileName        :=
CurrentFilePath        :=
CurrentFileFullPath    :=
User                   :=Confetti
Date                   :=25/05/18
CodeLitePath           :=/home/confetti/.codelite
LinkerName             :=g++
SharedObjectLinkerName :=g++ -shared -fPIC
ObjectSuffix           :=.o
DependSuffix           :=.o.d
PreprocessSuffix       :=.o.i
DebugSwitch            :=-gstab
IncludeSwitch          :=-I
LibrarySwitch          :=-l
OutputSwitch           :=-o 
LibraryPathSwitch      :=-L
PreprocessorSwitch     :=-D
SourceSwitch           :=-c 
OutputFile             :=$(IntermediateDirectory)/lib$(ProjectName).a
Preprocessors          :=$(PreprocessorSwitch)LINUX $(PreprocessorSwitch)VULKAN $(PreprocessorSwitch)_DEBUG 
ObjectSwitch           :=-o 
ArchiveOutputSwitch    := 
PreprocessOnlySwitch   :=-E 
ObjectsFileList        :="OS.txt"
PCHCompileFlags        :=
MakeDirCommand         :=mkdir -p
LinkOptions            :=  
IncludePath            :=  $(IncludeSwitch). $(IncludeSwitch). $(IncludeSwitch)$(VULKAN_SDK)/include/ 
IncludePCH             := 
RcIncludePath          := 
Libs                   := 
ArLibs                 :=  
LibPath                := $(LibraryPathSwitch). 

##
## Common variables
## AR, CXX, CC, AS, CXXFLAGS and CFLAGS can be overriden using an environment variables
##
AR       := ar rcus
CXX      := g++
CC       := gcc
CXXFLAGS :=  -g  -std=c++11  $(Preprocessors)
CFLAGS   :=  -g $(Preprocessors)
ASFLAGS  := 
AS       := as


##
## User defined environment variables
##
CodeLiteDir:=/usr/share/codelite
Objects0=$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Linux_LinuxThreadManager.cpp$(ObjectSuffix) $(IntermediateDirectory)/up_up_up_up_Common_3_OS_Linux_LinuxFileSystem.cpp$(ObjectSuffix) $(IntermediateDirectory)/up_up_up_up_Common_3_ThirdParty_OpenSource_TinyEXR_tinyexr.cpp$(ObjectSuffix) $(IntermediateDirectory)/up_up_up_up_Common_3_OS_Image_Image.cpp$(ObjectSuffix) $(IntermediateDirectory)/up_up_up_up_Middleware_3_UI_AppUI.cpp$(ObjectSuffix) $(IntermediateDirectory)/up_up_up_up_Middleware_3_UI_Fontstash.cpp$(ObjectSuffix) $(IntermediateDirectory)/up_up_up_up_Common_3_OS_Camera_FpsCameraController.cpp$(ObjectSuffix) $(IntermediateDirectory)/up_up_up_up_Common_3_OS_Core_DebugRenderer.cpp$(ObjectSuffix) $(IntermediateDirectory)/up_up_up_up_Common_3_OS_Linux_LinuxBase.cpp$(ObjectSuffix) $(IntermediateDirectory)/up_up_up_up_Common_3_OS_Linux_LinuxLogManager.cpp$(ObjectSuffix) \
	$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Core_ThreadSystem.cpp$(ObjectSuffix) $(IntermediateDirectory)/up_up_up_up_Common_3_OS_Camera_GuiCameraController.cpp$(ObjectSuffix) $(IntermediateDirectory)/up_up_up_up_Common_3_OS_Core_FileSystem.cpp$(ObjectSuffix) $(IntermediateDirectory)/up_up_up_up_Common_3_OS_Logging_LogManager.cpp$(ObjectSuffix) $(IntermediateDirectory)/up_up_up_up_Common_3_OS_Core_PlatformEvents.cpp$(ObjectSuffix) $(IntermediateDirectory)/up_up_up_up_Common_3_OS_Core_Timer.cpp$(ObjectSuffix) $(IntermediateDirectory)/up_up_up_up_Middleware_3_UI_UIRenderer.cpp$(ObjectSuffix) $(IntermediateDirectory)/up_up_up_up_Common_3_OS_MemoryTracking_MemoryTrackingManager.cpp$(ObjectSuffix) $(IntermediateDirectory)/up_up_up_up_Middleware_3_UI_NuklearGUIDriver.cpp$(ObjectSuffix) 



Objects=$(Objects0) 

##
## Main Build Targets 
##
.PHONY: all clean PreBuild PrePreBuild PostBuild MakeIntermediateDirs
all: $(IntermediateDirectory) $(OutputFile)

$(OutputFile): $(Objects)
	@$(MakeDirCommand) $(@D)
	@echo "" > $(IntermediateDirectory)/.d
	@echo $(Objects0)  > $(ObjectsFileList)
	$(AR) $(ArchiveOutputSwitch)$(OutputFile) @$(ObjectsFileList) $(ArLibs)
	@$(MakeDirCommand) ".build-release"
	@echo rebuilt > ".build-release/OS"

MakeIntermediateDirs:
	@test -d ./Debug || $(MakeDirCommand) ./Debug


./Debug:
	@test -d ./Debug || $(MakeDirCommand) ./Debug

PreBuild:


##
## Objects
##
$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Linux_LinuxThreadManager.cpp$(ObjectSuffix): ../../../../Common_3/OS/Linux/LinuxThreadManager.cpp $(IntermediateDirectory)/up_up_up_up_Common_3_OS_Linux_LinuxThreadManager.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "../../../../Common_3/OS/Linux/LinuxThreadManager.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Linux_LinuxThreadManager.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Linux_LinuxThreadManager.cpp$(DependSuffix): ../../../../Common_3/OS/Linux/LinuxThreadManager.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Linux_LinuxThreadManager.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Linux_LinuxThreadManager.cpp$(DependSuffix) -MM ../../../../Common_3/OS/Linux/LinuxThreadManager.cpp

$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Linux_LinuxThreadManager.cpp$(PreprocessSuffix): ../../../../Common_3/OS/Linux/LinuxThreadManager.cpp
	$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/up_up_up_up_Common_3_OS_Linux_LinuxThreadManager.cpp$(PreprocessSuffix) ../../../../Common_3/OS/Linux/LinuxThreadManager.cpp

$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Linux_LinuxFileSystem.cpp$(ObjectSuffix): ../../../../Common_3/OS/Linux/LinuxFileSystem.cpp $(IntermediateDirectory)/up_up_up_up_Common_3_OS_Linux_LinuxFileSystem.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "../../../../Common_3/OS/Linux/LinuxFileSystem.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Linux_LinuxFileSystem.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Linux_LinuxFileSystem.cpp$(DependSuffix): ../../../../Common_3/OS/Linux/LinuxFileSystem.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Linux_LinuxFileSystem.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Linux_LinuxFileSystem.cpp$(DependSuffix) -MM ../../../../Common_3/OS/Linux/LinuxFileSystem.cpp

$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Linux_LinuxFileSystem.cpp$(PreprocessSuffix): ../../../../Common_3/OS/Linux/LinuxFileSystem.cpp
	$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/up_up_up_up_Common_3_OS_Linux_LinuxFileSystem.cpp$(PreprocessSuffix) ../../../../Common_3/OS/Linux/LinuxFileSystem.cpp

$(IntermediateDirectory)/up_up_up_up_Common_3_ThirdParty_OpenSource_TinyEXR_tinyexr.cpp$(ObjectSuffix): ../../../../Common_3/ThirdParty/OpenSource/TinyEXR/tinyexr.cpp $(IntermediateDirectory)/up_up_up_up_Common_3_ThirdParty_OpenSource_TinyEXR_tinyexr.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "../../../../Common_3/ThirdParty/OpenSource/TinyEXR/tinyexr.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/up_up_up_up_Common_3_ThirdParty_OpenSource_TinyEXR_tinyexr.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/up_up_up_up_Common_3_ThirdParty_OpenSource_TinyEXR_tinyexr.cpp$(DependSuffix): ../../../../Common_3/ThirdParty/OpenSource/TinyEXR/tinyexr.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/up_up_up_up_Common_3_ThirdParty_OpenSource_TinyEXR_tinyexr.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/up_up_up_up_Common_3_ThirdParty_OpenSource_TinyEXR_tinyexr.cpp$(DependSuffix) -MM ../../../../Common_3/ThirdParty/OpenSource/TinyEXR/tinyexr.cpp

$(IntermediateDirectory)/up_up_up_up_Common_3_ThirdParty_OpenSource_TinyEXR_tinyexr.cpp$(PreprocessSuffix): ../../../../Common_3/ThirdParty/OpenSource/TinyEXR/tinyexr.cpp
	$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/up_up_up_up_Common_3_ThirdParty_OpenSource_TinyEXR_tinyexr.cpp$(PreprocessSuffix) ../../../../Common_3/ThirdParty/OpenSource/TinyEXR/tinyexr.cpp

$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Image_Image.cpp$(ObjectSuffix): ../../../../Common_3/OS/Image/Image.cpp $(IntermediateDirectory)/up_up_up_up_Common_3_OS_Image_Image.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "../../../../Common_3/OS/Image/Image.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Image_Image.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Image_Image.cpp$(DependSuffix): ../../../../Common_3/OS/Image/Image.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Image_Image.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Image_Image.cpp$(DependSuffix) -MM ../../../../Common_3/OS/Image/Image.cpp

$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Image_Image.cpp$(PreprocessSuffix): ../../../../Common_3/OS/Image/Image.cpp
	$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/up_up_up_up_Common_3_OS_Image_Image.cpp$(PreprocessSuffix) ../../../../Common_3/OS/Image/Image.cpp

$(IntermediateDirectory)/up_up_up_up_Middleware_3_UI_AppUI.cpp$(ObjectSuffix): ../../../../Middleware_3/UI/AppUI.cpp $(IntermediateDirectory)/up_up_up_up_Middleware_3_UI_AppUI.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "../../../../Middleware_3/UI/AppUI.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/up_up_up_up_Middleware_3_UI_AppUI.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/up_up_up_up_Middleware_3_UI_AppUI.cpp$(DependSuffix): ../../../../Middleware_3/UI/AppUI.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/up_up_up_up_Middleware_3_UI_AppUI.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/up_up_up_up_Middleware_3_UI_AppUI.cpp$(DependSuffix) -MM ../../../../Middleware_3/UI/AppUI.cpp

$(IntermediateDirectory)/up_up_up_up_Middleware_3_UI_AppUI.cpp$(PreprocessSuffix): ../../../../Middleware_3/UI/AppUI.cpp
	$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/up_up_up_up_Middleware_3_UI_AppUI.cpp$(PreprocessSuffix) ../../../../Middleware_3/UI/AppUI.cpp

$(IntermediateDirectory)/up_up_up_up_Middleware_3_UI_Fontstash.cpp$(ObjectSuffix): ../../../../Middleware_3/UI/Fontstash.cpp $(IntermediateDirectory)/up_up_up_up_Middleware_3_UI_Fontstash.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "../../../../Middleware_3/UI/Fontstash.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/up_up_up_up_Middleware_3_UI_Fontstash.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/up_up_up_up_Middleware_3_UI_Fontstash.cpp$(DependSuffix): ../../../../Middleware_3/UI/Fontstash.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/up_up_up_up_Middleware_3_UI_Fontstash.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/up_up_up_up_Middleware_3_UI_Fontstash.cpp$(DependSuffix) -MM ../../../../Middleware_3/UI/Fontstash.cpp

$(IntermediateDirectory)/up_up_up_up_Middleware_3_UI_Fontstash.cpp$(PreprocessSuffix): ../../../../Middleware_3/UI/Fontstash.cpp
	$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/up_up_up_up_Middleware_3_UI_Fontstash.cpp$(PreprocessSuffix) ../../../../Middleware_3/UI/Fontstash.cpp

$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Camera_FpsCameraController.cpp$(ObjectSuffix): ../../../../Common_3/OS/Camera/FpsCameraController.cpp $(IntermediateDirectory)/up_up_up_up_Common_3_OS_Camera_FpsCameraController.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "../../../../Common_3/OS/Camera/FpsCameraController.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Camera_FpsCameraController.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Camera_FpsCameraController.cpp$(DependSuffix): ../../../../Common_3/OS/Camera/FpsCameraController.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Camera_FpsCameraController.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Camera_FpsCameraController.cpp$(DependSuffix) -MM ../../../../Common_3/OS/Camera/FpsCameraController.cpp

$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Camera_FpsCameraController.cpp$(PreprocessSuffix): ../../../../Common_3/OS/Camera/FpsCameraController.cpp
	$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/up_up_up_up_Common_3_OS_Camera_FpsCameraController.cpp$(PreprocessSuffix) ../../../../Common_3/OS/Camera/FpsCameraController.cpp

$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Core_DebugRenderer.cpp$(ObjectSuffix): ../../../../Common_3/OS/Core/DebugRenderer.cpp $(IntermediateDirectory)/up_up_up_up_Common_3_OS_Core_DebugRenderer.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "../../../../Common_3/OS/Core/DebugRenderer.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Core_DebugRenderer.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Core_DebugRenderer.cpp$(DependSuffix): ../../../../Common_3/OS/Core/DebugRenderer.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Core_DebugRenderer.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Core_DebugRenderer.cpp$(DependSuffix) -MM ../../../../Common_3/OS/Core/DebugRenderer.cpp

$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Core_DebugRenderer.cpp$(PreprocessSuffix): ../../../../Common_3/OS/Core/DebugRenderer.cpp
	$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/up_up_up_up_Common_3_OS_Core_DebugRenderer.cpp$(PreprocessSuffix) ../../../../Common_3/OS/Core/DebugRenderer.cpp

$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Linux_LinuxBase.cpp$(ObjectSuffix): ../../../../Common_3/OS/Linux/LinuxBase.cpp $(IntermediateDirectory)/up_up_up_up_Common_3_OS_Linux_LinuxBase.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "../../../../Common_3/OS/Linux/LinuxBase.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Linux_LinuxBase.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Linux_LinuxBase.cpp$(DependSuffix): ../../../../Common_3/OS/Linux/LinuxBase.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Linux_LinuxBase.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Linux_LinuxBase.cpp$(DependSuffix) -MM ../../../../Common_3/OS/Linux/LinuxBase.cpp

$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Linux_LinuxBase.cpp$(PreprocessSuffix): ../../../../Common_3/OS/Linux/LinuxBase.cpp
	$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/up_up_up_up_Common_3_OS_Linux_LinuxBase.cpp$(PreprocessSuffix) ../../../../Common_3/OS/Linux/LinuxBase.cpp

$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Linux_LinuxLogManager.cpp$(ObjectSuffix): ../../../../Common_3/OS/Linux/LinuxLogManager.cpp $(IntermediateDirectory)/up_up_up_up_Common_3_OS_Linux_LinuxLogManager.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "../../../../Common_3/OS/Linux/LinuxLogManager.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Linux_LinuxLogManager.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Linux_LinuxLogManager.cpp$(DependSuffix): ../../../../Common_3/OS/Linux/LinuxLogManager.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Linux_LinuxLogManager.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Linux_LinuxLogManager.cpp$(DependSuffix) -MM ../../../../Common_3/OS/Linux/LinuxLogManager.cpp

$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Linux_LinuxLogManager.cpp$(PreprocessSuffix): ../../../../Common_3/OS/Linux/LinuxLogManager.cpp
	$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/up_up_up_up_Common_3_OS_Linux_LinuxLogManager.cpp$(PreprocessSuffix) ../../../../Common_3/OS/Linux/LinuxLogManager.cpp

$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Core_ThreadSystem.cpp$(ObjectSuffix): ../../../../Common_3/OS/Core/ThreadSystem.cpp $(IntermediateDirectory)/up_up_up_up_Common_3_OS_Core_ThreadSystem.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "../../../../Common_3/OS/Core/ThreadSystem.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Core_ThreadSystem.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Core_ThreadSystem.cpp$(DependSuffix): ../../../../Common_3/OS/Core/ThreadSystem.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Core_ThreadSystem.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Core_ThreadSystem.cpp$(DependSuffix) -MM ../../../../Common_3/OS/Core/ThreadSystem.cpp

$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Core_ThreadSystem.cpp$(PreprocessSuffix): ../../../../Common_3/OS/Core/ThreadSystem.cpp
	$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/up_up_up_up_Common_3_OS_Core_ThreadSystem.cpp$(PreprocessSuffix) ../../../../Common_3/OS/Core/ThreadSystem.cpp

$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Camera_GuiCameraController.cpp$(ObjectSuffix): ../../../../Common_3/OS/Camera/GuiCameraController.cpp $(IntermediateDirectory)/up_up_up_up_Common_3_OS_Camera_GuiCameraController.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "../../../../Common_3/OS/Camera/GuiCameraController.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Camera_GuiCameraController.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Camera_GuiCameraController.cpp$(DependSuffix): ../../../../Common_3/OS/Camera/GuiCameraController.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Camera_GuiCameraController.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Camera_GuiCameraController.cpp$(DependSuffix) -MM ../../../../Common_3/OS/Camera/GuiCameraController.cpp

$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Camera_GuiCameraController.cpp$(PreprocessSuffix): ../../../../Common_3/OS/Camera/GuiCameraController.cpp
	$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/up_up_up_up_Common_3_OS_Camera_GuiCameraController.cpp$(PreprocessSuffix) ../../../../Common_3/OS/Camera/GuiCameraController.cpp

$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Core_FileSystem.cpp$(ObjectSuffix): ../../../../Common_3/OS/Core/FileSystem.cpp $(IntermediateDirectory)/up_up_up_up_Common_3_OS_Core_FileSystem.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "../../../../Common_3/OS/Core/FileSystem.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Core_FileSystem.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Core_FileSystem.cpp$(DependSuffix): ../../../../Common_3/OS/Core/FileSystem.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Core_FileSystem.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Core_FileSystem.cpp$(DependSuffix) -MM ../../../../Common_3/OS/Core/FileSystem.cpp

$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Core_FileSystem.cpp$(PreprocessSuffix): ../../../../Common_3/OS/Core/FileSystem.cpp
	$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/up_up_up_up_Common_3_OS_Core_FileSystem.cpp$(PreprocessSuffix) ../../../../Common_3/OS/Core/FileSystem.cpp

$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Logging_LogManager.cpp$(ObjectSuffix): ../../../../Common_3/OS/Logging/LogManager.cpp $(IntermediateDirectory)/up_up_up_up_Common_3_OS_Logging_LogManager.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "/home/confetti/Desktop/svn/TheForge/Common_3/OS/Logging/LogManager.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Logging_LogManager.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Logging_LogManager.cpp$(DependSuffix): ../../../../Common_3/OS/Logging/LogManager.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Logging_LogManager.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Logging_LogManager.cpp$(DependSuffix) -MM ../../../../Common_3/OS/Logging/LogManager.cpp

$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Logging_LogManager.cpp$(PreprocessSuffix): ../../../../Common_3/OS/Logging/LogManager.cpp
	$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/up_up_up_up_Common_3_OS_Logging_LogManager.cpp$(PreprocessSuffix) ../../../../Common_3/OS/Logging/LogManager.cpp

$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Core_PlatformEvents.cpp$(ObjectSuffix): ../../../../Common_3/OS/Core/PlatformEvents.cpp $(IntermediateDirectory)/up_up_up_up_Common_3_OS_Core_PlatformEvents.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "../../../../Common_3/OS/Core/PlatformEvents.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Core_PlatformEvents.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Core_PlatformEvents.cpp$(DependSuffix): ../../../../Common_3/OS/Core/PlatformEvents.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Core_PlatformEvents.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Core_PlatformEvents.cpp$(DependSuffix) -MM ../../../../Common_3/OS/Core/PlatformEvents.cpp

$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Core_PlatformEvents.cpp$(PreprocessSuffix): ../../../../Common_3/OS/Core/PlatformEvents.cpp
	$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/up_up_up_up_Common_3_OS_Core_PlatformEvents.cpp$(PreprocessSuffix) ../../../../Common_3/OS/Core/PlatformEvents.cpp

$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Core_Timer.cpp$(ObjectSuffix): ../../../../Common_3/OS/Core/Timer.cpp $(IntermediateDirectory)/up_up_up_up_Common_3_OS_Core_Timer.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "../../../../Common_3/OS/Core/Timer.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Core_Timer.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Core_Timer.cpp$(DependSuffix): ../../../../Common_3/OS/Core/Timer.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Core_Timer.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Core_Timer.cpp$(DependSuffix) -MM ../../../../Common_3/OS/Core/Timer.cpp

$(IntermediateDirectory)/up_up_up_up_Common_3_OS_Core_Timer.cpp$(PreprocessSuffix): ../../../../Common_3/OS/Core/Timer.cpp
	$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/up_up_up_up_Common_3_OS_Core_Timer.cpp$(PreprocessSuffix) ../../../../Common_3/OS/Core/Timer.cpp

$(IntermediateDirectory)/up_up_up_up_Middleware_3_UI_UIRenderer.cpp$(ObjectSuffix): ../../../../Middleware_3/UI/UIRenderer.cpp $(IntermediateDirectory)/up_up_up_up_Middleware_3_UI_UIRenderer.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "../../../../Middleware_3/UI/UIRenderer.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/up_up_up_up_Middleware_3_UI_UIRenderer.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/up_up_up_up_Middleware_3_UI_UIRenderer.cpp$(DependSuffix): ../../../../Middleware_3/UI/UIRenderer.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/up_up_up_up_Middleware_3_UI_UIRenderer.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/up_up_up_up_Middleware_3_UI_UIRenderer.cpp$(DependSuffix) -MM ../../../../Middleware_3/UI/UIRenderer.cpp

$(IntermediateDirectory)/up_up_up_up_Middleware_3_UI_UIRenderer.cpp$(PreprocessSuffix): ../../../../Middleware_3/UI/UIRenderer.cpp
	$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/up_up_up_up_Middleware_3_UI_UIRenderer.cpp$(PreprocessSuffix) ../../../../Middleware_3/UI/UIRenderer.cpp

$(IntermediateDirectory)/up_up_up_up_Common_3_OS_MemoryTracking_MemoryTrackingManager.cpp$(ObjectSuffix): ../../../../Common_3/OS/MemoryTracking/MemoryTrackingManager.cpp $(IntermediateDirectory)/up_up_up_up_Common_3_OS_MemoryTracking_MemoryTrackingManager.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "../../../../Common_3/OS/MemoryTracking/MemoryTrackingManager.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/up_up_up_up_Common_3_OS_MemoryTracking_MemoryTrackingManager.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/up_up_up_up_Common_3_OS_MemoryTracking_MemoryTrackingManager.cpp$(DependSuffix): ../../../../Common_3/OS/MemoryTracking/MemoryTrackingManager.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/up_up_up_up_Common_3_OS_MemoryTracking_MemoryTrackingManager.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/up_up_up_up_Common_3_OS_MemoryTracking_MemoryTrackingManager.cpp$(DependSuffix) -MM ../../../../Common_3/OS/MemoryTracking/MemoryTrackingManager.cpp

$(IntermediateDirectory)/up_up_up_up_Common_3_OS_MemoryTracking_MemoryTrackingManager.cpp$(PreprocessSuffix): ../../../../Common_3/OS/MemoryTracking/MemoryTrackingManager.cpp
	$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/up_up_up_up_Common_3_OS_MemoryTracking_MemoryTrackingManager.cpp$(PreprocessSuffix) ../../../../Common_3/OS/MemoryTracking/MemoryTrackingManager.cpp

$(IntermediateDirectory)/up_up_up_up_Middleware_3_UI_NuklearGUIDriver.cpp$(ObjectSuffix): ../../../../Middleware_3/UI/NuklearGUIDriver.cpp $(IntermediateDirectory)/up_up_up_up_Middleware_3_UI_NuklearGUIDriver.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "../../../../Middleware_3/UI/NuklearGUIDriver.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/up_up_up_up_Middleware_3_UI_NuklearGUIDriver.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/up_up_up_up_Middleware_3_UI_NuklearGUIDriver.cpp$(DependSuffix): ../../../../Middleware_3/UI/NuklearGUIDriver.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/up_up_up_up_Middleware_3_UI_NuklearGUIDriver.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/up_up_up_up_Middleware_3_UI_NuklearGUIDriver.cpp$(DependSuffix) -MM ../../../../Middleware_3/UI/NuklearGUIDriver.cpp

$(IntermediateDirectory)/up_up_up_up_Middleware_3_UI_NuklearGUIDriver.cpp$(PreprocessSuffix): ../../../../Middleware_3/UI/NuklearGUIDriver.cpp
	$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/up_up_up_up_Middleware_3_UI_NuklearGUIDriver.cpp$(PreprocessSuffix) ../../../../Middleware_3/UI/NuklearGUIDriver.cpp


-include $(IntermediateDirectory)/*$(DependSuffix)
##
## Clean
##
clean:
	$(RM) -r ./Debug/


