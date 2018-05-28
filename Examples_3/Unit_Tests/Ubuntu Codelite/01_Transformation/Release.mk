##
## Auto Generated makefile by CodeLite IDE
## any manual changes will be erased      
##
## Release
ProjectName            :=01_Transformation
ConfigurationName      :=Release
WorkspacePath          :="/home/confetti/Desktop/svn/TheForge/Examples_3/Unit_Tests/Ubuntu Codelite"
ProjectPath            :="01_Transformation/"
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
ObjectsFileList        :="01_Transformation.txt"
PCHCompileFlags        :=
MakeDirCommand         :=mkdir -p
LinkOptions            :=  -ldl -pthread 
IncludePath            :=  $(IncludeSwitch). $(IncludeSwitch). $(IncludeSwitch)$(ProjectPath)/../.. $(IncludeSwitch)$(VULKAN_SDK)/include/ 
IncludePCH             := 
RcIncludePath          := 
Libs                   := $(LibrarySwitch)OS $(LibrarySwitch)Renderer $(LibrarySwitch)X11 $(LibrarySwitch)SpirVTools $(LibrarySwitch)vulkan 
ArLibs                 :=  "libOS.a" "libRenderer.a" "libX11.a" "libSpirVTools.a" "libvulkan.so" 
LibPath                := $(LibraryPathSwitch). $(LibraryPathSwitch)../OSBase/Release/ $(LibraryPathSwitch)../Renderer/Release/ $(LibraryPathSwitch)../SpirVTools/Release/ $(LibraryPathSwitch)$(VULKAN_SDK)/lib/ 

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
Objects0=$(IntermediateDirectory)/up_up_src_01_Transformations_01_Transformations.cpp$(ObjectSuffix) 



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
$(IntermediateDirectory)/up_up_src_01_Transformations_01_Transformations.cpp$(ObjectSuffix): ../../src/01_Transformations/01_Transformations.cpp $(IntermediateDirectory)/up_up_src_01_Transformations_01_Transformations.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "../../src/01_Transformations/01_Transformations.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/up_up_src_01_Transformations_01_Transformations.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/up_up_src_01_Transformations_01_Transformations.cpp$(DependSuffix): ../../src/01_Transformations/01_Transformations.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/up_up_src_01_Transformations_01_Transformations.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/up_up_src_01_Transformations_01_Transformations.cpp$(DependSuffix) -MM ../../src/01_Transformations/01_Transformations.cpp

$(IntermediateDirectory)/up_up_src_01_Transformations_01_Transformations.cpp$(PreprocessSuffix): ../../src/01_Transformations/01_Transformations.cpp
	$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/up_up_src_01_Transformations_01_Transformations.cpp$(PreprocessSuffix) ../../src/01_Transformations/01_Transformations.cpp


-include $(IntermediateDirectory)/*$(DependSuffix)
##
## Clean
##
clean:
	$(RM) -r ./Release/


