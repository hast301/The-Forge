##
## Auto Generated makefile by CodeLite IDE
## any manual changes will be erased      
##
## Release
ProjectName            :=04_ExecuteIndirect
ConfigurationName      :=Release
WorkspacePath          :="./"
ProjectPath            :="04_ExecuteIndirect/"
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
ObjectsFileList        :="04_ExecuteIndirect.txt"
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
CXXFLAGS :=  -O2 -std=c++11 -Wall -Wno-unknown-pragmas  -march=native  $(Preprocessors)
CFLAGS   :=  -O2 -Wall $(Preprocessors)
ASFLAGS  := 
AS       := as


##
## User defined environment variables
##
CodeLiteDir:=/usr/share/codelite
Objects0=$(IntermediateDirectory)/up_up_up_up_Middleware_3_PaniniProjection_Panini.cpp$(ObjectSuffix) $(IntermediateDirectory)/up_up_src_04_ExecuteIndirect_TextureGen.cpp$(ObjectSuffix) $(IntermediateDirectory)/up_up_src_04_ExecuteIndirect_AsteroidSim.cpp$(ObjectSuffix) $(IntermediateDirectory)/up_up_src_04_ExecuteIndirect_04_ExecuteIndirect.cpp$(ObjectSuffix) $(IntermediateDirectory)/up_up_src_04_ExecuteIndirect_simplexnoise1234.cpp$(ObjectSuffix) 



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
$(IntermediateDirectory)/up_up_up_up_Middleware_3_PaniniProjection_Panini.cpp$(ObjectSuffix): ../../../../Middleware_3/PaniniProjection/Panini.cpp $(IntermediateDirectory)/up_up_up_up_Middleware_3_PaniniProjection_Panini.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "../../../../Middleware_3/PaniniProjection/Panini.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/up_up_up_up_Middleware_3_PaniniProjection_Panini.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/up_up_up_up_Middleware_3_PaniniProjection_Panini.cpp$(DependSuffix): ../../../../Middleware_3/PaniniProjection/Panini.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/up_up_up_up_Middleware_3_PaniniProjection_Panini.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/up_up_up_up_Middleware_3_PaniniProjection_Panini.cpp$(DependSuffix) -MM ../../../../Middleware_3/PaniniProjection/Panini.cpp

$(IntermediateDirectory)/up_up_up_up_Middleware_3_PaniniProjection_Panini.cpp$(PreprocessSuffix): ../../../../Middleware_3/PaniniProjection/Panini.cpp
	$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/up_up_up_up_Middleware_3_PaniniProjection_Panini.cpp$(PreprocessSuffix) ../../../../Middleware_3/PaniniProjection/Panini.cpp

$(IntermediateDirectory)/up_up_src_04_ExecuteIndirect_TextureGen.cpp$(ObjectSuffix): ../../src/04_ExecuteIndirect/TextureGen.cpp $(IntermediateDirectory)/up_up_src_04_ExecuteIndirect_TextureGen.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "../../src/04_ExecuteIndirect/TextureGen.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/up_up_src_04_ExecuteIndirect_TextureGen.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/up_up_src_04_ExecuteIndirect_TextureGen.cpp$(DependSuffix): ../../src/04_ExecuteIndirect/TextureGen.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/up_up_src_04_ExecuteIndirect_TextureGen.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/up_up_src_04_ExecuteIndirect_TextureGen.cpp$(DependSuffix) -MM ../../src/04_ExecuteIndirect/TextureGen.cpp

$(IntermediateDirectory)/up_up_src_04_ExecuteIndirect_TextureGen.cpp$(PreprocessSuffix): ../../src/04_ExecuteIndirect/TextureGen.cpp
	$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/up_up_src_04_ExecuteIndirect_TextureGen.cpp$(PreprocessSuffix) ../../src/04_ExecuteIndirect/TextureGen.cpp

