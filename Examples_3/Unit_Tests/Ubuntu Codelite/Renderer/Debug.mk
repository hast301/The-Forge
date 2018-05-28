##
## Auto Generated makefile by CodeLite IDE
## any manual changes will be erased      
##
## Debug
ProjectName            :=Renderer
ConfigurationName      :=Debug
WorkspacePath          :="./"
ProjectPath            :="Renderer/"
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
ObjectsFileList        :="Renderer.txt"
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
CXXFLAGS :=  -g -std=c++11   $(Preprocessors)
CFLAGS   :=  -g $(Preprocessors)
ASFLAGS  := 
AS       := as


##
## User defined environment variables
##
CodeLiteDir:=/usr/share/codelite
Objects0=$(IntermediateDirectory)/up_up_up_up_Common_3_Renderer_Vulkan_VulkanShaderReflection.cpp$(ObjectSuffix) $(IntermediateDirectory)/up_up_up_up_Common_3_Renderer_Vulkan_Vulkan.cpp$(ObjectSuffix) $(IntermediateDirectory)/up_up_up_up_Common_3_Renderer_ResourceLoader.cpp$(ObjectSuffix) $(IntermediateDirectory)/up_up_up_up_Common_3_Renderer_GpuProfiler.cpp$(ObjectSuffix) $(IntermediateDirectory)/up_up_up_up_Common_3_Renderer_CommonShaderReflection.cpp$(ObjectSuffix) 



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
	@echo rebuilt > ".build-release/Renderer"

MakeIntermediateDirs:
	@test -d ./Debug || $(MakeDirCommand) ./Debug


./Debug:
	@test -d ./Debug || $(MakeDirCommand) ./Debug

PreBuild:


##
## Objects
##
$(IntermediateDirectory)/up_up_up_up_Common_3_Renderer_Vulkan_VulkanShaderReflection.cpp$(ObjectSuffix): ../../../../Common_3/Renderer/Vulkan/VulkanShaderReflection.cpp $(IntermediateDirectory)/up_up_up_up_Common_3_Renderer_Vulkan_VulkanShaderReflection.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "../../../../Common_3/Renderer/Vulkan/VulkanShaderReflection.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/up_up_up_up_Common_3_Renderer_Vulkan_VulkanShaderReflection.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/up_up_up_up_Common_3_Renderer_Vulkan_VulkanShaderReflection.cpp$(DependSuffix): ../../../../Common_3/Renderer/Vulkan/VulkanShaderReflection.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/up_up_up_up_Common_3_Renderer_Vulkan_VulkanShaderReflection.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/up_up_up_up_Common_3_Renderer_Vulkan_VulkanShaderReflection.cpp$(DependSuffix) -MM ../../../../Common_3/Renderer/Vulkan/VulkanShaderReflection.cpp

$(IntermediateDirectory)/up_up_up_up_Common_3_Renderer_Vulkan_VulkanShaderReflection.cpp$(PreprocessSuffix): ../../../../Common_3/Renderer/Vulkan/VulkanShaderReflection.cpp
	$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/up_up_up_up_Common_3_Renderer_Vulkan_VulkanShaderReflection.cpp$(PreprocessSuffix) ../../../../Common_3/Renderer/Vulkan/VulkanShaderReflection.cpp

$(IntermediateDirectory)/up_up_up_up_Common_3_Renderer_Vulkan_Vulkan.cpp$(ObjectSuffix): ../../../../Common_3/Renderer/Vulkan/Vulkan.cpp $(IntermediateDirectory)/up_up_up_up_Common_3_Renderer_Vulkan_Vulkan.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "../../../../Common_3/Renderer/Vulkan/Vulkan.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/up_up_up_up_Common_3_Renderer_Vulkan_Vulkan.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/up_up_up_up_Common_3_Renderer_Vulkan_Vulkan.cpp$(DependSuffix): ../../../../Common_3/Renderer/Vulkan/Vulkan.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/up_up_up_up_Common_3_Renderer_Vulkan_Vulkan.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/up_up_up_up_Common_3_Renderer_Vulkan_Vulkan.cpp$(DependSuffix) -MM ../../../../Common_3/Renderer/Vulkan/Vulkan.cpp

