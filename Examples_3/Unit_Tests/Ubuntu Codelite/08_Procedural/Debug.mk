##
## Auto Generated makefile by CodeLite IDE
## any manual changes will be erased      
##
## Debug
ProjectName            :=08_Procedural
ConfigurationName      :=Debug
WorkspacePath          :="./"
ProjectPath            :="08_Procedural/"
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
OutputFile             :=$(IntermediateDirectory)/$(ProjectName)
Preprocessors          :=$(PreprocessorSwitch)LINUX $(PreprocessorSwitch)VULKAN $(PreprocessorSwitch)_DEBUG 
ObjectSwitch           :=-o 
ArchiveOutputSwitch    := 
PreprocessOnlySwitch   :=-E 
ObjectsFileList        :="08_Procedural.txt"
PCHCompileFlags        :=
MakeDirCommand         :=mkdir -p
LinkOptions            :=  -ldl -pthread 
IncludePath            :=  $(IncludeSwitch). $(IncludeSwitch). $(IncludeSwitch)$(ProjectPath)/../.. $(IncludeSwitch)$(VULKAN_SDK)/include/ 
IncludePCH             := 
RcIncludePath          := 
Libs                   := $(LibrarySwitch)OS $(LibrarySwitch)Renderer $(LibrarySwitch)X11 $(LibrarySwitch)SpirVTools $(LibrarySwitch)vulkan 
ArLibs                 :=  "libOS.a" "libRenderer.a" "libX11.a" "libSpirVTools.a" "libvulkan.so" 
LibPath                := $(LibraryPathSwitch). $(LibraryPathSwitch)../OSBase/Debug/ $(LibraryPathSwitch)../Renderer/Debug/ $(LibraryPathSwitch)../SpirVTools/Debug/ $(LibraryPathSwitch)$(VULKAN_SDK)/lib/ 

##
## Common variables
## AR, CXX, CC, AS, CXXFLAGS and CFLAGS can be overriden using an environment variables
##
AR       := ar rcus
CXX      := g++
CC       := gcc
CXXFLAGS :=  -g -O0 -std=c++11 -Wall -Wno-unknown-pragmas   $(Preprocessors)
CFLAGS   :=  -g -O0 -Wall $(Preprocessors)
ASFLAGS  := 
AS       := as


##
## User defined environment variables
##
CodeLiteDir:=/usr/share/codelite
Objects0=$(IntermediateDirectory)/up_up_src_08_Procedural_08_Procedural.cpp$(ObjectSuffix) 



Objects=$(Objects0) 

##
## Main Build Targets 
##
.PHONY: all clean PreBuild PrePreBuild PostBuild MakeIntermediateDirs
all: $(OutputFile)

$(OutputFile): $(IntermediateDirectory)/.d $(Objects) 
	@$(MakeDirCommand) $(@D)
	@echo "" > $(IntermediateDirectory)/.d
	@echo $(Objects0)  > $(ObjectsFileList)
	$(LinkerName) $(OutputSwitch)$(OutputFile) @$(ObjectsFileList) $(LibPath) $(Libs) $(LinkOptions)

MakeIntermediateDirs:
	@test -d ./Debug || $(MakeDirCommand) ./Debug


$(IntermediateDirectory)/.d:
	@test -d ./Debug || $(MakeDirCommand) ./Debug

PreBuild:


##
## Objects
##
$(IntermediateDirectory)/up_up_src_08_Procedural_08_Procedural.cpp$(ObjectSuffix): ../../src/08_Procedural/08_Procedural.cpp $(IntermediateDirectory)/up_up_src_08_Procedural_08_Procedural.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "../../src/08_Procedural/08_Procedural.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/up_up_src_08_Procedural_08_Procedural.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/up_up_src_08_Procedural_08_Procedural.cpp$(DependSuffix): ../../src/08_Procedural/08_Procedural.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/up_up_src_08_Procedural_08_Procedural.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/up_up_src_08_Procedural_08_Procedural.cpp$(DependSuffix) -MM ../../src/08_Procedural/08_Procedural.cpp

$(IntermediateDirectory)/up_up_src_08_Procedural_08_Procedural.cpp$(PreprocessSuffix): ../../src/08_Procedural/08_Procedural.cpp
	$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/up_up_src_08_Procedural_08_Procedural.cpp$(PreprocessSuffix) ../../src/08_Procedural/08_Procedural.cpp


-include $(IntermediateDirectory)/*$(DependSuffix)
##
## Clean
##
clean:
	$(RM) -r ./Debug/


