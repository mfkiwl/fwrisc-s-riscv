
include $(PACKAGES_DIR)/packages.mk
include $(PACKAGES_DIR)/simscripts/mkfiles/plusargs.mk

MK_INCLUDES += $(FWRISC)/ve/fwrisc_rv32imc_fpga/tests/fwrisc_fpga_tests.mk
MK_INCLUDES += $(FWRISC)/ve/fwrisc_rv32imc_fpga/tb/vl/fwrisc_fpga_tb_vl.mk
MK_INCLUDES += $(FWRISC)/ve/fwrisc_tracer_bfm/gvm/fwrisc_tracer_bfm.mk
SRC_DIRS += $(FWRISC)/ve/fwrisc_rv32imc/tests
SRC_DIRS += $(FWRISC)/ve/fwrisc_rv32imc/tests/cpp

MK_INCLUDES += $(GOOGLETEST_HDL)/src/sv/googletest_hdl_sv.mk
MK_INCLUDES += $(GOOGLETEST_HDL)/src/vl/googletest_hdl_vl.mk

RUN_PRE_TARGETS += rom.hex regs.hex

TB_MODULES_HDL=fwrisc_fpga_tb_hdl

SW_IMAGES := $(foreach img,$(call get_plusarg,SW_IMAGE,$(PLUSARGS)),$(subst $(BUILD_DIR)/esw/,,$(img)))
SW_IMAGE := $(firstword $(SW_IMAGES))

ifeq (zephyr.elf,$(notdir $(SW_IMAGE))) 
  SW_IMAGE := $(subst $(BUILD_DIR)/esw/,,$(SW_IMAGE))
else
  SW_IMAGE := $(notdir $(SW_IMAGE))
endif

ifneq (,$(SW_IMAGES))
  BUILD_PRECOMPILE_TARGETS += embedded_sw
endif


ifeq (vl,$(SIM))
#  VL_TB_OBJS_LIBS += libfwrisc_fpga_tests.o libgoogletest-vl.o libgoogletest.o
#  VL_TB_OBJS_LIBS += ElfFileReader.o ElfSymtabReader.o
  CXXFLAGS += -I$(BUILDDIR)/obj_dir
  DPI_OBJS_LIBS += libgoogletest-hdl-vl.o libfwrisc_fpga_tb_vl.o
endif

DPI_OBJS_LIBS += $(GVM_OBJS_LIBS)
DPI_OBJS_LIBS += libfwrisc_fpga_tests.o libgoogletest-hdl.o libgoogletest.o

include $(PACKAGES_DIR)/simscripts/mkfiles/common_sim.mk

regs.hex : $(FWRISC)/rtl/regs.hex
	$(Q)cp $(FWRISC)/rtl/regs.hex .

ifneq (,$(SW_IMAGE))
rom.hex : $(BUILD_DIR)/esw/$(SW_IMAGE)
	$(Q)riscv32-unknown-elf-objcopy $^ -O verilog rom.vlog
	$(Q)perl $(MEMORY_PRIMITIVES)/bin/objcopyvl2vl.pl \
		-width 32 -offset 0x80000000 -le rom.vlog rom.hex
else # No software image
rom.hex :
	$(Q)echo "00000000" > $@
	$(Q)echo "00000000" >> $@
	$(Q)echo "00000000" >> $@
	$(Q)echo "00000000" >> $@
	$(Q)echo "00000000" >> $@
	$(Q)echo "00000000" >> $@
	$(Q)echo "00000000" >> $@
	$(Q)echo "00000000" >> $@
endif

embedded_sw :
	$(Q)echo SW_IMAGES=$(SW_IMAGES) SW_IMAGE=$(SW_IMAGE)
	$(Q)if test ! -d esw; then mkdir -p esw; fi
	$(Q)$(MAKE) -C esw VERBOSE=$(VERBOSE) \
		-f $(SIM_DIR)/scripts/embedded.mk $(SW_IMAGES)

include $(PACKAGES_DIR)/packages.mk
	