$(IntermediateDirectory)/up_up_up_up_Common_3_Renderer_Vulkan_Vulkan.cpp$(PreprocessSuffix): ../../../../Common_3/Renderer/Vulkan/Vulkan.cpp
	$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/up_up_up_up_Common_3_Renderer_Vulkan_Vulkan.cpp$(PreprocessSuffix) ../../../../Common_3/Renderer/Vulkan/Vulkan.cpp

$(IntermediateDirectory)/up_up_up_up_Common_3_Renderer_ResourceLoader.cpp$(ObjectSuffix): ../../../../Common_3/Renderer/ResourceLoader.cpp $(IntermediateDirectory)/up_up_up_up_Common_3_Renderer_ResourceLoader.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "../../../../Common_3/Renderer/ResourceLoader.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/up_up_up_up_Common_3_Renderer_ResourceLoader.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/up_up_up_up_Common_3_Renderer_ResourceLoader.cpp$(DependSuffix): ../../../../Common_3/Renderer/ResourceLoader.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/up_up_up_up_Common_3_Renderer_ResourceLoader.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/up_up_up_up_Common_3_Renderer_ResourceLoader.cpp$(DependSuffix) -MM ../../../../Common_3/Renderer/ResourceLoader.cpp

$(IntermediateDirectory)/up_up_up_up_Common_3_Renderer_ResourceLoader.cpp$(PreprocessSuffix): ../../../../Common_3/Renderer/ResourceLoader.cpp
	$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/up_up_up_up_Common_3_Renderer_ResourceLoader.cpp$(PreprocessSuffix) ../../../../Common_3/Renderer/ResourceLoader.cpp

$(IntermediateDirectory)/up_up_up_up_Common_3_Renderer_GpuProfiler.cpp$(ObjectSuffix): ../../../../Common_3/Renderer/GpuProfiler.cpp $(IntermediateDirectory)/up_up_up_up_Common_3_Renderer_GpuProfiler.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "../../../../Common_3/Renderer/GpuProfiler.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/up_up_up_up_Common_3_Renderer_GpuProfiler.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/up_up_up_up_Common_3_Renderer_GpuProfiler.cpp$(DependSuffix): ../../../../Common_3/Renderer/GpuProfiler.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/up_up_up_up_Common_3_Renderer_GpuProfiler.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/up_up_up_up_Common_3_Renderer_GpuProfiler.cpp$(DependSuffix) -MM ../../../../Common_3/Renderer/GpuProfiler.cpp

$(IntermediateDirectory)/up_up_up_up_Common_3_Renderer_GpuProfiler.cpp$(PreprocessSuffix): ../../../../Common_3/Renderer/GpuProfiler.cpp
	$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/up_up_up_up_Common_3_Renderer_GpuProfiler.cpp$(PreprocessSuffix) ../../../../Common_3/Renderer/GpuProfiler.cpp

$(IntermediateDirectory)/up_up_up_up_Common_3_Renderer_CommonShaderReflection.cpp$(ObjectSuffix): ../../../../Common_3/Renderer/CommonShaderReflection.cpp $(IntermediateDirectory)/up_up_up_up_Common_3_Renderer_CommonShaderReflection.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "../../../../Common_3/Renderer/CommonShaderReflection.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/up_up_up_up_Common_3_Renderer_CommonShaderReflection.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/up_up_up_up_Common_3_Renderer_CommonShaderReflection.cpp$(DependSuffix): ../../../../Common_3/Renderer/CommonShaderReflection.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/up_up_up_up_Common_3_Renderer_CommonShaderReflection.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/up_up_up_up_Common_3_Renderer_CommonShaderReflection.cpp$(DependSuffix) -MM ../../../../Common_3/Renderer/CommonShaderReflection.cpp

$(IntermediateDirectory)/up_up_up_up_Common_3_Renderer_CommonShaderReflection.cpp$(PreprocessSuffix): ../../../../Common_3/Renderer/CommonShaderReflection.cpp
	$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/up_up_up_up_Common_3_Renderer_CommonShaderReflection.cpp$(PreprocessSuffix) ../../../../Common_3/Renderer/CommonShaderReflection.cpp


-include $(IntermediateDirectory)/*$(DependSuffix)
##
## Clean
##
clean:
	$(RM) -r ./Debug/


