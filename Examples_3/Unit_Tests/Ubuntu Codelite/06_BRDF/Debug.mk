##
## Auto Generated makefile by CodeLite IDE
## any manual changes will be erased      
##
## Debug
ProjectName            :=06_BRDF
ConfigurationName      :=Debug
WorkspacePath          :="./"
ProjectPath            :="06_BRDF/"
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
ObjectsFileList        :="06_BRDF.txt"
PCHCompileFlags        :=
MakeDirCommand         :=mkdir -p
LinkOptions            :=  -ldl -pthread 
IncludePath            :=  $(IncludeSwitch). $(IncludeSwitch). $(IncludeSwitch)../.. $(IncludeSwitch)$(VULKAN_SDK)/include/ $(IncludeSwitch)../../../../Common_3/ThirdParty/OpenSource/assimp/4.1.0/include 
IncludePCH             := 
RcIncludePath          := 
Libs                   := $(LibrarySwitch)OS $(LibrarySwitch)Renderer $(LibrarySwitch)X11 $(LibrarySwitch)SpirVTools $(LibrarySwitch)vulkan $(LibrarySwitch)assimp 
ArLibs                 :=  "libOS.a" "libRenderer.a" "libX11.a" "libSpirVTools.a" "libvulkan.so" "libassimp.so" 
LibPath                := $(LibraryPathSwitch). $(LibraryPathSwitch)../OSBase/Debug/ $(LibraryPathSwitch)../Renderer/Debug/ $(LibraryPathSwitch)../SpirVTools/Debug/ $(LibraryPathSwitch)$(VULKAN_SDK)/lib/ $(LibraryPathSwitch)../../../../Common_3/ThirdParty/OpenSource/assimp/4.1.0/lib 

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
Objects0=$(IntermediateDirectory)/up_up_src_06_BRDF_06_BRDF.cpp$(ObjectSuffix) $(IntermediateDirectory)/up_up_up_up_Common_3_Tools_AssimpImporter_AssimpImporter.cpp$(ObjectSuffix) 



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
$(IntermediateDirectory)/up_up_src_06_BRDF_06_BRDF.cpp$(ObjectSuffix): ../../src/06_BRDF/06_BRDF.cpp $(IntermediateDirectory)/up_up_src_06_BRDF_06_BRDF.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "../../src/06_BRDF/06_BRDF.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/up_up_src_06_BRDF_06_BRDF.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/up_up_src_06_BRDF_06_BRDF.cpp$(DependSuffix): ../../src/06_BRDF/06_BRDF.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/up_up_src_06_BRDF_06_BRDF.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/up_up_src_06_BRDF_06_BRDF.cpp$(DependSuffix) -MM ../../src/06_BRDF/06_BRDF.cpp

$(IntermediateDirectory)/up_up_src_06_BRDF_06_BRDF.cpp$(PreprocessSuffix): ../../src/06_BRDF/06_BRDF.cpp
	$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/up_up_src_06_BRDF_06_BRDF.cpp$(PreprocessSuffix) ../../src/06_BRDF/06_BRDF.cpp

$(IntermediateDirectory)/up_up_up_up_Common_3_Tools_AssimpImporter_AssimpImporter.cpp$(ObjectSuffix): ../../../../Common_3/Tools/AssimpImporter/AssimpImporter.cpp $(IntermediateDirectory)/up_up_up_up_Common_3_Tools_AssimpImporter_AssimpImporter.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "../../../../Common_3/Tools/AssimpImporter/AssimpImporter.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/up_up_up_up_Common_3_Tools_AssimpImporter_AssimpImporter.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/up_up_up_up_Common_3_Tools_AssimpImporter_AssimpImporter.cpp$(DependSuffix): ../../../../Common_3/Tools/AssimpImporter/AssimpImporter.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/up_up_up_up_Common_3_Tools_AssimpImporter_AssimpImporter.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/up_up_up_up_Common_3_Tools_AssimpImporter_AssimpImporter.cpp$(DependSuffix) -MM ../../../../Common_3/Tools/AssimpImporter/AssimpImporter.cpp

$(IntermediateDirectory)/up_up_up_up_Common_3_Tools_AssimpImporter_AssimpImporter.cpp$(PreprocessSuffix): ../../../../Common_3/Tools/AssimpImporter/AssimpImporter.cpp
	$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/up_up_up_up_Common_3_Tools_AssimpImporter_AssimpImporter.cpp$(PreprocessSuffix) ../../../../Common_3/Tools/AssimpImporter/AssimpImporter.cpp


-include $(IntermediateDirectory)/*$(DependSuffix)
##
## Clean
##
clean:
	$(RM) -r ./Debug/


