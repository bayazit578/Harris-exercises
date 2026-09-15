RTL_SRC   = rtl/cla_adder.sv rtl/cla_adder_4.sv \
					  rtl/cla_cell.sv rtl/full_adder.sv rtl/ripple_carry_adder.sv

TB_SRC    = tb/cla_adder_tb.sv

TOP_MDL   = cla_adder_tb
SIM_FLAGS = -g2012
OUT_DIR   = build
SIM       = sim
WAVE      = cla_adder.vcd

.PHONY: all clean run wave
all: $(OUT_DIR)/$(SIM)

$(OUT_DIR)/$(SIM): $(RTL_SRC) $(TB_SRC)
	@mkdir -p $(OUT_DIR)
	@iverilog $(SIM_FLAGS) -s $(TOP_MDL) -o $@ $^

run: $(OUT_DIR)/$(SIM)
	@vvp $^

wave: 
	@surfer $(WAVE)

clean:
	@rm -fr $(OUT_DIR)
