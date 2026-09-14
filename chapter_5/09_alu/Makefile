RTL_SRC   = rtl/alu.sv rtl/mux_4.sv \
					  rtl/prefix_adder.sv rtl/pg_cell.sv rtl/sum_cell.sv

TB_SRC    = tb/alu_tb.sv

TOP_MDL   = alu_tb
SIM_FLAGS = -g2012
OUT_DIR   = build
SIM       = sim
WAVE      = alu.vcd

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