$(IntermediateDirectory)/up_up_src_04_ExecuteIndirect_AsteroidSim.cpp$(ObjectSuffix): ../../src/04_ExecuteIndirect/AsteroidSim.cpp $(IntermediateDirectory)/up_up_src_04_ExecuteIndirect_AsteroidSim.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "../../src/04_ExecuteIndirect/AsteroidSim.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/up_up_src_04_ExecuteIndirect_AsteroidSim.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/up_up_src_04_ExecuteIndirect_AsteroidSim.cpp$(DependSuffix): ../../src/04_ExecuteIndirect/AsteroidSim.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/up_up_src_04_ExecuteIndirect_AsteroidSim.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/up_up_src_04_ExecuteIndirect_AsteroidSim.cpp$(DependSuffix) -MM ../../src/04_ExecuteIndirect/AsteroidSim.cpp

$(IntermediateDirectory)/up_up_src_04_ExecuteIndirect_AsteroidSim.cpp$(PreprocessSuffix): ../../src/04_ExecuteIndirect/AsteroidSim.cpp
	$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/up_up_src_04_ExecuteIndirect_AsteroidSim.cpp$(PreprocessSuffix) ../../src/04_ExecuteIndirect/AsteroidSim.cpp

$(IntermediateDirectory)/up_up_src_04_ExecuteIndirect_04_ExecuteIndirect.cpp$(ObjectSuffix): ../../src/04_ExecuteIndirect/04_ExecuteIndirect.cpp $(IntermediateDirectory)/up_up_src_04_ExecuteIndirect_04_ExecuteIndirect.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "../../src/04_ExecuteIndirect/04_ExecuteIndirect.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/up_up_src_04_ExecuteIndirect_04_ExecuteIndirect.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/up_up_src_04_ExecuteIndirect_04_ExecuteIndirect.cpp$(DependSuffix): ../../src/04_ExecuteIndirect/04_ExecuteIndirect.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/up_up_src_04_ExecuteIndirect_04_ExecuteIndirect.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/up_up_src_04_ExecuteIndirect_04_ExecuteIndirect.cpp$(DependSuffix) -MM ../../src/04_ExecuteIndirect/04_ExecuteIndirect.cpp

$(IntermediateDirectory)/up_up_src_04_ExecuteIndirect_04_ExecuteIndirect.cpp$(PreprocessSuffix): ../../src/04_ExecuteIndirect/04_ExecuteIndirect.cpp
	$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/up_up_src_04_ExecuteIndirect_04_ExecuteIndirect.cpp$(PreprocessSuffix) ../../src/04_ExecuteIndirect/04_ExecuteIndirect.cpp

$(IntermediateDirectory)/up_up_src_04_ExecuteIndirect_simplexnoise1234.cpp$(ObjectSuffix): ../../src/04_ExecuteIndirect/simplexnoise1234.cpp $(IntermediateDirectory)/up_up_src_04_ExecuteIndirect_simplexnoise1234.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "../../src/04_ExecuteIndirect/simplexnoise1234.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/up_up_src_04_ExecuteIndirect_simplexnoise1234.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/up_up_src_04_ExecuteIndirect_simplexnoise1234.cpp$(DependSuffix): ../../src/04_ExecuteIndirect/simplexnoise1234.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/up_up_src_04_ExecuteIndirect_simplexnoise1234.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/up_up_src_04_ExecuteIndirect_simplexnoise1234.cpp$(DependSuffix) -MM ../../src/04_ExecuteIndirect/simplexnoise1234.cpp

$(IntermediateDirectory)/up_up_src_04_ExecuteIndirect_simplexnoise1234.cpp$(PreprocessSuffix): ../../src/04_ExecuteIndirect/simplexnoise1234.cpp
	$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/up_up_src_04_ExecuteIndirect_simplexnoise1234.cpp$(PreprocessSuffix) ../../src/04_ExecuteIndirect/simplexnoise1234.cpp


-include $(IntermediateDirectory)/*$(DependSuffix)
##
## Clean
##
clean:
	$(RM) -r ./Release/


