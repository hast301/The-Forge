.PHONY: clean All

All:
	@echo "----------Building project:[ SpirVTools -  ]----------"
	@cd "SpirVTools" && "$(MAKE)" -f  "SpirVTools.mk"
	@echo "----------Building project:[ Renderer -  ]----------"
	@cd "Renderer" && "$(MAKE)" -f  "Renderer.mk"
	@echo "----------Building project:[ OS -  ]----------"
	@cd "OSBase" && "$(MAKE)" -f  "OS.mk"
	@echo "----------Building project:[ 01_Transformation - Debug ]----------"
	@cd "01_Transformation" && "$(MAKE)" -f  "01_Transformation.mk"
clean:
	@echo "----------Cleaning project:[ SpirVTools -  ]----------"
	@cd "SpirVTools" && "$(MAKE)" -f  "SpirVTools.mk"  clean
	@echo "----------Cleaning project:[ Renderer -  ]----------"
	@cd "Renderer" && "$(MAKE)" -f  "Renderer.mk"  clean
	@echo "----------Cleaning project:[ OS -  ]----------"
	@cd "OSBase" && "$(MAKE)" -f  "OS.mk"  clean
	@cd "01_Transformation" && "$(MAKE)" -f  "01_Transformation.mk" clean


