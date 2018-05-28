##
## Auto Generated makefile by CodeLite IDE
## any manual changes will be erased      
##
## Release
ProjectName            :=05_FontRendering
ConfigurationName      :=Release
WorkspacePath          :="/home/confetti/Desktop/svn/TheForge/Examples_3/Unit_Tests/Ubuntu Codelite"
ProjectPath            :="/home/confetti/Desktop/svn/TheForge/Examples_3/Unit_Tests/Ubuntu Codelite/05_FontRendering"
IntermediateDirectory  :=./Release
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
Preprocessors          :=$(PreprocessorSwitch)LINUX $(PreprocessorSwitch)VULKAN $(PreprocessorSwitch)NDEBUG 
ObjectSwitch           :=-o 
ArchiveOutputSwitch    := 
PreprocessOnlySwitch   :=-E 
ObjectsFileList        :="05_FontRendering.txt"
PCHCompileFlags        :=
MakeDirCommand         :=mkdir -p
LinkOptions            :=  -ldl -pthread 
IncludePath            :=  $(IncludeSwitch). $(IncludeSwitch). $(IncludeSwitch)$(ProjectPath)/../.. $(IncludeSwitch)$(VULKAN_SDK)/include/ 
IncludePCH             := 
RcIncludePath          := 
Libs                   := $(LibrarySwitch)OS $(LibrarySwitch)Renderer $(LibrarySwitch)X11 $(LibrarySwitch)SpirVTools $(LibrarySwitch)vulkan 
ArLibs                 :=  "libOS.a" "libRenderer.a" "libX11.a" "libSpirVTools.a" "libvulkan.so" 
LibPath                := $(LibraryPathSwitch). $(LibraryPathSwitch)$(ProjectPath)/../OSBase/Release/ $(LibraryPathSwitch)$(ProjectPath)/../Renderer/Release/ $(LibraryPathSwitch)$(ProjectPath)/../SpirVTools/Release/ $(LibraryPathSwitch)$(VULKAN_SDK)/lib/ 

##
## Common variables
## AR, CXX, CC, AS, CXXFLAGS and CFLAGS can be overriden using an environment variables
##
AR       := ar rcus
CXX      := g++
CC       := gcc
CXXFLAGS :=  -O2 -std=c++11 -Wall -Wno-unknown-pragmas   $(Preprocessors)
CFLAGS   :=  -O2 -Wall $(Preprocessors)
ASFLAGS  := 
AS       := as


##
## User defined environment variables
##
CodeLiteDir:=/usr/share/codelite
Objects0=$(IntermediateDirectory)/up_up_src_05_FontRendering_05_FontRendering.cpp$(ObjectSuffix) 



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
	@test -d ./Release || $(MakeDirCommand) ./Release


$(IntermediateDirectory)/.d:
	@test -d ./Release || $(MakeDirCommand) ./Release

PreBuild:


##
## Objects
##
$(IntermediateDirectory)/up_up_src_05_FontRendering_05_FontRendering.cpp$(ObjectSuffix): ../../src/05_FontRendering/05_FontRendering.cpp $(IntermediateDirectory)/up_up_src_05_FontRendering_05_FontRendering.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "/home/confetti/Desktop/svn/TheForge/Examples_3/Unit_Tests/src/05_FontRendering/05_FontRendering.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/up_up_src_05_FontRendering_05_FontRendering.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/up_up_src_05_FontRendering_05_FontRendering.cpp$(DependSuffix): ../../src/05_FontRendering/05_FontRendering.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/up_up_src_05_FontRendering_05_FontRendering.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/up_up_src_05_FontRendering_05_FontRendering.cpp$(DependSuffix) -MM ../../src/05_FontRendering/05_FontRendering.cpp

$(IntermediateDirectory)/up_up_src_05_FontRendering_05_FontRendering.cpp$(PreprocessSuffix): ../../src/05_FontRendering/05_FontRendering.cpp
	$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/up_up_src_05_FontRendering_05_FontRendering.cpp$(PreprocessSuffix) ../../src/05_FontRendering/05_FontRendering.cpp


-include $(IntermediateDirectory)/*$(DependSuffix)
##
## Clean
##
clean:
	$(RM) -r ./Release/


