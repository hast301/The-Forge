##
## Auto Generated makefile by CodeLite IDE
## any manual changes will be erased      
##
## Debug
ProjectName            :=SpirVTools
ConfigurationName      :=Debug
WorkspacePath          :="/home/confetti/Desktop/svn/TheForge/Examples_3/Unit_Tests/Ubuntu Codelite"
ProjectPath            :="/home/confetti/Desktop/svn/TheForge/Examples_3/Unit_Tests/Ubuntu Codelite/SpirVTools"
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
Preprocessors          :=
ObjectSwitch           :=-o 
ArchiveOutputSwitch    := 
PreprocessOnlySwitch   :=-E 
ObjectsFileList        :="SpirVTools.txt"
PCHCompileFlags        :=
MakeDirCommand         :=mkdir -p
LinkOptions            :=  
IncludePath            :=  $(IncludeSwitch). $(IncludeSwitch). 
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
CXXFLAGS :=  -g -std=c++11  $(Preprocessors)
CFLAGS   :=  -g $(Preprocessors)
ASFLAGS  := 
AS       := as


##
## User defined environment variables
##
CodeLiteDir:=/usr/share/codelite
Objects0=$(IntermediateDirectory)/up_up_up_up_Common_3_ThirdParty_OpenSource_SPIRV_Cross_spirv_cross.cpp$(ObjectSuffix) $(IntermediateDirectory)/up_up_up_up_Common_3_Tools_SpirvTools_SpirvTools.cpp$(ObjectSuffix) $(IntermediateDirectory)/up_up_up_up_Common_3_ThirdParty_OpenSource_SPIRV_Cross_spirv_cfg.cpp$(ObjectSuffix) 



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
	@$(MakeDirCommand) "/home/confetti/Desktop/svn/TheForge/Examples_3/Unit_Tests/Ubuntu Codelite/.build-release"
	@echo rebuilt > "/home/confetti/Desktop/svn/TheForge/Examples_3/Unit_Tests/Ubuntu Codelite/.build-release/SpirVTools"

MakeIntermediateDirs:
	@test -d ./Debug || $(MakeDirCommand) ./Debug


./Debug:
	@test -d ./Debug || $(MakeDirCommand) ./Debug

PreBuild:


##
## Objects
##
$(IntermediateDirectory)/up_up_up_up_Common_3_ThirdParty_OpenSource_SPIRV_Cross_spirv_cross.cpp$(ObjectSuffix): ../../../../Common_3/ThirdParty/OpenSource/SPIRV_Cross/spirv_cross.cpp $(IntermediateDirectory)/up_up_up_up_Common_3_ThirdParty_OpenSource_SPIRV_Cross_spirv_cross.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "/home/confetti/Desktop/svn/TheForge/Common_3/ThirdParty/OpenSource/SPIRV_Cross/spirv_cross.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/up_up_up_up_Common_3_ThirdParty_OpenSource_SPIRV_Cross_spirv_cross.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/up_up_up_up_Common_3_ThirdParty_OpenSource_SPIRV_Cross_spirv_cross.cpp$(DependSuffix): ../../../../Common_3/ThirdParty/OpenSource/SPIRV_Cross/spirv_cross.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/up_up_up_up_Common_3_ThirdParty_OpenSource_SPIRV_Cross_spirv_cross.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/up_up_up_up_Common_3_ThirdParty_OpenSource_SPIRV_Cross_spirv_cross.cpp$(DependSuffix) -MM ../../../../Common_3/ThirdParty/OpenSource/SPIRV_Cross/spirv_cross.cpp

$(IntermediateDirectory)/up_up_up_up_Common_3_ThirdParty_OpenSource_SPIRV_Cross_spirv_cross.cpp$(PreprocessSuffix): ../../../../Common_3/ThirdParty/OpenSource/SPIRV_Cross/spirv_cross.cpp
	$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/up_up_up_up_Common_3_ThirdParty_OpenSource_SPIRV_Cross_spirv_cross.cpp$(PreprocessSuffix) ../../../../Common_3/ThirdParty/OpenSource/SPIRV_Cross/spirv_cross.cpp

$(IntermediateDirectory)/up_up_up_up_Common_3_Tools_SpirvTools_SpirvTools.cpp$(ObjectSuffix): ../../../../Common_3/Tools/SpirvTools/SpirvTools.cpp $(IntermediateDirectory)/up_up_up_up_Common_3_Tools_SpirvTools_SpirvTools.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "/home/confetti/Desktop/svn/TheForge/Common_3/Tools/SpirvTools/SpirvTools.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/up_up_up_up_Common_3_Tools_SpirvTools_SpirvTools.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/up_up_up_up_Common_3_Tools_SpirvTools_SpirvTools.cpp$(DependSuffix): ../../../../Common_3/Tools/SpirvTools/SpirvTools.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/up_up_up_up_Common_3_Tools_SpirvTools_SpirvTools.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/up_up_up_up_Common_3_Tools_SpirvTools_SpirvTools.cpp$(DependSuffix) -MM ../../../../Common_3/Tools/SpirvTools/SpirvTools.cpp

$(IntermediateDirectory)/up_up_up_up_Common_3_Tools_SpirvTools_SpirvTools.cpp$(PreprocessSuffix): ../../../../Common_3/Tools/SpirvTools/SpirvTools.cpp
	$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/up_up_up_up_Common_3_Tools_SpirvTools_SpirvTools.cpp$(PreprocessSuffix) ../../../../Common_3/Tools/SpirvTools/SpirvTools.cpp

$(IntermediateDirectory)/up_up_up_up_Common_3_ThirdParty_OpenSource_SPIRV_Cross_spirv_cfg.cpp$(ObjectSuffix): ../../../../Common_3/ThirdParty/OpenSource/SPIRV_Cross/spirv_cfg.cpp $(IntermediateDirectory)/up_up_up_up_Common_3_ThirdParty_OpenSource_SPIRV_Cross_spirv_cfg.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "/home/confetti/Desktop/svn/TheForge/Common_3/ThirdParty/OpenSource/SPIRV_Cross/spirv_cfg.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/up_up_up_up_Common_3_ThirdParty_OpenSource_SPIRV_Cross_spirv_cfg.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/up_up_up_up_Common_3_ThirdParty_OpenSource_SPIRV_Cross_spirv_cfg.cpp$(DependSuffix): ../../../../Common_3/ThirdParty/OpenSource/SPIRV_Cross/spirv_cfg.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/up_up_up_up_Common_3_ThirdParty_OpenSource_SPIRV_Cross_spirv_cfg.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/up_up_up_up_Common_3_ThirdParty_OpenSource_SPIRV_Cross_spirv_cfg.cpp$(DependSuffix) -MM ../../../../Common_3/ThirdParty/OpenSource/SPIRV_Cross/spirv_cfg.cpp

$(IntermediateDirectory)/up_up_up_up_Common_3_ThirdParty_OpenSource_SPIRV_Cross_spirv_cfg.cpp$(PreprocessSuffix): ../../../../Common_3/ThirdParty/OpenSource/SPIRV_Cross/spirv_cfg.cpp
	$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/up_up_up_up_Common_3_ThirdParty_OpenSource_SPIRV_Cross_spirv_cfg.cpp$(PreprocessSuffix) ../../../../Common_3/ThirdParty/OpenSource/SPIRV_Cross/spirv_cfg.cpp


-include $(IntermediateDirectory)/*$(DependSuffix)
##
## Clean
##
clean:
	$(RM) -r ./Debug/


