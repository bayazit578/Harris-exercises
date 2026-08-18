module cla_cell #(
  parameter TERM_WIDTH = 4
)(
  input  logic [TERM_WIDTH-1:0] i_prg,
  input  logic [TERM_WIDTH-1:0] i_gen,
  input  logic                  c_in,

  output logic                  c_out
);

  logic [TERM_WIDTH-1:0] inter_gens;

  assign inter_gens [0] = i_gen;

  generate
    for (genvar i = 1; i < TERM_WIDTH; i += 1) begin: g_inter_gens
      assign inter_gens [i] = i_gen [i] | (i_prg [i] & inter_gens [i-1]);
    end
  endgenerate

  logic block_prg, block_gen;

  assign block_prg = & i_prg;
  assign block_gen = inter_gens [TERM_WIDTH];

  assign c_out = block_gen | (block_prg & c_in);

endmodule
